Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38466 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbXLJQTN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 11:19:13 -0500
Subject: Re: coding style lesson: iwlwifi vs. endianness
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <200712101630.48124.mb@bu3sch.de>
References: <1196189059.6058.95.camel@johannes.berg>
	 <1ba2fa240712100618g35a8e13ve143f8687f1b531a@mail.gmail.com>
	 <1197299937.6035.81.camel@johannes.berg>  <200712101630.48124.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Duk/1ka2kIaB2XxdSQva"
Date: Mon, 10 Dec 2007 17:18:43 +0100
Message-Id: <1197303523.6035.92.camel@johannes.berg> (sfid-20071210_161915_963222_EEBF4C26)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Duk/1ka2kIaB2XxdSQva
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> my_data =3D read_drom_device()
> swap_to_cpu(my_data)
> do_whatever(my_data)
> store the data somewhere else in the device structs for
> later use, maybe.
> do_something_else(my_data)
>=20
> You see that now you have only _one_ place that you have to care about.
> And if you have to write your data back at some point, simply do it
> just before the write.

The thing is that Tomas is saying that because they don't have a
function to "read_from_device()" but that is rather only
"shared_structure->something" it is special and completely different
than regular drivers.

The absolute worst thing imo is in the current radiotap code (before my
patch) where it passes around a value as "u16" but then needs to convert
it to __le16 before accessing bits in it because things are defined as
LE.

Also, let me reiterate the argument that this is not using more
code/run-time-memory size:

Consider

u16 phyflags =3D le16_to_cpu(shared_struct->phy_flags);

[...]
if (phyflags & ...)
[...]

vs.

[...]
if (shared_struct->phy_flags & ...)
[...]

If you have a LE machine, then the compiler should in both cases emit
the same code. If you have BE machine, you have a *single* "superfluous"
byteswap, and if there are multi-bit fields you have far *fewer*
byteswaps. If you instead wrote

u16 phyflags =3D le16_to_cpup(&shared_struct->phy_flags);

then most likely the byteswap would be microcoded/done by hardware
during the load.

The actual runtime penalty of byteswaps is insignificant since fetching
the value from memory already takes forever.

johannes

--=-Duk/1ka2kIaB2XxdSQva
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR11m4qVg1VMiehFYAQLzvg/9EMdp22msnjQ8tpCOfjwk2g2CNOExrtqV
gKNLVQnAsrMTJiTVsveBSl798vSOt4NG3pIGeRpGoMu01nvE/uoIuEaSBztWGSLj
RqL/wxdnXgV2pwaPNK2menE4lbSQg7613wFwXHAMGvHLRConfE/InT5gWQOdZkB7
f9TGSsXsX9jNl7eUnRwerkAdfyorrHUTg55x2aOEKSoVjkOkOVJ+wBNxWfO7pf5G
fmHPduy3Ynf0nI7unV266wwr4uq248Yh7gCjfEkt9Sm5mwjdk3pa6aH37f/oqHK7
ktXcoP+sRRagLj5RxgO9MKPL8miuAt6EztxrK10k16meSKO8eKyQETeb/DN1hCdZ
j96KFaseMfm2cgpmjEUrhrZnW3BrG+veXD46OPc2HmobOPA8q7DdkDd0a84fQ4vP
uTVWLw+vtz6wSebEcud2xfp0aKyNM+dH1sjTBncbRxkm+JfhF3LsHPwWxZhHTpnK
W2gSNdt8iqDwColkw5ybA26NSHKTFFn+04FE5gt9B3MlHPOfG/xJd4BvFwU+SZLq
zpkh2x549z2DuW2uMbc4d22Y+nL5+ASzZQx3ZUecXKVwR98f9apVuxCu2nJwtXqy
tFc+5T417D6Fb6V9PDHraKBga/GKPIjJpwghfdCsoikr4c2HXXVCfMFDzULEsEBF
zLSihXwxdPE=
=XOJL
-----END PGP SIGNATURE-----

--=-Duk/1ka2kIaB2XxdSQva--

