Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2967 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab1IAJRn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:43 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 10/30] staging: brcm80211: remove static function
 prototypes from main.c
Date: Thu, 1 Sep 2011 11:17:00 +0200
Message-ID: <1314868640-9425-11-git-send-email-rvossen@broadcom.com> (sfid-20110901_111825_732098_DBF2007F)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Function prototypes for static functions are not strictly needed and
considered unwanted by linux community. This patch reorders the
functions in brcmsmac/main.c and gets rid of the prototypes.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c | 4685 ++++++++++++++---------------
 1 files changed, 2254 insertions(+), 2431 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 3aa0309..2825b1e 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -285,181 +285,6 @@ struct brcms_b_state {
 	u32 preamble_ovr;	/* preamble override */
 };
 
-/* local prototypes */
-static void brcms_b_clkctl_clk(struct brcms_hardware *wlc, uint mode);
-
-/* used by wlc_wakeucode_init() */
-static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
-			    const struct d11init *inits);
-static void brcms_ucode_write(struct brcms_hardware *wlc_hw, const u32 ucode[],
-			    const uint nbytes);
-static void brcms_ucode_download(struct brcms_hardware *wlc);
-static void brcms_c_ucode_txant_set(struct brcms_hardware *wlc_hw);
-
-/* used by brcms_c_down() */
-static void brcms_c_flushqueues(struct brcms_c_info *wlc);
-
-static void brcms_c_write_mhf(struct brcms_hardware *wlc_hw, u16 *mhfs);
-static void brcms_c_mctrl_reset(struct brcms_hardware *wlc_hw);
-static void brcms_b_corerev_fifofixup(struct brcms_hardware *wlc_hw);
-static bool brcms_b_tx_fifo_suspended(struct brcms_hardware *wlc_hw,
-				       uint tx_fifo);
-static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
-				   uint tx_fifo);
-
-/* Low Level Prototypes */
-
-struct brcms_b_state;
-
-static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
-			  uint unit, bool piomode, void *regsva,
-			  struct pci_dev *btparam);
-
-/* up/down, reset, clk */
-static void brcms_b_reset(struct brcms_hardware *wlc_hw);
-static int brcms_b_state_get(struct brcms_hardware *wlc_hw,
-			      struct brcms_b_state *state);
-static void brcms_b_copyfrom_vars(struct brcms_hardware *wlc_hw, char **buf,
-				   uint *len);
-
-static void brcms_b_hw_etheraddr(struct brcms_hardware *wlc_hw,
-				  u8 *ea);
-
-static bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw);
-static void brcms_b_wait_for_wake(struct brcms_hardware *wlc_hw);
-
-static void brcms_b_set_addrmatch(struct brcms_hardware *wlc_hw,
-				   int match_reg_offset,
-				   const u8 *addr);
-static void brcms_b_set_cwmin(struct brcms_hardware *wlc_hw, u16 newmin);
-static void brcms_b_set_cwmax(struct brcms_hardware *wlc_hw, u16 newmax);
-
-static void brcms_b_retrylimit_upd(struct brcms_hardware *wlc_hw, u16 SRL,
-				    u16 LRL);
-
-static void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw);
-
-static void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set,
-			   u32 req_bit);
-static void brcms_b_antsel_set(struct brcms_hardware *wlc_hw,
-			       u32 antsel_avail);
-static int brcms_b_bandtype(struct brcms_hardware *wlc_hw);
-static void brcms_b_info_init(struct brcms_hardware *wlc_hw);
-static void brcms_b_xtal(struct brcms_hardware *wlc_hw, bool want);
-static u16 brcms_b_read_objmem(struct brcms_hardware *wlc_hw, uint offset,
-				   u32 sel);
-static void brcms_b_write_objmem(struct brcms_hardware *wlc_hw, uint offset,
-				  u16 v, u32 sel);
-static void brcms_b_core_phy_clk(struct brcms_hardware *wlc_hw, bool clk);
-static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme);
-static void brcms_b_detach_dmapio(struct brcms_hardware *wlc_hw);
-static void brcms_c_ucode_bsinit(struct brcms_hardware *wlc_hw);
-static bool brcms_c_validboardtype(struct brcms_hardware *wlc);
-static bool brcms_c_isgoodchip(struct brcms_hardware *wlc_hw);
-static bool brcms_b_validate_chip_access(struct brcms_hardware *wlc_hw);
-static char *brcms_c_get_macaddr(struct brcms_hardware *wlc_hw);
-static void brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init);
-static void brcms_c_mctrl_write(struct brcms_hardware *wlc_hw);
-static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool want, u32 flags);
-static void brcms_c_ucode_mute_override_set(struct brcms_hardware *wlc_hw);
-static void brcms_c_ucode_mute_override_clear(struct brcms_hardware *wlc_hw);
-static u32 brcms_c_wlintrsoff(struct brcms_c_info *wlc);
-static void brcms_c_wlintrsrestore(struct brcms_c_info *wlc, u32 macintmask);
-static void brcms_c_gpio_init(struct brcms_c_info *wlc);
-static void brcms_c_write_hw_bcntemplate0(struct brcms_hardware *wlc_hw,
-					  u16 bcn[], int len);
-static void brcms_c_write_hw_bcntemplate1(struct brcms_hardware *wlc_hw,
-					  u16 bcn[], int len);
-static void brcms_b_bsinit(struct brcms_c_info *wlc, u16 chanspec);
-static u32 brcms_c_setband_inact(struct brcms_c_info *wlc, uint bandunit);
-static void brcms_b_setband(struct brcms_hardware *wlc_hw, uint bandunit,
-			     u16 chanspec);
-static void brcms_b_update_slot_timing(struct brcms_hardware *wlc_hw,
-					bool shortslot);
-static void brcms_upd_ofdm_pctl1_table(struct brcms_hardware *wlc_hw);
-static u16 brcms_b_ofdm_ratetable_offset(struct brcms_hardware *wlc_hw,
-					     u8 rate);
-
-static u16 brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc,
-					       struct ieee80211_hw *hw,
-					       struct sk_buff *p,
-					       struct scb *scb, uint frag,
-					       uint nfrags, uint queue,
-					       uint next_frag_len,
-					       struct wsec_key *key,
-					       u32 rspec_override);
-static void brcms_c_bss_default_init(struct brcms_c_info *wlc);
-static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc);
-static u32 mac80211_wlc_set_nrate(struct brcms_c_info *wlc,
-					 struct brcms_band *cur_band,
-					 u32 int_val);
-static void brcms_c_tx_prec_map_init(struct brcms_c_info *wlc);
-static void brcms_c_watchdog(void *arg);
-static void brcms_c_watchdog_by_timer(void *arg);
-static u16 brcms_c_rate_shm_offset(struct brcms_c_info *wlc, u8 rate);
-static int brcms_c_set_rateset(struct brcms_c_info *wlc,
-			       struct brcms_c_rateset *rs_arg);
-static u8 brcms_c_local_constraint_qdbm(struct brcms_c_info *wlc);
-
-/* send and receive */
-static struct brcms_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc);
-static void brcms_c_txq_free(struct brcms_c_info *wlc,
-			 struct brcms_txq_info *qi);
-static void brcms_c_txflowcontrol_signal(struct brcms_c_info *wlc,
-				     struct brcms_txq_info *qi,
-				     bool on, int prio);
-static void brcms_c_txflowcontrol_reset(struct brcms_c_info *wlc);
-static void brcms_c_compute_cck_plcp(struct brcms_c_info *wlc, u32 rate,
-				 uint length, u8 *plcp);
-static void brcms_c_compute_ofdm_plcp(u32 rate, uint length, u8 *plcp);
-static void brcms_c_compute_mimo_plcp(u32 rate, uint length, u8 *plcp);
-static u16 brcms_c_compute_frame_dur(struct brcms_c_info *wlc, u32 rate,
-				    u8 preamble_type, uint next_frag_len);
-static u64 brcms_c_recover_tsf64(struct brcms_c_info *wlc,
-			     struct brcms_d11rxhdr *rxh);
-static void brcms_c_recvctl(struct brcms_c_info *wlc,
-			struct d11rxhdr *rxh, struct sk_buff *p);
-static uint brcms_c_calc_frame_len(struct brcms_c_info *wlc, u32 rate,
-			       u8 preamble_type, uint dur);
-static uint brcms_c_calc_ack_time(struct brcms_c_info *wlc, u32 rate,
-			      u8 preamble_type);
-static uint brcms_c_calc_cts_time(struct brcms_c_info *wlc, u32 rate,
-			      u8 preamble_type);
-/* interrupt, up/down, band */
-static void brcms_c_setband(struct brcms_c_info *wlc, uint bandunit);
-static u16 brcms_c_init_chanspec(struct brcms_c_info *wlc);
-static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
-				     u16 chanspec);
-static void brcms_c_bsinit(struct brcms_c_info *wlc);
-static int brcms_c_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle,
-			      bool isOFDM, bool writeToShm);
-static void brcms_c_radio_hwdisable_upd(struct brcms_c_info *wlc);
-static bool brcms_c_radio_monitor_start(struct brcms_c_info *wlc);
-static void brcms_c_radio_timer(void *arg);
-static void brcms_c_radio_enable(struct brcms_c_info *wlc);
-static void brcms_c_radio_upd(struct brcms_c_info *wlc);
-
-/* scan, association, BSS */
-static uint brcms_c_calc_ba_time(struct brcms_c_info *wlc, u32 rate,
-			     u8 preamble_type);
-static void brcms_c_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap);
-static void brcms_c_ht_update_sgi_rx(struct brcms_c_info *wlc, int val);
-static void brcms_c_ht_update_ldpc(struct brcms_c_info *wlc, s8 val);
-static void brcms_c_war16165(struct brcms_c_info *wlc, bool tx);
-
-static void brcms_c_wme_retries_write(struct brcms_c_info *wlc);
-static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc);
-static uint brcms_c_attach_module(struct brcms_c_info *wlc);
-static void brcms_c_detach_module(struct brcms_c_info *wlc);
-static void brcms_c_timers_deinit(struct brcms_c_info *wlc);
-static void brcms_c_down_led_upd(struct brcms_c_info *wlc);
-static uint brcms_c_down_del_timer(struct brcms_c_info *wlc);
-static void brcms_c_ofdm_rateset_war(struct brcms_c_info *wlc);
-static int _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
-		      struct brcms_c_if *wlcif);
-static void brcms_c_write_hw_bcntemplates(struct brcms_c_info *wlc, u16 bcn[],
-					  int len, bool both);
-
 const u8 prio2fifo[NUMPRIO] = {
 	TX_AC_BE_FIFO,		/* 0    BE      AC_BE   Best Effort */
 	TX_AC_BK_FIFO,		/* 1    BK      AC_BK   Background */
@@ -554,6 +379,44 @@ static void brcms_b_update_slot_timing(struct brcms_hardware *wlc_hw,
 	}
 }
 
+static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
+				const struct d11init *inits)
+{
+	int i;
+	u8 *base;
+	u8 *addr;
+	u16 size;
+	u32 value;
+
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+
+	base = (u8 *)wlc_hw->regs;
+
+	for (i = 0; inits[i].addr != 0xffff; i++) {
+		size = le16_to_cpu(inits[i].size);
+		addr = base + le16_to_cpu(inits[i].addr);
+		value = le32_to_cpu(inits[i].value);
+		if (size == 2)
+			W_REG((u16 *)addr, value);
+		else if (size == 4)
+			W_REG((u32 *)addr, value);
+		else
+			break;
+	}
+}
+
+static void brcms_c_write_mhf(struct brcms_hardware *wlc_hw, u16 *mhfs)
+{
+	u8 idx;
+	u16 addr[] = {
+		M_HOST_FLAGS1, M_HOST_FLAGS2, M_HOST_FLAGS3, M_HOST_FLAGS4,
+		M_HOST_FLAGS5
+	};
+
+	for (idx = 0; idx < MHFMAX; idx++)
+		brcms_b_write_shm(wlc_hw, addr[idx], mhfs[idx]);
+}
+
 static void brcms_c_ucode_bsinit(struct brcms_hardware *wlc_hw)
 {
 	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
@@ -585,6 +448,30 @@ static void brcms_c_ucode_bsinit(struct brcms_hardware *wlc_hw)
 	}
 }
 
+static void brcms_b_core_phy_clk(struct brcms_hardware *wlc_hw, bool clk)
+{
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: clk %d\n", wlc_hw->unit, clk);
+
+	wlc_hw->phyclk = clk;
+
+	if (OFF == clk) {	/* clear gmode bit, put phy into reset */
+
+		ai_core_cflags(wlc_hw->sih, (SICF_PRST | SICF_FGC | SICF_GMODE),
+			       (SICF_PRST | SICF_FGC));
+		udelay(1);
+		ai_core_cflags(wlc_hw->sih, (SICF_PRST | SICF_FGC), SICF_PRST);
+		udelay(1);
+
+	} else {		/* take phy out of reset */
+
+		ai_core_cflags(wlc_hw->sih, (SICF_PRST | SICF_FGC), SICF_FGC);
+		udelay(1);
+		ai_core_cflags(wlc_hw->sih, (SICF_FGC), 0);
+		udelay(1);
+
+	}
+}
+
 /* switch to new band but leave it inactive */
 static u32 brcms_c_setband_inact(struct brcms_c_info *wlc, uint bandunit)
 {
@@ -734,6 +621,36 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 	return morepending;
 }
 
+/* brcms_b_tx_fifo_suspended:
+ * Check the MAC's tx suspend status for a tx fifo.
+ *
+ * When the MAC acknowledges a tx suspend, it indicates that no more
+ * packets will be transmitted out the radio. This is independent of
+ * DMA channel suspension---the DMA may have finished suspending, or may still
+ * be pulling data into a tx fifo, by the time the MAC acks the suspend
+ * request.
+ */
+static bool brcms_b_tx_fifo_suspended(struct brcms_hardware *wlc_hw,
+				      uint tx_fifo)
+{
+	/* check that a suspend has been requested and is no longer pending */
+
+	/*
+	 * for DMA mode, the suspend request is set in xmtcontrol of the DMA
+	 * engine, and the tx fifo suspend at the lower end of the MAC is
+	 * acknowledged in the chnstatus register.
+	 *
+	 * The tx fifo suspend completion is independent of the DMA suspend
+	 * completion and may be acked before or after the DMA is suspended.
+	 */
+	if (dma_txsuspended(wlc_hw->di[tx_fifo]) &&
+	    (R_REG(&wlc_hw->regs->chnstatus) &
+	     (1 << tx_fifo)) == 0)
+		return true;
+
+	return false;
+}
+
 /* second-level interrupt processing
  *   Return true if another dpc needs to be re-scheduled. false otherwise.
  *   Param 'bounded' indicates if applicable loops should be bounded.
@@ -845,6 +762,26 @@ int brcms_b_state_get(struct brcms_hardware *wlc_hw,
 	return 0;
 }
 
+/* set initial host flags value */
+static void
+brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init)
+{
+	struct brcms_hardware *wlc_hw = wlc->hw;
+
+	memset(mhfs, 0, MHFMAX * sizeof(u16));
+
+	mhfs[MHF2] |= mhf2_init;
+
+	/* prohibit use of slowclock on multifunction boards */
+	if (wlc_hw->boardflags & BFL_NOPLLDOWN)
+		mhfs[MHF1] |= MHF1_FORCEFASTCLK;
+
+	if (BRCMS_ISNPHY(wlc_hw->band) && NREV_LT(wlc_hw->band->phyrev, 2)) {
+		mhfs[MHF2] |= MHF2_NPHY40MHZ_WAR;
+		mhfs[MHF1] |= MHF1_IQSWAP_WAR;
+	}
+}
+
 static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 {
 	uint i;
@@ -1058,26 +995,6 @@ static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, uint mode)
 	}
 }
 
-/* set initial host flags value */
-static void
-brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init)
-{
-	struct brcms_hardware *wlc_hw = wlc->hw;
-
-	memset(mhfs, 0, MHFMAX * sizeof(u16));
-
-	mhfs[MHF2] |= mhf2_init;
-
-	/* prohibit use of slowclock on multifunction boards */
-	if (wlc_hw->boardflags & BFL_NOPLLDOWN)
-		mhfs[MHF1] |= MHF1_FORCEFASTCLK;
-
-	if (BRCMS_ISNPHY(wlc_hw->band) && NREV_LT(wlc_hw->band->phyrev, 2)) {
-		mhfs[MHF2] |= MHF2_NPHY40MHZ_WAR;
-		mhfs[MHF1] |= MHF1_IQSWAP_WAR;
-	}
-}
-
 /* set or clear ucode host flag bits
  * it has an optimization for no-change write
  * it only writes through shared memory when the core has clock;
@@ -1142,18 +1059,6 @@ brcms_b_mhf(struct brcms_hardware *wlc_hw, u8 idx, u16 mask, u16 val,
 	}
 }
 
-static void brcms_c_write_mhf(struct brcms_hardware *wlc_hw, u16 *mhfs)
-{
-	u8 idx;
-	u16 addr[] = {
-		M_HOST_FLAGS1, M_HOST_FLAGS2, M_HOST_FLAGS3, M_HOST_FLAGS4,
-		M_HOST_FLAGS5
-	};
-
-	for (idx = 0; idx < MHFMAX; idx++)
-		brcms_b_write_shm(wlc_hw, addr[idx], mhfs[idx]);
-}
-
 /* set the maccontrol register to desired reset state and
  * initialize the sw cache of the register
  */
@@ -1167,6 +1072,27 @@ static void brcms_c_mctrl_reset(struct brcms_hardware *wlc_hw)
 	brcms_b_mctrl(wlc_hw, ~0, MCTL_IHR_EN | MCTL_WAKE);
 }
 
+/*
+ * write the software state of maccontrol and
+ * overrides to the maccontrol register
+ */
+static void brcms_c_mctrl_write(struct brcms_hardware *wlc_hw)
+{
+	u32 maccontrol = wlc_hw->maccontrol;
+
+	/* OR in the wake bit if overridden */
+	if (wlc_hw->wake_override)
+		maccontrol |= MCTL_WAKE;
+
+	/* set AP and INFRA bits for mute if needed */
+	if (wlc_hw->mute_override) {
+		maccontrol &= ~(MCTL_AP);
+		maccontrol |= MCTL_INFRA;
+	}
+
+	W_REG(&wlc_hw->regs->maccontrol, maccontrol);
+}
+
 /* set or clear maccontrol bits */
 void brcms_b_mctrl(struct brcms_hardware *wlc_hw, u32 mask, u32 val)
 {
@@ -1189,27 +1115,6 @@ void brcms_b_mctrl(struct brcms_hardware *wlc_hw, u32 mask, u32 val)
 	brcms_c_mctrl_write(wlc_hw);
 }
 
-/*
- * write the software state of maccontrol and
- * overrides to the maccontrol register
- */
-static void brcms_c_mctrl_write(struct brcms_hardware *wlc_hw)
-{
-	u32 maccontrol = wlc_hw->maccontrol;
-
-	/* OR in the wake bit if overridden */
-	if (wlc_hw->wake_override)
-		maccontrol |= MCTL_WAKE;
-
-	/* set AP and INFRA bits for mute if needed */
-	if (wlc_hw->mute_override) {
-		maccontrol &= ~(MCTL_AP);
-		maccontrol |= MCTL_INFRA;
-	}
-
-	W_REG(&wlc_hw->regs->maccontrol, maccontrol);
-}
-
 void brcms_c_ucode_wake_override_set(struct brcms_hardware *wlc_hw,
 				 u32 override_bit)
 {
@@ -1420,28 +1325,113 @@ static void brcms_b_upd_synthpu(struct brcms_hardware *wlc_hw)
 	brcms_b_write_shm(wlc_hw, M_SYNTHPU_DLY, v);
 }
 
-/* band-specific init */
-static void brcms_b_bsinit(struct brcms_c_info *wlc, u16 chanspec)
+static void brcms_c_ucode_txant_set(struct brcms_hardware *wlc_hw)
 {
-	struct brcms_hardware *wlc_hw = wlc->hw;
+	u16 phyctl;
+	u16 phytxant = wlc_hw->bmac_phytxant;
+	u16 mask = PHY_TXC_ANT_MASK;
 
-	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
-		wlc_hw->band->bandunit);
+	/* set the Probe Response frame phy control word */
+	phyctl = brcms_b_read_shm(wlc_hw, M_CTXPRS_BLK + C_CTX_PCTLWD_POS);
+	phyctl = (phyctl & ~mask) | phytxant;
+	brcms_b_write_shm(wlc_hw, M_CTXPRS_BLK + C_CTX_PCTLWD_POS, phyctl);
 
-	brcms_c_ucode_bsinit(wlc_hw);
+	/* set the Response (ACK/CTS) frame phy control word */
+	phyctl = brcms_b_read_shm(wlc_hw, M_RSP_PCTLWD);
+	phyctl = (phyctl & ~mask) | phytxant;
+	brcms_b_write_shm(wlc_hw, M_RSP_PCTLWD, phyctl);
+}
 
-	wlc_phy_init(wlc_hw->band->pi, chanspec);
+static u16 brcms_b_ofdm_ratetable_offset(struct brcms_hardware *wlc_hw,
+					 u8 rate)
+{
+	uint i;
+	u8 plcp_rate = 0;
+	struct plcp_signal_rate_lookup {
+		u8 rate;
+		u8 signal_rate;
+	};
+	/* OFDM RATE sub-field of PLCP SIGNAL field, per 802.11 sec 17.3.4.1 */
+	const struct plcp_signal_rate_lookup rate_lookup[] = {
+		{BRCM_RATE_6M, 0xB},
+		{BRCM_RATE_9M, 0xF},
+		{BRCM_RATE_12M, 0xA},
+		{BRCM_RATE_18M, 0xE},
+		{BRCM_RATE_24M, 0x9},
+		{BRCM_RATE_36M, 0xD},
+		{BRCM_RATE_48M, 0x8},
+		{BRCM_RATE_54M, 0xC}
+	};
 
-	brcms_c_ucode_txant_set(wlc_hw);
+	for (i = 0; i < ARRAY_SIZE(rate_lookup); i++) {
+		if (rate == rate_lookup[i].rate) {
+			plcp_rate = rate_lookup[i].signal_rate;
+			break;
+		}
+	}
 
-	/*
-	 * cwmin is band-specific, update hardware
-	 * with value for current band
+	/* Find the SHM pointer to the rate table entry by looking in the
+	 * Direct-map Table
 	 */
-	brcms_b_set_cwmin(wlc_hw, wlc_hw->band->CWmin);
-	brcms_b_set_cwmax(wlc_hw, wlc_hw->band->CWmax);
+	return 2 * brcms_b_read_shm(wlc_hw, M_RT_DIRMAP_A + (plcp_rate * 2));
+}
 
-	brcms_b_update_slot_timing(wlc_hw,
+static void brcms_upd_ofdm_pctl1_table(struct brcms_hardware *wlc_hw)
+{
+	u8 rate;
+	u8 rates[8] = {
+		BRCM_RATE_6M, BRCM_RATE_9M, BRCM_RATE_12M, BRCM_RATE_18M,
+		BRCM_RATE_24M, BRCM_RATE_36M, BRCM_RATE_48M, BRCM_RATE_54M
+	};
+	u16 entry_ptr;
+	u16 pctl1;
+	uint i;
+
+	if (!BRCMS_PHY_11N_CAP(wlc_hw->band))
+		return;
+
+	/* walk the phy rate table and update the entries */
+	for (i = 0; i < ARRAY_SIZE(rates); i++) {
+		rate = rates[i];
+
+		entry_ptr = brcms_b_ofdm_ratetable_offset(wlc_hw, rate);
+
+		/* read the SHM Rate Table entry OFDM PCTL1 values */
+		pctl1 =
+		    brcms_b_read_shm(wlc_hw, entry_ptr + M_RT_OFDM_PCTL1_POS);
+
+		/* modify the value */
+		pctl1 &= ~PHY_TXC1_MODE_MASK;
+		pctl1 |= (wlc_hw->hw_stf_ss_opmode << PHY_TXC1_MODE_SHIFT);
+
+		/* Update the SHM Rate Table entry OFDM PCTL1 values */
+		brcms_b_write_shm(wlc_hw, entry_ptr + M_RT_OFDM_PCTL1_POS,
+				   pctl1);
+	}
+}
+
+/* band-specific init */
+static void brcms_b_bsinit(struct brcms_c_info *wlc, u16 chanspec)
+{
+	struct brcms_hardware *wlc_hw = wlc->hw;
+
+	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
+		wlc_hw->band->bandunit);
+
+	brcms_c_ucode_bsinit(wlc_hw);
+
+	wlc_phy_init(wlc_hw->band->pi, chanspec);
+
+	brcms_c_ucode_txant_set(wlc_hw);
+
+	/*
+	 * cwmin is band-specific, update hardware
+	 * with value for current band
+	 */
+	brcms_b_set_cwmin(wlc_hw, wlc_hw->band->CWmin);
+	brcms_b_set_cwmax(wlc_hw, wlc_hw->band->CWmax);
+
+	brcms_b_update_slot_timing(wlc_hw,
 				    BAND_5G(wlc_hw->band->
 					    bandtype) ? true : wlc_hw->
 				    shortslot);
@@ -1459,30 +1449,6 @@ static void brcms_b_bsinit(struct brcms_c_info *wlc, u16 chanspec)
 	brcms_b_upd_synthpu(wlc_hw);
 }
 
