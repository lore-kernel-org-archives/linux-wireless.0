Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51990 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYDGOMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 10:12:43 -0400
Subject: Re: mac80211 hardware encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200804071610.47598.IvDoorn@gmail.com> (sfid-20080407_150805_069885_D2A6A3DD)
References: <200804051931.58895.IvDoorn@gmail.com>
	 <200804071534.38526.IvDoorn@gmail.com>
	 <1207576041.12481.21.camel@johannes.berg>
	 <200804071610.47598.IvDoorn@gmail.com>
	 (sfid-20080407_150805_069885_D2A6A3DD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vd5q6+GUf2HRjLOouA3e"
Date: Mon, 07 Apr 2008 16:12:29 +0200
Message-Id: <1207577549.12481.24.camel@johannes.berg> (sfid-20080407_151249_946604_DC29B372)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vd5q6+GUf2HRjLOouA3e
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I'm not sure if I understand completely what you mean but rt61pci/rt73usb=
 hardware does the following:
>=20
> 1) Receive frame
> 2) Determine key from register
> 3) Put IV/EIV into descriptor
> 4) Decrypt
> 5) Notifies driver about the frame +  decryption status

Ok, so you get those out-of-band.

> Well as an alternative to adding it to tx_control, perhaps a callback fun=
ction for drivers
> could be provided? At the moment mac80211 calls:
>=20
> ieee80211_tkip_add_iv(pos, key,
>                       (u8) (key->u.tkip.iv16 >> 8),
>                       (u8) (((key->u.tkip.iv16 >> 8) | 0x20) &
>                             0x7f),
>                       (u8) key->u.tkip.iv16);
>=20
> to insert the IV into the skb, if the driver could get a calback function=
 that calls the above
> function and writes the result into a char* buffer you get the same effec=
t except that the
> driver can put the iv wherever it wants.
> That way rt2x00 doesn't have to set the IEEE80211_KEY_FLAG_GENERATE_IV fl=
ag, and
> can request the IV manually from mac80211.

No, you can't do that because the IV is already incremented at that
point, so you wouldn't be able to perfectly match things up because
ops->tx() need not be serialised with this due to deferring to the
master interface.

johannes

--=-vd5q6+GUf2HRjLOouA3e
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/ory6Vg1VMiehFYAQKYLw//aXOHXar/Bd5yc5gdGR2an7sMphiAp7Ef
QHMmZ/tPFyNdD50Nnad5MQy8FYroL6gHvoI5xtBgH6o+C4kP3Iz5lGrAkHi6hlTb
AvkPh+1XRHaKcmlzKktAB/5q7FKsJA0PEbLzMmsOVDBm+nirscYd03atLnvzewuG
SfYDsELaKKgksCmAkEeC/fcQhtHxjgsr49AI3+rd5zao+FQu0aJY9FHqcGA41Fbf
y52rcBK4OWBML1r0v1eWqQD8joo5OtOdCsZ6vezbR2BBBH+RMcl1alkYpbTzEUUS
I1MFVjlljM+sEattIbydc6MJe+MR2bM2t9HpEot3zXVaXnmG5IqH9LPq5XvclEgL
AxCe1c3bd1sLnZhU42f4LoYX8/ZsnVpruyE4LeXTrhEs9z4CCYDfS3Mw8UqeyJcq
YO+B3LfrilPtKl1OKVFxXIB2pLQGYE9ystDiDilixS30Mz+X6RlNQoCl6yszmWG6
NT4x5PUST6W9tjgD4S0B21ftq7okVXjs1kekh9D6XJGcd52OmJ7LWmBsgqQJLWQ0
VeTGZ33P1qsMfLBuAj0t3kK7d0kSXW56Gcx1KLQ189d/FAzh0kirOCqTx/rB+4pT
IYmZeSKKWP9ouOmdvi58vSuFyZaWEUwRN8bNOicbeuEtE3jC5h97QwB1qz+V/Aoc
dgSi575aNR8=
=1pCy
-----END PGP SIGNATURE-----

--=-vd5q6+GUf2HRjLOouA3e--

