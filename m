Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47475 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767246AbXDTUvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2007 16:51:15 -0400
Subject: Re: [PATCH] wext: allow wext users without rtnl
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: shemminger@linux-foundation.org, linville@tuxdriver.com,
	flamingice@sourmilk.net, linux-wireless@vger.kernel.org
In-Reply-To: <20070420.133257.32722308.davem@davemloft.net>
References: <1176825010.3902.28.camel@johannes.berg>
	 <20070418140451.075370fc@freekitty>
	 <1177098521.5902.20.camel@johannes.berg>
	 <20070420.133257.32722308.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6EchTCA8ofjZxyVd3tV4"
Date: Fri, 20 Apr 2007 22:53:42 +0200
Message-Id: <1177102423.5902.38.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6EchTCA8ofjZxyVd3tV4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-20 at 13:32 -0700, David Miller wrote:

> > Then again, holding rtnl in cfg80211 would simplify some things because
> > we could pass in a netdev pointer instead of the ifindex for example.
> >=20
> > If you think I can justify holding rtnl in cfg80211 I'm certainly
> > willing to change that. Global locks are just too suspicious to me ;)
>=20
> It is true that things like IPSEC configuration via xfrm_user.c
> uses it's own mutex, so there is precedence for splitting up
> the locking where things are truly seperate.

:)

> But changing things like MAC addresse changes, which you mention, do
> fall into the existing scope of the RTNL semaphore.

Actually, just thought about mac address change again, it is only
permitted when devices are down anyway and at that point nothing can
race since wireless devices that are down just store configuration for
when they're up (or ignore it)

> If it simplifies things, all the reason more to use it for cfg80211.

A few places could use a netdev pointer instead of ifindex but I don't
feel it's much of a simplification for callees. This is only an issue
for two or three calls that cannot hold a netdev reference because the
device will be removed by the driver/stack.

Since the discussion came up due to dropping the rtnl from wext I think
that it may be beneficial if we added rtnl locking to cfg80211 now to
simplify migration away from wext which holds rtnl and then revisit the
locking when we can drop wext completely from the mac80211 code. That
would allow us to revisit rtnl locking for wext when we have completely
migrated to cfg80211 and wext is only handled through cfg80211.

Does that sound like an acceptable way forward?

johannes

--=-6EchTCA8ofjZxyVd3tV4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGKShW/ETPhpq3jKURAnUSAJ4sQ2cnXKrQmnMYiM4DjQERaQgnuACfcvn8
fX8uPN8INcZzZsOaxKRAj3A=
=zHhL
-----END PGP SIGNATURE-----

--=-6EchTCA8ofjZxyVd3tV4--

