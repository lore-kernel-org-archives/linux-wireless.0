Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45569 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab2GQO0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 10:26:35 -0400
Received: by eaak11 with SMTP id k11so187424eaa.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jul 2012 07:26:33 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: add place for flash memory support
Date: Tue, 17 Jul 2012 16:26:41 +0200
Message-Id: <1342535201-19621-1-git-send-email-zajec5@gmail.com> (sfid-20120717_162639_195869_16EED59D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Hope my recent patches will make OpenWrt guys mainline their work ;)
---
 drivers/bcma/Kconfig                    |   10 ++++++++++
 drivers/bcma/Makefile                   |    2 ++
 drivers/bcma/bcma_private.h             |   22 ++++++++++++++++++++++
 drivers/bcma/driver_chipcommon_nflash.c |   19 +++++++++++++++++++
 drivers/bcma/driver_chipcommon_sflash.c |   19 +++++++++++++++++++
 drivers/bcma/driver_mips.c              |   15 ++++++++++++---
 6 files changed, 84 insertions(+), 3 deletions(-)
 create mode 100644 drivers/bcma/driver_chipcommon_nflash.c
 create mode 100644 drivers/bcma/driver_chipcommon_sflash.c

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index d878e03..8d1f777 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -47,6 +47,16 @@ config BCMA_DRIVER_MIPS
 
 	  If unsure, say N
 
+config BCMA_SFLASH
+	bool
+	depends on BCMA_DRIVER_MIPS && BROKEN
+	default y
+
+config BCMA_NFLASH
+	bool
+	depends on BCMA_DRIVER_MIPS && BROKEN
+	default y
+
 config BCMA_DRIVER_GMAC_CMN
 	bool "BCMA Broadcom GBIT MAC COMMON core driver"
 	depends on BCMA
diff --git a/drivers/bcma/Makefile b/drivers/bcma/Makefile
index d13803f..8ad42d4 100644
--- a/drivers/bcma/Makefile
+++ b/drivers/bcma/Makefile
@@ -1,5 +1,7 @@
 bcma-y					+= main.o scan.o core.o sprom.o
 bcma-y					+= driver_chipcommon.o driver_chipcommon_pmu.o
+bcma-$(CONFIG_BCMA_SFLASH)		+= driver_chipcommon_sflash.o
+bcma-$(CONFIG_BCMA_NFLASH)		+= driver_chipcommon_nflash.o
 bcma-y					+= driver_pci.o
 bcma-$(CONFIG_BCMA_DRIVER_PCI_HOSTMODE)	+= driver_pci_host.o
 bcma-$(CONFIG_BCMA_DRIVER_MIPS)		+= driver_mips.o
diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index f6589eb..3cf9cc9 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -51,6 +51,28 @@ void bcma_chipco_serial_init(struct bcma_drv_cc *cc);
 u32 bcma_pmu_alp_clock(struct bcma_drv_cc *cc);
 u32 bcma_pmu_get_clockcpu(struct bcma_drv_cc *cc);
 
+#ifdef CONFIG_BCMA_SFLASH
+/* driver_chipcommon_sflash.c */
+int bcma_sflash_init(struct bcma_drv_cc *cc);
+#else
+static inline int bcma_sflash_init(struct bcma_drv_cc *cc)
+{
+	bcma_err(cc->core->bus, "Serial flash not supported\n");
+	return 0;
+}
+#endif /* CONFIG_BCMA_SFLASH */
+
+#ifdef CONFIG_BCMA_NFLASH
+/* driver_chipcommon_nflash.c */
+int bcma_nflash_init(struct bcma_drv_cc *cc);
+#else
+static inline int bcma_nflash_init(struct bcma_drv_cc *cc)
+{
+	bcma_err(cc->core->bus, "NAND flash not supported\n");
+	return 0;
+}
+#endif /* CONFIG_BCMA_NFLASH */
+
 #ifdef CONFIG_BCMA_HOST_PCI
 /* host_pci.c */
 extern int __init bcma_host_pci_init(void);
diff --git a/drivers/bcma/driver_chipcommon_nflash.c b/drivers/bcma/driver_chipcommon_nflash.c
new file mode 100644
index 0000000..574d624
--- /dev/null
+++ b/drivers/bcma/driver_chipcommon_nflash.c
@@ -0,0 +1,19 @@
+/*
+ * Broadcom specific AMBA
+ * ChipCommon NAND flash interface
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include <linux/bcma/bcma.h>
+#include <linux/bcma/bcma_driver_chipcommon.h>
+#include <linux/delay.h>
+
+#include "bcma_private.h"
+
+/* Initialize NAND flash access */
+int bcma_nflash_init(struct bcma_drv_cc *cc)
+{
+	bcma_err(cc->core->bus, "NAND flash support is broken\n");
+	return 0;
+}
diff --git a/drivers/bcma/driver_chipcommon_sflash.c b/drivers/bcma/driver_chipcommon_sflash.c
new file mode 100644
index 0000000..6e157a5
--- /dev/null
+++ b/drivers/bcma/driver_chipcommon_sflash.c
@@ -0,0 +1,19 @@
+/*
+ * Broadcom specific AMBA
+ * ChipCommon serial flash interface
+ *
+ * Licensed under the GNU/GPL. See COPYING for details.
+ */
+
+#include <linux/bcma/bcma.h>
+#include <linux/bcma/bcma_driver_chipcommon.h>
+#include <linux/delay.h>
+
+#include "bcma_private.h"
+
+/* Initialize serial flash access */
+int bcma_sflash_init(struct bcma_drv_cc *cc)
+{
+	bcma_err(cc->core->bus, "Serial flash support is broken\n");
+	return 0;
+}
diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index ef34ed2..b013b04 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -185,10 +185,11 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 	switch (bus->drv_cc.capabilities & BCMA_CC_CAP_FLASHT) {
 	case BCMA_CC_FLASHT_STSER:
 	case BCMA_CC_FLASHT_ATSER:
-		bcma_err(bus, "Serial flash not supported.\n");
+		bcma_debug(bus, "Found serial flash\n");
+		bcma_sflash_init(&bus->drv_cc);
 		break;
 	case BCMA_CC_FLASHT_PARA:
-		bcma_info(bus, "found parallel flash.\n");
+		bcma_debug(bus, "Found parallel flash\n");
 		bus->drv_cc.pflash.window = 0x1c000000;
 		bus->drv_cc.pflash.window_size = 0x02000000;
 
@@ -199,7 +200,15 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 			bus->drv_cc.pflash.buswidth = 2;
 		break;
 	default:
-		bcma_err(bus, "flash not supported.\n");
+		bcma_err(bus, "Flash type not supported\n");
+	}
+
+	if (bus->drv_cc.core->id.rev == 38 ||
+	    bus->chipinfo.id == BCMA_CHIP_ID_BCM4706) {
+		if (bus->drv_cc.capabilities & BCMA_CC_CAP_NFLASH) {
+			bcma_debug(bus, "Found NAND flash\n");
+			bcma_nflash_init(&bus->drv_cc);
+		}
 	}
 }
 
-- 
1.7.7

