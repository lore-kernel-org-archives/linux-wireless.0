Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49072 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957AbZDQJvk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 05:51:40 -0400
Subject: Re: [Proposal]TX flags
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, radiotap@radiotap.org,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910904161824t7af6860dxebf3a13069b924d5@mail.gmail.com> (sfid-20090417_032507_012632_CF7AA3F9)
References: <69e28c910904141733m72ce521ap8f1865bec991fff7@mail.gmail.com>
	 <69e28c910904161147h5a68d3b5nd054b043d6ad2719@mail.gmail.com>
	 <1239908374.26575.20.camel@johannes.local>
	 <200904162110.05150.mb@bu3sch.de>  <20090416204806.GD25412@ojctech.com>
	 <69e28c910904161824t7af6860dxebf3a13069b924d5@mail.gmail.com>
	 (sfid-20090417_032507_012632_CF7AA3F9)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UZ9g0TTlwNU2A7OJblho"
Date: Fri, 17 Apr 2009 11:50:59 +0200
Message-Id: <1239961859.26575.44.camel@johannes.local> (sfid-20090417_115144_928014_89774D48)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UZ9g0TTlwNU2A7OJblho
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-17 at 03:24 +0200, G=C3=A1bor Stefanik wrote:

> > I see the point that Michael is making.  What do you think?  Shall
> > we treat it as a 2-bit wide unsigned integer field in the Tx flags,
> > instead?
> >
>=20
> IMO that is a good idea, if we accept having non-booleans in a flags
> field. In that case, this proposal comes to my mind:
> -Define the second and third bits (mask 0x0006) as a quad-state flag
> indicating the use of RTS/CTS. So, we can have these values for the
> flag (accessible as (TXFlags & 0x0006) >> 1):
> 0: neither
> 1: rts
> 2: cts
> 3: auto-select (only makes sense when sending & during feature discovery)=
.

Like I said -- this doesn't help for feature discovery because there you
may need to say "only 0 and 2 are valid values", or maybe "only 3 is a
valid value".

I also don't like _setting_ bits for automatic -- I have a nagging
feeling that leaving out the entire field should be more similar to
setting it to all-zero, rather than all-ones. It cannot ever be exactly
the same for most fields, but still...

> Also, a proposal for feature discovery:
> The userspace can send a packet that consists of nothing but a
> "christmas tree" radiotap header, with no payload, but with all fields
> and flags set that are known by the userspace app. The response could
> be another payloadless radiotap header, copying the bits set by
> userspace, but unsetting the ones not supported by the hardware. This
> way, the response packet has all flags set that are supported by both
> the sender and the userspace app.

Let's keep that out of this thread -- but let me note that this has no
advantages (and a disadvantage in complicating the API and requiring
parsing) over unilaterally sending those bits supported by the driver --
after all the app could do it the other way and unset whatever it cannot
support in the full bitmap the driver gave it.

johannes

--=-UZ9g0TTlwNU2A7OJblho
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6FEAAAoJEKVg1VMiehFYbpsP/iykFMyGIRj0gm9qMmpAxsRv
OxkKY1csWpu/Xsm7w3uzWIi5KUb836tQdHuiPruMgOYbJ5H6ZAeOrto0sLzrCoSP
zMq144e2pB/hOcM9dd7xPnF2u0RINI6mIsvTyVnpL0Sbnm3ePByAKY3ZRIpfmpVk
Ny91Iv1gyGqegjZwaV/ioahVf3jr58eeVcLMeCwZmMppjyBWybprJ8dDaFYU59To
QVhr8E1GhyJksP+Ye9J5hkbgB3s9zAEASTLw2zd+5NxnhqNLu5v7BDAMPNG/UurZ
YLcBzZMu547f2YyO/ojWvhg2BU7hSSicYCnbxc7OZgFDJK09Zg+m7dQ99Wc5dweH
Dc4qZPhykUXm5pBKJGgLx6U+YaZ+umpci8c3j6hwV/7PwWUB/K2OROX5GgX8BKhx
k0hjhfLeO3QXazsF+UdRvhUXVNg7iMba/xDN9JaAr4U3YFg9Z4s/g/j9ZNjnxe6I
Hp/W/bxEzX5ohU1y15jRbIgiWCyTclGJT0TNkT44JmyxHka/rR4evMPjUThZNnua
6kgVn9mGwMHDzkO8ACMxU+IY+L8lzvM3p2nc8ZkOXJPLri8rM2wEQTmgz8bmLKnd
xQjcsxtLB1BBFYnzT7e3Vk6uIB7xVwuSL9gPAoR5DgWyc4FXQ2dffJ2PWXXV4fOS
1Hqf0ghGURwga3BDp7bp
=8Lxy
-----END PGP SIGNATURE-----

--=-UZ9g0TTlwNU2A7OJblho--

