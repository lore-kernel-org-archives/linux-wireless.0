Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 9pmail.ess.barracuda.com ([64.235.150.225]:40553 "EHLO
        9pmail.ess.barracuda.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbeAOUbm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 15:31:42 -0500
Date: Mon, 15 Jan 2018 20:30:23 +0000
From: James Hogan <james.hogan@mips.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Paul Burton <paul.burton@mips.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Matt Redfearn <matt.redfearn@imgtec.com>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Subject: Re: [PATCH] bcma: Fix 'allmodconfig' and BCMA builds on MIPS targets
Message-ID: <20180115203022.GE5027@jhogan-linux.mipstec.com> (sfid-20180115_213228_109148_F5DFE6A3)
References: <1515965642-16259-1-git-send-email-linux@roeck-us.net>
 <20180115102336.GC29126@saruman>
 <20180115171053.6nvstoufw4y6ar4s@pburton-laptop>
 <61e41256-f0d3-11f7-06ca-768fab84914d@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <61e41256-f0d3-11f7-06ca-768fab84914d@roeck-us.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 15, 2018 at 12:05:48PM -0800, Guenter Roeck wrote:
> On 01/15/2018 09:10 AM, Paul Burton wrote:
> > Hello,
> > 
> > On Mon, Jan 15, 2018 at 10:23:37AM +0000, James Hogan wrote:
> >> On Sun, Jan 14, 2018 at 01:34:02PM -0800, Guenter Roeck wrote:
> >>> Mips builds with BCMA host mode enabled fail in mainline and -next
> >>> with:
> >>>
> >>> In file included from include/linux/bcma/bcma.h:10:0,
> >>>                   from drivers/bcma/bcma_private.h:9,
> >>> 		 from drivers/bcma/main.c:8:
> >>> include/linux/bcma/bcma_driver_pci.h:218:24: error:
> >>> 	field 'pci_controller' has incomplete type
> >>>
> >>> Bisect points to commit d41e6858ba58c ("MIPS: Kconfig: Set default MIPS
> >>> system type as generic") as the culprit. Analysis shows that the commmit
> >>> changes PCI configuration and enables PCI_DRIVERS_GENERIC. This in turn
> >>> disables PCI_DRIVERS_LEGACY. 'struct pci_controller' is, however, only
> >>> defined if PCI_DRIVERS_LEGACY is enabled.
> >>>
> >>> Ultimately that means that BCMA_DRIVER_PCI_HOSTMODE depends on
> >>> PCI_DRIVERS_LEGACY. Add the missing dependency.
> >>>
> >>> Fixes: d41e6858ba58c ("MIPS: Kconfig: Set default MIPS system type as ...")
> >>
> >> Well, technically I think commit c5611df96804 ("MIPS: PCI: Introduce
> >> CONFIG_PCI_DRIVERS_LEGACY") is to blame (Cc'ing paul), and the first bad
> >> commit would be commit eed0eabd12ef ("MIPS: generic: Introduce generic
> >> DT-based board support") which selects PCI_DRIVERS_GENERIC and is the
> >> only platform to do so. Both commits were first in v4.9-rc1 and I can
> >> reproduce this problem at that latter commit with the appropriate
> >> configuration.
> > 
> > Ah - yes if I recall correctly my assumption was that the MIPS-specific
> > struct pci_controller was only used by the MIPS-specific PCI drivers
> > under arch/mips/pci/, which are only built when configured for the
> > appropriate platform.
> > 
> > In this case use of that MIPS-specific struct pci_controller has spread
> > beyond arch/mips/ & the user can be configured in for platforms other
> > than the one that will actually use the driver, including the generic
> > platform which moves towards more generic PCI drivers in
> > drivers/pci/host/.
> > 
> >> But yes clearly the mentioned commit does also expose that existing
> >> problem more widely and to the default allmodconfig, and it looks like a
> >> reasonable approach for now, so if some mention of the other two commits
> >> is added:
> >>
> >> Reviewed-by: James Hogan <jhogan@kernel.org>
> > 
> > Likewise, with the "Fixes:" tag fixed:
> > 
> >      Reviewed-by: Paul Burton <paul.burton@mips.com>
> > 
> 
> Unfortunately, that alone doesn't fix the problem. SSB driver dependencies
> are also broken, and in much worse shape. I had to add dependencies in five
> places to get it to build, and the result is so messy that I won't even try
> to submit it.

Oh, thats interesting. When I tried this earlier I just added "&&
PCI_DRIVERS_LEGACY" to the SSB_PCIHOST_POSSIBLE dependencies, but I was
waiting for Paul's feedback before submitting a similar patch.

But that wasn't -next, it was mainline + mips fixes branch + individual
fixes:

> And if that is fixed, mips:allmodconfig still doesn't build -
> the next error is an undefined reference to physical_memsize in
> arch/mips/kernel/vpe-mt.o.

That one is fairly easy to fix properly, I'll hopefully submit something
this evening.

> 
> I wonder if I should just stop trying to build allmodconfig for mips.
> Any thoughts ?

With a few fixes applied it should be buildable I think. Sorry its been
late in the cycle before we've been able to get fixes merged.

Cheers
James

> 
> Guenter
> 
> > Thanks,
> >      Paul
> > 
> >> Having it in 4.15 would be great.
> >>
> >> Cheers
> >> James
> >>
> >>> Cc: Matt Redfearn <matt.redfearn@imgtec.com>
> >>> Cc: James Hogan <jhogan@kernel.org>
> >>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> >>> ---
> >>> I am aware that this problem has been reported several times. I have
> >>> not been able to find a fix, but I may have missed it. If so, my
> >>> apologies for the noise.
> >>>
> >>> Also note that this is not the only fix required; commit d41e6858ba58c,
> >>> as simple as it looks like, does a pretty good job messing up
> >>> "mips:allmodconfig" builds.
> >>>
> >>>   drivers/bcma/Kconfig | 2 +-
> >>>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> >>> index 02d78f6cecbb..ba8acca036df 100644
> >>> --- a/drivers/bcma/Kconfig
> >>> +++ b/drivers/bcma/Kconfig
> >>> @@ -55,7 +55,7 @@ config BCMA_DRIVER_PCI
> >>>   
> >>>   config BCMA_DRIVER_PCI_HOSTMODE
> >>>   	bool "Driver for PCI core working in hostmode"
> >>> -	depends on MIPS && BCMA_DRIVER_PCI
> >>> +	depends on MIPS && BCMA_DRIVER_PCI && PCI_DRIVERS_LEGACY
> >>>   	help
> >>>   	  PCI core hostmode operation (external PCI bus).
> >>>   
> >>> -- 
> >>> 2.7.4
> >>>
> > 
> > 
> > 
> 