-static void brcms_b_core_phy_clk(struct brcms_hardware *wlc_hw, bool clk)
-{
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: clk %d\n", wlc_hw->unit, clk);
-
-	wlc_hw->phyclk = clk;
-
-	if (OFF == clk) {	/* clear gmode bit, put phy into reset */
-
-		ai_core_cflags(wlc_hw->sih, (SICF_PRST | SICF_FGC | SICF_GMODE),
-			       (SICF_PRST | SICF_FGC));
-		udelay(1);
-		ai_core_cflags(wlc_hw->sih, (SICF_PRST | SICF_FGC), SICF_PRST);
-		udelay(1);
-
-	} else {		/* take phy out of reset */
-
-		ai_core_cflags(wlc_hw->sih, (SICF_PRST | SICF_FGC), SICF_FGC);
-		udelay(1);
-		ai_core_cflags(wlc_hw->sih, (SICF_FGC), 0);
-		udelay(1);
-
-	}
-}
-
 /* Perform a soft reset of the PHY PLL */
 void brcms_b_core_phypll_reset(struct brcms_hardware *wlc_hw)
 {
@@ -1689,6 +1655,29 @@ static char *brcms_c_get_macaddr(struct brcms_hardware *wlc_hw)
 	return macaddr;
 }
 
+/* power both the pll and external oscillator on/off */
+static void brcms_b_xtal(struct brcms_hardware *wlc_hw, bool want)
+{
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: want %d\n", wlc_hw->unit, want);
+
+	/*
+	 * dont power down if plldown is false or
+	 * we must poll hw radio disable
+	 */
+	if (!want && wlc_hw->pllreq)
+		return;
+
+	if (wlc_hw->sih)
+		ai_clkctl_xtal(wlc_hw->sih, XTAL | PLL, want);
+
+	wlc_hw->sbclk = want;
+	if (!wlc_hw->sbclk) {
+		wlc_hw->clk = false;
+		if (wlc_hw->band && wlc_hw->band->pi)
+			wlc_phy_hw_clk_state_upd(wlc_hw->band->pi, false);
+	}
+}
+
 /*
  * Return true if radio is disabled, otherwise false.
  * hw radio disable signal is an external pin, users activate it asynchronously
@@ -1990,6 +1979,23 @@ static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 	ai_gpiocontrol(wlc_hw->sih, gm, gc, GPIO_DRV_PRIORITY);
 }
 
+static void brcms_ucode_write(struct brcms_hardware *wlc_hw, const u32 ucode[],
+			      const uint nbytes) {
+	struct d11regs *regs = wlc_hw->regs;
+	uint i;
+	uint count;
+
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
+
+	count = (nbytes / sizeof(u32));
+
+	W_REG(&regs->objaddr, (OBJADDR_AUTO_INC | OBJADDR_UCM_SEL));
+	(void)R_REG(&regs->objaddr);
+	for (i = 0; i < count; i++)
+		W_REG(&regs->objdata, le32_to_cpu(ucode[i]));
+
+}
+
 static void brcms_ucode_download(struct brcms_hardware *wlc_hw)
 {
 	struct brcms_c_info *wlc;
@@ -2020,66 +2026,6 @@ static void brcms_ucode_download(struct brcms_hardware *wlc_hw)
 	}
 }
 
-static void brcms_ucode_write(struct brcms_hardware *wlc_hw, const u32 ucode[],
-			      const uint nbytes) {
-	struct d11regs *regs = wlc_hw->regs;
-	uint i;
-	uint count;
-
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
-	count = (nbytes / sizeof(u32));
-
-	W_REG(&regs->objaddr, (OBJADDR_AUTO_INC | OBJADDR_UCM_SEL));
-	(void)R_REG(&regs->objaddr);
-	for (i = 0; i < count; i++)
-		W_REG(&regs->objdata, le32_to_cpu(ucode[i]));
-
-}
-
-static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
-			    const struct d11init *inits)
-{
-	int i;
-	u8 *base;
-	u8 *addr;
-	u16 size;
-	u32 value;
-
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
-	base = (u8 *)wlc_hw->regs;
-
-	for (i = 0; inits[i].addr != 0xffff; i++) {
-		size = le16_to_cpu(inits[i].size);
-		addr = base + le16_to_cpu(inits[i].addr);
-		value = le32_to_cpu(inits[i].value);
-		if (size == 2)
-			W_REG((u16 *)addr, value);
-		else if (size == 4)
-			W_REG((u32 *)addr, value);
-		else
-			break;
-	}
-}
-
-static void brcms_c_ucode_txant_set(struct brcms_hardware *wlc_hw)
-{
-	u16 phyctl;
-	u16 phytxant = wlc_hw->bmac_phytxant;
-	u16 mask = PHY_TXC_ANT_MASK;
-
-	/* set the Probe Response frame phy control word */
-	phyctl = brcms_b_read_shm(wlc_hw, M_CTXPRS_BLK + C_CTX_PCTLWD_POS);
-	phyctl = (phyctl & ~mask) | phytxant;
-	brcms_b_write_shm(wlc_hw, M_CTXPRS_BLK + C_CTX_PCTLWD_POS, phyctl);
-
-	/* set the Response (ACK/CTS) frame phy control word */
-	phyctl = brcms_b_read_shm(wlc_hw, M_RSP_PCTLWD);
-	phyctl = (phyctl & ~mask) | phytxant;
-	brcms_b_write_shm(wlc_hw, M_RSP_PCTLWD, phyctl);
-}
-
 void brcms_b_txant_set(struct brcms_hardware *wlc_hw, u16 phytxant)
 {
 	/* update sw state */
@@ -2259,6 +2205,28 @@ static void brcms_b_tx_fifo_suspend(struct brcms_hardware *wlc_hw,
 	}
 }
 
+static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
+				   uint tx_fifo)
+{
+	/* BMAC_NOTE: BRCMS_TX_FIFO_ENAB is done in brcms_c_dpc() for DMA case
+	 * but need to be done here for PIO otherwise the watchdog will catch
+	 * the inconsistency and fire
+	 */
+	/* Two clients of this code, 11h Quiet period and scanning. */
+	if (wlc_hw->di[tx_fifo])
+		dma_txresume(wlc_hw->di[tx_fifo]);
+
+	/* allow core to sleep again */
+	if (wlc_hw->suspended_fifos == 0)
+		return;
+	else {
+		wlc_hw->suspended_fifos &= ~(1 << tx_fifo);
+		if (wlc_hw->suspended_fifos == 0)
+			brcms_c_ucode_wake_override_clear(wlc_hw,
+						BRCMS_WAKE_OVERRIDE_TXFIFO);
+	}
+}
+
 static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool on, u32 flags)
 {
 	u8 null_ether_addr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
@@ -2295,58 +2263,6 @@ static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool on, u32 flags)
 		brcms_c_ucode_mute_override_clear(wlc_hw);
 }
 
-/* brcms_b_tx_fifo_suspended:
- * Check the MAC's tx suspend status for a tx fifo.
- *
- * When the MAC acknowledges a tx suspend, it indicates that no more
- * packets will be transmitted out the radio. This is independent of
- * DMA channel suspension---the DMA may have finished suspending, or may still
- * be pulling data into a tx fifo, by the time the MAC acks the suspend
- * request.
- */
-static bool brcms_b_tx_fifo_suspended(struct brcms_hardware *wlc_hw,
-				      uint tx_fifo)
-{
-	/* check that a suspend has been requested and is no longer pending */
-
-	/*
-	 * for DMA mode, the suspend request is set in xmtcontrol of the DMA
-	 * engine, and the tx fifo suspend at the lower end of the MAC is
-	 * acknowledged in the chnstatus register.
-	 *
-	 * The tx fifo suspend completion is independent of the DMA suspend
-	 * completion and may be acked before or after the DMA is suspended.
-	 */
-	if (dma_txsuspended(wlc_hw->di[tx_fifo]) &&
-	    (R_REG(&wlc_hw->regs->chnstatus) &
-	     (1 << tx_fifo)) == 0)
-		return true;
-
-	return false;
-}
-
-static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
-				   uint tx_fifo)
-{
-	/* BMAC_NOTE: BRCMS_TX_FIFO_ENAB is done in brcms_c_dpc() for DMA case
-	 * but need to be done here for PIO otherwise the watchdog will catch
-	 * the inconsistency and fire
-	 */
-	/* Two clients of this code, 11h Quiet period and scanning. */
-	if (wlc_hw->di[tx_fifo])
-		dma_txresume(wlc_hw->di[tx_fifo]);
-
-	/* allow core to sleep again */
-	if (wlc_hw->suspended_fifos == 0)
-		return;
-	else {
-		wlc_hw->suspended_fifos &= ~(1 << tx_fifo);
-		if (wlc_hw->suspended_fifos == 0)
-			brcms_c_ucode_wake_override_clear(wlc_hw,
-						BRCMS_WAKE_OVERRIDE_TXFIFO);
-	}
-}
-
 /*
  * Read and clear macintmask and macintstatus and intstatus registers.
  * This routine should be called with interrupts off
@@ -2569,75 +2485,7 @@ void brcms_c_enable_mac(struct brcms_c_info *wlc)
 					  BRCMS_WAKE_OVERRIDE_MACSUSPEND);
 }
 
-static void brcms_upd_ofdm_pctl1_table(struct brcms_hardware *wlc_hw)
-{
-	u8 rate;
-	u8 rates[8] = {
-		BRCM_RATE_6M, BRCM_RATE_9M, BRCM_RATE_12M, BRCM_RATE_18M,
-		BRCM_RATE_24M, BRCM_RATE_36M, BRCM_RATE_48M, BRCM_RATE_54M
-	};
-	u16 entry_ptr;
-	u16 pctl1;
-	uint i;
-
-	if (!BRCMS_PHY_11N_CAP(wlc_hw->band))
-		return;
-
-	/* walk the phy rate table and update the entries */
-	for (i = 0; i < ARRAY_SIZE(rates); i++) {
-		rate = rates[i];
-
-		entry_ptr = brcms_b_ofdm_ratetable_offset(wlc_hw, rate);
-
-		/* read the SHM Rate Table entry OFDM PCTL1 values */
-		pctl1 =
-		    brcms_b_read_shm(wlc_hw, entry_ptr + M_RT_OFDM_PCTL1_POS);
-
-		/* modify the value */
-		pctl1 &= ~PHY_TXC1_MODE_MASK;
-		pctl1 |= (wlc_hw->hw_stf_ss_opmode << PHY_TXC1_MODE_SHIFT);
-
-		/* Update the SHM Rate Table entry OFDM PCTL1 values */
-		brcms_b_write_shm(wlc_hw, entry_ptr + M_RT_OFDM_PCTL1_POS,
-				   pctl1);
-	}
-}
-
-static u16 brcms_b_ofdm_ratetable_offset(struct brcms_hardware *wlc_hw,
-					 u8 rate)
-{
-	uint i;
-	u8 plcp_rate = 0;
-	struct plcp_signal_rate_lookup {
-		u8 rate;
-		u8 signal_rate;
-	};
-	/* OFDM RATE sub-field of PLCP SIGNAL field, per 802.11 sec 17.3.4.1 */
-	const struct plcp_signal_rate_lookup rate_lookup[] = {
-		{BRCM_RATE_6M, 0xB},
-		{BRCM_RATE_9M, 0xF},
-		{BRCM_RATE_12M, 0xA},
-		{BRCM_RATE_18M, 0xE},
-		{BRCM_RATE_24M, 0x9},
-		{BRCM_RATE_36M, 0xD},
-		{BRCM_RATE_48M, 0x8},
-		{BRCM_RATE_54M, 0xC}
-	};
-
-	for (i = 0; i < ARRAY_SIZE(rate_lookup); i++) {
-		if (rate == rate_lookup[i].rate) {
-			plcp_rate = rate_lookup[i].signal_rate;
-			break;
-		}
-	}
-
-	/* Find the SHM pointer to the rate table entry by looking in the
-	 * Direct-map Table
-	 */
-	return 2 * brcms_b_read_shm(wlc_hw, M_RT_DIRMAP_A + (plcp_rate * 2));
-}
-
-void brcms_b_band_stf_ss_set(struct brcms_hardware *wlc_hw, u8 stf_mode)
+void brcms_b_band_stf_ss_set(struct brcms_hardware *wlc_hw, u8 stf_mode)
 {
 	wlc_hw->hw_stf_ss_opmode = stf_mode;
 
@@ -2799,29 +2647,6 @@ void brcms_c_coredisable(struct brcms_hardware *wlc_hw)
 	wlc_phy_hw_clk_state_upd(wlc_hw->band->pi, false);
 }
 
-/* power both the pll and external oscillator on/off */
-static void brcms_b_xtal(struct brcms_hardware *wlc_hw, bool want)
-{
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: want %d\n", wlc_hw->unit, want);
-
-	/*
-	 * dont power down if plldown is false or
-	 * we must poll hw radio disable
-	 */
-	if (!want && wlc_hw->pllreq)
-		return;
-
-	if (wlc_hw->sih)
-		ai_clkctl_xtal(wlc_hw->sih, XTAL | PLL, want);
-
-	wlc_hw->sbclk = want;
-	if (!wlc_hw->sbclk) {
-		wlc_hw->clk = false;
-		if (wlc_hw->band && wlc_hw->band->pi)
-			wlc_phy_hw_clk_state_upd(wlc_hw->band->pi, false);
-	}
-}
-
 static void brcms_c_flushqueues(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
@@ -2841,16 +2666,6 @@ static void brcms_c_flushqueues(struct brcms_c_info *wlc)
 	dma_rxreclaim(wlc_hw->di[RX_FIFO]);
 }
 
-u16 brcms_b_read_shm(struct brcms_hardware *wlc_hw, uint offset)
-{
-	return brcms_b_read_objmem(wlc_hw, offset, OBJADDR_SHM_SEL);
-}
-
-void brcms_b_write_shm(struct brcms_hardware *wlc_hw, uint offset, u16 v)
-{
-	brcms_b_write_objmem(wlc_hw, offset, v, OBJADDR_SHM_SEL);
-}
-
 static u16
 brcms_b_read_objmem(struct brcms_hardware *wlc_hw, uint offset, u32 sel)
 {
@@ -2885,6 +2700,16 @@ brcms_b_write_objmem(struct brcms_hardware *wlc_hw, uint offset, u16 v,
 		W_REG(objdata_lo, v);
 }
 
+u16 brcms_b_read_shm(struct brcms_hardware *wlc_hw, uint offset)
+{
+	return brcms_b_read_objmem(wlc_hw, offset, OBJADDR_SHM_SEL);
+}
+
+void brcms_b_write_shm(struct brcms_hardware *wlc_hw, uint offset, u16 v)
+{
+	brcms_b_write_objmem(wlc_hw, offset, v, OBJADDR_SHM_SEL);
+}
+
 /* Copy a buffer to shared memory of specified type .
  * SHM 'offset' needs to be an even address and
  * Buffer length 'len' must be an even number of bytes
@@ -3319,101 +3144,315 @@ brcms_b_init(struct brcms_hardware *wlc_hw, u16 chanspec,
 		brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
 }
 
-void brcms_c_init(struct brcms_c_info *wlc)
+static u8 brcms_c_local_constraint_qdbm(struct brcms_c_info *wlc)
 {
-	struct d11regs *regs;
-	u16 chanspec;
-	int i;
-	struct brcms_bss_cfg *bsscfg;
-	bool mute = false;
+	u8 local;
+	s16 local_max;
 
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
+	local = BRCMS_TXPWR_MAX;
+	if (wlc->pub->associated &&
+	    (brcmu_chspec_ctlchan(wlc->chanspec) ==
+	     brcmu_chspec_ctlchan(wlc->home_chanspec))) {
 
-	regs = wlc->regs;
+		/* get the local power constraint if we are on the AP's
+		 * channel [802.11h, 7.3.2.13]
+		 */
+		/* Clamp the value between 0 and BRCMS_TXPWR_MAX w/o
+		 * overflowing the target */
+		local_max =
+		    (wlc->txpwr_local_max -
+		     wlc->txpwr_local_constraint) * BRCMS_TXPWR_DB_FACTOR;
+		if (local_max > 0 && local_max < BRCMS_TXPWR_MAX)
+			return (u8) local_max;
+		if (local_max < 0)
+			return 0;
+	}
 
-	/*
-	 * This will happen if a big-hammer was executed. In
-	 * that case, we want to go back to the channel that
-	 * we were on and not new channel
-	 */
-	if (wlc->pub->associated)
-		chanspec = wlc->home_chanspec;
-	else
-		chanspec = brcms_c_init_chanspec(wlc);
+	return local;
+}
 
-	brcms_b_init(wlc->hw, chanspec, mute);
+static void brcms_c_set_phy_chanspec(struct brcms_c_info *wlc,
+				     u16 chanspec)
+{
+	/* Save our copy of the chanspec */
+	wlc->chanspec = chanspec;
 
-	/* update beacon listen interval */
-	brcms_c_bcn_li_upd(wlc);
+	/* Set the chanspec and power limits for this locale after computing
+	 * any 11h local tx power constraints.
+	 */
+	brcms_c_channel_set_chanspec(wlc->cmi, chanspec,
+				 brcms_c_local_constraint_qdbm(wlc));
 
-	/* the world is new again, so is our reported rate */
-	brcms_c_reprate_init(wlc);
+	if (wlc->stf->ss_algosel_auto)
+		brcms_c_stf_ss_algo_channel_get(wlc, &wlc->stf->ss_algo_channel,
+					    chanspec);
 
-	/* write ethernet address to core */
-	FOREACH_BSS(wlc, i, bsscfg)
-		brcms_c_set_mac(bsscfg);
-		brcms_c_set_bssid(bsscfg);
-	END_FOREACH_BSS()
+	brcms_c_stf_ss_update(wlc, wlc->band);
 
-	/* Update tsf_cfprep if associated and up */
-	if (wlc->pub->associated) {
-		FOREACH_BSS(wlc, i, bsscfg)
-			if (bsscfg->up) {
-				u32 bi;
+}
 
-				/* get beacon period and convert to uS */
-				bi = bsscfg->current_bss->beacon_period << 10;
-				/*
-				 * update since init path would reset
-				 * to default value
-				 */
-				W_REG(&regs->tsf_cfprep,
-				      (bi << CFPREP_CBI_SHIFT));
+static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
+				     u16 chanspec)
+{
+	struct brcms_c_rateset default_rateset;
+	uint parkband;
+	uint i, band_order[2];
 
-				/* Update maccontrol PM related bits */
-				brcms_c_set_ps_ctrl(wlc);
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
+	/*
+	 * We might have been bandlocked during down and the chip
+	 * power-cycled (hibernate). Figure out the right band to park on
+	 */
+	if (wlc->bandlocked || NBANDS(wlc) == 1) {
+		/* updated in brcms_c_bandlock() */
+		parkband = wlc->band->bandunit;
+		band_order[0] = band_order[1] = parkband;
+	} else {
+		/* park on the band of the specified chanspec */
+		parkband = CHSPEC_BANDUNIT(chanspec);
 
-				break;
-			}
-		END_FOREACH_BSS()
+		/* order so that parkband initialize last */
+		band_order[0] = parkband ^ 1;
+		band_order[1] = parkband;
 	}
 
-	brcms_c_bandinit_ordered(wlc, chanspec);
-
-	brcms_c_init_scb(wlc, &global_scb);
-
-	/* init probe response timeout */
-	brcms_c_write_shm(wlc, M_PRS_MAXTIME, wlc->prb_resp_timeout);
-
-	/* init max burst txop (framebursting) */
-	brcms_c_write_shm(wlc, M_MBURST_TXOP,
-		      (wlc->
-		       _rifs ? (EDCF_AC_VO_TXOP_AP << 5) : MAXFRAMEBURST_TXOP));
+	/* make each band operational, software state init */
+	for (i = 0; i < NBANDS(wlc); i++) {
+		uint j = band_order[i];
 
-	/* initialize maximum allowed duty cycle */
-	brcms_c_duty_cycle_set(wlc, wlc->tx_duty_cycle_ofdm, true, true);
-	brcms_c_duty_cycle_set(wlc, wlc->tx_duty_cycle_cck, false, true);
+		wlc->band = wlc->bandstate[j];
 
-	/*
-	 * Update some shared memory locations related to
-	 * max AMPDU size allowed to received
-	 */
-	brcms_c_ampdu_shm_upd(wlc->ampdu);
+		brcms_default_rateset(wlc, &default_rateset);
 
-	/* band-specific inits */
-	brcms_c_bsinit(wlc);
+		/* fill in hw_rate */
+		brcms_c_rateset_filter(&default_rateset, &wlc->band->hw_rateset,
+				   false, BRCMS_RATES_CCK_OFDM, BRCMS_RATE_MASK,
+				   (bool) N_ENAB(wlc->pub));
 
-	/* Enable EDCF mode (while the MAC is suspended) */
-	if (EDCF_ENAB(wlc->pub)) {
-		OR_REG(&regs->ifs_ctl, IFS_USEEDCF);
-		brcms_c_edcf_setparams(wlc, false);
+		/* init basic rate lookup */
+		brcms_c_rate_lookup_init(wlc, &default_rateset);
 	}
 
-	/* Init precedence maps for empty FIFOs */
-	brcms_c_tx_prec_map_init(wlc);
+	/* sync up phy/radio chanspec */
+	brcms_c_set_phy_chanspec(wlc, chanspec);
+}
 
-	/* read the ucode version if we have not yet done so */
-	if (wlc->ucode_rev == 0) {
+/*
+ * ucode, hwmac update
+ *    Channel dependent updates for ucode and hw
+ */
+static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc)
+{
+	/* enable or disable any active IBSSs depending on whether or not
+	 * we are on the home channel
+	 */
+	if (wlc->home_chanspec == BRCMS_BAND_PI_RADIO_CHANSPEC) {
+		if (wlc->pub->associated) {
+			/*
+			 * BMAC_NOTE: This is something that should be fixed
+			 * in ucode inits. I think that the ucode inits set
+			 * up the bcn templates and shm values with a bogus
+			 * beacon. This should not be done in the inits. If
+			 * ucode needs to set up a beacon for testing, the
+			 * test routines should write it down, not expect the
+			 * inits to populate a bogus beacon.
+			 */
+			if (BRCMS_PHY_11N_CAP(wlc->band))
+				brcms_c_write_shm(wlc, M_BCN_TXTSF_OFFSET,
+					      wlc->band->bcntsfoff);
+		}
+	} else {
+		/* disable an active IBSS if we are not on the home channel */
+	}
+
+	/* update the various promisc bits */
+	brcms_c_mac_bcn_promisc(wlc);
+	brcms_c_mac_promisc(wlc);
+}
+
+/* band-specific init */
+static void brcms_c_bsinit(struct brcms_c_info *wlc)
+{
+	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n",
+		 wlc->pub->unit, wlc->band->bandunit);
+
+	/* write ucode ACK/CTS rate table */
+	brcms_c_set_ratetable(wlc);
+
+	/* update some band specific mac configuration */
+	brcms_c_ucode_mac_upd(wlc);
+
+	/* init antenna selection */
+	brcms_c_antsel_init(wlc->asi);
+
+}
+
+/* formula:  IDLE_BUSY_RATIO_X_16 = (100-duty_cycle)/duty_cycle*16 */
+static int
+brcms_c_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle, bool isOFDM,
+		   bool writeToShm)
+{
+	int idle_busy_ratio_x_16 = 0;
+	uint offset =
+	    isOFDM ? M_TX_IDLE_BUSY_RATIO_X_16_OFDM :
+	    M_TX_IDLE_BUSY_RATIO_X_16_CCK;
+	if (duty_cycle > 100 || duty_cycle < 0) {
+		wiphy_err(wlc->wiphy, "wl%d:  duty cycle value off limit\n",
+			  wlc->pub->unit);
+		return -EINVAL;
+	}
+	if (duty_cycle)
+		idle_busy_ratio_x_16 = (100 - duty_cycle) * 16 / duty_cycle;
+	/* Only write to shared memory  when wl is up */
+	if (writeToShm)
+		brcms_c_write_shm(wlc, offset, (u16) idle_busy_ratio_x_16);
+
+	if (isOFDM)
+		wlc->tx_duty_cycle_ofdm = (u16) duty_cycle;
+	else
+		wlc->tx_duty_cycle_cck = (u16) duty_cycle;
+
+	return 0;
+}
+
+/*
+ * Initialize the base precedence map for dequeueing
+ * from txq based on WME settings
+ */
+static void brcms_c_tx_prec_map_init(struct brcms_c_info *wlc)
+{
+	wlc->tx_prec_map = BRCMS_PREC_BMP_ALL;
+	memset(wlc->fifo2prec_map, 0, NFIFO * sizeof(u16));
+
+	/*
+	 * For non-WME, both fifos have overlapping MAXPRIO. So just
+	 * disable all precedences if either is full.
+	 */
+	if (!EDCF_ENAB(wlc->pub)) {
+		wlc->fifo2prec_map[TX_DATA_FIFO] = BRCMS_PREC_BMP_ALL;
+		wlc->fifo2prec_map[TX_CTL_FIFO] = BRCMS_PREC_BMP_ALL;
+	} else {
+		wlc->fifo2prec_map[TX_AC_BK_FIFO] = BRCMS_PREC_BMP_AC_BK;
+		wlc->fifo2prec_map[TX_AC_BE_FIFO] = BRCMS_PREC_BMP_AC_BE;
+		wlc->fifo2prec_map[TX_AC_VI_FIFO] = BRCMS_PREC_BMP_AC_VI;
+		wlc->fifo2prec_map[TX_AC_VO_FIFO] = BRCMS_PREC_BMP_AC_VO;
+	}
+}
+
+static void
+brcms_c_txflowcontrol_signal(struct brcms_c_info *wlc,
+			     struct brcms_txq_info *qi, bool on, int prio)
+{
+	/* transmit flowcontrol is not yet implemented */
+}
+
+static void brcms_c_txflowcontrol_reset(struct brcms_c_info *wlc)
+{
+	struct brcms_txq_info *qi;
+
+	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next) {
+		if (qi->stopped) {
+			brcms_c_txflowcontrol_signal(wlc, qi, OFF, ALLPRIO);
+			qi->stopped = 0;
+		}
+	}
+}
+
+void brcms_c_init(struct brcms_c_info *wlc)
+{
+	struct d11regs *regs;
+	u16 chanspec;
+	int i;
+	struct brcms_bss_cfg *bsscfg;
+	bool mute = false;
+
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
+
+	regs = wlc->regs;
+
+	/*
+	 * This will happen if a big-hammer was executed. In
+	 * that case, we want to go back to the channel that
+	 * we were on and not new channel
+	 */
+	if (wlc->pub->associated)
+		chanspec = wlc->home_chanspec;
+	else
+		chanspec = brcms_c_init_chanspec(wlc);
+
+	brcms_b_init(wlc->hw, chanspec, mute);
+
+	/* update beacon listen interval */
+	brcms_c_bcn_li_upd(wlc);
+
+	/* the world is new again, so is our reported rate */
+	brcms_c_reprate_init(wlc);
+
+	/* write ethernet address to core */
+	FOREACH_BSS(wlc, i, bsscfg)
+		brcms_c_set_mac(bsscfg);
+		brcms_c_set_bssid(bsscfg);
+	END_FOREACH_BSS()
+
+	/* Update tsf_cfprep if associated and up */
+	if (wlc->pub->associated) {
+		FOREACH_BSS(wlc, i, bsscfg)
+			if (bsscfg->up) {
+				u32 bi;
+
+				/* get beacon period and convert to uS */
+				bi = bsscfg->current_bss->beacon_period << 10;
+				/*
+				 * update since init path would reset
+				 * to default value
+				 */
+				W_REG(&regs->tsf_cfprep,
+				      (bi << CFPREP_CBI_SHIFT));
+
+				/* Update maccontrol PM related bits */
+				brcms_c_set_ps_ctrl(wlc);
+
+				break;
+			}
+		END_FOREACH_BSS()
+	}
+
+	brcms_c_bandinit_ordered(wlc, chanspec);
+
+	brcms_c_init_scb(wlc, &global_scb);
+
+	/* init probe response timeout */
+	brcms_c_write_shm(wlc, M_PRS_MAXTIME, wlc->prb_resp_timeout);
+
+	/* init max burst txop (framebursting) */
+	brcms_c_write_shm(wlc, M_MBURST_TXOP,
+		      (wlc->
+		       _rifs ? (EDCF_AC_VO_TXOP_AP << 5) : MAXFRAMEBURST_TXOP));
+
+	/* initialize maximum allowed duty cycle */
+	brcms_c_duty_cycle_set(wlc, wlc->tx_duty_cycle_ofdm, true, true);
+	brcms_c_duty_cycle_set(wlc, wlc->tx_duty_cycle_cck, false, true);
+
+	/*
+	 * Update some shared memory locations related to
+	 * max AMPDU size allowed to received
+	 */
+	brcms_c_ampdu_shm_upd(wlc->ampdu);
+
+	/* band-specific inits */
+	brcms_c_bsinit(wlc);
+
+	/* Enable EDCF mode (while the MAC is suspended) */
+	if (EDCF_ENAB(wlc->pub)) {
+		OR_REG(&regs->ifs_ctl, IFS_USEEDCF);
+		brcms_c_edcf_setparams(wlc, false);
+	}
+
+	/* Init precedence maps for empty FIFOs */
+	brcms_c_tx_prec_map_init(wlc);
+
+	/* read the ucode version if we have not yet done so */
+	if (wlc->ucode_rev == 0) {
 		wlc->ucode_rev =
 		    brcms_c_read_shm(wlc, M_BOM_REV_MAJOR) << NBITS(u16);
 		wlc->ucode_rev |= brcms_c_read_shm(wlc, M_BOM_REV_MINOR);
@@ -3585,33 +3624,6 @@ void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
 	brcms_b_set_shortslot(wlc->hw, shortslot);
 }
 
-static u8 brcms_c_local_constraint_qdbm(struct brcms_c_info *wlc)
-{
-	u8 local;
-	s16 local_max;
-
-	local = BRCMS_TXPWR_MAX;
-	if (wlc->pub->associated &&
-	    (brcmu_chspec_ctlchan(wlc->chanspec) ==
-	     brcmu_chspec_ctlchan(wlc->home_chanspec))) {
-
-		/* get the local power constraint if we are on the AP's
-		 * channel [802.11h, 7.3.2.13]
-		 */
-		/* Clamp the value between 0 and BRCMS_TXPWR_MAX w/o
-		 * overflowing the target */
-		local_max =
-		    (wlc->txpwr_local_max -
-		     wlc->txpwr_local_constraint) * BRCMS_TXPWR_DB_FACTOR;
-		if (local_max > 0 && local_max < BRCMS_TXPWR_MAX)
-			return (u8) local_max;
-		if (local_max < 0)
-			return 0;
-	}
-
-	return local;
-}
-
 /*
  * propagate home chanspec to all bsscfgs in
  * case bsscfg->current_bss->chanspec is referenced
@@ -3635,33 +3647,13 @@ void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 	}
 }
 
-static void brcms_c_set_phy_chanspec(struct brcms_c_info *wlc,
-				     u16 chanspec)
+void
+brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, u16 chanspec,
+		      bool mute, struct txpwr_limits *txpwr)
 {
-	/* Save our copy of the chanspec */
-	wlc->chanspec = chanspec;
+	uint bandunit;
 
-	/* Set the chanspec and power limits for this locale after computing
-	 * any 11h local tx power constraints.
-	 */
-	brcms_c_channel_set_chanspec(wlc->cmi, chanspec,
-				 brcms_c_local_constraint_qdbm(wlc));
-
-	if (wlc->stf->ss_algosel_auto)
-		brcms_c_stf_ss_algo_channel_get(wlc, &wlc->stf->ss_algo_channel,
-					    chanspec);
-
-	brcms_c_stf_ss_update(wlc, wlc->band);
-
-}
-
-void
-brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, u16 chanspec,
-		      bool mute, struct txpwr_limits *txpwr)
-{
-	uint bandunit;
-
-	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: 0x%x\n", wlc_hw->unit, chanspec);
+	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: 0x%x\n", wlc_hw->unit, chanspec);
 
 	wlc_hw->chanspec = chanspec;
 
@@ -3699,6 +3691,30 @@ brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, u16 chanspec,
 	}
 }
 
