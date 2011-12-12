Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3077 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667Ab1LLXPq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:46 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 05/15] brcm80211: smac: use bcma core access functions
 in aiutils.c
Date: Mon, 12 Dec 2011 15:15:03 -0800
Message-ID: <1323731713-14942-6-git-send-email-frankyl@broadcom.com> (sfid-20111213_001558_094868_D4474BB4)
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The code in aiutils.c now uses the BCMA function for control the
registers in the device cores.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |  190 ++++++++-------------
 1 files changed, 70 insertions(+), 120 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index bb12ebc..7e5d41b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -558,28 +558,26 @@ static bool ai_buscore_prep(struct si_info *sii)
 }
 
 static bool
-ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
+ai_buscore_setup(struct si_info *sii, struct bcma_device *cc)
 {
 	bool pci, pcie;
 	uint i;
 	uint pciidx, pcieidx, pcirev, pcierev;
-	struct chipcregs __iomem *cc;
-
-	cc = ai_setcoreidx(&sii->pub, SI_CC_IDX);
 
 	/* get chipcommon rev */
-	sii->pub.ccrev = (int)ai_corerev(&sii->pub);
+	sii->pub.ccrev = cc->id.rev;
 
 	/* get chipcommon chipstatus */
 	if (ai_get_ccrev(&sii->pub) >= 11)
-		sii->chipst = R_REG(&cc->chipstatus);
+		sii->chipst = bcma_read32(cc, CHIPCREGOFFS(chipstatus));
 
 	/* get chipcommon capabilites */
-	sii->pub.cccaps = R_REG(&cc->capabilities);
+	sii->pub.cccaps = bcma_read32(cc, CHIPCREGOFFS(capabilities));
 
 	/* get pmu rev and caps */
 	if (ai_get_cccaps(&sii->pub) & CC_CAP_PMU) {
-		sii->pub.pmucaps = R_REG(&cc->pmucapabilities);
+		sii->pub.pmucaps = bcma_read32(cc,
+					       CHIPCREGOFFS(pmucapabilities));
 		sii->pub.pmurev = sii->pub.pmucaps & PCAP_REV_MASK;
 	}
 
@@ -608,11 +606,6 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 			pcierev = crev;
 			pcie = true;
 		}
-
-		/* find the core idx before entering this func. */
-		if ((savewin && (savewin == sii->coresba[i])) ||
-		    (cc == sii->regs[i]))
-			*origidx = i;
 	}
 
 	if (pci && pcie) {
@@ -642,9 +635,6 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 		return false;
 	}
 
-	/* return to the original core */
-	ai_setcoreidx(&sii->pub, *origidx);
-
 	return true;
 }
 
@@ -668,9 +658,8 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	void __iomem *regs = pbus->mmio;
 	struct si_pub *sih = &sii->pub;
 	u32 w, savewin;
-	struct chipcregs __iomem *cc;
+	struct bcma_device *cc;
 	uint socitype;
-	uint origidx;
 
 	memset((unsigned char *) sii, 0, sizeof(struct si_info));
 
@@ -683,10 +672,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	sii->curwrap = sii->curmap + SI_CORE_SIZE;
 
 	/* switch to Chipcommon core */
-	bcma_read32(pbus->drv_cc.core, 0);
-	savewin = SI_ENUM_BASE;
-
-	cc = (struct chipcregs __iomem *) regs;
+	cc = pbus->drv_cc.core;
 
 	/* bus/core/clk setup for register access */
 	if (!ai_buscore_prep(sii))
@@ -699,7 +685,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	 *   hosts w/o chipcommon), some way of recognizing them needs to
 	 *   be added here.
 	 */
