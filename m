Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYFSRZ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 13:25:29 -0400
Subject: Re: [RFC 3/2] get rid of rx handler function pointers
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213896016.2125.51.camel@brick> (sfid-20080619_192022_768705_8A43D8D3)
References: <1213879121.8967.9.camel@johannes.berg>
	 <1213896016.2125.51.camel@brick> (sfid-20080619_192022_768705_8A43D8D3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OLrVSUk92ejstWO6B1/Q"
Date: Thu, 19 Jun 2008 19:24:49 +0200
Message-Id: <1213896290.8967.39.camel@johannes.berg> (sfid-20080619_192532_485093_B4D01193)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OLrVSUk92ejstWO6B1/Q
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


> > =EF=BB=BF#define CALL_RXH(rxh) if ((res =3D rxh(rx)) !=3D RX_CONTINUE) =
goto rxh_done;
>=20
> Would it really be so bad to just open-code them rather than the macro ap=
proach?
>=20
> 	res =3D =EF=BB=BFieee80211_rx_h_passive_scan(rx);
> 	if (res !=3D RX_CONTINUE) goto rxh_done;
>=20
> 	res =3D =EF=BB=BFieee80211_rx_h_check(rx);
> 	if (res !=3D RX_CONTINUE) goto rxh_done;
>=20
> 	...
>=20
>=20
> Similar comment for the transmit handler patch. =20

Well, I was lazy, and figured it'd be easier to add new ones that way if
needed.

> Either way, the approach looks good,
> and the size reduction is nice.

:)

johannes

--=-OLrVSUk92ejstWO6B1/Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWpZdAAoJEKVg1VMiehFYfBEP/16YDhfQ20tvLGaf9f/SxlNu
kR6VoRYfdAm61Q81d1c9q6vz17xYrCGOE9YW0lpNVY91Udmwwo1gVIAObSO6HCO8
eZzvLIAkID/3wZgeaoz6OvOqGdbtsbF5Njs4gUe8JTWy98nLr53O4HscqVGYzUOC
A4UTfSZxAZWAuIRZzmrlFDDK08P7eQ1bkz4nI22ycyv8yQO5Fd6Jd5K0yr4ZLj/N
ID8c3L7Pjg/W4MD3wN0Lq5GXWVTQnhGyWFGWoEgQJalAQlbkdAcbyqkpZwkEzp3u
WxGGFvuI+JRH2HGfw1p5nirqhKj2LroZNTTwwLDrZxYJvyQnIcrOL6uKAS0EV3LS
1jbX9qq2i+91uaT4i0MOwhDgxqrI7gKg4Apl59yvs56Ri4vpsZ5xJAyKX9qQPUBr
FISef3nF0h6J+Fej6jSEopgZorFLuWmoJH4bLHmtV41Vekee6nICIm2xBQ43YoGu
hJORil+B7SI4Bp0Oz7nYSoLaBFGzZlOgu6rq4kSj+uLVuESO/zyNLhVmex51+A4C
OdMMsJ/KwY3VREfAoI5hEXLO68k8TuRnNiHMEdc8YHjzdGRT0+bZy+S8P98P5+U/
MHhqhNya7aKXYzZvO31jbIoDJ0Yz86MiinE82TtvZOHRe1CU/gFg0VHwPOsDwwSJ
wCDV6Z+XLKBC+LupGbcN
=74vf
-----END PGP SIGNATURE-----

--=-OLrVSUk92ejstWO6B1/Q--

