Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38779 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYJKNsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 09:48:30 -0400
Subject: Re: [PATCH] mac80211: make retry limits part of hw config
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <200810111541.14983.mb@bu3sch.de>
References: <1223682835.29811.10.camel@johannes.berg>
	 <200810111541.14983.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5pW4YSUMKkw26svbYEUw"
Date: Sat, 11 Oct 2008 15:48:27 +0200
Message-Id: <1223732907.29811.43.camel@johannes.berg> (sfid-20081011_154833_327756_6694610E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5pW4YSUMKkw26svbYEUw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-11 at 15:41 +0200, Michael Buesch wrote:
> On Saturday 11 October 2008 01:53:55 Johannes Berg wrote:
> >  static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
> >  {
> >  	struct b43_wl *wl =3D hw_to_b43_wl(hw);
> > @@ -3333,6 +3349,20 @@ static int b43_op_config(struct ieee8021
> > =20
> >  	mutex_lock(&wl->mutex);
> > =20
> > +	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
> > +		dev =3D wl->current_dev;
> > +		if (unlikely(!dev || (b43_status(dev) < B43_STAT_INITIALIZED))) {
> > +			err =3D -ENODEV;
> > +			goto out_unlock_mutex;
> > +		}
> > +		b43_set_retry_limits(dev, conf->short_frame_max_tx_count,
> > +					  conf->long_frame_max_tx_count);
> > +		changed &=3D ~IEEE80211_CONF_CHANGE_RETRY_LIMITS;
> > +	}
> > +
> > +	if (!changed)
> > +		goto out_unlock_mutex;
> > +
> >  	/* Switch the band (if necessary). This might change the active core.=
 */
> >  	err =3D b43_switch_band(wl, conf->channel);
> >  	if (err)
>=20
> This must be done _after_ bandswitch. (You also have a valid dev pointer =
there.
> Just do it after the checks done there).

Possibly, but the original code didn't do that either and I didn't want
to think much :)


> > +	mutex_lock(&wl->mutex);
> > +	dev =3D wl->current_dev;
> > +
> > +	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
> > +		if (unlikely(!dev ||
> > +			     (b43legacy_status(dev) < B43legacy_STAT_INITIALIZED))) {
> > +			err =3D -ENODEV;
> > +			goto out_unlock_mutex;
> > +		}
> > +		b43legacy_set_retry_limits(dev,
> > +					   conf->short_frame_max_tx_count,
> > +					   conf->long_frame_max_tx_count);
> > +		changed &=3D ~IEEE80211_CONF_CHANGE_RETRY_LIMITS;
> > +	}
> > +
> > +	if (!changed)
> > +		goto out_unlock_mutex;
> > +
> >  	antenna_tx =3D B43legacy_ANTENNA_DEFAULT;
> >  	antenna_rx =3D B43legacy_ANTENNA_DEFAULT;
> > =20
> > -	mutex_lock(&wl->mutex);
> >  	dev =3D wl->current_dev;
>=20
> This also is a bit fishy.

Which part? the double assignment of "wl"?

johannes

--=-5pW4YSUMKkw26svbYEUw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI8K6nAAoJEKVg1VMiehFY7jYP/3qwD9m+OkS4enPgEveifS6n
vAwA5dHTLixgWQb0ESrmGrMru+o8P9LboU5e10jqjBB4tswEAlP8+oOZrKmHk25E
sPQBKUld1uwCppsqv1GMPnQHuals5U2+XbUygQIFPBOAMReLsJoO9ykCR10G3+1A
Xr6A5bKY97RC8+RK9lU+fISb7MLUE5CuovBQVcXzoTvOX/04vq/dX9eWCmTBsR+O
rylPlI4wVvjfr8X87VWI3xrCRsKWfaGp4+XndFfQ9gwmQY2INYLprQBmvkN80gYC
R41AZaTV2Ap3SV4G3v3Jp1tcw7zpNO2dBjzSafHkheAf68OgQX2o7hlhc0o7suSY
FLPg718kbDT9mclAWOuBg/dMMuQRss2noGAGFUx6j8Gym4sEovLdYZsHULeUz7+V
oUR2uxSalZkoso+u/l8+TPZQlo+x/xYIRLW1e8QzJ+wiOhq43ZlJ1AEAzkMGYb7Z
ee3zZ248fJuKb0XLW0hyszY9KDq4NUhnJqqJU4omcJwv2LX6C3iOWFblEVGw4Omc
6hsAxUklFk6N2A9uXKS4U6hQIIWj6Hg9Xg7MNsLVtetp+KmgPL6ETPuHwma1NvH5
xJRJwa+nXf81ruqjwsZgx/eaA3EVD2pnfwVw+q9o64R3J+QbKg6pAYrB4AOLv2rK
n1Ts1EpSUG+yUv/OkR/Q
=YD4T
-----END PGP SIGNATURE-----

--=-5pW4YSUMKkw26svbYEUw--

