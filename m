Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761124Ab0GURf3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:35:29 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 19/20] omap: zoom: keep the MMC3 wl1271 device powered off
Date: Wed, 21 Jul 2010 20:33:53 +0300
Message-Id: <1279733634-21974-20-git-send-email-ohad@wizery.com>
In-Reply-To: <1279733634-21974-1-git-send-email-ohad@wizery.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Keep the MMC3 wl1271 WLAN device powered off until its
SDIO function driver requests otherwise.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 arch/arm/mach-omap2/board-zoom-peripherals.c |    1 +
 arch/arm/mach-omap2/hsmmc.c                  |    3 +++
 arch/arm/mach-omap2/hsmmc.h                  |    1 +
 arch/arm/plat-omap/include/plat/mmc.h        |    3 +++
 drivers/mmc/host/omap_hsmmc.c                |    3 +++
 5 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index 3230801..3ab9125 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -217,6 +217,7 @@ static struct omap2_hsmmc_info mmc[] __initdata = {
 		.gpio_wp	= -EINVAL,
 		.gpio_cd	= -EINVAL,
 		.ocr_mask	= MMC_VDD_165_195,
+		.dont_power_card = true,
 		.priv_data	= &omap_zoom_wlan_data,
 	},
 	{}      /* Terminator */
diff --git a/arch/arm/mach-omap2/hsmmc.c b/arch/arm/mach-omap2/hsmmc.c
index f06ddd2..24c4144 100644
--- a/arch/arm/mach-omap2/hsmmc.c
+++ b/arch/arm/mach-omap2/hsmmc.c
@@ -284,6 +284,9 @@ void __init omap2_hsmmc_init(struct omap2_hsmmc_info *controllers)
 		if (c->vcc_aux_disable_is_sleep)
 			mmc->slots[0].vcc_aux_disable_is_sleep = 1;
 
+		if (c->dont_power_card)
+			mmc->slots[0].dont_power_card = 1;
+
 		mmc->slots[0].priv_data = c->priv_data;
 
 		/* NOTE:  MMC slots should have a Vcc regulator set up.
diff --git a/arch/arm/mach-omap2/hsmmc.h b/arch/arm/mach-omap2/hsmmc.h
index 434a3ed..e200786 100644
--- a/arch/arm/mach-omap2/hsmmc.h
+++ b/arch/arm/mach-omap2/hsmmc.h
@@ -23,6 +23,7 @@ struct omap2_hsmmc_info {
 	int	ocr_mask;	/* temporary HACK */
 	/* Remux (pad configuation) when powering on/off */
 	void (*remux)(struct device *dev, int slot, int power_on);
+	bool	dont_power_card;/* keep card power off at boot (default is n)*/
 	void	*priv_data;	/* private data to SDIO function driver */
 };
 
diff --git a/arch/arm/plat-omap/include/plat/mmc.h b/arch/arm/plat-omap/include/plat/mmc.h
index 9db1617..d042494 100644
--- a/arch/arm/plat-omap/include/plat/mmc.h
+++ b/arch/arm/plat-omap/include/plat/mmc.h
@@ -140,6 +140,9 @@ struct omap_mmc_platform_data {
 
 		unsigned int ban_openended:1;
 
+		/* keep this card powered off at boot (default is n) */
+		unsigned int dont_power_card:1;
+
 		/* card private data that should be used by function driver */
 		void *priv_data;
 	} slots[OMAP_MMC_MAX_SLOTS];
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 4ac548e..4fb6634 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2157,6 +2157,9 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
 	if (mmc_slot(host).nonremovable)
 		mmc->caps |= MMC_CAP_NONREMOVABLE;
 
+	if (mmc_slot(host).dont_power_card)
+		mmc->caps |= MMC_CAP_DONT_POWER_CARD;
+
 	mmc_set_embedded_data(mmc, mmc_slot(host).priv_data);
 
 	omap_hsmmc_conf_bus_power(host);
-- 
1.7.0.4

