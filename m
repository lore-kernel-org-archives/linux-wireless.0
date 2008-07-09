Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41469 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbYGIUIN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 16:08:13 -0400
Subject: Re: [PATCH] libertas: fix memory alignment problems on the blackfin
From: Johannes Berg <johannes@sipsolutions.net>
To: Ihar Hrachyshka <ihar.hrachyshka@gmail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	libertas-dev@lists.infradead.org,
	Ihar Hrachyshka <ihar.hrachyshka@promwad.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <fce2a370807091303m4699e7dbl336eddd86735619e@mail.gmail.com> (sfid-20080709_220315_017163_15F72AF9)
References: <20080709031850.2e7bf50f@promwad.com>
	 <200807091521.04520.hs4233@mail.mn-solutions.de>
	 <fce2a370807091303m4699e7dbl336eddd86735619e@mail.gmail.com>
	 (sfid-20080709_220315_017163_15F72AF9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S4w6w4gsmL0G/B270v+G"
Date: Wed, 09 Jul 2008 22:07:24 +0200
Message-Id: <1215634044.3246.50.camel@johannes.berg> (sfid-20080709_220816_912972_200F297B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S4w6w4gsmL0G/B270v+G
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 23:03 +0300, Ihar Hrachyshka wrote:
> On Wed, Jul 9, 2008 at 4:21 PM, Holger Schurig
> <hs4233@mail.mn-solutions.de> wrote:
> >> Fixing unaligned memory access on the blackfin architecture
> >> (maybe on the ARM also).
> >
> > You can delete the "maybe", on ARM (more specificially, on a
> > PXA255, which is ARMv5TE) I didn't had a problem.
>=20
> Ok, just blackfin. Is it a joke or should I resend the patch with
> another description?..

I'm sure arm has that problem too and sparc and others, but it may not
always show up because the frame might actually be aligned sometimes.

OTOH, why are you getting unaligned frames in the first place? This is
the beacon interval, so it's at a fixed modulo-two position from the
start of the frame.

johannes

--=-S4w6w4gsmL0G/B270v+G
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdRp4AAoJEKVg1VMiehFY3OsP/33K2/Azjzmt4A6zXxJztUSL
7H2ZYSWzKTSpNSxEgsG1OP4Lv5sLRtdfInBmtJmpeS8dMEDIf3gXF12/FxcZtDSZ
bJIGmIGcbTXFc/o+r1deJwFfBn4MFFwruAa1nklrrFyCaCt9rS1vOX0cl90Z5FL+
rmazcVxjgXZRgssFC4AGwU63dx5+tnOTr6IMzXgdNCWlV5TeacO5Oy1ylCz4TrY/
Gb/7vZJBbjl+4yI25NIZ6g1tKQjiIDYuSOQsDWqiRlujPfHti3/5/qlDed0QrjyV
71hpEgsQQ0jWo8UvMK5ipoP7xBEjdSRTJB8zEOtAkI/Wp3UZiItRColRjmbX5ABv
J1tW61+T+GHY09i3CUgR/9aVQmK/P45ot6PDc9axiDpGeq5ECnkjC1xYR3IlGPxW
Z2yRIINKxv54PNS8S3DompQXVk61TBjWOuU4JHRmN7wQEUt96YZqvSR2w09EOAg5
V7OuPCikeHo1Z0s7xoOSRdFQs6QwaVkhHZ8w6v4ZY/PiPG87jGOCfjptDZ2qc2ST
sKOo9Kl6ImqR6YS4pdgxT375l1gzJPJnV4uNExdsUmzWFcRw8qUK9TsIsAKQQTCI
RvfEp8KAD75Ms6zUvdWB5E0GWxCAt1YOWsBsgAe+n2nUUzujof2Q5aBm/ET96JP6
d6He3APEnmxGjoSejCZL
=ZxAn
-----END PGP SIGNATURE-----

--=-S4w6w4gsmL0G/B270v+G--

