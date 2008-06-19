Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbYFSRrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 13:47:36 -0400
Subject: Re: [RFC 3/2] get rid of rx handler function pointers
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200806191944.52164.mb@bu3sch.de>
References: <1213879121.8967.9.camel@johannes.berg>
	 <1213896016.2125.51.camel@brick>  <200806191944.52164.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wBgDQqmLCZJluLPeV8KV"
Date: Thu, 19 Jun 2008 19:46:53 +0200
Message-Id: <1213897613.8967.48.camel@johannes.berg> (sfid-20080619_194739_140830_464B46FF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wBgDQqmLCZJluLPeV8KV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-19 at 19:44 +0200, Michael Buesch wrote:
> On Thursday 19 June 2008 19:20:16 Harvey Harrison wrote:
> > > =EF=BB=BF#define CALL_RXH(rxh) if ((res =3D rxh(rx)) !=3D RX_CONTINUE=
) goto rxh_done;
> >=20
> > Would it really be so bad to just open-code them rather than the macro =
approach?
>=20
> I think the macro makes it readable. And as it is defined locally it
> does not obfuscate it.

We can always make the macro more readable:

#define CALL_RXH(rxh)		\
	res =3D rxh(rx);		\
	if (res !=3D RX_CONTINUE)	\
		goto rxh_done;

johannes

--=-wBgDQqmLCZJluLPeV8KV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWpuDAAoJEKVg1VMiehFY21IP/35QrR5ffTEOVmneQFcNHI3s
wuaomgCiFA8ed5Rgn8vJPFKEyUiTC4ZS8erEzCE+K0gyrpB5lgM+da+l9wjICqej
yDqqrGDL+dMwk1Rw3ramKTzqC2fvmstAVEL31rZXYZTemDYtJFDiThSvrHE6ZNTc
DyjWdHPBkxOnMBzhe+9g68FclO8H+nLce8y5obAkX8ttD2tEM+Qfa6Me3/Nl4hdx
M4S5bOOkAByDr7HnRl9ebGl2KZp0BGa7VWjuOLQnvNErkrvo0L6o/w/Oe1FRDK/p
n/Jc8dn4WUO0ByEQMOsp/UvNIe6p+98Oylx8G3EMUHw9qqSKWGY9HmKHKinHckZf
Xkdt/8B5yFbZdMC18Lay9ep4ssH8wQ9irafDz1LjUrdWaKx2IKzVr8P4OGlkFb4Z
ziOE5c7H/iqzH9y+VIbIMkqY782tuwNsMA5xI2YhQCw/19txX+cVY9TKzcNEeIyR
NjEcRAClj+NiHy7iv2UNF2Rh1T2GkLqvAbpf5NoHkCgCVZHdQxCKDcDDmGgwAEju
evd9PQrWiD4hWGXWQQWRfRQTxc3k/Vcn9aUhgimtd1S5N9pWKxjMX3cIvRaj1j6R
4tIfj6+01XFv96nrR6vtzACZB1YwjDvxOe63EQ/UCXJjOlsrMEFGEgQ2IeM1zV4B
QCmbd1f/ZmdanmhX7ba3
=a1/m
-----END PGP SIGNATURE-----

--=-wBgDQqmLCZJluLPeV8KV--

