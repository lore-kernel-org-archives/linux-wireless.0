Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50547 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbZBPKCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 05:02:51 -0500
Subject: Re: [PATCH 08/10] cfg80211: make regulatory_request use wiphy_idx
	instead of wiphy
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890902160155j402e887an9c5ea3ca9b9f64f3@mail.gmail.com> (sfid-20090216_105534_710168_C595F3A3)
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
	 <1234589627-16977-9-git-send-email-lrodriguez@atheros.com>
	 <1234695858.4219.54.camel@johannes.local>
	 <43e72e890902160155j402e887an9c5ea3ca9b9f64f3@mail.gmail.com>
	 (sfid-20090216_105534_710168_C595F3A3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dlBNSdiLL7vh0RLGZY9A"
Date: Mon, 16 Feb 2009 11:02:46 +0100
Message-Id: <1234778566.4219.120.camel@johannes.local> (sfid-20090216_110255_562148_F76CCAC7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dlBNSdiLL7vh0RLGZY9A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-16 at 01:55 -0800, Luis R. Rodriguez wrote:

> >> +static inline
> >> +int wiphy_idx(struct wiphy *wiphy)
> >> +{
> >> +     struct cfg80211_registered_device *drv;
> >> +     if (!wiphy)
> >> +             return WIPHY_IDX_STALE;
> >> +     drv =3D wiphy_to_dev(wiphy);
> >> +     return drv->wiphy_idx;
> >> +}
> >
> > I neither like the name of this function (same as the variable name) no=
r
> > the function -- you're using it in exactly one place where you cannot
> > ever pass NULL afaict.
>=20
> Nope, I'm calling it from 2 places:
>=20
> * Driver hints which never have the wiphy NULL
> * __regulatory_hint: called from 11d hints, and from the workqueue
> that processes the pending requests (which can come from userspace or
> from drivers right now).

Ok, but in the first case you can't have NULL, and in the second you
could just inline it. It's not an operation that requires an inline here
for it.

johannes

--=-dlBNSdiLL7vh0RLGZY9A
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJmTnCAAoJEKVg1VMiehFYqEQP/1pMuzPC9f1C0UoiRKxtU/4t
avX4ClJArCqpPQwo39aEKruPbFpnYtvc/J4H1JyfSredKm6h0zYHRoec5iktif5Z
TXsyC+tDFIg4R5EGFD0j7V3C5r0vNGNHbln9mcUcma2SSKXpo8BCiBX54iK//MFc
wqb5C/7q+bzubHlf9LqJCieWvWsgQ8OSfMou8NgDsaoxqkXCf/wAaPq/WqofkA1G
z03Wzylbz81xXj1Gds7+3xgf+Fh9B6tgc0Hw8bTMMwWBcd/0GVmk1y51vXXxJxso
tzVetwPZ3Efrt6mzMeDug7dhasMn4YKP5VwwtKVMBU+eT/yz8stLhfE274idCfG5
vAMWkX8oqkN0dCDgk4smYZJ+XOist/cF5LyjQ/2F1Bw2fODF4hikrgSD0RKCovZZ
EzRry/hgCFctTFg3lfDTQX/RycOiaXyHxnnBe1nKBQp98nfjAQpAPDAFqqYERuJ2
wI4UXNkul5AfMHLVw32dNgzffWe81TgoqWe/+0KzpykY71iKy5y+b6E1RATNrbKp
0L+ZTeePcoVGoACM/uTzootarvhVzwm8Q8gbXlYewfe0Skv4n+HC5UP+9r+Bn9GK
d4QpoelKVY16PyOx3Go3PIVnADz49lYka4cXX+fKOOEAZx0XRvANmrMtEcm9VC3z
FktlIfi9c/jixdKGJOg/
=H5o2
-----END PGP SIGNATURE-----

--=-dlBNSdiLL7vh0RLGZY9A--

