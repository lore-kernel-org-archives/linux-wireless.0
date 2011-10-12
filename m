Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4325 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab1JLSvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:47 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/22] brcm80211: cleanup function prototypes
Date: Wed, 12 Oct 2011 20:51:13 +0200
Message-ID: <1318445492-24207-4-git-send-email-arend@broadcom.com> (sfid-20111012_205157_064307_C3033048)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

- removed unneeded fn prototypes from include files.
- explicitly marked fn prototypes as extern in include files.
- reordered functions to account for removed forward declarations
  in include files.
- removed unused functions: brcms_c_txflowcontrol_override,
  brcms_c_txflowcontrol_prio_isset, brcms_c_txflowcontrol.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c | 3425 ++++++++++++------------
 drivers/net/wireless/brcm80211/brcmsmac/main.h |   84 -
 drivers/net/wireless/brcm80211/brcmsmac/pub.h  |   49 +-
 3 files changed, 1663 insertions(+), 1895 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 665bf80..cce6228 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -343,53 +343,6 @@ struct d11init {
 	__le32 value;
 };
 
-/* currently the best mechanism for determining SIFS is the band in use */
-static u16 get_sifs(struct brcms_band *band)
-{
-	return band->bandtype == BRCM_BAND_5G ? APHY_SIFS_TIME :
-				 BPHY_SIFS_TIME;
-}
-
-
-/*
- * Detect Card removed.
- * Even checking an sbconfig register read will not false trigger when the core
- * is in reset it breaks CF address mechanism. Accessing gphy phyversion will
- * cause SB error if aphy is in reset on 4306B0-DB. Need a simple accessible
- * reg with fixed 0/1 pattern (some platforms return all 0).
- * If clocks are present, call the sb routine which will figure out if the
- * device is removed.
- */
-static bool brcms_deviceremoved(struct brcms_c_info *wlc)
-{
-	if (!wlc->hw->clk)
-		return ai_deviceremoved(wlc->hw->sih);
-	return (R_REG(&wlc->hw->regs->maccontrol) &
-		(MCTL_PSM_JMP_0 | MCTL_IHR_EN)) != MCTL_IHR_EN;
-}
-
-/* sum the individual fifo tx pending packet counts */
-static s16 brcms_txpktpendtot(struct brcms_c_info *wlc)
-{
-	return wlc->core->txpktpend[0] + wlc->core->txpktpend[1] +
-	       wlc->core->txpktpend[2] + wlc->core->txpktpend[3];
-}
-
-static bool brcms_is_mband_unlocked(struct brcms_c_info *wlc)
-{
-	return wlc->pub->_nbands > 1 && !wlc->bandlocked;
-}
-
-static int brcms_chspec_bw(u16 chanspec)
-{
-	if (CHSPEC_IS40(chanspec))
-		return BRCMS_40_MHZ;
-	if (CHSPEC_IS20(chanspec))
-		return BRCMS_20_MHZ;
-
-	return BRCMS_10_MHZ;
-}
-
 struct edcf_acparam {
 	u8 ACI;
 	u8 ECW;
@@ -465,6 +418,66 @@ static const char fifo_names[6][0];
 static struct brcms_c_info *wlc_info_dbg = (struct brcms_c_info *) (NULL);
 #endif
 
+/* currently the best mechanism for determining SIFS is the band in use */
+static u16 get_sifs(struct brcms_band *band)
+{
+	return band->bandtype == BRCM_BAND_5G ? APHY_SIFS_TIME :
+				 BPHY_SIFS_TIME;
+}
+
+/*
+ * Detect Card removed.
+ * Even checking an sbconfig register read will not false trigger when the core
+ * is in reset it breaks CF address mechanism. Accessing gphy phyversion will
+ * cause SB error if aphy is in reset on 4306B0-DB. Need a simple accessible
+ * reg with fixed 0/1 pattern (some platforms return all 0).
+ * If clocks are present, call the sb routine which will figure out if the
+ * device is removed.
+ */
+static bool brcms_deviceremoved(struct brcms_c_info *wlc)
+{
+	if (!wlc->hw->clk)
+		return ai_deviceremoved(wlc->hw->sih);
+	return (R_REG(&wlc->hw->regs->maccontrol) &
+		(MCTL_PSM_JMP_0 | MCTL_IHR_EN)) != MCTL_IHR_EN;
+}
+
+/* sum the individual fifo tx pending packet counts */
+static s16 brcms_txpktpendtot(struct brcms_c_info *wlc)
+{
+	return wlc->core->txpktpend[0] + wlc->core->txpktpend[1] +
+	       wlc->core->txpktpend[2] + wlc->core->txpktpend[3];
+}
+
+static bool brcms_is_mband_unlocked(struct brcms_c_info *wlc)
+{
+	return wlc->pub->_nbands > 1 && !wlc->bandlocked;
+}
+
+static int brcms_chspec_bw(u16 chanspec)
+{
+	if (CHSPEC_IS40(chanspec))
+		return BRCMS_40_MHZ;
+	if (CHSPEC_IS20(chanspec))
+		return BRCMS_20_MHZ;
+
+	return BRCMS_10_MHZ;
+}
+
+/*
+ * return true if Minimum Power Consumption should
+ * be entered, false otherwise
+ */
+static bool brcms_c_is_non_delay_mpc(struct brcms_c_info *wlc)
+{
+	return false;
+}
+
+static bool brcms_c_ismpc(struct brcms_c_info *wlc)
+{
+	return (wlc->mpc_delay_off == 0) && (brcms_c_is_non_delay_mpc(wlc));
+}
+
 static void brcms_c_bsscfg_mfree(struct brcms_bss_cfg *cfg)
 {
 	if (cfg == NULL)
@@ -646,6 +659,79 @@ static void brcms_b_update_slot_timing(struct brcms_hardware *wlc_hw,
 	}
 }
 
+/*
+ * calculate frame duration of a given rate and length, return
+ * time in usec unit
+ */
+uint
+brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
+			u8 preamble_type, uint mac_len)
+{
+	uint nsyms, dur = 0, Ndps, kNdps;
+	uint rate = rspec2rate(ratespec);
+
+	if (rate == 0) {
+		wiphy_err(wlc->wiphy, "wl%d: WAR: using rate of 1 mbps\n",
+			  wlc->pub->unit);
+		rate = BRCM_RATE_1M;
+	}
+
+	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d, len%d\n",
+		 wlc->pub->unit, ratespec, preamble_type, mac_len);
+
+	if (is_mcs_rate(ratespec)) {
+		uint mcs = ratespec & RSPEC_RATE_MASK;
+		int tot_streams = mcs_2_txstreams(mcs) + rspec_stc(ratespec);
+
+		dur = PREN_PREAMBLE + (tot_streams * PREN_PREAMBLE_EXT);
+		if (preamble_type == BRCMS_MM_PREAMBLE)
+			dur += PREN_MM_EXT;
+		/* 1000Ndbps = kbps * 4 */
+		kNdps = mcs_2_rate(mcs, rspec_is40mhz(ratespec),
+				   rspec_issgi(ratespec)) * 4;
+
+		if (rspec_stc(ratespec) == 0)
+			nsyms =
+			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
+				  APHY_TAIL_NBITS) * 1000, kNdps);
+		else
+			/* STBC needs to have even number of symbols */
+			nsyms =
+			    2 *
+			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
+				  APHY_TAIL_NBITS) * 1000, 2 * kNdps);
+
+		dur += APHY_SYMBOL_TIME * nsyms;
+		if (wlc->band->bandtype == BRCM_BAND_2G)
+			dur += DOT11_OFDM_SIGNAL_EXTENSION;
+	} else if (is_ofdm_rate(rate)) {
+		dur = APHY_PREAMBLE_TIME;
+		dur += APHY_SIGNAL_TIME;
+		/* Ndbps = Mbps * 4 = rate(500Kbps) * 2 */
+		Ndps = rate * 2;
+		/* NSyms = CEILING((SERVICE + 8*NBytes + TAIL) / Ndbps) */
+		nsyms =
+		    CEIL((APHY_SERVICE_NBITS + 8 * mac_len + APHY_TAIL_NBITS),
+			 Ndps);
+		dur += APHY_SYMBOL_TIME * nsyms;
+		if (wlc->band->bandtype == BRCM_BAND_2G)
+			dur += DOT11_OFDM_SIGNAL_EXTENSION;
+	} else {
+		/*
+		 * calc # bits * 2 so factor of 2 in rate (1/2 mbps)
+		 * will divide out
+		 */
+		mac_len = mac_len * 8 * 2;
+		/* calc ceiling of bits/rate = microseconds of air time */
+		dur = (mac_len + rate - 1) / rate;
+		if (preamble_type & BRCMS_SHORT_PREAMBLE)
+			dur += BPHY_PLCP_SHORT_TIME;
+		else
+			dur += BPHY_PLCP_TIME;
+	}
+	return dur;
+}
+
 static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
 				const struct d11init *inits)
 {
@@ -740,6 +826,26 @@ static void brcms_b_core_phy_clk(struct brcms_hardware *wlc_hw, bool clk)
 	}
 }
 
+/* low-level band switch utility routine */
+static void brcms_c_setxband(struct brcms_hardware *wlc_hw, uint bandunit)
+{
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
+		bandunit);
+
+	wlc_hw->band = wlc_hw->bandstate[bandunit];
+
+	/*
+	 * BMAC_NOTE:
+	 *   until we eliminate need for wlc->band refs in low level code
+	 */
+	wlc_hw->wlc->band = wlc_hw->wlc->bandstate[bandunit];
+
+	/* set gmode core flag */
+	if (wlc_hw->sbclk && !wlc_hw->noreset)
+		ai_core_cflags(wlc_hw->sih, SICF_GMODE,
+			       ((bandunit == 0) ? SICF_GMODE : 0));
+}
+
 /* switch to new band but leave it inactive */
 static u32 brcms_c_setband_inact(struct brcms_c_info *wlc, uint bandunit)
 {
@@ -763,107 +869,45 @@ static u32 brcms_c_setband_inact(struct brcms_c_info *wlc, uint bandunit)
 	return macintmask;
 }
 
-/* Process received frames */
-/*
- * Return true if more frames need to be processed. false otherwise.
- * Param 'bound' indicates max. # frames to process before break out.
- */
+/* process an individual struct tx_status */
 static bool
-brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
+brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
 {
 	struct sk_buff *p;
-	struct sk_buff *head = NULL;
-	struct sk_buff *tail = NULL;
-	uint n = 0;
-	uint bound_limit = bound ? RXBND : -1;
-
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-	/* gather received frames */
-	while ((p = dma_rx(wlc_hw->di[fifo]))) {
+	uint queue;
+	struct d11txh *txh;
+	struct scb *scb = NULL;
+	bool free_pdu;
+	int tx_rts, tx_frame_count, tx_rts_count;
+	uint totlen, supr_status;
+	bool lastframe;
+	struct ieee80211_hdr *h;
+	u16 mcl;
+	struct ieee80211_tx_info *tx_info;
+	struct ieee80211_tx_rate *txrate;
+	int i;
 
-		if (!tail)
-			head = tail = p;
-		else {
-			tail->prev = p;
-			tail = p;
-		}
+	/* discard intermediate indications for ucode with one legitimate case:
+	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange,
+	 *   but the subsequent tx of DATA failed. so it will start rts/cts
+	 *   from the beginning (resetting the rts transmission count)
+	 */
+	if (!(txs->status & TX_STATUS_AMPDU)
+	    && (txs->status & TX_STATUS_INTERMEDIATE)) {
+		wiphy_err(wlc->wiphy, "%s: INTERMEDIATE but not AMPDU\n",
+			  __func__);
+		return false;
+	}
 
-		/* !give others some time to run! */
-		if (++n >= bound_limit)
-			break;
+	queue = txs->frameid & TXFID_QUEUE_MASK;
+	if (queue >= NFIFO) {
+		p = NULL;
+		goto fatal;
 	}
 
-	/* post more rbufs */
-	dma_rxfill(wlc_hw->di[fifo]);
-
-	/* process each frame */
-	while ((p = head) != NULL) {
-		struct d11rxhdr_le *rxh_le;
-		struct d11rxhdr *rxh;
-		head = head->prev;
-		p->prev = NULL;
-
-		rxh_le = (struct d11rxhdr_le *)p->data;
-		rxh = (struct d11rxhdr *)p->data;
-
-		/* fixup rx header endianness */
-		rxh->RxFrameSize = le16_to_cpu(rxh_le->RxFrameSize);
-		rxh->PhyRxStatus_0 = le16_to_cpu(rxh_le->PhyRxStatus_0);
-		rxh->PhyRxStatus_1 = le16_to_cpu(rxh_le->PhyRxStatus_1);
-		rxh->PhyRxStatus_2 = le16_to_cpu(rxh_le->PhyRxStatus_2);
-		rxh->PhyRxStatus_3 = le16_to_cpu(rxh_le->PhyRxStatus_3);
-		rxh->PhyRxStatus_4 = le16_to_cpu(rxh_le->PhyRxStatus_4);
-		rxh->PhyRxStatus_5 = le16_to_cpu(rxh_le->PhyRxStatus_5);
-		rxh->RxStatus1 = le16_to_cpu(rxh_le->RxStatus1);
-		rxh->RxStatus2 = le16_to_cpu(rxh_le->RxStatus2);
-		rxh->RxTSFTime = le16_to_cpu(rxh_le->RxTSFTime);
-		rxh->RxChan = le16_to_cpu(rxh_le->RxChan);
-
-		brcms_c_recv(wlc_hw->wlc, p);
-	}
-
-	return n >= bound_limit;
-}
-
-/* process an individual struct tx_status */
-static bool
-brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs)
-{
-	struct sk_buff *p;
-	uint queue;
-	struct d11txh *txh;
-	struct scb *scb = NULL;
-	bool free_pdu;
-	int tx_rts, tx_frame_count, tx_rts_count;
-	uint totlen, supr_status;
-	bool lastframe;
-	struct ieee80211_hdr *h;
-	u16 mcl;
-	struct ieee80211_tx_info *tx_info;
-	struct ieee80211_tx_rate *txrate;
-	int i;
-
-	/* discard intermediate indications for ucode with one legitimate case:
-	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange,
-	 *   but the subsequent tx of DATA failed. so it will start rts/cts
-	 *   from the beginning (resetting the rts transmission count)
-	 */
-	if (!(txs->status & TX_STATUS_AMPDU)
-	    && (txs->status & TX_STATUS_INTERMEDIATE)) {
-		wiphy_err(wlc->wiphy, "%s: INTERMEDIATE but not AMPDU\n",
-			  __func__);
-		return false;
-	}
-
-	queue = txs->frameid & TXFID_QUEUE_MASK;
-	if (queue >= NFIFO) {
-		p = NULL;
-		goto fatal;
-	}
-
-	p = dma_getnexttxp(wlc->hw->di[queue], DMA_RANGE_TRANSMITTED);
-	if (p == NULL)
-		goto fatal;
+	p = dma_getnexttxp(wlc->hw->di[queue], DMA_RANGE_TRANSMITTED);
+	if (p == NULL)
+		goto fatal;
 
 	txh = (struct d11txh *) (p->data);
 	mcl = le16_to_cpu(txh->MacTxControlLow);
@@ -1054,97 +1098,14 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 	return morepending;
 }
 
-/* second-level interrupt processing
- *   Return true if another dpc needs to be re-scheduled. false otherwise.
- *   Param 'bounded' indicates if applicable loops should be bounded.
- */
-bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
+static void brcms_c_tbtt(struct brcms_c_info *wlc)
 {
-	u32 macintstatus;
-	struct brcms_hardware *wlc_hw = wlc->hw;
-	struct d11regs __iomem *regs = wlc_hw->regs;
-	struct wiphy *wiphy = wlc->wiphy;
-
-	if (brcms_deviceremoved(wlc)) {
-		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
-			  __func__);
-		brcms_down(wlc->wl);
-		return false;
-	}
-
-	/* grab and clear the saved software intstatus bits */
-	macintstatus = wlc->macintstatus;
-	wlc->macintstatus = 0;
-
-	BCMMSG(wlc->wiphy, "wl%d: macintstatus 0x%x\n",
-	       wlc_hw->unit, macintstatus);
-
-	WARN_ON(macintstatus & MI_PRQ); /* PRQ Interrupt in non-MBSS */
-
-	/* tx status */
-	if (macintstatus & MI_TFS) {
-		bool fatal;
-		if (brcms_b_txstatus(wlc->hw, bounded, &fatal))
-			wlc->macintstatus |= MI_TFS;
-		if (fatal) {
-			wiphy_err(wiphy, "MI_TFS: fatal\n");
-			goto fatal;
-		}
-	}
-
-	if (macintstatus & (MI_TBTT | MI_DTIM_TBTT))
-		brcms_c_tbtt(wlc);
-
-	/* ATIM window end */
-	if (macintstatus & MI_ATIMWINEND) {
-		BCMMSG(wlc->wiphy, "end of ATIM window\n");
-		OR_REG(&regs->maccommand, wlc->qvalid);
-		wlc->qvalid = 0;
-	}
-
-	/*
-	 * received data or control frame, MI_DMAINT is
-	 * indication of RX_FIFO interrupt
-	 */
-	if (macintstatus & MI_DMAINT)
-		if (brcms_b_recv(wlc_hw, RX_FIFO, bounded))
-			wlc->macintstatus |= MI_DMAINT;
-
-	/* noise sample collected */
-	if (macintstatus & MI_BG_NOISE)
-		wlc_phy_noise_sample_intr(wlc_hw->band->pi);
-
-	if (macintstatus & MI_GP0) {
-		wiphy_err(wiphy, "wl%d: PSM microcode watchdog fired at %d "
-			"(seconds). Resetting.\n", wlc_hw->unit, wlc_hw->now);
-
-		printk_once("%s : PSM Watchdog, chipid 0x%x, chiprev 0x%x\n",
-					__func__, wlc_hw->sih->chip,
-					wlc_hw->sih->chiprev);
-		/* big hammer */
-		brcms_init(wlc->wl);
-	}
-
-	/* gptimer timeout */
-	if (macintstatus & MI_TO)
-		W_REG(&regs->gptimer, 0);
-
-	if (macintstatus & MI_RFDISABLE) {
-		BCMMSG(wlc->wiphy, "wl%d: BMAC Detected a change on the"
-		       " RF Disable Input\n", wlc_hw->unit);
-		brcms_rfkill_set_hw_state(wlc->wl);
-	}
-
-	/* send any enq'd tx packets. Just makes sure to jump start tx */
-	if (!pktq_empty(&wlc->pkt_queue->q))
-		brcms_c_send_q(wlc);
-
-	/* it isn't done and needs to be resched if macintstatus is non-zero */
-	return wlc->macintstatus != 0;
-
- fatal:
-	brcms_init(wlc->wl);
-	return wlc->macintstatus != 0;
+	if (!wlc->bsscfg->BSS)
+		/*
+		 * DirFrmQ is now valid...defer setting until end
+		 * of ATIM window
+		 */
+		wlc->qvalid |= MCMD_DIRFRMQVAL;
 }
 
 /* set initial host flags value */
@@ -1922,26 +1883,6 @@ static void brcms_b_setband(struct brcms_hardware *wlc_hw, uint bandunit,
 	WARN_ON((R_REG(&wlc_hw->regs->maccontrol) & MCTL_EN_MAC) != 0);
 }
 
-/* low-level band switch utility routine */
-void brcms_c_setxband(struct brcms_hardware *wlc_hw, uint bandunit)
-{
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
-		bandunit);
-
-	wlc_hw->band = wlc_hw->bandstate[bandunit];
-
-	/*
-	 * BMAC_NOTE:
-	 *   until we eliminate need for wlc->band refs in low level code
-	 */
-	wlc_hw->wlc->band = wlc_hw->wlc->bandstate[bandunit];
-
-	/* set gmode core flag */
-	if (wlc_hw->sbclk && !wlc_hw->noreset)
-		ai_core_cflags(wlc_hw->sih, SICF_GMODE,
-			       ((bandunit == 0) ? SICF_GMODE : 0));
-}
-
 static bool brcms_c_isgoodchip(struct brcms_hardware *wlc_hw)
 {
 
@@ -2405,6 +2346,13 @@ void brcms_b_antsel_type_set(struct brcms_hardware *wlc_hw, u8 antsel_type)
 	wlc_phy_antsel_type_set(wlc_hw->band->pi, antsel_type);
 }
 
+static void brcms_c_fatal_error(struct brcms_c_info *wlc)
+{
+	wiphy_err(wlc->wiphy, "wl%d: fatal error, reinitializing\n",
+		  wlc->pub->unit);
+	brcms_init(wlc->wl);
+}
+
 static void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
 {
 	bool fatal = false;
@@ -2962,7 +2910,7 @@ void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on)
 	}
 }
 
