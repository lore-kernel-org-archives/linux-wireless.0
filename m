Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2928 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758778Ab1EMKAQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:16 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 06/32] staging: brcm80211: remove unnecessary functions
 from wlc_main.c
Date: Fri, 13 May 2011 11:59:26 +0200
Message-ID: <1305280792-9475-6-git-send-email-arend@broadcom.com> (sfid-20110513_120038_395038_13CE6D62)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Couple of functions were not needed and have been removed.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |  445 +------------------------
 drivers/staging/brcm80211/brcmsmac/wlc_main.h |   24 --
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h  |   11 -
 3 files changed, 4 insertions(+), 476 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 2fed0eb..259544e 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -277,8 +277,6 @@ static void wlc_txflowcontrol_signal(struct wlc_info *wlc,
 				     struct wlc_txq_info *qi,
 				     bool on, int prio);
 static void wlc_txflowcontrol_reset(struct wlc_info *wlc);
-static u16 wlc_compute_airtime(struct wlc_info *wlc, ratespec_t rspec,
-				  uint length);
 static void wlc_compute_cck_plcp(struct wlc_info *wlc, ratespec_t rate,
 				 uint length, u8 *plcp);
 static void wlc_compute_ofdm_plcp(ratespec_t rate, uint length, u8 *plcp);
@@ -326,35 +324,6 @@ static void wlc_ofdm_rateset_war(struct wlc_info *wlc);
 static int _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		      struct wlc_if *wlcif);
 
-#if defined(BCMDBG)
-void wlc_get_rcmta(struct wlc_info *wlc, int idx, u8 *addr)
-{
-	d11regs_t *regs = wlc->regs;
-	u32 v32;
-
-	BCMMSG(wlc->wiphy, "wl%d\n", WLCWLUNIT(wlc));
-
-	W_REG(&regs->objaddr, (OBJADDR_RCMTA_SEL | (idx * 2)));
-	(void)R_REG(&regs->objaddr);
-	v32 = R_REG(&regs->objdata);
-	addr[0] = (u8) v32;
-	addr[1] = (u8) (v32 >> 8);
-	addr[2] = (u8) (v32 >> 16);
-	addr[3] = (u8) (v32 >> 24);
-	W_REG(&regs->objaddr, (OBJADDR_RCMTA_SEL | ((idx * 2) + 1)));
-	(void)R_REG(&regs->objaddr);
-	v32 = R_REG(&regs->objdata);
-	addr[4] = (u8) v32;
-	addr[5] = (u8) (v32 >> 8);
-}
-#endif				/* defined(BCMDBG) */
-
-/* keep the chip awake if needed */
-bool wlc_stay_awake(struct wlc_info *wlc)
-{
-	return true;
-}
-
 /* conditions under which the PM bit should be set in outgoing frames and STAY_AWAKE is meaningful
  */
 bool wlc_ps_allowed(struct wlc_info *wlc)
@@ -607,27 +576,23 @@ void wlc_mac_promisc(struct wlc_info *wlc)
 void wlc_set_ps_ctrl(struct wlc_info *wlc)
 {
 	u32 v1, v2;
-	bool hps, wake;
+	bool hps;
 	bool awake_before;
 
 	hps = PS_ALLOWED(wlc);
-	wake = hps ? (STAY_AWAKE(wlc)) : true;
 
-	BCMMSG(wlc->wiphy, "wl%d: hps %d wake %d\n",
-		 wlc->pub->unit, hps, wake);
+	BCMMSG(wlc->wiphy, "wl%d: hps %d\n", wlc->pub->unit, hps);
 
 	v1 = R_REG(&wlc->regs->maccontrol);
-	v2 = 0;
+	v2 = MCTL_WAKE;
 	if (hps)
 		v2 |= MCTL_HPS;
-	if (wake)
-		v2 |= MCTL_WAKE;
 
 	wlc_mctrl(wlc, MCTL_WAKE | MCTL_HPS, v2);
 
 	awake_before = ((v1 & MCTL_WAKE) || ((v1 & MCTL_HPS) == 0));
 
-	if (wake && !awake_before)
+	if (!awake_before)
 		wlc_bmac_wait_for_wake(wlc->hw);
 
 }
