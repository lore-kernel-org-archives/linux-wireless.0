Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:36286 "EHLO
	mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086AbcASHpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2016 02:45:46 -0500
Received: by mail-lf0-f50.google.com with SMTP id h129so138499059lfh.3
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2016 23:45:45 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] bcma: support PMU present as separated bus core
Date: Tue, 19 Jan 2016 08:45:26 +0100
Message-Id: <1453189526-24689-2-git-send-email-zajec5@gmail.com> (sfid-20160119_084556_285510_B36A3922)
In-Reply-To: <1453189526-24689-1-git-send-email-zajec5@gmail.com>
References: <1453189526-24689-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On recent Broadcom chipsets PMU is present as separated core and it
can't be accessed using ChipCommon anymore as it fails with e.g.:
[    0.000577] Unhandled fault: external abort on non-linefetch (0x1008) at 0xf1000604

Solve it by using a new (PMU) core pointer set to ChipCommon or PMU
depending on the hardware capabilities.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_chipcommon.c            |  2 +-
 drivers/bcma/driver_chipcommon_pmu.c        | 94 ++++++++++++++++-------------
 include/linux/bcma/bcma_driver_chipcommon.h | 19 ++++++
 3 files changed, 72 insertions(+), 43 deletions(-)

diff --git a/drivers/bcma/driver_chipcommon.c b/drivers/bcma/driver_chipcommon.c
index b7c8a8d..36ee221 100644
--- a/drivers/bcma/driver_chipcommon.c
+++ b/drivers/bcma/driver_chipcommon.c
@@ -185,7 +185,7 @@ u32 bcma_chipco_watchdog_timer_set(struct bcma_drv_cc *cc, u32 ticks)
 			ticks = 2;
 		else if (ticks > maxt)
 			ticks = maxt;
-		bcma_cc_write32(cc, BCMA_CC_PMU_WATCHDOG, ticks);
+		bcma_pmu_write32(cc, BCMA_CC_PMU_WATCHDOG, ticks);
 	} else {
 		struct bcma_bus *bus = cc->core->bus;
 
diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
index 472f39d..f1eb4d3 100644
--- a/drivers/bcma/driver_chipcommon_pmu.c
+++ b/drivers/bcma/driver_chipcommon_pmu.c
@@ -15,44 +15,44 @@
 
 u32 bcma_chipco_pll_read(struct bcma_drv_cc *cc, u32 offset)
 {
-	bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR, offset);
-	bcma_cc_read32(cc, BCMA_CC_PMU_PLLCTL_ADDR);
-	return bcma_cc_read32(cc, BCMA_CC_PMU_PLLCTL_DATA);
+	bcma_pmu_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR, offset);
+	bcma_pmu_read32(cc, BCMA_CC_PMU_PLLCTL_ADDR);
+	return bcma_pmu_read32(cc, BCMA_CC_PMU_PLLCTL_DATA);
 }
 EXPORT_SYMBOL_GPL(bcma_chipco_pll_read);
 
 void bcma_chipco_pll_write(struct bcma_drv_cc *cc, u32 offset, u32 value)
 {
-	bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR, offset);
-	bcma_cc_read32(cc, BCMA_CC_PMU_PLLCTL_ADDR);
-	bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_DATA, value);
+	bcma_pmu_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR, offset);
+	bcma_pmu_read32(cc, BCMA_CC_PMU_PLLCTL_ADDR);
+	bcma_pmu_write32(cc, BCMA_CC_PMU_PLLCTL_DATA, value);
 }
 EXPORT_SYMBOL_GPL(bcma_chipco_pll_write);
 
 void bcma_chipco_pll_maskset(struct bcma_drv_cc *cc, u32 offset, u32 mask,
 			     u32 set)
 {
-	bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR, offset);
-	bcma_cc_read32(cc, BCMA_CC_PMU_PLLCTL_ADDR);
-	bcma_cc_maskset32(cc, BCMA_CC_PMU_PLLCTL_DATA, mask, set);
+	bcma_pmu_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR, offset);
+	bcma_pmu_read32(cc, BCMA_CC_PMU_PLLCTL_ADDR);
+	bcma_pmu_maskset32(cc, BCMA_CC_PMU_PLLCTL_DATA, mask, set);
 }
 EXPORT_SYMBOL_GPL(bcma_chipco_pll_maskset);
 
 void bcma_chipco_chipctl_maskset(struct bcma_drv_cc *cc,
 				 u32 offset, u32 mask, u32 set)
 {
-	bcma_cc_write32(cc, BCMA_CC_PMU_CHIPCTL_ADDR, offset);
-	bcma_cc_read32(cc, BCMA_CC_PMU_CHIPCTL_ADDR);
-	bcma_cc_maskset32(cc, BCMA_CC_PMU_CHIPCTL_DATA, mask, set);
+	bcma_pmu_write32(cc, BCMA_CC_PMU_CHIPCTL_ADDR, offset);
+	bcma_pmu_read32(cc, BCMA_CC_PMU_CHIPCTL_ADDR);
+	bcma_pmu_maskset32(cc, BCMA_CC_PMU_CHIPCTL_DATA, mask, set);
 }
 EXPORT_SYMBOL_GPL(bcma_chipco_chipctl_maskset);
 
 void bcma_chipco_regctl_maskset(struct bcma_drv_cc *cc, u32 offset, u32 mask,
 				u32 set)
 {
-	bcma_cc_write32(cc, BCMA_CC_PMU_REGCTL_ADDR, offset);
-	bcma_cc_read32(cc, BCMA_CC_PMU_REGCTL_ADDR);
-	bcma_cc_maskset32(cc, BCMA_CC_PMU_REGCTL_DATA, mask, set);
+	bcma_pmu_write32(cc, BCMA_CC_PMU_REGCTL_ADDR, offset);
+	bcma_pmu_read32(cc, BCMA_CC_PMU_REGCTL_ADDR);
+	bcma_pmu_maskset32(cc, BCMA_CC_PMU_REGCTL_DATA, mask, set);
 }
 EXPORT_SYMBOL_GPL(bcma_chipco_regctl_maskset);
 
