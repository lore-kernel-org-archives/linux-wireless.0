Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36797 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab2HJGvX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 02:51:23 -0400
Received: by weyx8 with SMTP id x8so792295wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 23:51:22 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] bcma: detect and register serial flash device
Date: Fri, 10 Aug 2012 08:51:14 +0200
Message-Id: <1344581475-11568-1-git-send-email-zajec5@gmail.com> (sfid-20120810_085132_915871_AFB2E53B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/Kconfig                        |    2 +-
 drivers/bcma/bcma_private.h                 |    1 +
 drivers/bcma/driver_chipcommon_sflash.c     |  122 ++++++++++++++++++++++++++-
 drivers/bcma/main.c                         |    9 ++
 include/linux/bcma/bcma_driver_chipcommon.h |   12 +++
 include/linux/bcma/bcma_regs.h              |    2 +
 6 files changed, 144 insertions(+), 4 deletions(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 8d1f777..c4252c4 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -49,7 +49,7 @@ config BCMA_DRIVER_MIPS
 
 config BCMA_SFLASH
 	bool
-	depends on BCMA_DRIVER_MIPS && BROKEN
+	depends on BCMA_DRIVER_MIPS
 	default y
 
 config BCMA_NFLASH
diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 3cf9cc9..94bf07c 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -54,6 +54,7 @@ u32 bcma_pmu_get_clockcpu(struct bcma_drv_cc *cc);
 #ifdef CONFIG_BCMA_SFLASH
 /* driver_chipcommon_sflash.c */
 int bcma_sflash_init(struct bcma_drv_cc *cc);
+extern struct platform_device bcma_sflash_dev;
 #else
 static inline int bcma_sflash_init(struct bcma_drv_cc *cc)
 {
diff --git a/drivers/bcma/driver_chipcommon_sflash.c b/drivers/bcma/driver_chipcommon_sflash.c
index 6e157a5..f26bdc8 100644
--- a/drivers/bcma/driver_chipcommon_sflash.c
+++ b/drivers/bcma/driver_chipcommon_sflash.c
@@ -5,15 +5,131 @@
  * Licensed under the GNU/GPL. See COPYING for details.
  */
 
+#include <linux/platform_device.h>
 #include <linux/bcma/bcma.h>
-#include <linux/bcma/bcma_driver_chipcommon.h>
-#include <linux/delay.h>
 
 #include "bcma_private.h"
 
+static struct resource bcma_sflash_resource = {
+	.name	= "bcma_sflash",
+	.start	= BCMA_SFLASH,
+	.end	= 0,
+	.flags  = IORESOURCE_MEM | IORESOURCE_READONLY,
+};
+
+struct platform_device bcma_sflash_dev = {
+	.name		= "bcma_sflash",
+	.resource	= &bcma_sflash_resource,
+	.num_resources	= 1,
+};
+
+struct bcma_sflash_tbl_e {
+	char *name;
+	u32 id;
+	u32 blocksize;
+	u16 numblocks;
+};
+
+static struct bcma_sflash_tbl_e bcma_sflash_st_tbl[] = {
+	{ "", 0x14, 0x10000, 32, },
+	{ 0 },
+};
+
+static struct bcma_sflash_tbl_e bcma_sflash_sst_tbl[] = {
+	{ 0 },
+};
+
+static struct bcma_sflash_tbl_e bcma_sflash_at_tbl[] = {
+	{ 0 },
+};
+
+static void bcma_sflash_cmd(struct bcma_drv_cc *cc, u32 opcode)
+{
+	int i;
+	bcma_cc_write32(cc, BCMA_CC_FLASHCTL,
+			BCMA_CC_FLASHCTL_START | opcode);
+	for (i = 0; i < 1000; i++) {
+		if (!(bcma_cc_read32(cc, BCMA_CC_FLASHCTL) &
+		      BCMA_CC_FLASHCTL_BUSY))
+			return;
+		cpu_relax();
+	}
+	bcma_err(cc->core->bus, "SFLASH control command failed (timeout)!\n");
+}
+
 /* Initialize serial flash access */
 int bcma_sflash_init(struct bcma_drv_cc *cc)
 {
-	bcma_err(cc->core->bus, "Serial flash support is broken\n");
+	struct bcma_bus *bus = cc->core->bus;
+	struct bcma_sflash *sflash = &cc->sflash;
+	struct bcma_sflash_tbl_e *e;
+	u32 id, id2;
+
+	switch (cc->capabilities & BCMA_CC_CAP_FLASHT) {
+	case BCMA_CC_FLASHT_STSER:
+		bcma_sflash_cmd(cc, BCMA_CC_FLASHCTL_ST_DP);
+
+		bcma_cc_write32(cc, BCMA_CC_FLASHADDR, 0);
+		bcma_sflash_cmd(cc, BCMA_CC_FLASHCTL_ST_RES);
+		id = bcma_cc_read32(cc, BCMA_CC_FLASHDATA);
+
+		bcma_cc_write32(cc, BCMA_CC_FLASHADDR, 1);
+		bcma_sflash_cmd(cc, BCMA_CC_FLASHCTL_ST_RES);
+		id2 = bcma_cc_read32(cc, BCMA_CC_FLASHDATA);
+
+		switch (id) {
+		case 0xbf:
+			for (e = bcma_sflash_sst_tbl; e->name; e++) {
+				if (e->id == id2)
+					break;
+			}
+			break;
+		default:
+			for (e = bcma_sflash_st_tbl; e->name; e++) {
+				if (e->id == id)
+					break;
+			}
+			break;
+		}
+		if (!e->name) {
+			bcma_err(bus, "Unsupported ST serial flash (id: 0x%X, id2: 0x%X)\n", id, id2);
+			return -ENOTSUPP;
+		}
+
+		break;
+	case BCMA_CC_FLASHT_ATSER:
+		bcma_sflash_cmd(cc, BCMA_CC_FLASHCTL_AT_STATUS);
+		id = bcma_cc_read32(cc, BCMA_CC_FLASHDATA) & 0x3c;
+
+		for (e = bcma_sflash_at_tbl; e->name; e++) {
+			if (e->id == id)
+				break;
+		}
+		if (!e->name) {
+			bcma_err(bus, "Unsupported Atmel serial flash (id: 0x%X)\n", id);
+			return -ENOTSUPP;
+		}
+
+		break;
+	default:
+		bcma_err(bus, "Unsupported flash type\n");
+		return -ENOTSUPP;
+	}
+
+	sflash->blocksize = e->blocksize;
+	sflash->numblocks = e->numblocks;
+	sflash->size = sflash->blocksize * sflash->numblocks;
+	sflash->present = true;
+
+	bcma_info(bus, "Found %s serial flash (size: %dKiB, blocksize: 0x%X, blocks: %d)\n",
+		  e->name, sflash->size / 1024, sflash->blocksize,
+		  sflash->numblocks);
+
+	/* Prepare platform device, but don't register it yet. It's too early,
+	 * malloc (required by device_private_init) is not available yet. */
+	bcma_sflash_dev.resource[0].end = bcma_sflash_dev.resource[0].start +
+					  sflash->size;
+	bcma_sflash_dev.dev.platform_data = sflash;
+
 	return 0;
 }
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 10904aa4..648688a 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -7,6 +7,7 @@
 
 #include "bcma_private.h"
 #include <linux/module.h>
+#include <linux/platform_device.h>
 #include <linux/bcma/bcma.h>
 #include <linux/slab.h>
 
@@ -136,6 +137,14 @@ static int bcma_register_cores(struct bcma_bus *bus)
 		dev_id++;
 	}
 
+#ifdef CONFIG_BCMA_SFLASH
+	if (bus->drv_cc.sflash.present) {
+		err = platform_device_register(&bcma_sflash_dev);
+		if (err)
+			bcma_err(bus, "Error registering serial flash\n");
+	}
+#endif
+
 	return 0;
 }
 
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 16c266c..575af84 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -516,6 +516,15 @@ struct bcma_pflash {
 	u32 window_size;
 };
 
+#ifdef CONFIG_BCMA_SFLASH
+struct bcma_sflash {
+	bool present;
+	u32 blocksize;
+	u16 numblocks;
+	u32 size;
+};
+#endif
+
 struct bcma_serial_port {
 	void *regs;
 	unsigned long clockspeed;
@@ -536,6 +545,9 @@ struct bcma_drv_cc {
 	struct bcma_chipcommon_pmu pmu;
 #ifdef CONFIG_BCMA_DRIVER_MIPS
 	struct bcma_pflash pflash;
+#ifdef CONFIG_BCMA_SFLASH
+	struct bcma_sflash sflash;
+#endif
 
 	int nr_serial_ports;
 	struct bcma_serial_port serial_ports[4];
diff --git a/include/linux/bcma/bcma_regs.h b/include/linux/bcma/bcma_regs.h
index a393e82..6c9cb93 100644
--- a/include/linux/bcma/bcma_regs.h
+++ b/include/linux/bcma/bcma_regs.h
@@ -85,4 +85,6 @@
 							 * (2 ZettaBytes), high 32 bits
 							 */
 
+#define BCMA_SFLASH			0x1c000000
+
 #endif /* LINUX_BCMA_REGS_H_ */
-- 
1.7.7

