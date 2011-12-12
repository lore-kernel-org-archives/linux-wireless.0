Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3059 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab1LLXPv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:51 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/15] brcm80211: smac: use bcma core access functions
 in pmu.c
Date: Mon, 12 Dec 2011 15:15:02 -0800
Message-ID: <1323731713-14942-5-git-send-email-frankyl@broadcom.com> (sfid-20111213_001608_642283_1D6CDEC2)
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The code in pmu.c now uses the functions provided by BCMA to
access the core registers.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c |  153 ++++++++++++-------------
 1 files changed, 73 insertions(+), 80 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
index ba319f3..9a4d367 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
@@ -140,7 +140,7 @@ static void si_pmu_res_masks(struct si_pub *sih, u32 * pmin, u32 * pmax)
 }
 
 static void
-si_pmu_spuravoid_pllupdate(struct si_pub *sih, struct chipcregs __iomem *cc,
+si_pmu_spuravoid_pllupdate(struct si_pub *sih, struct bcma_device *core,
 			   u8 spuravoid)
 {
 	u32 tmp = 0;
@@ -149,58 +149,65 @@ si_pmu_spuravoid_pllupdate(struct si_pub *sih, struct chipcregs __iomem *cc,
 	case BCM43224_CHIP_ID:
 	case BCM43225_CHIP_ID:
 		if (spuravoid == 1) {
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
-			W_REG(&cc->pllcontrol_data, 0x11500010);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
-			W_REG(&cc->pllcontrol_data, 0x000C0C06);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
-			W_REG(&cc->pllcontrol_data, 0x0F600a08);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
-			W_REG(&cc->pllcontrol_data, 0x00000000);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
-			W_REG(&cc->pllcontrol_data, 0x2001E920);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
-			W_REG(&cc->pllcontrol_data, 0x88888815);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
+				     PMU1_PLL0_PLLCTL0);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
+				     0x11500010);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
+				     PMU1_PLL0_PLLCTL1);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
+				     0x000C0C06);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
+				     PMU1_PLL0_PLLCTL2);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
+				     0x0F600a08);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
+				     PMU1_PLL0_PLLCTL3);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
+				     0x00000000);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
+				     PMU1_PLL0_PLLCTL4);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
+				     0x2001E920);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
+				     PMU1_PLL0_PLLCTL5);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
+				     0x88888815);
 		} else {
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
-			W_REG(&cc->pllcontrol_data, 0x11100010);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
-			W_REG(&cc->pllcontrol_data, 0x000c0c06);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
-			W_REG(&cc->pllcontrol_data, 0x03000a08);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
-			W_REG(&cc->pllcontrol_data, 0x00000000);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
-			W_REG(&cc->pllcontrol_data, 0x200005c0);
-			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
-			W_REG(&cc->pllcontrol_data, 0x88888815);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
+				     PMU1_PLL0_PLLCTL0);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
+				     0x11100010);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
+				     PMU1_PLL0_PLLCTL1);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
+				     0x000c0c06);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
+				     PMU1_PLL0_PLLCTL2);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
+				     0x03000a08);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
+				     PMU1_PLL0_PLLCTL3);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
+				     0x00000000);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
+				     PMU1_PLL0_PLLCTL4);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
+				     0x200005c0);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_addr),
+				     PMU1_PLL0_PLLCTL5);
+			bcma_write32(core, CHIPCREGOFFS(pllcontrol_data),
+				     0x88888815);
 		}
 		tmp = 1 << 10;
 		break;
 
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL0);
-		W_REG(&cc->pllcontrol_data, 0x11100008);
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
-		W_REG(&cc->pllcontrol_data, 0x0c000c06);
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
-		W_REG(&cc->pllcontrol_data, 0x03000a08);
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
-		W_REG(&cc->pllcontrol_data, 0x00000000);
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
-		W_REG(&cc->pllcontrol_data, 0x200005c0);
-		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
-		W_REG(&cc->pllcontrol_data, 0x88888855);
-
-		tmp = 1 << 10;
-		break;
-
 	default:
 		/* bail out */
 		return;
 	}
 
-	tmp |= R_REG(&cc->pmucontrol);
-	W_REG(&cc->pmucontrol, tmp);
+	bcma_set32(core, CHIPCREGOFFS(pmucontrol), tmp);
 }
 
 u16 si_pmu_fast_pwrup_delay(struct si_pub *sih)
