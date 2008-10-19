Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37385 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbYJSQsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 12:48:14 -0400
Subject: Re: Power saving on mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <871vyc7st7.fsf@nokia.com>
References: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com>
	 <87bpxh6t1n.fsf@nokia.com> <87y70l59p4.fsf@nokia.com>
	 <1224412006.6324.45.camel@johannes.berg>  <871vyc7st7.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2iKkbKQSR5zyyw4fXiKm"
Date: Sun, 19 Oct 2008 18:48:05 +0200
Message-Id: <1224434885.6324.49.camel@johannes.berg> (sfid-20081019_184841_588707_5C3C2BCC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2iKkbKQSR5zyyw4fXiKm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-19 at 14:00 +0300, Kalle Valo wrote:

> > Then add a new flag to mac80211 hw description that says "driver will
> > watch beacons". This means that the code above that rearms the timer fo=
r
> > the future 'nothing from AP' check is skipped.
>=20
> I will. I need to check that if the "firmware beacon watch" is enabled
> only when PSM is enabled. If it is, we might have to make the flag
> dynamic.

IIRC it's a separate flag.

> > Also add a way for mac80211 to tell the driver after how many beacons
> > (or calculate the timeout in ms, it's convertible) it should tell
> > mac80211 about the situation. Finally, to make it possible to have the
> > driver tell mac80211, extend the MLME callback (ieee80211_notify_mac)
>=20
> The beacon filtering in stlc4560 works so that a beacon is passed to
> the host only when the TIM bit for the AID is set.

There's also a beacon checksum feature which we might want to enable,
just in case the AP ever changes QoS parameters etc.

>  There isn't any
> timeout for delivering beacons to the host, if the data path is idle
> for 24 hours, mac80211 will not receive any beacons for the 24 hours.
> I don't see why we need a timeout here.

Right. But we need to program the chip to tell the chip "hey please tell
me if you haven't seen a beacon in X seconds".

> I believe that there's also a feature in stlc4560 that the driver can
> provide a checksum of the beacon and the firmware will send the beacon
> if checksum doesn't match. But I don't yet know how that works in
> practise.

It seems to be a firmware feature, first beacon from the BSS the
firmware computes the checksum, and if it changes it lets the beacon go
through and re-computes the checksum, so you see all beacon changes.
Maybe it excludes the TIM. I think we want this for when the QoS
parameters or something else changes.

johannes

--=-2iKkbKQSR5zyyw4fXiKm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI+2TBAAoJEKVg1VMiehFYhkcP+wV3KYovycv3fNupUKg+1px4
8jEJozt8riWZz0r5IzyrTpUoFRjtvpqrqN/DEt+Cb7PCZCaIz8LxIJLjCd0Nu/AU
BGiULEcTJWAy/6F8kamBTp5L4zymQB6ljwLxLpA75itudmU1GlFrEfpJPYq4FpEl
MvUa5kBjpCsgk2tU3DK5XPenTVSlrRYKbccNW2W4r44E4Ocm3ziS829xPQu0FPxv
0k5N6oKNvUzi+Hc3aTigO6RletrlqAy8UFfaDWSTabXskKw0VO+UraNFrXYntD+/
kQFhX/1Mr10BLbDeO6csSzAm3u0sWM83ACGKXmvC0TdLPntLMbYq2Np/U1rJNZYK
Wn0Zln1gwddlES6//N1g6ztRuWBFhVH7ywMzmAfWLUK+TqQcGpusvokmUo/H3/tL
BTHelEf4ENPbzuvkUFLZknZUSQZdrW6KM8KtE/E/s7gXPxdRXv0GZXbM0NlR9xUm
hfc8bLI70h3wU6spPDM4aeeW4nb4Vjq8zM3VFUMxF9e65unqM19D7+4o3E9vr3AZ
AOTvNFR5JTV/PXMDa1UumfCW+jT8ajhf5bXYcYtnTmAIlCHO3Sy1kFprhjW7YDeM
Zp0rf/li8ptQMDs/qZHPmW6KpBChIETerdKkFHynW23L+qF/W4nOikUrvhk9HNVm
Ry5a1Slq8ppyPfWhp0U/
=AsC5
-----END PGP SIGNATURE-----

--=-2iKkbKQSR5zyyw4fXiKm--

