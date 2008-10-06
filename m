Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58026 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYJFNVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 09:21:53 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1223298455.15196.18.camel@johannes.berg> (sfid-20081006_150810_157765_23C3C8AA)
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 <1221123779.2513.88.camel@debian.sh.intel.com>
	 <1221184060.11498.3.camel@californication>
	 <1221185432.6695.0.camel@californication>
	 (sfid-20080912_041007_653566_F8146EC3)  <1223296221.15196.6.camel@johannes.berg>
	 (sfid-20081006_143057_986057_BC4A63C0)  <1223296359.15196.8.camel@johannes.berg>
	 (sfid-20081006_143329_031518_3AA03EA8)  <1223298455.15196.18.camel@johannes.berg>
	 (sfid-20081006_150810_157765_23C3C8AA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FpBWEH6SdlxAgkeZVl8k"
Date: Mon, 06 Oct 2008 15:21:21 +0200
Message-Id: <1223299281.15196.21.camel@johannes.berg> (sfid-20081006_152157_724356_6DB90F0F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FpBWEH6SdlxAgkeZVl8k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 15:07 +0200, Johannes Berg wrote:
> On Mon, 2008-10-06 at 14:32 +0200, Johannes Berg wrote:
> > On Mon, 2008-10-06 at 14:30 +0200, Johannes Berg wrote:
> > > On Fri, 2008-09-12 at 04:10 +0200, Marcel Holtmann wrote:
> > >=20
> > > > I take this back. It took a couple of hours, but it crashed again.
> > >=20
> > > Do you have 64k pages enabled? My issue goes away entirely when I
> > > disable 64k pages.
> >=20
> > Well, clearly not entirely. But it's holding up much better now.
> >=20
> > [  325.379292] iommu_free: invalid entry
>=20
> I added two printks to make it easier to look at:

adding printk to iommu_map_single, we see that the address was never
even mapped!

[...]
[  297.544692] iommu_map_single =3D 10ef2000
[  297.544711] iommu_map_single =3D 10ef4000
[  297.646975] iommu_map_single =3D 10ef6920
[  297.748983] iommu_map_single =3D 10ef7b68
[  297.953110] iommu_map_single =3D 10ef8db0
[  297.953229] iommu_free: invalid entry
[  297.953245] 	free_entry=3D 0x991c0
[  297.953256] 	npages    =3D 0x1
[  297.953268] 	entry     =3D 0x991c0
[  297.953279] 	dma_addr  =3D 0x991c0100
[  297.953290] 	Table     =3D 0xc00000000083f348
[  297.953302] 	bus#      =3D 0x0
[  297.953313] 	size      =3D 0x80000
[  297.953324] 	startOff  =3D 0x0
[  297.953333] 	index     =3D 0x0
[  297.953349] ------------[ cut here ]------------
[  297.953361] Badness at arch/powerpc/kernel/iommu.c:260

clearly, that can't be right since iommu_map_single has been returning
increasing numbers up to this point, and a dma_addr of 0x991c0100 wasn't
among them.

johannes

--=-FpBWEH6SdlxAgkeZVl8k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6hDNAAoJEKVg1VMiehFY2T8QAJatYPgtf/okyVW6CK28fLyH
mkdO38qoyU+8XpI5Q8GTSdadL1Y/Zz2kdPPbKy9dlXvjT/M+znmhLO/tgiP4IlIK
WuLi9j0b4k3IR4NoAz29yc/uq+owDfcNowOa3aNtjQ+8AE/sgCDlSpyMlEz4np4u
TTCji2Wi76vy9b9YrmSy55Z45QS0bj9DQnr71ITfAOtzEE00gTJqLZxBZnHLJ0yl
4q4srWfr5S390nJiofj85kbkGNUegNL+jcBBEGRrQim6um+wuq8wd1CSYILqrBb5
SJ/ximX6tlhjYaa4JyR7AgOlhGQpTbaKW1yAAyEm+RZYOheC4SsegZCtSmoyC8mA
9zywttRymJQNQfOjYA67UmaOUfb4oKlwoaBIASTJFmEcoaCLmANj8alOgEU4NlGr
YcVVWf1tot7x/U2L9bCRUabp0ulBwDSoPeSgkq2jHLdK+M/YzM7eu48SMIKQEx99
2j2IjxHP+3aSiDOAuCII3Ew6UPVa9CmkqPDqebIkxP/N3uZuGfD3q1Vq4x/QUq/S
i7+6Fp/VX+ZU1c9gHktLMSLK2j7zWdFefW/aHuZngELOc97WQIYTGgYrbnbl5gS2
VKQ9IWwdJ/9YsYotOn3+IWYij/mf/ae/wiCqo38c2oX8V6uF4A+4aiYo5pZXvu7r
Q8ZJipBbM8yrdveQynuA
=O2WR
-----END PGP SIGNATURE-----

--=-FpBWEH6SdlxAgkeZVl8k--

