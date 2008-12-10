Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50182 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196AbYLJSeg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 13:34:36 -0500
Subject: Re: [RFC] b43: rework rfkill code
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	Michael Buesch <mb@bu3sch.de>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
In-Reply-To: <1228933790.28590.29.camel@localhost.localdomain>
References: <20081210150935.GA10927@srcf.ucam.org>
	 <1228929529.15837.34.camel@johannes.berg>
	 <1228929820.15837.40.camel@johannes.berg> <200812101831.13526.mb@bu3sch.de>
	 <1228930643.15837.48.camel@johannes.berg>
	 <20081210175102.GA14282@srcf.ucam.org>
	 <1228932343.15837.57.camel@johannes.berg>
	 <1228933790.28590.29.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-P+jaxV4WTFt9e1sY1kHZ"
Date: Wed, 10 Dec 2008 19:33:59 +0100
Message-Id: <1228934039.15837.59.camel@johannes.berg> (sfid-20081210_193505_986993_76D1F0F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-P+jaxV4WTFt9e1sY1kHZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 13:29 -0500, Dan Williams wrote:

> > Does the wireless driver get the notification about this from the
> > hardware, like it would if this was a real physical switch? Then it's
> > probably pretty simple: provide a rfkill struct from the driver that
> > updates hard-kill and provide a second rfkill struct for the platform
> > device that doesn't get hard-killed, but also provide a soft-kill input
> > form the platform device. That way, you can toggle that button, but you
> > can also software-enable the platform rfkill device and that in turn
> > re-enables the wifi-rfkill "hw" switch device.
>=20
> This sort of sucks for userspace, because we see the actual wifi card as
> hardblocked, but some other random button as softblocked.  There's no
> indication that changing the softblock one will affect the hardblocked
> one.  What are userspace processes supposed to do here, assume that if a
> non-radio-associated softblocked switch exists, that it can re-enable a
> hardblocked radio of some random wifi card?

The other question is whether we actually care? So what if the hardware
can only be enabled with the button, why does that matter?

johannes

--=-P+jaxV4WTFt9e1sY1kHZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQAuPAAoJEKVg1VMiehFYe3AP/2gTuRWKwJK6ZGcIK+uDLo80
4ahWZS8p95oPVgMU3ylfEK7kDQ7aZNbSPt1jNRC2boS72t/D8G+Hq5ymxanbVgM8
4RKBPOAwjuP+YSsT+PjS7WKAO7vSGavSs11BmluMw84O3KQQEogWSgyA+gx4UJoz
S22jQpIeFnU901xVkjg/JYm4iw8kneCiiF5FXiVmnK4q8FG2yr9UNgbJr9spG+5S
IhdidJJpwGvwEq251mPXDuvg45vMQXZcPhSH7OdLk4Ssuqkmn4Nb9B3XtSl8ewnA
+FiWgA3GsZIg/3U+CQ4uHrFOLDhov45jBihG/HgprM6ggFpwVBPAlNF6aYJqExeG
kYrADWAPLXhZsOKUkQniJYm2X/c0sugTAtW6ekWsnlJZ4C6olw5Bb4AtLsTi13mm
TJHB6LmpOtrtHKBh/pUqCSohH2dmnuNE4N332qhZvPj2B1IK1YVzKNs0DhcKEB2p
Rr4YHbUf4xqnYZVzIDQWFT9E166Vc3Jf+b1dUBoaxkXuxE7/C0gReBuYGb5gj7pB
rqcvgFMSP5W9U4APC7hRO+gff7I2rV4UMzuTHeYX7jt55BRO6FL0kXqxv7fU68fb
t68zFw5G1q8/i6M6RxxXyxw0wJJDXTiXAf6URXcqDz4ggaBPMbJ7kCjjPw5WUQxx
She+vxfqU105yXX+AUSo
=CNB3
-----END PGP SIGNATURE-----

--=-P+jaxV4WTFt9e1sY1kHZ--

