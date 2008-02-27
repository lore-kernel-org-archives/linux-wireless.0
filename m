Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbYB0Roa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2008 12:44:30 -0500
Subject: Re: Roaming issues.
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Lars Ericsson <Lars_Ericsson@telia.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <1204133806.11761.12.camel@localhost.localdomain>
References: <004501c87946$e5f1f490$0b3ca8c0@gotws1589>
	 <1204129706.6309.19.camel@johannes.berg>
	 <1204133806.11761.12.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PBgG3Nf1YlZ6BLgMNeO6"
Date: Wed, 27 Feb 2008 18:44:15 +0100
Message-Id: <1204134256.6309.31.camel@johannes.berg> (sfid-20080227_174500_067179_F4C413D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PBgG3Nf1YlZ6BLgMNeO6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Does associating actually block scanning?
>=20
> If it doesn't, it really should.  There's been a number of problems over
> the years with scan requests screwing up association because the card is
> on a different channel and misses the association/auth exchanges.  To
> ensure that association/authentication is as robust as possible, the
> driver should refuse scans while association is ongoing.

Good point.

> > > My patches simply put the mac layer in IEEE80211_DISABLED state and w=
ait for
> > > the supplicant to decide.
> >=20
> > That would break supplicant-less operation which we can't do.
>=20
> Yeah; roaming is an area that's somewhat underdefined right now.  Wasn't
> there previous discussion of a knob to tell the driver that userspace
> was going to handle roaming?  Could be wrong, but the driver doesn't
> always have all the details for roaming and there are times when
> userspace knows better.  Could default to "driver" for roaming and then
> the supplicant could set it to "off" when it takes over.

Well you can set a fixed BSSID so mac80211 won't roam. I think
wpa_supplicant does that, but it still tries to re-auth if it lost the
connection and the AP is in range.

> Which brings up the other issue of auto-association by drivers, which is
> usually the wrong thing.  Yeah, it makes 1337 kernel hackers in the
> woods happier because the card will be up automatically and associated
> with their single open AP, but it's pretty much a bad idea anywhere else
> (ipw2200 associate=3D1 for example).  The driver should only be
> associating when it's told to do so, it shouldn't be going out and
> finding APs on it's own ever.

mac80211 never associates on its own afaik.

> > > I think it would be a good idea to signal to the supplicant that the
> > > operation has timeout, and no further action will be taken.
> > > To speed up the timeout response I had squeezed the supplicant timeou=
t.
> >=20
> > How do you signal that? Make a wext event with the BSSID all-zeroes or
> > something? Sounds ok.
>=20
> Yeah, a zero-BSSID event would mean "disconnected" or "association
> failed" and the supplicant would take over at that point.

Right, that's a simple patch for somebody willing to dig through
ieee80211_sta.c

johannes

--=-PBgG3Nf1YlZ6BLgMNeO6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8WhbqVg1VMiehFYAQJcXBAAmcJjAS6xSJ+v4K9rak+AYVlJHtq6UTjL
i+cyEJmJEKsmREYmeiilzSQmCWxXQel+ocC3blRFtt/mQP9aRQX2apBaLLvMhvJA
OfvyX4zHsZAqhN7XT0125469tNyQD8opaLJkFZVA88h1IGuO/+dAXxoMqZ2oZVpY
732COkrWAKJWQ6gsIWkAj/7SJAofJC8vmkzvfjAiF7vafD5kqXTT7iCMbjJq2wOA
X+DJscaFORF0xVG4bGcPLCro67gkc/okuaG2CmbmdqN+WO4rRaFvxSiZGs1hlt4Q
2g1Lk2bpvRDmbSnkLwqUoutSsAt8CFvu2PWuyWxyuaKFy2GInHMvctiSsVY+tkzO
DxCND1TjnzjXpOxZzNZxHUZoV7200IntcWMn8wBIMSmIXVbU6fHbrzx0JWiJ1Hbr
VubGaiNtogKshCEvFXDOmNhwQ0TUzMR3GOqEVP0HEwKL3NA2JvMsvCi3vFuJq4BR
U/QpWuPHbhqJ3nbkpWyu4iOlW5qE3WLqlll/tYfPAXlsYlj1D/6Wm0pCSIy85462
iZCqyCOBw191b8pUZvF9afdtuH6gGzlhCvC+FP2bs+TPcICR0z5TqYnVtAzAR+Lr
mW6VLhPllVp8jbXxrccF7JNqHAhMPKhvSIsjbVggtKUGn29iWwxugqRjEIUq3GJB
6mJrbYPvRas=
=+Qv5
-----END PGP SIGNATURE-----

--=-PBgG3Nf1YlZ6BLgMNeO6--

