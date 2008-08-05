Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48390 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005AbYHEM7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 08:59:54 -0400
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <1217940634.3603.42.camel@johannes.berg> (sfid-20080805_145128_598896_D6AEFF76)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
	 <1217700664-20792-9-git-send-email-hmh@hmh.eng.br>
	 <1217703723.8621.50.camel@johannes.berg>
	 <20080802192704.GB24253@khazad-dum.debian.net>
	 <1217864565.3139.17.camel@localhost.localdomain>
	 <20080804223052.GG24927@khazad-dum.debian.net>
	 <1217890611.17793.17.camel@localhost.localdomain>
	 <20080804233525.GI24927@khazad-dum.debian.net>
	 <1217927541.3603.32.camel@johannes.berg>
	 <20080805124814.GA32675@khazad-dum.debian.net>
	 <1217940634.3603.42.camel@johannes.berg>
	 (sfid-20080805_145128_598896_D6AEFF76)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nTo6sSN0QU7RpGtENk3z"
Date: Tue, 05 Aug 2008 14:59:08 +0200
Message-Id: <1217941148.3603.46.camel@johannes.berg> (sfid-20080805_145957_649049_058E265B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nTo6sSN0QU7RpGtENk3z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-05 at 14:50 +0200, Johannes Berg wrote:
> On Tue, 2008-08-05 at 09:48 -0300, Henrique de Moraes Holschuh wrote:
>=20
> > Maybe on net/wireless, but I am really not going to trust that one for,
> > e.g., serial and USB drivers (USB being a bus that is often not shut do=
wn
> > during suspend because there are USB wake devices), unless you clearly =
state
> > you DID review them all, and which ones.
>=20
> Look, this is _clearly_ the wrong thing to do, so unless you want your
> patches blocked over it, just rip it out.

You can of course keep the current _wrong_ behaviour of blocking the
radio when suspending, but instead of adding extra API for the
wake-on-wlan case you should work on fixing that.

If you think that you then need to review all drivers, so be it. I don't
think it makes sense because keeping the device alive requires
additional code nobody in their right mind would write unless they knew
they needed it, like libertas.

As it stands, rfkill also does the wrong thing for rfkill. You don't
have to fix it, of course, but don't add workarounds.

johannes

--=-nTo6sSN0QU7RpGtENk3z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImE6ZAAoJEKVg1VMiehFY1+sQAJDUt9TfEXMHLfg8CifLfpWR
2Q0SDmDW1/sHyib4nmdsPtZ7U1wMXJ9Nx/G4RThLJA8jjU7es1CSeU8+MF/r7bys
gvIUjDavC12TWFzwv6l+3Ftjk3vKXpf0Y3mTSqmPwlSEgBDbde64yyURqpy8UfBU
rocnNVun+dZwzyGb0YrVedmM/GS5gjXFMcDFyrz02kQREtqNNut0s4++KWOA9ySx
uDVm2v185gh1VUorjGzefSNiLCJak6wPgsTedD8T5jEQ/Xum/ZDl9ecOcUPiZc3j
gI4/+6wCJ5BPN7h1hsvrj4jMCqhHT5QW00esUSCLftyRByilLFSdEEhEKoaqfeed
H2f8aAcIr2TGaQIwh9rr17j7tl9LrLFjYElgWSxPea6jMj3i55YGQQRGEKv+LJc2
JIGeJ2ma16T5j5gm62UjQkVBt/xXzN0JipdDReTqIwMB2EdIyjHRibqx1iWvFGgv
PLQOKkg1uyxbskwSOzF3hBJUxv3dQ7E5YAfUYUSItbZIKFuT0+WV0cS/Om6ZT8Xo
KQT0fjDdC4vCLfdwHCtqP1/b+DD8E0WgrAJsF/XIjtLWaabVvZ0XR3Mt3gopS91t
iN+R2hKCsLDiopvJQM1Fq8JZUGVHf9PDXsS7/trj2duj7hgjWD5JywmsbJGE93JK
68jaOe4CRmVRWqeFS1Qw
=w3o+
-----END PGP SIGNATURE-----

--=-nTo6sSN0QU7RpGtENk3z--

