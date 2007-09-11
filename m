Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56646 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbXIKKzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Sep 2007 06:55:49 -0400
Subject: Re: zd-mac80211: Fix TX status reports.
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200709111252.30291.mb@bu3sch.de>
References: <200709082341.31720.mb@bu3sch.de>
	 <200709111220.31700.mb@bu3sch.de> <1189506596.6161.14.camel@johannes.berg>
	 <200709111252.30291.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-y2bDOE1uNlFMnjgBDi3E"
Date: Tue, 11 Sep 2007 12:57:10 +0200
Message-Id: <1189508230.6161.18.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-y2bDOE1uNlFMnjgBDi3E
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-11 at 12:52 +0200, Michael Buesch wrote:
> On Tuesday 11 September 2007 12:29:56 Johannes Berg wrote:
> > On Tue, 2007-09-11 at 12:20 +0200, Michael Buesch wrote:
> >=20
> > > What about the following:
> > > We have a "the packet failed" IRQ. so we know that if that didn't
> > > raise for a packet, it must have succeed.
> > > So currently we already maintain a queue of TX packets. What about
> > > changing the handling of this queue? Instead of dropping (and
> > > telling mac80211 success) on an ACK RX, simply do a timeout.
> > > We can calculate the time (plus some additional msecs to be sure)
> > > by when an ACK must have arrived, no?=20
> >=20
> > That's tricky though, because multiple retry rates mean that it can
> > possibly take quite a while for the packet to go through. And ath5k
> > wants to support up to 7 different rates for each packet.
>=20
> I'm only talking about zd, though.

Yeah, but that means the driver should implement it because it has much
less problems getting the heuristics right.

johannes

--=-y2bDOE1uNlFMnjgBDi3E
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5nSG/ETPhpq3jKURAi24AKCVnGe+EKXPyWOJpwybNnTX0O99ZACfQWnh
Vqv+u8OHoloWCguIGh+NpiM=
=GoQV
-----END PGP SIGNATURE-----

--=-y2bDOE1uNlFMnjgBDi3E--

