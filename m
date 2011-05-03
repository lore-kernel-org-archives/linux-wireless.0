Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2382 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 17/61] staging: brcm80211: removed ASSERTs from
 wlc_bmac.c
Date: Tue, 3 May 2011 11:35:17 +0200
Message-ID: <1304415361-7813-18-git-send-email-arend@broadcom.com> (sfid-20110503_113638_539341_84491472)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Driver contains far too many ASSERTs. Extraneous asserts removed.
Only asserts that signal a hardware problem have been converted
into WARN_ON.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |  153 ++++++-------------------
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |   52 ---------
 drivers/staging/brcm80211/brcmsmac/wlc_main.h |    1 -
 3 files changed, 34 insertions(+), 172 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index e2dadf0..0f3e19b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -237,10 +237,7 @@ static u32 WLBANDINITFN(wlc_setband_inact) (struct wlc_info *wlc, uint bandunit)
 
 	WL_TRACE("wl%d: wlc_setband_inact\n", wlc_hw->unit);
 
-	ASSERT(bandunit != wlc_hw->band->bandunit);
-	ASSERT(ai_iscoreup(wlc_hw->sih));
-	ASSERT((R_REG(&wlc_hw->regs->maccontrol) & MCTL_EN_MAC) ==
-	       0);
+	WARN_ON((R_REG(&wlc_hw->regs->maccontrol) & MCTL_EN_MAC) != 0);
 
 	/* disable interrupts */
 	macintmask = wl_intrsoff(wlc->wl);
@@ -248,8 +245,6 @@ static u32 WLBANDINITFN(wlc_setband_inact) (struct wlc_info *wlc, uint bandunit)
 	/* radio off */
 	wlc_phy_switch_radio(wlc_hw->band->pi, OFF);
 
-	ASSERT(wlc_hw->clk);
-
 	wlc_bmac_core_phy_clk(wlc_hw, OFF);
 
 	wlc_setxband(wlc_hw, bandunit);
@@ -339,10 +334,7 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 	WL_TRACE("wl%d: wlc_dpc: macintstatus 0x%x\n",
 		 wlc_hw->unit, macintstatus);
 
-	if (macintstatus & MI_PRQ) {
-		/* Process probe request FIFO */
-		ASSERT(0 && "PRQ Interrupt in non-MBSS");
-	}
+	WARN_ON(macintstatus & MI_PRQ); /* PRQ Interrupt in non-MBSS */
 
 	/* BCN template is available */
 	/* ZZZ: Use AP_ACTIVE ? */
@@ -430,11 +422,6 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 	if (!pktq_empty(&wlc->active_queue->q))
 		wlc_send_q(wlc, wlc->active_queue);
 
-	ASSERT(wlc_ps_check(wlc));
-
-	/* make sure the bound indication and the implementation are in sync */
-	ASSERT(bounded == true || wlc->macintstatus == 0);
-
 	/* it isn't done and needs to be resched if macintstatus is non-zero */
 	return wlc->macintstatus != 0;
 
@@ -854,8 +841,6 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		wlc_hw->machwcap_backup = wlc_hw->machwcap;
 
 		/* init tx fifo size */
-		ASSERT((wlc_hw->corerev - XMTFIFOTBL_STARTREV) <
-		       ARRAY_SIZE(xmtfifo_sz));
 		wlc_hw->xmtfifo_sz =
 		    xmtfifo_sz[(wlc_hw->corerev - XMTFIFOTBL_STARTREV)];
 
@@ -1128,8 +1113,6 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 
 	WL_TRACE("wl%d: %s:\n", wlc_hw->unit, __func__);
 
-	ASSERT(wlc_hw->wlc->pub->hw_up && wlc_hw->wlc->macintmask == 0);
-
 	/*
 	 * Enable pll and xtal, initialize the power control registers,
 	 * and force fastclock for the remainder of wlc_up().
@@ -1147,8 +1130,6 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 	if (wlc_hw->sih->bustype == PCI_BUS)
 		si_pci_setup(wlc_hw->sih, coremask);
 
-	ASSERT(si_coreid(wlc_hw->sih) == D11_CORE_ID);
-
 	/*
 	 * Need to read the hwradio status here to cover the case where the system
 	 * is loaded with the hw radio disabled. We do not want to bring the driver up in this case.
@@ -1179,7 +1160,6 @@ int wlc_bmac_up_finish(struct wlc_hw_info *wlc_hw)
 
 	/* FULLY enable dynamic power control and d11 core interrupt */
 	wlc_clkctl_clk(wlc_hw, CLK_DYNAMIC);
