Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:56103 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934614AbaH0OXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 10:23:51 -0400
Received: by mail-lb0-f175.google.com with SMTP id c11so552632lbj.34
        for <linux-wireless@vger.kernel.org>; Wed, 27 Aug 2014 07:23:49 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: get & store info about flash type SoC booted from
Date: Wed, 27 Aug 2014 16:23:24 +0200
Message-Id: <1409149404-26856-1-git-send-email-zajec5@gmail.com> (sfid-20140827_162354_648982_AD8971AE)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need this info to know where to look for NVRAM.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/main.c            | 43 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/bcma/bcma.h      |  9 +++++++++
 include/linux/bcma/bcma_regs.h |  5 +++++
 3 files changed, 57 insertions(+)

diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 0ff8d58..0f48604 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -110,6 +110,45 @@ bool bcma_wait_value(struct bcma_device *core, u16 reg, u32 mask, u32 value,
 	return false;
 }
 
+static enum bcma_boot_dev bcma_boot_dev(struct bcma_bus *bus)
+{
+	struct bcma_drv_cc *cc = &bus->drv_cc;
+	u8 cc_rev = cc->core->id.rev;
+
+	if (cc_rev == 42) {
+		struct bcma_device *core;
+
+		core = bcma_find_core(bus, BCMA_CORE_NS_ROM);
+		if (core) {
+			switch (bcma_aread32(core, BCMA_IOST) &
+				BCMA_NS_ROM_IOST_BOOT_DEV_MASK) {
+			case BCMA_NS_ROM_IOST_BOOT_DEV_NOR:
+				return BCMA_BOOT_DEV_SERIAL;
+			case BCMA_NS_ROM_IOST_BOOT_DEV_NAND:
+				return BCMA_BOOT_DEV_NAND;
+			case BCMA_NS_ROM_IOST_BOOT_DEV_ROM:
+			default:
+				return BCMA_BOOT_DEV_ROM;
+			}
+		}
+	} else {
+		if (cc_rev == 38) {
+			if (cc->status & BCMA_CC_CHIPST_5357_NAND_BOOT)
+				return BCMA_BOOT_DEV_NAND;
+			else if (cc->status & BIT(5))
+				return BCMA_BOOT_DEV_ROM;
+		}
+
+		if ((cc->capabilities & BCMA_CC_CAP_FLASHT) ==
+		    BCMA_CC_FLASHT_PARA)
+			return BCMA_BOOT_DEV_PARALLEL;
+		else
+			return BCMA_BOOT_DEV_SERIAL;
+	}
+
+	return BCMA_BOOT_DEV_SERIAL;
+}
+
 static void bcma_release_core_dev(struct device *dev)
 {
 	struct bcma_device *core = container_of(dev, struct bcma_device, dev);
@@ -247,6 +286,10 @@ int bcma_bus_register(struct bcma_bus *bus)
 		bcma_core_chipcommon_early_init(&bus->drv_cc);
 	}
 
+	/* Determine flash type this SoC boots from */
+	if (bus->hosttype == BCMA_HOSTTYPE_SOC)
+		bus->boot_dev = bcma_boot_dev(bus);
+
 	/* Try to get SPROM */
 	err = bcma_sprom_get(bus);
 	if (err == -ENOENT) {
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 0272e49..d871568 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -22,6 +22,14 @@ enum bcma_hosttype {
 	BCMA_HOSTTYPE_SOC,
 };
 
+enum bcma_boot_dev {
+	BCMA_BOOT_DEV_UNK = 0,
+	BCMA_BOOT_DEV_ROM,
+	BCMA_BOOT_DEV_PARALLEL,
+	BCMA_BOOT_DEV_SERIAL,
+	BCMA_BOOT_DEV_NAND,
+};
+
 struct bcma_chipinfo {
 	u16 id;
 	u8 rev;
@@ -335,6 +343,7 @@ struct bcma_bus {
 	u8 init_done:1;
 	u8 num;
 
+	enum bcma_boot_dev boot_dev;
 	struct bcma_drv_cc drv_cc;
 	struct bcma_drv_pci drv_pci[2];
 	struct bcma_drv_pcie2 drv_pcie2;
diff --git a/include/linux/bcma/bcma_regs.h b/include/linux/bcma/bcma_regs.h
index 917dcd7..e64ae7b 100644
--- a/include/linux/bcma/bcma_regs.h
+++ b/include/linux/bcma/bcma_regs.h
@@ -39,6 +39,11 @@
 #define  BCMA_RESET_CTL_RESET		0x0001
 #define BCMA_RESET_ST			0x0804
 
+#define BCMA_NS_ROM_IOST_BOOT_DEV_MASK	0x0003
+#define BCMA_NS_ROM_IOST_BOOT_DEV_NOR	0x0000
+#define BCMA_NS_ROM_IOST_BOOT_DEV_NAND	0x0001
+#define BCMA_NS_ROM_IOST_BOOT_DEV_ROM	0x0002
+
 /* BCMA PCI config space registers. */
 #define BCMA_PCI_PMCSR			0x44
 #define  BCMA_PCI_PE			0x100
-- 
1.8.4.5

