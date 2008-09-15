Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37265 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYIOQGp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 12:06:45 -0400
Subject: Re: [PATCH 1/2] mac80211: Support iwconfig enc restricted with WEP
From: Johannes Berg <johannes@sipsolutions.net>
To: Ortwin =?ISO-8859-1?Q?Gl=FCck?= <odi@odi.ch>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1221494210.3700.50.camel@johannes.berg> (sfid-20080915_175726_992604_5474600F)
References: <48CE837E.2010109@odi.ch>
	 (sfid-20080915_174719_472906_26C0ABC9)  <1221494210.3700.50.camel@johannes.berg>
	 (sfid-20080915_175726_992604_5474600F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TZ8+PAPknDDew5DNbebl"
Date: Mon, 15 Sep 2008 18:06:10 +0200
Message-Id: <1221494770.3700.57.camel@johannes.berg> (sfid-20080915_180647_482347_D7E7A583)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TZ8+PAPknDDew5DNbebl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-15 at 17:56 +0200, Johannes Berg wrote:

> > +	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_STA) {
> > +		struct ieee80211_if_sta *ifsta =3D &sdata->u.sta;
> > +		if (erq->flags & IW_ENCODE_OPEN) {
> > +			printk("wext: open\n");
> > +			ifsta->auth_alg =3D WLAN_AUTH_OPEN;
> > +		}
> > +		else if (erq->flags & IW_ENCODE_RESTRICTED) {
> > +			printk("wext: shared key\n");
> > +			ifsta->auth_alg =3D WLAN_AUTH_SHARED_KEY;
> > +
>=20
> Come to think of it, since we already fall back from open to shared-key
> when the AP rejects, why would we want to support this at all? The
> semantics aren't well defined enough to support it _properly_, that is
> have it change the ifsta->auth_algs variable, and touching this variable
> as you're doing in these two patches is just plain wrong since it can be
> changed underneath (yes, you're removing the automatic changing, but
> that's totally wrong).

Then again, I suppose you _can_ actually implement this, but in terms of
which authentication algorithms are allowed, something like:

if (erq->flags & RESTRICTED)
	ifsta->auth_algs =3D SHARED;
else
	ifsta->auth_algs =3D OPEN | SHARED | LEAP;

johannes

--=-TZ8+PAPknDDew5DNbebl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIzofuAAoJEKVg1VMiehFYbo8QAJEPZeTjPs2fcmfALH5xakEo
uwnXb3dCw5Cj92xC88TXFkKwxP4zvAkiszX0FG+wi9AxhpbeTcOo2k1+ycXd+DZx
iTzfW+Kxeef+BO+B4RjUn5gGT8aEsywYwaMcWJs6HSbogDRd348Y/3pMTIM7y7/K
bjP3QDdbl5c0Ntxjz9+pY7n5HOy2xSTjKfpAE1q9K+FY6Ooz4WOoDtKdHd2lyAJt
zPAa23kYezN4tOSPAqKVh/kiWVjO5n92pW454BMZuoUlUcR9EbnQWeWb3l8dh4+p
PeUeOImIc+JeezfCO54ZowWbUTh5HNbmled+/u056Mc+opOR8y1ZNsTGBnO9xhLW
zz3D+VgorpqSl8BI5tI+9sdwi4kLS2YKOOlEPxdhd3Vz2KNkvDwmsOjMn0LCR98i
mlzjBUzxxi8oew2L/XOrF02qdASH4dRvze6PgrwS9R+ud5+I1DTp/vJRY8V20T8z
yeU1mb33OFeEeCQWB1/Y5XF1wvnPlzQ/eusIIzwcek/CMAfwn/ulYQKc1+hxT4PK
qt2SnhRfeQdSZ7g/qYVLWk/hQAg0a70iaz1BTiZ5a2Ht0JjOueakWuCUxMBEfgcM
PL0jA149lkPVDwf4/XxF7taUTgPlNLSLdcJrOy6q3DJlo6dpvlrVFxIwG/jYgpgz
F4fQOGbBUV2GdWfnOvo5
=AAOi
-----END PGP SIGNATURE-----

--=-TZ8+PAPknDDew5DNbebl--