-	w = R_REG(&cc->chipid);
+	w = bcma_read32(cc, CHIPCREGOFFS(chipid));
 	socitype = (w & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
 	/* Might as wll fill in chip id rev & pkg */
 	sih->chip = w & CID_ID_MASK;
@@ -720,8 +706,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 		return NULL;
 
 	/* bus/core/clk setup */
-	origidx = SI_CC_IDX;
-	if (!ai_buscore_setup(sii, savewin, &origidx))
+	if (!ai_buscore_setup(sii, cc))
 		goto exit;
 
 	/* Init nvram from sprom/otp if they exist */
@@ -731,10 +716,8 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	ai_nvram_process(sii);
 
 	/* === NVRAM, clock is ready === */
-	cc = (struct chipcregs __iomem *) ai_setcore(sih, CC_CORE_ID, 0);
-	W_REG(&cc->gpiopullup, 0);
-	W_REG(&cc->gpiopulldown, 0);
-	ai_setcoreidx(sih, origidx);
+	bcma_write32(cc, CHIPCREGOFFS(gpiopullup), 0);
+	bcma_write32(cc, CHIPCREGOFFS(gpiopulldown), 0);
 
 	/* PMU specific initializations */
 	if (ai_get_cccaps(sih) & CC_CAP_PMU) {
@@ -990,11 +973,12 @@ uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val)
 }
 
 /* return the slow clock source - LPO, XTAL, or PCI */
-static uint ai_slowclk_src(struct si_info *sii)
+static uint ai_slowclk_src(struct si_pub *sih, struct bcma_device *cc)
 {
-	struct chipcregs __iomem *cc;
+	struct si_info *sii;
 	u32 val;
 
+	sii = (struct si_info *)sih;
 	if (ai_get_ccrev(&sii->pub) < 6) {
 		pci_read_config_dword(sii->pcibus, PCI_GPIO_OUT,
 				      &val);
@@ -1002,9 +986,8 @@ static uint ai_slowclk_src(struct si_info *sii)
 			return SCC_SS_PCI;
 		return SCC_SS_XTAL;
 	} else if (ai_get_ccrev(&sii->pub) < 10) {
-		cc = (struct chipcregs __iomem *)
-			ai_setcoreidx(&sii->pub, sii->curidx);
-		return R_REG(&cc->slow_clk_ctl) & SCC_SS_MASK;
+		return bcma_read32(cc, CHIPCREGOFFS(slow_clk_ctl)) &
+		       SCC_SS_MASK;
 	} else			/* Insta-clock */
 		return SCC_SS_XTAL;
 }
@@ -1013,24 +996,24 @@ static uint ai_slowclk_src(struct si_info *sii)
 * return the ILP (slowclock) min or max frequency
 * precondition: we've established the chip has dynamic clk control
 */
