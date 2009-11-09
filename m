Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37443 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009AbZKIQuu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 11:50:50 -0500
Subject: Re: [PATCH]: setting bit-rate when injecting
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless@vger.kernel.org, technoboy85@gmail.com
In-Reply-To: <f74418680911090807g4e83a15cr2ce21ea21a86ea23@mail.gmail.com>
References: <f74418680911090807g4e83a15cr2ce21ea21a86ea23@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Zke4RWCk1AIbtasJ/Axr"
Date: Mon, 09 Nov 2009 17:50:22 +0100
Message-ID: <1257785423.29454.177.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Zke4RWCk1AIbtasJ/Axr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-11-09 at 17:07 +0100, Lorenzo Bianconi wrote:
> I and my Matteo Croce made a patch which adds the capability
> to set the bit-rate when injecting in monitor mode.
>=20
> The code parse the bit-rate field from the radiotap header and passes the=
 info
> to the struct ieee80211_tx_info
>=20
> --- a/net/mac80211/tx.c	2009-11-09 16:41:15.000000000 +0100
> +++ b/net/mac80211/tx.c	2009-11-09 16:50:12.000000000 +0100
> @@ -505,6 +505,9 @@
>  	struct ieee80211_tx_rate_control txrc;
>  	u32 sta_flags;
>=20
> +	if (info->control.vif->type =3D=3D NL80211_IFTYPE_MONITOR)
> +		return TX_CONTINUE;

Sorry, can't do that, we need rate control for packets that are injected
from hostapd.

> -	int ret =3D ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len=
);
> +	int i, ret =3D ieee80211_radiotap_iterator_init(&iterator,
> +			rthdr, skb->len);
> +	struct ieee80211_rate *rates;

A separate "int i;" would be a lot cleaner I think.

>  	sband =3D tx->local->hw.wiphy->bands[tx->channel->band];
>=20
> @@ -979,6 +984,25 @@
>  				tx->flags |=3D IEEE80211_TX_FRAGMENTED;
>  			break;
>=20
> +		case IEEE80211_RADIOTAP_RATE:
> +			rates =3D sband->bitrates;
> +			for (i =3D 0; i < sband->n_bitrates; i++) {
> +				if (rates[i].bitrate/5 =3D=3D *iterator.this_arg) {
> +					info->control.rates[0].idx =3D i;
> +					break;
> +				}
> +			}
> +			info->control.rates[0].flags =3D 0;

This leaves the number of retries at ... 0. That makes no sense. What
driver are you using that this actually works with?!

> @@ -1518,7 +1542,6 @@
>  					 struct net_device *dev)
>  {
>  	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
> -	struct ieee80211_channel *chan =3D local->hw.conf.channel;
>  	struct ieee80211_radiotap_header *prthdr =3D
>  		(struct ieee80211_radiotap_header *)skb->data;
>  	struct ieee80211_tx_info *info =3D IEEE80211_SKB_CB(skb);
> @@ -1540,9 +1563,6 @@
>  	 * radar detection by itself. We can do that later by adding a
>  	 * monitor flag interfaces used for AP support.
>  	 */
> -	if ((chan->flags & (IEEE80211_CHAN_NO_IBSS | IEEE80211_CHAN_RADAR |
> -	     IEEE80211_CHAN_PASSIVE_SCAN)))
> -		goto fail;

We don't want to break regulatory rules either ...

johannes

--=-Zke4RWCk1AIbtasJ/Axr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK+EhLAAoJEODzc/N7+QmaEDYQAJS+iiksdBBqiyS/4/EB78IG
fwyqfSuxQURVCztQgIBhawIfyS5MfS3vnuurEzMCbYBWd10OEIoeF46b+9Z4EnCA
hiWzJ8T8g5BI6mZTD9HrOg6F9993b11Gn4KWk+MTX5jOIuL2hwaqB5Rf4RH526jg
M0Os3yzn/1ACx9TVqJGWL1J4H58MawaS5Z+8oZSHmnxR4Iwm72Vb0fz1HmJ6s6wL
iH+qm9G1C8eSgVhmw2rO2e3A8fnXsDaroPfag4VlKkrFuddaiuF6ZzpVdMT3/baZ
Kmsfd2zhhHFGK5dpcNHPG3nxPc3N9vHLqK8t8YHCP3Dq7Lb8ItODmJty77CUlekI
VquzrHGzyoBUtTxiSDPS7uSISdNsqFRI/vVPEgb/oef4m5b8dCWAQ+1nMVJAZ0op
vD3oRa3D+g0UODdohxOAQjn8kvBQ7samcafiJ3IYa2UpAxhdzc12C2EpTQp9IlVN
OAnZ5UYU2KgwLg1FV1xe0BbmZFY7xikSkHQG6OsdXIDhBpx4XH11QT+0E8sh3G8s
TEF0yJkCHw0T9FXuDV0ShRo4JjeZhVQItOWUE1qTVe/+6jkItIa1NwoSG08Sv1W9
lptNtNqrfAYK9VLKqcFD/32FfSai4WJZwKz9huNOlN2jDZM4NxIzGeTC0HuLph1m
0a9MHEsU8C60c3e7TUJM
=SJfE
-----END PGP SIGNATURE-----

--=-Zke4RWCk1AIbtasJ/Axr--

