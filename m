Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:35282 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757390AbcASHpm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 02:45:42 -0500
Received: by mail-lf0-f52.google.com with SMTP id c192so333061049lfe.2
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2016 23:45:42 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] bcma: use _PMU_ in all names of PMU registers
Date: Tue, 19 Jan 2016 08:45:25 +0100
Message-Id: <1453189526-24689-1-git-send-email-zajec5@gmail.com> (sfid-20160119_084552_694272_FC455E75)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PMU (Power Management Unit) seems to be a separated piece of hardware,
just accessed using ChipCommon core registers. In recent Broadcom
chipsets PMU is not bounded to CC but available as separated core.

To make code cleaner & easier to review (for a correct R/W access) use
clearer names.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon_pmu.c        | 46 ++++++++++++++---------------
 drivers/net/wireless/broadcom/b43/main.c    |  8 ++---
 include/linux/bcma/bcma_driver_chipcommon.h | 12 ++++----
 3 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index fe0d48c..472f39d 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -15,44 +15,44 @@
 
 u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset)
 {
-	bcma_cc_write32(cc, BCMA_CC_PLLCTL_ADDR, offset);
-	bcma_cc_read32(cc, BCMA_CC_PLLCTL_ADDR);
-	return bcma_cc_read32(cc, BCMA_CC_PLLCTL_DATA);
+	bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR, offset);
+	bcma_cc_read32(cc, BCMA_CC_PMU_PLLCTL_ADDR);
+	return bcma_cc_read32(cc, BCMA_CC_PMU_PLLCTL_DATA);
 }
 EXPORT_SYMBOL_GPL(bcma_chipco_pll_read);
 
 void bcma_chipco_pll_write(struct bcma_drv_cc *cc, u32 offset, u32 value)
 {
-	bcma_cc_write32(cc, BCMA_CC_PLLCTL_ADDR, offset);
-	bcma_cc_read32(cc, BCMA_CC_PLLCTL_ADDR);
-	bcma_cc_write32(cc, BCMA_CC_PLLCTL_DATA, value);
+	bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR, offset);
+	bcma_cc_read32(cc, BCMA_CC_PMU_PLLCTL_ADDR);
+	bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_DATA, value);
 }
 EXPORT_SYMBOL_GPL(bcma_chipco_pll_write);
 
 void bcma_chipco_pll_maskset(struct bcma_drv_cc *cc, u32 offset, u32 mask,
 			     u32 set)
 {
-	bcma_cc_write32(cc, BCMA_CC_PLLCTL_ADDR, offset);
-	bcma_cc_read32(cc, BCMA_CC_PLLCTL_ADDR);
-	bcma_cc_maskset32(cc, BCMA_CC_PLLCTL_DATA, mask, set);
+	bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR, offset);
+	bcma_cc_read32(cc, BCMA_CC_PMU_PLLCTL_ADDR);
+	bcma_cc_maskset32(cc, BCMA_CC_PMU_PLLCTL_DATA, mask, set);
 }
 EXPORT_SYMBOL_GPL(bcma_chipco_pll_maskset);
 
 void bcma_chipco_chipctl_maskset(struct bcma_drv_cc *cc,
 				 u32 offset, u32 mask, u32 set)
 {
-	bcma_cc_write32(cc, BCMA_CC_CHIPCTL_ADDR, offset);
-	bcma_cc_read32(cc, BCMA_CC_CHIPCTL_ADDR);
-	bcma_cc_maskset32(cc, BCMA_CC_CHIPCTL_DATA, mask, set);
+	bcma_cc_write32(cc, BCMA_CC_PMU_CHIPCTL_ADDR, offset);
+	bcma_cc_read32(cc, BCMA_CC_PMU_CHIPCTL_ADDR);
+	bcma_cc_maskset32(cc, BCMA_CC_PMU_CHIPCTL_DATA, mask, set);
 }
 EXPORT_SYMBOL_GPL(bcma_chipco_chipctl_maskset);
 
 void bcma_chipco_regctl_maskset(struct bcma_drv_cc *cc, u32 offset, u32 mask,
 				u32 set)
 {
-	bcma_cc_write32(cc, BCMA_CC_REGCTL_ADDR, offset);
-	bcma_cc_read32(cc, BCMA_CC_REGCTL_ADDR);
-	bcma_cc_maskset32(cc, BCMA_CC_REGCTL_DATA, mask, set);
+	bcma_cc_write32(cc, BCMA_CC_PMU_REGCTL_ADDR, offset);
+	bcma_cc_read32(cc, BCMA_CC_PMU_REGCTL_ADDR);
+	bcma_cc_maskset32(cc, BCMA_CC_PMU_REGCTL_DATA, mask, set);
 }
 EXPORT_SYMBOL_GPL(bcma_chipco_regctl_maskset);
 
@@ -472,8 +472,8 @@ u32 bcma_pmu_get_cpu_clock(struct bcma_drv_cc *cc)
 static void bcma_pmu_spuravoid_pll_write(struct bcma_drv_cc *cc, u32 offset,
 					 u32 value)
 {
-	bcma_cc_write32(cc, BCMA_CC_PLLCTL_ADDR, offset);
-	bcma_cc_write32(cc, BCMA_CC_PLLCTL_DATA, value);
+	bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR, offset);
+	bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_DATA, value);
 }
 
 void bcma_pmu_spuravoid_pllupdate(struct bcma_drv_cc *cc, int spuravoid)
