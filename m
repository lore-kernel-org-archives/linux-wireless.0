Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51531 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754167AbXGLRv2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2007 13:51:28 -0400
Date: Thu, 12 Jul 2007 10:49:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mb@bu3sch.de
Cc: John Linville <linville@tuxdriver.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	linux-wireless@vger.kernel.org,
	Gary Zambrano <zambrano@broadcom.com>
Subject: Re: [patch 2/2] ssb: Add a driver for the Broadcom OHCI core
Message-Id: <20070712104937.1b0970c5.akpm@linux-foundation.org>
In-Reply-To: <20070712085744.961584000@bu3sch.de>
References: <20070712085432.528319000@bu3sch.de>
	<20070712085744.961584000@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 12 Jul 2007 10:54:34 +0200
mb@bu3sch.de wrote:

> This adds a driver for the Broadcom USB OHCI HCD device.
> These devices are found in various embedded Broadcom-47xx machines.
> 

The patch generates 2 checkpatch warnings.

> +#ifdef CONFIG_PM
> +static int ssb_ohci_hcd_suspend(struct usb_hcd *hcd, pm_message_t message)
> +{
> +	struct ssb_ohci_device *ohcidev = hcd_to_ssb_ohci(hcd);
> +	struct ohci_hcd *ohci = &ohcidev->ohci;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&ohci->lock, flags);
> +
> +	ohci_writel(ohci, OHCI_INTR_MIE, &ohci->regs->intrdisable);
> +	ohci_readl(ohci, &ohci->regs->intrdisable); /* commit write */
> +
> +	/* make sure snapshot being resumed re-enumerates everything */
> +	if (message.event == PM_EVENT_PRETHAW)
> +		ohci_usb_reset(ohci);
> +
> +	clear_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
> +
> +	spin_unlock_irqrestore(&ohci->lock, flags);
> +
> +	return 0;
> +}
> +
> +static int ssb_ohci_hcd_resume(struct usb_hcd *hcd)
> +{
> +	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
> +	usb_hcd_resume_root_hub(hcd);
> +	return 0;
> +}

Here, we'd normally do

#else
#define ssb_ohci_hcd_suspend NULL
#define ssb_ohci_hcd_resume NULL

> +#endif /* CONFIG_PM */
> +
> +static const struct hc_driver ssb_ohci_hc_driver = {
> +	.description		= "ssb-usb-ohci",
> +	.product_desc		= "SSB OHCI Controller",
> +	.hcd_priv_size		= sizeof(struct ssb_ohci_device),
> +
> +	.irq			= ohci_irq,
> +	.flags			= HCD_MEMORY | HCD_USB11,
> +
> +	.reset			= ssb_ohci_reset,
> +	.start			= ssb_ohci_start,
> +	.stop			= ohci_stop,
> +	.shutdown		= ohci_shutdown,
> +
> +#ifdef CONFIG_PM
> +	.suspend		= ssb_ohci_hcd_suspend,
> +	.resume			= ssb_ohci_hcd_resume,
> +#endif

and then remove these ifdefs.

> +	.urb_enqueue		= ohci_urb_enqueue,
> +	.urb_dequeue		= ohci_urb_dequeue,
> +	.endpoint_disable	= ohci_endpoint_disable,
> +
> +	.get_frame_number	= ohci_get_frame,
> +
> +	.hub_status_data	= ohci_hub_status_data,
> +	.hub_control		= ohci_hub_control,
> +	.hub_irq_enable		= ohci_rhsc_enable,
> +
> +#ifdef CONFIG_PM
> +	.bus_suspend		= ohci_bus_suspend,
> +	.bus_resume		= ohci_bus_resume,
> +#endif

Perhaps the same could be done here.

> +	.start_port_reset	= ohci_start_port_reset,
> +};
> +
>
> ...
>
> +
> +#ifdef CONFIG_PM
> +static int ssb_ohci_suspend(struct ssb_device *dev, pm_message_t state)
> +{
> +	ssb_device_disable(dev, 0);
> +
> +	return 0;
> +}
> +
> +static int ssb_ohci_resume(struct ssb_device *dev)
> +{
> +	struct usb_hcd *hcd = ssb_get_drvdata(dev);
> +	struct ssb_ohci_device *ohcidev = hcd_to_ssb_ohci(hcd);
> +
> +	ssb_device_enable(dev, ohcidev->enable_flags);
> +
> +	return 0;
> +}
> +#else /* CONFIG_PM */
> +# define ssb_ohci_suspend	NULL
> +# define ssb_ohci_resume	NULL
> +#endif /* CONFIG_PM */
> +
> +static struct ssb_driver ssb_ohci_driver = {
> +	.name		= KBUILD_MODNAME,
> +	.id_table	= ssb_ohci_table,
> +	.probe		= ssb_ohci_probe,
> +	.remove		= ssb_ohci_remove,
> +	.suspend	= ssb_ohci_suspend,
> +	.resume		= ssb_ohci_resume,
> +};

Like this.

> Index: linux-2.6/drivers/usb/host/ohci-hcd.c
> ===================================================================
> --- linux-2.6.orig/drivers/usb/host/ohci-hcd.c	2007-07-12 10:51:46.000000000 +0200
> +++ linux-2.6/drivers/usb/host/ohci-hcd.c	2007-07-12 10:52:45.000000000 +0200
> @@ -920,11 +920,17 @@ MODULE_LICENSE ("GPL");
>  #define PS3_SYSTEM_BUS_DRIVER	ps3_ohci_sb_driver
>  #endif
>  
> +#ifdef CONFIG_USB_OHCI_HCD_SSB
> +#include "ohci-ssb.c"
> +#define SSB_OHCI_DRIVER		ssb_ohci_driver
> +#endif

argh.  Why did USB do this?  Sigh.

>  #if	!defined(PCI_DRIVER) &&		\
>  	!defined(PLATFORM_DRIVER) &&	\
>  	!defined(OF_PLATFORM_DRIVER) &&	\
>  	!defined(SA1111_DRIVER) &&	\
> -	!defined(PS3_SYSTEM_BUS_DRIVER)
> +	!defined(PS3_SYSTEM_BUS_DRIVER) && \
> +	!defined(SSB_OHCI_DRIVER)
>  #error "missing bus glue for ohci-hcd"
>  #endif
>  
> @@ -972,10 +978,20 @@ static int __init ohci_hcd_mod_init(void
>  		goto error_pci;
>  #endif
>  
> +#ifdef SSB_OHCI_DRIVER
> +	retval = ssb_driver_register(&SSB_OHCI_DRIVER);
> +	if (retval)
> +		goto error_ssb;
> +#endif

Why do we use SSB_OHCI_DRIVER here rather than ssb_ohci_driver?   Seems odd.

> +
>  	return retval;
>  
>  	/* Error path */
> +#ifdef SSB_OHCI_DRIVER
> + error_ssb:
> +#endif
>  #ifdef PCI_DRIVER
> +	pci_unregister_driver(&PCI_DRIVER);

hm, are you sure about this?  I don't see anywhere in here where PCI_DRIVER
got newly registered, but we are newly unregistering it?


