Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35670 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZIWRvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 13:51:53 -0400
Subject: Re: Comparison of wpa_supplicant with -Dnl80211 and -Dwext, WEP
 and WPA
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
In-Reply-To: <200909230907.24750.hs4233@mail.mn-solutions.de>
References: <200909221118.04569.hs4233@mail.mn-solutions.de>
	 <1253689198.4458.24.camel@johannes.local>
	 <200909230907.24750.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Y9wjWwm1niW3pTMUGjoE"
Date: Wed, 23 Sep 2009 19:51:55 +0200
Message-Id: <1253728315.4458.66.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y9wjWwm1niW3pTMUGjoE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-09-23 at 09:07 +0200, Holger Schurig wrote:
> > Those are expected, and ok.
>=20
> Okay, then here is a patch to silence this in wpa_supplicant.

No, they should only be ignored under certain circumstances.

johannes

> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
>=20
> Index: wpasupplicant/src/drivers/driver_nl80211.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wpasupplicant.orig/src/drivers/driver_nl80211.c	2009-09-22 12:28:58.0=
00000000 +0200
> +++ wpasupplicant/src/drivers/driver_nl80211.c	2009-09-22 12:30:29.000000=
000 +0200
> @@ -1819,6 +1819,8 @@ static int nl_set_encr(int ifindex, stru
>  	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, ifindex);
> =20
>  	ret =3D send_and_recv_msgs(drv, msg, NULL, NULL);
> +	if (ret =3D=3D -ENOLINK)
> +		ret =3D 0;
>  	if (ret =3D=3D -ENOENT && alg =3D=3D WPA_ALG_NONE)
>  		ret =3D 0;
>  	if (ret)
> @@ -1850,7 +1852,7 @@ static int nl_set_encr(int ifindex, stru
>  		NLA_PUT_FLAG(msg, NL80211_ATTR_KEY_DEFAULT);
> =20
>  	ret =3D send_and_recv_msgs(drv, msg, NULL, NULL);
> -	if (ret =3D=3D -ENOENT)
> +	if (ret =3D=3D -ENOENT || ret =3D=3D -ENOLINK)
>  		ret =3D 0;
>  	if (ret)
>  		wpa_printf(MSG_DEBUG, "nl80211: set_key default failed; "
>=20
>=20
>=20


--=-Y9wjWwm1niW3pTMUGjoE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKumA2AAoJEODzc/N7+Qmadr0P/1civ6D1KoIkqlwV80xahC16
GwHYgKghO13sr1pwPzwNwK6yDr3ucZTvfGGLhk3qvFA/shPLUhl2JjS8bZGALA9I
mpreokUjVs5xn0iOMPocLjX4D/7sJ2zFtGirz1p7T0/kXuxODoXzoJxdpHePFZXI
8iodiqZsmGQDZ3ktG7wqj9aUSslRkb1GL8560iixx7/EcNvqv2f08c8A+2++jI0s
m8vR4CLRXzZN5lN6NS0xYFkZ9bR2mw+EGdNRS9NnZEiR6dLfjZBPagpXCWXJSdDQ
qAYgjxHUNsbXJP84xk/xe6PS6Kue9QdMjbxAmQHzzD34jcOAg+e09wNlLsRQIa+e
LnYe5n7zREh6HqNj9CKCKA7GlyJlJZ/KGZ88WCZ/R5VIPRw87gEudWTZkG5ZVr3T
oarqk40/VoRbEajL0BzXSjN8iVvKL9+gzraZxtQUX/BgOFE8jO0HkMPSaxdC7ZAt
1+NSEwDR8VUu+N6OCC0bvfeP1x49NMzGlN79gMCVZ2bG2b9/N//xkOUgcMcXgQZq
mLiO7+Y/4F6+rPWz8l079Xx3kPN1OC7OBr08I8SuC8ftDI5IhIRJbpQRAa3zXZKQ
XUC6D/MQvW++yTETMt8f9XksG/28K4k0AK7UqyI4w0mz+4gc8ESMaqVOZrWwyyNH
wHVUOojagshGb+eVVpJu
=VU80
-----END PGP SIGNATURE-----

--=-Y9wjWwm1niW3pTMUGjoE--

