Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44334 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496AbYKISbS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 13:31:18 -0500
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Shaddy Baddah <shaddy_baddah@hotmail.com>
In-Reply-To: <200811091302.15899.mb@bu3sch.de>
References: <4902DEBB.3050205@hotmail.com>
	 <1226220992.3614.16.camel@johannes.berg>
	 <1226221438.3614.20.camel@johannes.berg>  <200811091302.15899.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RwLqdjZ3Uj3QFG8ZQVzz"
Date: Sun, 09 Nov 2008 19:31:19 +0100
Message-Id: <1226255479.3614.29.camel@johannes.berg> (sfid-20081109_193122_604489_FD423B28)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RwLqdjZ3Uj3QFG8ZQVzz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-11-09 at 13:02 +0100, Michael Buesch wrote:
> On Sunday 09 November 2008 10:03:58 Johannes Berg wrote:
> > On Sun, 2008-11-09 at 09:56 +0100, Johannes Berg wrote:
> >=20
> > > I think you forgot to attach the patch.
> >=20
> > Sorry, I missed your second mail. (btw, if you generate patches with -p
> > in diff arguments it helps a bit reading them)
> >=20
> > Ok so it looks like the buffer you're getting is unaligned. This is
> > strange, but I'm too unfamiliar with the code. It seems that there's th=
e
> > PLCP 5 byte header in front. Well, try the printk I asked for, because
> > at that point zd1211 should avoid "leaking" the alignment problem.
>=20
> zd1211rw has some code to align the packet to a 4-byte boundary.
> But the compare_ether_addr() and the other le16 accesses are done before
> that realignment.
> This these blow up if (ieee80211_is_data_qos(fc) ^ ieee80211_has_a4(fc))

Well, yes, however, then his patch should have fixed the whole thing,
which it didn't.

johannes

--=-RwLqdjZ3Uj3QFG8ZQVzz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJFyxzAAoJEKVg1VMiehFYa4EQAKnvDEiRyImEwHeyUL5WtpAj
vjl4Hc1A37xTNVB64bjrlkfrlFf+b1gqwlxxa0K46ojf+azVQn3nJPmW+D0rumWf
MEzslUbSzug66CIuS14S/taqgA1yQXgcgKDGHItjwjdTpA74VrA/KTEF2G8IBhAG
sTE6/MXJsDgDrUEneG7V8ut48TYqHpQDjq6BZLruYILPN10TjhtLOmDPfevtR+4h
N2NY8c/dRO8qG+jPwUzHEWTpyBhGBVYEzBr+EJqBU0eJjiFa+JZm4KBJlWF2H7oG
XJ6SUZpDxBBpyM8WRyxYo1dOC+Ksqk+CBbeNNab6wyBWVEDGl7sRHaY+6Yia1Svz
8AmdO97vJd7lqo2rmPQP5SRDOP9bZLUujhqc5ZAwWhDK5dju0r8JndVzviJlImq6
ZilpGLRHDZ9oIY7M02HwJTArHtx9C0FcmMesUlN1BTOqpQm9vRmA5jNfLdD66va3
1N0xGhmuHnMgswvZQzBfVqewQmInjtCozQxWRLZRQRQiGT06xyEChAtpTbic1V2n
fuGH9eb+EiS0xKuhHh80Ut1lAFx99w1igjgtJZ9tPC83pQwk0me1qU1KnZL7hR8E
B3hc3mWVd5FUG26R8leXRy6UMrVoJJ9tzIbtj3UPCRsg2ONaTaOAb2EOyZ3IWFDn
i1CNluCG2uEqdtHDZPST
=fsR6
-----END PGP SIGNATURE-----

--=-RwLqdjZ3Uj3QFG8ZQVzz--

