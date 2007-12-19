Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbXLSQnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:43:16 -0500
Subject: Re: [PATCH v3 1/8] mac80211: clean up rate selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071219012528.7cb831eb@morte>
References: <20071219001955.055692620@polimi.it> >
	  <20071219012528.7cb831eb@morte>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Hd9hnib98A4wZMKq0OV3"
Date: Wed, 19 Dec 2007 17:42:43 +0100
Message-Id: <1198082563.4747.25.camel@johannes.berg> (sfid-20071219_164321_994396_F4AF9A96)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Hd9hnib98A4wZMKq0OV3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +static inline int
> +rate_lowest_index(struct ieee80211_local *local, struct ieee80211_hw_mod=
e *mode,
> +		  struct sta_info *sta)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < mode->num_rates; i++) {
> +		if (rate_supported(sta, mode, i))
> +			return i;
> +	}
> +
> +	/* warn when we cannot find a rate. */
> +	WARN_ON(i =3D=3D 0);
> +
> +	return 0;
> +}

That doesn't look right. Shouldn't it be WARN_ON(1)? Not that it can
ever happen with proper drivers...

Other than that, looks ok to me.

johannes

--=-Hd9hnib98A4wZMKq0OV3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2lKAaVg1VMiehFYAQIAbQ//aN1cmuiwtZEa1pU10RnNlWL81j/vx5Gh
YCsprlP/OQtVR+q3WSzBG7kV95l8P1xoOvacyT+viKwdEzqaMDUrb3vy6ngH9NJi
Z+9quYeAElCNjTr+SFiJm4rXjjwNyghQHg3y+1vT2k3q5ktP8X46/8cwmPgwecaD
Fis9DqvUoWxYzH3Bvg+9n1V4tXcevC7CJVcsCAxEadU6nA+1wpSDL0xIPbhi1G5T
ztFsoigd7YXhDT1SWcE36s6H+HGsfKRGZUE0VIEuszVgwXCMZGUygb/EZjAWjev8
ZchbE+0Icj9geQYy+F61Ve7KSKapJuYp6TeDkcf+R87weJYv875Ugj98Cxn/DMWQ
zLHEn78cYW/rXZaK5OtCpJpecq8OosG0m6FX58ohoq3SqWphwnH7cTY5FrbqECTT
79aXy7rUtEBN1gV2CgRJD3FnnxyGQBKEM8LLr4vSPl89zaqm2Wh/5rgGY1BUQNMr
VkU1WzdNRTUGQ79/sZPFJ6BuTgnmJAth3Q90eFcP2ZJy5tnhoQRI/DPoIF/WI6o/
Gp/WXJxfoXE2qbINtTnNIBaiEulftemXXBPypMMIOOICSa2+tLx9/oSZAf2Pkix3
nNWO52tJoz06lC6rby8iX0J3XentRrHG+8prSBX7h7EZwQ5GWKKCt3IXMCYeoBJQ
LtsnKVRi/U4=
=i0ON
-----END PGP SIGNATURE-----

--=-Hd9hnib98A4wZMKq0OV3--

