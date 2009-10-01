Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53312 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515AbZJAOXj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 10:23:39 -0400
Subject: Re: BUG: "wext: refactor" broke compilation
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200910011139.30914.hs4233@mail.mn-solutions.de>
References: <200910011139.30914.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-tY+Z3YQwZyzVWS+uv5SK"
Date: Thu, 01 Oct 2009 16:23:35 +0200
Message-Id: <1254407015.3959.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tY+Z3YQwZyzVWS+uv5SK
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

Oops, yes, that one needs to be fixed. I thought I just used sed but I
guess somehow I managed to miss this one.

johannes

--=-tY+Z3YQwZyzVWS+uv5SK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKxLtkAAoJEODzc/N7+QmaZFcP/39f2gyNNr5bvK3WiVBd3hWz
nd//8Kz0VrGFXFfGYqSjZgLAK5TH0rjmu4Av6b+mFIWw2WFkPnSdY5c/draIdyw9
Xxw3oUfIzLlrQjpt1kGlP3kNM++Iber10z+puSvSOxxniyDJLrOUerKzdS3aU0Eh
M9OZ8i/hM0hoY7GIQXdqk9j8Z1OBCT2qIUQx7i2FsU8o6HQSMWwj3WTFTggHxtaB
uazNdrH4Ge3zRABTSNP556IqxfOes5Oke31WoQD6vC8E04PHJIz1Wj9HmnbWIxum
8ap3o6ekNM6dLRFHnFIg8Dp+q3j3fpx0LN4j7QwuL14urX+V45jxyK4T4OVOT2rZ
jzlC4Vx9+vQg/B2SWRChoWmM81ZEg7A4l1zeS9dg6K8yM5PTPMHTLppNofTO7Pik
qxKRALkdq1up+KvoPwQTHIPcgX7XMQIQj/G6GRV9L+bgUqqCSHEdlZFNczIO9zJt
vGQcv+fNpsl6EN8vJZVkIPgmGYW7Np13VrGo6GMTKlUHdnKDy7pi+2zSss1cjUno
znOyQBpnP1jgKJDYvIIIqHv5suUkHxrvP3VXRc5BXDJJxoba4/XXK9AFvjACd+8W
K6+ctLN7NcUlVXZ3LCt25noHPUnpTXAiHKlFsl4l0641iw3hX9rrhfO78ZXNi1Bw
7oL7WfQO4MwWUobrek+7
=MJrD
-----END PGP SIGNATURE-----

--=-tY+Z3YQwZyzVWS+uv5SK--

