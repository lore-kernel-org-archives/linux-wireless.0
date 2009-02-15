Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59857 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbZBOLB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 06:01:58 -0500
Subject: Re: [PATCH 07/10] cfg80211: add assert_cfg80211_lock() to ensure
	proper protection
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1234589627-16977-8-git-send-email-lrodriguez@atheros.com>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-8-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ISgTh6O8ZicbwYpvMnCo"
Date: Sun, 15 Feb 2009 12:01:53 +0100
Message-Id: <1234695713.4219.51.camel@johannes.local> (sfid-20090215_120202_625411_79F5AE1D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ISgTh6O8ZicbwYpvMnCo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-13 at 21:33 -0800, Luis R. Rodriguez wrote:

> @@ -1122,6 +1128,9 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg=
_set_by set_by,
>  	bool intersect =3D false;
>  	int r =3D 0;
> =20
> +	if (set_by !=3D REGDOM_SET_BY_CORE)
> +		assert_cfg80211_lock();
> +
>  	r =3D ignore_request(wiphy, set_by, alpha2);
> =20
>  	if (r =3D=3D REG_INTERSECT) {

still conditional locking?

johannes

--=-ISgTh6O8ZicbwYpvMnCo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJl/YfAAoJEKVg1VMiehFYQUUP/AwQ+Ylujh9tJ99O+i4+PGxc
P2tGDZPJHWkKpA/hmgofkqShCduKSmXDD+PLwFm1KzKvLvsnJJuAbITc9zNeV5/H
gUNYhQWT676R3487WMjGKLbBGqkzpPExr3dI8m0b+gESQLqtW9PVDpIDkCPOdF98
Hn0uuQo/dldKGw3dv8p77c94yjUgJ3CvFPkKnt79itx3wqw42ky2AE+ZaxcvIlwL
xy+sjfIR/wUsgvrVoU1deG3T8ZQgcE5axgYh9hHYy/jDdUEBYu059xPsmFQWOSZ9
fFY5px79IuuIsAMgvEHePd9/4DMGGUnAtgx/fq7tQob1XYCRMjVFbUBp1OO7Me2z
cHo7bp1oHBdtMFlPMc4tzRIo9/QxXbMbyTi0oLYlNkJGmv1ajGHH5Kue9DvhYb8s
Qmzmo39BFETm9M54/ZfZDRyX64dGgGden8TvSeaRTRTA4W1HB+gyLPw6sNhYgMKG
2QRSzk+z3srBfyTrhpgtW6LrCbCdXglfb+DWr5+9xYOHSuVDjwM26Zt4rAoZFKJ3
3oVa34Cu0NoLJ8G95GulePwuGpqr4PzRqmPMAUAg2meaHVFYYAEEiNP0GrImwyK2
tcH6zQj5wLaafTZgsO7OGGbvfF7Uu0o/qe2JXnY0IOKI439MAsqyQSMUGduCY1r5
VpnGveOVsTOp09OWnOjY
=qA4g
-----END PGP SIGNATURE-----

--=-ISgTh6O8ZicbwYpvMnCo--

