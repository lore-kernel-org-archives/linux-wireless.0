Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbYFLH0q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2008 03:26:46 -0400
Subject: Re: [RFC] Do not activate promiscuous mode on wlan interfaces for
	bridging.
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org, shemminger@linux-foundation.org,
	j@w1.fi, bridge@linux-foundation.org
In-Reply-To: <1213232760.6645.24.camel@localhost> (sfid-20080612_030607_332834_1EFDE126)
References: <1213232760.6645.24.camel@localhost>
	 (sfid-20080612_030607_332834_1EFDE126)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FLv19E992uvl+MJRqMXj"
Date: Thu, 12 Jun 2008 09:26:10 +0200
Message-Id: <1213255570.3871.8.camel@johannes.berg> (sfid-20080612_092649_533808_7FE64D86)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FLv19E992uvl+MJRqMXj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> It seems that it is not really necessary to activate promiscuous mode
> when
> attaching a wlan interface to a bridge, and it causes unnecessary
> processing
> overhead to any wlan device.

[...]

> Given this three cases, the best would be to consider case 3 to be not
> supported (it is indeed not supported, AFAIK), and apply the patch below.
>=20
> Please let me know what you think of this patch and whether it could inte=
rfere
> with any functionality.

All your description makes a lot of sense, but I don't see why altering
the bridge code is necessary. In mac80211, we decided that the "promisc"
bit only means to capture all frames in the current BSS (remember that
in ethernet there is no way to capture frames from different LAN
segments) and hence an AP would not behave differently in promisc mode
at all since, by definition, it sees all BSS traffic.

What exactly is happening when you run into this problem?

johannes

--=-FLv19E992uvl+MJRqMXj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUM+OAAoJEKVg1VMiehFYMOMQAKk3cwZMBEPy0FV3wWOBQ3O/
jS4+gPSmmQIQbUgEVZDAnxa/uX6xAbrhT5MMHb9Wd85LScbjLy83u5fFz8XRMNDH
k4zn3dkzvebyHkQ1sr53Yi6pymTUkmMBhjZb7JyBUo1d+jTlqGoUFi5GNl6SrEOb
aVyYayFBZaoMrprKSfaLuxiAFHy/qxskZS60t8iWxkNy0JyBQQkOiN9qzX3eDIbE
CY4Pq/Fd813p8NOekTeDbRe3kgjL/fj+Q3vn8KrlS2SAulbxIDVVRhVOXKt7xmnm
IBf//O9IlCqEezee0Y564PFHOE01PfRUapaRwapFXuYXCguzKaFYtUppLYb2kuNZ
13TkTVVL0yKaKz26XKiTA+iumn+p/L6jyQQJ/8fkbrQLeyRNqk4ceyrRzR2lc6re
9gi1+G87eS6eC5paetM3dRf5EyXP6GwizPx3B7Bm2oDCNQHXXkluUjuBMsiCP2ay
C5wv3NXueLQxelo7+mZ48T2eO+LFNluz/tNP6k0PpdQCCMrQE7/14E9kPE0fCeyZ
m77XvsMEUyLcrfRl9E25WZbClusCdxXwww6lRca2HTjkIV/gpwp2ZD2AeH08HiJz
P4rLPdaEwEplLF2R12ncsfUcjyiZpXJUpH/+zqTMaVTvV+Jy71nKJ2+OrlZJ+pnO
nQtZxHa2KNeP5OD+X+Co
=v2aN
-----END PGP SIGNATURE-----

--=-FLv19E992uvl+MJRqMXj--

