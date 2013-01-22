Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:42442 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3AVTsJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 14:48:09 -0500
Received: by mail-bk0-f54.google.com with SMTP id w5so717071bku.27
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2013 11:48:08 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: register platform device for parallel flash
Date: Tue, 22 Jan 2013 20:48:03 +0100
Message-Id: <1358884083-29607-1-git-send-email-zajec5@gmail.com> (sfid-20130122_204814_341821_C81701F7)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/bcma_private.h |    1 +
 drivers/bcma/driver_mips.c  |   28 +++++++++++++++++++++++-----
 drivers/bcma/main.c         |    8 ++++++++
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 04f7c86..6f377bd 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -47,6 +47,7 @@ int bcma_sprom_get(struct bcma_bus *bus);
 /* driver_chipcommon.c */
 #ifdef CONFIG_BCMA_DRIVER_MIPS
 void bcma_chipco_serial_init(struct bcma_drv_cc *cc);
+extern struct platform_device bcma_pflash_dev;
 #endif /* CONFIG_BCMA_DRIVER_MIPS */
 
 /* driver_chipcommon_pmu.c */
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 9fe86ee..cf8b6b7 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -14,11 +14,23 @@
 
 #include <linux/bcma/bcma.h>
 
+#include <linux/platform_device.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
 #include <linux/time.h>
 
+static struct resource bcma_pflash_resource = {
+	.name	= "bcma_pflash",
+	.flags  = IORESOURCE_MEM,
+};
+
+struct platform_device bcma_pflash_dev = {
+	.name		= "bcma_pflash",
+	.resource	= &bcma_pflash_resource,
+	.num_resources	= 1,
+};
+
 /* The 47162a0 hangs when reading MIPS DMP registers registers */
 static inline bool bcma_core_mips_bcm47162a0_quirk(struct bcma_device *dev)
 {
@@ -211,6 +223,7 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 {
 	struct bcma_bus *bus = mcore->core->bus;
 	struct bcma_drv_cc *cc = &bus->drv_cc;
+	struct bcma_pflash *pflash = &cc->pflash;
 
 	switch (cc->capabilities & BCMA_CC_CAP_FLASHT) {
 	case BCMA_CC_FLASHT_STSER:
@@ -220,15 +233,20 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 		break;
 	case BCMA_CC_FLASHT_PARA:
 		bcma_debug(bus, "Found parallel flash\n");
-		cc->pflash.present = true;
-		cc->pflash.window = BCMA_SOC_FLASH2;
-		cc->pflash.window_size = BCMA_SOC_FLASH2_SZ;
+		pflash->present = true;
+		pflash->window = BCMA_SOC_FLASH2;
+		pflash->window_size = BCMA_SOC_FLASH2_SZ;
 
 		if ((bcma_read32(cc->core, BCMA_CC_FLASH_CFG) &
 		     BCMA_CC_FLASH_CFG_DS) == 0)
-			cc->pflash.buswidth = 1;
+			pflash->buswidth = 1;
 		else
-			cc->pflash.buswidth = 2;
+			pflash->buswidth = 2;
+
+		bcma_pflash_resource.start = pflash->window;
+		bcma_pflash_resource.end = pflash->window + pflash->window_size;
+		bcma_pflash_dev.dev.platform_data = pflash;
+
 		break;
 	default:
 		bcma_err(bus, "Flash type not supported\n");
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index ff85289..ed172ac 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -149,6 +149,14 @@ static int bcma_register_cores(struct bcma_bus *bus)
 		dev_id++;
 	}
 
+#ifdef CONFIG_BCMA_DRIVER_MIPS
+	if (bus->drv_cc.pflash.present) {
+		err = platform_device_register(&bcma_pflash_dev);
+		if (err)
+			bcma_err(bus, "Error registering serial flash\n");
+	}
+#endif
+
 #ifdef CONFIG_BCMA_SFLASH
 	if (bus->drv_cc.sflash.present) {
 		err = platform_device_register(&bcma_sflash_dev);
-- 
1.7.7

