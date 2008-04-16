Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41655 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbYDPSC0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 14:02:26 -0400
Subject: Re: 2.6.25-rc9 -- bcm4306 performance is in the toilet
From: Johannes Berg <johannes@sipsolutions.net>
To: Miles Lane <miles.lane@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <a44ae5cd0804161045h37aafedbk5ff69bbb3c5ff850@mail.gmail.com> (sfid-20080416_184616_878424_D672AB3A)
References: <48056406.2060502@gmail.com> <48060D71.6020507@lwfinger.net>
	 <a44ae5cd0804161012w7c07efb0w68f9a8664f077556@mail.gmail.com>
	 <1208367041.11676.55.camel@johannes.berg>
	 <a44ae5cd0804161045h37aafedbk5ff69bbb3c5ff850@mail.gmail.com>
	 (sfid-20080416_184616_878424_D672AB3A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ltTyat7eSiXYf8aWeWRQ"
Date: Wed, 16 Apr 2008 20:01:15 +0200
Message-Id: <1208368875.11676.58.camel@johannes.berg> (sfid-20080416_192700_200631_2D0768A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ltTyat7eSiXYf8aWeWRQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Am I required to get the linux-wireless git kernel tree in order to
> get the newer nl80211.h?

No, you can just get it from gitweb too :) But other than that,
probably. Or a compat tarball would work.

> I checked in the 2.6.25-rc9 tree and was surprised to find four copies
> of nl80211.h:
> 0 2008-04-14 23:48 ./include/config/nl80211.h
> 10074 2008-04-11 16:32 ./include/linux/nl80211.h
> 510 2008-04-11 16:32 ./net/wireless/nl80211.h
> 10074 2008-04-15 05:50 ./usr/include/linux/nl80211.h
>=20
> It seems interesting that two copies have the same byte count and that
> one of the files is empty.  What's up with that?

The empty one is created when you configure, because there's a kconfig
symbol for nl80211. I'm not sure why it is empty, it should have
"#define CONFIG_NL80211 1" or so in it. The ./usr one is a copy of
the ./include one, that's done by headers_install (IIRC), the
net/wireless/nl80211.h one is for some local stuff in that dir.

johannes

--=-ltTyat7eSiXYf8aWeWRQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAY+6aVg1VMiehFYAQIkLQ//bY4eY7M6lHXmU+dTGMwbLDZn78UqqggD
HUCq4/m+KNOavc7y4zvunrPW4l7IMJOo70fBQw2RtX8BBi4FMJxZjAvjch9l6reE
KSZL+zS9lAu8cPHDSXaaepPgYc11bReWNqCoEf6Vpyj2nPVHMRQYaOD46lZiLK89
RlVefJHKtO6pW79aCIyL+WpkbinlRMMd30irbUkQOLqi2iWedapVEq+KU3teJjCy
abn3qD5vP32SdgQi3mQNr1c/EKb1OMrvJIovrE1Dxlz0YylNbbUOJa9VUvxGeQnM
3pl7lEWj7uYb8tC++aSg05ghSZ/TSh1PFJ3kCFspzp76Z78fJvHKtq3+kURcrVxI
1oKn3Yy756rtJe0/xy7EmJoGRb5a6p1xrJ95klD8FVtYCiHvU00pwjeRBf+85E5v
F8PzQsjwyC5aISF+CYmHjk37IGYOKlAwdnQ6lCTxNmMZ/YIZeBZ9x9oNiJL3Snoj
xUwvFtWxiCSuG4W8PYy8GzBnFqXXX7tjQvkZ0IuzIUdH9oikNu3tS5pXtV6rWUYv
+6NbmwpdKOov6jTi8NEmiTtnth5rMXRGANfhcs9STJW7N56mq0LtLnrrsaK4LC53
lCr6+B9nPuQM7lqXaijBe0QaaCxpXzImihU3jZXzMj587IOTgtA1kYt8zE0FRg//
2ZeaxX4py5U=
=pwia
-----END PGP SIGNATURE-----

--=-ltTyat7eSiXYf8aWeWRQ--

