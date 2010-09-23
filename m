Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:52041 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab0IWM2g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 08:28:36 -0400
Subject: Re: [PATCH v2] omap: beagle: add support for wl1271 on the board
 file
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "balbi@ti.com" <balbi@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"tony@atomide.com" <tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
In-Reply-To: <20100923122048.GO4580@legolas.emea.dhcp.ti.com>
References: <1285230003-5065-1-git-send-email-luciano.coelho@nokia.com>
	 <20100923114528.GL4580@legolas.emea.dhcp.ti.com>
	 <1285244253.3231.75.camel@chilepepper>
	 <20100923122048.GO4580@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 15:28:28 +0300
Message-ID: <1285244908.3231.77.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-23 at 14:20 +0200, ext Felipe Balbi wrote:
> Hi Luca,
> 
> On Thu, Sep 23, 2010 at 07:17:33AM -0500, Luciano Coelho wrote:
> >On Thu, 2010-09-23 at 13:45 +0200, ext Felipe Balbi wrote:
> >> On Thu, Sep 23, 2010 at 03:20:03AM -0500, Luciano Coelho wrote:
> >> > static struct mtd_partition omap3beagle_nand_partitions[] = {
> >> >@@ -163,12 +168,25 @@ static void __init beagle_display_init(void)
> >> >
> >> > #include "sdram-micron-mt46h32m32lf-6.h"
> >> >
> >> >+struct wl12xx_platform_data omap_beagle_wlan_data __initdata = {
> >> >+	.irq = OMAP_GPIO_IRQ(OMAP_BEAGLE_WLAN_IRQ_GPIO),
> >>
> >> can you pass IRQ as a struct resource ?
> >
> >Sorry, I don't understand what you mean here.  Can you clarify?
> 
> static struct resource wl12xx_resource[] = {
> 	{
> 		.start	= OMAP_GPIO_IRQ(OMAP_BEAGLE_WLAN_IRQ_GPIO),
> 		.flags	= IORESOURCE_IRQ,
> 	},
> };
> 
> static struct platform_device wl12xx_platform_device = {
> 	.resource	= wl12xx_resource,
> 	.num_resources	= ARRAY_SIZE(wl12xx_resource),
> 	.....
> };
> 
> then on driver you would:
> 
> irq = platform_get_irq(pdev, 0);
> 
> something like that :-)

Ah, I see.  Thanks for the explanation.  I guess we could do that in a
separate patch.  The zoom board file already uses this .irq element, so
this patch would not be the appropriate place to change it.

Is it okay if I deal with that after I'm done with the current patch?

