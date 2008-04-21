Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:47815 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYDUTYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 15:24:32 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Miles Lane" <miles.lane@gmail.com>
Subject: Re: b43 speed problem over 2.6.24 (was: One more log file from when the network was unusable)
Date: Mon, 21 Apr 2008 21:24:05 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Stefano Brivio" <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>
References: <a44ae5cd0804161701k1014f3dkebaa1d35f1a8e20a@mail.gmail.com> <1208779022.26186.91.camel@johannes.berg> <a44ae5cd0804211150l1ede6030t5844458e4f92c73c@mail.gmail.com>
In-Reply-To: <a44ae5cd0804211150l1ede6030t5844458e4f92c73c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200804212124.05493.mb@bu3sch.de> (sfid-20080421_212522_318754_874A3E52)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 21 April 2008 20:50:06 Miles Lane wrote:
> On Mon, Apr 21, 2008 at 7:57 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > Hi,
> >
> >  Miles described a b43 speed problem in the thread
> >
> >         =EF=BB=BF2.6.25-rc9 -- bcm4306 performance is in the toilet
> >
> >  (over 2.6.24) and not being able to see anything from his logs/pac=
ket
> >  captures/... I asked him to bisect. This resulted in
> >
> >  commit 61bca6eb85c863603d6054530e2f65c3b9aba85b
> >  Author: Stefano Brivio <stefano.brivio@polimi.it>
> >  Date:   Tue Nov 6 22:49:05 2007 +0100
> >
> >     b43: rewrite A PHY initialization
> >
> >  which is a huge commit and hence a bit of a problem. Does anyone h=
ave
> >  suggestions how to proceed?
> >
> >  I have very similar hardware, maybe this card is affected by the
> >  boardflags problems we found recently? Miles, can you give us
> >   * lspci -vn -s =EF=BB=BF01:06.0
> >   * the kernel init messages when ssb is built with debugging
>=20
> Here you go:
>=20
> # lspci -vn -s 01:06.0
> 01:06.0 0280: 14e4:4320 (rev 03)
> 	Subsystem: 1057:7110
> 	Flags: bus master, fast devsel, latency 16, IRQ 5
> 	Memory at ed000000 (32-bit, non-prefetchable) [size=3D8K]
>=20
> [    3.977930] ssb: Core 0 found: ChipCommon (cc 0x800, rev 0x04, ven=
dor 0x4243)
> [    3.977942] ssb: Core 1 found: IEEE 802.11 (cc 0x812, rev 0x05,
> vendor 0x4243)
> [    3.977952] ssb: Core 2 found: PCMCIA (cc 0x80D, rev 0x02, vendor =
0x4243)
> [    3.977962] ssb: Core 3 found: V90 (cc 0x807, rev 0x02, vendor 0x4=
243)
> [    3.977971] ssb: Core 4 found: PCI (cc 0x804, rev 0x09, vendor 0x4=
243)
> [    3.993965] ssb: SPROM revision 2 detected.
> [    3.994816] ssb: Sonics Silicon Backplane found on PCI device 0000=
:01:06.0
>=20
> Thanks,
>       Miles
>=20

Can you also provide an SPROM dump?
cat $(find /sys -name ssb_sprom)

--=20
Greetings Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
