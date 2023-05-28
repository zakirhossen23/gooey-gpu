#!/usr/bin/env bash

if [ "$#" -lt 1 ]; then
    echo "usage: $0 <variant> (<port>)"
    exit 1
fi

VARIANT=$1
PORT=${2:-5000}
IMG=gooey-gpu-dev

echo "Starting $IMG on port $PORT (via $VARIANT)..."

set -ex

docker build . -f $VARIANT/Dockerfile -t $IMG

docker rm -f $IMG || true
docker run -it --rm \
  --name $IMG \
  -e VARIANT=$VARIANT \
  -v $PWD/checkpoints:/src/checkpoints \
  -v $HOME/.cache/gooey-gpu/checkpoints:/root/.cache/gooey-gpu/checkpoints \
  -v $HOME/.cache/huggingface:/root/.cache/huggingface \
  -v $HOME/.cache/torch:/root/.cache/torch \
  -v $HOME/.cache/suno:/root/.cache/suno \
  -e MAX_WORKERS=1 \
  -e HUGGING_FACE_HUB_TOKEN=$HUGGING_FACE_HUB_TOKEN \
  -p $PORT:5000 \
  $IMG
