Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53455 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbZCWT4n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 15:56:43 -0400
Subject: Re: Kernel panic with zd1211rw and today's compat-wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	"Alexander E. Patrakov" <patrakov@gmail.com>,
	linux-wireless@vger.kernel.org, mb@bu3sch.de
In-Reply-To: <20090323194523.M76544@bobcopeland.com>
References: <20090322174515.22f11d92@home.aephome.ru>
	 <1237726612.19647.2.camel@johannes.local>
	 <b6c5339f0903220749j5373d132gdf24edc4d6ac610c@mail.gmail.com>
	 <87iqm0s2dy.fsf@litku.valot.fi>
	 (sfid-20090323_160900_704015_CEA0ADD2) <1237836988.6147.18.camel@johannes.local>
	 <20090323194523.M76544@bobcopeland.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-X//pPiTj5UQenuMPrvb7"
Date: Mon, 23 Mar 2009 20:56:22 +0100
Message-Id: <1237838182.6147.20.camel@johannes.local> (sfid-20090323_205644_794372_0886E92A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X//pPiTj5UQenuMPrvb7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-23 at 14:52 -0500, Bob Copeland wrote:
> On Mon, 23 Mar 2009 20:36:28 +0100, Johannes Berg wrote
> > I think I'm in favour of "downgrading" that to a WARN_ON, like this:
> > 	if (WARN_ON(...))
> > 		info->control.rates[0].idx =3D rate_lowest()
> >=20
> > johannes
>=20
> How about the similar WARN_ON() in ieee80211_get_tx_rate()?  Does
> it make sense to try and tx a frame but return null for the rate
> structure?

Not really, I think. But it should only return NULL if the above
condition was true.

johannes

--=-X//pPiTj5UQenuMPrvb7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJx+ljAAoJEKVg1VMiehFYqTEP/RNRBvth/FRcV3pA+QO6iqQ7
Icp12ufeFA6jhuY9TcGwFxZD0TM7cN/NrzWYxlvE4rEh5dcxVMdTmgbF1gypeh2a
tqRvgOiw18Oc/5A2k1PGWUi8L+i9JiyLoDpPHOdG+q7rukB+uaUK9zGY6SDIsUv7
SfMYY59KsbL5vk8kg6NA7ISi+IxZN+hJXrq7JO0pGslJIQZFSaHJv3DJPBolKAxX
2Q1y2h9hyCf3x2SuiNKl+seZkMZcbzDqCdb8OrKXiTceTBiXhLGIcU2uq//Wx3B6
sNshdRwOvUHzIiSBobpcOtr/285bdWdlVjA/GC6YBeXBEMyBQFPUAMt+wBGl7vJ3
fW7YGwhAessRwH8SQOlUo5dvBiUje6Ahhw1UQvCYOlBPKQi+1d40/J3UAxLkU6Uj
ikppY09XZp8jSu0FXck9ouBJnZLZIEpw68Ix8S8wmDPSmjtbifHJs0beEePA5Vfp
FtmZ6sKUeE/HAGgCnPhtYSQ9as8MNx5xc93OZxUdH6/ygyLm8RuzvALoIwa3znYR
XwNYo5RevJseKRHG9CHxKRF4K25RBKZLk3gqA/bmQm8AW2d4zxeLXZ7Lub+5WauH
FjVoDfI/eG4e5UiVdzmreHrLDzgOONzwhyjxM8Cl0wxOnuDKEadWSugAy/AQO5y/
nXPdHs97qPwG6mar0YaO
=Z9D1
-----END PGP SIGNATURE-----

--=-X//pPiTj5UQenuMPrvb7--