@@ -60,18 +60,18 @@ static u32 bcma_pmu_xtalfreq(struct bcma_drv_cc *cc)
 {
 	u32 ilp_ctl, alp_hz;
 
-	if (!(bcma_cc_read32(cc, BCMA_CC_PMU_STAT) &
+	if (!(bcma_pmu_read32(cc, BCMA_CC_PMU_STAT) &
 	      BCMA_CC_PMU_STAT_EXT_LPO_AVAIL))
 		return 0;
 
-	bcma_cc_write32(cc, BCMA_CC_PMU_XTAL_FREQ,
-			BIT(BCMA_CC_PMU_XTAL_FREQ_MEASURE_SHIFT));
+	bcma_pmu_write32(cc, BCMA_CC_PMU_XTAL_FREQ,
+			 BIT(BCMA_CC_PMU_XTAL_FREQ_MEASURE_SHIFT));
 	usleep_range(1000, 2000);
 
-	ilp_ctl = bcma_cc_read32(cc, BCMA_CC_PMU_XTAL_FREQ);
+	ilp_ctl = bcma_pmu_read32(cc, BCMA_CC_PMU_XTAL_FREQ);
 	ilp_ctl &= BCMA_CC_PMU_XTAL_FREQ_ILPCTL_MASK;
 
-	bcma_cc_write32(cc, BCMA_CC_PMU_XTAL_FREQ, 0);
+	bcma_pmu_write32(cc, BCMA_CC_PMU_XTAL_FREQ, 0);
 
 	alp_hz = ilp_ctl * 32768 / 4;
 	return (alp_hz + 50000) / 100000 * 100;
@@ -127,8 +127,8 @@ static void bcma_pmu2_pll_init0(struct bcma_drv_cc *cc, u32 xtalfreq)
 		mask = (u32)~(BCMA_RES_4314_HT_AVAIL |
 			      BCMA_RES_4314_MACPHY_CLK_AVAIL);
 
-		bcma_cc_mask32(cc, BCMA_CC_PMU_MINRES_MSK, mask);
-		bcma_cc_mask32(cc, BCMA_CC_PMU_MAXRES_MSK, mask);
+		bcma_pmu_mask32(cc, BCMA_CC_PMU_MINRES_MSK, mask);
+		bcma_pmu_mask32(cc, BCMA_CC_PMU_MAXRES_MSK, mask);
 		bcma_wait_value(cc->core, BCMA_CLKCTLST,
 				BCMA_CLKCTLST_HAVEHT, 0, 20000);
 		break;
@@ -140,7 +140,7 @@ static void bcma_pmu2_pll_init0(struct bcma_drv_cc *cc, u32 xtalfreq)
 
 	/* Flush */
 	if (cc->pmu.rev >= 2)
-		bcma_cc_set32(cc, BCMA_CC_PMU_CTL, BCMA_CC_PMU_CTL_PLL_UPD);
+		bcma_pmu_set32(cc, BCMA_CC_PMU_CTL, BCMA_CC_PMU_CTL_PLL_UPD);
 
 	/* TODO: Do we need to update OTP? */
 }
@@ -195,9 +195,9 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc *cc)
 
 	/* Set the resource masks. */
 	if (min_msk)
-		bcma_cc_write32(cc, BCMA_CC_PMU_MINRES_MSK, min_msk);
+		bcma_pmu_write32(cc, BCMA_CC_PMU_MINRES_MSK, min_msk);
 	if (max_msk)
-		bcma_cc_write32(cc, BCMA_CC_PMU_MAXRES_MSK, max_msk);
+		bcma_pmu_write32(cc, BCMA_CC_PMU_MAXRES_MSK, max_msk);
 
 	/*
 	 * Add some delay; allow resources to come up and settle.
@@ -269,23 +269,33 @@ static void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
 
 void bcma_pmu_early_init(struct bcma_drv_cc *cc)
 {
+	struct bcma_bus *bus = cc->core->bus;
 	u32 pmucap;
 
-	pmucap = bcma_cc_read32(cc, BCMA_CC_PMU_CAP);
+	if (cc->core->id.rev >= 35 &&
+	    cc->capabilities_ext & BCMA_CC_CAP_EXT_AOB_PRESENT) {
+		cc->pmu.core = bcma_find_core(bus, BCMA_CORE_PMU);
+		if (!cc->pmu.core)
+			bcma_warn(bus, "Couldn't find expected PMU core");
+	}
+	if (!cc->pmu.core)
+		cc->pmu.core = cc->core;
+
+	pmucap = bcma_pmu_read32(cc, BCMA_CC_PMU_CAP);
 	cc->pmu.rev = (pmucap & BCMA_CC_PMU_CAP_REVISION);
 
-	bcma_debug(cc->core->bus, "Found rev %u PMU (capabilities 0x%08X)\n",
-		   cc->pmu.rev, pmucap);
+	bcma_debug(bus, "Found rev %u PMU (capabilities 0x%08X)\n", cc->pmu.rev,
+		   pmucap);
 }
 
 void bcma_pmu_init(struct bcma_drv_cc *cc)
 {
 	if (cc->pmu.rev == 1)
-		bcma_cc_mask32(cc, BCMA_CC_PMU_CTL,
-			      ~BCMA_CC_PMU_CTL_NOILPONW);
+		bcma_pmu_mask32(cc, BCMA_CC_PMU_CTL,
+				~BCMA_CC_PMU_CTL_NOILPONW);
 	else
-		bcma_cc_set32(cc, BCMA_CC_PMU_CTL,
-			     BCMA_CC_PMU_CTL_NOILPONW);
+		bcma_pmu_set32(cc, BCMA_CC_PMU_CTL,
+			       BCMA_CC_PMU_CTL_NOILPONW);
 
 	bcma_pmu_pll_init(cc);
 	bcma_pmu_resources_init(cc);
@@ -472,8 +482,8 @@ u32 bcma_pmu_get_cpu_clock(struct bcma_drv_cc *cc)
 static void bcma_pmu_spuravoid_pll_write(struct bcma_drv_cc *cc, u32 offset,
 					 u32 value)
 {
-	bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR, offset);
-	bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_DATA, value);
+	bcma_pmu_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR, offset);
+	bcma_pmu_write32(cc, BCMA_CC_PMU_PLLCTL_DATA, value);
 }
 
 void bcma_pmu_spuravoid_pllupdate(struct bcma_drv_cc *cc, int spuravoid)
@@ -497,20 +507,20 @@ void bcma_pmu_spuravoid_pllupdate(struct bcma_drv_cc *cc, int spuravoid)
 		       bus->chipinfo.id == BCMA_CHIP_ID_BCM53572) ? 6 : 0;
 
 		/* RMW only the P1 divider */
-		bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR,
+		bcma_pmu_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR,
 				BCMA_CC_PMU_PLL_CTL0 + phypll_offset);
