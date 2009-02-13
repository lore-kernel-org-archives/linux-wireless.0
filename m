Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60117 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbZBMHRW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 02:17:22 -0500
Subject: Re: [PATCH 6/6] cfg80211: move regulatory hints to workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890902122314r6b9e881cg5538523780e808ef@mail.gmail.com> (sfid-20090213_081438_770752_801CC2D1)
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-4-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-5-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-6-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-7-git-send-email-lrodriguez@atheros.com>
	 <1234508187.1327.19.camel@johannes.local>
	 <43e72e890902122309q61036a23k2efeb14fe3a6e814@mail.gmail.com>
	 <43e72e890902122314m2966471dm3a9485a91e8e927@mail.gmail.com>
	 <43e72e890902122314r6b9e881cg5538523780e808ef@mail.gmail.com>
	 (sfid-20090213_081438_770752_801CC2D1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HyXjG8IoscepqTUebBQV"
Date: Fri, 13 Feb 2009 08:17:16 +0100
Message-Id: <1234509436.1327.25.camel@johannes.local> (sfid-20090213_081726_373100_9C176492)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HyXjG8IoscepqTUebBQV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-12 at 23:14 -0800, Luis R. Rodriguez wrote:

> >>> Yes, but I need to look at the one Reinette posted and fix that one,
> >>> which will probably require a different solution.
> >>
> >> Oh I didn't see that one. How different?
> >
> > I see an rtnl lock issue against scanning and the drv mutex. Doesn't
> > seem to be related to regulatory. So how would that affect a path to
> > move hints to a workqueue?
>=20
> Oh you mean the rntl_lock() and drv mutex is _still_ an issue?

Well, regardless of regulatory, we now have two paths:

nl80211: cfg80211_mutex  -->  drv->mutex  -->  rtnl
wext:    rtnl  -->  cfg80211_mutex  -->  drv->mutex

which is clearly not a good plan.

Therefore, I'll probably have to implement solution (1) from what I sent
you, and invert the locking in nl80211. That would fix your the
immediate problem with regulatory as well, because that was:

rtnl  --->  (regulatory_hint) --->  cfg80211_mutex  -->  drv->mutex

johannes

--=-HyXjG8IoscepqTUebBQV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJlR55AAoJEKVg1VMiehFYq4YP/iB8rB+mpLdtj8UlkR258q9J
xkeqK82V5K0Mb4nYidEWst7ymaPYwYu0E8aGu2NFBibBJr5UjfREyppBosw8RkWG
gzuyWzZ76wMEq1Kz+MnuIkJ8LWioHz9KbbCxdLp2Lay/D42pJi1jbB4n3znPNP++
+JKQphhrDvMBSH7sCdO9ZIUwA0RjIuzZ5YgwmjaB+QzKeD31knn8jf9BzD2TrIwD
qOztELI/SVsgXacgN6kNYGIQ7d1TrhE/CeL6HwA3zY46OYHd7uL0rw5sZWxoxSFF
h8ZzlxZcWtfxUGanv4N8YcukIDbpUy4OP75FDIcR/KLCgBxLCxYsFwhscnIu/0OO
yXPutxzmk0nx4hBiTCqbpLSRp4CQdUgqmh40+DMiVDO64wrj2ZY+JZddp60BD4Jh
lvxlAImiiTDTf/LI8XSxEu+Zun2F2tD/RBwnQqPOKDcsDZG7PWekDlSQ2fVlFRfl
MO0+DL93N0uo543417EXg6gYr+Gg3hmXX5RUIF5fc08Jp0HpgZJ3R/1KI25saLiX
yJP1zsm41WVdl/0BmNe23yy+Tnjd55ZthdSEHieQIQlGDREEFALHiZHWZfmkQmiY
3VBX2r4sqY7Bf9Hk8MR8HNmTg50gM4k65EicZ7NhVQWQaS4Hpa0vGf32wDTrMXwL
AJcNJDuJFA7OnM35SDHq
=q/D1
-----END PGP SIGNATURE-----

--=-HyXjG8IoscepqTUebBQV--

