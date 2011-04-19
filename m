Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4485 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753232Ab1DSJB1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 05:01:27 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] staging: brcm80211: removed ASSERTs from wlc_pmu.c
Date: Tue, 19 Apr 2011 11:01:13 +0200
Message-ID: <1303203676-20165-3-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303203676-20165-1-git-send-email-rvossen@broadcom.com>
References: <1303203676-20165-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c |   50 +-------------------------
 1 files changed, 1 insertions(+), 49 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index dacc5ca..d4b941c 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -884,7 +884,6 @@ static const pmu1_xtaltab0_t *si_pmu1_xtaldef0(si_t *sih)
 	default:
 		break;
 	}
-	ASSERT(0);
 	return NULL;
 }
 
@@ -906,7 +905,6 @@ static const pmu1_xtaltab0_t *si_pmu1_xtaltab0(si_t *sih)
 	default:
 		break;
 	}
-	ASSERT(0);
 	return NULL;
 }
 
@@ -926,7 +924,6 @@ si_pmu1_alpclk0(si_t *sih, chipcregs_t *cc)
 	/* Could not find it so assign a default value */
 	if (xt == NULL || xt->fref == 0)
 		xt = si_pmu1_xtaldef0(sih);
-	ASSERT(xt != NULL && xt->fref != 0);
 
 	return xt->fref * 1000;
 }
@@ -949,7 +946,6 @@ static u32 si_pmu1_pllfvco0(si_t *sih)
 	default:
 		break;
 	}
-	ASSERT(0);
 	return 0;
 }
 
@@ -1031,7 +1027,6 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 			  PMURES_BIT(RES4329_HT_AVAIL)));
 		SPINWAIT(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL,
 			 PMU_MAX_TRANSITION_DLY);
-		ASSERT(!(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL));
 		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
 		if (xt->fref == 38400)
 			tmp = 0x200024C0;
@@ -1076,7 +1071,6 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 		udelay(100);
 		SPINWAIT(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL,
 			 PMU_MAX_TRANSITION_DLY);
-		ASSERT(!(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL));
 		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL4);
 		tmp = 0x200005c0;
 		W_REG(&cc->pllcontrol_data, tmp);
@@ -1092,7 +1086,6 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 		udelay(100);
 		SPINWAIT(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL,
 			 PMU_MAX_TRANSITION_DLY);
-		ASSERT(!(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL));
 		break;
 
 	case BCM4330_CHIP_ID:
@@ -1105,11 +1098,10 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 		udelay(100);
 		SPINWAIT(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL,
 			 PMU_MAX_TRANSITION_DLY);
-		ASSERT(!(R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL));
 		break;
 
 	default:
-		ASSERT(0);
+		break;
 	}
 
 	/* Write p1div and p2div to pllcontrol[0] */
@@ -1222,7 +1214,6 @@ u32 si_pmu_ilp_clock(si_t *sih)
 		u32 start, end, delta;
 		u32 origidx = ai_coreidx(sih);
 		chipcregs_t *cc = ai_setcoreidx(sih, SI_CC_IDX);
-		ASSERT(cc != NULL);
 		start = R_REG(&cc->pmutimer);
 		mdelay(ILP_CALC_DUR);
 		end = R_REG(&cc->pmutimer);
@@ -1239,8 +1230,6 @@ void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage)
 	u8 sr_cntl_shift = 0, rc_shift = 0, shift = 0, mask = 0;
 	u8 addr = 0;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	switch (sih->chip) {
 	case BCM4336_CHIP_ID:
 		switch (ldo) {
@@ -1260,7 +1249,6 @@ void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage)
 			mask = 0xf;
 			break;
 		default:
-			ASSERT(false);
 			return;
 		}
 		break;
@@ -1272,12 +1260,10 @@ void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage)
 			mask = 0x1f;
 			break;
 		default:
-			ASSERT(false);
 			break;
 		}
 		break;
 	default:
-		ASSERT(false);
 		return;
 	}
 
