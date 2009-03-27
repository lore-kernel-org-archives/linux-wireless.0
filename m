Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42122 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbZC0ITS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 04:19:18 -0400
Subject: Re: [RFC] regulatory information interpretation rules
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1237712542.5100.766.camel@johannes.local> (sfid-20090322_100234_495492_0385D4F0)
References: <1237712542.5100.766.camel@johannes.local>
	 (sfid-20090322_100234_495492_0385D4F0)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ueurdSIRgx3mVjepq+cu"
Date: Fri, 27 Mar 2009 09:18:42 +0100
Message-Id: <1238141922.4331.100.camel@johannes.local> (sfid-20090327_091923_361026_29E179F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ueurdSIRgx3mVjepq+cu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-22 at 10:02 +0100, Johannes Berg wrote:
> Ok, so I'm thinking about the interpretation rules for the regulatory
> information. I even dreamt about this tonight, unfortunately...

The posting about the German rules made me look at them again and I
realised that there's no way (with either interpretation of the rules)
we can currently handle the German requirement of using only
0.25mW/25kHz, 10mW/MHz or 50mW/MHz.

Previously we had only thought about 20 MHz (or above) channels so that
wasn't a restriction (since you then reach the max EIRP permitted), but
with smaller bandwidths that does become a limit, a 5 MHz channel can
only have a max EIRP of 50mW, 50mW or 250mW respectively.

Should we incorporate that into regdb while we're changing things there
anyway? I'd add an optional field into the database like this:
	(5150 - 5250 @ 40), (N/A, 200mW, 0.25 mW / 25 kHz), ...
                                       ^^^^^^^^^^^^^^^^^^ optional

and extend netlink with it as well -- this requires a regdb version
change but not a netlink protocol change (except for the addition of the
new limit).

Does that make sense?

johannes

--=-ueurdSIRgx3mVjepq+cu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzIvfAAoJEKVg1VMiehFYsCkP/0gvJymORZC/0yrNfI3s+57N
RqkSkG2gAzjGF7WjvWerYm9+GHWatu+SxH7HWsOHmmwgU8n5m5NbrTF68cZF8923
fRVmvp58x3uaatdvNfbC00fjEIEuKOoPVf6ZobJkcVefm/GJrmzOQUaKBjLJA114
gEHlo9BJP1e9t0xYqHqBfemHvJrjRG66X30PX8goZJT1QmocBPSRfFP0jjP8ACoi
wMfYmLwgHQfKKE6Exx3Gp0tWLBCUcRmV1l1YTeBlHG+1zqerPCRxt9UREaWZgnOL
PIMVrj8xtXgb+yPFuIE28ISOjEC81GmiS5IQ5LGt5cYisEAb1pmOvKyXp+vi42Y5
76Qdl+iW4zapUPhtdCU0tn/b/fCJ4H5QIUqiJjnNbIEwD4wr2FNR1Qy3mxkKANyw
JAwgFDBOQTrQdE8qQNyDWVd+vP52CSHL2GlwkbHvEFfqhXdnD9m9Um0kIKMpLV6z
KR/AgBH1qpeHkKSIF9FSfXGE8rOGVvIvJrAmZZBPLff7DcN2MfUwmtt88jlNB2q6
L5PNGucD/yy9lfQDlEyAzGobgMXRsKFDJpOgspSad7FlWJUzw2kV35usKy48qJRF
ePDhlXvTNdWHIYU+A7qf9xbCwTJddKsX8TUA6CyGswHVsj7p6MjkPghhm3Ahn3yy
T8w8EN+UwPnipH258cjn
=cJsc
-----END PGP SIGNATURE-----

--=-ueurdSIRgx3mVjepq+cu--

