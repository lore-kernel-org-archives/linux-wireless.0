Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2084 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932370Ab1GNV3t (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:29:49 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 03/35] staging: brcm80211: shuffled sections in main.c
Date: Thu, 14 Jul 2011 14:28:59 -0700
Message-ID: <1310678971-28952-4-git-send-email-frankyl@broadcom.com> (sfid-20110714_232957_648441_02FE0518)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Moved bmac functions above 'common' functions invoking them. This facilitates
merging these functions in a later commit. Also declared locally used
functions static.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c | 2250 ++++++++++++++---------------
 1 files changed, 1092 insertions(+), 1158 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 8399bf3..bd3d5f0 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -271,7 +271,6 @@ struct brcms_b_state {
 
 /* local prototypes */
 static void brcms_b_clkctl_clk(struct brcms_hardware *wlc, uint mode);
-static void brcms_b_coreinit(struct brcms_c_info *wlc);
 
 /* used by wlc_wakeucode_init() */
 static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
@@ -281,13 +280,6 @@ static void brcms_ucode_write(struct brcms_hardware *wlc_hw, const u32 ucode[],
 static void brcms_ucode_download(struct brcms_hardware *wlc);
 static void brcms_c_ucode_txant_set(struct brcms_hardware *wlc_hw);
 
-/* used by brcms_c_dpc() */
-static bool brcms_b_dotxstatus(struct brcms_hardware *wlc,
-			       struct tx_status *txs, u32 s2);
-static bool brcms_b_txstatus(struct brcms_hardware *wlc, bool bound,
-			     bool *fatal);
-static bool brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound);
-
 /* used by brcms_c_down() */
 static void brcms_c_flushqueues(struct brcms_c_info *wlc);
 
@@ -296,8 +288,6 @@ static void brcms_c_mctrl_reset(struct brcms_hardware *wlc_hw);
 static void brcms_b_corerev_fifofixup(struct brcms_hardware *wlc_hw);
 static bool brcms_b_tx_fifo_suspended(struct brcms_hardware *wlc_hw,
 				       uint tx_fifo);
-static void brcms_b_tx_fifo_suspend(struct brcms_hardware *wlc_hw,
-				    uint tx_fifo);
 static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
 				   uint tx_fifo);
 
@@ -305,66 +295,38 @@ static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
 
 struct brcms_b_state;
 
-extern int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
+static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 			   uint unit, bool piomode, void *regsva, uint bustype,
 			   void *btparam);
-extern int brcms_b_detach(struct brcms_c_info *wlc);
-extern void brcms_b_watchdog(void *arg);
 
 /* up/down, reset, clk */
-extern void brcms_b_reset(struct brcms_hardware *wlc_hw);
-extern void brcms_b_init(struct brcms_hardware *wlc_hw, chanspec_t chanspec,
-			  bool mute);
-extern int brcms_b_up_prep(struct brcms_hardware *wlc_hw);
-extern int brcms_b_up_finish(struct brcms_hardware *wlc_hw);
-extern int brcms_b_bmac_down_prep(struct brcms_hardware *wlc_hw);
-extern int brcms_b_down_finish(struct brcms_hardware *wlc_hw);
-
-extern int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
-				   uint *blocks);
-extern u16 brcms_b_mhf_get(struct brcms_hardware *wlc_hw, u8 idx, int bands);
-extern int brcms_b_state_get(struct brcms_hardware *wlc_hw,
+static void brcms_b_reset(struct brcms_hardware *wlc_hw);
+static int brcms_b_state_get(struct brcms_hardware *wlc_hw,
 			      struct brcms_b_state *state);
-extern void brcms_b_copyfrom_vars(struct brcms_hardware *wlc_hw, char **buf,
+static void brcms_b_copyfrom_vars(struct brcms_hardware *wlc_hw, char **buf,
 				   uint *len);
 
-extern void brcms_b_hw_etheraddr(struct brcms_hardware *wlc_hw,
+static void brcms_b_hw_etheraddr(struct brcms_hardware *wlc_hw,
 				  u8 *ea);
 
-extern bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw);
-extern void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw,
-				  bool shortslot);
-
-extern void brcms_b_wait_for_wake(struct brcms_hardware *wlc_hw);
+static bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw);
+static void brcms_b_wait_for_wake(struct brcms_hardware *wlc_hw);
 
-extern void brcms_b_set_addrmatch(struct brcms_hardware *wlc_hw,
+static void brcms_b_set_addrmatch(struct brcms_hardware *wlc_hw,
 				   int match_reg_offset,
 				   const u8 *addr);
-extern void brcms_b_write_hw_bcntemplates(struct brcms_hardware *wlc_hw,
-					   void *bcn, int len, bool both);
+static void brcms_b_set_cwmin(struct brcms_hardware *wlc_hw, u16 newmin);
+static void brcms_b_set_cwmax(struct brcms_hardware *wlc_hw, u16 newmax);
 
-extern void brcms_b_read_tsf(struct brcms_hardware *wlc_hw, u32 *tsf_l_ptr,
-			      u32 *tsf_h_ptr);
-extern void brcms_b_set_cwmin(struct brcms_hardware *wlc_hw, u16 newmin);
-extern void brcms_b_set_cwmax(struct brcms_hardware *wlc_hw, u16 newmax);
-
-extern void brcms_b_retrylimit_upd(struct brcms_hardware *wlc_hw, u16 SRL,
+static void brcms_b_retrylimit_upd(struct brcms_hardware *wlc_hw, u16 SRL,
 				    u16 LRL);
 
-extern void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw);
-
+static void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw);
 
-/* API for BMAC driver (e.g. wlc_phy.c etc) */
-
-extern void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set,
+static void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set,
 			    mbool req_bit);
-extern void brcms_b_hw_up(struct brcms_hardware *wlc_hw);
-extern void brcms_b_antsel_set(struct brcms_hardware *wlc_hw,
+static void brcms_b_antsel_set(struct brcms_hardware *wlc_hw,
 			       u32 antsel_avail);
-
-
-
-
 static int brcms_b_bandtype(struct brcms_hardware *wlc_hw);
 static void brcms_b_info_init(struct brcms_hardware *wlc_hw);
 static void brcms_b_xtal(struct brcms_hardware *wlc_hw, bool want);
@@ -546,19 +508,6 @@ static const char fifo_names[6][0];
 static struct brcms_c_info *wlc_info_dbg = (struct brcms_c_info *) (NULL);
 #endif
 
-/* === Low Level functions === */
-
-void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw, bool shortslot)
-{
-	wlc_hw->shortslot = shortslot;
-
-	if (BAND_2G(brcms_b_bandtype(wlc_hw)) && wlc_hw->up) {
-		brcms_c_suspend_mac_and_wait(wlc_hw->wlc);
-		brcms_b_update_slot_timing(wlc_hw, shortslot);
-		brcms_c_enable_mac(wlc_hw->wlc);
-	}
-}
-
 /*
  * Update the slot timing for standard 11b/g (20us slots)
  * or shortslot 11g (9us slots)
@@ -687,6 +636,81 @@ brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 	return n >= bound_limit;
 }
 
+static bool
+brcms_b_dotxstatus(struct brcms_hardware *wlc_hw, struct tx_status *txs,
+		   u32 s2)
+{
+	/* discard intermediate indications for ucode with one legitimate case:
+	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange, but the subsequent
+	 *   tx of DATA failed. so it will start rts/cts from the beginning (resetting the rts
+	 *   transmission count)
+	 */
+	if (!(txs->status & TX_STATUS_AMPDU)
+	    && (txs->status & TX_STATUS_INTERMEDIATE)) {
+		return false;
+	}
+
+	return brcms_c_dotxstatus(wlc_hw->wlc, txs, s2);
+}
+
+/* process tx completion events in BMAC
+ * Return true if more tx status need to be processed. false otherwise.
+ */
+static bool
+brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
+{
+	bool morepending = false;
+	struct brcms_c_info *wlc = wlc_hw->wlc;
+	d11regs_t *regs;
+	struct tx_status txstatus, *txs;
+	u32 s1, s2;
+	uint n = 0;
+	/*
+	 * Param 'max_tx_num' indicates max. # tx status to process before
+	 * break out.
+	 */
+	uint max_tx_num = bound ? wlc->pub->tunables->txsbnd : -1;
+
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
+
+	txs = &txstatus;
+	regs = wlc_hw->regs;
+	while (!(*fatal)
+	       && (s1 = R_REG(&regs->frmtxstatus)) & TXS_V) {
+
+		if (s1 == 0xffffffff) {
+			wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n",
+				wlc_hw->unit, __func__);
+			return morepending;
+		}
+
+			s2 = R_REG(&regs->frmtxstatus2);
+
+		txs->status = s1 & TXS_STATUS_MASK;
+		txs->frameid = (s1 & TXS_FID_MASK) >> TXS_FID_SHIFT;
+		txs->sequence = s2 & TXS_SEQ_MASK;
+		txs->phyerr = (s2 & TXS_PTX_MASK) >> TXS_PTX_SHIFT;
+		txs->lasttxtime = 0;
+
+		*fatal = brcms_b_dotxstatus(wlc_hw, txs, s2);
+
+		/* !give others some time to run! */
+		if (++n >= max_tx_num)
+			break;
+	}
+
+	if (*fatal)
+		return 0;
+
+	if (n >= max_tx_num)
+		morepending = true;
+
+	if (!pktq_empty(&wlc->pkt_queue->q))
+		brcms_c_send_q(wlc);
+
+	return morepending;
+}
+
 /* second-level interrupt processing
  *   Return true if another dpc needs to be re-scheduled. false otherwise.
  *   Param 'bounded' indicates if applicable loops should be bounded.
@@ -790,73 +814,6 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 	return wlc->macintstatus != 0;
 }
 
-/* common low-level watchdog code */
-void brcms_b_watchdog(void *arg)
-{
-	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
-	struct brcms_hardware *wlc_hw = wlc->hw;
-
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
-	if (!wlc_hw->up)
-		return;
-
-	/* increment second count */
-	wlc_hw->now++;
-
-	/* Check for FIFO error interrupts */
-	brcms_b_fifoerrors(wlc_hw);
-
-	/* make sure RX dma has buffers */
-	dma_rxfill(wlc->hw->di[RX_FIFO]);
-
-	wlc_phy_watchdog(wlc_hw->band->pi);
-}
-
-void
-brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, chanspec_t chanspec,
-		      bool mute, struct txpwr_limits *txpwr)
-{
-	uint bandunit;
-
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: 0x%x\n", wlc_hw->unit, chanspec);
-
-	wlc_hw->chanspec = chanspec;
-
-	/* Switch bands if necessary */
-	if (NBANDS_HW(wlc_hw) > 1) {
-		bandunit = CHSPEC_BANDUNIT(chanspec);
-		if (wlc_hw->band->bandunit != bandunit) {
-			/* brcms_b_setband disables other bandunit,
-			 *  use light band switch if not up yet
-			 */
-			if (wlc_hw->up) {
-				wlc_phy_chanspec_radio_set(wlc_hw->
-							   bandstate[bandunit]->
-							   pi, chanspec);
-				brcms_b_setband(wlc_hw, bandunit, chanspec);
-			} else {
-				brcms_c_setxband(wlc_hw, bandunit);
-			}
-		}
-	}
-
-	wlc_phy_initcal_enable(wlc_hw->band->pi, !mute);
-
-	if (!wlc_hw->up) {
-		if (wlc_hw->clk)
-			wlc_phy_txpower_limit_set(wlc_hw->band->pi, txpwr,
-						  chanspec);
-		wlc_phy_chanspec_radio_set(wlc_hw->band->pi, chanspec);
-	} else {
-		wlc_phy_chanspec_set(wlc_hw->band->pi, chanspec);
-		wlc_phy_txpower_limit_set(wlc_hw->band->pi, txpwr, chanspec);
-
-		/* Update muting of the channel */
-		brcms_b_mute(wlc_hw, mute, 0);
-	}
-}
-
 int brcms_b_state_get(struct brcms_hardware *wlc_hw,
 		      struct brcms_b_state *state)
 {
@@ -974,356 +931,6 @@ static void brcms_b_detach_dmapio(struct brcms_hardware *wlc_hw)
 	}
 }
 
