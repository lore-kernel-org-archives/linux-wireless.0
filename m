Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34084 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYLVG4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 01:56:40 -0500
Subject: Re: [PATCH] rtl8180: Fix to add STA mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <494eb7d1.t197ktKMLMlIer8t%Larry.Finger@lwfinger.net> (sfid-20081221_224041_525205_B0C21FE7)
References: <494eb7d1.t197ktKMLMlIer8t%Larry.Finger@lwfinger.net>
	 (sfid-20081221_224041_525205_B0C21FE7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Zowgo2igcgZ4m1CHT3gF"
Date: Mon, 22 Dec 2008 07:56:36 +0100
Message-Id: <1229928996.3087.3.camel@johannes> (sfid-20081222_075657_561165_6B8B2F15)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Zowgo2igcgZ4m1CHT3gF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-12-21 at 15:40 -0600, Larry Finger wrote:
> To be compatible with mac80211 following commit 3fc7826b95521 (mac80211:
> only create default STA interface if supported), rtl8180 needs to set
> NL80211_IFTYPE_STATION in interface_modes.
>=20
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Reported-by: Fabio Rossi <rossi.f@inwind.it>
> Tested-by: Piter PUNK <piterpunk@unitednerds.org>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

obviously. I didn't know we'd missed an in-tree driver when adding the
interface_modes thing, thanks.

> ---
>=20
> John,
>=20
> This patch should be included with the 2.6.29 material.
>=20
> Larry
> ---
>=20
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8180_dev.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8180_dev.c
> @@ -898,6 +898,7 @@ static int __devinit rtl8180_probe(struc
>  	dev->flags =3D IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
>  		     IEEE80211_HW_RX_INCLUDES_FCS |
>  		     IEEE80211_HW_SIGNAL_UNSPEC;
> +	dev->wiphy->interface_modes =3D BIT(NL80211_IFTYPE_STATION);
>  	dev->queues =3D 1;
>  	dev->max_signal =3D 65;
> =20
> ---
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

--=-Zowgo2igcgZ4m1CHT3gF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJTzohAAoJEKVg1VMiehFYAh8P/1uPhxJRPJ7pIvkLWDoZNK4y
yOfn54OzLbtVyOxG1HVgynp2b+6j1KHjCoVsGXDHdrYIqcYZA56VHlxkxnuDoYTw
aEFnbWJbi1r7mfrQybSWuXBG9aILiT4XHoJ4c4PWyYH+/CV2rrcZW0xcZJFof+Nm
VIM7U9qdf3atmy9uQNoYlsmBEk3bgTgWd/U+A/JDjSohvu3UknfRfPYElEHnoMTE
xzm8azNpBMabGVHxWwCsNFXNdB7jPJlPczOLdiA26ra5a2x7W2enXOVFb/xHJPQa
tMg96ePTrpL3XOmDflb/6kyd8jqIrgcOm07ITDLozOnKLIY09RV1b+4l0qlG8ezY
WUkZIWJwiSnh89pRTp9yoEeCuOJOBYkYyNN8iYiCjlf+cYoVvHSgIWQaKqU5R3ZT
q1CLuT9h6h+5QE42o767PnpYsSQXi190DI6AOQBLqGv5hLxmSc9KhP7OMVi9JAEY
lJzzlDT+hCDm/3j1uxvIunyxl8zXHNe0pMlJYnmMe7KkuzH2vjkcFaOO1BFLRmD/
NvfJgrjhLcNQCdDzv2ybr2Sxxt+JaCgfbCQrp7eO3SZUyYrBate8/YC0hbKgNnJ1
N/zcsr8Hc5aY+tFqYsbWtMMas6CUg04ITATGLh2r3ZxaJqS/PI35YGuG82SrJaa0
deQSmbHm4grPah58EMvC
=tLFB
-----END PGP SIGNATURE-----

--=-Zowgo2igcgZ4m1CHT3gF--

