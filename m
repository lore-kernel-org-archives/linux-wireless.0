Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2432 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab1ECJgS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 35/61] staging: brcm80211: remove unused functions from
 hndpmu.c
Date: Tue, 3 May 2011 11:35:35 +0200
Message-ID: <1304415361-7813-36-git-send-email-arend@broadcom.com> (sfid-20110503_113819_313981_ABD2BE66)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The source file contained several functions that are not being
used in the brcmsmac and/or brcmfmac driver. These functions have
been removed.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/include/hndpmu.h |   19 +--
 drivers/staging/brcm80211/util/hndpmu.c    |  383 ----------------------------
 2 files changed, 2 insertions(+), 400 deletions(-)

diff --git a/drivers/staging/brcm80211/include/hndpmu.h b/drivers/staging/brcm80211/include/hndpmu.h
index b2b2095..56a7311 100644
--- a/drivers/staging/brcm80211/include/hndpmu.h
+++ b/drivers/staging/brcm80211/include/hndpmu.h
@@ -33,35 +33,20 @@ extern void si_pmu_chip_init(si_t *sih);
 extern void si_pmu_pll_init(si_t *sih, u32 xtalfreq);
 extern void si_pmu_res_init(si_t *sih);
 extern void si_pmu_swreg_init(si_t *sih);
-
-extern u32 si_pmu_force_ilp(si_t *sih, bool force);
-
-extern u32 si_pmu_si_clock(si_t *sih);
-extern u32 si_pmu_cpu_clock(si_t *sih);
-extern u32 si_pmu_mem_clock(si_t *sih);
 extern u32 si_pmu_alp_clock(si_t *sih);
-extern u32 si_pmu_ilp_clock(si_t *sih);
-
-extern void si_pmu_set_switcher_voltage(si_t *sih,
-					u8 bb_voltage, u8 rf_voltage);
 extern void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage);
 extern u16 si_pmu_fast_pwrup_delay(si_t *sih);
-extern void si_pmu_rcal(si_t *sih);
 extern void si_pmu_pllupd(si_t *sih);
 extern void si_pmu_spuravoid(si_t *sih, u8 spuravoid);
-
 extern bool si_pmu_is_otp_powered(si_t *sih);
 extern u32 si_pmu_measure_alpclk(si_t *sih);
-
 extern u32 si_pmu_chipcontrol(si_t *sih, uint reg, u32 mask, u32 val);
 extern u32 si_pmu_regcontrol(si_t *sih, uint reg, u32 mask, u32 val);
 extern u32 si_pmu_pllcontrol(si_t *sih, uint reg, u32 mask, u32 val);
 extern void si_pmu_sprom_enable(si_t *sih, bool enable);
-
-extern void si_pmu_radio_enable(si_t *sih, bool enable);
-extern u32 si_pmu_waitforclk_on_backplane(si_t *sih, u32 clk, u32 delay);
-
 extern void si_pmu_otp_power(si_t *sih, bool on);
+
 extern void si_sdiod_drive_strength_init(si_t *sih, u32 drivestrength);
+extern u32 si_pmu_ilp_clock(si_t *sih);
 
 #endif				/* _hndpmu_h_ */
diff --git a/drivers/staging/brcm80211/util/hndpmu.c b/drivers/staging/brcm80211/util/hndpmu.c
index 2518b63..ffa2e2d 100644
--- a/drivers/staging/brcm80211/util/hndpmu.c
+++ b/drivers/staging/brcm80211/util/hndpmu.c
@@ -45,7 +45,6 @@
 
 /* PLL controls/clocks */
 static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal);
-static u32 si_pmu1_cpuclk0(si_t *sih, chipcregs_t *cc);
 static u32 si_pmu1_alpclk0(si_t *sih, chipcregs_t *cc);
 
 /* PMU resources */
@@ -101,26 +100,6 @@ void si_pmu_pllupd(si_t *sih)
 		   PCTL_PLL_PLLCTL_UPD, PCTL_PLL_PLLCTL_UPD);
 }
 
