Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3783 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034Ab1ILKPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:23 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 18/20] staging: brcm80211: removed more unused softmac
 main.h struct members
Date: Mon, 12 Sep 2011 12:15:02 +0200
Message-ID: <1315822504-24210-19-git-send-email-rvossen@broadcom.com> (sfid-20110912_121542_579495_7B177D62)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Members were always set to zero, or set but never read.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   21 ++-----------
 drivers/staging/brcm80211/brcmsmac/main.h |   47 -----------------------------
 2 files changed, 3 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 5199f6a..a1f5e24 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -168,8 +168,6 @@
 
 #define	BRCMS_HWRXOFF		38	/* chip rx buffer offset */
 
-#define OSL_SYSUPTIME()		((u32)jiffies * (1000 / HZ))
-
 /*
  * driver maintains internal 'tick'(wlc->pub->now) which increments in 1s
  * OS timer(soft watchdog) it is not a wall clock and won't increment when
@@ -3359,8 +3357,7 @@ static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc)
 			 * inits to populate a bogus beacon.
 			 */
 			if (BRCMS_PHY_11N_CAP(wlc->band))
-				brcms_c_write_shm(wlc, M_BCN_TXTSF_OFFSET,
-					      wlc->band->bcntsfoff);
+				brcms_c_write_shm(wlc, M_BCN_TXTSF_OFFSET, 0);
 		}
 	} else {
 		/* disable an active IBSS if we are not on the home channel */
@@ -3593,7 +3590,7 @@ void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc, bool promisc)
 
 void brcms_c_mac_bcn_promisc(struct brcms_c_info *wlc)
 {
-	if (wlc->bcnmisc_ibss || wlc->bcnmisc_scan || wlc->bcnmisc_monitor)
+	if (wlc->bcnmisc_monitor)
 		brcms_c_mctrl(wlc, MCTL_BCNS_PROMISC, MCTL_BCNS_PROMISC);
 	else
 		brcms_c_mctrl(wlc, MCTL_BCNS_PROMISC, 0);
@@ -4275,7 +4272,6 @@ static void brcms_c_watchdog(void *arg)
 				 WL_RADIO_MPC_DISABLE);
 			if (wlc->mpc && brcms_c_ismpc(wlc))
 				wlc->mpc_offcnt = 0;
-			wlc->mpc_laston_ts = OSL_SYSUPTIME();
 		}
 	}
 
@@ -5167,22 +5163,15 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	if (BRCMS_SGI_CAP_PHY(wlc)) {
 		brcms_c_ht_update_sgi_rx(wlc, (BRCMS_N_SGI_20 |
 					       BRCMS_N_SGI_40));
-		wlc->sgi_tx = AUTO;
 	} else if (BRCMS_ISSSLPNPHY(wlc->band)) {
 		brcms_c_ht_update_sgi_rx(wlc, (BRCMS_N_SGI_20 |
 					       BRCMS_N_SGI_40));
-		wlc->sgi_tx = AUTO;
 	} else {
 		brcms_c_ht_update_sgi_rx(wlc, 0);
-		wlc->sgi_tx = OFF;
 	}
 
 	/* *******nvram 11n config overrides Start ********* */
 
-	/* apply the sgi override from nvram conf */
-	if (n_disabled & WLFEATURE_DISABLE_11N_SGI_TX)
-		wlc->sgi_tx = OFF;
-
 	if (n_disabled & WLFEATURE_DISABLE_11N_SGI_RX)
 		brcms_c_ht_update_sgi_rx(wlc, 0);
 
@@ -5402,7 +5391,6 @@ void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
 			wlc->mpc_dlycnt = BRCMS_MPC_MAX_DELAYCNT;
 		else
 			wlc->mpc_dlycnt = BRCMS_MPC_MIN_DELAYCNT;
-		wlc->mpc_dur += OSL_SYSUPTIME() - wlc->mpc_laston_ts;
 	}
 	/*
 	 * Below logic is meant to capture the transition from mpc off
@@ -5825,9 +5813,6 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 	if (config == true)
 		brcms_c_protection_upd(wlc, BRCMS_PROT_G_USER, gmode);
 
-	/* Clear supported rates filter */
-	memset(&wlc->sup_rates_override, 0, sizeof(struct brcms_c_rateset));
-
 	/* Clear rateset override */
 	memset(&rs, 0, sizeof(struct brcms_c_rateset));
 
