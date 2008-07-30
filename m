Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55012 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbYG3PTp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 11:19:45 -0400
Subject: Re: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Friedrich.Beckmann@infineon.com, linux-wireless@vger.kernel.org,
	j@w1.fi
In-Reply-To: <1ba2fa240807300659p4d743f31se265f550a2da0dd1@mail.gmail.com> (sfid-20080730_155910_940459_1CBFE2D2)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217339170.10489.62.camel@johannes.berg>
	 <1ba2fa240807290706h70f89f68xf8fe7e672c0275ad@mail.gmail.com>
	 <1217341293.10489.73.camel@johannes.berg>
	 <1ba2fa240807290855p191eebesb1ecf2314031f688@mail.gmail.com>
	 <1217411631.10489.103.camel@johannes.berg>
	 <8469FC7DDCBE054D9653D8506E1FF0F001F1E7B606@mucse406.eu.infineon.com>
	 <1217423948.10489.121.camel@johannes.berg>
	 <1ba2fa240807300645j654a82b4rb813b71681dfab71@mail.gmail.com>
	 <1217425854.10489.125.camel@johannes.berg>
	 <1ba2fa240807300659p4d743f31se265f550a2da0dd1@mail.gmail.com>
	 (sfid-20080730_155910_940459_1CBFE2D2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WGdRt/PcyN3Z46E+fKok"
Date: Wed, 30 Jul 2008 17:19:39 +0200
Message-Id: <1217431179.10489.134.camel@johannes.berg> (sfid-20080730_171948_586568_7121DBF3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WGdRt/PcyN3Z46E+fKok
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-30 at 16:59 +0300, Tomas Winkler wrote:

> > Well qdiscs don't just do that, depending on the configuration, so we
> > shouldn't rely on them doing just that.
>=20
> I know but this was the primary purpose of MQ to push the scheduling
> decision to HW if I'm not mistaken.

I thought it was more about the upper level locking, ethernet hw really
just round-robins most of the time. Although it will, of course, be used
for scheduling decisions.

Is aggregation really a scheduling decision though?

> We really don't need anything else just queueing.

Exactly, but qdiscs do most definitely not provide just queueing, and we
should not deprive the user of the ability to use qdiscs on wireless.

>  For example what the
> prioritization which is done in current wme.c
> is wrong and it won't pass certification and creates starvation.
> Tested and proved.

Can you explain how starvation happens? In what scenarios? With or
without aggregation?

johannes

--=-WGdRt/PcyN3Z46E+fKok
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIkIaHAAoJEKVg1VMiehFYn0cP/iSsMLcPms3BREG8TL6bb7pm
OMCau5/KW2kDI1HstisDNgGiIwwUybBSx8+amgb1hyb2o/H+x3O+CysuQr2+Amf3
eWil8RI6l7jgAO/IegWHORDaQwbygGIHpxHSFNYOdXRr7pFz2xB72HkCipaHYmTS
tTUIaYTso3lEcjUfa/+e0uBsAQXv9usW+jboqnUTxu8n6SyzNE2tfKHSBGg6aFwU
MWGcMTwKRpE1UOZ9o04Md+ifzfNCmlf6dekowTSn+5eNRW587mCFBMj2pgVr8vND
MHPwVJgnXHQIaddekK53DsIwkFpmIgik2nTipW9Fqs6fVVVCF65PblXzoLStcqdU
PMwW7TSk0KtS1Bqd/qZjStGYJVNFhUpUMDCCiJKFE3ZEbk0V52yNJPyReuREQQZ7
BOo9dR5R/pAVKR+XjnpoRcKsiFCKgJoppCeXnI+FOZ/4BiKUoMPOyCRkAwuKePuZ
pCDQCkQLXmcbmJOODe6lYkr36VTM1rmuZUGkFeSsyBwYwKRSls992wW1JLVARjth
KPDUhtsGH32nqem1/lGhpqwOf+WH8klh9L5p4w/8bmk6udcWUg9HdLzcCx5dZUbt
bpLCpRHhOhpuM0bW62tVaptqi/3XOLPNr9KhZKxkWLSGHnBgrHNk4iazAwxdoEb9
nT6ZdCiEceVTD4+4OZi3
=Mafk
-----END PGP SIGNATURE-----

--=-WGdRt/PcyN3Z46E+fKok--

