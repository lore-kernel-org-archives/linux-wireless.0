Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbXLJMIX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 07:08:23 -0500
Subject: Re: coding style lesson: iwlwifi vs. endianness
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <1ba2fa240711291502k65cefd5au60f2c22d6f436c82@mail.gmail.com> (sfid-20071129_230229_963685_5642DCB9)
References: <1196189059.6058.95.camel@johannes.berg>
	 <1ba2fa240711281020n6052980cl610f6c790788d2da@mail.gmail.com>
	 <1196286192.4967.29.camel@localhost.localdomain>
	 <20071129005810.GA6161@tuxdriver.com>
	 <1ba2fa240711291502k65cefd5au60f2c22d6f436c82@mail.gmail.com>
	 (sfid-20071129_230229_963685_5642DCB9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aMtGr4kyaxIsnV62ovAh"
Date: Mon, 10 Dec 2007 12:42:29 +0100
Message-Id: <1197286949.6035.49.camel@johannes.berg> (sfid-20071210_120839_095615_90764A5B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aMtGr4kyaxIsnV62ovAh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Apologies for the late reply, I was rather busy and wanted to
investigate your claims a bit more in detail.

> Iwlwifi driver talks to firmware using so called host command
> structures defined naturally in little endian.=20

Yes, I know that. I actually read the code before saying it was ugly.

> Statistically most of
> the operations are setting and testing bits which is endianity
> agnostic meaning no run time swap operations are needed.

It's interesting that you say this, single bits don't need any
endianness conversion at all if you simply define the container types as
u8. Of course, that isn't always how the hardware is documented and not
always the right thing to do, but it is possible.

However, with much of the code it it would actually make sense: For
example, RXON_FLG_* go from bit 0 to bit 7 (a single u8) and then comes
the antenna selection mask. "HT flags" are called "flags" but really are
two- and three-bit values mashed into a single field so the "flags"
argument doesn't apply. Filter flags go from 0-6. Similar for QoS flags.
Key "flags" really aren't completely flags, contain a three-bit field
for the encryption type. etc etc.

> The few computation including the shifting one visible in Johannes
> example are the trade off of run time efficiency and 'ugliness'. It
> was better bargain for us.  Iwlwifi keeps that in host command
> structures through the driver operation so we don't need to keep
> shadow native layered structures and there is quite a few of them.

I never said you should keep native layout structures. I merely said
that it leads to better code if the data is converted to CPU endianness
at the system boundary. While the actual system boundary is obviously
the PCI(-E) bus, the logical system boundary may well be at the point
where you load a certain value from the DMA memory into the CPU to
operate with it (whether it's then pushed back out to memory on the
stack is uninteresting). Yes, doing that can lead to larger C files, but
the compile result won't suffer; given a sufficiently smart compiler
it'll even be *completely* equivalent on little-endian platforms
(because nothing is declared volatile so the extra variables containing
the CPU byte order fields can be completely removed by the compiler by
going back to the memory the data came from if not enough registers are
available).

> Also number swap operation is much lower then the other approach.

As I will show, this is not true. At least not if you go away from
"shadow" structures.

> We rather think of all constants for host commands as liitle endian.
> As we stick consistently to this paradigma it becomes natural.
> I'm not sure if this was a good decision for a long run as we are
> adding more hardware and we are need more abstraction, at that point
> it looked correct.

Maybe it's "natural" to Intel people to think in little endian, but I'd
guess most other people don't want to be bothered thinking about
endianness in every single line of code.

Here's my argument for why this is inefficient not only in terms of
comprehensibility but also in terms of runtime penalty.

Let's consider STA flags. I don't know whether they're written or read
more but it hardly matters.

The field is defined as follows:
| bits | 0-7 | 8       | 9-16 | 19-20 | 21  | 22          | 23-25        | =
...
| means|  -  | pwrsave |  -   | aggsz | fat | mimodisable | mpdu density | =
-

In order to set all information in this field, you need code like this:

--- >% ---
__le32 staflags =3D 0;

if (sta power save)
	staflags |=3D STA_FLG_PWR_SAVE_MSK;

staflags |=3D cpu_to_le32(ampdu_factor << STA_FLG_MAX_AGG_SIZE_POS);
staflags |=3D cpu_to_le32(ampdu_density << STA_FLG_AGG_MPDU_DENSITY_POS);

[...]

memstruct->sta_flags =3D staflags;
--- %< ---

(similar code is present in iwl4965_set_ht_add_station)

Let's compare to my approach (assuming the constants are appropriately
redefined):
--- >% ---
u32 staflags =3D 0;

if (sta power save)
	staflags |=3D STA_FLG_PWR_SAVE_MSK;

staflags |=3D ampdu_factor << STA_FLG_MAX_AGG_SIZE_POS;
staflags |=3D ampdu_density << STA_FLG_AGG_MPDU_DENSITY_POS;

[...]

memstruct->sta_flags =3D cpu_to_le32(staflags);
--- %< ---

Notice how it is
 (a) easier to understand (especially when you look at the constants)
and
 (b) more (run-time) efficient?

Yes, you can make a case for "flags are nicer this way", but in fact
even when you have flags it doesn't matter much at all because the flags
value is loaded from memory which takes much longer than byte-swapping
it anyway. [1]

The above code becomes (in my opinion) even harder to understand when
you read out these fields, because it requires doing something like
this:

ampdu_factor =3D le32_to_cpu(staflags) >> STA_FLG_MAX_AGG_SIZE_POS;
[etc]

which is similar to the example I quoted in my first mail and absolutely
not intuitive.

johannes

[1] And you could even use the little-endian load macros (like
le32_to_cpup, beware of alignment though) that powerpc for example
optimises into a single "lwbrx" statement, sparc64 does a similar thing.
For little endian processors it doesn't make a difference at all.


--=-aMtGr4kyaxIsnV62ovAh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR10mJKVg1VMiehFYAQLTsA/+Jv6EX2AH6+8teIHFFf2HyVIc3UY3O77S
+G1vU1wDZx12xxxVPXwLJr1DmoJjapuxepAoboJTKEpvC/uFHy6fSiknpo5I3T68
q3cldr+a2rGFn40TiPA7zrtWZp1H+qeFm/4RpoCsUvDUJataQuFamBcWX5Vi8nki
1OvmTgvCDgfc3ryGiIw4+0tbtBjoPTBcO83QTXSkgHbz59EqA++FYvVd3LlkwjBx
SxFhtaMHCnmvNQc09ZlDg78ZVj6wP/oa2dshxApOhRxdZfzrm5ruGP0jbzyhpvtG
0WK073IXW9+T3VeWuYSGy+6Xn5vxRmgX58SBMYvfMArlAjZ4G/In1Qu4zKtSdPge
5f9AH+lB8vMMQcH+N1YpR9dAX4Sge/bNKDoAFvc79w8spzbhxOhCxP9zt/xl4tjW
+Ky0cjWxWCMVN0DtN+nbianfBU9HeV6LT5gQ+rTLjItzSHwvURD3cGT3WPLh3flT
2XGshXEvRhM3ilWzPrsMUDiWgkhwASI3ZRvGfyt4r4QCinIqnfiC2bQukZE5wSxB
wX2ZTGMVItsh6ALBhvYov1xNkhmH83yA1OaDOrpNQkbX8Y4tzpBM2MOPSZ+TBTxM
y9lm457WWp20CakZoGLL58KrRfKa4EZmtyRZHuYJeM4W7nw+hdL1TN21GT9SptkU
WPuNYKbILis=
=SQy1
-----END PGP SIGNATURE-----

--=-aMtGr4kyaxIsnV62ovAh--

