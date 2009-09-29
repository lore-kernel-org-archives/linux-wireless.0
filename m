Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:32990 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZI2OEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 10:04:39 -0400
Subject: Re: scan_request->nr_ssids never 0 ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200909291518.46655.hs4233@mail.mn-solutions.de>
References: <200909291518.46655.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QbnoGrceI4uwuCa26r4Q"
Date: Tue, 29 Sep 2009 16:04:06 +0200
Message-Id: <1254233047.30589.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QbnoGrceI4uwuCa26r4Q
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-29 at 15:18 +0200, Holger Schurig wrote:
> Even when I do an "iw xxx scan trigger", scan_request->nr_ssids=20
> is always 1 in my driver.
>=20
> Is this a bug or a feature?

# iw wlan0 scan trigger passive

> However, scan_request->ssids[0].ssid_len is 0.
>=20
> So to ask my firmware for an SSID scan, I need to do=20
>=20
>  if (req->n_ssids && req->ssid[0].ssid_len)
>=20
> instead of simply
>=20
>  if (req->n_ssids)

No. You need to ask it to probe for the wildcard SSID, which is 0 bytes
long.

johannes


--=-QbnoGrceI4uwuCa26r4Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKwhPSAAoJEODzc/N7+QmaaYUQALLJelf2K+KNZBqzphmf26Yl
8rLLtIFl8EngQIfFCZrhDFuUt8vQ1OxiUhuFsEe7nP+Kujf/fi1ksCSue6E6GUSv
09GXMppz6ZKr7t/wpo8IE6M217fR60qtb7fZ88h5YzT866oh4Q4D4zgGaJ7ZZZ38
OGLGgRZg4pfvsbJYGmGzgFVn0Fs+GEva1XkUiUq8A4jCezbz/C01p1/37CVlOHjR
I2HrXYjOvYynpkzSwxK7FNbsOlijntRQuSjwDwWFw2fCG9cNKAvHIg7LWoirAADp
MfVzeRo6sKg6mXmg/V+ZmTS3flcgExzBa9IcrMUJoQm6zG1VOo2eJ44iQFQGLDPI
YsIVg5+G0rkxxUB4aiSvA9bq6ToiYtxLeETRt7AFsGWuUosl/rLW5idCV0pDRf0e
J1HM5U+boI37L52CNTtsRxno1GiOrF1xy8Xg9NvrW4FfYSs97gIhXKOcHYcAka2q
TANG47IiLVHmRP+DzodDgifHPxCDOVVb/88Gedoh1mi6PPhfJA9rmuAoAZcIWNXl
RzqmfLAufkJh040CZYnJpYgznfAZdVdLsQYlcVeIewG2aHaCnTZde+Unf0iVbvVr
E6S5PrvKuMbJpWoE/I2nPDLs+WIk+9ojCnnMVpdJMfGHvIm8Turh0NT2u1gwlqHP
MOVgXw8hzBfhUUNC/YQR
=GCZA
-----END PGP SIGNATURE-----

--=-QbnoGrceI4uwuCa26r4Q--

