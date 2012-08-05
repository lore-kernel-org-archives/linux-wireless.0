Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:53364 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab2HEUDL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 16:03:11 -0400
Received: by wibhm11 with SMTP id hm11so1078149wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 05 Aug 2012 13:03:10 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH V2] bcma: add basic NAND flash driver
Date: Sun,  5 Aug 2012 22:03:07 +0200
Message-Id: <1344196987-32041-1-git-send-email-zajec5@gmail.com> (sfid-20120805_220349_836371_8DC75289)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is basic driver for NAND flash memory that allows reading it's
content. It was succesfully tested on Netgear WNDR4500 which is BCM4706
based router.

This driver has been written using specs at:
http://bcm-v4.sipsolutions.net/NAND_Flash

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>
CC: Hauke Mehrtens <hauke@hauke-m.de>
---
V2: Split bcma_nflash_read into three functions as suggested by Hauke
    Use bcma_* for printing
---
 drivers/bcma/Kconfig                        |    4 +-
 drivers/bcma/bcma_private.h                 |    2 +-
 drivers/bcma/driver_chipcommon_nflash.c     |  402 ++++++++++++++++++++++++++-
 drivers/bcma/driver_chipcommon_pmu.c        |    2 +-
 include/linux/bcma/bcma_driver_chipcommon.h |   88 ++++++
 5 files changed, 490 insertions(+), 8 deletions(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 8d1f777..a58d7a9 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -53,8 +53,8 @@ config BCMA_SFLASH
 	default y
 
 config BCMA_NFLASH
-	bool
-	depends on BCMA_DRIVER_MIPS && BROKEN
+	bool "Support for NAND flash"
+	depends on BCMA_DRIVER_MIPS
 	default y
 
 config BCMA_DRIVER_GMAC_CMN
diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 3cf9cc9..9895c7e 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -68,7 +68,7 @@ int bcma_nflash_init(struct bcma_drv_cc *cc);
 #else
 static inline int bcma_nflash_init(struct bcma_drv_cc *cc)
 {
-	bcma_err(cc->core->bus, "NAND flash not supported\n");
+	bcma_err(cc->core->bus, "NAND flash support not enabled\n");
 	return 0;
 }
 #endif /* CONFIG_BCMA_NFLASH */
diff --git a/drivers/bcma/driver_chipcommon_nflash.c b/drivers/bcma/driver_chipcommon_nflash.c
index 574d624..0d11e6f 100644
--- a/drivers/bcma/driver_chipcommon_nflash.c
+++ b/drivers/bcma/driver_chipcommon_nflash.c
@@ -2,18 +2,412 @@
  * Broadcom specific AMBA
  * ChipCommon NAND flash interface
  *
+ * Copyright 2012, Rafał Miłecki <zajec5@gmail.com>
+ *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
 
+#include "bcma_private.h"
 #include <linux/bcma/bcma.h>
 #include <linux/bcma/bcma_driver_chipcommon.h>
 #include <linux/delay.h>
 
-#include "bcma_private.h"
+/* Broadcom uses 1'000'000 but it seems to be too many. Tests on WNDR4500 has
+ * shown 6 retries were enough. */
+#define NFLASH_READY_RETRIES		100
 
-/* Initialize NAND flash access */
-int bcma_nflash_init(struct bcma_drv_cc *cc)
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
+		if (cc->status & BCMA_CC_CHIPST_REV38_NAND_BOOT)
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
+		bcma_err(cc->core->bus, "NFLASH control command not ready!\n");
+		return -EBUSY;
+	}
+	return 0;
+}
+
+int bcma_nflash_poll(struct bcma_drv_cc *cc)
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
+					bcma_err(cc->core->bus, "Error on polling\n");
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
+	bcma_err(cc->core->bus, "Polling timeout!\n");
+	return -EBUSY;
+}
+
+static void bcma_nflash_cmd(struct bcma_drv_cc *cc, u32 code)
+{
+	bcma_cc_write32(cc, BCMA_CC_NAND_CMD_START, code);
+	bcma_cc_read32(cc, BCMA_CC_NAND_CMD_START);
+}
+
+static char *bcma_nflash_check_id(u8 *id)
+{
+	switch (id[0]) {
+	case 0x01:
+		return "AMD";
+	case 0x20:
+		return "Numonyx";
+	case 0x2c:
+		return "Micron";
+	case 0x98:
+		return "Toshiba";
+	case 0xad:
+		return "Hynix";
+	case 0xec:
+		return "Samsung";
+	}
+	return NULL;
+}
+
+/**************************************************
+ * Initialize NAND flash access
+ **************************************************/
+
+static int bcma_nflash_init_bcm4706(struct bcma_drv_cc *cc)
+{
+	struct bcma_bus *bus = cc->core->bus;
+	struct bcma_nflash *nflash = &cc->nflash;
+
+	u32 freq, code, val, tmp;
+	u16 clock;
+	u8 w0, w1, w2, w3, w4;
+	u8 cbits, tbits;
+	u8 csize, rbits, bsize;
+	char *name;
+	int i;
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
+		(w4 << 24 | w3 << 18 | w2 << 12 | w1 << 6 | w0));
+	if (bcma_nflash_ctl_cmd(cc, 0x40000000 | 0x01000000 | 0x00080000 |
+				    0x00010000 | 0x00000090))
+		return -EBUSY;
+
+	for (i = 0; i < 5; i++) {
+		/* Useless Broadcom condition dropped */
+		code = 0x40000000 | 0x00100000;
+		if (bcma_nflash_ctl_cmd(cc, code))
+			return -EBUSY;
+		else
+			nflash->id[i] =
+				bcma_cc_read32(cc, BCMA_CC_NFLASH_DATA) & 0xFF;
+	}
+
+	name = bcma_nflash_check_id(nflash->id);
+	if (name == NULL) {
+		bcma_err(bus, "Invalid flash id: 0x%X\n", nflash->id[0]);
+		/* TODO: Clear bit 8 of Register flashstrconfig */
+		return -ENOTSUPP;
+	}
+
+	nflash->type = nflash->id[0];
+	nflash->pagesize = 1024 << (nflash->id[3] & 0x3);
+	nflash->blocksize = (64 * 1024) << ((nflash->id[3] >> 4) & 0x3);
+	tmp = (8 << ((nflash->id[3] >> 2) & 0x1));
+	nflash->oobsize = tmp * nflash->pagesize / 512;
+	nflash->size = (8 << ((nflash->id[4] >> 4) & 0x7)) *
+		       (1 << ((nflash->id[4] >> 2) & 0x3));
+
+	tbits = ffs(nflash->size); /* find first bit set */
+	if (!tbits || tbits != fls(nflash->size)) {
+		bcma_err(bus, "Invalid flash size 0x%X\n", nflash->size);
+		return -ENOTSUPP;
+	}
+	tbits += 19; /* Broadcom increases *index* by 20, we increase *pos* */
+
+	cbits = ffs(nflash->pagesize);
+	if (!cbits || cbits != fls(nflash->pagesize)) {
+		bcma_err(bus, "Invalid flash pagesize 0x%X\n",
+			 nflash->pagesize);
+		return -ENOTSUPP;
+	}
+
+	nflash->col_mask = (1 << cbits) - 1;
+	nflash->row_shift = cbits;
+	csize = (cbits + 7) / 8;
+	rbits = tbits - cbits + 1;
+	bsize = (rbits + 7) / 8;
+	val = ((bsize - 1) << 6) | ((csize - 1) << 4) | 2;
+	bcma_cc_write32(cc, BCMA_CC_NFLASH_CONF, val);
+
+	bcma_info(bus, "Found %s %dMiB NAND flash, pagesize: %dB, blocksize: %dKiB\n",
+		  name, nflash->size, nflash->pagesize,
+		  nflash->blocksize / 1024);
+	nflash->present = true;
+	return 0;
+}
+
+static int bcma_nflash_init_default(struct bcma_drv_cc *cc)
 {
-	bcma_err(cc->core->bus, "NAND flash support is broken\n");
+	struct bcma_bus *bus = cc->core->bus;
+	struct bcma_nflash *nflash = &cc->nflash;
+	u32 id, id2, ncfg, control, val;
+	char *name;
+	int i;
+
+	bcma_nflash_enable(cc, true);
+	bcma_nflash_cmd(cc, 7);
+	if (bcma_nflash_poll(cc) < 0) {
+		bcma_nflash_enable(cc, false);
+		return -EBUSY;
+	}
+	bcma_nflash_enable(cc, false);
+
+	id = bcma_cc_read32(cc, BCMA_CC_NAND_DEVID);
+	id2 = bcma_cc_read32(cc, BCMA_CC_NAND_DEVID_X);
+	for (i = 0; i < 5; i++) {
+		if (i < 4)
+			nflash->id[i] = (id >> (8 * i)) & 0xff;
+		else
+			nflash->id[i] = id2 & 0xff;
+	}
+
+	name = bcma_nflash_check_id(nflash->id);
+	if (name == NULL) {
+		bcma_err(bus, "Invalid flash id: 0x%X\n", nflash->id[0]);
+		return -ENOTSUPP;
+	}
+
+	nflash->type = nflash->id[0];
+
+	ncfg = bcma_cc_read32(cc, BCMA_CC_NAND_CONFIG);
+	switch ((ncfg >> 20) & 3) {
+	case 0:
+		nflash->pagesize = 0x200;
+		break;
+	case 1:
+		nflash->pagesize = 0x800;
+		break;
+	case 2:
+		nflash->pagesize = 0x1000;
+		break;
+	default:
+		nflash->pagesize = 0x2000;
+		break;
+	}
+	val = (ncfg >> 28) & 7;
+	switch (val) {
+	case 0:
+		nflash->blocksize = 0x4000;
+		break;
+	case 1:
+		nflash->blocksize = 0x20000;
+		break;
+	case 2:
+		nflash->blocksize = 0x2000;
+		break;
+	case 3:
+		nflash->blocksize = 0x80000;
+		break;
+	case 4:
+		nflash->blocksize = 0x40000;
+		break;
+	default:
+		nflash->blocksize = 0;
+		bcma_err(bus, "Unknown blocksize\n");
+		return -ENOTSUPP;
+	}
+	nflash->size = (1 << (val - 1)) * 8;
+
+	control = bcma_cc_read32(cc, BCMA_CC_NAND_ACC_CONTROL);
+	nflash->ecclevel = (control & 0x000f0000) >> 16;
+	nflash->ecclevel0 = (control & 0x00f00000) >> 20;
+	if (nflash->ecclevel != nflash->ecclevel0) {
+		control = control & ~(0x00ff0000);
+		control = control | (nflash->ecclevel0 << 20) |
+				(nflash->ecclevel0 << 16);
+		bcma_cc_write32(cc, BCMA_CC_NAND_ACC_CONTROL, control);
+		nflash->ecclevel = nflash->ecclevel0;
+	}
+	nflash->numblocks = (nflash->size * (1 << 10)) /
+			    (nflash->blocksize >> 10);
+	if (nflash->size == 0) {
+		bcma_err(bus, "Invalid flash size\n");
+		return -ENOTSUPP;
+	}
+
+	bcma_info(bus, "Found %s %dMiB NAND flash, pagesize: %dB, blocksize: %dKiB\n",
+		  name, nflash->size, nflash->pagesize,
+		  nflash->blocksize / 1024);
+	nflash->present = true;
 	return 0;
 }
