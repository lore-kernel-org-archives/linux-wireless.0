Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45206 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbXLMLhl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 06:37:41 -0500
Subject: Re: [PATCH] try 2: mac80211: Fix swapped parameters to
	ieee80211_set_channel()
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Lunn <andrew@lunn.ch>
Cc: flamingice@sourmilk.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <1197482969.6558.149.camel@johannes.berg> (sfid-20071212_180937_711926_82CF467E)
References: <20071212153158.GB16947@lunn.ch>
	 <1197481426.6558.138.camel@johannes.berg>  <20071212180204.GP31218@lunn.ch>
	 <1197482969.6558.149.camel@johannes.berg>
	 (sfid-20071212_180937_711926_82CF467E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RjscP/e5ip9eaKQplUb9"
Date: Thu, 13 Dec 2007 01:16:14 +0100
Message-Id: <1197504975.6558.199.camel@johannes.berg> (sfid-20071213_113744_049512_91331FB4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RjscP/e5ip9eaKQplUb9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> Acked-by: Johannes Berg <johannes@sipsolutions.net>

Actually, I take that back.

The code is correct, as per the comment above it. Stupid wext :/

        /* freq->e =3D=3D 0: freq->m =3D channel; otherwise freq =3D m * 10=
^e */
        if (freq->e =3D=3D 0) {
                if (freq->m < 0) {
                        if (sdata->type =3D=3D IEEE80211_IF_TYPE_STA)
                                sdata->u.sta.flags |=3D
                                        IEEE80211_STA_AUTO_CHANNEL_SEL;
                        return 0;
                } else =20
                        return ieee80211_set_channel(local, freq->m, -1);

johannes

--=-RjscP/e5ip9eaKQplUb9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2B5zaVg1VMiehFYAQIkFBAAw97+T2gmZ3I1oCLSxTknkC+lwzZ0trLL
ZKH5Q+/c9UBNxM+Pmm5hz/3FMVjJahETFAnIC0/TT9zfzNnr4QqQeeNtHbBhlkjx
N0RW5UgIBh9rdkS2qBcwuWQxIbsVtw0vHLxCvjTf7++zP99l1siQRyLKiWkLNeds
QrNVq8BQrdm/qYLKnQO1/K0fFnObXyCn0HHzjAKMJxye9NOFrvy7lE+w8qjBpQER
dxfSvfNlDLecxfwLzZJwkeIwVoSwgP7M6ed4HxIggCMp4xQ4EQGRDuCiAePqzMWN
Ubj4zJmTBybSnXQk2mOnAqRgMloG3k5hEQiNR575IdexAlffNlKKp5GraOsXVqIV
C2blcVlYyye16ZsYkmAzZ9KjiTQM/qEPum6fRkZJLxCLeEORwixBiYryXdwljOMT
bd6uAMKL6Xpm1Y6hXNrriYLFGMPD0W2dFHS1wUzlNb0UbpQNtfVvvIVCflsf95GH
IB+jti6s3m7bT2ZKkDH1KwXT22SFGvAA8sEuoa3W+ya9l4p68ZJ5UOVKfehNoO9s
suCMMCeYF3Ldi0tYDC0e6bkBqcw4OaIGJrmX9ZW58D+wjqnicpntNY9EASfj1Fu2
vxB0vqnhvHhNVrH2q7XpkX/HDPDXutHWoFfEAuGdARFf0RXmIUenLrbRLpXN7VH9
FZ90ruFbqgs=
=ZjM9
-----END PGP SIGNATURE-----

--=-RjscP/e5ip9eaKQplUb9--

