Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from asmtpout024.mac.com ([17.148.16.99]:54408 "EHLO
	asmtpout024.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077Ab0LTVAp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 16:00:45 -0500
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Received: from [192.168.1.30] ([87.201.169.175])
 by asmtp024.mac.com (Oracle Communications Messaging Exchange Server 7u4-18.01
 64bit (built Jul 15 2010)) with ESMTPSA id <0LDQ00NSUVOX2Y50@asmtp024.mac.com>
 for linux-wireless@vger.kernel.org; Mon, 20 Dec 2010 13:00:37 -0800 (PST)
Subject: Re: WL1271 chip
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <0826983CC0CB074798C42E77D8ACD07F01AEA8@pdtms1.pdt.com>
Date: Tue, 21 Dec 2010 01:00:21 +0400
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-id: <8A703B3F-A771-4E63-8E0F-64D1BEB0C7F2@mac.com>
References: <0826983CC0CB074798C42E77D8ACD07F01AE4A@pdtms1.pdt.com>
 <1292843841.13129.9.camel@chilepepper>
 <0826983CC0CB074798C42E77D8ACD07F01AEA8@pdtms1.pdt.com>
To: "Brzezowski, Karen" <Karen.Brzezowski@pdt.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Karen,
                   
On Dec 20, 2010, at 9:12 PM, Brzezowski, Karen wrote:

> I looked at arch/arm/mach-omap2/board-zoom-peripherals.c file..
> I didn't see anything specific to SDIO..

I'm attaching a patch that integrates the Murata WL1271 chip with the MMC2 SDIO
controller for the BeagleBoard. You can try to adapt this for you iMX platform.

> I was looking at linux-2.6.36.2..
> Is this the correct version to look at?

You will have to use linux-2.6.37-rc6 or higher for mainline kernel support for the
wl1271 device.

You will also need to ensure that you have the following kernel configuration options
are set:

CONFIG_REGULATOR_FIXED_VOLTAGE = y
CONFIG_WL12XX=m
CONFIG_WL1271=m
CONFIG_WL1271_SDIO=m
CONFIG_WL12XX_PLATFORM_DATA=y

Best regards,

Elvis Dowson


>From e84ded71b45aecd340ec6030a540d0305c43c82d Mon Sep 17 00:00:00 2001
From: Elvis Dowson <elvis.dowson@gmail.com>
Date: Fri, 17 Dec 2010 12:27:23 +0400
Subject: [PATCH] Add support for Murata wl1271 wlan module.

---
arch/arm/mach-omap2/Makefile                 |    1 +
arch/arm/mach-omap2/board-beagle20-wifi.c |   64 ++++++++++++++++++++++++++
arch/arm/mach-omap2/board-beagle20-wifi.h |   24 ++++++++++
arch/arm/mach-omap2/board-omap3beagle.c      |   62 +++++++++++++++++++++++++
4 files changed, 151 insertions(+), 0 deletions(-)
create mode 100644 arch/arm/mach-omap2/board-beagle20-wifi.c
create mode 100644 arch/arm/mach-omap2/board-beagle20-wifi.h

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 60e51bc..36f2b69 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -119,6 +119,7 @@ obj-$(CONFIG_MACH_OMAP_2430SDP)		+= board-2430sdp.o \
					   hsmmc.o
obj-$(CONFIG_MACH_OMAP_APOLLON)		+= board-apollon.o
obj-$(CONFIG_MACH_OMAP3_BEAGLE)		+= board-omap3beagle.o \
+					   board-beagle20-wifi.o \
					   hsmmc.o
obj-$(CONFIG_MACH_DEVKIT8000)     	+= board-devkit8000.o \
                                           hsmmc.o
diff --git a/arch/arm/mach-omap2/board-beagle20-wifi.c b/arch/arm/mach-omap2/board-beagle20-wifi.c
new file mode 100644
index 0000000..4f75e2d
--- /dev/null
+++ b/arch/arm/mach-omap2/board-beagle20-wifi.c
@@ -0,0 +1,64 @@
+/*
+ * linux/arch/arm/mach-omap2/board-beagle20-wifi.c
+ *
+ *
+ *
+ * Copyright (C) 2010 Texas Instruments Inc.
+ *
+ * Author :
+ *	Elvis Dowson <elvis.dowson@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/platform_device.h>
+#include <linux/clk.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+
+#include <linux/mmc/host.h>
+#include <linux/mmc/sdio_ids.h>
+
+#include <linux/gpio.h>
+
+#include "board-beagle20-wifi.h"
+#include "mux.h"
+
+void wlan_mux_init(void)
+{
+    pr_info("%s: Configuring mux settings for wl1271 wlan module\n", __func__);
+
+    /* OMAP_BEAGLE20_WIFI_PMENA_GPIO and OMAP_BEAGLE20_WIFI_IRQ_GPIO */
+	omap_mux_init_gpio(OMAP_BEAGLE20_WIFI_PMENA_GPIO, OMAP_PIN_OUTPUT);
+	omap_mux_init_gpio(OMAP_BEAGLE20_WIFI_IRQ_GPIO,   OMAP_PIN_INPUT_PULLUP);
+
+	/*
+	 * MMC2 pin mux settings.
+	 *
+	 * The pix mux strings can be found in /arch/arm/mach-omap2/mux34xx.c
+	 *
+	 * Refer the TI OMAP 35x Technical Reference Manual (Rev.D), page 840
+	 * for the following example.
+	 *
+	 * If the string name is “xxx.yyy”
+	 * xxx – is the name of the default mode of the pad, usually Mode 0
+	 *       as described in the TRM.
+	 * yyy – is the pin on that pad you want to select.
+	 *
+	 * For example, MMC3 CLK line ("sdmmc3_clk")  can be brought out in
+	 * 2 places ("mcspi1_cs2" and "etk_clk").
+	 *
+	 */
+	omap_mux_init_signal("sdmmc2_clk.sdmmc2_clk", 	OMAP_PIN_INPUT_PULLUP);
+	omap_mux_init_signal("sdmmc2_cmd.sdmmc2_cmd", 	OMAP_PIN_INPUT_PULLUP);
+	omap_mux_init_signal("sdmmc2_dat0.sdmmc2_dat0", OMAP_PIN_INPUT_PULLUP);
+	omap_mux_init_signal("sdmmc2_dat1.sdmmc2_dat1", OMAP_PIN_INPUT_PULLUP);
+	omap_mux_init_signal("sdmmc2_dat2.sdmmc2_dat2", OMAP_PIN_INPUT_PULLUP);
+	omap_mux_init_signal("sdmmc2_dat3.sdmmc2_dat3", OMAP_PIN_INPUT_PULLUP);
+}
+
diff --git a/arch/arm/mach-omap2/board-beagle20-wifi.h b/arch/arm/mach-omap2/board-beagle20-wifi.h
new file mode 100644
index 0000000..5ce7df2
--- /dev/null
+++ b/arch/arm/mach-omap2/board-beagle20-wifi.h
@@ -0,0 +1,24 @@
+/*
+ * linux/arch/arm/mach-omap2/board-beagle20-wifi.h
+ *
+ * 
+ *
+ * Copyright (C) 2010 Texas Instruments Inc.
+ *
+ * Author :
+ *	Elvis Dowson <elvis.dowson@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef BOARD_BEAGLE20_WIFI_H_
+#define BOARD_BEAGLE20_WIFI_H_
+
+#define OMAP_BEAGLE20_WIFI_PMENA_GPIO 139     /* Murata TI WL1271 WLAN module enable GPIO */
+#define OMAP_BEAGLE20_WIFI_IRQ_GPIO   137     /* Murata TI WL1271 WLAN module IRQ GPIO */
+
+void wlan_mux_init(void);
+
+#endif /* BOARD_BEAGLE20_WIFI_H_ */
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 50af879..6d1fcd6 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -30,7 +30,9 @@
#include <linux/mmc/host.h>

