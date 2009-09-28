Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60155 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbZI1Nbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 09:31:55 -0400
Subject: Re: [RFC] libertas: first stab at cfg80211 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <h.schurig@mn-solutions.de>
Cc: libertas-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <200909281321.21600.h.schurig@mn-solutions.de>
References: <200909281321.21600.h.schurig@mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-YsNwzqjQWCOa2Un7I1vY"
Date: Mon, 28 Sep 2009 15:31:54 +0200
Message-Id: <1254144714.3151.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YsNwzqjQWCOa2Un7I1vY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-09-28 at 13:21 +0200, Holger Schurig wrote:
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
>=20
> ---
>=20
> This patch currently just create a wdev, so you can do "iw list".
>=20
> I'd like to get comments if the position where I create/destroy
> the wdev makes sense.
>=20
> Index: linux-wl/drivers/net/wireless/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-wl.orig/drivers/net/wireless/Kconfig	2009-09-28 12:06:02.000000=
000 +0200
> +++ linux-wl/drivers/net/wireless/Kconfig	2009-09-28 12:06:30.000000000 +=
0200
> @@ -138,6 +138,7 @@ config LIBERTAS
>  	depends on WLAN_80211
>  	select WIRELESS_EXT
>  	select LIB80211
> +	select CFG80211
>  	select FW_LOADER
>  	---help---
>  	  A library for Marvell Libertas 8xxx devices.
> Index: linux-wl/drivers/net/wireless/libertas/Makefile
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-wl.orig/drivers/net/wireless/libertas/Makefile	2009-09-28 12:06=
:02.000000000 +0200
> +++ linux-wl/drivers/net/wireless/libertas/Makefile	2009-09-28 12:06:30.0=
00000000 +0200
> @@ -1,5 +1,5 @@
>  libertas-objs :=3D main.o wext.o rx.o tx.o cmd.o cmdresp.o scan.o 11d.o	=
\
> -		 debugfs.o persistcfg.o ethtool.o assoc.o
> +		 debugfs.o persistcfg.o ethtool.o assoc.o cfg.o
> =20
>  usb8xxx-objs +=3D if_usb.o
>  libertas_cs-objs +=3D if_cs.o
> Index: linux-wl/drivers/net/wireless/libertas/dev.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-wl.orig/drivers/net/wireless/libertas/dev.h	2009-09-28 12:06:02=
.000000000 +0200
> +++ linux-wl/drivers/net/wireless/libertas/dev.h	2009-09-28 12:06:30.0000=
00000 +0200
> @@ -100,6 +100,7 @@ struct lbs_mesh_stats {
> =20
>  /** Private structure for the MV device */
>  struct lbs_private {
> +	struct wireless_dev *wdev;
>  	int mesh_open;
>  	int mesh_fw_ver;
>  	int infra_open;

This seems wrong -- doesn't libertas have multiple netdevs? You're
treating wdev =3D=3D wiphy it seems here, rather than wdev =3D=3D netdev.

johannes

--=-YsNwzqjQWCOa2Un7I1vY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKwLrGAAoJEODzc/N7+QmanPgQAJX7SrXNFsNY9YaY2TE9HwUj
YzNz0xmZp3BVgXCJWjGtl3ea7WQncHbTmW2eKrwZ1fqHFGq2ubyJCsP+iJdOSJtR
SzKCUTkkfpcA+dLv11jqQZc3CtPf665wI7fvm1o7P2Xj2z+uW+M/bbWc39YoesQQ
L7Kg+yEJzAew+mVfwPdbi77P5RSxd+Oxx1OGUARbCFFVcwZoIDmI+szQk5TTbK5a
VTi07VqvypTGLxAWnRvivbeqFOOcw2U+XzLSgcNAeUJjEndbqDD70FcvbNpq/G03
ZhPGW4YalB8/QFWZH2sJjduyaPd1pXKL1S65C2R85C4yH4bWM01t0agsNheKoviR
+dmvPksbycXVSiteYkSmHrH0I599w7R1PKBdDEKo16Dc+FWXLeyjEshCHxeSRRhn
fngpEnFlm4jVlxqx1W+olVMLQs3leVoP0Ofla22EmoR2Gzy5xHiD9Vj3QvR4TABa
gdiLOG3nbS2Yr5EljHAeimR6hAt0MPAx/0g2vbDxkDdBS2YbD9xrBEhoUpeP7MEm
RiABikr7kJ7e6bLuK/jpqVJR63Pn/KVbp7ekWzr8BnGxidfTp0+QwGx2ZB8wz3ys
vq8N8a0/eu80vgQFYhrEDa9f4E5ry49WE7DPfo+BBUuH7Y+OMC4uHnMOw4kb4Rvv
VfxldjF+UGo3sdGxSw1K
=dusu
-----END PGP SIGNATURE-----

--=-YsNwzqjQWCOa2Un7I1vY--