@@ -2227,23 +2192,6 @@ bool wlc_radio_monitor_stop(struct wlc_info *wlc)
 	return wl_del_timer(wlc->wl, wlc->radio_timer);
 }
 
-/* bring the driver down, but don't reset hardware */
-void wlc_out(struct wlc_info *wlc)
-{
-	wlc_bmac_set_noreset(wlc->hw, true);
-	wlc_radio_upd(wlc);
-	wl_down(wlc->wl);
-	wlc_bmac_set_noreset(wlc->hw, false);
-
-	/* core clk is true in BMAC driver due to noreset, need to mirror it in HIGH */
-	wlc->clk = true;
-
-	/* This will make sure that when 'up' is done
-	 * after 'out' it'll restore hardware (especially gpios)
-	 */
-	wlc->pub->hw_up = false;
-}
-
 static void wlc_watchdog_by_timer(void *arg)
 {
 	struct wlc_info *wlc = (struct wlc_info *) arg;
@@ -3999,16 +3947,6 @@ int wlc_iocregchk(struct wlc_info *wlc, uint band)
 }
 #endif				/* defined(BCMDBG) */
 
-#if defined(BCMDBG)
-/* For some ioctls, make sure that the pi pointer matches the current phy */
-int wlc_iocpichk(struct wlc_info *wlc, uint phytype)
-{
-	if (wlc->band->phytype != phytype)
-		return -EINVAL;
-	return 0;
-}
-#endif
-
 /* Look up the given var name in the given table */
 static const bcm_iovar_t *wlc_iovar_lookup(const bcm_iovar_t *table,
 					   const char *name)
@@ -4046,21 +3984,6 @@ int wlc_iovar_setint(struct wlc_info *wlc, const char *name, int arg)
 			    IOV_SET, NULL);
 }
 
-/* simplified s8 get interface for common WLC_GET_VAR ioctl handler */
-int wlc_iovar_gets8(struct wlc_info *wlc, const char *name, s8 *arg)
-{
-	int iovar_int;
-	int err;
-
-	err =
-	    wlc_iovar_op(wlc, name, NULL, 0, &iovar_int, sizeof(iovar_int),
-			 IOV_GET, NULL);
-	if (!err)
-		*arg = (s8) iovar_int;
-
-	return err;
-}
-
 /*
  * register iovar table, watchdog and down handlers.
  * calling function must keep 'iovars' until wlc_module_unregister is called.
@@ -5068,51 +4991,6 @@ wlc_txfifo(struct wlc_info *wlc, uint fifo, struct sk_buff *p, bool commit,
 	}
 }
 
-static u16
-wlc_compute_airtime(struct wlc_info *wlc, ratespec_t rspec, uint length)
-{
-	u16 usec = 0;
-	uint mac_rate = RSPEC2RATE(rspec);
-	uint nsyms;
-
-	if (IS_MCS(rspec)) {
-		/* not supported yet */
-	} else if (IS_OFDM(rspec)) {
-		/* nsyms = Ceiling(Nbits / (Nbits/sym))
-		 *
-		 * Nbits = length * 8
-		 * Nbits/sym = Mbps * 4 = mac_rate * 2
-		 */
-		nsyms = CEIL((length * 8), (mac_rate * 2));
-
-		/* usec = symbols * usec/symbol */
-		usec = (u16) (nsyms * APHY_SYMBOL_TIME);
-		return usec;
-	} else {
-		switch (mac_rate) {
-		case WLC_RATE_1M:
-			usec = length << 3;
-			break;
-		case WLC_RATE_2M:
-			usec = length << 2;
-			break;
-		case WLC_RATE_5M5:
-			usec = (length << 4) / 11;
-			break;
-		case WLC_RATE_11M:
-			usec = (length << 3) / 11;
-			break;
-		default:
-			wiphy_err(wlc->wiphy, "wl%d: wlc_compute_airtime: "
-				  "unsupported rspec 0x%x\n",
-				  wlc->pub->unit, rspec);
-			break;
-		}
-	}
-
-	return usec;
-}
-
 void
 wlc_compute_plcp(struct wlc_info *wlc, ratespec_t rspec, uint length, u8 *plcp)
 {
@@ -6070,122 +5948,6 @@ void wlc_tbtt(struct wlc_info *wlc, d11regs_t *regs)
 	}
 }
 
