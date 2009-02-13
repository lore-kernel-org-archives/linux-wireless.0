Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60154 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbZBMHSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 02:18:20 -0500
Subject: Re: [PATCH 2/6] cfg80211: add wiphy_idx_valid to check for
	wiphy_idx  sanity
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890902122308x375cc22fu1c27f8fe9aaac524@mail.gmail.com> (sfid-20090213_081423_734967_DF01AF3C)
References: <1234503363-11014-1-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-2-git-send-email-lrodriguez@atheros.com>
	 <1234503363-11014-3-git-send-email-lrodriguez@atheros.com>
	 <1234507985.1327.15.camel@johannes.local>
	 <43e72e890902122308x375cc22fu1c27f8fe9aaac524@mail.gmail.com>
	 (sfid-20090213_081423_734967_DF01AF3C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TReOPSwdBXodJ0eFEUVD"
Date: Fri, 13 Feb 2009 08:18:15 +0100
Message-Id: <1234509495.1327.27.camel@johannes.local> (sfid-20090213_081822_593590_5CE864D5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TReOPSwdBXodJ0eFEUVD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-02-12 at 23:08 -0800, Luis R. Rodriguez wrote:
> On Thu, Feb 12, 2009 at 10:53 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2009-02-12 at 21:35 -0800, Luis R. Rodriguez wrote:
> >
> >> -     if (unlikely(drv->wiphy_idx < 0)) {
> >> +     if (!wiphy_idx_valid(drv->wiphy_idx)) {
> >
> >> +/* Note 0 is valid, hence phy0 */
> >> +static inline
> >> +bool wiphy_idx_valid(int wiphy_idx)
> >> +{
> >> +     return (likely(wiphy_idx >=3D 0));
> >> +}
> >
> > Does that really work properly with the likely in there?
>=20
> Oh you mean !likely() won't give me my unlikely() effect? I think so
> as the path is meant to not be optimized so the optimized path would
> be put first, no?

Well keep in mind that likely() also affects branch prediction on some
CPUs where you can annotate that, and I think it wouldn't be possible
for the compiler to get it out of the inline there properly.

johannes

--=-TReOPSwdBXodJ0eFEUVD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJlR60AAoJEKVg1VMiehFYVe0P/RJwt6zWNIkl1ZnKY2D//ngD
bI5sgiEaIyJ4DwH5HlFfTdQU2T9NVCHStFiHfzHv5mnP1eagyR6/YfxxJ3LbmMvq
cxjDxOdxqzaADouRHPwOg1RVcZJzulwtz7a46olKeTNnqkU7oGeDh/r+I1nOIFti
qaeR2BOGaJVYGtZzJpVwkmphZv/AU7Ng1Arqt33FHxMQzUddVg5YmYJaA8nt07tM
+Xv4tO74L2nnrogt1SUDlZt1EUQ4ybaEw7at6Qc/TqjCif9zeftJuWThOQQD+FQx
+fcmBnwMOuW9fU9ku2aEs5AWAVefXREzSUKa9oPm+0dsrQ9bWBvk/x4QcWdE4Kwe
aQlFuTo8xkYjeWpg54tmpxdt19wXt2NAco20iJ3xKBEoPs5RSVGnF2IhbCdX0abN
DWsgd5Of5Y4AgM9N+qvHqrFqbBBNCLJHEcm7MHU9wBK4Otni2DwbHOXnd9XQkp1V
+lpb27kbFDpaRGMmuVdF437KqfsFRIvHt8+CwfD25ulln1xXqJDq4z/1vmjGzCG2
XPHTmbhpP/ZyH8vT5oIBs0N0TQKAFL2uXU1KVewvkiEsEWZWg2cvT2LzKR+iCoWB
8Y4bWR6sn7IFqvMm0d3yiefeaoz6kJTj7rDPeB5URe6XicnaAGm7TqjoyIHehJdl
eHGqf5eaoMZey8m5SoaN
=57A2
-----END PGP SIGNATURE-----

--=-TReOPSwdBXodJ0eFEUVD--

