Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42327 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbYKWLM6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2008 06:12:58 -0500
Subject: Re: [PATCH iw] Report max TX power from NL80211_BAND_ATTR_FREQS
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20081122200202.GC8265@jm.kir.nu>
References: <20081122200202.GC8265@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yVPnmrqvezuvvcQyPyrZ"
Date: Sun, 23 Nov 2008 12:12:53 +0100
Message-Id: <1227438773.3599.41.camel@johannes.berg> (sfid-20081123_121302_447837_B9DD7112)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yVPnmrqvezuvvcQyPyrZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +			if (!tb_freq[NL80211_FREQUENCY_ATTR_DISABLED])
> +				printf(" (%.1f dBm)", 0.01 * nla_get_u32(tb_freq[NL80211_FREQUENCY_A=
TTR_MAX_TX_POWER]));

You need to check whether that attribute is present too otherwise iw
will segfault on kernels that don't have it, I've fixed that and
committed it, thanks.

johannes

--=-yVPnmrqvezuvvcQyPyrZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKTqyAAoJEKVg1VMiehFYRMoP/iEAi3ZJSFZRlSlTgPNrV2ws
nOrGWGF+S2UA0P/aWzGEIXUVeCYmg9ErOqTwrNGdN/4iD7SRj/jjJ3HGEBrL9tPs
QKB9tU1n3WJMbdMMHMDAp5YTmRLKxQ3QW6cNC1yvVdsjKzb6U7MlWSt74iW91fdi
6D1CmnXYXVxIrYZK0qmQ9yzgv8JsL2RxgP1If+VFl9K0ZLjkObxvUSZd8ZD2/lXE
+3tcAARW1SWn4D1V3mJ10zRx6/lbc95trtQy4/Xx6j80qFjWyR/RoB3F1FgtAuVA
iuiFIEgmESyxygp3KDnQAoqouMeSJFlTSEdWnuH6dbH8H/MlhjPZCeG/Qyco3EcB
U04EjsEP0hZz2y0OzbAs7aWoslKvraxV7z8NTZZ2rC+4sxFgxuzOcEefM2FBrc+s
+Sg1jaHUEJLTBh8ECrpMIuszWusOaG7f9gZt+OU1h6E2C/mohnsHbNg1MzzSpFRU
yFY1Kuetid+K4X9O6N9IMb34ZuC5QBxZTignY3Id9uMlrCbmHiY/wkqK6mnTaZi8
Gawr7rNs8slyq4aRoseeMWFIOASBGbM7stIAp5drlKpEdms4o6Rm8Iq0iUnStdfm
T0NUB7TUi4WC47ZUwvB77ElS9MLnWMrytuFPn7fCt6R9OBBThCqJ0ouKtSYkgNsX
FKNZjR2Osnp4uoU6vce5
=3Nw5
-----END PGP SIGNATURE-----

--=-yVPnmrqvezuvvcQyPyrZ--