-/* Setup switcher voltage */
-void si_pmu_set_switcher_voltage(si_t *sih, u8 bb_voltage, u8 rf_voltage)
-{
-	chipcregs_t *cc;
-	uint origidx;
-
-	/* Remember original core before switch to chipc */
-	origidx = si_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
-
-	W_REG(&cc->regcontrol_addr, 0x01);
-	W_REG(&cc->regcontrol_data, (u32) (bb_voltage & 0x1f) << 22);
-
-	W_REG(&cc->regcontrol_addr, 0x00);
-	W_REG(&cc->regcontrol_data, (u32) (rf_voltage & 0x1f) << 14);
-
-	/* Return to original core */
-	si_setcoreidx(sih, origidx);
-}
-
 void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage)
 {
 	u8 sr_cntl_shift = 0, rc_shift = 0, shift = 0, mask = 0;
@@ -249,30 +228,6 @@ u16 si_pmu_fast_pwrup_delay(si_t *sih)
 	return (u16) delay;
 }
 
-u32 si_pmu_force_ilp(si_t *sih, bool force)
-{
-	chipcregs_t *cc;
-	uint origidx;
-	u32 oldpmucontrol;
-
-	/* Remember original core before switch to chipc */
-	origidx = si_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
-
-	oldpmucontrol = R_REG(&cc->pmucontrol);
-	if (force)
-		W_REG(&cc->pmucontrol, oldpmucontrol &
-		      ~(PCTL_HT_REQ_EN | PCTL_ALP_REQ_EN));
-	else
-		W_REG(&cc->pmucontrol, oldpmucontrol |
-		      (PCTL_HT_REQ_EN | PCTL_ALP_REQ_EN));
-
-	/* Return to original core */
-	si_setcoreidx(sih, origidx);
-
-	return oldpmucontrol;
-}
-
 /* Setup resource up/down timers */
 typedef struct {
 	u8 resnum;
@@ -1415,22 +1370,6 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 	W_REG(&cc->pmucontrol, tmp);
 }
 
-/* query the CPU clock frequency */
-static u32
-si_pmu1_cpuclk0(si_t *sih, chipcregs_t *cc)
-{
-	u32 tmp, m1div;
-	u32 FVCO = si_pmu1_pllfvco0(sih);
-
-	/* Read m1div from pllcontrol[1] */
-	W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL1);
-	tmp = R_REG(&cc->pllcontrol_data);
-	m1div = (tmp & PMU1_PLL0_PC1_M1DIV_MASK) >> PMU1_PLL0_PC1_M1DIV_SHIFT;
-
-	/* Return ARM/SB clock */
-	return FVCO / m1div * 1000;
-}
-
 /* initialize PLL */
 void si_pmu_pll_init(si_t *sih, uint xtalfreq)
 {
@@ -1532,219 +1471,6 @@ u32 si_pmu_alp_clock(si_t *sih)
 	return clock;
 }
 
