Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbYAXO6d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 09:58:33 -0500
Subject: Re: [PATCH] mac80211: enable IBSS merging
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <200801241443.40067.bruno@thinktube.com>
References: <20080118125252.6455.41047.stgit@one>
	 <1201099729.3454.17.camel@johannes.berg>
	 <200801241443.40067.bruno@thinktube.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MZxHhaqzV7+HdXM78o2i"
Date: Thu, 24 Jan 2008 15:30:02 +0100
Message-Id: <1201185002.3454.90.camel@johannes.berg> (sfid-20080124_145836_053150_2C433E46)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MZxHhaqzV7+HdXM78o2i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I think that needs a check "&& ssid_len" or something. Someone's bound
> > to try making an IBSS with a hidden SSID and we really don't want that
> > to work.
>=20
> why? i know, hidden SSIDs are pretty useless but if somedody wants them..=
. why=20
> would you want to make extra effort so it does not work?

Uh, I think you should rethink your question. Consider two different
hidden-SSID IBSSes.

> > > +			printk(KERN_DEBUG "%s: beacon TSF higher than local TSF"
> > > +				" -> IBSS merge with BSSID %s\n",
> > > +				dev->name, print_mac(mac, mgmt->bssid));
> >
> > No way. At the very least you need to ratelimit this.
>=20
> well, it should not happen very often, and for debugging i would like to =
see=20
> this case. would

Well, "should" is pretty soft. It can also be trivially triggered as a
DOS attack by sending beacons with fake timestamps.

>=20
>  			if (CONFIG_MAC80211_IBSS_DEBUG || net_ratelimit())
> 				printk(KERN_DEBUG "%s: beacon TSF higher than "
>=20
> be ok with you?

Maybe && would be better?

johannes

--=-MZxHhaqzV7+HdXM78o2i
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5ig6KVg1VMiehFYAQIuTA//ZP6+nGOmZ1/yzUeyTitVMFKqOgHOFlQQ
fAx1uXgcx9nYA+YMts1UFknO5Tr1Rr6Rva754RITBdPGq6DXx6CjEuf0pIGHnW8C
hDzijEKR5TuSXQE0IDiDyxQrkNpzMroTQtDKgpKww7/uzYY5mfeq+iDm/m9yXzUE
hIbbiS6QFhfzGaOp7EwHp1F4sMzVZx7zxYXX2YIbe3/599q2+iwRlRV4KMUzKlFX
fTEawkVF928EFkag/zFxeWwu5V68lQNDKvyIbVc1Hx3arpKVk4YlVpSBrmaadZj8
o1q07qLshLM0RazCCDPFshe7cLspKFlN5pJRu2MpK744JCl92J96G1oN9UiMuLhG
XCoD7N+yp5wlgVKhUdqshRMlCCbUZZSE3c5nnMR3RWbw+DAUV772DuOWIJKqrwzj
KglXHVvLCEflK7oHCWxITm/ue5jh/VQ12q23WWmHpKT+Ps/YWI01MlK5s4K4S2H4
IsQ2Dil4AxYogE915gEqisJggcXRZi2v9k1AQOqNRoXn4rgLTuttSeZMmHMJLaWT
V8wcb/qf0M53/4wo08blQyQnIwHXtSSnjaBgoNmvDdKg+0vCWuzXNhxczTTVEOg2
YKGrG/fFS2a6oZCCaaNoSrOCUrKyKCJj1LrA3U4JPMVcDUPTs7XTknc/Ba88tCNO
L6IvN2/95dM=
=CDhX
-----END PGP SIGNATURE-----

--=-MZxHhaqzV7+HdXM78o2i--

