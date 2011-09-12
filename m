Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3735 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753650Ab1ILKPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:23 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 12/20] staging: brcm80211: cleaned up unused softmac
 struct members
Date: Mon, 12 Sep 2011 12:14:56 +0200
Message-ID: <1315822504-24210-13-git-send-email-rvossen@broadcom.com> (sfid-20110912_121606_908255_1DC4EFEC)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Struct members were unused or only written but never read.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/alloc.c |   45 +-----------------
 drivers/staging/brcm80211/brcmsmac/main.c  |   68 +++-------------------------
 drivers/staging/brcm80211/brcmsmac/main.h  |   11 -----
 drivers/staging/brcm80211/brcmsmac/pub.h   |   62 -------------------------
 4 files changed, 9 insertions(+), 177 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
index 52189dc..b99087d 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -20,44 +20,11 @@
 #include "main.h"
 #include "alloc.h"
 
-static void brcms_c_pub_mfree(struct brcms_pub *pub)
-{
-	if (pub == NULL)
-		return;
-
-	kfree(pub->multicast);
-	kfree(pub);
-}
-
-static struct brcms_pub *brcms_c_pub_malloc(uint unit, uint *err, uint devid)
-{
-	struct brcms_pub *pub;
-
-	pub = kzalloc(sizeof(struct brcms_pub), GFP_ATOMIC);
-	if (pub == NULL) {
-		*err = 1001;
-		goto fail;
-	}
-
-	pub->multicast = kzalloc(ETH_ALEN * MAXMULTILIST, GFP_ATOMIC);
-	if (pub->multicast == NULL) {
-		*err = 1003;
-		goto fail;
-	}
-
-	return pub;
-
- fail:
-	brcms_c_pub_mfree(pub);
-	return NULL;
-}
-
 static void brcms_c_bsscfg_mfree(struct brcms_bss_cfg *cfg)
 {
 	if (cfg == NULL)
 		return;
 
-	kfree(cfg->maclist);
 	kfree(cfg->current_bss);
 	kfree(cfg);
 }
@@ -81,13 +48,6 @@ static struct brcms_bss_cfg *brcms_c_bsscfg_malloc(uint unit)
 	return NULL;
 }
 
-static void brcms_c_bsscfg_ID_assign(struct brcms_c_info *wlc,
-				 struct brcms_bss_cfg *bsscfg)
-{
-	bsscfg->ID = wlc->next_bsscfg_ID;
-	wlc->next_bsscfg_ID++;
-}
-
 /*
  * The common driver entry routine. Error codes should be unique
  */
@@ -102,7 +62,7 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 	}
 
 	/* allocate struct brcms_c_pub state structure */
-	wlc->pub = brcms_c_pub_malloc(unit, err, devid);
+	wlc->pub = kzalloc(sizeof(struct brcms_pub), GFP_ATOMIC);
 	if (wlc->pub == NULL) {
 		*err = 1003;
 		goto fail;
@@ -150,7 +110,6 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 		*err = 1011;
 		goto fail;
 	}
-	brcms_c_bsscfg_ID_assign(wlc, wlc->cfg);
 
 	wlc->protection = kzalloc(sizeof(struct brcms_protection),
 				  GFP_ATOMIC);
@@ -205,7 +164,7 @@ void brcms_c_detach_mfree(struct brcms_c_info *wlc)
 		return;
 
 	brcms_c_bsscfg_mfree(wlc->cfg);
-	brcms_c_pub_mfree(wlc->pub);
+	kfree(wlc->pub);
 	kfree(wlc->modulecb);
 	kfree(wlc->default_bss);
 	kfree(wlc->protection);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index c5cecb4..e330c02 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -70,11 +70,6 @@
 
 #define	TBTT_ALIGN_LEEWAY_US	100	/* min leeway before first TBTT in us */
 