-/* Find the output of the "m" pll divider given pll controls that start with
- * pllreg "pll0" i.e. 12 for main 6 for phy, 0 for misc.
- */
-static u32
-si_pmu5_clock(si_t *sih, chipcregs_t *cc, uint pll0, uint m) {
-	u32 tmp, div, ndiv, p1, p2, fc;
-
-	if ((pll0 & 3) || (pll0 > PMU4716_MAINPLL_PLL0)) {
-		PMU_ERROR(("%s: Bad pll0: %d\n", __func__, pll0));
-		return 0;
-	}
-
-	/* Strictly there is an m5 divider, but I'm not sure we use it */
-	if ((m == 0) || (m > 4)) {
-		PMU_ERROR(("%s: Bad m divider: %d\n", __func__, m));
-		return 0;
-	}
-
-	if (sih->chip == BCM5357_CHIP_ID) {
-		/* Detect failure in clock setting */
-		if ((R_REG(&cc->chipstatus) & 0x40000) != 0)
-			return 133 * 1000000;
-	}
-
-	W_REG(&cc->pllcontrol_addr, pll0 + PMU5_PLL_P1P2_OFF);
-	(void)R_REG(&cc->pllcontrol_addr);
-	tmp = R_REG(&cc->pllcontrol_data);
-	p1 = (tmp & PMU5_PLL_P1_MASK) >> PMU5_PLL_P1_SHIFT;
-	p2 = (tmp & PMU5_PLL_P2_MASK) >> PMU5_PLL_P2_SHIFT;
-
-	W_REG(&cc->pllcontrol_addr, pll0 + PMU5_PLL_M14_OFF);
-	(void)R_REG(&cc->pllcontrol_addr);
-	tmp = R_REG(&cc->pllcontrol_data);
-	div = (tmp >> ((m - 1) * PMU5_PLL_MDIV_WIDTH)) & PMU5_PLL_MDIV_MASK;
-
-	W_REG(&cc->pllcontrol_addr, pll0 + PMU5_PLL_NM5_OFF);
-	(void)R_REG(&cc->pllcontrol_addr);
-	tmp = R_REG(&cc->pllcontrol_data);
-	ndiv = (tmp & PMU5_PLL_NDIV_MASK) >> PMU5_PLL_NDIV_SHIFT;
-
-	/* Do calculation in Mhz */
-	fc = si_pmu_alp_clock(sih) / 1000000;
-	fc = (p1 * ndiv * fc) / p2;
-
-	PMU_NONE(("%s: p1=%d, p2=%d, ndiv=%d(0x%x), m%d=%d; fc=%d, clock=%d\n",
-		  __func__, p1, p2, ndiv, ndiv, m, div, fc, fc / div));
-
-	/* Return clock in Hertz */
-	return (fc / div) * 1000000;
-}
-
-/* query backplane clock frequency */
-/* For designs that feed the same clock to both backplane
- * and CPU just return the CPU clock speed.
- */
-u32 si_pmu_si_clock(si_t *sih)
-{
-	chipcregs_t *cc;
-	uint origidx;
-	u32 clock = HT_CLOCK;
-#ifdef BCMDBG
-	char chn[8];
-#endif
-
-	/* Remember original core before switch to chipc */
-	origidx = si_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
-
-	switch (sih->chip) {
-	case BCM43224_CHIP_ID:
-	case BCM43225_CHIP_ID:
-	case BCM43421_CHIP_ID:
-	case BCM4331_CHIP_ID:
-	case BCM6362_CHIP_ID:
-		/* 96MHz backplane clock */
-		clock = 96000 * 1000;
-		break;
-	case BCM4716_CHIP_ID:
-	case BCM4748_CHIP_ID:
-	case BCM47162_CHIP_ID:
-		clock =
-		    si_pmu5_clock(sih, cc, PMU4716_MAINPLL_PLL0,
-				  PMU5_MAINPLL_SI);
-		break;
-	case BCM4329_CHIP_ID:
-		if (sih->chiprev == 0)
-			clock = 38400 * 1000;
-		else
-			clock = si_pmu1_cpuclk0(sih, cc);
-		break;
-	case BCM4319_CHIP_ID:
-	case BCM4336_CHIP_ID:
-	case BCM4330_CHIP_ID:
-		clock = si_pmu1_cpuclk0(sih, cc);
-		break;
-	case BCM4313_CHIP_ID:
-		/* 80MHz backplane clock */
-		clock = 80000 * 1000;
-		break;
-	case BCM43235_CHIP_ID:
-	case BCM43236_CHIP_ID:
-	case BCM43238_CHIP_ID:
-		clock =
-		    (cc->chipstatus & CST43236_BP_CLK) ? (120000 *
-							  1000) : (96000 *
-								   1000);
-		break;
-	case BCM5356_CHIP_ID:
-		clock =
-		    si_pmu5_clock(sih, cc, PMU5356_MAINPLL_PLL0,
-				  PMU5_MAINPLL_SI);
-		break;
-	case BCM5357_CHIP_ID:
-		clock =
-		    si_pmu5_clock(sih, cc, PMU5357_MAINPLL_PLL0,
-				  PMU5_MAINPLL_SI);
-		break;
-	default:
-		PMU_MSG(("No backplane clock specified "
-			 "for chip %s rev %d pmurev %d, using default %d Hz\n",
-			 bcm_chipname(sih->chip, chn, 8), sih->chiprev,
-			 sih->pmurev, clock));
-		break;
-	}
-
-	/* Return to original core */
-	si_setcoreidx(sih, origidx);
-	return clock;
-}
-
-/* query CPU clock frequency */
-u32 si_pmu_cpu_clock(si_t *sih)
-{
-	chipcregs_t *cc;
-	uint origidx;
-	u32 clock;
-
-	if ((sih->pmurev >= 5) &&
-	    !((sih->chip == BCM4329_CHIP_ID) ||
-	      (sih->chip == BCM4319_CHIP_ID) ||
-	      (sih->chip == BCM43236_CHIP_ID) ||
-	      (sih->chip == BCM4336_CHIP_ID) ||
-	      (sih->chip == BCM4330_CHIP_ID))) {
-		uint pll;
-
-		switch (sih->chip) {
-		case BCM5356_CHIP_ID:
-			pll = PMU5356_MAINPLL_PLL0;
-			break;
-		case BCM5357_CHIP_ID:
-			pll = PMU5357_MAINPLL_PLL0;
-			break;
-		default:
-			pll = PMU4716_MAINPLL_PLL0;
-			break;
-		}
-
-		/* Remember original core before switch to chipc */
-		origidx = si_coreidx(sih);
-		cc = si_setcoreidx(sih, SI_CC_IDX);
-
-		clock = si_pmu5_clock(sih, cc, pll, PMU5_MAINPLL_CPU);
-
-		/* Return to original core */
-		si_setcoreidx(sih, origidx);
-	} else
-		clock = si_pmu_si_clock(sih);
-
-	return clock;
-}
-
-/* query memory clock frequency */
-u32 si_pmu_mem_clock(si_t *sih)
-{
-	chipcregs_t *cc;
-	uint origidx;
-	u32 clock;
-
-	if ((sih->pmurev >= 5) &&
-	    !((sih->chip == BCM4329_CHIP_ID) ||
-	      (sih->chip == BCM4319_CHIP_ID) ||
-	      (sih->chip == BCM4330_CHIP_ID) ||
-	      (sih->chip == BCM4336_CHIP_ID) ||
-	      (sih->chip == BCM43236_CHIP_ID))) {
-		uint pll;
-
-		switch (sih->chip) {
-		case BCM5356_CHIP_ID:
-			pll = PMU5356_MAINPLL_PLL0;
-			break;
-		case BCM5357_CHIP_ID:
-			pll = PMU5357_MAINPLL_PLL0;
-			break;
-		default:
-			pll = PMU4716_MAINPLL_PLL0;
-			break;
-		}
-
-		/* Remember original core before switch to chipc */
-		origidx = si_coreidx(sih);
-		cc = si_setcoreidx(sih, SI_CC_IDX);
-
-		clock = si_pmu5_clock(sih, cc, pll, PMU5_MAINPLL_MEM);
-
-		/* Return to original core */
-		si_setcoreidx(sih, origidx);
-	} else {
-		clock = si_pmu_si_clock(sih);
-	}
-
-	return clock;
-}
-
 /* Measure ILP clock frequency */
 #define ILP_CALC_DUR	10	/* ms, make sure 1000 can be divided by it. */
 