-void brcms_c_coredisable(struct brcms_hardware *wlc_hw)
+static void brcms_c_coredisable(struct brcms_hardware *wlc_hw)
 {
 	bool dev_gone;
 
@@ -3106,6 +3054,16 @@ brcms_b_copyfrom_objmem(struct brcms_hardware *wlc_hw, uint offset, void *buf,
 	}
 }
 
+/* Copy a buffer to shared memory.
+ * SHM 'offset' needs to be an even address and
+ * Buffer length 'len' must be an even number of bytes
+ */
+static void brcms_c_copyto_shm(struct brcms_c_info *wlc, uint offset,
+			const void *buf, int len)
+{
+	brcms_b_copyto_objmem(wlc->hw, offset, buf, len, OBJADDR_SHM_SEL);
+}
+
 static void brcms_b_retrylimit_upd(struct brcms_hardware *wlc_hw,
 				   u16 SRL, u16 LRL)
 {
@@ -3159,7 +3117,7 @@ static void brcms_b_antsel_set(struct brcms_hardware *wlc_hw, u32 antsel_avail)
  * conditions under which the PM bit should be set in outgoing frames
  * and STAY_AWAKE is meaningful
  */
-bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
+static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 {
 	struct brcms_bss_cfg *cfg = wlc->bsscfg;
 
@@ -3185,6 +3143,58 @@ bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 	return true;
 }
 
+static void brcms_c_statsupd(struct brcms_c_info *wlc)
+{
+	int i;
+	struct macstat macstats;
+#ifdef BCMDBG
+	u16 delta;
+	u16 rxf0ovfl;
+	u16 txfunfl[NFIFO];
+#endif				/* BCMDBG */
+
+	/* if driver down, make no sense to update stats */
+	if (!wlc->pub->up)
+		return;
+
+#ifdef BCMDBG
+	/* save last rx fifo 0 overflow count */
+	rxf0ovfl = wlc->core->macstat_snapshot->rxf0ovfl;
+
+	/* save last tx fifo  underflow count */
+	for (i = 0; i < NFIFO; i++)
+		txfunfl[i] = wlc->core->macstat_snapshot->txfunfl[i];
+#endif				/* BCMDBG */
+
+	/* Read mac stats from contiguous shared memory */
+	brcms_b_copyfrom_objmem(wlc->hw, M_UCODE_MACSTAT, &macstats,
+				sizeof(struct macstat), OBJADDR_SHM_SEL);
+
+#ifdef BCMDBG
+	/* check for rx fifo 0 overflow */
+	delta = (u16) (wlc->core->macstat_snapshot->rxf0ovfl - rxf0ovfl);
+	if (delta)
+		wiphy_err(wlc->wiphy, "wl%d: %u rx fifo 0 overflows!\n",
+			  wlc->pub->unit, delta);
+
+	/* check for tx fifo underflows */
+	for (i = 0; i < NFIFO; i++) {
+		delta =
+		    (u16) (wlc->core->macstat_snapshot->txfunfl[i] -
+			      txfunfl[i]);
+		if (delta)
+			wiphy_err(wlc->wiphy, "wl%d: %u tx fifo %d underflows!"
+				  "\n", wlc->pub->unit, delta, i);
+	}
+#endif				/* BCMDBG */
+
+	/* merge counters from dma module */
+	for (i = 0; i < NFIFO; i++) {
+		if (wlc->hw->di[i])
+			dma_counterreset(wlc->hw->di[i]);
+	}
+}
+
 static void brcms_b_reset(struct brcms_hardware *wlc_hw)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
@@ -3211,13 +3221,6 @@ void brcms_c_reset(struct brcms_c_info *wlc)
 	brcms_b_reset(wlc->hw);
 }
 
-void brcms_c_fatal_error(struct brcms_c_info *wlc)
-{
-	wiphy_err(wlc->wiphy, "wl%d: fatal error, reinitializing\n",
-		  wlc->pub->unit);
-	brcms_init(wlc->wl);
-}
-
 /* Return the channel the driver should initialize during brcms_c_init.
  * the channel may have to be changed from the currently configured channel
  * if other configurations are in conflict (bandlocked, 11n mode disabled,
@@ -3494,11 +3497,115 @@ static void brcms_c_set_phy_chanspec(struct brcms_c_info *wlc,
 					    chanspec);
 
 	brcms_c_stf_ss_update(wlc, wlc->band);
-
 }
 
-static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
-				     u16 chanspec)
+static void
+brcms_default_rateset(struct brcms_c_info *wlc, struct brcms_c_rateset *rs)
+{
+	brcms_c_rateset_default(rs, NULL, wlc->band->phytype,
+		wlc->band->bandtype, false, BRCMS_RATE_MASK_FULL,
+		(bool) (wlc->pub->_n_enab & SUPPORT_11N),
+		brcms_chspec_bw(wlc->default_bss->chanspec),
+		wlc->stf->txstreams);
+}
+
+/* derive wlc->band->basic_rate[] table from 'rateset' */
+static void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
+			      struct brcms_c_rateset *rateset)
+{
+	u8 rate;
+	u8 mandatory;
+	u8 cck_basic = 0;
+	u8 ofdm_basic = 0;
+	u8 *br = wlc->band->basic_rate;
+	uint i;
+
+	/* incoming rates are in 500kbps units as in 802.11 Supported Rates */
+	memset(br, 0, BRCM_MAXRATE + 1);
+
+	/* For each basic rate in the rates list, make an entry in the
+	 * best basic lookup.
+	 */
+	for (i = 0; i < rateset->count; i++) {
+		/* only make an entry for a basic rate */
+		if (!(rateset->rates[i] & BRCMS_RATE_FLAG))
+			continue;
+
+		/* mask off basic bit */
+		rate = (rateset->rates[i] & BRCMS_RATE_MASK);
+
+		if (rate > BRCM_MAXRATE) {
+			wiphy_err(wlc->wiphy, "brcms_c_rate_lookup_init: "
+				  "invalid rate 0x%X in rate set\n",
+				  rateset->rates[i]);
+			continue;
+		}
+
+		br[rate] = rate;
+	}
+
+	/* The rate lookup table now has non-zero entries for each
+	 * basic rate, equal to the basic rate: br[basicN] = basicN
+	 *
+	 * To look up the best basic rate corresponding to any
+	 * particular rate, code can use the basic_rate table
+	 * like this
+	 *
+	 * basic_rate = wlc->band->basic_rate[tx_rate]
+	 *
+	 * Make sure there is a best basic rate entry for
+	 * every rate by walking up the table from low rates
+	 * to high, filling in holes in the lookup table
+	 */
+
+	for (i = 0; i < wlc->band->hw_rateset.count; i++) {
+		rate = wlc->band->hw_rateset.rates[i];
+
+		if (br[rate] != 0) {
+			/* This rate is a basic rate.
+			 * Keep track of the best basic rate so far by
+			 * modulation type.
+			 */
+			if (is_ofdm_rate(rate))
+				ofdm_basic = rate;
+			else
+				cck_basic = rate;
+
+			continue;
+		}
+
+		/* This rate is not a basic rate so figure out the
+		 * best basic rate less than this rate and fill in
+		 * the hole in the table
+		 */
+
+		br[rate] = is_ofdm_rate(rate) ? ofdm_basic : cck_basic;
+
+		if (br[rate] != 0)
+			continue;
+
+		if (is_ofdm_rate(rate)) {
+			/*
+			 * In 11g and 11a, the OFDM mandatory rates
+			 * are 6, 12, and 24 Mbps
+			 */
+			if (rate >= BRCM_RATE_24M)
+				mandatory = BRCM_RATE_24M;
+			else if (rate >= BRCM_RATE_12M)
+				mandatory = BRCM_RATE_12M;
+			else
+				mandatory = BRCM_RATE_6M;
+		} else {
+			/* In 11b, all CCK rates are mandatory 1 - 11 Mbps */
+			mandatory = rate;
+		}
+
+		br[rate] = mandatory;
+	}
+}
+
+static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
+				     u16 chanspec)
 {
 	struct brcms_c_rateset default_rateset;
 	uint parkband;
@@ -3543,6 +3650,44 @@ static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 	brcms_c_set_phy_chanspec(wlc, chanspec);
 }
 
+static void brcms_c_mac_bcn_promisc(struct brcms_c_info *wlc)
+{
+	if (wlc->bcnmisc_monitor)
+		brcms_b_mctrl(wlc->hw, MCTL_BCNS_PROMISC, MCTL_BCNS_PROMISC);
+	else
+		brcms_b_mctrl(wlc->hw, MCTL_BCNS_PROMISC, 0);
+}
+
+void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc, bool promisc)
+{
+	wlc->bcnmisc_monitor = promisc;
+	brcms_c_mac_bcn_promisc(wlc);
+}
+
+/* set or clear maccontrol bits MCTL_PROMISC and MCTL_KEEPCONTROL */
+static void brcms_c_mac_promisc(struct brcms_c_info *wlc)
+{
+	u32 promisc_bits = 0;
+
+	/*
+	 * promiscuous mode just sets MCTL_PROMISC
+	 * Note: APs get all BSS traffic without the need to set
+	 * the MCTL_PROMISC bit since all BSS data traffic is
+	 * directed at the AP
+	 */
+	if (wlc->pub->promisc)
+		promisc_bits |= MCTL_PROMISC;
+
+	/* monitor mode needs both MCTL_PROMISC and MCTL_KEEPCONTROL
+	 * Note: monitor mode also needs MCTL_BCNS_PROMISC, but that is
+	 * handled in brcms_c_mac_bcn_promisc()
+	 */
+	if (wlc->monitor)
+		promisc_bits |= MCTL_PROMISC | MCTL_KEEPCONTROL;
+
+	brcms_b_mctrl(wlc->hw, MCTL_PROMISC | MCTL_KEEPCONTROL, promisc_bits);
+}
+
 /*
  * ucode, hwmac update
  *    Channel dependent updates for ucode and hw
@@ -3576,6 +3721,88 @@ static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc)
 	brcms_c_mac_promisc(wlc);
 }
 
+static void brcms_c_write_rate_shm(struct brcms_c_info *wlc, u8 rate,
+				   u8 basic_rate)
+{
+	u8 phy_rate, index;
+	u8 basic_phy_rate, basic_index;
+	u16 dir_table, basic_table;
+	u16 basic_ptr;
+
+	/* Shared memory address for the table we are reading */
+	dir_table = is_ofdm_rate(basic_rate) ? M_RT_DIRMAP_A : M_RT_DIRMAP_B;
+
+	/* Shared memory address for the table we are writing */
+	basic_table = is_ofdm_rate(rate) ? M_RT_BBRSMAP_A : M_RT_BBRSMAP_B;
+
+	/*
+	 * for a given rate, the LS-nibble of the PLCP SIGNAL field is
+	 * the index into the rate table.
+	 */
+	phy_rate = rate_info[rate] & BRCMS_RATE_MASK;
+	basic_phy_rate = rate_info[basic_rate] & BRCMS_RATE_MASK;
+	index = phy_rate & 0xf;
+	basic_index = basic_phy_rate & 0xf;
+
+	/* Find the SHM pointer to the ACK rate entry by looking in the
+	 * Direct-map Table
+	 */
+	basic_ptr = brcms_b_read_shm(wlc->hw, (dir_table + basic_index * 2));
+
+	/* Update the SHM BSS-basic-rate-set mapping table with the pointer
+	 * to the correct basic rate for the given incoming rate
+	 */
+	brcms_b_write_shm(wlc->hw, (basic_table + index * 2), basic_ptr);
+}
+
+static const struct brcms_c_rateset *
+brcms_c_rateset_get_hwrs(struct brcms_c_info *wlc)
+{
+	const struct brcms_c_rateset *rs_dflt;
+
+	if (BRCMS_PHY_11N_CAP(wlc->band)) {
+		if (wlc->band->bandtype == BRCM_BAND_5G)
+			rs_dflt = &ofdm_mimo_rates;
+		else
+			rs_dflt = &cck_ofdm_mimo_rates;
+	} else if (wlc->band->gmode)
+		rs_dflt = &cck_ofdm_rates;
+	else
+		rs_dflt = &cck_rates;
+
+	return rs_dflt;
+}
+
+static void brcms_c_set_ratetable(struct brcms_c_info *wlc)
+{
+	const struct brcms_c_rateset *rs_dflt;
+	struct brcms_c_rateset rs;
+	u8 rate, basic_rate;
+	uint i;
+
+	rs_dflt = brcms_c_rateset_get_hwrs(wlc);
+
+	brcms_c_rateset_copy(rs_dflt, &rs);
+	brcms_c_rateset_mcs_upd(&rs, wlc->stf->txstreams);
+
+	/* walk the phy rate table and update SHM basic rate lookup table */
+	for (i = 0; i < rs.count; i++) {
+		rate = rs.rates[i] & BRCMS_RATE_MASK;
+
+		/* for a given rate brcms_basic_rate returns the rate at
+		 * which a response ACK/CTS should be sent.
+		 */
+		basic_rate = brcms_basic_rate(wlc, rate);
+		if (basic_rate == 0)
+			/* This should only happen if we are using a
+			 * restricted rateset.
+			 */
+			basic_rate = rs.rates[0] & BRCMS_RATE_MASK;
+
+		brcms_c_write_rate_shm(wlc, rate, basic_rate);
+	}
+}
+
 /* band-specific init */
 static void brcms_c_bsinit(struct brcms_c_info *wlc)
 {
@@ -3655,183 +3882,35 @@ static void brcms_c_txflowcontrol_reset(struct brcms_c_info *wlc)
 	}
 }
 
-void brcms_c_init(struct brcms_c_info *wlc)
+/* push sw hps and wake state through hardware */
+static void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
 {
-	struct d11regs __iomem *regs;
-	u16 chanspec;
-	bool mute = false;
-
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
+	u32 v1, v2;
+	bool hps;
+	bool awake_before;
 
-	regs = wlc->regs;
+	hps = brcms_c_ps_allowed(wlc);
 
-	/*
-	 * This will happen if a big-hammer was executed. In
-	 * that case, we want to go back to the channel that
-	 * we were on and not new channel
-	 */
-	if (wlc->pub->associated)
-		chanspec = wlc->home_chanspec;
-	else
-		chanspec = brcms_c_init_chanspec(wlc);
+	BCMMSG(wlc->wiphy, "wl%d: hps %d\n", wlc->pub->unit, hps);
 
-	brcms_b_init(wlc->hw, chanspec, mute);
+	v1 = R_REG(&wlc->regs->maccontrol);
+	v2 = MCTL_WAKE;
+	if (hps)
+		v2 |= MCTL_HPS;
 
-	/* update beacon listen interval */
-	brcms_c_bcn_li_upd(wlc);
+	brcms_b_mctrl(wlc->hw, MCTL_WAKE | MCTL_HPS, v2);
 
-	/* write ethernet address to core */
-	brcms_c_set_mac(wlc->bsscfg);
-	brcms_c_set_bssid(wlc->bsscfg);
-
-	/* Update tsf_cfprep if associated and up */
-	if (wlc->pub->associated && wlc->bsscfg->up) {
-		u32 bi;
-
-		/* get beacon period and convert to uS */
-		bi = wlc->bsscfg->current_bss->beacon_period << 10;
-		/*
-		 * update since init path would reset
-		 * to default value
-		 */
-		W_REG(&regs->tsf_cfprep,
-		      (bi << CFPREP_CBI_SHIFT));
-
-		/* Update maccontrol PM related bits */
-		brcms_c_set_ps_ctrl(wlc);
-	}
-
-	brcms_c_bandinit_ordered(wlc, chanspec);
-
-	/* init probe response timeout */
-	brcms_b_write_shm(wlc->hw, M_PRS_MAXTIME, wlc->prb_resp_timeout);
-
-	/* init max burst txop (framebursting) */
-	brcms_b_write_shm(wlc->hw, M_MBURST_TXOP,
-		      (wlc->
-		       _rifs ? (EDCF_AC_VO_TXOP_AP << 5) : MAXFRAMEBURST_TXOP));
-
-	/* initialize maximum allowed duty cycle */
-	brcms_c_duty_cycle_set(wlc, wlc->tx_duty_cycle_ofdm, true, true);
-	brcms_c_duty_cycle_set(wlc, wlc->tx_duty_cycle_cck, false, true);
-
-	/*
-	 * Update some shared memory locations related to
-	 * max AMPDU size allowed to received
-	 */
-	brcms_c_ampdu_shm_upd(wlc->ampdu);
-
-	/* band-specific inits */
-	brcms_c_bsinit(wlc);
-
-	/* Enable EDCF mode (while the MAC is suspended) */
-	OR_REG(&regs->ifs_ctl, IFS_USEEDCF);
-	brcms_c_edcf_setparams(wlc, false);
-
-	/* Init precedence maps for empty FIFOs */
-	brcms_c_tx_prec_map_init(wlc);
-
-	/* read the ucode version if we have not yet done so */
-	if (wlc->ucode_rev == 0) {
-		wlc->ucode_rev =
-		    brcms_b_read_shm(wlc->hw, M_BOM_REV_MAJOR) << NBITS(u16);
-		wlc->ucode_rev |= brcms_b_read_shm(wlc->hw, M_BOM_REV_MINOR);
-	}
-
-	/* ..now really unleash hell (allow the MAC out of suspend) */
-	brcms_c_enable_mac(wlc);
-
-	/* clear tx flow control */
-	brcms_c_txflowcontrol_reset(wlc);
-
-	/* enable the RF Disable Delay timer */
-	W_REG(&wlc->regs->rfdisabledly, RFDISABLE_DEFAULT);
-
-	/* initialize mpc delay */
-	wlc->mpc_delay_off = wlc->mpc_dlycnt = BRCMS_MPC_MIN_DELAYCNT;
-
-	/*
-	 * Initialize WME parameters; if they haven't been set by some other
-	 * mechanism (IOVar, etc) then read them from the hardware.
-	 */
-	if (GFIELD(wlc->wme_retries[0], EDCF_SHORT) == 0) {
-		/* Uninitialized; read from HW */
-		int ac;
-
-		for (ac = 0; ac < AC_COUNT; ac++)
-			wlc->wme_retries[ac] =
-			    brcms_b_read_shm(wlc->hw, M_AC_TXLMT_ADDR(ac));
-	}
-}
-
-void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc, bool promisc)
-{
-	wlc->bcnmisc_monitor = promisc;
-	brcms_c_mac_bcn_promisc(wlc);
-}
-
-void brcms_c_mac_bcn_promisc(struct brcms_c_info *wlc)
-{
-	if (wlc->bcnmisc_monitor)
-		brcms_b_mctrl(wlc->hw, MCTL_BCNS_PROMISC, MCTL_BCNS_PROMISC);
-	else
-		brcms_b_mctrl(wlc->hw, MCTL_BCNS_PROMISC, 0);
-}
-
-/* set or clear maccontrol bits MCTL_PROMISC and MCTL_KEEPCONTROL */
-void brcms_c_mac_promisc(struct brcms_c_info *wlc)
-{
-	u32 promisc_bits = 0;
-
-	/*
-	 * promiscuous mode just sets MCTL_PROMISC
-	 * Note: APs get all BSS traffic without the need to set
-	 * the MCTL_PROMISC bit since all BSS data traffic is
-	 * directed at the AP
-	 */
-	if (wlc->pub->promisc)
-		promisc_bits |= MCTL_PROMISC;
-
-	/* monitor mode needs both MCTL_PROMISC and MCTL_KEEPCONTROL
-	 * Note: monitor mode also needs MCTL_BCNS_PROMISC, but that is
-	 * handled in brcms_c_mac_bcn_promisc()
-	 */
-	if (wlc->monitor)
-		promisc_bits |= MCTL_PROMISC | MCTL_KEEPCONTROL;
-
-	brcms_b_mctrl(wlc->hw, MCTL_PROMISC | MCTL_KEEPCONTROL, promisc_bits);
-}
-
-/* push sw hps and wake state through hardware */
-void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
-{
-	u32 v1, v2;
-	bool hps;
-	bool awake_before;
-
-	hps = brcms_c_ps_allowed(wlc);
-
-	BCMMSG(wlc->wiphy, "wl%d: hps %d\n", wlc->pub->unit, hps);
-
-	v1 = R_REG(&wlc->regs->maccontrol);
-	v2 = MCTL_WAKE;
-	if (hps)
-		v2 |= MCTL_HPS;
-
-	brcms_b_mctrl(wlc->hw, MCTL_WAKE | MCTL_HPS, v2);
-
-	awake_before = ((v1 & MCTL_WAKE) || ((v1 & MCTL_HPS) == 0));
+	awake_before = ((v1 & MCTL_WAKE) || ((v1 & MCTL_HPS) == 0));
 
 	if (!awake_before)
 		brcms_b_wait_for_wake(wlc->hw);
-
 }
 
 /*
  * Write this BSS config's MAC address to core.
  * Updates RXE match engine.
  */
