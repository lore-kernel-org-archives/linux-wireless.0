Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56400 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbXKBJx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2007 05:53:27 -0400
Subject: Re: [PATCH 4/7] o80211s: (mac80211s) basic mesh interface support
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <mailto@nbd.name>
In-Reply-To: <8e8340660710311736k555474f3ifd7490b5f0f7b623@mail.gmail.com> (sfid-20071101_003628_984847_78170051)
References: <4727de06.0e578c0a.2568.ffffb079@mx.google.com>
	 <1193832985.12078.14.camel@johannes.berg>
	 <8e8340660710311736k555474f3ifd7490b5f0f7b623@mail.gmail.com>
	 (sfid-20071101_003628_984847_78170051)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ljqyU+nbxE1lFfme3hH1"
Date: Fri, 02 Nov 2007 10:54:48 +0100
Message-Id: <1193997288.12078.39.camel@johannes.berg> (sfid-20071102_095330_248200_375AEA6F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ljqyU+nbxE1lFfme3hH1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Agreed about filename length. I would prefer not to make mesh
> networking configurable, as STA, IBSS, etc modes aren't configurable
> either. I prefer to avoid polluting the data path with ifdefs.

Ok, I'm not sure, it just seems like quite a bit of code especially when
all the other features will be added, something people like the OpenWRT
folks might not like. nbd?

> Mesh APs are not supported yet, but we plan to support them through a
> different interface type (e.g.  ..._TYPE_MAP) or extending the AP
> interface type. Mesh STAs and APs will share all the mesh-specific
> stuff (peer link discovery, path discovery, etc) but they have little
> in common in the data path, so I do not think it makes sense to use
> the same interface type for both. Maybe I should rename ..IF_TYPE_MESH
> to ..IF_TYPE_MESH_STA?

Probably. Come to think of it, how much mesh networking is actually done
by the mesh AP? I guess we need to support this in hostapd rather than
the kernel?

> > > +static void ieee80211_mesh(struct net_device *dev,
> > > +                        struct ieee80211_if_sta *ifsta)
> > > +{
> > > +     mod_timer(&ifsta->timer, jiffies + IEEE80211_MONITORING_INTERVA=
L);
> > > +}
> >
> > ?? That needs a better name, whatever it does.
>=20
> Well, doesn't really do anything yet, I can rename it to
> ieee80211_mesh_housekeeping, which is the function it will perform
> soon.

Hmm, ok. I'll take another look then. "housekeeping" sounds far too
generic though, so at least if it's named that way it should call other
functions IMHO.

> It would be ((rx->fc & (FROMDS|TODS)) =3D=3D (FROMDS|TODS)). Given the
> length of 'FROMDS' and 'TODS' actual macros, I would leave it as it is
> or add a new definition IEEE80211_FCTL_WDS =3D (FROMDS|TODS) and use
> that.

Yeah, I know they're pretty long, but the ! in there confused me. I
think it's fine if you indent the second line one space more to indicate
that it belongs into the !( parenthesis.

johannes

--=-ljqyU+nbxE1lFfme3hH1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyrz56Vg1VMiehFYAQIsZRAAvs6j0SXFLa1v91Gg9L7IplgNWkGFaJrP
I3KQHHDG07HhwGs57/S7ajJbrN2MYSNe3YiO4Ye65p2Nic2guNRUkaC/OgNjy5Aa
uAqeMKjJ+QYliOro6HNwXv46if/m6pgRN8ITCha2GXj2OEL6pPvWA8WWeEQlATsn
USmI1k5K5f4+3FldAifPRlLGYAbcZ0EY5BXZrtyUj8ndhNPq3nncims+XU0RaXRW
2aFiWi1hnbWyAxevxPG6BIPnScUUgZ8+LhD/wv89Yd6MDaQOZOD5yRWJ3NSsQ0zY
dnvoiMfOgpRt3EzS5XuAtB5rDrG32AjCf/tySLO7yKdAi97bgxU9vU44H2ydJvOw
ZuqM8hWUbmRMoZCk4wdVX4eagnAVits5ETa7+O8LowROc4uLsRds2J5aE9v7M/FF
UuCWaQGmmGeZk9olUtfwehPZ6uKO2He4TI+Yx4uTx0Jn2+Ve5vaJo4as0kMw9PEu
FC2ARjkNiR14WWB/El5SG0iBMqjhpkikWFyiP85qchHtzM/p8XWh1DVhT1g9T3Co
FMOgZQoRwRaesLyJ9S5n06bmNz5JhK4XgD1QGlDElBlOI5KRoffBPLT4kVF9SzVk
fENsQ8Pcv2OoTrcOdkaDvsHAJodOy2BYZn6c+CDS8B4sc/mDpNwTRADvDlSg6r+P
DJ4I0t0C3g8=
=35hj
-----END PGP SIGNATURE-----

--=-ljqyU+nbxE1lFfme3hH1--

