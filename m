Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608AbZC1VSA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 17:18:00 -0400
Subject: Re: [PATCH 7/8] mac80211: fix aggregation to not require queue stop
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
In-Reply-To: <43e72e890903281406w528719b1vda8128255f1ac707@mail.gmail.com> (sfid-20090328_220623_318840_66621554)
References: <20090323162834.154525349@sipsolutions.net>
	 <20090323163053.344441542@sipsolutions.net>
	 <20090328045529.GF5543@bombadil.infradead.org>
	 <1238262118.4217.13.camel@johannes.local>
	 <43e72e890903281218s6b4eeb9eu4a97aa3e87c5a3a6@mail.gmail.com>
	 <1238269957.4217.24.camel@johannes.local>
	 <43e72e890903281326j1bba2456j3b82bf3831b614f6@mail.gmail.com>
	 <1238272957.4217.28.camel@johannes.local>
	 <43e72e890903281406w528719b1vda8128255f1ac707@mail.gmail.com>
	 (sfid-20090328_220623_318840_66621554)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-w1xIWzJ0EX5VpdYpdLSl"
Date: Sat, 28 Mar 2009 22:17:48 +0100
Message-Id: <1238275068.4217.31.camel@johannes.local> (sfid-20090328_221806_733581_44717399)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-w1xIWzJ0EX5VpdYpdLSl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-28 at 14:06 -0700, Luis R. Rodriguez wrote:

> My point was that if you have the tasklet handled by a separate CPU
> the DRV flag would most likely be set by the time the addba response
> comes back. On a UP box though you have no option but to wait for wait
> for it to be done after we send off the addba request so then it is a
> race between the scheduler to schedule the tasklet and the remote
> station's speed + the IRQ processing of the received response.

Ah, I see what you mean. But this goes off the same tasklet :) so ath9k
doesn't have a problem in any case.

> If we would somehow be able to ensure pending BHs complete before we
> process the addba response this wouldn't be needed in both places.

No, we can't ensure that -- the driver might very well take longer and
we don't have a way to only process the received frame later.

> Anyway I'm also stating that its likely that the ampdu start action is
> slower with iwlagn as interaction with the firmware is required so I
> would suspect one can see this behavior more likely on UP iwlagn
> boxen.
>=20
> Where did you see it?

I didn't actually see it :) But iwlagn can possibly flush the queue
before calling back to the cb.

johannes

--=-w1xIWzJ0EX5VpdYpdLSl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzpP5AAoJEKVg1VMiehFYr/0QAKV1XczsTVvMhjFHrL9Vd2JB
Cl7dz8VK102Wuvg8SFhDoxGyLVTN6bLWN7IJhETh3poZ7M6WqPZd+mbh9ki5ZR6l
A1Pse8g3xHfYBNzulkvXXfUhUCv+6J0UZ32lA/Vo2hmahaqFPERu6q7ax1NS5mTb
/lUY/2GMVIyhVgk0ABCqmPbC7lDGLvlEmJno1wFkm3TcF8j1tuJQ7N1mZVHx4wlL
DOmh9KZb6+unIzVdFP4NNj6q56vU7GDGoBN2hMBBbF847kK0cLwjaT/jBZWjcK/L
zmeARiB7Aqz2COpy8Xg0NX+sgokaiP7FkeRQPGNJTJjFBA6oxFXKgS/MkUwvHEB8
eRxJEERRn9bDZn6dInXPGIVJ60RPkRkEQIVesP5ndxyb/Ix2cIHWdu224QoyEYsY
bD3hNZHFkGaS7tCd99gt/n4gVyIvJxwV6yU5vyL1LnppTH2zUdLxjatUloXo37YT
54DtEXxAp0DLNbZ54QBdckJLIGYcZqbeGLLBT8n8PgH9vs+51DchE/krXxALfukH
lTdYlaWV36amJqQ+ibD79QvLcz8qOK03w7/THPgZut1+fIZjJaQHeN97WR0eAPQV
a6OMKag+/wPl6m5ef5xAar1gxUTo/Vh+nHnFepuSqlQ4DFn3ZkBpCrVA3SAbzkPz
1MTzd8VcJNQFPn4MBqmA
=346D
-----END PGP SIGNATURE-----

--=-w1xIWzJ0EX5VpdYpdLSl--

