Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbXKMNLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 08:11:49 -0500
Subject: Re: [PATCH 2/4] o80211s: (nl80211) support for mesh interfaces and
	set_mesh_cfg command
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1194896861.6980.28.camel@localhost> (sfid-20071112_194800_018283_4168B9EB)
References: <473516df.18bb720a.41e8.5fdc@mx.google.com>
	 (sfid-20071110_022645_005653_498DB7A6)  <1194687275.7258.36.camel@johannes.berg>
	 <1194896861.6980.28.camel@localhost> (sfid-20071112_194800_018283_4168B9EB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-w/x5Pqr67zU4na1DYDDt"
Date: Tue, 13 Nov 2007 14:12:44 +0100
Message-Id: <1194959564.9116.44.camel@johannes.berg> (sfid-20071113_131151_591424_7DB40A46)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-w/x5Pqr67zU4na1DYDDt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-11-12 at 11:47 -0800, Luis Carlos Cobo wrote:

> > So if I bring up a mesh interface and don't use SET_MESH_CFG, it won't
> > operate at all?
>=20
> Yes it would, it would use the wild card, zero-length mesh ID.

Oh ok, need to give it more thought then.

> > I think I'd prefer if the MESH_ID attribute would be given as part of
> > SET_INTERFACE/NEW_INTERFACE instead of a new command. I'm attempting to
> > keep nl80211 as object oriented as possible and this single command
> > doesn't really fit the picture.
>=20
> Will that be the way to specify the SSID for the STA interfaces?=20

No, see below.

> If so,
> I agree it would be better to use that command instead of an additional
> mesh specific command. As by now it's just used to set the interface
> type I was not sure it was appropriate to add the mesh configuration
> there.

The way I've been trying to do things is work in an object oriented
fashion. If you look at the beacon and sta commands I did, basically you
can add/del a sta or beacon. With association, the way I would want it
to work is that we have a virtual "association" object (of which you can
have zero or one). Deleting this association object would cause the MLME
to disassociate.

I don't see any object-oriented way to do the mesh stuff because as you
said one *always* has a mesh ID. Is this really what one wants though?
Is the broadcast mesh ID actually useful? I think I need to understand
more about this to be able to give a good recommendation.

johannes

--=-w/x5Pqr67zU4na1DYDDt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzmiy6Vg1VMiehFYAQLtwA/7B0U49NCygxQEaYUdEa3CDeBVx+4Iuimf
BliedAPmLHfCo6Rmnou3v5BPtJtklffsMgMv7FolDjhfa2dN9TFqXBxETTDZgQEb
voLd/aAnZANhZNFI0r3K09+qlpqzh2pAm8wbUCGA5+nwcqE3HpsgKWBv1TDoxlAE
V+KownxwJ54HtoEI+8D35Q8lsci0I47MgcqWr2fsz8wS5tmw/6Yx369lGsh64vFC
t0zNhVcEdQlfM4u+HLvaUTAGFCwXyAl6Kcd5GSEOR8xb1Hnjgk+sScxWv7CIyEyH
VZqBZYQGFoAUnHiiyvx/0Pv9DWyqDtCe9z4MGFc4PPHqEPUvEr1fjAi+VxLTX1NA
MKXZ8MgVFMPYdcj67IO9Fff3nFqp93jAnALDWkuCpfolMgoQxHt37XRCAre9pC2x
MR2CkyB69CwNuwsVfrakAsIkacj4cOjoQwwcMCaAG4YVu8yNUXzGbWLNrJwgKl63
w0o7PTo+CQPCGZ0iZTOF/RAJu8IQgXjqv4iPi9rVLzp1qRzrtLRBElvkrZDRIcDK
qfLioNuL4HhFFfRa5z3CR2sw/ggcHjF3L9u426mZEjzxCw8+Z98bzok1yE1CgKwU
5BY/Iyj5INWU9QiMlrDLWaLPaiuiSBkU51iPePZbvL2lHDpKNFkpmVV8ut0bhxaq
gmlIxz/dgz0=
=ZFvl
-----END PGP SIGNATURE-----

--=-w/x5Pqr67zU4na1DYDDt--

