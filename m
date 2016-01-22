Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:33540 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbcAVRDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2016 12:03:09 -0500
Received: by mail-lb0-f179.google.com with SMTP id x4so45046483lbm.0
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jan 2016 09:03:08 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: init serial console directly from ChipCommon code
Date: Fri, 22 Jan 2016 18:02:54 +0100
Message-Id: <1453482174-11021-1-git-send-email-zajec5@gmail.com> (sfid-20160122_180313_747708_06133CD2)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

UART is connected to and controlled over ChipCommon core. It doesn't
have much to do with MIPS core (where we initialize it currently)
except just existing on embedded systemms. There isn't point of such
cross-core initialization (and we needed #ifdef anyway) so just handle
it in ChipCommon.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/bcma_private.h      |  1 -
 drivers/bcma/driver_chipcommon.c | 13 ++++++++++---
 drivers/bcma/driver_mips.c       |  3 ---
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 38f1567..7e4ddfb 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -48,7 +48,6 @@ void bcma_core_chipcommon_early_init(struct bcma_drv_cc *cc);
 void bcma_core_chipcommon_init(struct bcma_drv_cc *cc);
 void bcma_chipco_bcm4331_ext_pa_lines_ctl(struct bcma_drv_cc *cc, bool enable);
 #ifdef CONFIG_BCMA_DRIVER_MIPS
-void bcma_chipco_serial_init(struct bcma_drv_cc *cc);
 extern struct platform_device bcma_pflash_dev;
 #endif /* CONFIG_BCMA_DRIVER_MIPS */
 
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index 36ee221..bdb73d9 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -15,6 +15,8 @@
 #include <linux/platform_device.h>
 #include <linux/bcma/bcma.h>
 
+static void bcma_chipco_serial_init(struct bcma_drv_cc *cc);
+
 static inline u32 bcma_cc_write32_masked(struct bcma_drv_cc *cc, u16 offset,
 					 u32 mask, u32 value)
 {
@@ -115,6 +117,8 @@ int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc)
 
 void bcma_core_chipcommon_early_init(struct bcma_drv_cc *cc)
 {
+	struct bcma_bus *bus = cc->core->bus;
+
 	if (cc->early_setup_done)
 		return;
 
@@ -129,6 +133,9 @@ void bcma_core_chipcommon_early_init(struct bcma_drv_cc *cc)
 	if (cc->capabilities & BCMA_CC_CAP_PMU)
 		bcma_pmu_early_init(cc);
 
+	if (IS_BUILTIN(CONFIG_BCM47XX) && bus->hosttype == BCMA_HOSTTYPE_SOC)
+		bcma_chipco_serial_init(cc);
+
 	cc->early_setup_done = true;
 }
 
@@ -314,9 +321,9 @@ u32 bcma_chipco_gpio_pulldown(struct bcma_drv_cc *cc, u32 mask, u32 value)
 	return res;
 }
 
-#ifdef CONFIG_BCMA_DRIVER_MIPS
-void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
+static void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
 {
+#if IS_BUILTIN(CONFIG_BCM47XX)
 	unsigned int irq;
 	u32 baud_base;
 	u32 i;
@@ -358,5 +365,5 @@ void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
 		ports[i].baud_base = baud_base;
 		ports[i].reg_shift = 0;
 	}
+#endif /* CONFIG_BCM47XX */
 }
-#endif /* CONFIG_BCMA_DRIVER_MIPS */
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 24424f3..a40a203 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -337,12 +337,9 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 
 void bcma_core_mips_early_init(struct bcma_drv_mips *mcore)
 {
-	struct bcma_bus *bus = mcore->core->bus;
-
 	if (mcore->early_setup_done)
 		return;
 
-	bcma_chipco_serial_init(&bus->drv_cc);
 	bcma_core_mips_flash_detect(mcore);
 
 	mcore->early_setup_done = true;
-- 
1.8.4.5