@@ -1299,12 +1285,9 @@ u16 si_pmu_fast_pwrup_delay(si_t *sih)
 	chn[0] = 0;		/* to suppress compile error */
 #endif
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
 	cc = ai_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	switch (sih->chip) {
 	case BCM43224_CHIP_ID:
@@ -1374,7 +1357,6 @@ void si_pmu_sprom_enable(si_t *sih, bool enable)
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
 	cc = ai_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	/* Return to original core */
 	ai_setcoreidx(sih, origidx);
@@ -1425,12 +1407,9 @@ u32 si_pmu_alp_clock(si_t *sih)
 	if (!PMUCTL_ENAB(sih))
 		return clock;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
 	cc = ai_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	switch (sih->chip) {
 	case BCM43224_CHIP_ID:
@@ -1478,7 +1457,6 @@ void si_pmu_spuravoid(si_t *sih, u8 spuravoid)
 	/* Remember original core before switch to chipc */
 	cc = (chipcregs_t *) ai_switch_core(sih, CC_CORE_ID, &origidx,
 					    &intr_val);
-	ASSERT(cc != NULL);
 
 	/* force the HT off  */
 	if (sih->chip == BCM4336_CHIP_ID) {
@@ -1488,7 +1466,6 @@ void si_pmu_spuravoid(si_t *sih, u8 spuravoid)
 		/* wait for the ht to really go away */
 		SPINWAIT(((R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL) == 0),
 			 10000);
-		ASSERT((R_REG(&cc->clk_ctl_st) & CCS_HTAVAIL) == 0);
 	}
 
 	/* update the pll changes */
@@ -1511,12 +1488,9 @@ void si_pmu_init(si_t *sih)
 	chipcregs_t *cc;
 	uint origidx;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
 	cc = ai_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	if (sih->pmurev == 1)
 		AND_REG(&cc->pmucontrol, ~PCTL_NOILP_ON_WAIT);
@@ -1541,8 +1515,6 @@ void si_pmu_chip_init(si_t *sih)
 {
 	uint origidx;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Gate off SPROM clock and chip select signals */
 	si_pmu_sprom_enable(sih, false);
 
@@ -1556,8 +1528,6 @@ void si_pmu_chip_init(si_t *sih)
 /* initialize PMU switch/regulators */
 void si_pmu_swreg_init(si_t *sih)
 {
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	switch (sih->chip) {
 	case BCM4336_CHIP_ID:
 		/* Reduce CLDO PWM output voltage to 1.2V */
@@ -1586,12 +1556,9 @@ void si_pmu_pll_init(si_t *sih, uint xtalfreq)
 	chipcregs_t *cc;
 	uint origidx;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
 	cc = ai_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -1636,12 +1603,9 @@ void si_pmu_res_init(si_t *sih)
 	char name[8], *val;
 	uint i, rsrcs;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
 	cc = ai_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -1715,7 +1679,6 @@ void si_pmu_res_init(si_t *sih)
 
 	/* Program up/down timers */
 	while (pmu_res_updown_table_sz--) {
-		ASSERT(pmu_res_updown_table != NULL);
 		W_REG(&cc->res_table_sel,
 		      pmu_res_updown_table[pmu_res_updown_table_sz].resnum);
 		W_REG(&cc->res_updn_timer,
@@ -1734,7 +1697,6 @@ void si_pmu_res_init(si_t *sih)
 
 	/* Program resource dependencies table */
 	while (pmu_res_depend_table_sz--) {
-		ASSERT(pmu_res_depend_table != NULL);
 		if (pmu_res_depend_table[pmu_res_depend_table_sz].filter != NULL
 		    && !(pmu_res_depend_table[pmu_res_depend_table_sz].
 			 filter) (sih))
@@ -1762,7 +1724,6 @@ void si_pmu_res_init(si_t *sih)
 					[pmu_res_depend_table_sz].depend_mask);
 				break;
 			default:
-				ASSERT(0);
 				break;
 			}
 		}
@@ -1811,12 +1772,9 @@ u32 si_pmu_measure_alpclk(si_t *sih)
 	if (sih->pmurev < 10)
 		return 0;
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
 	cc = ai_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	if (R_REG(&cc->pmustatus) & PST_EXTLPOAVAIL) {
 		u32 ilp_ctr, alp_hz;
@@ -1858,7 +1816,6 @@ bool si_pmu_is_otp_powered(si_t *sih)
 	/* Remember original core before switch to chipc */
 	idx = ai_coreidx(sih);
 	cc = ai_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -1906,8 +1863,6 @@ void si_pmu_otp_power(si_t *sih, bool on)
 	uint origidx;
 	u32 rsrcs = 0;	/* rsrcs to turn on/off OTP power */
 
-	ASSERT(sih->cccaps & CC_CAP_PMU);
-
 	/* Don't do anything if OTP is disabled */
 	if (ai_is_otp_disabled(sih))
 		return;
@@ -1915,7 +1870,6 @@ void si_pmu_otp_power(si_t *sih, bool on)
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
 	cc = ai_setcoreidx(sih, SI_CC_IDX);
-	ASSERT(cc != NULL);
 
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -1947,14 +1901,12 @@ void si_pmu_otp_power(si_t *sih, bool on)
 			OR_REG(&cc->min_res_mask, (rsrcs | deps));
 			SPINWAIT(!(R_REG(&cc->res_state) & rsrcs),
 				 PMU_MAX_TRANSITION_DLY);
-			ASSERT(R_REG(&cc->res_state) & rsrcs);
 		} else {
 			AND_REG(&cc->min_res_mask, ~(rsrcs | deps));
 		}
 
 		SPINWAIT((((otps = R_REG(&cc->otpstatus)) & OTPS_READY) !=
 			  (on ? OTPS_READY : 0)), 100);
-		ASSERT((otps & OTPS_READY) == (on ? OTPS_READY : 0));
 	}
 
 	/* Return to original core */
-- 
1.7.1