+/* switch to and initialize new band */
+static void brcms_c_setband(struct brcms_c_info *wlc,
+					   uint bandunit)
+{
+	int idx;
+	struct brcms_bss_cfg *cfg;
+
+	wlc->band = wlc->bandstate[bandunit];
+
+	if (!wlc->pub->up)
+		return;
+
+	/* wait for at least one beacon before entering sleeping state */
+	for (idx = 0; idx < BRCMS_MAXBSSCFG; idx++) {
+		cfg = wlc->bsscfg[idx];
+		if (cfg && BSSCFG_STA(cfg) && cfg->associated)
+			cfg->PMawakebcn = true;
+	}
+	brcms_c_set_ps_ctrl(wlc);
+
+	/* band-specific initializations */
+	brcms_c_bsinit(wlc);
+}
+
 void brcms_c_set_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 {
 	uint bandunit;
@@ -3883,126 +3899,6 @@ static void brcms_c_ht_update_ldpc(struct brcms_c_info *wlc, s8 val)
 }
 
 /*
- * ucode, hwmac update
- *    Channel dependent updates for ucode and hw
- */
-static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc)
-{
-	/* enable or disable any active IBSSs depending on whether or not
-	 * we are on the home channel
-	 */
-	if (wlc->home_chanspec == BRCMS_BAND_PI_RADIO_CHANSPEC) {
-		if (wlc->pub->associated) {
-			/*
-			 * BMAC_NOTE: This is something that should be fixed
-			 * in ucode inits. I think that the ucode inits set
-			 * up the bcn templates and shm values with a bogus
-			 * beacon. This should not be done in the inits. If
-			 * ucode needs to set up a beacon for testing, the
-			 * test routines should write it down, not expect the
-			 * inits to populate a bogus beacon.
-			 */
-			if (BRCMS_PHY_11N_CAP(wlc->band))
-				brcms_c_write_shm(wlc, M_BCN_TXTSF_OFFSET,
-					      wlc->band->bcntsfoff);
-		}
-	} else {
-		/* disable an active IBSS if we are not on the home channel */
-	}
-
-	/* update the various promisc bits */
-	brcms_c_mac_bcn_promisc(wlc);
-	brcms_c_mac_promisc(wlc);
-}
-
-static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
-				     u16 chanspec)
-{
-	struct brcms_c_rateset default_rateset;
-	uint parkband;
-	uint i, band_order[2];
-
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
-	/*
-	 * We might have been bandlocked during down and the chip
-	 * power-cycled (hibernate). Figure out the right band to park on
-	 */
-	if (wlc->bandlocked || NBANDS(wlc) == 1) {
-		/* updated in brcms_c_bandlock() */
-		parkband = wlc->band->bandunit;
-		band_order[0] = band_order[1] = parkband;
-	} else {
-		/* park on the band of the specified chanspec */
-		parkband = CHSPEC_BANDUNIT(chanspec);
-
-		/* order so that parkband initialize last */
-		band_order[0] = parkband ^ 1;
-		band_order[1] = parkband;
-	}
-
-	/* make each band operational, software state init */
-	for (i = 0; i < NBANDS(wlc); i++) {
-		uint j = band_order[i];
-
-		wlc->band = wlc->bandstate[j];
-
-		brcms_default_rateset(wlc, &default_rateset);
-
-		/* fill in hw_rate */
-		brcms_c_rateset_filter(&default_rateset, &wlc->band->hw_rateset,
-				   false, BRCMS_RATES_CCK_OFDM, BRCMS_RATE_MASK,
-				   (bool) N_ENAB(wlc->pub));
-
-		/* init basic rate lookup */
-		brcms_c_rate_lookup_init(wlc, &default_rateset);
-	}
-
-	/* sync up phy/radio chanspec */
-	brcms_c_set_phy_chanspec(wlc, chanspec);
-}
-
-/* band-specific init */
-static void brcms_c_bsinit(struct brcms_c_info *wlc)
-{
-	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n",
-		 wlc->pub->unit, wlc->band->bandunit);
-
-	/* write ucode ACK/CTS rate table */
-	brcms_c_set_ratetable(wlc);
-
-	/* update some band specific mac configuration */
-	brcms_c_ucode_mac_upd(wlc);
-
-	/* init antenna selection */
-	brcms_c_antsel_init(wlc->asi);
-
-}
-
-/* switch to and initialize new band */
-static void brcms_c_setband(struct brcms_c_info *wlc,
-					   uint bandunit)
-{
-	int idx;
-	struct brcms_bss_cfg *cfg;
-
-	wlc->band = wlc->bandstate[bandunit];
-
-	if (!wlc->pub->up)
-		return;
-
-	/* wait for at least one beacon before entering sleeping state */
-	for (idx = 0; idx < BRCMS_MAXBSSCFG; idx++) {
-		cfg = wlc->bsscfg[idx];
-		if (cfg && BSSCFG_STA(cfg) && cfg->associated)
-			cfg->PMawakebcn = true;
-	}
-	brcms_c_set_ps_ctrl(wlc);
-
-	/* band-specific initializations */
-	brcms_c_bsinit(wlc);
-}
-
-/*
  * Initialize a WME Parameter Info Element with default
  * STA parameters from WMM Spec, Table 12
  */
@@ -4142,68 +4038,275 @@ void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 
 }
 
-bool brcms_c_timers_init(struct brcms_c_info *wlc, int unit)
+/* maintain LED behavior in down state */
+static void brcms_c_down_led_upd(struct brcms_c_info *wlc)
 {
-	wlc->wdtimer = brcms_init_timer(wlc->wl, brcms_c_watchdog_by_timer,
-		wlc, "watchdog");
-	if (!wlc->wdtimer) {
-		wiphy_err(wlc->wiphy, "wl%d:  wl_init_timer for wdtimer "
-			  "failed\n", unit);
-		goto fail;
-	}
+	/*
+	 * maintain LEDs while in down state, turn on sbclk if
+	 * not available yet. Turn on sbclk if necessary
+	 */
+	if (!AP_ENAB(wlc->pub)) {
+		brcms_c_pllreq(wlc, true, BRCMS_PLLREQ_FLIP);
 
-	wlc->radio_timer = brcms_init_timer(wlc->wl, brcms_c_radio_timer,
-		wlc, "radio");
-	if (!wlc->radio_timer) {
-		wiphy_err(wlc->wiphy, "wl%d:  wl_init_timer for radio_timer "
-			  "failed\n", unit);
-		goto fail;
+		brcms_c_pllreq(wlc, false, BRCMS_PLLREQ_FLIP);
 	}
+}
 
-	return true;
+static bool brcms_c_radio_monitor_start(struct brcms_c_info *wlc)
+{
+	/* Don't start the timer if HWRADIO feature is disabled */
+	if (wlc->radio_monitor || (wlc->pub->wlfeatureflag & WL_SWFL_NOHWRADIO))
+		return true;
 
- fail:
-	return false;
+	wlc->radio_monitor = true;
+	brcms_c_pllreq(wlc, true, BRCMS_PLLREQ_RADIO_MON);
+	brcms_add_timer(wlc->wl, wlc->radio_timer, TIMER_INTERVAL_RADIOCHK,
+			true);
+	return true;
 }
 
-/*
- * Initialize brcms_c_info default values ...
- * may get overrides later in this function
- */
-void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
+void brcms_c_radio_disable(struct brcms_c_info *wlc)
 {
-	int i;
-	/* Assume the device is there until proven otherwise */
-	wlc->device_present = true;
-
-	/* Save our copy of the chanspec */
-	wlc->chanspec = CH20MHZ_CHSPEC(1);
+	if (!wlc->pub->up) {
+		brcms_c_down_led_upd(wlc);
+		return;
+	}
 
-	/* various 802.11g modes */
-	wlc->shortslot = false;
-	wlc->shortslot_override = BRCMS_SHORTSLOT_AUTO;
+	brcms_c_radio_monitor_start(wlc);
+	brcms_down(wlc->wl);
+}
 
-	brcms_c_protection_upd(wlc, BRCMS_PROT_G_OVR, BRCMS_PROTECTION_AUTO);
-	brcms_c_protection_upd(wlc, BRCMS_PROT_G_SPEC, false);
+static void brcms_c_radio_enable(struct brcms_c_info *wlc)
+{
+	if (wlc->pub->up)
+		return;
 
-	brcms_c_protection_upd(wlc, BRCMS_PROT_N_CFG_OVR,
-			       BRCMS_PROTECTION_AUTO);
-	brcms_c_protection_upd(wlc, BRCMS_PROT_N_CFG, BRCMS_N_PROTECTION_OFF);
-	brcms_c_protection_upd(wlc, BRCMS_PROT_N_NONGF_OVR,
-			       BRCMS_PROTECTION_AUTO);
-	brcms_c_protection_upd(wlc, BRCMS_PROT_N_NONGF, false);
-	brcms_c_protection_upd(wlc, BRCMS_PROT_N_PAM_OVR, AUTO);
+	if (DEVICEREMOVED(wlc))
+		return;
 
-	brcms_c_protection_upd(wlc, BRCMS_PROT_OVERLAP,
-			       BRCMS_PROTECTION_CTL_OVERLAP);
+	brcms_up(wlc->wl);
+}
 
-	/* 802.11g draft 4.0 NonERP elt advertisement */
-	wlc->include_legacy_erp = true;
+bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc)
+{
+	if (!wlc->radio_monitor)
+		return true;
 
-	wlc->stf->ant_rx_ovr = ANT_RX_DIV_DEF;
-	wlc->stf->txant = ANT_TX_DEF;
+	wlc->radio_monitor = false;
+	brcms_c_pllreq(wlc, false, BRCMS_PLLREQ_RADIO_MON);
+	return brcms_del_timer(wlc->wl, wlc->radio_timer);
+}
 
-	wlc->prb_resp_timeout = BRCMS_PRB_RESP_TIMEOUT;
+/* read hwdisable state and propagate to wlc flag */
+static void brcms_c_radio_hwdisable_upd(struct brcms_c_info *wlc)
+{
+	if (wlc->pub->wlfeatureflag & WL_SWFL_NOHWRADIO || wlc->pub->hw_off)
+		return;
+
+	if (brcms_b_radio_read_hwdisabled(wlc->hw))
+		mboolset(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE);
+	else
+		mboolclr(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE);
+}
+
+/*
+ * centralized radio disable/enable function,
+ * invoke radio enable/disable after updating hwradio status
+ */
+static void brcms_c_radio_upd(struct brcms_c_info *wlc)
+{
+	if (wlc->pub->radio_disabled)
+		brcms_c_radio_disable(wlc);
+	else
+		brcms_c_radio_enable(wlc);
+}
+
+/* update hwradio status and return it */
+bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc)
+{
+	brcms_c_radio_hwdisable_upd(wlc);
+
+	return mboolisset(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE) ?
+			true : false;
+}
+
+/* periodical query hw radio button while driver is "down" */
+static void brcms_c_radio_timer(void *arg)
+{
+	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
+
+	if (DEVICEREMOVED(wlc)) {
+		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
+			__func__);
+		brcms_down(wlc->wl);
+		return;
+	}
+
+	/* cap mpc off count */
+	if (wlc->mpc_offcnt < BRCMS_MPC_MAX_DELAYCNT)
+		wlc->mpc_offcnt++;
+
+	brcms_c_radio_hwdisable_upd(wlc);
+	brcms_c_radio_upd(wlc);
+}
+
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
+/* common watchdog code */
+static void brcms_c_watchdog(void *arg)
+{
+	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
+	int i;
+	struct brcms_bss_cfg *cfg;
+
+	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
+
+	if (!wlc->pub->up)
+		return;
+
+	if (DEVICEREMOVED(wlc)) {
+		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
+			  __func__);
+		brcms_down(wlc->wl);
+		return;
+	}
+
+	/* increment second count */
+	wlc->pub->now++;
+
+	/* delay radio disable */
+	if (wlc->mpc_delay_off) {
+		if (--wlc->mpc_delay_off == 0) {
+			mboolset(wlc->pub->radio_disabled,
+				 WL_RADIO_MPC_DISABLE);
+			if (wlc->mpc && brcms_c_ismpc(wlc))
+				wlc->mpc_offcnt = 0;
+			wlc->mpc_laston_ts = OSL_SYSUPTIME();
+		}
+	}
+
+	/* mpc sync */
+	brcms_c_radio_mpc_upd(wlc);
+	/* radio sync: sw/hw/mpc --> radio_disable/radio_enable */
+	brcms_c_radio_hwdisable_upd(wlc);
+	brcms_c_radio_upd(wlc);
+	/* if radio is disable, driver may be down, quit here */
+	if (wlc->pub->radio_disabled)
+		return;
+
+	brcms_b_watchdog(wlc);
+
+	/*
+	 * occasionally sample mac stat counters to
+	 * detect 16-bit counter wrap
+	 */
+	if ((wlc->pub->now % SW_TIMER_MAC_STAT_UPD) == 0)
+		brcms_c_statsupd(wlc);
+
+	/* Manage TKIP countermeasures timers */
+	FOREACH_BSS(wlc, i, cfg)
+		if (cfg->tk_cm_dt)
+			cfg->tk_cm_dt--;
+		if (cfg->tk_cm_bt)
+			cfg->tk_cm_bt--;
+	END_FOREACH_BSS()
+
+	if (BRCMS_ISNPHY(wlc->band) && !wlc->pub->tempsense_disable &&
+	    ((wlc->pub->now - wlc->tempsense_lasttime) >=
+	     BRCMS_TEMPSENSE_PERIOD)) {
+		wlc->tempsense_lasttime = wlc->pub->now;
+		brcms_c_tempsense_upd(wlc);
+	}
+}
+
+static void brcms_c_watchdog_by_timer(void *arg)
+{
+	brcms_c_watchdog(arg);
+}
+
+bool brcms_c_timers_init(struct brcms_c_info *wlc, int unit)
+{
+	wlc->wdtimer = brcms_init_timer(wlc->wl, brcms_c_watchdog_by_timer,
+		wlc, "watchdog");
+	if (!wlc->wdtimer) {
+		wiphy_err(wlc->wiphy, "wl%d:  wl_init_timer for wdtimer "
+			  "failed\n", unit);
+		goto fail;
+	}
+
+	wlc->radio_timer = brcms_init_timer(wlc->wl, brcms_c_radio_timer,
+		wlc, "radio");
+	if (!wlc->radio_timer) {
+		wiphy_err(wlc->wiphy, "wl%d:  wl_init_timer for radio_timer "
+			  "failed\n", unit);
+		goto fail;
+	}
+
+	return true;
+
+ fail:
+	return false;
+}
+
+/*
+ * Initialize brcms_c_info default values ...
+ * may get overrides later in this function
+ */
+void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
+{
+	int i;
+	/* Assume the device is there until proven otherwise */
+	wlc->device_present = true;
+
+	/* Save our copy of the chanspec */
+	wlc->chanspec = CH20MHZ_CHSPEC(1);
+
+	/* various 802.11g modes */
+	wlc->shortslot = false;
+	wlc->shortslot_override = BRCMS_SHORTSLOT_AUTO;
+
+	brcms_c_protection_upd(wlc, BRCMS_PROT_G_OVR, BRCMS_PROTECTION_AUTO);
+	brcms_c_protection_upd(wlc, BRCMS_PROT_G_SPEC, false);
+
+	brcms_c_protection_upd(wlc, BRCMS_PROT_N_CFG_OVR,
+			       BRCMS_PROTECTION_AUTO);
+	brcms_c_protection_upd(wlc, BRCMS_PROT_N_CFG, BRCMS_N_PROTECTION_OFF);
+	brcms_c_protection_upd(wlc, BRCMS_PROT_N_NONGF_OVR,
+			       BRCMS_PROTECTION_AUTO);
+	brcms_c_protection_upd(wlc, BRCMS_PROT_N_NONGF, false);
+	brcms_c_protection_upd(wlc, BRCMS_PROT_N_PAM_OVR, AUTO);
+
+	brcms_c_protection_upd(wlc, BRCMS_PROT_OVERLAP,
+			       BRCMS_PROTECTION_CTL_OVERLAP);
+
+	/* 802.11g draft 4.0 NonERP elt advertisement */
+	wlc->include_legacy_erp = true;
+
+	wlc->stf->ant_rx_ovr = ANT_RX_DIV_DEF;
+	wlc->stf->txant = ANT_TX_DEF;
+
+	wlc->prb_resp_timeout = BRCMS_PRB_RESP_TIMEOUT;
 
 	wlc->usr_fragthresh = DOT11_DEFAULT_FRAG_LEN;
 	for (i = 0; i < NFIFO; i++)
@@ -4637,28 +4740,210 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	return err;
 }
 
-/*
- * The common driver entry routine. Error codes should be unique
- */
-struct brcms_c_info *
-brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
-	       bool piomode, void *regsva, struct pci_dev *btparam, uint *perr)
+static void brcms_c_attach_antgain_init(struct brcms_c_info *wlc)
 {
-	struct brcms_c_info *wlc;
-	uint err = 0;
-	uint j;
-	struct brcms_pub *pub;
-	uint n_disabled;
+	uint unit;
+	unit = wlc->pub->unit;
 
-	/* allocate struct brcms_c_info state and its substructures */
-	wlc = (struct brcms_c_info *) brcms_c_attach_malloc(unit, &err, device);
-	if (wlc == NULL)
-		goto fail;
-	wlc->wiphy = wl->wiphy;
-	pub = wlc->pub;
+	if ((wlc->band->antgain == -1) && (wlc->pub->sromrev == 1)) {
+		/* default antenna gain for srom rev 1 is 2 dBm (8 qdbm) */
+		wlc->band->antgain = 8;
+	} else if (wlc->band->antgain == -1) {
+		wiphy_err(wlc->wiphy, "wl%d: %s: Invalid antennas available in"
+			  " srom, using 2dB\n", unit, __func__);
+		wlc->band->antgain = 8;
+	} else {
+		s8 gain, fract;
+		/* Older sroms specified gain in whole dbm only.  In order
+		 * be able to specify qdbm granularity and remain backward
+		 * compatible the whole dbms are now encoded in only
+		 * low 6 bits and remaining qdbms are encoded in the hi 2 bits.
+		 * 6 bit signed number ranges from -32 - 31.
+		 *
+		 * Examples:
+		 * 0x1 = 1 db,
+		 * 0xc1 = 1.75 db (1 + 3 quarters),
+		 * 0x3f = -1 (-1 + 0 quarters),
+		 * 0x7f = -.75 (-1 + 1 quarters) = -3 qdbm.
+		 * 0xbf = -.50 (-1 + 2 quarters) = -2 qdbm.
+		 */
+		gain = wlc->band->antgain & 0x3f;
+		gain <<= 2;	/* Sign extend */
+		gain >>= 2;
+		fract = (wlc->band->antgain & 0xc0) >> 6;
+		wlc->band->antgain = 4 * gain + fract;
+	}
+}
 
