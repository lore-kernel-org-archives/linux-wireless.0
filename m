Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47692 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbYKNXOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 18:14:36 -0500
Subject: Re: [PATCH] mac80211: don't assume driver has been attached on
	registration
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <b6c5339f0811141505u1f8c7c3hd6858ebe21cc10bb@mail.gmail.com> (sfid-20081115_000539_525567_2666AA21)
References: <1226702662-29694-1-git-send-email-lrodriguez@atheros.com>
	 <b6c5339f0811141505u1f8c7c3hd6858ebe21cc10bb@mail.gmail.com>
	 (sfid-20081115_000539_525567_2666AA21)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IVUf38TDttmBQr8yU+bJ"
Date: Sat, 15 Nov 2008 00:14:24 +0100
Message-Id: <1226704464.4120.32.camel@johannes.berg> (sfid-20081115_001440_412936_FF30A2A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IVUf38TDttmBQr8yU+bJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-14 at 18:05 -0500, Bob Copeland wrote:
> On Fri, Nov 14, 2008 at 5:44 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > mac80211's ieee80211_register_hw() is often called within the
> > probe path so it cannot assume the device's driver structure
> > has been attached yet so to create a workqueue instead of
> > using driver->name use the wiphy's phy%d name. The name doesn't
> > really matter anyway.
> >
> > This should fix sporadic oopses found when we race to beat the
> > driver pointer setting. Not even sure how this was working properly.
>=20
> I'd still like to identify the race first.  This patch won't hurt
> anything, but I'm not confident it will solve any problem either (the
> pci_dev->driver setting I was seeing after probe was for a different
> struct driver).  Also it could make the bug harder to track down.
>=20
> In the reported case, wiphy_name will be empty string which isn't too
> helpful for the workqueue name either, though it probably won't crash.

That can't be right! wiphy_name is assigned right in wiphy_new()!

johannes

--=-IVUf38TDttmBQr8yU+bJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJHgZNAAoJEKVg1VMiehFYjkYP/RSMJq6xLQnsl39ohvCQMoLI
zzNXAvOX//xvP9cLYVWJ6p/qMTIUuSArhzDHFX8qLK73JhBZBsX4WXgwkrB9Zq1K
kOwiZNJnVs9BTqz+gGD8fhw7a/KaMGCehWFWfHXpB/tNEoyzy6RBl+Hh0DDkrlya
AEpYuHrZ1R86Tb07p6fsWYhEW1odlr/nYxP3b1j4yFLL/5RzpPBYJHtWyzAFn14z
R+MfJhIQxQSpbygdKg7A05r2f57cgWfZqnSpfcwyBnLf/c0ariu6iZYNpRemTpw5
PekJ7AsE5Dk9k+DFHdV4bSNgXxBO4jrcOne24zD4ljs51UILcK48406m2R5QiNA/
uL1qD3dwhEUXId1T5GBH4zHZNDy7q4MENvGf+VZPSQnSezyQ06DMJUi6Ay8AZYaN
990UIGwpFs0zmz0rfnMZdMMxhbYLSRf7M0r4IY6LMtzDVubs9FSXcHeT9bTsW60i
8WvYA4/qNJq18KDnthyy/UCANAvA2teYQojnOYQPuMUnnYhjRUE9oRDBgwp+spMC
gaPUhBnZYkNJJ4L2HLxfcIPdildricJIgXPNLcZG6Hvnll+Vo4R2dyrTO+F6+1zZ
y8MlhZ8sevAF/fOU1A3flFDr4pq4cpkxOaW8X1XF9TwkezochKTcZp+Yh1Qel4rw
LDIX8kidCP+mulM5tqQF
=2O/P
-----END PGP SIGNATURE-----

--=-IVUf38TDttmBQr8yU+bJ--

