Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50028 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZHBHus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 03:50:48 -0400
Subject: Re: [PATCH] Fix SPARC64 unaligned access in zd_mac_rx
From: Johannes Berg <johannes@sipsolutions.net>
To: Patrick Simmons <linuxrocks123@netscape.net>
Cc: David Miller <davem@davemloft.net>, mb@bu3sch.de,
	linux-wireless@vger.kernel.org, dsd@gentoo.org, kune@deine-taler.de
In-Reply-To: <4A74EEB2.6040400@netscape.net>
References: <1249029583.29587.46.camel@johannes.local>
	 <20090731.222350.254918321.davem@davemloft.net>
	 <200908011240.17229.mb@bu3sch.de>
	 <20090801.091207.217317135.davem@davemloft.net>
	 <4A74EEB2.6040400@netscape.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Hj8WW9rElg9dRX+r7R1D"
Date: Sun, 02 Aug 2009 09:50:41 +0200
Message-Id: <1249199441.2007.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Hj8WW9rElg9dRX+r7R1D
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-08-01 at 19:41 -0600, Patrick Simmons wrote:

> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -694,7 +694,7 @@
>                          && !mac->pass_ctrl)
>                  return 0;
>=20
> -       fc =3D *(__le16 *)buffer;
> +       fc =3D get_unaligned(buffer);

Now the code is completely incorrect -- you're now loading the lower 16
bits of the 'buffer' _pointer_ into the variable as an unaligned load.

It really needs to be

fc =3D get_unaligned((__le16 *)buffer);

I think.

johannes

--=-Hj8WW9rElg9dRX+r7R1D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKdUVOAAoJEODzc/N7+QmaRU8P/RdYh/+45yZmw1OHeVoxmZ42
pfRQDwh0Sp3VTWSRADJUVMFwpU543tqLNnUuZlHQzfv5qyTMm4U+oikIxyK1P2OW
sOd+oJbHp5L7hJ/aCXufSDplkw0+gtkqJcu7Mh/uY0E3RzM5vKu/RiMaGcAtdYjB
4oUdkQQz7L0+aAHO5DKd4T/IDgMHuC3wsxa9tk38yg4cMv08gWdtBflwItqb0g6g
ialHPvInrzXRfzqtRQ7fPTP8MFyfkmKS9WlHut+ZO/2BlcbXJJEZkS+xTQvd2lJR
rKU1nwnEb9HLWyS6gWHNQb/m/lYiy7BTFT4eaBAFZdJts5Y5pjS0x2IuSuSIHAU3
UndYHMl94pPy7uG45m4Yr6vcirLAg8bWqhx1rIwnSmXl1QUgjSAMnqVZRUlP4ZA5
ZfRkGCGhrr80q5GP+p+K+q1LNHj8X6oPM8Ny9xSSjHzHU1FFb4Az2hxJ35bhXxSw
xlQTmMwKT9bnkFAh4FSrUlBSG9fXzz0/ZtF0801tWtr90kkW6m4hTPrdY7hXNCqO
5grb/g2gLimNZj83VYVRF4W2qoXh56S0O0tvxYD4nxaitSVSS0XHsZW6Z6SIN9Wo
x7g+dRRnUPRlUAkiuPOND3ZSwf2hyPkcfk0X2QF4dN0s8r07allclA9wgmfS6Uaw
hIsjcycGha1gVBZIjONM
=oycR
-----END PGP SIGNATURE-----

--=-Hj8WW9rElg9dRX+r7R1D--

