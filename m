Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40740 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbYFIRZz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 13:25:55 -0400
Subject: Re: [PATCH 3/7] mac80211: add utility function to get header length
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1213028660.5974.9.camel@brick> (sfid-20080609_182426_913011_F2C185A1)
References: <1212774672.6340.77.camel@brick>
	 <1213002964.698.67.camel@johannes.berg>
	 <1ba2fa240806090301h2a1a3350x606cfe1d83be066a@mail.gmail.com>
	 <1213028660.5974.9.camel@brick> (sfid-20080609_182426_913011_F2C185A1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DTxl0TbwxFLu1rzHprZK"
Date: Mon, 09 Jun 2008 19:24:21 +0200
Message-Id: <1213032261.22220.6.camel@johannes.berg> (sfid-20080609_192557_909440_A3BAD457)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DTxl0TbwxFLu1rzHprZK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > So I guess will we converting idioms
> > u16 fc =3D le16_to_cpu(hdr->frame_control);
> > int hdr_len =3D ieee80211_get_hdrlen(fc);
> > to
> > int hdr_len =3D ieee80211_hdrlen(hdr->frame_control)
> >=20
> > This is how it used in driver code so it make sense to export this
> > function and remove ieee80211_get_hdrlen(fc)
>=20
> Yes, that was my thinking, I just did it this way to avoid the flag day
> change, I'll trickle the changes in and then remove _get_hdrlen.

Sounds good to me.

> > Since all fc operations are bitwise 'and' and 'or'
> > u16 rx->fc can be dropped in future as well
>=20
> I was going to convert it to a __le16, but if it is just a copy of the
> ->frame_control in the header, I'll look at removing it instead.

Yeah, I think rx->fc was meant to be a cpu-byteorder copy of
hdr->frame_control to avoid repeated byteswapping. If we do all
operations on the constants instead as you're doing with this series, we
ought to be able to remove it. Bonus point: that gets rid of the
possible "rx->fc is out of sync" issue we had to fix once already.

johannes

--=-DTxl0TbwxFLu1rzHprZK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITWdCAAoJEKVg1VMiehFYDcAQALmKmZH60U39u2MnbUk6qMFG
wJUP0ldwHNn8innO1CUnvENpOjUf1N/djAw99WqN3Nd/e7FumSr4IfCCmgh2Brto
PVuPBQrBbfEesUg4Sp14uC6HYvYU+htNGaRXIDnee1YQk76bDvAfiIGT+OMxGaRv
JaFzqnvwNjb8jZPvTxQEyHdbSd4TNdXzS1LMoqxbhdI3ItnoYJ5pImidZ6kw9a7r
v1/A/oeOPCr4GZo4pejq1EkOfqTkVpEz3cTUjp5a4IoVt4zw/eaLiwRfI03t0Cl2
SC0YHTaPF0m2TE18rzaw4TMLCIcpSPPs1hpP+Ru47gPPdXr3C7EA7Kw9luMoLl3E
qmmE3YCdEKVj3dWcHOp1vI75O9MS7kZnifnmRIGYmUOwIJbxm4rdZTT68d72hfX7
UvMgjdZpD68xsDcpVHqlnFG476Bgy3bsj+G7HkS6jg2G3/ft8RG+rBohADAIXucK
mGizB9/ZmA0Q1S5TZT5IkK3uGFqygLmHwVqRbfY/DXYTyYQASByKdrmLRDxFIRBG
tcC5K24uVOOH0x8RMFjBuHeNCcgdY4Dg/BZPngQDw/QwhHyjOBFAbSAbgzstfJVh
Bq7PiV+FMIQccZCQ3jNoEGfJHEtVQAsO7zWA3y3liWJqARwW4cEkvSCDqqQisTO4
zvnHgSIhF4cj98A4+Xbg
=UsF6
-----END PGP SIGNATURE-----

--=-DTxl0TbwxFLu1rzHprZK--

