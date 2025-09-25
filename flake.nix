{
  description = "Build and run daggerfall-bevy";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell rec {
          nativeBuildInputs = with pkgs; [ pkg-config ];

          buildInputs = with pkgs; [
            udev
            alsa-lib-with-plugins
            vulkan-loader

            # X11 support
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr

            # Wayland support
            libxkbcommon
            wayland
          ];

          env.LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath buildInputs;
        };
      }
    );
}
