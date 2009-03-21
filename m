Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59696 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbZCUQ5A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 12:57:00 -0400
Subject: Re: [RFT] mac80211: allow mode changes while interface is up
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200903211745.06974.mb@bu3sch.de>
References: <1237653563.5100.309.camel@johannes.local>
	 <200903211745.06974.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Rq6JlRGKMGRrnphBxSNr"
Date: Sat, 21 Mar 2009 17:56:53 +0100
Message-Id: <1237654613.5100.312.camel@johannes.local> (sfid-20090321_175715_305704_31B33064)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Rq6JlRGKMGRrnphBxSNr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-21 at 17:45 +0100, Michael Buesch wrote:

> > -	return 0;
> > +	if (running) {
> > +		ret =3D ieee80211_open(sdata->dev);
> > +		if (ret) {
> > +			/*
> > +			 * ieee80211_open could fail, for example if the user
> > +			 * wants to have an interface combination now that we
> > +			 * do not support -- in that case roll back. This has
> > +			 * to succeed unless we have a driver/mac80211 bug,
> > +			 * since the interface was there before!
>=20
> What about memory allocation failures?
> I think we should check for an error and if one occurs take the interface
> completely down and return the error to userspace.

Makes sense, need to audit the code though to verify that
ieee80211_stop() doesn't puke if you call it twice in a row (since
dev_close() will call it again)

It's only proof-of-concept code -- like I said, I have no interest in
it.

johannes

--=-Rq6JlRGKMGRrnphBxSNr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJxRxSAAoJEKVg1VMiehFYMuUQAL56ZlJEWsapTjaIjY8zmsY/
7N9CXRRFW8sBFBf5BcH2m88JvYgzTBR404IgUWys11SAH2imwKMQ37pDWT+6U4EC
xoRB+HRNgRMNqsqKdVCqK3sVW9sPTzvswDA2KE8HTN0LZ0BOxsx2IBzpcVGboX4U
3uD4HnS/AWpS0JmaSpHlpnM5YIt6JyXfBZmb6ODd+/54rAVsNvRUvhVBkw/2wYXr
cBaWGWsygVjAsQRV7A9TCV6DeC3jti8lXN+OV56NaiP7B9I2+Km74s1g3J9cOwQY
44NP0aP2+ZD3LHnYuFgPobGTWJTJ40wwEIoyMlqp5wTsR4ZCiPbFerdYL2A8lecD
efHwUcE0KwOPrpQTjgwuFovvxZNlvc23Gg9hnkQr8vcsgTcBlLxohSdNld1Gywfe
zuU0jKeUtAZfHmQKm9ExbBhMf9YvPkQq/LkDNCCOcn7x6uJsFYK4OUT1prGkTd5Q
sKQlwPrO0/IisRD1r9zE1x57PkZ3krglKGLw4CWjN1yA09yYNHdolIroPfPnNkts
mo2WBL8AQp4Epxd7DcWi5pKIlEN3NT724nFo4NaEdBnJ/pAc9uBYHmPIMCE26Rr/
KldkWbzGeLvsbtgAqxs74yz9NCseMmkfr5HTALENxgq1aXpmczdyXlOV7maTUyxS
eKbTc8kzd58aCPY7Mc5S
=bYeN
-----END PGP SIGNATURE-----

--=-Rq6JlRGKMGRrnphBxSNr--

