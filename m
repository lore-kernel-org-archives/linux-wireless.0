Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37901 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838Ab0GFAjz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jul 2010 20:39:55 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Ohad Ben-Cohen <ohadb@ti.com>
Subject: [PATCH 03/15] omap: mmc: prepare for software card detect support
Date: Tue,  6 Jul 2010 03:37:34 +0300
Message-Id: <1278376666-3509-4-git-send-email-ohad@wizery.com>
In-Reply-To: <1278376666-3509-1-git-send-email-ohad@wizery.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ohad Ben-Cohen <ohadb@ti.com>

Make it possible for board files to give the
host controller two handlers needed for emulating
card detect events in software:

* The virtual_get_cd handler will allow the host
controller to query the status of the software
card detect (for the given controller/slot).

* The register_embedded_control will allow the host
controller to register handlers that will be used by
board devices to:
    1. trigger a software card detect event
    2. set private data (e.g. device context) that can later
       be used by an sdio function driver

Signed-off-by: Ohad Ben-Cohen <ohadb@ti.com>
---
 arch/arm/mach-omap2/hsmmc.c           |    4 ++++
 arch/arm/mach-omap2/hsmmc.h           |    5 +++++
 arch/arm/plat-omap/include/plat/mmc.h |    5 +++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-omap2/hsmmc.c b/arch/arm/mach-omap2/hsmmc.c
index 1ef54b0..1361128 100644
--- a/arch/arm/mach-omap2/hsmmc.c
+++ b/arch/arm/mach-omap2/hsmmc.c
@@ -269,6 +269,10 @@ void __init omap2_hsmmc_init(struct omap2_hsmmc_info *controllers)
 
 		mmc->slots[0].remux = c->remux;
 
+		mmc->slots[0].register_embedded_control =
+						c->register_embedded_control;
+		mmc->slots[0].virtual_get_cd = c->virtual_get_cd;
+
 		if (c->cover_only)
 			mmc->slots[0].cover = 1;
 
diff --git a/arch/arm/mach-omap2/hsmmc.h b/arch/arm/mach-omap2/hsmmc.h
index 36f0ba8..dc12c90 100644
--- a/arch/arm/mach-omap2/hsmmc.h
+++ b/arch/arm/mach-omap2/hsmmc.h
@@ -23,6 +23,11 @@ struct omap2_hsmmc_info {
 	int	ocr_mask;	/* temporary HACK */
 	/* Remux (pad configuation) when powering on/off */
 	void (*remux)(struct device *dev, int slot, int power_on);
+	/* following methods are for embedded sdio devices, e.g. wl1271 */
+	int (*register_embedded_control)(void *dev_id,
+			void (*set_virtual_cd)(void *dev_id, int card_present),
+			void (*set_embedded_data)(void *dev_id, void *priv));
+	int (*virtual_get_cd)(void);
 };
 
 #if defined(CONFIG_MMC_OMAP_HS) || defined(CONFIG_MMC_OMAP_HS_MODULE)
diff --git a/arch/arm/plat-omap/include/plat/mmc.h b/arch/arm/plat-omap/include/plat/mmc.h
index c835f1e..0f5bf12 100644
--- a/arch/arm/plat-omap/include/plat/mmc.h
+++ b/arch/arm/plat-omap/include/plat/mmc.h
@@ -140,6 +140,11 @@ struct omap_mmc_platform_data {
 
 		unsigned int ban_openended:1;
 
+		/* Embedded SDIO devices control */
+		int (*register_embedded_control)(void *dev_id,
+			void (*set_virtual_cd)(void *dev_id, int card_present),
+			void (*set_embedded_data)(void *dev_id, void *priv));
+		int (*virtual_get_cd)(void);
 	} slots[OMAP_MMC_MAX_SLOTS];
 };
 
-- 
1.7.0.4

