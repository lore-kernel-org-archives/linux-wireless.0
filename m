Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34939 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbZCURNR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 13:13:17 -0400
Subject: Re: [RFT] mac80211: allow mode changes while interface is up
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1237654613.5100.312.camel@johannes.local> (sfid-20090321_175715_305704_31B33064)
References: <1237653563.5100.309.camel@johannes.local>
	 <200903211745.06974.mb@bu3sch.de>
	 <1237654613.5100.312.camel@johannes.local>
	 (sfid-20090321_175715_305704_31B33064)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WlIjWiHbzEuFZ7dfTMuf"
Date: Sat, 21 Mar 2009 18:13:13 +0100
Message-Id: <1237655593.5100.314.camel@johannes.local> (sfid-20090321_181326_550657_4629B5CF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WlIjWiHbzEuFZ7dfTMuf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-21 at 17:56 +0100, Johannes Berg wrote:

> > What about memory allocation failures?
> > I think we should check for an error and if one occurs take the interfa=
ce
> > completely down and return the error to userspace.
>=20
> Makes sense, need to audit the code though to verify that
> ieee80211_stop() doesn't puke if you call it twice in a row (since
> dev_close() will call it again)

In fact, it is _not_ safe to do that, the iff_allmultis/promiscs
counters for example will be wrong. Easily worked around though --
shortcut the function if you realise it was already called.

johannes

--=-WlIjWiHbzEuFZ7dfTMuf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxSAmAAoJEKVg1VMiehFYjMgP/3kc6vwxa7H5t8mC2OBQTDc2
WosXo268efBcmhu8tZe2mtCWPdEjLtLzT1XRhFY1ouR7askhM4YQlKT9WJKqLfqm
8bgk7OpfSG0dTIJgATYVV1nF1gpze0ebxIjZyjuMx2wOXg8YaUrS1Okk0AnKNO5m
F4U+wTLiLnnHQ9/hvvRO/RdYaQYOkvsuxuG9yHnx59Ou/AWRuF2znst3vBB9VhYo
qxJ3GVcXoLbDTymdWfaoy30CngMoRODThTieH6dg4NnZ36Y+bauOynMQr1pHD+zX
+FGA7A9G0p/obO3YdApOFBPUgkK+QAEN9Cb09dZY9IxZ+SZs+WkmlnEIaHwZ6T7R
pMlHQOb7Gm1wFvHZrqxXUg52nmaxnhjPEDnsXiCLiS7Z0s2NtrzA0C7ZEqt6SZOL
xpf09ikZy/qdj+v2CQ+AcSz0b2MCXTrtsY4VroECAK2LEmK28pohFNLIzOibvgJ6
R9SsON9ukJh2UCM+MMxUYfNj1UaJIgHKspVVjjHMFKj1ja/ZrFSRfZ0EYwbqvdPF
zriR9dm4kdzNWBtO7t1p3eWv+Ajasi1BKJYTsKWQi3uumKhiOqshBe0Mmtlk8M/U
JpkqQhb2I03C/duRnunu68XDxqIAyD4Mo605JCHM8ekY666tscOYS5h4+bHzLyJL
C7F+eiyuZ5tCxQGh77QC
=HAMB
-----END PGP SIGNATURE-----

--=-WlIjWiHbzEuFZ7dfTMuf--

