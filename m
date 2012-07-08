Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:40759 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2GHKHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 06:07:07 -0400
Date: Sun, 8 Jul 2012 12:07:13 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl/cfg/mac80211: add set_mcast_rate API
Message-ID: <20120708100713.GA4488@ritirata.org> (sfid-20120708_120751_519117_7CCD1BA7)
References: <1341739885-15385-1-git-send-email-ordex@autistici.org>
 <1341741386.4987.5.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
In-Reply-To: <1341741386.4987.5.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 08, 2012 at 11:56:26AM +0200, Johannes Berg wrote:
> On Sun, 2012-07-08 at 11:31 +0200, Antonio Quartulli wrote:
>=20
> > +int cfg80211_set_mcast_rate(struct cfg80211_registered_device *rdev,
> > +			    struct net_device *dev,
> > +			    struct cfg80211_ibss_params *params)
>=20
> I'd say just inline the function into the nl80211.c handler itself, not
> much value in having it separate.

ok, will do.

>=20
>=20
> > +	mcast_attr =3D nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE]);
> > +	if (info->attrs[NL80211_ATTR_MCAST_RATE] &&
>=20
> this is wrong

ops, you are right! I moved the nla_get_u32() at the line before to avoid h=
aving
a ugly statement, but I missed something :)

Thank you


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAk/5W9EACgkQpGgxIkP9cwcDegCggt4cvOfxCzjY2frQU1PRVb0n
Kr8AniLGYzO4i1S4VGhV1t7LxLcv8d9r
=V2NK
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