+
+int bcma_nflash_init(struct bcma_drv_cc *cc)
+{
+	struct bcma_bus *bus = cc->core->bus;
+
+	if (cc->core->bus->chipinfo.id != BCMA_CHIP_ID_BCM4706 &&
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
+	if (cc->nflash.present) {
+		bcma_warn(bus, "NAND flash already initialized");
+		return 0;
+	}
+
+	if (cc->core->bus->chipinfo.id == BCMA_CHIP_ID_BCM4706)
+		return bcma_nflash_init_bcm4706(cc);
+	else
+		return bcma_nflash_init_default(cc);
+}
+
+/**************************************************
+ * R/W ops
+ **************************************************/
+
+static int bcma_nflash_read_bcm4706(struct bcma_drv_cc *cc, uint offset,
+				    uint len, u8 *buf)
+{
+	struct bcma_nflash *nflash = &cc->nflash;
+	u32 page_offset, page_addr, ctrlcode;
+	u32 *dest = (u32 *)buf;
+	uint remains = len;
+	int i;
+
+	while (remains > 0) {
+		page_offset = offset & (nflash->pagesize - 1);
+		page_addr = (offset & ~(nflash->pagesize - 1)) *
+			    2 + page_offset;
+		bcma_cc_write32(cc, BCMA_CC_NFLASH_COL_ADDR,
+				page_addr & nflash->col_mask);
+		bcma_cc_write32(cc, BCMA_CC_NFLASH_ROW_ADDR,
+				page_addr >> nflash->row_shift);
+
+		ctrlcode = 0x40000000 | 0x00080000 | 0x00040000 | 0x00020000 |
+			   0x00010000 | 0x3000;
+		if (bcma_nflash_ctl_cmd(cc, ctrlcode))
+			break;
+		if (bcma_nflash_poll(cc) < 0)
+			break;
+		for (i = 0; i < 512; i += 4, dest++) {
+			if (i < 508)
+				ctrlcode = 0x40000000 | 0x30000000 | 0x00100000;
+			else
+				ctrlcode = 0x30000000 | 0x00100000;
+			if (bcma_nflash_ctl_cmd(cc, ctrlcode))
+				return len - remains;
+			*dest = bcma_cc_read32(cc, BCMA_CC_NFLASH_DATA);
+		}
+		remains -= 512;
+		offset += 512;
+	}
+	return len - remains;
+}
+
+static int bcma_nflash_read_default(struct bcma_drv_cc *cc, uint offset,
+				    uint len, u8 *buf)
+{
+	u32 *dest = (u32 *)buf;
+	uint remains = len;
+	int i;
+
+	bcma_nflash_enable(cc, true);
+	while (remains > 0) {
+		bcma_cc_write32(cc, BCMA_CC_NAND_CMD_ADDR, offset);
+		bcma_nflash_cmd(cc, 1);
+		if (bcma_nflash_poll(cc) < 0)
+			break;
+		if (!(bcma_cc_read32(cc, BCMA_CC_NAND_INTFC_STATUS) &
+			0x20000000))
+			break;
+		for (i = 0; i < 512; i += 4, dest++)
+			*dest = bcma_cc_read32(cc, BCMA_CC_NAND_CACHE_DATA);
+		remains -= 512;
+		offset += 512;
+	}
+	bcma_nflash_enable(cc, false);
+	return len - remains;
+}
+
+int bcma_nflash_read(struct bcma_drv_cc *cc, uint offset, uint len, u8 *buf)
+{
+	struct bcma_nflash *nflash = &cc->nflash;
+	u32 mask = 0x1FF;
+	u32 tmp;
+
+	if ((offset & mask) != 0 || (len & mask) != 0)
+		return 0;
+
+	tmp = (offset + len) >> 20;
+	if (tmp > nflash->size)
+		return 0;
+	if (tmp == nflash->size && ((offset + len) & ((1 << 20) - 1)) != 0)
+		return 0;
+
+	if (cc->core->bus->chipinfo.id == BCMA_CHIP_ID_BCM4706)
+		return bcma_nflash_read_bcm4706(cc, offset, len, buf);
+	else
+		return bcma_nflash_read_default(cc, offset, len, buf);
+}
diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 4432617..fd6620e 100644
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
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 3c80885..c80d8f1 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -94,6 +94,7 @@
 #define  BCMA_CC_CHIPST_4706_SFLASH_TYPE	BIT(2) /* 0: 8b-p/ST-s flash, 1: 16b-p/Atmal-s flash */
 #define  BCMA_CC_CHIPST_4706_MIPS_BENDIAN	BIT(3) /* 0: little, 1: big endian */
 #define  BCMA_CC_CHIPST_4706_PCIE1_DISABLE	BIT(5) /* PCIE1 enable strap pin */
+#define  BCMA_CC_CHIPST_REV38_NAND_BOOT		BIT(4) /* NAND boot, valid for CC rev 38 */
 #define BCMA_CC_JCMD			0x0030		/* Rev >= 10 only */
 #define  BCMA_CC_JCMD_START		0x80000000
 #define  BCMA_CC_JCMD_BUSY		0x80000000
@@ -260,6 +261,14 @@
 #define  BCMA_CC_SROM_CONTROL_SIZE_16K	0x00000004
 #define  BCMA_CC_SROM_CONTROL_SIZE_SHIFT	1
 #define  BCMA_CC_SROM_CONTROL_PRESENT	0x00000001
+/* NAND flash registers for BCM4706 (corerev = 31) */
+#define BCMA_CC_NFLASH_CTL		0x01A0
+#define  BCMA_CC_NFLASH_CTL_ERR		0x08000000
+#define BCMA_CC_NFLASH_CONF		0x01A4
+#define BCMA_CC_NFLASH_COL_ADDR		0x01A8
+#define BCMA_CC_NFLASH_ROW_ADDR		0x01AC
+#define BCMA_CC_NFLASH_DATA		0x01B0
+#define BCMA_CC_NFLASH_WAITCNT0		0x01B4
 /* 0x1E0 is defined as shared BCMA_CLKCTLST */
 #define BCMA_CC_HW_WORKAROUND		0x01E4 /* Hardware workaround (rev >= 20) */
 #define BCMA_CC_UART0_DATA		0x0300
@@ -319,6 +328,60 @@
 #define BCMA_CC_PLLCTL_ADDR		0x0660
 #define BCMA_CC_PLLCTL_DATA		0x0664
 #define BCMA_CC_SPROM			0x0800 /* SPROM beginning */
+/* NAND flash MLC controller registers (corerev >= 38) */
+#define BCMA_CC_NAND_REVISION		0x0C00
+#define BCMA_CC_NAND_CMD_START		0x0C04
+#define BCMA_CC_NAND_CMD_ADDR_X		0x0C08
+#define BCMA_CC_NAND_CMD_ADDR		0x0C0C
+#define BCMA_CC_NAND_CMD_END_ADDR	0x0C10
+#define BCMA_CC_NAND_CS_NAND_SELECT	0x0C14
+#define BCMA_CC_NAND_CS_NAND_XOR	0x0C18
+#define BCMA_CC_NAND_SPARE_RD0		0x0C20
+#define BCMA_CC_NAND_SPARE_RD4		0x0C24
+#define BCMA_CC_NAND_SPARE_RD8		0x0C28
+#define BCMA_CC_NAND_SPARE_RD12		0x0C2C
+#define BCMA_CC_NAND_SPARE_WR0		0x0C30
+#define BCMA_CC_NAND_SPARE_WR4		0x0C34
+#define BCMA_CC_NAND_SPARE_WR8		0x0C38
+#define BCMA_CC_NAND_SPARE_WR12		0x0C3C
+#define BCMA_CC_NAND_ACC_CONTROL	0x0C40
+#define BCMA_CC_NAND_CONFIG		0x0C48
+#define BCMA_CC_NAND_TIMING_1		0x0C50
+#define BCMA_CC_NAND_TIMING_2		0x0C54
+#define BCMA_CC_NAND_SEMAPHORE		0x0C58
+#define BCMA_CC_NAND_DEVID		0x0C60
+#define BCMA_CC_NAND_DEVID_X		0x0C64
+#define BCMA_CC_NAND_BLOCK_LOCK_STATUS	0x0C68
+#define BCMA_CC_NAND_INTFC_STATUS	0x0C6C
+#define BCMA_CC_NAND_ECC_CORR_ADDR_X	0x0C70
+#define BCMA_CC_NAND_ECC_CORR_ADDR	0x0C74
+#define BCMA_CC_NAND_ECC_UNC_ADDR_X	0x0C78
+#define BCMA_CC_NAND_ECC_UNC_ADDR	0x0C7C
+#define BCMA_CC_NAND_READ_ERROR_COUNT	0x0C80
+#define BCMA_CC_NAND_CORR_STAT_THRESHOLD	0x0C84
+#define BCMA_CC_NAND_READ_ADDR_X	0x0C90
+#define BCMA_CC_NAND_READ_ADDR		0x0C94
+#define BCMA_CC_NAND_PAGE_PROGRAM_ADDR_X	0x0C98
+#define BCMA_CC_NAND_PAGE_PROGRAM_ADDR	0x0C9C
+#define BCMA_CC_NAND_COPY_BACK_ADDR_X	0x0CA0
+#define BCMA_CC_NAND_COPY_BACK_ADDR	0x0CA4
+#define BCMA_CC_NAND_BLOCK_ERASE_ADDR_X	0x0CA8
+#define BCMA_CC_NAND_BLOCK_ERASE_ADDR	0x0CAC
+#define BCMA_CC_NAND_INV_READ_ADDR_X	0x0CB0
+#define BCMA_CC_NAND_INV_READ_ADDR	0x0CB4
+#define BCMA_CC_NAND_BLK_WR_PROTECT	0x0CC0
+#define BCMA_CC_NAND_ACC_CONTROL_CS1	0x0CD0
+#define BCMA_CC_NAND_CONFIG_CS1		0x0CD4
+#define BCMA_CC_NAND_TIMING_1_CS1	0x0CD8
+#define BCMA_CC_NAND_TIMING_2_CS1	0x0CDC
+#define BCMA_CC_NAND_SPARE_RD16		0x0D30
+#define BCMA_CC_NAND_SPARE_RD20		0x0D34
+#define BCMA_CC_NAND_SPARE_RD24		0x0D38
+#define BCMA_CC_NAND_SPARE_RD28		0x0D3C
+#define BCMA_CC_NAND_CACHE_ADDR		0x0D40
+#define BCMA_CC_NAND_CACHE_DATA		0x0D44
+#define BCMA_CC_NAND_CTRL_CONFIG	0x0D48
+#define BCMA_CC_NAND_CTRL_STATUS	0x0D4C
 
 /* Divider allocation in 4716/47162/5356 */
 #define BCMA_CC_PMU5_MAINPLL_CPU	1
@@ -424,6 +487,26 @@ struct bcma_pflash {
 	u32 window_size;
 };
 
+#ifdef CONFIG_BCMA_NFLASH
+struct bcma_nflash {
+	bool present;
+
+	uint blocksize; /* Block size */
+	uint pagesize; /* Page size */
+	uint oobsize; /* OOB size per page */
+	uint numblocks; /* Number of blocks */
+	u32 type; /* Type */
+	uint size; /* Total size */
+	u8 id[5];
+	uint ecclevel; /* ECC algorithm for blocks other than block 0 */
+	uint ecclevel0; /* ECC algorithm for blocks 0 */
+
+	/* BCM4706 specific */
+	u32 col_mask;
+	u32 row_shift;
+};
+#endif
+
 struct bcma_serial_port {
 	void *regs;
 	unsigned long clockspeed;
@@ -442,8 +525,12 @@ struct bcma_drv_cc {
 	/* Fast Powerup Delay constant */
 	u16 fast_pwrup_delay;
 	struct bcma_chipcommon_pmu pmu;
+
 #ifdef CONFIG_BCMA_DRIVER_MIPS
 	struct bcma_pflash pflash;
+#ifdef CONFIG_BCMA_NFLASH
+	struct bcma_nflash nflash;
+#endif
 
 	int nr_serial_ports;
 	struct bcma_serial_port serial_ports[4];
@@ -488,6 +575,7 @@ u32 bcma_chipco_gpio_polarity(struct bcma_drv_cc *cc, u32 mask, u32 value);
 /* PMU support */
 extern void bcma_pmu_init(struct bcma_drv_cc *cc);
 
+u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset);
 extern void bcma_chipco_pll_write(struct bcma_drv_cc *cc, u32 offset,
 				  u32 value);
 extern void bcma_chipco_pll_maskset(struct bcma_drv_cc *cc, u32 offset,
-- 
1.7.7

