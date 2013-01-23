Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:62916 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab3AWMaE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 07:30:04 -0500
Received: by mail-ea0-f172.google.com with SMTP id f13so3484253eaa.31
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 04:30:03 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 RFC] bcma: register platform device for parallel flash
Date: Wed, 23 Jan 2013 13:29:54 +0100
Message-Id: <1358944194-28796-1-git-send-email-zajec5@gmail.com> (sfid-20130123_133015_851164_89FEC27E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/bcma/bcma_private.h |    1 +
 drivers/bcma/driver_mips.c  |   38 +++++++++++++++++++++++++++++++++-----
 drivers/bcma/main.c         |    8 ++++++++
 3 files changed, 42 insertions(+), 5 deletions(-)

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
index 9fe86ee..9a7f0e3 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -14,11 +14,33 @@
 
 #include <linux/bcma/bcma.h>
 
+#include <linux/mtd/physmap.h>
+#include <linux/platform_device.h>
 #include <linux/serial.h>
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
 #include <linux/time.h>
 
+static const char *part_probes[] = { "bcm47xxpart", NULL };
+
+static struct physmap_flash_data bcma_pflash_data = {
+	.part_probe_types	= part_probes,
+};
+
+static struct resource bcma_pflash_resource = {
+	.name	= "bcma_pflash",
+	.flags  = IORESOURCE_MEM,
+};
+
+struct platform_device bcma_pflash_dev = {
+	.name		= "physmap-flash",
+	.dev		= {
+		.platform_data  = &bcma_pflash_data,
+	},
+	.resource	= &bcma_pflash_resource,
+	.num_resources	= 1,
+};
+
 /* The 47162a0 hangs when reading MIPS DMP registers registers */
 static inline bool bcma_core_mips_bcm47162a0_quirk(struct bcma_device *dev)
 {
@@ -211,6 +233,7 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 {
 	struct bcma_bus *bus = mcore->core->bus;
 	struct bcma_drv_cc *cc = &bus->drv_cc;
+	struct bcma_pflash *pflash = &cc->pflash;
 
 	switch (cc->capabilities & BCMA_CC_CAP_FLASHT) {
 	case BCMA_CC_FLASHT_STSER:
@@ -220,15 +243,20 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
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
+		bcma_pflash_data.width = pflash->buswidth;
+		bcma_pflash_resource.start = pflash->window;
+		bcma_pflash_resource.end = pflash->window + pflash->window_size;
+
 		break;
 	default:
 		bcma_err(bus, "Flash type not supported\n");
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index ff85289..6eda7ef 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -149,6 +149,14 @@ static int bcma_register_cores(struct bcma_bus *bus)
 		dev_id++;
 	}
 
+#ifdef CONFIG_BCMA_DRIVER_MIPS
+	if (bus->drv_cc.pflash.present) {
+		err = platform_device_register(&bcma_pflash_dev);
+		if (err)
+			bcma_err(bus, "Error registering parallel flash\n");
+	}
+#endif
+
 #ifdef CONFIG_BCMA_SFLASH
 	if (bus->drv_cc.sflash.present) {
 		err = platform_device_register(&bcma_sflash_dev);
-- 
1.7.7