-/* low level attach
- *    run backplane attach, init nvram
- *    run phy attach
- *    initialize software state for each core and band
- *    put the whole chip in reset(driver down state), no clock
- */
-int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
-		    bool piomode, void *regsva, uint bustype, void *btparam)
-{
-	struct brcms_hardware *wlc_hw;
-	d11regs_t *regs;
-	char *macaddr = NULL;
-	char *vars;
-	uint err = 0;
-	uint j;
-	bool wme = false;
-	struct shared_phy_params sha_params;
-	struct wiphy *wiphy = wlc->wiphy;
-
-	BCMMSG(wlc->wiphy, "wl%d: vendor 0x%x device 0x%x\n", unit, vendor,
-		device);
-
-	wme = true;
-
-	wlc_hw = wlc->hw;
-	wlc_hw->wlc = wlc;
-	wlc_hw->unit = unit;
-	wlc_hw->band = wlc_hw->bandstate[0];
-	wlc_hw->_piomode = piomode;
-
-	/* populate struct brcms_hardware with default values  */
-	brcms_b_info_init(wlc_hw);
-
-	/*
-	 * Do the hardware portion of the attach.
-	 * Also initialize software state that depends on the particular hardware
-	 * we are running.
-	 */
-	wlc_hw->sih = ai_attach(regsva, bustype, btparam,
-				&wlc_hw->vars, &wlc_hw->vars_size);
-	if (wlc_hw->sih == NULL) {
-		wiphy_err(wiphy, "wl%d: brcms_b_attach: si_attach failed\n",
-			  unit);
-		err = 11;
-		goto fail;
-	}
-	vars = wlc_hw->vars;
-
-	/*
-	 * Get vendid/devid nvram overwrites, which could be different
-	 * than those the BIOS recognizes for devices on PCMCIA_BUS,
-	 * SDIO_BUS, and SROMless devices on PCI_BUS.
-	 */
-#ifdef BCMBUSTYPE
-	bustype = BCMBUSTYPE;
-#endif
-	if (bustype != SI_BUS) {
-		char *var;
-
-		var = getvar(vars, "vendid");
-		if (var) {
-			vendor = (u16) simple_strtoul(var, NULL, 0);
-			wiphy_err(wiphy, "Overriding vendor id = 0x%x\n",
-				  vendor);
-		}
-		var = getvar(vars, "devid");
-		if (var) {
-			u16 devid = (u16) simple_strtoul(var, NULL, 0);
-			if (devid != 0xffff) {
-				device = devid;
-				wiphy_err(wiphy, "Overriding device id = 0x%x"
-					  "\n", device);
-			}
-		}
-
-		/* verify again the device is supported */
-		if (!brcms_c_chipmatch(vendor, device)) {
-			wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported "
-				"vendor/device (0x%x/0x%x)\n",
-				 unit, vendor, device);
-			err = 12;
-			goto fail;
-		}
-	}
-
-	wlc_hw->vendorid = vendor;
-	wlc_hw->deviceid = device;
-
-	/* set bar0 window to point at D11 core */
-	wlc_hw->regs = (d11regs_t *) ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
-	wlc_hw->corerev = ai_corerev(wlc_hw->sih);
-
-	regs = wlc_hw->regs;
-
-	wlc->regs = wlc_hw->regs;
-
-	/* validate chip, chiprev and corerev */
-	if (!brcms_c_isgoodchip(wlc_hw)) {
-		err = 13;
-		goto fail;
-	}
-
-	/* initialize power control registers */
-	ai_clkctl_init(wlc_hw->sih);
-
-	/* request fastclock and force fastclock for the rest of attach
-	 * bring the d11 core out of reset.
-	 *   For PMU chips, the first wlc_clkctl_clk is no-op since core-clk is still false;
-	 *   But it will be called again inside wlc_corereset, after d11 is out of reset.
-	 */
-	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
-	brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
-
-	if (!brcms_b_validate_chip_access(wlc_hw)) {
-		wiphy_err(wiphy, "wl%d: brcms_b_attach: validate_chip_access "
-			"failed\n", unit);
-		err = 14;
-		goto fail;
-	}
-
-	/* get the board rev, used just below */
-	j = getintvar(vars, "boardrev");
-	/* promote srom boardrev of 0xFF to 1 */
-	if (j == BOARDREV_PROMOTABLE)
-		j = BOARDREV_PROMOTED;
-	wlc_hw->boardrev = (u16) j;
-	if (!brcms_c_validboardtype(wlc_hw)) {
-		wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported Broadcom "
-			"board type (0x%x)" " or revision level (0x%x)\n",
-			 unit, wlc_hw->sih->boardtype, wlc_hw->boardrev);
-		err = 15;
-		goto fail;
-	}
-	wlc_hw->sromrev = (u8) getintvar(vars, "sromrev");
-	wlc_hw->boardflags = (u32) getintvar(vars, "boardflags");
-	wlc_hw->boardflags2 = (u32) getintvar(vars, "boardflags2");
-
-	if (wlc_hw->boardflags & BFL_NOPLLDOWN)
-		brcms_b_pllreq(wlc_hw, true, BRCMS_PLLREQ_SHARED);
-
-	if ((wlc_hw->sih->bustype == PCI_BUS)
-	    && (ai_pci_war16165(wlc_hw->sih)))
-		wlc->war16165 = true;
-
-	/* check device id(srom, nvram etc.) to set bands */
-	if (wlc_hw->deviceid == BCM43224_D11N_ID ||
-	    wlc_hw->deviceid == BCM43224_D11N_ID_VEN1) {
-		/* Dualband boards */
-		wlc_hw->_nbands = 2;
-	} else
-		wlc_hw->_nbands = 1;
-
-	if ((wlc_hw->sih->chip == BCM43225_CHIP_ID))
-		wlc_hw->_nbands = 1;
-
-	/* BMAC_NOTE: remove init of pub values when brcms_c_attach()
-	 * unconditionally does the init of these values
-	 */
-	wlc->vendorid = wlc_hw->vendorid;
-	wlc->deviceid = wlc_hw->deviceid;
-	wlc->pub->sih = wlc_hw->sih;
-	wlc->pub->corerev = wlc_hw->corerev;
-	wlc->pub->sromrev = wlc_hw->sromrev;
-	wlc->pub->boardrev = wlc_hw->boardrev;
-	wlc->pub->boardflags = wlc_hw->boardflags;
-	wlc->pub->boardflags2 = wlc_hw->boardflags2;
-	wlc->pub->_nbands = wlc_hw->_nbands;
-
-	wlc_hw->physhim = wlc_phy_shim_attach(wlc_hw, wlc->wl, wlc);
-
-	if (wlc_hw->physhim == NULL) {
-		wiphy_err(wiphy, "wl%d: brcms_b_attach: wlc_phy_shim_attach "
-			"failed\n", unit);
-		err = 25;
-		goto fail;
-	}
-
-	/* pass all the parameters to wlc_phy_shared_attach in one struct */
-	sha_params.sih = wlc_hw->sih;
-	sha_params.physhim = wlc_hw->physhim;
-	sha_params.unit = unit;
-	sha_params.corerev = wlc_hw->corerev;
-	sha_params.vars = vars;
-	sha_params.vid = wlc_hw->vendorid;
-	sha_params.did = wlc_hw->deviceid;
-	sha_params.chip = wlc_hw->sih->chip;
-	sha_params.chiprev = wlc_hw->sih->chiprev;
-	sha_params.chippkg = wlc_hw->sih->chippkg;
-	sha_params.sromrev = wlc_hw->sromrev;
-	sha_params.boardtype = wlc_hw->sih->boardtype;
-	sha_params.boardrev = wlc_hw->boardrev;
-	sha_params.boardvendor = wlc_hw->sih->boardvendor;
-	sha_params.boardflags = wlc_hw->boardflags;
-	sha_params.boardflags2 = wlc_hw->boardflags2;
-	sha_params.bustype = wlc_hw->sih->bustype;
-	sha_params.buscorerev = wlc_hw->sih->buscorerev;
-
-	/* alloc and save pointer to shared phy state area */
-	wlc_hw->phy_sh = wlc_phy_shared_attach(&sha_params);
-	if (!wlc_hw->phy_sh) {
-		err = 16;
-		goto fail;
-	}
-
-	/* initialize software state for each core and band */
-	for (j = 0; j < NBANDS_HW(wlc_hw); j++) {
-		/*
-		 * band0 is always 2.4Ghz
-		 * band1, if present, is 5Ghz
-		 */
-
-		/* So if this is a single band 11a card, use band 1 */
-		if (IS_SINGLEBAND_5G(wlc_hw->deviceid))
-			j = BAND_5G_INDEX;
-
-		brcms_c_setxband(wlc_hw, j);
-
-		wlc_hw->band->bandunit = j;
-		wlc_hw->band->bandtype = j ? BRCM_BAND_5G : BRCM_BAND_2G;
-		wlc->band->bandunit = j;
-		wlc->band->bandtype = j ? BRCM_BAND_5G : BRCM_BAND_2G;
-		wlc->core->coreidx = ai_coreidx(wlc_hw->sih);
-
-		wlc_hw->machwcap = R_REG(&regs->machwcap);
-		wlc_hw->machwcap_backup = wlc_hw->machwcap;
-
-		/* init tx fifo size */
-		wlc_hw->xmtfifo_sz =
-		    xmtfifo_sz[(wlc_hw->corerev - XMTFIFOTBL_STARTREV)];
-
-		/* Get a phy for this band */
-		wlc_hw->band->pi = wlc_phy_attach(wlc_hw->phy_sh,
-			(void *)regs, brcms_b_bandtype(wlc_hw), vars,
-			wlc->wiphy);
-		if (wlc_hw->band->pi == NULL) {
-			wiphy_err(wiphy, "wl%d: brcms_b_attach: wlc_phy_"
-				  "attach failed\n", unit);
-			err = 17;
-			goto fail;
-		}
-
-		wlc_phy_machwcap_set(wlc_hw->band->pi, wlc_hw->machwcap);
-
-		wlc_phy_get_phyversion(wlc_hw->band->pi, &wlc_hw->band->phytype,
-				       &wlc_hw->band->phyrev,
-				       &wlc_hw->band->radioid,
-				       &wlc_hw->band->radiorev);
-		wlc_hw->band->abgphy_encore =
-		    wlc_phy_get_encore(wlc_hw->band->pi);
-		wlc->band->abgphy_encore = wlc_phy_get_encore(wlc_hw->band->pi);
-		wlc_hw->band->core_flags =
-		    wlc_phy_get_coreflags(wlc_hw->band->pi);
-
-		/* verify good phy_type & supported phy revision */
-		if (BRCMS_ISNPHY(wlc_hw->band)) {
-			if (NCONF_HAS(wlc_hw->band->phyrev))
-				goto good_phy;
-			else
-				goto bad_phy;
-		} else if (BRCMS_ISLCNPHY(wlc_hw->band)) {
-			if (LCNCONF_HAS(wlc_hw->band->phyrev))
-				goto good_phy;
-			else
-				goto bad_phy;
-		} else {
- bad_phy:
-			wiphy_err(wiphy, "wl%d: brcms_b_attach: unsupported "
-				  "phy type/rev (%d/%d)\n", unit,
-				  wlc_hw->band->phytype, wlc_hw->band->phyrev);
-			err = 18;
-			goto fail;
-		}
-
- good_phy:
-		/* BMAC_NOTE: wlc->band->pi should not be set below and should be done in the
-		 * high level attach. However we can not make that change until all low level access
-		 * is changed to wlc_hw->band->pi. Instead do the wlc->band->pi init below, keeping
-		 * wlc_hw->band->pi as well for incremental update of low level fns, and cut over
-		 * low only init when all fns updated.
-		 */
-		wlc->band->pi = wlc_hw->band->pi;
-		wlc->band->phytype = wlc_hw->band->phytype;
-		wlc->band->phyrev = wlc_hw->band->phyrev;
-		wlc->band->radioid = wlc_hw->band->radioid;
-		wlc->band->radiorev = wlc_hw->band->radiorev;
-
-		/* default contention windows size limits */
-		wlc_hw->band->CWmin = APHY_CWMIN;
-		wlc_hw->band->CWmax = PHY_CWMAX;
-
-		if (!brcms_b_attach_dmapio(wlc, j, wme)) {
-			err = 19;
-			goto fail;
-		}
-	}
-
-	/* disable core to match driver "down" state */
-	brcms_c_coredisable(wlc_hw);
-
-	/* Match driver "down" state */
-	if (wlc_hw->sih->bustype == PCI_BUS)
-		ai_pci_down(wlc_hw->sih);
-
-	/* register sb interrupt callback functions */
-	ai_register_intr_callback(wlc_hw->sih, (void *)brcms_c_wlintrsoff,
-				  (void *)brcms_c_wlintrsrestore, NULL, wlc);
-
-	/* turn off pll and xtal to match driver "down" state */
-	brcms_b_xtal(wlc_hw, OFF);
-
-	/* *********************************************************************
-	 * The hardware is in the DOWN state at this point. D11 core
-	 * or cores are in reset with clocks off, and the board PLLs
-	 * are off if possible.
-	 *
-	 * Beyond this point, wlc->sbclk == false and chip registers
-	 * should not be touched.
-	 *********************************************************************
-	 */
-
-	/* init etheraddr state variables */
-	macaddr = brcms_c_get_macaddr(wlc_hw);
-	if (macaddr == NULL) {
-		wiphy_err(wiphy, "wl%d: brcms_b_attach: macaddr not found\n",
-			  unit);
-		err = 21;
-		goto fail;
-	}
-	brcmu_ether_atoe(macaddr, wlc_hw->etheraddr);
-	if (is_broadcast_ether_addr(wlc_hw->etheraddr) ||
-	    is_zero_ether_addr(wlc_hw->etheraddr)) {
-		wiphy_err(wiphy, "wl%d: brcms_b_attach: bad macaddr %s\n",
-			  unit, macaddr);
-		err = 22;
-		goto fail;
-	}
-
-	BCMMSG(wlc->wiphy,
-		 "deviceid 0x%x nbands %d board 0x%x macaddr: %s\n",
-		 wlc_hw->deviceid, wlc_hw->_nbands,
-		 wlc_hw->sih->boardtype, macaddr);
-
-	return err;
-
- fail:
-	wiphy_err(wiphy, "wl%d: brcms_b_attach: failed with err %d\n", unit,
-		  err);
-	return err;
-}
-
 /*
  * Initialize brcms_c_info default values ...
  * may get overrides later in this function
@@ -1348,253 +955,6 @@ static void brcms_b_info_init(struct brcms_hardware *wlc_hw)
 	wlc_hw->chanspec = CH20MHZ_CHSPEC(1);
 }
 
-/*
- * low level detach
- */
-int brcms_b_detach(struct brcms_c_info *wlc)
-{
-	uint i;
-	struct brcms_hw_band *band;
-	struct brcms_hardware *wlc_hw = wlc->hw;
-	int callbacks;
-
-	callbacks = 0;
-
-	if (wlc_hw->sih) {
-		/* detach interrupt sync mechanism since interrupt is disabled and per-port
-		 * interrupt object may has been freed. this must be done before sb core switch
-		 */
-		ai_deregister_intr_callback(wlc_hw->sih);
-
-		if (wlc_hw->sih->bustype == PCI_BUS)
-			ai_pci_sleep(wlc_hw->sih);
-	}
-
-	brcms_b_detach_dmapio(wlc_hw);
-
-	band = wlc_hw->band;
-	for (i = 0; i < NBANDS_HW(wlc_hw); i++) {
-		if (band->pi) {
-			/* Detach this band's phy */
-			wlc_phy_detach(band->pi);
-			band->pi = NULL;
-		}
-		band = wlc_hw->bandstate[OTHERBANDUNIT(wlc)];
-	}
-
-	/* Free shared phy state */
-	kfree(wlc_hw->phy_sh);
-
-	wlc_phy_shim_detach(wlc_hw->physhim);
-
-	/* free vars */
-	kfree(wlc_hw->vars);
-	wlc_hw->vars = NULL;
-
-	if (wlc_hw->sih) {
-		ai_detach(wlc_hw->sih);
-		wlc_hw->sih = NULL;
-	}
-
-	return callbacks;
-
-}
-
-void brcms_b_reset(struct brcms_hardware *wlc_hw)
-{
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
-	/* reset the core */
-	if (!DEVICEREMOVED(wlc_hw->wlc))
-		brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
-
-	/* purge the dma rings */
-	brcms_c_flushqueues(wlc_hw->wlc);
-
-	brcms_c_reset_bmac_done(wlc_hw->wlc);
-}
-
-void
-brcms_b_init(struct brcms_hardware *wlc_hw, chanspec_t chanspec,
-			  bool mute) {
-	u32 macintmask;
-	bool fastclk;
-	struct brcms_c_info *wlc = wlc_hw->wlc;
-
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
-	/* request FAST clock if not on */
-	fastclk = wlc_hw->forcefastclk;
-	if (!fastclk)
-		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
-
-	/* disable interrupts */
-	macintmask = brcms_intrsoff(wlc->wl);
-
-	/* set up the specified band and chanspec */
-	brcms_c_setxband(wlc_hw, CHSPEC_BANDUNIT(chanspec));
-	wlc_phy_chanspec_radio_set(wlc_hw->band->pi, chanspec);
-
-	/* do one-time phy inits and calibration */
-	wlc_phy_cal_init(wlc_hw->band->pi);
-
-	/* core-specific initialization */
-	brcms_b_coreinit(wlc);
-
-	/* suspend the tx fifos and mute the phy for preism cac time */
-	if (mute)
-		brcms_b_mute(wlc_hw, ON, PHY_MUTE_FOR_PREISM);
-
-	/* band-specific inits */
-	brcms_b_bsinit(wlc, chanspec);
-
-	/* restore macintmask */
-	brcms_intrsrestore(wlc->wl, macintmask);
-
-	/* seed wake_override with BRCMS_WAKE_OVERRIDE_MACSUSPEND since the mac
-	 * is suspended and brcms_c_enable_mac() will clear this override bit.
-	 */
-	mboolset(wlc_hw->wake_override, BRCMS_WAKE_OVERRIDE_MACSUSPEND);
-
-	/*
-	 * initialize mac_suspend_depth to 1 to match ucode initial suspended state
-	 */
-	wlc_hw->mac_suspend_depth = 1;
-
-	/* restore the clk */
-	if (!fastclk)
-		brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
-}
-
-int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
-{
-	uint coremask;
-
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
-	/*
-	 * Enable pll and xtal, initialize the power control registers,
-	 * and force fastclock for the remainder of brcms_c_up().
-	 */
-	brcms_b_xtal(wlc_hw, ON);
-	ai_clkctl_init(wlc_hw->sih);
-	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
-
-	/*
-	 * Configure pci/pcmcia here instead of in brcms_c_attach()
-	 * to allow mfg hotswap:  down, hotswap (chip power cycle), up.
-	 */
-	coremask = (1 << wlc_hw->wlc->core->coreidx);
-
-	if (wlc_hw->sih->bustype == PCI_BUS)
-		ai_pci_setup(wlc_hw->sih, coremask);
-
-	/*
-	 * Need to read the hwradio status here to cover the case where the system
-	 * is loaded with the hw radio disabled. We do not want to bring the driver up in this case.
-	 */
-	if (brcms_b_radio_read_hwdisabled(wlc_hw)) {
-		/* put SB PCI in down state again */
-		if (wlc_hw->sih->bustype == PCI_BUS)
-			ai_pci_down(wlc_hw->sih);
-		brcms_b_xtal(wlc_hw, OFF);
-		return -ENOMEDIUM;
-	}
-
-	if (wlc_hw->sih->bustype == PCI_BUS)
-		ai_pci_up(wlc_hw->sih);
-
-	/* reset the d11 core */
-	brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
-
-	return 0;
-}
-
-int brcms_b_up_finish(struct brcms_hardware *wlc_hw)
-{
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
-	wlc_hw->up = true;
-	wlc_phy_hw_state_upd(wlc_hw->band->pi, true);
-
-	/* FULLY enable dynamic power control and d11 core interrupt */
-	brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
-	brcms_intrson(wlc_hw->wlc->wl);
-	return 0;
-}
-
-int brcms_b_bmac_down_prep(struct brcms_hardware *wlc_hw)
-{
-	bool dev_gone;
-	uint callbacks = 0;
-
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
-	if (!wlc_hw->up)
-		return callbacks;
-
-	dev_gone = DEVICEREMOVED(wlc_hw->wlc);
-
-	/* disable interrupts */
-	if (dev_gone)
-		wlc_hw->wlc->macintmask = 0;
-	else {
-		/* now disable interrupts */
-		brcms_intrsoff(wlc_hw->wlc->wl);
-
-		/* ensure we're running on the pll clock again */
-		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
-	}
-	/* down phy at the last of this stage */
-	callbacks += wlc_phy_down(wlc_hw->band->pi);
-
-	return callbacks;
-}
-
-int brcms_b_down_finish(struct brcms_hardware *wlc_hw)
-{
-	uint callbacks = 0;
-	bool dev_gone;
-
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
-	if (!wlc_hw->up)
-		return callbacks;
-
-	wlc_hw->up = false;
-	wlc_phy_hw_state_upd(wlc_hw->band->pi, false);
-
-	dev_gone = DEVICEREMOVED(wlc_hw->wlc);
-
-	if (dev_gone) {
-		wlc_hw->sbclk = false;
-		wlc_hw->clk = false;
-		wlc_phy_hw_clk_state_upd(wlc_hw->band->pi, false);
-
-		/* reclaim any posted packets */
-		brcms_c_flushqueues(wlc_hw->wlc);
-	} else {
-
-		/* Reset and disable the core */
-		if (ai_iscoreup(wlc_hw->sih)) {
-			if (R_REG(&wlc_hw->regs->maccontrol) &
-			    MCTL_EN_MAC)
-				brcms_c_suspend_mac_and_wait(wlc_hw->wlc);
-			callbacks += brcms_reset(wlc_hw->wlc->wl);
-			brcms_c_coredisable(wlc_hw);
-		}
-
-		/* turn off primary xtal and pll */
-		if (!wlc_hw->noreset) {
-			if (wlc_hw->sih->bustype == PCI_BUS)
-				ai_pci_down(wlc_hw->sih);
-			brcms_b_xtal(wlc_hw, OFF);
-		}
-	}
-
-	return callbacks;
-}
-
 void brcms_b_wait_for_wake(struct brcms_hardware *wlc_hw)
 {
 	/* delay before first read of ucode state */
@@ -1769,32 +1129,6 @@ brcms_b_mhf(struct brcms_hardware *wlc_hw, u8 idx, u16 mask, u16 val,
 	}
 }
 
