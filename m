Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52178 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbYLJRh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 12:37:56 -0500
Subject: Re: [RFC] b43: rework rfkill code
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
In-Reply-To: <200812101831.13526.mb@bu3sch.de>
References: <20081210150935.GA10927@srcf.ucam.org>
	 <1228929529.15837.34.camel@johannes.berg>
	 <1228929820.15837.40.camel@johannes.berg> <200812101831.13526.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RasjcS8Kq8fQVoonl3ci"
Date: Wed, 10 Dec 2008 18:37:23 +0100
Message-Id: <1228930643.15837.48.camel@johannes.berg> (sfid-20081210_183800_771673_A3FD7CCD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RasjcS8Kq8fQVoonl3ci
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 18:31 +0100, Michael Buesch wrote:

> I introduced it when I ported b43 to rfkill.
> Well, a lot of semantical changes were made _after_ that.
> When I added it there only were two rfkill states and b43 handled these w=
rt the
> actual hardware state (and I still think that's the right thing to do. Th=
e sw-state intermix
> is confusing).

Right.

> So when I added the flag it meant:
> user_claim_unsupported =3D True means user cannot change the hardware kil=
l state.

Yeah, but the assumption that software can change the "hardware kill
state" is rather stupid to start with, I think.

> So basically it means the device has two states. One software state and o=
ne hardware
> state.
> However, I don't know what the semantics for the flag are today. Lots of =
code changed.

Ok. I think the fundamental flaw here is assuming that there's just a
single state. There isn't. The device can be turned off in hardware (in
which case sw won't be able do anything about it, but we want to know)
or in software (which we want to handle). Pretending that there's just a
single state that's either hw-off, sw-off or on is plain wrong. The
device can be hw-off and sw-off at the same time, and then if you turn
off the hw-off button it won't turn on (however, unless your system
integrator totally screwed up, you won't have a hw and a sw button on
your system)

johannes

--=-RasjcS8Kq8fQVoonl3ci
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJP/5QAAoJEKVg1VMiehFYlpYP/Rv03rttekezF8CzAFanwyFL
E/ZBrt4YCCk5kP0QBTIoEwTa8Rc0CDfe9IzcnA6l0PBYTZQ7uokOxWpCnqj6AJSL
nKRcFBzNJf8kItuxG10vG/F8mPsVi9CXCNxrvjsj2niUW1f2jkfdrENscrdBIVQS
CAx5Ko0RlTDFcmn47uqtCebB77IsLwzp9keBf7CAHHPpgpw22AGr+LMPGU8VSZnJ
/W+xP6PQdO3gfV6s9daxjFlIPGWPQ0oFfg2s/vwAPT0SKDRuAKtWCHHclAP0DCGr
iAk2BnpoEkkpvBaun8zayJerac6FkBgNWKEJCXguRTLR8hEOPDFXOIvhfa1pHi0O
8c8qgqa4rU+k5b9e0B92gUWCN1yRFvoU3s9Sikyh1S+N25hp1u94Q+AJrnjZIvX7
HIlgQvNRDqROT7lLLYTwBy6lZ+6IBUf8Z7H3l3BjsFW7Ke8A2UK+kD3d+5PX4/dR
kPOBBbOLoZv3ipdEyUYOBRjxlwtyPFBUW+v6qV67IoRTws31FOz2BbCWQiIuNpLo
vaGcskelu3yKULEBTHik7UIDmQKIHtunG2J5XzVGzvRUNtdDptuYDDReoXQleAgv
rA1BXBDSXXcsgyfVEGm1WdabE4ZkDtS0SIDeWcCDu703a70vEG3KaGyMa7bA59Tf
xKJs/hhi4wMDeX5rgyyd
=RpSy
-----END PGP SIGNATURE-----

--=-RasjcS8Kq8fQVoonl3ci--

