Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36324 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751419AbdAMLXq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 06:23:46 -0500
Received: by mail-lf0-f68.google.com with SMTP id h65so5236027lfi.3
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 03:23:45 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 4.10 fix V2] Revert "bcma: init serial console directly from ChipCommon code"
Date: Fri, 13 Jan 2017 12:23:35 +0100
Message-Id: <20170113112335.23730-1-zajec5@gmail.com> (sfid-20170113_122354_333147_3711CA49)
In-Reply-To: <20170112174451.7124-1-zajec5@gmail.com>
References: <20170112174451.7124-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

This reverts commit 4c81acab3816 ("bcma: init serial console directly
from ChipCommon code") as it broke IRQ assignment. Getting IRQ with
bcma_core_irq helper on SoC requires MIPS core to be set. It happens
*after* ChipCommon initialization so we can't do this so early.

This fixes a user reported regression. It wasn't critical as serial was
still somehow working but lack of IRQs was making in unreliable.

Fixes: 4c81acab3816 ("bcma: init serial console directly from ChipCommon code")
Reported-by: Felix Fietkau <nbd@nbd.name>
Cc: stable@vger.kernel.org # 4.6+
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
V2: Update commit message (regression part), add Fixes & Cc. Thanks Kalle!
---
 drivers/bcma/bcma_private.h      |  3 +++
 drivers/bcma/driver_chipcommon.c | 11 +++--------
 drivers/bcma/driver_mips.c       |  3 +++
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index f642c42..168fa17 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -45,6 +45,9 @@ int bcma_sprom_get(struct bcma_bus *bus);
 void bcma_core_chipcommon_early_init(struct bcma_drv_cc *cc);
 void bcma_core_chipcommon_init(struct bcma_drv_cc *cc);
 void bcma_chipco_bcm4331_ext_pa_lines_ctl(struct bcma_drv_cc *cc, bool enable);
+#ifdef CONFIG_BCMA_DRIVER_MIPS
+void bcma_chipco_serial_init(struct bcma_drv_cc *cc);
+#endif /* CONFIG_BCMA_DRIVER_MIPS */
 
 /* driver_chipcommon_b.c */
 int bcma_core_chipcommon_b_init(struct bcma_drv_cc_b *ccb);
diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index b4f6520..62f5bfa 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -15,8 +15,6 @@
 #include <linux/platform_device.h>
 #include <linux/bcma/bcma.h>
 
-static void bcma_chipco_serial_init(struct bcma_drv_cc *cc);
-
 static inline u32 bcma_cc_write32_masked(struct bcma_drv_cc *cc, u16 offset,
 					 u32 mask, u32 value)
 {
@@ -186,9 +184,6 @@ void bcma_core_chipcommon_early_init(struct bcma_drv_cc *cc)
 	if (cc->capabilities & BCMA_CC_CAP_PMU)
 		bcma_pmu_early_init(cc);
 
-	if (IS_BUILTIN(CONFIG_BCM47XX) && bus->hosttype == BCMA_HOSTTYPE_SOC)
-		bcma_chipco_serial_init(cc);
-
 	if (bus->hosttype == BCMA_HOSTTYPE_SOC)
 		bcma_core_chipcommon_flash_detect(cc);
 
@@ -378,9 +373,9 @@ u32 bcma_chipco_gpio_pulldown(struct bcma_drv_cc *cc, u32 mask, u32 value)
 	return res;
 }
 
-static void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
+#ifdef CONFIG_BCMA_DRIVER_MIPS
+void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
 {
-#if IS_BUILTIN(CONFIG_BCM47XX)
 	unsigned int irq;
 	u32 baud_base;
 	u32 i;
@@ -422,5 +417,5 @@ static void bcma_chipco_serial_init(struct bcma_drv_cc *cc)
 		ports[i].baud_base = baud_base;
 		ports[i].reg_shift = 0;
 	}
-#endif /* CONFIG_BCM47XX */
 }
+#endif /* CONFIG_BCMA_DRIVER_MIPS */
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 96f1713..89af807 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -278,9 +278,12 @@ static void bcma_core_mips_nvram_init(struct bcma_drv_mips *mcore)
 
 void bcma_core_mips_early_init(struct bcma_drv_mips *mcore)
 {
+	struct bcma_bus *bus = mcore->core->bus;
+
 	if (mcore->early_setup_done)
 		return;
 
+	bcma_chipco_serial_init(&bus->drv_cc);
 	bcma_core_mips_nvram_init(mcore);
 
 	mcore->early_setup_done = true;
-- 
2.10.1
