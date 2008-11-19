Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39395 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657AbYKSLhi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 06:37:38 -0500
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
In-Reply-To: <1ba2fa240811190115i6bad0c89wb1d9c8ee281be2f8@mail.gmail.com> (sfid-20081119_101517_611176_902A0F8E)
References: <1226969241.4014.24.camel@johannes.berg>
	 <1227001390.4014.43.camel@johannes.berg>
	 <1ba2fa240811180613g48c94199s67e4334e89282e76@mail.gmail.com>
	 <1227021904.4014.58.camel@johannes.berg>
	 <1ba2fa240811190115i6bad0c89wb1d9c8ee281be2f8@mail.gmail.com>
	 (sfid-20081119_101517_611176_902A0F8E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8CXRFmPugqhC8Ao3Hpc6"
Date: Wed, 19 Nov 2008 12:36:33 +0100
Message-Id: <1227094594.26243.6.camel@johannes.berg> (sfid-20081119_123742_338812_28D21D3E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8CXRFmPugqhC8Ao3Hpc6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 11:15 +0200, Tomas Winkler wrote:

> >> You are off here. The constrain is just that address will fit in 32
> >> bit register. I don't know why this constrain, but there is always a
> >> reason.
> >
> > There's also the PCI-E constraint of having to split up DMA at 4k
> > boundaries, which is what I was talking about above.
>=20
> Have to check this but I'm not sure if this is anyhow related.

It's not. I misunderstood how RX DMA works, but given that you actually
have to allocate the buffers that large the HW has to support splitting.

> Not just that, it was never confirmed this is the issue it was the
> first place we started to look.
> This code is there from time zero of the driver something like kernel
> 2.6.18 and the problem popped only in kernel 2.6.27 so what else has
> changed.

Yeah, it's weird, and it doesn't even seem to solve it for everyone. So
there must be another thing too.


> Yes I have CONFIG_SWIOTLB=3Dy in my config spec for X86_64, nevertheless
> you've mentioned that the allocation problem is due to headroom
> allocation in skb?!

Well, the skb "head" is _all_ of the skb data that is not part of an
extra buffer. So skb->data is the "head" while the skb fraglist is
referred to as the data. That can be a bit confusing. Anyway skb->data
is just allocated with kmalloc and on my machine that has 128 byte
alignment. The IOMMU maps pages, so doesn't change the alignment. If you
are using swiotlb (just having it in the config isn't enough, check the
kernel messages) then much DMA will be done with bounce buffer.


> > Incidentally, where does the 36 bit limit come from? The RX has a 40 bi=
t
> > limit if you see that it uses 32 bit pointer that's shifted by 8 bits.
>=20
> I'm checking with the HW guys

Seems that isn't necessary, there are some things like the rbb stats
that are only shifted down by 4 bits, so they need a 36 bit mask. Bit
unfortunate that this single allocations forces all into the mask, but I
don't right now see how to just get that single one into 36 and the rest
into 40.

johannes

--=-8CXRFmPugqhC8Ao3Hpc6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJI/o+AAoJEKVg1VMiehFY5VgP/jSGkfp/UbbsKXoEiE4/Lz1o
s8THgt58llaDzKnEHEEBikuP7OoprVCS7YpDqBbFcVR/pwVK37+lr5yPhHWreT5l
dAw4WLvlDWTAeGszuSRh2INNEPvdVYT+cWdgu6UU0isu6P048nEDQLsLBODreabt
x+EbZmJb6++556kw4/GalQ/NHHw7ml4xS1I5h2EJjtQRq8Do52xvEvsgRW1aE1XM
s/f+19GEiI34FeTubAbbvbYeTliMxdFA3pZXXYBhejRuIkYi4E8HSKmLaiLJk8O2
KnIiiRXR37PLbaPIbM71ARg45HhZ46rcm3xubIRNR/BRE+bnvapdoB+waaZnQW+i
SiSYKlhtQsLkJrBlxKGneyqrpvJulGXz6JwzDZcnzafwLi9o5dxARhkHTSyCrTuc
ohSMkerRWpS+eMRYyTypggAVkZ6d43f3p76oGsgHIb4y3dyw9rz9+5t+CDHaIYBm
pAVVt9SkiIymgtTHhH6XKudUVBVzNyi59WGz9XZTPIs+bH1g0vzEGE2U++JIH1nG
xznicMMauI5pjJkXkDhtFtCVUQmGfvSUu+3S8H+hEadnS51/pa+I2YhpFl7rczSR
m01+egk+GQHZsKb0Y5a/A/sLUn/IUxpffHSbwLEl+zyPLVF0UtyXk0NN5Xgzal9d
VMwUQ5fjJdhC4vuiHbL/
=orRB
-----END PGP SIGNATURE-----

--=-8CXRFmPugqhC8Ao3Hpc6--

