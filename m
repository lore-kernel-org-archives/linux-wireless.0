Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36114 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbYKZIcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 03:32:22 -0500
Subject: Re: RFC Patch: Add signal strength to nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Henning Rogge <hrogge@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <EA31B699-C803-460C-8D90-9E946CC97A33@linux.intel.com>
References: <200811252131.30161.hrogge@googlemail.com>
	 (sfid-20081125_213139_680674_17E7A0BB) <1227646037.4613.46.camel@johannes.berg>
	 <EA31B699-C803-460C-8D90-9E946CC97A33@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kXnIKrxcdeOlJxMq/8+V"
Date: Wed, 26 Nov 2008 09:32:16 +0100
Message-Id: <1227688336.4613.51.camel@johannes.berg> (sfid-20081126_093226_028624_7A01D2E0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kXnIKrxcdeOlJxMq/8+V
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-26 at 06:21 +0100, Marcel Holtmann wrote:
> Hi Johannes,
>=20
> >> +	NL80211_STA_INFO_SIGNAL,
> >> +	NL80211_STA_INFO_NOISE,
> >> +	NL80211_STA_INFO_QUAL,
> >
> > Sorry, no, this WEXT junk is just too undefined to put it into =20
> > nl80211.
>=20
> I know that WEXT were pretty bad in describing what to expect from =20
> these values and every driver did whatever it thought it would be =20
> best. Can we not just try to define how these values should be filled =20
> in and then either mark drivers as broken or try to fix them? Just an =20
> idea.

But it doesn't even physically make sense. The noise is not per station
but rather per channel, if you know it at all. The "quality" is simply
not defined, and would usually be "signal", unless you're doing
something else to estimate "quality", like taking into account
retransmissions, ... And then signal/noise should be in dBm.

johannes

--=-kXnIKrxcdeOlJxMq/8+V
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJLQmNAAoJEKVg1VMiehFY884P/i7bEO9TDsaKq9I4HzpqODqI
ISz/KyrWIzhZbhHbRpFPxX2jd4BYd8ZqQlVhrdSTSy2Qi3yW7th/g2EMX3nN9To3
N+keUmb9QvH+BPZHxYUDy3GPdkM9NbvAGoLnP90ioJBSeM4KWn9sLM0oLPvt2rY3
YSrAVrLMZJ2/AwVjP4n1levMavk8GOMDI0c3FRLBxLyKimZl3mwWmBNvv88+qpm9
LE7A7sj3oaFfmVwy+bnSmC6X7oFaLN5mJsfAsRe+Tb7ZSdPAioXzDQdW/wAUdKal
MthXe6Y3Ej8/gTNUVNB0s9LfEiauOVTvoZm1yIuLWe2NhGWk/9O4OG2FuiOV8OTq
F7jvvoNH7I/sQ54vL3fhytwbJeAHmWApW3c3FBPA6enecUPQ32aosHqUFXKAdbkg
xxVz9UcvUoWxa3th9pAJtfbDn0/pTxxLSubu8CGR8d2gO6Pivwx3cmzUyLG+MSjG
stsEJF4gIbGpMs9GJczHLtRgh7Ax0mK50fTdjTd+QKNZVQf7X/0s/hK88DtnTBb7
Y4KpNYvZPhnK6/45PY0Xdv8GkPYsIjsan0VjzSvA4KyIJixToDrKqHoF4Koa4UmP
cSvu3VI82B47kA5fTbqAeNlgTg6iWhpHgZh7nDPiQMaD6o5669bJq0g3cEaWfHzw
5/Iu+3xYqX1FWkchszqZ
=mJXv
-----END PGP SIGNATURE-----

--=-kXnIKrxcdeOlJxMq/8+V--