-	ASSERT(wlc_hw->wlc->macintmask == 0);
 	wl_intrson(wlc_hw->wlc->wl);
 	return 0;
 }
@@ -1264,8 +1244,6 @@ void wlc_bmac_wait_for_wake(struct wlc_hw_info *wlc_hw)
 	/* wait until ucode is no longer asleep */
 	SPINWAIT((wlc_bmac_read_shm(wlc_hw, M_UCODE_DBGST) ==
 		  DBGST_ASLEEP), wlc_hw->wlc->fastpwrup_dly);
-
-	ASSERT(wlc_bmac_read_shm(wlc_hw, M_UCODE_DBGST) != DBGST_ASLEEP);
 }
 
 void wlc_bmac_hw_etheraddr(struct wlc_hw_info *wlc_hw, u8 *ea)
@@ -1299,9 +1277,9 @@ static void wlc_clkctl_clk(struct wlc_hw_info *wlc_hw, uint mode)
 					   (&wlc_hw->regs->
 					    clk_ctl_st) & CCS_HTAVAIL) == 0),
 					 PMU_MAX_TRANSITION_DLY);
-				ASSERT(R_REG
-				       (&wlc_hw->regs->
-					clk_ctl_st) & CCS_HTAVAIL);
+				WARN_ON(!(R_REG
+					  (&wlc_hw->regs->
+					   clk_ctl_st) & CCS_HTAVAIL));
 			} else {
 				if ((wlc_hw->sih->pmurev == 0) &&
 				    (R_REG
@@ -1327,7 +1305,8 @@ static void wlc_clkctl_clk(struct wlc_hw_info *wlc_hw, uint mode)
 
 		/* check fast clock is available (if core is not in reset) */
 		if (wlc_hw->forcefastclk && wlc_hw->clk)
-			ASSERT(ai_core_sflags(wlc_hw->sih, 0, 0) & SISF_FCLKA);
+			WARN_ON(!(ai_core_sflags(wlc_hw->sih, 0, 0) &
+				  SISF_FCLKA));
 
 		/* keep the ucode wake bit on if forcefastclk is on
 		 * since we do not want ucode to put us back to slow clock
@@ -1389,8 +1368,8 @@ wlc_bmac_mhf(struct wlc_hw_info *wlc_hw, u8 idx, u16 mask, u16 val,
 	};
 	struct wlc_hwband *band;
 
-	ASSERT((val & ~mask) == 0);
-	ASSERT(idx < MHFMAX);
+	if ((val & ~mask) || idx >= MHFMAX)
+		return; /* error condition */
 
 	switch (bands) {
 		/* Current band only or all bands,
@@ -1407,8 +1386,7 @@ wlc_bmac_mhf(struct wlc_hw_info *wlc_hw, u8 idx, u16 mask, u16 val,
 		band = wlc_hw->bandstate[BAND_2G_INDEX];
 		break;
 	default:
-		ASSERT(0);
-		band = NULL;
+		band = NULL;	/* error condition */
 	}
 
 	if (band) {
@@ -1435,8 +1413,9 @@ wlc_bmac_mhf(struct wlc_hw_info *wlc_hw, u8 idx, u16 mask, u16 val,
 u16 wlc_bmac_mhf_get(struct wlc_hw_info *wlc_hw, u8 idx, int bands)
 {
 	struct wlc_hwband *band;
-	ASSERT(idx < MHFMAX);
 
+	if (idx >= MHFMAX)
+		return 0; /* error condition */
 	switch (bands) {
 	case WLC_BAND_AUTO:
 		band = wlc_hw->band;
@@ -1448,8 +1427,7 @@ u16 wlc_bmac_mhf_get(struct wlc_hw_info *wlc_hw, u8 idx, int bands)
 		band = wlc_hw->bandstate[BAND_2G_INDEX];
 		break;
 	default:
-		ASSERT(0);
-		band = NULL;
+		band = NULL;		/* error condition */
 	}
 
 	if (!band)
@@ -1490,8 +1468,8 @@ void wlc_bmac_mctrl(struct wlc_hw_info *wlc_hw, u32 mask, u32 val)
 	u32 maccontrol;
 	u32 new_maccontrol;
 
-	ASSERT((val & ~mask) == 0);
-
+	if (val & ~mask)
+		return; /* error condition */
 	maccontrol = wlc_hw->maccontrol;
 	new_maccontrol = (maccontrol & ~mask) | val;
 
@@ -1526,8 +1504,6 @@ static void wlc_mctrl_write(struct wlc_hw_info *wlc_hw)
 
 void wlc_ucode_wake_override_set(struct wlc_hw_info *wlc_hw, u32 override_bit)
 {
-	ASSERT((wlc_hw->wake_override & override_bit) == 0);
-
 	if (wlc_hw->wake_override || (wlc_hw->maccontrol & MCTL_WAKE)) {
 		mboolset(wlc_hw->wake_override, override_bit);
 		return;
@@ -1543,8 +1519,6 @@ void wlc_ucode_wake_override_set(struct wlc_hw_info *wlc_hw, u32 override_bit)
 
 void wlc_ucode_wake_override_clear(struct wlc_hw_info *wlc_hw, u32 override_bit)
 {
-	ASSERT(wlc_hw->wake_override & override_bit);
-
 	mboolclr(wlc_hw->wake_override, override_bit);
 
 	if (wlc_hw->wake_override || (wlc_hw->maccontrol & MCTL_WAKE))
@@ -1635,8 +1609,6 @@ wlc_bmac_set_addrmatch(struct wlc_hw_info *wlc_hw, int match_reg_offset,
 
 	WL_TRACE("wl%d: wlc_bmac_set_addrmatch\n", wlc_hw->unit);
 
-	ASSERT(match_reg_offset < RCM_SIZE);
-
 	regs = wlc_hw->regs;
 	mac_l = addr[0] | (addr[1] << 8);
 	mac_m = addr[2] | (addr[3] << 8);
@@ -1663,11 +1635,6 @@ wlc_bmac_write_template_ram(struct wlc_hw_info *wlc_hw, int offset, int len,
 	WL_TRACE("wl%d: wlc_bmac_write_template_ram\n", wlc_hw->unit);
 
 	regs = wlc_hw->regs;
-
-	ASSERT(IS_ALIGNED(offset, sizeof(u32)));
-	ASSERT(IS_ALIGNED(len, sizeof(u32)));
-	ASSERT((offset & ~0xffff) == 0);
-
 	W_REG(&regs->tplatewrptr, offset);
 
 	/* if MCTL_BIGEND bit set in mac control register,
@@ -1720,8 +1687,6 @@ void wlc_bmac_bw_set(struct wlc_hw_info *wlc_hw, u16 bw)
 
 	wlc_phy_bw_state_set(wlc_hw->band->pi, bw);
 
-	ASSERT(wlc_hw->clk);
-
 	wlc_bmac_phy_reset(wlc_hw);
 	wlc_phy_init(wlc_hw->band->pi, wlc_phy_chanspec_get(wlc_hw->band->pi));
 
@@ -1738,7 +1703,6 @@ wlc_write_hw_bcntemplate0(struct wlc_hw_info *wlc_hw, void *bcn, int len)
 	wlc_bmac_write_template_ram(wlc_hw, T_BCN0_TPL_BASE, (len + 3) & ~3,
 				    bcn);
 	/* write beacon length to SCR */
-	ASSERT(len < 65536);
 	wlc_bmac_write_shm(wlc_hw, M_BCN0_FRM_BYTESZ, (u16) len);
 	/* mark beacon0 valid */
 	OR_REG(&regs->maccommand, MCMD_BCN0VLD);
@@ -1752,7 +1716,6 @@ wlc_write_hw_bcntemplate1(struct wlc_hw_info *wlc_hw, void *bcn, int len)
 	wlc_bmac_write_template_ram(wlc_hw, T_BCN1_TPL_BASE, (len + 3) & ~3,
 				    bcn);
 	/* write beacon length to SCR */
-	ASSERT(len < 65536);
 	wlc_bmac_write_shm(wlc_hw, M_BCN1_FRM_BYTESZ, (u16) len);
 	/* mark beacon1 valid */
 	OR_REG(&regs->maccommand, MCMD_BCN1VLD);
@@ -1776,8 +1739,6 @@ wlc_bmac_write_hw_bcntemplates(struct wlc_hw_info *wlc_hw, void *bcn, int len,
 		else if (!
 			 (R_REG(&regs->maccommand) & MCMD_BCN1VLD))
 			wlc_write_hw_bcntemplate1(wlc_hw, bcn, len);
-		else		/* one template should always have been available */
-			ASSERT(0);
 	}
 }
 
@@ -1807,13 +1768,6 @@ WLBANDINITFN(wlc_bmac_bsinit) (struct wlc_info *wlc, chanspec_t chanspec)
 	WL_TRACE("wl%d: wlc_bmac_bsinit: bandunit %d\n",
 		 wlc_hw->unit, wlc_hw->band->bandunit);
 
-	/* sanity check */
-	if (PHY_TYPE(R_REG(&wlc_hw->regs->phyversion)) !=
-	    PHY_TYPE_LCNXN)
-		ASSERT((uint)
-		       PHY_TYPE(R_REG(&wlc_hw->regs->phyversion))
-		       == wlc_hw->band->phytype);
-
 	wlc_ucode_bsinit(wlc_hw);
 
 	wlc_phy_init(wlc_hw->band->pi, chanspec);
@@ -1955,13 +1909,9 @@ WLBANDINITFN(wlc_bmac_setband) (struct wlc_hw_info *wlc_hw, uint bandunit,
 	struct wlc_info *wlc = wlc_hw->wlc;
 	u32 macintmask;
 
-	ASSERT(NBANDS_HW(wlc_hw) > 1);
-	ASSERT(bandunit != wlc_hw->band->bandunit);
-
 	/* Enable the d11 core before accessing it */
 	if (!ai_iscoreup(wlc_hw->sih)) {
 		ai_core_reset(wlc_hw->sih, 0, 0);
-		ASSERT(ai_iscoreup(wlc_hw->sih));
 		wlc_mctrl_reset(wlc_hw);
 	}
 
@@ -1987,8 +1937,7 @@ WLBANDINITFN(wlc_bmac_setband) (struct wlc_hw_info *wlc_hw, uint bandunit,
 	wl_intrsrestore(wlc->wl, macintmask);
 
 	/* ucode should still be suspended.. */
-	ASSERT((R_REG(&wlc_hw->regs->maccontrol) & MCTL_EN_MAC) ==
-	       0);
+	WARN_ON((R_REG(&wlc_hw->regs->maccontrol) & MCTL_EN_MAC) != 0);
 }
 
 /* low-level band switch utility routine */
@@ -2415,11 +2364,10 @@ static void wlc_coreinit(struct wlc_info *wlc)
 		wiphy_err(wiphy, "wlc_coreinit: txfifo mismatch: ucode size %d"
 			  " driver size %d index %d\n", buf[i],
 			  wlc_hw->xmtfifo_sz[i], i);
-		ASSERT(0);
 	}
 
 	/* make sure we can still talk to the mac */
-	ASSERT(R_REG(&regs->maccontrol) != 0xffffffff);
+	WARN_ON(R_REG(&regs->maccontrol) == 0xffffffff);
 
 	/* band-specific inits done by wlc_bsinit() */
 
@@ -2565,7 +2513,6 @@ static void wlc_gpio_init(struct wlc_info *wlc)
 		wlc_phy_antsel_init(wlc_hw->band->pi, false);
 
 	} else if (wlc_hw->antsel_type == ANTSEL_2x4) {
-		ASSERT((gm & BOARD_GPIO_12) == 0);
 		gm |= gc |= (BOARD_GPIO_12 | BOARD_GPIO_13);
 		/*
 		 * The board itself is powered by these GPIOs
@@ -2633,8 +2580,6 @@ static void wlc_ucode_write(struct wlc_hw_info *wlc_hw, const u32 ucode[],
 
 	WL_TRACE("wl%d: wlc_ucode_write\n", wlc_hw->unit);
 
-	ASSERT(IS_ALIGNED(nbytes, sizeof(u32)));
-
 	count = (nbytes / sizeof(u32));
 
 	W_REG(&regs->objaddr, (OBJADDR_AUTO_INC | OBJADDR_UCM_SEL));
@@ -2654,8 +2599,6 @@ static void wlc_write_inits(struct wlc_hw_info *wlc_hw,
 	base = (volatile u8 *)wlc_hw->regs;
 
 	for (i = 0; inits[i].addr != 0xffff; i++) {
-		ASSERT((inits[i].size == 2) || (inits[i].size == 4));
-
 		if (inits[i].size == 2)
 			W_REG((u16 *)(base + inits[i].addr),
 			      inits[i].value);
@@ -2780,7 +2723,6 @@ void wlc_bmac_fifoerrors(struct wlc_hw_info *wlc_hw)
 void wlc_intrson(struct wlc_info *wlc)
 {
 	struct wlc_hw_info *wlc_hw = wlc->hw;
-	ASSERT(wlc->defmacintmask);
 	wlc->macintmask = wlc->defmacintmask;
 	W_REG(&wlc_hw->regs->macintmask, wlc->macintmask);
 }
@@ -3028,8 +2970,6 @@ bool wlc_intrsupd(struct wlc_info *wlc)
 {
 	u32 macintstatus;
 
-	ASSERT(wlc->macintstatus != 0);
-
 	/* read and clear macintstatus and intstatus registers */
 	macintstatus = wlc_intstatus(wlc, false);
 
@@ -3073,7 +3013,6 @@ bool BCMFASTPATH wlc_isr(struct wlc_info *wlc, bool *wantdpc)
 	*wantdpc = true;
 
 	/* save interrupt status bits */
-	ASSERT(wlc->macintstatus == 0);
 	wlc->macintstatus = macintstatus;
 
 	return true;
@@ -3124,7 +3063,6 @@ wlc_bmac_txstatus(struct wlc_hw_info *wlc_hw, bool bound, bool *fatal)
 		if (s1 == 0xffffffff) {
 			wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n",
 				wlc_hw->unit, __func__);
-			ASSERT(s1 != 0xffffffff);
 			return morepending;
 		}
 
@@ -3183,9 +3121,9 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 		wl_down(wlc->wl);
 		return;
 	}
-	ASSERT(!(mc & MCTL_PSM_JMP_0));
-	ASSERT(mc & MCTL_PSM_RUN);
-	ASSERT(mc & MCTL_EN_MAC);
+	WARN_ON(mc & MCTL_PSM_JMP_0);
+	WARN_ON(!(mc & MCTL_PSM_RUN));
+	WARN_ON(!(mc & MCTL_EN_MAC));
 
 	mi = R_REG(&regs->macintstatus);
 	if (mi == 0xffffffff) {
@@ -3194,7 +3132,7 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 		wl_down(wlc->wl);
 		return;
 	}
-	ASSERT(!(mi & MI_MACSSPNDD));
+	WARN_ON(mi & MI_MACSSPNDD);
 
 	wlc_bmac_mctrl(wlc_hw, MCTL_EN_MAC, 0);
 
@@ -3219,9 +3157,9 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 		wl_down(wlc->wl);
 		return;
 	}
-	ASSERT(!(mc & MCTL_PSM_JMP_0));
-	ASSERT(mc & MCTL_PSM_RUN);
-	ASSERT(!(mc & MCTL_EN_MAC));
+	WARN_ON(mc & MCTL_PSM_JMP_0);
+	WARN_ON(!(mc & MCTL_PSM_RUN));
+	WARN_ON(mc & MCTL_EN_MAC);
 }
 
 void wlc_enable_mac(struct wlc_info *wlc)
@@ -3236,26 +3174,25 @@ void wlc_enable_mac(struct wlc_info *wlc)
 	/*
 	 * Track overlapping suspend requests
 	 */
-	ASSERT(wlc_hw->mac_suspend_depth > 0);
 	wlc_hw->mac_suspend_depth--;
 	if (wlc_hw->mac_suspend_depth > 0)
 		return;
 
 	mc = R_REG(&regs->maccontrol);
-	ASSERT(!(mc & MCTL_PSM_JMP_0));
-	ASSERT(!(mc & MCTL_EN_MAC));
-	ASSERT(mc & MCTL_PSM_RUN);
+	WARN_ON(mc & MCTL_PSM_JMP_0);
+	WARN_ON(mc & MCTL_EN_MAC);
+	WARN_ON(!(mc & MCTL_PSM_RUN));
 
 	wlc_bmac_mctrl(wlc_hw, MCTL_EN_MAC, MCTL_EN_MAC);
 	W_REG(&regs->macintstatus, MI_MACSSPNDD);
 
 	mc = R_REG(&regs->maccontrol);
-	ASSERT(!(mc & MCTL_PSM_JMP_0));
-	ASSERT(mc & MCTL_EN_MAC);
-	ASSERT(mc & MCTL_PSM_RUN);
+	WARN_ON(mc & MCTL_PSM_JMP_0);
+	WARN_ON(!(mc & MCTL_EN_MAC));
+	WARN_ON(!(mc & MCTL_PSM_RUN));
 
 	mi = R_REG(&regs->macintstatus);
-	ASSERT(!(mi & MI_MACSSPNDD));
+	WARN_ON(mi & MI_MACSSPNDD);
 
 	wlc_ucode_wake_override_clear(wlc_hw, WLC_WAKE_OVERRIDE_MACSUSPEND);
 }
@@ -3437,7 +3374,6 @@ void wlc_bmac_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on)
 			    (CCS_ERSRC_AVAIL_HT)) {
 				wiphy_err(wlc_hw->wlc->wiphy, "%s: turn on PHY"
 					  " PLL failed\n", __func__);
-				ASSERT(0);
 			}
 		} else {
 			OR_REG(&regs->clk_ctl_st,
@@ -3455,7 +3391,6 @@ void wlc_bmac_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on)
 			    (CCS_ERSRC_AVAIL_D11PLL | CCS_ERSRC_AVAIL_PHYPLL)) {
 				wiphy_err(wlc_hw->wlc->wiphy, "%s: turn on "
 					  "PHY PLL failed\n", __func__);
-				ASSERT(0);
 			}
 		}
 	} else {
@@ -3473,8 +3408,6 @@ void wlc_coredisable(struct wlc_hw_info *wlc_hw)
 
 	WL_TRACE("wl%d: %s\n", wlc_hw->unit, __func__);
 
-	ASSERT(!wlc_hw->up);
-
 	dev_gone = DEVICEREMOVED(wlc_hw->wlc);
 
 	if (dev_gone)
@@ -3564,11 +3497,7 @@ void wlc_bmac_set_shm(struct wlc_hw_info *wlc_hw, uint offset, u16 v, int len)
 {
 	int i;
 
-	/* offset and len need to be even */
-	ASSERT((offset & 1) == 0);
-	ASSERT((len & 1) == 0);
-
-	if (len <= 0)
+	if (len <= 0 || (offset & 1) || (len & 1))
 		return;
 
 	for (i = 0; i < len; i += 2) {
@@ -3584,8 +3513,6 @@ wlc_bmac_read_objmem(struct wlc_hw_info *wlc_hw, uint offset, u32 sel)
 	volatile u16 *objdata_hi = objdata_lo + 1;
 	u16 v;
 
-	ASSERT((offset & 1) == 0);
-
 	W_REG(&regs->objaddr, sel | (offset >> 2));
 	(void)R_REG(&regs->objaddr);
 	if (offset & 2) {
@@ -3604,8 +3531,6 @@ wlc_bmac_write_objmem(struct wlc_hw_info *wlc_hw, uint offset, u16 v, u32 sel)
 	volatile u16 *objdata_lo = (volatile u16 *)&regs->objdata;
 	volatile u16 *objdata_hi = objdata_lo + 1;
 
-	ASSERT((offset & 1) == 0);
-
 	W_REG(&regs->objaddr, sel | (offset >> 2));
 	(void)R_REG(&regs->objaddr);
 	if (offset & 2) {
@@ -3628,11 +3553,7 @@ wlc_bmac_copyto_objmem(struct wlc_hw_info *wlc_hw, uint offset, const void *buf,
 	const u8 *p = (const u8 *)buf;
 	int i;
 
-	/* offset and len need to be even */
-	ASSERT((offset & 1) == 0);
-	ASSERT((len & 1) == 0);
-
-	if (len <= 0)
+	if (len <= 0 || (offset & 1) || (len & 1))
 		return;
 
 	for (i = 0; i < len; i += 2) {
@@ -3654,11 +3575,7 @@ wlc_bmac_copyfrom_objmem(struct wlc_hw_info *wlc_hw, uint offset, void *buf,
 	u8 *p = (u8 *) buf;
 	int i;
 
-	/* offset and len need to be even */
-	ASSERT((offset & 1) == 0);
-	ASSERT((len & 1) == 0);
-
-	if (len <= 0)
+	if (len <= 0 || (offset & 1) || (len & 1))
 		return;
 
 	for (i = 0; i < len; i += 2) {
@@ -3702,8 +3619,6 @@ void wlc_bmac_set_noreset(struct wlc_hw_info *wlc_hw, bool noreset_flag)
 
 void wlc_bmac_pllreq(struct wlc_hw_info *wlc_hw, bool set, mbool req_bit)
 {
-	ASSERT(req_bit);
-
 	if (set) {
 		if (mboolisset(wlc_hw->pllreq, req_bit))
 			return;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index af51f16..c70ee52 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -602,58 +602,6 @@ void wlc_mac_promisc(struct wlc_info *wlc)
 	wlc_mctrl(wlc, MCTL_PROMISC | MCTL_KEEPCONTROL, promisc_bits);
 }
 
-/* check if hps and wake states of sw and hw are in sync */
-bool wlc_ps_check(struct wlc_info *wlc)
-{
-	bool res = true;
-	bool hps, wake;
-	bool wake_ok;
-
-	if (!AP_ACTIVE(wlc)) {
-		u32 tmp;
-		tmp = R_REG(&wlc->regs->maccontrol);
-
-		/*
-		 * If deviceremoved is detected, then don't take any action as
-		 * this can be called in any context. Assume that caller will
-		 * take care of the condition. This is just to avoid assert
-		 */
-		if (tmp == 0xffffffff) {
-			wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n",
-				  wlc->pub->unit, __func__);
-			return DEVICEREMOVED(wlc);
-		}
-
-		hps = PS_ALLOWED(wlc);
-
-		if (hps != ((tmp & MCTL_HPS) != 0)) {
-			int idx;
-			struct wlc_bsscfg *cfg;
-			wiphy_err(wlc->wiphy, "wl%d: hps not sync, sw %d, "
-				  "maccontrol 0x%x\n",
-				  wlc->pub->unit, hps, tmp);
-			FOREACH_BSS(wlc, idx, cfg) {
-				if (!BSSCFG_STA(cfg))
-					continue;
-			}
-
-			res = false;
-		}
-		/* For a monolithic build the wake check can be exact since it looks at wake
-		 * override bits. The MCTL_WAKE bit should match the 'wake' value.
-		 */
-		wake = STAY_AWAKE(wlc) || wlc->hw->wake_override;
-		wake_ok = (wake == ((tmp & MCTL_WAKE) != 0));
-		if (hps && !wake_ok) {
-			wiphy_err(wlc->wiphy, "wl%d: wake not sync, sw %d "
-				  "maccontrol 0x%x\n",
-				  wlc->pub->unit, wake, tmp);
-			res = false;
-		}
-	}
-	return res;
-}
-
 /* push sw hps and wake state through hardware */
 void wlc_set_ps_ctrl(struct wlc_info *wlc)
 {
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index a5e0f5d..6dc029e 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -881,7 +881,6 @@ extern void wlc_dump_ie(struct wlc_info *wlc, bcm_tlv_t *ie,
 			struct bcmstrbuf *b);
 #endif
 
-extern bool wlc_ps_check(struct wlc_info *wlc);
 extern void wlc_reprate_init(struct wlc_info *wlc);
 extern void wlc_bsscfg_reprate_init(struct wlc_bsscfg *bsscfg);
 extern void wlc_uint64_sub(u32 *a_high, u32 *a_low, u32 b_high,
-- 
1.7.4.1