-/* Software feature flag defines used by wlfeatureflag */
-#define WL_SWFL_NOHWRADIO	0x0004
-#define WL_SWFL_FLOWCONTROL     0x0008	/* Enable backpressure to OS stack */
-#define WL_SWFL_WLBSSSORT	0x0010	/* Per-port supports sorting of BSS */
-
 /* n-mode support capability */
 /* 2x2 includes both 1x1 & 2x2 devices
  * reserved #define 2 for future when we want to separate 1x1 & 2x2 and
@@ -2779,11 +2774,6 @@ void brcms_c_coredisable(struct brcms_hardware *wlc_hw)
 	/* turn off PHYPLL to save power */
 	brcms_b_core_phypll_ctl(wlc_hw, false);
 
-	/* No need to set wlc->pub->radio_active = OFF
-	 * because this function needs down capability and
-	 * radio_active is designed for BCMNODOWN.
-	 */
-
 	/* remove gpio controls */
 	if (wlc_hw->ucode_dbgsel)
 		ai_gpiocontrol(wlc_hw->sih, ~0, 0, GPIO_DRV_PRIORITY);
@@ -3744,9 +3734,6 @@ static void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw, bool shortslot)
  */
 void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
 {
-	int idx;
-	struct brcms_bss_cfg *cfg;
-
 	/* use the override if it is set */
 	if (wlc->shortslot_override != BRCMS_SHORTSLOT_AUTO)
 		shortslot = (wlc->shortslot_override == BRCMS_SHORTSLOT_ON);
@@ -3756,17 +3743,6 @@ void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
 
 	wlc->shortslot = shortslot;
 
-	/* update the capability based on current shortslot mode */
-	FOREACH_BSS(wlc, idx, cfg)
-		if (!cfg->associated)
-			continue;
-		cfg->current_bss->capability &=
-					~WLAN_CAPABILITY_SHORT_SLOT_TIME;
-		if (wlc->shortslot)
-			cfg->current_bss->capability |=
-					WLAN_CAPABILITY_SHORT_SLOT_TIME;
-	END_FOREACH_BSS()
-
 	brcms_b_set_shortslot(wlc->hw, shortslot);
 }
 