-#if defined(BCMDBG)
-	wlc_info_dbg = wlc;
+static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc)
+{
+	int aa;
+	uint unit;
+	char *vars;
+	int bandtype;
+
+	unit = wlc->pub->unit;
+	vars = wlc->pub->vars;
+	bandtype = wlc->band->bandtype;
+
+	/* get antennas available */
+	aa = (s8) getintvar(vars, (BAND_5G(bandtype) ? "aa5g" : "aa2g"));
+	if (aa == 0)
+		aa = (s8) getintvar(vars,
+				      (BAND_5G(bandtype) ? "aa1" : "aa0"));
+	if ((aa < 1) || (aa > 15)) {
+		wiphy_err(wlc->wiphy, "wl%d: %s: Invalid antennas available in"
+			  " srom (0x%x), using 3\n", unit, __func__, aa);
+		aa = 3;
+	}
+
+	/* reset the defaults if we have a single antenna */
+	if (aa == 1) {
+		wlc->stf->ant_rx_ovr = ANT_RX_DIV_FORCE_0;
+		wlc->stf->txant = ANT_TX_FORCE_0;
+	} else if (aa == 2) {
+		wlc->stf->ant_rx_ovr = ANT_RX_DIV_FORCE_1;
+		wlc->stf->txant = ANT_TX_FORCE_1;
+	} else {
+	}
+
+	/* Compute Antenna Gain */
+	wlc->band->antgain =
+	    (s8) getintvar(vars, (BAND_5G(bandtype) ? "ag1" : "ag0"));
+	brcms_c_attach_antgain_init(wlc);
+
+	return true;
+}
+
+static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
+{
+	u16 chanspec;
+	struct brcms_band *band;
+	struct brcms_bss_info *bi = wlc->default_bss;
+
+	/* init default and target BSS with some sane initial values */
+	memset((char *)(bi), 0, sizeof(struct brcms_bss_info));
+	bi->beacon_period = BEACON_INTERVAL_DEFAULT;
+	bi->dtim_period = DTIM_INTERVAL_DEFAULT;
+
+	/* fill the default channel as the first valid channel
+	 * starting from the 2G channels
+	 */
+	chanspec = CH20MHZ_CHSPEC(1);
+	wlc->home_chanspec = bi->chanspec = chanspec;
+
+	/* find the band of our default channel */
+	band = wlc->band;
+	if (NBANDS(wlc) > 1 && band->bandunit != CHSPEC_BANDUNIT(chanspec))
+		band = wlc->bandstate[OTHERBANDUNIT(wlc)];
+
+	/* init bss rates to the band specific default rate set */
+	brcms_c_rateset_default(&bi->rateset, NULL, band->phytype,
+		band->bandtype, false, BRCMS_RATE_MASK_FULL,
+		(bool) N_ENAB(wlc->pub), CHSPEC_WLC_BW(chanspec),
+		wlc->stf->txstreams);
+
+	if (N_ENAB(wlc->pub))
+		bi->flags |= BRCMS_BSS_HT;
+}
+
+static struct brcms_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc)
+{
+	struct brcms_txq_info *qi, *p;
+
+	qi = kzalloc(sizeof(struct brcms_txq_info), GFP_ATOMIC);
+	if (qi != NULL) {
+		/*
+		 * Have enough room for control packets along with HI watermark
+		 * Also, add room to txq for total psq packets if all the SCBs
+		 * leave PS mode. The watermark for flowcontrol to OS packets
+		 * will remain the same
+		 */
+		brcmu_pktq_init(&qi->q, BRCMS_PREC_COUNT,
+			  (2 * wlc->pub->tunables->datahiwat) + PKTQ_LEN_DEFAULT
+			  + wlc->pub->psq_pkts_total);
+
+		/* add this queue to the the global list */
+		p = wlc->tx_queues;
+		if (p == NULL) {
+			wlc->tx_queues = qi;
+		} else {
+			while (p->next != NULL)
+				p = p->next;
+			p->next = qi;
+		}
+	}
+	return qi;
+}
+
+static void brcms_c_txq_free(struct brcms_c_info *wlc,
+			     struct brcms_txq_info *qi)
+{
+	struct brcms_txq_info *p;
+
+	if (qi == NULL)
+		return;
+
+	/* remove the queue from the linked list */
+	p = wlc->tx_queues;
+	if (p == qi)
+		wlc->tx_queues = p->next;
+	else {
+		while (p != NULL && p->next != qi)
+			p = p->next;
+		if (p != NULL)
+			p->next = p->next->next;
+	}
+
+	kfree(qi);
+}
+
+static void brcms_c_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap)
+{
+	uint i;
+	struct brcms_band *band;
+
+	for (i = 0; i < NBANDS(wlc); i++) {
+		if (IS_SINGLEBAND_5G(wlc->deviceid))
+			i = BAND_5G_INDEX;
+		band = wlc->bandstate[i];
+		if (band->bandtype == BRCM_BAND_5G) {
+			if ((bwcap == BRCMS_N_BW_40ALL)
+			    || (bwcap == BRCMS_N_BW_20IN2G_40IN5G))
+				band->mimo_cap_40 = true;
+			else
+				band->mimo_cap_40 = false;
+		} else {
+			if (bwcap == BRCMS_N_BW_40ALL)
+				band->mimo_cap_40 = true;
+			else
+				band->mimo_cap_40 = false;
+		}
+	}
+}
+
+/*
+ * The common driver entry routine. Error codes should be unique
+ */
+struct brcms_c_info *
+brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
+	       bool piomode, void *regsva, struct pci_dev *btparam, uint *perr)
+{
+	struct brcms_c_info *wlc;
+	uint err = 0;
+	uint j;
+	struct brcms_pub *pub;
+	uint n_disabled;
+
+	/* allocate struct brcms_c_info state and its substructures */
+	wlc = (struct brcms_c_info *) brcms_c_attach_malloc(unit, &err, device);
+	if (wlc == NULL)
+		goto fail;
+	wlc->wiphy = wl->wiphy;
+	pub = wlc->pub;
+
+#if defined(BCMDBG)
+	wlc_info_dbg = wlc;
 #endif
 
 	wlc->band = wlc->bandstate[0];
@@ -4893,82 +5178,6 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	return NULL;
 }
 
-static void brcms_c_attach_antgain_init(struct brcms_c_info *wlc)
-{
-	uint unit;
-	unit = wlc->pub->unit;
-
-	if ((wlc->band->antgain == -1) && (wlc->pub->sromrev == 1)) {
-		/* default antenna gain for srom rev 1 is 2 dBm (8 qdbm) */
-		wlc->band->antgain = 8;
-	} else if (wlc->band->antgain == -1) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: Invalid antennas available in"
-			  " srom, using 2dB\n", unit, __func__);
-		wlc->band->antgain = 8;
-	} else {
-		s8 gain, fract;
-		/* Older sroms specified gain in whole dbm only.  In order
-		 * be able to specify qdbm granularity and remain backward
-		 * compatible the whole dbms are now encoded in only
-		 * low 6 bits and remaining qdbms are encoded in the hi 2 bits.
-		 * 6 bit signed number ranges from -32 - 31.
-		 *
-		 * Examples:
-		 * 0x1 = 1 db,
-		 * 0xc1 = 1.75 db (1 + 3 quarters),
-		 * 0x3f = -1 (-1 + 0 quarters),
-		 * 0x7f = -.75 (-1 + 1 quarters) = -3 qdbm.
-		 * 0xbf = -.50 (-1 + 2 quarters) = -2 qdbm.
-		 */
-		gain = wlc->band->antgain & 0x3f;
-		gain <<= 2;	/* Sign extend */
-		gain >>= 2;
-		fract = (wlc->band->antgain & 0xc0) >> 6;
-		wlc->band->antgain = 4 * gain + fract;
-	}
-}
-
-static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc)
-{
-	int aa;
-	uint unit;
-	char *vars;
-	int bandtype;
-
-	unit = wlc->pub->unit;
-	vars = wlc->pub->vars;
-	bandtype = wlc->band->bandtype;
-
-	/* get antennas available */
-	aa = (s8) getintvar(vars, (BAND_5G(bandtype) ? "aa5g" : "aa2g"));
-	if (aa == 0)
-		aa = (s8) getintvar(vars,
-				      (BAND_5G(bandtype) ? "aa1" : "aa0"));
-	if ((aa < 1) || (aa > 15)) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: Invalid antennas available in"
-			  " srom (0x%x), using 3\n", unit, __func__, aa);
-		aa = 3;
-	}
-
-	/* reset the defaults if we have a single antenna */
-	if (aa == 1) {
-		wlc->stf->ant_rx_ovr = ANT_RX_DIV_FORCE_0;
-		wlc->stf->txant = ANT_TX_FORCE_0;
-	} else if (aa == 2) {
-		wlc->stf->ant_rx_ovr = ANT_RX_DIV_FORCE_1;
-		wlc->stf->txant = ANT_TX_FORCE_1;
-	} else {
-	}
-
-	/* Compute Antenna Gain */
-	wlc->band->antgain =
-	    (s8) getintvar(vars, (BAND_5G(bandtype) ? "ag1" : "ag0"));
-	brcms_c_attach_antgain_init(wlc);
-
-	return true;
-}
-
-
 static void brcms_c_timers_deinit(struct brcms_c_info *wlc)
 {
 	/* free timer state */
@@ -5102,26 +5311,14 @@ void brcms_c_ap_upd(struct brcms_c_info *wlc)
 	wlc->mpc = true;
 }
 
-/* read hwdisable state and propagate to wlc flag */
-static void brcms_c_radio_hwdisable_upd(struct brcms_c_info *wlc)
+/*
+ * return true if Minimum Power Consumption should
+ * be entered, false otherwise
+ */
+bool brcms_c_is_non_delay_mpc(struct brcms_c_info *wlc)
 {
-	if (wlc->pub->wlfeatureflag & WL_SWFL_NOHWRADIO || wlc->pub->hw_off)
-		return;
-
-	if (brcms_b_radio_read_hwdisabled(wlc->hw))
-		mboolset(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE);
-	else
-		mboolclr(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE);
-}
-
-/*
- * return true if Minimum Power Consumption should
- * be entered, false otherwise
- */
-bool brcms_c_is_non_delay_mpc(struct brcms_c_info *wlc)
-{
-	return false;
-}
+	return false;
+}
 
 bool brcms_c_ismpc(struct brcms_c_info *wlc)
 {
@@ -5182,202 +5379,6 @@ void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
 
 	wlc->prev_non_delay_mpc = brcms_c_is_non_delay_mpc(wlc);
 }
-
-/*
- * centralized radio disable/enable function,
- * invoke radio enable/disable after updating hwradio status
- */
-static void brcms_c_radio_upd(struct brcms_c_info *wlc)
-{
-	if (wlc->pub->radio_disabled)
-		brcms_c_radio_disable(wlc);
-	else
-		brcms_c_radio_enable(wlc);
-}
-
-/* maintain LED behavior in down state */
-static void brcms_c_down_led_upd(struct brcms_c_info *wlc)
-{
-	/*
-	 * maintain LEDs while in down state, turn on sbclk if
-	 * not available yet. Turn on sbclk if necessary
-	 */
-	if (!AP_ENAB(wlc->pub)) {
-		brcms_c_pllreq(wlc, true, BRCMS_PLLREQ_FLIP);
-
-		brcms_c_pllreq(wlc, false, BRCMS_PLLREQ_FLIP);
-	}
-}
-
-/* update hwradio status and return it */
-bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc)
-{
-	brcms_c_radio_hwdisable_upd(wlc);
-
-	return mboolisset(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE) ?
-			true : false;
-}
-
-void brcms_c_radio_disable(struct brcms_c_info *wlc)
-{
-	if (!wlc->pub->up) {
-		brcms_c_down_led_upd(wlc);
-		return;
-	}
-
-	brcms_c_radio_monitor_start(wlc);
-	brcms_down(wlc->wl);
-}
-
-static void brcms_c_radio_enable(struct brcms_c_info *wlc)
-{
-	if (wlc->pub->up)
-		return;
-
-	if (DEVICEREMOVED(wlc))
-		return;
-
-	brcms_up(wlc->wl);
-}
-
-/* periodical query hw radio button while driver is "down" */
-static void brcms_c_radio_timer(void *arg)
-{
-	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
-
-	if (DEVICEREMOVED(wlc)) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
-			__func__);
-		brcms_down(wlc->wl);
-		return;
-	}
-
-	/* cap mpc off count */
-	if (wlc->mpc_offcnt < BRCMS_MPC_MAX_DELAYCNT)
-		wlc->mpc_offcnt++;
-
-	brcms_c_radio_hwdisable_upd(wlc);
-	brcms_c_radio_upd(wlc);
-}
-
-static bool brcms_c_radio_monitor_start(struct brcms_c_info *wlc)
-{
-	/* Don't start the timer if HWRADIO feature is disabled */
-	if (wlc->radio_monitor || (wlc->pub->wlfeatureflag & WL_SWFL_NOHWRADIO))
-		return true;
-
-	wlc->radio_monitor = true;
-	brcms_c_pllreq(wlc, true, BRCMS_PLLREQ_RADIO_MON);
-	brcms_add_timer(wlc->wl, wlc->radio_timer, TIMER_INTERVAL_RADIOCHK,
-			true);
-	return true;
-}
-
-bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc)
-{
-	if (!wlc->radio_monitor)
-		return true;
-
-	wlc->radio_monitor = false;
-	brcms_c_pllreq(wlc, false, BRCMS_PLLREQ_RADIO_MON);
-	return brcms_del_timer(wlc->wl, wlc->radio_timer);
-}
-
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
-static void brcms_c_watchdog_by_timer(void *arg)
-{
-	brcms_c_watchdog(arg);
-}
-
-/* common watchdog code */
-static void brcms_c_watchdog(void *arg)
-{
-	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
-	int i;
-	struct brcms_bss_cfg *cfg;
-
-	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
-
-	if (!wlc->pub->up)
-		return;
-
-	if (DEVICEREMOVED(wlc)) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
-			  __func__);
-		brcms_down(wlc->wl);
-		return;
-	}
-
-	/* increment second count */
-	wlc->pub->now++;
-
-	/* delay radio disable */
-	if (wlc->mpc_delay_off) {
-		if (--wlc->mpc_delay_off == 0) {
-			mboolset(wlc->pub->radio_disabled,
-				 WL_RADIO_MPC_DISABLE);
-			if (wlc->mpc && brcms_c_ismpc(wlc))
-				wlc->mpc_offcnt = 0;
-			wlc->mpc_laston_ts = OSL_SYSUPTIME();
-		}
-	}
-
-	/* mpc sync */
-	brcms_c_radio_mpc_upd(wlc);
-	/* radio sync: sw/hw/mpc --> radio_disable/radio_enable */
-	brcms_c_radio_hwdisable_upd(wlc);
-	brcms_c_radio_upd(wlc);
-	/* if radio is disable, driver may be down, quit here */
-	if (wlc->pub->radio_disabled)
-		return;
-
-	brcms_b_watchdog(wlc);
-
-	/*
-	 * occasionally sample mac stat counters to
-	 * detect 16-bit counter wrap
-	 */
-	if ((wlc->pub->now % SW_TIMER_MAC_STAT_UPD) == 0)
-		brcms_c_statsupd(wlc);
-
-	/* Manage TKIP countermeasures timers */
-	FOREACH_BSS(wlc, i, cfg)
-		if (cfg->tk_cm_dt)
-			cfg->tk_cm_dt--;
-		if (cfg->tk_cm_bt)
-			cfg->tk_cm_bt--;
-	END_FOREACH_BSS()
-
-	if (BRCMS_ISNPHY(wlc->band) && !wlc->pub->tempsense_disable &&
-	    ((wlc->pub->now - wlc->tempsense_lasttime) >=
-	     BRCMS_TEMPSENSE_PERIOD)) {
-		wlc->tempsense_lasttime = wlc->pub->now;
-		brcms_c_tempsense_upd(wlc);
-	}
-}
-
 /* Initialize just the hardware when coming out of POR or S3/S5 system states */
 void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 {
@@ -5478,6 +5479,23 @@ int brcms_b_up_finish(struct brcms_hardware *wlc_hw)
 	return 0;
 }
 
+/*
+ * Write WME tunable parameters for retransmit/max rate
+ * from wlc struct to ucode
+ */
+static void brcms_c_wme_retries_write(struct brcms_c_info *wlc)
+{
+	int ac;
+
+	/* Need clock to do this */
+	if (!wlc->clk)
+		return;
+
+	for (ac = 0; ac < AC_COUNT; ac++)
+		brcms_c_write_shm(wlc, M_AC_TXLMT_ADDR(ac),
+				  wlc->wme_retries[ac]);
+}
+
 /* make interface operational */
 int brcms_c_up(struct brcms_c_info *wlc)
 {
@@ -5586,30 +5604,6 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	return 0;
 }
 
-/*
- * Initialize the base precedence map for dequeueing
- * from txq based on WME settings
- */
-static void brcms_c_tx_prec_map_init(struct brcms_c_info *wlc)
-{
-	wlc->tx_prec_map = BRCMS_PREC_BMP_ALL;
-	memset(wlc->fifo2prec_map, 0, NFIFO * sizeof(u16));
-
-	/*
-	 * For non-WME, both fifos have overlapping MAXPRIO. So just
-	 * disable all precedences if either is full.
-	 */
-	if (!EDCF_ENAB(wlc->pub)) {
-		wlc->fifo2prec_map[TX_DATA_FIFO] = BRCMS_PREC_BMP_ALL;
-		wlc->fifo2prec_map[TX_CTL_FIFO] = BRCMS_PREC_BMP_ALL;
-	} else {
-		wlc->fifo2prec_map[TX_AC_BK_FIFO] = BRCMS_PREC_BMP_AC_BK;
-		wlc->fifo2prec_map[TX_AC_BE_FIFO] = BRCMS_PREC_BMP_AC_BE;
-		wlc->fifo2prec_map[TX_AC_VI_FIFO] = BRCMS_PREC_BMP_AC_VI;
-		wlc->fifo2prec_map[TX_AC_VO_FIFO] = BRCMS_PREC_BMP_AC_VO;
-	}
-}
-
 static uint brcms_c_down_del_timer(struct brcms_c_info *wlc)
 {
 	uint callbacks = 0;
@@ -6057,13 +6051,6 @@ static void brcms_c_ofdm_rateset_war(struct brcms_c_info *wlc)
 	return;
 }
 
-int
-brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
-	      struct brcms_c_if *wlcif)
-{
-	return _brcms_c_ioctl(wlc, cmd, arg, len, wlcif);
-}
-
 /* common ioctl handler. return: 0=ok, -1=error, positive=particular error */
 static int
 _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
@@ -6314,6 +6301,13 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 	return bcmerror;
 }
 
+int
+brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
+	      struct brcms_c_if *wlcif)
+{
+	return _brcms_c_ioctl(wlc, cmd, arg, len, wlcif);
+}
+
 /*
  * register watchdog and down handlers.
  */
@@ -6360,23 +6354,6 @@ int brcms_c_module_unregister(struct brcms_pub *pub, const char *name,
 	return -ENODATA;
 }
 
-/*
- * Write WME tunable parameters for retransmit/max rate
- * from wlc struct to ucode
- */
-static void brcms_c_wme_retries_write(struct brcms_c_info *wlc)
-{
-	int ac;
-
-	/* Need clock to do this */
-	if (!wlc->clk)
-		return;
-
-	for (ac = 0; ac < AC_COUNT; ac++)
-		brcms_c_write_shm(wlc, M_AC_TXLMT_ADDR(ac),
-				  wlc->wme_retries[ac]);
-}
-
 #ifdef BCMDBG
 static const char * const supr_reason[] = {
 	"None", "PMQ Entry", "Flush request",
@@ -6759,100 +6736,6 @@ void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
 	}
 }
 
-bool
-brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
-		     struct ieee80211_hw *hw)
-{
-	u8 prio;
-	uint fifo;
-	struct scb *scb = &global_scb;
-	struct ieee80211_hdr *d11_header = (struct ieee80211_hdr *)(sdu->data);
-
-	/*
-	 * 802.11 standard requires management traffic
-	 * to go at highest priority
-	 */
-	prio = ieee80211_is_data(d11_header->frame_control) ? sdu->priority :
-		MAXPRIO;
-	fifo = prio2fifo[prio];
-	if (unlikely
-	    (brcms_c_d11hdrs_mac80211(
-		wlc, hw, sdu, scb, 0, 1, fifo, 0, NULL, 0)))
-		return -EINVAL;
-	brcms_c_txq_enq(wlc, scb, sdu, BRCMS_PRIO_TO_PREC(prio));
-	brcms_c_send_q(wlc);
-	return 0;
-}
-
-void brcms_c_send_q(struct brcms_c_info *wlc)
-{
-	struct sk_buff *pkt[DOT11_MAXNUMFRAGS];
-	int prec;
-	u16 prec_map;
-	int err = 0, i, count;
-	uint fifo;
-	struct brcms_txq_info *qi = wlc->pkt_queue;
-	struct pktq *q = &qi->q;
-	struct ieee80211_tx_info *tx_info;
-
-	if (in_send_q)
-		return;
-	else
-		in_send_q = true;
-
-	prec_map = wlc->tx_prec_map;
-
-	/* Send all the enq'd pkts that we can.
-	 * Dequeue packets with precedence with empty HW fifo only
-	 */
-	while (prec_map && (pkt[0] = brcmu_pktq_mdeq(q, prec_map, &prec))) {
-		tx_info = IEEE80211_SKB_CB(pkt[0]);
-		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-			err = brcms_c_sendampdu(wlc->ampdu, qi, pkt, prec);
-		} else {
-			count = 1;
-			err = brcms_c_prep_pdu(wlc, pkt[0], &fifo);
-			if (!err) {
-				for (i = 0; i < count; i++)
-					brcms_c_txfifo(wlc, fifo, pkt[i], true,
-						       1);
-			}
-		}
-
-		if (err == -EBUSY) {
-			brcmu_pktq_penq_head(q, prec, pkt[0]);
-			/*
-			 * If send failed due to any other reason than a
-			 * change in HW FIFO condition, quit. Otherwise,
-			 * read the new prec_map!
-			 */
-			if (prec_map == wlc->tx_prec_map)
-				break;
-			prec_map = wlc->tx_prec_map;
-		}
-	}
-
-	/*
-	 * Check if flow control needs to be turned off after
-	 * sending the packet
-	 */
-	if (!EDCF_ENAB(wlc->pub)
-	    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL)) {
-		if (brcms_c_txflowcontrol_prio_isset(wlc, qi, ALLPRIO)
-		    && (pktq_len(q) < wlc->pub->tunables->datahiwat / 2))
-			brcms_c_txflowcontrol(wlc, qi, OFF, ALLPRIO);
-	} else if (wlc->pub->_priofc) {
-		int prio;
-		for (prio = MAXPRIO; prio >= 0; prio--) {
-			if (brcms_c_txflowcontrol_prio_isset(wlc, qi, prio) &&
-			    (pktq_plen(q, wlc_prio2prec_map[prio]) <
-			    wlc->pub->tunables->datahiwat / 2))
-				brcms_c_txflowcontrol(wlc, qi, OFF, prio);
-		}
-	}
-	in_send_q = false;
-}
-
 /*
  * bcmc_fid_generate:
  * Generate frame ID for a BCMC packet.  The frag field is not used
@@ -6874,347 +6757,264 @@ bcmc_fid_generate(struct brcms_c_info *wlc, struct brcms_bss_cfg *bsscfg,
 	return frameid;
 }
 
-void
-brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
-	       bool commit, s8 txpktpend)
+static uint
+brcms_c_calc_ack_time(struct brcms_c_info *wlc, u32 rspec,
+		      u8 preamble_type)
 {
-	u16 frameid = INVALIDFID;
-	struct d11txh *txh;
-
-	txh = (struct d11txh *) (p->data);
-
-	/* When a BC/MC frame is being committed to the BCMC fifo
-	 * via DMA (NOT PIO), update ucode or BSS info as appropriate.
-	 */
-	if (fifo == TX_BCMC_FIFO)
-		frameid = le16_to_cpu(txh->TxFrameID);
-
-	if (BRCMS_WAR16165(wlc))
-		brcms_c_war16165(wlc, true);
-
+	uint dur = 0;
 
+	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d\n",
+		wlc->pub->unit, rspec, preamble_type);
 	/*
-	 * Bump up pending count for if not using rpc. If rpc is
-	 * used, this will be handled in brcms_b_txfifo()
+	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
+	 * is less than or equal to the rate of the immediately previous
+	 * frame in the FES
 	 */
-	if (commit) {
-		TXPKTPENDINC(wlc, fifo, txpktpend);
-		BCMMSG(wlc->wiphy, "pktpend inc %d to %d\n",
-			 txpktpend, TXPKTPENDGET(wlc, fifo));
-	}
-
-	/* Commit BCMC sequence number in the SHM frame ID location */
-	if (frameid != INVALIDFID)
-		BCMCFID(wlc, frameid);
-
-	if (dma_txfast(wlc->hw->di[fifo], p, commit) < 0)
-		wiphy_err(wlc->wiphy, "txfifo: fatal, toss frames !!!\n");
+	rspec = BRCMS_BASIC_RATE(wlc, rspec);
+	/* ACK frame len == 14 == 2(fc) + 2(dur) + 6(ra) + 4(fcs) */
+	dur =
+	    brcms_c_calc_frame_time(wlc, rspec, preamble_type,
+				(DOT11_ACK_LEN + FCS_LEN));
+	return dur;
 }
 
