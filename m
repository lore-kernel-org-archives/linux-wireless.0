Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43474 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbZDQTsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2009 15:48:11 -0400
Subject: Re: [PATCH] nl80211: Add set/get for frag/rts threshold and retry
 limits
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090417193838.GA21250@jm.kir.nu>
References: <20090417184629.GA9275@jm.kir.nu>
	 <1239996573.5110.12.camel@johannes.local>
	 <20090417193838.GA21250@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LyUps6XppvoBTMbUT+WH"
Date: Fri, 17 Apr 2009 21:48:05 +0200
Message-Id: <1239997685.4543.1.camel@johannes.local> (sfid-20090417_214814_561944_6765B474)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LyUps6XppvoBTMbUT+WH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-17 at 22:38 +0300, Jouni Malinen wrote:=20
> On Fri, Apr 17, 2009 at 09:29:33PM +0200, Johannes Berg wrote:
> > > +	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
> > > +		if (local->ops->set_rts_threshold)
> > > +			local->ops->set_rts_threshold(local_to_hw(local),
> > > +						      wiphy->rts_threshold);
> > > +	}
> >=20
> > That could return an error. (so do the changes the other way around)
>=20
> I noticed, but ended up following the existing behavior in wext.c. While
> that may not be the ideal source for good behavior, at least this is
> consistent. Should both of them be changed? What exactly should happen
> on error?

Well if you do the rts change first, and return early, you change none
of the other parameters when that has an error.

> > > +		result =3D rdev->ops->set_wiphy_params(&rdev->wiphy, changed);
> > > +		if (result)
> > > +			goto bad_res;
> > > +	}
> >=20
> > If that returns an error we need to roll back the values?
>=20
> I thought about this, but ended up not doing that because the existing
> (wext) code seemed to behave in the same way. It is unclear whether the
> error there would indicate that some of the parameters were taken into
> use, but not all. Unless we provide mechanism for returning that
> information (e.g., separate calls for each parameter), I'm not sure what
> exactly should be done here. Just leaving the parameters (which were
> validated before) in struct wiphy seemed like the safest (and well,
> certainly easiest ;-) alternative.

And then here you can just mandate that it's either-or and returning an
error means that you haven't done any of the requested changes...

Or you just remove the ability to return an error and let whoever needs
that ability for their hardware deal with it :P

johannes

--=-LyUps6XppvoBTMbUT+WH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6NzyAAoJEKVg1VMiehFYjiIP+wczFfgl38bOIOT/RwIp9mHE
gzGedMcbUZaRDQJKRC/DRuAMrcPzbcKoSV9Q7LGRXxg4YUYgU2YkArAOMSSdYj9s
Vh0PUM9T42eVsDew+IndXgyRrx2Y2nMhlJ2H3lM9EDkbxonQwHuIt5peUgJkXSqc
ZXx83cHerEqojvDhDyiNX7suxY+RmkgFqD8g7MPu/xgOaCjMCWaTNvSRWswNpc05
NlPko10xvyEJHz5Np+FV9Xf4Cb5zQXDk0Ftg3ewCKpu06hhWswP2I4jJB00/vlk5
UoruUhbgobPh/jY9Kq+2FQW2PbPx10U2eMznMNSauO5xX+Rz8jWqvmdaC3J5Zlk7
4aKsBXs0ESWY+i4Y86Zll2sDsWfI3q/DfKo7cY2+7qjF/ly7+N/FqhvnfIKorHJb
rr3mu9IxDk85lhwHPnZPUDwlySNDOSi10ofRLgOPlJRw3q0zQ4VY4RD55/ntMHn8
rlozmhG8Sa4utRQSJoNoFI6Y87uj5vQ3o1jqmCTU5ctl4DN1EszOe2VZdDXJXVeV
NhlaBFcAdyv6w8RmaQ9F5SCSXx9bDqFtMyGWZ/5RDVhwoKrpBUZKJjkvZkovKa8+
IHiBBkH4lCW4SurQEVEXOoNvCYdwnvIcn+GmIq99/cqf6LMFzhwy6s0GzxeXT60m
zB1GA3yEAstlWdCSFHXm
=ZFC1
-----END PGP SIGNATURE-----

--=-LyUps6XppvoBTMbUT+WH--

