Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48169 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413AbYEFVMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 17:12:53 -0400
Subject: Re: [PATCH 1/4][MAC80211]: Fix GFP_KERNEL allocation under read
	lock.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Oeser <netdev@axxeo.de>
Cc: Pavel Emelyanov <xemul@openvz.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org,
	Linux Netdev List <netdev@vger.kernel.org>
In-Reply-To: <200805061840.37713.netdev@axxeo.de>
References: <48206F4C.5050105@openvz.org>
	 <200805061840.37713.netdev@axxeo.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xrBEP1cDTObt5DmJCrqK"
Date: Tue, 06 May 2008 23:12:00 +0200
Message-Id: <1210108320.9305.4.camel@johannes.berg> (sfid-20080506_231211_914449_681A93CD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xrBEP1cDTObt5DmJCrqK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> What about doing both allocations in succession to local variables,
> share the failure path if an error occours an kfree them unconditionally=20
> like this?
>=20
> new_node =3D kmalloc(sizeof(struct mpath_node), GFP_KERNEL);
> new_mpath =3D kzalloc(sizeof(struct mesh_path), GFP_KERNEL);

If the system is under enough pressure to fail the first allocation, do
we really want to try another one just to free things again right away?
I'm with Pavel here, let's rather clean up the failure code path.

johannes

--=-xrBEP1cDTObt5DmJCrqK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASCDJnqVg1VMiehFYAQJZNQ/+LbbTTgghcC95yxYyiidrrN3H6AWGuDZc
cqoLIa0Mz5uyLPe1sOYefWd7M7nR/CDHxdB5ouOizFfDR7HrRf/2NcTKwdiD7pgM
n4B3MYXaiL2LEuXzeRwoKoI1Q8rog8iV+KXPM1lO0f8xNkP9YXlCZ6tiNnJEqYJ2
rdewLsUVS+ngyxRZWlLkszXkIsnDtQzEOmHxVZVY1V0Uc44WZxKVv60BjEVbh0sx
L4lmddHKF1pr4YMTo6q/N00JZnM1/pFlhqwwfkV8Q31uP9N0IcJToiNK+YynWXnR
TtTuqUGyc4ctqP0Dh+5i6Zztsk9PjYJxvJKdmRVOtYcvZlub0g79r4kw9mRJ2rrA
mseqJ6HDqOlR3ADh1oiDvCcE0kXKfEMYtmqx/1ZWEGHGD5oMNZ9L1gbahJVccvbV
MTqZuMmZOQjnlWav9DYsCzpaLTbpBBxORN28xm+9Pom0SLvyQhx+eHPETp56SrFw
Bs9nOmS9z0f9urYCjbZaRAK2L61qB1NOuWmLLNPLIOiob0EGXIHE7AQkSHhFMFxn
/M+7u+UTg01U3qtOTGEZ2RIn+NZge00hTs+f69M48TwHggpw0eU3nNCkYLsqfBYq
4GzQHksDiwsUgToP8o7yuRQK/zl+vWyrEjDry1J3gIwbUbmpmQJ4FEeOIoYyajGY
HDmXjM8JprE=
=eCJY
-----END PGP SIGNATURE-----

--=-xrBEP1cDTObt5DmJCrqK--

