Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbYGAKtR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 06:49:17 -0400
Subject: Re: rt61 and TSF reporting?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200807011247.57739.IvDoorn@gmail.com> (sfid-20080701_124340_925081_6971CC60)
References: <1214907990.7763.40.camel@johannes.berg>
	 <200807011247.57739.IvDoorn@gmail.com>
	 (sfid-20080701_124340_925081_6971CC60)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NhyqtuxwpjCLgcjBxz95"
Date: Tue, 01 Jul 2008 12:48:34 +0200
Message-Id: <1214909314.7763.43.camel@johannes.berg> (sfid-20080701_124920_125993_502D342A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NhyqtuxwpjCLgcjBxz95
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> The specsheets say nothing about TSF timestamps anywhere else then
> the registers (which is accessed by the get_tsf() callback function).
> To be more exact, the specsheets say _nothing_ about the RXD descriptors =
at all,
> which means they are not helpful for that. ;)

Heh.

> However there are a few RXD fields which are labeled as "reserved" which =
could
> mean the field is present, just not documented.
>=20
> You could try printing the values of those words to see if they contain v=
alid data,
> and to be more exact the TSF data (this can be done in the function rt61p=
ci_fill_rxdone(...))
> The undocumented/reserved words are: 6 to 15
>=20
> Do you want me to come up with a patch for this?
>=20
> Note that these undocumented fields only are present in rt2500pci and rt6=
1pci.

Ok cool, I'll play with that, I should be able to make a patch myself,
thanks.

> Neither rt2500usb or rt73usb contain them, which means that they can't re=
port the TSF
> based on descriptor information.

So I guess they just don't transfer those reserved fields on USB.

johannes

--=-NhyqtuxwpjCLgcjBxz95
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIagt+AAoJEKVg1VMiehFYn/wP/2Vb6uiy2KPwHixnVpqabfMB
GfN8g4O6UDbSRseIS0cmab6IkgSqj4d/psmlPSmMTZg76t/2C4YsV8ykfoKdoE8l
GRNHTdW3vDrUZL03pe1VU9rF0XMgpo7AqoMPFK+0qhi8BRQyzWMWYh1XTndgDdTa
Av9qrYbPNR9ruIA7brPn1ufVD+CbK/beQbsY0NUW+jnA/Y+QrvjlvNW0wU15Z5QY
7vprjZM4rKoyvNYxprZLFfeefC8gglUdhcieCVyHIq1PqCEw9crwWGhbRwGtFRNy
7o4gtVl3jkH+7qJAkanRuxYhwX2UaIPyY9n7XU6/14lZh3nkz4PNL9yDDDPtlKpp
/xAA5WmiMML837HBGEaGvxJU5Ky4EuP5so0FX3IZ8XIc/B0UswsYR6FmcOgOc/6l
vdc5x3grwEQbIlMm0xtq6fj/fAip5q34Atkz+1pDrnOnC/q5nOOPD6Eyn4r1EoU6
hqW/aQOwQGwZiXBPjDLL3M/5ux0qBatcKoLjNbc5pYbbgkAbtbz11itOytk2jbkR
QgrSfdwJ6FZNzKI0gMRrWxH+t479+L5Om2KX7WJ8JqjliOlzciwibgFuTWfncfG0
2l9QqJGlX+2+UIkjamWN09r7vKzGYKEHukxJcS5A3oMbP48Bx+FTnEcfqbQTbenS
nWKabD5MvjLIl1w36Rsc
=IRRH
-----END PGP SIGNATURE-----

--=-NhyqtuxwpjCLgcjBxz95--

