Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961AbYGIPRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 11:17:19 -0400
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh
	beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807091708.04870.IvDoorn@gmail.com> (sfid-20080709_165916_536085_4E7EB629)
References: <200807091511.14288.IvDoorn@gmail.com>
	 <200807091637.02090.IvDoorn@gmail.com>
	 <1215614895.3246.17.camel@johannes.berg>
	 <200807091708.04870.IvDoorn@gmail.com>
	 (sfid-20080709_165916_536085_4E7EB629)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EP3JKRdGfYjDsbNlHDVV"
Date: Wed, 09 Jul 2008 17:16:32 +0200
Message-Id: <1215616592.3246.24.camel@johannes.berg> (sfid-20080709_171721_889912_11E8A503)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EP3JKRdGfYjDsbNlHDVV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 17:08 +0200, Ivo van Doorn wrote:

> > That just widens the window. And if you have multiple queues then you
> > can't do sw sequence numbers anyway because the hardware might reorder
> > the frames.
>=20
> That doesn't seem to be a problem in the legacy drivers, so I guess the h=
ardware
> does *something* to prevent problems.

Actually, looking at 7.1.3.4.1 (Sequence Number field) this all seems to
be wrong anyway, we should be keeping a sequence number counter
_per_TID_ and one for non-QoS data/mgmt frames.

> > > As far as rt2x00 is concerned, all hardware that supports multi-bss a=
lso
> > > support HW sequence counters. rt2400pci and rt2500pci are the only on=
es
> > > requiring SW sequence counters, and they can't do multi-bss.
> >=20
> > Do they keep per-BSS counters?
>=20
> Not sure what you mean, but rt2400pci and rt2500pci don't support multi-b=
ss,
> so they wouldn't have per-BSS counters.
> rt61pci and rt73usb do support multi-bss and keep the sequence counting
> completely in firmware/hardware and I am not sure how they can be read
> by the driver. So I don't know how those are stored either.

Ok. Since the hw is capable of mBSS I'd guess it has sequence numbers
for each BSS.

johannes

--=-EP3JKRdGfYjDsbNlHDVV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdNZKAAoJEKVg1VMiehFYw/AP/0pyW36FquLh4pOgRB9qwvZq
IGegSVpWYR88GOZvbgrVbPMEpj+8emKZY+ofYmjK4BtYpqTUqDdK0yJi0e+6f8aY
6MR8ggQVt7nLsvEnRgvnuF80XDEIl81NwuHoo5XMgffov59MvomKWcOBu1NJL0W8
e4YBfix5IPAb6uQByQ9zKmlBGbjMIZtBVL4nuGxteBgGfpetZU1XpdnnLTfiDWjh
mrgkZ//jYcT1TLGZ2f/uxtcZ47Ru+m3fqqKrgfIMc8hR50NKHIAb7EGCr/NNwnbw
DVXkoywAohXZuvn/BMNl83lzMwM3cBZp7MlcziwFymLss6YCCCx+VAPtN40IniR6
cAgdIWT1AET4TwVqG5ppgc4KLiy+ErH4z3DOTwfU/tRWK7wBUXF/V9Qdi6BVT2yc
v94AUAddLI0JxkKr2nSFXb4MzAryP3C68zJvYKk9U7rPsQzNmNcOtxhMhh8HKzts
/+W4lKYFQh9mKBhkYYXlalL75d1Vm+qpwOZ1d6d7V3s+A/tU8cs5d3MAdFz0uFNI
KNvacKuRBaUTOeQpM1+HYEruWVziAM+qNhD9E/g383G8zOzyOVXBXzdIAPea97NR
TiIKM0A6v/N/E6YKAxEQVBWATsWxAW6BS2dSLDgHWNkprJRqRiUk3VIJQkG5URhx
CFpGSS7Q0Bnmvr23fzxn
=HXrC
-----END PGP SIGNATURE-----

--=-EP3JKRdGfYjDsbNlHDVV--