@@ -497,20 +497,20 @@ void bcma_pmu_spuravoid_pllupdate(struct bcma_drv_cc *cc, int spuravoid)
 		       bus->chipinfo.id == BCMA_CHIP_ID_BCM53572) ? 6 : 0;
 
 		/* RMW only the P1 divider */
-		bcma_cc_write32(cc, BCMA_CC_PLLCTL_ADDR,
+		bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR,
 				BCMA_CC_PMU_PLL_CTL0 + phypll_offset);
-		tmp = bcma_cc_read32(cc, BCMA_CC_PLLCTL_DATA);
+		tmp = bcma_cc_read32(cc, BCMA_CC_PMU_PLLCTL_DATA);
 		tmp &= (~(BCMA_CC_PMU1_PLL0_PC0_P1DIV_MASK));
 		tmp |= (bcm5357_bcm43236_p1div[spuravoid] << BCMA_CC_PMU1_PLL0_PC0_P1DIV_SHIFT);
-		bcma_cc_write32(cc, BCMA_CC_PLLCTL_DATA, tmp);
+		bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_DATA, tmp);
 
 		/* RMW only the int feedback divider */
-		bcma_cc_write32(cc, BCMA_CC_PLLCTL_ADDR,
+		bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR,
 				BCMA_CC_PMU_PLL_CTL2 + phypll_offset);
-		tmp = bcma_cc_read32(cc, BCMA_CC_PLLCTL_DATA);
+		tmp = bcma_cc_read32(cc, BCMA_CC_PMU_PLLCTL_DATA);
 		tmp &= ~(BCMA_CC_PMU1_PLL0_PC2_NDIV_INT_MASK);
 		tmp |= (bcm5357_bcm43236_ndiv[spuravoid]) << BCMA_CC_PMU1_PLL0_PC2_NDIV_INT_SHIFT;
-		bcma_cc_write32(cc, BCMA_CC_PLLCTL_DATA, tmp);
+		bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_DATA, tmp);
 
 		tmp = BCMA_CC_PMU_CTL_PLL_UPD;
 		break;
diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
index ec013fb..c279211 100644
--- a/drivers/net/wireless/broadcom/b43/main.c
+++ b/drivers/net/wireless/broadcom/b43/main.c
@@ -1215,10 +1215,10 @@ void b43_wireless_core_phy_pll_reset(struct b43_wldev *dev)
 	case B43_BUS_BCMA:
 		bcma_cc = &dev->dev->bdev->bus->drv_cc;
 
-		bcma_cc_write32(bcma_cc, BCMA_CC_CHIPCTL_ADDR, 0);
-		bcma_cc_mask32(bcma_cc, BCMA_CC_CHIPCTL_DATA, ~0x4);
-		bcma_cc_set32(bcma_cc, BCMA_CC_CHIPCTL_DATA, 0x4);
-		bcma_cc_mask32(bcma_cc, BCMA_CC_CHIPCTL_DATA, ~0x4);
+		bcma_cc_write32(bcma_cc, BCMA_CC_PMU_CHIPCTL_ADDR, 0);
+		bcma_cc_mask32(bcma_cc, BCMA_CC_PMU_CHIPCTL_DATA, ~0x4);
+		bcma_cc_set32(bcma_cc, BCMA_CC_PMU_CHIPCTL_DATA, 0x4);
+		bcma_cc_mask32(bcma_cc, BCMA_CC_PMU_CHIPCTL_DATA, ~0x4);
 		break;
 #endif
 #ifdef CONFIG_B43_SSB
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index cf03843..3fde133 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -351,12 +351,12 @@
 #define BCMA_CC_PMU_RES_REQTS		0x0640 /* PMU res req timer sel */
 #define BCMA_CC_PMU_RES_REQT		0x0644 /* PMU res req timer */
 #define BCMA_CC_PMU_RES_REQM		0x0648 /* PMU res req mask */
-#define BCMA_CC_CHIPCTL_ADDR		0x0650
-#define BCMA_CC_CHIPCTL_DATA		0x0654
-#define BCMA_CC_REGCTL_ADDR		0x0658
-#define BCMA_CC_REGCTL_DATA		0x065C
-#define BCMA_CC_PLLCTL_ADDR		0x0660
-#define BCMA_CC_PLLCTL_DATA		0x0664
+#define BCMA_CC_PMU_CHIPCTL_ADDR	0x0650
+#define BCMA_CC_PMU_CHIPCTL_DATA	0x0654
+#define BCMA_CC_PMU_REGCTL_ADDR		0x0658
+#define BCMA_CC_PMU_REGCTL_DATA		0x065C
+#define BCMA_CC_PMU_PLLCTL_ADDR		0x0660
+#define BCMA_CC_PMU_PLLCTL_DATA		0x0664
 #define BCMA_CC_PMU_STRAPOPT		0x0668 /* (corerev >= 28) */
 #define BCMA_CC_PMU_XTAL_FREQ		0x066C /* (pmurev >= 10) */
 #define  BCMA_CC_PMU_XTAL_FREQ_ILPCTL_MASK	0x00001FFF
-- 
1.8.4.5