-static uint ai_slowclk_freq(struct si_info *sii, bool max_freq,
-			    struct chipcregs __iomem *cc)
+static uint ai_slowclk_freq(struct si_pub *sih, bool max_freq,
+			    struct bcma_device *cc)
 {
 	u32 slowclk;
 	uint div;
 
-	slowclk = ai_slowclk_src(sii);
-	if (ai_get_ccrev(&sii->pub) < 6) {
+	slowclk = ai_slowclk_src(sih, cc);
+	if (ai_get_ccrev(sih) < 6) {
 		if (slowclk == SCC_SS_PCI)
 			return max_freq ? (PCIMAXFREQ / 64)
 				: (PCIMINFREQ / 64);
 		else
 			return max_freq ? (XTALMAXFREQ / 32)
 				: (XTALMINFREQ / 32);
-	} else if (ai_get_ccrev(&sii->pub) < 10) {
+	} else if (ai_get_ccrev(sih) < 10) {
 		div = 4 *
-		    (((R_REG(&cc->slow_clk_ctl) & SCC_CD_MASK) >>
-		      SCC_CD_SHIFT) + 1);
+		    (((bcma_read32(cc, CHIPCREGOFFS(slow_clk_ctl)) &
+		      SCC_CD_MASK) >> SCC_CD_SHIFT) + 1);
 		if (slowclk == SCC_SS_LPO)
 			return max_freq ? LPOMAXFREQ : LPOMINFREQ;
 		else if (slowclk == SCC_SS_XTAL)
@@ -1041,15 +1024,15 @@ static uint ai_slowclk_freq(struct si_info *sii, bool max_freq,
 				: (PCIMINFREQ / div);
 	} else {
 		/* Chipc rev 10 is InstaClock */
-		div = R_REG(&cc->system_clk_ctl) >> SYCC_CD_SHIFT;
-		div = 4 * (div + 1);
+		div = bcma_read32(cc, CHIPCREGOFFS(system_clk_ctl));
+		div = 4 * ((div >> SYCC_CD_SHIFT) + 1);
 		return max_freq ? XTALMAXFREQ : (XTALMINFREQ / div);
 	}
 	return 0;
 }
 
 static void
-ai_clkctl_setdelay(struct si_info *sii, struct chipcregs __iomem *cc)
+ai_clkctl_setdelay(struct si_pub *sih, struct bcma_device *cc)
 {
 	uint slowmaxfreq, pll_delay, slowclk;
 	uint pll_on_delay, fref_sel_delay;
@@ -1062,47 +1045,40 @@ ai_clkctl_setdelay(struct si_info *sii, struct chipcregs __iomem *cc)
 	 * powered down by dynamic clk control logic.
 	 */
 
-	slowclk = ai_slowclk_src(sii);
+	slowclk = ai_slowclk_src(sih, cc);
 	if (slowclk != SCC_SS_XTAL)
 		pll_delay += XTAL_ON_DELAY;
 
 	/* Starting with 4318 it is ILP that is used for the delays */
 	slowmaxfreq =
-	    ai_slowclk_freq(sii,
-			    (ai_get_ccrev(&sii->pub) >= 10) ? false : true, cc);
+	    ai_slowclk_freq(sih,
+			    (ai_get_ccrev(sih) >= 10) ? false : true, cc);
 
 	pll_on_delay = ((slowmaxfreq * pll_delay) + 999999) / 1000000;
 	fref_sel_delay = ((slowmaxfreq * FREF_DELAY) + 999999) / 1000000;
 
-	W_REG(&cc->pll_on_delay, pll_on_delay);
-	W_REG(&cc->fref_sel_delay, fref_sel_delay);
+	bcma_write32(cc, CHIPCREGOFFS(pll_on_delay), pll_on_delay);
+	bcma_write32(cc, CHIPCREGOFFS(fref_sel_delay), fref_sel_delay);
 }
 
 /* initialize power control delay registers */
 void ai_clkctl_init(struct si_pub *sih)
 {
-	struct si_info *sii;
-	uint origidx = 0;
-	struct chipcregs __iomem *cc;
+	struct bcma_device *cc;
 
 	if (!(ai_get_cccaps(sih) & CC_CAP_PWR_CTL))
 		return;
 
-	sii = (struct si_info *)sih;
-	origidx = sii->curidx;
-	cc = (struct chipcregs __iomem *)
-		ai_setcore(sih, CC_CORE_ID, 0);
+	cc = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
 	if (cc == NULL)
 		return;
 
 	/* set all Instaclk chip ILP to 1 MHz */
 	if (ai_get_ccrev(sih) >= 10)
-		SET_REG(&cc->system_clk_ctl, SYCC_CD_MASK,
-			(ILP_DIV_1MHZ << SYCC_CD_SHIFT));
-
-	ai_clkctl_setdelay(sii, cc);
+		bcma_maskset32(cc, CHIPCREGOFFS(system_clk_ctl), SYCC_CD_MASK,
+			       (ILP_DIV_1MHZ << SYCC_CD_SHIFT));
 
-	ai_setcoreidx(sih, origidx);
+	ai_clkctl_setdelay(sih, cc);
 }
 
 /*
@@ -1112,8 +1088,7 @@ void ai_clkctl_init(struct si_pub *sih)
 u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 {
 	struct si_info *sii;
-	uint origidx = 0;
-	struct chipcregs __iomem *cc;
+	struct bcma_device *cc;
 	uint slowminfreq;
 	u16 fpdelay;
 	uint intr_val = 0;
@@ -1130,19 +1105,17 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 		return 0;
 
 	fpdelay = 0;
-	origidx = sii->curidx;
 	INTR_OFF(sii, intr_val);
-	cc = (struct chipcregs __iomem *)
-		ai_setcore(sih, CC_CORE_ID, 0);
+	cc = ai_findcore(sih, CC_CORE_ID, 0);
 	if (cc == NULL)
 		goto done;
 
-	slowminfreq = ai_slowclk_freq(sii, false, cc);
-	fpdelay = (((R_REG(&cc->pll_on_delay) + 2) * 1000000) +
-		   (slowminfreq - 1)) / slowminfreq;
+
+	slowminfreq = ai_slowclk_freq(sih, false, cc);
+	fpdelay = (((bcma_read32(cc, CHIPCREGOFFS(pll_on_delay)) + 2) * 1000000)
+		   + (slowminfreq - 1)) / slowminfreq;
 
  done:
-	ai_setcoreidx(sih, origidx);
 	INTR_RESTORE(sii, intr_val);
 	return fpdelay;
 }
@@ -1213,8 +1186,7 @@ int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on)
 /* clk control mechanism through chipcommon, no policy checking */
 static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 {
-	uint origidx = 0;
-	struct chipcregs __iomem *cc;
+	struct bcma_device *cc;
 	u32 scc;
 	uint intr_val = 0;
 
@@ -1223,9 +1195,7 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 		return false;
 
 	INTR_OFF(sii, intr_val);
-	origidx = sii->curidx;
-	cc = (struct chipcregs __iomem *)
-				ai_setcore(&sii->pub, CC_CORE_ID, 0);
+	cc = ai_findcore(&sii->pub, BCMA_CORE_CHIPCOMMON, 0);
 
 	if (!(ai_get_cccaps(&sii->pub) & CC_CAP_PWR_CTL) &&
 	    (ai_get_ccrev(&sii->pub) < 20))
@@ -1239,19 +1209,19 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 			 * on before we clear SCC_DYN_XTAL..
 			 */
 			ai_clkctl_xtal(&sii->pub, XTAL, ON);
-			SET_REG(&cc->slow_clk_ctl,
-				(SCC_XC | SCC_FS | SCC_IP), SCC_IP);
+			bcma_maskset32(cc, CHIPCREGOFFS(slow_clk_ctl),
+				       (SCC_XC | SCC_FS | SCC_IP), SCC_IP);
 		} else if (ai_get_ccrev(&sii->pub) < 20) {
-			OR_REG(&cc->system_clk_ctl, SYCC_HR);
+			bcma_set32(cc, CHIPCREGOFFS(system_clk_ctl), SYCC_HR);
 		} else {
-			OR_REG(&cc->clk_ctl_st, CCS_FORCEHT);
+			bcma_set32(cc, CHIPCREGOFFS(clk_ctl_st), CCS_FORCEHT);
 		}
 
 		/* wait for the PLL */
 		if (ai_get_cccaps(&sii->pub) & CC_CAP_PMU) {
 			u32 htavail = CCS_HTAVAIL;
-			SPINWAIT(((R_REG(&cc->clk_ctl_st) & htavail)
-				  == 0), PMU_MAX_TRANSITION_DLY);
+			SPINWAIT(((bcma_read32(cc, CHIPCREGOFFS(clk_ctl_st)) &
+				   htavail) == 0), PMU_MAX_TRANSITION_DLY);
 		} else {
 			udelay(PLL_DELAY);
 		}
@@ -1259,11 +1229,11 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 
 	case CLK_DYNAMIC:	/* enable dynamic clock control */
 		if (ai_get_ccrev(&sii->pub) < 10) {
-			scc = R_REG(&cc->slow_clk_ctl);
+			scc = bcma_read32(cc, CHIPCREGOFFS(slow_clk_ctl));
 			scc &= ~(SCC_FS | SCC_IP | SCC_XC);
 			if ((scc & SCC_SS_MASK) != SCC_SS_XTAL)
 				scc |= SCC_XC;
-			W_REG(&cc->slow_clk_ctl, scc);
+			bcma_write32(cc, CHIPCREGOFFS(slow_clk_ctl), scc);
 
 			/*
 			 * for dynamic control, we have to
@@ -1273,9 +1243,9 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 				ai_clkctl_xtal(&sii->pub, XTAL, OFF);
 		} else if (ai_get_ccrev(&sii->pub) < 20) {
 			/* Instaclock */
-			AND_REG(&cc->system_clk_ctl, ~SYCC_HR);
+			bcma_mask32(cc, CHIPCREGOFFS(system_clk_ctl), ~SYCC_HR);
 		} else {
-			AND_REG(&cc->clk_ctl_st, ~CCS_FORCEHT);
+			bcma_mask32(cc, CHIPCREGOFFS(clk_ctl_st), ~CCS_FORCEHT);
 		}
 		break;
 
@@ -1284,7 +1254,6 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 	}
 
  done:
-	ai_setcoreidx(&sii->pub, origidx);
 	INTR_RESTORE(sii, intr_val);
 	return mode == CLK_FAST;
 }