-/* GP timer is a freerunning 32 bit counter, decrements at 1 us rate */
-void wlc_hwtimer_gptimer_set(struct wlc_info *wlc, uint us)
-{
-	W_REG(&wlc->regs->gptimer, us);
-}
-
-void wlc_hwtimer_gptimer_abort(struct wlc_info *wlc)
-{
-	W_REG(&wlc->regs->gptimer, 0);
-}
-
-static void wlc_hwtimer_gptimer_cb(struct wlc_info *wlc)
-{
-	/* when interrupt is generated, the counter is loaded with last value
-	 * written and continue to decrement. So it has to be cleaned first
-	 */
-	W_REG(&wlc->regs->gptimer, 0);
-}
-
-/*
- * This fn has all the high level dpc processing from wlc_dpc.
- * POLICY: no macinstatus change, no bounding loop.
- *         All dpc bounding should be handled in BMAC dpc, like txstatus and rxint
- */
-void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus)
-{
-	d11regs_t *regs = wlc->regs;
-#ifdef BCMDBG
-	char flagstr[128];
-	static const bcm_bit_desc_t int_flags[] = {
-		{MI_MACSSPNDD, "MACSSPNDD"},
-		{MI_BCNTPL, "BCNTPL"},
-		{MI_TBTT, "TBTT"},
-		{MI_BCNSUCCESS, "BCNSUCCESS"},
-		{MI_BCNCANCLD, "BCNCANCLD"},
-		{MI_ATIMWINEND, "ATIMWINEND"},
-		{MI_PMQ, "PMQ"},
-		{MI_NSPECGEN_0, "NSPECGEN_0"},
-		{MI_NSPECGEN_1, "NSPECGEN_1"},
-		{MI_MACTXERR, "MACTXERR"},
-		{MI_NSPECGEN_3, "NSPECGEN_3"},
-		{MI_PHYTXERR, "PHYTXERR"},
-		{MI_PME, "PME"},
-		{MI_GP0, "GP0"},
-		{MI_GP1, "GP1"},
-		{MI_DMAINT, "DMAINT"},
-		{MI_TXSTOP, "TXSTOP"},
-		{MI_CCA, "CCA"},
-		{MI_BG_NOISE, "BG_NOISE"},
-		{MI_DTIM_TBTT, "DTIM_TBTT"},
-		{MI_PRQ, "PRQ"},
-		{MI_PWRUP, "PWRUP"},
-		{MI_RFDISABLE, "RFDISABLE"},
-		{MI_TFS, "TFS"},
-		{MI_PHYCHANGED, "PHYCHANGED"},
-		{MI_TO, "TO"},
-		{0, NULL}
-	};
-
-	if (macintstatus & ~(MI_TBTT | MI_TXSTOP)) {
-		bcm_format_flags(int_flags, macintstatus, flagstr,
-				 sizeof(flagstr));
-		BCMMSG(wlc->wiphy, "wl%d: macintstatus 0x%x %s\n",
-			 wlc->pub->unit, macintstatus, flagstr);
-	}
-#endif				/* BCMDBG */
-
-	/* TBTT indication */
-	/* ucode only gives either TBTT or DTIM_TBTT, not both */
-	if (macintstatus & (MI_TBTT | MI_DTIM_TBTT))
-		wlc_tbtt(wlc, regs);
-
-	if (macintstatus & MI_GP0) {
-		wiphy_err(wlc->wiphy, "wl%d: PSM microcode watchdog fired at "
-			  "%d (seconds). Resetting.\n",
-			  wlc->pub->unit, wlc->pub->now);
-
-		printk_once("%s : PSM Watchdog, chipid 0x%x, chiprev 0x%x\n",
-					__func__, wlc->pub->sih->chip,
-					wlc->pub->sih->chiprev);
-
-		wlc->pub->_cnt->psmwds++;
-
-		/* big hammer */
-		wl_init(wlc->wl);
-	}
-
-	/* gptimer timeout */
-	if (macintstatus & MI_TO) {
-		wlc_hwtimer_gptimer_cb(wlc);
-	}
-
-	if (macintstatus & MI_RFDISABLE) {
-		wiphy_err(wlc->wiphy, "wl%d: MAC Detected a change on the RF "
-			  "Disable Input 0x%x\n", wlc->pub->unit,
-			  R_REG(&regs->phydebug) & PDBG_RFD);
-		/* delay the cleanup to wl_down in IBSS case */
-		if ((R_REG(&regs->phydebug) & PDBG_RFD)) {
-			int idx;
-			struct wlc_bsscfg *bsscfg;
-			FOREACH_BSS(wlc, idx, bsscfg) {
-				if (!BSSCFG_STA(bsscfg) || !bsscfg->enable
-				    || !bsscfg->BSS)
-					continue;
-				wiphy_err(wlc->wiphy, "wl%d: wlc_dpc: "
-					  "rfdisable -> wlc_bsscfg_disable()"
-					  "\n", wlc->pub->unit);
-			}
-		}
-	}
-
-	/* send any enq'd tx packets. Just makes sure to jump start tx */
-	if (!pktq_empty(&wlc->pkt_queue->q))
-		wlc_send_q(wlc);
-}
-
 static void wlc_war16165(struct wlc_info *wlc, bool tx)
 {
 	if (tx) {
@@ -6386,84 +6148,6 @@ wlc_txfifo_complete(struct wlc_info *wlc, uint fifo, s8 txpktpend)
 	/* figure out which bsscfg is being worked on... */
 }
 
-/* Given the beacon interval in kus, and a 64 bit TSF in us,
- * return the offset (in us) of the TSF from the last TBTT
- */
-u32 wlc_calc_tbtt_offset(u32 bp, u32 tsf_h, u32 tsf_l)
-{
-	u32 k, btklo, btkhi, offset;
-
-	/* TBTT is always an even multiple of the beacon_interval,
-	 * so the TBTT less than or equal to the beacon timestamp is
-	 * the beacon timestamp minus the beacon timestamp modulo
-	 * the beacon interval.
-	 *
-	 * TBTT = BT - (BT % BIu)
-	 *      = (BTk - (BTk % BP)) * 2^10
-	 *
-	 * BT = beacon timestamp (usec, 64bits)
-	 * BTk = beacon timestamp (Kusec, 54bits)
-	 * BP = beacon interval (Kusec, 16bits)
-	 * BIu = BP * 2^10 = beacon interval (usec, 26bits)
-	 *
-	 * To keep the calculations in u32s, the modulo operation
-	 * on the high part of BT needs to be done in parts using the
-	 * relations:
-	 * X*Y mod Z = ((X mod Z) * (Y mod Z)) mod Z
-	 * and
-	 * (X + Y) mod Z = ((X mod Z) + (Y mod Z)) mod Z
-	 *
-	 * So, if BTk[n] = u16 n [0,3] of BTk.
-	 * BTk % BP = SUM((BTk[n] * 2^16n) % BP , 0<=n<4) % BP
-	 * and the SUM term can be broken down:
-	 * (BTk[n] *     2^16n)    % BP
-	 * (BTk[n] * (2^16n % BP)) % BP
-	 *
-	 * Create a set of power of 2 mod BP constants:
-	 * K[n] = 2^(16n) % BP
-	 *      = (K[n-1] * 2^16) % BP
-	 * K[2] = 2^32 % BP = ((2^16 % BP) * 2^16) % BP
-	 *
-	 * BTk % BP = BTk[0-1] % BP +
-	 *            (BTk[2] * K[2]) % BP +
-	 *            (BTk[3] * K[3]) % BP
-	 *
-	 * Since K[n] < 2^16 and BTk[n] is < 2^16, then BTk[n] * K[n] < 2^32
-	 */
-
-	/* BTk = BT >> 10, btklo = BTk[0-3], bkthi = BTk[4-6] */
-	btklo = (tsf_h << 22) | (tsf_l >> 10);
-	btkhi = tsf_h >> 10;
-
-	/* offset = BTk % BP */
-	offset = btklo % bp;
-
-	/* K[2] = ((2^16 % BP) * 2^16) % BP */
-	k = (u32) (1 << 16) % bp;
-	k = (u32) (k * 1 << 16) % (u32) bp;
-
-	/* offset += (BTk[2] * K[2]) % BP */
-	offset += ((btkhi & 0xffff) * k) % bp;
-
-	/* BTk[3] */
-	btkhi = btkhi >> 16;
-
-	/* k[3] = (K[2] * 2^16) % BP */
-	k = (k << 16) % bp;
-
-	/* offset += (BTk[3] * K[3]) % BP */
-	offset += ((btkhi & 0xffff) * k) % bp;
-
-	offset = offset % bp;
-
-	/* convert offset from kus to us by shifting up 10 bits and
-	 * add in the low 10 bits of tsf that we ignored
-	 */
-	offset = (offset << 10) + (tsf_l & 0x3FF);
-
-	return offset;
-}
-
 /* Update beacon listen interval in shared memory */
 void wlc_bcn_li_upd(struct wlc_info *wlc)
 {
@@ -6646,23 +6330,6 @@ wlc_recvctl(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p)
 	return;
 }
 
-void wlc_bss_list_free(struct wlc_info *wlc, struct wlc_bss_list *bss_list)
-{
-	uint index;
-
-	if (!bss_list) {
-		wiphy_err(wlc->wiphy, "%s: Attempting to free NULL list\n",
-			  __func__);
-		return;
-	}
-	/* inspect all BSS descriptor */
-	for (index = 0; index < bss_list->count; index++) {
-		kfree(bss_list->ptrs[index]);
-		bss_list->ptrs[index] = NULL;
-	}
-	bss_list->count = 0;
-}
-
 /* Process received frames */
 /*
  * Return true if more frames need to be processed. false otherwise.
@@ -7243,41 +6910,6 @@ void wlc_mod_prb_rsp_rate_table(struct wlc_info *wlc, uint frame_len)
 	}
 }
 
-u16
-wlc_compute_bcntsfoff(struct wlc_info *wlc, ratespec_t rspec,
-		      bool short_preamble, bool phydelay)
-{
-	uint bcntsfoff = 0;
-
-	if (IS_MCS(rspec)) {
-		wiphy_err(wlc->wiphy, "wl%d: recd beacon with mcs rate; rspec "
-			  "0x%x\n", wlc->pub->unit, rspec);
-	} else if (IS_OFDM(rspec)) {
-		/* tx delay from MAC through phy to air (2.1 usec) +
-		 * phy header time (preamble + PLCP SIGNAL == 20 usec) +
-		 * PLCP SERVICE + MAC header time (SERVICE + FC + DUR + A1 + A2 + A3 + SEQ == 26
-		 * bytes at beacon rate)
-		 */
-		bcntsfoff += phydelay ? D11A_PHY_TX_DELAY : 0;
-		bcntsfoff += APHY_PREAMBLE_TIME + APHY_SIGNAL_TIME;
-		bcntsfoff +=
-		    wlc_compute_airtime(wlc, rspec,
-					APHY_SERVICE_NBITS / 8 +
-					DOT11_MAC_HDR_LEN);
-	} else {
-		/* tx delay from MAC through phy to air (3.4 usec) +
-		 * phy header time (long preamble + PLCP == 192 usec) +
-		 * MAC header time (FC + DUR + A1 + A2 + A3 + SEQ == 24 bytes at beacon rate)
-		 */
-		bcntsfoff += phydelay ? D11B_PHY_TX_DELAY : 0;
-		bcntsfoff +=
-		    short_preamble ? D11B_PHY_SPREHDR_TIME :
-		    D11B_PHY_LPREHDR_TIME;
-		bcntsfoff += wlc_compute_airtime(wlc, rspec, DOT11_MAC_HDR_LEN);
-	}
-	return (u16) (bcntsfoff);
-}
-
 /*	Max buffering needed for beacon template/prb resp template is 142 bytes.
  *
  *	PLCP header is 6 bytes.
@@ -7610,17 +7242,6 @@ static void wlc_bss_default_init(struct wlc_info *wlc)
 		bi->flags |= WLC_BSS_HT;
 }
 
-void
-wlc_uint64_sub(u32 *a_high, u32 *a_low, u32 b_high, u32 b_low)
-{
-	if (b_low > *a_low) {
-		/* low half needs a carry */
-		b_high += 1;
-	}
-	*a_low -= b_low;
-	*a_high -= b_high;
-}
-
 static ratespec_t
 mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 		       u32 int_val)
