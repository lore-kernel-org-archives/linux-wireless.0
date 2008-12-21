Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37353 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbYLUKgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 05:36:24 -0500
Subject: Re: [RFC] wireless: Add channel/frequency conversions
From: Johannes Berg <johannes@sipsolutions.net>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1229797871-21179-1-git-send-email-kilroyd@googlemail.com> (sfid-20081220_193122_880708_FEC683E0)
References: <1229797871-21179-1-git-send-email-kilroyd@googlemail.com>
	 (sfid-20081220_193122_880708_FEC683E0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0v56bdGdyc35jJcWorlo"
Date: Sun, 21 Dec 2008 11:36:22 +0100
Message-Id: <1229855782.4953.8.camel@johannes> (sfid-20081221_113628_718646_BFA3E586)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0v56bdGdyc35jJcWorlo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-12-20 at 18:31 +0000, David Kilroy wrote:
> While refactorring orinoco I found I was encapsulating the static
> channel frequency table. A quick poll of drivers showed that a number of
> the older driver have their own version of the table, and use it in the
> same way. So rather than keep this to orinoco I added the function to
> the ieee80211 header.
>=20
> To be complete I've added conversion routines for all the
> bands/modulations in IEEE 802.11-2007
>=20
> Does this seem reasonable? Should they go somewhere else?

Seems fine, though maybe lib80211 would be appropriate? I'd hate using
lib80211 in cfg80211 though since that pulls in all crypto bits that we
don't need there. OTOH, the code really isn't big, so I wouldn't worry
about inlining them.

johannes

--=-0v56bdGdyc35jJcWorlo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJThwjAAoJEKVg1VMiehFYVmwP/1rX1S75hxLwOEWu7aAB/9CF
pWgsPsXthza54pjvhW6gB7gQsqiDU8CiRrLkuJpbhLqyqvqdmI5w4vRbh/dvsW8o
20nlo0ENcpoL3V5u4EHrykdosPXum1JCbiRK0EzPHqh2oSPXe6wD4Lyi6aUAT7C0
SkS7ZsKV5yl+eQ8R2PVhqQhEYcMhJuPQluk/J4qP4XckY7Q945K/Q8L0grm1W9Em
WYUBnKgrwWg5phqWR2hB+0AeUCB6xfBpBOgtippo3qpYeJMNESazhcN8EA3/kORn
Jwk8T8jd+M6ND9xVCX3lw4neUCTDdeqM9KPFE9iEpHz19ZNjb0+FkaboJoYE7Aez
eKQbEDZIl0QQlS1P0W+9JKu8o4DEldkuFWU3Hb7ZK1j28LU6uzb2+hqPHE9BLglj
iw9QOJke7N/4sYzraieAt/KA+uAxbEuI4jZi9zthLGzN9FIUF8KuyuQiSDLgpran
gPOiuzJ3QzIFSHsjv12lUZtINyEz5zEJtnYZCRmAH2Hojh2KWDGJg08W46AnRwC+
KAly8UTCYKrvacTZiFJR96BoEBiRjOLHoN3JveB+B6pZkRNkr6fjyCwp64zjzMMI
o8qks3XoAOx5sIm/8NK6mPQwU13DrZK0QAdu74wIJhYSvm2ANl653PQ8OPgLNqHq
/Uu/EflnNo/46721AvA6
=wbEj
-----END PGP SIGNATURE-----

--=-0v56bdGdyc35jJcWorlo--

