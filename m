Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58349 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbZD2Okc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 10:40:32 -0400
Subject: Re: [PATCH] mac80211: tell driver when idle
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241015587.997.76.camel@localhost.localdomain>
References: <1240997537.593.35.camel@johannes.local>
	 <1241015587.997.76.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-S4I/9ARYZrHsuC6kYDfI"
Date: Wed, 29 Apr 2009 16:39:59 +0200
Message-Id: <1241015999.593.62.camel@johannes.local> (sfid-20090429_164036_459306_53D500BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S4I/9ARYZrHsuC6kYDfI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Marcel,

> > Is it appropriate to go into idle state for a short time when we have
> > just authenticated, but not associated yet? This happens only with the
> > userspace SME, because we cannot really know how long it will wait
> > before asking us to associate. Would going idle after a short timeout
> > be more appropriate? We may need to revisit this, depending on what
> > happens.
>=20
> what about having the hardware set a value for how long something should
> be idle before you tell it. I am more thinking about some sort penalty
> value from the hardware that can not do this quickly.

You're only referring to this case of between auth/assoc, right? I'm not
sure it makes sense to have this HW dependent, the time between
auth/assoc really only depend on how fast the SME is. If we first wait a
bit, because HW advertises some "penalty value", and then the SME is
just a little bit slower than that value, we'd get an even worse
situation, no?

johannes

--=-S4I/9ARYZrHsuC6kYDfI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+Ga9AAoJEKVg1VMiehFYssUP/iHhKiJRfZDKRRQlJKWKBzd7
Xb2h62hGJYIZlPkRpY8Npa4F7fUPOhILKaYzBzLaZOsKF3rfLSYfB43gLitTui67
CuXs0RjduC6mDeB/yNIvh6DJIX9Oun3ydKfirHB9tAl+UZcluGKPdOvYd6IVEnRI
50NGqTBI7XYs9peoinPe3uz5pqYRcNdEw0X8FkiXmO2LS0r/6rlM7zEgqX9UIXsN
GP0XCft8P6av17Kx+88/MekbOgqPA/i4DtaybIz1nneoQgl1uycsLuxVDl7gEJ1q
6/vPtEzSQBKtZSYvkL0JMAqQkC4ShCyA2MozYaPu/Af/kwHxZUehHn32q2ArpxTB
564ygfAG+ymcpa/Ih2Kkvv4Wx/JUIKb4B2RgDO9JWpZ1KAZWwHaid/o+2hwuwUrf
4WTqq1z2wnuMkYhLYeGlz8FqHFsSs/qvpSWBuFGkr5CzagjKddZZPfSPEHnjdQqF
Ga4RDI1rJXkpbZ59fdr/7BuJ+/GAMuXQ5djRfY/is7xSzirYfAnYTgEyfov80Ja9
/MGpokXWBqfsJy9m4d5/SV8QEKI0pDVzRVOVfykBL8eIu/4P7kA9rbRGh9EfkXt1
zn5ye70Vtael/n2txyPoSnrQzyYgpEotzd5LR//5GX8HeTBVgyjP1wdMrVB4wPrZ
wmrxe5hV8PfNoJARFoob
=gRM7
-----END PGP SIGNATURE-----

--=-S4I/9ARYZrHsuC6kYDfI--

