Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51741 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbZAMNj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 08:39:28 -0500
Subject: Re: [PATCH] nl80211: New command for adding extra IE(s) into
	management frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090113115128.GA11245@jm.kir.nu>
References: <20090113115128.GA11245@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sfTTDJgWr6mgkoqAPiax"
Date: Tue, 13 Jan 2009 14:38:57 +0100
Message-Id: <1231853937.3671.28.camel@johannes> (sfid-20090113_143932_502263_50815837)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sfTTDJgWr6mgkoqAPiax
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-13 at 13:51 +0200, Jouni Malinen wrote:

> +	if (params->ies) {
> +		ies =3D kmalloc(params->ies_len, GFP_KERNEL);
> +		if (ies =3D=3D NULL)
> +			return -ENOMEM;
> +		ies_len =3D params->ies_len;
> +		memcpy(ies, params->ies, ies_len);

kmemdup? Might also make sense to not try the allocation if we're going
to refuse it anyway, but that might be complicated to do and probably
doesn't matter.

Otherwise looks good to me.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--=-sfTTDJgWr6mgkoqAPiax
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJbJluAAoJEKVg1VMiehFYVsQP/3IrGsGLOueQWUOqbXbMT9ab
yiAJlGZWabwVuAx7bUbj8MAIS3ScodYYCxcelnRHRKcxp3Eagh8797//yOvEnoJi
sVIewATwS4u2q2fCo72RnBjjIsWNLzBzieG8T3xf/jUZIbvWwJ0+2e5GY4vqAvnm
3Hon2uqQQyZ1erzCSzwCYVbSqSNdgNtWdYuZYBAkXiQJn2BU5nLATrDleItXIX3R
m/EpkyIJoldm3Xyw74rCLk5e2eBYn4D2Z0nKEZdyEGoo0ZmrprTlekliH9vzIxlC
B6qs29Kp+Zd4cJmnXAMIWd9EC59guASShEh7kw7TH52SxGDGaoN9ZT4/osXro3Kk
IL3idlpnK5ZV4tCVehDPtD3kH3JDkAmD+WIJxMdKZBi20ISr4Qi9azz6P/gU6s8V
8RoYB2ZeTX5QU334tUb84zeJP++DiG6lf9E3KpTqfnmskZZE+XlVg4I3sZO4e+VM
AEufQLvoecfgSJscnZAFMrvNutaNc35B9rPoiT6LMUsHVfdqoDWE4VTGp2nJ6xU+
QplPV71gKEsnIkWxDN0P/ZsDxFIlZaujxUJd1YexJrv+OYZMIZSdCQWbT13t2q2a
BFkD2jCe3GFT5bX5w66ScbzMqKnTWVDQKczYrgVcEmHeyOBXZ3dcBldZtexChxD2
QWzNtrQ4APmm7IuJN5aA
=z2uB
-----END PGP SIGNATURE-----

--=-sfTTDJgWr6mgkoqAPiax--

