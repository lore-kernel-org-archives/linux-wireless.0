Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZBMVvh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 16:51:37 -0500
Subject: Re: [PATCH] mac80211: split IBSS/managed code
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20090213214354.67600@gmx.net> (sfid-20090213_224425_365749_2DF37F3C)
References: <1234396421.16004.67.camel@johannes.local>
	 <20090213203641.199830@gmx.net>
	 (sfid-20090213_213711_951136_CAB188EF) <1234559990.4219.27.camel@johannes.local>
	 <20090213214354.67600@gmx.net> (sfid-20090213_224425_365749_2DF37F3C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6OwXrQP1O4DFhUMxsFNb"
Date: Fri, 13 Feb 2009 22:51:32 +0100
Message-Id: <1234561892.4219.43.camel@johannes.local> (sfid-20090213_225142_008691_E7A6BEF6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6OwXrQP1O4DFhUMxsFNb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Odd, I'm sure that worked for me. What hw are you using?
>=20
> I have tested it with ath5k and atk9k. Without this patch (tag:
> master-2009-02-12) beaconing works fine. Have you test it with a
> passive scanner like kismet?

No, only tried connecting it to my N810.

> > > * If you create a new IBSS network it
> > >   scans for other networks to often
> > >   3 times a second.
> >
> > That might've happened here too, but given that I never used ibss
> > usually I didn't realise it was wrong ;)
>=20
> This is to fast consecutively, so it scans and scans but it is not
> listening on the working channel.

Absolutely.

> > > * If you join an existent IBSS it does
> > >   the following strange things:
> >
> > That does look a little strange,
>=20
> The STA information is expired much to fast. This is all the same STA/Nod=
e in an endless loop.

Right, probably some assignment missing to the last_update or something.

> > even if you disregard the fact that
> > you're using compat without %pM :)
>=20
> Why is a strange pointer used to display a MAC address, why not %x:%x:%x:=
%x:%x:%x? (?)

Well, you're using compat, and that doesn't know how to do %pM in lib/.

johannes

--=-6OwXrQP1O4DFhUMxsFNb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJletfAAoJEKVg1VMiehFYdeoQAJVf/sj1YsOoIZ9F2CVEm42p
kc3QvDSPhvO7uCHAiGBmNgVKwRVFBqrNqUTnvJ9spWW79ugrAjnkomPCl32qvS05
9alMXW/ZNzUO6aR+1bZPtEC6pnJxxl/f8zOtohJDxaiJLvxo2GQXHMU/FyZg3VOO
wn1BRxi/NODiPaT6s62DfK6Ep57y+TSRYpkijIhuVf3Cb37G4Jz48wJy8JvJL97k
LQvFyhJQzLmz0aACSH19AS01d8C0rDsweCbWyYyPbLXycfyVSZrkFt4wa59a6V73
KP+bckDe/b2zP7iHya317ggVHRLQyOfqpaoATBXzjB0CPbpsJPhhGqP9hqXFSqwA
O8qRmHamI2Lu6Wxy+agEOZgCkopEM9aru6ZViYMXnElirXq56eaXiu5s5CAU+PaE
k8XmmbLDz0t0bvfwbJRK+UA6MEuY1Vxhz0tIzqlpYocGmSZr9+PeqXrZYQGtNGOT
k2AEtmlmpCtIEXL4XB1sPZ0DitQwg7xw0mCM8SMQGsA+ty1cu1IB0gRQwg4djmYQ
Aj92V+nvRjrefVXxX3DjBKDrswLzlNls/SX1dDROaEUo2CiI8rZykgcn//TYnlsj
ByBLQP/hAAPWqczsxtn/st79e3/KtsZMe71Zn9pqf0cKPKoppRh+Qjk8G9hg4unE
naC74e1N2nyndJJOPolH
=J1le
-----END PGP SIGNATURE-----

--=-6OwXrQP1O4DFhUMxsFNb--

