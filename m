Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39160 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbXLSPpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:45:51 -0500
Subject: Re: [PATCH 2/8] mac80211: A-MPDU Rx add MLME structures
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <c85cb4470712180541l3427454ek94c66b14bb26cb4f@mail.gmail.com> (sfid-20071218_134145_320212_A4A350F5)
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070782201-git-send-email-ron.rindjunsky@intel.com>
	 <1197914893.4885.76.camel@johannes.berg>
	 <c85cb4470712180541l3427454ek94c66b14bb26cb4f@mail.gmail.com>
	 (sfid-20071218_134145_320212_A4A350F5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Gayb8m3qYNbavvt+h+1S"
Date: Tue, 18 Dec 2007 22:18:12 +0100
Message-Id: <1198012693.4885.180.camel@johannes.berg> (sfid-20071219_154556_333825_65E469B1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Gayb8m3qYNbavvt+h+1S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2007-12-18 at 15:41 +0200, Ron Rindjunsky wrote:
> >
> > > +     struct sta_ampdu_mlme ampdu_mlme;
> > > +     int timer_to_tid[STA_TID_NUM];  /* convert timer id to tid */
> >
> > Since you only use that as an identity mapping it can well be a u8
> > array. Not that I like the trick used, but I don't see any good way to
> > avoid it either.
> >
>=20
> yes... that was quite an irritating issue, had to use this kind of
> mechanism here.
> i will check changing type to u8 (need to exmine if it will cause any
> addresses problems)

I just checked, it's an unsigned long and not an address so you can
really pass anything to it. Therefore, I think using a u8 array would be
appropriate.

johannes

--=-Gayb8m3qYNbavvt+h+1S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2g5E6Vg1VMiehFYAQIR8RAAvBu0dY6E8imU+jc5r9mhGY3/QeCfd3uv
XOQvpRVDZnhj3gr5PhAwobo10J9CAQlCUtLWtrK2Ni8JH3w5rDfoM3DxCuwP9CQ9
rMBAKwJSTEKb1Kj3Gwly8tKELKAimXbchLv7uvuZi8JTtalS5c4quLoO89278hAo
/w1QnhDHhA13rjTuI13IF6IAwkEkS5U5/uVxUbCEMmMPnGHl+npOoGTme9tQJS6E
cTgb/VjNtvVNv6Ook38cJ7f4CwTcTXPn5xltaBOuKntoTqDQV6m2Ygg1Ncjl2eD/
7ZFAo0FyBBwZd0WCO0aNOduAE6IjpRdSUDTs1JGhzXHbaRM9HojzqwSUcFh2umf2
Gk4B1hNihShsD+bELX82TWFyPqtavlvifCaj0uGY3PFEvXENf4wVNDdKaSWUtgA5
npqsxNcWfIqWGTbf35Xez/OoqRFvWhjcouxBvwXQj9H9FXP/7ZfIMM/oqB5OrDJY
k2NIrlV0bxiEe0xo9R/PlxK/B2+sP+AR+fNHV0azyxYjMnMDhEyG/MrwK7Tkn9i5
d7gU3XAENeTrC7NtaPWhWsS+R4sKOXO7z13pDmakRdrpi4O4AMnSUVoRHVUrvB9P
GbZZbpOgFnNUftkUeVsXRUmXwdQBu+CZmBbKDn1jTqGrKTRM4KjGBQ8UsU5TF+B9
xL0tMXNQztQ=
=Vryr
-----END PGP SIGNATURE-----

--=-Gayb8m3qYNbavvt+h+1S--

