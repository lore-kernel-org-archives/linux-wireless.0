Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60517 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbZJAVOp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 17:14:45 -0400
Subject: Re: BUG: "wext: refactor" broke compilation
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200910011139.30914.hs4233@mail.mn-solutions.de>
References: <200910011139.30914.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-faB/l9N7T7OM3lq4GqmK"
Date: Thu, 01 Oct 2009 23:14:47 +0200
Message-Id: <1254431687.3959.43.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-faB/l9N7T7OM3lq4GqmK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-01 at 11:39 +0200, Holger Schurig wrote:
> LD      net/wireless/built-in.o
>   CC [M]  net/wireless/core.o
> net/wireless/core.c: In function 'cfg80211_netdev_notifier_call':
> net/wireless/core.c:673: error: 'struct wireless_dev' has no member named=
 'wext'
> net/wireless/core.c:674: error: 'struct wireless_dev' has no member named=
 'wext'
> net/wireless/core.c:675: error: 'struct wireless_dev' has no member named=
 'wext'
> net/wireless/core.c:676: error: 'struct wireless_dev' has no member named=
 'wext'
> net/wireless/core.c:677: error: 'struct wireless_dev' has no member named=
 'wext'
> net/wireless/core.c:680: error: 'struct wireless_dev' has no member named=
 'wext'
> net/wireless/core.c:681: error: 'struct wireless_dev' has no member named=
 'wext'
> net/wireless/core.c:683: error: 'struct wireless_dev' has no member named=
 'wext'
>=20
> The reason is that currently two different Kconfig
> defines are used:
>=20
>=20
> in net/wireless/core.c:
>=20
> #ifdef CONFIG_WIRELESS_EXT
>                 wdev->wext.default_key =3D -1;
>   ...
> #endif

Did you send a patch to change that to CONFIG_CFG80211_WEXT, or do I
need to?

johannes

--=-faB/l9N7T7OM3lq4GqmK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKxRvDAAoJEODzc/N7+QmaJ6AP/i6vFzmK9jW6u7kDQKdy5GUr
x8/coQzaHRUqoWQ+AHEhpWNh5jXNkldIk73IMP0gRB4YE6Ozgh7i5trzeZUMfF0Q
W9D5pSK0biX3ki4odpBl7qcCMKFglRFngJVqf4qjlZYlJvaQvKdfNjjzzpWS0FkN
QEP1iVi1MnIAaEOwFLuaF6jc6O/jYVO+0x8HlmRADZkgC5qN4/WrVKS2d5IId8ua
GAH+BBdSZYDnYbzpoMdDCmPscDidrsmqfJTBIsk6W85LYjc5t6WQ3eHgnoZ/02pe
3NaE7JorC7uqmap0N5sofz92akTs0CTPSWwoSWWnodsv/rAyiiadvseBJ+bs/4uu
k1puD+ivZl00JOTzCPWFTl19b/INBq+S6WzugY6/gcxw8CXFrRx6Fk9Z6+nRKUVn
bN8MUcxK9AOfEkfeydY//H9MC8JYcuHZfDdpsoneQCTNUDTLdlA/DWX2MuxIIBd6
yNUXCC0QJji0ORA7MQeVb4xs+3qz0lvmXkB3V2OuOYtILBY9INfwbinvq7CXW6O2
rfPoGuc/fOFHGb3OSauz/fhb+R9BP+1J7Mg6F6yWsPL0ixWlf9yB1bIhX5UaMBMD
v7JCVfpWlnr9FlflFW8HgwVVEebpTM1qH3dx2tIEw9X+4SpHHTTCdAi/D1XTnswd
u8RW3gyPIY9vXYnGJln2
=dSZJ
-----END PGP SIGNATURE-----

--=-faB/l9N7T7OM3lq4GqmK--