-int brcms_c_set_mac(struct brcms_bss_cfg *bsscfg)
+static int brcms_c_set_mac(struct brcms_bss_cfg *bsscfg)
 {
 	int err = 0;
 	struct brcms_c_info *wlc = bsscfg->wlc;
@@ -3847,7 +3926,7 @@ int brcms_c_set_mac(struct brcms_bss_cfg *bsscfg)
 /* Write the BSS config's BSSID address to core (set_bssid in d11procs.tcl).
  * Updates RXE match engine.
  */
-void brcms_c_set_bssid(struct brcms_bss_cfg *bsscfg)
+static void brcms_c_set_bssid(struct brcms_bss_cfg *bsscfg)
 {
 	/* we need to update BSSID in RXE match registers */
 	brcms_c_set_addrmatch(bsscfg->wlc, RCM_BSSID_OFFSET, bsscfg->BSSID);
@@ -3868,7 +3947,7 @@ static void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw, bool shortslot)
  * Suspend the the MAC and update the slot timing
  * for standard 11b/g (20us slots) or shortslot 11g (9us slots).
  */
-void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
+static void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
 {
 	/* use the override if it is set */
 	if (wlc->shortslot_override != BRCMS_SHORTSLOT_AUTO)
@@ -3882,7 +3961,7 @@ void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
 	brcms_b_set_shortslot(wlc->hw, shortslot);
 }
 
-void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, u16 chanspec)
+static void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 {
 	if (wlc->home_chanspec != chanspec) {
 		wlc->home_chanspec = chanspec;
@@ -3952,7 +4031,7 @@ static void brcms_c_setband(struct brcms_c_info *wlc,
 	brcms_c_bsinit(wlc);
 }
 
-void brcms_c_set_chanspec(struct brcms_c_info *wlc, u16 chanspec)
+static void brcms_c_set_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 {
 	uint bandunit;
 	bool switchband = false;
@@ -4006,31 +4085,6 @@ void brcms_c_set_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 	brcms_c_ucode_mac_upd(wlc);
 }
 
-u32 brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
-				      struct brcms_c_rateset *rs)
-{
-	u32 lowest_basic_rspec;
-	uint i;
-
-	/* Use the lowest basic rate */
-	lowest_basic_rspec = rs->rates[0] & BRCMS_RATE_MASK;
-	for (i = 0; i < rs->count; i++) {
-		if (rs->rates[i] & BRCMS_RATE_FLAG) {
-			lowest_basic_rspec = rs->rates[i] & BRCMS_RATE_MASK;
-			break;
-		}
-	}
-
-	/*
-	 * pick siso/cdd as default for OFDM (note no basic
-	 * rate MCSs are supported yet)
-	 */
-	if (is_ofdm_rate(lowest_basic_rspec))
-		lowest_basic_rspec |= (wlc->stf->ss_opmode << RSPEC_STF_SHIFT);
-
-	return lowest_basic_rspec;
-}
-
 /*
  * This function changes the phytxctl for beacon based on current
  * beacon ratespec AND txant setting as per this table:
@@ -4239,7 +4293,7 @@ static void brcms_c_radio_monitor_start(struct brcms_c_info *wlc)
 	brcms_add_timer(wlc->radio_timer, TIMER_INTERVAL_RADIOCHK, true);
 }
 
-void brcms_c_radio_disable(struct brcms_c_info *wlc)
+static void brcms_c_radio_disable(struct brcms_c_info *wlc)
 {
 	if (!wlc->pub->up) {
 		brcms_c_down_led_upd(wlc);
@@ -4261,7 +4315,7 @@ static void brcms_c_radio_enable(struct brcms_c_info *wlc)
 	brcms_up(wlc->wl);
 }
 
-bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc)
+static bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc)
 {
 	if (!wlc->radio_monitor)
 		return true;
@@ -4347,6 +4401,60 @@ static void brcms_b_watchdog(void *arg)
 	wlc_phy_watchdog(wlc_hw->band->pi);
 }
 
+static void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
+{
+	bool mpc_radio, radio_state;
+
+	/*
+	 * Clear the WL_RADIO_MPC_DISABLE bit when mpc feature is disabled
+	 * in case the WL_RADIO_MPC_DISABLE bit was set. Stop the radio
+	 * monitor also when WL_RADIO_MPC_DISABLE is the only reason that
+	 * the radio is going down.
+	 */
+	if (!wlc->mpc) {
+		if (!wlc->pub->radio_disabled)
+			return;
+		mboolclr(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE);
+		brcms_c_radio_upd(wlc);
+		if (!wlc->pub->radio_disabled)
+			brcms_c_radio_monitor_stop(wlc);
+		return;
+	}
+
+	/*
+	 * sync ismpc logic with WL_RADIO_MPC_DISABLE bit in
+	 * wlc->pub->radio_disabled to go ON, always call radio_upd
+	 * synchronously to go OFF, postpone radio_upd to later when
+	 * context is safe(e.g. watchdog)
+	 */
+	radio_state =
+	    (mboolisset(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE) ? OFF :
+	     ON);
+	mpc_radio = (brcms_c_ismpc(wlc) == true) ? OFF : ON;
+
+	if (radio_state == ON && mpc_radio == OFF)
+		wlc->mpc_delay_off = wlc->mpc_dlycnt;
+	else if (radio_state == OFF && mpc_radio == ON) {
+		mboolclr(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE);
+		brcms_c_radio_upd(wlc);
+		if (wlc->mpc_offcnt < BRCMS_MPC_THRESHOLD)
+			wlc->mpc_dlycnt = BRCMS_MPC_MAX_DELAYCNT;
+		else
+			wlc->mpc_dlycnt = BRCMS_MPC_MIN_DELAYCNT;
+	}
+	/*
+	 * Below logic is meant to capture the transition from mpc off
+	 * to mpc on for reasons other than wlc->mpc_delay_off keeping
+	 * the mpc off. In that case reset wlc->mpc_delay_off to
+	 * wlc->mpc_dlycnt, so that we restart the countdown of mpc_delay_off
+	 */
+	if ((wlc->prev_non_delay_mpc == false) &&
+	    (brcms_c_is_non_delay_mpc(wlc) == true) && wlc->mpc_delay_off)
+		wlc->mpc_delay_off = wlc->mpc_dlycnt;
+
+	wlc->prev_non_delay_mpc = brcms_c_is_non_delay_mpc(wlc);
+}
+
 /* common watchdog code */
 static void brcms_c_watchdog(void *arg)
 {
@@ -4408,7 +4516,7 @@ static void brcms_c_watchdog_by_timer(void *arg)
 	brcms_c_watchdog(arg);
 }
 
-bool brcms_c_timers_init(struct brcms_c_info *wlc, int unit)
+static bool brcms_c_timers_init(struct brcms_c_info *wlc, int unit)
 {
 	wlc->wdtimer = brcms_init_timer(wlc->wl, brcms_c_watchdog_by_timer,
 		wlc, "watchdog");
@@ -4436,7 +4544,7 @@ bool brcms_c_timers_init(struct brcms_c_info *wlc, int unit)
  * Initialize brcms_c_info default values ...
  * may get overrides later in this function
  */
-void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
+static void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 {
 	int i;
 
@@ -5025,224 +5133,33 @@ static void brcms_c_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap)
 	}
 }
 
-/*
- * The common driver entry routine. Error codes should be unique
- */
-struct brcms_c_info *
-brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
-	       bool piomode, void __iomem *regsva, struct pci_dev *btparam,
-	       uint *perr)
+static void brcms_c_timers_deinit(struct brcms_c_info *wlc)
 {
-	struct brcms_c_info *wlc;
-	uint err = 0;
-	uint i, j;
-	struct brcms_pub *pub;
-
-	/* allocate struct brcms_c_info state and its substructures */
-	wlc = (struct brcms_c_info *) brcms_c_attach_malloc(unit, &err, device);
-	if (wlc == NULL)
-		goto fail;
-	wlc->wiphy = wl->wiphy;
-	pub = wlc->pub;
-
-#if defined(BCMDBG)
-	wlc_info_dbg = wlc;
-#endif
+	/* free timer state */
+	if (wlc->wdtimer) {
+		brcms_free_timer(wlc->wdtimer);
+		wlc->wdtimer = NULL;
+	}
+	if (wlc->radio_timer) {
+		brcms_free_timer(wlc->radio_timer);
+		wlc->radio_timer = NULL;
+	}
+}
 
-	wlc->band = wlc->bandstate[0];
-	wlc->core = wlc->corestate;
-	wlc->wl = wl;
-	pub->unit = unit;
-	pub->_piomode = piomode;
-	wlc->bandinit_pending = false;
+static void brcms_c_detach_module(struct brcms_c_info *wlc)
+{
+	if (wlc->asi) {
+		brcms_c_antsel_detach(wlc->asi);
+		wlc->asi = NULL;
+	}
 
-	/* populate struct brcms_c_info with default values  */
-	brcms_c_info_init(wlc, unit);
+	if (wlc->ampdu) {
+		brcms_c_ampdu_detach(wlc->ampdu);
+		wlc->ampdu = NULL;
+	}
 
-	/* update sta/ap related parameters */
-	brcms_c_ap_upd(wlc);
-
-	/*
-	 * low level attach steps(all hw accesses go
-	 * inside, no more in rest of the attach)
-	 */
-	err = brcms_b_attach(wlc, vendor, device, unit, piomode, regsva,
-			     btparam);
-	if (err)
-		goto fail;
-
-	brcms_c_protection_upd(wlc, BRCMS_PROT_N_PAM_OVR, OFF);
-
-	pub->phy_11ncapable = BRCMS_PHY_11N_CAP(wlc->band);
-
-	/* disable allowed duty cycle */
-	wlc->tx_duty_cycle_ofdm = 0;
-	wlc->tx_duty_cycle_cck = 0;
-
-	brcms_c_stf_phy_chain_calc(wlc);
-
-	/* txchain 1: txant 0, txchain 2: txant 1 */
-	if (BRCMS_ISNPHY(wlc->band) && (wlc->stf->txstreams == 1))
-		wlc->stf->txant = wlc->stf->hw_txchain - 1;
-
-	/* push to BMAC driver */
-	wlc_phy_stf_chain_init(wlc->band->pi, wlc->stf->hw_txchain,
-			       wlc->stf->hw_rxchain);
-
-	/* pull up some info resulting from the low attach */
-	for (i = 0; i < NFIFO; i++)
-		wlc->core->txavail[i] = wlc->hw->txavail[i];
-
-	memcpy(&wlc->perm_etheraddr, &wlc->hw->etheraddr, ETH_ALEN);
-	memcpy(&pub->cur_etheraddr, &wlc->hw->etheraddr, ETH_ALEN);
-
-	for (j = 0; j < wlc->pub->_nbands; j++) {
-		wlc->band = wlc->bandstate[j];
-
-		if (!brcms_c_attach_stf_ant_init(wlc)) {
-			err = 24;
-			goto fail;
-		}
-
-		/* default contention windows size limits */
-		wlc->band->CWmin = APHY_CWMIN;
-		wlc->band->CWmax = PHY_CWMAX;
-
-		/* init gmode value */
-		if (wlc->band->bandtype == BRCM_BAND_2G) {
-			wlc->band->gmode = GMODE_AUTO;
-			brcms_c_protection_upd(wlc, BRCMS_PROT_G_USER,
-					   wlc->band->gmode);
-		}
-
-		/* init _n_enab supported mode */
-		if (BRCMS_PHY_11N_CAP(wlc->band)) {
-			pub->_n_enab = SUPPORT_11N;
-			brcms_c_protection_upd(wlc, BRCMS_PROT_N_USER,
-						   ((pub->_n_enab ==
-						     SUPPORT_11N) ? WL_11N_2x2 :
-						    WL_11N_3x3));
-		}
-
-		/* init per-band default rateset, depend on band->gmode */
-		brcms_default_rateset(wlc, &wlc->band->defrateset);
-
-		/* fill in hw_rateset */
-		brcms_c_rateset_filter(&wlc->band->defrateset,
-				   &wlc->band->hw_rateset, false,
-				   BRCMS_RATES_CCK_OFDM, BRCMS_RATE_MASK,
-				   (bool) (wlc->pub->_n_enab & SUPPORT_11N));
-	}
-
-	/*
-	 * update antenna config due to
-	 * wlc->stf->txant/txchain/ant_rx_ovr change
-	 */
-	brcms_c_stf_phy_txant_upd(wlc);
-
-	/* attach each modules */
-	err = brcms_c_attach_module(wlc);
-	if (err != 0)
-		goto fail;
-
-	if (!brcms_c_timers_init(wlc, unit)) {
-		wiphy_err(wl->wiphy, "wl%d: %s: init_timer failed\n", unit,
-			  __func__);
-		err = 32;
-		goto fail;
-	}
-
-	/* depend on rateset, gmode */
-	wlc->cmi = brcms_c_channel_mgr_attach(wlc);
-	if (!wlc->cmi) {
-		wiphy_err(wl->wiphy, "wl%d: %s: channel_mgr_attach failed"
-			  "\n", unit, __func__);
-		err = 33;
-		goto fail;
-	}
-
-	/* init default when all parameters are ready, i.e. ->rateset */
-	brcms_c_bss_default_init(wlc);
-
-	/*
-	 * Complete the wlc default state initializations..
-	 */
-
-	/* allocate our initial queue */
-	wlc->pkt_queue = brcms_c_txq_alloc(wlc);
-	if (wlc->pkt_queue == NULL) {
-		wiphy_err(wl->wiphy, "wl%d: %s: failed to malloc tx queue\n",
-			  unit, __func__);
-		err = 100;
-		goto fail;
-	}
-
-	wlc->bsscfg->wlc = wlc;
-
-	wlc->mimoft = FT_HT;
-	wlc->mimo_40txbw = AUTO;
-	wlc->ofdm_40txbw = AUTO;
-	wlc->cck_40txbw = AUTO;
-	brcms_c_update_mimo_band_bwcap(wlc, BRCMS_N_BW_20IN2G_40IN5G);
-
-	/* Set default values of SGI */
-	if (BRCMS_SGI_CAP_PHY(wlc)) {
-		brcms_c_ht_update_sgi_rx(wlc, (BRCMS_N_SGI_20 |
-					       BRCMS_N_SGI_40));
-	} else if (BRCMS_ISSSLPNPHY(wlc->band)) {
-		brcms_c_ht_update_sgi_rx(wlc, (BRCMS_N_SGI_20 |
-					       BRCMS_N_SGI_40));
-	} else {
-		brcms_c_ht_update_sgi_rx(wlc, 0);
-	}
-
-	/* initialize radio_mpc_disable according to wlc->mpc */
-	brcms_c_radio_mpc_upd(wlc);
-	brcms_b_antsel_set(wlc->hw, wlc->asi->antsel_avail);
-
-	if (perr)
-		*perr = 0;
-
-	return wlc;
-
- fail:
-	wiphy_err(wl->wiphy, "wl%d: %s: failed with err %d\n",
-		  unit, __func__, err);
-	if (wlc)
-		brcms_c_detach(wlc);
-
-	if (perr)
-		*perr = err;
-	return NULL;
-}
-
-static void brcms_c_timers_deinit(struct brcms_c_info *wlc)
-{
-	/* free timer state */
-	if (wlc->wdtimer) {
-		brcms_free_timer(wlc->wdtimer);
-		wlc->wdtimer = NULL;
-	}
-	if (wlc->radio_timer) {
-		brcms_free_timer(wlc->radio_timer);
-		wlc->radio_timer = NULL;
-	}
-}
-
-static void brcms_c_detach_module(struct brcms_c_info *wlc)
-{
-	if (wlc->asi) {
-		brcms_c_antsel_detach(wlc->asi);
-		wlc->asi = NULL;
-	}
-
-	if (wlc->ampdu) {
-		brcms_c_ampdu_detach(wlc->ampdu);
-		wlc->ampdu = NULL;
-	}
-
-	brcms_c_stf_detach(wlc);
-}
+	brcms_c_stf_detach(wlc);
+}
 
 /*
  * low level detach
@@ -5332,7 +5249,7 @@ uint brcms_c_detach(struct brcms_c_info *wlc)
 }
 
 /* update state that depends on the current value of "ap" */
-void brcms_c_ap_upd(struct brcms_c_info *wlc)
+static void brcms_c_ap_upd(struct brcms_c_info *wlc)
 {
 	/* STA-BSS; short capable */
 	wlc->PLCPHdr_override = BRCMS_PLCP_SHORT;
@@ -5341,73 +5258,6 @@ void brcms_c_ap_upd(struct brcms_c_info *wlc)
 	wlc->mpc = true;
 }
 
-/*
- * return true if Minimum Power Consumption should
- * be entered, false otherwise
- */
-bool brcms_c_is_non_delay_mpc(struct brcms_c_info *wlc)
-{
-	return false;
-}
-
-bool brcms_c_ismpc(struct brcms_c_info *wlc)
-{
-	return (wlc->mpc_delay_off == 0) && (brcms_c_is_non_delay_mpc(wlc));
-}
-
-void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
-{
-	bool mpc_radio, radio_state;
-
-	/*
-	 * Clear the WL_RADIO_MPC_DISABLE bit when mpc feature is disabled
-	 * in case the WL_RADIO_MPC_DISABLE bit was set. Stop the radio
-	 * monitor also when WL_RADIO_MPC_DISABLE is the only reason that
-	 * the radio is going down.
-	 */
-	if (!wlc->mpc) {
-		if (!wlc->pub->radio_disabled)
-			return;
-		mboolclr(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE);
-		brcms_c_radio_upd(wlc);
-		if (!wlc->pub->radio_disabled)
-			brcms_c_radio_monitor_stop(wlc);
-		return;
-	}
-
-	/*
-	 * sync ismpc logic with WL_RADIO_MPC_DISABLE bit in
-	 * wlc->pub->radio_disabled to go ON, always call radio_upd
-	 * synchronously to go OFF, postpone radio_upd to later when
-	 * context is safe(e.g. watchdog)
-	 */
-	radio_state =
-	    (mboolisset(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE) ? OFF :
-	     ON);
-	mpc_radio = (brcms_c_ismpc(wlc) == true) ? OFF : ON;
-
-	if (radio_state == ON && mpc_radio == OFF)
-		wlc->mpc_delay_off = wlc->mpc_dlycnt;
-	else if (radio_state == OFF && mpc_radio == ON) {
-		mboolclr(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE);
-		brcms_c_radio_upd(wlc);
-		if (wlc->mpc_offcnt < BRCMS_MPC_THRESHOLD)
-			wlc->mpc_dlycnt = BRCMS_MPC_MAX_DELAYCNT;
-		else
-			wlc->mpc_dlycnt = BRCMS_MPC_MIN_DELAYCNT;
-	}
-	/*
-	 * Below logic is meant to capture the transition from mpc off
-	 * to mpc on for reasons other than wlc->mpc_delay_off keeping
-	 * the mpc off. In that case reset wlc->mpc_delay_off to
-	 * wlc->mpc_dlycnt, so that we restart the countdown of mpc_delay_off
-	 */
-	if ((wlc->prev_non_delay_mpc == false) &&
-	    (brcms_c_is_non_delay_mpc(wlc) == true) && wlc->mpc_delay_off)
-		wlc->mpc_delay_off = wlc->mpc_dlycnt;
-
-	wlc->prev_non_delay_mpc = brcms_c_is_non_delay_mpc(wlc);
-}
 /* Initialize just the hardware when coming out of POR or S3/S5 system states */
 static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 {
@@ -6195,59 +6045,7 @@ void brcms_c_print_txstatus(struct tx_status *txs)
 #endif				/* defined(BCMDBG) */
 }
 