-void
-brcms_c_compute_plcp(struct brcms_c_info *wlc, u32 rspec,
-		     uint length, u8 *plcp)
+static uint
+brcms_c_calc_cts_time(struct brcms_c_info *wlc, u32 rspec,
+		      u8 preamble_type)
 {
-	if (IS_MCS(rspec))
-		brcms_c_compute_mimo_plcp(rspec, length, plcp);
-	else if (IS_OFDM(rspec))
-		brcms_c_compute_ofdm_plcp(rspec, length, plcp);
-	else
-		brcms_c_compute_cck_plcp(wlc, rspec, length, plcp);
-	return;
+	BCMMSG(wlc->wiphy, "wl%d: ratespec 0x%x, preamble_type %d\n",
+		wlc->pub->unit, rspec, preamble_type);
+	return brcms_c_calc_ack_time(wlc, rspec, preamble_type);
 }
 
-/* Rate: 802.11 rate code, length: PSDU length in octets */
-static void brcms_c_compute_mimo_plcp(u32 rspec, uint length, u8 *plcp)
+static uint
+brcms_c_calc_ba_time(struct brcms_c_info *wlc, u32 rspec,
+		     u8 preamble_type)
 {
-	u8 mcs = (u8) (rspec & RSPEC_RATE_MASK);
-	plcp[0] = mcs;
-	if (RSPEC_IS40MHZ(rspec) || (mcs == 32))
-		plcp[0] |= MIMO_PLCP_40MHZ;
-	BRCMS_SET_MIMO_PLCP_LEN(plcp, length);
-	plcp[3] = RSPEC_MIMOPLCP3(rspec); /* rspec already holds this byte */
-	plcp[3] |= 0x7; /* set smoothing, not sounding ppdu & reserved */
-	plcp[4] = 0; /* number of extension spatial streams bit 0 & 1 */
-	plcp[5] = 0;
+	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, "
+		 "preamble_type %d\n", wlc->pub->unit, rspec, preamble_type);
+	/*
+	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
+	 * is less than or equal to the rate of the immediately previous
+	 * frame in the FES
+	 */
+	rspec = BRCMS_BASIC_RATE(wlc, rspec);
+	/* BA len == 32 == 16(ctl hdr) + 4(ba len) + 8(bitmap) + 4(fcs) */
+	return brcms_c_calc_frame_time(wlc, rspec, preamble_type,
+				   (DOT11_BA_LEN + DOT11_BA_BITMAP_LEN +
+				    FCS_LEN));
 }
 
-/* Rate: 802.11 rate code, length: PSDU length in octets */
-static void
-brcms_c_compute_ofdm_plcp(u32 rspec, u32 length, u8 *plcp)
+/* brcms_c_compute_frame_dur()
+ *
+ * Calculate the 802.11 MAC header DUR field for MPDU
+ * DUR for a single frame = 1 SIFS + 1 ACK
+ * DUR for a frame with following frags = 3 SIFS + 2 ACK + next frag time
+ *
+ * rate			MPDU rate in unit of 500kbps
+ * next_frag_len	next MPDU length in bytes
+ * preamble_type	use short/GF or long/MM PLCP header
+ */
+static u16
+brcms_c_compute_frame_dur(struct brcms_c_info *wlc, u32 rate,
+		      u8 preamble_type, uint next_frag_len)
 {
-	u8 rate_signal;
-	u32 tmp = 0;
-	int rate = RSPEC2RATE(rspec);
+	u16 dur, sifs;
 
-	/*
-	 * encode rate per 802.11a-1999 sec 17.3.4.1, with lsb
-	 * transmitted first
-	 */
-	rate_signal = rate_info[rate] & BRCMS_RATE_MASK;
-	memset(plcp, 0, D11_PHY_HDR_LEN);
-	D11A_PHY_HDR_SRATE((struct ofdm_phy_hdr *) plcp, rate_signal);
+	sifs = SIFS(wlc->band);
 
-	tmp = (length & 0xfff) << 5;
-	plcp[2] |= (tmp >> 16) & 0xff;
-	plcp[1] |= (tmp >> 8) & 0xff;
-	plcp[0] |= tmp & 0xff;
+	dur = sifs;
+	dur += (u16) brcms_c_calc_ack_time(wlc, rate, preamble_type);
 
-	return;
+	if (next_frag_len) {
+		/* Double the current DUR to get 2 SIFS + 2 ACKs */
+		dur *= 2;
+		/* add another SIFS and the frag time */
+		dur += sifs;
+		dur +=
+		    (u16) brcms_c_calc_frame_time(wlc, rate, preamble_type,
+						 next_frag_len);
+	}
+	return dur;
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
+/* The opposite of brcms_c_calc_frame_time */
+static uint
+brcms_c_calc_frame_len(struct brcms_c_info *wlc, u32 ratespec,
+		   u8 preamble_type, uint dur)
 {
-	u16 usec = 0;
-	u8 le = 0;
+	uint nsyms, mac_len, Ndps, kNdps;
+	uint rate = RSPEC2RATE(ratespec);
 
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
+	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d, dur %d\n",
+		 wlc->pub->unit, ratespec, preamble_type, dur);
 
-	default:
-		wiphy_err(wlc->wiphy,
-			  "brcms_c_cck_plcp_set: unsupported rate %d\n",
-			  rate_500);
-		rate_500 = BRCM_RATE_1M;
-		usec = length << 3;
-		break;
+	if (IS_MCS(ratespec)) {
+		uint mcs = ratespec & RSPEC_RATE_MASK;
+		int tot_streams = MCS_TXS(mcs) + RSPEC_STC(ratespec);
+		dur -= PREN_PREAMBLE + (tot_streams * PREN_PREAMBLE_EXT);
+		/* payload calculation matches that of regular ofdm */
+		if (BAND_2G(wlc->band->bandtype))
+			dur -= DOT11_OFDM_SIGNAL_EXTENSION;
+		/* kNdbps = kbps * 4 */
+		kNdps =
+		    MCS_RATE(mcs, RSPEC_IS40MHZ(ratespec),
+			     RSPEC_ISSGI(ratespec)) * 4;
+		nsyms = dur / APHY_SYMBOL_TIME;
+		mac_len =
+		    ((nsyms * kNdps) -
+		     ((APHY_SERVICE_NBITS + APHY_TAIL_NBITS) * 1000)) / 8000;
+	} else if (IS_OFDM(ratespec)) {
+		dur -= APHY_PREAMBLE_TIME;
+		dur -= APHY_SIGNAL_TIME;
+		/* Ndbps = Mbps * 4 = rate(500Kbps) * 2 */
+		Ndps = rate * 2;
+		nsyms = dur / APHY_SYMBOL_TIME;
+		mac_len =
+		    ((nsyms * Ndps) -
+		     (APHY_SERVICE_NBITS + APHY_TAIL_NBITS)) / 8;
+	} else {
+		if (preamble_type & BRCMS_SHORT_PREAMBLE)
+			dur -= BPHY_PLCP_SHORT_TIME;
+		else
+			dur -= BPHY_PLCP_TIME;
+		mac_len = dur * rate;
+		/* divide out factor of 2 in rate (1/2 mbps) */
+		mac_len = mac_len / 8 / 2;
 	}
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
+	return mac_len;
 }
 
-/* Rate: 802.11 rate code, length: PSDU length in octets */
-static void brcms_c_compute_cck_plcp(struct brcms_c_info *wlc, u32 rspec,
-				 uint length, u8 *plcp)
+static u32
+mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
+		       u32 int_val)
 {
-	int rate = RSPEC2RATE(rspec);
-
-	brcms_c_cck_plcp_set(wlc, rate, length, plcp);
-}
+	u8 stf = (int_val & NRATE_STF_MASK) >> NRATE_STF_SHIFT;
+	u8 rate = int_val & NRATE_RATE_MASK;
+	u32 rspec;
+	bool ismcs = ((int_val & NRATE_MCS_INUSE) == NRATE_MCS_INUSE);
+	bool issgi = ((int_val & NRATE_SGI_MASK) >> NRATE_SGI_SHIFT);
+	bool override_mcs_only = ((int_val & NRATE_OVERRIDE_MCS_ONLY)
+				  == NRATE_OVERRIDE_MCS_ONLY);
+	int bcmerror = 0;
 
-/* brcms_c_compute_frame_dur()
- *
- * Calculate the 802.11 MAC header DUR field for MPDU
- * DUR for a single frame = 1 SIFS + 1 ACK
- * DUR for a frame with following frags = 3 SIFS + 2 ACK + next frag time
- *
- * rate			MPDU rate in unit of 500kbps
- * next_frag_len	next MPDU length in bytes
- * preamble_type	use short/GF or long/MM PLCP header
- */
-static u16
-brcms_c_compute_frame_dur(struct brcms_c_info *wlc, u32 rate,
-		      u8 preamble_type, uint next_frag_len)
-{
-	u16 dur, sifs;
+	if (!ismcs)
+		return (u32) rate;
 
-	sifs = SIFS(wlc->band);
+	/* validate the combination of rate/mcs/stf is allowed */
+	if (N_ENAB(wlc->pub) && ismcs) {
+		/* mcs only allowed when nmode */
+		if (stf > PHY_TXC1_MODE_SDM) {
+			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid stf\n",
+				 BRCMS_UNIT(wlc), __func__);
+			bcmerror = -EINVAL;
+			goto done;
+		}
 
-	dur = sifs;
-	dur += (u16) brcms_c_calc_ack_time(wlc, rate, preamble_type);
+		/* mcs 32 is a special case, DUP mode 40 only */
+		if (rate == 32) {
+			if (!CHSPEC_IS40(wlc->home_chanspec) ||
+			    ((stf != PHY_TXC1_MODE_SISO)
+			     && (stf != PHY_TXC1_MODE_CDD))) {
+				wiphy_err(wlc->wiphy, "wl%d: %s: Invalid mcs "
+					  "32\n", BRCMS_UNIT(wlc), __func__);
+				bcmerror = -EINVAL;
+				goto done;
+			}
+			/* mcs > 7 must use stf SDM */
+		} else if (rate > HIGHEST_SINGLE_STREAM_MCS) {
+			/* mcs > 7 must use stf SDM */
+			if (stf != PHY_TXC1_MODE_SDM) {
+				BCMMSG(wlc->wiphy, "wl%d: enabling "
+					 "SDM mode for mcs %d\n",
+					 BRCMS_UNIT(wlc), rate);
+				stf = PHY_TXC1_MODE_SDM;
+			}
+		} else {
+			/*
+			 * MCS 0-7 may use SISO, CDD, and for
+			 * phy_rev >= 3 STBC
+			 */
+			if ((stf > PHY_TXC1_MODE_STBC) ||
+			    (!BRCMS_STBC_CAP_PHY(wlc)
+			     && (stf == PHY_TXC1_MODE_STBC))) {
+				wiphy_err(wlc->wiphy, "wl%d: %s: Invalid STBC"
+					  "\n", BRCMS_UNIT(wlc), __func__);
+				bcmerror = -EINVAL;
+				goto done;
+			}
+		}
+	} else if (IS_OFDM(rate)) {
+		if ((stf != PHY_TXC1_MODE_CDD) && (stf != PHY_TXC1_MODE_SISO)) {
+			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid OFDM\n",
+				  BRCMS_UNIT(wlc), __func__);
+			bcmerror = -EINVAL;
+			goto done;
+		}
+	} else if (IS_CCK(rate)) {
+		if ((cur_band->bandtype != BRCM_BAND_2G)
+		    || (stf != PHY_TXC1_MODE_SISO)) {
+			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid CCK\n",
+				  BRCMS_UNIT(wlc), __func__);
+			bcmerror = -EINVAL;
+			goto done;
+		}
+	} else {
+		wiphy_err(wlc->wiphy, "wl%d: %s: Unknown rate type\n",
+			  BRCMS_UNIT(wlc), __func__);
+		bcmerror = -EINVAL;
+		goto done;
+	}
+	/* make sure multiple antennae are available for non-siso rates */
+	if ((stf != PHY_TXC1_MODE_SISO) && (wlc->stf->txstreams == 1)) {
+		wiphy_err(wlc->wiphy, "wl%d: %s: SISO antenna but !SISO "
+			  "request\n", BRCMS_UNIT(wlc), __func__);
+		bcmerror = -EINVAL;
+		goto done;
+	}
 
-	if (next_frag_len) {
-		/* Double the current DUR to get 2 SIFS + 2 ACKs */
-		dur *= 2;
-		/* add another SIFS and the frag time */
-		dur += sifs;
-		dur +=
-		    (u16) brcms_c_calc_frame_time(wlc, rate, preamble_type,
-						 next_frag_len);
+	rspec = rate;
+	if (ismcs) {
+		rspec |= RSPEC_MIMORATE;
+		/* For STBC populate the STC field of the ratespec */
+		if (stf == PHY_TXC1_MODE_STBC) {
+			u8 stc;
+			stc = 1;	/* Nss for single stream is always 1 */
+			rspec |= (stc << RSPEC_STC_SHIFT);
+		}
 	}
-	return dur;
+
+	rspec |= (stf << RSPEC_STF_SHIFT);
+
+	if (override_mcs_only)
+		rspec |= RSPEC_OVERRIDE_MCS_ONLY;
+
+	if (issgi)
+		rspec |= RSPEC_SHORT_GI;
+
+	if ((rate != 0)
+	    && !brcms_c_valid_rate(wlc, rspec, cur_band->bandtype, true))
+		return rate;
+
+	return rspec;
+done:
+	return rate;
 }
 
-/* brcms_c_compute_rtscts_dur()
+/*
+ * Add struct d11txh, struct cck_phy_hdr.
  *
- * Calculate the 802.11 MAC header DUR field for an RTS or CTS frame
- * DUR for normal RTS/CTS w/ frame = 3 SIFS + 1 CTS + next frame time + 1 ACK
- * DUR for CTS-TO-SELF w/ frame    = 2 SIFS         + next frame time + 1 ACK
+ * 'p' data must start with 802.11 MAC header
+ * 'p' must allow enough bytes of local headers to be "pushed" onto the packet
+ *
+ * headroom == D11_PHY_HDR_LEN + D11_TXH_LEN (D11_TXH_LEN is now 104 bytes)
  *
- * cts			cts-to-self or rts/cts
- * rts_rate		rts or cts rate in unit of 500kbps
- * rate			next MPDU rate in unit of 500kbps
- * frame_len		next MPDU frame length in bytes
  */
-u16
-brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
-			   u32 rts_rate,
-			   u32 frame_rate, u8 rts_preamble_type,
-			   u8 frame_preamble_type, uint frame_len, bool ba)
-{
-	u16 dur, sifs;
-
-	sifs = SIFS(wlc->band);
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
-		bw = RSPEC_GET_BW(rspec);
-		/* 10Mhz is not supported yet */
-		if (bw < PHY_TXC1_BW_20MHZ) {
-			wiphy_err(wlc->wiphy, "phytxctl1_calc: bw %d is "
-				  "not supported yet, set to 20L\n", bw);
-			bw = PHY_TXC1_BW_20MHZ;
-		}
-	}
-
-	if (IS_MCS(rspec)) {
-		uint mcs = rspec & RSPEC_RATE_MASK;
-
-		/* bw, stf, coding-type is part of RSPEC_PHYTXBYTE2 returns */
-		phyctl1 = RSPEC_PHYTXBYTE2(rspec);
-		/* set the upper byte of phyctl1 */
-		phyctl1 |= (mcs_table[mcs].tx_phy_ctl3 << 8);
-	} else if (IS_CCK(rspec) && !BRCMS_ISLCNPHY(wlc->band)
-		   && !BRCMS_ISSSLPNPHY(wlc->band)) {
-		/*
-		 * In CCK mode LPPHY overloads OFDM Modulation bits with CCK
-		 * Data Rate. Eventually MIMOPHY would also be converted to
-		 * this format
-		 */
-		/* 0 = 1Mbps; 1 = 2Mbps; 2 = 5.5Mbps; 3 = 11Mbps */
-		phyctl1 = (bw | (RSPEC_STF(rspec) << PHY_TXC1_MODE_SHIFT));
-	} else {		/* legacy OFDM/CCK */
-		s16 phycfg;
-		/* get the phyctl byte from rate phycfg table */
-		phycfg = brcms_c_rate_legacy_phyctl(RSPEC2RATE(rspec));
-		if (phycfg == -1) {
-			wiphy_err(wlc->wiphy, "phytxctl1_calc: wrong "
-				  "legacy OFDM/CCK rate\n");
-			phycfg = 0;
-		}
-		/* set the upper byte of phyctl1 */
-		phyctl1 =
-		    (bw | (phycfg << 8) |
-		     (RSPEC_STF(rspec) << PHY_TXC1_MODE_SHIFT));
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
-	else if (wlc->band->gmode && wlc->protection->_g && !IS_CCK(rspec))
-		/* Use 11Mbps as the g protection RTS target rate and fallback.
-		 * Use the BRCMS_BASIC_RATE() lookup to find the best basic rate
-		 * under the target in case 11 Mbps is not Basic.
-		 * 6 and 9 Mbps are not usually selected by rate selection, but
-		 * even if the OFDM rate we are protecting is 6 or 9 Mbps, 11
-		 * is more robust.
-		 */
-		rts_rspec = BRCMS_BASIC_RATE(wlc, BRCM_RATE_11M);
-	else
-		/* calculate RTS rate and fallback rate based on the frame rate
-		 * RTS must be sent at a basic rate since it is a
-		 * control frame, sec 9.6 of 802.11 spec
-		 */
-		rts_rspec = BRCMS_BASIC_RATE(wlc, rspec);
-
-	if (BRCMS_PHY_11N_CAP(wlc->band)) {
-		/* set rts txbw to correct side band */
-		rts_rspec &= ~RSPEC_BW_MASK;
-
-		/*
-		 * if rspec/rspec_fallback is 40MHz, then send RTS on both
-		 * 20MHz channel (DUP), otherwise send RTS on control channel
-		 */
-		if (RSPEC_IS40MHZ(rspec) && !IS_CCK(rts_rspec))
-			rts_rspec |= (PHY_TXC1_BW_40MHZ_DUP << RSPEC_BW_SHIFT);
-		else
-			rts_rspec |= (mimo_ctlchbw << RSPEC_BW_SHIFT);
-
-		/* pick siso/cdd as default for ofdm */
-		if (IS_OFDM(rts_rspec)) {
-			rts_rspec &= ~RSPEC_STF_MASK;
-			rts_rspec |= (wlc->stf->ss_opmode << RSPEC_STF_SHIFT);
-		}
-	}
-	return rts_rspec;
-}
-
-/*
- * Add struct d11txh, struct cck_phy_hdr.
- *
- * 'p' data must start with 802.11 MAC header
- * 'p' must allow enough bytes of local headers to be "pushed" onto the packet
- *
- * headroom == D11_PHY_HDR_LEN + D11_TXH_LEN (D11_TXH_LEN is now 104 bytes)
- *
- */
-static u16
-brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
-		     struct sk_buff *p, struct scb *scb, uint frag,
-		     uint nfrags, uint queue, uint next_frag_len,
-		     struct wsec_key *key, u32 rspec_override)
+static u16
+brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
+		     struct sk_buff *p, struct scb *scb, uint frag,
+		     uint nfrags, uint queue, uint next_frag_len,
+		     struct wsec_key *key, u32 rspec_override)
 {
 	struct ieee80211_hdr *h;
 	struct d11txh *txh;
@@ -7249,621 +7049,1022 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	u16 mimo_txbw;
 	u8 mimo_preamble_type;
 
-	/* locate 802.11 MAC header */
-	h = (struct ieee80211_hdr *)(p->data);
-	qos = ieee80211_is_data_qos(h->frame_control);
+	/* locate 802.11 MAC header */
+	h = (struct ieee80211_hdr *)(p->data);
+	qos = ieee80211_is_data_qos(h->frame_control);
+
+	/* compute length of frame in bytes for use in PLCP computations */
+	len = brcmu_pkttotlen(p);
+	phylen = len + FCS_LEN;
+
+	/* If WEP enabled, add room in phylen for the additional bytes of
+	 * ICV which MAC generates.  We do NOT add the additional bytes to
+	 * the packet itself, thus phylen = packet length + ICV_LEN + FCS_LEN
+	 * in this case
+	 */
+	if (key)
+		phylen += key->icv_len;
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
+				  "TX_BCMC!\n", BRCMS_UNIT(wlc), __func__);
+			frameid = bcmc_fid_generate(wlc, NULL, txh);
+		} else {
+			/* Increment the counter for first fragment */
+			if (tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
+				SCB_SEQNUM(scb, p->priority)++;
+
+			/* extract fragment number from frame first */
+			seq = le16_to_cpu(seq) & FRAGNUM_MASK;
+			seq |= (SCB_SEQNUM(scb, p->priority) << SEQNUM_SHIFT);
+			h->seq_ctrl = cpu_to_le16(seq);
+
+			frameid = ((seq << TXFID_SEQ_SHIFT) & TXFID_SEQ_MASK) |
+			    (queue & TXFID_QUEUE_MASK);
+		}
+	}
+	frameid |= queue & TXFID_QUEUE_MASK;
+
+	/* set the ignpmq bit for all pkts tx'd in PS mode and for beacons */
+	if (SCB_PS(scb) || ieee80211_is_beacon(h->frame_control))
+		mcl |= TXC_IGNOREPMQ;
+
+	txrate[0] = tx_info->control.rates;
+	txrate[1] = txrate[0] + 1;
+
+	/*
+	 * if rate control algorithm didn't give us a fallback
+	 * rate, use the primary rate
+	 */
+	if (txrate[1]->idx < 0)
+		txrate[1] = txrate[0];
+
+	for (k = 0; k < hw->max_rates; k++) {
+		is_mcs[k] =
+		    txrate[k]->flags & IEEE80211_TX_RC_MCS ? true : false;
+		if (!is_mcs[k]) {
+			if ((txrate[k]->idx >= 0)
+			    && (txrate[k]->idx <
+				hw->wiphy->bands[tx_info->band]->n_bitrates)) {
+				rate_val[k] =
+				    hw->wiphy->bands[tx_info->band]->
+				    bitrates[txrate[k]->idx].hw_value;
+				short_preamble[k] =
+				    txrate[k]->
+				    flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE ?
+				    true : false;
+			} else {
+				rate_val[k] = BRCM_RATE_1M;
+			}
+		} else {
+			rate_val[k] = txrate[k]->idx;
+		}
+
+		/*
+		 * Currently only support same setting for primay and
+		 * fallback rates. Unify flags for each rate into a
+		 * single value for the frame
+		 */
+		use_rts |=
+		    txrate[k]->
+		    flags & IEEE80211_TX_RC_USE_RTS_CTS ? true : false;
+		use_cts |=
+		    txrate[k]->
+		    flags & IEEE80211_TX_RC_USE_CTS_PROTECT ? true : false;
+
+		if (is_mcs[k])
+			rate_val[k] |= NRATE_MCS_INUSE;
+
+		rspec[k] = mac80211_wlc_set_nrate(wlc, wlc->band, rate_val[k]);
+
+		/*
+		 * (1) RATE:
+		 *   determine and validate primary rate
+		 *   and fallback rates
+		 */
+		if (!RSPEC_ACTIVE(rspec[k])) {
+			rspec[k] = BRCM_RATE_1M;
+		} else {
+			if (!is_multicast_ether_addr(h->addr1)) {
+				/* set tx antenna config */
+				brcms_c_antsel_antcfg_get(wlc->asi, false,
+					false, 0, 0, &antcfg, &fbantcfg);
+			}
+		}
+	}
+
+	phyctl1_stf = wlc->stf->ss_opmode;
+
+	if (N_ENAB(wlc->pub)) {
+		for (k = 0; k < hw->max_rates; k++) {
+			/*
+			 * apply siso/cdd to single stream mcs's or ofdm
+			 * if rspec is auto selected
+			 */
+			if (((IS_MCS(rspec[k]) &&
+			      IS_SINGLE_STREAM(rspec[k] & RSPEC_RATE_MASK)) ||
+			     IS_OFDM(rspec[k]))
+			    && ((rspec[k] & RSPEC_OVERRIDE_MCS_ONLY)
+				|| !(rspec[k] & RSPEC_OVERRIDE))) {
+				rspec[k] &= ~(RSPEC_STF_MASK | RSPEC_STC_MASK);
+
+				/* For SISO MCS use STBC if possible */
+				if (IS_MCS(rspec[k])
+				    && BRCMS_STF_SS_STBC_TX(wlc, scb)) {
+					u8 stc;
+
+					/* Nss for single stream is always 1 */
+					stc = 1;
+					rspec[k] |= (PHY_TXC1_MODE_STBC <<
+							RSPEC_STF_SHIFT) |
+						    (stc << RSPEC_STC_SHIFT);
+				} else
+					rspec[k] |=
+					    (phyctl1_stf << RSPEC_STF_SHIFT);
+			}
+
+			/*
+			 * Is the phy configured to use 40MHZ frames? If
+			 * so then pick the desired txbw
+			 */
+			if (CHSPEC_WLC_BW(wlc->chanspec) == BRCMS_40_MHZ) {
+				/* default txbw is 20in40 SB */
+				mimo_ctlchbw = mimo_txbw =
+				   CHSPEC_SB_UPPER(BRCMS_BAND_PI_RADIO_CHANSPEC)
+				   ? PHY_TXC1_BW_20MHZ_UP : PHY_TXC1_BW_20MHZ;
+
+				if (IS_MCS(rspec[k])) {
+					/* mcs 32 must be 40b/w DUP */
+					if ((rspec[k] & RSPEC_RATE_MASK)
+					    == 32) {
+						mimo_txbw =
+						    PHY_TXC1_BW_40MHZ_DUP;
+						/* use override */
+					} else if (wlc->mimo_40txbw != AUTO)
+						mimo_txbw = wlc->mimo_40txbw;
+					/* else check if dst is using 40 Mhz */
+					else if (scb->flags & SCB_IS40)
+						mimo_txbw = PHY_TXC1_BW_40MHZ;
+				} else if (IS_OFDM(rspec[k])) {
+					if (wlc->ofdm_40txbw != AUTO)
+						mimo_txbw = wlc->ofdm_40txbw;
+				} else if (wlc->cck_40txbw != AUTO) {
+					mimo_txbw = wlc->cck_40txbw;
+				}
+			} else {
+				/*
+				 * mcs32 is 40 b/w only.
+				 * This is possible for probe packets on
+				 * a STA during SCAN
+				 */
+				if ((rspec[k] & RSPEC_RATE_MASK) == 32)
+					/* mcs 0 */
+					rspec[k] = RSPEC_MIMORATE;
+
+				mimo_txbw = PHY_TXC1_BW_20MHZ;
+			}
+
+			/* Set channel width */
+			rspec[k] &= ~RSPEC_BW_MASK;
+			if ((k == 0) || ((k > 0) && IS_MCS(rspec[k])))
+				rspec[k] |= (mimo_txbw << RSPEC_BW_SHIFT);
+			else
+				rspec[k] |= (mimo_ctlchbw << RSPEC_BW_SHIFT);
+
+			/* Disable short GI, not supported yet */
+			rspec[k] &= ~RSPEC_SHORT_GI;
+
+			mimo_preamble_type = BRCMS_MM_PREAMBLE;
+			if (txrate[k]->flags & IEEE80211_TX_RC_GREEN_FIELD)
+				mimo_preamble_type = BRCMS_GF_PREAMBLE;
+
+			if ((txrate[k]->flags & IEEE80211_TX_RC_MCS)
+			    && (!IS_MCS(rspec[k]))) {
+				wiphy_err(wlc->wiphy, "wl%d: %s: IEEE80211_TX_"
+					  "RC_MCS != IS_MCS(rspec)\n",
+					  BRCMS_UNIT(wlc), __func__);
+			}
+
+			if (IS_MCS(rspec[k])) {
+				preamble_type[k] = mimo_preamble_type;
+
+				/*
+				 * if SGI is selected, then forced mm
+				 * for single stream
+				 */
+				if ((rspec[k] & RSPEC_SHORT_GI)
+				    && IS_SINGLE_STREAM(rspec[k] &
+							RSPEC_RATE_MASK))
+					preamble_type[k] = BRCMS_MM_PREAMBLE;
+			}
+
+			/* should be better conditionalized */
+			if (!IS_MCS(rspec[0])
+			    && (tx_info->control.rates[0].
+				flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE))
+				preamble_type[k] = BRCMS_SHORT_PREAMBLE;
+		}
+	} else {
+		for (k = 0; k < hw->max_rates; k++) {
+			/* Set ctrlchbw as 20Mhz */
+			rspec[k] &= ~RSPEC_BW_MASK;
+			rspec[k] |= (PHY_TXC1_BW_20MHZ << RSPEC_BW_SHIFT);
+
+			/* for nphy, stf of ofdm frames must follow policies */
+			if (BRCMS_ISNPHY(wlc->band) && IS_OFDM(rspec[k])) {
+				rspec[k] &= ~RSPEC_STF_MASK;
+				rspec[k] |= phyctl1_stf << RSPEC_STF_SHIFT;
+			}
+		}
+	}
+
+	/* Reset these for use with AMPDU's */
+	txrate[0]->count = 0;
+	txrate[1]->count = 0;
+
+	/* (2) PROTECTION, may change rspec */
+	if ((ieee80211_is_data(h->frame_control) ||
+	    ieee80211_is_mgmt(h->frame_control)) &&
+	    (phylen > wlc->RTSThresh) && !is_multicast_ether_addr(h->addr1))
+		use_rts = true;
+
+	/* (3) PLCP: determine PLCP header and MAC duration,
+	 * fill struct d11txh */
+	brcms_c_compute_plcp(wlc, rspec[0], phylen, plcp);
+	brcms_c_compute_plcp(wlc, rspec[1], phylen, plcp_fallback);
+	memcpy(&txh->FragPLCPFallback,
+	       plcp_fallback, sizeof(txh->FragPLCPFallback));
+
+	/* Length field now put in CCK FBR CRC field */
+	if (IS_CCK(rspec[1])) {
+		txh->FragPLCPFallback[4] = phylen & 0xff;
+		txh->FragPLCPFallback[5] = (phylen & 0xff00) >> 8;
+	}
+
+	/* MIMO-RATE: need validation ?? */
+	mainrates = IS_OFDM(rspec[0]) ?
+			D11A_PHY_HDR_GRATE((struct ofdm_phy_hdr *) plcp) :
+			plcp[0];
+
+	/* DUR field for main rate */
+	if (!ieee80211_is_pspoll(h->frame_control) &&
+	    !is_multicast_ether_addr(h->addr1) && !use_rifs) {
+		durid =
+		    brcms_c_compute_frame_dur(wlc, rspec[0], preamble_type[0],
+					  next_frag_len);
+		h->duration_id = cpu_to_le16(durid);
+	} else if (use_rifs) {
+		/* NAV protect to end of next max packet size */
+		durid =
+		    (u16) brcms_c_calc_frame_time(wlc, rspec[0],
+						 preamble_type[0],
+						 DOT11_MAX_FRAG_LEN);
+		durid += RIFS_11N_TIME;
+		h->duration_id = cpu_to_le16(durid);
+	}
+
+	/* DUR field for fallback rate */
+	if (ieee80211_is_pspoll(h->frame_control))
+		txh->FragDurFallback = h->duration_id;
+	else if (is_multicast_ether_addr(h->addr1) || use_rifs)
+		txh->FragDurFallback = 0;
+	else {
+		durid = brcms_c_compute_frame_dur(wlc, rspec[1],
+					      preamble_type[1], next_frag_len);
+		txh->FragDurFallback = cpu_to_le16(durid);
+	}
 
