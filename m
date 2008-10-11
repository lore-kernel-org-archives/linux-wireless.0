Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50610 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647AbYJKAiL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 20:38:11 -0400
Subject: Re: [PATCH] mac80211: Fix scan RX processing oops
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081011002955.GA15802@jm.kir.nu>
References: <20081011002955.GA15802@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GUcBR2HdgGH/7pwieBIO"
Date: Sat, 11 Oct 2008 02:38:06 +0200
Message-Id: <1223685486.29811.17.camel@johannes.berg> (sfid-20081011_023820_970509_039DEA1A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GUcBR2HdgGH/7pwieBIO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-11 at 03:29 +0300, Jouni Malinen wrote:
> ieee80211_bss_info_update() can return NULL. Verify that this is not the
> case before calling ieee802111_rx_bss_put() which would trigger an oops
> in interrupt context in atomic_dec_and_lock().
>=20
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

>=20
> Index: wireless-testing/net/mac80211/scan.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/net/mac80211/scan.c
> +++ wireless-testing/net/mac80211/scan.c
> @@ -388,7 +388,8 @@ ieee80211_scan_rx(struct ieee80211_sub_i
>  	bss =3D ieee80211_bss_info_update(sdata->local, rx_status,
>  					mgmt, skb->len, &elems,
>  					freq, beacon);
> -	ieee80211_rx_bss_put(sdata->local, bss);
> +	if (bss)
> +		ieee80211_rx_bss_put(sdata->local, bss);

I keep falling into that trap, maybe the put function should just handle
NULL instead...

johannes

--=-GUcBR2HdgGH/7pwieBIO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7/VqAAoJEKVg1VMiehFYdo0P/08JK1oE1LvqL+VgICbohel2
/O6TvCWuKrkiDMU86QpVbzt434PL37A6F2uhYHrvqj1Q1PA5sZo/nx5v8P5KhvcO
T7i4SH1qDNoqbfABQ6GCVtdiudhgza04c84H5J4th7FAuHuLa1f4t67SzXSDVxWt
e1RWIGwO73xVzSB1iFKyeOnMbJ/kJrl+943j0QXZAx33SFn69XlcpvbOgXu5ccm2
kcAqoMTbxZ57h6x0sZvWGGt4uqXGRHNF5VOcc0IAXqviaxE+vtYph/80FeRA3uQE
MSWSyNX+l/HSYluFezDNQ9aAa2hPfY1pLP53s5P4aKafS9/9pa0CQyuBSBvMQWTU
baFqelNH/zFJKjGY72roV0a+2hpSJtzsRVvwzFN3/5+0QmWKBaKr05iqqyZkC76I
yJdqX+ZEnjTDIWrzw36z35dFXTUIhFg5pQx81gZsbGlI7acFEY/4Ew8WrjTVJjE0
WyF9QTEIRNzHfnytsk4PhhQrlBjA1uNQbtzzuei/4bm2IJBOLqxgxahMUG6+NV/f
1iBKeodYqeH06trwv58QJg6aTJtEbyJO4lDh8z3dTsJlWMY/OLH/rW7qJ3BAxdCS
sOlKLeQba5iYUadS7oTCSxXymueMehGIOVoKoecjz+6Ft7u0iAGq8VDZ56oYkoa+
eALWqwV1UeVhNQbGR/o2
=x5Kn
-----END PGP SIGNATURE-----

--=-GUcBR2HdgGH/7pwieBIO--