-void brcms_c_statsupd(struct brcms_c_info *wlc)
-{
-	int i;
-	struct macstat macstats;
-#ifdef BCMDBG
-	u16 delta;
-	u16 rxf0ovfl;
-	u16 txfunfl[NFIFO];
-#endif				/* BCMDBG */
-
-	/* if driver down, make no sense to update stats */
-	if (!wlc->pub->up)
-		return;
-
-#ifdef BCMDBG
-	/* save last rx fifo 0 overflow count */
-	rxf0ovfl = wlc->core->macstat_snapshot->rxf0ovfl;
-
-	/* save last tx fifo  underflow count */
-	for (i = 0; i < NFIFO; i++)
-		txfunfl[i] = wlc->core->macstat_snapshot->txfunfl[i];
-#endif				/* BCMDBG */
-
-	/* Read mac stats from contiguous shared memory */
-	brcms_b_copyfrom_objmem(wlc->hw, M_UCODE_MACSTAT, &macstats,
-				sizeof(struct macstat), OBJADDR_SHM_SEL);
-
-#ifdef BCMDBG
-	/* check for rx fifo 0 overflow */
-	delta = (u16) (wlc->core->macstat_snapshot->rxf0ovfl - rxf0ovfl);
-	if (delta)
-		wiphy_err(wlc->wiphy, "wl%d: %u rx fifo 0 overflows!\n",
-			  wlc->pub->unit, delta);
-
-	/* check for tx fifo underflows */
-	for (i = 0; i < NFIFO; i++) {
-		delta =
-		    (u16) (wlc->core->macstat_snapshot->txfunfl[i] -
-			      txfunfl[i]);
-		if (delta)
-			wiphy_err(wlc->wiphy, "wl%d: %u tx fifo %d underflows!"
-				  "\n", wlc->pub->unit, delta, i);
-	}
-#endif				/* BCMDBG */
-
-	/* merge counters from dma module */
-	for (i = 0; i < NFIFO; i++) {
-		if (wlc->hw->di[i])
-			dma_counterreset(wlc->hw->di[i]);
-	}
-}
-
-bool brcms_c_chipmatch(u16 vendor, u16 device)
+bool brcms_c_chipmatch(u16 vendor, u16 device)
 {
 	if (vendor != PCI_VENDOR_ID_BROADCOM) {
 		pr_err("chipmatch: unknown vendor id %04x\n", vendor);
@@ -6417,24 +6215,7 @@ u16 brcms_b_rate_shm_offset(struct brcms_hardware *wlc_hw, u8 rate)
 	return 2 * brcms_b_read_shm(wlc_hw, table_ptr + (index * 2));
 }
 
-/* Callback for device removed */
-
-/*
- * Attempts to queue a packet onto a multiple-precedence queue,
- * if necessary evicting a lower precedence packet from the queue.
- *
- * 'prec' is the precedence number that has already been mapped
- * from the packet priority.
- *
- * Returns true if packet consumed (queued), false if not.
- */
-static bool brcms_c_prec_enq(struct brcms_c_info *wlc, struct pktq *q,
-		      struct sk_buff *pkt, int prec)
-{
-	return brcms_c_prec_enq_head(wlc, q, pkt, prec, false);
-}
-
-bool
+static bool
 brcms_c_prec_enq_head(struct brcms_c_info *wlc, struct pktq *q,
 		      struct sk_buff *pkt, int prec, bool head)
 {
@@ -6481,6 +6262,21 @@ brcms_c_prec_enq_head(struct brcms_c_info *wlc, struct pktq *q,
 	return true;
 }
 
+/*
+ * Attempts to queue a packet onto a multiple-precedence queue,
+ * if necessary evicting a lower precedence packet from the queue.
+ *
+ * 'prec' is the precedence number that has already been mapped
+ * from the packet priority.
+ *
+ * Returns true if packet consumed (queued), false if not.
+ */
+static bool brcms_c_prec_enq(struct brcms_c_info *wlc, struct pktq *q,
+		      struct sk_buff *pkt, int prec)
+{
+	return brcms_c_prec_enq_head(wlc, q, pkt, prec, false);
+}
+
 void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
 		     struct sk_buff *sdu, uint prec)
 {
@@ -6647,6 +6443,43 @@ brcms_c_calc_frame_len(struct brcms_c_info *wlc, u32 ratespec,
 	return mac_len;
 }
 
+/*
+ * Return true if the specified rate is supported by the specified band.
+ * BRCM_BAND_AUTO indicates the current band.
+ */
+static bool brcms_c_valid_rate(struct brcms_c_info *wlc, u32 rspec, int band,
+		    bool verbose)
+{
+	struct brcms_c_rateset *hw_rateset;
+	uint i;
+
+	if ((band == BRCM_BAND_AUTO) || (band == wlc->band->bandtype))
+		hw_rateset = &wlc->band->hw_rateset;
+	else if (wlc->pub->_nbands > 1)
+		hw_rateset = &wlc->bandstate[OTHERBANDUNIT(wlc)]->hw_rateset;
+	else
+		/* other band specified and we are a single band device */
+		return false;
+
+	/* check if this is a mimo rate */
+	if (is_mcs_rate(rspec)) {
+		if ((rspec & RSPEC_RATE_MASK) >= MCS_TABLE_SIZE)
+			goto error;
+
+		return isset(hw_rateset->mcs, (rspec & RSPEC_RATE_MASK));
+	}
+
+	for (i = 0; i < hw_rateset->count; i++)
+		if (hw_rateset->rates[i] == rspec2rate(rspec))
+			return true;
+ error:
+	if (verbose)
+		wiphy_err(wlc->wiphy, "wl%d: valid_rate: rate spec 0x%x "
+			  "not in hw_rateset\n", wlc->pub->unit, rspec);
+
+	return false;
+}
+
 static u32
 mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 		       u32 int_val)
@@ -6764,84 +6597,291 @@ done:
 }
 
 /*
- * Add struct d11txh, struct cck_phy_hdr.
- *
- * 'p' data must start with 802.11 MAC header
- * 'p' must allow enough bytes of local headers to be "pushed" onto the packet
- *
- * headroom == D11_PHY_HDR_LEN + D11_TXH_LEN (D11_TXH_LEN is now 104 bytes)
- *
+ * Compute PLCP, but only requires actual rate and length of pkt.
+ * Rate is given in the driver standard multiple of 500 kbps.
+ * le is set for 11 Mbps rate if necessary.
+ * Broken out for PRQ.
  */
-static u16
-brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
-		     struct sk_buff *p, struct scb *scb, uint frag,
-		     uint nfrags, uint queue, uint next_frag_len)
-{
-	struct ieee80211_hdr *h;
-	struct d11txh *txh;
-	u8 *plcp, plcp_fallback[D11_PHY_HDR_LEN];
-	int len, phylen, rts_phylen;
-	u16 mch, phyctl, xfts, mainrates;
-	u16 seq = 0, mcl = 0, status = 0, frameid = 0;
-	u32 rspec[2] = { BRCM_RATE_1M, BRCM_RATE_1M };
-	u32 rts_rspec[2] = { BRCM_RATE_1M, BRCM_RATE_1M };
-	bool use_rts = false;
-	bool use_cts = false;
-	bool use_rifs = false;
-	bool short_preamble[2] = { false, false };
-	u8 preamble_type[2] = { BRCMS_LONG_PREAMBLE, BRCMS_LONG_PREAMBLE };
-	u8 rts_preamble_type[2] = { BRCMS_LONG_PREAMBLE, BRCMS_LONG_PREAMBLE };
-	u8 *rts_plcp, rts_plcp_fallback[D11_PHY_HDR_LEN];
-	struct ieee80211_rts *rts = NULL;
-	bool qos;
-	uint ac;
-	bool hwtkmic = false;
-	u16 mimo_ctlchbw = PHY_TXC1_BW_20MHZ;
-#define ANTCFG_NONE 0xFF
-	u8 antcfg = ANTCFG_NONE;
-	u8 fbantcfg = ANTCFG_NONE;
-	uint phyctl1_stf = 0;
-	u16 durid = 0;
-	struct ieee80211_tx_rate *txrate[2];
-	int k;
-	struct ieee80211_tx_info *tx_info;
-	bool is_mcs;
-	u16 mimo_txbw;
-	u8 mimo_preamble_type;
 
-	/* locate 802.11 MAC header */
-	h = (struct ieee80211_hdr *)(p->data);
-	qos = ieee80211_is_data_qos(h->frame_control);
+static void brcms_c_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
+			     uint length, u8 *plcp)
+{
+	u16 usec = 0;
+	u8 le = 0;
 
-	/* compute length of frame in bytes for use in PLCP computations */
-	len = brcmu_pkttotlen(p);
-	phylen = len + FCS_LEN;
+	switch (rate_500) {
+	case BRCM_RATE_1M:
+		usec = length << 3;
+		break;
+	case BRCM_RATE_2M:
+		usec = length << 2;
+		break;
+	case BRCM_RATE_5M5:
+		usec = (length << 4) / 11;
+		if ((length << 4) - (usec * 11) > 0)
+			usec++;
+		break;
+	case BRCM_RATE_11M:
+		usec = (length << 3) / 11;
+		if ((length << 3) - (usec * 11) > 0) {
+			usec++;
+			if ((usec * 11) - (length << 3) >= 8)
+				le = D11B_PLCP_SIGNAL_LE;
+		}
+		break;
 
-	/* Get tx_info */
-	tx_info = IEEE80211_SKB_CB(p);
+	default:
+		wiphy_err(wlc->wiphy,
+			  "brcms_c_cck_plcp_set: unsupported rate %d\n",
+			  rate_500);
+		rate_500 = BRCM_RATE_1M;
+		usec = length << 3;
+		break;
+	}
+	/* PLCP signal byte */
+	plcp[0] = rate_500 * 5;	/* r (500kbps) * 5 == r (100kbps) */
+	/* PLCP service byte */
+	plcp[1] = (u8) (le | D11B_PLCP_SIGNAL_LOCKED);
+	/* PLCP length u16, little endian */
+	plcp[2] = usec & 0xff;
+	plcp[3] = (usec >> 8) & 0xff;
+	/* PLCP CRC16 */
+	plcp[4] = 0;
+	plcp[5] = 0;
+}
 
-	/* add PLCP */
-	plcp = skb_push(p, D11_PHY_HDR_LEN);
+/* Rate: 802.11 rate code, length: PSDU length in octets */
+static void brcms_c_compute_mimo_plcp(u32 rspec, uint length, u8 *plcp)
+{
+	u8 mcs = (u8) (rspec & RSPEC_RATE_MASK);
+	plcp[0] = mcs;
+	if (rspec_is40mhz(rspec) || (mcs == 32))
+		plcp[0] |= MIMO_PLCP_40MHZ;
+	BRCMS_SET_MIMO_PLCP_LEN(plcp, length);
+	plcp[3] = rspec_mimoplcp3(rspec); /* rspec already holds this byte */
+	plcp[3] |= 0x7; /* set smoothing, not sounding ppdu & reserved */
+	plcp[4] = 0; /* number of extension spatial streams bit 0 & 1 */
+	plcp[5] = 0;
+}
 
