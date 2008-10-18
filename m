Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34634 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbYJRSW4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2008 14:22:56 -0400
Subject: Re: [PATCH] Add nl80211 commands to get and set o11s mesh
	networking parameters.
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: colin@cozybit.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net
In-Reply-To: <200810181900.48707.mb@bu3sch.de>
References: <48f7dedf.16098e0a.7692.537e@mx.google.com>
	 <1224341637.6324.29.camel@johannes.berg>  <200810181900.48707.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tHYtTaR67H2uIglNBwQL"
Date: Sat, 18 Oct 2008 20:22:49 +0200
Message-Id: <1224354169.6324.33.camel@johannes.berg> (sfid-20081018_202309_867633_B056A92D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tHYtTaR67H2uIglNBwQL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-18 at 19:00 +0200, Michael Buesch wrote:
> On Saturday 18 October 2008 16:53:57 Johannes Berg wrote:
> > > +	return (mask >> (attr-1)) & 0x1;
> >=20
> > I think
> >=20
> > 	return mask & (1<<(attr-1));
> >=20
> > would be easier to understand.
>=20
>=20
> I'm not sure if that would be correct.
> The returned type is bool, which is 8bit. mask is 32bit.
> So if attr is > 8 you end up with truncation, AFAICS.
>=20
> So it should be
>=20
> 	return !!(mask & (1<<(attr-1)));

Indeed.

> to explicitely convert the mask into a boolean with the LSB
> indicating the state.
>=20
> But the original contruct isn't that bad, either, IMO :)

True :) I just had to think about it for a moment, but that's ok :)

johannes

--=-tHYtTaR67H2uIglNBwQL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI+il2AAoJEKVg1VMiehFYpDoQAJ76v8OOIOzkC4v6lHodrXXt
iK70G14VL5oMmH6VtUc5LrI6jLv8pK0mnL0bpEFQ8qRhARbMW3bFFCbrYE1L9Zae
NQyvak1WD4Lk1DzkiaJqfnAfhF8v3JwxQmyvEYeV2QEnKG1wmTvRebNS/RdI1Mk6
RI2970Nh7WRp/dzW8Kk8J3UFjRdFwaRYwBbR9ue19ppMA+shnABbOeX/bfsfLbcH
s7tfrJzu+n/FLP2TwMCg1JCgFBYnWjOwNEQ/LmfKEDbRVEjgykXACBcA9ryjBEj4
KY4lpy0wSiGqtvAvboNrbQ5NIf6GLd33/XJ94P/BlHRBrMt1unYDFsAQ3AuyfO9l
eO8trmXKfztMHL/NIdjOHYZRy5ICT4vvs15I6gk8bF5z42eOpSyGCtJJfA6aFRaK
Wper37EF5KknWdhYaSSqi2nk8ppqyupz5kel3h/YhMoW1svO8hyil+FIRnm/9Xeb
T4tlWvaL9OldUzQE48vMngU5Fd56OGjPnWwiICofMpaL65C2xqskIeYZBtaFDC2O
bCS+d5ac/o08fjqH/9ToTGFSkfhFSk6nwH+qNBtJU0N+cb7s63cAbNoQ44uX1xDT
MPDwiBIu1Wjid8rloaycARXjL02tdl6O0o7JO2kFC7PXj9yS1qoDjmNesWto4ciI
2MPnq7E/z7NDTgA8B/vp
=t1+a
-----END PGP SIGNATURE-----

--=-tHYtTaR67H2uIglNBwQL--

