Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46111 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbXC1KUb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Mar 2007 06:20:31 -0400
Subject: PLCP header information (was: Re: [PATCH] zd1211rw-mac80211: Fix  for monitor mode bug)
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andy Green <andy@warmcat.com>, Jiri Benc <jbenc@suse.cz>,
	Daniel Drake <dsd@gentoo.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, kune@deine-taler.de,
	radiotap@mail.ojctech.com
In-Reply-To: <200703281155.52208.mb@bu3sch.de>
References: <20070325231817.9C5887B409F@zog.reactivated.net>
	 <200703262239.07013.mb@bu3sch.de> <1175073595.5151.28.camel@johannes.berg>
	 <200703281155.52208.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oX1+TeLDf4ofHViDVkXa"
Date: Wed, 28 Mar 2007 12:18:42 +0200
Message-Id: <1175077122.5151.43.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oX1+TeLDf4ofHViDVkXa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-03-28 at 11:55 +0200, Michael Buesch wrote:

> I think we need at least two "stages" for this config.
> One that says: Get all packets with bad FCS
> And one that says: Get all packets with bad FCS and everything else
> that looks like a signal, which is probably your microwave oven, though.

I agree.

> So, when these packets are passed up the stack the PLCP is stripped.
> I think we should make the stack aware of the PLCP (and add an RX flag
> PLCP_available) so that it is able to check the PLCP checksum.
> Otherwise the only way to detect your microwave oven from the packet
> stream would be failed FCS. Which would also most likely failed then, but
> I think it's probably useful for the user to see the PLCP, too, on
> a mon interface.
>=20
> So we need RX flags "PLCP_available" and "Not_checksummed".

Also "PLCP checksummed" or such. And we need to think about how we
represent the PLCP in radiotap.

The PLCP header has different lengths depending on the type of PHY used,
for Clause 17 (A) it is 40 bits, for the others (I think) it is 48 bits.
For N I think the whole notion was changed a bit with the stuff being
defined in terms of microseconds and not bits.

It'd be useful to make this part of radiotap but it'd need a length byte
too. I propose always padding it to a multiple of 8 bytes with a length
byte as the first byte.

For mac80211, we'd add a new item s16 plcp offset that tells us where in
the radiotap header that the driver generated the plcp header can be
found so that in the RX path we don't need to parse the radiotap header
to find the PLCP if necessary.

johannes

--=-oX1+TeLDf4ofHViDVkXa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGCkEC/ETPhpq3jKURArGoAKCnmjXZCvmgDh8Kqt1TCqSg3BFV+wCgtTl/
+spbR8U09UWATK1VjxvWMRI=
=Lh8g
-----END PGP SIGNATURE-----

--=-oX1+TeLDf4ofHViDVkXa--