@@ -7780,19 +7401,6 @@ void wlc_write_shm(struct wlc_info *wlc, uint offset, u16 v)
 	wlc_bmac_write_shm(wlc->hw, offset, v);
 }
 
-/* Set a range of shared memory to a value.
- * SHM 'offset' needs to be an even address and
- * Range length 'len' must be an even number of bytes
- */
-void wlc_set_shm(struct wlc_info *wlc, uint offset, u16 v, int len)
-{
-	/* offset and len need to be even */
-	if (len <= 0 || (offset & 1) || (len & 1))
-		return;
-
-	wlc_bmac_set_shm(wlc->hw, offset, v, len);
-}
-
 /* Copy a buffer to shared memory.
  * SHM 'offset' needs to be an even address and
  * Buffer length 'len' must be an even number of bytes
@@ -7807,40 +7415,17 @@ void wlc_copyto_shm(struct wlc_info *wlc, uint offset, const void *buf, int len)
 
 }
 
-/* Copy from shared memory to a buffer.
- * SHM 'offset' needs to be an even address and
- * Buffer length 'len' must be an even number of bytes
- */
-void wlc_copyfrom_shm(struct wlc_info *wlc, uint offset, void *buf, int len)
-{
-	/* offset and len need to be even */
-	if (len <= 0 || (offset & 1) || (len & 1))
-		return;
-
-	wlc_bmac_copyfrom_objmem(wlc->hw, offset, buf, len, OBJADDR_SHM_SEL);
-}
-
 /* wrapper BMAC functions to for HIGH driver access */
 void wlc_mctrl(struct wlc_info *wlc, u32 mask, u32 val)
 {
 	wlc_bmac_mctrl(wlc->hw, mask, val);
 }
 
