Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbYKRP0Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 10:26:24 -0500
Subject: Re: [PATCH/RFT] iwlagn: fix RX skb alignment
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	reinette chatre <reinette.chatre@intel.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Matt Mackall <mpm@selenic.com>,
	Christophe Dumez <dchris@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
	Jan =?UTF-8?Q?V=C4=8Del=C3=A1k?= <vcelak.jan@seznam.cz>,
	Thomas Witt <witt_th@gmx.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andres Freund <andres@anarazel.de>
In-Reply-To: <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com> (sfid-20081118_151339_564916_705BFF73)
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227001390.4014.43.camel@johannes.berg>
	 <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com>
	 (sfid-20081118_151339_564916_705BFF73)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-n4K/Pcag4wSlybEXDRS5"
Date: Tue, 18 Nov 2008 16:25:03 +0100
Message-Id: <1227021904.4014.58.camel@johannes.berg> (sfid-20081118_162627_906020_C5BE96DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-n4K/Pcag4wSlybEXDRS5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-11-18 at 16:13 +0200, Tomas Winkler wrote:

> >> So I dug deeper into the DMA problems I had with iwlagn and a kind sou=
l
> >> helped me in that he said something about pci-e alignment and mentione=
d
> >> the iwl_rx_allocate function to check for crossing 4KB boundaries. Sin=
ce
> >> there's 8KB A-MPDU support, crossing 4k boundaries didn't seem like
> >> something the device would fail with
> >
> > Come to think of it, maybe it does. One common failure case seems to be
> > "this goes wrong with an 11n AP, but not on a regular one", so one
> > explanation for that would be that the hardware designers expect the
> > driver to split up the DMA into multiple DMA descriptors at 4K
> > boundaries, but iwlagn uses only one and undefined behaviour results.
> > That's something you'll need to ask the HW designers though or look up
> > in the datasheet.
>=20
> You are off here. The constrain is just that address will fit in 32
> bit register. I don't know why this constrain, but there is always a
> reason.

There's also the PCI-E constraint of having to split up DMA at 4k
boundaries, which is what I was talking about above. After reading the
code I'm fully aware of the 32-bit pointer (I wouldn't call it a
register, it's also just DMA memory)

> We've assumed that allocations are on the page or cache boundaries I'm
> not who already assured me that this is the case.=20

He lied.

> I  actually  haven't
> encountered this problem on X86_64 I even have the correct check.=20

Are you using swiotlb? That's the only case I can think of where the
alignment would always be satisfied.

> What
> I know there is difference in memory mapping in PPC64 as it has IOMMU.

The powerpc IOMMU design isn't very peculiar. It maps 4k pages of
machine memory into device space. If the memory pointer you're mapping
isn't aligned, then the device memory pointer will not be either. I
suspect the same happens on any iommu design, other than machines
without an iommu of course, using swiotlb.

And since the skb data is simply assigned with kmalloc, it surely won't
be aligned on a 256 byte boundary. 256 is _huge_.

>  Hope this address the wrong command queue number bug but I'm not
> sure.

It certainly does for me.

> There are other places with alignment requirement in the driver we
> probably need to address as well.

Haven't found any, but yeah, anything >16 byte alignment isn't
guaranteed (I think, might be 8, might be 32, not exactly sure)


Incidentally, where does the 36 bit limit come from? The RX has a 40 bit
limit if you see that it uses 32 bit pointer that's shifted by 8 bits.

johannes

--=-n4K/Pcag4wSlybEXDRS5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJIt5MAAoJEKVg1VMiehFYJ3gP+waXL2Dp+nbXvNJyko3+Lz+2
yto3UHiMKqTM6XywAFf1L3Sd+Der9pbg0rMB7BOgXxiNzs1DexAni9ui83Av2wYb
4H7q5UkInQzxJhEvCF+ZMjvNzww6FBxRKqZEQ63nw8HdOnlIYKjUHuQEOWjBMsg8
vir4zvvQe4Q0idFk4DO7JlEZ+2DpKN+tzSsr4xfVfQQ/b+ghfu7Z80w+YXE4PCGq
NfFqN+Hx8KiCh8rZfao55iH8TF1aCfAYUBsS+RicHOZkiO06JfcINRWA0O87zVBK
J7E+05YgWvbM5HpQM4w5UoHcutlTwBfTH2/YL6GQeW33uTAUNVMxd+KtF0VuDL2e
FeRInnngY+D/Ca17wA4t5ccmj1gcV6jmIx+z5Ibw9Fi1JIN6uOQB5n30Z056oXSY
CJRXlEY5F1tM/VIohjS/pUSZ5OMCZHTYaeJmcgJrGXpKXW7FKuZUpOnkWcJSaMA7
UDFRCyEha6u7ar7x5zOoQ+wQz1rrPruDOMOWOtD4rn4mNToQI9SbSMKuIufdk6Lr
QLiDDSqYrUr0KnP3XHhXGjMiChM5viFuaDPHpGZJXOKOXNkdWZ2BQfFznoUK6BNx
ZzSgmZN2Me9uH7cfQAsXenkRklO6gS4Gfg91mVLPkUM/25GBuvyc+Z0eoWor290p
WyLj1cg6l2KiqD36kqMq
=484O
-----END PGP SIGNATURE-----

--=-n4K/Pcag4wSlybEXDRS5--

