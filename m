Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4828 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758885Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 06/83] staging: brcm80211: cleanup struct wlc_info
 definition
Date: Wed, 1 Jun 2011 13:44:51 +0200
Message-ID: <1306928768-7501-6-git-send-email-rvossen@broadcom.com> (sfid-20110601_134825_062537_9468C454)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The structure definition for wlc_info contained a lot of fields that
are only initialized or not used at all. These have been removed to
cleanup the driver code.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.c |   11 --
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |    4 -
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c  |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c  |  121 ++----------------------
 drivers/staging/brcm80211/brcmsmac/wlc_main.h  |   86 -----------------
 5 files changed, 11 insertions(+), 213 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
index 82c64cd..3c4b2c0 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
@@ -152,8 +152,6 @@ struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 		goto fail;
 	}
 
-	wlc->hwrxoff = WL_HWRXOFF;
-
 	/* allocate struct wlc_pub state structure */
 	wlc->pub = wlc_pub_malloc(unit, err, devid);
 	if (wlc->pub == NULL) {
@@ -206,14 +204,6 @@ struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 	}
 	wlc_bsscfg_ID_assign(wlc, wlc->cfg);
 
-	wlc->pkt_callback = kzalloc(sizeof(struct pkt_cb) *
-				    (wlc->pub->tunables->maxpktcb + 1),
-				    GFP_ATOMIC);
-	if (wlc->pkt_callback == NULL) {
-		*err = 1013;
-		goto fail;
-	}
-
 	wlc->wsec_def_keys[0] =
 		kzalloc(sizeof(wsec_key_t) * WLC_DEFAULT_KEYS, GFP_ATOMIC);
 	if (wlc->wsec_def_keys[0] == NULL) {
@@ -284,7 +274,6 @@ void wlc_detach_mfree(struct wlc_info *wlc)
 	wlc_pub_mfree(wlc->pub);
 	kfree(wlc->modulecb);
 	kfree(wlc->default_bss);
-	kfree(wlc->pkt_callback);
 	kfree(wlc->wsec_def_keys[0]);
 	kfree(wlc->protection);
 	kfree(wlc->stf);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 85ad700..75343ab 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -499,10 +499,6 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 
 	wlc_ampdu_agg(ampdu, scb, p, tid);
 
-	if (wlc->block_datafifo) {
-		wiphy_err(wiphy, "%s: Fifo blocked\n", __func__);
-		return -EBUSY;
-	}
 	rr_retry_limit = ampdu->rr_retry_limit_tid[tid];
 	ampdu_len = 0;
 	dma_len = 0;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 4534926..9ef7707 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -333,7 +333,7 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 
 	/* BCN template is available */
 	/* ZZZ: Use AP_ACTIVE ? */
-	if (AP_ENAB(wlc->pub) && (!APSTA_ENAB(wlc->pub) || wlc->aps_associated)
+	if (AP_ENAB(wlc->pub) && (!APSTA_ENAB(wlc->pub))
 	    && (macintstatus & MI_BCNTPL)) {
 		wlc_update_beacon(wlc);
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 56ea77f..33045d5 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -294,14 +294,12 @@ bool wlc_ps_allowed(struct wlc_info *wlc)
 	struct wlc_bsscfg *cfg;
 
 	/* disallow PS when one of the following global conditions meets */
-	if (!wlc->pub->associated || !wlc->PMenabled || wlc->PM_override)
+	if (!wlc->pub->associated)
 		return false;
 
 	/* disallow PS when one of these meets when not scanning */
-	if (!wlc->PMblocked) {
-		if (AP_ACTIVE(wlc) || wlc->monitor)
-			return false;
-	}
+	if (AP_ACTIVE(wlc) || wlc->monitor)
+		return false;
 
 	FOREACH_AS_STA(wlc, idx, cfg) {
 		/* disallow PS when one of the following bsscfg specific conditions meets */
@@ -319,8 +317,6 @@ void wlc_reset(struct wlc_info *wlc)
 {
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
-	wlc->check_for_unaligned_tbtt = false;
-
 	/* slurp up hw mac counters before core reset */
 	wlc_statsupd(wlc);
 
@@ -329,8 +325,6 @@ void wlc_reset(struct wlc_info *wlc)
 		sizeof(macstat_t));
 
 	wlc_bmac_reset(wlc->hw);
-	wlc->txretried = 0;
-
 }
 
 void wlc_fatal_error(struct wlc_info *wlc)
@@ -386,15 +380,8 @@ void wlc_init(struct wlc_info *wlc)
 
 	wlc_bmac_init(wlc->hw, chanspec, mute);
 
-	wlc->seckeys = wlc_bmac_read_shm(wlc->hw, M_SECRXKEYS_PTR) * 2;
-	if (wlc->machwcap & MCAP_TKIPMIC)
-		wlc->tkmickeys =
-		    wlc_bmac_read_shm(wlc->hw, M_TKMICKEYS_PTR) * 2;
-
 	/* update beacon listen interval */
 	wlc_bcn_li_upd(wlc);
-	wlc->bcn_wait_prd =
-	    (u8) (wlc_bmac_read_shm(wlc->hw, M_NOSLPZNATDTIM) >> 10);
 
 	/* the world is new again, so is our reported rate */
 	wlc_reprate_init(wlc);
@@ -521,7 +508,7 @@ void wlc_mac_promisc(struct wlc_info *wlc)
 	 * Note: APs get all BSS traffic without the need to set the MCTL_PROMISC bit
 	 * since all BSS data traffic is directed at the AP
 	 */
-	if (PROMISC_ENAB(wlc->pub) && !AP_ENAB(wlc->pub) && !wlc->wet)
+	if (PROMISC_ENAB(wlc->pub) && !AP_ENAB(wlc->pub))
 		promisc_bits |= MCTL_PROMISC;
 
 	/* monitor mode needs both MCTL_PROMISC and MCTL_KEEPCONTROL
@@ -987,7 +974,6 @@ static void WLBANDINITFN(wlc_setband) (struct wlc_info *wlc, uint bandunit)
 		return;
 
 	/* wait for at least one beacon before entering sleeping state */
-	wlc->PMawakebcn = true;
 	FOREACH_AS_STA(wlc, idx, cfg)
 	    cfg->PMawakebcn = true;
 	wlc_set_ps_ctrl(wlc);
@@ -1035,8 +1021,6 @@ void wlc_wme_setparams(struct wlc_info *wlc, u16 aci,
 		return;
 	}
 
-	wlc->wme_admctl = 0;
-
 	do {
 		memset((char *)&acp_shm, 0, sizeof(shm_acparams_t));
 		/* fill in shm ac params struct */
@@ -1108,10 +1092,6 @@ void wlc_edcf_setparams(struct wlc_info *wlc, bool suspend)
 	for (i_ac = 0; i_ac < AC_COUNT; i_ac++, edcf_acp++) {
 		/* find out which ac this set of params applies to */
 		aci = (edcf_acp->ACI & EDCF_ACI_MASK) >> EDCF_ACI_SHIFT;
-		/* set the admission control policy for this AC */
-		if (edcf_acp->ACI & EDCF_ACM_MASK) {
-			wlc->wme_admctl |= 1 << aci;
-		}
 
 		/* fill in shm ac params struct */
 		params->txop = edcf_acp->TXOP;
@@ -1172,25 +1152,13 @@ void wlc_info_init(struct wlc_info *wlc, int unit)
 	/* Assume the device is there until proven otherwise */
 	wlc->device_present = true;
 
-	/* set default power output percentage to 100 percent */
-	wlc->txpwr_percent = 100;
-
 	/* Save our copy of the chanspec */
 	wlc->chanspec = CH20MHZ_CHSPEC(1);
 
-	/* initialize CCK preamble mode to unassociated state */
-	wlc->shortpreamble = false;
-
-	wlc->legacy_probe = true;
-
 	/* various 802.11g modes */
 	wlc->shortslot = false;
 	wlc->shortslot_override = WLC_SHORTSLOT_AUTO;
 
-	wlc->barker_overlap_control = true;
-	wlc->barker_preamble = WLC_BARKER_SHORT_ALLOWED;
-	wlc->txburst_limit_override = AUTO;
-
 	wlc_protection_upd(wlc, WLC_PROT_G_OVR, WLC_PROTECTION_AUTO);
 	wlc_protection_upd(wlc, WLC_PROT_G_SPEC, false);
 
@@ -1223,30 +1191,6 @@ void wlc_info_init(struct wlc_info *wlc, int unit)
 	wlc->SRL = RETRY_SHORT_DEF;
 	wlc->LRL = RETRY_LONG_DEF;
 
-	/* init PM state */
-	wlc->PM = PM_OFF;	/* User's setting of PM mode through IOCTL */
-	wlc->PM_override = false;	/* Prevents from going to PM if our AP is 'ill' */
-	wlc->PMenabled = false;	/* Current PM state */
-	wlc->PMpending = false;	/* Tracks whether STA indicated PM in the last attempt */
-	wlc->PMblocked = false;	/* To allow blocking going into PM during RM and scans */
-
-	/* In WMM Auto mode, PM is allowed if association is a UAPSD association */
-	wlc->WME_PM_blocked = false;
-
-	/* Init wme queuing method */
-	wlc->wme_prec_queuing = false;
-
-	/* Overrides for the core to stay awake under zillion conditions Look for STAY_AWAKE */
-	wlc->wake = false;
-	/* Are we waiting for a response to PS-Poll that we sent */
-	wlc->PSpoll = false;
-
-	/* APSD defaults */
-	wlc->wme_apsd = true;
-	wlc->apsd_sta_usp = false;
-	wlc->apsd_trigger_timeout = 0;	/* disable the trigger timer */
-	wlc->apsd_trigger_ac = AC_BITMAP_ALL;
-
 	/* Set flag to indicate that hw keys should be used when available. */
 	wlc->wsec_swkeys = false;
 
@@ -1256,8 +1200,6 @@ void wlc_info_init(struct wlc_info *wlc, int unit)
 		wlc->wsec_keys[i]->idx = (u8) i;
 	}
 
-	wlc->_regulatory_domain = false;	/* 802.11d */
-
 	/* WME QoS mode is Auto by default */
 	wlc->pub->_wme = AUTO;
 
@@ -1267,14 +1209,10 @@ void wlc_info_init(struct wlc_info *wlc, int unit)
 
 	wlc->pub->_ampdu = AMPDU_AGG_HOST;
 	wlc->pub->bcmerror = 0;
-	wlc->ibss_allowed = true;
-	wlc->ibss_coalesce_allowed = true;
 	wlc->pub->_coex = ON;
 
 	/* initialize mpc delay */
 	wlc->mpc_delay_off = wlc->mpc_dlycnt = WLC_MPC_MIN_DELAYCNT;
-
-	wlc->pr80838_war = true;
 }
 
 static bool wlc_state_bmac_sync(struct wlc_info *wlc)
@@ -1358,11 +1296,8 @@ void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
 	wlc->core = wlc->corestate;
 	wlc->wl = wl;
 	pub->unit = unit;
-	wlc->btparam = btparam;
 	pub->_piomode = piomode;
 	wlc->bandinit_pending = false;
-	/* By default restrict TKIP associations from 11n STA's */
-	wlc->ht_wsec_restriction = WLC_HT_TKIP_RESTRICT;
 
 	/* populate struct wlc_info with default values  */
 	wlc_info_init(wlc, unit);
@@ -1527,9 +1462,6 @@ void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
 	wlc->cck_40txbw = AUTO;
 	wlc_update_mimo_band_bwcap(wlc, WLC_N_BW_20IN2G_40IN5G);
 
-	/* Enable setting the RIFS Mode bit by default in HT Info IE */
-	wlc->rifs_advert = AUTO;
-
 	/* Set default values of SGI */
 	if (WLC_SGI_CAP_PHY(wlc)) {
 		wlc_ht_update_sgi_rx(wlc, (WLC_N_SGI_20 | WLC_N_SGI_40));
@@ -1722,25 +1654,6 @@ uint wlc_detach(struct wlc_info *wlc)
 
 	wlc_detach_module(wlc);
 
-	/* free other state */
-
-
-#ifdef BCMDBG
-	kfree(wlc->country_ie_override);
-	wlc->country_ie_override = NULL;
-#endif				/* BCMDBG */
-
-	{
-		/* free dumpcb list */
-		struct dumpcb_s *prev, *ptr;
-		prev = ptr = wlc->dumpcb_head;
-		while (ptr) {
-			ptr = prev->next;
-			kfree(prev);
-			prev = ptr;
-		}
-		wlc->dumpcb_head = NULL;
-	}
 
 	while (wlc->tx_queues != NULL)
 		wlc_txq_free(wlc, wlc->tx_queues);
@@ -1757,9 +1670,6 @@ void wlc_ap_upd(struct wlc_info *wlc)
 	else
 		wlc->PLCPHdr_override = WLC_PLCP_SHORT;	/* STA-BSS; short capable */
 
-	/* disable vlan_mode on AP since some legacy STAs cannot rx tagged pkts */
-	wlc->vlan_mode = AP_ENAB(wlc->pub) ? OFF : AUTO;
-
 	/* fixup mpc */
 	wlc->mpc = true;
 }
@@ -1892,9 +1802,7 @@ static void wlc_radio_enable(struct wlc_info *wlc)
 	if (DEVICEREMOVED(wlc))
 		return;
 
-	if (!wlc->down_override) {	/* imposed by wl down/out ioctl */
-		wl_up(wlc->wl);
-	}
+	wl_up(wlc->wl);
 }
 
 /* periodical query hw radio button while driver is "down" */
@@ -2230,7 +2138,6 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 	s8 shortslot = WLC_SHORTSLOT_AUTO;	/* Advertise and use shortslot (-1/0/1 Auto/Off/On) */
 	bool shortslot_restrict = false;	/* Restrict association to stations that support shortslot
 						 */
-	bool ignore_bcns = true;	/* Ignore legacy beacons on the same channel */
 	bool ofdm_basic = false;	/* Make 6, 12, and 24 basic rates */
 	int preamble = WLC_PLCP_LONG;	/* Advertise and use short preambles (-1/0/1 Auto/Off/On) */
 	bool preamble_restrict = false;	/* Restrict association to stations that support short
@@ -2326,8 +2233,6 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 
 	band->gmode = gmode;
 
-	wlc->ignore_bcns = ignore_bcns;
-
 	wlc->shortslot_override = shortslot;
 
 	if (AP_ENAB(wlc->pub)) {
@@ -4418,7 +4323,6 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 	if (lastframe) {
 		p->next = NULL;
 		p->prev = NULL;
-		wlc->txretried = 0;
 		/* remove PLCP & Broadcom tx descriptor header */
 		skb_pull(p, D11_PHY_HDR_LEN);
 		skb_pull(p, D11_TXH_LEN);
@@ -4448,15 +4352,9 @@ wlc_txfifo_complete(struct wlc_info *wlc, uint fifo, s8 txpktpend)
 	/* There is more room; mark precedences related to this FIFO sendable */
 	WLC_TX_FIFO_ENAB(wlc, fifo);
 
-	if (!TXPKTPENDTOT(wlc)) {
-		if (wlc->block_datafifo & DATA_BLOCK_TX_SUPR)
-			wlc_bsscfg_tx_check(wlc);
-	}
-
 	/* Clear MHF2_TXBCMC_NOW flag if BCMC fifo has drained */
 	if (AP_ENAB(wlc->pub) &&
-	    wlc->bcmcfifo_drain && !TXPKTPENDGET(wlc, TX_BCMC_FIFO)) {
-		wlc->bcmcfifo_drain = false;
+	    !TXPKTPENDGET(wlc, TX_BCMC_FIFO)) {
 		wlc_mhf(wlc, MHF2, MHF2_TXBCMC_NOW, 0, WLC_BAND_AUTO);
 	}
 
@@ -4662,7 +4560,7 @@ void wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	rxh = (d11rxhdr_t *) (p->data);
 
 	/* strip off rxhdr */
-	skb_pull(p, wlc->hwrxoff);
+	skb_pull(p, WL_HWRXOFF);
 
 	/* fixup rx header endianness */
 	rxh->RxFrameSize = le16_to_cpu(rxh->RxFrameSize);
@@ -5174,8 +5072,6 @@ static void wlc_update_mimo_band_bwcap(struct wlc_info *wlc, u8 bwcap)
 				band->mimo_cap_40 = false;
 		}
 	}
