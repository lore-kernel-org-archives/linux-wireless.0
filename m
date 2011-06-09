Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4691 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739Ab1FIOpT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:19 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 13/21] staging: brcm80211: replaced bmac acronym by
 brcms_b_
Date: Thu, 9 Jun 2011 16:44:53 +0200
Message-ID: <1307630701-9170-14-git-send-email-rvossen@broadcom.com> (sfid-20110609_164549_645736_CAD6F9E3)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/antsel.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/bmac.c     |  471 ++++++++++++-------------
 drivers/staging/brcm80211/brcmsmac/bmac.h     |  110 +++---
 drivers/staging/brcm80211/brcmsmac/channel.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.c     |   95 +++---
 drivers/staging/brcm80211/brcmsmac/phy_shim.c |   34 +-
 drivers/staging/brcm80211/brcmsmac/stf.c      |    6 +-
 drivers/staging/brcm80211/brcmsmac/types.h    |    2 +-
 8 files changed, 360 insertions(+), 362 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index 5356e2a..b18c85b 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -136,7 +136,7 @@ struct antsel_info *wlc_antsel_attach(struct wlc_info *wlc)
 	}
 
 	/* Set the antenna selection type for the low driver */
-	wlc_bmac_antsel_type_set(wlc->hw, asi->antsel_type);
+	brcms_b_antsel_type_set(wlc->hw, asi->antsel_type);
 
 	/* Init (auto/manual) antenna selection */
 	wlc_antsel_init_cfg(asi, &asi->antcfg_11n, true);
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index 9d6ee5d..ccd9cb5 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -71,8 +71,8 @@ static u16 xmtfifo_sz[][NFIFO] = {
 	{9, 58, 22, 14, 14, 5},	/* corerev 24: 2304, 14848, 5632, 3584, 3584, 1280 */
 };
 
-static void wlc_clkctl_clk(struct wlc_hw_info *wlc, uint mode);
-static void wlc_coreinit(struct wlc_info *wlc);
+static void brcms_b_clkctl_clk(struct wlc_hw_info *wlc, uint mode);
+static void brcms_b_coreinit(struct wlc_info *wlc);
 
 /* used by wlc_wakeucode_init() */
 static void wlc_write_inits(struct wlc_hw_info *wlc_hw,
@@ -83,41 +83,41 @@ static void wlc_ucode_download(struct wlc_hw_info *wlc);
 static void wlc_ucode_txant_set(struct wlc_hw_info *wlc_hw);
 
 /* used by wlc_dpc() */
-static bool wlc_bmac_dotxstatus(struct wlc_hw_info *wlc, tx_status_t *txs,
+static bool brcms_b_dotxstatus(struct wlc_hw_info *wlc, tx_status_t *txs,
 				u32 s2);
-static bool wlc_bmac_txstatus(struct wlc_hw_info *wlc, bool bound, bool *fatal);
-static bool wlc_bmac_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound);
+static bool brcms_b_txstatus(struct wlc_hw_info *wlc, bool bound, bool *fatal);
+static bool brcms_b_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound);
 
 /* used by wlc_down() */
 static void wlc_flushqueues(struct wlc_info *wlc);
 
 static void wlc_write_mhf(struct wlc_hw_info *wlc_hw, u16 *mhfs);
 static void wlc_mctrl_reset(struct wlc_hw_info *wlc_hw);
