# ---------- Builder stage ----------
FROM --platform=$BUILDPLATFORM golang:1.22 AS builder

WORKDIR /app

COPY go.mod ./
RUN go mod download

COPY . .

# Cross compile Linux AMD64 binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .


# ---------- Runtime stage ----------
FROM gcr.io/distroless/base

WORKDIR /

COPY --from=builder /app/main .
COPY --from=builder /app/static ./static

EXPOSE 8080
CMD ["./main"]