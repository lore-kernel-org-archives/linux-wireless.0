Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:46271 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab3CBEJO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 23:09:14 -0500
Date: Sat, 2 Mar 2013 05:09:00 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: HT-PHY: make it BCMA-only
Message-ID: <20130302050900.6e768a3e@milhouse> (sfid-20130302_050919_454580_4A07E83D)
In-Reply-To: <1362186865-20539-1-git-send-email-zajec5@gmail.com>
References: <1362186865-20539-1-git-send-email-zajec5@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RW_TeJah/zgwbHK13UZwOSs"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/RW_TeJah/zgwbHK13UZwOSs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat,  2 Mar 2013 02:14:25 +0100
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> HT-PHY was found only on BCM4331 which is a BCMA-based chipset. This is
> reallly unlikely we will ever see HT-PHY on SSB thus make the whole code
> BCMA specific. This will allow us to call various BCMA-specific
> functions directly (without extra checks).
>=20
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com>
> ---
>  drivers/net/wireless/b43/Kconfig  |    2 +-
>  drivers/net/wireless/b43/phy_ht.c |    5 +++++
>  2 files changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/=
Kconfig
> index 7a28d21..09d315d 100644
> --- a/drivers/net/wireless/b43/Kconfig
> +++ b/drivers/net/wireless/b43/Kconfig
> @@ -131,7 +131,7 @@ config B43_PHY_LP
> =20
>  config B43_PHY_HT
>  	bool "Support for HT-PHY (high throughput) devices (EXPERIMENTAL)"
> -	depends on B43 && EXPERIMENTAL
> +	depends on B43 && B43_BCMA && EXPERIMENTAL

Makes sense.
What about removing EXPERIMENTAL? This flag is mostly useless these days.

>  	---help---
>  	  Support for the HT-PHY.
> =20
> diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43=
/phy_ht.c
> index 7416c5e..3719a88 100644
> --- a/drivers/net/wireless/b43/phy_ht.c
> +++ b/drivers/net/wireless/b43/phy_ht.c
> @@ -346,6 +346,11 @@ static int b43_phy_ht_op_init(struct b43_wldev *dev)
>  	u16 tmp;
>  	u16 clip_state[3];
> =20
> +	if (dev->dev->bus_type !=3D B43_BUS_BCMA) {
> +		b43err(dev->wl, "HT-PHY is supported only on BCMA bus!\n");
> +		return -EOPNOTSUPP;
> +	}
> +
>  	b43_phy_ht_tables_init(dev);
> =20
>  	b43_phy_mask(dev, 0x0be, ~0x2);



--=20
Michael

--Sig_/RW_TeJah/zgwbHK13UZwOSs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMXtcAAoJEPUyvh2QjYsOd7MQAIuNhRVD3tmQXzWTEARgC7ZG
WTB4MDSYMAbNVUHH763znojGaXYrzBDUxybXHm6xcSEaFvw7nBvjADHesE6aq3Ve
vJvV58aIAfi6rTwEPnKiuyKSBnMmYhedGJWK1jRM048jkiumHc1C74btY3anmrwy
/jS2vL5/BsFa4QgJckdiTNvhxB5G3s2g2lXp7rN3asJlxOSI54iJw0zCoN3MAd+A
IlIIk69+GKjXrBFiAqhugZntnNI++ODoF8bo6KHl+VZy+GKdu8Ex/1TwPDrrX/LF
5uMJr9tMdhjuNg0/UPZpiiMisAB4+M8GLkbmq0NZE8D8JaZV//Os0HhGUm6SMBmq
KtOeoMCz4M0DFx1Yi6jQhHIZXO8cQ5OPJa1WiDGK1OEyXXe1uKURt2W/dAzbtxxm
T1Lu9Qom34TpYliihnN2fGkbfcKTsfR6CQqV/iIQ8tb+DTqzEdJYStgKdVNMbrys
QGLb8nvsqkV8G6eTYHqIEkTjatDigUBt/BBw1UtiiCRnEmpC+YQod15vh/na+xiA
Q+lLYZoORCShqj/kYjJ4o1lzlT1LMtH7dskaVcz1wwWq3y8ae0/5vFhsIpiMFf8x
xRoUGCVRmM3k16ur/JkAC/CfE/ZnBrVfp4I/GKRnFMSpk0Zf5yCeyXGV128tUIVm
QTb3jOKijCtGwjH1skjP
=VbtD
-----END PGP SIGNATURE-----

--Sig_/RW_TeJah/zgwbHK13UZwOSs--
