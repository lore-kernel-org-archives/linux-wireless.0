Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45340 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbYJFMkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 08:40:35 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1223296592.11272.163.camel@violet.holtmann.net>
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 <1221123779.2513.88.camel@debian.sh.intel.com>
	 <1221184060.11498.3.camel@californication>
	 <1221185432.6695.0.camel@californication>
	 (sfid-20080912_041007_653566_F8146EC3)  <1223296221.15196.6.camel@johannes.berg>
	 <1223296592.11272.163.camel@violet.holtmann.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oi2fPphmA1vicxgfaFrl"
Date: Mon, 06 Oct 2008 14:39:43 +0200
Message-Id: <1223296783.15196.13.camel@johannes.berg> (sfid-20081006_144041_503102_EE4E8D8A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oi2fPphmA1vicxgfaFrl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 14:36 +0200, Marcel Holtmann wrote:
> Hi Johannes,
>=20
> > > I take this back. It took a couple of hours, but it crashed again.
> >=20
> > Do you have 64k pages enabled? My issue goes away entirely when I
> > disable 64k pages.
>=20
> so the initial issue was a BUG_ON when the ucode reports back an
> unsupported event. That should have been fixed by now since we just
> can't crash the whole kernel, because some piece of firmware acts bogus
> now and then.=20

I have a different interpretation of the original issue, since afaik the
value it was doing a BUG_ON on is a value that is only passed in by the
driver and copied by the ucode to the response, hence it shouldn't
actually crash unless the driver is passing bogus stuff in or, as it
seems to be the case here, the DMA programming is completely fucked and
the ucode just goes to write to random memory locations.

> However there seems to be some other issues with me
> running a 64-bit OS and connecting to an N-capable access point.

Strange. My test AP isn't N capable though.

johannes

--=-oi2fPphmA1vicxgfaFrl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6gcLAAoJEKVg1VMiehFYkjYP/RMUOlcr2cEKnGWkTQkj7w82
3+4PPVH01d0PhSTSDVdTGlvfk6POV/yrOmH6oFC8xTgbwzjmCRd+/bAW8s07486q
zRBbf5Z7IUMUopRobSBRBKi3/f+oYUZhVN1I3qv+DD2kLlOJ8fWLTrOL1FHR0Q+R
KdzgV5R6AyL6wj3zCeZ03smEBaMOf/mLPwShHk11HZECKX42b4NQoPQxT5F72Cww
IvvsV5A/jZKJDCMTdBQHn+rP92wj0KH7JaT1FxrgmczN6fM/QRK+HNBvNxUFArId
uA0n11453Pw8yS2Nq7cMZD29rAvb4tAChLOOOm9z4uIeLhajUqDf2kZbR2CWe4uj
9PyGOKe1FSyaX2aBNA34EGNINZwGli59HOQKeU7h7yMWP1IDrTrA1IZR9T8DFvx2
ObJSkdwThH87G7WkY7C3XdJF3PMnl24yZwebTKqrVy65ZFMq+NNprfreeUZuuHFj
O+SgzmzaVfYB51I5dwpSqx0qO+Spi5y69Aif1wq0V7amfvSpRAKmN0sFdj/gFHKg
2RDlIEhnPVDNp3QxnVZQS1jxKS1kt/fXkQ24lMz2SLk9NMGlFD0soLV/ahFG2oVv
yzdq0/yT2bzQtbxj8T0gAevVXkG0tdzrNtrECW08FSoyJICgrFFfERpupUzgjAtU
MB43diiJCsSjkPvcCZe+
=peJb
-----END PGP SIGNATURE-----

--=-oi2fPphmA1vicxgfaFrl--