-
-	wlc->mimo_band_bwcap = bwcap;
 }
 
 void wlc_mod_prb_rsp_rate_table(struct wlc_info *wlc, uint frame_len)
@@ -5848,12 +5744,15 @@ static void
 wlc_txflowcontrol_signal(struct wlc_info *wlc, struct wlc_txq_info *qi, bool on,
 			 int prio)
 {
+#ifdef NON_FUNCTIONAL
+	/* wlcif_list is never filled so this function is not functional */
 	struct wlc_if *wlcif;
 
 	for (wlcif = wlc->wlcif_list; wlcif != NULL; wlcif = wlcif->next) {
 		if (wlcif->qi == qi && wlcif->flags & WLC_IF_LINKED)
 			wl_txflowcontrol(wlc->wl, wlcif->wlif, on, prio);
 	}
+#endif
 }
 
 static struct wlc_txq_info *wlc_txq_alloc(struct wlc_info *wlc)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index 4d45972..edbf3d2 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -515,8 +515,6 @@ struct wlc_info {
 	struct antsel_info *asi;	/* antsel module handler */
 	wlc_cm_info_t *cmi;	/* channel manager module handler */
 
-	void *btparam;		/* bus type specific cookie */
-
 	uint vars_size;		/* size of vars, free vars on detach */
 
 	u16 vendorid;	/* PCI vendor id */
@@ -531,7 +529,6 @@ struct wlc_info {
 	bool bandinit_pending;	/* track band init in auto band */
 
 	bool radio_monitor;	/* radio timer is running */
-	bool down_override;	/* true=down */
 	bool going_down;	/* down path intermediate variable */
 
 	bool mpc;		/* enable minimum power consumption */
@@ -542,14 +539,7 @@ struct wlc_info {
 
 	/* timer */
 	struct wl_timer *wdtimer;	/* timer for watchdog routine */
-	uint fast_timer;	/* Periodic timeout for 'fast' timer */
-	uint slow_timer;	/* Periodic timeout for 'slow' timer */
-	uint glacial_timer;	/* Periodic timeout for 'glacial' timer */
-	uint phycal_mlo;	/* last time measurelow calibration was done */
-	uint phycal_txpower;	/* last time txpower calibration was done */
-
 	struct wl_timer *radio_timer;	/* timer for hw radio button monitor routine */
-	struct wl_timer *pspoll_timer;	/* periodic pspoll timer */
 
 	/* promiscuous */
 	bool monitor;		/* monitor (MPDU sniffing) mode */
@@ -557,30 +547,11 @@ struct wlc_info {
 	bool bcnmisc_scan;	/* bcns promisc mode override for scan */
 	bool bcnmisc_monitor;	/* bcns promisc mode override for monitor */
 
-	u8 bcn_wait_prd;	/* max waiting period (for beacon) in 1024TU */
-
 	/* driver feature */
 	bool _rifs;		/* enable per-packet rifs */
-	s32 rifs_advert;	/* RIFS mode advertisement */
 	s8 sgi_tx;		/* sgi tx */
-	bool wet;		/* true if wireless ethernet bridging mode */
 
 	/* AP-STA synchronization, power save */
-	bool check_for_unaligned_tbtt;	/* check unaligned tbtt flag */
-	bool PM_override;	/* no power-save flag, override PM(user input) */
-	bool PMenabled;		/* current power-management state (CAM or PS) */
-	bool PMpending;		/* waiting for tx status with PM indicated set */
-	bool PMblocked;		/* block any PSPolling in PS mode, used to buffer
-				 * AP traffic, also used to indicate in progress
-				 * of scan, rm, etc. off home channel activity.
-				 */
-	bool PSpoll;		/* whether there is an outstanding PS-Poll frame */
-	u8 PM;		/* power-management mode (CAM, PS or FASTPS) */
-	bool PMawakebcn;	/* bcn recvd during current waking state */
-
-	bool WME_PM_blocked;	/* Can STA go to PM when in WME Auto mode */
-	bool wake;		/* host-specified PS-mode sleep state */
-	u8 pspoll_prd;	/* pspoll interval in milliseconds */
 	u8 bcn_li_bcn;	/* beacon listen interval in # beacons */
 	u8 bcn_li_dtim;	/* beacon listen interval in # dtims */
 
@@ -589,18 +560,14 @@ struct wlc_info {
 
 	/* WME */
 	ac_bitmap_t wme_dp;	/* Discard (oldest first) policy per AC */
-	bool wme_apsd;		/* enable Advanced Power Save Delivery */
-	ac_bitmap_t wme_admctl;	/* bit i set if AC i under admission control */
 	u16 edcf_txop[AC_COUNT];	/* current txop for each ac */
 	wme_param_ie_t wme_param_ie;	/* WME parameter info element, which on STA
 					 * contains parameters in use locally, and on
 					 * AP contains parameters advertised to STA
 					 * in beacons and assoc responses.
 					 */
-	bool wme_prec_queuing;	/* enable/disable non-wme STA prec queuing */
 	u16 wme_retries[AC_COUNT];	/* per-AC retry limits */
 
-	int vlan_mode;		/* OK to use 802.1Q Tags (ON, OFF, AUTO) */
 	u16 tx_prec_map;	/* Precedence map based on HW FIFO space */
 	u16 fifo2prec_map[NFIFO];	/* pointer to fifo2_prec map based on WME */
 
@@ -610,10 +577,6 @@ struct wlc_info {
 	 */
 	struct wlc_bsscfg *bsscfg[WLC_MAXBSSCFG];
 	struct wlc_bsscfg *cfg;	/* the primary bsscfg (can be AP or STA) */
-	u8 stas_associated;	/* count of ASSOCIATED STA bsscfgs */
-	u8 aps_associated;	/* count of UP AP bsscfgs */
-	u8 block_datafifo;	/* prohibit posting frames to data fifos */
-	bool bcmcfifo_drain;	/* TX_BCMC_FIFO is set to drain */
 
 	/* tx queue */
 	struct wlc_txq_info *tx_queues;	/* common TX Queue list */
@@ -625,43 +588,24 @@ struct wlc_info {
 				 * treated as sw keys (used for debugging)
 				 */
 	struct modulecb *modulecb;
-	struct dumpcb_s *dumpcb_head;
 
 	u8 mimoft;		/* SIGN or 11N */
-	u8 mimo_band_bwcap;	/* bw cap per band type */
-	s8 txburst_limit_override;	/* tx burst limit override */
-	u16 txburst_limit;	/* tx burst limit value */
 	s8 cck_40txbw;	/* 11N, cck tx b/w override when in 40MHZ mode */
 	s8 ofdm_40txbw;	/* 11N, ofdm tx b/w override when in 40MHZ mode */
 	s8 mimo_40txbw;	/* 11N, mimo tx b/w override when in 40MHZ mode */
 	/* HT CAP IE being advertised by this node: */
 	struct ieee80211_ht_cap ht_cap;
 
-	uint seckeys;		/* 54 key table shm address */
-	uint tkmickeys;		/* 12 TKIP MIC key table shm address */
-
 	wlc_bss_info_t *default_bss;	/* configured BSS parameters */
 
-	u16 AID;		/* association ID */
-	u16 counter;		/* per-sdu monotonically increasing counter */
 	u16 mc_fid_counter;	/* BC/MC FIFO frame ID counter */
 
-	bool ibss_allowed;	/* false, all IBSS will be ignored during a scan
-				 * and the driver will not allow the creation of
-				 * an IBSS network
-				 */
-	bool ibss_coalesce_allowed;
-
 	char country_default[WLC_CNTRY_BUF_SZ];	/* saved country for leaving 802.11d
 						 * auto-country mode
 						 */
 	char autocountry_default[WLC_CNTRY_BUF_SZ];	/* initial country for 802.11d
 							 * auto-country mode
 							 */
-#ifdef BCMDBG
-	bcm_tlv_t *country_ie_override;	/* debug override of announced Country IE */
-#endif
-
 	u16 prb_resp_timeout;	/* do not send prb resp if request older than this,
 					 * 0 = disable
 					 */
@@ -683,44 +627,17 @@ struct wlc_info {
 	u16 LFBL;		/* Long Frame Rate Fallback Limit */
 
 	/* network config */
-	bool shortpreamble;	/* currently operating with CCK ShortPreambles */
 	bool shortslot;		/* currently using 11g ShortSlot timing */
-	s8 barker_preamble;	/* current Barker Preamble Mode */
 	s8 shortslot_override;	/* 11g ShortSlot override */
 	bool include_legacy_erp;	/* include Legacy ERP info elt ID 47 as well as g ID 42 */
-	bool barker_overlap_control;	/* true: be aware of overlapping BSSs for barker */
-	bool ignore_bcns;	/* override: ignore non shortslot bcns in a 11g network */
-	bool legacy_probe;	/* restricts probe requests to CCK rates */
 
 	struct wlc_protection *protection;
 	s8 PLCPHdr_override;	/* 802.11b Preamble Type override */
 
 	struct wlc_stf *stf;
 
-	struct pkt_cb *pkt_callback;	/* tx completion callback handlers */
-
-	u32 txretried;	/* tx retried number in one msdu */
-
 	ratespec_t bcn_rspec;	/* save bcn ratespec purpose */
 
-	bool apsd_sta_usp;	/* Unscheduled Service Period in progress on STA */
-	struct wl_timer *apsd_trigger_timer;	/* timer for wme apsd trigger frames */
-	u32 apsd_trigger_timeout;	/* timeout value for apsd_trigger_timer (in ms)
-					 * 0 == disable
-					 */
-	ac_bitmap_t apsd_trigger_ac;	/* Permissible Access Category in which APSD Null
-					 * Trigger frames can be send
-					 */
-	u8 htphy_membership;	/* HT PHY membership */
-
-	bool _regulatory_domain;	/* 802.11d enabled? */
-
-	u8 mimops_PM;
-
-	u8 txpwr_percent;	/* power output percentage */
-
-	u8 ht_wsec_restriction;	/* the restriction of HT with TKIP or WEP */
-
 	uint tempsense_lasttime;
 
 	u16 tx_duty_cycle_ofdm;	/* maximum allowed duty cycle for OFDM */
@@ -728,7 +645,6 @@ struct wlc_info {
 
 	u16 next_bsscfg_ID;
 
-	struct wlc_if *wlcif_list;	/* linked list of wlc_if structs */
 	struct wlc_txq_info *pkt_queue; /* txq for transmit packets */
 	u32 mpc_dur;		/* total time (ms) in mpc mode except for the
 				 * portion since radio is turned off last time
@@ -736,8 +652,6 @@ struct wlc_info {
 	u32 mpc_laston_ts;	/* timestamp (ms) when radio is turned off last
 				 * time
 				 */
-	bool pr80838_war;
-	uint hwrxoff;
 	struct wiphy *wiphy;
 };
 
-- 
1.7.4.1


