Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dike.telenet-ops.be ([195.130.132.36]:46391 "EHLO
	dike.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbXK0WyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 17:54:11 -0500
Received: from astra.telenet-ops.be (astra.telenet-ops.be [195.130.132.58])
	by dike.telenet-ops.be (Postfix) with ESMTP id DEB156F85FE
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2007 18:25:50 +0100 (CET)
Date: Tue, 27 Nov 2007 18:25:06 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: loswillios <loswillios@gmail.com>, kyle@mcmartin.ca,
	linux-wireless@vger.kernel.org, developers@islsm.org,
	linux-mips@linux-mips.org
Subject: Re: prism54 - MIPS do_be() trap caught
In-Reply-To: <43e72e890711270917o309441a0g99ac435a629b6d5e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0711271824350.14777@anakin> (sfid-20071127_225420_386021_5CDFFCC3)
References: <43e72e890711270917o309441a0g99ac435a629b6d5e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 27 Nov 2007, Luis R. Rodriguez wrote:
> Changing subject, CC'ing linux-mips, perhaps they can help.
> 
> On Nov 26, 2007 7:54 PM, loswillios <loswillios@gmail.com> wrote:
> > Jan Willies wrote:
> > > Luis R. Rodriguez wrote:
> > >> Actually I've been informed this is not unaligned access problem but
> > >> instead it occurs on do_be() or ip22_be_interrupt() on MIPS. I'll have
> > >> to check how that works, I do not yet understand how this is reached.
> > >
> > > I will try a new build with prism54 in the next days and let you know if
> > > that issue is still present.
> >
> > Still the same problem with 2.6.23.1:
> >
> > root@OpenWrt:/# ifconfig eth1 up
> > eth1: resetting device...
> > eth1: uploading firmware...
> > eth1: firmware version: 1.0.4.3
> > eth1: firmware upload complete
> > eth1: interface reset complete
> >
> > root@OpenWrt:/# iwlist eth1 scanning
> > Data bus error, epc == c011518c, ra == c01146cc
> > Oops[#1]:
> > Cpu 0
> > $ 0   : 00000000 1000b800 abad0000 00000032
> > $ 4   : 00000001 c00c8000 00000013 00000001
> > $ 8   : 0000003c 80102bd4 ffffffff 81e2101c
> > $12   : ffffffff 00000580 2ab8af24 00000498
> > $16   : 81e21680 000000fa 81339380 0000004a
> > $20   : 81339380 00000000 a1e80000 81339000
> > $24   : 00000000 2abd55e0
> > $28   : 813b4000 813b5cc8 00000019 c01146cc
> > Hi    : 00000000
> > Lo    : 00000580
> > epc   : c011518c     Not tainted
> > ra    : c01146cc Status: 1000b803    KERNEL EXL IE
> > Cause : 0000001c
> > PrId  : 00029007
> 
> I can see that this comes from arch/mips/kernel/traps.c do_be() but I
> fail to see when this is triggered. Perhaps someone from linux-mips
> might be able to help shed some light here. I tried looking into the
> stack trace before but I couldn't find any code that made me suspect
> of a possible big endian problem (it seems that may be the problem?).
> The stack trace used to look like this:

BE = bus error, not big endian here.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
