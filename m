Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:40300 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754653Ab0IWMRh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 08:17:37 -0400
Subject: Re: [PATCH v2] omap: beagle: add support for wl1271 on the board
 file
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "balbi@ti.com" <balbi@ti.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"tony@atomide.com" <tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
In-Reply-To: <20100923114528.GL4580@legolas.emea.dhcp.ti.com>
References: <1285230003-5065-1-git-send-email-luciano.coelho@nokia.com>
	 <20100923114528.GL4580@legolas.emea.dhcp.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Sep 2010 15:17:33 +0300
Message-ID: <1285244253.3231.75.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felipe,


On Thu, 2010-09-23 at 13:45 +0200, ext Felipe Balbi wrote:
> On Thu, Sep 23, 2010 at 03:20:03AM -0500, Luciano Coelho wrote:
> > static struct mtd_partition omap3beagle_nand_partitions[] = {
> >@@ -163,12 +168,25 @@ static void __init beagle_display_init(void)
> >
> > #include "sdram-micron-mt46h32m32lf-6.h"
> >
> >+struct wl12xx_platform_data omap_beagle_wlan_data __initdata = {
> >+	.irq = OMAP_GPIO_IRQ(OMAP_BEAGLE_WLAN_IRQ_GPIO),
> 
> can you pass IRQ as a struct resource ?

Sorry, I don't understand what you mean here.  Can you clarify?


> >+static struct regulator_consumer_supply beagle_vmmc2_supply = {
> >+	.supply         = "vmmc",
> >+	.dev_name       = "mmci-omap-hs.1",
> >+};
> 
> this should be:
> 
> static struct regulator_consume_supply beagle_vmmc2_supplies = {
> 	{
> 		.supply		= "vmmc",
> 		.dev_name	= "mmci-omap-hs.1",
> 	},
> };

Okay, I'll do it.  The other supplies that are already defined in this
board file don't do that, but it's better to do it as you proposed.
Thanks.


> >+static struct regulator_init_data beagle_vmmc2 = {
> >+	.constraints = {
> >+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
> >+	},
> >+	.num_consumer_supplies = 1,
> >+	.consumer_supplies = &beagle_vmmc2_supply,
> 
> please tabify, it's easier for reading, same for all below:

Sure, I'll do it.  You're not the first one to complain. :)


> 	constrants	= {
> 		.valid_ops_mask	= REGULATOR_CHANGE_STATUS,
> 	},
> 	.num_consumer_supplies	= ARRAY_SIZE(beagle_vmmc2_supplies),
> 	.consumer_supplies	= beagle_vmmc2_supplies,
> 
> >@@ -464,9 +528,14 @@ static struct omap_musb_board_data musb_board_data = {
> > static void __init omap3_beagle_init(void)
> > {
> > 	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
> >+	if (wl12xx_set_platform_data(&omap_beagle_wlan_data))
> >+		pr_err("error setting wl12xx data\n");
> >+
> > 	omap3_beagle_i2c_init();
> > 	platform_add_devices(omap3_beagle_devices,
> > 			ARRAY_SIZE(omap3_beagle_devices));
> >+	platform_device_register(&omap_vwlan_device);
> >+
> 
> trailing blank line. Also, you could just add omap_vwlan_device to
> omap3_beagle_devices.

I'll fix it.


> >diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
> >index 4134f44..8bb028e 100644
> >--- a/drivers/net/wireless/wl12xx/wl1271.h
> >+++ b/drivers/net/wireless/wl12xx/wl1271.h
> >@@ -60,7 +60,7 @@ enum {
> > 	DEBUG_ALL	= ~0,
> > };
> >
> >-#define DEBUG_LEVEL (DEBUG_NONE)
> >+#define DEBUG_LEVEL (DEBUG_MAC80211 | DEBUG_CMD | DEBUG_ACX | DEBUG_BOOT)
> 
> some debugging trash came into commit ??

Yes, I kept it by mistake.  I've already removed it from the v3 I sent a
bit earlier today.



-- 
Cheers,
Luca.

