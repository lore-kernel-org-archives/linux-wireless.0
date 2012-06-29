Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52538 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab2F2XqX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 19:46:23 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 8/9] bcma: add bcma_pmu_spuravoid_pllupdate()
Date: Sat, 30 Jun 2012 01:44:44 +0200
Message-Id: <1341013486-2520-9-git-send-email-hauke@hauke-m.de> (sfid-20120630_014630_338885_C7FD4351)
In-Reply-To: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
References: <1341013486-2520-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is needed by brcmsmac. This code is based on code from
the Broadcom SDK.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_pmu.c        |  183 ++++++++++++++++++++++++++-
 include/linux/bcma/bcma_driver_chipcommon.h |   14 ++
 2 files changed, 196 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 1a7a72f..35c9130 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -3,7 +3,8 @@
  * ChipCommon Power Management Unit driver
  *
  * Copyright 2009, Michael Buesch <m@bues.ch>
- * Copyright 2007, Broadcom Corporation
+ * Copyright 2007, 2011, Broadcom Corporation
+ * Copyright 2011, 2012, Hauke Mehrtens <hauke@hauke-m.de>
  *
  * Licensed under the GNU/GPL. See COPYING for details.
  */
@@ -284,3 +285,183 @@ u32 bcma_pmu_get_clockcpu(struct bcma_drv_cc *cc)
 
 	return bcma_pmu_get_clockcontrol(cc);
 }
+
+static void bcma_pmu_spuravoid_pll_write(struct bcma_drv_cc *cc, u32 offset,
+					 u32 value)
+{
+	bcma_cc_write32(cc, BCMA_CC_PLLCTL_ADDR, offset);
+	bcma_cc_write32(cc, BCMA_CC_PLLCTL_DATA, value);
+}
+
+void bcma_pmu_spuravoid_pllupdate(struct bcma_drv_cc *cc, int spuravoid)
+{
+	u32 tmp = 0;
+	u8 phypll_offset = 0;
+	u8 bcm5357_bcm43236_p1div[] = {0x1, 0x5, 0x5};
+	u8 bcm5357_bcm43236_ndiv[] = {0x30, 0xf6, 0xfc};
+	struct bcma_bus *bus = cc->core->bus;
+
+	switch (bus->chipinfo.id) {
+	case BCMA_CHIP_ID_BCM5357:
+	case BCMA_CHIP_ID_BCM4749:
+	case BCMA_CHIP_ID_BCM53572:
+		/* 5357[ab]0, 43236[ab]0, and 6362b0 */
+
+		/* BCM5357 needs to touch PLL1_PLLCTL[02],
+		   so offset PLL0_PLLCTL[02] by 6 */
+		phypll_offset = (bus->chipinfo.id == BCMA_CHIP_ID_BCM5357 ||
+		       bus->chipinfo.id == BCMA_CHIP_ID_BCM4749 ||
+		       bus->chipinfo.id == BCMA_CHIP_ID_BCM53572) ? 6 : 0;
+
+		/* RMW only the P1 divider */
+		bcma_cc_write32(cc, BCMA_CC_PLLCTL_ADDR,
+				BCMA_CC_PMU_PLL_CTL0 + phypll_offset);
+		tmp = bcma_cc_read32(cc, BCMA_CC_PLLCTL_DATA);
+		tmp &= (~(BCMA_CC_PMU1_PLL0_PC0_P1DIV_MASK));
+		tmp |= (bcm5357_bcm43236_p1div[spuravoid] << BCMA_CC_PMU1_PLL0_PC0_P1DIV_SHIFT);
+		bcma_cc_write32(cc, BCMA_CC_PLLCTL_DATA, tmp);
+
+		/* RMW only the int feedback divider */
+		bcma_cc_write32(cc, BCMA_CC_PLLCTL_ADDR,
+				BCMA_CC_PMU_PLL_CTL2 + phypll_offset);
+		tmp = bcma_cc_read32(cc, BCMA_CC_PLLCTL_DATA);
+		tmp &= ~(BCMA_CC_PMU1_PLL0_PC2_NDIV_INT_MASK);
+		tmp |= (bcm5357_bcm43236_ndiv[spuravoid]) << BCMA_CC_PMU1_PLL0_PC2_NDIV_INT_SHIFT;
+		bcma_cc_write32(cc, BCMA_CC_PLLCTL_DATA, tmp);
+
+		tmp = 1 << 10;
+		break;
+
+	case BCMA_CHIP_ID_BCM4331:
+	case BCMA_CHIP_ID_BCM43431:
+		if (spuravoid == 2) {
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+						     0x11500014);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+						     0x0FC00a08);
+		} else if (spuravoid == 1) {
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+						     0x11500014);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+						     0x0F600a08);
+		} else {
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+						     0x11100014);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+						     0x03000a08);
+		}
+		tmp = 1 << 10;
+		break;
+
+	case BCMA_CHIP_ID_BCM43224:
+	case BCMA_CHIP_ID_BCM43225:
+	case BCMA_CHIP_ID_BCM43421:
+		if (spuravoid == 1) {
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+						     0x11500010);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL1,
+						     0x000C0C06);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+						     0x0F600a08);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL3,
+						     0x00000000);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL4,
+						     0x2001E920);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
+						     0x88888815);
+		} else {
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+						     0x11100010);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL1,
+						     0x000c0c06);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+						     0x03000a08);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL3,
+						     0x00000000);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL4,
+						     0x200005c0);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
+						     0x88888815);
+		}
+		tmp = 1 << 10;
+		break;
+
+	case BCMA_CHIP_ID_BCM4716:
+	case BCMA_CHIP_ID_BCM4748:
+	case BCMA_CHIP_ID_BCM47162:
+		if (spuravoid == 1) {
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+						     0x11500060);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL1,
+						     0x080C0C06);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+						     0x0F600000);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL3,
+						     0x00000000);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL4,
+						     0x2001E924);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
+						     0x88888815);
+		} else {
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+						     0x11100060);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL1,
+						     0x080c0c06);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+						     0x03000000);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL3,
+						     0x00000000);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL4,
+						     0x200005c0);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
+						     0x88888815);
+		}
+
+		tmp = 3 << 9;
+		break;
+
+	case BCMA_CHIP_ID_BCM43227:
+	case BCMA_CHIP_ID_BCM43228:
+	case BCMA_CHIP_ID_BCM43428:
+		/* LCNXN */
+		/* PLL Settings for spur avoidance on/off mode,
+		   no on2 support for 43228A0 */
+		if (spuravoid == 1) {
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+						     0x01100014);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL1,
+						     0x040C0C06);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+						     0x03140A08);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL3,
+						     0x00333333);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL4,
+						     0x202C2820);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
+						     0x88888815);
+		} else {
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+						     0x11100014);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL1,
+						     0x040c0c06);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+						     0x03000a08);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL3,
+						     0x00000000);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL4,
+						     0x200005c0);
+			bcma_pmu_spuravoid_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
+						     0x88888815);
+		}
+		tmp = 1 << 10;
+		break;
+	default:
+		pr_err("unknown spuravoidance settings for chip 0x%04X, not changing PLL\n",
+		       bus->chipinfo.id);
+		break;
+	}
+
+	tmp |= bcma_cc_read32(cc, BCMA_CC_PMU_CTL);
+	bcma_cc_write32(cc, BCMA_CC_PMU_CTL, tmp);
+}
+EXPORT_SYMBOL_GPL(bcma_pmu_spuravoid_pllupdate);
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 09f31ad..12975ea 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -308,6 +308,19 @@
 #define BCMA_CC_PPL_PCHI_OFF		5
 #define BCMA_CC_PPL_PCHI_MASK		0x0000003f
 