-	/* add Broadcom tx descriptor header */
-	txh = (struct d11txh *) skb_push(p, D11_TXH_LEN);
-	memset(txh, 0, D11_TXH_LEN);
+/* Rate: 802.11 rate code, length: PSDU length in octets */
+static void
+brcms_c_compute_ofdm_plcp(u32 rspec, u32 length, u8 *plcp)
+{
+	u8 rate_signal;
+	u32 tmp = 0;
+	int rate = rspec2rate(rspec);
 
-	/* setup frameid */
-	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		/* non-AP STA should never use BCMC queue */
-		if (queue == TX_BCMC_FIFO) {
-			wiphy_err(wlc->wiphy, "wl%d: %s: ASSERT queue == "
-				  "TX_BCMC!\n", wlc->pub->unit, __func__);
-			frameid = bcmc_fid_generate(wlc, NULL, txh);
-		} else {
-			/* Increment the counter for first fragment */
-			if (tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
-				scb->seqnum[p->priority]++;
+	/*
+	 * encode rate per 802.11a-1999 sec 17.3.4.1, with lsb
+	 * transmitted first
+	 */
+	rate_signal = rate_info[rate] & BRCMS_RATE_MASK;
+	memset(plcp, 0, D11_PHY_HDR_LEN);
+	D11A_PHY_HDR_SRATE((struct ofdm_phy_hdr *) plcp, rate_signal);
 
-			/* extract fragment number from frame first */
-			seq = le16_to_cpu(h->seq_ctrl) & FRAGNUM_MASK;
-			seq |= (scb->seqnum[p->priority] << SEQNUM_SHIFT);
+	tmp = (length & 0xfff) << 5;
+	plcp[2] |= (tmp >> 16) & 0xff;
+	plcp[1] |= (tmp >> 8) & 0xff;
+	plcp[0] |= tmp & 0xff;
+}
+
+/* Rate: 802.11 rate code, length: PSDU length in octets */
+static void brcms_c_compute_cck_plcp(struct brcms_c_info *wlc, u32 rspec,
+				 uint length, u8 *plcp)
+{
+	int rate = rspec2rate(rspec);
+
+	brcms_c_cck_plcp_set(wlc, rate, length, plcp);
+}
+
+static void
+brcms_c_compute_plcp(struct brcms_c_info *wlc, u32 rspec,
+		     uint length, u8 *plcp)
+{
+	if (is_mcs_rate(rspec))
+		brcms_c_compute_mimo_plcp(rspec, length, plcp);
+	else if (is_ofdm_rate(rspec))
+		brcms_c_compute_ofdm_plcp(rspec, length, plcp);
+	else
+		brcms_c_compute_cck_plcp(wlc, rspec, length, plcp);
+}
+
+/* brcms_c_compute_rtscts_dur()
+ *
+ * Calculate the 802.11 MAC header DUR field for an RTS or CTS frame
+ * DUR for normal RTS/CTS w/ frame = 3 SIFS + 1 CTS + next frame time + 1 ACK
+ * DUR for CTS-TO-SELF w/ frame    = 2 SIFS         + next frame time + 1 ACK
+ *
+ * cts			cts-to-self or rts/cts
+ * rts_rate		rts or cts rate in unit of 500kbps
+ * rate			next MPDU rate in unit of 500kbps
+ * frame_len		next MPDU frame length in bytes
+ */
+u16
+brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
+			   u32 rts_rate,
+			   u32 frame_rate, u8 rts_preamble_type,
+			   u8 frame_preamble_type, uint frame_len, bool ba)
+{
+	u16 dur, sifs;
+
+	sifs = get_sifs(wlc->band);
+
+	if (!cts_only) {
+		/* RTS/CTS */
+		dur = 3 * sifs;
+		dur +=
+		    (u16) brcms_c_calc_cts_time(wlc, rts_rate,
+					       rts_preamble_type);
+	} else {
+		/* CTS-TO-SELF */
+		dur = 2 * sifs;
+	}
+
+	dur +=
+	    (u16) brcms_c_calc_frame_time(wlc, frame_rate, frame_preamble_type,
+					 frame_len);
+	if (ba)
+		dur +=
+		    (u16) brcms_c_calc_ba_time(wlc, frame_rate,
+					      BRCMS_SHORT_PREAMBLE);
+	else
+		dur +=
+		    (u16) brcms_c_calc_ack_time(wlc, frame_rate,
+					       frame_preamble_type);
+	return dur;
+}
+
+static u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
+{
+	u16 phyctl1 = 0;
+	u16 bw;
+
+	if (BRCMS_ISLCNPHY(wlc->band)) {
+		bw = PHY_TXC1_BW_20MHZ;
+	} else {
+		bw = rspec_get_bw(rspec);
+		/* 10Mhz is not supported yet */
+		if (bw < PHY_TXC1_BW_20MHZ) {
+			wiphy_err(wlc->wiphy, "phytxctl1_calc: bw %d is "
+				  "not supported yet, set to 20L\n", bw);
+			bw = PHY_TXC1_BW_20MHZ;
+		}
+	}
+
+	if (is_mcs_rate(rspec)) {
+		uint mcs = rspec & RSPEC_RATE_MASK;
+
+		/* bw, stf, coding-type is part of rspec_phytxbyte2 returns */
+		phyctl1 = rspec_phytxbyte2(rspec);
+		/* set the upper byte of phyctl1 */
+		phyctl1 |= (mcs_table[mcs].tx_phy_ctl3 << 8);
+	} else if (is_cck_rate(rspec) && !BRCMS_ISLCNPHY(wlc->band)
+		   && !BRCMS_ISSSLPNPHY(wlc->band)) {
+		/*
+		 * In CCK mode LPPHY overloads OFDM Modulation bits with CCK
+		 * Data Rate. Eventually MIMOPHY would also be converted to
+		 * this format
+		 */
+		/* 0 = 1Mbps; 1 = 2Mbps; 2 = 5.5Mbps; 3 = 11Mbps */
+		phyctl1 = (bw | (rspec_stf(rspec) << PHY_TXC1_MODE_SHIFT));
+	} else {		/* legacy OFDM/CCK */
+		s16 phycfg;
+		/* get the phyctl byte from rate phycfg table */
+		phycfg = brcms_c_rate_legacy_phyctl(rspec2rate(rspec));
+		if (phycfg == -1) {
+			wiphy_err(wlc->wiphy, "phytxctl1_calc: wrong "
+				  "legacy OFDM/CCK rate\n");
+			phycfg = 0;
+		}
+		/* set the upper byte of phyctl1 */
+		phyctl1 =
+		    (bw | (phycfg << 8) |
+		     (rspec_stf(rspec) << PHY_TXC1_MODE_SHIFT));
+	}
+	return phyctl1;
+}
+
+/*
+ * Add struct d11txh, struct cck_phy_hdr.
+ *
+ * 'p' data must start with 802.11 MAC header
+ * 'p' must allow enough bytes of local headers to be "pushed" onto the packet
+ *
+ * headroom == D11_PHY_HDR_LEN + D11_TXH_LEN (D11_TXH_LEN is now 104 bytes)
+ *
+ */
+static u16
+brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
+		     struct sk_buff *p, struct scb *scb, uint frag,
+		     uint nfrags, uint queue, uint next_frag_len)
+{
+	struct ieee80211_hdr *h;
+	struct d11txh *txh;
+	u8 *plcp, plcp_fallback[D11_PHY_HDR_LEN];
+	int len, phylen, rts_phylen;
+	u16 mch, phyctl, xfts, mainrates;
+	u16 seq = 0, mcl = 0, status = 0, frameid = 0;
+	u32 rspec[2] = { BRCM_RATE_1M, BRCM_RATE_1M };
+	u32 rts_rspec[2] = { BRCM_RATE_1M, BRCM_RATE_1M };
+	bool use_rts = false;
+	bool use_cts = false;
+	bool use_rifs = false;
+	bool short_preamble[2] = { false, false };
+	u8 preamble_type[2] = { BRCMS_LONG_PREAMBLE, BRCMS_LONG_PREAMBLE };
+	u8 rts_preamble_type[2] = { BRCMS_LONG_PREAMBLE, BRCMS_LONG_PREAMBLE };
+	u8 *rts_plcp, rts_plcp_fallback[D11_PHY_HDR_LEN];
+	struct ieee80211_rts *rts = NULL;
+	bool qos;
+	uint ac;
+	bool hwtkmic = false;
+	u16 mimo_ctlchbw = PHY_TXC1_BW_20MHZ;
+#define ANTCFG_NONE 0xFF
+	u8 antcfg = ANTCFG_NONE;
+	u8 fbantcfg = ANTCFG_NONE;
+	uint phyctl1_stf = 0;
+	u16 durid = 0;
+	struct ieee80211_tx_rate *txrate[2];
+	int k;
+	struct ieee80211_tx_info *tx_info;
+	bool is_mcs;
+	u16 mimo_txbw;
+	u8 mimo_preamble_type;
+
+	/* locate 802.11 MAC header */
+	h = (struct ieee80211_hdr *)(p->data);
+	qos = ieee80211_is_data_qos(h->frame_control);
+
+	/* compute length of frame in bytes for use in PLCP computations */
+	len = brcmu_pkttotlen(p);
+	phylen = len + FCS_LEN;
+
+	/* Get tx_info */
+	tx_info = IEEE80211_SKB_CB(p);
+
+	/* add PLCP */
+	plcp = skb_push(p, D11_PHY_HDR_LEN);
+
+	/* add Broadcom tx descriptor header */
+	txh = (struct d11txh *) skb_push(p, D11_TXH_LEN);
+	memset(txh, 0, D11_TXH_LEN);
+
+	/* setup frameid */
+	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
+		/* non-AP STA should never use BCMC queue */
+		if (queue == TX_BCMC_FIFO) {
+			wiphy_err(wlc->wiphy, "wl%d: %s: ASSERT queue == "
+				  "TX_BCMC!\n", wlc->pub->unit, __func__);
+			frameid = bcmc_fid_generate(wlc, NULL, txh);
+		} else {
+			/* Increment the counter for first fragment */
+			if (tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+				scb->seqnum[p->priority]++;
+
+			/* extract fragment number from frame first */
+			seq = le16_to_cpu(h->seq_ctrl) & FRAGNUM_MASK;
+			seq |= (scb->seqnum[p->priority] << SEQNUM_SHIFT);
 			h->seq_ctrl = cpu_to_le16(seq);
 
 			frameid = ((seq << TXFID_SEQ_SHIFT) & TXFID_SEQ_MASK) |
@@ -7518,237 +7558,30 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 		wiphy_err(wlc->wiphy, "txfifo: fatal, toss frames !!!\n");
 }
 
-/*
- * Compute PLCP, but only requires actual rate and length of pkt.
- * Rate is given in the driver standard multiple of 500 kbps.
- * le is set for 11 Mbps rate if necessary.
- * Broken out for PRQ.
- */
-
-static void brcms_c_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
-			     uint length, u8 *plcp)
+u32
+brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
+			   bool use_rspec, u16 mimo_ctlchbw)
 {
-	u16 usec = 0;
-	u8 le = 0;
+	u32 rts_rspec = 0;
 
-	switch (rate_500) {
-	case BRCM_RATE_1M:
-		usec = length << 3;
-		break;
-	case BRCM_RATE_2M:
-		usec = length << 2;
-		break;
-	case BRCM_RATE_5M5:
-		usec = (length << 4) / 11;
-		if ((length << 4) - (usec * 11) > 0)
-			usec++;
-		break;
-	case BRCM_RATE_11M:
-		usec = (length << 3) / 11;
-		if ((length << 3) - (usec * 11) > 0) {
-			usec++;
-			if ((usec * 11) - (length << 3) >= 8)
-				le = D11B_PLCP_SIGNAL_LE;
-		}
-		break;
-
-	default:
-		wiphy_err(wlc->wiphy,
-			  "brcms_c_cck_plcp_set: unsupported rate %d\n",
-			  rate_500);
-		rate_500 = BRCM_RATE_1M;
-		usec = length << 3;
-		break;
-	}
-	/* PLCP signal byte */
-	plcp[0] = rate_500 * 5;	/* r (500kbps) * 5 == r (100kbps) */
-	/* PLCP service byte */
-	plcp[1] = (u8) (le | D11B_PLCP_SIGNAL_LOCKED);
-	/* PLCP length u16, little endian */
-	plcp[2] = usec & 0xff;
-	plcp[3] = (usec >> 8) & 0xff;
-	/* PLCP CRC16 */
-	plcp[4] = 0;
-	plcp[5] = 0;
-}
-
-/* Rate: 802.11 rate code, length: PSDU length in octets */
-static void brcms_c_compute_mimo_plcp(u32 rspec, uint length, u8 *plcp)
-{
-	u8 mcs = (u8) (rspec & RSPEC_RATE_MASK);
-	plcp[0] = mcs;
-	if (rspec_is40mhz(rspec) || (mcs == 32))
-		plcp[0] |= MIMO_PLCP_40MHZ;
-	BRCMS_SET_MIMO_PLCP_LEN(plcp, length);
-	plcp[3] = rspec_mimoplcp3(rspec); /* rspec already holds this byte */
-	plcp[3] |= 0x7; /* set smoothing, not sounding ppdu & reserved */
-	plcp[4] = 0; /* number of extension spatial streams bit 0 & 1 */
-	plcp[5] = 0;
-}
-
-/* Rate: 802.11 rate code, length: PSDU length in octets */
-static void
-brcms_c_compute_ofdm_plcp(u32 rspec, u32 length, u8 *plcp)
-{
-	u8 rate_signal;
-	u32 tmp = 0;
-	int rate = rspec2rate(rspec);
-
-	/*
-	 * encode rate per 802.11a-1999 sec 17.3.4.1, with lsb
-	 * transmitted first
-	 */
-	rate_signal = rate_info[rate] & BRCMS_RATE_MASK;
-	memset(plcp, 0, D11_PHY_HDR_LEN);
-	D11A_PHY_HDR_SRATE((struct ofdm_phy_hdr *) plcp, rate_signal);
-
-	tmp = (length & 0xfff) << 5;
-	plcp[2] |= (tmp >> 16) & 0xff;
-	plcp[1] |= (tmp >> 8) & 0xff;
-	plcp[0] |= tmp & 0xff;
-}
-
-/* Rate: 802.11 rate code, length: PSDU length in octets */
-static void brcms_c_compute_cck_plcp(struct brcms_c_info *wlc, u32 rspec,
-				 uint length, u8 *plcp)
-{
-	int rate = rspec2rate(rspec);
-
-	brcms_c_cck_plcp_set(wlc, rate, length, plcp);
-}
-
-void
-brcms_c_compute_plcp(struct brcms_c_info *wlc, u32 rspec,
-		     uint length, u8 *plcp)
-{
-	if (is_mcs_rate(rspec))
-		brcms_c_compute_mimo_plcp(rspec, length, plcp);
-	else if (is_ofdm_rate(rspec))
-		brcms_c_compute_ofdm_plcp(rspec, length, plcp);
-	else
-		brcms_c_compute_cck_plcp(wlc, rspec, length, plcp);
-}
-
-/* brcms_c_compute_rtscts_dur()
- *
- * Calculate the 802.11 MAC header DUR field for an RTS or CTS frame
- * DUR for normal RTS/CTS w/ frame = 3 SIFS + 1 CTS + next frame time + 1 ACK
- * DUR for CTS-TO-SELF w/ frame    = 2 SIFS         + next frame time + 1 ACK
- *
- * cts			cts-to-self or rts/cts
- * rts_rate		rts or cts rate in unit of 500kbps
- * rate			next MPDU rate in unit of 500kbps
- * frame_len		next MPDU frame length in bytes
- */
-u16
-brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
-			   u32 rts_rate,
-			   u32 frame_rate, u8 rts_preamble_type,
-			   u8 frame_preamble_type, uint frame_len, bool ba)
-{
-	u16 dur, sifs;
-
-	sifs = get_sifs(wlc->band);
-
-	if (!cts_only) {
-		/* RTS/CTS */
-		dur = 3 * sifs;
-		dur +=
-		    (u16) brcms_c_calc_cts_time(wlc, rts_rate,
-					       rts_preamble_type);
-	} else {
-		/* CTS-TO-SELF */
-		dur = 2 * sifs;
-	}
-
-	dur +=
-	    (u16) brcms_c_calc_frame_time(wlc, frame_rate, frame_preamble_type,
-					 frame_len);
-	if (ba)
-		dur +=
-		    (u16) brcms_c_calc_ba_time(wlc, frame_rate,
-					      BRCMS_SHORT_PREAMBLE);
-	else
-		dur +=
-		    (u16) brcms_c_calc_ack_time(wlc, frame_rate,
-					       frame_preamble_type);
-	return dur;
-}
-
-u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
-{
-	u16 phyctl1 = 0;
-	u16 bw;
-
-	if (BRCMS_ISLCNPHY(wlc->band)) {
-		bw = PHY_TXC1_BW_20MHZ;
-	} else {
-		bw = rspec_get_bw(rspec);
-		/* 10Mhz is not supported yet */
-		if (bw < PHY_TXC1_BW_20MHZ) {
-			wiphy_err(wlc->wiphy, "phytxctl1_calc: bw %d is "
-				  "not supported yet, set to 20L\n", bw);
-			bw = PHY_TXC1_BW_20MHZ;
-		}
-	}
-
-	if (is_mcs_rate(rspec)) {
-		uint mcs = rspec & RSPEC_RATE_MASK;
-
-		/* bw, stf, coding-type is part of rspec_phytxbyte2 returns */
-		phyctl1 = rspec_phytxbyte2(rspec);
-		/* set the upper byte of phyctl1 */
-		phyctl1 |= (mcs_table[mcs].tx_phy_ctl3 << 8);
-	} else if (is_cck_rate(rspec) && !BRCMS_ISLCNPHY(wlc->band)
-		   && !BRCMS_ISSSLPNPHY(wlc->band)) {
-		/*
-		 * In CCK mode LPPHY overloads OFDM Modulation bits with CCK
-		 * Data Rate. Eventually MIMOPHY would also be converted to
-		 * this format
-		 */
-		/* 0 = 1Mbps; 1 = 2Mbps; 2 = 5.5Mbps; 3 = 11Mbps */
-		phyctl1 = (bw | (rspec_stf(rspec) << PHY_TXC1_MODE_SHIFT));
-	} else {		/* legacy OFDM/CCK */
-		s16 phycfg;
-		/* get the phyctl byte from rate phycfg table */
-		phycfg = brcms_c_rate_legacy_phyctl(rspec2rate(rspec));
-		if (phycfg == -1) {
-			wiphy_err(wlc->wiphy, "phytxctl1_calc: wrong "
-				  "legacy OFDM/CCK rate\n");
-			phycfg = 0;
-		}
-		/* set the upper byte of phyctl1 */
-		phyctl1 =
-		    (bw | (phycfg << 8) |
-		     (rspec_stf(rspec) << PHY_TXC1_MODE_SHIFT));
-	}
-	return phyctl1;
-}
-
-u32
-brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
-			   bool use_rspec, u16 mimo_ctlchbw)
-{
-	u32 rts_rspec = 0;
-
-	if (use_rspec)
-		/* use frame rate as rts rate */
-		rts_rspec = rspec;
-	else if (wlc->band->gmode && wlc->protection->_g && !is_cck_rate(rspec))
-		/* Use 11Mbps as the g protection RTS target rate and fallback.
-		 * Use the brcms_basic_rate() lookup to find the best basic rate
-		 * under the target in case 11 Mbps is not Basic.
-		 * 6 and 9 Mbps are not usually selected by rate selection, but
-		 * even if the OFDM rate we are protecting is 6 or 9 Mbps, 11
-		 * is more robust.
-		 */
-		rts_rspec = brcms_basic_rate(wlc, BRCM_RATE_11M);
-	else
-		/* calculate RTS rate and fallback rate based on the frame rate
-		 * RTS must be sent at a basic rate since it is a
-		 * control frame, sec 9.6 of 802.11 spec
-		 */
-		rts_rspec = brcms_basic_rate(wlc, rspec);
+	if (use_rspec)
+		/* use frame rate as rts rate */
+		rts_rspec = rspec;
+	else if (wlc->band->gmode && wlc->protection->_g && !is_cck_rate(rspec))
+		/* Use 11Mbps as the g protection RTS target rate and fallback.
+		 * Use the brcms_basic_rate() lookup to find the best basic rate
+		 * under the target in case 11 Mbps is not Basic.
+		 * 6 and 9 Mbps are not usually selected by rate selection, but
+		 * even if the OFDM rate we are protecting is 6 or 9 Mbps, 11
+		 * is more robust.
+		 */
+		rts_rspec = brcms_basic_rate(wlc, BRCM_RATE_11M);
+	else
+		/* calculate RTS rate and fallback rate based on the frame rate
+		 * RTS must be sent at a basic rate since it is a
+		 * control frame, sec 9.6 of 802.11 spec
+		 */
+		rts_rspec = brcms_basic_rate(wlc, rspec);
 
 	if (BRCMS_PHY_11N_CAP(wlc->band)) {
 		/* set rts txbw to correct side band */
@@ -7772,16 +7605,6 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 	return rts_rspec;
 }
 
-void brcms_c_tbtt(struct brcms_c_info *wlc)
-{
-	if (!wlc->bsscfg->BSS)
-		/*
-		 * DirFrmQ is now valid...defer setting until end
-		 * of ATIM window
-		 */
-		wlc->qvalid |= MCMD_DIRFRMQVAL;
-}
-
 void
 brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo, s8 txpktpend)
 {
@@ -7796,7 +7619,7 @@ brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo, s8 txpktpend)
 }
 
 /* Update beacon listen interval in shared memory */
-void brcms_c_bcn_li_upd(struct brcms_c_info *wlc)
+static void brcms_c_bcn_li_upd(struct brcms_c_info *wlc)
 {
 	/* wake up every DTIM is the default */
 	if (wlc->bcn_li_dtim == 1)
@@ -7993,93 +7816,33 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 	ieee80211_rx_irqsafe(wlc->pub->ieee_hw, p);
 }
 
-/* Process received frames */
-/*
- * Return true if more frames need to be processed. false otherwise.
- * Param 'bound' indicates max. # frames to process before break out.
+/* calculate frame duration for Mixed-mode L-SIG spoofing, return
+ * number of bytes goes in the length field
+ *
+ * Formula given by HT PHY Spec v 1.13
+ *   len = 3(nsyms + nstream + 3) - 3
  */
-void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
+u16
+brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
+		      uint mac_len)
 {
-	struct d11rxhdr *rxh;
-	struct ieee80211_hdr *h;
-	uint len;
-	bool is_amsdu;
-
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
-
-	/* frame starts with rxhdr */
-	rxh = (struct d11rxhdr *) (p->data);
+	uint nsyms, len = 0, kNdps;
 
-	/* strip off rxhdr */
-	skb_pull(p, BRCMS_HWRXOFF);
+	BCMMSG(wlc->wiphy, "wl%d: rate %d, len%d\n",
+		 wlc->pub->unit, rspec2rate(ratespec), mac_len);
 
-	/* MAC inserts 2 pad bytes for a4 headers or QoS or A-MSDU subframes */
-	if (rxh->RxStatus1 & RXS_PBPRES) {
-		if (p->len < 2) {
-			wiphy_err(wlc->wiphy, "wl%d: recv: rcvd runt of "
-				  "len %d\n", wlc->pub->unit, p->len);
-			goto toss;
-		}
-		skb_pull(p, 2);
-	}
+	if (is_mcs_rate(ratespec)) {
+		uint mcs = ratespec & RSPEC_RATE_MASK;
+		int tot_streams = (mcs_2_txstreams(mcs) + 1) +
+				  rspec_stc(ratespec);
 
-	h = (struct ieee80211_hdr *)(p->data + D11_PHY_HDR_LEN);
-	len = p->len;
-
-	if (rxh->RxStatus1 & RXS_FCSERR) {
-		if (wlc->pub->mac80211_state & MAC80211_PROMISC_BCNS) {
-			wiphy_err(wlc->wiphy, "FCSERR while scanning******* -"
-				  " tossing\n");
-			goto toss;
-		} else {
-			wiphy_err(wlc->wiphy, "RCSERR!!!\n");
-			goto toss;
-		}
-	}
-
-	/* check received pkt has at least frame control field */
-	if (len < D11_PHY_HDR_LEN + sizeof(h->frame_control))
-		goto toss;
-
-	/* not supporting A-MSDU */
-	is_amsdu = rxh->RxStatus2 & RXS_AMSDU_MASK;
-	if (is_amsdu)
-		goto toss;
-
-	brcms_c_recvctl(wlc, rxh, p);
-	return;
-
- toss:
-	brcmu_pkt_buf_free_skb(p);
-}
-
-/* calculate frame duration for Mixed-mode L-SIG spoofing, return
- * number of bytes goes in the length field
- *
- * Formula given by HT PHY Spec v 1.13
- *   len = 3(nsyms + nstream + 3) - 3
- */
-u16
-brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
-		      uint mac_len)
-{
-	uint nsyms, len = 0, kNdps;
-
-	BCMMSG(wlc->wiphy, "wl%d: rate %d, len%d\n",
-		 wlc->pub->unit, rspec2rate(ratespec), mac_len);
-
-	if (is_mcs_rate(ratespec)) {
-		uint mcs = ratespec & RSPEC_RATE_MASK;
-		int tot_streams = (mcs_2_txstreams(mcs) + 1) +
-				  rspec_stc(ratespec);
-
-		/*
-		 * the payload duration calculation matches that
-		 * of regular ofdm
-		 */
-		/* 1000Ndbps = kbps * 4 */
-		kNdps = mcs_2_rate(mcs, rspec_is40mhz(ratespec),
-				   rspec_issgi(ratespec)) * 4;
+		/*
+		 * the payload duration calculation matches that
+		 * of regular ofdm
+		 */
+		/* 1000Ndbps = kbps * 4 */
+		kNdps = mcs_2_rate(mcs, rspec_is40mhz(ratespec),
+				   rspec_issgi(ratespec)) * 4;
 
 		if (rspec_stc(ratespec) == 0)
 			nsyms =
@@ -8104,737 +7867,847 @@ brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
 	return (u16) len;
 }
 
-/*
- * calculate frame duration of a given rate and length, return
- * time in usec unit
- */
-uint
-brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
-			u8 preamble_type, uint mac_len)
+static void
+brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 {
-	uint nsyms, dur = 0, Ndps, kNdps;
-	uint rate = rspec2rate(ratespec);
+	const struct brcms_c_rateset *rs_dflt;
+	struct brcms_c_rateset rs;
+	u8 rate;
+	u16 entry_ptr;
+	u8 plcp[D11_PHY_HDR_LEN];
+	u16 dur, sifs;
+	uint i;
 
-	if (rate == 0) {
-		wiphy_err(wlc->wiphy, "wl%d: WAR: using rate of 1 mbps\n",
-			  wlc->pub->unit);
-		rate = BRCM_RATE_1M;
-	}
+	sifs = get_sifs(wlc->band);
 
-	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d, len%d\n",
-		 wlc->pub->unit, ratespec, preamble_type, mac_len);
+	rs_dflt = brcms_c_rateset_get_hwrs(wlc);
 
-	if (is_mcs_rate(ratespec)) {
-		uint mcs = ratespec & RSPEC_RATE_MASK;
-		int tot_streams = mcs_2_txstreams(mcs) + rspec_stc(ratespec);
+	brcms_c_rateset_copy(rs_dflt, &rs);
+	brcms_c_rateset_mcs_upd(&rs, wlc->stf->txstreams);
 
-		dur = PREN_PREAMBLE + (tot_streams * PREN_PREAMBLE_EXT);
-		if (preamble_type == BRCMS_MM_PREAMBLE)
-			dur += PREN_MM_EXT;
-		/* 1000Ndbps = kbps * 4 */
-		kNdps = mcs_2_rate(mcs, rspec_is40mhz(ratespec),
-				   rspec_issgi(ratespec)) * 4;
+	/*
+	 * walk the phy rate table and update MAC core SHM
+	 * basic rate table entries
+	 */
+	for (i = 0; i < rs.count; i++) {
+		rate = rs.rates[i] & BRCMS_RATE_MASK;
 
-		if (rspec_stc(ratespec) == 0)
-			nsyms =
-			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
-				  APHY_TAIL_NBITS) * 1000, kNdps);
-		else
-			/* STBC needs to have even number of symbols */
-			nsyms =
-			    2 *
-			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
-				  APHY_TAIL_NBITS) * 1000, 2 * kNdps);
+		entry_ptr = brcms_b_rate_shm_offset(wlc->hw, rate);
+
+		/* Calculate the Probe Response PLCP for the given rate */
+		brcms_c_compute_plcp(wlc, rate, frame_len, plcp);
 
-		dur += APHY_SYMBOL_TIME * nsyms;
-		if (wlc->band->bandtype == BRCM_BAND_2G)
-			dur += DOT11_OFDM_SIGNAL_EXTENSION;
-	} else if (is_ofdm_rate(rate)) {
-		dur = APHY_PREAMBLE_TIME;
-		dur += APHY_SIGNAL_TIME;
-		/* Ndbps = Mbps * 4 = rate(500Kbps) * 2 */
-		Ndps = rate * 2;
-		/* NSyms = CEILING((SERVICE + 8*NBytes + TAIL) / Ndbps) */
-		nsyms =
-		    CEIL((APHY_SERVICE_NBITS + 8 * mac_len + APHY_TAIL_NBITS),
-			 Ndps);
-		dur += APHY_SYMBOL_TIME * nsyms;
-		if (wlc->band->bandtype == BRCM_BAND_2G)
-			dur += DOT11_OFDM_SIGNAL_EXTENSION;
-	} else {
 		/*
-		 * calc # bits * 2 so factor of 2 in rate (1/2 mbps)
-		 * will divide out
+		 * Calculate the duration of the Probe Response
+		 * frame plus SIFS for the MAC
 		 */
-		mac_len = mac_len * 8 * 2;
-		/* calc ceiling of bits/rate = microseconds of air time */
-		dur = (mac_len + rate - 1) / rate;
-		if (preamble_type & BRCMS_SHORT_PREAMBLE)
-			dur += BPHY_PLCP_SHORT_TIME;
-		else
-			dur += BPHY_PLCP_TIME;
+		dur = (u16) brcms_c_calc_frame_time(wlc, rate,
+						BRCMS_LONG_PREAMBLE, frame_len);
+		dur += sifs;
+
+		/* Update the SHM Rate Table entry Probe Response values */
+		brcms_b_write_shm(wlc->hw, entry_ptr + M_RT_PRS_PLCP_POS,
+			      (u16) (plcp[0] + (plcp[1] << 8)));
+		brcms_b_write_shm(wlc->hw, entry_ptr + M_RT_PRS_PLCP_POS + 2,
+			      (u16) (plcp[2] + (plcp[3] << 8)));
+		brcms_b_write_shm(wlc->hw, entry_ptr + M_RT_PRS_DUR_POS, dur);
 	}
-	return dur;
 }
 
