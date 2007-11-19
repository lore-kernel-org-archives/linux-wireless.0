Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37026 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbXKSPBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 10:01:44 -0500
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: shaddy_baddah@hotmail.com, linux-wireless@vger.kernel.org,
	Jean Tourrilhes <jt@hpl.hp.com>, Daniel Drake <dsd@gentoo.org>
In-Reply-To: <20071119.002755.77617097.davem@davemloft.net> (sfid-20071119_082758_146579_574C7820)
References: <4740DF47.4040206@hotmail.com>
	 <20071119.002755.77617097.davem@davemloft.net>
	 (sfid-20071119_082758_146579_574C7820)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CuuI2MlFiw1moD3Tdbof"
Date: Mon, 19 Nov 2007 16:03:02 +0100
Message-Id: <1195484582.8642.18.camel@johannes.berg> (sfid-20071119_150207_845854_7CB31649)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CuuI2MlFiw1moD3Tdbof
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > The first noticeable problem is when using iwconfig on the device. I=20
> > cannot set a key for the device, and a query of the configuration alway=
s=20
> > claims that the "<encryption key is too long>".
>=20
> Likely some wireless ioctl compat layer bug in the kernel.

Is this 32/64 interop? The kernel has never been fixed and never will
be. New wireless tools should "support" this, but imnsho you're *much*
better off compiling 64-bit wireless tools.

> > If I try to scan for APs using iwlist, I get one AP listed, before a bu=
s=20
> > error occurs. This of course, does not suggest that the problem is with=
=20
> > the driver, but I mention it for the record.
>=20
> This is an unaligned data access in the userland tools.
> Try to catch it with GDB and give us ths backtrace.

For Jean.

> > Whilst the device is up, I continually get console messages like those =
I=20
> > have inlined below:
> >=20
> > Kernel unaligned access at TPC[100ee4d4] do_rx+0x244/0x614 [zd1211rw]
> > Kernel unaligned access at TPC[100ee4e8] do_rx+0x258/0x614 [zd1211rw]
> > Kernel unaligned access at TPC[100ee4cc] do_rx+0x23c/0x614 [zd1211rw]
>=20
> These are unaligned data accesses in the kernel driver.

For Daniel.

johannes

--=-CuuI2MlFiw1moD3Tdbof
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0GlpaVg1VMiehFYAQIsIQ//Rjf81+MSCgRxKRTXqoe7XAkFH9H6wXOQ
lGfZF+qgVGiiu7HvUXBjildV3eXGO6OSfMqPQ7P7jIRnYofLXUy+GVcHaGRZvJrM
BUWlxUEge+qIX9mcFF8Jtk3m0Ru75At7V7rDsnnfPtHSG+sk2PKCFGq15heNEtt/
z5833BP4K3E9TEJRWN+RvpxdyvfsMDs1y3QUN/vi33N9McJq9scqs10yRLv5CiRI
k5anrAvYsv0l/7iNrjYSiTrGlHu6PM9Afrs+dYaX92buOgdeFHmPuxphAw6I5dZ7
p/fuYRINXvccCU3YGep7WoSmBBcpTTybNQ/xnaqPFPfdtH0VY2IccjPnnUAFUonh
Wn0ypTGXzVVxHRa6FQpHQ9CdUmehC7l+BE8L6MUroablCz4ClcVmLGkpaLuA2ONs
YuEN0KoDPlNDR261pP7XruidxXJwqW2u0OfQWC5rjrH5F8n8UFHdE8W2Pwj8qwY3
MLH4Yovf04qHwjketBTygnXPr1Re1htEDMpnEW0NTupx+6kDkIuJsDE3M6ZfmJrw
BN4287p3FleBdExMO/QdgfFgkkezLbdeE+oUBt+1p8aI/0ftbudAkgMuzfcEDF75
oDtagzYPtJs9F508mfqTula4iHXmY8nxkOg2i0b9UbnskuAW+9rCD+L7uPGVA8Jj
fz3scj9oe0g=
=kP45
-----END PGP SIGNATURE-----

--=-CuuI2MlFiw1moD3Tdbof--