+#define BCMA_CC_PMU_PLL_CTL0		0
+#define BCMA_CC_PMU_PLL_CTL1		1
+#define BCMA_CC_PMU_PLL_CTL2		2
+#define BCMA_CC_PMU_PLL_CTL3		3
+#define BCMA_CC_PMU_PLL_CTL4		4
+#define BCMA_CC_PMU_PLL_CTL5		5
+
+#define BCMA_CC_PMU1_PLL0_PC0_P1DIV_MASK	0x00f00000
+#define BCMA_CC_PMU1_PLL0_PC0_P1DIV_SHIFT	20
+
+#define BCMA_CC_PMU1_PLL0_PC2_NDIV_INT_MASK	0x1ff00000
+#define BCMA_CC_PMU1_PLL0_PC2_NDIV_INT_SHIFT	20
+
 /* BCM4331 ChipControl numbers. */
 #define BCMA_CHIPCTL_4331_BT_COEXIST		BIT(0)	/* 0 disable */
 #define BCMA_CHIPCTL_4331_SECI			BIT(1)	/* 0 SECI is disabled (JATG functional) */
@@ -420,5 +433,6 @@ extern void bcma_chipco_chipctl_maskset(struct bcma_drv_cc *cc,
 					u32 offset, u32 mask, u32 set);
 extern void bcma_chipco_regctl_maskset(struct bcma_drv_cc *cc,
 				       u32 offset, u32 mask, u32 set);
+extern void bcma_pmu_spuravoid_pllupdate(struct bcma_drv_cc *cc, int spuravoid);
 
 #endif /* LINUX_BCMA_DRIVER_CC_H_ */
-- 
1.7.9.5

