Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56954 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab0AaTxR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2010 14:53:17 -0500
Subject: Re: Regression in b43 with BCM4311/2
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4B65D51F.1090903@lwfinger.net>
References: <4B64A2F2.6060608@lwfinger.net>
	 <1264887027.3546.207.camel@johannes.local> <4B64AAEB.9020806@lwfinger.net>
	 <1264888699.3546.208.camel@johannes.local> <4B65D51F.1090903@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EFDHrPs9WcCzYWUG6gev"
Date: Sun, 31 Jan 2010 20:53:14 +0100
Message-ID: <1264967594.3597.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EFDHrPs9WcCzYWUG6gev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Larry,

> I finally sorted this out. The patch in question (c7ab5ef) is the bad one=
, but
> not the basic response rate part.
>=20
> Going back to the code that worked, I discovered that the routines
> b43_short_slot_timing_enable/disable() were never called. Once the new co=
de
> touched the shared memory location 0x0010, the transmit performance dropp=
ed way
> off. If I let the new code adjust the Interframe Slot time in MMIO space,=
 but
> not the shared memory location, the transmit rate in my BCM4311/2 went fr=
om a
> maximum of 18 to 22 Mb/s. This problem did not affect the 0x4315 device a=
s the
> memory was changed only for G PHYs. I think that should be for 2GHz, and =
have
> made that adjustment. I have not yet tested that with the LP PHY. Once I =
do, I
> will post a patch for comment and testing.

Cool, thanks for looking into it and the detailed analysis!

> Thanks for helping me understand the basic response rates.

Any time.

johannes

--=-EFDHrPs9WcCzYWUG6gev
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLZd+nAAoJEODzc/N7+QmaJZ4QANLWKq11qVmQR2VqnRtmbone
mDlYD6N+k56caSZrSASXEr0GfS4BA4umRcMeAxNLrUUQnkv1ZMwYmANSUo2YohIm
RrcShKCaVdwk7rqF+UyF+TqU0NOqxZelVQnWhUQ9EcQrB6fphs8NO9/HAZGRwWm1
02EzhtroGdCPFJG+50X/iuh6L/rb07rv9qr3xsiFWMEOOqy+MZu1rtABMjG4GwE6
nWH6nwH1qz6xYEMC8YyGK9OJ7fXDn8CNKUmE2RYbP+z9JGQFb/BXwOm6OH7Krehc
nNdEvWjp+2b/uOTyVx/3yfbBmVpqn4lqQCaLCNbtDxn4MISI85M58S16uMnjQa+G
tWrAzk5aosX5dAp4c6C/Ta/+W/M5nSoZVPycx51ZjT+UJxm42PXj10M43qyk54JQ
TEGKobZk/iuuffVgfqoK8Se4gDfeylwFQrcDcZ0IB+tFDCaiTxlZva9MtE1rxA6M
GXnxqBtOvDGxjueBQFe60O/5aO6brJyxVEMzRylX+y9jBC3twOp1BFBZ+exPPTgc
bnG7bfYdBm3mt9KBwWeu4lQX7QKZrWy+lCWTvw8aAG/pKOWBwMgqyFoWf65rVOuh
F+DRZZcrpWaaBQC3566Fj5tWUR1Y7DjnImz/YmZJegchKyvmibNCyshgHtSUG8t6
55TtXSNq2o5BA4nyXEB+
=eQLF
-----END PGP SIGNATURE-----

--=-EFDHrPs9WcCzYWUG6gev--

