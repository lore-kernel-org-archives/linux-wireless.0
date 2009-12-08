Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966610AbZLHWAi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 17:00:38 -0500
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors
 in 	2.6.32
From: Johannes Berg <johannes@sipsolutions.net>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	linux-wireless@vger.kernel.org, Tim Blechmann <tim@klingt.org>,
	rjw@sisk.pl, IvDoorn@gmail.com, linville@tuxdriver.com
In-Reply-To: <4B1ECB84.6010009@gmail.com>
References: <20091204233202.GA13658@basil.fritz.box>
	 <4B1BB44E.90706@gmail.com>	 <200912080006.28892.s.L-H@gmx.de>
	 <20091208095755.GT18989@one.firstfloor.org>
	 <14add3d10912080219u17c65cbemf6d56290a8f12efd@mail.gmail.com>
	 <4B1EC842.7040407@gmail.com> <1260308669.32227.2.camel@johannes.local>
	 <4B1ECB84.6010009@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dcbUAt0cHYsHCcEKekEc"
Date: Tue, 08 Dec 2009 23:00:07 +0100
Message-ID: <1260309607.32227.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dcbUAt0cHYsHCcEKekEc
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-08 at 22:56 +0100, Gertjan van Wingerde wrote:

> Well, this is a test patch, to validate my theory that this is where the =
problem is.
> If that is confirmed, then I can start working out a proper solution.

Well but this patch won't help you test that theory, because it'll just
disable PS completely if there were packets pending when mac80211 asked
you to enable PS, afaict.

> How does mac80211 look at these things anyway. How does it expect the dri=
ver to handle
> the cases where mac80211 asks the driver to go to sleep because of power =
saving, and
> the driver can't because its queues haven't drained yet?

mac80211 does expect you to be able to transmit while asleep. Same
happens when PS-polling, where it actually expects you to wait for the
response frame too. I think. I haven't looked at this in a while.

johannes

--=-dcbUAt0cHYsHCcEKekEc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLHsxjAAoJEODzc/N7+QmaOO0P/RWfzg1JMXkmzgSqgu5wymWQ
a3bU8FgpK2Zr3oZz3sf3E82OVvW74/uQJ8HBI9oHGFpU8ici7Nmi70ix6RNvKDv1
lf8+9yYbRh9DMZ/1C6nDB4o/khJYhMK7etH+nklpz0LqcsWMY2Tk8XiplKsAEJyL
Lga7uzFE0XOInv8N6R8cn+i1Tr9Oh9Q+aIHSvYjcwpYvYMaMYe+9Jg82cCeLV1F4
JbsRgpli/ljjdoT1evqQMunD5p+RW5h7ta45pTtGcAqVDmS6zyek7xoHm4CeLXZy
mstryHsGF8llDJ+eObpsIiKOkA1KhtUZol9jp2QB/+ctgBe1RnjzdH10fs/VDrMw
i3YhMON5Y1iW7ZjPh92jxolFp2gdvauroeW2uwZI7PJRPECf90IcpLckzO3Lxdyh
HneWnmxAdh2rQMh4ql5jOyf/IqYrLfwwbkLtgwI8degx6/2M6n2UQnVjxjSDDQWl
W+BUi8qfytBk7r/J0yGfN/sTzzAXjirGFJUSBUOAJvyYm/nihxbUk8UTE9HyhOu6
rDVq54a8ScWZBpFo8oKO+F2wDLHRS/Lec5oNeL9DBTRpolJEJ07O5YmlAcKenaY4
v0irDfA/zIOT9+XcqEks4a7hqAQMoCldmmYjZiXCh+z3CQeSqBbBlY9R1toIR4W+
e5n0vFP/qUl97+64v1Wq
=aUJx
-----END PGP SIGNATURE-----

--=-dcbUAt0cHYsHCcEKekEc--

