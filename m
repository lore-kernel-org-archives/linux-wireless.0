Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hall.aurel32.net ([88.191.38.19]:37972 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760830AbXHMASv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2007 20:18:51 -0400
Date: Mon, 13 Aug 2007 02:18:49 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][SSB] Fix a warning in PCI core driver
Message-ID: <20070813001849.GC4966@hall.aurel32.net>
References: <20070812235058.GA4966@hall.aurel32.net> <200708130202.28030.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <200708130202.28030.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 13, 2007 at 02:02:27AM +0200, Michael Buesch wrote:
> On Monday 13 August 2007 01:50:58 Aurelien Jarno wrote:
> > The patch below fixes a warning spotted a few days ago by Andrew Morton
> > while releasing 2.6.23-rc2-mm1.
> > 
> > Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> > 
> > --- a/drivers/ssb/driver_pcicore.c
> > +++ b/drivers/ssb/driver_pcicore.c
> > @@ -278,7 +278,7 @@
> >  static struct resource ssb_pcicore_mem_resource = {
> >  	.name	= "SSB PCIcore external memory",
> >  	.start	= SSB_PCI_DMA,
> > -	.end	= SSB_PCI_DMA + SSB_PCI_DMA_SZ - 1,
> > +	.end	= (u32)SSB_PCI_DMA + (u32)SSB_PCI_DMA_SZ - 1,
> >  	.flags	= IORESOURCE_MEM,
> >  };
> >  
> > 
> 
> These casts were intentionally removed by me.
> I think they are bogus and I have no idea why this
> generates this strange compiler warning (I think it
> was some overflow warning?).
> 

Yes it is overflow warning. The compiler thinks that those constant are
signed values and thus generate an overflow.

Another fix would be to postfix those constants by U.

-- 
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
