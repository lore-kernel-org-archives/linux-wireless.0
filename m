Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2303 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab1ECJhE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:37:04 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 45/61] staging: brcm80211: cleanup code in source file
 aiutils.c
Date: Tue, 3 May 2011 11:35:45 +0200
Message-ID: <1304415361-7813-46-git-send-email-arend@broadcom.com> (sfid-20110503_114019_865188_004CE403)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The aiutils functions that were taken from siutils have been renamed
with proper ai_ prefix. Calling functions have been updated accordingly.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |    6 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |   48 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.h      |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c       |   74 ++--
 drivers/staging/brcm80211/include/aiutils.h        |   88 ++--
 drivers/staging/brcm80211/util/aiutils.c           |  653 ++++++++------------
 drivers/staging/brcm80211/util/bcmotp.c            |   38 +-
 drivers/staging/brcm80211/util/bcmsrom.c           |   10 +-
 drivers/staging/brcm80211/util/hnddma.c            |   17 +-
 drivers/staging/brcm80211/util/nicpci.c            |   12 +-
 10 files changed, 399 insertions(+), 549 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
index 353b5e2..56e0ba1 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
@@ -14558,7 +14558,7 @@ void WLBANDINITFN(wlc_phy_init_nphy) (phy_info_t *pi)
 	if ((pi->nphy_gband_spurwar2_en) && CHSPEC_IS2G(pi->radio_chanspec) &&
 	    CHSPEC_IS40(pi->radio_chanspec)) {
 
-		regs = (d11regs_t *) si_switch_core(pi->sh->sih, D11_CORE_ID,
+		regs = (d11regs_t *) ai_switch_core(pi->sh->sih, D11_CORE_ID,
 						    &origidx, &intr_val);
 		d11_clk_ctl_st = R_REG(&regs->clk_ctl_st);
 		AND_REG(&regs->clk_ctl_st,
@@ -14566,7 +14566,7 @@ void WLBANDINITFN(wlc_phy_init_nphy) (phy_info_t *pi)
 
 		W_REG(&regs->clk_ctl_st, d11_clk_ctl_st);
 
-		si_restore_core(pi->sh->sih, origidx, intr_val);
+		ai_restore_core(pi->sh->sih, origidx, intr_val);
 	}
 
 	pi->use_int_tx_iqlo_cal_nphy =
@@ -19580,7 +19580,7 @@ void wlc_phy_antsel_init(wlc_phy_t *ppi, bool lut_init)
 		write_phy_reg(pi, 0xc8, 0x0);
 		write_phy_reg(pi, 0xc9, 0x0);
 
-		si_gpiocontrol(pi->sh->sih, mask, mask, GPIO_DRV_PRIORITY);
+		ai_gpiocontrol(pi->sh->sih, mask, mask, GPIO_DRV_PRIORITY);
 
 		mc = R_REG(&pi->regs->maccontrol);
 		mc &= ~MCTL_GPOUT_SEL_MASK;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index a646ab9..5217ead 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -647,7 +647,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	 * Also initialize software state that depends on the particular hardware
 	 * we are running.
 	 */
-	wlc_hw->sih = si_attach((uint) device, regsva, bustype, btparam,
+	wlc_hw->sih = ai_attach((uint) device, regsva, bustype, btparam,
 				&wlc_hw->vars, &wlc_hw->vars_size);
 	if (wlc_hw->sih == NULL) {
 		wiphy_err(wiphy, "wl%d: wlc_bmac_attach: si_attach failed\n",
@@ -698,7 +698,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc_hw->deviceid = device;
 
 	/* set bar0 window to point at D11 core */
-	wlc_hw->regs = (d11regs_t *) si_setcore(wlc_hw->sih, D11_CORE_ID, 0);
+	wlc_hw->regs = (d11regs_t *) ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
 	wlc_hw->corerev = ai_corerev(wlc_hw->sih);
 
 	regs = wlc_hw->regs;
@@ -712,7 +712,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	}
 
 	/* initialize power control registers */
-	si_clkctl_init(wlc_hw->sih);
+	ai_clkctl_init(wlc_hw->sih);
 
 	/* request fastclock and force fastclock for the rest of attach
 	 * bring the d11 core out of reset.
@@ -750,7 +750,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		wlc_bmac_pllreq(wlc_hw, true, WLC_PLLREQ_SHARED);
 
 	if ((wlc_hw->sih->bustype == PCI_BUS)
-	    && (si_pci_war16165(wlc_hw->sih)))
+	    && (ai_pci_war16165(wlc_hw->sih)))
 		wlc->war16165 = true;
 
 	/* check device id(srom, nvram etc.) to set bands */
@@ -909,10 +909,10 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 
 	/* Match driver "down" state */
 	if (wlc_hw->sih->bustype == PCI_BUS)
-		si_pci_down(wlc_hw->sih);
+		ai_pci_down(wlc_hw->sih);
 
 	/* register sb interrupt callback functions */
-	si_register_intr_callback(wlc_hw->sih, (void *)wlc_wlintrsoff,
+	ai_register_intr_callback(wlc_hw->sih, (void *)wlc_wlintrsoff,
 				  (void *)wlc_wlintrsrestore, NULL, wlc);
 
 	/* turn off pll and xtal to match driver "down" state */
@@ -997,10 +997,10 @@ int wlc_bmac_detach(struct wlc_info *wlc)
 		/* detach interrupt sync mechanism since interrupt is disabled and per-port
 		 * interrupt object may has been freed. this must be done before sb core switch
 		 */
-		si_deregister_intr_callback(wlc_hw->sih);
+		ai_deregister_intr_callback(wlc_hw->sih);
 
 		if (wlc_hw->sih->bustype == PCI_BUS)
-			si_pci_sleep(wlc_hw->sih);
+			ai_pci_sleep(wlc_hw->sih);
 	}
 
 	wlc_bmac_detach_dmapio(wlc_hw);
@@ -1025,7 +1025,7 @@ int wlc_bmac_detach(struct wlc_info *wlc)
 	wlc_hw->vars = NULL;
 
 	if (wlc_hw->sih) {
-		si_detach(wlc_hw->sih);
+		ai_detach(wlc_hw->sih);
 		wlc_hw->sih = NULL;
 	}
 
@@ -1112,7 +1112,7 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 	 * and force fastclock for the remainder of wlc_up().
 	 */
 	wlc_bmac_xtal(wlc_hw, ON);
-	si_clkctl_init(wlc_hw->sih);
+	ai_clkctl_init(wlc_hw->sih);
 	wlc_clkctl_clk(wlc_hw, CLK_FAST);
 
 	/*
@@ -1122,7 +1122,7 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 	coremask = (1 << wlc_hw->wlc->core->coreidx);
 
 	if (wlc_hw->sih->bustype == PCI_BUS)
-		si_pci_setup(wlc_hw->sih, coremask);
+		ai_pci_setup(wlc_hw->sih, coremask);
 
 	/*
 	 * Need to read the hwradio status here to cover the case where the system
@@ -1131,13 +1131,13 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 	if (wlc_bmac_radio_read_hwdisabled(wlc_hw)) {
 		/* put SB PCI in down state again */
 		if (wlc_hw->sih->bustype == PCI_BUS)
-			si_pci_down(wlc_hw->sih);
+			ai_pci_down(wlc_hw->sih);
 		wlc_bmac_xtal(wlc_hw, OFF);
 		return -ENOMEDIUM;
 	}
 
 	if (wlc_hw->sih->bustype == PCI_BUS)
-		si_pci_up(wlc_hw->sih);
+		ai_pci_up(wlc_hw->sih);
 
 	/* reset the d11 core */
 	wlc_bmac_corereset(wlc_hw, WLC_USE_COREFLAGS);
@@ -1222,7 +1222,7 @@ int wlc_bmac_down_finish(struct wlc_hw_info *wlc_hw)
 		/* turn off primary xtal and pll */
 		if (!wlc_hw->noreset) {
 			if (wlc_hw->sih->bustype == PCI_BUS)
-				si_pci_down(wlc_hw->sih);
+				ai_pci_down(wlc_hw->sih);
 			wlc_bmac_xtal(wlc_hw, OFF);
 		}
 	}
@@ -1295,7 +1295,7 @@ static void wlc_clkctl_clk(struct wlc_hw_info *wlc_hw, uint mode)
 		 * then use FCA to verify mac is running fast clock
 		 */
 
-		wlc_hw->forcefastclk = si_clkctl_cc(wlc_hw->sih, mode);
+		wlc_hw->forcefastclk = ai_clkctl_cc(wlc_hw->sih, mode);
 
 		/* check fast clock is available (if core is not in reset) */
 		if (wlc_hw->forcefastclk && wlc_hw->clk)
@@ -2042,7 +2042,7 @@ bool wlc_bmac_radio_read_hwdisabled(struct wlc_hw_info *wlc_hw)
 		    (wlc_hw->sih->chip == BCM43225_CHIP_ID) ||
 		    (wlc_hw->sih->chip == BCM43421_CHIP_ID))
 			wlc_hw->regs =
-			    (d11regs_t *) si_setcore(wlc_hw->sih, D11_CORE_ID,
+			    (d11regs_t *) ai_setcore(wlc_hw->sih, D11_CORE_ID,
 						     0);
 		ai_core_reset(wlc_hw->sih, flags, resetbits);
 		wlc_mctrl_reset(wlc_hw);
@@ -2073,18 +2073,18 @@ void wlc_bmac_hw_up(struct wlc_hw_info *wlc_hw)
 	 * and force fastclock for the remainder of wlc_up().
 	 */
 	wlc_bmac_xtal(wlc_hw, ON);
-	si_clkctl_init(wlc_hw->sih);
+	ai_clkctl_init(wlc_hw->sih);
 	wlc_clkctl_clk(wlc_hw, CLK_FAST);
 
 	if (wlc_hw->sih->bustype == PCI_BUS) {
-		si_pci_fixcfg(wlc_hw->sih);
+		ai_pci_fixcfg(wlc_hw->sih);
 
 		/* AI chip doesn't restore bar0win2 on hibernation/resume, need sw fixup */
 		if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
 		    (wlc_hw->sih->chip == BCM43225_CHIP_ID) ||
 		    (wlc_hw->sih->chip == BCM43421_CHIP_ID))
 			wlc_hw->regs =
-			    (d11regs_t *) si_setcore(wlc_hw->sih, D11_CORE_ID,
+			    (d11regs_t *) ai_setcore(wlc_hw->sih, D11_CORE_ID,
 						     0);
 	}
 
@@ -2099,7 +2099,7 @@ void wlc_bmac_hw_up(struct wlc_hw_info *wlc_hw)
 		if (!
 		    (wlc_hw->boardrev >= 0x1250
 		     && (wlc_hw->boardflags & BFL_FEM_BT)))
-			si_epa_4313war(wlc_hw->sih);
+			ai_epa_4313war(wlc_hw->sih);
 	}
 }
 
@@ -2390,7 +2390,7 @@ static void wlc_coreinit(struct wlc_info *wlc)
 	wlc_bmac_macphyclk_set(wlc_hw, ON);
 
 	/* program dynamic clock control fast powerup delay register */
-	wlc->fastpwrup_dly = si_clkctl_fast_pwrup_delay(wlc_hw->sih);
+	wlc->fastpwrup_dly = ai_clkctl_fast_pwrup_delay(wlc_hw->sih);
 	W_REG(&regs->scc_fastpwrup_dly, wlc->fastpwrup_dly);
 
 	/* tell the ucode the corerev */
@@ -2533,7 +2533,7 @@ static void wlc_gpio_init(struct wlc_info *wlc)
 		gm |= gc |= BOARD_GPIO_PACTRL;
 
 	/* apply to gpiocontrol register */
-	si_gpiocontrol(wlc_hw->sih, gm, gc, GPIO_DRV_PRIORITY);
+	ai_gpiocontrol(wlc_hw->sih, gm, gc, GPIO_DRV_PRIORITY);
 }
 
 static void wlc_ucode_download(struct wlc_hw_info *wlc_hw)
