Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52863 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbYFQSBT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 14:01:19 -0400
Subject: Re: [RFC PATCH 0/7] IEEE 802.11w / management frame protection
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <200806171952.53183.mb@bu3sch.de>
References: <20080617154008.883383150@localhost>
	 <1213721067.3803.73.camel@johannes.berg> <20080617174749.GB4974@jm.kir.nu>
	 <200806171952.53183.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GT3DG7Z6Zvggty+Ot7GF"
Date: Tue, 17 Jun 2008 20:00:24 +0200
Message-Id: <1213725624.3803.94.camel@johannes.berg> (sfid-20080617_200121_930904_5C5967F1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GT3DG7Z6Zvggty+Ot7GF
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-17 at 19:52 +0200, Michael Buesch wrote:
> On Tuesday 17 June 2008 19:47:49 Jouni Malinen wrote:
> > On Tue, Jun 17, 2008 at 06:44:27PM +0200, Johannes Berg wrote:
> >=20
> > > > crypto. It is unclear whether this can be used as-is with devices t=
hat
> > > > use hwaccel for crypto at least before the low-level drivers and/or
> > > > firmware have been modified to cope with the possibility of CCMP be=
ing
> > > > used with management frames.
> > >=20
> > > b43 will be able to do this for sure, it doesn't care what sort of fr=
ame
> > > is encrypted. The question is how drivers can indicate
> > > support/non-support I guess.
> >=20
> > One of the problems is that CCMP as defined in IEEE 802.11i for data
> > frames is not compatible with CCMP as defined in IEEE 802.11w for
> > management frames (there are small differences in AAD and nonce
> > generation). As such, if the hardware/firmware is trying to decrypt
> > received CCMP protected frames based on the IEEE 802.11i rules even if
> > the frame is a management frame, the end result is not going to be very
> > good..

Oh, ok, never mind then. Probably not worth accelerating anyway.

> Well, as long as the checksum will fail in that case we're OK for b43,
> as the driver will notify the need for software crypto for those packets.

=EF=BB=BFI don't think it'll try to decrypt them anyway but I thought we co=
uld
at least use it to encrypt.

johannes

--=-GT3DG7Z6Zvggty+Ot7GF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIV/u0AAoJEKVg1VMiehFYbVYQAIaJJoFtgQGlTsRHAeZGOEEF
v2kp4ONJ/cSAo5aJargnU1NC0dQtcg9kQGxrmemxXxSrFtqDVReTGOoRNDAPT+Hw
rbyXLKcU3NnddI1xrj9RPIWuvPKioSX8UcgC7OPIqHtNMqY0h2uQvG2G4/RW8WmS
EYtGCPTu1+N2H6QpDuUGUoq8xwCMdGjTdcNYFu328V52+F5wOCbF4RzNZPxyjq3y
RT367j9I9pEHp8jZLY+WOdoSxrE84ZNi3mXueejK4Jj9AyIy/aCRiopVQ1rcVIxW
MldfQZT4AF8yU36gr2wyx9EI+4HuMf23U/MgNYuEpc10Jt0Ec/nzoO9tCHD91hGx
F18H6MSyfiBN0w7AdjwBB3nYcucgkftKXU81l93aull7Ql6JJdhmQFS1sTHmQvWq
iBlz028IM/Ow1tfBeDcfR6gWKsIcTQzz2zVSzJPMPa9XKmyI4PK8uhq/sRsLezCY
Lfz0kNTEhhfekPt1fPKG6jdlYpdjF2Vox7uoytSkhzPOlaWd1EJg2xRN4GJLCPZd
Lugg0XDMGU68b/I9hgdx4GoN5eaKYmnGfRt5iVnfgaGUQlSLqTOiN2vJwIkGVo9l
57w0ARK+tNEmtclyhcW3yNiGmtQGAn/sj+DufFEkcItk1DTNHsV/jlDcL24yfGJI
vMqvtwQReOa/N2WzXXl7
=afI1
-----END PGP SIGNATURE-----

--=-GT3DG7Z6Zvggty+Ot7GF--

