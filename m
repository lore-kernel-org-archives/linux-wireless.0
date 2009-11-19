Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755839AbZKSO2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 09:28:11 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1NB7zc-00028h-VX
	for linux-wireless@vger.kernel.org; Thu, 19 Nov 2009 15:28:17 +0100
Subject: Re: [RFC] mac80211: move TX status processing to process context
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1258571772.30511.54.camel@johannes.local>
References: <1258571772.30511.54.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4PoT/r3UHmpwwvg/gN5C"
Date: Thu, 19 Nov 2009 14:34:37 +0100
Message-ID: <1258637677.7094.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4PoT/r3UHmpwwvg/gN5C
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-18 at 20:16 +0100, Johannes Berg wrote:
> I see no real reason for status processing to be in
> tasklet context,

Actually, I do.

The current code relies on the fact that TX status and RX is processed
in order (RX first) due to the filtered frame/sleeping station problem.

Moving RX into process context would be nice too, but I'm sure that'll
meet even more resistance.

johannes

--=-4PoT/r3UHmpwwvg/gN5C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLBUlpAAoJEODzc/N7+QmamZsQALrRxtp3jOypfNLuTNV0rfio
9Z1A1xO/9utNILlrxb4zBTrWDDVhrFQHsSlZ5ZxBW9kUS66GasXKcxcPkGU+a5i5
Ge5FObOlnVCEJ5AHkKPp/Kptl9lhfC5jqzBhbZxVBVTJb1CgUVxtgk4tRePrpaKm
+htnP0w/nKzV/ayfmCJxL+Yqo/LxrmURMP2UPSTECbKyPCOlZZwHk1+ona1kz90U
fUgSJ56gGy02CVn9FVu7h1iw3kGw6FgWGTqzTLxQ0Sc762FNt2s5IfdPmXAspjmM
niZ8kTmioY7HhfoRLBFzPAXArxzH5Rr2DZjEJ0gzLCV79VLr7i5ietaGt6qGVN3X
BPFPEvjIXanx+Ov3N2Q84enZzwhWICHEVLOxaN90MK8ootgFHEHk11inTyknW4oA
8nmr5l1/He3pX2QCWoTMKQRgSU8rFpSV+kYDH+Rf2Z8eHHzLfilunzkojdkqRiK9
3cSHE+r0q008sbHO32gf7S5wQddKpmWEASJJ3uoHPCLP0SB81WJRRKwlLH7gmrQH
Xw+LoPMqOuAPvZMzJBobuxpobzPBgPbtDiFVMnEbZq+RFCeMx6mudo60AuWEg4U+
mv5mlP0dnrv4AHQlw1qdGaVZAtj8pqJEZlCmRoEORzv3xpzxAobtJSKI00AWWZQr
ManQad2YhR6lZ+Z1txxF
=zQay
-----END PGP SIGNATURE-----

--=-4PoT/r3UHmpwwvg/gN5C--