-u16 brcms_b_mhf_get(struct brcms_hardware *wlc_hw, u8 idx, int bands)
-{
-	struct brcms_hw_band *band;
-
-	if (idx >= MHFMAX)
-		return 0; /* error condition */
-	switch (bands) {
-	case BRCM_BAND_AUTO:
-		band = wlc_hw->band;
-		break;
-	case BRCM_BAND_5G:
-		band = wlc_hw->bandstate[BAND_5G_INDEX];
-		break;
-	case BRCM_BAND_2G:
-		band = wlc_hw->bandstate[BAND_2G_INDEX];
-		break;
-	default:
-		band = NULL;		/* error condition */
-	}
-
-	if (!band)
-		return 0;
-
-	return band->mhfs[idx];
-}
-
 static void brcms_c_write_mhf(struct brcms_hardware *wlc_hw, u16 *mhfs)
 {
 	u8 idx;
@@ -2055,27 +1389,6 @@ brcms_c_write_hw_bcntemplate1(struct brcms_hardware *wlc_hw, void *bcn,
 	OR_REG(&regs->maccommand, MCMD_BCN1VLD);
 }
 
-/* mac is assumed to be suspended at this point */
-void
-brcms_b_write_hw_bcntemplates(struct brcms_hardware *wlc_hw, void *bcn,
-			      int len, bool both)
-{
-	d11regs_t *regs = wlc_hw->regs;
-
-	if (both) {
-		brcms_c_write_hw_bcntemplate0(wlc_hw, bcn, len);
-		brcms_c_write_hw_bcntemplate1(wlc_hw, bcn, len);
-	} else {
-		/* bcn 0 */
-		if (!(R_REG(&regs->maccommand) & MCMD_BCN0VLD))
-			brcms_c_write_hw_bcntemplate0(wlc_hw, bcn, len);
-		/* bcn 1 */
-		else if (!
-			 (R_REG(&regs->maccommand) & MCMD_BCN1VLD))
-			brcms_c_write_hw_bcntemplate1(wlc_hw, bcn, len);
-	}
-}
-
 static void brcms_b_upd_synthpu(struct brcms_hardware *wlc_hw)
 {
 	u16 v;
@@ -2403,48 +1716,6 @@ bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw)
 	return v;
 }
 
