Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53238 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbXC2LN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:13:26 -0400
Subject: Re: WPA/RSN information in cfg80211?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jkm@devicescape.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <20070328190017.GI6036@devicescape.com>
References: <1175034846.5151.20.camel@johannes.berg>
	 <20070328190017.GI6036@devicescape.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LQXB6uDZuDU5PB0Q0j5g"
Date: Thu, 29 Mar 2007 13:12:19 +0200
Message-Id: <1175166739.8807.46.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LQXB6uDZuDU5PB0Q0j5g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-03-28 at 12:00 -0700, Jouni Malinen wrote:

> Use of WPA/RSN IE vs. individual parameters depends on the driver. For
> example, NDIS drivers generate the IEs internally and need to be
> configured with the key management (WPA-PSK, WPA-Enterprise, WPA2-PSK,
> WPA2-Enterprise, ..) and cipher suites separately. They would not use
> WPA/RSN IE at all. Some drivers use the IE so that kernel code does not
> need to have all the code for generating it. They may (or may not,
> depending on needs) ignore the individual values.

Yes, I know that much.

> > I'm inclined to just require userspace to put both the IE and the
> > individual settings into the relevant nl80211 messages, but then we
> > might just as well piece the IE together from those settings, no?
>=20
> As long as the information is available for the driver at the time of
> association request, it does not really matter how that information got
> there..

I'd have thought you would rather see the IE included to be able to
experiment with new things easier ;)

I really can't decide which way to use. Piecing together the IE in the
kernel and then just passing it doesn't seem like much overhead, but
doing it in userspace gives us more freedom for experiments...

johannes

--=-LQXB6uDZuDU5PB0Q0j5g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGC58T/ETPhpq3jKURAhxrAJ0cveux5pWhNdZ72GqfXybo+Gc8uwCfaSUI
3Scb63pwT1SYJ5M5X9+WgXs=
=apQL
-----END PGP SIGNATURE-----

--=-LQXB6uDZuDU5PB0Q0j5g--

