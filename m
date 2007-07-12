Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55688
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390AbXGLU6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 16:58:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/2] ssb: Add a driver for the Broadcom OHCI core
Date: Thu, 12 Jul 2007 22:57:56 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	linux-wireless@vger.kernel.org,
	Gary Zambrano <zambrano@broadcom.com>
References: <20070712085432.528319000@bu3sch.de> <20070712085744.961584000@bu3sch.de> <20070712104937.1b0970c5.akpm@linux-foundation.org>
In-Reply-To: <20070712104937.1b0970c5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707122257.56526.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 12 July 2007 19:49, Andrew Morton wrote:
> Here, we'd normally do
> 
> #else
> #define ssb_ohci_hcd_suspend NULL
> #define ssb_ohci_hcd_resume NULL

Ah, well. I don't care either way, so if that is the preferred way to deal
with it, I'll change :)

> > Index: linux-2.6/drivers/usb/host/ohci-hcd.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/usb/host/ohci-hcd.c	2007-07-12 10:51:46.000000000 +0200
> > +++ linux-2.6/drivers/usb/host/ohci-hcd.c	2007-07-12 10:52:45.000000000 +0200
> > @@ -920,11 +920,17 @@ MODULE_LICENSE ("GPL");
> >  #define PS3_SYSTEM_BUS_DRIVER	ps3_ohci_sb_driver
> >  #endif
> >  
> > +#ifdef CONFIG_USB_OHCI_HCD_SSB
> > +#include "ohci-ssb.c"
> > +#define SSB_OHCI_DRIVER		ssb_ohci_driver
> > +#endif
> 
> argh.  Why did USB do this?  Sigh.
> 
> >  #if	!defined(PCI_DRIVER) &&		\
> >  	!defined(PLATFORM_DRIVER) &&	\
> >  	!defined(OF_PLATFORM_DRIVER) &&	\
> >  	!defined(SA1111_DRIVER) &&	\
> > -	!defined(PS3_SYSTEM_BUS_DRIVER)
> > +	!defined(PS3_SYSTEM_BUS_DRIVER) && \
> > +	!defined(SSB_OHCI_DRIVER)
> >  #error "missing bus glue for ohci-hcd"
> >  #endif
> >  
> > @@ -972,10 +978,20 @@ static int __init ohci_hcd_mod_init(void
> >  		goto error_pci;
> >  #endif
> >  
> > +#ifdef SSB_OHCI_DRIVER
> > +	retval = ssb_driver_register(&SSB_OHCI_DRIVER);
> > +	if (retval)
> > +		goto error_ssb;
> > +#endif
> 
> Why do we use SSB_OHCI_DRIVER here rather than ssb_ohci_driver?   Seems odd.

Yes, that ohci code is horrible. But all other ohci drivers do it this way, too,
so I did it, too.

> > +
> >  	return retval;
> >  
> >  	/* Error path */
> > +#ifdef SSB_OHCI_DRIVER
> > + error_ssb:
> > +#endif
> >  #ifdef PCI_DRIVER
> > +	pci_unregister_driver(&PCI_DRIVER);
> 
> hm, are you sure about this?  I don't see anywhere in here where PCI_DRIVER
> got newly registered, but we are newly unregistering it?

Whoops, good catch. That's a merge error.
