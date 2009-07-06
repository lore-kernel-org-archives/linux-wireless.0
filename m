Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbZGFRkP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 13:40:15 -0400
Subject: Re: [PATCH] cfg80211: fix giwrange
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave <kilroyd@googlemail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A523609.5070409@gmail.com>
References: <1246828399.4411.7.camel@johannes.local>
	 <4A523609.5070409@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+21FJCxJVDHQoP8ctMd9"
Date: Mon, 06 Jul 2009 19:40:13 +0200
Message-Id: <1246902013.4652.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+21FJCxJVDHQoP8ctMd9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-06 at 18:36 +0100, Dave wrote:
> Johannes Berg wrote:
> > commit c4c496e49ddbf022e51adbd25cedd071329280db
> > Author: David Kilroy <kilroyd@googlemail.com>
> > Date:   Thu Jun 18 23:21:14 2009 +0100
> >=20
> >     cfg80211: Advertise ciphers via WE according to driver capability
> >=20
> > unfortunately broke iwrange -- it used the variable c
> > that needs to be 0 for the channel list.
>=20
> Doh! I distinctly recall wonderring whether I should use a separate
> variable. Must've got side-tracked. Sorry :(

No worries.

> Just one thing about the fix though...
>=20
> > @@ -201,7 +201,7 @@ int cfg80211_wext_giwrange(struct net_de
> >  	range->avg_qual.noise =3D range->max_qual.noise / 2;
> >  	range->avg_qual.updated =3D range->max_qual.updated;
> > =20
> > -	for (c =3D 0; c < wdev->wiphy->n_cipher_suites; c++) {
> > +	for (i =3D 0; i < wdev->wiphy->n_cipher_suites; i++) {
> >  		switch (wdev->wiphy->cipher_suites[c]) {
>                                                    ^ needs to be i

Ouch! Thanks, good catch.

johannes

--=-+21FJCxJVDHQoP8ctMd9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKUjb5AAoJEODzc/N7+QmadfAP/35LzkDNj5cWVHH6UTaGNm/l
PQxKfGQLLNeJUxRhWQgo7LUgTXlWBviAgl8sLitQuNDW27mOK1W6b2buV9ouSL1W
fzl/4YSZPVKUr4RSkrtaCvA7oDY+6doBvVuzEiLzc2Q3+aQBAX0qWBHvlxTUlhrv
f3C3GeWaO906A5Ea9sx9wwhQVwprz1qwrPjDB2cgkcgTASTQR6bLRjpFJT7dSNFM
td01zoJGoCFCJQqXOzDFb/xeC+RkHlCphwkdD057S6j2LbJ/05xbL8gwSUziA9Cc
8SbT4TTSvpnD4P1iObxx7c9gRWYpXubVfd4DhTXGp8Ger841YWTXQfVJ4qWf31np
opJ7Uue0RflSYVlHWeztsKHd10pkYjB4rCHZmjj0DKnq6MJd8dPLQ0ReV4VzK33J
1iDW04YFGlp8cQEry2VSzcBZk9si/myIADQUnfR3o+2nJDy4v3b2A6hBZoR+HSna
EhNyw8CCoVsgfamrf7NEu7lq1tMPaWefKTshbKTLF8mzIWyeXm1MMDvrF+WWQ8AA
c2F8di6cGe01e5Ofgwo/AEhE6ktd5OOAuNj/Xy/QWH/9pgLM1cy9LWH29DWl1RSx
76riTgf9Uqnu/ZnZlLaldhUO7gKW0VwuezGcLJ05ysNtkZYXThI7PUP+M5WnwKic
+d/Zr4GYVWb5VIeupu5H
=aC3N
-----END PGP SIGNATURE-----

--=-+21FJCxJVDHQoP8ctMd9--

