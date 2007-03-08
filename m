Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55002 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188AbXCHTg4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 14:36:56 -0500
Subject: Re: cfg/nl80211 primitives
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Jouni Malinen <jkm@devicescape.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1173382599.3020.34.camel@localhost.localdomain>
References: <1173219649.3503.50.camel@johannes.berg>
	 <20070308004940.GC31388@devicescape.com>
	 <1173380977.3248.55.camel@johannes.berg>
	 <1173382599.3020.34.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GvKGkBdXnekIiO78mPEH"
Date: Thu, 08 Mar 2007 20:36:46 +0100
Message-Id: <1173382607.3248.65.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GvKGkBdXnekIiO78mPEH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-08 at 14:36 -0500, Dan Williams wrote:

> So when wpa_supplicant or whatever has to do rekeying, or if I want to
> change some parameter but not completely re-associate, how does that
> work?

I suppose it'll be a different command. But SetKeys() is already an MLME
primitive in the specs :)

> > What I'd like to see instead is that you give the MLME (whether it's in
> > the kernel or in userspace[1]) all the parameters it needs to do one
> > action when telling it to do that action.
>=20
> I'd basically expected that this was the model we'd be using anyway.  A
> user tool wouldn't have to:
>=20
> set ssid
> set key
> set authmode
> associate
>=20
> but instead bundle all those up into one message to netlink with the
> "associate" command or something.

Right. However, as far as I understood some people at the wireless
summit, they'd prefer having one command that bundles all the settings
and then another one that applies them. Maybe it's just a
misunderstanding on my part and this whole thread is pointless?

> I'd much rather conceptually have the following (in python-esque), which
> is what I thought it would be more like...
>=20
> err =3D associate(ssid=3D"foo", key=3D0x435223, auth=3D"shared")
> <rekey>
> err =3D set(key=3D0x235326563)

Yup, makes sense to me.

johannes

--=-GvKGkBdXnekIiO78mPEH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF8GXO/ETPhpq3jKURAsTnAJ9C55MK5fqe2Y44h/VGfNiuJroR3gCfc5Bc
pC8T3Y3jK6ql7JBpqKU60Nk=
=HaeS
-----END PGP SIGNATURE-----

--=-GvKGkBdXnekIiO78mPEH--

