Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:38506 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276AbaDTTZ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 15:25:29 -0400
Date: Sun, 20 Apr 2014 20:54:52 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [wireless-next][PATCH 1/2] b43: ssb: refuse to support more
 than IEEE 802.11 core
Message-ID: <20140420205452.79a95330@wiggum> (sfid-20140420_212549_930179_F2DBA3F5)
In-Reply-To: <1398018659-17263-1-git-send-email-zajec5@gmail.com>
References: <1398018659-17263-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/uEd9FgBpXKy4YsByt0CnZzv"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/uEd9FgBpXKy4YsByt0CnZzv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 20 Apr 2014 20:30:58 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/m=
ain.c
> index 69fc3d6..cf84cf2 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -5486,39 +5486,42 @@ int b43_ssb_probe(struct ssb_device *sdev, const =
struct ssb_device_id *id)
>  	struct b43_bus_dev *dev;
>  	struct b43_wl *wl;
>  	int err;
> -	int first =3D 0;
> =20
>  	dev =3D b43_bus_dev_ssb_init(sdev);
>  	if (!dev)
>  		return -ENOMEM;
> =20
>  	wl =3D ssb_get_devtypedata(sdev);


The whole "struct b43_wl" and "ssb_get_devtypedata" was to support multiple
cores of the same type in a single driver instance (=3D b43 multicore).
With multicore support being removed, everything in b43_wl could be merged =
into b43_wldev.
Also the use of ssb_get_devtypedata could probably be removed, too.

This will simplify a lot of the b43 startup and shutdown code.


--=20
Michael.

----
Please use PGP/GPG encryption.
Key-ID: F532BE1D908D8B0E
--------

--Sig_/uEd9FgBpXKy4YsByt0CnZzv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTVBf8AAoJEPUyvh2QjYsO/SUQAN49zE17A7h5ILKghgxt8zh7
sPjSOover5It4t9t3iMxwEkyOwABcGtv//QMvGZKEhKB0opxmGM7q3BYVMlMgrdG
hASM+a6bRLqUD41Z+BGhVOouNR+eTkDJV7miFfKXRtZ7cYGD3x//xkkpXfHQeOTa
K5OuVjwg6HYpr28yXvD08BJBGyG7cZD+z8cg7qphjCnw9YveW+H+Oq8irYk38h8j
ntg5/ncTrWMit6Cy5zV41vqRGGsUNxHY7XCt24JIaefIGBYBhmDpkMlc6vMZOYu2
x+DBXnabyZKfFEDfufOlsluxI6cVpZufp5g+fJ/KRxQFiJu84Rl6kuD5IUtEQVKr
xMZqAvg29LBQYkt2uN+YBXKC2b9aaxKPPEftA1qFkPNkI1aiVBlIx9mzpmn8ypAW
Nt6xc5Wl/sQrKAXbSNvd+Puzr5I0dDxF46MNU9x87Bew4ZhNtApDtJre9waKNGTl
enjRjnLWWn30WD01lyWyFsNjO0+KqR8f3R/G+kqDfxHHisfZcA7swHceJRi/qHWc
439h0n/ogur8W/haxcG2EeTpWxqMpQ3utlcCxXH9zd2O07l6fik6/xktdmoxo+L+
kQwdVtZMtW/AadLt+VAeiCuzg85YuU4uW+tUKnSH2xjHVdDZIX5SP5MUIdPYUObJ
eLZU6/7l7YlaDL7mFWhz
=I7Lk
-----END PGP SIGNATURE-----

--Sig_/uEd9FgBpXKy4YsByt0CnZzv--