@@ -289,12 +296,12 @@ u32 si_pmu_alp_clock(struct si_pub *sih)
 
 void si_pmu_spuravoid(struct si_pub *sih, u8 spuravoid)
 {
-	struct chipcregs __iomem *cc;
+	struct bcma_device *cc;
 	uint origidx, intr_val;
 
-	/* Remember original core before switch to chipc */
-	cc = (struct chipcregs __iomem *)
-			ai_switch_core(sih, CC_CORE_ID, &origidx, &intr_val);
+	/* switch to chipc */
+	cc = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
+	ai_switch_core(sih, CC_CORE_ID, &origidx, &intr_val);
 
 	/* update the pll changes */
 	si_pmu_spuravoid_pllupdate(sih, cc, spuravoid);
@@ -306,20 +313,16 @@ void si_pmu_spuravoid(struct si_pub *sih, u8 spuravoid)
 /* initialize PMU */
 void si_pmu_init(struct si_pub *sih)
 {
-	struct chipcregs __iomem *cc;
-	uint origidx;
+	struct bcma_device *core;
 
-	/* Remember original core before switch to chipc */
-	origidx = ai_coreidx(sih);
-	cc = ai_setcoreidx(sih, SI_CC_IDX);
+	/* select chipc */
+	core = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
 
 	if (ai_get_pmurev(sih) == 1)
-		AND_REG(&cc->pmucontrol, ~PCTL_NOILP_ON_WAIT);
+		bcma_mask32(core, CHIPCREGOFFS(pmucontrol),
+			    ~PCTL_NOILP_ON_WAIT);
 	else if (ai_get_pmurev(sih) >= 2)
-		OR_REG(&cc->pmucontrol, PCTL_NOILP_ON_WAIT);
-
-	/* Return to original core */
-	ai_setcoreidx(sih, origidx);
+		bcma_set32(core, CHIPCREGOFFS(pmucontrol), PCTL_NOILP_ON_WAIT);
 }
 
 /* initialize PMU chip controls and other chip level stuff */
@@ -369,13 +372,11 @@ void si_pmu_pll_init(struct si_pub *sih, uint xtalfreq)
 /* initialize PMU resources */
 void si_pmu_res_init(struct si_pub *sih)
 {
-	struct chipcregs __iomem *cc;
-	uint origidx;
+	struct bcma_device *core;
 	u32 min_mask = 0, max_mask = 0;
 
-	/* Remember original core before switch to chipc */
-	origidx = ai_coreidx(sih);
-	cc = ai_setcoreidx(sih, SI_CC_IDX);
+	/* select to chipc */
+	core = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
 
 	/* Determine min/max rsrc masks */
 	si_pmu_res_masks(sih, &min_mask, &max_mask);
@@ -385,55 +386,50 @@ void si_pmu_res_init(struct si_pub *sih)
 	/* Program max resource mask */
 
 	if (max_mask)
-		W_REG(&cc->max_res_mask, max_mask);
+		bcma_write32(core, CHIPCREGOFFS(max_res_mask), max_mask);
 
 	/* Program min resource mask */
 
 	if (min_mask)
-		W_REG(&cc->min_res_mask, min_mask);
+		bcma_write32(core, CHIPCREGOFFS(min_res_mask), min_mask);
 
 	/* Add some delay; allow resources to come up and settle. */
 	mdelay(2);
-
-	/* Return to original core */
-	ai_setcoreidx(sih, origidx);
 }
 
 u32 si_pmu_measure_alpclk(struct si_pub *sih)
 {
-	struct chipcregs __iomem *cc;
-	uint origidx;
+	struct bcma_device *core;
 	u32 alp_khz;
 
 	if (ai_get_pmurev(sih) < 10)
 		return 0;
 
 	/* Remember original core before switch to chipc */
-	origidx = ai_coreidx(sih);
-	cc = ai_setcoreidx(sih, SI_CC_IDX);
+	core = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
 
-	if (R_REG(&cc->pmustatus) & PST_EXTLPOAVAIL) {
+	if (bcma_read32(core, CHIPCREGOFFS(pmustatus)) & PST_EXTLPOAVAIL) {
 		u32 ilp_ctr, alp_hz;
 
 		/*
 		 * Enable the reg to measure the freq,
 		 * in case it was disabled before
 		 */
-		W_REG(&cc->pmu_xtalfreq,
-		      1U << PMU_XTALFREQ_REG_MEASURE_SHIFT);
+		bcma_write32(core, CHIPCREGOFFS(pmu_xtalfreq),
+			    1U << PMU_XTALFREQ_REG_MEASURE_SHIFT);
 
 		/* Delay for well over 4 ILP clocks */
 		udelay(1000);
 
 		/* Read the latched number of ALP ticks per 4 ILP ticks */
-		ilp_ctr =
-		    R_REG(&cc->pmu_xtalfreq) & PMU_XTALFREQ_REG_ILPCTR_MASK;
+		ilp_ctr = bcma_read32(core, CHIPCREGOFFS(pmu_xtalfreq)) &
+			  PMU_XTALFREQ_REG_ILPCTR_MASK;
 
 		/*
 		 * Turn off the PMU_XTALFREQ_REG_MEASURE_SHIFT
 		 * bit to save power
 		 */
-		W_REG(&cc->pmu_xtalfreq, 0);
+		bcma_write32(core, CHIPCREGOFFS(pmu_xtalfreq), 0);
 
 		/* Calculate ALP frequency */
 		alp_hz = (ilp_ctr * EXT_ILP_HZ) / 4;
@@ -446,8 +442,5 @@ u32 si_pmu_measure_alpclk(struct si_pub *sih)
 	} else
 		alp_khz = 0;
 
-	/* Return to original core */
-	ai_setcoreidx(sih, origidx);
-
 	return alp_khz;
 }
-- 
1.7.5.4


