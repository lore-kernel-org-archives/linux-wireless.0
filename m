Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59404 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbYIKRm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 13:42:59 -0400
Subject: Re: [PATCH 00/18] mac80211 cleanups and fixes
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1221154777.6986.43.camel@johannes.berg> (sfid-20080911_194024_972872_166E0270)
References: <20080910220145.707263000@sipsolutions.net>
	 <18632.55008.411078.289830@gargle.gargle.HOWL>
	 <1221139351.6986.26.camel@johannes.berg> <20080911165011.GA6049@tesla>
	 <1221151995.6986.33.camel@johannes.berg>  <20080911173335.GD6049@tesla>
	 <1221154777.6986.43.camel@johannes.berg>
	 (sfid-20080911_194024_972872_166E0270)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VSOU2WrhAZdFiD5flYQ8"
Date: Thu, 11 Sep 2008 19:42:21 +0200
Message-Id: <1221154941.6986.46.camel@johannes.berg> (sfid-20080911_194301_979620_DD1EC47A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VSOU2WrhAZdFiD5flYQ8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-11 at 19:39 +0200, Johannes Berg wrote:

> Well take the larger bit of code:
>=20
> 	struct something *an =3D NULL;
>=20
> ...
>=20
> 	rcu_read_lock();
> 	sta =3D ieee80211_find_sta(hw, hdr->addr2);
> 	if (sta)
> 		an =3D (void *) sta->drv_priv;
> =20
>  	if (an) {
>  		ath_rx_input(sc, an,
>  			     hw->conf.ht_conf.ht_supported,
>  			     skb, status, &st);
>  	}
> 	rcu_read_unlock();
>=20
> 	/* the "!an" here is fine even outside RCU lock */
>  	if (!an || (st !=3D ATH_RX_CONSUMED))
>  		__ieee80211_rx(hw, skb, &rx_status);
>=20
>=20
> So at this point it's only checking whether above it had a pointer, it's
> not accessing it. Think of the "an" variable, after rcu_read_unlock(),
> as a bool indicating whether or not the code that just happened had
> access to the node or not.

That said, here it's probably smarter to just initialise "st" to
something other than _RX_CONSUMED and remove that !an condition
entirely.

johannes

--=-VSOU2WrhAZdFiD5flYQ8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyVh5AAoJEKVg1VMiehFYQr4P/ROk7cG0fuUjyU2hQ6F4ee+a
6GmOw4LgZ0BkfvHSnndKrY6l+ErEQ1YfIIXqhd1gEzUPnw5iAWPKIJ6JcbnLOEWh
g7zwWDdrMncI+bHuGIx69QNgGsyMplKk4vN90tlpwyXWRFGyE0eXV1LTRh0mOdsR
1CXSs7LEdT0hskvYviCJ0qN75MoBMXzSOvVH1EhHHBaYg6UrZQX3xQVeEmldDjmQ
MMK0+lt81sU4offMrlnxQ64VYfK7W2UNewzSeP8Vl+aA4v46p/Usp4Op7PHfSnHu
QKNbay5+v6rCcktbNJKjz5JZRBGXSt0vp9JmTDrhc2kPBXw0dLkyq+acm57PmiTP
Hw9p5tF+2dYkHJZtfu67uJERHUyGWRbrQdj1BJI1c21+pz0sAD2PUxorz4/p2bxp
XvyGyRi0EuykmLrz7A7iTxOLewKQAJXxDluNqJJDRXysLXrzis6dSOKcVfdZGkJR
lM4JQzY9+va3PVSroiZWEhB4vXoysgbRC4gU6tm87/A+5kQ1bW/5He2JnrkKWkvb
3FiX519w37eZwBbWkEnyhBIZbzQ6weAgParC1G6x8InMSZDj0CQalZcOsqGvyBY1
Y/q+KAknvwO7MrrH/pp4HU/vkzsq5/43mKa6n3VSolpsTqGl8lq3yqwfoRuq6JXE
m+yRRU7fN3ULjB7Ebl8Z
=suwV
-----END PGP SIGNATURE-----

--=-VSOU2WrhAZdFiD5flYQ8--

