Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37901 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab0GFAkL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jul 2010 20:40:11 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Ohad Ben-Cohen <ohadb@ti.com>
Subject: [PATCH 05/15] omap: hsmmc: add virtual card detect support
Date: Tue,  6 Jul 2010 03:37:36 +0300
Message-Id: <1278376666-3509-6-git-send-email-ohad@wizery.com>
In-Reply-To: <1278376666-3509-1-git-send-email-ohad@wizery.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ohad Ben-Cohen <ohadb@ti.com>

Add support for software emulation of card detect
events.

This is required for specific controllers
that are hard wired with embedded SDIO devices
(such as TI's wl1271 WLAN device).

Board-specific configuration is required to
enable this software card detect control.

Based on Android's EMBEDDED SDIO patch by
San Mehat <san@android.com>.

Signed-off-by: Ohad Ben-Cohen <ohadb@ti.com>
---
 drivers/mmc/host/omap_hsmmc.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index b032828..60694df 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -1208,6 +1208,38 @@ static void omap_hsmmc_detect(struct work_struct *work)
 		mmc_detect_change(host->mmc, (HZ * 50) / 1000);
 }
 
+#ifdef CONFIG_MMC_EMBEDDED_SDIO
+static void omap_hsmmc_set_embedded_data(void *dev_id, void *priv)
+{
+	struct omap_hsmmc_host *host = dev_id;
+	struct mmc_host *mmc = host->mmc;
+
+	mmc_set_embedded_data(mmc, priv);
+}
+
+static void omap_hsmmc_virtual_detect(void *dev_id, int carddetect)
+{
+	struct omap_hsmmc_host *host = dev_id;
+
+	printk(KERN_DEBUG "%s: card detect %d\n", mmc_hostname(host->mmc),
+							carddetect);
+
+	sysfs_notify(&host->mmc->class_dev.kobj, NULL, "cover_switch");
+
+	if (carddetect)
+		mmc_detect_change(host->mmc, (HZ * 200) / 1000);
+	else
+		mmc_detect_change(host->mmc, (HZ * 50) / 1000);
+}
+#else
+static void omap_hsmmc_set_embedded_data(void *dev_id, void *priv)
+{
+}
+static void omap_hsmmc_virtual_detect(void *dev_id, int carddetect)
+{
+}
+#endif
+
 /*
  * ISR for handling card insertion and removal
  */
@@ -2170,7 +2202,10 @@ static int __init omap_hsmmc_probe(struct platform_device *pdev)
 				"Unable to grab MMC CD IRQ\n");
 			goto err_irq_cd;
 		}
-	}
+	} else if (mmc_slot(host).register_embedded_control)
+		mmc_slot(host).register_embedded_control(host,
+					omap_hsmmc_virtual_detect,
+					omap_hsmmc_set_embedded_data);
 
 	omap_hsmmc_disable_irq(host);
 
-- 
1.7.0.4

