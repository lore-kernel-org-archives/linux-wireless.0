Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbYKUJgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 04:36:11 -0500
Subject: Re: Fwd: p54: testing AP mode: cannot switch to master mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Steuerwald <salsasepp@googlemail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <f76a32050811210037x5958de39g53b174b2d0dfd41b@mail.gmail.com> (sfid-20081121_093709_047280_C86566C8)
References: <f76a32050811190306s6a86f46dwc245200069ff8a82@mail.gmail.com>
	 <200811201537.19047.hs4233@mail.mn-solutions.de>
	 <f76a32050811201121r27ba1d82ma788e5a55bfd422b@mail.gmail.com>
	 <200811210838.25977.hs4233@mail.mn-solutions.de>
	 <f76a32050811210037x5958de39g53b174b2d0dfd41b@mail.gmail.com>
	 (sfid-20081121_093709_047280_C86566C8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HbM2udg4CvvC8xUEhdIR"
Date: Fri, 21 Nov 2008 10:36:05 +0100
Message-Id: <1227260165.3766.60.camel@johannes.berg> (sfid-20081121_103616_302159_533E0669)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HbM2udg4CvvC8xUEhdIR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-21 at 09:37 +0100, Stefan Steuerwald wrote:

> indeed I overlooked the AID bit in the relevant traffic sequences.
> Knowing now what to look for, I can follow what is going on and find
> it ok - except for the huge delay in between http request and reply.
> Typically, the http request is sent, the iPod goes to sleep, and
> several seconds pass (with numerous beacons without any AID bit set),
> before we see one or two "traffic for you" beacons, then the iPod
> wakes up and gets the reply. Most of the time my app already
> timeouted.
>=20
> I have checked that my app indeed completes its TCP reply in almost no
> time. Mysteriously, the data takes several seconds from boost::asio
> write completion until it appears on the air. That's the problem.
>=20
> I will go back to square one and the fact that I see different
> behaviour in the iPod and my other clients. I will work out the
> differences. Will be back in case I come up with more wireless
> questions.

Well, there could a buffering error in mac80211/p54 too. You could
enable verbose power save mode debugging (mac80211 debug kconfig,
normally not recommended to turn on); that will then print to the kernel
log whenever data for the station is being buffered and the AID bit will
be set. Since multiple seconds pass, you should be able to correlate
whether or not the AID bit is sent in the beacon right away after
mac80211 requests that, or not.

johannes

--=-HbM2udg4CvvC8xUEhdIR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJoEAAAoJEKVg1VMiehFYGSsQAI6G9D88hoGu+n5n8Z3GLl2E
C8GrWSpJFbLpI7BAq2MpOr0XIZxjQFcoplG+3Y6mxYfJ01StUmJIzKoJsJgVIgxO
iyh9a9WNJHUtTGQ+a+RL6ET9r17WP4r8BTdw8IbfL3JjxZzJkZTemqTHiesZ54pv
d3GqXDcfmuqfUFRvyEDDldSHB1zon/iHMjy2duDWaRuZ1YpMQ3HYk4bBIifow4GK
dWLspJ3KnX2R0uVUCyxs9t0BFU5gWxbXLxSTn7KJzxozkqCIfXhBcoYiV9UVtzsc
S10wbDa2wKlyCOHUXzlTcREAaUbZHoIunZOtX/DNQZdtI0udD6GndEzUzljX9Cjk
TJHy3//WJJBcPPDbCZIQMX2R7fMuijZvkWZIBoYVt/AJYRJ/y/6KCQga3ZJDbeZN
K5TrFBdHynPcHLWEN5/cr/sEtY2ztr8PinjE9xTMBHhBqry7cNfgrXzRglcWczW9
UDoFFIxX8xDcmZJ+H/USct04Pbujha6HyNnlwMQ5hFNyYSmlYvECdswtI7PNlUvi
u82ekEgpiint70EEQBYQkeLB6+OlxcBukMwdZXSDi/8h2JSKeQ72U1kuKsaoSYCG
IcISn2NCmq1tioCNqhNKkoQH/XERhrfkL6cBW6fEu35EzuT1HyGFHm6aL8lFegT6
/j0+bYQ0+FEjBZFK0vjD
=o0yK
-----END PGP SIGNATURE-----

--=-HbM2udg4CvvC8xUEhdIR--