@@ -2033,81 +1759,6 @@ void si_pmu_otp_power(si_t *sih, bool on)
 	si_setcoreidx(sih, origidx);
 }
 
-void si_pmu_rcal(si_t *sih)
-{
-	chipcregs_t *cc;
-	uint origidx;
-
-	/* Remember original core before switch to chipc */
-	origidx = si_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
-
-	switch (sih->chip) {
-	case BCM4329_CHIP_ID:{
-			u8 rcal_code;
-			u32 val;
-
-			/* Kick RCal */
-			W_REG(&cc->chipcontrol_addr, 1);
-
-			/* Power Down RCAL Block */
-			AND_REG(&cc->chipcontrol_data, ~0x04);
-
-			/* Power Up RCAL block */
-			OR_REG(&cc->chipcontrol_data, 0x04);
-
-			/* Wait for completion */
-			SPINWAIT(0 == (R_REG(&cc->chipstatus) & 0x08),
-				 10 * 1000 * 1000);
-
-			/* Drop the LSB to convert from 5 bit code to 4 bit code */
-			rcal_code =
-			    (u8) (R_REG(&cc->chipstatus) >> 5) & 0x0f;
-
-			PMU_MSG(("RCal completed, status 0x%x, code 0x%x\n",
-				 R_REG(&cc->chipstatus), rcal_code));
-
-			/* Write RCal code into pmu_vreg_ctrl[32:29] */
-			W_REG(&cc->regcontrol_addr, 0);
-			val =
-			    R_REG(&cc->regcontrol_data) & ~((u32) 0x07 << 29);
-			val |= (u32) (rcal_code & 0x07) << 29;
-			W_REG(&cc->regcontrol_data, val);
-			W_REG(&cc->regcontrol_addr, 1);
-			val = R_REG(&cc->regcontrol_data) & ~(u32) 0x01;
-			val |= (u32) ((rcal_code >> 3) & 0x01);
-			W_REG(&cc->regcontrol_data, val);
-
-			/* Write RCal code into pmu_chip_ctrl[33:30] */
-			W_REG(&cc->chipcontrol_addr, 0);
-			val =
-			    R_REG(&cc->chipcontrol_data) & ~((u32) 0x03 << 30);
-			val |= (u32) (rcal_code & 0x03) << 30;
-			W_REG(&cc->chipcontrol_data, val);
-			W_REG(&cc->chipcontrol_addr, 1);
-			val =
-			    R_REG(&cc->chipcontrol_data) & ~(u32) 0x03;
-			val |= (u32) ((rcal_code >> 2) & 0x03);
-			W_REG(&cc->chipcontrol_data, val);
-
-			/* Set override in pmu_chip_ctrl[29] */
-			W_REG(&cc->chipcontrol_addr, 0);
-			OR_REG(&cc->chipcontrol_data, (0x01 << 29));
-
-			/* Power off RCal block */
-			W_REG(&cc->chipcontrol_addr, 1);
-			AND_REG(&cc->chipcontrol_data, ~0x04);
-
-			break;
-		}
-	default:
-		break;
-	}
-
-	/* Return to original core */
-	si_setcoreidx(sih, origidx);
-}
-
 void si_pmu_spuravoid(si_t *sih, u8 spuravoid)
 {
 	chipcregs_t *cc;
@@ -2440,40 +2091,6 @@ void si_pmu_swreg_init(si_t *sih)
 	}
 }
 
-void si_pmu_radio_enable(si_t *sih, bool enable)
-{
-	switch (sih->chip) {
-	case BCM4319_CHIP_ID:
-		if (enable)
-			si_write_wrapperreg(sih, AI_OOBSELOUTB74,
-					    (u32) 0x868584);
-		else
-			si_write_wrapperreg(sih, AI_OOBSELOUTB74,
-					    (u32) 0x060584);
-		break;
-	}
-}
-
-/* Wait for a particular clock level to be on the backplane */
-u32
-si_pmu_waitforclk_on_backplane(si_t *sih, u32 clk, u32 delay)
-{
-	chipcregs_t *cc;
-	uint origidx;
-
-	/* Remember original core before switch to chipc */
-	origidx = si_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
-
-	if (delay)
-		SPINWAIT(((R_REG(&cc->pmustatus) & clk) != clk), delay);
-
-	/* Return to original core */
-	si_setcoreidx(sih, origidx);
-
-	return R_REG(&cc->pmustatus) & clk;
-}
-
 /*
  * Measures the ALP clock frequency in KHz.  Returns 0 if not possible.
  * Possible only if PMU rev >= 10 and there is an external LPO 32768Hz crystal.
-- 
1.7.4.1


