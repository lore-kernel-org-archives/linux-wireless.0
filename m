Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49008 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbcFCVKX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 17:10:23 -0400
Date: Fri, 3 Jun 2016 23:09:11 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Lucas Stach <dev@lynxeye.de>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: only hardcode LED behavior if SPROM doesn't encode
 any
Message-ID: <20160603230911.4a9e80b6@wiggum> (sfid-20160603_231026_245689_9DE206A2)
In-Reply-To: <1464987843-6928-1-git-send-email-dev@lynxeye.de>
References: <1464987843-6928-1-git-send-email-dev@lynxeye.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/II8CxAs0DbGc6LFeinz9PqH"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/II8CxAs0DbGc6LFeinz9PqH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri,  3 Jun 2016 23:04:03 +0200
Lucas Stach <dev@lynxeye.de> wrote:

> Only hardcode the LED behavior if the SROM doesn't provide any for all
> LEDs of the card. This avoids instantiating LED triggers for unconnected
> LEDs, while (hopefully) keeping things working for old cards with a
> blank SROM.
>=20
> Signed-off-by: Lucas Stach <dev@lynxeye.de>

Acked-by: Michael Buesch <m@bues.ch>


> ---
>  drivers/net/wireless/broadcom/b43/leds.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/broadcom/b43/leds.c b/drivers/net/wirel=
ess/broadcom/b43/leds.c
> index d79ab2a..cb987c2 100644
> --- a/drivers/net/wireless/broadcom/b43/leds.c
> +++ b/drivers/net/wireless/broadcom/b43/leds.c
> @@ -222,7 +222,7 @@ static void b43_led_get_sprominfo(struct b43_wldev *d=
ev,
>  	sprom[2] =3D dev->dev->bus_sprom->gpio2;
>  	sprom[3] =3D dev->dev->bus_sprom->gpio3;
> =20
> -	if (sprom[led_index] =3D=3D 0xFF) {
> +	if ((sprom[0] & sprom[1] & sprom[2] & sprom[3]) =3D=3D 0xff) {
>  		/* There is no LED information in the SPROM
>  		 * for this LED. Hardcode it here. */
>  		*activelow =3D false;
> @@ -250,7 +250,11 @@ static void b43_led_get_sprominfo(struct b43_wldev *=
dev,
>  			return;
>  		}
>  	} else {
> -		*behaviour =3D sprom[led_index] & B43_LED_BEHAVIOUR;
> +		/* keep LED disabled if no mapping is defined */
> +		if (sprom[led_index] =3D=3D 0xff)
> +			*behaviour =3D B43_LED_OFF;
> +		else
> +			*behaviour =3D sprom[led_index] & B43_LED_BEHAVIOUR;
>  		*activelow =3D !!(sprom[led_index] & B43_LED_ACTIVELOW);
>  	}
>  }




--=20
Michael

--Sig_/II8CxAs0DbGc6LFeinz9PqH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXUfH3AAoJEPUyvh2QjYsOV8QP/i7MXkiA3P1UxmwHZqGWzhf0
QRaxrJYtLXj06d5MhTFXkBjNZPPMmQyN5NxUL2eT+lIUAzsFbDejD1y1fPr4163J
WR88VMzAC3Mj0hPNI5qK54VGLhB3Sh3QgPqWa/XtWzhZZbn6YuGQaFZ75WK7FoMI
hy8tccVnDQvYNxBdqcsTYVGVY/jfL0YKbFox9++y6QjsBJp/WOANodxOO0AHcIYX
6vBWx4O1gLEbueAX3Nf3jPai84Zwtjx1CiukRZLTCakJ1hTWH0n3UNUvoppxokMX
qqqOxb1KHe963GjYxJtYzZTGUwMgRIAoTEh4c1KGUbweElZiXMV++mZ/6a+GHd3L
6WVS71XfT7iRVvJp01KKe1pBax1Vsv5paw98giN4hEyXwZguF8JGbuWfaBpr/Cft
VC1552IVx7FEnsOd5n80vR3O99fwEaOvKAjvU1v0S/ArucyrfmNS/UlgEblRY+K8
ZFIvaRRC7L+DosLhe3oaGRbSEnpXSkHGECf8lVsknxk4/rB0mkmRMsJHVmmrRtvS
ld1vhofJerO/a+G8BXCGsNoyDFDWACtwPot3KU5y7hosUD1cXvhtjC9ay/4RrOPE
1tXXqZq2ym16Xav6oX/r154M75r+D2tayU/07suGguoErK2H8S9lRAVKKz/xoteZ
wDqqElwjetPDvbrGDyu9
=sOtC
-----END PGP SIGNATURE-----

--Sig_/II8CxAs0DbGc6LFeinz9PqH--
