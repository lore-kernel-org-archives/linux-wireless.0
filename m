Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44997 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYG1MKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 08:10:09 -0400
Subject: Re: [ath5k-devel] [PATCH] ath5k: add Mesh Point support
From: Johannes Berg <johannes@sipsolutions.net>
To: sbrown@cortland.com
Cc: YanBo <dreamfly281@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
In-Reply-To: <488D9E79.8050408@cortland.com> (sfid-20080728_122546_840137_51FD7C0F)
References: <487fa7a8.14da600a.1aae.48b1@mx.google.com>
	 <1197ff4c0807280209x754f3a15j9dca3e60e99c69cb@mail.gmail.com>
	 <488D9E79.8050408@cortland.com> (sfid-20080728_122546_840137_51FD7C0F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lFN3MJyJgKKd/YizjOuO"
Date: Mon, 28 Jul 2008 14:10:04 +0200
Message-Id: <1217247004.12662.3.camel@johannes.berg> (sfid-20080728_141015_015506_8908639D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lFN3MJyJgKKd/YizjOuO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I've been looking at this too. After the "revamp beacon configuration"=20
> patch, mesh no longer send beacons. If I revert it, beacons reappear and=20
> my two stations are found. I'm using both a b43 & zd1211rw.
>=20
> I believe the problem is in mac80211. It appears that the call to=20
> ieee80211_if_config that was previously in ieee80211_open never made it=20
> to the new start_mesh routine in the revision. The attached patch seems=20
> to revive beacons and both stations are now found. I'm not familiar with=20
> the code and wouldn't call this a fix.

Yeah, we talked about it yesterday or the day before, and this seems
like the right fix, except you say that AP is also broken.

I'll look into everything when I no longer feel hung over from
travelling for about 18 hours.

johannes

--=-lFN3MJyJgKKd/YizjOuO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjbcYAAoJEKVg1VMiehFYgVcP/3imjPdHyscMtJ5aS/LQUU7y
0O7rHxjoCPXajR0boJOLVO6fWUXruVru7zBUGxDynFiFN4lmNhk+FWgVO5+LHoml
sUZa8VtIYx8cb+rDz+12xLaLQpXkhbXDjMaOgUyL5ZS3WdkN3p2fVW8NGGEAy6Jv
7QAVGTmiaqkjEOROdqyiY+RXslLn9cVlSUYtwdBSZzEH+nZcU2eiLVw+gDYG6QwI
A9tmaSt4aj23DsRkX0BRnYX/42l9c/1eGKCijuv5TIHNaC08n+7vckTaQNgqB+IB
tlbiKY2bwKSbJbgjCYenB7Rg4BtHMwmzCZ7rH8yeJSzHS2Ur/DpfdjshJdzq4s+P
zR5slOQpD0+u1jVzSXwFm03mkNiMmDit0TkODtpIxkTKijbsLsVout5eodJWkWYD
8CBZblTJ0E3/Mfun6iwI08jrGhniT/E0KrpYTN4HPqXu50aZz00JbLhlqAZdCON3
w9omqgr6/5plc0q8P6mQv96t4aTYapI24xOc/k7iZCW6KYyJrYJLtiBqzrzJis4H
sodCkOen/YxvKbmueHPqD/AUPiC4f5cPhjHMicEHhSQeba2nLV6EtoFqGgeToMj0
ZHQEkXn6ug+R7NASyeIn+Pn9oJADg5ayu/SaWhQ5HxaM5dcdVJFNqo88YhETIcZN
wW+ntWZQxZrUbsl0cvvb
=Em+h
-----END PGP SIGNATURE-----

--=-lFN3MJyJgKKd/YizjOuO--

