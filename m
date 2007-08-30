Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757482AbXH3QZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 12:25:49 -0400
Subject: Re: mac80211, iwlwifi and packet injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Andy Green <andy@warmcat.com>, ian <ischram@telenet.be>,
	Robert =?ISO-8859-1?Q?F=FChricht?=
	<the_master_of_disaster@gmx.at>, linux-wireless@vger.kernel.org
In-Reply-To: <1188490617.28908.5.camel@xo-3E-67-34.localdomain>
References: <20070829161655.7f68542c@doppelhertz>
	 <46D5B8B9.8000803@telenet.be>  <46D5CE9B.8080401@warmcat.com>
	 <1188481073.27590.11.camel@xo-3E-67-34.localdomain>
	 <46D6D18F.2080108@warmcat.com> <1188483950.3978.15.camel@johannes.berg>
	 <46D6D759.2050600@warmcat.com>  <1188485483.3978.25.camel@johannes.berg>
	 <1188490617.28908.5.camel@xo-3E-67-34.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gxNbIe2fvJih9zHuM/Pa"
Date: Thu, 30 Aug 2007 18:26:55 +0200
Message-Id: <1188491215.3978.50.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gxNbIe2fvJih9zHuM/Pa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-30 at 12:16 -0400, Dan Williams wrote:

> So that's a b*tch and a half to deal with, when there are multiple
> devices that actually share certain properties (like frequency).  That's
> what's happening with libertas for OLPC, and it's not easy to coordinate
> between the devices because there's no standard way for each device to
> say "I share X, Y, and Z with device A".  It would be quite a bit easier
> if NM could figure out exactly what attributes would be shared.
>=20
> For libertas, everything is shared except for SSID, mode, bitrate, and
> possibly encryption settings.  Frequency is shared, yet they are two
> completely separate WEXT interfaces.  Not fun.

Yeah, I can see how that's tough. However, this is where the wiphy comes
in handy, it's fairly well defined which properties are shared if the
devices are linked to a single wiphy.

> Right; can somebody attach an 'lshal' run that shows at least one
> STA-mode interface and one non-STA-mode interface?  Send it to me
> privately since I want the whole thing, not just the bits for the
> net.interface object only.

Sent.

> I don't plan on making NM talk to hostapd to do master mode on an
> interface for a really, really long time, if ever.  That's better left
> to other tools.  As long as a STA interface _is_ a STA interface (and
> doesn't have other properties like "monitor"/"raw") then this will work
> fine.

Yeah, that's what it should be.

johannes

--=-gxNbIe2fvJih9zHuM/Pa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1u/P/ETPhpq3jKURAonBAJ48EIFl4mu7FybbktL+tUXh5MxFswCguKC1
hL4ktkmpWDMxW+k8SocK1Ek=
=tvSX
-----END PGP SIGNATURE-----

--=-gxNbIe2fvJih9zHuM/Pa--

