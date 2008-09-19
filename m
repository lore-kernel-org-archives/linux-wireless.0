Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58213 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYISKbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 06:31:50 -0400
Subject: Re: ACK matching [was: TX status reporting with help of an ack
	queue]
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>, dsd@gentoo.org,
	kune@deine-taler.de
In-Reply-To: <1221819579.4491.34.camel@localhost> (sfid-20080919_122011_765612_F53F8EFC)
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <1221505251.4511.77.camel@localhost>
	 <1221541089.14102.44.camel@virkkmi-linux>
	 <200809162018.42576.IvDoorn@gmail.com>  <1221770220.4563.3.camel@localhost>
	 <1221776990.4563.19.camel@localhost>
	 <1221815294.19539.15.camel@virkkmi-linux>
	 <1221817584.4491.29.camel@localhost>
	 (sfid-20080919_114701_416600_478C4255)  <1221818057.10419.58.camel@johannes.berg>
	 <1221819579.4491.34.camel@localhost> (sfid-20080919_122011_765612_F53F8EFC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qJuC1QYbim19cU9PEq/p"
Date: Fri, 19 Sep 2008 12:31:05 +0200
Message-Id: <1221820265.10419.78.camel@johannes.berg> (sfid-20080919_123154_683503_DFDB462A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qJuC1QYbim19cU9PEq/p
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-19 at 12:19 +0200, Mattias Nissler wrote:

> Well, maybe we can work around this requirement? I still need to learn
> about the details, but what happens for example if the STA sends the ACK
> and then resets due to a crash? I guess the AP is able to cope with
> that, no? So maybe we can relax the rules a bit (unless we become really
> incompliant with the standard of course).

I don't really see how to. We can't just assume the station got the
frame properly and advance our state machine. The case you're citing is
quite different, we'll advance the state machine but it won't work
because the STA crashed; if we advance but the station simply hasn't
gotten the frame we'll get out of sync and stuff will fail for no real
reason.

But you can do workarounds all you want in hostapd, I don't care.
However, I do think that if the hardware just isn't up to the job you
should probably buy new hardware, after all, it's dirt cheap. :)

johannes

--=-qJuC1QYbim19cU9PEq/p
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI039mAAoJEKVg1VMiehFYR7IQALd3goiXVIdVzGpUfdiCIOCo
mKdbcI9QJ+iT4Pr+m6JCLcaYuL8AlmA1oE3Tm6hNkMa4fuLyriUD/RHC0LMbe3s8
7VTbQMuRKB350OPZK3saxR00f738WLlhD2XRHWJKgsFsIH7JBS6ZPjarLjqBmwuy
HVC9SDIxY2ic1vKmkEvnhORgenRlhvVP/TNWhqqLrpa3wAAH9QpbKjF23/F63jNf
OTCJGsOWt7OhyXgEaYPo4z9ZHwP29Ocm1s0yTg/B5ULbLhAsSU4b8cTZPQ0oQisO
DRdECC8ABscTaYr8Bjxxd6VvVzc6muwmV8l0aEOZN9TzAKo4L/HL1p0H9GLXCjih
0dqPrxc/z212g5AGRj1mMCjsilJ02vp14zW7QtK9osNGXGysW3rQCqFh4YkLiJCL
SGW55As333YTbVTbqRSVoij8BlTFAw3+ZMSGAtHNGTFUPWRFAMM2MUHd8ZY+3xVz
HCDdJtATGp4ckE9AXICF9sfI8zxx0kfJEVKI+pnmSn53mBSXh0KdRc5Su+lgT/jo
+TEnep3DhubPDnqnTb0z0sLs5tAmJmKImAfVzwluE9TZhZ4bMtGpxMpybBGk+bpS
UKqOYzGNTI0Q2dNYbK0FSvJ+ipxHNSeJSgmcb9kFKfcra5Xg8U0+Th8+/zVMz+Ko
j8HMoH6fRcuWt+lTZO8N
=rP/u
-----END PGP SIGNATURE-----

--=-qJuC1QYbim19cU9PEq/p--

