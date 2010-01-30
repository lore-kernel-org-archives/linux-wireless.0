Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39614 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669Ab0A3IoC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 03:44:02 -0500
Subject: Re: [PATCH 1/1 v3] cfg80211: wext: fix cfg80211's SIOCSIWAP
 function
From: Johannes Berg <johannes@sipsolutions.net>
To: shanyu.zhao@intel.com
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1264840545.3546.179.camel@johannes.local>
References: <1264801649-4985-1-git-send-email-shanyu.zhao@intel.com>
	 <1264840545.3546.179.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PtciPfpMNlp/O2OVhXnB"
Date: Sat, 30 Jan 2010 09:43:57 +0100
Message-ID: <1264841037.3546.183.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PtciPfpMNlp/O2OVhXnB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-01-30 at 09:35 +0100, Johannes Berg wrote:

> >  		wdev->conn->params.ssid_len =3D connect->ssid_len;
> > +		if (connect->ssid_len) {
> > +			memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
> > +			wdev->conn->params.ssid =3D wdev->ssid;
> > +		}
> > +		else
> > +			wdev->conn->params.ssid =3D NULL;
>=20
> I don't think I understand this. The wdev->conn->params are initialised
> from "connect", and now you're copying the data back again? That's not
> making sense to me.

Hmm, so setting the ssid to NULL would make it impossible to connect to
any network, no?

I don't think I understand what you want to achieve. Are you, by any
chance, trying to get it to connect to an AP without ever specifying an
SSID? That can't really be supported (nor ever was by mac80211).

johannes

--=-PtciPfpMNlp/O2OVhXnB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLY/FGAAoJEODzc/N7+QmaJBwP/27qYLz5x0IUR2bgFrA2bpiJ
4Sjkn/wdO3Z+bHfjb9GAFzZIOTQLhNnHMci2auSHoArY5ITngns57W5R/BN9WBmH
9rsei1y58ikS9J9xp6P3+8SEVNAXBVvOcgu0J45K+82zELEbPp3hNN7xCNsMgrCI
GQBcDxAn/3LkdOp6Yk6x1uHwyN2pCkNEeE2jEs/WymVPzxtYGoiPbUg1Lb/xTLNQ
Eo4ZnlT4UAX/i7F1ogjMZCggs0SOl2lIW4njNGqUPTtPBGrNORdjPS2BN2DpatpE
jEKMmOP5VSW+A87Er6MKWiMSogUYF4v6YOdDJIXoPv6TYK7e1FE05ovmdc3CM7Qs
Oj7Hsan96+mL8Q6zYqF94i0bNZXCpkZyi7s7Nh9lEXJisu5FFm93e/x3ywwJ0o1H
2CTJiFzC0CHeQC4ICxSVfxXWPPIlRWyAOsAXPsBjZJ7JoI9WDqoXQ2PGmrbPhIDu
URdPtXzJQytUBdRukgIJ78IANFtAQiqNhljwMsvYDMJzJR74dMsr/V0rlRsbEjR4
gKs+CXIMIH2wQ1YvAisARBG7f6LrI6ytp7EcU48CVfUVfjEbmgnKkDtTKsxzv4r0
op7U7lc0gZbUS2IaEbxuit5ZzJ1t99HbMVT81tLkwn8ayduF2C9/x5ImkCnAZwdr
oLhGErOKmkcA0FPtG8jx
=K6p+
-----END PGP SIGNATURE-----

--=-PtciPfpMNlp/O2OVhXnB--

