Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:48151 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732587AbeGKLgn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 07:36:43 -0400
Date: Wed, 11 Jul 2018 13:32:36 +0200
From: Boris Brezillon <boris.brezillon@bootlin.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        "open list:RALINK MIPS ARCHITECTURE" <linux-mips@linux-mips.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v2 04/24] mtd: rawnand: s3c2410: Allow selection of this
 driver when COMPILE_TEST=y
Message-ID: <20180711133236.67726256@bbrezillon> (sfid-20180711_133313_956875_9FD5CF7C)
In-Reply-To: <CAK8P3a1CR_sN2KW4fZjADHrbKyB1ZSi=6+hPAPYoVeAeLGK_3g@mail.gmail.com>
References: <20180709200945.30116-1-boris.brezillon@bootlin.com>
        <20180709200945.30116-5-boris.brezillon@bootlin.com>
        <20180711131626.732967be@bbrezillon>
        <CAK8P3a1CR_sN2KW4fZjADHrbKyB1ZSi=6+hPAPYoVeAeLGK_3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 11 Jul 2018 13:27:53 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Wed, Jul 11, 2018 at 1:16 PM, Boris Brezillon
> <boris.brezillon@bootlin.com> wrote:
> > On Mon,  9 Jul 2018 22:09:25 +0200
> > Boris Brezillon <boris.brezillon@bootlin.com> wrote:
> >  
> >> It just makes NAND maintainers' life easier by allowing them to
> >> compile-test this driver without having ARCH_S3C24XX or ARCH_S3C64XX
> >> enabled.
> >>
> >> We add a dependency on HAS_IOMEM to make sure the driver compiles
> >> correctly, and a dependency on !IA64 because the {read,write}s{bwl}()
> >> accessors are not defined for this architecture.  
> >
> > I see that SPARC does not define those accessors either. So I guess we
> > should add depends on !SPARC.
> >
> > Arnd, any other way to know when the platform implements
> > {read,write}s{bwl}() accessors?  
> 
> I'd just consider that a bug, and send a patch to fix sparc64 if it's broken.
> sparc32 appears to have these, and when Thierry sent the patch
> to implement them everywhere[1], he said that he tested sparc64 as
> well, so either something regressed since then, or his testing
> was incomplete. Either way, the correct answer IMHO would be to
> make it work rather than to add infrastructure around the broken
> configurations.

I guess the same goes for IA64 then.
