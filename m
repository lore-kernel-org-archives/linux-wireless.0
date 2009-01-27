Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbZA0LWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 06:22:22 -0500
Subject: Re: [PATCH 4/6] mac80211: More small changes for modularization
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Sesser <flomaillist@cosetrain.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <497EECED.1020106@cosetrain.com>
References: <497E1B90.4060803@cosetrain.com>
	 <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
	 <3202b18e8531aa78c29636c163de20875ae1a9cf.1233001802.git.flomaillist@cosetrain.com>
	 <e236615740b8ce8c9515c14aac3a2d9d93806a98.1233001802.git.flomaillist@cosetrain.com>
	 <79a59b62a4378b8b88cb3a33b1ec3cbd3808906e.1233001802.git.flomaillist@cosetrain.com>
	 (sfid-20090126_213927_757374_C1421A9C) <1233004598.4533.37.camel@johannes.local>
	 <497EECED.1020106@cosetrain.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-V5bxJmzbpfaZ2ZbBwjEs"
Date: Tue, 27 Jan 2009 12:22:18 +0100
Message-Id: <1233055338.4012.36.camel@johannes.local> (sfid-20090127_122238_244540_12D3B09D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V5bxJmzbpfaZ2ZbBwjEs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 12:15 +0100, Florian Sesser wrote:
> Hi!
>=20
> Thanks for your comment. My intention was having a logical seperation to
> enable better discussion of my patch, which I think is pretty much of a
> monster and not yet ready for inclusion?
>=20
> What do you think about my selection of mesh_path_sel_ops and the
> storing of mesh PP/PM/CC id?
>=20
> If you deem it OK I would be happy to reformat the patch (into three or
> so seperatly compiling patches) and include KConfigs.

I also see a lot of EXPORT_SYMBOLs that should not be necessary, but I
need to look through it in more detail. I think your layering may be
broken in some parts. Why, for example, do you need to look up path
selection algorithms by name?

I also think you should wrap things like

osdata->u.mesh.mesh_pp->ops->nexthop_lookup_fn

into small static inlines that can go away if only one algorithm is
built in, for example.

johannes

--=-V5bxJmzbpfaZ2ZbBwjEs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfu5oAAoJEKVg1VMiehFYyAAQALKoDFSUW0F6dv3g0xrB1/kO
e08fGt89WS0AvRhsKZv6QMHE0nmJ5R+G+tOeyO9Yzj38hFoRl4dcXJXDidkEGm+n
JL59nXVFRwYaB6FwHYYDQBkLKdh1EHKQ9ahOCapTalpOH9M9UlLhJBeeKvhMZAF5
aLMt8QO/9n3mkX60dK+C/SN4b3DY5xlXRTvwDgFW/ww9uDifoCA2CVL4PF1J8HCu
BMp3iyWvezncGBb8sO3jcBQFQTKvA5lGUxpD97a8WIQzTy8BuU0C2ZbDBq4LnTg4
uP7Q7Ws77gfSe3fdo56YBtAEX+mXiDRLtj4ffm1kwvWmo5l8gSxALv480gtejT9n
KXBE1uonAuFFmnWvSCXAM5bH0m/+ExEVztlad3IMX/2sg8t6eiJ9S2OXftozUpgm
8P8zIBSKGruAkXrt45h9JTqPqza1WRYgj8stxSis590I6PA6S9o2e0WQw5mjoV1N
hNTQ/4TuTi2165gH1evQ8iSCuHCzpjRndiTgvXCHAolwe+Qhk+EmT6h04rv9jLh6
snWeJUMLFciQDi2NL24BxQzzUImkGHGIWR9sroJcjPayoIbArTQjvhva/dDT7Q7V
nOoBN2SQATjfHyAqf4TrA9V3dZiSxl3k3redjq05gJhtN1YKqpuoEg+UoezkZTaW
VCIx/njeSTOGGiGZZQwo
=csgV
-----END PGP SIGNATURE-----

--=-V5bxJmzbpfaZ2ZbBwjEs--