-	/* compute length of frame in bytes for use in PLCP computations */
-	len = brcmu_pkttotlen(p);
-	phylen = len + FCS_LEN;
+	/* (4) MAC-HDR: MacTxControlLow */
+	if (frag == 0)
+		mcl |= TXC_STARTMSDU;
 
-	/* If WEP enabled, add room in phylen for the additional bytes of
-	 * ICV which MAC generates.  We do NOT add the additional bytes to
-	 * the packet itself, thus phylen = packet length + ICV_LEN + FCS_LEN
-	 * in this case
-	 */
-	if (key)
-		phylen += key->icv_len;
+	if (!is_multicast_ether_addr(h->addr1))
+		mcl |= TXC_IMMEDACK;
 
-	/* Get tx_info */
-	tx_info = IEEE80211_SKB_CB(p);
+	if (BAND_5G(wlc->band->bandtype))
+		mcl |= TXC_FREQBAND_5G;
 
-	/* add PLCP */
-	plcp = skb_push(p, D11_PHY_HDR_LEN);
+	if (CHSPEC_IS40(BRCMS_BAND_PI_RADIO_CHANSPEC))
+		mcl |= TXC_BW_40;
 
-	/* add Broadcom tx descriptor header */
-	txh = (struct d11txh *) skb_push(p, D11_TXH_LEN);
-	memset(txh, 0, D11_TXH_LEN);
+	/* set AMIC bit if using hardware TKIP MIC */
+	if (hwtkmic)
+		mcl |= TXC_AMIC;
 
-	/* setup frameid */
-	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
-		/* non-AP STA should never use BCMC queue */
-		if (queue == TX_BCMC_FIFO) {
-			wiphy_err(wlc->wiphy, "wl%d: %s: ASSERT queue == "
-				  "TX_BCMC!\n", BRCMS_UNIT(wlc), __func__);
-			frameid = bcmc_fid_generate(wlc, NULL, txh);
-		} else {
-			/* Increment the counter for first fragment */
-			if (tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
-				SCB_SEQNUM(scb, p->priority)++;
+	txh->MacTxControlLow = cpu_to_le16(mcl);
 
-			/* extract fragment number from frame first */
-			seq = le16_to_cpu(seq) & FRAGNUM_MASK;
-			seq |= (SCB_SEQNUM(scb, p->priority) << SEQNUM_SHIFT);
-			h->seq_ctrl = cpu_to_le16(seq);
+	/* MacTxControlHigh */
+	mch = 0;
 
-			frameid = ((seq << TXFID_SEQ_SHIFT) & TXFID_SEQ_MASK) |
-			    (queue & TXFID_QUEUE_MASK);
-		}
+	/* Set fallback rate preamble type */
+	if ((preamble_type[1] == BRCMS_SHORT_PREAMBLE) ||
+	    (preamble_type[1] == BRCMS_GF_PREAMBLE)) {
+		if (RSPEC2RATE(rspec[1]) != BRCM_RATE_1M)
+			mch |= TXC_PREAMBLE_DATA_FB_SHORT;
 	}
-	frameid |= queue & TXFID_QUEUE_MASK;
 
-	/* set the ignpmq bit for all pkts tx'd in PS mode and for beacons */
-	if (SCB_PS(scb) || ieee80211_is_beacon(h->frame_control))
-		mcl |= TXC_IGNOREPMQ;
+	/* MacFrameControl */
+	memcpy(&txh->MacFrameControl, &h->frame_control, sizeof(u16));
+	txh->TxFesTimeNormal = cpu_to_le16(0);
 
-	txrate[0] = tx_info->control.rates;
-	txrate[1] = txrate[0] + 1;
+	txh->TxFesTimeFallback = cpu_to_le16(0);
+
+	/* TxFrameRA */
+	memcpy(&txh->TxFrameRA, &h->addr1, ETH_ALEN);
+
+	/* TxFrameID */
+	txh->TxFrameID = cpu_to_le16(frameid);
 
 	/*
-	 * if rate control algorithm didn't give us a fallback
-	 * rate, use the primary rate
+	 * TxStatus, Note the case of recreating the first frag of a suppressed
+	 * frame then we may need to reset the retry cnt's via the status reg
 	 */
-	if (txrate[1]->idx < 0)
-		txrate[1] = txrate[0];
+	txh->TxStatus = cpu_to_le16(status);
 
-	for (k = 0; k < hw->max_rates; k++) {
-		is_mcs[k] =
-		    txrate[k]->flags & IEEE80211_TX_RC_MCS ? true : false;
-		if (!is_mcs[k]) {
-			if ((txrate[k]->idx >= 0)
-			    && (txrate[k]->idx <
-				hw->wiphy->bands[tx_info->band]->n_bitrates)) {
-				rate_val[k] =
-				    hw->wiphy->bands[tx_info->band]->
-				    bitrates[txrate[k]->idx].hw_value;
-				short_preamble[k] =
-				    txrate[k]->
-				    flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE ?
-				    true : false;
-			} else {
-				rate_val[k] = BRCM_RATE_1M;
-			}
-		} else {
-			rate_val[k] = txrate[k]->idx;
-		}
+	/*
+	 * extra fields for ucode AMPDU aggregation, the new fields are added to
+	 * the END of previous structure so that it's compatible in driver.
+	 */
+	txh->MaxNMpdus = cpu_to_le16(0);
+	txh->MaxABytes_MRT = cpu_to_le16(0);
+	txh->MaxABytes_FBR = cpu_to_le16(0);
+	txh->MinMBytes = cpu_to_le16(0);
 
-		/*
-		 * Currently only support same setting for primay and
-		 * fallback rates. Unify flags for each rate into a
-		 * single value for the frame
-		 */
-		use_rts |=
-		    txrate[k]->
-		    flags & IEEE80211_TX_RC_USE_RTS_CTS ? true : false;
-		use_cts |=
-		    txrate[k]->
-		    flags & IEEE80211_TX_RC_USE_CTS_PROTECT ? true : false;
+	/* (5) RTS/CTS: determine RTS/CTS PLCP header and MAC duration,
+	 * furnish struct d11txh */
+	/* RTS PLCP header and RTS frame */
+	if (use_rts || use_cts) {
+		if (use_rts && use_cts)
+			use_cts = false;
 
-		if (is_mcs[k])
-			rate_val[k] |= NRATE_MCS_INUSE;
+		for (k = 0; k < 2; k++) {
+			rts_rspec[k] = brcms_c_rspec_to_rts_rspec(wlc, rspec[k],
+							      false,
+							      mimo_ctlchbw);
+		}
 
-		rspec[k] = mac80211_wlc_set_nrate(wlc, wlc->band, rate_val[k]);
+		if (!IS_OFDM(rts_rspec[0]) &&
+		    !((RSPEC2RATE(rts_rspec[0]) == BRCM_RATE_1M) ||
+		      (wlc->PLCPHdr_override == BRCMS_PLCP_LONG))) {
+			rts_preamble_type[0] = BRCMS_SHORT_PREAMBLE;
+			mch |= TXC_PREAMBLE_RTS_MAIN_SHORT;
+		}
 
-		/*
-		 * (1) RATE:
-		 *   determine and validate primary rate
-		 *   and fallback rates
-		 */
-		if (!RSPEC_ACTIVE(rspec[k])) {
-			rspec[k] = BRCM_RATE_1M;
+		if (!IS_OFDM(rts_rspec[1]) &&
+		    !((RSPEC2RATE(rts_rspec[1]) == BRCM_RATE_1M) ||
+		      (wlc->PLCPHdr_override == BRCMS_PLCP_LONG))) {
+			rts_preamble_type[1] = BRCMS_SHORT_PREAMBLE;
+			mch |= TXC_PREAMBLE_RTS_FB_SHORT;
+		}
+
+		/* RTS/CTS additions to MacTxControlLow */
+		if (use_cts) {
+			txh->MacTxControlLow |= cpu_to_le16(TXC_SENDCTS);
 		} else {
-			if (!is_multicast_ether_addr(h->addr1)) {
-				/* set tx antenna config */
-				brcms_c_antsel_antcfg_get(wlc->asi, false,
-					false, 0, 0, &antcfg, &fbantcfg);
-			}
+			txh->MacTxControlLow |= cpu_to_le16(TXC_SENDRTS);
+			txh->MacTxControlLow |= cpu_to_le16(TXC_LONGFRAME);
 		}
-	}
 
-	phyctl1_stf = wlc->stf->ss_opmode;
+		/* RTS PLCP header */
+		rts_plcp = txh->RTSPhyHeader;
+		if (use_cts)
+			rts_phylen = DOT11_CTS_LEN + FCS_LEN;
+		else
+			rts_phylen = DOT11_RTS_LEN + FCS_LEN;
 
-	if (N_ENAB(wlc->pub)) {
-		for (k = 0; k < hw->max_rates; k++) {
-			/*
-			 * apply siso/cdd to single stream mcs's or ofdm
-			 * if rspec is auto selected
-			 */
-			if (((IS_MCS(rspec[k]) &&
-			      IS_SINGLE_STREAM(rspec[k] & RSPEC_RATE_MASK)) ||
-			     IS_OFDM(rspec[k]))
-			    && ((rspec[k] & RSPEC_OVERRIDE_MCS_ONLY)
-				|| !(rspec[k] & RSPEC_OVERRIDE))) {
-				rspec[k] &= ~(RSPEC_STF_MASK | RSPEC_STC_MASK);
+		brcms_c_compute_plcp(wlc, rts_rspec[0], rts_phylen, rts_plcp);
 
-				/* For SISO MCS use STBC if possible */
-				if (IS_MCS(rspec[k])
-				    && BRCMS_STF_SS_STBC_TX(wlc, scb)) {
-					u8 stc;
+		/* fallback rate version of RTS PLCP header */
+		brcms_c_compute_plcp(wlc, rts_rspec[1], rts_phylen,
+				 rts_plcp_fallback);
+		memcpy(&txh->RTSPLCPFallback, rts_plcp_fallback,
+		       sizeof(txh->RTSPLCPFallback));
 
-					/* Nss for single stream is always 1 */
-					stc = 1;
-					rspec[k] |= (PHY_TXC1_MODE_STBC <<
-							RSPEC_STF_SHIFT) |
-						    (stc << RSPEC_STC_SHIFT);
-				} else
-					rspec[k] |=
-					    (phyctl1_stf << RSPEC_STF_SHIFT);
-			}
+		/* RTS frame fields... */
+		rts = (struct ieee80211_rts *)&txh->rts_frame;
+
+		durid = brcms_c_compute_rtscts_dur(wlc, use_cts, rts_rspec[0],
+					       rspec[0], rts_preamble_type[0],
+					       preamble_type[0], phylen, false);
+		rts->duration = cpu_to_le16(durid);
+		/* fallback rate version of RTS DUR field */
+		durid = brcms_c_compute_rtscts_dur(wlc, use_cts,
+					       rts_rspec[1], rspec[1],
+					       rts_preamble_type[1],
+					       preamble_type[1], phylen, false);
+		txh->RTSDurFallback = cpu_to_le16(durid);
+
+		if (use_cts) {
+			rts->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
+							 IEEE80211_STYPE_CTS);
+
+			memcpy(&rts->ra, &h->addr2, ETH_ALEN);
+		} else {
+			rts->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
+							 IEEE80211_STYPE_RTS);
+
+			memcpy(&rts->ra, &h->addr1, 2 * ETH_ALEN);
+		}
+
+		/* mainrate
+		 *    low 8 bits: main frag rate/mcs,
+		 *    high 8 bits: rts/cts rate/mcs
+		 */
+		mainrates |= (IS_OFDM(rts_rspec[0]) ?
+				D11A_PHY_HDR_GRATE(
+					(struct ofdm_phy_hdr *) rts_plcp) :
+				rts_plcp[0]) << 8;
+	} else {
+		memset((char *)txh->RTSPhyHeader, 0, D11_PHY_HDR_LEN);
+		memset((char *)&txh->rts_frame, 0,
+			sizeof(struct ieee80211_rts));
+		memset((char *)txh->RTSPLCPFallback, 0,
+		      sizeof(txh->RTSPLCPFallback));
+		txh->RTSDurFallback = 0;
+	}
 
-			/*
-			 * Is the phy configured to use 40MHZ frames? If
-			 * so then pick the desired txbw
-			 */
-			if (CHSPEC_WLC_BW(wlc->chanspec) == BRCMS_40_MHZ) {
-				/* default txbw is 20in40 SB */
-				mimo_ctlchbw = mimo_txbw =
-				   CHSPEC_SB_UPPER(BRCMS_BAND_PI_RADIO_CHANSPEC)
-				   ? PHY_TXC1_BW_20MHZ_UP : PHY_TXC1_BW_20MHZ;
+#ifdef SUPPORT_40MHZ
+	/* add null delimiter count */
+	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && IS_MCS(rspec))
+		txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM] =
+		   brcm_c_ampdu_null_delim_cnt(wlc->ampdu, scb, rspec, phylen);
 
-				if (IS_MCS(rspec[k])) {
-					/* mcs 32 must be 40b/w DUP */
-					if ((rspec[k] & RSPEC_RATE_MASK)
-					    == 32) {
-						mimo_txbw =
-						    PHY_TXC1_BW_40MHZ_DUP;
-						/* use override */
-					} else if (wlc->mimo_40txbw != AUTO)
-						mimo_txbw = wlc->mimo_40txbw;
-					/* else check if dst is using 40 Mhz */
-					else if (scb->flags & SCB_IS40)
-						mimo_txbw = PHY_TXC1_BW_40MHZ;
-				} else if (IS_OFDM(rspec[k])) {
-					if (wlc->ofdm_40txbw != AUTO)
-						mimo_txbw = wlc->ofdm_40txbw;
-				} else if (wlc->cck_40txbw != AUTO) {
-					mimo_txbw = wlc->cck_40txbw;
-				}
-			} else {
-				/*
-				 * mcs32 is 40 b/w only.
-				 * This is possible for probe packets on
-				 * a STA during SCAN
-				 */
-				if ((rspec[k] & RSPEC_RATE_MASK) == 32)
-					/* mcs 0 */
-					rspec[k] = RSPEC_MIMORATE;
+#endif
 
-				mimo_txbw = PHY_TXC1_BW_20MHZ;
-			}
+	/*
+	 * Now that RTS/RTS FB preamble types are updated, write
+	 * the final value
+	 */
+	txh->MacTxControlHigh = cpu_to_le16(mch);
 
-			/* Set channel width */
-			rspec[k] &= ~RSPEC_BW_MASK;
-			if ((k == 0) || ((k > 0) && IS_MCS(rspec[k])))
-				rspec[k] |= (mimo_txbw << RSPEC_BW_SHIFT);
-			else
-				rspec[k] |= (mimo_ctlchbw << RSPEC_BW_SHIFT);
+	/*
+	 * MainRates (both the rts and frag plcp rates have
+	 * been calculated now)
+	 */
+	txh->MainRates = cpu_to_le16(mainrates);
 
-			/* Disable short GI, not supported yet */
-			rspec[k] &= ~RSPEC_SHORT_GI;
+	/* XtraFrameTypes */
+	xfts = FRAMETYPE(rspec[1], wlc->mimoft);
+	xfts |= (FRAMETYPE(rts_rspec[0], wlc->mimoft) << XFTS_RTS_FT_SHIFT);
+	xfts |= (FRAMETYPE(rts_rspec[1], wlc->mimoft) << XFTS_FBRRTS_FT_SHIFT);
+	xfts |=
+	    CHSPEC_CHANNEL(BRCMS_BAND_PI_RADIO_CHANSPEC) << XFTS_CHANNEL_SHIFT;
+	txh->XtraFrameTypes = cpu_to_le16(xfts);
 
-			mimo_preamble_type = BRCMS_MM_PREAMBLE;
-			if (txrate[k]->flags & IEEE80211_TX_RC_GREEN_FIELD)
-				mimo_preamble_type = BRCMS_GF_PREAMBLE;
+	/* PhyTxControlWord */
+	phyctl = FRAMETYPE(rspec[0], wlc->mimoft);
+	if ((preamble_type[0] == BRCMS_SHORT_PREAMBLE) ||
+	    (preamble_type[0] == BRCMS_GF_PREAMBLE)) {
+		if (RSPEC2RATE(rspec[0]) != BRCM_RATE_1M)
+			phyctl |= PHY_TXC_SHORT_HDR;
+	}
 
-			if ((txrate[k]->flags & IEEE80211_TX_RC_MCS)
-			    && (!IS_MCS(rspec[k]))) {
-				wiphy_err(wlc->wiphy, "wl%d: %s: IEEE80211_TX_"
-					  "RC_MCS != IS_MCS(rspec)\n",
-					  BRCMS_UNIT(wlc), __func__);
-			}
+	/* phytxant is properly bit shifted */
+	phyctl |= brcms_c_stf_d11hdrs_phyctl_txant(wlc, rspec[0]);
+	txh->PhyTxControlWord = cpu_to_le16(phyctl);
 