-/* Initialize just the hardware when coming out of POR or S3/S5 system states */
-void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
-{
-	if (wlc_hw->wlc->pub->hw_up)
-		return;
-
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
-	/*
-	 * Enable pll and xtal, initialize the power control registers,
-	 * and force fastclock for the remainder of brcms_c_up().
-	 */
-	brcms_b_xtal(wlc_hw, ON);
-	ai_clkctl_init(wlc_hw->sih);
-	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
-
-	if (wlc_hw->sih->bustype == PCI_BUS) {
-		ai_pci_fixcfg(wlc_hw->sih);
-
-		/* AI chip doesn't restore bar0win2 on hibernation/resume, need sw fixup */
-		if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
-		    (wlc_hw->sih->chip == BCM43225_CHIP_ID))
-			wlc_hw->regs =
-			    (d11regs_t *) ai_setcore(wlc_hw->sih, D11_CORE_ID,
-						     0);
-	}
-
-	/* Inform phy that a POR reset has occurred so it does a complete phy init */
-	wlc_phy_por_inform(wlc_hw->band->pi);
-
-	wlc_hw->ucode_loaded = false;
-	wlc_hw->wlc->pub->hw_up = true;
-
-	if ((wlc_hw->boardflags & BFL_FEM)
-	    && (wlc_hw->sih->chip == BCM4313_CHIP_ID)) {
-		if (!
-		    (wlc_hw->boardrev >= 0x1250
-		     && (wlc_hw->boardflags & BFL_FEM_BT)))
-			ai_epa_4313war(wlc_hw->sih);
-	}
-}
-
 static bool wlc_dma_rxreset(struct brcms_hardware *wlc_hw, uint fifo)
 {
 	struct dma_pub *di = wlc_hw->di[fifo];
@@ -2589,191 +1860,6 @@ static void brcms_b_corerev_fifofixup(struct brcms_hardware *wlc_hw)
 			    xmtfifo_sz[TX_BCMC_FIFO]));
 }
 
-/* d11 core init
- *   reset PSM
- *   download ucode/PCM
- *   let ucode run to suspended
- *   download ucode inits
- *   config other core registers
- *   init dma
- */
-static void brcms_b_coreinit(struct brcms_c_info *wlc)
-{
-	struct brcms_hardware *wlc_hw = wlc->hw;
-	d11regs_t *regs;
-	u32 sflags;
-	uint bcnint_us;
-	uint i = 0;
-	bool fifosz_fixup = false;
-	int err = 0;
-	u16 buf[NFIFO];
-	struct wiphy *wiphy = wlc->wiphy;
-
-	regs = wlc_hw->regs;
-
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
-	/* reset PSM */
-	brcms_b_mctrl(wlc_hw, ~0, (MCTL_IHR_EN | MCTL_PSM_JMP_0 | MCTL_WAKE));
-
-	brcms_ucode_download(wlc_hw);
-	/*
-	 * FIFOSZ fixup. driver wants to controls the fifo allocation.
-	 */
-	fifosz_fixup = true;
-
-	/* let the PSM run to the suspended state, set mode to BSS STA */
-	W_REG(&regs->macintstatus, -1);
-	brcms_b_mctrl(wlc_hw, ~0,
-		       (MCTL_IHR_EN | MCTL_INFRA | MCTL_PSM_RUN | MCTL_WAKE));
-
-	/* wait for ucode to self-suspend after auto-init */
-	SPINWAIT(((R_REG(&regs->macintstatus) & MI_MACSSPNDD) == 0),
-		 1000 * 1000);
-	if ((R_REG(&regs->macintstatus) & MI_MACSSPNDD) == 0)
-		wiphy_err(wiphy, "wl%d: wlc_coreinit: ucode did not self-"
-			  "suspend!\n", wlc_hw->unit);
-
-	brcms_c_gpio_init(wlc);
-
-	sflags = ai_core_sflags(wlc_hw->sih, 0, 0);
-
-	if (D11REV_IS(wlc_hw->corerev, 23)) {
-		if (BRCMS_ISNPHY(wlc_hw->band))
-			brcms_c_write_inits(wlc_hw, d11n0initvals16);
-		else
-			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
-				  " %d\n", __func__, wlc_hw->unit,
-				  wlc_hw->corerev);
-	} else if (D11REV_IS(wlc_hw->corerev, 24)) {
-		if (BRCMS_ISLCNPHY(wlc_hw->band)) {
-			brcms_c_write_inits(wlc_hw, d11lcn0initvals24);
-		} else {
-			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
-				  " %d\n", __func__, wlc_hw->unit,
-				  wlc_hw->corerev);
-		}
-	} else {
-		wiphy_err(wiphy, "%s: wl%d: unsupported corerev %d\n",
-			  __func__, wlc_hw->unit, wlc_hw->corerev);
-	}
-
-	/* For old ucode, txfifo sizes needs to be modified(increased) */
-	if (fifosz_fixup == true) {
-		brcms_b_corerev_fifofixup(wlc_hw);
-	}
-
-	/* check txfifo allocations match between ucode and driver */
-	buf[TX_AC_BE_FIFO] = brcms_b_read_shm(wlc_hw, M_FIFOSIZE0);
-	if (buf[TX_AC_BE_FIFO] != wlc_hw->xmtfifo_sz[TX_AC_BE_FIFO]) {
-		i = TX_AC_BE_FIFO;
-		err = -1;
-	}
-	buf[TX_AC_VI_FIFO] = brcms_b_read_shm(wlc_hw, M_FIFOSIZE1);
-	if (buf[TX_AC_VI_FIFO] != wlc_hw->xmtfifo_sz[TX_AC_VI_FIFO]) {
-		i = TX_AC_VI_FIFO;
-		err = -1;
-	}
-	buf[TX_AC_BK_FIFO] = brcms_b_read_shm(wlc_hw, M_FIFOSIZE2);
-	buf[TX_AC_VO_FIFO] = (buf[TX_AC_BK_FIFO] >> 8) & 0xff;
-	buf[TX_AC_BK_FIFO] &= 0xff;
-	if (buf[TX_AC_BK_FIFO] != wlc_hw->xmtfifo_sz[TX_AC_BK_FIFO]) {
-		i = TX_AC_BK_FIFO;
-		err = -1;
-	}
-	if (buf[TX_AC_VO_FIFO] != wlc_hw->xmtfifo_sz[TX_AC_VO_FIFO]) {
-		i = TX_AC_VO_FIFO;
-		err = -1;
-	}
-	buf[TX_BCMC_FIFO] = brcms_b_read_shm(wlc_hw, M_FIFOSIZE3);
-	buf[TX_ATIM_FIFO] = (buf[TX_BCMC_FIFO] >> 8) & 0xff;
-	buf[TX_BCMC_FIFO] &= 0xff;
-	if (buf[TX_BCMC_FIFO] != wlc_hw->xmtfifo_sz[TX_BCMC_FIFO]) {
-		i = TX_BCMC_FIFO;
-		err = -1;
-	}
-	if (buf[TX_ATIM_FIFO] != wlc_hw->xmtfifo_sz[TX_ATIM_FIFO]) {
-		i = TX_ATIM_FIFO;
-		err = -1;
-	}
-	if (err != 0) {
-		wiphy_err(wiphy, "wlc_coreinit: txfifo mismatch: ucode size %d"
-			  " driver size %d index %d\n", buf[i],
-			  wlc_hw->xmtfifo_sz[i], i);
-	}
-
-	/* make sure we can still talk to the mac */
-	WARN_ON(R_REG(&regs->maccontrol) == 0xffffffff);
-
-	/* band-specific inits done by wlc_bsinit() */
-
-	/* Set up frame burst size and antenna swap threshold init values */
-	brcms_b_write_shm(wlc_hw, M_MBURST_SIZE, MAXTXFRAMEBURST);
-	brcms_b_write_shm(wlc_hw, M_MAX_ANTCNT, ANTCNT);
-
-	/* enable one rx interrupt per received frame */
-	W_REG(&regs->intrcvlazy[0], (1 << IRL_FC_SHIFT));
-
-	/* set the station mode (BSS STA) */
-	brcms_b_mctrl(wlc_hw,
-		       (MCTL_INFRA | MCTL_DISCARD_PMQ | MCTL_AP),
-		       (MCTL_INFRA | MCTL_DISCARD_PMQ));
-
-	/* set up Beacon interval */
-	bcnint_us = 0x8000 << 10;
-	W_REG(&regs->tsf_cfprep, (bcnint_us << CFPREP_CBI_SHIFT));
-	W_REG(&regs->tsf_cfpstart, bcnint_us);
-	W_REG(&regs->macintstatus, MI_GP1);
-
-	/* write interrupt mask */
-	W_REG(&regs->intctrlregs[RX_FIFO].intmask, DEF_RXINTMASK);
-
-	/* allow the MAC to control the PHY clock (dynamic on/off) */
-	brcms_b_macphyclk_set(wlc_hw, ON);
-
-	/* program dynamic clock control fast powerup delay register */
-	wlc->fastpwrup_dly = ai_clkctl_fast_pwrup_delay(wlc_hw->sih);
-	W_REG(&regs->scc_fastpwrup_dly, wlc->fastpwrup_dly);
-
-	/* tell the ucode the corerev */
-	brcms_b_write_shm(wlc_hw, M_MACHW_VER, (u16) wlc_hw->corerev);
-
-	/* tell the ucode MAC capabilities */
-	brcms_b_write_shm(wlc_hw, M_MACHW_CAP_L,
-			   (u16) (wlc_hw->machwcap & 0xffff));
-	brcms_b_write_shm(wlc_hw, M_MACHW_CAP_H,
-			   (u16) ((wlc_hw->
-				      machwcap >> 16) & 0xffff));
-
-	/* write retry limits to SCR, this done after PSM init */
-	W_REG(&regs->objaddr, OBJADDR_SCR_SEL | S_DOT11_SRC_LMT);
-	(void)R_REG(&regs->objaddr);
-	W_REG(&regs->objdata, wlc_hw->SRL);
-	W_REG(&regs->objaddr, OBJADDR_SCR_SEL | S_DOT11_LRC_LMT);
-	(void)R_REG(&regs->objaddr);
-	W_REG(&regs->objdata, wlc_hw->LRL);
-
-	/* write rate fallback retry limits */
-	brcms_b_write_shm(wlc_hw, M_SFRMTXCNTFBRTHSD, wlc_hw->SFBL);
-	brcms_b_write_shm(wlc_hw, M_LFRMTXCNTFBRTHSD, wlc_hw->LFBL);
-
-	AND_REG(&regs->ifs_ctl, 0x0FFF);
-	W_REG(&regs->ifs_aifsn, EDCF_AIFSN_MIN);
-
-	/* dma initializations */
-	wlc->txpend16165war = 0;
-
-	/* init the tx dma engines */
-	for (i = 0; i < NFIFO; i++) {
-		if (wlc_hw->di[i])
-			dma_txinit(wlc_hw->di[i]);
-	}
-
-	/* init the rx dma engine(s) and post receive buffers */
-	dma_rxinit(wlc_hw->di[RX_FIFO]);
-	dma_rxfill(wlc_hw->di[RX_FIFO]);
-}
-
 /* This function is used for changing the tsf frac register
  * If spur avoidance mode is off, the mac freq will be 80/120/160Mhz
  * If spur avoidance mode is on1, the mac freq will be 82/123/164Mhz
@@ -3107,6 +2193,39 @@ void brcms_c_intrsrestore(struct brcms_c_info *wlc, u32 macintmask)
 	W_REG(&wlc_hw->regs->macintmask, wlc->macintmask);
 }
 
+static void brcms_b_tx_fifo_suspend(struct brcms_hardware *wlc_hw,
+				    uint tx_fifo)
+{
+	u8 fifo = 1 << tx_fifo;
+
+	/* Two clients of this code, 11h Quiet period and scanning. */
+
+	/* only suspend if not already suspended */
+	if ((wlc_hw->suspended_fifos & fifo) == fifo)
+		return;
+
+	/* force the core awake only if not already */
+	if (wlc_hw->suspended_fifos == 0)
+		brcms_c_ucode_wake_override_set(wlc_hw,
+						BRCMS_WAKE_OVERRIDE_TXFIFO);
+
+	wlc_hw->suspended_fifos |= fifo;
+
+	if (wlc_hw->di[tx_fifo]) {
+		/* Suspending AMPDU transmissions in the middle can cause underflow
+		 * which may result in mismatch between ucode and driver
+		 * so suspend the mac before suspending the FIFO
+		 */
+		if (BRCMS_PHY_11N_CAP(wlc_hw->band))
+			brcms_c_suspend_mac_and_wait(wlc_hw->wlc);
+
+		dma_txsuspend(wlc_hw->di[tx_fifo]);
+
+		if (BRCMS_PHY_11N_CAP(wlc_hw->band))
+			brcms_c_enable_mac(wlc_hw->wlc);
+	}
+}
+
 static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool on, mbool flags)
 {
 	u8 null_ether_addr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
@@ -3143,17 +2262,6 @@ static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool on, mbool flags)
 		brcms_c_ucode_mute_override_clear(wlc_hw);
 }
 
