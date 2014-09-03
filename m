Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:42356 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaICIfn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 04:35:43 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so416637wiv.7
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 01:35:41 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V3] bcma: get info about flash type SoC booted from
Date: Wed,  3 Sep 2014 10:35:13 +0200
Message-Id: <1409733313-11104-1-git-send-email-zajec5@gmail.com> (sfid-20140903_103549_529325_C53454A3)
In-Reply-To: <1409696042-5397-1-git-send-email-zajec5@gmail.com>
References: <1409696042-5397-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is an ongoing work on cleaning MIPS's nvram support so it could be
re-used on other platforms (bcm53xx to say precisely).
This will require a bit of extra logic in bcma this patch implements.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
After some extra discussion it seems my initial idea was correct. It is
not possible on bcm47xx to use anything like a platform device/driver to
handle NVRAM.

V2: We don't use info about boot_dev anywhere else, so don't store it.
    Move the code to the bcma_bus_early_register as we need NVRAM early.
V3: Move this code to the driver_mips.c, it won't be needed on other
    hosts / archs.
---
 drivers/bcma/driver_mips.c     | 62 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/bcma/bcma_regs.h |  5 ++++
 2 files changed, 67 insertions(+)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 11115bb..004d6aa 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -21,6 +21,14 @@
 #include <linux/serial_reg.h>
 #include <linux/time.h>
 
+enum bcma_boot_dev {
+	BCMA_BOOT_DEV_UNK = 0,
+	BCMA_BOOT_DEV_ROM,
+	BCMA_BOOT_DEV_PARALLEL,
+	BCMA_BOOT_DEV_SERIAL,
+	BCMA_BOOT_DEV_NAND,
+};
+
 static const char * const part_probes[] = { "bcm47xxpart", NULL };
 
 static struct physmap_flash_data bcma_pflash_data = {
@@ -229,11 +237,51 @@ u32 bcma_cpu_clock(struct bcma_drv_mips *mcore)
 }
 EXPORT_SYMBOL(bcma_cpu_clock);
 
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
 static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 {
 	struct bcma_bus *bus = mcore->core->bus;
 	struct bcma_drv_cc *cc = &bus->drv_cc;
 	struct bcma_pflash *pflash = &cc->pflash;
+	enum bcma_boot_dev boot_dev;
 
 	switch (cc->capabilities & BCMA_CC_CAP_FLASHT) {
 	case BCMA_CC_FLASHT_STSER:
@@ -269,6 +317,20 @@ static void bcma_core_mips_flash_detect(struct bcma_drv_mips *mcore)
 			bcma_nflash_init(cc);
 		}
 	}
+
+	/* Determine flash type this SoC boots from */
+	boot_dev = bcma_boot_dev(bus);
+	switch (boot_dev) {
+	case BCMA_BOOT_DEV_PARALLEL:
+	case BCMA_BOOT_DEV_SERIAL:
+		/* TODO: Init NVRAM using BCMA_SOC_FLASH2 window */
+		break;
+	case BCMA_BOOT_DEV_NAND:
+		/* TODO: Init NVRAM using BCMA_SOC_FLASH1 window */
+		break;
+	default:
+		break;
+	}
 }
 
 void bcma_core_mips_early_init(struct bcma_drv_mips *mcore)
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