-		tmp = bcma_cc_read32(cc, BCMA_CC_PMU_PLLCTL_DATA);
+		tmp = bcma_pmu_read32(cc, BCMA_CC_PMU_PLLCTL_DATA);
 		tmp &= (~(BCMA_CC_PMU1_PLL0_PC0_P1DIV_MASK));
 		tmp |= (bcm5357_bcm43236_p1div[spuravoid] << BCMA_CC_PMU1_PLL0_PC0_P1DIV_SHIFT);
-		bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_DATA, tmp);
+		bcma_pmu_write32(cc, BCMA_CC_PMU_PLLCTL_DATA, tmp);
 
 		/* RMW only the int feedback divider */
-		bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR,
+		bcma_pmu_write32(cc, BCMA_CC_PMU_PLLCTL_ADDR,
 				BCMA_CC_PMU_PLL_CTL2 + phypll_offset);
-		tmp = bcma_cc_read32(cc, BCMA_CC_PMU_PLLCTL_DATA);
+		tmp = bcma_pmu_read32(cc, BCMA_CC_PMU_PLLCTL_DATA);
 		tmp &= ~(BCMA_CC_PMU1_PLL0_PC2_NDIV_INT_MASK);
 		tmp |= (bcm5357_bcm43236_ndiv[spuravoid]) << BCMA_CC_PMU1_PLL0_PC2_NDIV_INT_SHIFT;
