Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60721 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbYJYMFV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2008 08:05:21 -0400
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
From: Johannes Berg <johannes@sipsolutions.net>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
In-Reply-To: <20081025112526.GB12252@Chamillionaire.breakpoint.cc>
References: <4902DEBB.3050205@hotmail.com>
	 <1224926241.6695.1.camel@johannes.berg>
	 <20081025112526.GB12252@Chamillionaire.breakpoint.cc>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qzQvUKSN5KElAX+iBKsu"
Date: Sat, 25 Oct 2008 14:05:11 +0200
Message-Id: <1224936311.3410.0.camel@johannes.berg> (sfid-20081025_140536_918939_71951227)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qzQvUKSN5KElAX+iBKsu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-25 at 13:25 +0200, Sebastian Andrzej Siewior wrote:
> * Johannes Berg | 2008-10-25 11:17:21 [+0200]:
>=20
> >> [  277.190494] Kernel unaligned access at TPC[10129b68] zd_mac_rx+0x14=
4/0x32c [zd1211rw]
> >
> >my best bet is this:
> >
> >        fc =3D *(__le16 *)buffer;
> >
> >could you try something with get_unaligned? Though if this is it,
> >then ... We really need disassembly of the exact spot.
> A few lines before that:
> |         buffer +=3D ZD_PLCP_HEADER_SIZE;
>=20
> and ZD_PLCP_HEADER_SIZE is 5 so we end up unaligned, don't we?

Depends where the buffer was before, and thought has gone into this
alignment stuff here so it shouldn't. Might well be a new bug though.

johannes

--=-qzQvUKSN5KElAX+iBKsu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAwt0AAoJEKVg1VMiehFYBt4QAJ3BKbB3yjY8Y4bNwMikXuNh
Sc7AGD6DJL2Z/c/7wKdGEf/OvwsgUD0mqigRcrPcmq5Te7n/xzvgh5CkzRnSX1tZ
rlWdFh/sNM+gpPpZPI14T3G01O16fM32zQZdElqxLpqIHoQdTqBL/M2DoNX8kS5E
PhumppZCQS4GwkAQetljm1RBjpGME3JuiJzNw+yYV4+stx5FLGQbUg9q8kPa/1Rr
qC+np9NrB2kPaYX/oW43NAYjl96LmgvYXQ+dIAIqPcl1lMmpnhKGTrB0Uang8Q4u
k1fm7yotCfibToq8F++Vi37d50yx/692yqb38hRdl8Frq/5U3ObUDEan/H/bFtEk
rRfgmMOMyEJBhKc2DN8zpOEzqrmvmmTIqXwC3Pq9kqq5cWrW8vj3ghhGRBo18xTL
b/OpZHZTzRJxrPKWJXHCZ9Cnzu+AuITQz2A4O0tRFIMqnEJv7z9Smm4gV+3FPUH3
nb8vZBbr7KaipDo7Azyxe/Szhc51dY+iTxsnXZ/MpDOwDU3K5YkZ55NhoOi4BIl6
fJjyaTBUFuX1gMmXKdQaMFHygM5LGyRs3T0aJ8DkJETeDeI4rmRyjS0Raq9kvk5J
1+Jvdw2ioAbuloucbxAD2IpkYjd60iNh/aYXhS/iOjWn1DTMe3J9nrs2o00qPVlL
1k59a63XVX3biabKFvuk
=A93W
-----END PGP SIGNATURE-----

--=-qzQvUKSN5KElAX+iBKsu--

