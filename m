Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbXKIMKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 07:10:54 -0500
Subject: Re: [RFC] b43: multiple MAC addresses support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
In-Reply-To: <1194572631.4793.64.camel@johannes.berg>
References: <1194572631.4793.64.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bDdwABlLxuA+x7ZTvmk5"
Date: Fri, 09 Nov 2007 11:33:26 +0100
Message-Id: <1194604406.4793.79.camel@johannes.berg> (sfid-20071109_121057_070235_10CDFE5F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bDdwABlLxuA+x7ZTvmk5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> This patch adds support for multiple virtual interfaces (up to 65536)
> to b43. This requires modified firmware which is detected by an invalid
> day in the firmware timestamp (254), and then the firmware time and the
> rest of the date is used for feature bits.

One thing I forgot to mention is that currently, mac80211 is not able to
associate different virtual stations with the same BSSID. I had a patch
to fix this but because I had so many patches I dropped that one. I'll
try to revive it next week if I get around, basically it consisted of
adding an sdata pointer to the station get routine. The bigger problem
was making the RX path happy about it :)

johannes

--=-bDdwABlLxuA+x7ZTvmk5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzQ3daVg1VMiehFYAQLWYQ/9G4Iv936OTe2JHw5tud6wx+q88FXbCGh1
lDSii4C1kGxt0cyylOqKuEe1fC3hZH/MFgHZkhGbiF31vRfJq1ZBcXnnZamCGhIL
pB8ng3MaAk9O2D/r03jyPL8/bvqLQm36SdVZiaBzzCKlZCqUtcHSnJe+Hor+jOI5
GCyLPCpbs97dcFVUvIeAxnAdqCJk2AXUz/qlcH8dMdYI+Aq15Kx6aY44e7rK8IX4
+VApDeQlkcE7F4yLk13vaz0xrNzBK4ZuVamCKeTsXgcOX3BQKk8/ExJSKb8/UkKp
P2FPD5rDuPE2/hWwoVr+tkMPNky5OcqibPWDdTCg+djsId59vx7Vugi52/Iqyprd
qghdoFbzwV1ochxwo9cVxmaO1vCz6fDElH4hQBkk5wQbRcWNN/IdoCcwFSZU0YMV
GXC9Qmat7MXLbrzoiV3ZJg3j6/DAddhMWC8fVRjUIEPa5Qgh359Jr9f9W01UeSuQ
5Q/VIApvYfLPeso/eZd1m2/8HRt1Y3dJ3tfxYMLNmYluBYUWLVj1I3+umHVO/xT0
FZJ7vHVf5aCeB1tD73YlNn3tq0ffEm232j7hlYGkpBEjnentqmnD2DqxV4FXxLqd
77TCp4+vnT6T/AjBgq9ZWa+qcOHnWRu7CoH9EibxwYh39HV0pYZ6yn8DOTEn8FD1
n9k7At5vpps=
=aEms
-----END PGP SIGNATURE-----

--=-bDdwABlLxuA+x7ZTvmk5--

