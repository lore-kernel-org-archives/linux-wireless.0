Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43942 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbZCKNsk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 09:48:40 -0400
Subject: Re: configuring while interface is down
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, samuel@sortiz.org, j@w1.fi
In-Reply-To: <20090311134329.269810@gmx.net> (sfid-20090311_144435_584837_2198C4E4)
References: <1236774973.20266.13.camel@johannes.local>
	 <20090311134329.269810@gmx.net> (sfid-20090311_144435_584837_2198C4E4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dPU/p61PNCT0BjQMVn3a"
Date: Wed, 11 Mar 2009 14:48:34 +0100
Message-Id: <1236779314.20266.22.camel@johannes.local> (sfid-20090311_144923_590405_4CF18CE0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dPU/p61PNCT0BjQMVn3a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-11 at 14:43 +0100, Alina Friedrichsen wrote:
> Hello!
>=20
> > For cfg80211's assoc/ibss calls, I think we should reject them outright
> > when the interface is down, any objections?
>=20
> How should assoc in cfg80211 work?

see Jouni's patches.

> For WEXT I like collecting all changes while the interface is down and
> the if it's up again apply them in one step. That is the reason why I
> want call "*_commit()" on interface up.

which is what we'll continue doing in cfg80211, but I think we shouldn't
bother the driver/mac80211 with it until the netdev is up, and thus
reject things from nl80211.

johannes

--=-dPU/p61PNCT0BjQMVn3a
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJt8EwAAoJEKVg1VMiehFYvyAP/3phgqr3Kv2TGskvF5CQHPHs
eUOJJ1pn72qqX2Z08Q9QZxHP21+/lVS3KNRh0qAXc9JRyfHbMMqFHn/XEkd0thb/
P5pgDKQ+fTDM/bEoKXZLktYK9O/t1y4QnsONHyB/U4vESAvttfTux3tNIq7MZgk6
pIcwRbIBSnbtKQE3X9tBOS3IUtaN2EXX6B3Jo56+zNzESPrAueI39w7zcM9su3zX
Oh//sXVbMRwQpi583ZJTrhtY7t5SA67oUbaolF98KE2NuA36WgSuBJ00as5gojCs
ttuqbyR+Thi0vsCqvC1/hyZ8eh1sMn79XhFIpJO+FJ7q2BYe6TVMyo6/l6oM3Boy
aOmWFar4wD/qnsPaAndmBm3v1rKdX6XLJX1d/EVEorzsnVlNWY45zl2P4ivg2JqE
/oJIyJYUoLi6yUfvXeMIkSGCBu/4gDj4umjKza4xSXj4O4FXOMQqlmwtqSenMul7
x2yEGH0tUDPJc064lZ3cCtkCPgbVTGVczEXkCtDC21pAcaZFPWpTyXUUqguXK6Cn
ZzCXK/BjKKzQX2klK/6gWnCVmNkVdMczm3lSflK4NV1qUY0uSdpXO5+DEs7QlX0E
yWmSpluvpAfxgRbt3qKmCovB0EXgghMUyHvo0ZWOaMDjTnPJuClx7jkXzGDBZZMU
xjvTleoPzU9V7MkZNp61
=oQLr
-----END PGP SIGNATURE-----

--=-dPU/p61PNCT0BjQMVn3a--

