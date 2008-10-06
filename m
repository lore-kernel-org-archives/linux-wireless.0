Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43914 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbYJFQzO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 12:55:14 -0400
Subject: Re: [PATCH v2] iwlwifi: fix DMA code and bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223311876.15196.38.camel@johannes.berg> (sfid-20081006_185150_705636_45A51E0F)
References: <1223308831.15196.28.camel@johannes.berg>
	 <1223309405.15196.32.camel@johannes.berg>
	 <1ba2fa240810060949w5404944dud9f7b6b373542981@mail.gmail.com>
	 (sfid-20081006_184903_690814_3BC35C90)  <1223311876.15196.38.camel@johannes.berg>
	 (sfid-20081006_185150_705636_45A51E0F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sg0rtxquUHmnqxEhMJsY"
Date: Mon, 06 Oct 2008 18:54:44 +0200
Message-Id: <1223312084.15196.41.camel@johannes.berg> (sfid-20081006_185519_179479_50D0DD62)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sg0rtxquUHmnqxEhMJsY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 18:51 +0200, Johannes Berg wrote:

> > >  * therefore, all the is_odd junk goes away
> > >  * fix a bug in iwl_hcmd_queue_reclaim where it would reclaim all the
> > >   fragments of a descriptor rather than all descriptors (this may be
> > >   the cause of the dma unmapping problem I reported)
> > >  * some more cleanups
> >=20
> > > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > > --
> >=20
> >=20
> > > Tested on 5000 hw, please apply.
> >=20
> > Great job,  however do not apply this before I review it I had strong
> > feeling this will not
> > work with aggregation flows.
>=20
> I cannot imagine why you think that, care to explain?

Of course, I would very much appreciate you review the actual bug fix in
iwl_hcmd_queue_reclaim, which consist of the addition of the line

+               bd =3D &txq->bd[index];

johannes

--=-sg0rtxquUHmnqxEhMJsY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6kLQAAoJEKVg1VMiehFYdt4P/RTMM0xJWJ0qsyFLokwNlXoN
kwdcdhW7CMPWAwTeyhzzbG7nkzc9JhJDXT7WK2bjsWueKudD6mSTYISoG81Kj/Ks
q3DYVpQ1kNGsxhbBv3Ig5flVFL2CwWF+QbTbifbhqVt5huC0lsWuw6O6YtzIqu3m
yzM+gam6Q7fLOVImgZJaR4s1FSRTI5ghX2+MJz02U9V/gy4E5iqjSlffQkftBFuJ
jML51TeOoibOCU8iZs2AgDewRC4HkSh3MZUeOvhJD3Dz+mnDb+rLSzIpkZOOkPCX
SY9jVaLn3aiQbTKEiGFOrsBWvAwzsLVLXNLQSogUkqKzxlTIrPmpm5nNqAOoh4Qt
awEyOeoMpxEtQ7I7BNmzaPCYnELfQYzpaWs1k5OcZcvshGfLpSyOWcUvN4DHC7VG
reBmMKVkbCBEf4iVbRzqi9h4ichJ8NXDjo/xJENjmWNhWg2EcqgzYS7FA6yyBaiF
QhC+MgEwITj1iKPQCUDORu7yBCQtKtiquAAvgN8++2O+7H+NrF0gi2/X3FDAFjfQ
lZBHSuOxhU3JrHsK3TWyHbP5QORZ4L6mYb1Z4FMunqO910csPhfr3i2z0SjhQXgw
orfFgKYmjw3KwkckRYBB01+UDmCG5Xdd0r7Uv655IWDFQQYyoAtPBJvqntflRaQ+
hUjSNQKPcEuRai/sJ+Iz
=acF6
-----END PGP SIGNATURE-----

--=-sg0rtxquUHmnqxEhMJsY--

