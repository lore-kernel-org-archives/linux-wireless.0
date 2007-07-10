Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42212 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075AbXGKJjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2007 05:39:18 -0400
Subject: Re: Setting channel when interface is down inconsistency
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Jon Smirl <jonsmirl@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1184005862.5671.2.camel@xo-13-A4-25.localdomain>
References: <9e4733910707090759v5cd20f2en1f6c4e6fc6279b3f@mail.gmail.com>
	 <1184005862.5671.2.camel@xo-13-A4-25.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sGXV2hrdb5ROHYxwKe3j"
Date: Wed, 11 Jul 2007 00:50:50 +0200
Message-Id: <1184107850.3738.20.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sGXV2hrdb5ROHYxwKe3j
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-07-09 at 14:31 -0400, Dan Williams wrote:
> On Mon, 2007-07-09 at 10:59 -0400, Jon Smirl wrote:
> > bcm43xx and rx2x00 let me set the channel before the interface is up.
> > zd1211 requires the interface to be up before setting the channel.
> >=20
> > Is there a guideline for how this is supposed to work?
>=20
> In the ideal case, the driver should allow you to set any _attribute_
> when the device is down, but if you try to do an _action_ that requires
> that the interface be up (for example, associating), it should return an
> error of some kind.
>=20
> So setting things like encryption key, channel, ssid, bssid, etc should
> all work when the device is down, but actually issuing the 'iwconfig
> wlan0 ssid "foobar"' can be expected to fail because in WEXT that is
> supposed to trigger an association.
>=20
> Splitting up this stuff and having an explicit association request in
> nl80211/cfg80211 should make this a lot clearer.

In fact, the way it's planned now is that you can't even give it an
ssid/bssid etc. without also triggering an association, but contrary to
wext you do pass all parameters at once and when needed.

Hence, this will not actually solve the problem per se, we could make it
a requirement either way to document it (though in fact it'd be simple
to return -ENOTCONN for every configuration request when the device is
down) but setting the channel for example isn't actually any different
than with wext. Therefore, I think we still need a guideline. Do you
think setting everything when the device is down makes sense? Then we'll
have to document that drivers must accept these requests and honour them
when the device is turned on. Which is actually another thing we need to
make absolutely sure, when the netdev is down the device should be
turned off.

johannes

--=-sGXV2hrdb5ROHYxwKe3j
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGlA1K/ETPhpq3jKURAjJSAKC5RKndfLo9wpn1ryfK/ArbJrZQSgCbBEWr
OZ715EBQxRDdosHrdKXeP6A=
=ywDl
-----END PGP SIGNATURE-----

--=-sGXV2hrdb5ROHYxwKe3j--

