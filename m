Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60334 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932206Ab3GDCXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 22:23:07 -0400
Message-ID: <1372904558.22888.50.camel@deadeye.wl.decadent.org.uk> (sfid-20130704_042311_547171_A46E0C92)
Subject: Re: [PATCH] brcm: add brcmfmac sdio firmware for bcm43241
From: Ben Hutchings <ben@decadent.org.uk>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	David Woodhouse <dwmw2@infradead.org>
Date: Thu, 04 Jul 2013 03:22:38 +0100
In-Reply-To: <1369833235-3642-1-git-send-email-arend@broadcom.com>
References: <1369833235-3642-1-git-send-email-arend@broadcom.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-0UjoP8N0U6kdlr6fU7J6"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0UjoP8N0U6kdlr6fU7J6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-05-29 at 15:13 +0200, Arend van Spriel wrote:
> From: Franky Lin <frankyl@broadcom.com>
>=20
> Add missing firmware file for the BCM43241 SDIO device. The firmware
> version is v6.10.170.4
>=20
> Reported-by: Alex Courbot <acourbot@nvidia.com>
> Signed-off-by: Franky Lin <frankyl@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> Hi Ben,
>=20
> Somehow this firmware got forgotten although brcmfmac has support for
> the device for a while now.
>=20
> Regards,
> Arend
> ---
>  WHENCE                 |    1 +
>  brcm/brcmfmac43241.bin |  Bin 0 -> 414238 bytes
>  2 files changed, 1 insertion(+)
>  create mode 100644 brcm/brcmfmac43241.bin
>=20
> diff --git a/WHENCE b/WHENCE
> index ef64612..5eca1d0 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1652,6 +1652,7 @@ Driver: brcmfmac - Broadcom 802.11n fullmac wireles=
s LAN driver.
> =20
>  File: brcm/bcm4329-fullmac-4.bin
>  File: brcm/brcmfmac43236b.bin
> +File: brcm/brcmfmac43241.bin
>  File: brcm/brcmfmac4329.bin
>  File: brcm/brcmfmac4330.bin
>  File: brcm/brcmfmac4334.bin
[...]

Unless you're doing something very clever with macros, I don't believe
you've posted any driver code that uses this file... or several of the
others.  The current driver in net-next (I don't know what you've sent
to Nvidia) appears to request only these files:

- brcm/brcmfmac43143.bin
- brcm/brcmfmac43236b.bin
- brcm/brcmfmac43242a.bin
- brcm/brcmfmac-sdio.bin
- brcm/brcmfmac-sdio.txt

Looking through the git history, I can see that various other names have
been used:

- brcm/bcm4329-fullmac-4.bin (renamed to brcm/brcmfmac-sdio.bin)
- brcm/bcm4329-fullmac-4.txt (renamed to brcm/brcmfmac-sdio.txt)
- brcm/brcmfmac-usb.bin (renamed to brcm/brcmfmac43236b.bin)
- brcm/brcmfmac.bin (renamed to brcm/brcmfmac-sdio.bin)
- brcm/brcmfmac.txt (renamed to brcm/brcmfmac-sdio.txt)

So I think, before this patch is applied, you owe me and David patches
to:

1. Add brcm/brcmfmac43143.bin, brcm/brcmfmac43242a.bin and
brcm/brcmfmac-sdio.txt.
2. Rename brcm/bcm4329-fullmac-4.bin to brcm/brcmfmac-sdio.bin.
3. Add symlinks from all the old names to the new names.  (As
linux-firmware should support old in-tree drivers indefinitely.)

and you owe linux-wireless some driver patches.

linux-firmware.git is not the appropriate place to send firmware used
only by out-of-tree code, and any firmware blob that has never been
referenced by in-tree code is subject to removal.

Ben.

--=20
Ben Hutchings
Tomorrow will be cancelled due to lack of interest.

--=-0UjoP8N0U6kdlr6fU7J6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUdTcbue/yOyVhhEJAQqXCA//fD8miBqGGUxc7lgysmTszyI2hr887CRU
jot/8Rx+56TFEWF7deSvxoNkUNSfPA1Elka4dNLviIEgKQHFXc911/uSjygE3Q83
xkb3yoF1sk+9RjkCgiweLFoIZWo3wU0KaJeV3srQX3zoPRwHaRtF/NbI7LB7krty
R2H985rBdFdtNmbpeDG8VDqmnTIxxMbI+w4rZMEeCxtltq9DSsu9DiSesdWxmPUs
naFwe4qW6K1PUGbaOkH2fvUvgBpT+aCJA11qKpvuiyoWQFwRkj8puaofix9dCJOh
WRF/Xkbid0qQK0hZEj6eRilhfnJLvymW4lWjRLy5HG465vPbUL9rafuxSUPG9TPC
YREy874FfB4ArcOLTxH5t40DRbIr6c4cvXzLrGaCx7tAiwOQ12br5ryFbMdnVCVi
9stT5rnebuUxzr8t2FDWyEE8mcYrNA2hbY9UOwflHmaHXgxfXdupFSiAC6GE9qGx
4pLKyrLYMryC5cAr99iOhXeKkY70p57TBzoHos9uzSzvTyWdXEyvLBvdwP+Fc033
mjSGVkVoTP05GqvkXucJ3NZBtQNono2INUE1ZsZo1AiIEj0Ai04Cu2fcQYGJyGMR
vVsPwNmIH2NebEhjTbjk3QiSggoXMD9HiaKPuGLMKPM6Et8GskwTzAeuH8m/P6j0
HV8E977n15o=
=dim7
-----END PGP SIGNATURE-----

--=-0UjoP8N0U6kdlr6fU7J6--
