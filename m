Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:53117 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab0JMNBY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 09:01:24 -0400
From: "Premi, Sanjeev" <premi@ti.com>
To: Sanjay Kumar Champati <csanjay@mistralsolutions.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 13 Oct 2010 18:31:18 +0530
Subject: RE: [WL1271 DC support on OMAP3EVM 2/5] ARM: Supported for Standard
 SDIO driver on OMAP3EVM for WL1271 DC
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB5930234405CB8@dbde02.ent.ti.com>
References: <B85A65D85D7EB246BE421B3FB0FBB5930234405BCA@dbde02.ent.ti.com>
 <2615178032399077084343141213216@psmtp.com>
In-Reply-To: <2615178032399077084343141213216@psmtp.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -----Original Message-----
> From: Sanjay Kumar Champati [mailto:csanjay@mistralsolutions.com] 
> Sent: Wednesday, October 13, 2010 5:50 PM
> To: Premi, Sanjeev; linux-omap@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Subject: RE: [WL1271 DC support on OMAP3EVM 2/5] ARM: 
> Supported for Standard SDIO driver on OMAP3EVM for WL1271 DC
> 
[snip]...[snip]

> > > diff --git a/drivers/mmc/core/sdio_ops.c 
> b/drivers/mmc/core/sdio_ops.c
> > > index 4eb7825..4213ee0 100644
> > > --- a/drivers/mmc/core/sdio_ops.c
> > > +++ b/drivers/mmc/core/sdio_ops.c
> > > @@ -114,6 +114,9 @@ int mmc_io_rw_direct(struct mmc_card
> > > *card, int write, unsigned fn,
> > >
> > >  	return 0;
> > >  }
> > > +#ifdef CONFIG_WL1271_WLAN
> > > +EXPORT_SYMBOL(mmc_io_rw_direct);
> > > +#endif
> > 
> > [sp] Why is the export required?
> For the standard SDIO support WL1271 driver is using 
> "mmc_io_rw_direct".
> > 
> > >
> > >  int mmc_io_rw_extended(struct mmc_card *card, int write, 
> unsigned fn,
> > >  	unsigned addr, int incr_addr, u8 *buf, unsigned blocks,
> > > unsigned blksz)
> > > @@ -181,4 +184,6 @@ int mmc_io_rw_extended(struct mmc_card
> > > *card, int write, unsigned fn,
> > >
> > >  	return 0;
> > >  }
> > > -
> > > +#ifdef CONFIG_WL1271_WLAN
> > > +EXPORT_SYMBOL(mmc_io_rw_extended);
> > > +#endif
> > 
> > [sp] Why is the export required?
> For the standard SDIO support WL1271 driver is using 
> "mmc_io_rw_extended".
> > 

[sp] part of my question is: Why do you need to modify the
     generic sdio implementation to export these functions?

     You cannot make "custom" modifications here. See similar
     comment in other patch as well.

[snip]...[snip]
