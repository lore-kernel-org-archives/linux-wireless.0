Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53687 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbXKMNNQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 08:13:16 -0500
Subject: Re: [PATCH 4/4] o80211s: (zd1211rw-mac80211) support for mesh
	interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1194911599.6980.107.camel@localhost> (sfid-20071112_235326_369001_A52ADA69)
References: <473516f2.15528c0a.7196.3372@mx.google.com>
	 (sfid-20071110_022703_924708_89D9D43C)  <1194689934.7258.66.camel@johannes.berg>
	 <1194911599.6980.107.camel@localhost>
	 (sfid-20071112_235326_369001_A52ADA69)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pP95d3561vFoX9m6WOIm"
Date: Tue, 13 Nov 2007 14:14:33 +0100
Message-Id: <1194959673.9116.46.camel@johannes.berg> (sfid-20071113_131322_140604_CCDA2B83)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pP95d3561vFoX9m6WOIm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Shouldn't that depend on the interface type? I.e. set it for WDS/MESH
> > but clear it for station so that the station won't ack WDS frames? OTOH=
,
> > it may just as well ack WDS frames for itself...
>=20
> Yes, it doesn't look like it does any harm.

Yeah, makes sense.

> > > +			zd_set_beacon_interval(&mac->chip, BCN_MODE_IBSS | 100);
> >=20
> > Does that mean you're hardcoding the beacon interval here while before
> > you confused me how we should handle that setting in userspace? :)
>=20
> I am not sure what are you referring to... anyway, by now I think it's
> fine to hard code the beacon interval, but in mac80211 instead of the
> driver adding a beacon_int field to ieee80211_if_conf.

Well that | 100 looks like it'd be a beacon interval in the lower N bits
of the value that's set there.

johannes

--=-pP95d3561vFoX9m6WOIm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzmjOKVg1VMiehFYAQIv7g//QWl2PhtM0soav5yzQbIUvHpFeQJF+4cn
3g5B7RNc1VYCi0Cl3CvbvWcUWQZ16hv0OQL8w5IK6jSKQdhOcZdFYJip5ccXkPut
XFhLDJkZt1Ay9scThsB2asy798xmmcU1pR/4QmUoUqwzAvZvQTvv2mhqEXxckMCn
JHjpAMEV9SyrShbwasNtVbL1mOXFlcu+TredXLJy4MeqiH6ylIDpUfilobAPBOe6
LrNINZOmwj6O1CaHpKvlS4YEsJOKIaR6q0G9JxOnT+/sYZrVL1b6UrHBCtY5yBs3
gAwxS4LXebw6rotqjW2iAD1MPXku8JG9gNbQL2KTJa2rAcqrrxqYUPvqoFAGbgiz
zb6QNcrDE59MOT/JF3jf1WQs4SQpJrvKaHiXglpsTJN3tulc+ZG2M59mAM8ipphZ
eyH7seA8+VPBGfzUa3N3VBxGZd29juoHR40vG31/w4qT65ayCyCfzF0JTFPEHaWS
1sN39dnL89fr2Ltr4T4qxrklyNIhn7kCgugwan2XRhDZKS/Fg+Oh3tGueA862xsx
/K8ChabzIBdhz9wFn8k35AyfVEeBrJISpvtYBR87Ixb+grxpDR3xeonqLwOtRFTm
BSQq/YkYQ5BNc/FMEbXy70NzTWsioS1W8lVjEyONBymXdF8eSXpK9soJRtZMJd7P
06KS0Wfg2LM=
=g38q
-----END PGP SIGNATURE-----

--=-pP95d3561vFoX9m6WOIm--

