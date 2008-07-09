Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42313 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217AbYGIOtD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 10:49:03 -0400
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh
	beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807091637.02090.IvDoorn@gmail.com> (sfid-20080709_162814_035311_2A5B7D8C)
References: <200807091511.14288.IvDoorn@gmail.com>
	 <200807091600.44437.mb@bu3sch.de> <1215612322.3246.12.camel@johannes.berg>
	 <200807091637.02090.IvDoorn@gmail.com>
	 (sfid-20080709_162814_035311_2A5B7D8C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iXU9RCYm4AmeJutV5F7F"
Date: Wed, 09 Jul 2008 16:48:15 +0200
Message-Id: <1215614895.3246.17.camel@johannes.berg> (sfid-20080709_164915_175838_8AC6FFFC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iXU9RCYm4AmeJutV5F7F
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> If rt2x00 would use a global lock to block all TX and beacons, then yes.
> But rt2x00 uses per-queue locking. When a beacon is being updated rt2x00
> will still allow regular frames to be queued.

That just widens the window. And if you have multiple queues then you
can't do sw sequence numbers anyway because the hardware might reorder
the frames.

> As far as rt2x00 is concerned, all hardware that supports multi-bss also
> support HW sequence counters. rt2400pci and rt2500pci are the only ones
> requiring SW sequence counters, and they can't do multi-bss.

Do they keep per-BSS counters?

johannes

--=-iXU9RCYm4AmeJutV5F7F
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdM+rAAoJEKVg1VMiehFY3C8QALlH4rBcsfr1VFQbgo7G4nEt
f3s+hZGXfsyWels7IdKJk57NETtLPKj1lIgadds9CXaNX2u3+4RJVjNK/y0HO+4E
I4xUaO4iSqqfsEu4NClSxhJtO7iFMlg5XPMMUYrJI9hOlggTDMZ5IIXYziWmT9sr
QobMYTyOcD24zqNRDm3Roz2GXRyH4VycLeKoMerNuLXNiesEJ6avkCdOdBnw4sdY
BmLQdePSa8UoXU+lPVmhrjQ8s5oJ9T2+Pz8U7CQ5hBvzTAvDPUT8dfwMBze6Pfg6
dDR1t6IbzKZLyYCxLLLRT3iTBD+DCXGjrVMwqKN2oAKNof0KbHJv34N74g1IyYbS
RtrkDnRybEwRohsSYjV4dxO7oZQgqVUWiwn2JlZr16XrC6oIyt5o0ICmYj6fy6MA
mx2MUkzpfkmI9ALreU1uz98JzihnfVMl8iwx4bo2oLgBgKV+vCZECqc2cu/nd6He
2U9Hc8ljpaiy5vhejHLljXMNk2sMVwmbWJc84mYK/R24LClcTruUFuaL84ArcaPX
RPCDFLm3QY/id4eq2b6apPo4Np+CFTj/WSYzmYk4fJwIDZ8vZoTq1yXbt+tIIK6T
kJno6dM+5YQ5XZTUc+xzfGkKxUvI4z1N4bTjfxQky8JpmKGZIPsyuUE+yoLPsfXt
2RSQGW5SKP64K8ka2uyj
=tH+q
-----END PGP SIGNATURE-----

--=-iXU9RCYm4AmeJutV5F7F--

