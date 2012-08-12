Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36577 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab2HLLIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Aug 2012 07:08:10 -0400
Received: by wicr5 with SMTP id r5so1721953wic.1
        for <linux-wireless@vger.kernel.org>; Sun, 12 Aug 2012 04:08:08 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [BROKEN][PROOF][DONT APPLY][PATCH 2/2] bcm47nflash driver (WIP, BROKEN)
Date: Sun, 12 Aug 2012 13:08:06 +0200
Message-Id: <1344769686-3541-2-git-send-email-zajec5@gmail.com> (sfid-20120812_130815_530109_E206233A)
In-Reply-To: <1344769686-3541-1-git-send-email-zajec5@gmail.com>
References: <1344769686-3541-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is proof of concept for BCMA NAND flash driver. With that patch I
get:
NAND device: Manufacturer ID: 0xec, Chip ID: 0xf1 (Samsung NAND 128MiB
3,3V 8-bit), page size: 2048, OOB size: 64
---
 drivers/bcma/driver_chipcommon_pmu.c        |    2 +-
 drivers/mtd/nand/Kconfig                    |    4 +
 drivers/mtd/nand/Makefile                   |    1 +
 drivers/mtd/nand/bcm47nflash.c              |  293 +++++++++++++++++++++++++++
 include/linux/bcma/bcma_driver_chipcommon.h |    1 +
 5 files changed, 300 insertions(+), 1 deletions(-)
 create mode 100644 drivers/mtd/nand/bcm47nflash.c

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 8b8f2f3..da8b8e7 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -13,7 +13,7 @@
 #include <linux/export.h>
 #include <linux/bcma/bcma.h>
 