@@ -6663,7 +6648,7 @@ brcms_c_prec_enq_head(struct brcms_c_info *wlc, struct pktq *q,
 	if (eprec >= 0) {
 		bool discard_oldest;
 
-		discard_oldest = ac_bitmap_tst(wlc->wme_dp, eprec);
+		discard_oldest = ac_bitmap_tst(0, eprec);
 
 		/* Refuse newer packet unless configured to discard oldest */
 		if (eprec == prec && !discard_oldest) {
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 58d5c2e..ed8369f 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -281,47 +281,15 @@ struct brcms_band {
 
 	u16 CWmin; /* minimum size of contention window, in unit of aSlotTime */
 	u16 CWmax; /* maximum size of contention window, in unit of aSlotTime */
-	u16 bcntsfoff;	/* beacon tsf offset */
-};
-
-struct pkt_cb {
-	/* function to call when tx frame completes */
-	/* tx completion callback takes 3 args */
-	void (*fn)(struct brcms_c_info *wlc, uint txstatus, void *arg);
-
-	void *arg;		/* void arg for fn */
-	u8 nextidx;		/* index of next call back if threading */
-	bool entered;		/* recursion check */
 };
 
 /* module control blocks */
 struct modulecb {
 	/* module name : NULL indicates empty array member */
 	char name[32];
-	/* iovar table */
-	const struct brcmu_iovar *iovars;
 	/* handle passed when handler 'doiovar' is called */
 	struct brcms_info *hdl;
 
-	/* IOVar handler
-	 *
-	 * handle - a pointer value registered with the function
-	 * vi - iovar_info that was looked up
-	 * actionid - action ID, calculated by IOV_GVAL() and IOV_SVAL()
-	 *    based on varid.
-	 * name - the actual iovar name
-	 * params/plen - parameters and length for a get, input only.
-	 * arg/len - buffer and length for value to be set or retrieved,
-	 *      input or output.
-	 * vsize - value size, valid for integer type only.
-	 * wlcif - interface context (brcms_c_if pointer)
-	 *
-	 * All pointers may point into the same buffer.
-	 */
-	int (*iovar_fn)(void *handle, const struct brcmu_iovar *vi,
-			u32 actionid, const char *name, void *params,
-			uint plen, void *arg, int alen, int vsize);
-
 	int (*down_fn)(void *handle); /* down handler. Note: the int returned
 				       * by the down function is a count of the
 				       * number of timers that could not be
@@ -488,16 +456,12 @@ struct brcms_txq_info {
  * wdtimer: timer for watchdog routine.
  * radio_timer: timer for hw radio button monitor routine.
  * monitor: monitor (MPDU sniffing) mode.
- * bcnmisc_ibss: bcns promisc mode override for IBSS.
- * bcnmisc_scan: bcns promisc mode override for scan.
  * bcnmisc_monitor: bcns promisc mode override for monitor.
  * _rifs: enable per-packet rifs.
- * sgi_tx: sgi tx.
  * bcn_li_bcn: beacon listen interval in # beacons.
  * bcn_li_dtim: beacon listen interval in # dtims.
  * WDarmed: watchdog timer is armed.
  * WDlast: last time wlc_watchdog() was called.
- * wme_dp: AC bitmap. Discard (oldest first) policy per AC.
  * edcf_txop[AC_COUNT]: current txop for each ac.
  * wme_param_ie: on STA contains parameters in use locally, and on AP
  *		 contains parameters advertised
@@ -519,7 +483,6 @@ struct brcms_txq_info {
  * autocountry_default: initial country for 802.11d auto-country mode.
  * prb_resp_timeout: do not send prb resp if request older
  *		     than this, 0 = disable.
- * sup_rates_override: use only these rates in 11g supported rates if specified.
  * home_chanspec: shared home chanspec.
  * chanspec: target operational channel.
  * usr_fragthresh: user configured fragmentation threshold.
@@ -539,9 +502,6 @@ struct brcms_txq_info {
  * tx_duty_cycle_ofdm: maximum allowed duty cycle for OFDM.
  * tx_duty_cycle_cck: maximum allowed duty cycle for CCK.
  * pkt_queue: txq for transmit packets.
- * mpc_dur: total time (ms) in mpc mode except for the portion since
- *	    radio is turned off last time.
- * mpc_laston_ts: timestamp (ms) when radio is turned off last time.
  * wiphy:
  */
 struct brcms_c_info {
@@ -603,13 +563,10 @@ struct brcms_c_info {
 
 	/* promiscuous */
 	bool monitor;
-	bool bcnmisc_ibss;
-	bool bcnmisc_scan;
 	bool bcnmisc_monitor;
 
 	/* driver feature */
 	bool _rifs;
-	s8 sgi_tx;
 
 	/* AP-STA synchronization, power save */
 	u8 bcn_li_bcn;
@@ -619,7 +576,6 @@ struct brcms_c_info {
 	u32 WDlast;
 
 	/* WME */
-	u8 wme_dp;
 	u16 edcf_txop[AC_COUNT];
 
 	struct wme_param_ie wme_param_ie;
@@ -648,7 +604,6 @@ struct brcms_c_info {
 	char country_default[BRCM_CNTRY_BUF_SZ];
 	char autocountry_default[BRCM_CNTRY_BUF_SZ];
 	u16 prb_resp_timeout;
-	struct brcms_c_rateset sup_rates_override;
 
 	u16 home_chanspec;
 
@@ -680,8 +635,6 @@ struct brcms_c_info {
 	u16 tx_duty_cycle_cck;
 
 	struct brcms_txq_info *pkt_queue;
-	u32 mpc_dur;
-	u32 mpc_laston_ts;
 	struct wiphy *wiphy;
 };
 
-- 
1.7.4.1


