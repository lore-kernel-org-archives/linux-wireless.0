Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbZDGTaB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 15:30:01 -0400
Subject: Re: mac80211: changing number of queues in ops->start
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
In-Reply-To: <200904072024.41910.mb@bu3sch.de>
References: <200904072024.41910.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-gA1auIjvcpQ8u44beNEZ"
Date: Tue, 07 Apr 2009 21:29:27 +0200
Message-Id: <1239132567.7187.1.camel@johannes.local> (sfid-20090407_213008_420261_482587B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gA1auIjvcpQ8u44beNEZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 20:24 +0200, Michael Buesch wrote:
> I'm wondering how to implement QoS capability runtime detection
> in a mac80211 driver.
>=20
> In b43 we don't know at ieee80211_register time whether the firmware does
> support QoS or not, because it's not loaded yet. (Reasons for not loading
> it that early are issues with builtin-b43, etc...).
> So we don't know whether we are going to load opensource fw (no QoS) or
> proprietary fw (QoS capable).
> But it seems that mac80211 requires to set hw->queues before ieee80211_re=
gister.
>=20
> So what I'd need is a way to change the number of possible queues from wi=
thin
> the ops->start handler.

Well, I suppose you could register with the max and later reduce and
stop the remaining queues you're not using... Or not stop them and drop
packets on them. That's somewhat fragile, gives people who look at tc a
wrong idea, and I can't imagine supporting it, but it should work.

johannes

--=-gA1auIjvcpQ8u44beNEZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ26mVAAoJEKVg1VMiehFY4XwP/i64qd2wUbf/ql5oB5nW7TCw
okK6ZadN+Gr5vHAdpmvf1ztmvP/zxvqA3wDlc1+phGTjOeVzkfoRBrnF0fbCx8dN
DDUL77yZHdUbsWQoYMNFADFjukh9R+cclRxJ10S+uIO4m6cP6u09gBSA8QqFdx3m
2MqhIu4vZhokx3tHoC3IlGDUu1lkdrzel5Croo0UkKXEEyNazk2RsaYmOlwXgXNB
BoyFNMUf/B5Cv+m2pW0bkAF34N7ZJpNYE6jPN6fu8JRCrXA4eVs6c3/vs2YFsLTr
Pxq9fvxkrVGIevXcioeWdM2xCwQ0JyRuHRNWZpTfZ4+aAyRvlKm2Oyy/sN18W9AE
olDlLACyUnaoA6AiazeBuQptCOYKdSlUUBUJcQb5+KAWjST6Vd2ojFzwaO7cl2d0
5blZxIKZHljgVsoPc98E0K9/YMuFHvnht2TzHOHa0hAzg8KJK2nJUpVPI+YgrFnP
YtgGNA0JFVK+pez5J3g/EegYLcypAPY+eeKR3HOfqjjk5JQKuSBKTUPAb0Qc4MqS
aJz0L/BRa6n1s1ZjdYPYqHE+uprdKwJt8A+r3y6W9XR5+EmqS+2gxxVBxKf1KWpB
EzWUGcsITWPDk7GbWXff9xyXuzskIvhCGj4NHJ2ZfalpZXpg22Y3GAhm+OAdM6rF
T9k2akRuiicnSq0tXqHF
=qAAm
-----END PGP SIGNATURE-----

--=-gA1auIjvcpQ8u44beNEZ--