-static u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset)
+u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset)
 {
 	bcma_cc_write32(cc, BCMA_CC_PLLCTL_ADDR, offset);
 	bcma_cc_read32(cc, BCMA_CC_PLLCTL_ADDR);
diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
index 31bb7e5..4b8ae37 100644
--- a/drivers/mtd/nand/Kconfig
+++ b/drivers/mtd/nand/Kconfig
@@ -607,4 +607,8 @@ config MTD_NAND_FSMC
 	  Enables support for NAND Flash chips on the ST Microelectronics
 	  Flexible Static Memory Controller (FSMC)
 
+config MTD_NAND_BCM47NFLASH
+	bool "Broadcom NAND flash driver"
+	depends on BCMA && BCMA_NFLASH
+
 endif # MTD_NAND
diff --git a/drivers/mtd/nand/Makefile b/drivers/mtd/nand/Makefile
index d4b4d87..879681f 100644
--- a/drivers/mtd/nand/Makefile
+++ b/drivers/mtd/nand/Makefile
@@ -51,5 +51,6 @@ obj-$(CONFIG_MTD_NAND_MPC5121_NFC)	+= mpc5121_nfc.o
 obj-$(CONFIG_MTD_NAND_RICOH)		+= r852.o
 obj-$(CONFIG_MTD_NAND_JZ4740)		+= jz4740_nand.o
 obj-$(CONFIG_MTD_NAND_GPMI_NAND)	+= gpmi-nand/
+obj-$(CONFIG_MTD_NAND_BCM47NFLASH)	+= bcm47nflash.o
 
 nand-objs := nand_base.o nand_bbt.o
diff --git a/drivers/mtd/nand/bcm47nflash.c b/drivers/mtd/nand/bcm47nflash.c
new file mode 100644
index 0000000..df7f373
--- /dev/null
+++ b/drivers/mtd/nand/bcm47nflash.c
@@ -0,0 +1,293 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/platform_device.h>
+#include <linux/bcma/bcma.h>
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Broadcom NAND flash driver");
+
+/* Broadcom uses 1'000'000 but it seems to be too many. Tests on WNDR4500 has
+ * shown 6 retries were enough. */
+#define NFLASH_READY_RETRIES		100
+
+int devid_column = 0;
+unsigned curr_command = 0;
+
+/**************************************************
+ * Various helpers
+ **************************************************/
+
+static inline u8 bcma_nflash_ns_to_cycle(u16 ns, u16 clock)
+{
+	return ((ns * 1000 * clock) / 1000000) + 1;
+}
+
+static void bcma_nflash_enable(struct bcma_drv_cc *cc, bool enable)
+{
+	if (cc->core->id.rev == 38) {
+		if (cc->status & BCMA_CC_CHIPST_5357_NAND_BOOT)
+			return;
+		if (enable)
+			bcma_chipco_chipctl_maskset(cc, 1, ~0, 0x10000);
+		else
+			bcma_chipco_chipctl_maskset(cc, 1, ~0x10000, 0);
+	}
+}
+
+static int bcma_nflash_ctl_cmd(struct bcma_drv_cc *cc, u32 code)
+{
+	int i = 0;
+
+	bcma_cc_write32(cc, BCMA_CC_NFLASH_CTL, 0x80000000 | code);
+	for (i = 0; i < NFLASH_READY_RETRIES; i++) {
+		if (!(bcma_cc_read32(cc, BCMA_CC_NFLASH_CTL) & 0x80000000)) {
+			i = 0;
+			break;
+		}
+	}
+	if (i) {
+		pr_err("NFLASH control command not ready!\n");
+		return -EBUSY;
+	}
+	return 0;
+}
+
+static int bcma_nflash_poll(struct bcma_drv_cc *cc)
+{
+	int i;
+	u32 tmp;
+
+	if (cc->core->bus->chipinfo.id == BCMA_CHIP_ID_BCM4706) {
+		for (i = 0; i < NFLASH_READY_RETRIES; i++) {
+			if (bcma_cc_read32(cc, BCMA_CC_NFLASH_CTL) &
+			    0x04000000) {
+				if (bcma_cc_read32(cc, BCMA_CC_NFLASH_CTL) &
+				    BCMA_CC_NFLASH_CTL_ERR) {
+					pr_err("Error on polling\n");
+					return -EBUSY;
+				} else {
+					return 0;
+				}
+			}
+		}
+	} else {
+		for (i = 0; i < NFLASH_READY_RETRIES; i++) {
+			tmp = bcma_cc_read32(cc, BCMA_CC_NAND_INTFC_STATUS);
+			if ((tmp & 0xC0000000) == 0xC0000000)
+				return 0;
+		}
+	}
+	pr_err("Polling timeout!\n");
+	return -EBUSY;
+}
+
+static void bcma_nflash_cmd(struct bcma_drv_cc *cc, u32 code)
+{
+	bcma_cc_write32(cc, BCMA_CC_NAND_CMD_START, code);
+	bcma_cc_read32(cc, BCMA_CC_NAND_CMD_START);
+}
+
+/**************************************************
+ * MTD ops
+ **************************************************/
+
+static void bcma_nand_select_chip(struct mtd_info *mtd, int chip)
+{
+	return;
+}
+
+static void bcma_nand_cmdfunc(struct mtd_info *mtd, unsigned command,
+			      int column, int page_addr)
+{
+	struct nand_chip *nand_chip = (struct nand_chip *)mtd->priv;
+	struct bcma_nflash *nflash = (struct bcma_nflash *)nand_chip->priv;
+	struct bcma_drv_cc *cc = container_of(nflash, struct bcma_drv_cc, nflash);
+
+	switch (command) {
+	case NAND_CMD_RESET:
+		break;
+	case NAND_CMD_READID:
+		if (cc->core->bus->chipinfo.id == BCMA_CHIP_ID_BCM4706) {
+			if (bcma_nflash_ctl_cmd(cc, 0x40000000 | 0x01000000 |
+			    0x00080000 | 0x00010000 | 0x00000090) < 0)
+				pr_err("READID error\n");
+		} else {
+			bcma_nflash_enable(cc, true);
+			bcma_nflash_cmd(cc, 7);
+			if (bcma_nflash_poll(cc) < 0) {
+				bcma_nflash_enable(cc, false);
+				pr_err("READID error\n");
+			}
+			bcma_nflash_enable(cc, false);
+		}
+		devid_column = 0;
+		break;
+	default:
+		pr_err("Command 0x%X unsupported\n", command);
+		break;
+	}
+	curr_command = command;
+	pr_info("Set curr_command to 0x%X\n", curr_command);
+}
+
+static u8 bcma_nand_read_byte(struct mtd_info *mtd)
+{
+	struct nand_chip *nand_chip = (struct nand_chip *)mtd->priv;
+	struct bcma_nflash *nflash = (struct bcma_nflash *)nand_chip->priv;
+	struct bcma_drv_cc *cc = container_of(nflash, struct bcma_drv_cc, nflash);
+	u32 code;
+
+	switch (curr_command) {
+	case NAND_CMD_READID:
+		if (cc->core->bus->chipinfo.id == BCMA_CHIP_ID_BCM4706) {
+			u32 tmp;
+			if (devid_column <= 4)
+				code = 0x40000000 | 0x00100000;
+			else
+				code = 0x00100000;
+			if (bcma_nflash_ctl_cmd(cc, code))
+				return 0xff;
+			else
+				tmp = bcma_cc_read32(cc, BCMA_CC_NFLASH_DATA) & 0xFF;
+			pr_info("Returning 0x%X\n", tmp);
+			return tmp;
+		} else {
+			u32 tmp = 0;
+			if (devid_column < 4)
+				tmp = bcma_cc_read32(cc, BCMA_CC_NAND_DEVID);
+			else if (devid_column < 8)
+				tmp = bcma_cc_read32(cc, BCMA_CC_NAND_DEVID_X);
+			else
+				WARN_ON(1);
+			tmp = (tmp >> (8 * curr_command)) & 0xff;
+			devid_column++;
+			return tmp;
+		}
+		break;
+	}
+
+	pr_err("Invalid curr_command: 0x%X\n", curr_command);
+	return 0;
+}
+
+/**************************************************
+ * Init & exit
+ **************************************************/
+
+static int bcma_nflash_init_bcm4706(struct mtd_info *mtd)
+{
+	struct nand_chip *nand_chip = (struct nand_chip *)mtd->priv;
+	struct bcma_nflash *nflash = (struct bcma_nflash *)nand_chip->priv;
+	struct bcma_drv_cc *cc = container_of(nflash, struct bcma_drv_cc, nflash);
+
+	u32 freq;
+	u16 clock;
+	u8 w0, w1, w2, w3, w4;
+
+	/* TODO: Set bit 0x8 in CC flashstrconfig Register */
+
+	if (cc->status & BCMA_CC_CHIPST_4706_PKG_OPTION) {
+		freq = 100000000;
+	} else {
+		freq = bcma_chipco_pll_read(cc, 4);
+		freq = (freq * 0xFFF) >> 3;
+		freq = (freq * 25000000) >> 3;
+	}
+	clock = freq / 1000000;
+	w0 = bcma_nflash_ns_to_cycle(15, clock);
+	w1 = bcma_nflash_ns_to_cycle(20, clock);
+	w2 = bcma_nflash_ns_to_cycle(10, clock);
+	w3 = bcma_nflash_ns_to_cycle(10, clock);
+	w4 = bcma_nflash_ns_to_cycle(100, clock);
+	bcma_cc_write32(cc, BCMA_CC_NFLASH_WAITCNT0,
+			(w4 << 24 | w3 << 18 | w2 << 12 | w1 << 6 | w0));
+
+	pr_info("Scanning: %d\n", nand_scan_ident(mtd, 1, NULL));
+	pr_info("pagemask: 0x%X\n", nand_chip->pagemask);
+	pr_info("page_shift: %d\n", nand_chip->page_shift);
+	pr_info("tail: %d\n", nand_scan_tail(mtd));
+
+	/* TODO: bcma_cc_write32(cc, BCMA_CC_NFLASH_CONF, val); */
+
+	return 0;
+}
+
+static int bcm47nflash_probe(struct platform_device *pdev)
+{
+	struct bcma_nflash *nflash = dev_get_platdata(&pdev->dev);
+	struct bcma_drv_cc *cc = container_of(nflash, struct bcma_drv_cc, nflash);
+	struct mtd_info *mtd = nflash->mtd;
+	struct nand_chip *nand_chip;
+
+	mtd = kzalloc(sizeof(struct mtd_info), GFP_KERNEL);
+	if (!mtd)
+		return -ENOMEM;
+
+	nand_chip = kzalloc(sizeof(struct nand_chip), GFP_KERNEL);
+	if (!nand_chip)
+		return -ENOMEM;
+
+	nand_chip->priv = nflash;
+	nand_chip->select_chip = bcma_nand_select_chip;
+	nand_chip->cmdfunc = bcma_nand_cmdfunc;
+	nand_chip->read_byte = bcma_nand_read_byte;
+	nand_chip->options = NAND_SKIP_BBTSCAN;
+
+	mtd->priv = nand_chip;
+	mtd->owner = THIS_MODULE;
+
+	if (cc->core->bus->chipinfo.id == BCMA_CHIP_ID_BCM4706)
+		bcma_nflash_init_bcm4706(mtd);
+	//else
+	//	bcma_nflash_init_default(mtd);
+
+#if 0
+	err = mtd_device_parse_register(nflash->mtd, probes, NULL, NULL, 0);
+	if (err) {
+		pr_err("Failed to register MTD device: %d\n", err);
+		return err;
+	}
+#endif
+
+	return 0;
+}
+
+static int __devexit bcm47nflash_remove(struct platform_device *pdev)
+{
+	struct bcma_nflash *nflash = dev_get_platdata(&pdev->dev);
+
+	if (nflash->mtd)
+		mtd_device_unregister(nflash->mtd);
+
+	return 0;
+}
+
+static struct platform_driver bcma_nflash_driver = {
+	.remove = __devexit_p(bcm47nflash_remove),
+	.driver = {
+		.name = "bcma_nflash",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init init_bcm47nflash(void)
+{
+	int err;
+
+	err = platform_driver_probe(&bcma_nflash_driver, bcm47nflash_probe);
+	if (err)
+		pr_err("Failed to register serial flash driver: %d\n", err);
+
+	return err;
+}
+
+static void __exit exit_bcm47nflash(void)
+{
+	platform_driver_unregister(&bcma_nflash_driver);
+}
+
+module_init(init_bcm47nflash);
+module_exit(exit_bcm47nflash);
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index b9d7eeb..8507f51 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -606,6 +606,7 @@ u32 bcma_chipco_gpio_polarity(struct bcma_drv_cc *cc, u32 mask, u32 value);
 /* PMU support */
 extern void bcma_pmu_init(struct bcma_drv_cc *cc);
 
+extern u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset);
 extern void bcma_chipco_pll_write(struct bcma_drv_cc *cc, u32 offset,
 				  u32 value);
 extern void bcma_chipco_pll_maskset(struct bcma_drv_cc *cc, u32 offset,
-- 
1.7.7

