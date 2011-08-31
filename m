Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:40309 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073Ab1HaKbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 06:31:48 -0400
Received: by mail-ey0-f176.google.com with SMTP id 10so484665eyz.35
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 03:31:47 -0700 (PDT)
Subject: Re: Problem with wl1271
From: Luciano Coelho <coelho@ti.com>
To: Ilya Ledvich <ilya@compulab.co.il>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	linux-wireless@vger.kernel.org,
	Igor Grinberg <grinberg@compulab.co.il>
In-Reply-To: <4E5CF23F.2060806@compulab.co.il>
References: <4E5B9B44.6080508@compulab.co.il>
	 <1314627555.2296.353.camel@cumari>  <4E5CF23F.2060806@compulab.co.il>
Content-Type: multipart/mixed; boundary="=-o+TeGHGR1quLvTV0Cw7b"
Date: Wed, 31 Aug 2011 13:31:43 +0300
Message-ID: <1314786703.2296.566.camel@cumari> (sfid-20110831_123156_855233_CF2022CC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o+TeGHGR1quLvTV0Cw7b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Ilya,

On Tue, 2011-08-30 at 17:22 +0300, Ilya Ledvich wrote: 
> On 08/29/2011 05:19 PM, Luciano Coelho wrote:
> > On Mon, 2011-08-29 at 16:59 +0300, Ilya Ledvich wrote:
> >> I load the wl12xx_sdio module and then set the interface up; no obvious
> >> error
> >> is seen. When I run any other command (e.g. interface down/up, iwlist scan).
> >> I have "/wl1271: ERROR ELP wakeup timeout!/" error. Then the driver
> >> tries to
> >> recover the chip; this eventually leads to the
> >> "/wl1271: ERROR sdio read failed (-110)/" error. The log file for
> >> ifconfig wlan0 up - down - up sequence is attached.
> > This looks like an SDIO power management problem.  Do you have
> > CONFIG_PM_RUNTIME enabled in your kernel?
> >
> > Can you send us your .config and the patch where you modified the
> > board-cm-t35.c file?
> >
> Hi Luciano,
> Sorry, my mailer converted the previous e-mail to html...
> I thank you for fast response.
> The required files are are attached. The CONFIG_PM_RUNTIME is enabled indeed.

This seems to be a problem in your board file.  You have probably not
configured the interrupt line correctly.  Are you sure all the MUXing is
correct? Also, please check the regulator settings for your card.

I have attached the patch I use to add this stuff to my beagleboard.
Take a look at it and see if you find some more information about what
you need to change in your board file.

I hope this helps.

-- 
Cheers,
Luca.

--=-o+TeGHGR1quLvTV0Cw7b
Content-Disposition: attachment; filename*0=0001-omap-beagle-add-support-for-wl1271-on-the-board-file.pat; filename*1=ch
Content-Type: text/x-patch; name="0001-omap-beagle-add-support-for-wl1271-on-the-board-file.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From ea13526f8b8d89a1f702f8ccd357a9bb11a17dbf Mon Sep 17 00:00:00 2001
From: Luciano Coelho <luciano.coelho@nokia.com>
Date: Thu, 23 Sep 2010 22:07:49 +0300
Subject: [PATCH] omap: beagle: add support for wl1271 on the board file

Add board configuration for the wl1271 daughter board.  This patch is based
on Ohad Ben-Cohen's patches for Zoom boards.

Updated to work on 2.6.39-rc1.

Cc: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 arch/arm/mach-omap2/board-omap3beagle.c |   71 +++++++++++++++++++++++++++++++
 1 files changed, 71 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 33007fd..03f2c5b 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -31,7 +31,9 @@
 #include <linux/mmc/host.h>
 
 #include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
 #include <linux/i2c/twl.h>
+#include <linux/wl12xx.h>
 
 #include <mach/hardware.h>
 #include <asm/mach-types.h>
@@ -53,6 +55,9 @@
 #include "timer-gp.h"
 #include "pm.h"
 
+#define OMAP_BEAGLE_WLAN_EN_GPIO    (139)
+#define OMAP_BEAGLE_WLAN_IRQ_GPIO   (137)
+
 #define NAND_BLOCK_SIZE		SZ_128K
 
 /*
@@ -254,12 +259,25 @@ static void __init beagle_display_init(void)
 
 #include "sdram-micron-mt46h32m32lf-6.h"
 
+struct wl12xx_platform_data omap_beagle_wlan_data __initdata = {
+	.irq = OMAP_GPIO_IRQ(OMAP_BEAGLE_WLAN_IRQ_GPIO),
+	.board_ref_clock = WL12XX_REFCLOCK_38,
+};
+
 static struct omap2_hsmmc_info mmc[] = {
 	{
 		.mmc		= 1,
 		.caps		= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA,
 		.gpio_wp	= 29,
 	},
+	{
+		.name           = "wl1271",
+		.mmc            = 2,
+		.caps           = MMC_CAP_4_BIT_DATA | MMC_CAP_POWER_OFF_CARD,
+		.gpio_wp        = -EINVAL,
+		.gpio_cd        = -EINVAL,
+		.nonremovable   = true,
+	},
 	{}	/* Terminator */
 };
 