@@ -3426,7 +3426,7 @@ void wlc_coredisable(struct wlc_hw_info *wlc_hw)
 
 	/* remove gpio controls */
 	if (wlc_hw->ucode_dbgsel)
-		si_gpiocontrol(wlc_hw->sih, ~0, 0, GPIO_DRV_PRIORITY);
+		ai_gpiocontrol(wlc_hw->sih, ~0, 0, GPIO_DRV_PRIORITY);
 
 	wlc_hw->clk = false;
 	ai_core_disable(wlc_hw->sih, 0);
@@ -3443,7 +3443,7 @@ static void wlc_bmac_xtal(struct wlc_hw_info *wlc_hw, bool want)
 		return;
 
 	if (wlc_hw->sih)
-		si_clkctl_xtal(wlc_hw->sih, XTAL | PLL, want);
+		ai_clkctl_xtal(wlc_hw->sih, XTAL | PLL, want);
 
 	wlc_hw->sbclk = want;
 	if (!wlc_hw->sbclk) {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index 23130bb..56c0ae0 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -193,7 +193,7 @@ extern const u8 prio2fifo[];
 	((wlc->hw->clk) ?   \
 	((R_REG(&wlc->hw->regs->maccontrol) & \
 	(MCTL_PSM_JMP_0 | MCTL_IHR_EN)) != MCTL_IHR_EN) : \
-	(si_deviceremoved(wlc->hw->sih)))
+	(ai_deviceremoved(wlc->hw->sih)))
 
 #define WLCWLUNIT(wlc)		((wlc)->pub->unit)
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index 4b2095f..8fc644f 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -1213,20 +1213,20 @@ u32 si_pmu_ilp_clock(si_t *sih)
 {
 	static u32 ilpcycles_per_sec;
 
-	if (ISSIM_ENAB(sih))
+	if (ISSIM_ENAB(sih) || !PMUCTL_ENAB(sih))
 		return ILP_CLOCK;
 
 	if (ilpcycles_per_sec == 0) {
 		u32 start, end, delta;
 		u32 origidx = ai_coreidx(sih);
-		chipcregs_t *cc = si_setcoreidx(sih, SI_CC_IDX);
+		chipcregs_t *cc = ai_setcoreidx(sih, SI_CC_IDX);
 		ASSERT(cc != NULL);
 		start = R_REG(&cc->pmutimer);
 		mdelay(ILP_CALC_DUR);
 		end = R_REG(&cc->pmutimer);
 		delta = end - start;
 		ilpcycles_per_sec = delta * (1000 / ILP_CALC_DUR);
-		si_setcoreidx(sih, origidx);
+		ai_setcoreidx(sih, origidx);
 	}
 
 	return ilpcycles_per_sec;
@@ -1276,9 +1276,9 @@ void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage)
 
 	shift = sr_cntl_shift + rc_shift;
 
-	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, regcontrol_addr),
+	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, regcontrol_addr),
 		   ~0, addr);
-	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, regcontrol_data),
+	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, regcontrol_data),
 		   mask << shift, (voltage & mask) << shift);
 }
 
@@ -1294,7 +1294,7 @@ u16 si_pmu_fast_pwrup_delay(si_t *sih)
 
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
+	cc = ai_setcoreidx(sih, SI_CC_IDX);
 
 	switch (sih->chip) {
 	case BCM43224_CHIP_ID:
@@ -1312,7 +1312,7 @@ u16 si_pmu_fast_pwrup_delay(si_t *sih)
 		if (ISSIM_ENAB(sih))
 			delay = 70;
 		else {
-			u32 ilp = si_ilp_clock(sih);
+			u32 ilp = si_pmu_ilp_clock(sih);
 			delay =
 			    (si_pmu_res_uptime(sih, cc, RES4329_HT_AVAIL) +
 			     D11SCC_SLOW2FAST_TRANSITION) * ((1000000 + ilp -
@@ -1327,7 +1327,7 @@ u16 si_pmu_fast_pwrup_delay(si_t *sih)
 		if (ISSIM_ENAB(sih))
 			delay = 70;
 		else {
-			u32 ilp = si_ilp_clock(sih);
+			u32 ilp = si_pmu_ilp_clock(sih);
 			delay =
 			    (si_pmu_res_uptime(sih, cc, RES4336_HT_AVAIL) +
 			     D11SCC_SLOW2FAST_TRANSITION) * ((1000000 + ilp -
@@ -1339,7 +1339,7 @@ u16 si_pmu_fast_pwrup_delay(si_t *sih)
 		if (ISSIM_ENAB(sih))
 			delay = 70;
 		else {
-			u32 ilp = si_ilp_clock(sih);
+			u32 ilp = si_pmu_ilp_clock(sih);
 			delay =
 			    (si_pmu_res_uptime(sih, cc, RES4330_HT_AVAIL) +
 			     D11SCC_SLOW2FAST_TRANSITION) * ((1000000 + ilp -
@@ -1351,7 +1351,7 @@ u16 si_pmu_fast_pwrup_delay(si_t *sih)
 		break;
 	}
 	/* Return to original core */
-	si_setcoreidx(sih, origidx);
+	ai_setcoreidx(sih, origidx);
 
 	return (u16) delay;
 }
@@ -1363,43 +1363,43 @@ void si_pmu_sprom_enable(si_t *sih, bool enable)
 
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
+	cc = ai_setcoreidx(sih, SI_CC_IDX);
 
 	/* Return to original core */
-	si_setcoreidx(sih, origidx);
+	ai_setcoreidx(sih, origidx);
 }
 
 /* Read/write a chipcontrol reg */
 u32 si_pmu_chipcontrol(si_t *sih, uint reg, u32 mask, u32 val)
 {
-	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, chipcontrol_addr), ~0,
+	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, chipcontrol_addr), ~0,
 		   reg);
-	return si_corereg(sih, SI_CC_IDX,
+	return ai_corereg(sih, SI_CC_IDX,
 			  offsetof(chipcregs_t, chipcontrol_data), mask, val);
 }
 
 /* Read/write a regcontrol reg */
 u32 si_pmu_regcontrol(si_t *sih, uint reg, u32 mask, u32 val)
 {
-	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, regcontrol_addr), ~0,
+	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, regcontrol_addr), ~0,
 		   reg);
-	return si_corereg(sih, SI_CC_IDX,
+	return ai_corereg(sih, SI_CC_IDX,
 			  offsetof(chipcregs_t, regcontrol_data), mask, val);
 }
 
 /* Read/write a pllcontrol reg */
 u32 si_pmu_pllcontrol(si_t *sih, uint reg, u32 mask, u32 val)
 {
-	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, pllcontrol_addr), ~0,
+	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, pllcontrol_addr), ~0,
 		   reg);
-	return si_corereg(sih, SI_CC_IDX,
+	return ai_corereg(sih, SI_CC_IDX,
 			  offsetof(chipcregs_t, pllcontrol_data), mask, val);
 }
 
 /* PMU PLL update */
 void si_pmu_pllupd(si_t *sih)
 {
-	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, pmucontrol),
+	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, pmucontrol),
 		   PCTL_PLL_PLLCTL_UPD, PCTL_PLL_PLLCTL_UPD);
 }
 
@@ -1416,7 +1416,7 @@ u32 si_pmu_alp_clock(si_t *sih)
 
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
+	cc = ai_setcoreidx(sih, SI_CC_IDX);
 
 	switch (sih->chip) {
 	case BCM43224_CHIP_ID:
@@ -1451,7 +1451,7 @@ u32 si_pmu_alp_clock(si_t *sih)
 	}
 
 	/* Return to original core */
-	si_setcoreidx(sih, origidx);
+	ai_setcoreidx(sih, origidx);
 	return clock;
 }
 
@@ -1462,7 +1462,7 @@ void si_pmu_spuravoid(si_t *sih, u8 spuravoid)
 	u32 tmp = 0;
 
 	/* Remember original core before switch to chipc */
-	cc = (chipcregs_t *) si_switch_core(sih, CC_CORE_ID, &origidx,
+	cc = (chipcregs_t *) ai_switch_core(sih, CC_CORE_ID, &origidx,
 					    &intr_val);
 
 	/* force the HT off  */
@@ -1487,7 +1487,7 @@ void si_pmu_spuravoid(si_t *sih, u8 spuravoid)
 	}
 
 	/* Return to original core */
-	si_restore_core(sih, origidx, intr_val);
+	ai_restore_core(sih, origidx, intr_val);
 }
 
 /* initialize PMU */
@@ -1498,7 +1498,7 @@ void si_pmu_init(si_t *sih)
 
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
+	cc = ai_setcoreidx(sih, SI_CC_IDX);
 
 	if (sih->pmurev == 1)
 		AND_REG(&cc->pmucontrol, ~PCTL_NOILP_ON_WAIT);
@@ -1515,7 +1515,7 @@ void si_pmu_init(si_t *sih)
 	}
 
 	/* Return to original core */
-	si_setcoreidx(sih, origidx);
+	ai_setcoreidx(sih, origidx);
 }
 
 /* initialize PMU chip controls and other chip level stuff */
@@ -1531,7 +1531,7 @@ void si_pmu_chip_init(si_t *sih)
 	origidx = ai_coreidx(sih);
 
 	/* Return to original core */
-	si_setcoreidx(sih, origidx);
+	ai_setcoreidx(sih, origidx);
 }
 
 /* initialize PMU switch/regulators */
@@ -1569,7 +1569,7 @@ void si_pmu_pll_init(si_t *sih, uint xtalfreq)
 
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
+	cc = ai_setcoreidx(sih, SI_CC_IDX);
 
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -1598,7 +1598,7 @@ void si_pmu_pll_init(si_t *sih, uint xtalfreq)
 	}
 
 	/* Return to original core */
-	si_setcoreidx(sih, origidx);
+	ai_setcoreidx(sih, origidx);
 }
 
 /* initialize PMU resources */
@@ -1616,7 +1616,7 @@ void si_pmu_res_init(si_t *sih)
 
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
+	cc = ai_setcoreidx(sih, SI_CC_IDX);
 
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -1771,7 +1771,7 @@ void si_pmu_res_init(si_t *sih)
 	mdelay(2);
 
 	/* Return to original core */
-	si_setcoreidx(sih, origidx);
+	ai_setcoreidx(sih, origidx);
 }
 
 u32 si_pmu_measure_alpclk(si_t *sih)
@@ -1786,7 +1786,7 @@ u32 si_pmu_measure_alpclk(si_t *sih)
 
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
+	cc = ai_setcoreidx(sih, SI_CC_IDX);
 	ASSERT(cc != NULL);
 
 	if (R_REG(&cc->pmustatus) & PST_EXTLPOAVAIL) {
@@ -1824,7 +1824,7 @@ u32 si_pmu_measure_alpclk(si_t *sih)
 		alp_khz = 0;
 
 	/* Return to original core */
-	si_setcoreidx(sih, origidx);
+	ai_setcoreidx(sih, origidx);
 
 	return alp_khz;
 }
@@ -1837,7 +1837,7 @@ bool si_pmu_is_otp_powered(si_t *sih)
 
 	/* Remember original core before switch to chipc */
 	idx = ai_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
+	cc = ai_setcoreidx(sih, SI_CC_IDX);
 
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -1874,7 +1874,7 @@ bool si_pmu_is_otp_powered(si_t *sih)
 	}
 
 	/* Return to original core */
-	si_setcoreidx(sih, idx);
+	ai_setcoreidx(sih, idx);
 	return st;
 }
 
@@ -1886,12 +1886,12 @@ void si_pmu_otp_power(si_t *sih, bool on)
 	u32 rsrcs = 0;	/* rsrcs to turn on/off OTP power */
 
 	/* Don't do anything if OTP is disabled */
-	if (si_is_otp_disabled(sih))
+	if (ai_is_otp_disabled(sih))
 		return;
 
 	/* Remember original core before switch to chipc */
 	origidx = ai_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
+	cc = ai_setcoreidx(sih, SI_CC_IDX);
 
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -1932,5 +1932,5 @@ void si_pmu_otp_power(si_t *sih, bool on)
 	}
 
 	/* Return to original core */
