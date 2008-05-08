Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42633 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761526AbYEHXU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 19:20:29 -0400
Subject: Re: iwlwifi and tx info in skb->cb
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1210288662.3547.85.camel@johannes.berg> (sfid-20080509_011655_234582_DBEBB846)
References: <1210197711.3547.1.camel@johannes.berg>
	 <1ba2fa240805071629i6c7336f6y61a7c9690820ef5e@mail.gmail.com>
	 <1210203054.3547.12.camel@johannes.berg>
	 <1ba2fa240805071721i3d1e3258s1e8c024c4cae9239@mail.gmail.com>
	 <1210255522.3547.48.camel@johannes.berg>
	 <1ba2fa240805081507j7cf991ffo5bae443b0b77a39e@mail.gmail.com>
	 <1210284656.3547.76.camel@johannes.berg>
	 <1ba2fa240805081528t45d7810cjfd553bf99daff096@mail.gmail.com>
	 <1210285845.3547.81.camel@johannes.berg>
	 <1ba2fa240805081616l3f49d770pefd517076a06b3ef@mail.gmail.com>
	 (sfid-20080509_011511_095937_36DE1999)  <1210288662.3547.85.camel@johannes.berg>
	 (sfid-20080509_011655_234582_DBEBB846)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MJptV3DtjRSVXN2U83bU"
Date: Fri, 09 May 2008 01:20:15 +0200
Message-Id: <1210288815.3547.88.camel@johannes.berg> (sfid-20080509_011926_539761_F07ADB9D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MJptV3DtjRSVXN2U83bU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-09 at 01:17 +0200, Johannes Berg wrote:
> > >  That's not really related to wireless at all, if you want to do
> > >  zero-copy IO then you need to checksum when the stuff hits the wire
> > >  which means out of hardware buffers, which some hardware (including
> > >  802.11) doesn't support so you need to copy, nothing wireless specif=
ic
> > >  here :)
> > >
> >=20
> > The FCS/CRS checksum of the wireless packet is performed in the HW but
> > why should I care about IP layer?
>=20
> Because the data you're sending is sent via TCP?

Basically, it boils down to this:

If you want to checksum the data in software then you need to checksum a
snapshot of the data and not allow the application to modify it after
you have checksummed it, so you need to make a copy and then checksum it
after copying. But if you're making a copy anyway, you can put it all
into one buffer too.

johannes

--=-MJptV3DtjRSVXN2U83bU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCOKrqVg1VMiehFYAQLOSA//X5FsODZFmBhq5MbyV6Yo0O2OlQ9GbjnX
petlEbnmC31wOQ8jDCSHAk9I9wtNKXOS97n+BKk0Ev/0MBJq4X6gKz4MWru4uUYW
xV9fAiHWYeA0NXNXt6F9he94yM3dgrN6h4Z7xRh8So5M6zAf41bWPMCT/q/FS/Eh
kSyNkxrrAvvPrYFGJaO0bqZ74wyNzUP2vMfEJEyy+t2M7xsjhsB2ulHpIdl5R22e
ZvRn6IrMAj9Dtg/as9LzoHpGt58hBAdndB+TVSM2GcRkpm8gk5vzI5a0dAs/9Xtl
t4r0xw4FOWVauDo8jujOGhOkKhbBQFGTNJWVw7P3nod9jOadMSsOWlsiu+GWcSCj
ukwG2lHTbQiett9o9sEBcc8rp/H+hF0f/HEsUyVZoqlKImit8cxACg36l6jlxBKN
KglOBk6qb2CT6VKX44VyBQcMR4pdFDoUZ6NRWZpDudM9rgQCTrzvrk0oxmSUehts
2JWpwkMr5eQCSViCrlLEclBxQUkoDZIg7lcdF/RFQWrSJ3m21Who942QQ9h5pZZ3
Z2a/FxeH0reCOAz8sPApzZM7TwBpJ4VaYTffVNBYa+drGO9R0KtphOzn3MgVsCuI
zEJ2mdNDwp/vPEjqvFhwLNGvz66aeBKOfAtw72AvCGRUXicHqFbI59xUudxd050N
YVYLWfEF830=
=Iwir
-----END PGP SIGNATURE-----

--=-MJptV3DtjRSVXN2U83bU--

