Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:44439 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab2HLLII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2012 07:08:08 -0400
Received: by weyx8 with SMTP id x8so1910707wey.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Aug 2012 04:08:06 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [READY][PATCH 1/2] bcma: detect and register NAND flash device
Date: Sun, 12 Aug 2012 13:08:05 +0200
Message-Id: <1344769686-3541-1-git-send-email-zajec5@gmail.com> (sfid-20120812_130813_265374_515FC8C3)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/Kconfig                        |    2 +-
 drivers/bcma/bcma_private.h                 |    1 +
 drivers/bcma/driver_chipcommon_nflash.c     |   28 ++++++++++++++++++++++++--
 drivers/bcma/main.c                         |    8 +++++++
 include/linux/bcma/bcma_driver_chipcommon.h |   13 ++++++++++++
 5 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index c4252c4..0d5b425 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -54,7 +54,7 @@ config BCMA_SFLASH
 
 config BCMA_NFLASH
 	bool
-	depends on BCMA_DRIVER_MIPS && BROKEN
+	depends on BCMA_DRIVER_MIPS
 	default y
 
 config BCMA_DRIVER_GMAC_CMN
diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 94bf07c..169fc58 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -66,6 +66,7 @@ static inline int bcma_sflash_init(struct bcma_drv_cc *cc)
 #ifdef CONFIG_BCMA_NFLASH
 /* driver_chipcommon_nflash.c */
 int bcma_nflash_init(struct bcma_drv_cc *cc);
+extern struct platform_device bcma_nflash_dev;
 #else
 static inline int bcma_nflash_init(struct bcma_drv_cc *cc)
 {
diff --git a/drivers/bcma/driver_chipcommon_nflash.c b/drivers/bcma/driver_chipcommon_nflash.c
index 574d624..9042781 100644
--- a/drivers/bcma/driver_chipcommon_nflash.c
+++ b/drivers/bcma/driver_chipcommon_nflash.c
@@ -5,15 +5,37 @@
  * Licensed under the GNU/GPL. See COPYING for details.
  */
 
+#include <linux/platform_device.h>
 #include <linux/bcma/bcma.h>
-#include <linux/bcma/bcma_driver_chipcommon.h>
-#include <linux/delay.h>
 
 #include "bcma_private.h"
 
+struct platform_device bcma_nflash_dev = {
+	.name		= "bcma_nflash",
+	.num_resources	= 0,
+};
+
 /* Initialize NAND flash access */
 int bcma_nflash_init(struct bcma_drv_cc *cc)
 {
-	bcma_err(cc->core->bus, "NAND flash support is broken\n");
+	struct bcma_bus *bus = cc->core->bus;
+
+	if (bus->chipinfo.id != BCMA_CHIP_ID_BCM4706 &&
+	    cc->core->id.rev != 0x38) {
+		bcma_err(bus, "NAND flash on unsupported board!\n");
+		return -ENOTSUPP;
+	}
+
+	if (!(cc->capabilities & BCMA_CC_CAP_NFLASH)) {
+		bcma_err(bus, "NAND flash not present according to ChipCommon\n");
+		return -ENODEV;
+	}
+
+	cc->nflash.present = true;
+
+	/* Prepare platform device, but don't register it yet. It's too early,
+	 * malloc (required by device_private_init) is not available yet. */
+	bcma_nflash_dev.dev.platform_data = &cc->nflash;
+
 	return 0;
 }
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 648688a..a3736f5 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -145,6 +145,14 @@ static int bcma_register_cores(struct bcma_bus *bus)
 	}
 #endif
 
+#ifdef CONFIG_BCMA_NFLASH
+	if (bus->drv_cc.nflash.present) {
+		err = platform_device_register(&bcma_nflash_dev);
+		if (err)
+			bcma_err(bus, "Error registering NAND flash\n");
+	}
+#endif
+
 	return 0;
 }
 
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 799e4200..b9d7eeb 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -526,6 +526,16 @@ struct bcma_sflash {
 };
 #endif
 
+#ifdef CONFIG_BCMA_NFLASH
+struct mtd_info;
+
+struct bcma_nflash {
+	bool present;
+
+	struct mtd_info *mtd;
+};
+#endif
+
 struct bcma_serial_port {
 	void *regs;
 	unsigned long clockspeed;
@@ -549,6 +559,9 @@ struct bcma_drv_cc {
 #ifdef CONFIG_BCMA_SFLASH
 	struct bcma_sflash sflash;
 #endif
+#ifdef CONFIG_BCMA_NFLASH
+	struct bcma_nflash nflash;
+#endif
 
 	int nr_serial_ports;
 	struct bcma_serial_port serial_ports[4];
-- 
1.7.7

