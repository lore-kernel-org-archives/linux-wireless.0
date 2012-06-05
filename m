Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35904 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab2FEVze (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 17:55:34 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 7/8] bcma: add bcma_pmu_spuravoid_pllupdate()
Date: Tue,  5 Jun 2012 23:55:06 +0200
Message-Id: <1338933307-13446-8-git-send-email-hauke@hauke-m.de> (sfid-20120605_235538_469939_F7A3892F)
In-Reply-To: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function is needed by brcmsmac. This code is based on code from
the Broadcom SDK.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_chipcommon_pmu.c        |  211 ++++++++++++++++++++++++++-
 include/linux/bcma/bcma_driver_chipcommon.h |   14 ++
 2 files changed, 224 insertions(+), 1 deletion(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 9bf2dff..ea054a2 100644
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
@@ -360,3 +361,211 @@ u32 bcma_pmu_get_clockcpu(struct bcma_drv_cc *cc)
 
 	return bcma_pmu_get_clockcontrol(cc);
 }
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
+	case BCMA_CHIP_ID_BCM6362:
+	case BCMA_CHIP_ID_BCM53572:
+
+		if  (bus->chipinfo.id == BCMA_CHIP_ID_BCM6362 &&
+		     bus->chipinfo.rev == 0) {
+			/* 6362a0 (same clks as 4322[4-6]) */
+			if (spuravoid == 1) {
+				bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+						      0x11500010);
+				bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL1,
+						      0x000C0C06);
+				bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+						      0x0F600a08);
+				bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL3,
+						      0x00000000);
+				bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL4,
+						      0x2001E920);
+				bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
+						      0x88888815);
+			} else {
+				bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+						      0x11100010);
+				bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL1,
+						      0x000c0c06);
+				bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+						      0x03000a08);
+				bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL3,
+						      0x00000000);
+				bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL4,
+						      0x200005c0);
+				bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
+						      0x88888815);
+			}
+
+		} else {
+			/* 5357[ab]0, 43236[ab]0, and 6362b0 */
+
+			/* BCM5357 needs to touch PLL1_PLLCTL[02],
+			   so offset PLL0_PLLCTL[02] by 6 */
+			phypll_offset = (bus->chipinfo.id == BCMA_CHIP_ID_BCM5357 ||
+			       bus->chipinfo.id == BCMA_CHIP_ID_BCM4749 ||
+			       bus->chipinfo.id == BCMA_CHIP_ID_BCM53572) ? 6 : 0;
+
+			/* RMW only the P1 divider */
+			bcma_cc_write32(cc, BCMA_CC_PLLCTL_ADDR,
+					BCMA_CC_PMU_PLL_CTL0 + phypll_offset);
+			tmp = bcma_cc_read32(cc, BCMA_CC_PLLCTL_DATA);
+			tmp &= (~(BCMA_CC_PMU1_PLL0_PC0_P1DIV_MASK));
+			tmp |= (bcm5357_bcm43236_p1div[spuravoid] << BCMA_CC_PMU1_PLL0_PC0_P1DIV_SHIFT);
+			bcma_cc_write32(cc, BCMA_CC_PLLCTL_DATA, tmp);
+
+			/* RMW only the int feedback divider */
+			bcma_cc_write32(cc, BCMA_CC_PLLCTL_ADDR,
+					BCMA_CC_PMU_PLL_CTL2 + phypll_offset);
+			tmp = bcma_cc_read32(cc, BCMA_CC_PLLCTL_DATA);
+			tmp &= ~(BCMA_CC_PMU1_PLL0_PC2_NDIV_INT_MASK);
+			tmp |= (bcm5357_bcm43236_ndiv[spuravoid]) << BCMA_CC_PMU1_PLL0_PC2_NDIV_INT_SHIFT;
+			bcma_cc_write32(cc, BCMA_CC_PLLCTL_DATA, tmp);
+		}
+
+		tmp = 1 << 10;
+		break;
+
+	case BCMA_CHIP_ID_BCM4331:
+	case BCMA_CHIP_ID_BCM43431:
+		if (spuravoid == 2) {
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+					      0x11500014);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+					      0x0FC00a08);
+		} else if (spuravoid == 1) {
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+					      0x11500014);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+					      0x0F600a08);
+		} else {
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+					      0x11100014);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+					      0x03000a08);
+		}
+		tmp = 1 << 10;
+		break;
+
+	case BCMA_CHIP_ID_BCM43224:
+	case BCMA_CHIP_ID_BCM43225:
+	case BCMA_CHIP_ID_BCM43421:
+		if (spuravoid == 1) {
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+					      0x11500010);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL1,
+					      0x000C0C06);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+					      0x0F600a08);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL3,
+					      0x00000000);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL4,
+					      0x2001E920);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
+					      0x88888815);
+		} else {
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+					      0x11100010);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL1,
+					      0x000c0c06);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+					      0x03000a08);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL3,
+					      0x00000000);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL4,
+					      0x200005c0);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
+					      0x88888815);
+		}
+		tmp = 1 << 10;
+		break;
+
+	case BCMA_CHIP_ID_BCM4716:
+	case BCMA_CHIP_ID_BCM4748:
+	case BCMA_CHIP_ID_BCM47162:
+		if (spuravoid == 1) {
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+					      0x11500060);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL1,
+					      0x080C0C06);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+					      0x0F600000);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL3,
+					      0x00000000);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL4,
+					      0x2001E924);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
+					      0x88888815);
+		} else {
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+					      0x11100060);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL1,
+					      0x080c0c06);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+					      0x03000000);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL3,
+					      0x00000000);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL4,
+					      0x200005c0);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
+					      0x88888815);
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
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+					      0x01100014);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL1,
+					      0x040C0C06);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+					      0x03140A08);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL3,
+					      0x00333333);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL4,
+					      0x202C2820);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
+					      0x88888815);
+		} else {
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL0,
+					      0x11100014);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL1,
+					      0x040c0c06);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL2,
+					      0x03000a08);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL3,
+					      0x00000000);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL4,
+					      0x200005c0);
+			bcma_chipco_pll_write(cc, BCMA_CC_PMU_PLL_CTL5,
+					      0x88888815);
+		}
+		tmp = 1 << 10;
+		break;
+	default:
+		pr_err("unknown spuravoidance settings for chip 0x%04X, not"
+		       " changing PLL\n", bus->chipinfo.id);
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

