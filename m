Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:49007 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYBVPRZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 10:17:25 -0500
Subject: Re: mac80211: sta info locking
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080222143745.GB3067@tuxdriver.com> (sfid-20080222_150653_481242_9B66FAA1)
References: <1203677069.26341.52.camel@johannes.berg>
	 <20080222143745.GB3067@tuxdriver.com>
	 (sfid-20080222_150653_481242_9B66FAA1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Tof5O+ZmbQe4aIdQlEi2"
Date: Fri, 22 Feb 2008 16:16:49 +0100
Message-Id: <1203693409.7082.30.camel@johannes.berg> (sfid-20080222_151736_254806_EA5B252D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Tof5O+ZmbQe4aIdQlEi2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Hence, I think we can actually get away without more locking if we
> > protect the flags better. Should we use a spinlock or the atomic
> > set_bit()/clear_bit()/etc. operations?
>=20
> Using the atomic operations seems appropriate to me.

Right, but I figured if we could get rid of the AMPDU spinlocks and just
use a single one in total (for flags as well) then that'd be of benefit
too; even with the dynamic allocation strategy (see other mail) we'd not
need to allocate two more spinlocks for ampdu.

johannes

--=-Tof5O+ZmbQe4aIdQlEi2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR77nX6Vg1VMiehFYAQJ0og//a+QeaEmcKMZgjb3wXUDr+2TP+tJShANi
NXhbm/F8y70QwvzPv4jIq7XQ9I2m6VHcw4t6WLy2rUSKxn3g8VcrM1xnCxIzMYwO
cvJDWNsSeFaa5a5KIllMWVAx6tMVmCOR+uqeO8z79VNTbwEf5Xwvih2HZnucPk2u
X6lvhJ0NQuKHcAGNyi2N2p0m0QsiSJ63r5ndTD4bDoqUyztmLrTw7Yq/h7wP4+1C
813vTnyyTI0xN4/9C+g4nndHeqQeYcQMVyXxGOM+PeAb58cdC5LbOEVXj1yKOxJr
nJlKu2HwpmIDmf/BkuPuAToq3iQLel+BwVNlutlRoJLr8CemomCC1kd2ysvfRPKq
Hp+seFGj+kKtJwb4Rr1NM3L7dbfojIVayUZ2tfXnmijc1dDrwiCAucxFy5+4z3fY
Z2CqHc6uuwfgzFXQ20P2VXJ/DfOJV7BqGfJEbF2TzXlgvIsIuOGFh1wwBI7pGXHS
GEWrpkzRccfwDFW9SgyRhgRZ6FW5tBCek5BRhgzXHzpRvMeqJiW2oo0RSeOaBNch
n6s9iTVjAalbQ1TVnJ/RATM/7CZtFjD6CFCpbV9FeOLL26GmpsF8loq3Kt2RySNz
/UvgKUXBULqjymjiop0Rzi1Zdb2p0poezLKlQxqpymZG/lbcMgDJJvVKQlSsFpSi
dpN1r7iRAAU=
=LEbq
-----END PGP SIGNATURE-----

--=-Tof5O+ZmbQe4aIdQlEi2--

