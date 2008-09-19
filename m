Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42082 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYISJy7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 05:54:59 -0400
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
In-Reply-To: <1221817584.4491.29.camel@localhost> (sfid-20080919_114701_416600_478C4255)
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <1221505251.4511.77.camel@localhost>
	 <1221541089.14102.44.camel@virkkmi-linux>
	 <200809162018.42576.IvDoorn@gmail.com>  <1221770220.4563.3.camel@localhost>
	 <1221776990.4563.19.camel@localhost>
	 <1221815294.19539.15.camel@virkkmi-linux>
	 <1221817584.4491.29.camel@localhost> (sfid-20080919_114701_416600_478C4255)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UHtDpj5k3igC2bZ/vOuA"
Date: Fri, 19 Sep 2008 11:54:17 +0200
Message-Id: <1221818057.10419.58.camel@johannes.berg> (sfid-20080919_115503_772440_72E31D71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UHtDpj5k3igC2bZ/vOuA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-19 at 11:46 +0200, Mattias Nissler wrote:

> This brings up the question whether we can do without tx status
> reporting. Does anyone know why hostapd requires the tx status? As far
> as I understand, mac80211 only uses the tx status reporting only for the
> tx rate control. Rate control algos that don't use tx status are
> definitely feasible (and in fact we'll need one for rt73).

mac80211 also uses it for reporting the sent frame to userspace on
monitor interfaces.

> I'll look into hostapd to figure out whether the tx status reporting is
> really required when I find some time.

hostapd requires this because it needs to know whether a station
acknowledged a frame or not to proceed its state machine, it's just how
it has to work. If the hardware can't deal with that I guess you can't
implement AP mode properly.

johannes

--=-UHtDpj5k3igC2bZ/vOuA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI03bFAAoJEKVg1VMiehFYDTAP/0ONgScQrtpntNEs2doZv9+G
/IHWEQA9zGmIqvYv0/SbefmemQySLOzuxDwfsuyOgJVLDsUIjrrAg/teqRpu0en9
KTHUVJOVsXhByj1YOGzW1rQmFa9FYcDuB7osFAU+PxGMzmUi8fAGA066wlmqopWi
lT6QVYRfMhSppSbkJLlfNxXa7krYgUFkv4S6C1r9N5e4M+Q+HVfk3o1YdR0G7GkV
/D0lXqsf9AZB90b7sL4lcAPEWU6IAHTLSxq3ssIzeqQxVOCbyVlNP6TRRm4eKbdX
U5DHq8/00kQTKGl/w6TNwwuiwHI3JeAzO93qUg6fPMzHSSxKRrGWIPtqVsLhY0+O
xdc1fNfrLKBJGNthqy0zLYitrvrH/gM/l41I9Tq1M7QTom8nrcReK9ptK+odOVsx
w17uOE1HaT1Lnw1LW+1FqHWRu1NwnqX4gGvsU0IAaYqgbfqhM8wKb5Jv3g3KBEhu
vr9CV2rUScinvW/IIFQNOh5nIUyHzaI7z0k7xNj3w40ui8ZGY6YLXOQ8zVM3KJPx
yYmqs9R1c7VZGx8knzBv+hZOgF9Rx0VJKhx7b/4eZNQdvcon5PhXla+MoT7KeSnI
fFnP9vO9V6XqRqbtJGAc5O5zRdBPn10LFV2ODeIMVtLJEKD2RZL+VIMxQbnCfBFF
rcx1MToi1sJ7TlWiOE1E
=jPfW
-----END PGP SIGNATURE-----

--=-UHtDpj5k3igC2bZ/vOuA--

