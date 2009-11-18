Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53823 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbZKRKmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 05:42:45 -0500
Subject: Re: [PATCH] mac80211: Fix panic in aggregation handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <19203.36926.787342.765046@gargle.gargle.HOWL>
References: <19203.36926.787342.765046@gargle.gargle.HOWL>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mHlD0RpPOW3VA1aVcX6h"
Date: Wed, 18 Nov 2009 11:42:14 +0100
Message-ID: <1258540934.30511.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mHlD0RpPOW3VA1aVcX6h
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-18 at 11:42 +0530, Sujith wrote:
> Not assigning the vif pointer causes an oops.
> This patch fixes it.

Ouch, sorry about that, and thanks for the fix. I /thought/ I tested it
but apparently not :(

johannes

> Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> ---
>  net/mac80211/agg-tx.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
> index 6ddd114..26d42e8 100644
> --- a/net/mac80211/agg-tx.c
> +++ b/net/mac80211/agg-tx.c
> @@ -489,6 +489,7 @@ void ieee80211_start_tx_ba_cb_irqsafe(struct ieee8021=
1_vif *vif,
>  	ra_tid =3D (struct ieee80211_ra_tid *) &skb->cb;
>  	memcpy(&ra_tid->ra, ra, ETH_ALEN);
>  	ra_tid->tid =3D tid;
> +	ra_tid->vif =3D vif;
> =20
>  	skb->pkt_type =3D IEEE80211_ADDBA_MSG;
>  	skb_queue_tail(&local->skb_queue, skb);
> @@ -625,6 +626,7 @@ void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211=
_vif *vif,
>  	ra_tid =3D (struct ieee80211_ra_tid *) &skb->cb;
>  	memcpy(&ra_tid->ra, ra, ETH_ALEN);
>  	ra_tid->tid =3D tid;
> +	ra_tid->vif =3D vif;
> =20
>  	skb->pkt_type =3D IEEE80211_DELBA_MSG;
>  	skb_queue_tail(&local->skb_queue, skb);


--=-mHlD0RpPOW3VA1aVcX6h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLA8+DAAoJEODzc/N7+QmaLI4P/0fMkSot7ibFufvShK4+qSMo
UUTfgnT+pM/CVVoK9x+UDfOslRLwYismgnVv17c3HedswL+Yzg6vaNyuFhm6P1J3
gIUgWIZeqt1vju7qaGTlnv0CoufhC4nWPh+DTn9USOsXN9Py0wlgevVVMpY3/nPf
yNH1hwccjtzZSlahwiQPpbE4HBOVYP3fFMg9A6DwUMS+94DQ4FQrSJkJeq1nK6dP
9CisPYO/vAyRhHc6HWqvq7MfbQR9jtr0RknnJ16APxtfaxjN5PPCIw5gGz+0nXH3
YpBlBl77biXOPerEePYwMtScBNsocJIH/ff9nYGNVhnaCku/ZKtyf95WKC1g4jR5
/eMJupRn13OLMrayj/9sbEN5pACtQYf+aBQ9JG7S/UxsZ8k+MKOzdTt3uH/nHLUc
M1JaBHlD2Gl161jEfCOzXbRn7vNqdwJgZ97wQuGLSslvt2ElLhXn0p0xHS/pf+60
rqAapQ1CcX1t4SmC0pGiuZt50J8hTihBUuks8yHuZeB/LOG9Sjbf1sm19778BJxX
zAkdPWx0aRlsFCwf6Hemm7P6bMoQrN1FJX9zTbS2/XrNJQLvk2XyL9k6KQosOr1R
ycMhDq9cuQXo1hJByPwEZWVuxhX8EwXYi7q/8dOLQiVtshmtfE5pmxKMOUFzQeck
bvACpsHmMFbuD1IGEXrm
=Ae4m
-----END PGP SIGNATURE-----

--=-mHlD0RpPOW3VA1aVcX6h--

