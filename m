Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36003 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753748Ab2A3XEf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 18:04:35 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org,
	linux-mips@linux-mips.org, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 7/7] bcma: add extra sprom check
Date: Tue, 31 Jan 2012 00:03:37 +0100
Message-Id: <1327964617-7910-8-git-send-email-hauke@hauke-m.de> (sfid-20120131_000440_003305_FEF9A686)
In-Reply-To: <1327964617-7910-1-git-send-email-hauke@hauke-m.de>
References: <1327964617-7910-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This check is needed on the BCM43224 device as it says in the
capabilities it has an sprom but is extra check says it has not.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/sprom.c                        |    7 +++++++
 include/linux/bcma/bcma_driver_chipcommon.h |   16 ++++++++++++++++
 2 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index e35134f..ca77525 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -250,6 +250,7 @@ int bcma_sprom_get(struct bcma_bus *bus)
 {
 	u16 offset;
 	u16 *sprom;
+	u32 sromctrl;
 	int err = 0;
 
 	if (!bus->drv_cc.core)
@@ -258,6 +259,12 @@ int bcma_sprom_get(struct bcma_bus *bus)
 	if (!(bus->drv_cc.capabilities & BCMA_CC_CAP_SPROM))
 		return -ENOENT;
 
+	if (bus->drv_cc.core->id.rev >= 32) {
+		sromctrl = bcma_read32(bus->drv_cc.core, BCMA_CC_SROM_CONTROL);
+		if (!(sromctrl & BCMA_CC_SROM_CONTROL_PRESENT))
+			return -ENOENT;
+	}
+
 	sprom = kcalloc(SSB_SPROMSIZE_WORDS_R4, sizeof(u16),
 			GFP_KERNEL);
 	if (!sprom)
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index a33086a..e72938b 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -181,6 +181,22 @@
 #define BCMA_CC_FLASH_CFG		0x0128
 #define  BCMA_CC_FLASH_CFG_DS		0x0010	/* Data size, 0=8bit, 1=16bit */
 #define BCMA_CC_FLASH_WAITCNT		0x012C
+#define BCMA_CC_SROM_CONTROL		0x0190
+#define  BCMA_CC_SROM_CONTROL_START	0x80000000
+#define  BCMA_CC_SROM_CONTROL_BUSY	0x80000000
+#define  BCMA_CC_SROM_CONTROL_OPCODE	0x60000000
+#define  BCMA_CC_SROM_CONTROL_OP_READ	0x00000000
+#define  BCMA_CC_SROM_CONTROL_OP_WRITE	0x20000000
+#define  BCMA_CC_SROM_CONTROL_OP_WRDIS	0x40000000
+#define  BCMA_CC_SROM_CONTROL_OP_WREN	0x60000000
+#define  BCMA_CC_SROM_CONTROL_OTPSEL	0x00000010
+#define  BCMA_CC_SROM_CONTROL_LOCK	0x00000008
+#define  BCMA_CC_SROM_CONTROL_SIZE_MASK	0x00000006
+#define  BCMA_CC_SROM_CONTROL_SIZE_1K	0x00000000
+#define  BCMA_CC_SROM_CONTROL_SIZE_4K	0x00000002
+#define  BCMA_CC_SROM_CONTROL_SIZE_16K	0x00000004
+#define  BCMA_CC_SROM_CONTROL_SIZE_SHIFT	1
+#define  BCMA_CC_SROM_CONTROL_PRESENT	0x00000001
 /* 0x1E0 is defined as shared BCMA_CLKCTLST */
 #define BCMA_CC_HW_WORKAROUND		0x01E4 /* Hardware workaround (rev >= 20) */
 #define BCMA_CC_UART0_DATA		0x0300
-- 
1.7.5.4