@@ -4193,7 +4169,7 @@ static void brcms_c_down_led_upd(struct brcms_c_info *wlc)
 static bool brcms_c_radio_monitor_start(struct brcms_c_info *wlc)
 {
 	/* Don't start the timer if HWRADIO feature is disabled */
-	if (wlc->radio_monitor || (wlc->pub->wlfeatureflag & WL_SWFL_NOHWRADIO))
+	if (wlc->radio_monitor)
 		return true;
 
 	wlc->radio_monitor = true;
@@ -4238,7 +4214,7 @@ bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc)
 /* read hwdisable state and propagate to wlc flag */
 static void brcms_c_radio_hwdisable_upd(struct brcms_c_info *wlc)
 {
-	if (wlc->pub->wlfeatureflag & WL_SWFL_NOHWRADIO || wlc->pub->hw_off)
+	if (wlc->pub->hw_off)
 		return;
 
 	if (brcms_b_radio_read_hwdisabled(wlc->hw))
@@ -4360,7 +4336,7 @@ static void brcms_c_watchdog(void *arg)
 	if ((wlc->pub->now % SW_TIMER_MAC_STAT_UPD) == 0)
 		brcms_c_statsupd(wlc);
 
-	if (BRCMS_ISNPHY(wlc->band) && !wlc->pub->tempsense_disable &&
+	if (BRCMS_ISNPHY(wlc->band) &&
 	    ((wlc->pub->now - wlc->tempsense_lasttime) >=
 	     BRCMS_TEMPSENSE_PERIOD)) {
 		wlc->tempsense_lasttime = wlc->pub->now;
@@ -4453,7 +4429,6 @@ void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 	wlc->pub->_wme = AUTO;
 	wlc->pub->_ampdu = AMPDU_AGG_HOST;
 	wlc->pub->bcmerror = 0;
-	wlc->pub->_coex = ON;
 
 	/* initialize mpc delay */
 	wlc->mpc_delay_off = wlc->mpc_dlycnt = BRCMS_MPC_MIN_DELAYCNT;
@@ -4940,7 +4915,6 @@ static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 	/* init default and target BSS with some sane initial values */
 	memset((char *)(bi), 0, sizeof(struct brcms_bss_info));
 	bi->beacon_period = BEACON_INTERVAL_DEFAULT;
-	bi->dtim_period = DTIM_INTERVAL_DEFAULT;
 
 	/* fill the default channel as the first valid channel
 	 * starting from the 2G channels
@@ -4977,8 +4951,7 @@ static struct brcms_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc)
 		 * will remain the same
 		 */
 		brcmu_pktq_init(&qi->q, BRCMS_PREC_COUNT,
-			  2 * BRCMS_DATAHIWAT + PKTQ_LEN_DEFAULT
-			  + wlc->pub->psq_pkts_total);
+			  2 * BRCMS_DATAHIWAT + PKTQ_LEN_DEFAULT);
 
 		/* add this queue to the the global list */
 		p = wlc->tx_queues;
@@ -5220,7 +5193,6 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	wlc->bsscfg[0] = wlc->cfg;
 	wlc->cfg->_idx = 0;
 	wlc->cfg->wlc = wlc;
-	pub->txmaxpkts = MAXTXPKTS;
 
 	brcms_c_wme_initparams_sta(wlc, &wlc->wme_param_ie);
 
@@ -5953,18 +5925,6 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 
 	wlc->shortslot_override = shortslot;
 
-	if (preamble == BRCMS_PLCP_SHORT)
-		wlc->default_bss->capability |= WLAN_CAPABILITY_SHORT_PREAMBLE;
-	else
-		wlc->default_bss->capability &= ~WLAN_CAPABILITY_SHORT_PREAMBLE;
-
-	/* Update shortslot capability bit for AP and IBSS */
-	if (shortslot == BRCMS_SHORTSLOT_ON)
-		wlc->default_bss->capability |= WLAN_CAPABILITY_SHORT_SLOT_TIME;
-	else
-		wlc->default_bss->capability &=
-					~WLAN_CAPABILITY_SHORT_SLOT_TIME;
-
 	/* Use the default 11g rateset */
 	if (!rs.count)
 		brcms_c_rateset_copy(&cck_ofdm_rates, &rs);
@@ -6792,8 +6752,7 @@ void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
 	prio = sdu->priority;
 
 	if (!brcms_c_prec_enq(wlc, q, sdu, prec)) {
-		if (!EDCF_ENAB(wlc->pub)
-		    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL))
+		if (!EDCF_ENAB(wlc->pub))
 			wiphy_err(wlc->wiphy, "wl%d: txq_enq: txq overflow"
 				  "\n", wlc->pub->unit);
 
@@ -6810,13 +6769,9 @@ void brcms_c_txq_enq(struct brcms_c_info *wlc, struct scb *scb,
 	 * would make the decision on what to drop instead of relying on
 	 * stack to make the right decision
 	 */
-	if (!EDCF_ENAB(wlc->pub)
-	    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL)) {
+	if (!EDCF_ENAB(wlc->pub)) {
 		if (pktq_len(q) >= BRCMS_DATAHIWAT)
 			brcms_c_txflowcontrol(wlc, qi, ON, ALLPRIO);
-	} else if (wlc->pub->_priofc) {
-		if (pktq_plen(q, wlc_prio2prec_map[prio]) >= BRCMS_DATAHIWAT)
-			brcms_c_txflowcontrol(wlc, qi, ON, prio);
 	}
 }
 
@@ -7816,19 +7771,10 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
 	 * Check if flow control needs to be turned off after
 	 * sending the packet
 	 */
-	if (!EDCF_ENAB(wlc->pub)
-	    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL)) {
+	if (!EDCF_ENAB(wlc->pub)) {
 		if (brcms_c_txflowcontrol_prio_isset(wlc, qi, ALLPRIO)
 		    && (pktq_len(q) < BRCMS_DATAHIWAT / 2))
 			brcms_c_txflowcontrol(wlc, qi, OFF, ALLPRIO);
-	} else if (wlc->pub->_priofc) {
-		int prio;
-		for (prio = MAXPRIO; prio >= 0; prio--) {
-			if (brcms_c_txflowcontrol_prio_isset(wlc, qi, prio) &&
-			    q->q[wlc_prio2prec_map[prio]].len <
-			    BRCMS_DATAHIWAT / 2)
-				brcms_c_txflowcontrol(wlc, qi, OFF, prio);
-		}
 	}
 	in_send_q = false;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 674750b..b31c20f 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -568,7 +568,6 @@ struct brcms_txq_info {
  * tempsense_lasttime;
  * tx_duty_cycle_ofdm: maximum allowed duty cycle for OFDM.
  * tx_duty_cycle_cck: maximum allowed duty cycle for CCK.
- * next_bsscfg_ID;
  * pkt_queue: txq for transmit packets.
  * mpc_dur: total time (ms) in mpc mode except for the portion since
  *	    radio is turned off last time.
@@ -722,8 +721,6 @@ struct brcms_c_info {
 	u16 tx_duty_cycle_ofdm;
 	u16 tx_duty_cycle_cck;
 
-	u16 next_bsscfg_ID;
-
 	struct brcms_txq_info *pkt_queue;
 	u32 mpc_dur;
 	u32 mpc_laston_ts;
@@ -757,11 +754,6 @@ struct antsel_info {
  * bcmc_scb: one bcmc_scb per band
  * _idx: the index of this bsscfg, assigned at wlc_bsscfg_alloc()
  *
- * MAC filter
- * ----------
- * nmac: # of entries on maclist array
- * macmode: allow/deny stations on maclist array
- * maclist: list of source MAC addrs to match
  *
  * BSSID: BSSID (associated)
  * cur_etheraddr: h/w address
@@ -797,9 +789,6 @@ struct brcms_bss_cfg {
 	u8 SSID[IEEE80211_MAX_SSID_LEN];
 	struct scb *bcmc_scb[MAXBANDS];
 	s8 _idx;
-	uint nmac;
-	int macmode;
-	struct ether_addr *maclist;
 	u8 BSSID[ETH_ALEN];
 	u8 cur_etheraddr[ETH_ALEN];
 	u16 bcmc_fid;
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index acad21b..da63364 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -22,7 +22,6 @@
 #include "defs.h"
 
 #define	BRCMS_NUMRATES	16	/* max # of rates in a rateset */
-#define	MAXMULTILIST	32	/* max # multicast addresses */
 #define	D11_PHY_HDR_LEN	6	/* Phy header length - 6 bytes */
 
 /* phy types */
@@ -124,19 +123,8 @@ struct brcms_bss_info {
 	s16 RSSI;		/* receive signal strength (in dBm) */
 	s16 SNR;		/* receive signal SNR in dB */
 	u16 beacon_period;	/* units are Kusec */
-	u16 atim_window;	/* units are Kusec */
 	u16 chanspec;	/* Channel num, bw, ctrl_sb and band */
-	s8 infra;		/* 0=IBSS, 1=infrastructure, 2=unknown */
 	struct brcms_c_rateset rateset;	/* supported rates */
-	u8 dtim_period;	/* DTIM period */
-	s8 phy_noise;		/* noise right after tx (in dBm) */
-	u16 capability;	/* Capability information */
-	u8 wme_qosinfo;	/* QoS Info from WME IE; valid if BSS_WME flag set */
-	u16 qbss_load_aac;	/* qbss load available admission capacity */
-	/* qbss_load_chan_free <- (0xff - chan utilization of qbss_load_ie_t) */
-	u8 qbss_load_chan_free;	/* indicates how free the channel is */
-	u8 mcipher;		/* multicast cipher */
-	u8 wpacfg;		/* wpa config index */
 };
 
 #define MAC80211_PROMISC_BCNS	(1 << 0)
@@ -165,78 +153,28 @@ struct brcms_pub {
 
 	bool promisc;		/* promiscuous destination address */
 	bool delayed_down;	/* down delayed */
-	bool _ap;		/* AP mode enabled */
-	bool _apsta;		/* simultaneous AP/STA mode enabled */
-	bool _assoc_recreate;	/* association recreation on up transitions */
 	int _wme;		/* WME QoS mode */
-	u8 _mbss;		/* MBSS mode on */
-	bool allmulti;		/* enable all multicasts */
 	bool associated;	/* true:part of [I]BSS, false: not */
 	/* (union of stas_associated, aps_associated) */
-	bool phytest_on;	/* whether a PHY test is running */
-	bool bf_preempt_4306;	/* True to enable 'darwin' mode */
 	bool _ampdu;		/* ampdu enabled or not */
-	bool _cac;		/* 802.11e CAC enabled */
 	u8 _n_enab;		/* bitmap of 11N + HT support */
-	bool _n_reqd;		/* N support required for clients */
-
-	s8 _coex;	/* 20/40 MHz BSS Management AUTO, ENAB, DISABLE */
-	bool _priofc;		/* Priority-based flowcontrol */
 
 	u8 cur_etheraddr[ETH_ALEN];	/* our local ethernet address */
 
-	u8 *multicast;	/* ptr to list of multicast addresses */
-	uint nmulticast;	/* # enabled multicast addresses */
-
-	u32 wlfeatureflag;	/* Flags to control sw features from registry */
-	int psq_pkts_total;	/* total num of ps pkts */
-
-	u16 txmaxpkts;	/* max number of large pkts allowed to be pending */
-
-	/* s/w decryption counters */
-	u32 swdecrypt;	/* s/w decrypt attempts */
-
 	int bcmerror;		/* last bcm error */
 
 	u32 radio_disabled;	/* bit vector for radio disabled reasons */
-	bool radio_active;	/* radio on/off state */
-	u16 roam_time_thresh;	/* Max. # secs. of not hearing beacons
-					 * before roaming.
-					 */
-	bool align_wd_tbtt;	/* Align watchdog with tbtt indication
-				 * handling. This flag is cleared by default
-				 * and is set explicitly */
 
 	u16 boardrev;	/* version # of particular board */
 	u8 sromrev;		/* version # of the srom */
 	char srom_ccode[BRCM_CNTRY_BUF_SZ];	/* Country Code in SROM */
 	u32 boardflags;	/* Board specific flags from srom */
 	u32 boardflags2;	/* More board flags if sromrev >= 4 */
-	bool tempsense_disable;	/* disable periodic tempsense check */
 	bool phy_11ncapable;	/* the PHY/HW is capable of 802.11N */
-	bool _ampdumac;		/* mac assist ampdu enabled or not */
 
 	struct wl_cnt *_cnt;	/* low-level counters in driver */
 };
 
-/* wl_monitor rx status per packet */
-struct wl_rxsts {
-	uint pkterror;		/* error flags per pkt */
-	uint phytype;		/* 802.11 A/B/G ... */
-	uint channel;		/* channel */
-	uint datarate;		/* rate in 500kbps */
-	uint antenna;		/* antenna pkts received on */
-	uint pktlength;		/* pkt length minus bcm phy hdr */
-	u32 mactime;		/* time stamp from mac, count per 1us */
-	uint sq;		/* signal quality */
-	s32 signal;		/* in dbm */
-	s32 noise;		/* in dbm */
-	uint preamble;		/* Unknown, short, long */
-	uint encoding;		/* Unknown, CCK, PBCC, OFDM */
-	uint nfrmtype;		/* special 802.11n frames(AMPDU, AMSDU) */
-	struct brcms_if *wlif;	/* wl interface */
-};
-
 enum wlc_par_id {
 	IOV_MPC = 1,
 	IOV_RTSTHRESH,
-- 
1.7.4.1


