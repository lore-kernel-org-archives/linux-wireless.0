Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44413 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbZERUGt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 16:06:49 -0400
Subject: Re: [PATCH] cfg80211: allow wext to remove keys that don't exist
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: John Linville <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Samuel Ortiz <samuel@sortiz.org>
In-Reply-To: <1242677076.30019.5.camel@mj>
References: <1242669396.29049.2.camel@johannes.local>
	 <1242677076.30019.5.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GAtKRteC8Esg8X6nH0r1"
Date: Mon, 18 May 2009 22:06:40 +0200
Message-Id: <1242677200.29049.13.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GAtKRteC8Esg8X6nH0r1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-18 at 16:04 -0400, Pavel Roskin wrote:
> On Mon, 2009-05-18 at 19:56 +0200, Johannes Berg wrote:
> > Some applications using wireless extensions expect to be able to
> > remove a key that doesn't exist. One example is wpa_supplicant
> > which doesn't actually change behaviour when running into an
> > error while trying to do that, but it prints an error message
> > which users interpret as wpa_supplicant having problems.
>=20
> It sounds like you are working around a userspace problem in the kernel.

More a "user problem" rather than "userspace problem"...

> > The safe thing to do is not change the behaviour of wireless
> > extensions any more, so when the driver reports -ENOENT let
> > the wext bridge code return success to userspace. To guarantee
> > this, also document that drivers should return -ENOENT when the
> > key doesn't exist.
>=20
> You patch is changing the behavior or wireless extensions.  It would be
> much more reasonable for wpa_supplicant not to remove non-existent keys
> or (if it's unsafe or non-practical for some reason) not to report
> -ENOENT to the user.

Umm, no... my previous patch changed the behaviour and this restores it.

johannes

--=-GAtKRteC8Esg8X6nH0r1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKEb/MAAoJEODzc/N7+Qmaq6MP/0OcpQl1vm5q9Vcu5ufudh+1
xjVwZbgn8mTXy2aKK9nKTVHh+WpCQO08HL9Lk2zANc8QLgPmwWoejrO8kpYuv2nK
vljzZM+1y7Slc/f1ocBPrShWuxMLGmdZctpCxZZoEltokgYnNNQWbCk9iYGqiAWd
aBQxeX5dKshq45V8YbUAqX+DeIsy1W19cgJvv72ojrk4g3lX1hcsyYnl7PQvXnNr
1e+uR2EVl+S6w+Lb2f58dPOjucR4Cl6EvPSADZQw4TcC9XRaGE1svKDAgKCZ73Iu
SCP07R3rkFEm9EqL5Lcmy5NA2n5g1/OgfIGDrcfgRq71xC3hSToBsaR4KKWuUsX3
0r31qmTBOtWqK0PnJA0lN2KwIuimgeZwPdEaQ1x9pJ2ajaFj27hFfmyQNoeR8Bzj
HQ5zkYSrw3qj8UllPApWEw23kcG3UW9nsVfFJHgbEqOY2T2wsqA77e8eMuZOhl2Z
2H6iIL9S8RzqDGRcgdd9N2z6XzH5ullGH2FonhEBlrfPSBq4eY6+OKAhWgEFXhWT
lQobMnp6u4bwWQFD086nmtH2Qb7G3csZlybYejm0+RnyzWASX/KrNyj2Vh1xQRRZ
HBBa+XqgbYLkistwQOA5dgGG7ucfT9UXifPEVv8+3Dtw05htC4/S4WVPdA/iXPsf
JXuDiIpdYq1ZBGNhbVQr
=ibpd
-----END PGP SIGNATURE-----

--=-GAtKRteC8Esg8X6nH0r1--

