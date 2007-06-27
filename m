Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbXF0N6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 09:58:14 -0400
Subject: Re: [PATCH] mac80211: Export short-preamble bit to drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200706271533.57189.mb@bu3sch.de>
References: <200706251628.00838.mb@bu3sch.de>
	 <1182934500.4769.8.camel@johannes.berg>  <200706271533.57189.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EH5hp6UE6CAsbG5Kcd/y"
Date: Wed, 27 Jun 2007 15:58:20 +0200
Message-Id: <1182952700.4769.16.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EH5hp6UE6CAsbG5Kcd/y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-06-27 at 15:33 +0200, Michael Buesch wrote:
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
> >=20
> > johannes
> >=20
>=20
> Another thing, while we are at it.
> How is locking for the conf structure actually done? How is it
> made impossible to read the value of "flags" in another thread,
> while we update it in a non-atomic way, here?

I don't see any locking, though we do have this code running under rtnl
so you might need to check the other accesses.

johannes

--=-EH5hp6UE6CAsbG5Kcd/y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGgmz8/ETPhpq3jKURAkbwAJ9njmKzk23wEshYARemBjtkyl2XPACcDRrE
tBJDXm+jSOJtpeKyhsoDfOk=
=nuuH
-----END PGP SIGNATURE-----

--=-EH5hp6UE6CAsbG5Kcd/y--

