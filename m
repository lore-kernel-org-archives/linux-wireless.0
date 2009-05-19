Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35237 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbZESJGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 05:06:46 -0400
Subject: Re: Scan while TX/RX'ing a lot of data
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com, David Miller <davem@davemloft.net>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <200905181543.15266.helmut.schaa@gmail.com>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	 <43e72e890905152312m2077cc1dqd743cf7f625e9a49@mail.gmail.com>
	 <1242478657.10005.72.camel@johannes.local>
	 <200905181543.15266.helmut.schaa@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-A+CHy9fhHgp2xZ+v5cO4"
Date: Tue, 19 May 2009 11:06:40 +0200
Message-Id: <1242724000.17164.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-A+CHy9fhHgp2xZ+v5cO4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-18 at 15:43 +0200, Helmut Schaa wrote:

> That's what I've tried with the patch at [1]. I used a fixed time schedul=
e
> for switching back to the operating channel after each scanned channel.
> However, that could of course be done somewhat dynamic based on the curre=
nt
> traffic characteristics.

Not sure there's a need -- we have plenty of time.

> The basic problem I had was that I couldn't check if the nullfunc frame
> indicating the new "powersave" state to the AP was already sent out (or
> ACKed by the AP). This resulted in lost frames sometimes: if the device's
> tx queue contained a lot of data frames the nullfunc frame was sent out
> _after_ the channel switch occured.

Indeed.

> If anybody has a good idea on how to fix this issue I'm glad to provide a=
n
> updated version of the bg-scan patch.

Hmmm.

> One solution would be to force all drivers to report the tx status. Anoth=
er
> one would be to just wait until the device's queue is empty. At that poin=
t
> we know that all pending data frames were sent out and additionally the
> nullfunc frame was also sent out, so we can safely switch to the next
> to-be-scanned channel.

Some drivers now flush queues at channel switch time, but there's no way
to guarantee that the software queues are actually empty and the
nullfunc frame isn't queued up behind other traffic. Also, waiting for
any driver to report a status will lead to problems because the driver
might just have dropped the frame for various reasons like being out of
memory.

johannes


--=-A+CHy9fhHgp2xZ+v5cO4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKEnacAAoJEODzc/N7+QmaCV8P+weO2VMoz025DVacJyQ+7TAo
nuPGgVjxp/Qs9RhxlS3ESJssQCAximyqKkttBF87do63XdIRjSKRG52nJPVSwNmf
aAaqYNgDhzYVR3lBhMxP3GdQjEbxBltE2LmywzDB2Eh6LQqxeBUf3X1VuRwFeXI/
/Efj/TsaoUYDWPat5FqJVTGKEai4FJk9Nz7Kn7/U08sEjdFHTT+31GxZyByDuPkc
Qu52Ar693MmkqVCD8q9ti1p/YaYFb3lMqZsgpG89pPm2PavXE+5khXAy5DidQ9Fw
GRZoG9exT7YeriXJ7SBIqY5DAYoGSXr4eZLfYcoO2DzeshGHQ2n5SjRKpSuX8pM7
G54E3UaZ/o/TDN5pk/dk5fKDo/81Y41/aBothy0ZutKP03sVI74GFwg5lanJvAH8
xJtyW6sEuvZn9TrOD9lYpWDG+fUP145PaPMz/i+7VtJl0x9xbuHs54PVhhUKDwFq
VinoyL1xs9PYwQI+6vYgA+tFRd87mqWi1ooDfHEczfKJZwIDF/anWA6e0mY1rRaG
+w4XsRvxIfWaVahrBbtGQqdsHc2LPDNVZFCADueX03iZGLpZH8TzfJx8B/WNTOQo
VgjcizK1ni5fupJZFWnNM7rUwv0Cz6tWhrrfrvBB+M8/PYmcZARBSsksDKz3FHHr
Ree9tFYb+KjKw2vM+Cd8
=2qnf
-----END PGP SIGNATURE-----

--=-A+CHy9fhHgp2xZ+v5cO4--

