Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYKZN6n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 08:58:43 -0500
Subject: Re: AP (Master Mode) of wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Mark Ryden <markryde@gmail.com>
Cc: Vladimir Koutny <vlado@work.ksp.sk>, Pavel Roskin <proski@gnu.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <dac45060811260547w2c9d7a7dg839792f5c98011d1@mail.gmail.com> (sfid-20081126_144745_655764_8F111AA6)
References: <dac45060811250735m6922688fn13c03ebe388d3137@mail.gmail.com>
	 <1227633414.15224.6.camel@dv> <492D0A26.9090801@work.ksp.sk>
	 <1227693793.4613.57.camel@johannes.berg>
	 <dac45060811260547w2c9d7a7dg839792f5c98011d1@mail.gmail.com>
	 (sfid-20081126_144745_655764_8F111AA6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MrZM4QCLhRmbOGIwz0/i"
Date: Wed, 26 Nov 2008 14:58:03 +0100
Message-Id: <1227707883.4613.105.camel@johannes.berg> (sfid-20081126_145846_466394_B9192ABE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MrZM4QCLhRmbOGIwz0/i
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> "For AP mode, it must
> honour IEEE80211_TX_CTL_SEND_AFTER_DTIM or set
> 		IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING and use the
> ieee80211_get_buffered_bc() function"
> 	=09
> see:
>  http://wireless.kernel.org/en/developers/Documentation/mac80211/API

Yup.

> However, I found out that in wireless-testing, this is the situation:
>=20
> =09
> IEEE80211_TX_CTL_SEND_AFTER_DTIM appears only in rt2x00mac.c

It's also in b43 and p54. I think your grep-fu is weak ;)

> There is a call to ieee80211_get_buffered_bc() only in:
> 1) drivers/net/wireless/ath9k/beacon.c
> 2) wireless-testing/drivers/net/wireless/libertas_tf/main.c
>=20
> According to this , b43/b43legacy (Broadcom chips), Intel ipw2200,

ipw2200 is a very special case, and it doesn't use mac80211 so that
constant above won't occur in it anyway. Not sure if anybody has
recently tried, I'd almost assume it's broken since the project hasn't
been maintained forever, afaict.

johannes

--=-MrZM4QCLhRmbOGIwz0/i
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJLVXoAAoJEKVg1VMiehFYkngP/1Ep6s0yGASFN7ofvD2KZCyt
mOKO9qUlVysE4MlugUBC5gWe18KnC902epeaqnLl0WpaaUbIOXs5pAbZMOWEz+Ks
3sEaS0chwqXjkBY5ISa3EhNBSbh2rQPkggQ/T6XNNC/xxymgMmk5+t4NVJXSViek
Q+6db7GT/6YIe+1oCq2EKAVnG5dFfeFi+3IeaYJxq3+DxDFbz8Mel+akAzuw75kB
wYIYgEmlPQ/NxJwCoQ3po2CVMCk1CXLJigt4hX5dsoxVY0UexKhP5vCi3vHNrXhS
gWbd+g6WvX4xmbokIq/M4vlZ6NhLU5BKmYJtjRJaygz6yZy/dHVfzb9Kx9NI4YCd
zhcB6IB401rR5PriTolMItx4PJCrgDGRndOjSqOYuBOnJftOIfHJLD3Z3dW4nEz9
NBY/2JIe6ElYMddfFrt7JYceyyzpCM+eGif2rr15qJrW1UL8kI02sfdhH0pbysaV
ixmUNTaiy8ziR6T/ibCkCYBhy5dVdbK4hkMNf8YkNzelurac3BweUTSFQB1CqoZM
cYVZLrtCioNY2yd6sf934ZYcTLewGNvD+QZuhTOFXGapNeY+6iaH+oi4zMI2KExa
dRSI0Er36dTGU4rYzTtNJuWF3UnAJGnDtHjh/d115avsjvjSyc39S7qRVHBK+z2Z
gNTX5lNJ4JtCbZy/J68z
=/n8t
-----END PGP SIGNATURE-----

--=-MrZM4QCLhRmbOGIwz0/i--