-void wlc_corereset(struct wlc_info *wlc, u32 flags)
-{
-	wlc_bmac_corereset(wlc->hw, flags);
-}
-
 void wlc_mhf(struct wlc_info *wlc, u8 idx, u16 mask, u16 val, int bands)
 {
 	wlc_bmac_mhf(wlc->hw, idx, mask, val, bands);
 }
 
-u16 wlc_mhf_get(struct wlc_info *wlc, u8 idx, int bands)
-{
-	return wlc_bmac_mhf_get(wlc->hw, idx, bands);
-}
-
 int wlc_xmtfifo_sz_get(struct wlc_info *wlc, uint fifo, uint *blocks)
 {
 	return wlc_bmac_xmtfifo_sz_get(wlc->hw, fifo, blocks);
@@ -7867,11 +7452,6 @@ wlc_set_addrmatch(struct wlc_info *wlc, int match_reg_offset,
 		memcpy(wlc->cfg->BSSID, addr, ETH_ALEN);
 }
 
-void wlc_set_rcmta(struct wlc_info *wlc, int idx, const u8 *addr)
-{
-	wlc_bmac_set_rcmta(wlc->hw, idx, addr);
-}
-
 void wlc_set_cwmin(struct wlc_info *wlc, u16 newmin)
 {
 	wlc->band->CWmin = newmin;
@@ -7884,12 +7464,6 @@ void wlc_set_cwmax(struct wlc_info *wlc, u16 newmax)
 	wlc_bmac_set_cwmax(wlc->hw, newmax);
 }
 
-void wlc_fifoerrors(struct wlc_info *wlc)
-{
-
-	wlc_bmac_fifoerrors(wlc->hw);
-}
-
 /* Search mem rw utilities */
 
 void wlc_pllreq(struct wlc_info *wlc, bool set, mbool req_bit)
@@ -7901,17 +7475,6 @@ void wlc_reset_bmac_done(struct wlc_info *wlc)
 {
 }
 
-void wlc_ht_mimops_cap_update(struct wlc_info *wlc, u8 mimops_mode)
-{
-	wlc->ht_cap.cap_info &= ~IEEE80211_HT_CAP_SM_PS;
-	wlc->ht_cap.cap_info |= (mimops_mode << IEEE80211_HT_CAP_SM_PS_SHIFT);
-
-	if (AP_ENAB(wlc->pub) && wlc->clk) {
-		wlc_update_beacon(wlc);
-		wlc_update_probe_resp(wlc, true);
-	}
-}
-
 /* check for the particular priority flow control bit being set */
 bool
 wlc_txflowcontrol_prio_isset(struct wlc_info *wlc, struct wlc_txq_info *q,
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index 56c0ae0..fb48dfc 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -98,7 +98,6 @@ struct wlc_bss_list {
 	(cfg)->wsec_portopen : true)
 
 #define PS_ALLOWED(wlc)	wlc_ps_allowed(wlc)
-#define STAY_AWAKE(wlc) wlc_stay_awake(wlc)
 
 #define DATA_BLOCK_TX_SUPR	(1 << 4)
 
@@ -790,7 +789,6 @@ struct antsel_info {
 #define WLC_IS_MATCH_SSID(wlc, ssid1, ssid2, len1, len2) \
 	((len1 == len2) && !memcmp(ssid1, ssid2, len1))
 
-extern void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus);
 extern void wlc_fatal_error(struct wlc_info *wlc);
 extern void wlc_bmac_rpc_watchdog(struct wlc_info *wlc);
 extern void wlc_recv(struct wlc_info *wlc, struct sk_buff *p);
@@ -807,19 +805,10 @@ extern void wlc_write_template_ram(struct wlc_info *wlc, int offset, int len,
 				   void *buf);
 extern void wlc_write_hw_bcntemplates(struct wlc_info *wlc, void *bcn, int len,
 				      bool both);
-#if defined(BCMDBG)
-extern void wlc_get_rcmta(struct wlc_info *wlc, int idx,
-			  u8 *addr);
-#endif
-extern void wlc_set_rcmta(struct wlc_info *wlc, int idx,
-			  const u8 *addr);
 extern void wlc_set_cwmin(struct wlc_info *wlc, u16 newmin);
 extern void wlc_set_cwmax(struct wlc_info *wlc, u16 newmax);
-extern void wlc_fifoerrors(struct wlc_info *wlc);
 extern void wlc_pllreq(struct wlc_info *wlc, bool set, mbool req_bit);
 extern void wlc_reset_bmac_done(struct wlc_info *wlc);
-extern void wlc_hwtimer_gptimer_set(struct wlc_info *wlc, uint us);
-extern void wlc_hwtimer_gptimer_abort(struct wlc_info *wlc);
 
 #if defined(BCMDBG)
 extern void wlc_print_rxh(d11rxhdr_t *rxh);
@@ -879,18 +868,12 @@ extern void wlc_dump_ie(struct wlc_info *wlc, bcm_tlv_t *ie,
 
 extern void wlc_reprate_init(struct wlc_info *wlc);
 extern void wlc_bsscfg_reprate_init(struct wlc_bsscfg *bsscfg);
-extern void wlc_uint64_sub(u32 *a_high, u32 *a_low, u32 b_high,
-			   u32 b_low);
-extern u32 wlc_calc_tbtt_offset(u32 bi, u32 tsf_h, u32 tsf_l);
 
 /* Shared memory access */
 extern void wlc_write_shm(struct wlc_info *wlc, uint offset, u16 v);
 extern u16 wlc_read_shm(struct wlc_info *wlc, uint offset);
-extern void wlc_set_shm(struct wlc_info *wlc, uint offset, u16 v, int len);
 extern void wlc_copyto_shm(struct wlc_info *wlc, uint offset, const void *buf,
 			   int len);
-extern void wlc_copyfrom_shm(struct wlc_info *wlc, uint offset, void *buf,
-			     int len);
 
 extern void wlc_update_beacon(struct wlc_info *wlc);
 extern void wlc_bss_update_beacon(struct wlc_info *wlc,
@@ -928,7 +911,6 @@ extern void wlc_print_ies(struct wlc_info *wlc, u8 *ies, uint ies_len);
 #endif
 
 extern int wlc_set_nmode(struct wlc_info *wlc, s32 nmode);
-extern void wlc_ht_mimops_cap_update(struct wlc_info *wlc, u8 mimops_mode);
 extern void wlc_mimops_action_ht_send(struct wlc_info *wlc,
 				      struct wlc_bsscfg *bsscfg,
 				      u8 mimops_mode);
@@ -944,20 +926,14 @@ extern void wlc_beacon_phytxctl_txant_upd(struct wlc_info *wlc,
 extern void wlc_mod_prb_rsp_rate_table(struct wlc_info *wlc, uint frame_len);
 extern ratespec_t wlc_lowest_basic_rspec(struct wlc_info *wlc,
 					 wlc_rateset_t *rs);
-extern u16 wlc_compute_bcntsfoff(struct wlc_info *wlc, ratespec_t rspec,
-				    bool short_preamble, bool phydelay);
 extern void wlc_radio_disable(struct wlc_info *wlc);
 extern void wlc_bcn_li_upd(struct wlc_info *wlc);
 
 extern int wlc_get_revision_info(struct wlc_info *wlc, void *buf, uint len);
-extern void wlc_out(struct wlc_info *wlc);
 extern void wlc_set_home_chanspec(struct wlc_info *wlc, chanspec_t chanspec);
 extern void wlc_watchdog_upd(struct wlc_info *wlc, bool tbtt);
 extern bool wlc_ps_allowed(struct wlc_info *wlc);
 extern bool wlc_stay_awake(struct wlc_info *wlc);
 extern void wlc_wme_initparams_sta(struct wlc_info *wlc, wme_param_ie_t *pe);
 
-extern void wlc_bss_list_free(struct wlc_info *wlc,
-			      struct wlc_bss_list *bss_list);
-extern void wlc_ht_mimops_cap_update(struct wlc_info *wlc, u8 mimops_mode);
 #endif				/* _wlc_h_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index 44f6153..90d471d 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -536,10 +536,8 @@ extern int wlc_bmac_down_finish(struct wlc_hw_info *wlc_hw);
 
 extern u32 wlc_reg_read(struct wlc_info *wlc, void *r, uint size);
 extern void wlc_reg_write(struct wlc_info *wlc, void *r, u32 v, uint size);
-extern void wlc_corereset(struct wlc_info *wlc, u32 flags);
 extern void wlc_mhf(struct wlc_info *wlc, u8 idx, u16 mask, u16 val,
 		    int bands);
-extern u16 wlc_mhf_get(struct wlc_info *wlc, u8 idx, int bands);
 extern u32 wlc_delta_txfunfl(struct wlc_info *wlc, int fifo);
 extern void wlc_rate_lookup_init(struct wlc_info *wlc, wlc_rateset_t *rateset);
 extern void wlc_default_rateset(struct wlc_info *wlc, wlc_rateset_t *rs);
@@ -579,12 +577,6 @@ static inline int wlc_iovar_getuint(struct wlc_info *wlc, const char *name,
 	return wlc_iovar_getint(wlc, name, (int *)arg);
 }
 
-static inline int wlc_iovar_getu8(struct wlc_info *wlc, const char *name,
-				     u8 *arg)
-{
-	return wlc_iovar_gets8(wlc, name, (s8 *) arg);
-}
-
 static inline int wlc_iovar_setuint(struct wlc_info *wlc, const char *name,
 				    uint arg)
 {
@@ -594,9 +586,6 @@ static inline int wlc_iovar_setuint(struct wlc_info *wlc, const char *name,
 #if defined(BCMDBG)
 extern int wlc_iocregchk(struct wlc_info *wlc, uint band);
 #endif
-#if defined(BCMDBG)
-extern int wlc_iocpichk(struct wlc_info *wlc, uint phytype);
-#endif
 
 /* helper functions */
 extern bool wlc_check_radio_disabled(struct wlc_info *wlc);
-- 
1.7.4.1


