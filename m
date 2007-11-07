Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39147 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbXKGPIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2007 10:08:35 -0500
Subject: Re: RTL8187 rate control problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Claudio Matsuoka <claudio@mandriva.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200711061947.21927.flamingice@sourmilk.net> (sfid-20071107_005157_014757_0E6753FD)
References: <200711061323.16302.claudio@mandriva.com>
	 <20071106164148.GB4440@tuxdriver.com>
	 <200711062239.13052.claudio@mandriva.com>
	 <200711061947.21927.flamingice@sourmilk.net>
	 (sfid-20071107_005157_014757_0E6753FD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gx9mnqKGEvQQiwasIRUZ"
Date: Wed, 07 Nov 2007 15:20:43 +0100
Message-Id: <1194445243.4470.25.camel@johannes.berg> (sfid-20071107_150841_477747_FC1E2B2B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gx9mnqKGEvQQiwasIRUZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> There's no easy way to do tx ack reporting on the rtl8187.=20

This also means it doesn't show you outgoing frames on a monitor. We
really need to find a solution here that takes into account our current
use of tx status reports for outgoing frame monitor as well as rate
control.

At the higher network speeds of 802.11n equipment we'll not want to do
this anyway.

Since hostapd needs to know whether the packets it sent were acked,
we'll have to go back to using IEEE80211_TXCTL_REQ_TX_STATUS for those
injected frames.

Then we need to decide whether we want to report all outgoing frames on
monitor interfaces or only those where the hardware was able to provide
a status report. The latter would be sufficient for hostapd, of course.

Finally, we need to create a new hardware flag that determines whether
the driver will report status for all frames or not, this influences the
possible rate control algorithm choices. Of course we still need to
write rate control algorithms that are able to work with synthesized
information...

johannes

--=-gx9mnqKGEvQQiwasIRUZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzHJuqVg1VMiehFYAQIIyRAAntBA5ZrU6pRyfxu9ex4wB9Jf3WS37Kdx
P/LunnnzlzlbtAFZnonEp66MRttsrI3s4DXqhcebs0ZVVsFSlOVggBl0UsCygZLW
0Vz7mNPVzImLZCxEYcVb5flx0IBxD1HTp7Xj5Y5sOqjvoJIICGZggRVQl7EQtSCS
MzdUmJ/Sm0iJyPRRCLuGlx32uz06CsUUtoF5fyVYxiPvY5v20LSRuRQkOOM7ONjR
aGFS06H+JSJ7F5dPBcO/njMCgG7u1DhEJ/e0RFXa/K+YXEjGlzqSk7vlmbtBmCVu
fb/7dN4572R6kD0FHEDrqRl6SQVhc1vgbw6zIK7C/gMdnWST/8PlwoSVoFTBZTwM
OTXYBQROZhmMhq6BHkofNkETCQC+iQeHbiaJa5HUrGmDnWCs1Sl3KOi/sKHq0rVE
a6SisAX0Jlqhc+mtZOWN3o+zDeNd77I/qhx1tAk9wIjWe50ZIGzS1WoCskQfAn6r
zPmtvJOzK9jxnIqeJWjKAAPe3SHkub07yVzqSDYV+1V1cOLo8BlrI0ZrKBk8pscX
2jNcO0OesylLd0/nq2NuofLWqIiqR5HDlwKuoBuJKuyHTsV6577mmiozyQzhq0TA
Uai4ISKOwklNlNnDPwDH81KhE87T6uqR9R6o7POnwWGIVZ5T5sYTwThjdYEI0VQM
p6KN5bW4ORM=
=dLhM
-----END PGP SIGNATURE-----

--=-gx9mnqKGEvQQiwasIRUZ--

