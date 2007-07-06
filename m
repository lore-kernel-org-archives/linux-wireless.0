Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760800AbXGFLHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 07:07:46 -0400
Subject: Re: [PATCH] libertas: monitor mode support for OLPC
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200707060922.06110.hs4233@mail.mn-solutions.de>
References: <468c3f32.081b600a.3817.5051@mx.google.com>
	 <200707050842.01533.hs4233@mail.mn-solutions.de>
	 <8e8340660707051037p56e10ec7u3aa4d76893e0b1ed@mail.gmail.com>
	 <200707060922.06110.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-br4DSBVBAiWMTV74WY2t"
Date: Fri, 06 Jul 2007 13:08:46 +0200
Message-Id: <1183720126.3818.122.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-br4DSBVBAiWMTV74WY2t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Javier, Holger,

> Why not do it this way:
>=20
> "iwmode eth1 mode monitor" turn's the device into monitor mode.=20
> That's what by far the most drivers use. In this mode, the=20
> device will send all frames to the host, e.g. all beacon frames.=20
> After all, user space can filter:
>=20
>   tshark -i rtap0 -R '!(wlan.fc.subtype =3D=3D 8)'

I suppose you really should be using cfg80211 to create and change the
mode of new interfaces (and allow only one monitor and/or one STA
interface). Then you actually get a sysfs file for free, and as a bonus
it's the same one mac80211 uses :)

johannes

--=-br4DSBVBAiWMTV74WY2t
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjiK+/ETPhpq3jKURAtTnAJ4nvxihlkVhGXyRDUiPzQw2NzeOjQCgk6Uc
Va0fMYfKcQZTKKA/JyXHujk=
=Wotp
-----END PGP SIGNATURE-----

--=-br4DSBVBAiWMTV74WY2t--

