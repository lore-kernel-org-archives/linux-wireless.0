Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbXKMNJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 08:09:43 -0500
Subject: Re: [RFC] b43: multiple MAC addresses support
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <Kalle.Valo@nokia.com>
Cc: Jouni Malinen <j@w1.fi>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <87pryfd8cc.fsf@nokia.com>
References: <1194572631.4793.64.camel@johannes.berg>
	 <1194605550.4793.93.camel@johannes.berg> <20071111025808.GK4031@jm.kir.nu>
	 <87pryfd8cc.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sYPlQZREJmfQdN1s06Qc"
Date: Tue, 13 Nov 2007 12:26:57 +0100
Message-Id: <1194953217.9116.38.camel@johannes.berg> (sfid-20071113_130951_170678_EA73A8AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sYPlQZREJmfQdN1s06Qc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-11-12 at 13:14 +0200, Kalle Valo wrote:

> Exactly, it is important for small mobile devices that beacons are
> sent at the correct time. For example, I have seen broken APs which
> Target Beacon Transmission Time fluctuates and Nokia N800 has high
> power consumption because of that.

The N800 and similar devices only wake up at DTIM beacons, right? So
another idea would be to burst beacons but make sure the DTIM beacon
time doesn't fluctuate away from the DTIM TBTT. This would be possible
by changing the order of the beacons and adjusting the DTIM count so
that the beacon with DTIM count zero is always the first.

Noting beacon(BSS,DTIM count) you'd send:

 - at TBTT 123: beacon(A,1), beacon(B,2), beacon(C,3)
 - at TBTT 124: beacon(A,0), beacon(B,1), beacon(C,2)
 - at TBTT 125: beacon(B,0), beacon(C,1), beacon(A,3)
 - at TBTT 126: beacon(C,0), beacon(A,2), beacon(B,3)

etc.

The actual restrictions this imposes are very complicated to describe,
easier to describe and implement are the restrictions

 (a) identical beacon periods
 (b) identical DTIM periods
 (c) DTIM period > number of BSSes

that result in a subset of the possible values being allowed. Slight
relaxations could be allowed, identical DTIM periods are not really
required when it is possible to schedule them in a non-conflicting way,
i.e. (I think) when the sum over all 1/(DTIM period) is less or equal to
one (all fit) and the gcd of all is not one (possible to schedule in a
non-conflicting way).

[An example: You could have four BSSes A-D, with DTIM periods 2, 4, 8
and 16 respectively. The DTIM beacon scheduling would be
 A, B, A, C, A, B, A, D, A, B, A, C, A, B, A, - (repeat)
with all the other beacons at each period sent after the DTIM beacon.

In the empty slot ("-") you could insert another BSS with DTIM period 16
or a multiple of 16.]

[The actual restrictions don't even require using identical beacon
periods as long as there's a not too small value that divides all beacon
periods. This is very hard to describe formally.]

johannes

--=-sYPlQZREJmfQdN1s06Qc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzmKAKVg1VMiehFYAQKowBAAnPUo0OtNE2eiCfAPhen2EQWyuTlbn6Ma
kfkPBy8Na8v2bD6MuvbrLhMEoGhJM2iqf8YfDYzZAXfGvNla81kgzPTaBlKNXadf
lT2yn6W93yET7IddJIi+LW4TCNeRyHJxyqs+QGzLlwWT87bM0VIvfrNahOdQJhXE
g+V3ukUpmES5zDTziCbV0i40/2Nb0/ZxEAoGNi26TXDvTSXNiuA+ooaUGXvNW/mC
4h52Et5uJc+/8f1UmYRkjI2An0dp6Fm9pz82QKxmDXi71M/4VqFfKnYBiWbw3wat
3oR1kQ4fhrZZ9TYRsNcCmjk50LZb7VKWsuLJSZCBVdX2KhegS8cNF+ZH+MWYFqzj
EE+As8WrPz2SVrZBaVxmyJAWGKDUkrpyuNRfIJSGV2EYs070GtJgdXdLEgqSIbsT
jdvt+UD15UCAFOpMYqsOjD8x3iA6jkfoLUnOgr2kykP90p9mHQPHmQmGNh7GHsU/
ngqCJQja5APxA8PK93mH3a8a3QFefC33pxjtPzB7JV9TZniT8FG1oiKOiFN3gIgL
tc0yYL6A96pfsBd5c4WxDCgtv4Ju073cXpyMlbHLuImv0n16A/zrydQtoc2QeQ4K
4YWQKhxsoQdN1mY8vdANC9WdJ5mOUE9u+7u8OztH+mndHzj/Fl47o1v2nkf71/Ge
iHmHyiDH99Q=
=jRUw
-----END PGP SIGNATURE-----

--=-sYPlQZREJmfQdN1s06Qc--

