Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39025 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933097AbZGPT2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 15:28:11 -0400
Subject: Re: Cross compiling crda and SSL word size
From: Johannes Berg <johannes@sipsolutions.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <9e4733910907161225m7322b5dcidf9271cb45c07657@mail.gmail.com>
References: <9e4733910907161204x441c21b9n22530800682d363@mail.gmail.com>
	 <1247771344.30529.41.camel@johannes.local>
	 <1247772250.30529.42.camel@johannes.local>
	 <9e4733910907161225m7322b5dcidf9271cb45c07657@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-0Htlu549TPJ16T2ssTku"
Date: Thu, 16 Jul 2009 21:27:41 +0200
Message-Id: <1247772461.30529.43.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-0Htlu549TPJ16T2ssTku
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-16 at 15:25 -0400, Jon Smirl wrote:
> On Thu, Jul 16, 2009 at 3:24 PM, Johannes Berg<johannes@sipsolutions.net>=
 wrote:
> > On Thu, 2009-07-16 at 21:09 +0200, Johannes Berg wrote:
> >> On Thu, 2009-07-16 at 15:04 -0400, Jon Smirl wrote:
> >> > When cross compiling crda the Makefile asks the python system what t=
he
> >> > word size is. This gets the word size from the host. Is there a way =
to
> >> > ask the word size using gcc? In my environment the Makefile is
> >> > automatically using the correct gcc cross compiler.
> >>
> >> Can you just use gnutls instead? it has no such issue :)
> >>
> >> Otherwise you can probably parse it out of "gcc -dumpspecs", but that
> >> format doesn't look too nice, especially with multilib gcc...
> >
> > C99 says this works, I think:
> >
> > echo -e '#include <limits.h>\n#if ULONG_MAX =3D=3D 4294967295\n32\n#eli=
f ULONG_MAX =3D=3D 18446744073709551615U\n64\n#else\n0\n#endif' | gcc -E - =
| sed 's/^\(#.*\|\)$//;T;d'
>=20
> The problem test is in key2pub.py
>=20
> def print_ssl(output, name, val):
>     import struct
>     if len(struct.pack('@L', 0)) =3D=3D 8:
>         return print_ssl_64(output, name, val)
>     else:
>         return print_ssl_32(output, name, val)
>=20

I know, I wrote that code :)
You could make the makefile pass that in as a parameter to the script
instead.

johannes

--=-0Htlu549TPJ16T2ssTku
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKX38qAAoJEODzc/N7+Qma8woQAJdfxhjlHcuJsAszY3ibg9yL
nY1E7gfAIxce9h2eVLsFx5EZHtgzA7hz3Iorgx6vPq5Ne4mTSWbljn+EWBbdn2yh
fth93LgF0q8Oc+ieisJj+PJJ9FiSiJ7NBJ5ROAkdjdpXLtNQoF/lUyJ/qqOnVcrB
S6U9frzyArd4nfzfpFZ/ygEI0yoII2UFC+upsMIXKjFAXEX2tlPSybXeccbve/5/
QNRhvYmdFySG7XnnJLw2OdN+psiW9Q5rAEHTdVAp7Uq1ZUgCJO7CcMz1y9rOYrlk
AQX9ExRm0h8ZOa4zkY2hd5xm0DLstb4OhwxUW5W+DiJjO88PsX1KSwk+fbK/FJ8W
GCX+3B+CPc4f8yUqAddqyBCSutehEVxbSiCPxHl4QYFzncvKtn8QrMD/hRz0c+oD
2uny18iMUcFH06GxKZngmqeSfwWAFxYujUhyQTD50HzCkqIdbheper0Z6z5dxWOq
Xnb+uyHmx6mw5jMguciDv4lSblTV92QhbwtEh77/HyhxiCfjPWJBVv4XKw4Qx6Ca
RqyMFPdIZuN2lhcwyZu4JUilK1UM5FzRhJ63mgZccGSCLBdb3hY0fKsUg4HbAZ96
a7Gm9nifm/SVwrpmgZm4zR9GrsZ/HNk6CLQSLRzAA5cfUQ0tulFPdFliOmQmBpFv
vMMLdh3pHCtmPp5pm6qn
=3qFM
-----END PGP SIGNATURE-----

--=-0Htlu549TPJ16T2ssTku--