-		bcma_cc_write32(cc, BCMA_CC_PMU_PLLCTL_DATA, tmp);
+		bcma_pmu_write32(cc, BCMA_CC_PMU_PLLCTL_DATA, tmp);
 
 		tmp = BCMA_CC_PMU_CTL_PLL_UPD;
 		break;
@@ -646,7 +656,7 @@ void bcma_pmu_spuravoid_pllupdate(struct bcma_drv_cc *cc, int spuravoid)
 		break;
 	}
 
-	tmp |= bcma_cc_read32(cc, BCMA_CC_PMU_CTL);
-	bcma_cc_write32(cc, BCMA_CC_PMU_CTL, tmp);
+	tmp |= bcma_pmu_read32(cc, BCMA_CC_PMU_CTL);
+	bcma_pmu_write32(cc, BCMA_CC_PMU_CTL, tmp);
 }
 EXPORT_SYMBOL_GPL(bcma_pmu_spuravoid_pllupdate);
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index 3fde133..f078ee6 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -217,6 +217,11 @@
 #define	 BCMA_CC_CLKDIV_JTAG_SHIFT	8
 #define	 BCMA_CC_CLKDIV_UART		0x000000FF
 #define BCMA_CC_CAP_EXT			0x00AC		/* Capabilities */
+#define  BCMA_CC_CAP_EXT_SECI_PRESENT	0x00000001
+#define  BCMA_CC_CAP_EXT_GSIO_PRESENT	0x00000002
+#define  BCMA_CC_CAP_EXT_GCI_PRESENT	0x00000004
+#define  BCMA_CC_CAP_EXT_SECI_PUART_PRESENT		0x00000008    /* UART present */
+#define  BCMA_CC_CAP_EXT_AOB_PRESENT	0x00000040
 #define BCMA_CC_PLLONDELAY		0x00B0		/* Rev >= 4 only */
 #define BCMA_CC_FREFSELDELAY		0x00B4		/* Rev >= 4 only */
 #define BCMA_CC_SLOWCLKCTL		0x00B8		/* 6 <= Rev <= 9 only */
@@ -566,6 +571,7 @@
  * Check availability with ((struct bcma_chipcommon)->capabilities & BCMA_CC_CAP_PMU)
  */
 struct bcma_chipcommon_pmu {
+	struct bcma_device *core;	/* Can be separated core or just ChipCommon one */
 	u8 rev;			/* PMU revision */
 	u32 crystalfreq;	/* The active crystal frequency (in kHz) */
 };
@@ -662,6 +668,19 @@ struct bcma_drv_cc_b {
 #define bcma_cc_maskset32(cc, offset, mask, set) \
 	bcma_cc_write32(cc, offset, (bcma_cc_read32(cc, offset) & (mask)) | (set))
 
+/* PMU registers access */
+#define bcma_pmu_read32(cc, offset) \
+	bcma_read32((cc)->pmu.core, offset)
+#define bcma_pmu_write32(cc, offset, val) \
+	bcma_write32((cc)->pmu.core, offset, val)
+
+#define bcma_pmu_mask32(cc, offset, mask) \
+	bcma_pmu_write32(cc, offset, bcma_pmu_read32(cc, offset) & (mask))
+#define bcma_pmu_set32(cc, offset, set) \
+	bcma_pmu_write32(cc, offset, bcma_pmu_read32(cc, offset) | (set))
+#define bcma_pmu_maskset32(cc, offset, mask, set) \
+	bcma_pmu_write32(cc, offset, (bcma_pmu_read32(cc, offset) & (mask)) | (set))
+
 extern u32 bcma_chipco_watchdog_timer_set(struct bcma_drv_cc *cc, u32 ticks);
 
 extern u32 bcma_chipco_get_alp_clock(struct bcma_drv_cc *cc);
-- 
1.8.4.5

