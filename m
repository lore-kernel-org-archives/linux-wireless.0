Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbZCQXbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 19:31:18 -0400
Subject: Re: [PATCH] zd1211rw: Do not panic on device eject when associated
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090316194733.GA23062@jm.kir.nu> (sfid-20090316_204748_435020_3BB72D18)
References: <20090316194733.GA23062@jm.kir.nu>
	 (sfid-20090316_204748_435020_3BB72D18)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-blAnJyhUVZTeerbsRyTb"
Date: Wed, 18 Mar 2009 00:30:42 +0100
Message-Id: <1237332642.5100.10.camel@johannes.local> (sfid-20090318_003121_260116_9554FC53)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-blAnJyhUVZTeerbsRyTb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-16 at 21:47 +0200, Jouni Malinen wrote:
> zd_op_tx() must not return an arbitrary error value since that can
> leave mac80211 trying to retransmit the frame and with the extra data
> pushed into the beginning of the skb on every attempt, this will end up
> causing a kernel panic (skb_under_panic from skb_push call). This can
> happen, e.g., when ejecting the device when associated.
>=20
> Signed-off-by: Jouni Malinen <j@w1.fi>

Should be for the various stable versions too. All of them, most likely.

johannes

> ---
>  drivers/net/wireless/zd1211rw/zd_mac.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>=20
> --- wireless-testing.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2009-02-=
28 00:24:24.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/zd1211rw/zd_mac.c	2009-03-16 21=
:44:07.000000000 +0200
> @@ -575,13 +575,17 @@ static int zd_op_tx(struct ieee80211_hw=20
> =20
>  	r =3D fill_ctrlset(mac, skb);
>  	if (r)
> -		return r;
> +		goto fail;
> =20
>  	info->rate_driver_data[0] =3D hw;
> =20
>  	r =3D zd_usb_tx(&mac->chip.usb, skb);
>  	if (r)
> -		return r;
> +		goto fail;
> +	return 0;
> +
> +fail:
> +	dev_kfree_skb(skb);
>  	return 0;
>  }
> =20
>=20

--=-blAnJyhUVZTeerbsRyTb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwDKfAAoJEKVg1VMiehFYm38P/1koptT2CZPHu9NhFFJOLWhd
bHGdyxXctgpHfqe2bT78SRBUAwxAlUHwRYdlEz0D3ytHoLYWanbE+79VCd1t0DDv
RANm2jEAXRaFh+OZHjfDARlVKRhUJ1uviwJNpiZab4ZLc0SqXFbZRxHDHf0plYdD
YTsixwJDOGztPfQuXvvlAAB9FPzs8N7d4c8Xjvd6Y2TacIZtBxesjp39svg+hpQz
c/x0JvudeX/oh4nNyj43IhUR777hInQN94jAs3vndO2+YDKLon7XnbqvvoqF2ve+
jBB+25gC+fY3IdRQLuIzEh698+qrVPSEmjH/q5QX+XaFIfHDq7l0hZgjPPHg3Jn0
hcWv/FStZHVW0PuOKyjka8AAP4EJ5tNWz27Vuw416H3JyjwvzGfCSZM3EPaGkC33
25lQ+ud1cjMn8Tjzk2pq3cebi8quOCqIhfeW2CnKZVseGWtGfEkLKeHawv7w7Dvo
w+TphonZLbMORpZFdDDyRsM5PqUb5WP2YINvKQrWcwVfMgMJFjc/XYz2muacfviJ
7vfJF6GIz+K/zUTFDcSDigToj9bPIYN1IhKFWTMH7PWOMD8kC77A/lbDq2yZwqDl
q7svFIvw9wF4+BhLc7zclN4tUZhYuLCxthx1Ifs32j81avSoJsg/YC99kTehQzuk
3Uli4DTevCl+Q8mOeo/Q
=4CNQ
-----END PGP SIGNATURE-----

--=-blAnJyhUVZTeerbsRyTb--