-/* derive wlc->band->basic_rate[] table from 'rateset' */
-void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
-			      struct brcms_c_rateset *rateset)
+/*	Max buffering needed for beacon template/prb resp template is 142 bytes.
+ *
+ *	PLCP header is 6 bytes.
+ *	802.11 A3 header is 24 bytes.
+ *	Max beacon frame body template length is 112 bytes.
+ *	Max probe resp frame body template length is 110 bytes.
+ *
+ *      *len on input contains the max length of the packet available.
+ *
+ *	The *len value is set to the number of bytes in buf used, and starts
+ *	with the PLCP and included up to, but not including, the 4 byte FCS.
+ */
+static void
+brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
+			 u32 bcn_rspec,
+			 struct brcms_bss_cfg *cfg, u16 *buf, int *len)
 {
-	u8 rate;
-	u8 mandatory;
-	u8 cck_basic = 0;
-	u8 ofdm_basic = 0;
-	u8 *br = wlc->band->basic_rate;
-	uint i;
-
-	/* incoming rates are in 500kbps units as in 802.11 Supported Rates */
-	memset(br, 0, BRCM_MAXRATE + 1);
+	static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
+	struct cck_phy_hdr *plcp;
+	struct ieee80211_mgmt *h;
+	int hdr_len, body_len;
 
-	/* For each basic rate in the rates list, make an entry in the
-	 * best basic lookup.
-	 */
-	for (i = 0; i < rateset->count; i++) {
-		/* only make an entry for a basic rate */
-		if (!(rateset->rates[i] & BRCMS_RATE_FLAG))
-			continue;
+	hdr_len = D11_PHY_HDR_LEN + DOT11_MAC_HDR_LEN;
 
-		/* mask off basic bit */
-		rate = (rateset->rates[i] & BRCMS_RATE_MASK);
+	/* calc buffer size provided for frame body */
+	body_len = *len - hdr_len;
+	/* return actual size */
+	*len = hdr_len + body_len;
 
-		if (rate > BRCM_MAXRATE) {
-			wiphy_err(wlc->wiphy, "brcms_c_rate_lookup_init: "
-				  "invalid rate 0x%X in rate set\n",
-				  rateset->rates[i]);
-			continue;
-		}
+	/* format PHY and MAC headers */
+	memset((char *)buf, 0, hdr_len);
 
-		br[rate] = rate;
-	}
+	plcp = (struct cck_phy_hdr *) buf;
 
-	/* The rate lookup table now has non-zero entries for each
-	 * basic rate, equal to the basic rate: br[basicN] = basicN
-	 *
-	 * To look up the best basic rate corresponding to any
-	 * particular rate, code can use the basic_rate table
-	 * like this
-	 *
-	 * basic_rate = wlc->band->basic_rate[tx_rate]
-	 *
-	 * Make sure there is a best basic rate entry for
-	 * every rate by walking up the table from low rates
-	 * to high, filling in holes in the lookup table
+	/*
+	 * PLCP for Probe Response frames are filled in from
+	 * core's rate table
 	 */
+	if (type == IEEE80211_STYPE_BEACON)
+		/* fill in PLCP */
+		brcms_c_compute_plcp(wlc, bcn_rspec,
+				 (DOT11_MAC_HDR_LEN + body_len + FCS_LEN),
+				 (u8 *) plcp);
 
-	for (i = 0; i < wlc->band->hw_rateset.count; i++) {
-		rate = wlc->band->hw_rateset.rates[i];
+	/* "Regular" and 16 MBSS but not for 4 MBSS */
+	/* Update the phytxctl for the beacon based on the rspec */
+	brcms_c_beacon_phytxctl_txant_upd(wlc, bcn_rspec);
 
-		if (br[rate] != 0) {
-			/* This rate is a basic rate.
-			 * Keep track of the best basic rate so far by
-			 * modulation type.
-			 */
-			if (is_ofdm_rate(rate))
-				ofdm_basic = rate;
-			else
-				cck_basic = rate;
+	h = (struct ieee80211_mgmt *)&plcp[1];
 
-			continue;
-		}
+	/* fill in 802.11 header */
+	h->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT | type);
 
-		/* This rate is not a basic rate so figure out the
-		 * best basic rate less than this rate and fill in
-		 * the hole in the table
-		 */
+	/* DUR is 0 for multicast bcn, or filled in by MAC for prb resp */
+	/* A1 filled in by MAC for prb resp, broadcast for bcn */
+	if (type == IEEE80211_STYPE_BEACON)
+		memcpy(&h->da, &ether_bcast, ETH_ALEN);
+	memcpy(&h->sa, &cfg->cur_etheraddr, ETH_ALEN);
+	memcpy(&h->bssid, &cfg->BSSID, ETH_ALEN);
 
-		br[rate] = is_ofdm_rate(rate) ? ofdm_basic : cck_basic;
+	/* SEQ filled in by MAC */
+}
 
-		if (br[rate] != 0)
-			continue;
+int brcms_c_get_header_len(void)
+{
+	return TXOFF;
+}
 
-		if (is_ofdm_rate(rate)) {
-			/*
-			 * In 11g and 11a, the OFDM mandatory rates
-			 * are 6, 12, and 24 Mbps
-			 */
-			if (rate >= BRCM_RATE_24M)
-				mandatory = BRCM_RATE_24M;
-			else if (rate >= BRCM_RATE_12M)
-				mandatory = BRCM_RATE_12M;
-			else
-				mandatory = BRCM_RATE_6M;
-		} else {
-			/* In 11b, all CCK rates are mandatory 1 - 11 Mbps */
-			mandatory = rate;
-		}
+/*
+ * Update all beacons for the system.
+ */
+void brcms_c_update_beacon(struct brcms_c_info *wlc)
+{
+	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
 
-		br[rate] = mandatory;
-	}
+	if (bsscfg->up && !bsscfg->BSS)
+		/* Clear the soft intmask */
+		wlc->defmacintmask &= ~MI_BCNTPL;
 }
 
-static void brcms_c_write_rate_shm(struct brcms_c_info *wlc, u8 rate,
-				   u8 basic_rate)
+/* Write ssid into shared memory */
+static void
+brcms_c_shm_ssid_upd(struct brcms_c_info *wlc, struct brcms_bss_cfg *cfg)
 {
-	u8 phy_rate, index;
-	u8 basic_phy_rate, basic_index;
-	u16 dir_table, basic_table;
-	u16 basic_ptr;
+	u8 *ssidptr = cfg->SSID;
+	u16 base = M_SSID;
+	u8 ssidbuf[IEEE80211_MAX_SSID_LEN];
 
-	/* Shared memory address for the table we are reading */
-	dir_table = is_ofdm_rate(basic_rate) ? M_RT_DIRMAP_A : M_RT_DIRMAP_B;
+	/* padding the ssid with zero and copy it into shm */
+	memset(ssidbuf, 0, IEEE80211_MAX_SSID_LEN);
+	memcpy(ssidbuf, ssidptr, cfg->SSID_len);
 
-	/* Shared memory address for the table we are writing */
-	basic_table = is_ofdm_rate(rate) ? M_RT_BBRSMAP_A : M_RT_BBRSMAP_B;
+	brcms_c_copyto_shm(wlc, base, ssidbuf, IEEE80211_MAX_SSID_LEN);
+	brcms_b_write_shm(wlc->hw, M_SSIDLEN, (u16) cfg->SSID_len);
+}
+
+static void
+brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
+			      struct brcms_bss_cfg *cfg,
+			      bool suspend)
+{
+	u16 prb_resp[BCN_TMPL_LEN / 2];
+	int len = BCN_TMPL_LEN;
 
 	/*
-	 * for a given rate, the LS-nibble of the PLCP SIGNAL field is
-	 * the index into the rate table.
+	 * write the probe response to hardware, or save in
+	 * the config structure
 	 */
-	phy_rate = rate_info[rate] & BRCMS_RATE_MASK;
-	basic_phy_rate = rate_info[basic_rate] & BRCMS_RATE_MASK;
-	index = phy_rate & 0xf;
-	basic_index = basic_phy_rate & 0xf;
 
-	/* Find the SHM pointer to the ACK rate entry by looking in the
-	 * Direct-map Table
-	 */
-	basic_ptr = brcms_b_read_shm(wlc->hw, (dir_table + basic_index * 2));
+	/* create the probe response template */
+	brcms_c_bcn_prb_template(wlc, IEEE80211_STYPE_PROBE_RESP, 0,
+				 cfg, prb_resp, &len);
 
-	/* Update the SHM BSS-basic-rate-set mapping table with the pointer
-	 * to the correct basic rate for the given incoming rate
+	if (suspend)
+		brcms_c_suspend_mac_and_wait(wlc);
+
+	/* write the probe response into the template region */
+	brcms_b_write_template_ram(wlc->hw, T_PRS_TPL_BASE,
+				    (len + 3) & ~3, prb_resp);
+
+	/* write the length of the probe response frame (+PLCP/-FCS) */
+	brcms_b_write_shm(wlc->hw, M_PRB_RESP_FRM_LEN, (u16) len);
+
+	/* write the SSID and SSID length */
+	brcms_c_shm_ssid_upd(wlc, cfg);
+
+	/*
+	 * Write PLCP headers and durations for probe response frames
+	 * at all rates. Use the actual frame length covered by the
+	 * PLCP header for the call to brcms_c_mod_prb_rsp_rate_table()
+	 * by subtracting the PLCP len and adding the FCS.
 	 */
-	brcms_b_write_shm(wlc->hw, (basic_table + index * 2), basic_ptr);
+	len += (-D11_PHY_HDR_LEN + FCS_LEN);
+	brcms_c_mod_prb_rsp_rate_table(wlc, (u16) len);
+
+	if (suspend)
+		brcms_c_enable_mac(wlc);
 }
 
-static const struct brcms_c_rateset *
-brcms_c_rateset_get_hwrs(struct brcms_c_info *wlc)
+void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
 {
-	const struct brcms_c_rateset *rs_dflt;
-
-	if (BRCMS_PHY_11N_CAP(wlc->band)) {
-		if (wlc->band->bandtype == BRCM_BAND_5G)
-			rs_dflt = &ofdm_mimo_rates;
-		else
-			rs_dflt = &cck_ofdm_mimo_rates;
-	} else if (wlc->band->gmode)
-		rs_dflt = &cck_ofdm_rates;
-	else
-		rs_dflt = &cck_rates;
+	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
 
-	return rs_dflt;
+	/* update AP or IBSS probe responses */
+	if (bsscfg->up && !bsscfg->BSS)
+		brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
 }
 
-void brcms_c_set_ratetable(struct brcms_c_info *wlc)
+/* prepares pdu for transmission. returns BCM error codes */
+int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu, uint *fifop)
 {
-	const struct brcms_c_rateset *rs_dflt;
-	struct brcms_c_rateset rs;
-	u8 rate, basic_rate;
-	uint i;
+	uint fifo;
+	struct d11txh *txh;
+	struct ieee80211_hdr *h;
+	struct scb *scb;
 
-	rs_dflt = brcms_c_rateset_get_hwrs(wlc);
+	txh = (struct d11txh *) (pdu->data);
+	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
 
-	brcms_c_rateset_copy(rs_dflt, &rs);
-	brcms_c_rateset_mcs_upd(&rs, wlc->stf->txstreams);
+	/* get the pkt queue info. This was put at brcms_c_sendctl or
+	 * brcms_c_send for PDU */
+	fifo = le16_to_cpu(txh->TxFrameID) & TXFID_QUEUE_MASK;
 
-	/* walk the phy rate table and update SHM basic rate lookup table */
-	for (i = 0; i < rs.count; i++) {
-		rate = rs.rates[i] & BRCMS_RATE_MASK;
+	scb = NULL;
 
-		/* for a given rate brcms_basic_rate returns the rate at
-		 * which a response ACK/CTS should be sent.
-		 */
-		basic_rate = brcms_basic_rate(wlc, rate);
-		if (basic_rate == 0)
-			/* This should only happen if we are using a
-			 * restricted rateset.
-			 */
-			basic_rate = rs.rates[0] & BRCMS_RATE_MASK;
+	*fifop = fifo;
 
-		brcms_c_write_rate_shm(wlc, rate, basic_rate);
+	/* return if insufficient dma resources */
+	if (*wlc->core->txavail[fifo] < MAX_DMA_SEGS) {
+		/* Mark precedences related to this FIFO, unsendable */
+		/* A fifo is full. Clear precedences related to that FIFO */
+		wlc->tx_prec_map &= ~(wlc->fifo2prec_map[fifo]);
+		return -EBUSY;
 	}
+	return 0;
 }
 
-/*
- * Return true if the specified rate is supported by the specified band.
- * BRCM_BAND_AUTO indicates the current band.
- */
-bool brcms_c_valid_rate(struct brcms_c_info *wlc, u32 rspec, int band,
-		    bool verbose)
+int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
+			   uint *blocks)
 {
-	struct brcms_c_rateset *hw_rateset;
-	uint i;
+	if (fifo >= NFIFO)
+		return -EINVAL;
 
-	if ((band == BRCM_BAND_AUTO) || (band == wlc->band->bandtype))
-		hw_rateset = &wlc->band->hw_rateset;
-	else if (wlc->pub->_nbands > 1)
-		hw_rateset = &wlc->bandstate[OTHERBANDUNIT(wlc)]->hw_rateset;
-	else
-		/* other band specified and we are a single band device */
-		return false;
+	*blocks = wlc_hw->xmtfifo_sz[fifo];
 
-	/* check if this is a mimo rate */
-	if (is_mcs_rate(rspec)) {
-		if ((rspec & RSPEC_RATE_MASK) >= MCS_TABLE_SIZE)
-			goto error;
+	return 0;
+}
 
-		return isset(hw_rateset->mcs, (rspec & RSPEC_RATE_MASK));
-	}
+void
+brcms_c_set_addrmatch(struct brcms_c_info *wlc, int match_reg_offset,
+		  const u8 *addr)
+{
+	brcms_b_set_addrmatch(wlc->hw, match_reg_offset, addr);
+	if (match_reg_offset == RCM_BSSID_OFFSET)
+		memcpy(wlc->bsscfg->BSSID, addr, ETH_ALEN);
+}
 
-	for (i = 0; i < hw_rateset->count; i++)
-		if (hw_rateset->rates[i] == rspec2rate(rspec))
-			return true;
- error:
-	if (verbose)
-		wiphy_err(wlc->wiphy, "wl%d: valid_rate: rate spec 0x%x "
-			  "not in hw_rateset\n", wlc->pub->unit, rspec);
+/*
+ * Flag 'scan in progress' to withhold dynamic phy calibration
+ */
+void brcms_c_scan_start(struct brcms_c_info *wlc)
+{
+	wlc_phy_hold_upd(wlc->band->pi, PHY_HOLD_FOR_SCAN, true);
+}
 
-	return false;
+void brcms_c_scan_stop(struct brcms_c_info *wlc)
+{
+	wlc_phy_hold_upd(wlc->band->pi, PHY_HOLD_FOR_SCAN, false);
 }
 
-void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
+void brcms_c_associate_upd(struct brcms_c_info *wlc, bool state)
 {
-	const struct brcms_c_rateset *rs_dflt;
-	struct brcms_c_rateset rs;
-	u8 rate;
-	u16 entry_ptr;
-	u8 plcp[D11_PHY_HDR_LEN];
-	u16 dur, sifs;
-	uint i;
+	wlc->pub->associated = state;
+	wlc->bsscfg->associated = state;
+}
 
-	sifs = get_sifs(wlc->band);
+/*
+ * When a remote STA/AP is removed by Mac80211, or when it can no longer accept
+ * AMPDU traffic, packets pending in hardware have to be invalidated so that
+ * when later on hardware releases them, they can be handled appropriately.
+ */
+void brcms_c_inval_dma_pkts(struct brcms_hardware *hw,
+			       struct ieee80211_sta *sta,
+			       void (*dma_callback_fn))
+{
+	struct dma_pub *dmah;
+	int i;
+	for (i = 0; i < NFIFO; i++) {
+		dmah = hw->di[i];
+		if (dmah != NULL)
+			dma_walk_packets(dmah, dma_callback_fn, sta);
+	}
+}
 
-	rs_dflt = brcms_c_rateset_get_hwrs(wlc);
+int brcms_c_get_curband(struct brcms_c_info *wlc)
+{
+	return wlc->band->bandunit;
+}
 
-	brcms_c_rateset_copy(rs_dflt, &rs);
-	brcms_c_rateset_mcs_upd(&rs, wlc->stf->txstreams);
+void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc, bool drop)
+{
+	/* flush packet queue when requested */
+	if (drop)
+		brcmu_pktq_flush(&wlc->pkt_queue->q, false, NULL, NULL);
 
-	/*
-	 * walk the phy rate table and update MAC core SHM
-	 * basic rate table entries
-	 */
-	for (i = 0; i < rs.count; i++) {
-		rate = rs.rates[i] & BRCMS_RATE_MASK;
+	/* wait for queue and DMA fifos to run dry */
+	while (!pktq_empty(&wlc->pkt_queue->q) || brcms_txpktpendtot(wlc) > 0)
+		brcms_msleep(wlc->wl, 1);
+}
 
-		entry_ptr = brcms_b_rate_shm_offset(wlc->hw, rate);
+void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc, u8 interval)
+{
+	wlc->bcn_li_bcn = interval;
+	if (wlc->pub->up)
+		brcms_c_bcn_li_upd(wlc);
+}
 
-		/* Calculate the Probe Response PLCP for the given rate */
-		brcms_c_compute_plcp(wlc, rate, frame_len, plcp);
+int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr)
+{
+	uint qdbm;
 
-		/*
-		 * Calculate the duration of the Probe Response
-		 * frame plus SIFS for the MAC
-		 */
-		dur = (u16) brcms_c_calc_frame_time(wlc, rate,
-						BRCMS_LONG_PREAMBLE, frame_len);
-		dur += sifs;
+	/* Remove override bit and clip to max qdbm value */
+	qdbm = min_t(uint, txpwr * BRCMS_TXPWR_DB_FACTOR, 0xff);
+	return wlc_phy_txpower_set(wlc->band->pi, qdbm, false);
+}
 
-		/* Update the SHM Rate Table entry Probe Response values */
-		brcms_b_write_shm(wlc->hw, entry_ptr + M_RT_PRS_PLCP_POS,
-			      (u16) (plcp[0] + (plcp[1] << 8)));
-		brcms_b_write_shm(wlc->hw, entry_ptr + M_RT_PRS_PLCP_POS + 2,
-			      (u16) (plcp[2] + (plcp[3] << 8)));
-		brcms_b_write_shm(wlc->hw, entry_ptr + M_RT_PRS_DUR_POS, dur);
-	}
+int brcms_c_get_tx_power(struct brcms_c_info *wlc)
+{
+	uint qdbm;
+	bool override;
+
+	wlc_phy_txpower_get(wlc->band->pi, &qdbm, &override);
+
+	/* Return qdbm units */
+	return (int)(qdbm / BRCMS_TXPWR_DB_FACTOR);
 }
 
-/*	Max buffering needed for beacon template/prb resp template is 142 bytes.
- *
- *	PLCP header is 6 bytes.
- *	802.11 A3 header is 24 bytes.
- *	Max beacon frame body template length is 112 bytes.
- *	Max probe resp frame body template length is 110 bytes.
- *
- *      *len on input contains the max length of the packet available.
- *
- *	The *len value is set to the number of bytes in buf used, and starts
- *	with the PLCP and included up to, but not including, the 4 byte FCS.
- */
-static void
-brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
-			 u32 bcn_rspec,
-			 struct brcms_bss_cfg *cfg, u16 *buf, int *len)
+void brcms_c_set_radio_mpc(struct brcms_c_info *wlc, bool mpc)
 {
-	static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
-	struct cck_phy_hdr *plcp;
-	struct ieee80211_mgmt *h;
-	int hdr_len, body_len;
+	wlc->mpc = mpc;
+	brcms_c_radio_mpc_upd(wlc);
+}
 