-int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
-			   uint *blocks)
-{
-	if (fifo >= NFIFO)
-		return -EINVAL;
-
-	*blocks = wlc_hw->xmtfifo_sz[fifo];
-
-	return 0;
-}
-
 /* brcms_b_tx_fifo_suspended:
  * Check the MAC's tx suspend status for a tx fifo.
  *
@@ -3183,39 +2291,6 @@ static bool brcms_b_tx_fifo_suspended(struct brcms_hardware *wlc_hw,
 	return false;
 }
 
-static void brcms_b_tx_fifo_suspend(struct brcms_hardware *wlc_hw,
-				    uint tx_fifo)
-{
-	u8 fifo = 1 << tx_fifo;
-
-	/* Two clients of this code, 11h Quiet period and scanning. */
-
-	/* only suspend if not already suspended */
-	if ((wlc_hw->suspended_fifos & fifo) == fifo)
-		return;
-
-	/* force the core awake only if not already */
-	if (wlc_hw->suspended_fifos == 0)
-		brcms_c_ucode_wake_override_set(wlc_hw,
-						BRCMS_WAKE_OVERRIDE_TXFIFO);
-
-	wlc_hw->suspended_fifos |= fifo;
-
-	if (wlc_hw->di[tx_fifo]) {
-		/* Suspending AMPDU transmissions in the middle can cause underflow
-		 * which may result in mismatch between ucode and driver
-		 * so suspend the mac before suspending the FIFO
-		 */
-		if (BRCMS_PHY_11N_CAP(wlc_hw->band))
-			brcms_c_suspend_mac_and_wait(wlc_hw->wlc);
-
-		dma_txsuspend(wlc_hw->di[tx_fifo]);
-
-		if (BRCMS_PHY_11N_CAP(wlc_hw->band))
-			brcms_c_enable_mac(wlc_hw->wlc);
-	}
-}
-
 static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
 				   uint tx_fifo)
 {
@@ -3356,81 +2431,6 @@ bool brcms_c_isr(struct brcms_c_info *wlc, bool *wantdpc)
 
 }
 
-static bool
-brcms_b_dotxstatus(struct brcms_hardware *wlc_hw, struct tx_status *txs,
-		   u32 s2)
-{
-	/* discard intermediate indications for ucode with one legitimate case:
-	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange, but the subsequent
-	 *   tx of DATA failed. so it will start rts/cts from the beginning (resetting the rts
-	 *   transmission count)
-	 */
-	if (!(txs->status & TX_STATUS_AMPDU)
-	    && (txs->status & TX_STATUS_INTERMEDIATE)) {
-		return false;
-	}
-
-	return brcms_c_dotxstatus(wlc_hw->wlc, txs, s2);
-}
-
-/* process tx completion events in BMAC
- * Return true if more tx status need to be processed. false otherwise.
- */
-static bool
-brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
-{
-	bool morepending = false;
-	struct brcms_c_info *wlc = wlc_hw->wlc;
-	d11regs_t *regs;
-	struct tx_status txstatus, *txs;
-	u32 s1, s2;
-	uint n = 0;
-	/*
-	 * Param 'max_tx_num' indicates max. # tx status to process before
-	 * break out.
-	 */
-	uint max_tx_num = bound ? wlc->pub->tunables->txsbnd : -1;
-
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
-	txs = &txstatus;
-	regs = wlc_hw->regs;
-	while (!(*fatal)
-	       && (s1 = R_REG(&regs->frmtxstatus)) & TXS_V) {
-
-		if (s1 == 0xffffffff) {
-			wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n",
-				wlc_hw->unit, __func__);
-			return morepending;
-		}
-
-			s2 = R_REG(&regs->frmtxstatus2);
-
-		txs->status = s1 & TXS_STATUS_MASK;
-		txs->frameid = (s1 & TXS_FID_MASK) >> TXS_FID_SHIFT;
-		txs->sequence = s2 & TXS_SEQ_MASK;
-		txs->phyerr = (s2 & TXS_PTX_MASK) >> TXS_PTX_SHIFT;
-		txs->lasttxtime = 0;
-
-		*fatal = brcms_b_dotxstatus(wlc_hw, txs, s2);
-
-		/* !give others some time to run! */
-		if (++n >= max_tx_num)
-			break;
-	}
-
-	if (*fatal)
-		return 0;
-
-	if (n >= max_tx_num)
-		morepending = true;
-
-	if (!pktq_empty(&wlc->pkt_queue->q))
-		brcms_c_send_q(wlc);
-
-	return morepending;
-}
-
 void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
@@ -3612,19 +2612,6 @@ void brcms_b_band_stf_ss_set(struct brcms_hardware *wlc_hw, u8 stf_mode)
 		brcms_upd_ofdm_pctl1_table(wlc_hw);
 }
 
-void
-brcms_b_read_tsf(struct brcms_hardware *wlc_hw, u32 *tsf_l_ptr,
-		  u32 *tsf_h_ptr)
-{
-	d11regs_t *regs = wlc_hw->regs;
-
-	/* read the tsf timer low, then high to get an atomic read */
-	*tsf_l_ptr = R_REG(&regs->tsf_timerlow);
-	*tsf_h_ptr = R_REG(&regs->tsf_timerhigh);
-
-	return;
-}
-
 static bool brcms_b_validate_chip_access(struct brcms_hardware *wlc_hw)
 {
 	d11regs_t *regs;
@@ -3966,29 +2953,6 @@ void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set, mbool req_bit)
 	return;
 }
 
-u16 brcms_b_rate_shm_offset(struct brcms_hardware *wlc_hw, u8 rate)
-{
-	u16 table_ptr;
-	u8 phy_rate, index;
-
-	/* get the phy specific rate encoding for the PLCP SIGNAL field */
-	if (IS_OFDM(rate))
-		table_ptr = M_RT_DIRMAP_A;
-	else
-		table_ptr = M_RT_DIRMAP_B;
-
-	/* for a given rate, the LS-nibble of the PLCP SIGNAL field is
-	 * the index into the rate table.
-	 */
-	phy_rate = rate_info[rate] & BRCMS_RATE_MASK;
-	index = phy_rate & 0xf;
-
-	/* Find the SHM pointer to the rate table entry by looking in the
-	 * Direct-map Table
-	 */
-	return 2 * brcms_b_read_shm(wlc_hw, table_ptr + (index * 2));
-}
-
 void brcms_b_antsel_set(struct brcms_hardware *wlc_hw, u32 antsel_avail)
 {
 	wlc_hw->antsel_avail = antsel_avail;
@@ -4027,6 +2991,20 @@ bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 	return true;
 }
 
+void brcms_b_reset(struct brcms_hardware *wlc_hw)
+{
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+
+	/* reset the core */
+	if (!DEVICEREMOVED(wlc_hw->wlc))
+		brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
+
+	/* purge the dma rings */
+	brcms_c_flushqueues(wlc_hw->wlc);
+
+	brcms_c_reset_bmac_done(wlc_hw->wlc);
+}
+
 void brcms_c_reset(struct brcms_c_info *wlc)
 {
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
@@ -4072,6 +3050,243 @@ static void brcms_c_init_scb(struct brcms_c_info *wlc, struct scb *scb)
 		scb->seqnum[i] = 0;
 }
 