-			if (IS_MCS(rspec[k])) {
-				preamble_type[k] = mimo_preamble_type;
+	/* PhyTxControlWord_1 */
+	if (BRCMS_PHY_11N_CAP(wlc->band)) {
+		u16 phyctl1 = 0;
 
-				/*
-				 * if SGI is selected, then forced mm
-				 * for single stream
-				 */
-				if ((rspec[k] & RSPEC_SHORT_GI)
-				    && IS_SINGLE_STREAM(rspec[k] &
-							RSPEC_RATE_MASK))
-					preamble_type[k] = BRCMS_MM_PREAMBLE;
-			}
+		phyctl1 = brcms_c_phytxctl1_calc(wlc, rspec[0]);
+		txh->PhyTxControlWord_1 = cpu_to_le16(phyctl1);
+		phyctl1 = brcms_c_phytxctl1_calc(wlc, rspec[1]);
+		txh->PhyTxControlWord_1_Fbr = cpu_to_le16(phyctl1);
 
-			/* should be better conditionalized */
-			if (!IS_MCS(rspec[0])
-			    && (tx_info->control.rates[0].
-				flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE))
-				preamble_type[k] = BRCMS_SHORT_PREAMBLE;
+		if (use_rts || use_cts) {
+			phyctl1 = brcms_c_phytxctl1_calc(wlc, rts_rspec[0]);
+			txh->PhyTxControlWord_1_Rts = cpu_to_le16(phyctl1);
+			phyctl1 = brcms_c_phytxctl1_calc(wlc, rts_rspec[1]);
+			txh->PhyTxControlWord_1_FbrRts = cpu_to_le16(phyctl1);
 		}
-	} else {
-		for (k = 0; k < hw->max_rates; k++) {
-			/* Set ctrlchbw as 20Mhz */
-			rspec[k] &= ~RSPEC_BW_MASK;
-			rspec[k] |= (PHY_TXC1_BW_20MHZ << RSPEC_BW_SHIFT);
 
-			/* for nphy, stf of ofdm frames must follow policies */
-			if (BRCMS_ISNPHY(wlc->band) && IS_OFDM(rspec[k])) {
-				rspec[k] &= ~RSPEC_STF_MASK;
-				rspec[k] |= phyctl1_stf << RSPEC_STF_SHIFT;
-			}
+		/*
+		 * For mcs frames, if mixedmode(overloaded with long preamble)
+		 * is going to be set, fill in non-zero MModeLen and/or
+		 * MModeFbrLen it will be unnecessary if they are separated
+		 */
+		if (IS_MCS(rspec[0]) &&
+		    (preamble_type[0] == BRCMS_MM_PREAMBLE)) {
+			u16 mmodelen =
+			    brcms_c_calc_lsig_len(wlc, rspec[0], phylen);
+			txh->MModeLen = cpu_to_le16(mmodelen);
+		}
+
+		if (IS_MCS(rspec[1]) &&
+		    (preamble_type[1] == BRCMS_MM_PREAMBLE)) {
+			u16 mmodefbrlen =
+			    brcms_c_calc_lsig_len(wlc, rspec[1], phylen);
+			txh->MModeFbrLen = cpu_to_le16(mmodefbrlen);
 		}
 	}
 
-	/* Reset these for use with AMPDU's */
-	txrate[0]->count = 0;
-	txrate[1]->count = 0;
+	ac = skb_get_queue_mapping(p);
+	if (SCB_WME(scb) && qos && wlc->edcf_txop[ac]) {
+		uint frag_dur, dur, dur_fallback;
 
-	/* (2) PROTECTION, may change rspec */
-	if ((ieee80211_is_data(h->frame_control) ||
-	    ieee80211_is_mgmt(h->frame_control)) &&
-	    (phylen > wlc->RTSThresh) && !is_multicast_ether_addr(h->addr1))
-		use_rts = true;
+		/* WME: Update TXOP threshold */
+		if (!(tx_info->flags & IEEE80211_TX_CTL_AMPDU) && frag == 0) {
+			frag_dur =
+			    brcms_c_calc_frame_time(wlc, rspec[0],
+					preamble_type[0], phylen);
 
-	/* (3) PLCP: determine PLCP header and MAC duration,
-	 * fill struct d11txh */
-	brcms_c_compute_plcp(wlc, rspec[0], phylen, plcp);
-	brcms_c_compute_plcp(wlc, rspec[1], phylen, plcp_fallback);
-	memcpy(&txh->FragPLCPFallback,
-	       plcp_fallback, sizeof(txh->FragPLCPFallback));
+			if (rts) {
+				/* 1 RTS or CTS-to-self frame */
+				dur =
+				    brcms_c_calc_cts_time(wlc, rts_rspec[0],
+						      rts_preamble_type[0]);
+				dur_fallback =
+				    brcms_c_calc_cts_time(wlc, rts_rspec[1],
+						      rts_preamble_type[1]);
+				/* (SIFS + CTS) + SIFS + frame + SIFS + ACK */
+				dur += le16_to_cpu(rts->duration);
+				dur_fallback +=
+					le16_to_cpu(txh->RTSDurFallback);
+			} else if (use_rifs) {
+				dur = frag_dur;
+				dur_fallback = 0;
+			} else {
+				/* frame + SIFS + ACK */
+				dur = frag_dur;
+				dur +=
+				    brcms_c_compute_frame_dur(wlc, rspec[0],
+							  preamble_type[0], 0);
 
-	/* Length field now put in CCK FBR CRC field */
-	if (IS_CCK(rspec[1])) {
-		txh->FragPLCPFallback[4] = phylen & 0xff;
-		txh->FragPLCPFallback[5] = (phylen & 0xff00) >> 8;
-	}
+				dur_fallback =
+				    brcms_c_calc_frame_time(wlc, rspec[1],
+							preamble_type[1],
+							phylen);
+				dur_fallback +=
+				    brcms_c_compute_frame_dur(wlc, rspec[1],
+							  preamble_type[1], 0);
+			}
+			/* NEED to set TxFesTimeNormal (hard) */
+			txh->TxFesTimeNormal = cpu_to_le16((u16) dur);
+			/*
+			 * NEED to set fallback rate version of
+			 * TxFesTimeNormal (hard)
+			 */
+			txh->TxFesTimeFallback =
+				cpu_to_le16((u16) dur_fallback);
 
-	/* MIMO-RATE: need validation ?? */
-	mainrates = IS_OFDM(rspec[0]) ?
-			D11A_PHY_HDR_GRATE((struct ofdm_phy_hdr *) plcp) :
-			plcp[0];
+			/*
+			 * update txop byte threshold (txop minus intraframe
+			 * overhead)
+			 */
+			if (wlc->edcf_txop[ac] >= (dur - frag_dur)) {
+				uint newfragthresh;
 
-	/* DUR field for main rate */
-	if (!ieee80211_is_pspoll(h->frame_control) &&
-	    !is_multicast_ether_addr(h->addr1) && !use_rifs) {
-		durid =
-		    brcms_c_compute_frame_dur(wlc, rspec[0], preamble_type[0],
-					  next_frag_len);
-		h->duration_id = cpu_to_le16(durid);
-	} else if (use_rifs) {
-		/* NAV protect to end of next max packet size */
-		durid =
-		    (u16) brcms_c_calc_frame_time(wlc, rspec[0],
-						 preamble_type[0],
-						 DOT11_MAX_FRAG_LEN);
-		durid += RIFS_11N_TIME;
-		h->duration_id = cpu_to_le16(durid);
-	}
+				newfragthresh =
+				    brcms_c_calc_frame_len(wlc,
+					rspec[0], preamble_type[0],
+					(wlc->edcf_txop[ac] -
+						(dur - frag_dur)));
+				/* range bound the fragthreshold */
+				if (newfragthresh < DOT11_MIN_FRAG_LEN)
+					newfragthresh =
+					    DOT11_MIN_FRAG_LEN;
+				else if (newfragthresh >
+					 wlc->usr_fragthresh)
+					newfragthresh =
+					    wlc->usr_fragthresh;
+				/* update the fragthresh and do txc update */
+				if (wlc->fragthresh[queue] !=
+				    (u16) newfragthresh)
+					wlc->fragthresh[queue] =
+					    (u16) newfragthresh;
+			} else {
+				wiphy_err(wlc->wiphy, "wl%d: %s txop invalid "
+					  "for rate %d\n",
+					  wlc->pub->unit, fifo_names[queue],
+					  RSPEC2RATE(rspec[0]));
+			}
 
-	/* DUR field for fallback rate */
-	if (ieee80211_is_pspoll(h->frame_control))
-		txh->FragDurFallback = h->duration_id;
-	else if (is_multicast_ether_addr(h->addr1) || use_rifs)
-		txh->FragDurFallback = 0;
-	else {
-		durid = brcms_c_compute_frame_dur(wlc, rspec[1],
-					      preamble_type[1], next_frag_len);
-		txh->FragDurFallback = cpu_to_le16(durid);
+			if (dur > wlc->edcf_txop[ac])
+				wiphy_err(wlc->wiphy, "wl%d: %s: %s txop "
+					  "exceeded phylen %d/%d dur %d/%d\n",
+					  wlc->pub->unit, __func__,
+					  fifo_names[queue],
+					  phylen, wlc->fragthresh[queue],
+					  dur, wlc->edcf_txop[ac]);
+		}
 	}
 
-	/* (4) MAC-HDR: MacTxControlLow */
-	if (frag == 0)
-		mcl |= TXC_STARTMSDU;
+	return 0;
+}
 
-	if (!is_multicast_ether_addr(h->addr1))
-		mcl |= TXC_IMMEDACK;
+bool
+brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
+		     struct ieee80211_hw *hw)
+{
+	u8 prio;
+	uint fifo;
+	struct scb *scb = &global_scb;
+	struct ieee80211_hdr *d11_header = (struct ieee80211_hdr *)(sdu->data);
 
-	if (BAND_5G(wlc->band->bandtype))
-		mcl |= TXC_FREQBAND_5G;
+	/*
+	 * 802.11 standard requires management traffic
+	 * to go at highest priority
+	 */
+	prio = ieee80211_is_data(d11_header->frame_control) ? sdu->priority :
+		MAXPRIO;
+	fifo = prio2fifo[prio];
+	if (unlikely
+	    (brcms_c_d11hdrs_mac80211(
+		wlc, hw, sdu, scb, 0, 1, fifo, 0, NULL, 0)))
+		return -EINVAL;
+	brcms_c_txq_enq(wlc, scb, sdu, BRCMS_PRIO_TO_PREC(prio));
+	brcms_c_send_q(wlc);
+	return 0;
+}
 
-	if (CHSPEC_IS40(BRCMS_BAND_PI_RADIO_CHANSPEC))
-		mcl |= TXC_BW_40;
+void brcms_c_send_q(struct brcms_c_info *wlc)
+{
+	struct sk_buff *pkt[DOT11_MAXNUMFRAGS];
+	int prec;
+	u16 prec_map;
+	int err = 0, i, count;
+	uint fifo;
+	struct brcms_txq_info *qi = wlc->pkt_queue;
+	struct pktq *q = &qi->q;
+	struct ieee80211_tx_info *tx_info;
 
-	/* set AMIC bit if using hardware TKIP MIC */
-	if (hwtkmic)
-		mcl |= TXC_AMIC;
+	if (in_send_q)
+		return;
+	else
+		in_send_q = true;
 
-	txh->MacTxControlLow = cpu_to_le16(mcl);
+	prec_map = wlc->tx_prec_map;
 
-	/* MacTxControlHigh */
-	mch = 0;
+	/* Send all the enq'd pkts that we can.
+	 * Dequeue packets with precedence with empty HW fifo only
+	 */
+	while (prec_map && (pkt[0] = brcmu_pktq_mdeq(q, prec_map, &prec))) {
+		tx_info = IEEE80211_SKB_CB(pkt[0]);
+		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
+			err = brcms_c_sendampdu(wlc->ampdu, qi, pkt, prec);
+		} else {
+			count = 1;
+			err = brcms_c_prep_pdu(wlc, pkt[0], &fifo);
+			if (!err) {
+				for (i = 0; i < count; i++)
+					brcms_c_txfifo(wlc, fifo, pkt[i], true,
+						       1);
+			}
+		}
 
-	/* Set fallback rate preamble type */
-	if ((preamble_type[1] == BRCMS_SHORT_PREAMBLE) ||
-	    (preamble_type[1] == BRCMS_GF_PREAMBLE)) {
-		if (RSPEC2RATE(rspec[1]) != BRCM_RATE_1M)
-			mch |= TXC_PREAMBLE_DATA_FB_SHORT;
+		if (err == -EBUSY) {
+			brcmu_pktq_penq_head(q, prec, pkt[0]);
+			/*
+			 * If send failed due to any other reason than a
+			 * change in HW FIFO condition, quit. Otherwise,
+			 * read the new prec_map!
+			 */
+			if (prec_map == wlc->tx_prec_map)
+				break;
+			prec_map = wlc->tx_prec_map;
+		}
 	}
 
-	/* MacFrameControl */
-	memcpy(&txh->MacFrameControl, &h->frame_control, sizeof(u16));
-	txh->TxFesTimeNormal = cpu_to_le16(0);
-
-	txh->TxFesTimeFallback = cpu_to_le16(0);
-
-	/* TxFrameRA */
-	memcpy(&txh->TxFrameRA, &h->addr1, ETH_ALEN);
-
-	/* TxFrameID */
-	txh->TxFrameID = cpu_to_le16(frameid);
-
-	/*
-	 * TxStatus, Note the case of recreating the first frag of a suppressed
-	 * frame then we may need to reset the retry cnt's via the status reg
-	 */
-	txh->TxStatus = cpu_to_le16(status);
-
 	/*
-	 * extra fields for ucode AMPDU aggregation, the new fields are added to
-	 * the END of previous structure so that it's compatible in driver.
+	 * Check if flow control needs to be turned off after
+	 * sending the packet
 	 */
-	txh->MaxNMpdus = cpu_to_le16(0);
-	txh->MaxABytes_MRT = cpu_to_le16(0);
-	txh->MaxABytes_FBR = cpu_to_le16(0);
-	txh->MinMBytes = cpu_to_le16(0);
-
-	/* (5) RTS/CTS: determine RTS/CTS PLCP header and MAC duration,
-	 * furnish struct d11txh */
-	/* RTS PLCP header and RTS frame */
-	if (use_rts || use_cts) {
-		if (use_rts && use_cts)
-			use_cts = false;
-
-		for (k = 0; k < 2; k++) {
-			rts_rspec[k] = brcms_c_rspec_to_rts_rspec(wlc, rspec[k],
-							      false,
-							      mimo_ctlchbw);
+	if (!EDCF_ENAB(wlc->pub)
+	    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL)) {
+		if (brcms_c_txflowcontrol_prio_isset(wlc, qi, ALLPRIO)
+		    && (pktq_len(q) < wlc->pub->tunables->datahiwat / 2))
+			brcms_c_txflowcontrol(wlc, qi, OFF, ALLPRIO);
+	} else if (wlc->pub->_priofc) {
+		int prio;
+		for (prio = MAXPRIO; prio >= 0; prio--) {
+			if (brcms_c_txflowcontrol_prio_isset(wlc, qi, prio) &&
+			    (pktq_plen(q, wlc_prio2prec_map[prio]) <
+			    wlc->pub->tunables->datahiwat / 2))
+				brcms_c_txflowcontrol(wlc, qi, OFF, prio);
 		}
+	}
+	in_send_q = false;
+}
 
-		if (!IS_OFDM(rts_rspec[0]) &&
-		    !((RSPEC2RATE(rts_rspec[0]) == BRCM_RATE_1M) ||
-		      (wlc->PLCPHdr_override == BRCMS_PLCP_LONG))) {
-			rts_preamble_type[0] = BRCMS_SHORT_PREAMBLE;
-			mch |= TXC_PREAMBLE_RTS_MAIN_SHORT;
-		}
+static void brcms_c_war16165(struct brcms_c_info *wlc, bool tx)
+{
+	if (tx) {
+		/* the post-increment is used in STAY_AWAKE macro */
+		if (wlc->txpend16165war++ == 0)
+			brcms_c_set_ps_ctrl(wlc);
+	} else {
+		wlc->txpend16165war--;
+		if (wlc->txpend16165war == 0)
+			brcms_c_set_ps_ctrl(wlc);
+	}
+}
 
-		if (!IS_OFDM(rts_rspec[1]) &&
-		    !((RSPEC2RATE(rts_rspec[1]) == BRCM_RATE_1M) ||
-		      (wlc->PLCPHdr_override == BRCMS_PLCP_LONG))) {
-			rts_preamble_type[1] = BRCMS_SHORT_PREAMBLE;
-			mch |= TXC_PREAMBLE_RTS_FB_SHORT;
-		}
+void
+brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
+	       bool commit, s8 txpktpend)
+{
+	u16 frameid = INVALIDFID;
+	struct d11txh *txh;
 
-		/* RTS/CTS additions to MacTxControlLow */
-		if (use_cts) {
-			txh->MacTxControlLow |= cpu_to_le16(TXC_SENDCTS);
-		} else {
-			txh->MacTxControlLow |= cpu_to_le16(TXC_SENDRTS);
-			txh->MacTxControlLow |= cpu_to_le16(TXC_LONGFRAME);
-		}
+	txh = (struct d11txh *) (p->data);
 
-		/* RTS PLCP header */
-		rts_plcp = txh->RTSPhyHeader;
-		if (use_cts)
-			rts_phylen = DOT11_CTS_LEN + FCS_LEN;
-		else
-			rts_phylen = DOT11_RTS_LEN + FCS_LEN;
+	/* When a BC/MC frame is being committed to the BCMC fifo
+	 * via DMA (NOT PIO), update ucode or BSS info as appropriate.
+	 */
+	if (fifo == TX_BCMC_FIFO)
+		frameid = le16_to_cpu(txh->TxFrameID);
 
-		brcms_c_compute_plcp(wlc, rts_rspec[0], rts_phylen, rts_plcp);
+	if (BRCMS_WAR16165(wlc))
+		brcms_c_war16165(wlc, true);
 
-		/* fallback rate version of RTS PLCP header */
-		brcms_c_compute_plcp(wlc, rts_rspec[1], rts_phylen,
-				 rts_plcp_fallback);
-		memcpy(&txh->RTSPLCPFallback, rts_plcp_fallback,
-		       sizeof(txh->RTSPLCPFallback));
 
-		/* RTS frame fields... */
-		rts = (struct ieee80211_rts *)&txh->rts_frame;
+	/*
+	 * Bump up pending count for if not using rpc. If rpc is
+	 * used, this will be handled in brcms_b_txfifo()
+	 */
+	if (commit) {
+		TXPKTPENDINC(wlc, fifo, txpktpend);
+		BCMMSG(wlc->wiphy, "pktpend inc %d to %d\n",
+			 txpktpend, TXPKTPENDGET(wlc, fifo));
+	}
 
-		durid = brcms_c_compute_rtscts_dur(wlc, use_cts, rts_rspec[0],
-					       rspec[0], rts_preamble_type[0],
-					       preamble_type[0], phylen, false);
-		rts->duration = cpu_to_le16(durid);
-		/* fallback rate version of RTS DUR field */
-		durid = brcms_c_compute_rtscts_dur(wlc, use_cts,
-					       rts_rspec[1], rspec[1],
-					       rts_preamble_type[1],
-					       preamble_type[1], phylen, false);
-		txh->RTSDurFallback = cpu_to_le16(durid);
+	/* Commit BCMC sequence number in the SHM frame ID location */
+	if (frameid != INVALIDFID)
+		BCMCFID(wlc, frameid);
 
-		if (use_cts) {
-			rts->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
-							 IEEE80211_STYPE_CTS);
+	if (dma_txfast(wlc->hw->di[fifo], p, commit) < 0)
+		wiphy_err(wlc->wiphy, "txfifo: fatal, toss frames !!!\n");
+}
 
-			memcpy(&rts->ra, &h->addr2, ETH_ALEN);
-		} else {
-			rts->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
-							 IEEE80211_STYPE_RTS);
+/*
+ * Compute PLCP, but only requires actual rate and length of pkt.
+ * Rate is given in the driver standard multiple of 500 kbps.
+ * le is set for 11 Mbps rate if necessary.
+ * Broken out for PRQ.
+ */
+
+static void brcms_c_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
+			     uint length, u8 *plcp)
+{
+	u16 usec = 0;
+	u8 le = 0;
 
-			memcpy(&rts->ra, &h->addr1, 2 * ETH_ALEN);
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
 		}
+		break;
 
-		/* mainrate
-		 *    low 8 bits: main frag rate/mcs,
-		 *    high 8 bits: rts/cts rate/mcs
-		 */
-		mainrates |= (IS_OFDM(rts_rspec[0]) ?
-				D11A_PHY_HDR_GRATE(
-					(struct ofdm_phy_hdr *) rts_plcp) :
-				rts_plcp[0]) << 8;
-	} else {
-		memset((char *)txh->RTSPhyHeader, 0, D11_PHY_HDR_LEN);
-		memset((char *)&txh->rts_frame, 0,
-			sizeof(struct ieee80211_rts));
-		memset((char *)txh->RTSPLCPFallback, 0,
-		      sizeof(txh->RTSPLCPFallback));
-		txh->RTSDurFallback = 0;
+	default:
+		wiphy_err(wlc->wiphy,
+			  "brcms_c_cck_plcp_set: unsupported rate %d\n",
+			  rate_500);
+		rate_500 = BRCM_RATE_1M;
+		usec = length << 3;
+		break;
 	}
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
 
-#ifdef SUPPORT_40MHZ
-	/* add null delimiter count */
-	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && IS_MCS(rspec))
-		txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM] =
-		   brcm_c_ampdu_null_delim_cnt(wlc->ampdu, scb, rspec, phylen);
+/* Rate: 802.11 rate code, length: PSDU length in octets */
+static void brcms_c_compute_mimo_plcp(u32 rspec, uint length, u8 *plcp)
+{
+	u8 mcs = (u8) (rspec & RSPEC_RATE_MASK);
+	plcp[0] = mcs;
+	if (RSPEC_IS40MHZ(rspec) || (mcs == 32))
+		plcp[0] |= MIMO_PLCP_40MHZ;
+	BRCMS_SET_MIMO_PLCP_LEN(plcp, length);
+	plcp[3] = RSPEC_MIMOPLCP3(rspec); /* rspec already holds this byte */
+	plcp[3] |= 0x7; /* set smoothing, not sounding ppdu & reserved */
+	plcp[4] = 0; /* number of extension spatial streams bit 0 & 1 */
+	plcp[5] = 0;
+}
 
-#endif
+/* Rate: 802.11 rate code, length: PSDU length in octets */
+static void
+brcms_c_compute_ofdm_plcp(u32 rspec, u32 length, u8 *plcp)
+{
+	u8 rate_signal;
+	u32 tmp = 0;
+	int rate = RSPEC2RATE(rspec);
 
 	/*
-	 * Now that RTS/RTS FB preamble types are updated, write
-	 * the final value
+	 * encode rate per 802.11a-1999 sec 17.3.4.1, with lsb
+	 * transmitted first
 	 */
-	txh->MacTxControlHigh = cpu_to_le16(mch);
+	rate_signal = rate_info[rate] & BRCMS_RATE_MASK;
+	memset(plcp, 0, D11_PHY_HDR_LEN);
+	D11A_PHY_HDR_SRATE((struct ofdm_phy_hdr *) plcp, rate_signal);
 
-	/*
-	 * MainRates (both the rts and frag plcp rates have
-	 * been calculated now)
-	 */
-	txh->MainRates = cpu_to_le16(mainrates);
+	tmp = (length & 0xfff) << 5;
+	plcp[2] |= (tmp >> 16) & 0xff;
+	plcp[1] |= (tmp >> 8) & 0xff;
+	plcp[0] |= tmp & 0xff;
 
-	/* XtraFrameTypes */
-	xfts = FRAMETYPE(rspec[1], wlc->mimoft);
-	xfts |= (FRAMETYPE(rts_rspec[0], wlc->mimoft) << XFTS_RTS_FT_SHIFT);
-	xfts |= (FRAMETYPE(rts_rspec[1], wlc->mimoft) << XFTS_FBRRTS_FT_SHIFT);
-	xfts |=
-	    CHSPEC_CHANNEL(BRCMS_BAND_PI_RADIO_CHANSPEC) << XFTS_CHANNEL_SHIFT;
-	txh->XtraFrameTypes = cpu_to_le16(xfts);
+	return;
+}
 
-	/* PhyTxControlWord */
-	phyctl = FRAMETYPE(rspec[0], wlc->mimoft);
-	if ((preamble_type[0] == BRCMS_SHORT_PREAMBLE) ||
-	    (preamble_type[0] == BRCMS_GF_PREAMBLE)) {
-		if (RSPEC2RATE(rspec[0]) != BRCM_RATE_1M)
-			phyctl |= PHY_TXC_SHORT_HDR;
-	}
+/* Rate: 802.11 rate code, length: PSDU length in octets */
+static void brcms_c_compute_cck_plcp(struct brcms_c_info *wlc, u32 rspec,
+				 uint length, u8 *plcp)
+{
+	int rate = RSPEC2RATE(rspec);
 
-	/* phytxant is properly bit shifted */
-	phyctl |= brcms_c_stf_d11hdrs_phyctl_txant(wlc, rspec[0]);
-	txh->PhyTxControlWord = cpu_to_le16(phyctl);
+	brcms_c_cck_plcp_set(wlc, rate, length, plcp);
+}
 
