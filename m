Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54128 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbZFGRSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 13:18:35 -0400
Subject: Re: [PATCH] rfkill: print events when input handler is
 disabled/enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1244388331.23850.85.camel@localhost.localdomain>
References: <1244370412.2907.2.camel@johannes.local>
	 <1244388331.23850.85.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-lZi4T44zvsAq0n+OaUmK"
Date: Sun, 07 Jun 2009 19:18:34 +0200
Message-Id: <1244395114.12956.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lZi4T44zvsAq0n+OaUmK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-06-07 at 17:25 +0200, Marcel Holtmann wrote:

> >  	if (!data->input_handler) {
> > -		atomic_inc(&rfkill_input_disabled);
> > +		if (atomic_inc_return(&rfkill_input_disabled) =3D=3D 1)
> > +			printk(KERN_DEBUG "rfkill: input handler disabled\n");
> >  		data->input_handler =3D true;
> >  	}
>=20
> do you really think the =3D=3D 1 is the correct thing here. I think that
> should be a > 0.

Why would you want to know every time somebody uses the ioctl? I think
the first time should be sufficient, no? Common case will hopefully be
only one program using it anyway though.

johannes

--=-lZi4T44zvsAq0n+OaUmK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKK/ZmAAoJEODzc/N7+QmaPB8QAIt6DVGR5qvHQY74E8B3445D
m8Ys9WQDMl983W1d3toqMuMtKxlPGAFsf13XCVeEZwFPVmj1ujTvQVt06U1//hYy
6IQt49i77DaALxqq7RdSVafjehq7MCv576BI04aGmcTlobevGxFNTOyqmEMtFbB5
aQAmllhO1d6YX03/Oxo6rkJO/1ySRgtxqEUCyzXeM3+9lj7mNJEXi3xfAQApU9vr
J+d02qU9Vb7vNoLSKnHh/NdRoEzPLIWi2eq473+qoxT4Zg6pfthN7/rmv8dPgith
XAHLDAIosxo+/TL8/jj6A08dTT6Rf+36Oi+6Tx0wlAkg8tTaTWoYHvtKnxpASE3S
am+SlCI01ny3R/26Lpym/jltiRergaPPrWGRtjp0jx0Ppj+FoCiQ6xBUJg44F4zd
4JK1p8D7Y6P3jeQi4D92pQRgRj5NUU9Z9a0w5ls9QP9oLVaHbjtt7uyImYvRqyxA
IVgbKXsDbQcPVaKIARv4n6qXqwd78QZD9aOIUZMS2Kb4z65StRYfmb076bmV4DD/
Mb+pjINdrttVeNeJboXI/zhr4Kb2nby2OcPDNTXXwUpMYD6FYRdyrvnDyhO+H9IP
oqj4Xwa8GuzRFkKeMdzeMNUCBVdQqgxHeeDVtADF/bBmGCkQmUPllTzEQUzHEQ5j
LS2O7goNfd06CseX/i6c
=9KIN
-----END PGP SIGNATURE-----

--=-lZi4T44zvsAq0n+OaUmK--