+/* d11 core init
+ *   reset PSM
+ *   download ucode/PCM
+ *   let ucode run to suspended
+ *   download ucode inits
+ *   config other core registers
+ *   init dma
+ */
+static void brcms_b_coreinit(struct brcms_c_info *wlc)
+{
+	struct brcms_hardware *wlc_hw = wlc->hw;
+	d11regs_t *regs;
+	u32 sflags;
+	uint bcnint_us;
+	uint i = 0;
+	bool fifosz_fixup = false;
+	int err = 0;
+	u16 buf[NFIFO];
+	struct wiphy *wiphy = wlc->wiphy;
+
+	regs = wlc_hw->regs;
+
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
+
+	/* reset PSM */
+	brcms_b_mctrl(wlc_hw, ~0, (MCTL_IHR_EN | MCTL_PSM_JMP_0 | MCTL_WAKE));
+
+	brcms_ucode_download(wlc_hw);
+	/*
+	 * FIFOSZ fixup. driver wants to controls the fifo allocation.
+	 */
+	fifosz_fixup = true;
+
+	/* let the PSM run to the suspended state, set mode to BSS STA */
+	W_REG(&regs->macintstatus, -1);
+	brcms_b_mctrl(wlc_hw, ~0,
+		       (MCTL_IHR_EN | MCTL_INFRA | MCTL_PSM_RUN | MCTL_WAKE));
+
+	/* wait for ucode to self-suspend after auto-init */
+	SPINWAIT(((R_REG(&regs->macintstatus) & MI_MACSSPNDD) == 0),
+		 1000 * 1000);
+	if ((R_REG(&regs->macintstatus) & MI_MACSSPNDD) == 0)
+		wiphy_err(wiphy, "wl%d: wlc_coreinit: ucode did not self-"
+			  "suspend!\n", wlc_hw->unit);
+
+	brcms_c_gpio_init(wlc);
+
+	sflags = ai_core_sflags(wlc_hw->sih, 0, 0);
+
+	if (D11REV_IS(wlc_hw->corerev, 23)) {
+		if (BRCMS_ISNPHY(wlc_hw->band))
+			brcms_c_write_inits(wlc_hw, d11n0initvals16);
+		else
+			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
+				  " %d\n", __func__, wlc_hw->unit,
+				  wlc_hw->corerev);
+	} else if (D11REV_IS(wlc_hw->corerev, 24)) {
+		if (BRCMS_ISLCNPHY(wlc_hw->band)) {
+			brcms_c_write_inits(wlc_hw, d11lcn0initvals24);
+		} else {
+			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
+				  " %d\n", __func__, wlc_hw->unit,
+				  wlc_hw->corerev);
+		}
+	} else {
+		wiphy_err(wiphy, "%s: wl%d: unsupported corerev %d\n",
+			  __func__, wlc_hw->unit, wlc_hw->corerev);
+	}
+
+	/* For old ucode, txfifo sizes needs to be modified(increased) */
+	if (fifosz_fixup == true) {
+		brcms_b_corerev_fifofixup(wlc_hw);
+	}
+
+	/* check txfifo allocations match between ucode and driver */
+	buf[TX_AC_BE_FIFO] = brcms_b_read_shm(wlc_hw, M_FIFOSIZE0);
+	if (buf[TX_AC_BE_FIFO] != wlc_hw->xmtfifo_sz[TX_AC_BE_FIFO]) {
+		i = TX_AC_BE_FIFO;
+		err = -1;
+	}
+	buf[TX_AC_VI_FIFO] = brcms_b_read_shm(wlc_hw, M_FIFOSIZE1);
+	if (buf[TX_AC_VI_FIFO] != wlc_hw->xmtfifo_sz[TX_AC_VI_FIFO]) {
+		i = TX_AC_VI_FIFO;
+		err = -1;
+	}
+	buf[TX_AC_BK_FIFO] = brcms_b_read_shm(wlc_hw, M_FIFOSIZE2);
+	buf[TX_AC_VO_FIFO] = (buf[TX_AC_BK_FIFO] >> 8) & 0xff;
+	buf[TX_AC_BK_FIFO] &= 0xff;
+	if (buf[TX_AC_BK_FIFO] != wlc_hw->xmtfifo_sz[TX_AC_BK_FIFO]) {
+		i = TX_AC_BK_FIFO;
+		err = -1;
+	}
+	if (buf[TX_AC_VO_FIFO] != wlc_hw->xmtfifo_sz[TX_AC_VO_FIFO]) {
+		i = TX_AC_VO_FIFO;
+		err = -1;
+	}
+	buf[TX_BCMC_FIFO] = brcms_b_read_shm(wlc_hw, M_FIFOSIZE3);
+	buf[TX_ATIM_FIFO] = (buf[TX_BCMC_FIFO] >> 8) & 0xff;
+	buf[TX_BCMC_FIFO] &= 0xff;
+	if (buf[TX_BCMC_FIFO] != wlc_hw->xmtfifo_sz[TX_BCMC_FIFO]) {
+		i = TX_BCMC_FIFO;
+		err = -1;
+	}
+	if (buf[TX_ATIM_FIFO] != wlc_hw->xmtfifo_sz[TX_ATIM_FIFO]) {
+		i = TX_ATIM_FIFO;
+		err = -1;
+	}
+	if (err != 0) {
+		wiphy_err(wiphy, "wlc_coreinit: txfifo mismatch: ucode size %d"
+			  " driver size %d index %d\n", buf[i],
+			  wlc_hw->xmtfifo_sz[i], i);
+	}
+
+	/* make sure we can still talk to the mac */
+	WARN_ON(R_REG(&regs->maccontrol) == 0xffffffff);
+
+	/* band-specific inits done by wlc_bsinit() */
+
+	/* Set up frame burst size and antenna swap threshold init values */
+	brcms_b_write_shm(wlc_hw, M_MBURST_SIZE, MAXTXFRAMEBURST);
+	brcms_b_write_shm(wlc_hw, M_MAX_ANTCNT, ANTCNT);
+
+	/* enable one rx interrupt per received frame */
+	W_REG(&regs->intrcvlazy[0], (1 << IRL_FC_SHIFT));
+
+	/* set the station mode (BSS STA) */
+	brcms_b_mctrl(wlc_hw,
+		       (MCTL_INFRA | MCTL_DISCARD_PMQ | MCTL_AP),
+		       (MCTL_INFRA | MCTL_DISCARD_PMQ));
+
+	/* set up Beacon interval */
+	bcnint_us = 0x8000 << 10;
+	W_REG(&regs->tsf_cfprep, (bcnint_us << CFPREP_CBI_SHIFT));
+	W_REG(&regs->tsf_cfpstart, bcnint_us);
+	W_REG(&regs->macintstatus, MI_GP1);
+
+	/* write interrupt mask */
+	W_REG(&regs->intctrlregs[RX_FIFO].intmask, DEF_RXINTMASK);
+
+	/* allow the MAC to control the PHY clock (dynamic on/off) */
+	brcms_b_macphyclk_set(wlc_hw, ON);
+
+	/* program dynamic clock control fast powerup delay register */
+	wlc->fastpwrup_dly = ai_clkctl_fast_pwrup_delay(wlc_hw->sih);
+	W_REG(&regs->scc_fastpwrup_dly, wlc->fastpwrup_dly);
+
+	/* tell the ucode the corerev */
+	brcms_b_write_shm(wlc_hw, M_MACHW_VER, (u16) wlc_hw->corerev);
+
+	/* tell the ucode MAC capabilities */
+	brcms_b_write_shm(wlc_hw, M_MACHW_CAP_L,
+			   (u16) (wlc_hw->machwcap & 0xffff));
+	brcms_b_write_shm(wlc_hw, M_MACHW_CAP_H,
+			   (u16) ((wlc_hw->
+				      machwcap >> 16) & 0xffff));
+
+	/* write retry limits to SCR, this done after PSM init */
+	W_REG(&regs->objaddr, OBJADDR_SCR_SEL | S_DOT11_SRC_LMT);
+	(void)R_REG(&regs->objaddr);
+	W_REG(&regs->objdata, wlc_hw->SRL);
+	W_REG(&regs->objaddr, OBJADDR_SCR_SEL | S_DOT11_LRC_LMT);
+	(void)R_REG(&regs->objaddr);
+	W_REG(&regs->objdata, wlc_hw->LRL);
+
+	/* write rate fallback retry limits */
+	brcms_b_write_shm(wlc_hw, M_SFRMTXCNTFBRTHSD, wlc_hw->SFBL);
+	brcms_b_write_shm(wlc_hw, M_LFRMTXCNTFBRTHSD, wlc_hw->LFBL);
+
+	AND_REG(&regs->ifs_ctl, 0x0FFF);
+	W_REG(&regs->ifs_aifsn, EDCF_AIFSN_MIN);
+
+	/* dma initializations */
+	wlc->txpend16165war = 0;
+
+	/* init the tx dma engines */
+	for (i = 0; i < NFIFO; i++) {
+		if (wlc_hw->di[i])
+			dma_txinit(wlc_hw->di[i]);
+	}
+
+	/* init the rx dma engine(s) and post receive buffers */
+	dma_rxinit(wlc_hw->di[RX_FIFO]);
+	dma_rxfill(wlc_hw->di[RX_FIFO]);
+}
+
+void
+brcms_b_init(struct brcms_hardware *wlc_hw, chanspec_t chanspec,
+			  bool mute) {
+	u32 macintmask;
+	bool fastclk;
+	struct brcms_c_info *wlc = wlc_hw->wlc;
+
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+
+	/* request FAST clock if not on */
+	fastclk = wlc_hw->forcefastclk;
+	if (!fastclk)
+		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
+
+	/* disable interrupts */
+	macintmask = brcms_intrsoff(wlc->wl);
+
+	/* set up the specified band and chanspec */
+	brcms_c_setxband(wlc_hw, CHSPEC_BANDUNIT(chanspec));
+	wlc_phy_chanspec_radio_set(wlc_hw->band->pi, chanspec);
+
+	/* do one-time phy inits and calibration */
+	wlc_phy_cal_init(wlc_hw->band->pi);
+
+	/* core-specific initialization */
+	brcms_b_coreinit(wlc);
+
+	/* suspend the tx fifos and mute the phy for preism cac time */
+	if (mute)
+		brcms_b_mute(wlc_hw, ON, PHY_MUTE_FOR_PREISM);
+
+	/* band-specific inits */
+	brcms_b_bsinit(wlc, chanspec);
+
+	/* restore macintmask */
+	brcms_intrsrestore(wlc->wl, macintmask);
+
+	/* seed wake_override with BRCMS_WAKE_OVERRIDE_MACSUSPEND since the mac
+	 * is suspended and brcms_c_enable_mac() will clear this override bit.
+	 */
+	mboolset(wlc_hw->wake_override, BRCMS_WAKE_OVERRIDE_MACSUSPEND);
+
+	/*
+	 * initialize mac_suspend_depth to 1 to match ucode initial suspended state
+	 */
+	wlc_hw->mac_suspend_depth = 1;
+
+	/* restore the clk */
+	if (!fastclk)
+		brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
+}
+
 void brcms_c_init(struct brcms_c_info *wlc)
 {
 	d11regs_t *regs;
@@ -4296,6 +3511,17 @@ void brcms_c_set_bssid(struct brcms_bss_cfg *cfg)
 #endif
 }
 
