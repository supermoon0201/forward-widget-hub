#!/bin/sh
set -eu

DATA_DIR="${DATA_DIR:-/data}"

mkdir -p "$DATA_DIR"

if [ "$(id -u)" -eq 0 ]; then
  if chown -R nextjs:nodejs "$DATA_DIR" 2>/dev/null; then
    exec su-exec nextjs:nodejs node server.js
  fi

  echo "Warning: unable to change ownership of $DATA_DIR, starting as root so the mounted volume remains writable." >&2
  exec node server.js
fi

if [ ! -w "$DATA_DIR" ]; then
  echo "Error: DATA_DIR '$DATA_DIR' is not writable by uid $(id -u)." >&2
  echo "If you are using a bind mount, adjust the host directory permissions or rebuild with the updated image." >&2
  exit 1
fi

exec node server.js
