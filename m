Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36574 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321Ab2FKShq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 14:37:46 -0400
MIME-Version: 1.0
In-Reply-To: <1338115108-19091-2-git-send-email-ozancag@gmail.com>
References: <1338115108-19091-1-git-send-email-ozancag@gmail.com> <1338115108-19091-2-git-send-email-ozancag@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Mon, 11 Jun 2012 11:37:25 -0700
Message-ID: <CAB=NE6Xafsxpc0g+F8i5zDwS4ZGiiSQ2dmNpharZdnaTxsjHhQ@mail.gmail.com> (sfid-20120611_203751_081507_B77B4AC7)
Subject: Re: [PATCH 2/2] bin/get-compat-kernels: Do not depend on Ubuntu
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
Cc: mcgrof@kernel.org, lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 27, 2012 at 3:38 AM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> Use Ubuntu PPA vanilla kernels on other distributions too.
> The .deb files are extracted using 'ar' and 'tar'.
>
> Also check if the target directory exists before downloading
> the deb files.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
> ---
>  bin/get-compat-kernels |   81 ++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 57 insertions(+), 24 deletions(-)
>
> diff --git a/bin/get-compat-kernels b/bin/get-compat-kernels
> index 7a253c2..6cac898 100755
> --- a/bin/get-compat-kernels
> +++ b/bin/get-compat-kernels
> @@ -10,6 +10,9 @@
>  # to test compile the Linux kernel compatibility module. You can
>  # then use ckmake to cross compile against all supported kernels.
>
> +KERNELS=""
> +KPATH="http://kernel.ubuntu.com/~kernel-ppa/mainline/"
> +
>  function get_ubuntu_kernels() {
>
>        ARCH=$(uname -m)
> @@ -28,10 +31,6 @@ function get_ubuntu_kernels() {
>                ;;
>        esac
>
> -       KERNELS=""
> -
> -       KPATH="http://kernel.ubuntu.com/~kernel-ppa/mainline/"
> -
>        KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-headers-2.6.24-020624_2.6.24-020624_all.deb"
>        KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-headers-2.6.24-020624-generic_2.6.24-020624_${TARGET}.deb"
>        KERNELS="$KERNELS ${KPATH}/v2.6.24/linux-image-2.6.24-020624-generic_2.6.24-020624_${TARGET}.deb"
> @@ -121,19 +120,63 @@ function get_ubuntu_kernels() {
>                        continue
>                fi
>
> -               if [[ ! -f $FILE ]]; then
> +               # Do not download if installed, I think this
> +               # workarounds the below XXX: comment.

If I merge this patch the "XXX" comment would no longer present so
anyone reading this comment would not understand what was being
referred to with this. If this patch was meant more as an [RFC] then
the placement of the comment makes sense but my recommendation would
be to put these type of ephemeral comments right below the --- after
the commig log and right before the diff stat.

> +               if [[ ! -d /usr/src/$PKG && ! -f $FILE ]]; then

It is certainly a nice additional check, I'll take it, and yeah you
can remove the comment also then.

Nice stuff, I'll take these patches, feel free to send an [PATCH v2]!

  Luis
