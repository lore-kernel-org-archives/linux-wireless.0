Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbZGENiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2009 09:38:21 -0400
Subject: Re: [PATCH] rfkill: prep for rfkill API changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090705132422.GA30334@khazad-dum.debian.net>
References: <1246798266.4411.1.camel@johannes.local>
	 <20090705132422.GA30334@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JM7OzO4a5gU8u+sRnS8w"
Date: Sun, 05 Jul 2009 15:38:18 +0200
Message-Id: <1246801098.4411.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JM7OzO4a5gU8u+sRnS8w
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-07-05 at 10:24 -0300, Henrique de Moraes Holschuh wrote:

> This is good, but not complete.  Changes to the API that don't change the
> size (or those which reduces it) are a problem: they are impossible with =
a
> schema that detects API version by the size alone.

Umm, no, we can also add operations as required already.

> Maybe a new field with a API serial number should be added right _now_ wh=
ile
> it is still not too painful to do it?  This would be V2 of the API
> (detectable by the size change), but there aren't many users yet, so the
> effort to support it would not be daunting.
>=20
> You can also publish the API version through a read-only sysfs attribute =
or
> a separate IOCTL... it doesn't really need to be in-band (although in-ban=
d
> is a lot better).

No.

This patch doesn't change anything at all. It just reduces the
_subtlety_ involved in actually doing a size change, nothing more. A
real event version is _not_ necessary at all. In fact, I would argue
that basing _anything_ on the "version" rather than the "feature set" is
useless.

johannes

--=-JM7OzO4a5gU8u+sRnS8w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKUKzFAAoJEODzc/N7+QmaY9IP/i0T8H/fYLs0IsOJG2Drx6Sf
TSuPut53gPosMcm8A1SaRIla+Ccz1ydGsm8WWZqt13Lvty42tpC88rP2lumdHhiT
YdB8kSmWSa9MGbShoD64inE7+n7BQRPfReEcA+3VaiPkpqgZPA4HM2RmpAR0e/lt
I1uI+creEs7cltC3OQUd1imNhuILdhJaDguhU3XK+jqFPKOyc4vjZpdhn3rW+eC3
aAn39G+Ozc6ycAgLPUdXjn5JRhwsUMrvxvAcMODYYuPwrrGgvEswzZI4//knMQTu
jojYrirBWr1nrmRLGme60lqhQQuNHmMd4+2Tx6VeKGNH9YDR7/vOY0DxUcbLAbua
bx060YnqVzJM74XF58XjxMzmzmdVLuK74AL7vLNRiRnKuzjS4gFpfC1TmY4lNdKz
NriMkvASJKI4vCw5guB04BjscBR8LGKBDn7Dn6droKKcbRwtRVy4VQjNkb05Dw6T
Gs6ZYSKPhA4d9cIxfiob+FG3z+q1o3eq0Tc4ThySkOhdDWI07RGPUOY3bjImXdci
YSTOIgiZd4aSc5NzPinWlTUHoqfAIXjMnbviGVeLi5chG6X9Nyc1cZ/xjQf0/9zC
+GRVzUJtsBNU6kvN8pIo0gxuU/0ErwWx5YTQEsE5kzKtkeUIBEXy7awhIO1GrHHO
Es+ZU0zxCr/VjheiF+E1
=if52
-----END PGP SIGNATURE-----

--=-JM7OzO4a5gU8u+sRnS8w--

