Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60177 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbZLCKzD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 05:55:03 -0500
Subject: Re: question regarding cfg80211 monitor modes
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <holgerschurig@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200912031148.46934.holgerschurig@gmail.com>
References: <200912031148.46934.holgerschurig@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Jfn0VrMFwOF9DutOGsM6"
Date: Thu, 03 Dec 2009 11:54:42 +0100
Message-ID: <1259837682.12843.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Jfn0VrMFwOF9DutOGsM6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-12-03 at 11:48 +0100, Holger Schurig wrote:
> "iw wlan0 set type monitor" allows the following flags:
>=20
>                 none:     no special flags
>                 fcsfail:  show frames with FCS errors
>                 control:  show control frames
>                 otherbss: show frames from other BSSes
>                 cook:     use cooked mode
>=20
> However, I don't know how to map them to the Libertas' firmware=20
> flags, which has
>=20
> Libertas (bits can be ored)
> Data frames                   0x01  =20
> Mgmt frames but beacons       0x02
> Beacons                       0x04
>=20
>=20
> So I guess that the following could be a translation table:
>=20
> none       0x00
> fcsfail    -ENOTSUPP
> control    0x02 | 0x04
>=20
> But what should "otherbss" and "cook" be?

"cook" and "none" only make sense while operating in a different mode at
the same time. For "cook" you get frames that the kernel hasn't
consumed. For "none" you don't influence the filters due to the monitor.
I suspect you don't support concurrent operation, so neither of those
makes sense.

fcsfail/plcpfail are probably not supported.

=46rom what you say, "control" isn't supported either, since you were
talking about management frames, not control frames. "otherbss" is for
showing frames with a different BSSID, and in libertas monitor mode
probably always enabled.

I'd say don't bother with the flags at all.

johannes

--=-Jfn0VrMFwOF9DutOGsM6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLF5jvAAoJEODzc/N7+QmacsEQAJcgUsglq754O2zbGokABzIO
OQaztR5XeQ0bzCYg39uaKHhat9Co6i7ApIoMyxZlKu9Q+pBDaGSSEb2MVxgSxEyN
WJ/+MSldHiqGMeP5Xhf5a8jwmWChWpBnI9NHG7p6FhD1m7XLwjXEI+U25vT8MbK1
2irobIONtLHycg/ExnAF1fYOKqMsO7rVDQoz8R9NWPW90fyCXg1n65hizDpgEere
287nogMnZzFnIfPczFMeUPqa63UqfLV8J2GX7XjYeXPYCNhJiForNQoyMl2A8SZu
WFPOpq/8QeabQ4nelybH4UWZi6Q8TpLD+tBjfbqVYAOxEJq5i8sNtI63TZ0CrpW4
lG+z3DSEJnrfolS8wXaBP2LpnpsajXB3k3jVQ4eUz8O8lzUVG6iXdvZ9Cw2YWCf7
drDGT2DppZVcUDbLjMwpBURyY9Js652PBAwlZUuuLfzvfITPKYKiNvLUMGaS+DUj
HMTBMVR2h4gRz4wR0FJtjP95XeBuIIXgoeHnCH7L/72h1aJbUucaaYN5tO5Gee6l
S68QsjvqMi4N6BEp8M6nn07jgjb2qpEsjggaoPmYDxXDUPL+l5eXIedDIc/dddaA
n3+Q//TOi1N2+fX2B1b+s/POQkN4/YBbeFIfPG9nEQGIJMqfY4cyGY6xSi134tRs
QkOYt/qINgnxb+x3A6no
=FDwF
-----END PGP SIGNATURE-----

--=-Jfn0VrMFwOF9DutOGsM6--

