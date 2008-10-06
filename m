Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbYJFNIG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 09:08:06 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1223296359.15196.8.camel@johannes.berg> (sfid-20081006_143329_031518_3AA03EA8)
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 <1221123779.2513.88.camel@debian.sh.intel.com>
	 <1221184060.11498.3.camel@californication>
	 <1221185432.6695.0.camel@californication>
	 (sfid-20080912_041007_653566_F8146EC3)  <1223296221.15196.6.camel@johannes.berg>
	 (sfid-20081006_143057_986057_BC4A63C0)  <1223296359.15196.8.camel@johannes.berg>
	 (sfid-20081006_143329_031518_3AA03EA8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-utES3URrO9auzgQf+tPQ"
Date: Mon, 06 Oct 2008 15:07:35 +0200
Message-Id: <1223298455.15196.18.camel@johannes.berg> (sfid-20081006_150810_157765_23C3C8AA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-utES3URrO9auzgQf+tPQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 14:32 +0200, Johannes Berg wrote:
> On Mon, 2008-10-06 at 14:30 +0200, Johannes Berg wrote:
> > On Fri, 2008-09-12 at 04:10 +0200, Marcel Holtmann wrote:
> >=20
> > > I take this back. It took a couple of hours, but it crashed again.
> >=20
> > Do you have 64k pages enabled? My issue goes away entirely when I
> > disable 64k pages.
>=20
> Well, clearly not entirely. But it's holding up much better now.
>=20
> [  325.379292] iommu_free: invalid entry

I added two printks to make it easier to look at:

[  736.879335] iommu_free: invalid entry
[  736.890905] 	free_entry=3D 0xd6ec0
[  736.902494] 	npages    =3D 0x1
[  736.913864] 	entry     =3D 0xd6ec0
[  736.925100] 	dma_addr  =3D 0xd6ec0100
[  736.936116] 	Table     =3D 0xc00000000083f348
[  736.947078] 	bus#      =3D 0x0
[  736.957934] 	size      =3D 0x80000
[  736.968775] 	startOff  =3D 0x0
[  736.979574] 	index     =3D 0x0

johannes

--=-utES3URrO9auzgQf+tPQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6g2TAAoJEKVg1VMiehFYtyIP/iKq6BXGuOYUtZMXPo27pEQy
y/w0hqDoZzR0g4uPDtLMrcCvgcGYu1MZcDJZRUVjo1l5IGKgGhSSCJ7qaDfBGoqO
KQYlpxVDahSDb2o8YipPm3S8VysRZqXl9yCtnUZNA+FzvsPTavJ+XmADcEzvlszS
1sswW6m5qjtStuPLGrsQ5hJyrSL8UCEIznMJyhYKyebfMpj04HEiMKI17IKOCXn3
NSUetANjDsVWhjtBW9PLs+NRCvy2LnGXP4c15TPDajWKZmzSvFe6kQcJ772rPdTC
2NKN1zM2za8LYD3e8DeT+YckwQLASnH4pDpgKOX/s8fFiQGON4xBSa89ESE3TiJ/
NkSarQCQJUXLxGI2nANEqB9jHxEGiFTlf0orLt3kvv1m/rCNCF2Z0y9t7kdLKU0W
C0zFgfYmgt8bKzXwmHg5Rw0t3k2fmoRMOaazApM4BSpJ5PZp9k12lGybVvS86fkZ
7UdjfxHBXMACFSh4X+Vdn7uQih0VO57w4mWAKatN9dLH2I38d7mKp9sSxTpJd+Kd
7lN0YlkrUisTwutSPjcly17iPizbGKWSfmhQqrGcUOpZ6ZqLLqQDiYU7MN9Muj6O
N/pm9e7Jq8D1h6F1IuOcWX69T5bGxedw1FxE6ZEQ3O6CJRxPVKGXmGPIETJ6uFhd
dgr6PgcGdf+0cpbdRomn
=FcLj
-----END PGP SIGNATURE-----

--=-utES3URrO9auzgQf+tPQ--

