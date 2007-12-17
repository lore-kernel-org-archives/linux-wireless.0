Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60974 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbXLQRr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 12:47:26 -0500
Subject: Re: [patch 8/9] debugfs: Revamp debugfs_create_{u,x,s}{8,16,32,64}
	to support signed integers
From: Johannes Berg <johannes@sipsolutions.net>
To: mattias.nissler@gmx.de
Cc: linville@tuxdriver.com, stefano.brivio@polimi.it,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071217002056.677829348@gmx.de> (sfid-20071217_003027_870531_D9FE80DE)
References: <20071217001956.640555983@gmx.de>
	 <20071217002056.677829348@gmx.de> (sfid-20071217_003027_870531_D9FE80DE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-V+8BxkmJsASHoJODBs37"
Date: Mon, 17 Dec 2007 17:43:00 +0100
Message-Id: <1197909780.4885.52.camel@johannes.berg> (sfid-20071217_174728_395497_981E79D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V+8BxkmJsASHoJODBs37
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-12-17 at 01:20 +0100, mattias.nissler@gmx.de wrote:
> This makes debugfs use its own file_operations for the value accessor fil=
es
> created by debugfs_create_XXX. Having that, we can also have proper versi=
ons
> for signed integers.

I think I'd probably prefer if this didn't duplicate all the fs/libfs.c
simple attribute functionality but extended libfs instead to define
attributes that can have their own print/scan functions. Or something
like that.

As far as I can tell, the only reason you're doing this huge amount of
code duplication is the "(unsigned long long)" cast in fs/libfs.c, or am
I missing something?

You might even be able to get around that: define the get() function in
simple_attr to return unsigned long long (rather than u64 as it does
now) and then remove the cast. Then, %lld will still print a negative
number if applicable.

johannes

--=-V+8BxkmJsASHoJODBs37
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2anE6Vg1VMiehFYAQIAjRAAnJ8T/7Dtl7eULcwfS+kMfFzfMgjof0ig
slPOOiZu+IqsZKk9nv43AOVQfFm0qMowYV2O4ON1z91Ls+1FXAEU4ZmuLYzzpPoe
qWRJo26f42/ZtdNFXad2WuDmcWvKG+wfcm32ur0Z3tKQ3M8D+dQfMXyiCAyN5GUq
WCLcJifNN4AGJaiLql1q/yGuTHqfYSPEfmSLnPtRpAZk2JLQapV+NYi0q/Iu8vwz
vTqd9C27LvddHH/nSLheB/qUYRp5Ctu+jZ6EUNV5JpYrQYsuLK2brBNnjZdNqAcS
FRUoNVgMCwgN+oECDdhNJO9XELLm0Irvad6WGAJw0gCUI/qwUi/xc71QJ7BOZ8Ns
Q3W6sMmGhZdHSyBnplBCYTJWk0K5KCAfdSMPCgjdKHtn3pXIeRWAoE0jIwc4IYag
H2m3X5iSPTiqFgG7eeWGSU80Q3iNEP6LUVztGQys8WtT9tK2hgkhA1ScpVYclDzd
cWFoj2BaZO2UlpCyMqF1/nwyLoGLbelfm4Uor0A4RUDR8uNoaLqIPAMpa9PXDHiH
3JFnLXAmUwXMmaG2FlVb/Rk/24jtMHdyZQtP9M4lpe39y7AZCKIM8k6ibzUT2DQL
Z4up2jYuO4AW/Na921TAqIJRxy+/fGge0CTRUjyrll4xaaSQG3ZU+H73j0aU41jB
8+h8A6LWacc=
=EU1F
-----END PGP SIGNATURE-----

--=-V+8BxkmJsASHoJODBs37--