+void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw, bool shortslot)
+{
+	wlc_hw->shortslot = shortslot;
+
+	if (BAND_2G(brcms_b_bandtype(wlc_hw)) && wlc_hw->up) {
+		brcms_c_suspend_mac_and_wait(wlc_hw->wlc);
+		brcms_b_update_slot_timing(wlc_hw, shortslot);
+		brcms_c_enable_mac(wlc_hw->wlc);
+	}
+}
+
 /*
  * Suspend the the MAC and update the slot timing
  * for standard 11b/g (20us slots) or shortslot 11g (9us slots).
@@ -4394,6 +3620,50 @@ static void brcms_c_set_phy_chanspec(struct brcms_c_info *wlc,
 
 }
 
+void
+brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, chanspec_t chanspec,
+		      bool mute, struct txpwr_limits *txpwr)
+{
+	uint bandunit;
+
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: 0x%x\n", wlc_hw->unit, chanspec);
+
+	wlc_hw->chanspec = chanspec;
+
+	/* Switch bands if necessary */
+	if (NBANDS_HW(wlc_hw) > 1) {
+		bandunit = CHSPEC_BANDUNIT(chanspec);
+		if (wlc_hw->band->bandunit != bandunit) {
+			/* brcms_b_setband disables other bandunit,
+			 *  use light band switch if not up yet
+			 */
+			if (wlc_hw->up) {
+				wlc_phy_chanspec_radio_set(wlc_hw->
+							   bandstate[bandunit]->
+							   pi, chanspec);
+				brcms_b_setband(wlc_hw, bandunit, chanspec);
+			} else {
+				brcms_c_setxband(wlc_hw, bandunit);
+			}
+		}
+	}
+
+	wlc_phy_initcal_enable(wlc_hw->band->pi, !mute);
+
+	if (!wlc_hw->up) {
+		if (wlc_hw->clk)
+			wlc_phy_txpower_limit_set(wlc_hw->band->pi, txpwr,
+						  chanspec);
+		wlc_phy_chanspec_radio_set(wlc_hw->band->pi, chanspec);
+	} else {
+		wlc_phy_chanspec_set(wlc_hw->band->pi, chanspec);
+		wlc_phy_txpower_limit_set(wlc_hw->band->pi, txpwr, chanspec);
+
+		/* Update muting of the channel */
+		brcms_b_mute(wlc_hw, mute, 0);
+	}
+}
+
 void brcms_c_set_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
 {
 	uint bandunit;
@@ -4981,6 +4251,356 @@ struct brcms_pub *brcms_c_pub(void *wlc)
 
 #define CHIP_SUPPORTS_11N(wlc)	1
 
+/* low level attach
+ *    run backplane attach, init nvram
+ *    run phy attach
+ *    initialize software state for each core and band
+ *    put the whole chip in reset(driver down state), no clock
+ */
+int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
+		    bool piomode, void *regsva, uint bustype, void *btparam)
+{
+	struct brcms_hardware *wlc_hw;
+	d11regs_t *regs;
+	char *macaddr = NULL;
+	char *vars;
+	uint err = 0;
+	uint j;
+	bool wme = false;
+	struct shared_phy_params sha_params;
+	struct wiphy *wiphy = wlc->wiphy;
+
+	BCMMSG(wlc->wiphy, "wl%d: vendor 0x%x device 0x%x\n", unit, vendor,
+		device);
+
+	wme = true;
+
+	wlc_hw = wlc->hw;
+	wlc_hw->wlc = wlc;
+	wlc_hw->unit = unit;
+	wlc_hw->band = wlc_hw->bandstate[0];
+	wlc_hw->_piomode = piomode;
+
+	/* populate struct brcms_hardware with default values  */
+	brcms_b_info_init(wlc_hw);
+
+	/*
+	 * Do the hardware portion of the attach.
+	 * Also initialize software state that depends on the particular hardware
+	 * we are running.
+	 */
+	wlc_hw->sih = ai_attach(regsva, bustype, btparam,
+				&wlc_hw->vars, &wlc_hw->vars_size);
+	if (wlc_hw->sih == NULL) {
+		wiphy_err(wiphy, "wl%d: brcms_b_attach: si_attach failed\n",
+			  unit);
+		err = 11;
+		goto fail;
+	}
+	vars = wlc_hw->vars;
+
+	/*
+	 * Get vendid/devid nvram overwrites, which could be different
+	 * than those the BIOS recognizes for devices on PCMCIA_BUS,
+	 * SDIO_BUS, and SROMless devices on PCI_BUS.
+	 */
+#ifdef BCMBUSTYPE
+	bustype = BCMBUSTYPE;
+#endif
+	if (bustype != SI_BUS) {
+		char *var;
+
+		var = getvar(vars, "vendid");
+		if (var) {
+			vendor = (u16) simple_strtoul(var, NULL, 0);
+			wiphy_err(wiphy, "Overriding vendor id = 0x%x\n",
+				  vendor);
+		}
+		var = getvar(vars, "devid");
+		if (var) {
+			u16 devid = (u16) simple_strtoul(var, NULL, 0);
+			if (devid != 0xffff) {
+				device = devid;
+				wiphy_err(wiphy, "Overriding device id = 0x%x"
+					  "\n", device);
+			}
+		}
+
+		/* verify again the device is supported */
+		if (!brcms_c_chipmatch(vendor, device)) {
+			wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported "
+				"vendor/device (0x%x/0x%x)\n",
+				 unit, vendor, device);
+			err = 12;
+			goto fail;
+		}
+	}
+
+	wlc_hw->vendorid = vendor;
+	wlc_hw->deviceid = device;
+
+	/* set bar0 window to point at D11 core */
+	wlc_hw->regs = (d11regs_t *) ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
+	wlc_hw->corerev = ai_corerev(wlc_hw->sih);
+
+	regs = wlc_hw->regs;
+
+	wlc->regs = wlc_hw->regs;
+
+	/* validate chip, chiprev and corerev */
+	if (!brcms_c_isgoodchip(wlc_hw)) {
+		err = 13;
+		goto fail;
+	}
+
+	/* initialize power control registers */
+	ai_clkctl_init(wlc_hw->sih);
+
+	/* request fastclock and force fastclock for the rest of attach
+	 * bring the d11 core out of reset.
+	 *   For PMU chips, the first wlc_clkctl_clk is no-op since core-clk is still false;
+	 *   But it will be called again inside wlc_corereset, after d11 is out of reset.
+	 */
+	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
+	brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
+
+	if (!brcms_b_validate_chip_access(wlc_hw)) {
+		wiphy_err(wiphy, "wl%d: brcms_b_attach: validate_chip_access "
+			"failed\n", unit);
+		err = 14;
+		goto fail;
+	}
+
+	/* get the board rev, used just below */
+	j = getintvar(vars, "boardrev");
+	/* promote srom boardrev of 0xFF to 1 */
+	if (j == BOARDREV_PROMOTABLE)
+		j = BOARDREV_PROMOTED;
+	wlc_hw->boardrev = (u16) j;
+	if (!brcms_c_validboardtype(wlc_hw)) {
+		wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported Broadcom "
+			"board type (0x%x)" " or revision level (0x%x)\n",
+			 unit, wlc_hw->sih->boardtype, wlc_hw->boardrev);
+		err = 15;
+		goto fail;
+	}
+	wlc_hw->sromrev = (u8) getintvar(vars, "sromrev");
+	wlc_hw->boardflags = (u32) getintvar(vars, "boardflags");
+	wlc_hw->boardflags2 = (u32) getintvar(vars, "boardflags2");
+
+	if (wlc_hw->boardflags & BFL_NOPLLDOWN)
+		brcms_b_pllreq(wlc_hw, true, BRCMS_PLLREQ_SHARED);
+
+	if ((wlc_hw->sih->bustype == PCI_BUS)
+	    && (ai_pci_war16165(wlc_hw->sih)))
+		wlc->war16165 = true;
+
+	/* check device id(srom, nvram etc.) to set bands */
+	if (wlc_hw->deviceid == BCM43224_D11N_ID ||
+	    wlc_hw->deviceid == BCM43224_D11N_ID_VEN1) {
+		/* Dualband boards */
+		wlc_hw->_nbands = 2;
+	} else
+		wlc_hw->_nbands = 1;
+
+	if ((wlc_hw->sih->chip == BCM43225_CHIP_ID))
+		wlc_hw->_nbands = 1;
+
+	/* BMAC_NOTE: remove init of pub values when brcms_c_attach()
+	 * unconditionally does the init of these values
+	 */
+	wlc->vendorid = wlc_hw->vendorid;
+	wlc->deviceid = wlc_hw->deviceid;
+	wlc->pub->sih = wlc_hw->sih;
+	wlc->pub->corerev = wlc_hw->corerev;
+	wlc->pub->sromrev = wlc_hw->sromrev;
+	wlc->pub->boardrev = wlc_hw->boardrev;
+	wlc->pub->boardflags = wlc_hw->boardflags;
+	wlc->pub->boardflags2 = wlc_hw->boardflags2;
+	wlc->pub->_nbands = wlc_hw->_nbands;
+
+	wlc_hw->physhim = wlc_phy_shim_attach(wlc_hw, wlc->wl, wlc);
+
+	if (wlc_hw->physhim == NULL) {
+		wiphy_err(wiphy, "wl%d: brcms_b_attach: wlc_phy_shim_attach "
+			"failed\n", unit);
+		err = 25;
+		goto fail;
+	}
+
+	/* pass all the parameters to wlc_phy_shared_attach in one struct */
+	sha_params.sih = wlc_hw->sih;
+	sha_params.physhim = wlc_hw->physhim;
+	sha_params.unit = unit;
+	sha_params.corerev = wlc_hw->corerev;
+	sha_params.vars = vars;
+	sha_params.vid = wlc_hw->vendorid;
+	sha_params.did = wlc_hw->deviceid;
+	sha_params.chip = wlc_hw->sih->chip;
+	sha_params.chiprev = wlc_hw->sih->chiprev;
+	sha_params.chippkg = wlc_hw->sih->chippkg;
+	sha_params.sromrev = wlc_hw->sromrev;
+	sha_params.boardtype = wlc_hw->sih->boardtype;
+	sha_params.boardrev = wlc_hw->boardrev;
+	sha_params.boardvendor = wlc_hw->sih->boardvendor;
+	sha_params.boardflags = wlc_hw->boardflags;
+	sha_params.boardflags2 = wlc_hw->boardflags2;
+	sha_params.bustype = wlc_hw->sih->bustype;
+	sha_params.buscorerev = wlc_hw->sih->buscorerev;
+
+	/* alloc and save pointer to shared phy state area */
+	wlc_hw->phy_sh = wlc_phy_shared_attach(&sha_params);
+	if (!wlc_hw->phy_sh) {
+		err = 16;
+		goto fail;
+	}
+
+	/* initialize software state for each core and band */
+	for (j = 0; j < NBANDS_HW(wlc_hw); j++) {
+		/*
+		 * band0 is always 2.4Ghz
+		 * band1, if present, is 5Ghz
+		 */
+
+		/* So if this is a single band 11a card, use band 1 */
+		if (IS_SINGLEBAND_5G(wlc_hw->deviceid))
+			j = BAND_5G_INDEX;
+
+		brcms_c_setxband(wlc_hw, j);
+
+		wlc_hw->band->bandunit = j;
+		wlc_hw->band->bandtype = j ? BRCM_BAND_5G : BRCM_BAND_2G;
+		wlc->band->bandunit = j;
+		wlc->band->bandtype = j ? BRCM_BAND_5G : BRCM_BAND_2G;
+		wlc->core->coreidx = ai_coreidx(wlc_hw->sih);
+
+		wlc_hw->machwcap = R_REG(&regs->machwcap);
+		wlc_hw->machwcap_backup = wlc_hw->machwcap;
+
+		/* init tx fifo size */
+		wlc_hw->xmtfifo_sz =
+		    xmtfifo_sz[(wlc_hw->corerev - XMTFIFOTBL_STARTREV)];
+
+		/* Get a phy for this band */
+		wlc_hw->band->pi = wlc_phy_attach(wlc_hw->phy_sh,
+			(void *)regs, brcms_b_bandtype(wlc_hw), vars,
+			wlc->wiphy);
+		if (wlc_hw->band->pi == NULL) {
+			wiphy_err(wiphy, "wl%d: brcms_b_attach: wlc_phy_"
+				  "attach failed\n", unit);
+			err = 17;
+			goto fail;
+		}
+
+		wlc_phy_machwcap_set(wlc_hw->band->pi, wlc_hw->machwcap);
+
+		wlc_phy_get_phyversion(wlc_hw->band->pi, &wlc_hw->band->phytype,
+				       &wlc_hw->band->phyrev,
+				       &wlc_hw->band->radioid,
+				       &wlc_hw->band->radiorev);
+		wlc_hw->band->abgphy_encore =
+		    wlc_phy_get_encore(wlc_hw->band->pi);
+		wlc->band->abgphy_encore = wlc_phy_get_encore(wlc_hw->band->pi);
+		wlc_hw->band->core_flags =
+		    wlc_phy_get_coreflags(wlc_hw->band->pi);
+
+		/* verify good phy_type & supported phy revision */
+		if (BRCMS_ISNPHY(wlc_hw->band)) {
+			if (NCONF_HAS(wlc_hw->band->phyrev))
+				goto good_phy;
+			else
+				goto bad_phy;
+		} else if (BRCMS_ISLCNPHY(wlc_hw->band)) {
+			if (LCNCONF_HAS(wlc_hw->band->phyrev))
+				goto good_phy;
+			else
+				goto bad_phy;
+		} else {
+ bad_phy:
+			wiphy_err(wiphy, "wl%d: brcms_b_attach: unsupported "
+				  "phy type/rev (%d/%d)\n", unit,
+				  wlc_hw->band->phytype, wlc_hw->band->phyrev);
+			err = 18;
+			goto fail;
+		}
+
+ good_phy:
+		/* BMAC_NOTE: wlc->band->pi should not be set below and should be done in the
+		 * high level attach. However we can not make that change until all low level access
+		 * is changed to wlc_hw->band->pi. Instead do the wlc->band->pi init below, keeping
+		 * wlc_hw->band->pi as well for incremental update of low level fns, and cut over
+		 * low only init when all fns updated.
+		 */
+		wlc->band->pi = wlc_hw->band->pi;
+		wlc->band->phytype = wlc_hw->band->phytype;
+		wlc->band->phyrev = wlc_hw->band->phyrev;
+		wlc->band->radioid = wlc_hw->band->radioid;
+		wlc->band->radiorev = wlc_hw->band->radiorev;
+
+		/* default contention windows size limits */
+		wlc_hw->band->CWmin = APHY_CWMIN;
+		wlc_hw->band->CWmax = PHY_CWMAX;
+
+		if (!brcms_b_attach_dmapio(wlc, j, wme)) {
+			err = 19;
+			goto fail;
+		}
+	}
+
+	/* disable core to match driver "down" state */
+	brcms_c_coredisable(wlc_hw);
+
+	/* Match driver "down" state */
+	if (wlc_hw->sih->bustype == PCI_BUS)
+		ai_pci_down(wlc_hw->sih);
+
+	/* register sb interrupt callback functions */
+	ai_register_intr_callback(wlc_hw->sih, (void *)brcms_c_wlintrsoff,
+				  (void *)brcms_c_wlintrsrestore, NULL, wlc);
+
+	/* turn off pll and xtal to match driver "down" state */
+	brcms_b_xtal(wlc_hw, OFF);
+
+	/* *********************************************************************
+	 * The hardware is in the DOWN state at this point. D11 core
+	 * or cores are in reset with clocks off, and the board PLLs
+	 * are off if possible.
+	 *
+	 * Beyond this point, wlc->sbclk == false and chip registers
+	 * should not be touched.
+	 *********************************************************************
+	 */
+
+	/* init etheraddr state variables */
+	macaddr = brcms_c_get_macaddr(wlc_hw);
+	if (macaddr == NULL) {
+		wiphy_err(wiphy, "wl%d: brcms_b_attach: macaddr not found\n",
+			  unit);
+		err = 21;
+		goto fail;
+	}
+	brcmu_ether_atoe(macaddr, wlc_hw->etheraddr);
+	if (is_broadcast_ether_addr(wlc_hw->etheraddr) ||
+	    is_zero_ether_addr(wlc_hw->etheraddr)) {
+		wiphy_err(wiphy, "wl%d: brcms_b_attach: bad macaddr %s\n",
+			  unit, macaddr);
+		err = 22;
+		goto fail;
+	}
+
+	BCMMSG(wlc->wiphy,
+		 "deviceid 0x%x nbands %d board 0x%x macaddr: %s\n",
+		 wlc_hw->deviceid, wlc_hw->_nbands,
+		 wlc_hw->sih->boardtype, macaddr);
+
+	return err;
+
+ fail:
+	wiphy_err(wiphy, "wl%d: brcms_b_attach: failed with err %d\n", unit,
+		  err);
+	return err;
+}
+
 /*
  * The common driver entry routine. Error codes should be unique
  */
