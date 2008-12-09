Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59926 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbYLIPDl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 10:03:41 -0500
Subject: Re: [PATCH v2] p54usb: rewriting rx/tx routines to make use of
	usb_anchor's facilities
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20081209145439.GB3653@tuxdriver.com>
References: <200812091514.37634.chunkeey@web.de>
	 <20081209143530.GA3653@tuxdriver.com>
	 <1228833999.1029.0.camel@johannes.berg>
	 <20081209145439.GB3653@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Tr7sJdldxvcZCTbQ7ZdS"
Date: Tue, 09 Dec 2008 16:03:05 +0100
Message-Id: <1228834985.1029.2.camel@johannes.berg> (sfid-20081209_160344_533591_2BEC647B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Tr7sJdldxvcZCTbQ7ZdS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 09:54 -0500, John W. Linville wrote:
> On Tue, Dec 09, 2008 at 03:46:39PM +0100, Johannes Berg wrote:
> > On Tue, 2008-12-09 at 09:35 -0500, John W. Linville wrote:
> > > On Tue, Dec 09, 2008 at 03:14:37PM +0100, Christian Lamparter wrote:
> > > > Alan Stern found several flaws in p54usb's implementation and annot=
ated:=20
> > > > "usb_kill_urb() and similar routines do not expect an URB's complet=
ion
> > > > routine to deallocate it.  This is almost obvious -- if the URB is =
deallocated
> > > > before the completion routine returns then there's no way for usb_k=
ill_urb
> > > > to detect when the URB actually is complete."
> > > >=20
> > > > This patch addresses all known limitations in the old implementatio=
n and fixes
> > > > khub's "use-after-freed" hang, when SLUB debug's poisoning option i=
s enabled.
> > > >=20
> > > > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> > > > Cc: stable@kernel.org
> > >=20
> > > That's a big patch for so late in the cycle.  Is there a bugzilla ope=
n for it?
> >=20
> > No, but we can open one ;) It's strange, but nobody but me apparently
> > found the bug so far, even though it has been in there forever. Might b=
e
> > due to slub debugging being disabled by default even if you enable
> > SLUB_DEBUG in Kconfig (you also need to enable SLUB_DEBUG_ON)
>=20
> It might be helpful to have open a bug that includes a backtrace or somet=
hing.

There's no backtrace in that sense, it just hangs. I dumped it with
sysrq-w but that wasn't too helpful...

johannes

--=-Tr7sJdldxvcZCTbQ7ZdS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPoilAAoJEKVg1VMiehFYZ84QAKxNuepF7NXj2t+YHD6WauWI
gdPXJUZKK9/DptegCqT4pbKPWxOGnWSaPyBiV7y8qa383zIpkSLFE7lie8v4oYc1
wRFZ/h0RQobiCXczHaeDYqTqF6BfMwAhQz5mU8bPrJKXGJu8fj/IxWZ2+dOveWc8
KPadKSyDI9fh/4P1tZOy+HVW21NotPJWFTrIJyYUPoyVVJm8cgkp0CVWy54ZeVde
ir1K1HyklKWxAfCTxMxb40ZuLW80aEj3JtpHfZCUWNzV1ev1Lo73hgbTS+jGhqsD
lzYwdK1Lxgp/AOqGrPxFCxZusy06ArS+fyklItfeBqv2rA59QlYdD5XD+8fZ6gzk
7PxWMhbOCg4p8PY8VICQWxQctLNnZLAI1yqmNDQ83WZzzFdcs9e+nfumlHLp+bXJ
Mf84+vDoGub/mN1IlIlKMR6VoghMhNKS018OIZXi8OPNaUBR7Bot9tCDu3lc+KfZ
6oEssXwzNdXbI4D2Pf29yX00UVh4NpwG27PW+SnhjUvZwPd5FtaFMRp8x6/PNhgc
PJ+k5pd4hLGJNAL6Owcx+A74CPU97nipASYznGS5/4joOmZoXMdYeRO70jiKeyuz
lE8mQb6l9Pzk3hNKVoe7yjZS5CC0TUJ9och/5g/wmO8BKimrPGPC0Yew4/61YRkA
At2YUZ1LXre5wwM4zMhn
=U0MA
-----END PGP SIGNATURE-----

--=-Tr7sJdldxvcZCTbQ7ZdS--

