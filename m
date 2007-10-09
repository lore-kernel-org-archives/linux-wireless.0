Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43737 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbXJJIoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 04:44:22 -0400
Subject: Re: [PATCH] mac80211: Defer setting of RX_FLAG_DECRYPTED.
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	rt2400-devel@lists.sourceforge.net
In-Reply-To: <1191769555.8135.8.camel@localhost> (sfid-20071007_160610_867095_94AA695C)
References: <1191767731.8135.5.camel@localhost>
	 <200710071653.53335.mb@bu3sch.de>  <1191769555.8135.8.camel@localhost>
	 (sfid-20071007_160610_867095_94AA695C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wfi4SrtLyj/4YQzmPJ79"
Date: Tue, 09 Oct 2007 22:12:32 +0200
Message-Id: <1191960752.4013.60.camel@johannes.berg> (sfid-20071010_094425_001910_29CC4425)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wfi4SrtLyj/4YQzmPJ79
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-10-07 at 17:05 +0200, Mattias Nissler wrote:

> The decryption handlers will skip the frame if the RX_FLAG_DECRYPTED
> flag is set, so the early flag setting introduced by Johannes breaks
> decryption. To work around this, call the handlers first and then set
> the flag.
>=20
> Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

However, the patch is mangled (line-wrapped)

> ---
>  net/mac80211/rx.c |   20 +++++++++++---------
>  1 files changed, 11 insertions(+), 9 deletions(-)
>=20
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index de3f7ae..34699a1 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -424,6 +424,7 @@ ieee80211_rx_h_decrypt(struct ieee80211_txrx_data
> *rx)
>         struct ieee80211_hdr *hdr =3D (struct ieee80211_hdr *)
> rx->skb->data;
>         int keyidx;
>         int hdrlen;
> +       ieee80211_txrx_result result =3D TXRX_DROP;
>         struct ieee80211_key *stakey =3D NULL;
> =20
>         /*
> @@ -522,21 +523,22 @@ ieee80211_rx_h_decrypt(struct ieee80211_txrx_data
> *rx)
>             ieee80211_wep_is_weak_iv(rx->skb, rx->key))
>                 rx->sta->wep_weak_iv_count++;
> =20
> -       /* either the frame will be decrypted or dropped */
> -       rx->u.rx.status->flag |=3D RX_FLAG_DECRYPTED;
> -
>         switch (rx->key->conf.alg) {
>         case ALG_WEP:
> -               return ieee80211_crypto_wep_decrypt(rx);
> +               result =3D ieee80211_crypto_wep_decrypt(rx);
> +               break;
>         case ALG_TKIP:
> -               return ieee80211_crypto_tkip_decrypt(rx);
> +               result =3D ieee80211_crypto_tkip_decrypt(rx);
> +               break;
>         case ALG_CCMP:
> -               return ieee80211_crypto_ccmp_decrypt(rx);
> +               result =3D ieee80211_crypto_ccmp_decrypt(rx);
> +               break;
>         }
> =20
> -       /* not reached */
> -       WARN_ON(1);
> -       return TXRX_DROP;
> +       /* either the frame has been decrypted or will be dropped */
> +       rx->u.rx.status->flag |=3D RX_FLAG_DECRYPTED;
> +
> +       return result;
>  }
> =20
>  static void ap_sta_ps_start(struct net_device *dev, struct sta_info
> *sta)

--=-wfi4SrtLyj/4YQzmPJ79
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwvgr6Vg1VMiehFYAQLnbRAAsDV4JLa9dy/1wDZzhtaEgKq3PosN9kDZ
0I/2jNi0XdgpL7cL06z31xVPfhgA8PTVrdQfOLymmHrgWjB55v7h0jjEaC8nhSSx
9aRRnbPod2ZWsdhrWNAeOJA5TlgMLGOMn6o89ux2Uc+mQrBfhdqGkhldsZnrNlqf
pf7/X/U51ilHPMjhw4YkQ0VdCy1v/QGbhRMnxW1Tldy8jni3Q9PW+BwMbPZdzQ4G
WoQRo6IgaYjg9SxH5UcwO4ARuKt9LPaKotAIRfq09wki3eIEboZKQuOXdhlxZyW6
rBtCLhDlCAsvhCSnu1gCDTESwtJ5pfGTIf94lTggCPqcUxZRCQ5DMBknlDR8kyfE
V2t2+MxAS9dd1Mp86hf8erQ9Wj1iVt/wxHnPLEUKI7fsvgX5HfL00j7h0v8yJDsT
Fm24raZ3ruFXtsdrul++P+RtC57TqssEPrVXvKWe/wy7wklvYdzaJOQFaTSo+0By
vyKaS+U0AphiyJhqx2TNGbZGG7luD5GbTkV181+/EpSApqOuFFIpbvd3tDRvcwWB
WxmygDUfXLq0xD6F4EvWXgcjO7KrvQ/qls1/YTV+EBX4Ic8AkHZcY+mfLqQcFuIf
yT4eEOP6jELmku2oYpp9xkFX/VJfo5dD2DHk2F8AUVB3BYDkBoNB+pzSbhadcunE
FaaT2j/jA5U=
=YdXO
-----END PGP SIGNATURE-----

--=-wfi4SrtLyj/4YQzmPJ79--

