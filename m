Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50470 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbZJ0UZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 16:25:04 -0400
Subject: Re: [PATCH 2.6.32] mac80211: split hardware scan by band
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
In-Reply-To: <1256673595.4237.24.camel@johannes.local>
References: <1256673595.4237.24.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-08SEybUe1v0eiqRb+sRX"
Date: Tue, 27 Oct 2009 21:24:37 +0100
Message-ID: <1256675077.4237.26.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-08SEybUe1v0eiqRb+sRX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-27 at 20:59 +0100, Johannes Berg wrote:

> Fix this by splitting up cfg80211 scan requests by
> band -- recalculating the IEs every time -- and
> requesting only per-band scans from the driver.

Incidentally, this means that dual-band drivers now absolutely need to
take a look at the scan channel list that is provided since if they
ignore it they will end up doing two full scans instead of one. Since
wl1271 is the only driver this affects right now, and its 5ghz support
is disabled, this seems ok to me.

johannes

--=-08SEybUe1v0eiqRb+sRX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK51cBAAoJEODzc/N7+QmaJZsP/2qFfbMYFk85e0/q2ELSnm4T
CsgfZwuBzv6xKUaqGbXKGwaMH3sPnjFwS8m7Fhg60JXjG2cow5W9D4Uwtd4wO/dB
+v8Br59/kHlSIvU8u2FTpZfjAWVK0w0utvCL9Dc+9D8c/aM+H+9IuroAKdv1ItY2
cD+1fglqfZjryF80vl9U20cTPZrV15gqYQoX8dYMWw16wK8HQzjnt+RRm+GZ/nGd
oIdxCx+E7PoJB8oeLbK7j4kX+kx971+ciRrasjDRcy6+bgrl+dj0/PuavP27oVxb
4RtraQiD1ArWt5rND7k2ANg6finQZdZk7jvAHZsGanhM6Pz3LHMVSZbI3oaPj+jl
l1QUs7yn7869eb/n+hxUQGvH1mCWVwoGjOfMSqMaInBjpfRXf3LqZEw4Dd0WEef/
ONsStPbMns0r0of3c8B8JguNdsTbOYpPcmMcQxPeul1bWrH4m0nIslNH8fet1w3K
i1fbJFL0zRV4xxP6bZc7JDo6Zi1Upg2PK7H0spWXOJbc903Z/P/G24dCjEHloMsl
Ys9SQr8ZA5wKbdLbWvZeCs3m2NtZfQwZwhYxE0pWg2vo8v23j2xUsoUHisYNWx86
ep1ckYC4GL6yCOGHU9tb0JLlPqqkshhFjW9i5apgT2y8fwtOP3RLA+eTeJl6QIFr
fnQIfBrgHuPzlXGXD2Vc
=BvtP
-----END PGP SIGNATURE-----

--=-08SEybUe1v0eiqRb+sRX--