-	/* PhyTxControlWord_1 */
-	if (BRCMS_PHY_11N_CAP(wlc->band)) {
-		u16 phyctl1 = 0;
+void
+brcms_c_compute_plcp(struct brcms_c_info *wlc, u32 rspec,
+		     uint length, u8 *plcp)
+{
+	if (IS_MCS(rspec))
+		brcms_c_compute_mimo_plcp(rspec, length, plcp);
+	else if (IS_OFDM(rspec))
+		brcms_c_compute_ofdm_plcp(rspec, length, plcp);
+	else
+		brcms_c_compute_cck_plcp(wlc, rspec, length, plcp);
+	return;
+}
 
-		phyctl1 = brcms_c_phytxctl1_calc(wlc, rspec[0]);
-		txh->PhyTxControlWord_1 = cpu_to_le16(phyctl1);
-		phyctl1 = brcms_c_phytxctl1_calc(wlc, rspec[1]);
-		txh->PhyTxControlWord_1_Fbr = cpu_to_le16(phyctl1);
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
 
-		if (use_rts || use_cts) {
-			phyctl1 = brcms_c_phytxctl1_calc(wlc, rts_rspec[0]);
-			txh->PhyTxControlWord_1_Rts = cpu_to_le16(phyctl1);
-			phyctl1 = brcms_c_phytxctl1_calc(wlc, rts_rspec[1]);
-			txh->PhyTxControlWord_1_FbrRts = cpu_to_le16(phyctl1);
-		}
+	sifs = SIFS(wlc->band);
 
-		/*
-		 * For mcs frames, if mixedmode(overloaded with long preamble)
-		 * is going to be set, fill in non-zero MModeLen and/or
-		 * MModeFbrLen it will be unnecessary if they are separated
-		 */
-		if (IS_MCS(rspec[0]) &&
-		    (preamble_type[0] == BRCMS_MM_PREAMBLE)) {
-			u16 mmodelen =
-			    brcms_c_calc_lsig_len(wlc, rspec[0], phylen);
-			txh->MModeLen = cpu_to_le16(mmodelen);
-		}
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
 
-		if (IS_MCS(rspec[1]) &&
-		    (preamble_type[1] == BRCMS_MM_PREAMBLE)) {
-			u16 mmodefbrlen =
-			    brcms_c_calc_lsig_len(wlc, rspec[1], phylen);
-			txh->MModeFbrLen = cpu_to_le16(mmodefbrlen);
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
+u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
+{
+	u16 phyctl1 = 0;
+	u16 bw;
+
+	if (BRCMS_ISLCNPHY(wlc->band)) {
+		bw = PHY_TXC1_BW_20MHZ;
+	} else {
+		bw = RSPEC_GET_BW(rspec);
+		/* 10Mhz is not supported yet */
+		if (bw < PHY_TXC1_BW_20MHZ) {
+			wiphy_err(wlc->wiphy, "phytxctl1_calc: bw %d is "
+				  "not supported yet, set to 20L\n", bw);
+			bw = PHY_TXC1_BW_20MHZ;
 		}
 	}
 
-	ac = skb_get_queue_mapping(p);
-	if (SCB_WME(scb) && qos && wlc->edcf_txop[ac]) {
-		uint frag_dur, dur, dur_fallback;
+	if (IS_MCS(rspec)) {
+		uint mcs = rspec & RSPEC_RATE_MASK;
 
-		/* WME: Update TXOP threshold */
-		if (!(tx_info->flags & IEEE80211_TX_CTL_AMPDU) && frag == 0) {
-			frag_dur =
-			    brcms_c_calc_frame_time(wlc, rspec[0],
-					preamble_type[0], phylen);
+		/* bw, stf, coding-type is part of RSPEC_PHYTXBYTE2 returns */
+		phyctl1 = RSPEC_PHYTXBYTE2(rspec);
+		/* set the upper byte of phyctl1 */
+		phyctl1 |= (mcs_table[mcs].tx_phy_ctl3 << 8);
+	} else if (IS_CCK(rspec) && !BRCMS_ISLCNPHY(wlc->band)
+		   && !BRCMS_ISSSLPNPHY(wlc->band)) {
+		/*
+		 * In CCK mode LPPHY overloads OFDM Modulation bits with CCK
+		 * Data Rate. Eventually MIMOPHY would also be converted to
+		 * this format
+		 */
+		/* 0 = 1Mbps; 1 = 2Mbps; 2 = 5.5Mbps; 3 = 11Mbps */
+		phyctl1 = (bw | (RSPEC_STF(rspec) << PHY_TXC1_MODE_SHIFT));
+	} else {		/* legacy OFDM/CCK */
+		s16 phycfg;
+		/* get the phyctl byte from rate phycfg table */
+		phycfg = brcms_c_rate_legacy_phyctl(RSPEC2RATE(rspec));
+		if (phycfg == -1) {
+			wiphy_err(wlc->wiphy, "phytxctl1_calc: wrong "
+				  "legacy OFDM/CCK rate\n");
+			phycfg = 0;
+		}
+		/* set the upper byte of phyctl1 */
+		phyctl1 =
+		    (bw | (phycfg << 8) |
+		     (RSPEC_STF(rspec) << PHY_TXC1_MODE_SHIFT));
+	}
+	return phyctl1;
+}
 
-			if (rts) {
-				/* 1 RTS or CTS-to-self frame */
-				dur =
-				    brcms_c_calc_cts_time(wlc, rts_rspec[0],
-						      rts_preamble_type[0]);
-				dur_fallback =
-				    brcms_c_calc_cts_time(wlc, rts_rspec[1],
-						      rts_preamble_type[1]);
-				/* (SIFS + CTS) + SIFS + frame + SIFS + ACK */
-				dur += le16_to_cpu(rts->duration);
-				dur_fallback +=
-					le16_to_cpu(txh->RTSDurFallback);
-			} else if (use_rifs) {
-				dur = frag_dur;
-				dur_fallback = 0;
-			} else {
-				/* frame + SIFS + ACK */
-				dur = frag_dur;
-				dur +=
-				    brcms_c_compute_frame_dur(wlc, rspec[0],
-							  preamble_type[0], 0);
+u32
+brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
+			   bool use_rspec, u16 mimo_ctlchbw)
+{
+	u32 rts_rspec = 0;
 
-				dur_fallback =
-				    brcms_c_calc_frame_time(wlc, rspec[1],
-							preamble_type[1],
-							phylen);
-				dur_fallback +=
-				    brcms_c_compute_frame_dur(wlc, rspec[1],
-							  preamble_type[1], 0);
-			}
-			/* NEED to set TxFesTimeNormal (hard) */
-			txh->TxFesTimeNormal = cpu_to_le16((u16) dur);
-			/*
-			 * NEED to set fallback rate version of
-			 * TxFesTimeNormal (hard)
-			 */
-			txh->TxFesTimeFallback =
-				cpu_to_le16((u16) dur_fallback);
+	if (use_rspec)
+		/* use frame rate as rts rate */
+		rts_rspec = rspec;
+	else if (wlc->band->gmode && wlc->protection->_g && !IS_CCK(rspec))
+		/* Use 11Mbps as the g protection RTS target rate and fallback.
+		 * Use the BRCMS_BASIC_RATE() lookup to find the best basic rate
+		 * under the target in case 11 Mbps is not Basic.
+		 * 6 and 9 Mbps are not usually selected by rate selection, but
+		 * even if the OFDM rate we are protecting is 6 or 9 Mbps, 11
+		 * is more robust.
+		 */
+		rts_rspec = BRCMS_BASIC_RATE(wlc, BRCM_RATE_11M);
+	else
+		/* calculate RTS rate and fallback rate based on the frame rate
+		 * RTS must be sent at a basic rate since it is a
+		 * control frame, sec 9.6 of 802.11 spec
+		 */
+		rts_rspec = BRCMS_BASIC_RATE(wlc, rspec);
 
-			/*
-			 * update txop byte threshold (txop minus intraframe
-			 * overhead)
-			 */
-			if (wlc->edcf_txop[ac] >= (dur - frag_dur)) {
-				uint newfragthresh;
+	if (BRCMS_PHY_11N_CAP(wlc->band)) {
+		/* set rts txbw to correct side band */
+		rts_rspec &= ~RSPEC_BW_MASK;
 
-				newfragthresh =
-				    brcms_c_calc_frame_len(wlc,
-					rspec[0], preamble_type[0],
-					(wlc->edcf_txop[ac] -
-						(dur - frag_dur)));
-				/* range bound the fragthreshold */
-				if (newfragthresh < DOT11_MIN_FRAG_LEN)
-					newfragthresh =
-					    DOT11_MIN_FRAG_LEN;
-				else if (newfragthresh >
-					 wlc->usr_fragthresh)
-					newfragthresh =
-					    wlc->usr_fragthresh;
-				/* update the fragthresh and do txc update */
-				if (wlc->fragthresh[queue] !=
-				    (u16) newfragthresh)
-					wlc->fragthresh[queue] =
-					    (u16) newfragthresh;
-			} else {
-				wiphy_err(wlc->wiphy, "wl%d: %s txop invalid "
-					  "for rate %d\n",
-					  wlc->pub->unit, fifo_names[queue],
-					  RSPEC2RATE(rspec[0]));
-			}
+		/*
+		 * if rspec/rspec_fallback is 40MHz, then send RTS on both
+		 * 20MHz channel (DUP), otherwise send RTS on control channel
+		 */
+		if (RSPEC_IS40MHZ(rspec) && !IS_CCK(rts_rspec))
+			rts_rspec |= (PHY_TXC1_BW_40MHZ_DUP << RSPEC_BW_SHIFT);
+		else
+			rts_rspec |= (mimo_ctlchbw << RSPEC_BW_SHIFT);
 
-			if (dur > wlc->edcf_txop[ac])
-				wiphy_err(wlc->wiphy, "wl%d: %s: %s txop "
-					  "exceeded phylen %d/%d dur %d/%d\n",
-					  wlc->pub->unit, __func__,
-					  fifo_names[queue],
-					  phylen, wlc->fragthresh[queue],
-					  dur, wlc->edcf_txop[ac]);
+		/* pick siso/cdd as default for ofdm */
+		if (IS_OFDM(rts_rspec)) {
+			rts_rspec &= ~RSPEC_STF_MASK;
+			rts_rspec |= (wlc->stf->ss_opmode << RSPEC_STF_SHIFT);
 		}
 	}
-
-	return 0;
+	return rts_rspec;
 }
 
 void brcms_c_tbtt(struct brcms_c_info *wlc)
@@ -7878,19 +8079,6 @@ void brcms_c_tbtt(struct brcms_c_info *wlc)
 		wlc->qvalid |= MCMD_DIRFRMQVAL;
 }
 
-static void brcms_c_war16165(struct brcms_c_info *wlc, bool tx)
-{
-	if (tx) {
-		/* the post-increment is used in STAY_AWAKE macro */
-		if (wlc->txpend16165war++ == 0)
-			brcms_c_set_ps_ctrl(wlc);
-	} else {
-		wlc->txpend16165war--;
-		if (wlc->txpend16165war == 0)
-			brcms_c_set_ps_ctrl(wlc);
-	}
-}
-
 /* process an individual struct tx_status */
 bool
 brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs, u32 frm_tx2)
@@ -8507,101 +8695,6 @@ brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 	return dur;
 }
 
-/* The opposite of brcms_c_calc_frame_time */
-static uint
-brcms_c_calc_frame_len(struct brcms_c_info *wlc, u32 ratespec,
-		   u8 preamble_type, uint dur)
-{
-	uint nsyms, mac_len, Ndps, kNdps;
-	uint rate = RSPEC2RATE(ratespec);
-
-	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d, dur %d\n",
-		 wlc->pub->unit, ratespec, preamble_type, dur);
-
-	if (IS_MCS(ratespec)) {
-		uint mcs = ratespec & RSPEC_RATE_MASK;
-		int tot_streams = MCS_TXS(mcs) + RSPEC_STC(ratespec);
-		dur -= PREN_PREAMBLE + (tot_streams * PREN_PREAMBLE_EXT);
-		/* payload calculation matches that of regular ofdm */
-		if (BAND_2G(wlc->band->bandtype))
-			dur -= DOT11_OFDM_SIGNAL_EXTENSION;
-		/* kNdbps = kbps * 4 */
-		kNdps =
-		    MCS_RATE(mcs, RSPEC_IS40MHZ(ratespec),
-			     RSPEC_ISSGI(ratespec)) * 4;
-		nsyms = dur / APHY_SYMBOL_TIME;
-		mac_len =
-		    ((nsyms * kNdps) -
-		     ((APHY_SERVICE_NBITS + APHY_TAIL_NBITS) * 1000)) / 8000;
-	} else if (IS_OFDM(ratespec)) {
-		dur -= APHY_PREAMBLE_TIME;
-		dur -= APHY_SIGNAL_TIME;
-		/* Ndbps = Mbps * 4 = rate(500Kbps) * 2 */
-		Ndps = rate * 2;
-		nsyms = dur / APHY_SYMBOL_TIME;
-		mac_len =
-		    ((nsyms * Ndps) -
-		     (APHY_SERVICE_NBITS + APHY_TAIL_NBITS)) / 8;
-	} else {
-		if (preamble_type & BRCMS_SHORT_PREAMBLE)
-			dur -= BPHY_PLCP_SHORT_TIME;
-		else
-			dur -= BPHY_PLCP_TIME;
-		mac_len = dur * rate;
-		/* divide out factor of 2 in rate (1/2 mbps) */
-		mac_len = mac_len / 8 / 2;
-	}
-	return mac_len;
-}
-
-static uint
-brcms_c_calc_ba_time(struct brcms_c_info *wlc, u32 rspec,
-		     u8 preamble_type)
-{
-	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, "
-		 "preamble_type %d\n", wlc->pub->unit, rspec, preamble_type);
-	/*
-	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
-	 * is less than or equal to the rate of the immediately previous
-	 * frame in the FES
-	 */
-	rspec = BRCMS_BASIC_RATE(wlc, rspec);
-	/* BA len == 32 == 16(ctl hdr) + 4(ba len) + 8(bitmap) + 4(fcs) */
-	return brcms_c_calc_frame_time(wlc, rspec, preamble_type,
-				   (DOT11_BA_LEN + DOT11_BA_BITMAP_LEN +
-				    FCS_LEN));
-}
-
-static uint
-brcms_c_calc_ack_time(struct brcms_c_info *wlc, u32 rspec,
-		      u8 preamble_type)
-{
-	uint dur = 0;
-
-	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d\n",
-		wlc->pub->unit, rspec, preamble_type);
-	/*
-	 * Spec 9.6: ack rate is the highest rate in BSSBasicRateSet that
-	 * is less than or equal to the rate of the immediately previous
-	 * frame in the FES
-	 */
-	rspec = BRCMS_BASIC_RATE(wlc, rspec);
-	/* ACK frame len == 14 == 2(fc) + 2(dur) + 6(ra) + 4(fcs) */
-	dur =
-	    brcms_c_calc_frame_time(wlc, rspec, preamble_type,
-				(DOT11_ACK_LEN + FCS_LEN));
-	return dur;
-}
-
-static uint
-brcms_c_calc_cts_time(struct brcms_c_info *wlc, u32 rspec,
-		      u8 preamble_type)
-{
-	BCMMSG(wlc->wiphy, "wl%d: ratespec 0x%x, preamble_type %d\n",
-		wlc->pub->unit, rspec, preamble_type);
-	return brcms_c_calc_ack_time(wlc, rspec, preamble_type);
-}
-
 /* derive wlc->band->basic_rate[] table from 'rateset' */
 void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
 			      struct brcms_c_rateset *rateset)
@@ -8816,30 +8909,6 @@ bool brcms_c_valid_rate(struct brcms_c_info *wlc, u32 rspec, int band,
 	return false;
 }
 
-static void brcms_c_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap)
-{
-	uint i;
-	struct brcms_band *band;
-
-	for (i = 0; i < NBANDS(wlc); i++) {
-		if (IS_SINGLEBAND_5G(wlc->deviceid))
-			i = BAND_5G_INDEX;
-		band = wlc->bandstate[i];
-		if (band->bandtype == BRCM_BAND_5G) {
-			if ((bwcap == BRCMS_N_BW_40ALL)
-			    || (bwcap == BRCMS_N_BW_20IN2G_40IN5G))
-				band->mimo_cap_40 = true;
-			else
-				band->mimo_cap_40 = false;
-		} else {
-			if (bwcap == BRCMS_N_BW_40ALL)
-				band->mimo_cap_40 = true;
-			else
-				band->mimo_cap_40 = false;
-		}
-	}
-}
-
 void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 {
 	const struct brcms_c_rateset *rs_dflt;
@@ -8984,6 +9053,12 @@ brcms_b_write_hw_bcntemplates(struct brcms_hardware *wlc_hw, u16 bcn[],
 	}
 }
 
+void brcms_c_write_hw_bcntemplates(struct brcms_c_info *wlc, u16 bcn[], int len,
+				   bool both)
+{
+	brcms_b_write_hw_bcntemplates(wlc->hw, bcn, len, both);
+}
+
 /*
  * Update a beacon for a particular BSS
  * For MBSS, this updates the software template and sets "latest" to
@@ -9180,182 +9255,6 @@ void brcms_default_rateset(struct brcms_c_info *wlc, struct brcms_c_rateset *rs)
 		wlc->stf->txstreams);
 }
 
-static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
-{
-	u16 chanspec;
-	struct brcms_band *band;
-	struct brcms_bss_info *bi = wlc->default_bss;
-
-	/* init default and target BSS with some sane initial values */
-	memset((char *)(bi), 0, sizeof(struct brcms_bss_info));
-	bi->beacon_period = BEACON_INTERVAL_DEFAULT;
-	bi->dtim_period = DTIM_INTERVAL_DEFAULT;
-
-	/* fill the default channel as the first valid channel
-	 * starting from the 2G channels
-	 */
-	chanspec = CH20MHZ_CHSPEC(1);
-	wlc->home_chanspec = bi->chanspec = chanspec;
-
-	/* find the band of our default channel */
-	band = wlc->band;
-	if (NBANDS(wlc) > 1 && band->bandunit != CHSPEC_BANDUNIT(chanspec))
-		band = wlc->bandstate[OTHERBANDUNIT(wlc)];
-
-	/* init bss rates to the band specific default rate set */
-	brcms_c_rateset_default(&bi->rateset, NULL, band->phytype,
-		band->bandtype, false, BRCMS_RATE_MASK_FULL,
-		(bool) N_ENAB(wlc->pub), CHSPEC_WLC_BW(chanspec),
-		wlc->stf->txstreams);
-
-	if (N_ENAB(wlc->pub))
-		bi->flags |= BRCMS_BSS_HT;
-}
-
-static u32
-mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
-		       u32 int_val)
-{
-	u8 stf = (int_val & NRATE_STF_MASK) >> NRATE_STF_SHIFT;
-	u8 rate = int_val & NRATE_RATE_MASK;
-	u32 rspec;
-	bool ismcs = ((int_val & NRATE_MCS_INUSE) == NRATE_MCS_INUSE);
-	bool issgi = ((int_val & NRATE_SGI_MASK) >> NRATE_SGI_SHIFT);
-	bool override_mcs_only = ((int_val & NRATE_OVERRIDE_MCS_ONLY)
-				  == NRATE_OVERRIDE_MCS_ONLY);
-	int bcmerror = 0;
-
-	if (!ismcs)
-		return (u32) rate;
-
-	/* validate the combination of rate/mcs/stf is allowed */
-	if (N_ENAB(wlc->pub) && ismcs) {
-		/* mcs only allowed when nmode */
-		if (stf > PHY_TXC1_MODE_SDM) {
-			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid stf\n",
-				 BRCMS_UNIT(wlc), __func__);
-			bcmerror = -EINVAL;
-			goto done;
-		}
-
-		/* mcs 32 is a special case, DUP mode 40 only */
-		if (rate == 32) {
-			if (!CHSPEC_IS40(wlc->home_chanspec) ||
-			    ((stf != PHY_TXC1_MODE_SISO)
-			     && (stf != PHY_TXC1_MODE_CDD))) {
-				wiphy_err(wlc->wiphy, "wl%d: %s: Invalid mcs "
-					  "32\n", BRCMS_UNIT(wlc), __func__);
-				bcmerror = -EINVAL;
-				goto done;
-			}
-			/* mcs > 7 must use stf SDM */
-		} else if (rate > HIGHEST_SINGLE_STREAM_MCS) {
-			/* mcs > 7 must use stf SDM */
-			if (stf != PHY_TXC1_MODE_SDM) {
-				BCMMSG(wlc->wiphy, "wl%d: enabling "
-					 "SDM mode for mcs %d\n",
-					 BRCMS_UNIT(wlc), rate);
-				stf = PHY_TXC1_MODE_SDM;
-			}
-		} else {
-			/*
-			 * MCS 0-7 may use SISO, CDD, and for
-			 * phy_rev >= 3 STBC
-			 */
-			if ((stf > PHY_TXC1_MODE_STBC) ||
-			    (!BRCMS_STBC_CAP_PHY(wlc)
-			     && (stf == PHY_TXC1_MODE_STBC))) {
-				wiphy_err(wlc->wiphy, "wl%d: %s: Invalid STBC"
-					  "\n", BRCMS_UNIT(wlc), __func__);
-				bcmerror = -EINVAL;
-				goto done;
-			}
-		}
-	} else if (IS_OFDM(rate)) {
-		if ((stf != PHY_TXC1_MODE_CDD) && (stf != PHY_TXC1_MODE_SISO)) {
-			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid OFDM\n",
-				  BRCMS_UNIT(wlc), __func__);
-			bcmerror = -EINVAL;
-			goto done;
-		}
-	} else if (IS_CCK(rate)) {
-		if ((cur_band->bandtype != BRCM_BAND_2G)
-		    || (stf != PHY_TXC1_MODE_SISO)) {
-			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid CCK\n",
-				  BRCMS_UNIT(wlc), __func__);
-			bcmerror = -EINVAL;
-			goto done;
-		}
-	} else {
-		wiphy_err(wlc->wiphy, "wl%d: %s: Unknown rate type\n",
-			  BRCMS_UNIT(wlc), __func__);
-		bcmerror = -EINVAL;
-		goto done;
-	}
-	/* make sure multiple antennae are available for non-siso rates */
-	if ((stf != PHY_TXC1_MODE_SISO) && (wlc->stf->txstreams == 1)) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: SISO antenna but !SISO "
-			  "request\n", BRCMS_UNIT(wlc), __func__);
-		bcmerror = -EINVAL;
-		goto done;
-	}
-
-	rspec = rate;
-	if (ismcs) {
-		rspec |= RSPEC_MIMORATE;
-		/* For STBC populate the STC field of the ratespec */
-		if (stf == PHY_TXC1_MODE_STBC) {
-			u8 stc;
-			stc = 1;	/* Nss for single stream is always 1 */
-			rspec |= (stc << RSPEC_STC_SHIFT);
-		}
-	}
-
-	rspec |= (stf << RSPEC_STF_SHIFT);
-
-	if (override_mcs_only)
-		rspec |= RSPEC_OVERRIDE_MCS_ONLY;
-
-	if (issgi)
-		rspec |= RSPEC_SHORT_GI;
-
-	if ((rate != 0)
-	    && !brcms_c_valid_rate(wlc, rspec, cur_band->bandtype, true))
-		return rate;
-
-	return rspec;
-done:
-	return rate;
-}
-
-/* formula:  IDLE_BUSY_RATIO_X_16 = (100-duty_cycle)/duty_cycle*16 */
-static int
-brcms_c_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle, bool isOFDM,
-		   bool writeToShm)
-{
-	int idle_busy_ratio_x_16 = 0;
-	uint offset =
-	    isOFDM ? M_TX_IDLE_BUSY_RATIO_X_16_OFDM :
-	    M_TX_IDLE_BUSY_RATIO_X_16_CCK;
-	if (duty_cycle > 100 || duty_cycle < 0) {
-		wiphy_err(wlc->wiphy, "wl%d:  duty cycle value off limit\n",
-			  wlc->pub->unit);
-		return -EINVAL;
-	}
-	if (duty_cycle)
-		idle_busy_ratio_x_16 = (100 - duty_cycle) * 16 / duty_cycle;
-	/* Only write to shared memory  when wl is up */
-	if (writeToShm)
-		brcms_c_write_shm(wlc, offset, (u16) idle_busy_ratio_x_16);
-
-	if (isOFDM)
-		wlc->tx_duty_cycle_ofdm = (u16) duty_cycle;
-	else
-		wlc->tx_duty_cycle_cck = (u16) duty_cycle;
-
-	return 0;
-}
-
 /* Read a single u16 from shared memory.
  * SHM 'offset' needs to be an even address
  */
@@ -9420,12 +9319,6 @@ void brcms_c_write_template_ram(struct brcms_c_info *wlc, int offset, int len,
 	brcms_b_write_template_ram(wlc->hw, offset, len, buf);
 }
 
-void brcms_c_write_hw_bcntemplates(struct brcms_c_info *wlc, u16 bcn[], int len,
-				   bool both)
-{
-	brcms_b_write_hw_bcntemplates(wlc->hw, bcn, len, both);
-}
-
 void
 brcms_c_set_addrmatch(struct brcms_c_info *wlc, int match_reg_offset,
 		  const u8 *addr)
@@ -9545,76 +9438,6 @@ brcms_c_txflowcontrol_override(struct brcms_c_info *wlc,
 	}
 }
 
-static void brcms_c_txflowcontrol_reset(struct brcms_c_info *wlc)
-{
-	struct brcms_txq_info *qi;
-
-	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next) {
-		if (qi->stopped) {
-			brcms_c_txflowcontrol_signal(wlc, qi, OFF, ALLPRIO);
-			qi->stopped = 0;
-		}
-	}
-}
-
-static void
-brcms_c_txflowcontrol_signal(struct brcms_c_info *wlc,
-			     struct brcms_txq_info *qi, bool on, int prio)
-{
-	/* wlcif_list is never filled so this function is not functional yet */
-}
-
-static struct brcms_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc)
-{
-	struct brcms_txq_info *qi, *p;
-
-	qi = kzalloc(sizeof(struct brcms_txq_info), GFP_ATOMIC);
-	if (qi != NULL) {
-		/*
-		 * Have enough room for control packets along with HI watermark
-		 * Also, add room to txq for total psq packets if all the SCBs
-		 * leave PS mode. The watermark for flowcontrol to OS packets
-		 * will remain the same
-		 */
-		brcmu_pktq_init(&qi->q, BRCMS_PREC_COUNT,
-			  (2 * wlc->pub->tunables->datahiwat) + PKTQ_LEN_DEFAULT
-			  + wlc->pub->psq_pkts_total);
-
-		/* add this queue to the the global list */
-		p = wlc->tx_queues;
-		if (p == NULL) {
-			wlc->tx_queues = qi;
-		} else {
-			while (p->next != NULL)
-				p = p->next;
-			p->next = qi;
-		}
-	}
-	return qi;
-}
-
-static void brcms_c_txq_free(struct brcms_c_info *wlc,
-			     struct brcms_txq_info *qi)
-{
-	struct brcms_txq_info *p;
-
-	if (qi == NULL)
-		return;
-
-	/* remove the queue from the linked list */
-	p = wlc->tx_queues;
-	if (p == qi)
-		wlc->tx_queues = p->next;
-	else {
-		while (p != NULL && p->next != qi)
-			p = p->next;
-		if (p != NULL)
-			p->next = p->next->next;
-	}
-
-	kfree(qi);
-}
-
 /*
  * Flag 'scan in progress' to withhold dynamic phy calibration
  */
-- 
1.7.4.1


