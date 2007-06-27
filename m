Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51203 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378AbXF0OaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 10:30:18 -0400
Subject: Re: [PATCH] mac80211: Export short-preamble bit to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200706271508.29188.mb@bu3sch.de>
References: <200706251628.00838.mb@bu3sch.de>
	 <1182934500.4769.8.camel@johannes.berg>  <200706271508.29188.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zaskHnGZK0iuI16ZolJK"
Date: Wed, 27 Jun 2007 16:30:27 +0200
Message-Id: <1182954627.4769.30.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zaskHnGZK0iuI16ZolJK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-27 at 15:08 +0200, Michael Buesch wrote:
> On Wednesday 27 June 2007 10:55:00 Johannes Berg wrote:
> > On Mon, 2007-06-25 at 16:28 +0200, Michael Buesch wrote:
> >=20
> > >  	case PRISM2_PARAM_PREAMBLE:
> > > -		local->short_preamble =3D value;
> > > +		if (value)
> > > +			local_to_hw(local)->conf.flags |=3D IEEE80211_CONF_SHORT_PREAMBLE=
;
> > > +		else
> > > +			local_to_hw(local)->conf.flags &=3D ~IEEE80211_CONF_SHORT_PREAMBL=
E;
> > > +		if (ieee80211_hw_config(local))
> > > +			ret =3D -EINVAL;
> >=20
> > any reason not to return the actual error code from hw_config here? Not
> > that it'll be any different from -EINVAL I expect...
>=20
> The reason is copy&paste from other PRISM2 IOCTLs ;)
> I'm OK with the real error code, too.

I don't really care either way.

> Though, the error code of hw_config is usually not useful _at all_.
> As it might not be the SHORT_PRMBL flag that produced it, but some of the
> other config settings.
> I would probably vote for any code in mac80211 to ignore that return valu=
e,
> except the places where a failure of hw_config would be fatal (init or
> places like that).

Yeah, there's a todo item saying that we need a way to just commit the
changed settings.

johannes

--=-zaskHnGZK0iuI16ZolJK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGgnSC/ETPhpq3jKURAnJyAKCoJU+1uhADl3fq9tXwfU7XCNjJuQCfXU0z
OjF6d8FAV8YzOok4th1ZUPM=
=spOW
-----END PGP SIGNATURE-----

--=-zaskHnGZK0iuI16ZolJK--