@@ -1427,53 +1396,37 @@ u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val, u8 priority)
 
 void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
 {
-	struct si_info *sii;
-	struct chipcregs __iomem *cc;
-	uint origidx;
+	struct bcma_device *cc;
 	u32 val;
 
-	sii = (struct si_info *)sih;
-	origidx = ai_coreidx(sih);
-
-	cc = (struct chipcregs __iomem *) ai_setcore(sih, CC_CORE_ID, 0);
-
-	val = R_REG(&cc->chipcontrol);
+	cc = ai_findcore(sih, CC_CORE_ID, 0);
 
 	if (on) {
 		if (ai_get_chippkg(sih) == 9 || ai_get_chippkg(sih) == 0xb)
 			/* Ext PA Controls for 4331 12x9 Package */
-			W_REG(&cc->chipcontrol, val |
-			      CCTRL4331_EXTPA_EN |
-			      CCTRL4331_EXTPA_ON_GPIO2_5);
+			bcma_set32(cc, CHIPCREGOFFS(chipcontrol),
+				   CCTRL4331_EXTPA_EN |
+				   CCTRL4331_EXTPA_ON_GPIO2_5);
 		else
 			/* Ext PA Controls for 4331 12x12 Package */
-			W_REG(&cc->chipcontrol,
-			      val | CCTRL4331_EXTPA_EN);
+			bcma_set32(cc, CHIPCREGOFFS(chipcontrol),
+				   CCTRL4331_EXTPA_EN);
 	} else {
 		val &= ~(CCTRL4331_EXTPA_EN | CCTRL4331_EXTPA_ON_GPIO2_5);
-		W_REG(&cc->chipcontrol, val);
+		bcma_mask32(cc, CHIPCREGOFFS(chipcontrol),
+			    ~(CCTRL4331_EXTPA_EN | CCTRL4331_EXTPA_ON_GPIO2_5));
 	}
-
-	ai_setcoreidx(sih, origidx);
 }
 
 /* Enable BT-COEX & Ex-PA for 4313 */
 void ai_epa_4313war(struct si_pub *sih)
 {
-	struct si_info *sii;
-	struct chipcregs __iomem *cc;
-	uint origidx;
-
-	sii = (struct si_info *)sih;
-	origidx = ai_coreidx(sih);
+	struct bcma_device *cc;
 
-	cc = ai_setcore(sih, CC_CORE_ID, 0);
+	cc = ai_findcore(sih, CC_CORE_ID, 0);
 
 	/* EPA Fix */
-	W_REG(&cc->gpiocontrol,
-	      R_REG(&cc->gpiocontrol) | GPIO_CTRL_EPA_EN_MASK);
-
-	ai_setcoreidx(sih, origidx);
+	bcma_set32(cc, CHIPCREGOFFS(gpiocontrol), GPIO_CTRL_EPA_EN_MASK);
 }
 
 /* check if the device is removed */
@@ -1496,17 +1449,14 @@ bool ai_is_sprom_available(struct si_pub *sih)
 	struct si_info *sii = (struct si_info *)sih;
 
 	if (ai_get_ccrev(sih) >= 31) {
-		uint origidx;
-		struct chipcregs __iomem *cc;
+		struct bcma_device *cc;
 		u32 sromctrl;
 
 		if ((ai_get_cccaps(sih) & CC_CAP_SROM) == 0)
 			return false;
 
-		origidx = sii->curidx;
-		cc = ai_setcoreidx(sih, SI_CC_IDX);
-		sromctrl = R_REG(&cc->sromcontrol);
-		ai_setcoreidx(sih, origidx);
+		cc = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
+		sromctrl = bcma_read32(cc, CHIPCREGOFFS(sromcontrol));
 		return sromctrl & SRC_PRESENT;
 	}
 
-- 
1.7.5.4


