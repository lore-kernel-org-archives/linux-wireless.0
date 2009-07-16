Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51387 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933083AbZGPTYm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 15:24:42 -0400
Subject: Re: Cross compiling crda and SSL word size
From: Johannes Berg <johannes@sipsolutions.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1247771344.30529.41.camel@johannes.local>
References: <9e4733910907161204x441c21b9n22530800682d363@mail.gmail.com>
	 <1247771344.30529.41.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-W8gvSBusXev6Ml4bcJRu"
Date: Thu, 16 Jul 2009 21:24:10 +0200
Message-Id: <1247772250.30529.42.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W8gvSBusXev6Ml4bcJRu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 21:09 +0200, Johannes Berg wrote:
> On Thu, 2009-07-16 at 15:04 -0400, Jon Smirl wrote:
> > When cross compiling crda the Makefile asks the python system what the
> > word size is. This gets the word size from the host. Is there a way to
> > ask the word size using gcc? In my environment the Makefile is
> > automatically using the correct gcc cross compiler.
>=20
> Can you just use gnutls instead? it has no such issue :)
>=20
> Otherwise you can probably parse it out of "gcc -dumpspecs", but that
> format doesn't look too nice, especially with multilib gcc...

C99 says this works, I think:

echo -e '#include <limits.h>\n#if ULONG_MAX =3D=3D 4294967295\n32\n#elif UL=
ONG_MAX =3D=3D 18446744073709551615U\n64\n#else\n0\n#endif' | gcc -E - | se=
d 's/^\(#.*\|\)$//;T;d'

johannes

--=-W8gvSBusXev6Ml4bcJRu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKX35XAAoJEODzc/N7+Qma/RUP/313dIDbUYF77I50E2QdIs5i
HNhywDgre++0p+EX2UM8tQO1Dt8XQz+0r96FYfYYYWESqGV8b2DkoldAZOd+c/96
qfgYeIWPus/hyilnORt+BU/8PXlcRLCvUiVk6VN5i9QS0n3+ZOU8fMVAo5ns6/WT
7ScQUrnUsZ15dVTQPTkMpZePShNt0+bUGLIuUPChyyrFr98tFHNyULCHwc2jgOZ2
s9j31kKI37li3dYF+KHOOwwzTgWKb5j9Ww35gyFssiQWumG1+YSoIrRYfDYmIjDt
5svDhooZBWguqLrT28+5b9QM3vh0/Mz7Fv/tiZIRwU5/fCkPfAHxygWdwcttu8Wk
+VBbzuav99Feve3891HpZ/Y8eU9pfpe47R73pvua8TFrglaHVnkSa3kZZuF/8LoP
gSlNjgqdXf7ms4zwMTKeR1JKX4ZtEc6MfIGoxDyEEOIJoLYL/gWG3yHUYWdwjCok
0FGdkz1vZoG5MjycuSVP2Wi/F5eA7yOsSUSqszpYwsabWUJhCMAdpQsJt30GvNak
jHwJVJ54TAqSST8KyUoEf7NsaqVQfqdfk6/4fqiWN54pDBeeDBinSVaLXbTTIdyY
T8+9C6lsvwn7E0yzEyPuUuYFgwwUWUOs3XJJZNpKBbmpfZlVBVNpv/4AqTanhI9L
v6vFateCopObCgCPoHyh
=JYVi
-----END PGP SIGNATURE-----

--=-W8gvSBusXev6Ml4bcJRu--