-	hdr_len = D11_PHY_HDR_LEN + DOT11_MAC_HDR_LEN;
+/* Process received frames */
+/*
+ * Return true if more frames need to be processed. false otherwise.
+ * Param 'bound' indicates max. # frames to process before break out.
+ */
+static void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
+{
+	struct d11rxhdr *rxh;
+	struct ieee80211_hdr *h;
+	uint len;
+	bool is_amsdu;
 
-	/* calc buffer size provided for frame body */
-	body_len = *len - hdr_len;
-	/* return actual size */
-	*len = hdr_len + body_len;
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
-	/* format PHY and MAC headers */
-	memset((char *)buf, 0, hdr_len);
+	/* frame starts with rxhdr */
+	rxh = (struct d11rxhdr *) (p->data);
 
-	plcp = (struct cck_phy_hdr *) buf;
+	/* strip off rxhdr */
+	skb_pull(p, BRCMS_HWRXOFF);
 
-	/*
-	 * PLCP for Probe Response frames are filled in from
-	 * core's rate table
-	 */
-	if (type == IEEE80211_STYPE_BEACON)
-		/* fill in PLCP */
-		brcms_c_compute_plcp(wlc, bcn_rspec,
-				 (DOT11_MAC_HDR_LEN + body_len + FCS_LEN),
-				 (u8 *) plcp);
+	/* MAC inserts 2 pad bytes for a4 headers or QoS or A-MSDU subframes */
+	if (rxh->RxStatus1 & RXS_PBPRES) {
+		if (p->len < 2) {
+			wiphy_err(wlc->wiphy, "wl%d: recv: rcvd runt of "
+				  "len %d\n", wlc->pub->unit, p->len);
+			goto toss;
+		}
+		skb_pull(p, 2);
+	}
 
-	/* "Regular" and 16 MBSS but not for 4 MBSS */
-	/* Update the phytxctl for the beacon based on the rspec */
-	brcms_c_beacon_phytxctl_txant_upd(wlc, bcn_rspec);
+	h = (struct ieee80211_hdr *)(p->data + D11_PHY_HDR_LEN);
+	len = p->len;
 
-	h = (struct ieee80211_mgmt *)&plcp[1];
+	if (rxh->RxStatus1 & RXS_FCSERR) {
+		if (wlc->pub->mac80211_state & MAC80211_PROMISC_BCNS) {
+			wiphy_err(wlc->wiphy, "FCSERR while scanning******* -"
+				  " tossing\n");
+			goto toss;
+		} else {
+			wiphy_err(wlc->wiphy, "RCSERR!!!\n");
+			goto toss;
+		}
+	}
 
-	/* fill in 802.11 header */
-	h->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT | type);
+	/* check received pkt has at least frame control field */
+	if (len < D11_PHY_HDR_LEN + sizeof(h->frame_control))
+		goto toss;
 
-	/* DUR is 0 for multicast bcn, or filled in by MAC for prb resp */
-	/* A1 filled in by MAC for prb resp, broadcast for bcn */
-	if (type == IEEE80211_STYPE_BEACON)
-		memcpy(&h->da, &ether_bcast, ETH_ALEN);
-	memcpy(&h->sa, &cfg->cur_etheraddr, ETH_ALEN);
-	memcpy(&h->bssid, &cfg->BSSID, ETH_ALEN);
+	/* not supporting A-MSDU */
+	is_amsdu = rxh->RxStatus2 & RXS_AMSDU_MASK;
+	if (is_amsdu)
+		goto toss;
 
-	/* SEQ filled in by MAC */
-}
+	brcms_c_recvctl(wlc, rxh, p);
+	return;
 
-int brcms_c_get_header_len(void)
-{
-	return TXOFF;
+ toss:
+	brcmu_pkt_buf_free_skb(p);
 }
 
+/* Process received frames */
 /*
- * Update all beacons for the system.
+ * Return true if more frames need to be processed. false otherwise.
+ * Param 'bound' indicates max. # frames to process before break out.
  */
-void brcms_c_update_beacon(struct brcms_c_info *wlc)
+static bool
+brcms_b_recv(struct brcms_hardware *wlc_hw, uint fifo, bool bound)
 {
-	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
+	struct sk_buff *p;
+	struct sk_buff *head = NULL;
+	struct sk_buff *tail = NULL;
+	uint n = 0;
+	uint bound_limit = bound ? RXBND : -1;
 
-	if (bsscfg->up && !bsscfg->BSS)
-		/* Clear the soft intmask */
-		wlc->defmacintmask &= ~MI_BCNTPL;
-}
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+	/* gather received frames */
+	while ((p = dma_rx(wlc_hw->di[fifo]))) {
 
-/* Write ssid into shared memory */
-void brcms_c_shm_ssid_upd(struct brcms_c_info *wlc, struct brcms_bss_cfg *cfg)
-{
-	u8 *ssidptr = cfg->SSID;
-	u16 base = M_SSID;
-	u8 ssidbuf[IEEE80211_MAX_SSID_LEN];
+		if (!tail)
+			head = tail = p;
+		else {
+			tail->prev = p;
+			tail = p;
+		}
 
-	/* padding the ssid with zero and copy it into shm */
-	memset(ssidbuf, 0, IEEE80211_MAX_SSID_LEN);
-	memcpy(ssidbuf, ssidptr, cfg->SSID_len);
+		/* !give others some time to run! */
+		if (++n >= bound_limit)
+			break;
+	}
 
-	brcms_c_copyto_shm(wlc, base, ssidbuf, IEEE80211_MAX_SSID_LEN);
-	brcms_b_write_shm(wlc->hw, M_SSIDLEN, (u16) cfg->SSID_len);
+	/* post more rbufs */
+	dma_rxfill(wlc_hw->di[fifo]);
+
+	/* process each frame */
+	while ((p = head) != NULL) {
+		struct d11rxhdr_le *rxh_le;
+		struct d11rxhdr *rxh;
+		head = head->prev;
+		p->prev = NULL;
+
+		rxh_le = (struct d11rxhdr_le *)p->data;
+		rxh = (struct d11rxhdr *)p->data;
+
+		/* fixup rx header endianness */
+		rxh->RxFrameSize = le16_to_cpu(rxh_le->RxFrameSize);
+		rxh->PhyRxStatus_0 = le16_to_cpu(rxh_le->PhyRxStatus_0);
+		rxh->PhyRxStatus_1 = le16_to_cpu(rxh_le->PhyRxStatus_1);
+		rxh->PhyRxStatus_2 = le16_to_cpu(rxh_le->PhyRxStatus_2);
+		rxh->PhyRxStatus_3 = le16_to_cpu(rxh_le->PhyRxStatus_3);
+		rxh->PhyRxStatus_4 = le16_to_cpu(rxh_le->PhyRxStatus_4);
+		rxh->PhyRxStatus_5 = le16_to_cpu(rxh_le->PhyRxStatus_5);
+		rxh->RxStatus1 = le16_to_cpu(rxh_le->RxStatus1);
+		rxh->RxStatus2 = le16_to_cpu(rxh_le->RxStatus2);
+		rxh->RxTSFTime = le16_to_cpu(rxh_le->RxTSFTime);
+		rxh->RxChan = le16_to_cpu(rxh_le->RxChan);
+
+		brcms_c_recv(wlc_hw->wlc, p);
+	}
+
+	return n >= bound_limit;
 }
 
-void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
+/* second-level interrupt processing
+ *   Return true if another dpc needs to be re-scheduled. false otherwise.
+ *   Param 'bounded' indicates if applicable loops should be bounded.
+ */
+bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 {
-	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
+	u32 macintstatus;
+	struct brcms_hardware *wlc_hw = wlc->hw;
+	struct d11regs __iomem *regs = wlc_hw->regs;
+	struct wiphy *wiphy = wlc->wiphy;
 
-	/* update AP or IBSS probe responses */
-	if (bsscfg->up && !bsscfg->BSS)
-		brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
+	if (brcms_deviceremoved(wlc)) {
+		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
+			  __func__);
+		brcms_down(wlc->wl);
+		return false;
+	}
+
+	/* grab and clear the saved software intstatus bits */
+	macintstatus = wlc->macintstatus;
+	wlc->macintstatus = 0;
+
+	BCMMSG(wlc->wiphy, "wl%d: macintstatus 0x%x\n",
+	       wlc_hw->unit, macintstatus);
+
+	WARN_ON(macintstatus & MI_PRQ); /* PRQ Interrupt in non-MBSS */
+
+	/* tx status */
+	if (macintstatus & MI_TFS) {
+		bool fatal;
+		if (brcms_b_txstatus(wlc->hw, bounded, &fatal))
+			wlc->macintstatus |= MI_TFS;
+		if (fatal) {
+			wiphy_err(wiphy, "MI_TFS: fatal\n");
+			goto fatal;
+		}
+	}
+
+	if (macintstatus & (MI_TBTT | MI_DTIM_TBTT))
+		brcms_c_tbtt(wlc);
+
+	/* ATIM window end */
+	if (macintstatus & MI_ATIMWINEND) {
+		BCMMSG(wlc->wiphy, "end of ATIM window\n");
+		OR_REG(&regs->maccommand, wlc->qvalid);
+		wlc->qvalid = 0;
+	}
+
+	/*
+	 * received data or control frame, MI_DMAINT is
+	 * indication of RX_FIFO interrupt
+	 */
+	if (macintstatus & MI_DMAINT)
+		if (brcms_b_recv(wlc_hw, RX_FIFO, bounded))
+			wlc->macintstatus |= MI_DMAINT;
+
+	/* noise sample collected */
+	if (macintstatus & MI_BG_NOISE)
+		wlc_phy_noise_sample_intr(wlc_hw->band->pi);
+
+	if (macintstatus & MI_GP0) {
+		wiphy_err(wiphy, "wl%d: PSM microcode watchdog fired at %d "
+			"(seconds). Resetting.\n", wlc_hw->unit, wlc_hw->now);
+
+		printk_once("%s : PSM Watchdog, chipid 0x%x, chiprev 0x%x\n",
+					__func__, wlc_hw->sih->chip,
+					wlc_hw->sih->chiprev);
+		/* big hammer */
+		brcms_init(wlc->wl);
+	}
+
+	/* gptimer timeout */
+	if (macintstatus & MI_TO)
+		W_REG(&regs->gptimer, 0);
+
+	if (macintstatus & MI_RFDISABLE) {
+		BCMMSG(wlc->wiphy, "wl%d: BMAC Detected a change on the"
+		       " RF Disable Input\n", wlc_hw->unit);
+		brcms_rfkill_set_hw_state(wlc->wl);
+	}
+
+	/* send any enq'd tx packets. Just makes sure to jump start tx */
+	if (!pktq_empty(&wlc->pkt_queue->q))
+		brcms_c_send_q(wlc);
+
+	/* it isn't done and needs to be resched if macintstatus is non-zero */
+	return wlc->macintstatus != 0;
+
+ fatal:
+	brcms_init(wlc->wl);
+	return wlc->macintstatus != 0;
 }
 
-void
-brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
-			      struct brcms_bss_cfg *cfg,
-			      bool suspend)
+void brcms_c_init(struct brcms_c_info *wlc)
 {
-	u16 prb_resp[BCN_TMPL_LEN / 2];
-	int len = BCN_TMPL_LEN;
+	struct d11regs __iomem *regs;
+	u16 chanspec;
+	bool mute = false;
+
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
+
+	regs = wlc->regs;
 
 	/*
-	 * write the probe response to hardware, or save in
-	 * the config structure
+	 * This will happen if a big-hammer was executed. In
+	 * that case, we want to go back to the channel that
+	 * we were on and not new channel
 	 */
+	if (wlc->pub->associated)
+		chanspec = wlc->home_chanspec;
+	else
+		chanspec = brcms_c_init_chanspec(wlc);
 
-	/* create the probe response template */
-	brcms_c_bcn_prb_template(wlc, IEEE80211_STYPE_PROBE_RESP, 0,
-				 cfg, prb_resp, &len);
+	brcms_b_init(wlc->hw, chanspec, mute);
 
-	if (suspend)
-		brcms_c_suspend_mac_and_wait(wlc);
+	/* update beacon listen interval */
+	brcms_c_bcn_li_upd(wlc);
 
-	/* write the probe response into the template region */
-	brcms_b_write_template_ram(wlc->hw, T_PRS_TPL_BASE,
-				    (len + 3) & ~3, prb_resp);
+	/* write ethernet address to core */
+	brcms_c_set_mac(wlc->bsscfg);
+	brcms_c_set_bssid(wlc->bsscfg);
 
-	/* write the length of the probe response frame (+PLCP/-FCS) */
-	brcms_b_write_shm(wlc->hw, M_PRB_RESP_FRM_LEN, (u16) len);
+	/* Update tsf_cfprep if associated and up */
+	if (wlc->pub->associated && wlc->bsscfg->up) {
+		u32 bi;
 
-	/* write the SSID and SSID length */
-	brcms_c_shm_ssid_upd(wlc, cfg);
+		/* get beacon period and convert to uS */
+		bi = wlc->bsscfg->current_bss->beacon_period << 10;
+		/*
+		 * update since init path would reset
+		 * to default value
+		 */
+		W_REG(&regs->tsf_cfprep,
+		      (bi << CFPREP_CBI_SHIFT));
+
+		/* Update maccontrol PM related bits */
+		brcms_c_set_ps_ctrl(wlc);
+	}
+
+	brcms_c_bandinit_ordered(wlc, chanspec);
+
+	/* init probe response timeout */
+	brcms_b_write_shm(wlc->hw, M_PRS_MAXTIME, wlc->prb_resp_timeout);
+
+	/* init max burst txop (framebursting) */
+	brcms_b_write_shm(wlc->hw, M_MBURST_TXOP,
+		      (wlc->
+		       _rifs ? (EDCF_AC_VO_TXOP_AP << 5) : MAXFRAMEBURST_TXOP));
+
+	/* initialize maximum allowed duty cycle */
+	brcms_c_duty_cycle_set(wlc, wlc->tx_duty_cycle_ofdm, true, true);
+	brcms_c_duty_cycle_set(wlc, wlc->tx_duty_cycle_cck, false, true);
 
 	/*
-	 * Write PLCP headers and durations for probe response frames
-	 * at all rates. Use the actual frame length covered by the
-	 * PLCP header for the call to brcms_c_mod_prb_rsp_rate_table()
-	 * by subtracting the PLCP len and adding the FCS.
+	 * Update some shared memory locations related to
+	 * max AMPDU size allowed to received
 	 */
-	len += (-D11_PHY_HDR_LEN + FCS_LEN);
-	brcms_c_mod_prb_rsp_rate_table(wlc, (u16) len);
+	brcms_c_ampdu_shm_upd(wlc->ampdu);
 
-	if (suspend)
-		brcms_c_enable_mac(wlc);
-}
+	/* band-specific inits */
+	brcms_c_bsinit(wlc);
 
-/* prepares pdu for transmission. returns BCM error codes */
-int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu, uint *fifop)
-{
-	uint fifo;
-	struct d11txh *txh;
-	struct ieee80211_hdr *h;
-	struct scb *scb;
+	/* Enable EDCF mode (while the MAC is suspended) */
+	OR_REG(&regs->ifs_ctl, IFS_USEEDCF);
+	brcms_c_edcf_setparams(wlc, false);
 
-	txh = (struct d11txh *) (pdu->data);
-	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
+	/* Init precedence maps for empty FIFOs */
+	brcms_c_tx_prec_map_init(wlc);
 
-	/* get the pkt queue info. This was put at brcms_c_sendctl or
-	 * brcms_c_send for PDU */
-	fifo = le16_to_cpu(txh->TxFrameID) & TXFID_QUEUE_MASK;
+	/* read the ucode version if we have not yet done so */
+	if (wlc->ucode_rev == 0) {
+		wlc->ucode_rev =
+		    brcms_b_read_shm(wlc->hw, M_BOM_REV_MAJOR) << NBITS(u16);
+		wlc->ucode_rev |= brcms_b_read_shm(wlc->hw, M_BOM_REV_MINOR);
+	}
 
-	scb = NULL;
+	/* ..now really unleash hell (allow the MAC out of suspend) */
+	brcms_c_enable_mac(wlc);
 
-	*fifop = fifo;
+	/* clear tx flow control */
+	brcms_c_txflowcontrol_reset(wlc);
 
-	/* return if insufficient dma resources */
-	if (*wlc->core->txavail[fifo] < MAX_DMA_SEGS) {
-		/* Mark precedences related to this FIFO, unsendable */
-		/* A fifo is full. Clear precedences related to that FIFO */
-		wlc->tx_prec_map &= ~(wlc->fifo2prec_map[fifo]);
-		return -EBUSY;
-	}
-	return 0;
-}
+	/* enable the RF Disable Delay timer */
+	W_REG(&wlc->regs->rfdisabledly, RFDISABLE_DEFAULT);
 
-void brcms_default_rateset(struct brcms_c_info *wlc, struct brcms_c_rateset *rs)
-{
-	brcms_c_rateset_default(rs, NULL, wlc->band->phytype,
-		wlc->band->bandtype, false, BRCMS_RATE_MASK_FULL,
-		(bool) (wlc->pub->_n_enab & SUPPORT_11N),
-		brcms_chspec_bw(wlc->default_bss->chanspec),
-		wlc->stf->txstreams);
-}
+	/* initialize mpc delay */
+	wlc->mpc_delay_off = wlc->mpc_dlycnt = BRCMS_MPC_MIN_DELAYCNT;
 
-/* Copy a buffer to shared memory.
- * SHM 'offset' needs to be an even address and
- * Buffer length 'len' must be an even number of bytes
- */
-void brcms_c_copyto_shm(struct brcms_c_info *wlc, uint offset, const void *buf,
-			int len)
-{
-	brcms_b_copyto_objmem(wlc->hw, offset, buf, len, OBJADDR_SHM_SEL);
+	/*
+	 * Initialize WME parameters; if they haven't been set by some other
+	 * mechanism (IOVar, etc) then read them from the hardware.
+	 */
+	if (GFIELD(wlc->wme_retries[0], EDCF_SHORT) == 0) {
+		/* Uninitialized; read from HW */
+		int ac;
+
+		for (ac = 0; ac < AC_COUNT; ac++)
+			wlc->wme_retries[ac] =
+			    brcms_b_read_shm(wlc->hw, M_AC_TXLMT_ADDR(ac));
+	}
 }
 
-int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
-			   uint *blocks)
+/*
+ * The common driver entry routine. Error codes should be unique
+ */
+struct brcms_c_info *
+brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
+	       bool piomode, void __iomem *regsva, struct pci_dev *btparam,
+	       uint *perr)
 {
-	if (fifo >= NFIFO)
-		return -EINVAL;
+	struct brcms_c_info *wlc;
+	uint err = 0;
+	uint i, j;
+	struct brcms_pub *pub;
 
-	*blocks = wlc_hw->xmtfifo_sz[fifo];
+	/* allocate struct brcms_c_info state and its substructures */
+	wlc = (struct brcms_c_info *) brcms_c_attach_malloc(unit, &err, device);
+	if (wlc == NULL)
+		goto fail;
+	wlc->wiphy = wl->wiphy;
+	pub = wlc->pub;
 
-	return 0;
-}
+#if defined(BCMDBG)
+	wlc_info_dbg = wlc;
+#endif
 
-void
-brcms_c_set_addrmatch(struct brcms_c_info *wlc, int match_reg_offset,
-		  const u8 *addr)
-{
-	brcms_b_set_addrmatch(wlc->hw, match_reg_offset, addr);
-	if (match_reg_offset == RCM_BSSID_OFFSET)
-		memcpy(wlc->bsscfg->BSSID, addr, ETH_ALEN);
-}
+	wlc->band = wlc->bandstate[0];
+	wlc->core = wlc->corestate;
+	wlc->wl = wl;
+	pub->unit = unit;
+	pub->_piomode = piomode;
+	wlc->bandinit_pending = false;
 
-/* check for the particular priority flow control bit being set */
-bool
-brcms_c_txflowcontrol_prio_isset(struct brcms_c_info *wlc,
-				 struct brcms_txq_info *q,
-				 int prio)
-{
-	uint prio_mask;
+	/* populate struct brcms_c_info with default values  */
+	brcms_c_info_init(wlc, unit);
 
-	if (prio == ALLPRIO)
-		prio_mask = TXQ_STOP_FOR_PRIOFC_MASK;
-	else
-		prio_mask = NBITVAL(prio);
+	/* update sta/ap related parameters */
+	brcms_c_ap_upd(wlc);
 
-	return (q->stopped & prio_mask) == prio_mask;
-}
+	/*
+	 * low level attach steps(all hw accesses go
+	 * inside, no more in rest of the attach)
+	 */
+	err = brcms_b_attach(wlc, vendor, device, unit, piomode, regsva,
+			     btparam);
+	if (err)
+		goto fail;
 