-	si_setcoreidx(sih, origidx);
+	ai_setcoreidx(sih, origidx);
 }
diff --git a/drivers/staging/brcm80211/include/aiutils.h b/drivers/staging/brcm80211/include/aiutils.h
index c10d8f4..379bd51 100644
--- a/drivers/staging/brcm80211/include/aiutils.h
+++ b/drivers/staging/brcm80211/include/aiutils.h
@@ -477,72 +477,72 @@ extern u32 ai_addrspacesize(si_t *sih, uint asidx);
 extern void ai_write_wrap_reg(si_t *sih, u32 offset, u32 val);
 
 /* === exported functions === */
-extern si_t *si_attach(uint pcidev, void *regs, uint bustype,
+extern si_t *ai_attach(uint pcidev, void *regs, uint bustype,
 		       void *sdh, char **vars, uint *varsz);
 
-extern void si_detach(si_t *sih);
-extern bool si_pci_war16165(si_t *sih);
+extern void ai_detach(si_t *sih);
+extern bool ai_pci_war16165(si_t *sih);
 
-extern uint si_coreid(si_t *sih);
-extern uint si_corerev(si_t *sih);
-extern uint si_corereg(si_t *sih, uint coreidx, uint regoff, uint mask,
+extern uint ai_coreid(si_t *sih);
+extern uint ai_corerev(si_t *sih);
+extern uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask,
 		uint val);
-extern void si_write_wrapperreg(si_t *sih, u32 offset, u32 val);
-extern u32 si_core_cflags(si_t *sih, u32 mask, u32 val);
-extern u32 si_core_sflags(si_t *sih, u32 mask, u32 val);
-extern bool si_iscoreup(si_t *sih);
-extern uint si_findcoreidx(si_t *sih, uint coreid, uint coreunit);
-extern void *si_setcoreidx(si_t *sih, uint coreidx);
-extern void *si_setcore(si_t *sih, uint coreid, uint coreunit);
-extern void *si_switch_core(si_t *sih, uint coreid, uint *origidx,
+extern void ai_write_wrapperreg(si_t *sih, u32 offset, u32 val);
+extern u32 ai_core_cflags(si_t *sih, u32 mask, u32 val);
+extern u32 ai_core_sflags(si_t *sih, u32 mask, u32 val);
+extern bool ai_iscoreup(si_t *sih);
+extern uint ai_findcoreidx(si_t *sih, uint coreid, uint coreunit);
+extern void *ai_setcoreidx(si_t *sih, uint coreidx);
+extern void *ai_setcore(si_t *sih, uint coreid, uint coreunit);
+extern void *ai_switch_core(si_t *sih, uint coreid, uint *origidx,
 			    uint *intr_val);
-extern void si_restore_core(si_t *sih, uint coreid, uint intr_val);
-extern void si_core_reset(si_t *sih, u32 bits, u32 resetbits);
-extern void si_core_disable(si_t *sih, u32 bits);
-extern u32 si_alp_clock(si_t *sih);
-extern u32 si_ilp_clock(si_t *sih);
-extern void si_pci_setup(si_t *sih, uint coremask);
-extern void si_setint(si_t *sih, int siflag);
-extern bool si_backplane64(si_t *sih);
-extern void si_register_intr_callback(si_t *sih, void *intrsoff_fn,
+extern void ai_restore_core(si_t *sih, uint coreid, uint intr_val);
+extern void ai_core_reset(si_t *sih, u32 bits, u32 resetbits);
+extern void ai_core_disable(si_t *sih, u32 bits);
+extern u32 ai_alp_clock(si_t *sih);
+extern u32 ai_ilp_clock(si_t *sih);
+extern void ai_pci_setup(si_t *sih, uint coremask);
+extern void ai_setint(si_t *sih, int siflag);
+extern bool ai_backplane64(si_t *sih);
+extern void ai_register_intr_callback(si_t *sih, void *intrsoff_fn,
 				      void *intrsrestore_fn,
 				      void *intrsenabled_fn, void *intr_arg);
-extern void si_deregister_intr_callback(si_t *sih);
-extern void si_clkctl_init(si_t *sih);
-extern u16 si_clkctl_fast_pwrup_delay(si_t *sih);
-extern bool si_clkctl_cc(si_t *sih, uint mode);
-extern int si_clkctl_xtal(si_t *sih, uint what, bool on);
-extern bool si_deviceremoved(si_t *sih);
-extern u32 si_gpiocontrol(si_t *sih, u32 mask, u32 val,
+extern void ai_deregister_intr_callback(si_t *sih);
+extern void ai_clkctl_init(si_t *sih);
+extern u16 ai_clkctl_fast_pwrup_delay(si_t *sih);
+extern bool ai_clkctl_cc(si_t *sih, uint mode);
+extern int ai_clkctl_xtal(si_t *sih, uint what, bool on);
+extern bool ai_deviceremoved(si_t *sih);
+extern u32 ai_gpiocontrol(si_t *sih, u32 mask, u32 val,
 			     u8 priority);
 
 /* OTP status */
-extern bool si_is_otp_disabled(si_t *sih);
-extern bool si_is_otp_powered(si_t *sih);
-extern void si_otp_power(si_t *sih, bool on);
+extern bool ai_is_otp_disabled(si_t *sih);
+extern bool ai_is_otp_powered(si_t *sih);
+extern void ai_otp_power(si_t *sih, bool on);
 
 /* SPROM availability */
-extern bool si_is_sprom_available(si_t *sih);
+extern bool ai_is_sprom_available(si_t *sih);
 
 /*
  * Build device path. Path size must be >= SI_DEVPATH_BUFSZ.
  * The returned path is NULL terminated and has trailing '/'.
  * Return 0 on success, nonzero otherwise.
  */
-extern int si_devpath(si_t *sih, char *path, int size);
+extern int ai_devpath(si_t *sih, char *path, int size);
 /* Read variable with prepending the devpath to the name */
-extern char *si_getdevpathvar(si_t *sih, const char *name);
-extern int si_getdevpathintvar(si_t *sih, const char *name);
+extern char *ai_getdevpathvar(si_t *sih, const char *name);
+extern int ai_getdevpathintvar(si_t *sih, const char *name);
 
-extern void si_pci_sleep(si_t *sih);
-extern void si_pci_down(si_t *sih);
-extern void si_pci_up(si_t *sih);
-extern int si_pci_fixcfg(si_t *sih);
+extern void ai_pci_sleep(si_t *sih);
+extern void ai_pci_down(si_t *sih);
+extern void ai_pci_up(si_t *sih);
+extern int ai_pci_fixcfg(si_t *sih);
 
-extern void si_chipcontrl_epa4331(si_t *sih, bool on);
+extern void ai_chipcontrl_epa4331(si_t *sih, bool on);
 /* Enable Ex-PA for 4313 */
-extern void si_epa_4313war(si_t *sih);
+extern void ai_epa_4313war(si_t *sih);
 
-char *si_getnvramflvar(si_t *sih, const char *name);
+char *ai_getnvramflvar(si_t *sih, const char *name);
 
 #endif				/* _aiutils_h_ */
diff --git a/drivers/staging/brcm80211/util/aiutils.c b/drivers/staging/brcm80211/util/aiutils.c
index 57c5615..549a612 100644
--- a/drivers/staging/brcm80211/util/aiutils.c
+++ b/drivers/staging/brcm80211/util/aiutils.c
@@ -430,14 +430,6 @@ void ai_setint(si_t *sih, int siflag)
 {
 }
 
-void ai_write_wrap_reg(si_t *sih, u32 offset, u32 val)
-{
-	si_info_t *sii = SI_INFO(sih);
-	u32 *w = (u32 *) sii->curwrap;
-	W_REG(w + (offset / 4), val);
-	return;
-}
-
 uint ai_corevendor(si_t *sih)
 {
 	si_info_t *sii;
@@ -471,150 +463,6 @@ bool ai_iscoreup(si_t *sih)
 		&& ((R_REG(&ai->resetctrl) & AIRC_RESET) == 0));
 }
 
-/*
- * Switch to 'coreidx', issue a single arbitrary 32bit register mask&set operation,
- * switch back to the original core, and return the new value.
- *
- * When using the silicon backplane, no fiddling with interrupts or core switches is needed.
- *
- * Also, when using pci/pcie, we can optimize away the core switching for pci registers
- * and (on newer pci cores) chipcommon registers.
- */
-uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
-{
-	uint origidx = 0;
-	u32 *r = NULL;
-	uint w;
-	uint intr_val = 0;
-	bool fast = false;
-	si_info_t *sii;
-
-	sii = SI_INFO(sih);
-
-	if (coreidx >= SI_MAXCORES)
-		return 0;
-
-	if (sih->bustype == SI_BUS) {
-		/* If internal bus, we can always get at everything */
-		fast = true;
-		/* map if does not exist */
-		if (!sii->regs[coreidx]) {
-			sii->regs[coreidx] = REG_MAP(sii->coresba[coreidx],
-						     SI_CORE_SIZE);
-		}
-		r = (u32 *) ((unsigned char *) sii->regs[coreidx] + regoff);
-	} else if (sih->bustype == PCI_BUS) {
-		/* If pci/pcie, we can get at pci/pcie regs and on newer cores to chipc */
-
-		if ((sii->coreid[coreidx] == CC_CORE_ID) && SI_FAST(sii)) {
-			/* Chipc registers are mapped at 12KB */
-
-			fast = true;
-			r = (u32 *) ((char *)sii->curmap +
-					PCI_16KB0_CCREGS_OFFSET + regoff);
-		} else if (sii->pub.buscoreidx == coreidx) {
-			/* pci registers are at either in the last 2KB of an 8KB window
-			 * or, in pcie and pci rev 13 at 8KB
-			 */
-			fast = true;
-			if (SI_FAST(sii))
-				r = (u32 *) ((char *)sii->curmap +
-						PCI_16KB0_PCIREGS_OFFSET +
-						regoff);
-			else
-				r = (u32 *) ((char *)sii->curmap +
-						((regoff >= SBCONFIGOFF) ?
-						 PCI_BAR0_PCISBR_OFFSET :
-						 PCI_BAR0_PCIREGS_OFFSET) +
-						regoff);
-		}
-	}
-
-	if (!fast) {
-		INTR_OFF(sii, intr_val);
-
-		/* save current core index */
-		origidx = ai_coreidx(&sii->pub);
-
-		/* switch core */
-		r = (u32 *) ((unsigned char *) ai_setcoreidx(&sii->pub, coreidx) +
-				regoff);
-	}
-
-	/* mask and set */
-	if (mask || val) {
-		w = (R_REG(r) & ~mask) | val;
-		W_REG(r, w);
-	}
-
-	/* readback */
-	w = R_REG(r);
-
-	if (!fast) {
-		/* restore core index */
-		if (origidx != coreidx)
-			ai_setcoreidx(&sii->pub, origidx);
-
-		INTR_RESTORE(sii, intr_val);
-	}
-
-	return w;
-}
-
-void ai_core_disable(si_t *sih, u32 bits)
-{
-	si_info_t *sii;
-	volatile u32 dummy;
-	aidmp_t *ai;
-
-	sii = SI_INFO(sih);
-
-	ai = sii->curwrap;
-
-	/* if core is already in reset, just return */
-	if (R_REG(&ai->resetctrl) & AIRC_RESET)
-		return;
-
-	W_REG(&ai->ioctrl, bits);
-	dummy = R_REG(&ai->ioctrl);
-	udelay(10);
-
-	W_REG(&ai->resetctrl, AIRC_RESET);
-	udelay(1);
-}
-
-/* reset and re-enable a core
- * inputs:
- * bits - core specific bits that are set during and after reset sequence
- * resetbits - core specific bits that are set only during reset sequence
- */
-void ai_core_reset(si_t *sih, u32 bits, u32 resetbits)
-{
-	si_info_t *sii;
-	aidmp_t *ai;
-	volatile u32 dummy;
-
-	sii = SI_INFO(sih);
-	ai = sii->curwrap;
-
-	/*
-	 * Must do the disable sequence first to work for arbitrary current core state.
-	 */
-	ai_core_disable(sih, (bits | resetbits));
-
-	/*
-	 * Now do the initialization sequence.
-	 */
-	W_REG(&ai->ioctrl, (bits | SICF_FGC | SICF_CLOCK_EN));
-	dummy = R_REG(&ai->ioctrl);
-	W_REG(&ai->resetctrl, 0);
-	udelay(1);
-
-	W_REG(&ai->ioctrl, (bits | SICF_CLOCK_EN));
-	dummy = R_REG(&ai->ioctrl);
-	udelay(1);
-}
-
 void ai_core_cflags_wo(si_t *sih, u32 mask, u32 val)
 {
 	si_info_t *sii;
@@ -684,22 +532,22 @@ u32 ai_core_sflags(si_t *sih, u32 mask, u32 val)
 
 /* *************** from siutils.c ************** */
 /* local prototypes */
-static si_info_t *si_doattach(si_info_t *sii, uint devid, void *regs,
+static si_info_t *ai_doattach(si_info_t *sii, uint devid, void *regs,
 			      uint bustype, void *sdh, char **vars,
 			      uint *varsz);
-static bool si_buscore_prep(si_info_t *sii, uint bustype, uint devid,
+static bool ai_buscore_prep(si_info_t *sii, uint bustype, uint devid,
 			    void *sdh);
-static bool si_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
+static bool ai_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
 			     u32 savewin, uint *origidx, void *regs);
-static void si_nvram_process(si_info_t *sii, char *pvars);
+static void ai_nvram_process(si_info_t *sii, char *pvars);
 
 /* dev path concatenation util */
-static char *si_devpathvar(si_t *sih, char *var, int len, const char *name);
-static bool _si_clkctl_cc(si_info_t *sii, uint mode);
-static bool si_ispcie(si_info_t *sii);
+static char *ai_devpathvar(si_t *sih, char *var, int len, const char *name);
+static bool _ai_clkctl_cc(si_info_t *sii, uint mode);
+static bool ai_ispcie(si_info_t *sii);
 
 /* global variable to indicate reservation/release of gpio's */
-static u32 si_gpioreservation;
+static u32 ai_gpioreservation;
 
 /*
  * Allocate a si handle.
@@ -710,7 +558,7 @@ static u32 si_gpioreservation;
  * vars - pointer to a pointer area for "environment" variables
  * varsz - pointer to int to return the size of the vars
  */
-si_t *si_attach(uint devid, void *regs, uint bustype,
+si_t *ai_attach(uint devid, void *regs, uint bustype,
 		void *sdh, char **vars, uint *varsz)
 {
 	si_info_t *sii;
@@ -722,7 +570,7 @@ si_t *si_attach(uint devid, void *regs, uint bustype,
 		return NULL;
 	}
 
-	if (si_doattach(sii, devid, regs, bustype, sdh, vars, varsz) ==
+	if (ai_doattach(sii, devid, regs, bustype, sdh, vars, varsz) ==
 	    NULL) {
 		kfree(sii);
 		return NULL;
@@ -736,27 +584,27 @@ si_t *si_attach(uint devid, void *regs, uint bustype,
 /* global kernel resource */
 static si_info_t ksii;
 
-static bool si_buscore_prep(si_info_t *sii, uint bustype, uint devid,
+static bool ai_buscore_prep(si_info_t *sii, uint bustype, uint devid,
 			    void *sdh)
 {
 	/* kludge to enable the clock on the 4306 which lacks a slowclock */
-	if (bustype == PCI_BUS && !si_ispcie(sii))
-		si_clkctl_xtal(&sii->pub, XTAL | PLL, ON);
+	if (bustype == PCI_BUS && !ai_ispcie(sii))
+		ai_clkctl_xtal(&sii->pub, XTAL | PLL, ON);
 	return true;
 }
 
-static bool si_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
+static bool ai_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
 			     u32 savewin, uint *origidx, void *regs)
 {
 	bool pci, pcie;
 	uint i;
 	uint pciidx, pcieidx, pcirev, pcierev;
 
-	cc = si_setcoreidx(&sii->pub, SI_CC_IDX);
+	cc = ai_setcoreidx(&sii->pub, SI_CC_IDX);
 	ASSERT(cc);
 
 	/* get chipcommon rev */
-	sii->pub.ccrev = (int)si_corerev(&sii->pub);
+	sii->pub.ccrev = (int)ai_corerev(&sii->pub);
 
 	/* get chipcommon chipstatus */
 	if (sii->pub.ccrev >= 11)
@@ -787,9 +635,9 @@ static bool si_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
 	for (i = 0; i < sii->numcores; i++) {
 		uint cid, crev;
 
-		si_setcoreidx(&sii->pub, i);
-		cid = si_coreid(&sii->pub);
-		crev = si_corerev(&sii->pub);
+		ai_setcoreidx(&sii->pub, i);
+		cid = ai_coreid(&sii->pub);
+		crev = ai_corerev(&sii->pub);
 
 		/* Display cores found */
 		SI_VMSG(("CORE[%d]: id 0x%x rev %d base 0x%x regs 0x%p\n",
@@ -814,7 +662,7 @@ static bool si_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
 	}
 
 	if (pci && pcie) {
-		if (si_ispcie(sii))
+		if (ai_ispcie(sii))
 			pci = false;
 		else
 			pcie = false;
@@ -843,19 +691,19 @@ static bool si_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
 					return false;
 			}
 		}
-		if (si_pci_fixcfg(&sii->pub)) {
+		if (ai_pci_fixcfg(&sii->pub)) {
 			SI_ERROR(("si_doattach: si_pci_fixcfg failed\n"));
 			return false;
 		}
 	}
 
 	/* return to the original core */
-	si_setcoreidx(&sii->pub, *origidx);
+	ai_setcoreidx(&sii->pub, *origidx);
 
 	return true;
 }
 
-static __used void si_nvram_process(si_info_t *sii, char *pvars)
+static __used void ai_nvram_process(si_info_t *sii, char *pvars)
 {
 	uint w = 0;
 
@@ -865,14 +713,14 @@ static __used void si_nvram_process(si_info_t *sii, char *pvars)
 		/* do a pci config read to get subsystem id and subvendor id */
 		pci_read_config_dword(sii->pbus, PCI_SUBSYSTEM_VENDOR_ID, &w);
 		/* Let nvram variables override subsystem Vend/ID */
-		sii->pub.boardvendor = (u16)si_getdevpathintvar(&sii->pub,
+		sii->pub.boardvendor = (u16)ai_getdevpathintvar(&sii->pub,
 			"boardvendor");
 		if (sii->pub.boardvendor == 0)
 			sii->pub.boardvendor = w & 0xffff;
 		else
 			SI_ERROR(("Overriding boardvendor: 0x%x instead of "
 				  "0x%x\n", sii->pub.boardvendor, w & 0xffff));
-		sii->pub.boardtype = (u16)si_getdevpathintvar(&sii->pub,
+		sii->pub.boardtype = (u16)ai_getdevpathintvar(&sii->pub,
 			"boardtype");
 		if (sii->pub.boardtype == 0)
 			sii->pub.boardtype = (w >> 16) & 0xffff;
@@ -905,7 +753,7 @@ static __used void si_nvram_process(si_info_t *sii, char *pvars)
 	sii->pub.boardflags = getintvar(pvars, "boardflags");
 }
 
-static si_info_t *si_doattach(si_info_t *sii, uint devid,
+static si_info_t *ai_doattach(si_info_t *sii, uint devid,
 			      void *regs, uint bustype, void *pbus,
 			      char **vars, uint *varsz)
 {
@@ -952,7 +800,7 @@ static si_info_t *si_doattach(si_info_t *sii, uint devid,
 	sih->bustype = bustype;
 
 	/* bus/core/clk setup for register access */
-	if (!si_buscore_prep(sii, bustype, devid, pbus)) {
+	if (!ai_buscore_prep(sii, bustype, devid, pbus)) {
 		SI_ERROR(("si_doattach: si_core_clk_prep failed %d\n",
 			  bustype));
 		return NULL;
@@ -990,7 +838,7 @@ static si_info_t *si_doattach(si_info_t *sii, uint devid,
 	}
 	/* bus/core/clk setup */
 	origidx = SI_CC_IDX;
-	if (!si_buscore_setup(sii, cc, bustype, savewin, &origidx, regs)) {
+	if (!ai_buscore_setup(sii, cc, bustype, savewin, &origidx, regs)) {
 		SI_ERROR(("si_doattach: si_buscore_setup failed\n"));
 		goto exit;
 	}
@@ -1024,13 +872,13 @@ static si_info_t *si_doattach(si_info_t *sii, uint devid,
 		goto exit;
 	}
 	pvars = vars ? *vars : NULL;
-	si_nvram_process(sii, pvars);
+	ai_nvram_process(sii, pvars);
 
 	/* === NVRAM, clock is ready === */
-	cc = (chipcregs_t *) si_setcore(sih, CC_CORE_ID, 0);
+	cc = (chipcregs_t *) ai_setcore(sih, CC_CORE_ID, 0);
 	W_REG(&cc->gpiopullup, 0);
 	W_REG(&cc->gpiopulldown, 0);
-	si_setcoreidx(sih, origidx);
+	ai_setcoreidx(sih, origidx);
 
 	/* PMU specific initializations */
 	if (PMUCTL_ENAB(sih)) {
@@ -1050,7 +898,7 @@ static si_info_t *si_doattach(si_info_t *sii, uint devid,
 	w = getintvar(pvars, "leddc");
 	if (w == 0)
 		w = DEFAULT_GPIOTIMERVAL;
-	si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, gpiotimerval), ~0, w);
+	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, gpiotimerval), ~0, w);
 
 	if (PCIE(sii)) {
 		ASSERT(sii->pch != NULL);
@@ -1065,7 +913,7 @@ static si_info_t *si_doattach(si_info_t *sii, uint devid,
 		 */
 		if (sih->chiprev == 0) {
 			SI_MSG(("Applying 43224A0 WARs\n"));
-			si_corereg(sih, SI_CC_IDX,
+			ai_corereg(sih, SI_CC_IDX,
 				   offsetof(chipcregs_t, chipcontrol),
 				   CCTRL43224_GPIO_TOGGLE,
 				   CCTRL43224_GPIO_TOGGLE);
@@ -1091,7 +939,7 @@ static si_info_t *si_doattach(si_info_t *sii, uint devid,
 
 	if (sih->chip == BCM4331_CHIP_ID) {
 		/* Enable Ext PA lines depending on chip package option */
-		si_chipcontrl_epa4331(sih, true);
+		ai_chipcontrl_epa4331(sih, true);
 	}
 
 	return sii;
@@ -1106,7 +954,7 @@ static si_info_t *si_doattach(si_info_t *sii, uint devid,
 }
 
 /* may be called with core in reset */
-void si_detach(si_t *sih)
+void ai_detach(si_t *sih)
 {
 	si_info_t *sii;
 	uint idx;
@@ -1140,7 +988,7 @@ void si_detach(si_t *sih)
 
 /* register driver interrupt disabling and restoring callback functions */
 void
-si_register_intr_callback(si_t *sih, void *intrsoff_fn, void *intrsrestore_fn,
+ai_register_intr_callback(si_t *sih, void *intrsoff_fn, void *intrsrestore_fn,
 			  void *intrsenabled_fn, void *intr_arg)
 {
 	si_info_t *sii;
@@ -1156,7 +1004,7 @@ si_register_intr_callback(si_t *sih, void *intrsoff_fn, void *intrsrestore_fn,
 	sii->dev_coreid = sii->coreid[sii->curidx];
 }
 
-void si_deregister_intr_callback(si_t *sih)
+void ai_deregister_intr_callback(si_t *sih)
 {
 	si_info_t *sii;
 
@@ -1164,25 +1012,7 @@ void si_deregister_intr_callback(si_t *sih)
 	sii->intrsoff_fn = NULL;
 }
 
-uint si_flag(si_t *sih)
-{
-	if (sih->socitype == SOCI_AI)
-		return ai_flag(sih);
-	else {
-		ASSERT(0);
-		return 0;
-	}
-}
-
-void si_setint(si_t *sih, int siflag)
-{
-	if (sih->socitype == SOCI_AI)
-		ai_setint(sih, siflag);
-	else
-		ASSERT(0);
-}
-
-uint si_coreid(si_t *sih)
+uint ai_coreid(si_t *sih)
 {
 	si_info_t *sii;
 
@@ -1198,23 +1028,13 @@ uint ai_coreidx(si_t *sih)
 	return sii->curidx;
 }
 
-bool si_backplane64(si_t *sih)
+bool ai_backplane64(si_t *sih)
 {
 	return (sih->cccaps & CC_CAP_BKPLN64) != 0;
 }
 
-uint si_corerev(si_t *sih)
-{
-	if (sih->socitype == SOCI_AI)
-		return ai_corerev(sih);
-	else {
-		ASSERT(0);
-		return 0;
-	}
-}
-
 /* return index of coreid or BADIDX if not found */
-uint si_findcoreidx(si_t *sih, uint coreid, uint coreunit)
+uint ai_findcoreidx(si_t *sih, uint coreid, uint coreunit)
 {
 	si_info_t *sii;
 	uint found;
@@ -1240,11 +1060,11 @@ uint si_findcoreidx(si_t *sih, uint coreid, uint coreunit)
  * Moreover, callers should keep interrupts off during switching
  * out of and back to d11 core.
  */
-void *si_setcore(si_t *sih, uint coreid, uint coreunit)
+void *ai_setcore(si_t *sih, uint coreid, uint coreunit)
 {
 	uint idx;
 
-	idx = si_findcoreidx(sih, coreid, coreunit);
+	idx = ai_findcoreidx(sih, coreid, coreunit);
 	if (!GOODIDX(idx))
 		return NULL;
 
@@ -1256,18 +1076,8 @@ void *si_setcore(si_t *sih, uint coreid, uint coreunit)
 	}
 }
 
-void *si_setcoreidx(si_t *sih, uint coreidx)
-{
-	if (sih->socitype == SOCI_AI)
-		return ai_setcoreidx(sih, coreidx);
-	else {
-		ASSERT(0);
-		return NULL;
-	}
-}
-
-/* Turn off interrupt as required by si_setcore, before switch core */
-void *si_switch_core(si_t *sih, uint coreid, uint *origidx, uint *intr_val)
+/* Turn off interrupt as required by ai_setcore, before switch core */
+void *ai_switch_core(si_t *sih, uint coreid, uint *origidx, uint *intr_val)
 {
 	void *cc;
 	si_info_t *sii;
@@ -1287,14 +1097,14 @@ void *si_switch_core(si_t *sih, uint coreid, uint *origidx, uint *intr_val)
 	}
 	INTR_OFF(sii, *intr_val);
 	*origidx = sii->curidx;
-	cc = si_setcore(sih, coreid, 0);
+	cc = ai_setcore(sih, coreid, 0);
 	ASSERT(cc != NULL);
 
 	return cc;
 }
 
 /* restore coreidx and restore interrupt */
-void si_restore_core(si_t *sih, uint coreid, uint intr_val)
+void ai_restore_core(si_t *sih, uint coreid, uint intr_val)
 {
 	si_info_t *sii;
 
@@ -1303,141 +1113,182 @@ void si_restore_core(si_t *sih, uint coreid, uint intr_val)
 	    && ((coreid == CC_CORE_ID) || (coreid == sih->buscoretype)))
 		return;
 
-	si_setcoreidx(sih, coreid);
+	ai_setcoreidx(sih, coreid);
 	INTR_RESTORE(sii, intr_val);
 }
 
-u32 si_core_cflags(si_t *sih, u32 mask, u32 val)
+void ai_write_wrapperreg(si_t *sih, u32 offset, u32 val)
 {
-	if (sih->socitype == SOCI_AI)
-		return ai_core_cflags(sih, mask, val);
-	else {
-		ASSERT(0);
-		return 0;
-	}
+	si_info_t *sii = SI_INFO(sih);
+	u32 *w = (u32 *) sii->curwrap;
+	W_REG(w + (offset / 4), val);
+	return;
 }
 
-u32 si_core_sflags(si_t *sih, u32 mask, u32 val)
+/*
+ * Switch to 'coreidx', issue a single arbitrary 32bit register mask&set
+ * operation, switch back to the original core, and return the new value.
+ *
+ * When using the silicon backplane, no fiddling with interrupts or core
+ * switches is needed.
+ *
+ * Also, when using pci/pcie, we can optimize away the core switching for pci
+ * registers and (on newer pci cores) chipcommon registers.
+ */
+uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
 {
-	if (sih->socitype == SOCI_AI)
-		return ai_core_sflags(sih, mask, val);
-	else {
-		ASSERT(0);
+	uint origidx = 0;
+	u32 *r = NULL;
+	uint w;
+	uint intr_val = 0;
+	bool fast = false;
+	si_info_t *sii;
+
+	sii = SI_INFO(sih);
+
+	ASSERT(GOODIDX(coreidx));
+	ASSERT(regoff < SI_CORE_SIZE);
+	ASSERT((val & ~mask) == 0);
+
+	if (coreidx >= SI_MAXCORES)
 		return 0;
-	}
-}
 
-bool si_iscoreup(si_t *sih)
-{
-	if (sih->socitype == SOCI_AI)
-		return ai_iscoreup(sih);
-	else {
-		ASSERT(0);
-		return false;
+	if (sih->bustype == SI_BUS) {
+		/* If internal bus, we can always get at everything */
+		fast = true;
+		/* map if does not exist */
+		if (!sii->regs[coreidx]) {
+			sii->regs[coreidx] = REG_MAP(sii->coresba[coreidx],
+						     SI_CORE_SIZE);
+			ASSERT(GOODREGS(sii->regs[coreidx]));
+		}
+		r = (u32 *) ((unsigned char *) sii->regs[coreidx] + regoff);
+	} else if (sih->bustype == PCI_BUS) {
+		/*
+		 * If pci/pcie, we can get at pci/pcie regs
+		 * and on newer cores to chipc
+		 */
+		if ((sii->coreid[coreidx] == CC_CORE_ID) && SI_FAST(sii)) {
+			/* Chipc registers are mapped at 12KB */
+
+			fast = true;
+			r = (u32 *) ((char *)sii->curmap +
+					PCI_16KB0_CCREGS_OFFSET + regoff);
+		} else if (sii->pub.buscoreidx == coreidx) {
+			/*
+			 * pci registers are at either in the last 2KB of
+			 * an 8KB window or, in pcie and pci rev 13 at 8KB
+			 */
+			fast = true;
+			if (SI_FAST(sii))
+				r = (u32 *) ((char *)sii->curmap +
+						PCI_16KB0_PCIREGS_OFFSET +
+						regoff);
+			else
+				r = (u32 *) ((char *)sii->curmap +
+						((regoff >= SBCONFIGOFF) ?
+						 PCI_BAR0_PCISBR_OFFSET :
+						 PCI_BAR0_PCIREGS_OFFSET) +
+						regoff);
+		}
 	}
-}
 
-void si_write_wrapperreg(si_t *sih, u32 offset, u32 val)
-{
-	/* only for 4319, no requirement for SOCI_SB */
-	if (sih->socitype == SOCI_AI)
-		ai_write_wrap_reg(sih, offset, val);
-}
+	if (!fast) {
+		INTR_OFF(sii, intr_val);
 
-uint si_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
-{
+		/* save current core index */
+		origidx = ai_coreidx(&sii->pub);
 
-	if (sih->socitype == SOCI_AI)
-		return ai_corereg(sih, coreidx, regoff, mask, val);
-	else {
-		ASSERT(0);
-		return 0;
+		/* switch core */
+		r = (u32 *) ((unsigned char *) ai_setcoreidx(&sii->pub, coreidx)
+				+ regoff);
 	}
-}
+	ASSERT(r != NULL);
 
-void si_core_disable(si_t *sih, u32 bits)
-{
+	/* mask and set */
+	if (mask || val) {
+		w = (R_REG(r) & ~mask) | val;
+		W_REG(r, w);
+	}
 
-	if (sih->socitype == SOCI_AI)
-		ai_core_disable(sih, bits);
-}
+	/* readback */
+	w = R_REG(r);
 
-void si_core_reset(si_t *sih, u32 bits, u32 resetbits)
-{
-	if (sih->socitype == SOCI_AI)
-		ai_core_reset(sih, bits, resetbits);
-}
+	if (!fast) {
+		/* restore core index */
+		if (origidx != coreidx)
+			ai_setcoreidx(&sii->pub, origidx);
 
-u32 si_alp_clock(si_t *sih)
-{
-	if (PMUCTL_ENAB(sih))
-		return si_pmu_alp_clock(sih);
+		INTR_RESTORE(sii, intr_val);
+	}
 
-	return ALP_CLOCK;
+	return w;
 }
 
-u32 si_ilp_clock(si_t *sih)
+void ai_core_disable(si_t *sih, u32 bits)
 {
-	if (PMUCTL_ENAB(sih))
-		return si_pmu_ilp_clock(sih);
+	si_info_t *sii;
+	u32 dummy;
+	aidmp_t *ai;
 
-	return ILP_CLOCK;
-}
+	sii = SI_INFO(sih);
 
-/* set chip watchdog reset timer to fire in 'ticks' */
-void si_watchdog(si_t *sih, uint ticks)
-{
-	uint nb, maxt;
+	ASSERT(GOODREGS(sii->curwrap));
+	ai = sii->curwrap;
 
-	if (PMUCTL_ENAB(sih)) {
+	/* if core is already in reset, just return */
+	if (R_REG(&ai->resetctrl) & AIRC_RESET)
+		return;
 
-		if ((sih->chip == BCM4319_CHIP_ID) &&
-		    (sih->chiprev == 0) && (ticks != 0)) {
-			si_corereg(sih, SI_CC_IDX,
-				   offsetof(chipcregs_t, clk_ctl_st), ~0, 0x2);
-			si_setcore(sih, USB20D_CORE_ID, 0);
-			si_core_disable(sih, 1);
-			si_setcore(sih, CC_CORE_ID, 0);
-		}
+	W_REG(&ai->ioctrl, bits);
+	dummy = R_REG(&ai->ioctrl);
+	udelay(10);
 
-		nb = (sih->ccrev < 26) ? 16 : ((sih->ccrev >= 37) ? 32 : 24);
-		/* The mips compiler uses the sllv instruction,
-		 * so we specially handle the 32-bit case.
-		 */
-		if (nb == 32)
-			maxt = 0xffffffff;
-		else
-			maxt = ((1 << nb) - 1);
+	W_REG(&ai->resetctrl, AIRC_RESET);
+	udelay(1);
+}
 
-		if (ticks == 1)
-			ticks = 2;
-		else if (ticks > maxt)
-			ticks = maxt;
+/* reset and re-enable a core
+ * inputs:
+ * bits - core specific bits that are set during and after reset sequence
+ * resetbits - core specific bits that are set only during reset sequence
+ */
+void ai_core_reset(si_t *sih, u32 bits, u32 resetbits)
+{
+	si_info_t *sii;
+	aidmp_t *ai;
+	u32 dummy;
 
-		si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, pmuwatchdog),
-			   ~0, ticks);
-	} else {
-		/*
-		 * make sure we come up in fast clock mode;
-		 * or if clearing, clear clock
-		 */
-		si_clkctl_cc(sih, ticks ? CLK_FAST : CLK_DYNAMIC);
-		maxt = (1 << 28) - 1;
-		if (ticks > maxt)
-			ticks = maxt;
+	sii = SI_INFO(sih);
+	ASSERT(GOODREGS(sii->curwrap));
+	ai = sii->curwrap;
 
-		si_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, watchdog), ~0,
-			   ticks);
-	}
+	/*
+	 * Must do the disable sequence first to work
+	 * for arbitrary current core state.
+	 */
+	ai_core_disable(sih, (bits | resetbits));
+
+	/*
+	 * Now do the initialization sequence.
+	 */
+	W_REG(&ai->ioctrl, (bits | SICF_FGC | SICF_CLOCK_EN));
+	dummy = R_REG(&ai->ioctrl);
+	W_REG(&ai->resetctrl, 0);
+	udelay(1);
+
+	W_REG(&ai->ioctrl, (bits | SICF_CLOCK_EN));
+	dummy = R_REG(&ai->ioctrl);
+	udelay(1);
 }
 
 /* return the slow clock source - LPO, XTAL, or PCI */
-static uint si_slowclk_src(si_info_t *sii)
+static uint ai_slowclk_src(si_info_t *sii)
 {
 	chipcregs_t *cc;
 	u32 val;
 
-	ASSERT(SI_FAST(sii) || si_coreid(&sii->pub) == CC_CORE_ID);
+	ASSERT(SI_FAST(sii) || ai_coreid(&sii->pub) == CC_CORE_ID);
 
 	if (sii->pub.ccrev < 6) {
 		if (sii->pub.bustype == PCI_BUS) {
@@ -1448,19 +1299,19 @@ static uint si_slowclk_src(si_info_t *sii)
 		}
 		return SCC_SS_XTAL;
 	} else if (sii->pub.ccrev < 10) {
-		cc = (chipcregs_t *) si_setcoreidx(&sii->pub, sii->curidx);
+		cc = (chipcregs_t *) ai_setcoreidx(&sii->pub, sii->curidx);
 		return R_REG(&cc->slow_clk_ctl) & SCC_SS_MASK;
 	} else			/* Insta-clock */
 		return SCC_SS_XTAL;
 }
 
 /* return the ILP (slowclock) min or max frequency */
-static uint si_slowclk_freq(si_info_t *sii, bool max_freq, chipcregs_t *cc)
+static uint ai_slowclk_freq(si_info_t *sii, bool max_freq, chipcregs_t *cc)
 {
 	u32 slowclk;
 	uint div;
 
-	ASSERT(SI_FAST(sii) || si_coreid(&sii->pub) == CC_CORE_ID);
+	ASSERT(SI_FAST(sii) || ai_coreid(&sii->pub) == CC_CORE_ID);
 
 	/*
 	 * shouldn't be here unless we've established
@@ -1468,7 +1319,7 @@ static uint si_slowclk_freq(si_info_t *sii, bool max_freq, chipcregs_t *cc)
 	 */
 	ASSERT(R_REG(&cc->capabilities) & CC_CAP_PWR_CTL);
 
-	slowclk = si_slowclk_src(sii);
+	slowclk = ai_slowclk_src(sii);
 	if (sii->pub.ccrev < 6) {
 		if (slowclk == SCC_SS_PCI)
 			return max_freq ? (PCIMAXFREQ / 64)
@@ -1499,7 +1350,7 @@ static uint si_slowclk_freq(si_info_t *sii, bool max_freq, chipcregs_t *cc)
 	return 0;
 }
 
-static void si_clkctl_setdelay(si_info_t *sii, void *chipcregs)
+static void ai_clkctl_setdelay(si_info_t *sii, void *chipcregs)
 {
 	chipcregs_t *cc = (chipcregs_t *) chipcregs;
 	uint slowmaxfreq, pll_delay, slowclk;
@@ -1512,13 +1363,14 @@ static void si_clkctl_setdelay(si_info_t *sii, void *chipcregs)
 	 * add the xtal_on_delay since the xtal will also be
 	 * powered down by dynamic clk control logic.
 	 */
-	slowclk = si_slowclk_src(sii);
+
+	slowclk = ai_slowclk_src(sii);
 	if (slowclk != SCC_SS_XTAL)
 		pll_delay += XTAL_ON_DELAY;
 
 	/* Starting with 4318 it is ILP that is used for the delays */
 	slowmaxfreq =
-	    si_slowclk_freq(sii, (sii->pub.ccrev >= 10) ? false : true, cc);
+	    ai_slowclk_freq(sii, (sii->pub.ccrev >= 10) ? false : true, cc);
 
 	pll_on_delay = ((slowmaxfreq * pll_delay) + 999999) / 1000000;
 	fref_sel_delay = ((slowmaxfreq * FREF_DELAY) + 999999) / 1000000;
@@ -1528,7 +1380,7 @@ static void si_clkctl_setdelay(si_info_t *sii, void *chipcregs)
 }
 
 /* initialize power control delay registers */
-void si_clkctl_init(si_t *sih)
+void ai_clkctl_init(si_t *sih)
 {
 	si_info_t *sii;
 	uint origidx = 0;
@@ -1542,7 +1394,7 @@ void si_clkctl_init(si_t *sih)
 	fast = SI_FAST(sii);
 	if (!fast) {
 		origidx = sii->curidx;
-		cc = (chipcregs_t *) si_setcore(sih, CC_CORE_ID, 0);
+		cc = (chipcregs_t *) ai_setcore(sih, CC_CORE_ID, 0);
 		if (cc == NULL)
 			return;
 	} else {
@@ -1557,17 +1409,17 @@ void si_clkctl_init(si_t *sih)
 		SET_REG(&cc->system_clk_ctl, SYCC_CD_MASK,
 			(ILP_DIV_1MHZ << SYCC_CD_SHIFT));
 
-	si_clkctl_setdelay(sii, (void *)cc);
+	ai_clkctl_setdelay(sii, (void *)cc);
 
 	if (!fast)
-		si_setcoreidx(sih, origidx);
+		ai_setcoreidx(sih, origidx);
 }
 
 /*
  * return the value suitable for writing to the
  * dot11 core FAST_PWRUP_DELAY register
  */
-u16 si_clkctl_fast_pwrup_delay(si_t *sih)
+u16 ai_clkctl_fast_pwrup_delay(si_t *sih)
 {
 	si_info_t *sii;
 	uint origidx = 0;
@@ -1593,7 +1445,7 @@ u16 si_clkctl_fast_pwrup_delay(si_t *sih)
 	if (!fast) {
 		origidx = sii->curidx;
 		INTR_OFF(sii, intr_val);
-		cc = (chipcregs_t *) si_setcore(sih, CC_CORE_ID, 0);
+		cc = (chipcregs_t *) ai_setcore(sih, CC_CORE_ID, 0);
 		if (cc == NULL)
 			goto done;
 	} else {
@@ -1603,20 +1455,20 @@ u16 si_clkctl_fast_pwrup_delay(si_t *sih)
 	}
 	ASSERT(cc != NULL);
 
-	slowminfreq = si_slowclk_freq(sii, false, cc);
+	slowminfreq = ai_slowclk_freq(sii, false, cc);
 	fpdelay = (((R_REG(&cc->pll_on_delay) + 2) * 1000000) +
 		   (slowminfreq - 1)) / slowminfreq;
 
  done:
 	if (!fast) {
-		si_setcoreidx(sih, origidx);
+		ai_setcoreidx(sih, origidx);
 		INTR_RESTORE(sii, intr_val);
 	}
 	return fpdelay;
 }
 
 /* turn primary xtal and/or pll off/on */
-int si_clkctl_xtal(si_t *sih, uint what, bool on)
+int ai_clkctl_xtal(si_t *sih, uint what, bool on)
 {
 	si_info_t *sii;
 	u32 in, out, outen;
@@ -1693,7 +1545,7 @@ int si_clkctl_xtal(si_t *sih, uint what, bool on)
  *    this is a wrapper over the next internal function
  *      to allow flexible policy settings for outside caller
  */
-bool si_clkctl_cc(si_t *sih, uint mode)
+bool ai_clkctl_cc(si_t *sih, uint mode)
 {
 	si_info_t *sii;
 
@@ -1706,11 +1558,11 @@ bool si_clkctl_cc(si_t *sih, uint mode)
 	if (PCI_FORCEHT(sii))
 		return mode == CLK_FAST;
 
-	return _si_clkctl_cc(sii, mode);
+	return _ai_clkctl_cc(sii, mode);
 }
 
 /* clk control mechanism through chipcommon, no policy checking */
-static bool _si_clkctl_cc(si_info_t *sii, uint mode)
+static bool _ai_clkctl_cc(si_info_t *sii, uint mode)
 {
 	uint origidx = 0;
 	chipcregs_t *cc;
@@ -1733,11 +1585,11 @@ static bool _si_clkctl_cc(si_info_t *sii, uint mode)
 		origidx = sii->curidx;
 
 		if ((sii->pub.bustype == SI_BUS) &&
-		    si_setcore(&sii->pub, MIPS33_CORE_ID, 0) &&
-		    (si_corerev(&sii->pub) <= 7) && (sii->pub.ccrev >= 10))
+		    ai_setcore(&sii->pub, MIPS33_CORE_ID, 0) &&
+		    (ai_corerev(&sii->pub) <= 7) && (sii->pub.ccrev >= 10))
 			goto done;
 
-		cc = (chipcregs_t *) si_setcore(&sii->pub, CC_CORE_ID, 0);
+		cc = (chipcregs_t *) ai_setcore(&sii->pub, CC_CORE_ID, 0);
 	} else {
 		cc = (chipcregs_t *) CCREGS_FAST(sii);
 		if (cc == NULL)
@@ -1755,7 +1607,7 @@ static bool _si_clkctl_cc(si_info_t *sii, uint mode)
 			 * don't forget to force xtal back
 			 * on before we clear SCC_DYN_XTAL..
 			 */
-			si_clkctl_xtal(&sii->pub, XTAL, ON);
+			ai_clkctl_xtal(&sii->pub, XTAL, ON);
 			SET_REG(&cc->slow_clk_ctl,
 				(SCC_XC | SCC_FS | SCC_IP), SCC_IP);
 		} else if (sii->pub.ccrev < 20) {
@@ -1788,7 +1640,7 @@ static bool _si_clkctl_cc(si_info_t *sii, uint mode)
 			 * release our xtal_pu "force on"
 			 */
 			if (scc & SCC_XC)
-				si_clkctl_xtal(&sii->pub, XTAL, OFF);
+				ai_clkctl_xtal(&sii->pub, XTAL, OFF);
 		} else if (sii->pub.ccrev < 20) {
 			/* Instaclock */
 			AND_REG(&cc->system_clk_ctl, ~SYCC_HR);
@@ -1803,14 +1655,14 @@ static bool _si_clkctl_cc(si_info_t *sii, uint mode)
 
  done:
 	if (!fast) {
-		si_setcoreidx(&sii->pub, origidx);
+		ai_setcoreidx(&sii->pub, origidx);
 		INTR_RESTORE(sii, intr_val);
 	}
 	return mode == CLK_FAST;
 }
 
 /* Build device path. Support SI, PCI, and JTAG for now. */
-int si_devpath(si_t *sih, char *path, int size)
+int ai_devpath(si_t *sih, char *path, int size)
 {
 	int slen;
 
@@ -1848,30 +1700,30 @@ int si_devpath(si_t *sih, char *path, int size)
 }
 
 /* Get a variable, but only if it has a devpath prefix */
-char *si_getdevpathvar(si_t *sih, const char *name)
+char *ai_getdevpathvar(si_t *sih, const char *name)
 {
 	char varname[SI_DEVPATH_BUFSZ + 32];
 
-	si_devpathvar(sih, varname, sizeof(varname), name);
+	ai_devpathvar(sih, varname, sizeof(varname), name);
 
 	return getvar(NULL, varname);
 }
 
 /* Get a variable, but only if it has a devpath prefix */
-int si_getdevpathintvar(si_t *sih, const char *name)
+int ai_getdevpathintvar(si_t *sih, const char *name)
 {
 #if defined(BCMBUSTYPE) && (BCMBUSTYPE == SI_BUS)
 	return getintvar(NULL, name);
 #else
 	char varname[SI_DEVPATH_BUFSZ + 32];
 
-	si_devpathvar(sih, varname, sizeof(varname), name);
+	ai_devpathvar(sih, varname, sizeof(varname), name);
 
 	return getintvar(NULL, varname);
 #endif
 }
 
-char *si_getnvramflvar(si_t *sih, const char *name)
+char *ai_getnvramflvar(si_t *sih, const char *name)
 {
 	return getvar(NULL, name);
 }
@@ -1881,14 +1733,14 @@ char *si_getnvramflvar(si_t *sih, const char *name)
  * len == 0 or var is NULL, var is still returned. On overflow, the
  * first char will be set to '\0'.
  */
-static char *si_devpathvar(si_t *sih, char *var, int len, const char *name)
+static char *ai_devpathvar(si_t *sih, char *var, int len, const char *name)
 {
 	uint path_len;
 
 	if (!var || len <= 0)
 		return var;
 
-	if (si_devpath(sih, var, len) == 0) {
+	if (ai_devpath(sih, var, len) == 0) {
 		path_len = strlen(var);
 
 		if (strlen(name) + 1 > (uint) (len - path_len))
@@ -1901,7 +1753,7 @@ static char *si_devpathvar(si_t *sih, char *var, int len, const char *name)
 }
 
 /* return true if PCIE capability exists in the pci config space */
-static __used bool si_ispcie(si_info_t *sii)
+static __used bool ai_ispcie(si_info_t *sii)
 {
 	u8 cap_ptr;
 
@@ -1917,7 +1769,7 @@ static __used bool si_ispcie(si_info_t *sii)
 	return true;
 }
 
-bool si_pci_war16165(si_t *sih)
+bool ai_pci_war16165(si_t *sih)
 {
 	si_info_t *sii;
 
@@ -1926,7 +1778,7 @@ bool si_pci_war16165(si_t *sih)
 	return PCI(sii) && (sih->buscorerev <= 10);
 }
 
-void si_pci_up(si_t *sih)
+void ai_pci_up(si_t *sih)
 {
 	si_info_t *sii;
 
@@ -1937,7 +1789,7 @@ void si_pci_up(si_t *sih)
 		return;
 
 	if (PCI_FORCEHT(sii))
-		_si_clkctl_cc(sii, CLK_FAST);
+		_ai_clkctl_cc(sii, CLK_FAST);
 
 	if (PCIE(sii))
 		pcicore_up(sii->pch, SI_PCIUP);
@@ -1945,7 +1797,7 @@ void si_pci_up(si_t *sih)
 }
 
 /* Unconfigure and/or apply various WARs when system is going to sleep mode */
-void si_pci_sleep(si_t *sih)
+void ai_pci_sleep(si_t *sih)
 {
 	si_info_t *sii;
 
@@ -1955,7 +1807,7 @@ void si_pci_sleep(si_t *sih)
 }
 
 /* Unconfigure and/or apply various WARs when going down */
-void si_pci_down(si_t *sih)
+void ai_pci_down(si_t *sih)
 {
 	si_info_t *sii;
 
@@ -1967,7 +1819,7 @@ void si_pci_down(si_t *sih)
 
 	/* release FORCEHT since chip is going to "down" state */
 	if (PCI_FORCEHT(sii))
-		_si_clkctl_cc(sii, CLK_DYNAMIC);
+		_ai_clkctl_cc(sii, CLK_DYNAMIC);
 
 	pcicore_down(sii->pch, SI_PCIDOWN);
 }
@@ -1976,7 +1828,7 @@ void si_pci_down(si_t *sih)
  * Configure the pci core for pci client (NIC) action
  * coremask is the bitvec of cores by index to be enabled.
  */
-void si_pci_setup(si_t *sih, uint coremask)
+void ai_pci_setup(si_t *sih, uint coremask)
 {
 	si_info_t *sii;
 	struct sbpciregs *pciregs = NULL;
@@ -1996,10 +1848,10 @@ void si_pci_setup(si_t *sih, uint coremask)
 		idx = sii->curidx;
 
 		/* we interrupt on this backplane flag number */
-		siflag = si_flag(sih);
+		siflag = ai_flag(sih);
 
 		/* switch over to pci core */
-		pciregs = si_setcoreidx(sih, sii->pub.buscoreidx);
+		pciregs = ai_setcoreidx(sih, sii->pub.buscoreidx);
 	}
 
 	/*
@@ -2013,7 +1865,7 @@ void si_pci_setup(si_t *sih, uint coremask)
 		pci_write_config_dword(sii->pbus, PCI_INT_MASK, w);
 	} else {
 		/* set sbintvec bit for our flag number */
-		si_setint(sih, siflag);
+		ai_setint(sih, siflag);
 	}
 
 	if (PCI(sii)) {
@@ -2029,7 +1881,7 @@ void si_pci_setup(si_t *sih, uint coremask)
 		}
 
 		/* switch back to previous core */
-		si_setcoreidx(sih, idx);
+		ai_setcoreidx(sih, idx);
 	}
 }
 
@@ -2037,7 +1889,7 @@ void si_pci_setup(si_t *sih, uint coremask)
  * Fixup SROMless PCI device's configuration.
  * The current core may be changed upon return.
  */
-int si_pci_fixcfg(si_t *sih)
+int ai_pci_fixcfg(si_t *sih)
 {
 	uint origidx, pciidx;
 	struct sbpciregs *pciregs = NULL;
@@ -2055,12 +1907,12 @@ int si_pci_fixcfg(si_t *sih)
 
 	/* check 'pi' is correct and fix it if not */
 	if (sii->pub.buscoretype == PCIE_CORE_ID) {
-		pcieregs = si_setcore(&sii->pub, PCIE_CORE_ID, 0);
+		pcieregs = ai_setcore(&sii->pub, PCIE_CORE_ID, 0);
 		regs = pcieregs;
 		ASSERT(pcieregs != NULL);
 		reg16 = &pcieregs->sprom[SRSH_PI_OFFSET];
 	} else if (sii->pub.buscoretype == PCI_CORE_ID) {
-		pciregs = si_setcore(&sii->pub, PCI_CORE_ID, 0);
+		pciregs = ai_setcore(&sii->pub, PCI_CORE_ID, 0);
 		regs = pciregs;
 		ASSERT(pciregs != NULL);
 		reg16 = &pciregs->sprom[SRSH_PI_OFFSET];
@@ -2075,14 +1927,14 @@ int si_pci_fixcfg(si_t *sih)
 	}
 
 	/* restore the original index */
-	si_setcoreidx(&sii->pub, origidx);
+	ai_setcoreidx(&sii->pub, origidx);
 
 	pcicore_hwup(sii->pch);
 	return 0;
 }
 
 /* mask&set gpiocontrol bits */
-u32 si_gpiocontrol(si_t *sih, u32 mask, u32 val, u8 priority)
+u32 ai_gpiocontrol(si_t *sih, u32 mask, u32 val, u8 priority)
 {
 	uint regoff;
 
@@ -2093,16 +1945,16 @@ u32 si_gpiocontrol(si_t *sih, u32 mask, u32 val, u8 priority)
 	 */
 	if ((priority != GPIO_HI_PRIORITY) &&
 	    (sih->bustype == SI_BUS) && (val || mask)) {
-		mask = priority ? (si_gpioreservation & mask) :
-		    ((si_gpioreservation | mask) & ~(si_gpioreservation));
+		mask = priority ? (ai_gpioreservation & mask) :
+		    ((ai_gpioreservation | mask) & ~(ai_gpioreservation));
 		val &= mask;
 	}
 
 	regoff = offsetof(chipcregs_t, gpiocontrol);
-	return si_corereg(sih, SI_CC_IDX, regoff, mask, val);
+	return ai_corereg(sih, SI_CC_IDX, regoff, mask, val);
 }
 
-void si_chipcontrl_epa4331(si_t *sih, bool on)
+void ai_chipcontrl_epa4331(si_t *sih, bool on)
 {
 	si_info_t *sii;
 	chipcregs_t *cc;
@@ -2112,7 +1964,7 @@ void si_chipcontrl_epa4331(si_t *sih, bool on)
 	sii = SI_INFO(sih);
 	origidx = ai_coreidx(sih);
 
-	cc = (chipcregs_t *) si_setcore(sih, CC_CORE_ID, 0);
+	cc = (chipcregs_t *) ai_setcore(sih, CC_CORE_ID, 0);
 
 	val = R_REG(&cc->chipcontrol);
 
@@ -2132,11 +1984,11 @@ void si_chipcontrl_epa4331(si_t *sih, bool on)
 		W_REG(&cc->chipcontrol, val);
 	}
 
-	si_setcoreidx(sih, origidx);
+	ai_setcoreidx(sih, origidx);
 }
 
 /* Enable BT-COEX & Ex-PA for 4313 */
-void si_epa_4313war(si_t *sih)
+void ai_epa_4313war(si_t *sih)
 {
 	si_info_t *sii;
 	chipcregs_t *cc;
@@ -2145,17 +1997,17 @@ void si_epa_4313war(si_t *sih)
 	sii = SI_INFO(sih);
 	origidx = ai_coreidx(sih);
 
-	cc = (chipcregs_t *) si_setcore(sih, CC_CORE_ID, 0);
+	cc = (chipcregs_t *) ai_setcore(sih, CC_CORE_ID, 0);
 
 	/* EPA Fix */
 	W_REG(&cc->gpiocontrol,
 	      R_REG(&cc->gpiocontrol) | GPIO_CTRL_EPA_EN_MASK);
 
-	si_setcoreidx(sih, origidx);
+	ai_setcoreidx(sih, origidx);
 }
 
 /* check if the device is removed */
-bool si_deviceremoved(si_t *sih)
+bool ai_deviceremoved(si_t *sih)
 {
 	u32 w;
 	si_info_t *sii;
@@ -2173,7 +2025,7 @@ bool si_deviceremoved(si_t *sih)
 	return false;
 }
 
-bool si_is_sprom_available(si_t *sih)
+bool ai_is_sprom_available(si_t *sih)
 {
 	if (sih->ccrev >= 31) {
 		si_info_t *sii;
@@ -2186,9 +2038,9 @@ bool si_is_sprom_available(si_t *sih)
 
 		sii = SI_INFO(sih);
 		origidx = sii->curidx;
-		cc = si_setcoreidx(sih, SI_CC_IDX);
+		cc = ai_setcoreidx(sih, SI_CC_IDX);
 		sromctrl = R_REG(&cc->sromcontrol);
-		si_setcoreidx(sih, origidx);
+		ai_setcoreidx(sih, origidx);
 		return sromctrl & SRC_PRESENT;
 	}
 
@@ -2210,7 +2062,7 @@ bool si_is_sprom_available(si_t *sih)
 	}
 }
 
-bool si_is_otp_disabled(si_t *sih)
+bool ai_is_otp_disabled(si_t *sih)
 {
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -2238,17 +2090,16 @@ bool si_is_otp_disabled(si_t *sih)
 	}
 }
 
-bool si_is_otp_powered(si_t *sih)
+bool ai_is_otp_powered(si_t *sih)
 {
 	if (PMUCTL_ENAB(sih))
 		return si_pmu_is_otp_powered(sih);
 	return true;
 }
 
-void si_otp_power(si_t *sih, bool on)
+void ai_otp_power(si_t *sih, bool on)
 {
 	if (PMUCTL_ENAB(sih))
 		si_pmu_otp_power(sih, on);
 	udelay(1000);
 }
-
diff --git a/drivers/staging/brcm80211/util/bcmotp.c b/drivers/staging/brcm80211/util/bcmotp.c
index aaa80a3..2421785 100644
--- a/drivers/staging/brcm80211/util/bcmotp.c
+++ b/drivers/staging/brcm80211/util/bcmotp.c
@@ -314,14 +314,12 @@ static void *ipxotp_init(si_t *sih)
 		return NULL;
 
 	/* Make sure OTP is not disabled */
-	if (si_is_otp_disabled(sih)) {
+	if (ai_is_otp_disabled(sih))
 		return NULL;
-	}
 
 	/* Make sure OTP is powered up */
-	if (!si_is_otp_powered(sih)) {
+	if (!ai_is_otp_powered(sih))
 		return NULL;
-	}
 
 	oi = &otpinfo;
 
@@ -357,11 +355,11 @@ static void *ipxotp_init(si_t *sih)
 
 	/* Retrieve OTP region info */
 	idx = ai_coreidx(sih);
-	cc = si_setcoreidx(sih, SI_CC_IDX);
+	cc = ai_setcoreidx(sih, SI_CC_IDX);
 
 	_ipxotp_init(oi, cc);
 
-	si_setcoreidx(sih, idx);
+	ai_setcoreidx(sih, idx);
 
 	return (void *)oi;
 }
@@ -440,13 +438,13 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 	}
 
 	idx = ai_coreidx(oi->sih);
-	cc = si_setcoreidx(oi->sih, SI_CC_IDX);
+	cc = ai_setcoreidx(oi->sih, SI_CC_IDX);
 
 	/* Read the data */
 	for (i = 0; i < sz; i++)
 		data[i] = ipxotp_otpr(oh, cc, base + i);
 
-	si_setcoreidx(oi->sih, idx);
+	ai_setcoreidx(oi->sih, idx);
 	*wlen = sz;
 	return 0;
 }
@@ -618,7 +616,7 @@ static void *hndotp_init(si_t *sih)
 	idx = ai_coreidx(sih);
 
 	/* Check for otp */
-	cc = si_setcoreidx(sih, SI_CC_IDX);
+	cc = ai_setcoreidx(sih, SI_CC_IDX);
 	if (cc != NULL) {
 		cap = R_REG(&cc->capabilities);
 		if ((cap & CC_CAP_OTPSIZE) == 0) {
@@ -670,7 +668,7 @@ static void *hndotp_init(si_t *sih)
 	}
 
  out:				/* All done */
-	si_setcoreidx(sih, idx);
+	ai_setcoreidx(sih, idx);
 
 	return ret;
 }
@@ -700,12 +698,12 @@ static int hndotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 	    ((int)*wlen < oi->boundary / 2) ? *wlen : (uint) oi->boundary / 2;
 
 	idx = ai_coreidx(oi->sih);
-	cc = si_setcoreidx(oi->sih, SI_CC_IDX);
+	cc = ai_setcoreidx(oi->sih, SI_CC_IDX);
 
 	for (i = 0; i < (int)*wlen; i++)
 		data[i] = hndotp_otpr(oh, cc, i);
 
-	si_setcoreidx(oi->sih, idx);
+	ai_setcoreidx(oi->sih, idx);
 
 	return 0;
 }
@@ -723,7 +721,7 @@ static int hndotp_nvread(void *oh, char *data, uint *len)
 
 	/* save the orig core */
 	idx = ai_coreidx(oi->sih);
-	cc = si_setcoreidx(oi->sih, SI_CC_IDX);
+	cc = ai_setcoreidx(oi->sih, SI_CC_IDX);
 
 	st = hndotp_status(oh);
 	if (!(st & (OTP_HW_REGION | OTP_SW_REGION))) {
@@ -815,7 +813,7 @@ static int hndotp_nvread(void *oh, char *data, uint *len)
 
  out:
 	kfree(rawotp);
-	si_setcoreidx(oi->sih, idx);
+	ai_setcoreidx(oi->sih, idx);
 
 	return rc;
 }
@@ -861,9 +859,9 @@ u16 otp_read_bit(void *oh, uint offset)
 {
 	otpinfo_t *oi = (otpinfo_t *) oh;
 	uint idx = ai_coreidx(oi->sih);
-	chipcregs_t *cc = si_setcoreidx(oi->sih, SI_CC_IDX);
+	chipcregs_t *cc = ai_setcoreidx(oi->sih, SI_CC_IDX);
 	u16 readBit = (u16) oi->fn->read_bit(oh, cc, offset);
-	si_setcoreidx(oi->sih, idx);
+	ai_setcoreidx(oi->sih, idx);
 	return readBit;
 }
 
@@ -905,11 +903,11 @@ otp_read_region(si_t *sih, int region, u16 *data,
 	void *oh;
 	int err = 0;
 
-	wasup = si_is_otp_powered(sih);
+	wasup = ai_is_otp_powered(sih);
 	if (!wasup)
-		si_otp_power(sih, true);
+		ai_otp_power(sih, true);
 
-	if (!si_is_otp_powered(sih) || si_is_otp_disabled(sih)) {
+	if (!ai_is_otp_powered(sih) || ai_is_otp_disabled(sih)) {
 		err = -EPERM;
 		goto out;
 	}
@@ -924,7 +922,7 @@ otp_read_region(si_t *sih, int region, u16 *data,
 
  out:
 	if (!wasup)
-		si_otp_power(sih, false);
+		ai_otp_power(sih, false);
 
 	return err;
 }
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index 6026b32..8df4455 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -25,7 +25,7 @@
 #include <sbchipc.h>
 #include <bcmdevs.h>
 #include <pcicfg.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <bcmsrom.h>
 #include <bcmsrom_tbl.h>
 
@@ -353,7 +353,7 @@ static int initvars_flash(si_t *sih, char **base, uint len)
 	if (err)
 		goto exit;
 
-	si_devpath(sih, devpath, sizeof(devpath));
+	ai_devpath(sih, devpath, sizeof(devpath));
 
 	/* grab vars with the <devpath> prefix in name */
 	dl = strlen(devpath);
@@ -595,7 +595,7 @@ static int initvars_srom_pci(si_t *sih, void *curmap, char **vars, uint *count)
 		return -2;
 
 	sromwindow = (u16 *) SROM_OFFSET(sih);
-	if (si_is_sprom_available(sih)) {
+	if (ai_is_sprom_available(sih)) {
 		err =
 		    sprom_read_pci(sih, sromwindow, 0, srom, SROM_WORDS,
 				   true);
@@ -643,14 +643,14 @@ static int initvars_srom_pci(si_t *sih, void *curmap, char **vars, uint *count)
 		u32 val;
 		val = 0;
 
-		value = si_getdevpathvar(sih, "sromrev");
+		value = ai_getdevpathvar(sih, "sromrev");
 		if (value) {
 			sromrev = (u8) simple_strtoul(value, NULL, 0);
 			flash = true;
 			goto varscont;
 		}
 
-		value = si_getnvramflvar(sih, "sromrev");
+		value = ai_getnvramflvar(sih, "sromrev");
 		if (value) {
 			err = 0;
 			goto errout;
diff --git a/drivers/staging/brcm80211/util/hnddma.c b/drivers/staging/brcm80211/util/hnddma.c
index 950d862..0737fb2 100644
--- a/drivers/staging/brcm80211/util/hnddma.c
+++ b/drivers/staging/brcm80211/util/hnddma.c
@@ -22,7 +22,7 @@
 #include <bcmdevs.h>
 #include <hndsoc.h>
 #include <bcmutils.h>
-#include <siutils.h>
+#include <aiutils.h>
 
 #include <sbhnddma.h>
 #include <hnddma.h>
@@ -293,7 +293,8 @@ struct hnddma_pub *dma_attach(char *name, si_t *sih,
 
 	di->msg_level = msg_level ? msg_level : &dma_msg_level;
 
-	di->dma64 = ((si_core_sflags(sih, 0, 0) & SISF_DMA64) == SISF_DMA64);
+
+	di->dma64 = ((ai_core_sflags(sih, 0, 0) & SISF_DMA64) == SISF_DMA64);
 
 	/* init dma reg pointer */
 	di->d64txregs = (dma64regs_t *) dmaregstx;
@@ -355,11 +356,11 @@ struct hnddma_pub *dma_attach(char *name, si_t *sih,
 	di->dataoffsetlow = di->dataoffsetlow + SI_SDRAM_SWAPPED;
 #endif				/* defined(__mips__) && defined(IL_BIGENDIAN) */
 	/* WAR64450 : DMACtl.Addr ext fields are not supported in SDIOD core. */
-	if ((si_coreid(sih) == SDIOD_CORE_ID)
-	    && ((si_corerev(sih) > 0) && (si_corerev(sih) <= 2)))
+	if ((ai_coreid(sih) == SDIOD_CORE_ID)
+	    && ((ai_corerev(sih) > 0) && (ai_corerev(sih) <= 2)))
 		di->addrext = 0;
-	else if ((si_coreid(sih) == I2S_CORE_ID) &&
-		 ((si_corerev(sih) == 0) || (si_corerev(sih) == 1)))
+	else if ((ai_coreid(sih) == I2S_CORE_ID) &&
+		 ((ai_corerev(sih) == 0) || (ai_corerev(sih) == 1)))
 		di->addrext = 0;
 	else
 		di->addrext = _dma_isaddrext(di);
@@ -1725,9 +1726,9 @@ uint dma_addrwidth(si_t *sih, void *dmaregs)
 {
 	/* Perform 64-bit checks only if we want to advertise 64-bit (> 32bit) capability) */
 	/* DMA engine is 64-bit capable */
-	if ((si_core_sflags(sih, 0, 0) & SISF_DMA64) == SISF_DMA64) {
+	if ((ai_core_sflags(sih, 0, 0) & SISF_DMA64) == SISF_DMA64) {
 		/* backplane are 64-bit capable */
-		if (si_backplane64(sih))
+		if (ai_backplane64(sih))
 			/* If bus is System Backplane or PCIE then we can access 64-bits */
 			if ((sih->bustype == SI_BUS) ||
 			    ((sih->bustype == PCI_BUS) &&
diff --git a/drivers/staging/brcm80211/util/nicpci.c b/drivers/staging/brcm80211/util/nicpci.c
index 81a7d69..5a127d2 100644
--- a/drivers/staging/brcm80211/util/nicpci.c
+++ b/drivers/staging/brcm80211/util/nicpci.c
@@ -19,7 +19,7 @@
 #include <linux/pci.h>
 #include <bcmdefs.h>
 #include <bcmutils.h>
-#include <siutils.h>
+#include <aiutils.h>
 #include <hndsoc.h>
 #include <bcmdevs.h>
 #include <sbchipc.h>
@@ -382,10 +382,10 @@ static void pcie_clkreq_upd(pcicore_info_t *pi, uint state)
 		break;
 	case SI_PCIDOWN:
 		if (sih->buscorerev == 6) {	/* turn on serdes PLL down */
-			si_corereg(sih, SI_CC_IDX,
+			ai_corereg(sih, SI_CC_IDX,
 				   offsetof(chipcregs_t, chipcontrol_addr), ~0,
 				   0);
-			si_corereg(sih, SI_CC_IDX,
+			ai_corereg(sih, SI_CC_IDX,
 				   offsetof(chipcregs_t, chipcontrol_data),
 				   ~0x40, 0);
 		} else if (pi->pcie_pr42767) {
@@ -394,10 +394,10 @@ static void pcie_clkreq_upd(pcicore_info_t *pi, uint state)
 		break;
 	case SI_PCIUP:
 		if (sih->buscorerev == 6) {	/* turn off serdes PLL down */
-			si_corereg(sih, SI_CC_IDX,
+			ai_corereg(sih, SI_CC_IDX,
 				   offsetof(chipcregs_t, chipcontrol_addr), ~0,
 				   0);
-			si_corereg(sih, SI_CC_IDX,
+			ai_corereg(sih, SI_CC_IDX,
 				   offsetof(chipcregs_t, chipcontrol_data),
 				   ~0x40, 0x40);
 		} else if (PCIE_ASPM(sih)) {	/* disable clkreq */
@@ -523,7 +523,7 @@ static void pcie_war_noplldown(pcicore_info_t *pi)
 	u16 *reg16;
 
 	/* turn off serdes PLL down */
-	si_corereg(pi->sih, SI_CC_IDX, offsetof(chipcregs_t, chipcontrol),
+	ai_corereg(pi->sih, SI_CC_IDX, offsetof(chipcregs_t, chipcontrol),
 		   CHIPCTRL_4321_PLL_DOWN, CHIPCTRL_4321_PLL_DOWN);
 
 	/*  clear srom shadow backdoor */
-- 
1.7.4.1