#include <linux/regulator/machine.h>
+#include <linux/regulator/fixed.h>
#include <linux/i2c/twl.h>
+#include <linux/wl12xx.h>

#include <mach/hardware.h>
#include <asm/mach-types.h>
@@ -45,6 +47,7 @@
#include <plat/nand.h>
#include <plat/usb.h>

+#include "board-beagle20-wifi.h"
#include "mux.h"
#include "hsmmc.h"
#include "timer-gp.h"
@@ -166,6 +169,14 @@ static struct omap2_hsmmc_info mmc[] = {
		.gpio_cd	= -EINVAL,
		.gpio_wp	= -EINVAL,
	},
+	{
+		.name		= "wl1271",
+		.mmc		= 2,
+		.caps		= MMC_CAP_4_BIT_DATA | MMC_CAP_POWER_OFF_CARD,
+		.gpio_wp	= -EINVAL,
+		.gpio_cd	= -EINVAL,
+		.nonremovable	= true,
+	},
	{}	/* Terminator */
};

@@ -177,6 +188,10 @@ static struct regulator_consumer_supply beagle_vsim_supply = {
	.supply			= "vmmc_aux",
};

+static struct regulator_consumer_supply beagle_vmmc2_supply = {
+	.supply			= "vmmc",
+};
+
static struct gpio_led gpio_leds[];