@@ -5334,6 +4954,58 @@ static void brcms_c_detach_module(struct brcms_c_info *wlc)
 }
 
 /*
+ * low level detach
+ */
+int brcms_b_detach(struct brcms_c_info *wlc)
+{
+	uint i;
+	struct brcms_hw_band *band;
+	struct brcms_hardware *wlc_hw = wlc->hw;
+	int callbacks;
+
+	callbacks = 0;
+
+	if (wlc_hw->sih) {
+		/* detach interrupt sync mechanism since interrupt is disabled and per-port
+		 * interrupt object may has been freed. this must be done before sb core switch
+		 */
+		ai_deregister_intr_callback(wlc_hw->sih);
+
+		if (wlc_hw->sih->bustype == PCI_BUS)
+			ai_pci_sleep(wlc_hw->sih);
+	}
+
+	brcms_b_detach_dmapio(wlc_hw);
+
+	band = wlc_hw->band;
+	for (i = 0; i < NBANDS_HW(wlc_hw); i++) {
+		if (band->pi) {
+			/* Detach this band's phy */
+			wlc_phy_detach(band->pi);
+			band->pi = NULL;
+		}
+		band = wlc_hw->bandstate[OTHERBANDUNIT(wlc)];
+	}
+
+	/* Free shared phy state */
+	kfree(wlc_hw->phy_sh);
+
+	wlc_phy_shim_detach(wlc_hw->physhim);
+
+	/* free vars */
+	kfree(wlc_hw->vars);
+	wlc_hw->vars = NULL;
+
+	if (wlc_hw->sih) {
+		ai_detach(wlc_hw->sih);
+		wlc_hw->sih = NULL;
+	}
+
+	return callbacks;
+
+}
+
+/*
  * Return a count of the number of driver callbacks still pending.
  *
  * General policy is that brcms_c_detach can only dealloc/free software states.
@@ -5560,6 +5232,29 @@ bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc)
 	return brcms_del_timer(wlc->wl, wlc->radio_timer);
 }
 
+/* common low-level watchdog code */
+void brcms_b_watchdog(void *arg)
+{
+	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
+	struct brcms_hardware *wlc_hw = wlc->hw;
+
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
+
+	if (!wlc_hw->up)
+		return;
+
+	/* increment second count */
+	wlc_hw->now++;
+
+	/* Check for FIFO error interrupts */
+	brcms_b_fifoerrors(wlc_hw);
+
+	/* make sure RX dma has buffers */
+	dma_rxfill(wlc->hw->di[RX_FIFO]);
+
+	wlc_phy_watchdog(wlc_hw->band->pi);
+}
+
 static void brcms_c_watchdog_by_timer(void *arg)
 {
 	brcms_c_watchdog(arg);
@@ -5637,6 +5332,105 @@ static void brcms_c_watchdog(void *arg)
 	}
 }
 
+/* Initialize just the hardware when coming out of POR or S3/S5 system states */
+void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
+{
+	if (wlc_hw->wlc->pub->hw_up)
+		return;
+
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+
+	/*
+	 * Enable pll and xtal, initialize the power control registers,
+	 * and force fastclock for the remainder of brcms_c_up().
+	 */
+	brcms_b_xtal(wlc_hw, ON);
+	ai_clkctl_init(wlc_hw->sih);
+	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
+
+	if (wlc_hw->sih->bustype == PCI_BUS) {
+		ai_pci_fixcfg(wlc_hw->sih);
+
+		/* AI chip doesn't restore bar0win2 on hibernation/resume, need sw fixup */
+		if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
+		    (wlc_hw->sih->chip == BCM43225_CHIP_ID))
+			wlc_hw->regs =
+			    (d11regs_t *) ai_setcore(wlc_hw->sih, D11_CORE_ID,
+						     0);
+	}
+
+	/* Inform phy that a POR reset has occurred so it does a complete phy init */
+	wlc_phy_por_inform(wlc_hw->band->pi);
+
+	wlc_hw->ucode_loaded = false;
+	wlc_hw->wlc->pub->hw_up = true;
+
+	if ((wlc_hw->boardflags & BFL_FEM)
+	    && (wlc_hw->sih->chip == BCM4313_CHIP_ID)) {
+		if (!
+		    (wlc_hw->boardrev >= 0x1250
+		     && (wlc_hw->boardflags & BFL_FEM_BT)))
+			ai_epa_4313war(wlc_hw->sih);
+	}
+}
+
+int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
+{
+	uint coremask;
+
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+
+	/*
+	 * Enable pll and xtal, initialize the power control registers,
+	 * and force fastclock for the remainder of brcms_c_up().
+	 */
+	brcms_b_xtal(wlc_hw, ON);
+	ai_clkctl_init(wlc_hw->sih);
+	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
+
+	/*
+	 * Configure pci/pcmcia here instead of in brcms_c_attach()
+	 * to allow mfg hotswap:  down, hotswap (chip power cycle), up.
+	 */
+	coremask = (1 << wlc_hw->wlc->core->coreidx);
+
+	if (wlc_hw->sih->bustype == PCI_BUS)
+		ai_pci_setup(wlc_hw->sih, coremask);
+
+	/*
+	 * Need to read the hwradio status here to cover the case where the system
+	 * is loaded with the hw radio disabled. We do not want to bring the driver up in this case.
+	 */
+	if (brcms_b_radio_read_hwdisabled(wlc_hw)) {
+		/* put SB PCI in down state again */
+		if (wlc_hw->sih->bustype == PCI_BUS)
+			ai_pci_down(wlc_hw->sih);
+		brcms_b_xtal(wlc_hw, OFF);
+		return -ENOMEDIUM;
+	}
+
+	if (wlc_hw->sih->bustype == PCI_BUS)
+		ai_pci_up(wlc_hw->sih);
+
+	/* reset the d11 core */
+	brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
+
+	return 0;
+}
+
+int brcms_b_up_finish(struct brcms_hardware *wlc_hw)
+{
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+
+	wlc_hw->up = true;
+	wlc_phy_hw_state_upd(wlc_hw->band->pi, true);
+
+	/* FULLY enable dynamic power control and d11 core interrupt */
+	brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
+	brcms_intrson(wlc_hw->wlc->wl);
+	return 0;
+}
+
 /* make interface operational */
 int brcms_c_up(struct brcms_c_info *wlc)
 {
@@ -5773,6 +5567,78 @@ static uint brcms_c_down_del_timer(struct brcms_c_info *wlc)
 	return callbacks;
 }
 
+int brcms_b_bmac_down_prep(struct brcms_hardware *wlc_hw)
+{
+	bool dev_gone;
+	uint callbacks = 0;
+
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+
+	if (!wlc_hw->up)
+		return callbacks;
+
+	dev_gone = DEVICEREMOVED(wlc_hw->wlc);
+
+	/* disable interrupts */
+	if (dev_gone)
+		wlc_hw->wlc->macintmask = 0;
+	else {
+		/* now disable interrupts */
+		brcms_intrsoff(wlc_hw->wlc->wl);
+
+		/* ensure we're running on the pll clock again */
+		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
+	}
+	/* down phy at the last of this stage */
+	callbacks += wlc_phy_down(wlc_hw->band->pi);
+
+	return callbacks;
+}
+
+int brcms_b_down_finish(struct brcms_hardware *wlc_hw)
+{
+	uint callbacks = 0;
+	bool dev_gone;
+
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+
+	if (!wlc_hw->up)
+		return callbacks;
+
+	wlc_hw->up = false;
+	wlc_phy_hw_state_upd(wlc_hw->band->pi, false);
+
+	dev_gone = DEVICEREMOVED(wlc_hw->wlc);
+
+	if (dev_gone) {
+		wlc_hw->sbclk = false;
+		wlc_hw->clk = false;
+		wlc_phy_hw_clk_state_upd(wlc_hw->band->pi, false);
+
+		/* reclaim any posted packets */
+		brcms_c_flushqueues(wlc_hw->wlc);
+	} else {
+
+		/* Reset and disable the core */
+		if (ai_iscoreup(wlc_hw->sih)) {
+			if (R_REG(&wlc_hw->regs->maccontrol) &
+			    MCTL_EN_MAC)
+				brcms_c_suspend_mac_and_wait(wlc_hw->wlc);
+			callbacks += brcms_reset(wlc_hw->wlc->wl);
+			brcms_c_coredisable(wlc_hw);
+		}
+
+		/* turn off primary xtal and pll */
+		if (!wlc_hw->noreset) {
+			if (wlc_hw->sih->bustype == PCI_BUS)
+				ai_pci_down(wlc_hw->sih);
+			brcms_b_xtal(wlc_hw, OFF);
+		}
+	}
+
+	return callbacks;
+}
+
 /*
  * Mark the interface nonoperational, stop the software mechanisms,
  * disable the hardware, free any transient buffer state.
@@ -6709,6 +6575,29 @@ void brcms_c_print_rxh(struct d11rxhdr *rxh)
 }
 #endif				/* defined(BCMDBG) */
 
+u16 brcms_b_rate_shm_offset(struct brcms_hardware *wlc_hw, u8 rate)
+{
+	u16 table_ptr;
+	u8 phy_rate, index;
+
+	/* get the phy specific rate encoding for the PLCP SIGNAL field */
+	if (IS_OFDM(rate))
+		table_ptr = M_RT_DIRMAP_A;
+	else
+		table_ptr = M_RT_DIRMAP_B;
+
+	/* for a given rate, the LS-nibble of the PLCP SIGNAL field is
+	 * the index into the rate table.
+	 */
+	phy_rate = rate_info[rate] & BRCMS_RATE_MASK;
+	index = phy_rate & 0xf;
+
+	/* Find the SHM pointer to the rate table entry by looking in the
+	 * Direct-map Table
+	 */
+	return 2 * brcms_b_read_shm(wlc_hw, table_ptr + (index * 2));
+}
+
 static u16 brcms_c_rate_shm_offset(struct brcms_c_info *wlc, u8 rate)
 {
 	return brcms_b_rate_shm_offset(wlc->hw, rate);
@@ -8114,6 +8003,19 @@ void brcms_c_bcn_li_upd(struct brcms_c_info *wlc)
 			      (wlc->bcn_li_dtim << 8) | wlc->bcn_li_bcn);
 }
 
+void
+brcms_b_read_tsf(struct brcms_hardware *wlc_hw, u32 *tsf_l_ptr,
+		  u32 *tsf_h_ptr)
+{
+	d11regs_t *regs = wlc_hw->regs;
+
+	/* read the tsf timer low, then high to get an atomic read */
+	*tsf_l_ptr = R_REG(&regs->tsf_timerlow);
+	*tsf_h_ptr = R_REG(&regs->tsf_timerhigh);
+
+	return;
+}
+
 /*
  * recover 64bit TSF value from the 16bit TSF value in the rx header
  * given the assumption that the TSF passed in header is within 65ms
@@ -8933,6 +8835,27 @@ int brcms_c_get_header_len()
 	return TXOFF;
 }
 
+/* mac is assumed to be suspended at this point */
+void
+brcms_b_write_hw_bcntemplates(struct brcms_hardware *wlc_hw, void *bcn,
+			      int len, bool both)
+{
+	d11regs_t *regs = wlc_hw->regs;
+
+	if (both) {
+		brcms_c_write_hw_bcntemplate0(wlc_hw, bcn, len);
+		brcms_c_write_hw_bcntemplate1(wlc_hw, bcn, len);
+	} else {
+		/* bcn 0 */
+		if (!(R_REG(&regs->maccommand) & MCMD_BCN0VLD))
+			brcms_c_write_hw_bcntemplate0(wlc_hw, bcn, len);
+		/* bcn 1 */
+		else if (!
+			 (R_REG(&regs->maccommand) & MCMD_BCN1VLD))
+			brcms_c_write_hw_bcntemplate1(wlc_hw, bcn, len);
+	}
+}
+
 /* Update a beacon for a particular BSS
  * For MBSS, this updates the software template and sets "latest" to the index of the
  * template updated.
@@ -9341,6 +9264,17 @@ void brcms_c_mhf(struct brcms_c_info *wlc, u8 idx, u16 mask, u16 val, int bands)
 	brcms_b_mhf(wlc->hw, idx, mask, val, bands);
 }
 
+int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
+			   uint *blocks)
+{
+	if (fifo >= NFIFO)
+		return -EINVAL;
+
+	*blocks = wlc_hw->xmtfifo_sz[fifo];
+
+	return 0;
+}
+
 int brcms_c_xmtfifo_sz_get(struct brcms_c_info *wlc, uint fifo, uint *blocks)
 {
 	return brcms_b_xmtfifo_sz_get(wlc->hw, fifo, blocks);
-- 
1.7.1