-/* propagate the flow control to all interfaces using the given tx queue */
-void brcms_c_txflowcontrol(struct brcms_c_info *wlc,
-			   struct brcms_txq_info *qi,
-			   bool on, int prio)
-{
-	uint prio_bits;
-	uint cur_bits;
+	brcms_c_protection_upd(wlc, BRCMS_PROT_N_PAM_OVR, OFF);
 
-	BCMMSG(wlc->wiphy, "flow control kicks in\n");
+	pub->phy_11ncapable = BRCMS_PHY_11N_CAP(wlc->band);
 
-	if (prio == ALLPRIO)
-		prio_bits = TXQ_STOP_FOR_PRIOFC_MASK;
-	else
-		prio_bits = NBITVAL(prio);
+	/* disable allowed duty cycle */
+	wlc->tx_duty_cycle_ofdm = 0;
+	wlc->tx_duty_cycle_cck = 0;
 
-	cur_bits = qi->stopped & prio_bits;
+	brcms_c_stf_phy_chain_calc(wlc);
 
-	/* Check for the case of no change and return early
-	 * Otherwise update the bit and continue
-	 */
-	if (on) {
-		if (cur_bits == prio_bits)
-			return;
+	/* txchain 1: txant 0, txchain 2: txant 1 */
+	if (BRCMS_ISNPHY(wlc->band) && (wlc->stf->txstreams == 1))
+		wlc->stf->txant = wlc->stf->hw_txchain - 1;
 
-		mboolset(qi->stopped, prio_bits);
-	} else {
-		if (cur_bits == 0)
-			return;
+	/* push to BMAC driver */
+	wlc_phy_stf_chain_init(wlc->band->pi, wlc->stf->hw_txchain,
+			       wlc->stf->hw_rxchain);
 
-		mboolclr(qi->stopped, prio_bits);
-	}
+	/* pull up some info resulting from the low attach */
+	for (i = 0; i < NFIFO; i++)
+		wlc->core->txavail[i] = wlc->hw->txavail[i];
 
-	/* If there is a flow control override we will not change the external
-	 * flow control state.
-	 */
-	if (qi->stopped & ~TXQ_STOP_FOR_PRIOFC_MASK)
-		return;
+	memcpy(&wlc->perm_etheraddr, &wlc->hw->etheraddr, ETH_ALEN);
+	memcpy(&pub->cur_etheraddr, &wlc->hw->etheraddr, ETH_ALEN);
 
-	brcms_c_txflowcontrol_signal(wlc, qi, on, prio);
-}
+	for (j = 0; j < wlc->pub->_nbands; j++) {
+		wlc->band = wlc->bandstate[j];
 
-void
-brcms_c_txflowcontrol_override(struct brcms_c_info *wlc,
-			       struct brcms_txq_info *qi,
-			       bool on, uint override)
-{
-	uint prev_override;
+		if (!brcms_c_attach_stf_ant_init(wlc)) {
+			err = 24;
+			goto fail;
+		}
 
-	prev_override = (qi->stopped & ~TXQ_STOP_FOR_PRIOFC_MASK);
+		/* default contention windows size limits */
+		wlc->band->CWmin = APHY_CWMIN;
+		wlc->band->CWmax = PHY_CWMAX;
 
-	/* Update the flow control bits and do an early return if there is
-	 * no change in the external flow control state.
-	 */
-	if (on) {
-		mboolset(qi->stopped, override);
-		/* if there was a previous override bit on, then setting this
-		 * makes no difference.
-		 */
-		if (prev_override)
-			return;
+		/* init gmode value */
+		if (wlc->band->bandtype == BRCM_BAND_2G) {
+			wlc->band->gmode = GMODE_AUTO;
+			brcms_c_protection_upd(wlc, BRCMS_PROT_G_USER,
+					   wlc->band->gmode);
+		}
 
-		brcms_c_txflowcontrol_signal(wlc, qi, ON, ALLPRIO);
-	} else {
-		mboolclr(qi->stopped, override);
-		/* clearing an override bit will only make a difference for
-		 * flow control if it was the only bit set. For any other
-		 * override setting, just return
-		 */
-		if (prev_override != override)
-			return;
+		/* init _n_enab supported mode */
+		if (BRCMS_PHY_11N_CAP(wlc->band)) {
+			pub->_n_enab = SUPPORT_11N;
+			brcms_c_protection_upd(wlc, BRCMS_PROT_N_USER,
+						   ((pub->_n_enab ==
+						     SUPPORT_11N) ? WL_11N_2x2 :
+						    WL_11N_3x3));
+		}
 
-		if (qi->stopped == 0) {
-			brcms_c_txflowcontrol_signal(wlc, qi, OFF, ALLPRIO);
-		} else {
-			int prio;
+		/* init per-band default rateset, depend on band->gmode */
+		brcms_default_rateset(wlc, &wlc->band->defrateset);
 
-			for (prio = MAXPRIO; prio >= 0; prio--) {
-				if (!mboolisset(qi->stopped, NBITVAL(prio)))
-					brcms_c_txflowcontrol_signal(
-						wlc, qi, OFF, prio);
-			}
-		}
+		/* fill in hw_rateset */
+		brcms_c_rateset_filter(&wlc->band->defrateset,
+				   &wlc->band->hw_rateset, false,
+				   BRCMS_RATES_CCK_OFDM, BRCMS_RATE_MASK,
+				   (bool) (wlc->pub->_n_enab & SUPPORT_11N));
 	}
-}
 
-/*
- * Flag 'scan in progress' to withhold dynamic phy calibration
- */
-void brcms_c_scan_start(struct brcms_c_info *wlc)
-{
-	wlc_phy_hold_upd(wlc->band->pi, PHY_HOLD_FOR_SCAN, true);
-}
+	/*
+	 * update antenna config due to
+	 * wlc->stf->txant/txchain/ant_rx_ovr change
+	 */
+	brcms_c_stf_phy_txant_upd(wlc);
 
-void brcms_c_scan_stop(struct brcms_c_info *wlc)
-{
-	wlc_phy_hold_upd(wlc->band->pi, PHY_HOLD_FOR_SCAN, false);
-}
+	/* attach each modules */
+	err = brcms_c_attach_module(wlc);
+	if (err != 0)
+		goto fail;
 
-void brcms_c_associate_upd(struct brcms_c_info *wlc, bool state)
-{
-	wlc->pub->associated = state;
-	wlc->bsscfg->associated = state;
-}
+	if (!brcms_c_timers_init(wlc, unit)) {
+		wiphy_err(wl->wiphy, "wl%d: %s: init_timer failed\n", unit,
+			  __func__);
+		err = 32;
+		goto fail;
+	}
 
-/*
- * When a remote STA/AP is removed by Mac80211, or when it can no longer accept
- * AMPDU traffic, packets pending in hardware have to be invalidated so that
- * when later on hardware releases them, they can be handled appropriately.
- */
-void brcms_c_inval_dma_pkts(struct brcms_hardware *hw,
-			       struct ieee80211_sta *sta,
-			       void (*dma_callback_fn))
-{
-	struct dma_pub *dmah;
-	int i;
-	for (i = 0; i < NFIFO; i++) {
-		dmah = hw->di[i];
-		if (dmah != NULL)
-			dma_walk_packets(dmah, dma_callback_fn, sta);
+	/* depend on rateset, gmode */
+	wlc->cmi = brcms_c_channel_mgr_attach(wlc);
+	if (!wlc->cmi) {
+		wiphy_err(wl->wiphy, "wl%d: %s: channel_mgr_attach failed"
+			  "\n", unit, __func__);
+		err = 33;
+		goto fail;
 	}
-}
 
-int brcms_c_get_curband(struct brcms_c_info *wlc)
-{
-	return wlc->band->bandunit;
-}
+	/* init default when all parameters are ready, i.e. ->rateset */
+	brcms_c_bss_default_init(wlc);
 
-void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc, bool drop)
-{
-	/* flush packet queue when requested */
-	if (drop)
-		brcmu_pktq_flush(&wlc->pkt_queue->q, false, NULL, NULL);
+	/*
+	 * Complete the wlc default state initializations..
+	 */
 
-	/* wait for queue and DMA fifos to run dry */
-	while (!pktq_empty(&wlc->pkt_queue->q) || brcms_txpktpendtot(wlc) > 0)
-		brcms_msleep(wlc->wl, 1);
-}
+	/* allocate our initial queue */
+	wlc->pkt_queue = brcms_c_txq_alloc(wlc);
+	if (wlc->pkt_queue == NULL) {
+		wiphy_err(wl->wiphy, "wl%d: %s: failed to malloc tx queue\n",
+			  unit, __func__);
+		err = 100;
+		goto fail;
+	}
 
-void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc, u8 interval)
-{
-	wlc->bcn_li_bcn = interval;
-	if (wlc->pub->up)
-		brcms_c_bcn_li_upd(wlc);
-}
+	wlc->bsscfg->wlc = wlc;
 
-int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr)
-{
-	uint qdbm;
+	wlc->mimoft = FT_HT;
+	wlc->mimo_40txbw = AUTO;
+	wlc->ofdm_40txbw = AUTO;
+	wlc->cck_40txbw = AUTO;
+	brcms_c_update_mimo_band_bwcap(wlc, BRCMS_N_BW_20IN2G_40IN5G);
 
-	/* Remove override bit and clip to max qdbm value */
-	qdbm = min_t(uint, txpwr * BRCMS_TXPWR_DB_FACTOR, 0xff);
-	return wlc_phy_txpower_set(wlc->band->pi, qdbm, false);
-}
+	/* Set default values of SGI */
+	if (BRCMS_SGI_CAP_PHY(wlc)) {
+		brcms_c_ht_update_sgi_rx(wlc, (BRCMS_N_SGI_20 |
+					       BRCMS_N_SGI_40));
+	} else if (BRCMS_ISSSLPNPHY(wlc->band)) {
+		brcms_c_ht_update_sgi_rx(wlc, (BRCMS_N_SGI_20 |
+					       BRCMS_N_SGI_40));
+	} else {
+		brcms_c_ht_update_sgi_rx(wlc, 0);
+	}
 
-int brcms_c_get_tx_power(struct brcms_c_info *wlc)
-{
-	uint qdbm;
-	bool override;
+	/* initialize radio_mpc_disable according to wlc->mpc */
+	brcms_c_radio_mpc_upd(wlc);
+	brcms_b_antsel_set(wlc->hw, wlc->asi->antsel_avail);
 
-	wlc_phy_txpower_get(wlc->band->pi, &qdbm, &override);
+	if (perr)
+		*perr = 0;
 
-	/* Return qdbm units */
-	return (int)(qdbm / BRCMS_TXPWR_DB_FACTOR);
-}
+	return wlc;
 
-void brcms_c_set_radio_mpc(struct brcms_c_info *wlc, bool mpc)
-{
-	wlc->mpc = mpc;
-	brcms_c_radio_mpc_upd(wlc);
+ fail:
+	wiphy_err(wl->wiphy, "wl%d: %s: failed with err %d\n",
+		  unit, __func__, err);
+	if (wlc)
+		brcms_c_detach(wlc);
+
+	if (perr)
+		*perr = err;
+	return NULL;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index 7a2554f..c0e0fcf 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -653,9 +653,6 @@ struct brcms_bss_cfg {
 	struct brcms_bss_info *current_bss;
 };
 
-extern void brcms_c_fatal_error(struct brcms_c_info *wlc);
-extern void brcms_b_rpc_watchdog(struct brcms_c_info *wlc);
-extern void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p);
 extern void brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo,
 			   struct sk_buff *p,
 			   bool commit, s8 txpktpend);
@@ -663,47 +660,22 @@ extern void brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo,
 				    s8 txpktpend);
 extern void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
 			    struct sk_buff *sdu, uint prec);
-extern void brcms_c_info_init(struct brcms_c_info *wlc, int unit);
 extern void brcms_c_print_txstatus(struct tx_status *txs);
 extern int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 		   uint *blocks);
 
 #if defined(BCMDBG)
-extern void brcms_c_print_rxh(struct d11rxhdr *rxh);
 extern void brcms_c_print_txdesc(struct d11txh *txh);
 #else
 #define brcms_c_print_txdesc(a)
 #endif
 
-extern void brcms_c_setxband(struct brcms_hardware *wlc_hw, uint bandunit);
-extern void brcms_c_coredisable(struct brcms_hardware *wlc_hw);
-
-extern bool brcms_c_valid_rate(struct brcms_c_info *wlc, u32 rate,
-			       int band, bool verbose);
-extern void brcms_c_ap_upd(struct brcms_c_info *wlc);
-
-/* helper functions */
-extern void brcms_c_shm_ssid_upd(struct brcms_c_info *wlc,
-				 struct brcms_bss_cfg *cfg);
 extern int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config);
-
 extern void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc,
 					   bool promisc);
-extern void brcms_c_mac_bcn_promisc(struct brcms_c_info *wlc);
-extern void brcms_c_mac_promisc(struct brcms_c_info *wlc);
-extern void brcms_c_txflowcontrol(struct brcms_c_info *wlc,
-				  struct brcms_txq_info *qi,
-				  bool on, int prio);
-extern void brcms_c_txflowcontrol_override(struct brcms_c_info *wlc,
-				       struct brcms_txq_info *qi,
-				       bool on, uint override);
-extern bool brcms_c_txflowcontrol_prio_isset(struct brcms_c_info *wlc,
-					     struct brcms_txq_info *qi,
-					     int prio);
 extern void brcms_c_send_q(struct brcms_c_info *wlc);
 extern int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu,
 			    uint *fifo);
-
 extern u16 brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
 				uint mac_len);
 extern u32 brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc,
@@ -715,82 +687,26 @@ extern u16 brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
 				      u8 rts_preamble_type,
 				      u8 frame_preamble_type, uint frame_len,
 				      bool ba);
-
-extern void brcms_c_tbtt(struct brcms_c_info *wlc);
 extern void brcms_c_inval_dma_pkts(struct brcms_hardware *hw,
 			       struct ieee80211_sta *sta,
 			       void (*dma_callback_fn));
-
-/* Shared memory access */
-extern void brcms_c_copyto_shm(struct brcms_c_info *wlc, uint offset,
-			       const void *buf, int len);
-
 extern void brcms_c_update_beacon(struct brcms_c_info *wlc);
-
 extern void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend);
-extern void brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
-					  struct brcms_bss_cfg *cfg,
-					  bool suspend);
-extern bool brcms_c_ismpc(struct brcms_c_info *wlc);
-extern bool brcms_c_is_non_delay_mpc(struct brcms_c_info *wlc);
-extern void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc);
-extern bool brcms_c_prec_enq_head(struct brcms_c_info *wlc, struct pktq *q,
-			      struct sk_buff *pkt, int prec, bool head);
-extern u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec);
-extern void brcms_c_compute_plcp(struct brcms_c_info *wlc, u32 rate,
-				 uint length, u8 *plcp);
-extern uint brcms_c_calc_frame_time(struct brcms_c_info *wlc,
-				    u32 ratespec,
-				    u8 preamble_type, uint mac_len);
-
-extern void brcms_c_set_chanspec(struct brcms_c_info *wlc,
-				 u16 chanspec);
-
-extern bool brcms_c_timers_init(struct brcms_c_info *wlc, int unit);
-
 extern int brcms_c_set_nmode(struct brcms_c_info *wlc);
-extern void brcms_c_mimops_action_ht_send(struct brcms_c_info *wlc,
-				      struct brcms_bss_cfg *bsscfg,
-				      u8 mimops_mode);
-
-extern void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot);
-extern void brcms_c_set_bssid(struct brcms_bss_cfg *cfg);
-extern void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend);
-
-extern void brcms_c_set_ratetable(struct brcms_c_info *wlc);
-extern int brcms_c_set_mac(struct brcms_bss_cfg *cfg);
 extern void brcms_c_beacon_phytxctl_txant_upd(struct brcms_c_info *wlc,
 					  u32 bcn_rate);
-extern void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc,
-					   uint frame_len);
-extern u32 brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
-					     struct brcms_c_rateset *rs);
-extern void brcms_c_radio_disable(struct brcms_c_info *wlc);
-extern void brcms_c_bcn_li_upd(struct brcms_c_info *wlc);
-extern void brcms_c_set_home_chanspec(struct brcms_c_info *wlc,
-				      u16 chanspec);
-extern bool brcms_c_ps_allowed(struct brcms_c_info *wlc);
-extern bool brcms_c_stay_awake(struct brcms_c_info *wlc);
-
 extern void brcms_b_antsel_type_set(struct brcms_hardware *wlc_hw,
 				     u8 antsel_type);
-
-/* chanspec, ucode interface */
 extern void brcms_b_set_chanspec(struct brcms_hardware *wlc_hw,
 				  u16 chanspec,
 				  bool mute, struct txpwr_limits *txpwr);
-
 extern void brcms_b_write_shm(struct brcms_hardware *wlc_hw, uint offset,
 			      u16 v);
 extern u16 brcms_b_read_shm(struct brcms_hardware *wlc_hw, uint offset);
-
 extern void brcms_b_mhf(struct brcms_hardware *wlc_hw, u8 idx, u16 mask,
 			u16 val, int bands);
-
 extern void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags);
-
 extern void brcms_b_mctrl(struct brcms_hardware *wlc_hw, u32 mask, u32 val);
-
 extern void brcms_b_phy_reset(struct brcms_hardware *wlc_hw);
 extern void brcms_b_bw_set(struct brcms_hardware *wlc_hw, u16 bw);
 extern void brcms_b_core_phypll_reset(struct brcms_hardware *wlc_hw);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 3942f47..37bb2dc 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -563,7 +563,7 @@ struct brcms_antselcfg {
 };
 
 /* common functions for every port */
-struct brcms_c_info *
+extern struct brcms_c_info *
 brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	       bool piomode, void __iomem *regsva, struct pci_dev *btparam,
 	       uint *perr);
@@ -585,14 +585,9 @@ extern void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc,
 				     struct sk_buff *sdu,
 				     struct ieee80211_hw *hw);
 extern bool brcms_c_aggregatable(struct brcms_c_info *wlc, u8 tid);
-
-/* helper functions */
-extern void brcms_c_statsupd(struct brcms_c_info *wlc);
 extern void brcms_c_protection_upd(struct brcms_c_info *wlc, uint idx,
 				   int val);
 extern int brcms_c_get_header_len(void);
-extern void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc,
-					   bool promisc);
 extern void brcms_c_set_addrmatch(struct brcms_c_info *wlc,
 				  int match_reg_offset,
 				  const u8 *addr);
@@ -600,26 +595,12 @@ extern void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 			      const struct ieee80211_tx_queue_params *arg,
 			      bool suspend);
 extern struct brcms_pub *brcms_c_pub(struct brcms_c_info *wlc);
-
-/* common functions for every port */
-extern void brcms_c_mhf(struct brcms_c_info *wlc, u8 idx, u16 mask, u16 val,
-		    int bands);
-extern void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
-				     struct brcms_c_rateset *rateset);
-extern void brcms_default_rateset(struct brcms_c_info *wlc,
-				  struct brcms_c_rateset *rs);
-
 extern void brcms_c_ampdu_flush(struct brcms_c_info *wlc,
 			    struct ieee80211_sta *sta, u16 tid);
 extern void brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
 					 u8 ba_wsize, uint max_rx_ampdu_bytes);
 extern char *getvar(struct si_pub *sih, enum brcms_srom_id id);
 extern int getintvar(struct si_pub *sih, enum brcms_srom_id id);
-
-/* wlc_phy.c helper functions */
-extern void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc);
-extern void brcms_c_mctrl(struct brcms_c_info *wlc, u32 mask, u32 val);
-
 extern int brcms_c_module_register(struct brcms_pub *pub,
 				   const char *name, struct brcms_info *hdl,
 				   int (*down_fn)(void *handle));
@@ -633,23 +614,21 @@ extern void brcms_c_scan_stop(struct brcms_c_info *wlc);
 extern int brcms_c_get_curband(struct brcms_c_info *wlc);
 extern void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc,
 					   bool drop);
-
-int brcms_c_set_channel(struct brcms_c_info *wlc, u16 channel);
-int brcms_c_set_rate_limit(struct brcms_c_info *wlc, u16 srl, u16 lrl);
-void brcms_c_get_current_rateset(struct brcms_c_info *wlc,
+extern int brcms_c_set_channel(struct brcms_c_info *wlc, u16 channel);
+extern int brcms_c_set_rate_limit(struct brcms_c_info *wlc, u16 srl, u16 lrl);
+extern void brcms_c_get_current_rateset(struct brcms_c_info *wlc,
 				 struct brcm_rateset *currs);
-int brcms_c_set_rateset(struct brcms_c_info *wlc, struct brcm_rateset *rs);
-int brcms_c_set_beacon_period(struct brcms_c_info *wlc, u16 period);
-u16 brcms_c_get_phy_type(struct brcms_c_info *wlc, int phyidx);
-void brcms_c_set_shortslot_override(struct brcms_c_info *wlc,
+extern int brcms_c_set_rateset(struct brcms_c_info *wlc,
+					struct brcm_rateset *rs);
+extern int brcms_c_set_beacon_period(struct brcms_c_info *wlc, u16 period);
+extern u16 brcms_c_get_phy_type(struct brcms_c_info *wlc, int phyidx);
+extern void brcms_c_set_shortslot_override(struct brcms_c_info *wlc,
 				    s8 sslot_override);
-void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc, u8 interval);
-int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr);
-int brcms_c_get_tx_power(struct brcms_c_info *wlc);
-void brcms_c_set_radio_mpc(struct brcms_c_info *wlc, bool mpc);
-
-/* helper functions */
+extern void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc,
+					u8 interval);
+extern int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr);
+extern int brcms_c_get_tx_power(struct brcms_c_info *wlc);
+extern void brcms_c_set_radio_mpc(struct brcms_c_info *wlc, bool mpc);
 extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
-extern bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc);
 
 #endif				/* _BRCM_PUB_H_ */
-- 
1.7.4.1