static int beagle_twl_gpio_setup(struct device *dev,
@@ -187,6 +202,7 @@ static int beagle_twl_gpio_setup(struct device *dev,
	/* link regulators to MMC adapters */
	beagle_vmmc1_supply.dev = mmc[0].dev;
	beagle_vsim_supply.dev = mmc[0].dev;
+	beagle_vmmc2_supply.dev = mmc[1].dev;

	return 0;
}
@@ -217,6 +233,21 @@ static struct regulator_init_data beagle_vmmc1 = {
	.consumer_supplies	= &beagle_vmmc1_supply,
};

+/* VMMC2 for MMC2 card */
+static struct regulator_init_data beagle_vmmc2 = {
+	.constraints = {
+		.min_uV			= 1850000,
+		.max_uV			= 1850000,
+		.apply_uV		= true,
+		.valid_modes_mask	= REGULATOR_MODE_NORMAL
+					| REGULATOR_MODE_STANDBY,
+		.valid_ops_mask		= REGULATOR_CHANGE_MODE
+					| REGULATOR_CHANGE_STATUS,
+	},
+	.num_consumer_supplies  = 1,
+	.consumer_supplies      = &beagle_vmmc2_supply,
+};
+
/* VSIM for MMC1 pins DAT4..DAT7 (2 mA, plus card == max 50 mA) */
static struct regulator_init_data beagle_vsim = {
	.constraints = {
@@ -261,6 +292,31 @@ static struct regulator_init_data beagle_vpll2 = {
	.consumer_supplies	= &beagle_vdvi_supply,
};

+/* Fixed voltage regulator for wlan module */
+static struct fixed_voltage_config beagle_vwlan = {
+	.supply_name		= "vwl1271",
+	.microvolts		= 1850000, /* 1.8V */
+	.gpio			= OMAP_BEAGLE20_WIFI_PMENA_GPIO,
+	.startup_delay		= 70000, /* 70msec */
+	.enable_high		= 1,
+	.enabled_at_boot	= 0,
+	.init_data		= &beagle_vmmc2,
+};
+
+static struct platform_device omap_vwlan_device = {
+	.name		= "reg-fixed-voltage",
+	.id		= 1,
+	.dev = {
+		.platform_data	= &beagle_vwlan,
+	},
+};
+
+struct wl12xx_platform_data omap_beagle_wlan_data __initdata = {
+	.irq = OMAP_GPIO_IRQ(OMAP_BEAGLE20_WIFI_IRQ_GPIO),
+	/* ZOOM ref clock is 26 MHz */
+	.board_ref_clock = 1,
+};
+
static struct twl4030_usb_data beagle_usb_data = {
	.usb_mode	= T2_USB_MODE_ULPI,
};
@@ -455,6 +511,12 @@ static void __init omap3_beagle_init(void)
	omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);

	beagle_display_init();
+
+	/* wl12xx wlan module */
+	wlan_mux_init();
+	if (wl12xx_set_platform_data(&omap_beagle_wlan_data))
+		pr_err("error setting wl12xx data\n");
+	platform_device_register(&omap_vwlan_device);
}

MACHINE_START(OMAP3_BEAGLE, "Custom BeagleBoard 2.0")
-- 
1.7.0.4