@@ -267,10 +285,45 @@ static struct regulator_consumer_supply beagle_vmmc1_supply = {
 	.supply			= "vmmc",
 };
 
+static struct regulator_consumer_supply beagle_vmmc2_supplies[] = {
+	{
+		.supply         = "vmmc",
+		.dev_name       = "omap_hsmmc.1",
+	},
+};
+
+
 static struct regulator_consumer_supply beagle_vsim_supply = {
 	.supply			= "vmmc_aux",
 };
 
+
+static struct regulator_init_data beagle_vmmc2 = {
+	.constraints = {
+		.valid_ops_mask = REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies = 1,
+	.consumer_supplies = beagle_vmmc2_supplies,
+};
+
+static struct fixed_voltage_config beagle_vwlan = {
+	.supply_name = "vwl1271",
+	.microvolts = 1800000,  /* 1.8V */
+	.gpio = OMAP_BEAGLE_WLAN_EN_GPIO,
+	.startup_delay = 70000, /* 70ms */
+	.enable_high = 1,
+	.enabled_at_boot = 0,
+	.init_data = &beagle_vmmc2,
+};
+
+static struct platform_device omap_vwlan_device = {
+	.name           = "reg-fixed-voltage",
+	.id             = 1,
+	.dev = {
+		.platform_data = &beagle_vwlan,
+	},
+};
+
 static struct gpio_led gpio_leds[];
 
 static int beagle_twl_gpio_setup(struct device *dev,
@@ -598,6 +651,19 @@ static const struct usbhs_omap_board_data usbhs_bdata __initconst = {
 
 #ifdef CONFIG_OMAP_MUX
 static struct omap_board_mux board_mux[] __initdata = {
+	/* WLAN IRQ - GPIO 137 */
+	OMAP3_MUX(SDMMC2_DAT5,  OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLUP),
+	/* WLAN POWER ENABLE - GPIO 139 */
+	OMAP3_MUX(SDMMC2_DAT7,  OMAP_MUX_MODE4 | OMAP_PIN_OUTPUT),
+	/* WLAN SDIO: MMC2 CMD */
+	OMAP3_MUX(SDMMC2_CMD,   OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	/* WLAN SDIO: MMC2 CLK */
+	OMAP3_MUX(SDMMC2_CLK,   OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	/* WLAN SDIO: MMC2 DAT[0-3] */
+	OMAP3_MUX(SDMMC2_DAT0,  OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP3_MUX(SDMMC2_DAT1,  OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP3_MUX(SDMMC2_DAT2,  OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
+	OMAP3_MUX(SDMMC2_DAT3,  OMAP_MUX_MODE0 | OMAP_PIN_INPUT_PULLUP),
 	{ .reg_offset = OMAP_MUX_TERMINATOR },
 };
 #endif
@@ -657,10 +723,15 @@ static void __init beagle_opp_init(void)
 static void __init omap3_beagle_init(void)
 {
 	omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
+	if (wl12xx_set_platform_data(&omap_beagle_wlan_data))
+		pr_err("error setting wl12xx data\n");
+
 	omap3_beagle_init_rev();
 	omap3_beagle_i2c_init();
 	platform_add_devices(omap3_beagle_devices,
 			ARRAY_SIZE(omap3_beagle_devices));
+	platform_device_register(&omap_vwlan_device);
+
 	omap_display_init(&beagle_dss_data);
 	omap_serial_init();
 
-- 
1.7.1


--=-o+TeGHGR1quLvTV0Cw7b--

