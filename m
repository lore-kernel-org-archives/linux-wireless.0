Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36039 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757421AbXLPWj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Dec 2007 17:39:57 -0500
Subject: Re: b43 problem with led trigger registration
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1197844359.4653.39.camel@localhost.localdomain>
References: <1197822019.4138.2.camel@johannes.berg>
	 <1197837505.6769.25.camel@johannes.berg>
	 <1197837799.4653.21.camel@localhost.localdomain>
	 <200712162157.00759.mb@bu3sch.de>
	 <1197842962.4653.27.camel@localhost.localdomain>
	 <1197843464.6769.43.camel@johannes.berg>
	 <1197844359.4653.39.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Wf+iesmmZYzhUEczWBkF"
Date: Sun, 16 Dec 2007 23:39:52 +0100
Message-Id: <1197844792.6769.44.camel@johannes.berg> (sfid-20071216_224001_496941_CC9947D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Wf+iesmmZYzhUEczWBkF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2007-12-16 at 22:32 +0000, Richard Purdie wrote:
> On Sun, 2007-12-16 at 23:17 +0100, Johannes Berg wrote:
> > > Eeek, yes, its the LED core's fault.
> > > dc47206e552c0850ad11f7e9a1fca0a3c92f5d65 is needed for various reason=
s
> > > but that means the patch below is also needed. Its been compile teste=
d,
> > > once its runtime tested I'll push asap.
> >=20
> > Any reason you're using an rw semaphore rather than a simple mutex?
> > Nothing here is a hot-path, is it, and the led registrations are
> > mutually exclusive anyway, no?
>=20
> With a rw lock, the for loop of the trigger registration can happen in
> parallel with other trigger registrations. This case isn't a hot path as
> such but it keeps consistent style with other parts of the LED core
> where rw locks are used in hot paths.

Ok, just curious really, nothing that I really care about :)

johannes

--=-Wf+iesmmZYzhUEczWBkF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2WpNqVg1VMiehFYAQLflhAAta8ZcPc7CrIq2TlToeEhQJKUVxP0x0oj
g0TOzVn9jviF8l1d6qlNlrXD0f3o+pemAM3WwwkSAeghBLc8aGtFS4oiX9dJ6Gi8
jWjTG8w7IakqGZf2SEEuIIoFqF3tHfQXNPzRvPKXZOT54oleIrIKmExwowhKLWau
yN1cgeylrNTklA+DIadFSyVz3vBjjn7/IYcMan6Yjv+xnrKnM0pPrYXZveLGKIUp
pK3LMeL4KZD/KsSEQl6Adn98lC83ZRf8hfTUwB2rYy0ulAMJY8A6JLRESV4dMEnu
WQqiqE6Nj3yowTPE7nzsGnWzHlcRr2KzbS6+KOqBefSY/FOZdua20yeCvagkoAgE
aNjkR+U8HqmQMB78riBeGnQqZ4jmuppXsQohqrWTFr4YbMLL72QcrHtmVi9/finW
BpIowDUt/xtCIdtC5ce7VH1nzMkez2ujybVIYST2zKTX1Q1Kg0pucxH0EIj/qwLI
rVj28/R+u0XEAHC1dQYGSnWzALWQXhQIe+/u3ACqj7Tf7OoRAFtYAHX/ja7YezOA
PiKgELXCAQeWm8U75OmZlH8Vch4Rkq3x+auuRDjNFxj6XQZqWuGD+/8//Otqt0gs
LeBOH7ezyILWjOzqvxJI51EWaGOR2q7fJDso8QBOWVgpE4XMLNPioIwD0xvfC7Qs
VTIPhAEXM6g=
=kDN7
-----END PGP SIGNATURE-----

--=-Wf+iesmmZYzhUEczWBkF--

