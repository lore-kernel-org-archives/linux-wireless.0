Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56945 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbXHHJTE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2007 05:19:04 -0400
Subject: Re: further plan wrt. monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Ulrich Kunitz <kune@deine-taler.de>
Cc: Daniel Drake <dsd@gentoo.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070807220341.GA24236@deine-taler.de>
References: <1186178959.13315.30.camel@johannes.berg>
	 <46B3B2AD.1040509@gentoo.org> <20070804074616.GA17144@deine-taler.de>
	 <1186395427.28655.56.camel@johannes.berg>
	 <20070806212300.GA14347@deine-taler.de>
	 <1186480002.4067.28.camel@johannes.berg>
	 <20070807220341.GA24236@deine-taler.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2hlmU+4qZFXypg4VnjOj"
Date: Wed, 08 Aug 2007 11:20:54 +0200
Message-Id: <1186564854.11717.14.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2hlmU+4qZFXypg4VnjOj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-08 at 00:03 +0200, Ulrich Kunitz wrote:

> > Aha, but they're not fully compatible. First of all, you were talking
> > about multiple MACs which isn't something we're going to support
> > (multiple MAC addresses yes).
>=20
> I would state we should the support the functionality that the
> device supports. Everything else is "form follows function".=20

But we don't have any devices that have multiple MACs. Yes, we *do* have
devices that support multiple _MAC addresses_ but I don't think any of
them support multiple _MACs_.

> > Secondly, a WDS and AP interface will be
> > running with the same MAC address but have quite different
> > configuration. Thirdly, always doing lookups by MAC address (even if it
> > were possible which it is not due to WDS vs AP) is rather inefficient.
>=20
> The MAC address lookup issue could be handled.=20
>=20
> Assuming that the device would be able to create beacons on a
> specific MAC address, would it need to know about WDS or AP mode?

Say it supports multiple BSSes on a single AP MAC address like many APs
do. Then we have to look up beacons by BSS and other things by MAC
address and it really gets confusing quickly. I think that abstracting
it all down to BSS IDs and MAC addresses gets rather confusing because
the driver authors are also users at the other end and adds interfaces
for testing. If they can see the effect of adding an interface I think
there's a better chance of understanding what's going on.

> Beaconing needs to be supported by the device.

Yes, but how many different beacons does it support? That's something
easily solved by limiting
 1) the number of devices to the number of MAC addresses supported
 2) the number of AP devices to the number of different beacons
    supported

When you start abstracting it down to MAC addresses and BSSIDs these are
IMHO far less clear.

In any case, you're welcome to implement such an API as you're proposing
to demonstrate the feasibility and ease of use. But you probably should
first understand what is possible. And please don't confuse "MAC" and
"MAC address" too much.

johannes

--=-2hlmU+4qZFXypg4VnjOj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGuYr2/ETPhpq3jKURAqnHAJ4sUciN0l4y6bVYCsCuUtkZIWlBmwCdFwbz
5e3BkifbVgKaVnwfX344uxQ=
=qd6u
-----END PGP SIGNATURE-----

--=-2hlmU+4qZFXypg4VnjOj--

