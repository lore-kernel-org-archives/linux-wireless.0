Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbXLJPTa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 10:19:30 -0500
Subject: Re: coding style lesson: iwlwifi vs. endianness
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1ba2fa240712100618g35a8e13ve143f8687f1b531a@mail.gmail.com> (sfid-20071210_141923_263986_418FFADB)
References: <1196189059.6058.95.camel@johannes.berg>
	 <1ba2fa240711281020n6052980cl610f6c790788d2da@mail.gmail.com>
	 <1196286192.4967.29.camel@localhost.localdomain>
	 <20071129005810.GA6161@tuxdriver.com>
	 <1ba2fa240711291502k65cefd5au60f2c22d6f436c82@mail.gmail.com>
	 <1197286949.6035.49.camel@johannes.berg>
	 <1ba2fa240712100618g35a8e13ve143f8687f1b531a@mail.gmail.com>
	 (sfid-20071210_141923_263986_418FFADB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6qA+/lVYhBHBHjue+t1u"
Date: Mon, 10 Dec 2007 16:18:57 +0100
Message-Id: <1197299937.6035.81.camel@johannes.berg> (sfid-20071210_151933_298945_86D0A6F8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6qA+/lVYhBHBHjue+t1u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I never said you should keep native layout structures. I merely said
> > that it leads to better code if the data is converted to CPU endianness
> > at the system boundary. While the actual system boundary is obviously
> > the PCI(-E) bus, the logical system boundary may well be at the point
> > where you load a certain value from the DMA memory into the CPU to
> > operate with it (whether it's then pushed back out to memory on the
> > stack is uninteresting).
>=20
> I'm not buying this logical boundary definition if you don't do clean
> cut you still have to be endian aware across the whole code so what's
> a difference.

No, you only have to be endian aware when you do a load from a structure
you *know* was/is DMAed from/to the card. That's a world of a
difference.

> Yes, doing that can lead to larger C files, but
> > the compile result won't suffer; given a sufficiently smart compiler
> > it'll even be *completely* equivalent on little-endian platforms
> > (because nothing is declared volatile so the extra variables containing
> > the CPU byte order fields can be completely removed by the compiler by
> > going back to the memory the data came from if not enough registers are
> > available).
>=20
>  b =3D le_to_cpu(a)
>  b !=3D FLAG
>  a =3D cpu_to_le(b)
>  is probably longer then
>  a |=3D FL:AG_LE;
>  n matter what.

Obviously, with a flag this is true. But if you see my example below
then you'll realise that most of the time you don't just do a single
flag in a but multiple multi-bit values.

> > Maybe it's "natural" to Intel people to think in little endian, but I'd
> > guess most other people don't want to be bothered thinking about
> > endianness in every single line of code
>=20
> I still argue that you will have more swap operation in the code
> meaning that you also will have to be aware of endianity at least with
> your definition of logical boundaries.

Not considering single bits, you will have fewer swap operations as I've
shown in my example code. And you're only hiding the fact that you have
many more logical swap operations, most of which are of course constant,
when you do consider single bits.

> This I will fix. This just another of exemption of our approach.

There's nothing you can fix here. It's not an exemption of your
approach, it's a logical consequence of your approach. Making exemptions
for things like this in your approach will imho most likely make the
code even worse. But I'm interested to see how you want to "fix" this
without going to CPU-defined constants instead of LE-defined constants.

And once you start *mixing* the two approaches things will *really* be
confusing, so you really do need to write it the way I wrote (almost
quoted but simplified).

johannes

--=-6qA+/lVYhBHBHjue+t1u
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR11Y4KVg1VMiehFYAQKkpg/9HUoVJ64H+zih34f4hYdxoArpJY2OQOob
siMStVgd7rdVOU5CGMT+Xz9rZJAiXtzUhjLSd4IcPadGOPJFYVGubH3HgyA0T6lK
d5ENFuRdYp29Ae+m0rc12vs1PR0nvfuck1txO279bFHagJMpaB+66dGsoT7gNB6u
HSmvLS5YIUWy3pzdBp1jTqXb96o4h6nbU86dMLHpswH40F7sHb4revW93nBWj5ei
zOAAZN0XM+GIv/i86Dw9+kZ2of0kIos5bFuWqA+Y8lJRm8zWzl8AKrHBMeEISbJZ
eHzoQh++GGjjHqrgGBw9L+qIBNZl431sFikmkj5BbSRibrm+s/A78jL2x+igMwEf
flZXgoZGaTjLFi+Yv4FHLbZv0oD+9kTz+RHKSiAsYesK6lVUqJ6noJtV2vEzi02g
yomw89kb3GEpinQCggsU7Pg2D46NWgeL0cvhuCA51uQC0DOk3IqKPTmS1BPj1zGF
j+ujU2GzjJ5NPNyGihf66aP7EYsN5ur7trPXAR/KbqG0hs8IOW+BHfz5MUh1zV6z
hC6uDHsZA5rbiGA2Bm8P5Gpr5SP1nMapP5pl/qXuJZ/l5h1I1xFG5nzNuSiHJ5G8
7Ckhr0jXP/28GhaFstlX2rnQ/yHDZv3VG7n1VNdnDqApiICPaZsFrHI+4SHlcg0v
zt89HWZFmC8=
=Rcer
-----END PGP SIGNATURE-----

--=-6qA+/lVYhBHBHjue+t1u--

