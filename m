Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:55008 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZAXMMt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 07:12:49 -0500
Message-ID: <497B05AF.5050701@hauke-m.de> (sfid-20090124_131254_983321_2F939864)
Date: Sat, 24 Jan 2009 13:12:31 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix driver to return TX retry info for	RTL8187L
References: <49790961.JdcKIZyYlMNFSiuO%Larry.Finger@lwfinger.net> <4979DD39.9000601@hauke-m.de> <20090123153144.GA13658@tuxdriver.com>
In-Reply-To: <20090123153144.GA13658@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDCAC72547602E187E081D20A"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDCAC72547602E187E081D20A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

John W. Linville wrote:
> Just curious if you tried limiting the rate to 11Mb as Larry said
> someone else had done?  Did that work any better?
>=20
> John
I did some more testing with and without the patch. With the patch it
works when the rate is limited to 11M with pid and with minstrel
algorithm. Without this limitation it works only with pid.

Without this patch it also works with the limiting the rate to 11M with
both rate control algorithms, but with minstrel it also works without
limiting the rate.

Without the patch, without limiting the rate and with minstrel iwconfig
reports a rate of 1Mb/s, but I get 3Mb/s with wget, properly an other
bug. With pid the rate goes up to 54Mb/s and it does not work.

With the patch, without limiting the rate and with minstrel iwconfig
reports a rate of 24Mb/s and it does not work. With pid it starts with
1Mb/s and the connection is stable. The rate is changing between 1mb/s,
2Mb/s, 5.5Mb/s and 9Mb/s.

I will do more testing with pid and with this patch.

I have tested with compat-wireless-2009-01-24 and reversed the patch.

Hauke


--------------enigDCAC72547602E187E081D20A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJJewWzAAoJEIZ0px9YPRMyyGEP/2u97Aizg1c7L3e+0jykp5m/
HZ9H/lnJJruGeH4Uj2ckTNsSuPkfInxdYSZDIvT0l/1DOgzN45reLp0zk8iMq9Vj
EPzBT381kjw2CEXtncY8MbOgAlFl1IfRUxp3rwhmV4T2LATkbANx1j1Y2+vYDpY3
oRyPljRQs1YmBgWYBCQlyCp4ZcAc234UhEJQXFFez3FHYKcKQM8qr592mo9GohPf
+tLtAyXuYYL+y9iFt5xYqAQDM7DfVu4tUPEhuz2UEwlb8QW7fv0t7kSvekQ9wXGQ
PA4vDuf6zWmTdmBS1117XzcPw1AbAdqqjKx8lhE9SH/ZhAa9q4TFVrsgYFcTjYkQ
POCkQVtgd8wvOm6OiFgq00pl3068Kj44Ivos6HpyciZ0uGeibnmPzdVivGSoGQv/
QpHlOw0YXlWBTjMBYioSbxKCFYh+XWzbg81czlqztgRldYpwZJQZi11vwkIwgUAF
DFGcaXQsuCPBoo6oJYn5gJEeB1MJFllevusk/kDkX5zsoTheNW+74+hVOE0KV4X7
kLvCEMCJ/atoJx1q6YOSazRUOhfYeCHGECR2yTeTow6s6k4guYe44e7np8hieutA
rEkyYqXAdXqquNdgRlF+YFTre3ZD6+pulFKkb4rrwyNnFUTBwDUMH/Y7QMQFIGBh
b7d6/xoDtrW9hHWsNXIV
=napd
-----END PGP SIGNATURE-----

--------------enigDCAC72547602E187E081D20A--
