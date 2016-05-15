Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:53652 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbcEOOdY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2016 10:33:24 -0400
Date: Sun, 15 May 2016 16:32:17 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Adrian Chadd <adrian@freebsd.org>
Cc: b43-dev@lists.infradead.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [b43] don't unconditionally fall back to CCK if the rate is 6MB
 OFDM.
Message-ID: <20160515163217.2b75ba97@wiggum> (sfid-20160515_163422_608878_714A9D0E)
In-Reply-To: <CAJ-Vmom45Pb9X_1Zw6VdszZAiizZUUd=HbEFw0hFMmPFFSNbpQ@mail.gmail.com>
References: <CAJ-Vmom45Pb9X_1Zw6VdszZAiizZUUd=HbEFw0hFMmPFFSNbpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/6DG2qdiPNl.gIqE8HnLXB6W"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/6DG2qdiPNl.gIqE8HnLXB6W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 15 May 2016 07:23:25 -0700
Adrian Chadd <adrian@freebsd.org> wrote:

> Author: Adrian Chadd <adrian@freebsd.org>
> Date:   Sun May 15 07:15:54 2016 -0700
>=20
>     [b43] don't unconditionally fall back to CCK if the rate is 6MB OFDM.
>=20
>     Check the current PHY operating mode (gmode) to see if we should
>     fall back from 6MB OFDM to 11MB CCK.  For 5GHz operation this isn't
>     allowed.
>=20
>     Note, the fallback lookup is only done for RTS rates; normal fallback
>     rates are done via mac80211 and aren't affected by this change.
>=20
>     Signed-off-by: Adrian Chadd <adrian@freebsd.org>


This makes sense. I guess you tested this on actual hardware?

In the final submission please send this to Kalle Valo and add [PATCH]
to the subject, so tools can pick this up.


> diff --git a/drivers/net/wireless/broadcom/b43/xmit.c
> b/drivers/net/wireless/broadcom/b43/xmit.c
> index f620126..fbf0e92 100644
> --- a/drivers/net/wireless/broadcom/b43/xmit.c
> +++ b/drivers/net/wireless/broadcom/b43/xmit.c
> @@ -205,7 +205,7 @@ static u16 b43_generate_tx_phy_ctl1(struct
> b43_wldev *dev, u8 bitrate)
>         return control;
>  }
>=20
> -static u8 b43_calc_fallback_rate(u8 bitrate)
> +static u8 b43_calc_fallback_rate(u8 bitrate, int gmode)
>  {
>         switch (bitrate) {
>         case B43_CCK_RATE_1MB:
> @@ -216,8 +216,16 @@ static u8 b43_calc_fallback_rate(u8 bitrate)
>                 return B43_CCK_RATE_2MB;
>         case B43_CCK_RATE_11MB:
>                 return B43_CCK_RATE_5MB;
> +
> +       /*
> +        * Don't just fallback to CCK; it may be in 5GHz operation
> +        * and falling back to CCK won't work out very well.
> +        */
>         case B43_OFDM_RATE_6MB:
> -               return B43_CCK_RATE_5MB;
> +               if (gmode)
> +                       return B43_CCK_RATE_5MB;
> +               else
> +                       return B43_OFDM_RATE_6MB;
>         case B43_OFDM_RATE_9MB:
>                 return B43_OFDM_RATE_6MB;
>         case B43_OFDM_RATE_12MB:
> @@ -438,7 +446,7 @@ int b43_generate_txhdr(struct b43_wldev *dev,
>=20
>                 rts_rate =3D rts_cts_rate ? rts_cts_rate->hw_value :
> B43_CCK_RATE_1MB;
>                 rts_rate_ofdm =3D b43_is_ofdm_rate(rts_rate);
> -               rts_rate_fb =3D b43_calc_fallback_rate(rts_rate);
> +               rts_rate_fb =3D b43_calc_fallback_rate(rts_rate, phy->gmo=
de);
>                 rts_rate_fb_ofdm =3D b43_is_ofdm_rate(rts_rate_fb);
>=20
>                 if (rates[0].flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {

--Sig_/6DG2qdiPNl.gIqE8HnLXB6W
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXOIhxAAoJEPUyvh2QjYsOXJ8P+wbtFXpfg/oCX7x0gH+586IP
5j0DtGE/6LNeKPfcRDhvwbvAUjasA/nF4rwoxpfKpCWJ9DPH2ydPCJ1GsevUlWt1
EbBmfOemdn7aHd/FQIEYuF/zXJI2yXWkNZCfBKeeYvLuizgUpbGPTPOcQc8VW4Si
nNQuYgfmCi09r8ghkUVbfe2C2qO2aiUvzgYoqigzuL//BJ4ped1WIuDtbvz8WE7h
sJpSnmL2SXQhxIxfA26Mlpc1o0IG1KiavMWQOxxQMhKvIx6OSgTiw3azmb5aUDDk
SdQg6fw4hiy5bMvCWM7Grs+pPlb9eFS5O9pRYTPEtzgYlRS1jaFbP/jLbnDNh+ko
sHFNly2pTTpoWVU6Ycf81o2H4wyg6ZT8TFdwjqEnGa1D5GwewLpJpwWT53XZKjKT
KyUT/EjK1HAUFJtkv4koPCJ9XfYnSaC7Pej2lOze08SOFJQ9vNUrhVO/TV092lLn
6l6nmSMHphLq15c7l7kvwERl9jtEqALwHohgAEj4d3rj1iRyXQi3sv8HQRRbM6K/
X+hrle31YCoV9sOXJH2qWcrqj7XjqhZVygZiBmmxn3r8sA7fQfr15oH7QWs7JUW/
rvEb4ecRnFqryesVxIarna6VkRbUryr1JEhC1UI02Y//DYR1bq4yx5bumNR0F8ex
/Z0pLWyNvBGagNM1cRSP
=GME/
-----END PGP SIGNATURE-----

--Sig_/6DG2qdiPNl.gIqE8HnLXB6W--
