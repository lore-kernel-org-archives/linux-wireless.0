Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60957 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbXLQRrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 12:47:04 -0500
Subject: Re: [patch 0/9] Rate control rework
From: Johannes Berg <johannes@sipsolutions.net>
To: mattias.nissler@gmx.de
Cc: linville@tuxdriver.com, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071217001956.640555983@gmx.de> (sfid-20071217_003027_842318_90F1A18D)
References: <20071217001956.640555983@gmx.de>
	 (sfid-20071217_003027_842318_90F1A18D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Q5qGrHWc9KQfVD3InXpW"
Date: Mon, 17 Dec 2007 15:05:51 +0100
Message-Id: <1197900351.4885.41.camel@johannes.berg> (sfid-20071217_174709_456116_E01F551A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Q5qGrHWc9KQfVD3InXpW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> * It seems mac80211 fails to clean up the rate control algorithm. This
>   results in the debugfs entries created by patch 9 not being removed.

Probably a bug then, though I can't find it right now, the references
all look balanced and if they weren't then we'd not have been able to
rmmod rc80211_simple when it was still around. Not sure, can you try to
see what the problem is and maybe even fix it?

It does, however, look like the whole rate control code needs a revamp.
Looks like Jiri got busy there with krefs too without giving it too much
thought... It looks like all that can be converted to RCU just as well
as all the other stuff I already converted, I don't see a reason to keep
a reference count of the rate control algorithm for each sta.

If you fix the free problem I'll take a look at fixing the locking/refs
stuff there later.

johannes

--=-Q5qGrHWc9KQfVD3InXpW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2aCPqVg1VMiehFYAQJqChAArvIBSeTwZhKPPfv85j4dCw3HVKjt5HSU
fldfZJb3s3d4/dEKMleKkqG7iXH5S80GzsgjA1hCVe/FxjvJMunv13FL999UbEHE
2+D+t1gh5r52b5uxhOL7FP2oRJajlAjXzcOwBRarvlXvsIihDXPoVAVgrmWpPBzW
fPxVdhSXVTLo83Ug0Bq7IAVC7E4mcBXy/YvQ8wLnNrEoFSyl40gl84DG9FFs9JFF
8MzzqWY4R3OsTXfyccw8L32BHt0W+HWwLnRMT5iETN5OTVUR38D/wTPBZtXKuvb1
VcSU9InoEd3GdP9JSAGwlcEmXdkFZeEhM6QNNUzQM/3Bcc+gxSwE4WLqgkqyCaU5
3CXYOqbUdQlBybuc+pXHxVqioGNBrBQtoVqBCpavdRQ5gDsVErwZoveK15Ebg7at
podcd5BfIyIBkrOLP7wztniwh2W8pLD5a7TSZsO9eZvdapOV1DJ4SombtBsTqMiy
3nzj0aErXd4hucOQgHYVi6KzhRnbC5C8tfK+XtHlat3gvInG/RyouIxy17CeUw9o
zkh0WGN1R0cmeVtloQRf0aF+qY/Hqw196fXn4dmXMkn4gbhI+M/t4P9Ole1RS8aS
yVCkdTEzPOBM8/1HF3IFuSXyELebmuQ1kNu/awIVyG5AIaIIbXHkiEicsYNHGFeA
VMTWfS4aJkw=
=SlDH
-----END PGP SIGNATURE-----

--=-Q5qGrHWc9KQfVD3InXpW--