-static void wlc_corerev_fifofixup(struct wlc_hw_info *wlc_hw);
-static bool wlc_bmac_tx_fifo_suspended(struct wlc_hw_info *wlc_hw,
+static void brcms_b_corerev_fifofixup(struct wlc_hw_info *wlc_hw);
+static bool brcms_b_tx_fifo_suspended(struct wlc_hw_info *wlc_hw,
 				       uint tx_fifo);
-static void wlc_bmac_tx_fifo_suspend(struct wlc_hw_info *wlc_hw, uint tx_fifo);
-static void wlc_bmac_tx_fifo_resume(struct wlc_hw_info *wlc_hw, uint tx_fifo);
+static void brcms_b_tx_fifo_suspend(struct wlc_hw_info *wlc_hw, uint tx_fifo);
+static void brcms_b_tx_fifo_resume(struct wlc_hw_info *wlc_hw, uint tx_fifo);
 
 /* Low Level Prototypes */
-static int wlc_bmac_bandtype(struct wlc_hw_info *wlc_hw);
-static void wlc_bmac_info_init(struct wlc_hw_info *wlc_hw);
-static void wlc_bmac_xtal(struct wlc_hw_info *wlc_hw, bool want);
-static u16 wlc_bmac_read_objmem(struct wlc_hw_info *wlc_hw, uint offset,
+static int brcms_b_bandtype(struct wlc_hw_info *wlc_hw);
+static void brcms_b_info_init(struct wlc_hw_info *wlc_hw);
+static void brcms_b_xtal(struct wlc_hw_info *wlc_hw, bool want);
+static u16 brcms_b_read_objmem(struct wlc_hw_info *wlc_hw, uint offset,
 				   u32 sel);
-static void wlc_bmac_write_objmem(struct wlc_hw_info *wlc_hw, uint offset,
+static void brcms_b_write_objmem(struct wlc_hw_info *wlc_hw, uint offset,
 				  u16 v, u32 sel);
-static void wlc_bmac_core_phy_clk(struct wlc_hw_info *wlc_hw, bool clk);
-static bool wlc_bmac_attach_dmapio(struct wlc_info *wlc, uint j, bool wme);
-static void wlc_bmac_detach_dmapio(struct wlc_hw_info *wlc_hw);
+static void brcms_b_core_phy_clk(struct wlc_hw_info *wlc_hw, bool clk);
+static bool brcms_b_attach_dmapio(struct wlc_info *wlc, uint j, bool wme);
+static void brcms_b_detach_dmapio(struct wlc_hw_info *wlc_hw);
 static void wlc_ucode_bsinit(struct wlc_hw_info *wlc_hw);
 static bool wlc_validboardtype(struct wlc_hw_info *wlc);
 static bool wlc_isgoodchip(struct wlc_hw_info *wlc_hw);
-static bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw);
+static bool brcms_b_validate_chip_access(struct wlc_hw_info *wlc_hw);
 static char *wlc_get_macaddr(struct wlc_hw_info *wlc_hw);
 static void wlc_mhfdef(struct wlc_info *wlc, u16 *mhfs, u16 mhf2_init);
 static void wlc_mctrl_write(struct wlc_hw_info *wlc_hw);
-static void wlc_bmac_mute(struct wlc_hw_info *wlc_hw, bool want, mbool flags);
+static void brcms_b_mute(struct wlc_hw_info *wlc_hw, bool want, mbool flags);
 static void wlc_ucode_mute_override_set(struct wlc_hw_info *wlc_hw);
 static void wlc_ucode_mute_override_clear(struct wlc_hw_info *wlc_hw);
 static u32 wlc_wlintrsoff(struct wlc_info *wlc);
@@ -127,25 +127,25 @@ static void wlc_write_hw_bcntemplate0(struct wlc_hw_info *wlc_hw, void *bcn,
 				      int len);
 static void wlc_write_hw_bcntemplate1(struct wlc_hw_info *wlc_hw, void *bcn,
 				      int len);
-static void wlc_bmac_bsinit(struct wlc_info *wlc, chanspec_t chanspec);
+static void brcms_b_bsinit(struct wlc_info *wlc, chanspec_t chanspec);
 static u32 wlc_setband_inact(struct wlc_info *wlc, uint bandunit);
-static void wlc_bmac_setband(struct wlc_hw_info *wlc_hw, uint bandunit,
+static void brcms_b_setband(struct wlc_hw_info *wlc_hw, uint bandunit,
 			     chanspec_t chanspec);
-static void wlc_bmac_update_slot_timing(struct wlc_hw_info *wlc_hw,
+static void brcms_b_update_slot_timing(struct wlc_hw_info *wlc_hw,
 					bool shortslot);
 static void wlc_upd_ofdm_pctl1_table(struct wlc_hw_info *wlc_hw);
-static u16 wlc_bmac_ofdm_ratetable_offset(struct wlc_hw_info *wlc_hw,
+static u16 brcms_b_ofdm_ratetable_offset(struct wlc_hw_info *wlc_hw,
 					     u8 rate);
 
 /* === Low Level functions === */
 
-void wlc_bmac_set_shortslot(struct wlc_hw_info *wlc_hw, bool shortslot)
+void brcms_b_set_shortslot(struct wlc_hw_info *wlc_hw, bool shortslot)
 {
 	wlc_hw->shortslot = shortslot;
 
-	if (BAND_2G(wlc_bmac_bandtype(wlc_hw)) && wlc_hw->up) {
+	if (BAND_2G(brcms_b_bandtype(wlc_hw)) && wlc_hw->up) {
 		wlc_suspend_mac_and_wait(wlc_hw->wlc);
-		wlc_bmac_update_slot_timing(wlc_hw, shortslot);
+		brcms_b_update_slot_timing(wlc_hw, shortslot);
 		wlc_enable_mac(wlc_hw->wlc);
 	}
 }
@@ -155,7 +155,7 @@ void wlc_bmac_set_shortslot(struct wlc_hw_info *wlc_hw, bool shortslot)
  * or shortslot 11g (9us slots)
  * The PSM needs to be suspended for this call.
  */
-static void wlc_bmac_update_slot_timing(struct wlc_hw_info *wlc_hw,
+static void brcms_b_update_slot_timing(struct wlc_hw_info *wlc_hw,
 					bool shortslot)
 {
 	d11regs_t *regs;
@@ -165,11 +165,11 @@ static void wlc_bmac_update_slot_timing(struct wlc_hw_info *wlc_hw,
 	if (shortslot) {
 		/* 11g short slot: 11a timing */
 		W_REG(&regs->ifs_slot, 0x0207);	/* APHY_SLOT_TIME */
-		wlc_bmac_write_shm(wlc_hw, M_DOT11_SLOT, APHY_SLOT_TIME);
+		brcms_b_write_shm(wlc_hw, M_DOT11_SLOT, APHY_SLOT_TIME);
 	} else {
 		/* 11g long slot: 11b timing */
 		W_REG(&regs->ifs_slot, 0x0212);	/* BPHY_SLOT_TIME */
-		wlc_bmac_write_shm(wlc_hw, M_DOT11_SLOT, BPHY_SLOT_TIME);
+		brcms_b_write_shm(wlc_hw, M_DOT11_SLOT, BPHY_SLOT_TIME);
 	}
 }
 
@@ -220,7 +220,7 @@ static u32 WLBANDINITFN(wlc_setband_inact) (struct wlc_info *wlc, uint bandunit)
 	/* radio off */
 	wlc_phy_switch_radio(wlc_hw->band->pi, OFF);
 
-	wlc_bmac_core_phy_clk(wlc_hw, OFF);
+	brcms_b_core_phy_clk(wlc_hw, OFF);
 
 	wlc_setxband(wlc_hw, bandunit);
 
@@ -233,7 +233,7 @@ static u32 WLBANDINITFN(wlc_setband_inact) (struct wlc_info *wlc, uint bandunit)
  * Param 'bound' indicates max. # frames to process before break out.
  */
 static bool
-wlc_bmac_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound)
+brcms_b_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound)
 {
 	struct sk_buff *p;
 	struct sk_buff *head = NULL;
@@ -318,7 +318,7 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 
 	/* tx status */
 	if (macintstatus & MI_TFS) {
-		if (wlc_bmac_txstatus(wlc->hw, bounded, &fatal))
+		if (brcms_b_txstatus(wlc->hw, bounded, &fatal))
 			wlc->macintstatus |= MI_TFS;
 		if (fatal) {
 			wiphy_err(wiphy, "MI_TFS: fatal\n");
@@ -337,18 +337,13 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 	}
 
 	/* received data or control frame, MI_DMAINT is indication of RX_FIFO interrupt */
-	if (macintstatus & MI_DMAINT) {
-		if (wlc_bmac_recv(wlc_hw, RX_FIFO, bounded)) {
+	if (macintstatus & MI_DMAINT)
+		if (brcms_b_recv(wlc_hw, RX_FIFO, bounded))
 			wlc->macintstatus |= MI_DMAINT;
-		}
-	}
 
 	/* TX FIFO suspend/flush completion */
-	if (macintstatus & MI_TXSTOP) {
-		if (wlc_bmac_tx_fifo_suspended(wlc_hw, TX_DATA_FIFO)) {
-			/* wiphy_err(wiphy, "dpc: fifo_suspend_comlete\n"); */
-		}
-	}
+	if (macintstatus & MI_TXSTOP)
+		if (brcms_b_tx_fifo_suspended(wlc_hw, TX_DATA_FIFO));
 
 	/* noise sample collected */
 	if (macintstatus & MI_BG_NOISE) {
@@ -390,7 +385,7 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 }
 
 /* common low-level watchdog code */
-void wlc_bmac_watchdog(void *arg)
+void brcms_b_watchdog(void *arg)
 {
 	struct wlc_info *wlc = (struct wlc_info *) arg;
 	struct wlc_hw_info *wlc_hw = wlc->hw;
@@ -404,7 +399,7 @@ void wlc_bmac_watchdog(void *arg)
 	wlc_hw->now++;
 
 	/* Check for FIFO error interrupts */
-	wlc_bmac_fifoerrors(wlc_hw);
+	brcms_b_fifoerrors(wlc_hw);
 
 	/* make sure RX dma has buffers */
 	dma_rxfill(wlc->hw->di[RX_FIFO]);
@@ -413,7 +408,7 @@ void wlc_bmac_watchdog(void *arg)
 }
 
 void
-wlc_bmac_set_chanspec(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
+brcms_b_set_chanspec(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 		      bool mute, struct txpwr_limits *txpwr)
 {
 	uint bandunit;
@@ -426,14 +421,14 @@ wlc_bmac_set_chanspec(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 	if (NBANDS_HW(wlc_hw) > 1) {
 		bandunit = CHSPEC_WLCBANDUNIT(chanspec);
 		if (wlc_hw->band->bandunit != bandunit) {
-			/* wlc_bmac_setband disables other bandunit,
+			/* brcms_b_setband disables other bandunit,
 			 *  use light band switch if not up yet
 			 */
 			if (wlc_hw->up) {
 				wlc_phy_chanspec_radio_set(wlc_hw->
 							   bandstate[bandunit]->
 							   pi, chanspec);
-				wlc_bmac_setband(wlc_hw, bandunit, chanspec);
+				brcms_b_setband(wlc_hw, bandunit, chanspec);
 			} else {
 				wlc_setxband(wlc_hw, bandunit);
 			}
@@ -452,18 +447,18 @@ wlc_bmac_set_chanspec(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 		wlc_phy_txpower_limit_set(wlc_hw->band->pi, txpwr, chanspec);
 
 		/* Update muting of the channel */
-		wlc_bmac_mute(wlc_hw, mute, 0);
+		brcms_b_mute(wlc_hw, mute, 0);
 	}
 }
 
-int wlc_bmac_state_get(struct wlc_hw_info *wlc_hw, wlc_bmac_state_t *state)
+int brcms_b_state_get(struct wlc_hw_info *wlc_hw, brcms_b_state_t *state)
 {
 	state->machwcap = wlc_hw->machwcap;
 
 	return 0;
 }
 
-static bool wlc_bmac_attach_dmapio(struct wlc_info *wlc, uint j, bool wme)
+static bool brcms_b_attach_dmapio(struct wlc_info *wlc, uint j, bool wme)
 {
 	uint i;
 	char name[8];
@@ -560,7 +555,7 @@ static bool wlc_bmac_attach_dmapio(struct wlc_info *wlc, uint j, bool wme)
 	return true;
 }
 
-static void wlc_bmac_detach_dmapio(struct wlc_hw_info *wlc_hw)
+static void brcms_b_detach_dmapio(struct wlc_hw_info *wlc_hw)
 {
 	uint j;
 
@@ -578,7 +573,7 @@ static void wlc_bmac_detach_dmapio(struct wlc_hw_info *wlc_hw)
  *    initialize software state for each core and band
  *    put the whole chip in reset(driver down state), no clock
  */
-int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
+int brcms_b_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		    bool piomode, void *regsva, uint bustype, void *btparam)
 {
 	struct wlc_hw_info *wlc_hw;
@@ -603,7 +598,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc_hw->_piomode = piomode;
 
 	/* populate struct wlc_hw_info with default values  */
-	wlc_bmac_info_init(wlc_hw);
+	brcms_b_info_init(wlc_hw);
 
 	/*
 	 * Do the hardware portion of the attach.
@@ -613,7 +608,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc_hw->sih = ai_attach(regsva, bustype, btparam,
 				&wlc_hw->vars, &wlc_hw->vars_size);
 	if (wlc_hw->sih == NULL) {
-		wiphy_err(wiphy, "wl%d: wlc_bmac_attach: si_attach failed\n",
+		wiphy_err(wiphy, "wl%d: brcms_b_attach: si_attach failed\n",
 			  unit);
 		err = 11;
 		goto fail;
@@ -649,7 +644,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 
 		/* verify again the device is supported */
 		if (!wlc_chipmatch(vendor, device)) {
-			wiphy_err(wiphy, "wl%d: wlc_bmac_attach: Unsupported "
+			wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported "
 				"vendor/device (0x%x/0x%x)\n",
 				 unit, vendor, device);
 			err = 12;
@@ -682,11 +677,11 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	 *   For PMU chips, the first wlc_clkctl_clk is no-op since core-clk is still false;
 	 *   But it will be called again inside wlc_corereset, after d11 is out of reset.
 	 */
-	wlc_clkctl_clk(wlc_hw, CLK_FAST);
-	wlc_bmac_corereset(wlc_hw, WLC_USE_COREFLAGS);
+	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
+	brcms_b_corereset(wlc_hw, WLC_USE_COREFLAGS);
 
-	if (!wlc_bmac_validate_chip_access(wlc_hw)) {
-		wiphy_err(wiphy, "wl%d: wlc_bmac_attach: validate_chip_access "
+	if (!brcms_b_validate_chip_access(wlc_hw)) {
+		wiphy_err(wiphy, "wl%d: brcms_b_attach: validate_chip_access "
 			"failed\n", unit);
 		err = 14;
 		goto fail;
@@ -699,7 +694,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		j = BOARDREV_PROMOTED;
 	wlc_hw->boardrev = (u16) j;
 	if (!wlc_validboardtype(wlc_hw)) {
-		wiphy_err(wiphy, "wl%d: wlc_bmac_attach: Unsupported Broadcom "
+		wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported Broadcom "
 			"board type (0x%x)" " or revision level (0x%x)\n",
 			 unit, wlc_hw->sih->boardtype, wlc_hw->boardrev);
 		err = 15;
@@ -710,7 +705,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc_hw->boardflags2 = (u32) getintvar(vars, "boardflags2");
 
 	if (wlc_hw->boardflags & BFL_NOPLLDOWN)
-		wlc_bmac_pllreq(wlc_hw, true, WLC_PLLREQ_SHARED);
+		brcms_b_pllreq(wlc_hw, true, WLC_PLLREQ_SHARED);
 
 	if ((wlc_hw->sih->bustype == PCI_BUS)
 	    && (ai_pci_war16165(wlc_hw->sih)))
@@ -743,7 +738,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc_hw->physhim = wlc_phy_shim_attach(wlc_hw, wlc->wl, wlc);
 
 	if (wlc_hw->physhim == NULL) {
-		wiphy_err(wiphy, "wl%d: wlc_bmac_attach: wlc_phy_shim_attach "
+		wiphy_err(wiphy, "wl%d: brcms_b_attach: wlc_phy_shim_attach "
 			"failed\n", unit);
 		err = 25;
 		goto fail;
@@ -804,10 +799,10 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 
 		/* Get a phy for this band */
 		wlc_hw->band->pi = wlc_phy_attach(wlc_hw->phy_sh,
-			(void *)regs, wlc_bmac_bandtype(wlc_hw), vars,
+			(void *)regs, brcms_b_bandtype(wlc_hw), vars,
 			wlc->wiphy);
 		if (wlc_hw->band->pi == NULL) {
-			wiphy_err(wiphy, "wl%d: wlc_bmac_attach: wlc_phy_"
+			wiphy_err(wiphy, "wl%d: brcms_b_attach: wlc_phy_"
 				  "attach failed\n", unit);
 			err = 17;
 			goto fail;
@@ -838,7 +833,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 				goto bad_phy;
 		} else {
  bad_phy:
-			wiphy_err(wiphy, "wl%d: wlc_bmac_attach: unsupported "
+			wiphy_err(wiphy, "wl%d: brcms_b_attach: unsupported "
 				  "phy type/rev (%d/%d)\n", unit,
 				  wlc_hw->band->phytype, wlc_hw->band->phyrev);
 			err = 18;
@@ -862,7 +857,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		wlc_hw->band->CWmin = APHY_CWMIN;
 		wlc_hw->band->CWmax = PHY_CWMAX;
 
-		if (!wlc_bmac_attach_dmapio(wlc, j, wme)) {
+		if (!brcms_b_attach_dmapio(wlc, j, wme)) {
 			err = 19;
 			goto fail;
 		}
@@ -880,7 +875,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 				  (void *)wlc_wlintrsrestore, NULL, wlc);
 
 	/* turn off pll and xtal to match driver "down" state */
-	wlc_bmac_xtal(wlc_hw, OFF);
+	brcms_b_xtal(wlc_hw, OFF);
 
 	/* *********************************************************************
 	 * The hardware is in the DOWN state at this point. D11 core
@@ -895,7 +890,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	/* init etheraddr state variables */
 	macaddr = wlc_get_macaddr(wlc_hw);
 	if (macaddr == NULL) {
-		wiphy_err(wiphy, "wl%d: wlc_bmac_attach: macaddr not found\n",
+		wiphy_err(wiphy, "wl%d: brcms_b_attach: macaddr not found\n",
 			  unit);
 		err = 21;
 		goto fail;
@@ -903,7 +898,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	brcmu_ether_atoe(macaddr, wlc_hw->etheraddr);
 	if (is_broadcast_ether_addr(wlc_hw->etheraddr) ||
 	    is_zero_ether_addr(wlc_hw->etheraddr)) {
-		wiphy_err(wiphy, "wl%d: wlc_bmac_attach: bad macaddr %s\n",
+		wiphy_err(wiphy, "wl%d: brcms_b_attach: bad macaddr %s\n",
 			  unit, macaddr);
 		err = 22;
 		goto fail;
@@ -917,7 +912,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	return err;
 
  fail:
-	wiphy_err(wiphy, "wl%d: wlc_bmac_attach: failed with err %d\n", unit,
+	wiphy_err(wiphy, "wl%d: brcms_b_attach: failed with err %d\n", unit,
 		  err);
 	return err;
 }
@@ -927,7 +922,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
  * may get overrides later in this function
  *  BMAC_NOTES, move low out and resolve the dangling ones
  */
-static void wlc_bmac_info_init(struct wlc_hw_info *wlc_hw)
+static void brcms_b_info_init(struct wlc_hw_info *wlc_hw)
 {
 	struct wlc_info *wlc = wlc_hw->wlc;
 
@@ -949,7 +944,7 @@ static void wlc_bmac_info_init(struct wlc_hw_info *wlc_hw)
 /*
  * low level detach
  */
-int wlc_bmac_detach(struct wlc_info *wlc)
+int brcms_b_detach(struct wlc_info *wlc)
 {
 	uint i;
 	struct wlc_hwband *band;
@@ -968,7 +963,7 @@ int wlc_bmac_detach(struct wlc_info *wlc)
 			ai_pci_sleep(wlc_hw->sih);
 	}
 
-	wlc_bmac_detach_dmapio(wlc_hw);
+	brcms_b_detach_dmapio(wlc_hw);
 
 	band = wlc_hw->band;
 	for (i = 0; i < NBANDS_HW(wlc_hw); i++) {
@@ -998,13 +993,13 @@ int wlc_bmac_detach(struct wlc_info *wlc)
 
 }
 
-void wlc_bmac_reset(struct wlc_hw_info *wlc_hw)
+void brcms_b_reset(struct wlc_hw_info *wlc_hw)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	/* reset the core */
 	if (!DEVICEREMOVED(wlc_hw->wlc))
-		wlc_bmac_corereset(wlc_hw, WLC_USE_COREFLAGS);
+		brcms_b_corereset(wlc_hw, WLC_USE_COREFLAGS);
 
 	/* purge the dma rings */
 	wlc_flushqueues(wlc_hw->wlc);
@@ -1013,7 +1008,7 @@ void wlc_bmac_reset(struct wlc_hw_info *wlc_hw)
 }
 
 void
-wlc_bmac_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
+brcms_b_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 			  bool mute) {
 	u32 macintmask;
 	bool fastclk;
@@ -1024,7 +1019,7 @@ wlc_bmac_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 	/* request FAST clock if not on */
 	fastclk = wlc_hw->forcefastclk;
 	if (!fastclk)
-		wlc_clkctl_clk(wlc_hw, CLK_FAST);
+		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
 
 	/* disable interrupts */
 	macintmask = brcms_intrsoff(wlc->wl);
@@ -1037,14 +1032,14 @@ wlc_bmac_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 	wlc_phy_cal_init(wlc_hw->band->pi);
 
 	/* core-specific initialization */
-	wlc_coreinit(wlc);
+	brcms_b_coreinit(wlc);
 
 	/* suspend the tx fifos and mute the phy for preism cac time */
 	if (mute)
-		wlc_bmac_mute(wlc_hw, ON, PHY_MUTE_FOR_PREISM);
+		brcms_b_mute(wlc_hw, ON, PHY_MUTE_FOR_PREISM);
 
 	/* band-specific inits */
-	wlc_bmac_bsinit(wlc, chanspec);
+	brcms_b_bsinit(wlc, chanspec);
 
 	/* restore macintmask */
 	brcms_intrsrestore(wlc->wl, macintmask);
@@ -1061,10 +1056,10 @@ wlc_bmac_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 
 	/* restore the clk */
 	if (!fastclk)
-		wlc_clkctl_clk(wlc_hw, CLK_DYNAMIC);
+		brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
 }
 
-int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
+int brcms_b_up_prep(struct wlc_hw_info *wlc_hw)
 {
 	uint coremask;
 
@@ -1074,9 +1069,9 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 	 * Enable pll and xtal, initialize the power control registers,
 	 * and force fastclock for the remainder of wlc_up().
 	 */
-	wlc_bmac_xtal(wlc_hw, ON);
+	brcms_b_xtal(wlc_hw, ON);
 	ai_clkctl_init(wlc_hw->sih);
-	wlc_clkctl_clk(wlc_hw, CLK_FAST);
+	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
 
 	/*
 	 * Configure pci/pcmcia here instead of in wlc_attach()
@@ -1091,11 +1086,11 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 	 * Need to read the hwradio status here to cover the case where the system
 	 * is loaded with the hw radio disabled. We do not want to bring the driver up in this case.
 	 */
-	if (wlc_bmac_radio_read_hwdisabled(wlc_hw)) {
+	if (brcms_b_radio_read_hwdisabled(wlc_hw)) {
 		/* put SB PCI in down state again */
 		if (wlc_hw->sih->bustype == PCI_BUS)
 			ai_pci_down(wlc_hw->sih);
-		wlc_bmac_xtal(wlc_hw, OFF);
+		brcms_b_xtal(wlc_hw, OFF);
 		return -ENOMEDIUM;
 	}
 
@@ -1103,12 +1098,12 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 		ai_pci_up(wlc_hw->sih);
 
 	/* reset the d11 core */
-	wlc_bmac_corereset(wlc_hw, WLC_USE_COREFLAGS);
+	brcms_b_corereset(wlc_hw, WLC_USE_COREFLAGS);
 
 	return 0;
 }
 
-int wlc_bmac_up_finish(struct wlc_hw_info *wlc_hw)
+int brcms_b_up_finish(struct wlc_hw_info *wlc_hw)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
@@ -1116,12 +1111,12 @@ int wlc_bmac_up_finish(struct wlc_hw_info *wlc_hw)
 	wlc_phy_hw_state_upd(wlc_hw->band->pi, true);
 
 	/* FULLY enable dynamic power control and d11 core interrupt */
-	wlc_clkctl_clk(wlc_hw, CLK_DYNAMIC);
+	brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
 	brcms_intrson(wlc_hw->wlc->wl);
 	return 0;
 }
 
-int wlc_bmac_down_prep(struct wlc_hw_info *wlc_hw)
+int brcms_b_bmac_down_prep(struct wlc_hw_info *wlc_hw)
 {
 	bool dev_gone;
 	uint callbacks = 0;
@@ -1141,7 +1136,7 @@ int wlc_bmac_down_prep(struct wlc_hw_info *wlc_hw)
 		brcms_intrsoff(wlc_hw->wlc->wl);
 
 		/* ensure we're running on the pll clock again */
-		wlc_clkctl_clk(wlc_hw, CLK_FAST);
+		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
 	}
 	/* down phy at the last of this stage */
 	callbacks += wlc_phy_down(wlc_hw->band->pi);
@@ -1149,7 +1144,7 @@ int wlc_bmac_down_prep(struct wlc_hw_info *wlc_hw)
 	return callbacks;
 }
 
-int wlc_bmac_down_finish(struct wlc_hw_info *wlc_hw)
+int brcms_b_down_finish(struct wlc_hw_info *wlc_hw)
 {
 	uint callbacks = 0;
 	bool dev_gone;
@@ -1186,35 +1181,35 @@ int wlc_bmac_down_finish(struct wlc_hw_info *wlc_hw)
 		if (!wlc_hw->noreset) {
 			if (wlc_hw->sih->bustype == PCI_BUS)
 				ai_pci_down(wlc_hw->sih);
-			wlc_bmac_xtal(wlc_hw, OFF);
+			brcms_b_xtal(wlc_hw, OFF);
 		}
 	}
 
 	return callbacks;
 }
 
-void wlc_bmac_wait_for_wake(struct wlc_hw_info *wlc_hw)
+void brcms_b_wait_for_wake(struct wlc_hw_info *wlc_hw)
 {
 	/* delay before first read of ucode state */
 	udelay(40);
 
 	/* wait until ucode is no longer asleep */
-	SPINWAIT((wlc_bmac_read_shm(wlc_hw, M_UCODE_DBGST) ==
+	SPINWAIT((brcms_b_read_shm(wlc_hw, M_UCODE_DBGST) ==
 		  DBGST_ASLEEP), wlc_hw->wlc->fastpwrup_dly);
 }
 
-void wlc_bmac_hw_etheraddr(struct wlc_hw_info *wlc_hw, u8 *ea)
+void brcms_b_hw_etheraddr(struct wlc_hw_info *wlc_hw, u8 *ea)
 {
 	memcpy(ea, wlc_hw->etheraddr, ETH_ALEN);
 }
 
-static int wlc_bmac_bandtype(struct wlc_hw_info *wlc_hw)
+static int brcms_b_bandtype(struct wlc_hw_info *wlc_hw)
 {
 	return wlc_hw->band->bandtype;
 }
 
 /* control chip clock to save power, enable dynamic clock or force fast clock */
-static void wlc_clkctl_clk(struct wlc_hw_info *wlc_hw, uint mode)
+static void brcms_b_clkctl_clk(struct wlc_hw_info *wlc_hw, uint mode)
 {
 	if (PMUCTL_ENAB(wlc_hw->sih)) {
 		/* new chips with PMU, CCS_FORCEHT will distribute the HT clock on backplane,
@@ -1315,7 +1310,7 @@ wlc_mhfdef(struct wlc_info *wlc, u16 *mhfs, u16 mhf2_init)
  *                   WLC_BAND_ALL  <--- All bands
  */
 void
-wlc_bmac_mhf(struct wlc_hw_info *wlc_hw, u8 idx, u16 mask, u16 val,
+brcms_b_mhf(struct wlc_hw_info *wlc_hw, u8 idx, u16 mask, u16 val,
 	     int bands)
 {
 	u16 save;
@@ -1355,7 +1350,7 @@ wlc_bmac_mhf(struct wlc_hw_info *wlc_hw, u8 idx, u16 mask, u16 val,
 		 */
 		if (wlc_hw->clk && (band->mhfs[idx] != save)
 		    && (band == wlc_hw->band))
-			wlc_bmac_write_shm(wlc_hw, addr[idx],
+			brcms_b_write_shm(wlc_hw, addr[idx],
 					   (u16) band->mhfs[idx]);
 	}
 
@@ -1367,7 +1362,7 @@ wlc_bmac_mhf(struct wlc_hw_info *wlc_hw, u8 idx, u16 mask, u16 val,
 	}
 }
 
-u16 wlc_bmac_mhf_get(struct wlc_hw_info *wlc_hw, u8 idx, int bands)
+u16 brcms_b_mhf_get(struct wlc_hw_info *wlc_hw, u8 idx, int bands)
 {
 	struct wlc_hwband *band;
 
@@ -1402,7 +1397,7 @@ static void wlc_write_mhf(struct wlc_hw_info *wlc_hw, u16 *mhfs)
 	};
 
 	for (idx = 0; idx < MHFMAX; idx++) {
-		wlc_bmac_write_shm(wlc_hw, addr[idx], mhfs[idx]);
+		brcms_b_write_shm(wlc_hw, addr[idx], mhfs[idx]);
 	}
 }
 
@@ -1416,11 +1411,11 @@ static void wlc_mctrl_reset(struct wlc_hw_info *wlc_hw)
 	wlc_hw->suspended_fifos = 0;
 	wlc_hw->wake_override = 0;
 	wlc_hw->mute_override = 0;
-	wlc_bmac_mctrl(wlc_hw, ~0, MCTL_IHR_EN | MCTL_WAKE);
+	brcms_b_mctrl(wlc_hw, ~0, MCTL_IHR_EN | MCTL_WAKE);
 }
 
 /* set or clear maccontrol bits */
-void wlc_bmac_mctrl(struct wlc_hw_info *wlc_hw, u32 mask, u32 val)
+void brcms_b_mctrl(struct wlc_hw_info *wlc_hw, u32 mask, u32 val)
 {
 	u32 maccontrol;
 	u32 new_maccontrol;
@@ -1469,7 +1464,7 @@ void wlc_ucode_wake_override_set(struct wlc_hw_info *wlc_hw, u32 override_bit)
 	mboolset(wlc_hw->wake_override, override_bit);
 
 	wlc_mctrl_write(wlc_hw);
-	wlc_bmac_wait_for_wake(wlc_hw);
+	brcms_b_wait_for_wake(wlc_hw);
 
 	return;
 }
@@ -1529,7 +1524,7 @@ static void wlc_ucode_mute_override_clear(struct wlc_hw_info *wlc_hw)
  * Write a MAC address to the given match reg offset in the RXE match engine.
  */
 void
-wlc_bmac_set_addrmatch(struct wlc_hw_info *wlc_hw, int match_reg_offset,
+brcms_b_set_addrmatch(struct wlc_hw_info *wlc_hw, int match_reg_offset,
 		       const u8 *addr)
 {
 	d11regs_t *regs;
@@ -1537,7 +1532,7 @@ wlc_bmac_set_addrmatch(struct wlc_hw_info *wlc_hw, int match_reg_offset,
 	u16 mac_m;
 	u16 mac_h;
 
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: wlc_bmac_set_addrmatch\n",
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: brcms_b_set_addrmatch\n",
 		 wlc_hw->unit);
 
 	regs = wlc_hw->regs;
@@ -1554,7 +1549,7 @@ wlc_bmac_set_addrmatch(struct wlc_hw_info *wlc_hw, int match_reg_offset,
 }
 
 void
-wlc_bmac_write_template_ram(struct wlc_hw_info *wlc_hw, int offset, int len,
+brcms_b_write_template_ram(struct wlc_hw_info *wlc_hw, int offset, int len,
 			    void *buf)
 {
 	d11regs_t *regs;
@@ -1586,7 +1581,7 @@ wlc_bmac_write_template_ram(struct wlc_hw_info *wlc_hw, int offset, int len,
 	}
 }
 
-void wlc_bmac_set_cwmin(struct wlc_hw_info *wlc_hw, u16 newmin)
+void brcms_b_set_cwmin(struct wlc_hw_info *wlc_hw, u16 newmin)
 {
 	wlc_hw->band->CWmin = newmin;
 
@@ -1595,7 +1590,7 @@ void wlc_bmac_set_cwmin(struct wlc_hw_info *wlc_hw, u16 newmin)
 	W_REG(&wlc_hw->regs->objdata, newmin);
 }
 
-void wlc_bmac_set_cwmax(struct wlc_hw_info *wlc_hw, u16 newmax)
+void brcms_b_set_cwmax(struct wlc_hw_info *wlc_hw, u16 newmax)
 {
 	wlc_hw->band->CWmax = newmax;
 
@@ -1604,23 +1599,23 @@ void wlc_bmac_set_cwmax(struct wlc_hw_info *wlc_hw, u16 newmax)
 	W_REG(&wlc_hw->regs->objdata, newmax);
 }
 
-void wlc_bmac_bw_set(struct wlc_hw_info *wlc_hw, u16 bw)
+void brcms_b_bw_set(struct wlc_hw_info *wlc_hw, u16 bw)
 {
 	bool fastclk;
 
 	/* request FAST clock if not on */
 	fastclk = wlc_hw->forcefastclk;
 	if (!fastclk)
-		wlc_clkctl_clk(wlc_hw, CLK_FAST);
+		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
 
 	wlc_phy_bw_state_set(wlc_hw->band->pi, bw);
 
-	wlc_bmac_phy_reset(wlc_hw);
+	brcms_b_phy_reset(wlc_hw);
 	wlc_phy_init(wlc_hw->band->pi, wlc_phy_chanspec_get(wlc_hw->band->pi));
 
 	/* restore the clk */
 	if (!fastclk)
-		wlc_clkctl_clk(wlc_hw, CLK_DYNAMIC);
+		brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
 }
 
 static void
@@ -1628,10 +1623,10 @@ wlc_write_hw_bcntemplate0(struct wlc_hw_info *wlc_hw, void *bcn, int len)
 {
 	d11regs_t *regs = wlc_hw->regs;
 
-	wlc_bmac_write_template_ram(wlc_hw, T_BCN0_TPL_BASE, (len + 3) & ~3,
+	brcms_b_write_template_ram(wlc_hw, T_BCN0_TPL_BASE, (len + 3) & ~3,
 				    bcn);
 	/* write beacon length to SCR */
-	wlc_bmac_write_shm(wlc_hw, M_BCN0_FRM_BYTESZ, (u16) len);
+	brcms_b_write_shm(wlc_hw, M_BCN0_FRM_BYTESZ, (u16) len);
 	/* mark beacon0 valid */
 	OR_REG(&regs->maccommand, MCMD_BCN0VLD);
 }
@@ -1641,17 +1636,17 @@ wlc_write_hw_bcntemplate1(struct wlc_hw_info *wlc_hw, void *bcn, int len)
 {
 	d11regs_t *regs = wlc_hw->regs;
 
-	wlc_bmac_write_template_ram(wlc_hw, T_BCN1_TPL_BASE, (len + 3) & ~3,
+	brcms_b_write_template_ram(wlc_hw, T_BCN1_TPL_BASE, (len + 3) & ~3,
 				    bcn);
 	/* write beacon length to SCR */
-	wlc_bmac_write_shm(wlc_hw, M_BCN1_FRM_BYTESZ, (u16) len);
+	brcms_b_write_shm(wlc_hw, M_BCN1_FRM_BYTESZ, (u16) len);
 	/* mark beacon1 valid */
 	OR_REG(&regs->maccommand, MCMD_BCN1VLD);
 }
 
 /* mac is assumed to be suspended at this point */
 void
-wlc_bmac_write_hw_bcntemplates(struct wlc_hw_info *wlc_hw, void *bcn, int len,
+brcms_b_write_hw_bcntemplates(struct wlc_hw_info *wlc_hw, void *bcn, int len,
 			       bool both)
 {
 	d11regs_t *regs = wlc_hw->regs;
@@ -1670,7 +1665,7 @@ wlc_bmac_write_hw_bcntemplates(struct wlc_hw_info *wlc_hw, void *bcn, int len,
 	}
 }
 
-static void WLBANDINITFN(wlc_bmac_upd_synthpu) (struct wlc_hw_info *wlc_hw)
+static void WLBANDINITFN(brcms_b_upd_synthpu) (struct wlc_hw_info *wlc_hw)
 {
 	u16 v;
 	struct wlc_info *wlc = wlc_hw->wlc;
@@ -1684,12 +1679,12 @@ static void WLBANDINITFN(wlc_bmac_upd_synthpu) (struct wlc_hw_info *wlc_hw)
 		v = SYNTHPU_DLY_BPHY_US;
 	}
 
-	wlc_bmac_write_shm(wlc_hw, M_SYNTHPU_DLY, v);
+	brcms_b_write_shm(wlc_hw, M_SYNTHPU_DLY, v);
 }
 
 /* band-specific init */
 static void
-WLBANDINITFN(wlc_bmac_bsinit) (struct wlc_info *wlc, chanspec_t chanspec)
+WLBANDINITFN(brcms_b_bsinit) (struct wlc_info *wlc, chanspec_t chanspec)
 {
 	struct wlc_hw_info *wlc_hw = wlc->hw;
 
@@ -1703,25 +1698,25 @@ WLBANDINITFN(wlc_bmac_bsinit) (struct wlc_info *wlc, chanspec_t chanspec)
 	wlc_ucode_txant_set(wlc_hw);
 
 	/* cwmin is band-specific, update hardware with value for current band */
-	wlc_bmac_set_cwmin(wlc_hw, wlc_hw->band->CWmin);
-	wlc_bmac_set_cwmax(wlc_hw, wlc_hw->band->CWmax);
+	brcms_b_set_cwmin(wlc_hw, wlc_hw->band->CWmin);
+	brcms_b_set_cwmax(wlc_hw, wlc_hw->band->CWmax);
 
-	wlc_bmac_update_slot_timing(wlc_hw,
+	brcms_b_update_slot_timing(wlc_hw,
 				    BAND_5G(wlc_hw->band->
 					    bandtype) ? true : wlc_hw->
 				    shortslot);
 
 	/* write phytype and phyvers */
-	wlc_bmac_write_shm(wlc_hw, M_PHYTYPE, (u16) wlc_hw->band->phytype);
-	wlc_bmac_write_shm(wlc_hw, M_PHYVER, (u16) wlc_hw->band->phyrev);
+	brcms_b_write_shm(wlc_hw, M_PHYTYPE, (u16) wlc_hw->band->phytype);
+	brcms_b_write_shm(wlc_hw, M_PHYVER, (u16) wlc_hw->band->phyrev);
 
 	/* initialize the txphyctl1 rate table since shmem is shared between bands */
 	wlc_upd_ofdm_pctl1_table(wlc_hw);
 
-	wlc_bmac_upd_synthpu(wlc_hw);
+	brcms_b_upd_synthpu(wlc_hw);
 }
 
-static void wlc_bmac_core_phy_clk(struct wlc_hw_info *wlc_hw, bool clk)
+static void brcms_b_core_phy_clk(struct wlc_hw_info *wlc_hw, bool clk)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: clk %d\n", wlc_hw->unit, clk);
 
@@ -1746,7 +1741,7 @@ static void wlc_bmac_core_phy_clk(struct wlc_hw_info *wlc_hw, bool clk)
 }
 
 /* Perform a soft reset of the PHY PLL */
-void wlc_bmac_core_phypll_reset(struct wlc_hw_info *wlc_hw)
+void brcms_b_core_phypll_reset(struct wlc_hw_info *wlc_hw)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
@@ -1765,9 +1760,9 @@ void wlc_bmac_core_phypll_reset(struct wlc_hw_info *wlc_hw)
 }
 
 /* light way to turn on phy clock without reset for NPHY only
- *  refer to wlc_bmac_core_phy_clk for full version
+ *  refer to brcms_b_core_phy_clk for full version
  */
-void wlc_bmac_phyclk_fgc(struct wlc_hw_info *wlc_hw, bool clk)
+void brcms_b_phyclk_fgc(struct wlc_hw_info *wlc_hw, bool clk)
 {
 	/* support(necessary for NPHY and HYPHY) only */
 	if (!WLCISNPHY(wlc_hw->band))
@@ -1780,7 +1775,7 @@ void wlc_bmac_phyclk_fgc(struct wlc_hw_info *wlc_hw, bool clk)
 
 }
 
-void wlc_bmac_macphyclk_set(struct wlc_hw_info *wlc_hw, bool clk)
+void brcms_b_macphyclk_set(struct wlc_hw_info *wlc_hw, bool clk)
 {
 	if (ON == clk)
 		ai_core_cflags(wlc_hw->sih, SICF_MPCLKE, SICF_MPCLKE);
@@ -1788,7 +1783,7 @@ void wlc_bmac_macphyclk_set(struct wlc_hw_info *wlc_hw, bool clk)
 		ai_core_cflags(wlc_hw->sih, SICF_MPCLKE, 0);
 }
 
-void wlc_bmac_phy_reset(struct wlc_hw_info *wlc_hw)
+void brcms_b_phy_reset(struct wlc_hw_info *wlc_hw)
 {
 	wlc_phy_t *pih = wlc_hw->band->pi;
 	u32 phy_bw_clkbits;
@@ -1810,7 +1805,7 @@ void wlc_bmac_phy_reset(struct wlc_hw_info *wlc_hw)
 		udelay(1);
 
 		/* Perform a soft reset of the PHY PLL */
-		wlc_bmac_core_phypll_reset(wlc_hw);
+		brcms_b_core_phypll_reset(wlc_hw);
 
 		/* reset the PHY */
 		ai_core_cflags(wlc_hw->sih, (SICF_PRST | SICF_PCLKE),
@@ -1824,7 +1819,7 @@ void wlc_bmac_phy_reset(struct wlc_hw_info *wlc_hw)
 	}
 
 	udelay(2);
-	wlc_bmac_core_phy_clk(wlc_hw, ON);
+	brcms_b_core_phy_clk(wlc_hw, ON);
 
 	if (pih)
 		wlc_phy_anacore(pih, ON);
@@ -1832,7 +1827,7 @@ void wlc_bmac_phy_reset(struct wlc_hw_info *wlc_hw)
 
 /* switch to and initialize new band */
 static void
-WLBANDINITFN(wlc_bmac_setband) (struct wlc_hw_info *wlc_hw, uint bandunit,
+WLBANDINITFN(brcms_b_setband) (struct wlc_hw_info *wlc_hw, uint bandunit,
 				chanspec_t chanspec) {
 	struct wlc_info *wlc = wlc_hw->wlc;
 	u32 macintmask;
@@ -1848,10 +1843,10 @@ WLBANDINITFN(wlc_bmac_setband) (struct wlc_hw_info *wlc_hw, uint bandunit,
 	if (!wlc_hw->up)
 		return;
 
-	wlc_bmac_core_phy_clk(wlc_hw, ON);
+	brcms_b_core_phy_clk(wlc_hw, ON);
 
 	/* band-specific initializations */
-	wlc_bmac_bsinit(wlc, chanspec);
+	brcms_b_bsinit(wlc, chanspec);
 
 	/*
 	 * If there are any pending software interrupt bits,
@@ -1953,14 +1948,14 @@ static char *wlc_get_macaddr(struct wlc_hw_info *wlc_hw)
  * this function could be called when driver is down and w/o clock
  * it operates on different registers depending on corerev and boardflag.
  */
-bool wlc_bmac_radio_read_hwdisabled(struct wlc_hw_info *wlc_hw)
+bool brcms_b_radio_read_hwdisabled(struct wlc_hw_info *wlc_hw)
 {
 	bool v, clk, xtal;
 	u32 resetbits = 0, flags = 0;
 
 	xtal = wlc_hw->sbclk;
 	if (!xtal)
-		wlc_bmac_xtal(wlc_hw, ON);
+		brcms_b_xtal(wlc_hw, ON);
 
 	/* may need to take core out of reset first */
 	clk = wlc_hw->clk;
@@ -1990,13 +1985,13 @@ bool wlc_bmac_radio_read_hwdisabled(struct wlc_hw_info *wlc_hw)
 		ai_core_disable(wlc_hw->sih, 0);
 
 	if (!xtal)
-		wlc_bmac_xtal(wlc_hw, OFF);
+		brcms_b_xtal(wlc_hw, OFF);
 
 	return v;
 }
 
 /* Initialize just the hardware when coming out of POR or S3/S5 system states */
-void wlc_bmac_hw_up(struct wlc_hw_info *wlc_hw)
+void brcms_b_hw_up(struct wlc_hw_info *wlc_hw)
 {
 	if (wlc_hw->wlc->pub->hw_up)
 		return;
@@ -2007,9 +2002,9 @@ void wlc_bmac_hw_up(struct wlc_hw_info *wlc_hw)
 	 * Enable pll and xtal, initialize the power control registers,
 	 * and force fastclock for the remainder of wlc_up().
 	 */
-	wlc_bmac_xtal(wlc_hw, ON);
+	brcms_b_xtal(wlc_hw, ON);
 	ai_clkctl_init(wlc_hw->sih);
-	wlc_clkctl_clk(wlc_hw, CLK_FAST);
+	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
 
 	if (wlc_hw->sih->bustype == PCI_BUS) {
 		ai_pci_fixcfg(wlc_hw->sih);
@@ -2052,7 +2047,7 @@ static bool wlc_dma_rxreset(struct wlc_hw_info *wlc_hw, uint fifo)
  *   clear software macintstatus for fresh new start
  * one testing hack wlc_hw->noreset will bypass the d11/phy reset
  */
-void wlc_bmac_corereset(struct wlc_hw_info *wlc_hw, u32 flags)
+void brcms_b_corereset(struct wlc_hw_info *wlc_hw, u32 flags)
 {
 	d11regs_t *regs;
 	uint i;
@@ -2069,7 +2064,7 @@ void wlc_bmac_corereset(struct wlc_hw_info *wlc_hw, u32 flags)
 	/* request FAST clock if not on  */
 	fastclk = wlc_hw->forcefastclk;
 	if (!fastclk)
-		wlc_clkctl_clk(wlc_hw, CLK_FAST);
+		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
 
 	/* reset the dma engines except first time thru */
 	if (ai_iscoreup(wlc_hw->sih)) {
@@ -2090,7 +2085,7 @@ void wlc_bmac_corereset(struct wlc_hw_info *wlc_hw, u32 flags)
 	/* if noreset, just stop the psm and return */
 	if (wlc_hw->noreset) {
 		wlc_hw->wlc->macintstatus = 0;	/* skip wl_dpc after down */
-		wlc_bmac_mctrl(wlc_hw, MCTL_PSM_RUN | MCTL_EN_MAC, 0);
+		brcms_b_mctrl(wlc_hw, MCTL_PSM_RUN | MCTL_EN_MAC, 0);
 		return;
 	}
 
@@ -2117,25 +2112,25 @@ void wlc_bmac_corereset(struct wlc_hw_info *wlc_hw, u32 flags)
 	wlc_mctrl_reset(wlc_hw);
 
 	if (PMUCTL_ENAB(wlc_hw->sih))
-		wlc_clkctl_clk(wlc_hw, CLK_FAST);
+		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
 
-	wlc_bmac_phy_reset(wlc_hw);
+	brcms_b_phy_reset(wlc_hw);
 
 	/* turn on PHY_PLL */
-	wlc_bmac_core_phypll_ctl(wlc_hw, true);
+	brcms_b_core_phypll_ctl(wlc_hw, true);
 
 	/* clear sw intstatus */
 	wlc_hw->wlc->macintstatus = 0;
 
 	/* restore the clk setting */
 	if (!fastclk)
-		wlc_clkctl_clk(wlc_hw, CLK_DYNAMIC);
+		brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
 }
 
 /* txfifo sizes needs to be modified(increased) since the newer cores
  * have more memory.
  */
-static void wlc_corerev_fifofixup(struct wlc_hw_info *wlc_hw)
+static void brcms_b_corerev_fifofixup(struct wlc_hw_info *wlc_hw)
 {
 	d11regs_t *regs = wlc_hw->regs;
 	u16 fifo_nu;
@@ -2170,14 +2165,14 @@ static void wlc_corerev_fifofixup(struct wlc_hw_info *wlc_hw)
 	 * need to propagate to shm location to be in sync since ucode/hw won't
 	 * do this
 	 */
-	wlc_bmac_write_shm(wlc_hw, M_FIFOSIZE0,
+	brcms_b_write_shm(wlc_hw, M_FIFOSIZE0,
 			   wlc_hw->xmtfifo_sz[TX_AC_BE_FIFO]);
-	wlc_bmac_write_shm(wlc_hw, M_FIFOSIZE1,
+	brcms_b_write_shm(wlc_hw, M_FIFOSIZE1,
 			   wlc_hw->xmtfifo_sz[TX_AC_VI_FIFO]);
-	wlc_bmac_write_shm(wlc_hw, M_FIFOSIZE2,
+	brcms_b_write_shm(wlc_hw, M_FIFOSIZE2,
 			   ((wlc_hw->xmtfifo_sz[TX_AC_VO_FIFO] << 8) | wlc_hw->
 			    xmtfifo_sz[TX_AC_BK_FIFO]));
-	wlc_bmac_write_shm(wlc_hw, M_FIFOSIZE3,
+	brcms_b_write_shm(wlc_hw, M_FIFOSIZE3,
 			   ((wlc_hw->xmtfifo_sz[TX_ATIM_FIFO] << 8) | wlc_hw->
 			    xmtfifo_sz[TX_BCMC_FIFO]));
 }
@@ -2190,7 +2185,7 @@ static void wlc_corerev_fifofixup(struct wlc_hw_info *wlc_hw)
  *   config other core registers
  *   init dma
  */
-static void wlc_coreinit(struct wlc_info *wlc)
+static void brcms_b_coreinit(struct wlc_info *wlc)
 {
 	struct wlc_hw_info *wlc_hw = wlc->hw;
 	d11regs_t *regs;
@@ -2207,7 +2202,7 @@ static void wlc_coreinit(struct wlc_info *wlc)
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	/* reset PSM */
-	wlc_bmac_mctrl(wlc_hw, ~0, (MCTL_IHR_EN | MCTL_PSM_JMP_0 | MCTL_WAKE));
+	brcms_b_mctrl(wlc_hw, ~0, (MCTL_IHR_EN | MCTL_PSM_JMP_0 | MCTL_WAKE));
 
 	wlc_ucode_download(wlc_hw);
 	/*
@@ -2217,7 +2212,7 @@ static void wlc_coreinit(struct wlc_info *wlc)
 
 	/* let the PSM run to the suspended state, set mode to BSS STA */
 	W_REG(&regs->macintstatus, -1);
-	wlc_bmac_mctrl(wlc_hw, ~0,
+	brcms_b_mctrl(wlc_hw, ~0,
 		       (MCTL_IHR_EN | MCTL_INFRA | MCTL_PSM_RUN | MCTL_WAKE));
 
 	/* wait for ucode to self-suspend after auto-init */
@@ -2253,21 +2248,21 @@ static void wlc_coreinit(struct wlc_info *wlc)
 
 	/* For old ucode, txfifo sizes needs to be modified(increased) */
 	if (fifosz_fixup == true) {
-		wlc_corerev_fifofixup(wlc_hw);
+		brcms_b_corerev_fifofixup(wlc_hw);
 	}
 
 	/* check txfifo allocations match between ucode and driver */
-	buf[TX_AC_BE_FIFO] = wlc_bmac_read_shm(wlc_hw, M_FIFOSIZE0);
+	buf[TX_AC_BE_FIFO] = brcms_b_read_shm(wlc_hw, M_FIFOSIZE0);
 	if (buf[TX_AC_BE_FIFO] != wlc_hw->xmtfifo_sz[TX_AC_BE_FIFO]) {
 		i = TX_AC_BE_FIFO;
 		err = -1;
 	}
-	buf[TX_AC_VI_FIFO] = wlc_bmac_read_shm(wlc_hw, M_FIFOSIZE1);
+	buf[TX_AC_VI_FIFO] = brcms_b_read_shm(wlc_hw, M_FIFOSIZE1);
 	if (buf[TX_AC_VI_FIFO] != wlc_hw->xmtfifo_sz[TX_AC_VI_FIFO]) {
 		i = TX_AC_VI_FIFO;
 		err = -1;
 	}
-	buf[TX_AC_BK_FIFO] = wlc_bmac_read_shm(wlc_hw, M_FIFOSIZE2);
+	buf[TX_AC_BK_FIFO] = brcms_b_read_shm(wlc_hw, M_FIFOSIZE2);
 	buf[TX_AC_VO_FIFO] = (buf[TX_AC_BK_FIFO] >> 8) & 0xff;
 	buf[TX_AC_BK_FIFO] &= 0xff;
 	if (buf[TX_AC_BK_FIFO] != wlc_hw->xmtfifo_sz[TX_AC_BK_FIFO]) {
@@ -2278,7 +2273,7 @@ static void wlc_coreinit(struct wlc_info *wlc)
 		i = TX_AC_VO_FIFO;
 		err = -1;
 	}
-	buf[TX_BCMC_FIFO] = wlc_bmac_read_shm(wlc_hw, M_FIFOSIZE3);
+	buf[TX_BCMC_FIFO] = brcms_b_read_shm(wlc_hw, M_FIFOSIZE3);
 	buf[TX_ATIM_FIFO] = (buf[TX_BCMC_FIFO] >> 8) & 0xff;
 	buf[TX_BCMC_FIFO] &= 0xff;
 	if (buf[TX_BCMC_FIFO] != wlc_hw->xmtfifo_sz[TX_BCMC_FIFO]) {
@@ -2301,14 +2296,14 @@ static void wlc_coreinit(struct wlc_info *wlc)
 	/* band-specific inits done by wlc_bsinit() */
 
 	/* Set up frame burst size and antenna swap threshold init values */
-	wlc_bmac_write_shm(wlc_hw, M_MBURST_SIZE, MAXTXFRAMEBURST);
-	wlc_bmac_write_shm(wlc_hw, M_MAX_ANTCNT, ANTCNT);
+	brcms_b_write_shm(wlc_hw, M_MBURST_SIZE, MAXTXFRAMEBURST);
+	brcms_b_write_shm(wlc_hw, M_MAX_ANTCNT, ANTCNT);
 
 	/* enable one rx interrupt per received frame */
 	W_REG(&regs->intrcvlazy[0], (1 << IRL_FC_SHIFT));
 
 	/* set the station mode (BSS STA) */
-	wlc_bmac_mctrl(wlc_hw,
+	brcms_b_mctrl(wlc_hw,
 		       (MCTL_INFRA | MCTL_DISCARD_PMQ | MCTL_AP),
 		       (MCTL_INFRA | MCTL_DISCARD_PMQ));
 
@@ -2322,19 +2317,19 @@ static void wlc_coreinit(struct wlc_info *wlc)
 	W_REG(&regs->intctrlregs[RX_FIFO].intmask, DEF_RXINTMASK);
 
 	/* allow the MAC to control the PHY clock (dynamic on/off) */
-	wlc_bmac_macphyclk_set(wlc_hw, ON);
+	brcms_b_macphyclk_set(wlc_hw, ON);
 
 	/* program dynamic clock control fast powerup delay register */
 	wlc->fastpwrup_dly = ai_clkctl_fast_pwrup_delay(wlc_hw->sih);
 	W_REG(&regs->scc_fastpwrup_dly, wlc->fastpwrup_dly);
 
 	/* tell the ucode the corerev */
-	wlc_bmac_write_shm(wlc_hw, M_MACHW_VER, (u16) wlc_hw->corerev);
+	brcms_b_write_shm(wlc_hw, M_MACHW_VER, (u16) wlc_hw->corerev);
 
 	/* tell the ucode MAC capabilities */
-	wlc_bmac_write_shm(wlc_hw, M_MACHW_CAP_L,
+	brcms_b_write_shm(wlc_hw, M_MACHW_CAP_L,
 			   (u16) (wlc_hw->machwcap & 0xffff));
-	wlc_bmac_write_shm(wlc_hw, M_MACHW_CAP_H,
+	brcms_b_write_shm(wlc_hw, M_MACHW_CAP_H,
 			   (u16) ((wlc_hw->
 				      machwcap >> 16) & 0xffff));
 
@@ -2347,8 +2342,8 @@ static void wlc_coreinit(struct wlc_info *wlc)
 	W_REG(&regs->objdata, wlc_hw->LRL);
 
 	/* write rate fallback retry limits */
-	wlc_bmac_write_shm(wlc_hw, M_SFRMTXCNTFBRTHSD, wlc_hw->SFBL);
-	wlc_bmac_write_shm(wlc_hw, M_LFRMTXCNTFBRTHSD, wlc_hw->LFBL);
+	brcms_b_write_shm(wlc_hw, M_SFRMTXCNTFBRTHSD, wlc_hw->SFBL);
+	brcms_b_write_shm(wlc_hw, M_LFRMTXCNTFBRTHSD, wlc_hw->LFBL);
 
 	AND_REG(&regs->ifs_ctl, 0x0FFF);
 	W_REG(&regs->ifs_aifsn, EDCF_AIFSN_MIN);
@@ -2380,7 +2375,7 @@ static void wlc_coreinit(struct wlc_info *wlc)
  *  - 559241 = 0x88889 => tsf_clk_frac_h = 0x8, tsf_clk_frac_l = 0x8889
  */
 
-void wlc_bmac_switch_macfreq(struct wlc_hw_info *wlc_hw, u8 spurmode)
+void brcms_b_switch_macfreq(struct wlc_hw_info *wlc_hw, u8 spurmode)
 {
 	d11regs_t *regs;
 	regs = wlc_hw->regs;
@@ -2418,7 +2413,7 @@ static void wlc_gpio_init(struct wlc_info *wlc)
 	regs = wlc_hw->regs;
 
 	/* use GPIO select 0 to get all gpio signals from the gpio out reg */
-	wlc_bmac_mctrl(wlc_hw, MCTL_GPOUT_SEL_MASK, 0);
+	brcms_b_mctrl(wlc_hw, MCTL_GPOUT_SEL_MASK, 0);
 
 	/*
 	 * Common GPIO setup:
@@ -2433,9 +2428,9 @@ static void wlc_gpio_init(struct wlc_info *wlc)
 	/* Allocate GPIOs for mimo antenna diversity feature */
 	if (wlc_hw->antsel_type == ANTSEL_2x3) {
 		/* Enable antenna diversity, use 2x3 mode */
-		wlc_bmac_mhf(wlc_hw, MHF3, MHF3_ANTSEL_EN,
+		brcms_b_mhf(wlc_hw, MHF3, MHF3_ANTSEL_EN,
 			     MHF3_ANTSEL_EN, WLC_BAND_ALL);
-		wlc_bmac_mhf(wlc_hw, MHF3, MHF3_ANTSEL_MODE,
+		brcms_b_mhf(wlc_hw, MHF3, MHF3_ANTSEL_MODE,
 			     MHF3_ANTSEL_MODE, WLC_BAND_ALL);
 
 		/* init superswitch control */
@@ -2453,13 +2448,13 @@ static void wlc_gpio_init(struct wlc_info *wlc)
 		       (BOARD_GPIO_12 | BOARD_GPIO_13));
 
 		/* Enable antenna diversity, use 2x4 mode */
-		wlc_bmac_mhf(wlc_hw, MHF3, MHF3_ANTSEL_EN,
+		brcms_b_mhf(wlc_hw, MHF3, MHF3_ANTSEL_EN,
 			     MHF3_ANTSEL_EN, WLC_BAND_ALL);
-		wlc_bmac_mhf(wlc_hw, MHF3, MHF3_ANTSEL_MODE, 0,
+		brcms_b_mhf(wlc_hw, MHF3, MHF3_ANTSEL_MODE, 0,
 			     WLC_BAND_ALL);
 
 		/* Configure the desired clock to be 4Mhz */
-		wlc_bmac_write_shm(wlc_hw, M_ANTSEL_CLKDIV,
+		brcms_b_write_shm(wlc_hw, M_ANTSEL_CLKDIV,
 				   ANTSEL_CLKDIV_4MHZ);
 	}
 
@@ -2544,17 +2539,17 @@ static void wlc_ucode_txant_set(struct wlc_hw_info *wlc_hw)
 	u16 mask = PHY_TXC_ANT_MASK;
 
 	/* set the Probe Response frame phy control word */
-	phyctl = wlc_bmac_read_shm(wlc_hw, M_CTXPRS_BLK + C_CTX_PCTLWD_POS);
+	phyctl = brcms_b_read_shm(wlc_hw, M_CTXPRS_BLK + C_CTX_PCTLWD_POS);
 	phyctl = (phyctl & ~mask) | phytxant;
-	wlc_bmac_write_shm(wlc_hw, M_CTXPRS_BLK + C_CTX_PCTLWD_POS, phyctl);
+	brcms_b_write_shm(wlc_hw, M_CTXPRS_BLK + C_CTX_PCTLWD_POS, phyctl);
 
 	/* set the Response (ACK/CTS) frame phy control word */
-	phyctl = wlc_bmac_read_shm(wlc_hw, M_RSP_PCTLWD);
+	phyctl = brcms_b_read_shm(wlc_hw, M_RSP_PCTLWD);
 	phyctl = (phyctl & ~mask) | phytxant;
-	wlc_bmac_write_shm(wlc_hw, M_RSP_PCTLWD, phyctl);
+	brcms_b_write_shm(wlc_hw, M_RSP_PCTLWD, phyctl);
 }
 
-void wlc_bmac_txant_set(struct wlc_hw_info *wlc_hw, u16 phytxant)
+void brcms_b_txant_set(struct wlc_hw_info *wlc_hw, u16 phytxant)
 {
 	/* update sw state */
 	wlc_hw->bmac_phytxant = phytxant;
@@ -2566,12 +2561,12 @@ void wlc_bmac_txant_set(struct wlc_hw_info *wlc_hw, u16 phytxant)
 
 }
 
-u16 wlc_bmac_get_txant(struct wlc_hw_info *wlc_hw)
+u16 brcms_b_get_txant(struct wlc_hw_info *wlc_hw)
 {
 	return (u16) wlc_hw->wlc->stf->txant;
 }
 
-void wlc_bmac_antsel_type_set(struct wlc_hw_info *wlc_hw, u8 antsel_type)
+void brcms_b_antsel_type_set(struct wlc_hw_info *wlc_hw, u8 antsel_type)
 {
 	wlc_hw->antsel_type = antsel_type;
 
@@ -2579,7 +2574,7 @@ void wlc_bmac_antsel_type_set(struct wlc_hw_info *wlc_hw, u8 antsel_type)
 	wlc_phy_antsel_type_set(wlc_hw->band->pi, antsel_type);
 }
 
-void wlc_bmac_fifoerrors(struct wlc_hw_info *wlc_hw)
+void brcms_b_fifoerrors(struct wlc_hw_info *wlc_hw)
 {
 	bool fatal = false;
 	uint unit;
@@ -2700,31 +2695,31 @@ void wlc_intrsrestore(struct wlc_info *wlc, u32 macintmask)
 	W_REG(&wlc_hw->regs->macintmask, wlc->macintmask);
 }
 
-static void wlc_bmac_mute(struct wlc_hw_info *wlc_hw, bool on, mbool flags)
+static void brcms_b_mute(struct wlc_hw_info *wlc_hw, bool on, mbool flags)
 {
 	u8 null_ether_addr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
 
 	if (on) {
 		/* suspend tx fifos */
-		wlc_bmac_tx_fifo_suspend(wlc_hw, TX_DATA_FIFO);
-		wlc_bmac_tx_fifo_suspend(wlc_hw, TX_CTL_FIFO);
-		wlc_bmac_tx_fifo_suspend(wlc_hw, TX_AC_BK_FIFO);
-		wlc_bmac_tx_fifo_suspend(wlc_hw, TX_AC_VI_FIFO);
+		brcms_b_tx_fifo_suspend(wlc_hw, TX_DATA_FIFO);
+		brcms_b_tx_fifo_suspend(wlc_hw, TX_CTL_FIFO);
+		brcms_b_tx_fifo_suspend(wlc_hw, TX_AC_BK_FIFO);
+		brcms_b_tx_fifo_suspend(wlc_hw, TX_AC_VI_FIFO);
 
 		/* zero the address match register so we do not send ACKs */
-		wlc_bmac_set_addrmatch(wlc_hw, RCM_MAC_OFFSET,
+		brcms_b_set_addrmatch(wlc_hw, RCM_MAC_OFFSET,
 				       null_ether_addr);
 	} else {
 		/* resume tx fifos */
 		if (!wlc_hw->wlc->tx_suspended) {
-			wlc_bmac_tx_fifo_resume(wlc_hw, TX_DATA_FIFO);
+			brcms_b_tx_fifo_resume(wlc_hw, TX_DATA_FIFO);
 		}
-		wlc_bmac_tx_fifo_resume(wlc_hw, TX_CTL_FIFO);
-		wlc_bmac_tx_fifo_resume(wlc_hw, TX_AC_BK_FIFO);
-		wlc_bmac_tx_fifo_resume(wlc_hw, TX_AC_VI_FIFO);
+		brcms_b_tx_fifo_resume(wlc_hw, TX_CTL_FIFO);
+		brcms_b_tx_fifo_resume(wlc_hw, TX_AC_BK_FIFO);
+		brcms_b_tx_fifo_resume(wlc_hw, TX_AC_VI_FIFO);
 
 		/* Restore address */
-		wlc_bmac_set_addrmatch(wlc_hw, RCM_MAC_OFFSET,
+		brcms_b_set_addrmatch(wlc_hw, RCM_MAC_OFFSET,
 				       wlc_hw->etheraddr);
 	}
 
@@ -2736,7 +2731,7 @@ static void wlc_bmac_mute(struct wlc_hw_info *wlc_hw, bool on, mbool flags)
 		wlc_ucode_mute_override_clear(wlc_hw);
 }
 
-int wlc_bmac_xmtfifo_sz_get(struct wlc_hw_info *wlc_hw, uint fifo, uint *blocks)
+int brcms_b_xmtfifo_sz_get(struct wlc_hw_info *wlc_hw, uint fifo, uint *blocks)
 {
 	if (fifo >= NFIFO)
 		return -EINVAL;
@@ -2746,7 +2741,7 @@ int wlc_bmac_xmtfifo_sz_get(struct wlc_hw_info *wlc_hw, uint fifo, uint *blocks)
 	return 0;
 }
 
-/* wlc_bmac_tx_fifo_suspended:
+/* brcms_b_tx_fifo_suspended:
  * Check the MAC's tx suspend status for a tx fifo.
  *
  * When the MAC acknowledges a tx suspend, it indicates that no more
@@ -2755,7 +2750,7 @@ int wlc_bmac_xmtfifo_sz_get(struct wlc_hw_info *wlc_hw, uint fifo, uint *blocks)
  * be pulling data into a tx fifo, by the time the MAC acks the suspend
  * request.
  */
-static bool wlc_bmac_tx_fifo_suspended(struct wlc_hw_info *wlc_hw, uint tx_fifo)
+static bool brcms_b_tx_fifo_suspended(struct wlc_hw_info *wlc_hw, uint tx_fifo)
 {
 	/* check that a suspend has been requested and is no longer pending */
 
@@ -2774,7 +2769,7 @@ static bool wlc_bmac_tx_fifo_suspended(struct wlc_hw_info *wlc_hw, uint tx_fifo)
 	return false;
 }
 
-static void wlc_bmac_tx_fifo_suspend(struct wlc_hw_info *wlc_hw, uint tx_fifo)
+static void brcms_b_tx_fifo_suspend(struct wlc_hw_info *wlc_hw, uint tx_fifo)
 {
 	u8 fifo = 1 << tx_fifo;
 
@@ -2805,7 +2800,7 @@ static void wlc_bmac_tx_fifo_suspend(struct wlc_hw_info *wlc_hw, uint tx_fifo)
 	}
 }
 
-static void wlc_bmac_tx_fifo_resume(struct wlc_hw_info *wlc_hw, uint tx_fifo)
+static void brcms_b_tx_fifo_resume(struct wlc_hw_info *wlc_hw, uint tx_fifo)
 {
 	/* BMAC_NOTE: WLC_TX_FIFO_ENAB is done in wlc_dpc() for DMA case but need to be done
 	 * here for PIO otherwise the watchdog will catch the inconsistency and fire
@@ -2944,7 +2939,7 @@ bool wlc_isr(struct wlc_info *wlc, bool *wantdpc)
 }
 
 static bool
-wlc_bmac_dotxstatus(struct wlc_hw_info *wlc_hw, tx_status_t *txs, u32 s2)
+brcms_b_dotxstatus(struct wlc_hw_info *wlc_hw, tx_status_t *txs, u32 s2)
 {
 	/* discard intermediate indications for ucode with one legitimate case:
 	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange, but the subsequent
@@ -2963,7 +2958,7 @@ wlc_bmac_dotxstatus(struct wlc_hw_info *wlc_hw, tx_status_t *txs, u32 s2)
  * Return true if more tx status need to be processed. false otherwise.
  */
 static bool
-wlc_bmac_txstatus(struct wlc_hw_info *wlc_hw, bool bound, bool *fatal)
+brcms_b_txstatus(struct wlc_hw_info *wlc_hw, bool bound, bool *fatal)
 {
 	bool morepending = false;
 	struct wlc_info *wlc = wlc_hw->wlc;
@@ -2998,7 +2993,7 @@ wlc_bmac_txstatus(struct wlc_hw_info *wlc_hw, bool bound, bool *fatal)
 		txs->phyerr = (s2 & TXS_PTX_MASK) >> TXS_PTX_SHIFT;
 		txs->lasttxtime = 0;
 
-		*fatal = wlc_bmac_dotxstatus(wlc_hw, txs, s2);
+		*fatal = brcms_b_dotxstatus(wlc_hw, txs, s2);
 
 		/* !give others some time to run! */
 		if (++n >= max_tx_num)
@@ -3058,7 +3053,7 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 	}
 	WARN_ON(mi & MI_MACSSPNDD);
 
-	wlc_bmac_mctrl(wlc_hw, MCTL_EN_MAC, 0);
+	brcms_b_mctrl(wlc_hw, MCTL_EN_MAC, 0);
 
 	SPINWAIT(!(R_REG(&regs->macintstatus) & MI_MACSSPNDD),
 		 WLC_MAX_MAC_SUSPEND);
@@ -3107,7 +3102,7 @@ void wlc_enable_mac(struct wlc_info *wlc)
 	WARN_ON(mc & MCTL_EN_MAC);
 	WARN_ON(!(mc & MCTL_PSM_RUN));
 
-	wlc_bmac_mctrl(wlc_hw, MCTL_EN_MAC, MCTL_EN_MAC);
+	brcms_b_mctrl(wlc_hw, MCTL_EN_MAC, MCTL_EN_MAC);
 	W_REG(&regs->macintstatus, MI_MACSSPNDD);
 
 	mc = R_REG(&regs->maccontrol);
@@ -3139,23 +3134,23 @@ static void wlc_upd_ofdm_pctl1_table(struct wlc_hw_info *wlc_hw)
 	for (i = 0; i < ARRAY_SIZE(rates); i++) {
 		rate = rates[i];
 
-		entry_ptr = wlc_bmac_ofdm_ratetable_offset(wlc_hw, rate);
+		entry_ptr = brcms_b_ofdm_ratetable_offset(wlc_hw, rate);
 
 		/* read the SHM Rate Table entry OFDM PCTL1 values */
 		pctl1 =
-		    wlc_bmac_read_shm(wlc_hw, entry_ptr + M_RT_OFDM_PCTL1_POS);
+		    brcms_b_read_shm(wlc_hw, entry_ptr + M_RT_OFDM_PCTL1_POS);
 
 		/* modify the value */
 		pctl1 &= ~PHY_TXC1_MODE_MASK;
 		pctl1 |= (wlc_hw->hw_stf_ss_opmode << PHY_TXC1_MODE_SHIFT);
 
 		/* Update the SHM Rate Table entry OFDM PCTL1 values */
-		wlc_bmac_write_shm(wlc_hw, entry_ptr + M_RT_OFDM_PCTL1_POS,
+		brcms_b_write_shm(wlc_hw, entry_ptr + M_RT_OFDM_PCTL1_POS,
 				   pctl1);
 	}
 }
 
-static u16 wlc_bmac_ofdm_ratetable_offset(struct wlc_hw_info *wlc_hw, u8 rate)
+static u16 brcms_b_ofdm_ratetable_offset(struct wlc_hw_info *wlc_hw, u8 rate)
 {
 	uint i;
 	u8 plcp_rate = 0;
@@ -3185,10 +3180,10 @@ static u16 wlc_bmac_ofdm_ratetable_offset(struct wlc_hw_info *wlc_hw, u8 rate)
 	/* Find the SHM pointer to the rate table entry by looking in the
 	 * Direct-map Table
 	 */
-	return 2 * wlc_bmac_read_shm(wlc_hw, M_RT_DIRMAP_A + (plcp_rate * 2));
+	return 2 * brcms_b_read_shm(wlc_hw, M_RT_DIRMAP_A + (plcp_rate * 2));
 }
 
-void wlc_bmac_band_stf_ss_set(struct wlc_hw_info *wlc_hw, u8 stf_mode)
+void brcms_b_band_stf_ss_set(struct wlc_hw_info *wlc_hw, u8 stf_mode)
 {
 	wlc_hw->hw_stf_ss_opmode = stf_mode;
 
@@ -3197,7 +3192,7 @@ void wlc_bmac_band_stf_ss_set(struct wlc_hw_info *wlc_hw, u8 stf_mode)
 }
 
 void
-wlc_bmac_read_tsf(struct wlc_hw_info *wlc_hw, u32 *tsf_l_ptr,
+brcms_b_read_tsf(struct wlc_hw_info *wlc_hw, u32 *tsf_l_ptr,
 		  u32 *tsf_h_ptr)
 {
 	d11regs_t *regs = wlc_hw->regs;
@@ -3209,7 +3204,7 @@ wlc_bmac_read_tsf(struct wlc_hw_info *wlc_hw, u32 *tsf_l_ptr,
 	return;
 }
 
-static bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw)
+static bool brcms_b_validate_chip_access(struct wlc_hw_info *wlc_hw)
 {
 	d11regs_t *regs;
 	u32 w, val;
@@ -3274,7 +3269,7 @@ static bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw)
 
 #define PHYPLL_WAIT_US	100000
 
-void wlc_bmac_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on)
+void brcms_b_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on)
 {
 	d11regs_t *regs;
 	u32 tmp;
@@ -3347,7 +3342,7 @@ void wlc_coredisable(struct wlc_hw_info *wlc_hw)
 	wlc_phy_anacore(wlc_hw->band->pi, OFF);
 
 	/* turn off PHYPLL to save power */
-	wlc_bmac_core_phypll_ctl(wlc_hw, false);
+	brcms_b_core_phypll_ctl(wlc_hw, false);
 
 	/* No need to set wlc->pub->radio_active = OFF
 	 * because this function needs down capability and
@@ -3364,7 +3359,7 @@ void wlc_coredisable(struct wlc_hw_info *wlc_hw)
 }
 
 /* power both the pll and external oscillator on/off */
-static void wlc_bmac_xtal(struct wlc_hw_info *wlc_hw, bool want)
+static void brcms_b_xtal(struct wlc_hw_info *wlc_hw, bool want)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: want %d\n", wlc_hw->unit, want);
 
@@ -3402,18 +3397,18 @@ static void wlc_flushqueues(struct wlc_info *wlc)
 	dma_rxreclaim(wlc_hw->di[RX_FIFO]);
 }
 
-u16 wlc_bmac_read_shm(struct wlc_hw_info *wlc_hw, uint offset)
+u16 brcms_b_read_shm(struct wlc_hw_info *wlc_hw, uint offset)
 {
-	return wlc_bmac_read_objmem(wlc_hw, offset, OBJADDR_SHM_SEL);
+	return brcms_b_read_objmem(wlc_hw, offset, OBJADDR_SHM_SEL);
 }
 
-void wlc_bmac_write_shm(struct wlc_hw_info *wlc_hw, uint offset, u16 v)
+void brcms_b_write_shm(struct wlc_hw_info *wlc_hw, uint offset, u16 v)
 {
-	wlc_bmac_write_objmem(wlc_hw, offset, v, OBJADDR_SHM_SEL);
+	brcms_b_write_objmem(wlc_hw, offset, v, OBJADDR_SHM_SEL);
 }
 
 static u16
-wlc_bmac_read_objmem(struct wlc_hw_info *wlc_hw, uint offset, u32 sel)
+brcms_b_read_objmem(struct wlc_hw_info *wlc_hw, uint offset, u32 sel)
 {
 	d11regs_t *regs = wlc_hw->regs;
 	volatile u16 *objdata_lo = (volatile u16 *)&regs->objdata;
@@ -3432,7 +3427,7 @@ wlc_bmac_read_objmem(struct wlc_hw_info *wlc_hw, uint offset, u32 sel)
 }
 
 static void
-wlc_bmac_write_objmem(struct wlc_hw_info *wlc_hw, uint offset, u16 v, u32 sel)
+brcms_b_write_objmem(struct wlc_hw_info *wlc_hw, uint offset, u16 v, u32 sel)
 {
 	d11regs_t *regs = wlc_hw->regs;
 	volatile u16 *objdata_lo = (volatile u16 *)&regs->objdata;
@@ -3453,7 +3448,7 @@ wlc_bmac_write_objmem(struct wlc_hw_info *wlc_hw, uint offset, u16 v, u32 sel)
  * 'sel' selects the type of memory
  */
 void
-wlc_bmac_copyto_objmem(struct wlc_hw_info *wlc_hw, uint offset, const void *buf,
+brcms_b_copyto_objmem(struct wlc_hw_info *wlc_hw, uint offset, const void *buf,
 		       int len, u32 sel)
 {
 	u16 v;
@@ -3465,7 +3460,7 @@ wlc_bmac_copyto_objmem(struct wlc_hw_info *wlc_hw, uint offset, const void *buf,
 
 	for (i = 0; i < len; i += 2) {
 		v = p[i] | (p[i + 1] << 8);
-		wlc_bmac_write_objmem(wlc_hw, offset + i, v, sel);
+		brcms_b_write_objmem(wlc_hw, offset + i, v, sel);
 	}
 }
 
@@ -3475,7 +3470,7 @@ wlc_bmac_copyto_objmem(struct wlc_hw_info *wlc_hw, uint offset, const void *buf,
  * 'sel' selects the type of memory
  */
 void
-wlc_bmac_copyfrom_objmem(struct wlc_hw_info *wlc_hw, uint offset, void *buf,
+brcms_b_copyfrom_objmem(struct wlc_hw_info *wlc_hw, uint offset, void *buf,
 			 int len, u32 sel)
 {
 	u16 v;
@@ -3486,13 +3481,13 @@ wlc_bmac_copyfrom_objmem(struct wlc_hw_info *wlc_hw, uint offset, void *buf,
 		return;
 
 	for (i = 0; i < len; i += 2) {
-		v = wlc_bmac_read_objmem(wlc_hw, offset + i, sel);
+		v = brcms_b_read_objmem(wlc_hw, offset + i, sel);
 		p[i] = v & 0xFF;
 		p[i + 1] = (v >> 8) & 0xFF;
 	}
 }
 
-void wlc_bmac_copyfrom_vars(struct wlc_hw_info *wlc_hw, char **buf, uint *len)
+void brcms_b_copyfrom_vars(struct wlc_hw_info *wlc_hw, char **buf, uint *len)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "nvram vars totlen=%d\n",
 		wlc_hw->vars_size);
@@ -3501,7 +3496,7 @@ void wlc_bmac_copyfrom_vars(struct wlc_hw_info *wlc_hw, char **buf, uint *len)
 	*len = wlc_hw->vars_size;
 }
 
-void wlc_bmac_retrylimit_upd(struct wlc_hw_info *wlc_hw, u16 SRL, u16 LRL)
+void brcms_b_retrylimit_upd(struct wlc_hw_info *wlc_hw, u16 SRL, u16 LRL)
 {
 	wlc_hw->SRL = SRL;
 	wlc_hw->LRL = LRL;
@@ -3519,7 +3514,7 @@ void wlc_bmac_retrylimit_upd(struct wlc_hw_info *wlc_hw, u16 SRL, u16 LRL)
 	}
 }
 
-void wlc_bmac_pllreq(struct wlc_hw_info *wlc_hw, bool set, mbool req_bit)
+void brcms_b_pllreq(struct wlc_hw_info *wlc_hw, bool set, mbool req_bit)
 {
 	if (set) {
 		if (mboolisset(wlc_hw->pllreq, req_bit))
@@ -3529,7 +3524,7 @@ void wlc_bmac_pllreq(struct wlc_hw_info *wlc_hw, bool set, mbool req_bit)
 
 		if (mboolisset(wlc_hw->pllreq, WLC_PLLREQ_FLIP)) {
 			if (!wlc_hw->sbclk) {
-				wlc_bmac_xtal(wlc_hw, ON);
+				brcms_b_xtal(wlc_hw, ON);
 			}
 		}
 	} else {
@@ -3540,7 +3535,7 @@ void wlc_bmac_pllreq(struct wlc_hw_info *wlc_hw, bool set, mbool req_bit)
 
 		if (mboolisset(wlc_hw->pllreq, WLC_PLLREQ_FLIP)) {
 			if (wlc_hw->sbclk) {
-				wlc_bmac_xtal(wlc_hw, OFF);
+				brcms_b_xtal(wlc_hw, OFF);
 			}
 		}
 	}
@@ -3548,7 +3543,7 @@ void wlc_bmac_pllreq(struct wlc_hw_info *wlc_hw, bool set, mbool req_bit)
 	return;
 }
 
-u16 wlc_bmac_rate_shm_offset(struct wlc_hw_info *wlc_hw, u8 rate)
+u16 brcms_b_rate_shm_offset(struct wlc_hw_info *wlc_hw, u8 rate)
 {
 	u16 table_ptr;
 	u8 phy_rate, index;
@@ -3569,10 +3564,10 @@ u16 wlc_bmac_rate_shm_offset(struct wlc_hw_info *wlc_hw, u8 rate)
 	/* Find the SHM pointer to the rate table entry by looking in the
 	 * Direct-map Table
 	 */
-	return 2 * wlc_bmac_read_shm(wlc_hw, table_ptr + (index * 2));
+	return 2 * brcms_b_read_shm(wlc_hw, table_ptr + (index * 2));
 }
 
-void wlc_bmac_antsel_set(struct wlc_hw_info *wlc_hw, u32 antsel_avail)
+void brcms_b_antsel_set(struct wlc_hw_info *wlc_hw, u32 antsel_avail)
 {
 	wlc_hw->antsel_avail = antsel_avail;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.h b/drivers/staging/brcm80211/brcmsmac/bmac.h
index 58d9830..fe94685 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.h
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.h
@@ -21,7 +21,7 @@
 
 /* dup state between BMAC(struct wlc_hw_info) and HIGH(struct wlc_info)
    driver */
-struct wlc_bmac_state {
+struct brcms_b_state {
 	u32 machwcap;	/* mac hw capibility */
 	u32 preamble_ovr;	/* preamble override */
 };
@@ -71,100 +71,100 @@ enum {
 	IOV_BMAC_LAST
 };
 
-extern int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device,
+extern int brcms_b_attach(struct wlc_info *wlc, u16 vendor, u16 device,
 			   uint unit, bool piomode, void *regsva, uint bustype,
 			   void *btparam);
-extern int wlc_bmac_detach(struct wlc_info *wlc);
-extern void wlc_bmac_watchdog(void *arg);
+extern int brcms_b_detach(struct wlc_info *wlc);
+extern void brcms_b_watchdog(void *arg);
 
 /* up/down, reset, clk */
-extern void wlc_bmac_copyto_objmem(struct wlc_hw_info *wlc_hw,
+extern void brcms_b_copyto_objmem(struct wlc_hw_info *wlc_hw,
 				   uint offset, const void *buf, int len,
 				   u32 sel);
-extern void wlc_bmac_copyfrom_objmem(struct wlc_hw_info *wlc_hw, uint offset,
+extern void brcms_b_copyfrom_objmem(struct wlc_hw_info *wlc_hw, uint offset,
 				     void *buf, int len, u32 sel);
-#define wlc_bmac_copyfrom_shm(wlc_hw, offset, buf, len)                 \
-	wlc_bmac_copyfrom_objmem(wlc_hw, offset, buf, len, OBJADDR_SHM_SEL)
-#define wlc_bmac_copyto_shm(wlc_hw, offset, buf, len)                   \
-	wlc_bmac_copyto_objmem(wlc_hw, offset, buf, len, OBJADDR_SHM_SEL)
-
-extern void wlc_bmac_core_phypll_reset(struct wlc_hw_info *wlc_hw);
-extern void wlc_bmac_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on);
-extern void wlc_bmac_phyclk_fgc(struct wlc_hw_info *wlc_hw, bool clk);
-extern void wlc_bmac_macphyclk_set(struct wlc_hw_info *wlc_hw, bool clk);
-extern void wlc_bmac_phy_reset(struct wlc_hw_info *wlc_hw);
-extern void wlc_bmac_corereset(struct wlc_hw_info *wlc_hw, u32 flags);
-extern void wlc_bmac_reset(struct wlc_hw_info *wlc_hw);
-extern void wlc_bmac_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
+#define brcms_b_copyfrom_shm(wlc_hw, offset, buf, len)                 \
+	brcms_b_copyfrom_objmem(wlc_hw, offset, buf, len, OBJADDR_SHM_SEL)
+#define brcms_b_copyto_shm(wlc_hw, offset, buf, len)                   \
+	brcms_b_copyto_objmem(wlc_hw, offset, buf, len, OBJADDR_SHM_SEL)
+
+extern void brcms_b_core_phypll_reset(struct wlc_hw_info *wlc_hw);
+extern void brcms_b_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on);
+extern void brcms_b_phyclk_fgc(struct wlc_hw_info *wlc_hw, bool clk);
+extern void brcms_b_macphyclk_set(struct wlc_hw_info *wlc_hw, bool clk);
+extern void brcms_b_phy_reset(struct wlc_hw_info *wlc_hw);
+extern void brcms_b_corereset(struct wlc_hw_info *wlc_hw, u32 flags);
+extern void brcms_b_reset(struct wlc_hw_info *wlc_hw);
+extern void brcms_b_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 			  bool mute);
-extern int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw);
-extern int wlc_bmac_up_finish(struct wlc_hw_info *wlc_hw);
-extern int wlc_bmac_down_prep(struct wlc_hw_info *wlc_hw);
-extern int wlc_bmac_down_finish(struct wlc_hw_info *wlc_hw);
-extern void wlc_bmac_switch_macfreq(struct wlc_hw_info *wlc_hw, u8 spurmode);
+extern int brcms_b_up_prep(struct wlc_hw_info *wlc_hw);
+extern int brcms_b_up_finish(struct wlc_hw_info *wlc_hw);
+extern int brcms_b_bmac_down_prep(struct wlc_hw_info *wlc_hw);
+extern int brcms_b_down_finish(struct wlc_hw_info *wlc_hw);
+extern void brcms_b_switch_macfreq(struct wlc_hw_info *wlc_hw, u8 spurmode);
 
 /* chanspec, ucode interface */
-extern void wlc_bmac_set_chanspec(struct wlc_hw_info *wlc_hw,
+extern void brcms_b_set_chanspec(struct wlc_hw_info *wlc_hw,
 				  chanspec_t chanspec,
 				  bool mute, struct txpwr_limits *txpwr);
 
-extern int wlc_bmac_xmtfifo_sz_get(struct wlc_hw_info *wlc_hw, uint fifo,
+extern int brcms_b_xmtfifo_sz_get(struct wlc_hw_info *wlc_hw, uint fifo,
 				   uint *blocks);
-extern void wlc_bmac_mhf(struct wlc_hw_info *wlc_hw, u8 idx, u16 mask,
+extern void brcms_b_mhf(struct wlc_hw_info *wlc_hw, u8 idx, u16 mask,
 			 u16 val, int bands);
-extern void wlc_bmac_mctrl(struct wlc_hw_info *wlc_hw, u32 mask, u32 val);
-extern u16 wlc_bmac_mhf_get(struct wlc_hw_info *wlc_hw, u8 idx, int bands);
-extern void wlc_bmac_txant_set(struct wlc_hw_info *wlc_hw, u16 phytxant);
-extern u16 wlc_bmac_get_txant(struct wlc_hw_info *wlc_hw);
-extern void wlc_bmac_antsel_type_set(struct wlc_hw_info *wlc_hw,
+extern void brcms_b_mctrl(struct wlc_hw_info *wlc_hw, u32 mask, u32 val);
+extern u16 brcms_b_mhf_get(struct wlc_hw_info *wlc_hw, u8 idx, int bands);
+extern void brcms_b_txant_set(struct wlc_hw_info *wlc_hw, u16 phytxant);
+extern u16 brcms_b_get_txant(struct wlc_hw_info *wlc_hw);
+extern void brcms_b_antsel_type_set(struct wlc_hw_info *wlc_hw,
 				     u8 antsel_type);
-extern int wlc_bmac_state_get(struct wlc_hw_info *wlc_hw,
-			      wlc_bmac_state_t *state);
-extern void wlc_bmac_write_shm(struct wlc_hw_info *wlc_hw, uint offset, u16 v);
-extern u16 wlc_bmac_read_shm(struct wlc_hw_info *wlc_hw, uint offset);
-extern void wlc_bmac_write_template_ram(struct wlc_hw_info *wlc_hw, int offset,
+extern int brcms_b_state_get(struct wlc_hw_info *wlc_hw,
+			      brcms_b_state_t *state);
+extern void brcms_b_write_shm(struct wlc_hw_info *wlc_hw, uint offset, u16 v);
+extern u16 brcms_b_read_shm(struct wlc_hw_info *wlc_hw, uint offset);
+extern void brcms_b_write_template_ram(struct wlc_hw_info *wlc_hw, int offset,
 					int len, void *buf);
-extern void wlc_bmac_copyfrom_vars(struct wlc_hw_info *wlc_hw, char **buf,
+extern void brcms_b_copyfrom_vars(struct wlc_hw_info *wlc_hw, char **buf,
 				   uint *len);
 
-extern void wlc_bmac_hw_etheraddr(struct wlc_hw_info *wlc_hw,
+extern void brcms_b_hw_etheraddr(struct wlc_hw_info *wlc_hw,
 				  u8 *ea);
 
-extern bool wlc_bmac_radio_read_hwdisabled(struct wlc_hw_info *wlc_hw);
-extern void wlc_bmac_set_shortslot(struct wlc_hw_info *wlc_hw, bool shortslot);
-extern void wlc_bmac_band_stf_ss_set(struct wlc_hw_info *wlc_hw, u8 stf_mode);
+extern bool brcms_b_radio_read_hwdisabled(struct wlc_hw_info *wlc_hw);
+extern void brcms_b_set_shortslot(struct wlc_hw_info *wlc_hw, bool shortslot);
+extern void brcms_b_band_stf_ss_set(struct wlc_hw_info *wlc_hw, u8 stf_mode);
 
-extern void wlc_bmac_wait_for_wake(struct wlc_hw_info *wlc_hw);
+extern void brcms_b_wait_for_wake(struct wlc_hw_info *wlc_hw);
 
 extern void wlc_ucode_wake_override_set(struct wlc_hw_info *wlc_hw,
 					u32 override_bit);
 extern void wlc_ucode_wake_override_clear(struct wlc_hw_info *wlc_hw,
 					  u32 override_bit);
 
-extern void wlc_bmac_set_addrmatch(struct wlc_hw_info *wlc_hw,
+extern void brcms_b_set_addrmatch(struct wlc_hw_info *wlc_hw,
 				   int match_reg_offset,
 				   const u8 *addr);
-extern void wlc_bmac_write_hw_bcntemplates(struct wlc_hw_info *wlc_hw,
+extern void brcms_b_write_hw_bcntemplates(struct wlc_hw_info *wlc_hw,
 					   void *bcn, int len, bool both);
 
-extern void wlc_bmac_read_tsf(struct wlc_hw_info *wlc_hw, u32 *tsf_l_ptr,
+extern void brcms_b_read_tsf(struct wlc_hw_info *wlc_hw, u32 *tsf_l_ptr,
 			      u32 *tsf_h_ptr);
-extern void wlc_bmac_set_cwmin(struct wlc_hw_info *wlc_hw, u16 newmin);
-extern void wlc_bmac_set_cwmax(struct wlc_hw_info *wlc_hw, u16 newmax);
+extern void brcms_b_set_cwmin(struct wlc_hw_info *wlc_hw, u16 newmin);
+extern void brcms_b_set_cwmax(struct wlc_hw_info *wlc_hw, u16 newmax);
 
-extern void wlc_bmac_retrylimit_upd(struct wlc_hw_info *wlc_hw, u16 SRL,
+extern void brcms_b_retrylimit_upd(struct wlc_hw_info *wlc_hw, u16 SRL,
 				    u16 LRL);
 
-extern void wlc_bmac_fifoerrors(struct wlc_hw_info *wlc_hw);
+extern void brcms_b_fifoerrors(struct wlc_hw_info *wlc_hw);
 
 
 /* API for BMAC driver (e.g. wlc_phy.c etc) */
 
-extern void wlc_bmac_bw_set(struct wlc_hw_info *wlc_hw, u16 bw);
-extern void wlc_bmac_pllreq(struct wlc_hw_info *wlc_hw, bool set,
+extern void brcms_b_bw_set(struct wlc_hw_info *wlc_hw, u16 bw);
+extern void brcms_b_pllreq(struct wlc_hw_info *wlc_hw, bool set,
 			    mbool req_bit);
-extern void wlc_bmac_hw_up(struct wlc_hw_info *wlc_hw);
-extern u16 wlc_bmac_rate_shm_offset(struct wlc_hw_info *wlc_hw, u8 rate);
-extern void wlc_bmac_antsel_set(struct wlc_hw_info *wlc_hw, u32 antsel_avail);
+extern void brcms_b_hw_up(struct wlc_hw_info *wlc_hw);
+extern u16 brcms_b_rate_shm_offset(struct wlc_hw_info *wlc_hw, u8 rate);
+extern void brcms_b_antsel_set(struct wlc_hw_info *wlc_hw, u32 antsel_avail);
 
 #endif /* _BRCM_BOTTOM_MAC_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 011c490..9ed7a87 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -1122,7 +1122,7 @@ wlc_channel_set_chanspec(wlc_cm_info_t *wlc_cm, chanspec_t chanspec,
 	wlc_channel_min_txpower_limits_with_local_constraint(wlc_cm, &txpwr,
 							     local_constraint_qdbm);
 
-	wlc_bmac_set_chanspec(wlc->hw, chanspec,
+	brcms_b_set_chanspec(wlc->hw, chanspec,
 			      (wlc_quiet_chanspec(wlc_cm, chanspec) != 0),
 			      &txpwr);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 3244751..34438ac 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -165,7 +165,7 @@
  */
 
 /* To inform the ucode of the last mcast frame posted so that it can clear moredata bit */
-#define BCMCFID(wlc, fid) wlc_bmac_write_shm((wlc)->hw, M_BCMC_FID, (fid))
+#define BCMCFID(wlc, fid) brcms_b_write_shm((wlc)->hw, M_BCMC_FID, (fid))
 
 #define WLC_WAR16165(wlc) (wlc->pub->sih->bustype == PCI_BUS && \
 				(!AP_ENAB(wlc->pub)) && (wlc->war16165))
@@ -416,7 +416,7 @@ void wlc_reset(struct wlc_info *wlc)
 	memset((char *)wlc->core->macstat_snapshot, 0,
 		sizeof(macstat_t));
 
-	wlc_bmac_reset(wlc->hw);
+	brcms_b_reset(wlc->hw);
 }
 
 void wlc_fatal_error(struct wlc_info *wlc)
@@ -470,7 +470,7 @@ void wlc_init(struct wlc_info *wlc)
 	else
 		chanspec = wlc_init_chanspec(wlc);
 
-	wlc_bmac_init(wlc->hw, chanspec, mute);
+	brcms_b_init(wlc->hw, chanspec, mute);
 
 	/* update beacon listen interval */
 	wlc_bcn_li_upd(wlc);
@@ -632,7 +632,7 @@ void wlc_set_ps_ctrl(struct wlc_info *wlc)
 	awake_before = ((v1 & MCTL_WAKE) || ((v1 & MCTL_HPS) == 0));
 
 	if (!awake_before)
-		wlc_bmac_wait_for_wake(wlc->hw);
+		brcms_b_wait_for_wake(wlc->hw);
 
 }
 
@@ -702,7 +702,7 @@ void wlc_switch_shortslot(struct wlc_info *wlc, bool shortslot)
 					WLAN_CAPABILITY_SHORT_SLOT_TIME;
 	}
 
-	wlc_bmac_set_shortslot(wlc->hw, shortslot);
+	brcms_b_set_shortslot(wlc->hw, shortslot);
 }
 
 static u8 wlc_local_constraint_qdbm(struct wlc_info *wlc)
@@ -793,10 +793,13 @@ void wlc_set_chanspec(struct wlc_info *wlc, chanspec_t chanspec)
 					  CHSPEC_CHANNEL(chanspec));
 				return;
 			}
-			/* BMAC_NOTE: should the setband call come after the wlc_bmac_chanspec() ?
-			 * if the setband updates (wlc_bsinit) use low level calls to inspect and
-			 * set state, the state inspected may be from the wrong band, or the
-			 * following wlc_bmac_set_chanspec() may undo the work.
+			/*
+			 * should the setband call come after the
+			 * brcms_b_chanspec() ? if the setband updates
+			 * (wlc_bsinit) use low level calls to inspect and
+			 * set state, the state inspected may be from the wrong
+			 * band, or the following brcms_b_set_chanspec() may
+			 * undo the work.
 			 */
 			wlc_setband(wlc, bandunit);
 		}
@@ -1291,9 +1294,9 @@ void wlc_info_init(struct wlc_info *wlc, int unit)
 
 static bool wlc_state_bmac_sync(struct wlc_info *wlc)
 {
-	wlc_bmac_state_t state_bmac;
+	brcms_b_state_t state_bmac;
 
-	if (wlc_bmac_state_get(wlc->hw, &state_bmac) != 0)
+	if (brcms_b_state_get(wlc->hw, &state_bmac) != 0)
 		return false;
 
 	wlc->machwcap = state_bmac.machwcap;
@@ -1386,7 +1389,7 @@ void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	 * low level attach steps(all hw accesses go
 	 * inside, no more in rest of the attach)
 	 */
-	err = wlc_bmac_attach(wlc, vendor, device, unit, piomode, regsva,
+	err = brcms_b_attach(wlc, vendor, device, unit, piomode, regsva,
 			      bustype, btparam);
 	if (err)
 		goto fail;
@@ -1402,7 +1405,7 @@ void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	pub->phy_11ncapable = WLC_PHY_11N_CAP(wlc->band);
 
 	/* propagate *vars* from BMAC driver to high driver */
-	wlc_bmac_copyfrom_vars(wlc->hw, &pub->vars, &wlc->vars_size);
+	brcms_b_copyfrom_vars(wlc->hw, &pub->vars, &wlc->vars_size);
 
 
 	/* set maximum allowed duty cycle */
@@ -1428,7 +1431,7 @@ void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 			wlc->core->txavail[i] = wlc->hw->txavail[i];
 	}
 
-	wlc_bmac_hw_etheraddr(wlc->hw, wlc->perm_etheraddr);
+	brcms_b_hw_etheraddr(wlc->hw, wlc->perm_etheraddr);
 
 	memcpy(&pub->cur_etheraddr, &wlc->perm_etheraddr, ETH_ALEN);
 
@@ -1576,10 +1579,10 @@ void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	if ((wlc->pub->sih->chip) == BCM43235_CHIP_ID) {
 		if ((getintvar(wlc->pub->vars, "aa2g") == 7) ||
 		    (getintvar(wlc->pub->vars, "aa5g") == 7)) {
-			wlc_bmac_antsel_set(wlc->hw, 1);
+			brcms_b_antsel_set(wlc->hw, 1);
 		}
 	} else {
-		wlc_bmac_antsel_set(wlc->hw, wlc->asi->antsel_avail);
+		brcms_b_antsel_set(wlc->hw, wlc->asi->antsel_avail);
 	}
 
 	if (perr)
@@ -1716,7 +1719,7 @@ uint wlc_detach(struct wlc_info *wlc)
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
-	callbacks += wlc_bmac_detach(wlc);
+	callbacks += brcms_b_detach(wlc);
 
 	/* delete software timers */
 	if (!wlc_radio_monitor_stop(wlc))
@@ -1754,7 +1757,7 @@ static void wlc_radio_hwdisable_upd(struct wlc_info *wlc)
 	if (wlc->pub->wlfeatureflag & WL_SWFL_NOHWRADIO || wlc->pub->hw_off)
 		return;
 
-	if (wlc_bmac_radio_read_hwdisabled(wlc->hw)) {
+	if (brcms_b_radio_read_hwdisabled(wlc->hw)) {
 		mboolset(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE);
 	} else {
 		mboolclr(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE);
@@ -1969,7 +1972,7 @@ static void wlc_watchdog(void *arg)
 	if (wlc->pub->radio_disabled)
 		return;
 
-	wlc_bmac_watchdog(wlc);
+	brcms_b_watchdog(wlc);
 
 	/* occasionally sample mac stat counters to detect 16-bit counter wrap */
 	if ((wlc->pub->now % SW_TIMER_MAC_STAT_UPD) == 0)
@@ -2009,7 +2012,7 @@ int wlc_up(struct wlc_info *wlc)
 		return -ENOMEDIUM;
 
 	if (!wlc->pub->hw_up) {
-		wlc_bmac_hw_up(wlc->hw);
+		brcms_b_hw_up(wlc->hw);
 		wlc->pub->hw_up = true;
 	}
 
@@ -2031,10 +2034,10 @@ int wlc_up(struct wlc_info *wlc)
 	 * if radio is disabled, abort up, lower power, start radio timer and return 0(for NDIS)
 	 * don't call radio_update to avoid looping wlc_up.
 	 *
-	 * wlc_bmac_up_prep() returns either 0 or -BCME_RADIOOFF only
+	 * brcms_b_up_prep() returns either 0 or -BCME_RADIOOFF only
 	 */
 	if (!wlc->pub->radio_disabled) {
-		int status = wlc_bmac_up_prep(wlc->hw);
+		int status = brcms_b_up_prep(wlc->hw);
 		if (status == -ENOMEDIUM) {
 			if (!mboolisset
 			    (wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE)) {
@@ -2061,7 +2064,7 @@ int wlc_up(struct wlc_info *wlc)
 		return 0;
 	}
 
-	/* wlc_bmac_up_prep has done wlc_corereset(). so clk is on, set it */
+	/* brcms_b_up_prep has done wlc_corereset(). so clk is on, set it */
 	wlc->clk = true;
 
 	wlc_radio_monitor_stop(wlc);
@@ -2087,7 +2090,7 @@ int wlc_up(struct wlc_info *wlc)
 		wlc_enable_mac(wlc);
 	}
 
-	wlc_bmac_up_finish(wlc->hw);
+	brcms_b_up_finish(wlc->hw);
 
 	/* other software states up after ISR is running */
 	/* start APs that were to be brought up but are not up  yet */
@@ -2162,7 +2165,7 @@ uint wlc_down(struct wlc_info *wlc)
 	/* in between, mpc could try to bring down again.. */
 	wlc->going_down = true;
 
-	callbacks += wlc_bmac_down_prep(wlc->hw);
+	callbacks += brcms_b_bmac_down_prep(wlc->hw);
 
 	dev_gone = DEVICEREMOVED(wlc);
 
@@ -2194,9 +2197,9 @@ uint wlc_down(struct wlc_info *wlc)
 		brcmu_pktq_flush(&qi->q, true, NULL, NULL);
 	}
 
-	callbacks += wlc_bmac_down_finish(wlc->hw);
+	callbacks += brcms_b_down_finish(wlc->hw);
 
-	/* wlc_bmac_down_finish has done wlc_coredisable(). so clk is off */
+	/* brcms_b_down_finish has done wlc_coredisable(). so clk is off */
 	wlc->clk = false;
 
 	wlc->going_down = false;
@@ -2598,7 +2601,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			int ac;
 			wlc->SRL = (u16) val;
 
-			wlc_bmac_retrylimit_upd(wlc->hw, wlc->SRL, wlc->LRL);
+			brcms_b_retrylimit_upd(wlc->hw, wlc->SRL, wlc->LRL);
 
 			for (ac = 0; ac < AC_COUNT; ac++) {
 				WLC_WME_RETRY_SHORT_SET(wlc, ac, wlc->SRL);
@@ -2613,7 +2616,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			int ac;
 			wlc->LRL = (u16) val;
 
-			wlc_bmac_retrylimit_upd(wlc->hw, wlc->SRL, wlc->LRL);
+			brcms_b_retrylimit_upd(wlc->hw, wlc->SRL, wlc->LRL);
 
 			for (ac = 0; ac < AC_COUNT; ac++) {
 				WLC_WME_RETRY_LONG_SET(wlc, ac, wlc->LRL);
@@ -2889,8 +2892,8 @@ void wlc_statsupd(struct wlc_info *wlc)
 #endif				/* BCMDBG */
 
 	/* Read mac stats from contiguous shared memory */
-	wlc_bmac_copyfrom_shm(wlc->hw, M_UCODE_MACSTAT,
-			      &macstats, sizeof(macstat_t));
+	brcms_b_copyfrom_shm(wlc->hw, M_UCODE_MACSTAT,
+			     &macstats, sizeof(macstat_t));
 
 #ifdef BCMDBG
 	/* check for rx fifo 0 overflow */
@@ -3066,7 +3069,7 @@ void wlc_print_rxh(d11rxhdr_t *rxh)
 
 static u16 wlc_rate_shm_offset(struct wlc_info *wlc, u8 rate)
 {
-	return wlc_bmac_rate_shm_offset(wlc->hw, rate);
+	return brcms_b_rate_shm_offset(wlc->hw, rate);
 }
 
 /* Callback for device removed */
@@ -3305,7 +3308,7 @@ wlc_txfifo(struct wlc_info *wlc, uint fifo, struct sk_buff *p, bool commit,
 
 
 	/* Bump up pending count for if not using rpc. If rpc is used, this will be handled
-	 * in wlc_bmac_txfifo()
+	 * in brcms_b_txfifo()
 	 */
 	if (commit) {
 		TXPKTPENDINC(wlc, fifo, txpktpend);
@@ -4457,7 +4460,7 @@ void wlc_bcn_li_upd(struct wlc_info *wlc)
  * |<---------- tsf_h ----------->||<--- tsf_l -->||<-RxTSFTime ->|
  *
  * The RxTSFTime are the lowest 16 bits and provided by the ucode. The
- * tsf_l is filled in by wlc_bmac_recv, which is done earlier in the
+ * tsf_l is filled in by brcms_b_recv, which is done earlier in the
  * receive call sequence after rx interrupt. Only the higher 16 bits
  * are used. Finally, the tsf_h is read from the tsf register.
  */
@@ -4466,7 +4469,7 @@ static u64 wlc_recover_tsf64(struct wlc_info *wlc, struct wlc_d11rxhdr *rxh)
 	u32 tsf_h, tsf_l;
 	u16 rx_tsf_0_15, rx_tsf_16_31;
 
-	wlc_bmac_read_tsf(wlc->hw, &tsf_l, &tsf_h);
+	brcms_b_read_tsf(wlc->hw, &tsf_l, &tsf_h);
 
 	rx_tsf_16_31 = (u16)(tsf_l >> 16);
 	rx_tsf_0_15 = rxh->rxhdr.RxTSFTime;
@@ -5368,7 +5371,7 @@ wlc_bss_update_probe_resp(struct wlc_info *wlc, struct wlc_bsscfg *cfg,
 			wlc_suspend_mac_and_wait(wlc);
 
 		/* write the probe response into the template region */
-		wlc_bmac_write_template_ram(wlc->hw, T_PRS_TPL_BASE,
+		brcms_b_write_template_ram(wlc->hw, T_PRS_TPL_BASE,
 					    (len + 3) & ~3, prb_resp);
 
 		/* write the length of the probe response frame (+PLCP/-FCS) */
@@ -5626,7 +5629,7 @@ wlc_duty_cycle_set(struct wlc_info *wlc, int duty_cycle, bool isOFDM,
  */
 u16 wlc_read_shm(struct wlc_info *wlc, uint offset)
 {
-	return wlc_bmac_read_shm(wlc->hw, offset);
+	return brcms_b_read_shm(wlc->hw, offset);
 }
 
 /* Write a single u16 to shared memory.
@@ -5634,7 +5637,7 @@ u16 wlc_read_shm(struct wlc_info *wlc, uint offset)
  */
 void wlc_write_shm(struct wlc_info *wlc, uint offset, u16 v)
 {
-	wlc_bmac_write_shm(wlc->hw, offset, v);
+	brcms_b_write_shm(wlc->hw, offset, v);
 }
 
 /* Copy a buffer to shared memory.
@@ -5647,50 +5650,50 @@ void wlc_copyto_shm(struct wlc_info *wlc, uint offset, const void *buf, int len)
 	if (len <= 0 || (offset & 1) || (len & 1))
 		return;
 
-	wlc_bmac_copyto_objmem(wlc->hw, offset, buf, len, OBJADDR_SHM_SEL);
+	brcms_b_copyto_objmem(wlc->hw, offset, buf, len, OBJADDR_SHM_SEL);
 
 }
 
 /* wrapper BMAC functions to for HIGH driver access */
 void wlc_mctrl(struct wlc_info *wlc, u32 mask, u32 val)
 {
-	wlc_bmac_mctrl(wlc->hw, mask, val);
+	brcms_b_mctrl(wlc->hw, mask, val);
 }
 
 void wlc_mhf(struct wlc_info *wlc, u8 idx, u16 mask, u16 val, int bands)
 {
-	wlc_bmac_mhf(wlc->hw, idx, mask, val, bands);
+	brcms_b_mhf(wlc->hw, idx, mask, val, bands);
 }
 
 int wlc_xmtfifo_sz_get(struct wlc_info *wlc, uint fifo, uint *blocks)
 {
-	return wlc_bmac_xmtfifo_sz_get(wlc->hw, fifo, blocks);
+	return brcms_b_xmtfifo_sz_get(wlc->hw, fifo, blocks);
 }
 
 void wlc_write_template_ram(struct wlc_info *wlc, int offset, int len,
 			    void *buf)
 {
-	wlc_bmac_write_template_ram(wlc->hw, offset, len, buf);
+	brcms_b_write_template_ram(wlc->hw, offset, len, buf);
 }
 
 void wlc_write_hw_bcntemplates(struct wlc_info *wlc, void *bcn, int len,
 			       bool both)
 {
-	wlc_bmac_write_hw_bcntemplates(wlc->hw, bcn, len, both);
+	brcms_b_write_hw_bcntemplates(wlc->hw, bcn, len, both);
 }
 
 void
 wlc_set_addrmatch(struct wlc_info *wlc, int match_reg_offset,
 		  const u8 *addr)
 {
-	wlc_bmac_set_addrmatch(wlc->hw, match_reg_offset, addr);
+	brcms_b_set_addrmatch(wlc->hw, match_reg_offset, addr);
 	if (match_reg_offset == RCM_BSSID_OFFSET)
 		memcpy(wlc->cfg->BSSID, addr, ETH_ALEN);
 }
 
 void wlc_pllreq(struct wlc_info *wlc, bool set, mbool req_bit)
 {
-	wlc_bmac_pllreq(wlc->hw, set, req_bit);
+	brcms_b_pllreq(wlc->hw, set, req_bit);
 }
 
 void wlc_reset_bmac_done(struct wlc_info *wlc)
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index 3fa2cfb..972898b 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -100,24 +100,24 @@ void wlapi_intrsrestore(wlc_phy_shim_info_t *physhim, u32 macintmask)
 
 void wlapi_bmac_write_shm(wlc_phy_shim_info_t *physhim, uint offset, u16 v)
 {
-	wlc_bmac_write_shm(physhim->wlc_hw, offset, v);
+	brcms_b_write_shm(physhim->wlc_hw, offset, v);
 }
 
 u16 wlapi_bmac_read_shm(wlc_phy_shim_info_t *physhim, uint offset)
 {
-	return wlc_bmac_read_shm(physhim->wlc_hw, offset);
+	return brcms_b_read_shm(physhim->wlc_hw, offset);
 }
 
 void
 wlapi_bmac_mhf(wlc_phy_shim_info_t *physhim, u8 idx, u16 mask,
 	       u16 val, int bands)
 {
-	wlc_bmac_mhf(physhim->wlc_hw, idx, mask, val, bands);
+	brcms_b_mhf(physhim->wlc_hw, idx, mask, val, bands);
 }
 
 void wlapi_bmac_corereset(wlc_phy_shim_info_t *physhim, u32 flags)
 {
-	wlc_bmac_corereset(physhim->wlc_hw, flags);
+	brcms_b_corereset(physhim->wlc_hw, flags);
 }
 
 void wlapi_suspend_mac_and_wait(wlc_phy_shim_info_t *physhim)
@@ -127,7 +127,7 @@ void wlapi_suspend_mac_and_wait(wlc_phy_shim_info_t *physhim)
 
 void wlapi_switch_macfreq(wlc_phy_shim_info_t *physhim, u8 spurmode)
 {
-	wlc_bmac_switch_macfreq(physhim->wlc_hw, spurmode);
+	brcms_b_switch_macfreq(physhim->wlc_hw, spurmode);
 }
 
 void wlapi_enable_mac(wlc_phy_shim_info_t *physhim)
@@ -137,42 +137,42 @@ void wlapi_enable_mac(wlc_phy_shim_info_t *physhim)
 
 void wlapi_bmac_mctrl(wlc_phy_shim_info_t *physhim, u32 mask, u32 val)
 {
-	wlc_bmac_mctrl(physhim->wlc_hw, mask, val);
+	brcms_b_mctrl(physhim->wlc_hw, mask, val);
 }
 
 void wlapi_bmac_phy_reset(wlc_phy_shim_info_t *physhim)
 {
-	wlc_bmac_phy_reset(physhim->wlc_hw);
+	brcms_b_phy_reset(physhim->wlc_hw);
 }
 
 void wlapi_bmac_bw_set(wlc_phy_shim_info_t *physhim, u16 bw)
 {
-	wlc_bmac_bw_set(physhim->wlc_hw, bw);
+	brcms_b_bw_set(physhim->wlc_hw, bw);
 }
 
 u16 wlapi_bmac_get_txant(wlc_phy_shim_info_t *physhim)
 {
-	return wlc_bmac_get_txant(physhim->wlc_hw);
+	return brcms_b_get_txant(physhim->wlc_hw);
 }
 
 void wlapi_bmac_phyclk_fgc(wlc_phy_shim_info_t *physhim, bool clk)
 {
-	wlc_bmac_phyclk_fgc(physhim->wlc_hw, clk);
+	brcms_b_phyclk_fgc(physhim->wlc_hw, clk);
 }
 
 void wlapi_bmac_macphyclk_set(wlc_phy_shim_info_t *physhim, bool clk)
 {
-	wlc_bmac_macphyclk_set(physhim->wlc_hw, clk);
+	brcms_b_macphyclk_set(physhim->wlc_hw, clk);
 }
 
 void wlapi_bmac_core_phypll_ctl(wlc_phy_shim_info_t *physhim, bool on)
 {
-	wlc_bmac_core_phypll_ctl(physhim->wlc_hw, on);
+	brcms_b_core_phypll_ctl(physhim->wlc_hw, on);
 }
 
 void wlapi_bmac_core_phypll_reset(wlc_phy_shim_info_t *physhim)
 {
-	wlc_bmac_core_phypll_reset(physhim->wlc_hw);
+	brcms_b_core_phypll_reset(physhim->wlc_hw);
 }
 
 void wlapi_bmac_ucode_wake_override_phyreg_set(wlc_phy_shim_info_t *physhim)
@@ -190,12 +190,12 @@ void
 wlapi_bmac_write_template_ram(wlc_phy_shim_info_t *physhim, int offset,
 			      int len, void *buf)
 {
-	wlc_bmac_write_template_ram(physhim->wlc_hw, offset, len, buf);
+	brcms_b_write_template_ram(physhim->wlc_hw, offset, len, buf);
 }
 
 u16 wlapi_bmac_rate_shm_offset(wlc_phy_shim_info_t *physhim, u8 rate)
 {
-	return wlc_bmac_rate_shm_offset(physhim->wlc_hw, rate);
+	return brcms_b_rate_shm_offset(physhim->wlc_hw, rate);
 }
 
 void wlapi_ucode_sample_init(wlc_phy_shim_info_t *physhim)
@@ -206,12 +206,12 @@ void
 wlapi_copyfrom_objmem(wlc_phy_shim_info_t *physhim, uint offset, void *buf,
 		      int len, u32 sel)
 {
-	wlc_bmac_copyfrom_objmem(physhim->wlc_hw, offset, buf, len, sel);
+	brcms_b_copyfrom_objmem(physhim->wlc_hw, offset, buf, len, sel);
 }
 
 void
 wlapi_copyto_objmem(wlc_phy_shim_info_t *physhim, uint offset, const void *buf,
 		    int l, u32 sel)
 {
-	wlc_bmac_copyto_objmem(physhim->wlc_hw, offset, buf, l, sel);
+	brcms_b_copyto_objmem(physhim->wlc_hw, offset, buf, l, sel);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 3a264ec..41dd168 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -194,7 +194,7 @@ static int wlc_stf_txcore_set(struct wlc_info *wlc, u8 Nsts, u8 core_mask)
 		 * frames when 1 stream core map changed
 		 */
 		wlc->stf->phytxant = core_mask << PHY_TXC_ANT_SHIFT;
-		wlc_bmac_txant_set(wlc->hw, wlc->stf->phytxant);
+		brcms_b_txant_set(wlc->hw, wlc->stf->phytxant);
 		if (wlc->clk) {
 			wlc_suspend_mac_and_wait(wlc);
 			wlc_beacon_phytxctl_txant_upd(wlc, wlc->bcn_rspec);
@@ -314,7 +314,7 @@ int wlc_stf_ss_update(struct wlc_info *wlc, struct wlcband *band)
 	}
 	if (prev_stf_ss != upd_stf_ss) {
 		wlc->stf->ss_opmode = upd_stf_ss;
-		wlc_bmac_band_stf_ss_set(wlc->hw, upd_stf_ss);
+		brcms_b_band_stf_ss_set(wlc->hw, upd_stf_ss);
 	}
 
 	return ret_code;
@@ -396,7 +396,7 @@ static void _wlc_stf_phy_txant_upd(struct wlc_info *wlc)
 			wlc->stf->phytxant = PHY_TXC_OLD_ANT_LAST;
 	}
 
-	wlc_bmac_txant_set(wlc->hw, wlc->stf->phytxant);
+	brcms_b_txant_set(wlc->hw, wlc->stf->phytxant);
 }
 
 void wlc_stf_phy_txant_upd(struct wlc_info *wlc)
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 1619e6a..c4f7d9d 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -374,7 +374,7 @@ struct wlcband;
 
 typedef struct gpioh_item gpioh_item_t;
 typedef struct si_info si_info_t;
-typedef struct wlc_bmac_state wlc_bmac_state_t;
+typedef struct brcms_b_state brcms_b_state_t;
 typedef struct locale_info locale_info_t;
 typedef struct locale_mimo_info locale_mimo_info_t;
 typedef struct country_info country_info_t;
-- 
1.7.4.1


