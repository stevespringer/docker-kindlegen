FROM alpine:3.11.2@sha256:3983cc12fb9dc20a009340149e382a18de6a8261b0ac0e8f5fcdf11f8dd5937e
LABEL maintainer "Koen Rouwhorst <info@koenrouwhorst.nl>"

# NOTE: https://www.amazon.com/gp/feature.html?docId=1000765211
ENV KINDLEGEN_VERSION="2.9"
ENV KINDLEGEN_CHECKSUM="9828db5a2c8970d487ada2caa91a3b6403210d5d183a7e3849b1b206ff042296"

RUN apk add --no-cache ca-certificates curl tar

ENV HOME /home/kindlegen
RUN adduser -u 1001 -D kindlegen \
  && chown -R kindlegen:kindlegen $HOME

WORKDIR /tmp

RUN curl "https://kindlegen.s3.amazonaws.com/kindlegen_linux_2.6_i386_v${KINDLEGEN_VERSION/\./_}.tar.gz" \
  -o "kindlegen-$KINDLEGEN_VERSION.tar.gz" \
  && echo "$KINDLEGEN_CHECKSUM  kindlegen-$KINDLEGEN_VERSION.tar.gz" | sha256sum -c - \
  && mkdir -p /app \
  && tar -xzf "kindlegen-$KINDLEGEN_VERSION.tar.gz" -C /app \
  && rm "kindlegen-$KINDLEGEN_VERSION.tar.gz"

WORKDIR "$HOME"
USER kindlegen

# NOTE: https://kindlegen.s3.amazonaws.com/Readme.txt
ENTRYPOINT ["/app/kindlegen"]
