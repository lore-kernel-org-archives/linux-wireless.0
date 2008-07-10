Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47183 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759886AbYGJTjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 15:39:53 -0400
Subject: Re: [RFC] Add new regulatory framework for Linux wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <20080710193402.GL17936@ruslug.rutgers.edu>
References: <20080710152415.GK17936@ruslug.rutgers.edu>
	 <1215706960.3483.37.camel@johannes.berg>
	 <20080710193402.GL17936@ruslug.rutgers.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3dwHco+xPlMv+qkMA7YA"
Date: Thu, 10 Jul 2008 21:38:28 +0200
Message-Id: <1215718708.3483.46.camel@johannes.berg> (sfid-20080710_214020_427934_C5C5D761)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3dwHco+xPlMv+qkMA7YA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Its just a random number we use as a receipt. I was thinking of
> having it to provide uniqueness on requests and to provide a cookie
> to ensure it comes from the kernel but now that I think about this
> a bit more its really unnecessary.=20

> If we keep UUID we can remove the alpha2, you're right. But it seems
> we may rather keep the alpha2 and just nuke the UUID.

ok, makes sense to me, yes.

> > > +	reg_rule_policy[NL80211_REG_RULE_ATTR_MAX + 1] =3D {
> > > +	[NL80211_ATTR_REG_RULE_FLAGS]		=3D { .type =3D NLA_U32 },
> >=20
> > I thought we agreed to use actual NLA flags for the flags, in a nested
> > attribute, instead of using bitmaps.
>=20
> I forgot if we did. If we keep them as they are we can actually end
> up using them to replace the channel flags themselves with these
> though. What do you think? Also if we do use a nested attribut for
> the flags what would be the benefit?

Mostly we wouldn't need to care about any space concerns like adding a
"FLAGS2" attribute if we run out of the 32 bits we have there. I don't
feel strongly, but it seems to me that using NLA flags is more natural
in netlink and makes the separation clearer. Maybe.

> > > +/**
> > > + * regulatory_hint - hint to wireless core a regulatory domain
> > > + * @alpha2: the ISO-3166 alpha2 the driver thinks we're on
> > > + * @wiphy: the driver's very own &struct wiphy
> > > + *
> > > + * Wireles drivers can use this function to hint to the wireles core
> >=20
> > type in both instances :)
>=20
> Hm? I don't get it.

Sorry, made a typo myself. typ_o_, not typ_e_. you wrote "wireles".

> > > +static int is_an_alpha2(char *alpha2)
> > > +{
> > > +	if (is_alpha_upper(alpha2[0]) && is_alpha_upper(alpha2[1]))
> > > +		return 1;
> > > +	return 0;
> >=20
> > Why's that so important?
>=20
> Its not, but we should want to pick one or the other to use. I
> picked alpha_upper. Have some other ideas?

I'm just wondering whether we care at all. If userspace wants to call it
"de" when we requested "DE", what do we care? OTOH, since we match this
against 11d info I guess we do have to pick one or the other.

johannes

--=-3dwHco+xPlMv+qkMA7YA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdmUtAAoJEKVg1VMiehFYbY4QAJ12gBZiivsXH1iWe373Ms2k
M8VRd3D0To/DgZkgkKpvnAuzvYAVnNHrybm+EUwXDoR1GRLnhpUolelxB/HhTC7o
os4tV6c+kKS7y4JtXk9f0xMlwC8DgHK8229YPwjrBTm+TDM9srg77nSX0+zwc0Mx
wS2xShNJ6YmPJIzYxX6EcjMpdhaudB6Jk+j+MXB0y6TeDLikAEeHV6tr10riwc9V
ogFDUgiC3znTB6Av30dqRptCzzDdYB0xvT79rWwEydOCbQUclMuTspEopeQBsBSr
NZ9zvhBz6FARykVvhnolxfkIj5lVUj2vGlc3/iUlDnE9hsvnpHG49Es0DGoYW1hd
SVeYuQRmCBb3SZt8waByUi2ODMBiJJVTbVauemGPhP9sjQrD9vmJ/U5BCYXeaOBA
WmasuufvsGg7N6qc8eZnL5B2RGnMDYjkCDEtl4ivAOYQ1qQ7vZbMWiJNZtVlXdOv
o1kkXSHMHcSNnxNB3UgsMe8k6oZjYd/0e0m1YAatJmUWTYIuO7X+9WutzvhJodT4
aZOZkJXFYUiooDMVBxtyhKb6NLULBxGpeMkyWXmZsfoS8HOfYraMGd/bGMgNF+4u
VljJVuQ5r0/9e3wfDDozMmEJx474Hx3tSqukT3M4oK7s5G61kmdsYyVFdI2cwBom
IuYLb+8P2PUh2Byw1PFQ
=XYPt
-----END PGP SIGNATURE-----

--=-3dwHco+xPlMv+qkMA7YA--

