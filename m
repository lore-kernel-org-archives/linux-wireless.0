Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1623 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab1ECJgS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 09/61] staging: brcm80211: replaced WL_ERROR in
 wlc_main.c
Date: Tue, 3 May 2011 11:35:09 +0200
Message-ID: <1304415361-7813-10-git-send-email-arend@broadcom.com> (sfid-20110503_113801_591302_0E9A9785)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Replaced proprietary function by wiphy_err().

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |  299 ++++++++++++++-----------
 1 files changed, 169 insertions(+), 130 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index b4ca207..c76d401 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -278,7 +278,8 @@ static void wlc_txflowcontrol_signal(struct wlc_info *wlc,
 static void wlc_txflowcontrol_reset(struct wlc_info *wlc);
 static u16 wlc_compute_airtime(struct wlc_info *wlc, ratespec_t rspec,
 				  uint length);
-static void wlc_compute_cck_plcp(ratespec_t rate, uint length, u8 *plcp);
+static void wlc_compute_cck_plcp(struct wlc_info *wlc, ratespec_t rate,
+				 uint length, u8 *plcp);
 static void wlc_compute_ofdm_plcp(ratespec_t rate, uint length, u8 *plcp);
 static void wlc_compute_mimo_plcp(ratespec_t rate, uint length, u8 *plcp);
 static u16 wlc_compute_frame_dur(struct wlc_info *wlc, ratespec_t rate,
@@ -402,7 +403,8 @@ void wlc_reset(struct wlc_info *wlc)
 
 void wlc_fatal_error(struct wlc_info *wlc)
 {
-	WL_ERROR("wl%d: fatal error, reinitializing\n", wlc->pub->unit);
+	wiphy_err(wlc->wiphy, "wl%d: fatal error, reinitializing\n",
+		  wlc->pub->unit);
 	wl_init(wlc->wl);
 }
 
@@ -624,8 +626,8 @@ bool wlc_ps_check(struct wlc_info *wlc)
 		 * take care of the condition. This is just to avoid assert
 		 */
 		if (tmp == 0xffffffff) {
-			WL_ERROR("wl%d: %s: dead chip\n",
-				 wlc->pub->unit, __func__);
+			wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n",
+				  wlc->pub->unit, __func__);
 			return DEVICEREMOVED(wlc);
 		}
 
@@ -634,8 +636,9 @@ bool wlc_ps_check(struct wlc_info *wlc)
 		if (hps != ((tmp & MCTL_HPS) != 0)) {
 			int idx;
 			struct wlc_bsscfg *cfg;
-			WL_ERROR("wl%d: hps not sync, sw %d, maccontrol 0x%x\n",
-				 wlc->pub->unit, hps, tmp);
+			wiphy_err(wlc->wiphy, "wl%d: hps not sync, sw %d, "
+				  "maccontrol 0x%x\n",
+				  wlc->pub->unit, hps, tmp);
 			FOREACH_BSS(wlc, idx, cfg) {
 				if (!BSSCFG_STA(cfg))
 					continue;
@@ -649,8 +652,9 @@ bool wlc_ps_check(struct wlc_info *wlc)
 		wake = STAY_AWAKE(wlc) || wlc->hw->wake_override;
 		wake_ok = (wake == ((tmp & MCTL_WAKE) != 0));
 		if (hps && !wake_ok) {
-			WL_ERROR("wl%d: wake not sync, sw %d maccontrol 0x%x\n",
-				 wlc->pub->unit, wake, tmp);
+			wiphy_err(wlc->wiphy, "wl%d: wake not sync, sw %d "
+				  "maccontrol 0x%x\n",
+				  wlc->pub->unit, wake, tmp);
 			res = false;
 		}
 	}
@@ -829,8 +833,8 @@ void wlc_set_chanspec(struct wlc_info *wlc, chanspec_t chanspec)
 	chanspec_t old_chanspec = wlc->chanspec;
 
 	if (!wlc_valid_chanspec_db(wlc->cmi, chanspec)) {
-		WL_ERROR("wl%d: %s: Bad channel %d\n",
-			 wlc->pub->unit, __func__, CHSPEC_CHANNEL(chanspec));
+		wiphy_err(wlc->wiphy, "wl%d: %s: Bad channel %d\n",
+			  wlc->pub->unit, __func__, CHSPEC_CHANNEL(chanspec));
 		ASSERT(wlc_valid_chanspec_db(wlc->cmi, chanspec));
 		return;
 	}
@@ -841,9 +845,10 @@ void wlc_set_chanspec(struct wlc_info *wlc, chanspec_t chanspec)
 		if (wlc->band->bandunit != bandunit || wlc->bandinit_pending) {
 			switchband = true;
 			if (wlc->bandlocked) {
-				WL_ERROR("wl%d: %s: chspec %d band is locked!\n",
-					 wlc->pub->unit, __func__,
-					 CHSPEC_CHANNEL(chanspec));
+				wiphy_err(wlc->wiphy, "wl%d: %s: chspec %d "
+					  "band is locked!\n",
+					  wlc->pub->unit, __func__,
+					  CHSPEC_CHANNEL(chanspec));
 				return;
 			}
 			/* BMAC_NOTE: should the setband call come after the wlc_bmac_chanspec() ?
@@ -1373,7 +1378,8 @@ void wlc_wme_setparams(struct wlc_info *wlc, u16 aci,
 
 	/* Only apply params if the core is out of reset and has clocks */
 	if (!wlc->clk) {
-		WL_ERROR("wl%d: %s : no-clock\n", wlc->pub->unit, __func__);
+		wiphy_err(wlc->wiphy, "wl%d: %s : no-clock\n", wlc->pub->unit,
+			  __func__);
 		return;
 	}
 
@@ -1397,8 +1403,8 @@ void wlc_wme_setparams(struct wlc_info *wlc, u16 aci,
 
 		if (acp_shm.aifs < EDCF_AIFSN_MIN
 		    || acp_shm.aifs > EDCF_AIFSN_MAX) {
-			WL_ERROR("wl%d: wlc_edcf_setparams: bad aifs %d\n",
-				 wlc->pub->unit, acp_shm.aifs);
+			wiphy_err(wlc->wiphy, "wl%d: wlc_edcf_setparams: bad "
+				  "aifs %d\n", wlc->pub->unit, acp_shm.aifs);
 			continue;
 		}
 
@@ -1491,14 +1497,16 @@ bool wlc_timers_init(struct wlc_info *wlc, int unit)
 	wlc->wdtimer = wl_init_timer(wlc->wl, wlc_watchdog_by_timer,
 		wlc, "watchdog");
 	if (!wlc->wdtimer) {
-		WL_ERROR("wl%d:  wl_init_timer for wdtimer failed\n", unit);
+		wiphy_err(wlc->wiphy, "wl%d:  wl_init_timer for wdtimer "
+			  "failed\n", unit);
 		goto fail;
 	}
 
 	wlc->radio_timer = wl_init_timer(wlc->wl, wlc_radio_timer,
 		wlc, "radio");
 	if (!wlc->radio_timer) {
-		WL_ERROR("wl%d:  wl_init_timer for radio_timer failed\n", unit);
+		wiphy_err(wlc->wiphy, "wl%d:  wl_init_timer for radio_timer "
+			  "failed\n", unit);
 		goto fail;
 	}
 
@@ -1645,20 +1653,23 @@ static uint wlc_attach_module(struct wlc_info *wlc)
 
 	wlc->asi = wlc_antsel_attach(wlc);
 	if (wlc->asi == NULL) {
-		WL_ERROR("wl%d: wlc_attach: wlc_antsel_attach failed\n", unit);
+		wiphy_err(wlc->wiphy, "wl%d: wlc_attach: wlc_antsel_attach "
+			  "failed\n", unit);
 		err = 44;
 		goto fail;
 	}
 
 	wlc->ampdu = wlc_ampdu_attach(wlc);
 	if (wlc->ampdu == NULL) {
-		WL_ERROR("wl%d: wlc_attach: wlc_ampdu_attach failed\n", unit);
+		wiphy_err(wlc->wiphy, "wl%d: wlc_attach: wlc_ampdu_attach "
+			  "failed\n", unit);
 		err = 50;
 		goto fail;
 	}
 
 	if ((wlc_stf_attach(wlc) != 0)) {
-		WL_ERROR("wl%d: wlc_attach: wlc_stf_attach failed\n", unit);
+		wiphy_err(wlc->wiphy, "wl%d: wlc_attach: wlc_stf_attach "
+			  "failed\n", unit);
 		err = 68;
 		goto fail;
 	}
@@ -1827,7 +1838,8 @@ void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
 		goto fail;
 
 	if (!wlc_timers_init(wlc, unit)) {
-		WL_ERROR("wl%d: %s: wlc_init_timer failed\n", unit, __func__);
+		wiphy_err(wl->wiphy, "wl%d: %s: wlc_init_timer failed\n", unit,
+			  __func__);
 		err = 32;
 		goto fail;
 	}
@@ -1835,8 +1847,8 @@ void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
 	/* depend on rateset, gmode */
 	wlc->cmi = wlc_channel_mgr_attach(wlc);
 	if (!wlc->cmi) {
-		WL_ERROR("wl%d: %s: wlc_channel_mgr_attach failed\n",
-			 unit, __func__);
+		wiphy_err(wl->wiphy, "wl%d: %s: wlc_channel_mgr_attach failed"
+			  "\n", unit, __func__);
 		err = 33;
 		goto fail;
 	}
@@ -1851,8 +1863,8 @@ void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
 	/* allocate our initial queue */
 	qi = wlc_txq_alloc(wlc);
 	if (qi == NULL) {
-		WL_ERROR("wl%d: %s: failed to malloc tx queue\n",
-			 unit, __func__);
+		wiphy_err(wl->wiphy, "wl%d: %s: failed to malloc tx queue\n",
+			  unit, __func__);
 		err = 100;
 		goto fail;
 	}
@@ -1936,7 +1948,8 @@ void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
 	return (void *)wlc;
 
  fail:
-	WL_ERROR("wl%d: %s: failed with err %d\n", unit, __func__, err);
+	wiphy_err(wl->wiphy, "wl%d: %s: failed with err %d\n",
+		  unit, __func__, err);
 	if (wlc)
 		wlc_detach(wlc);
 
@@ -1954,8 +1967,8 @@ static void wlc_attach_antgain_init(struct wlc_info *wlc)
 		/* default antenna gain for srom rev 1 is 2 dBm (8 qdbm) */
 		wlc->band->antgain = 8;
 	} else if (wlc->band->antgain == -1) {
-		WL_ERROR("wl%d: %s: Invalid antennas available in srom, using 2dB\n",
-			 unit, __func__);
+		wiphy_err(wlc->wiphy, "wl%d: %s: Invalid antennas available in"
+			  " srom, using 2dB\n", unit, __func__);
 		wlc->band->antgain = 8;
 	} else {
 		s8 gain, fract;
@@ -1994,8 +2007,8 @@ static bool wlc_attach_stf_ant_init(struct wlc_info *wlc)
 		aa = (s8) getintvar(vars,
 				      (BAND_5G(bandtype) ? "aa1" : "aa0"));
 	if ((aa < 1) || (aa > 15)) {
-		WL_ERROR("wl%d: %s: Invalid antennas available in srom (0x%x), using 3\n",
-			 unit, __func__, aa);
+		wiphy_err(wlc->wiphy, "wl%d: %s: Invalid antennas available in"
+			  " srom (0x%x), using 3\n", unit, __func__, aa);
 		aa = 3;
 	}
 
@@ -2271,7 +2284,8 @@ static void wlc_radio_timer(void *arg)
 	struct wlc_info *wlc = (struct wlc_info *) arg;
 
 	if (DEVICEREMOVED(wlc)) {
-		WL_ERROR("wl%d: %s: dead chip\n", wlc->pub->unit, __func__);
+		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
+			__func__);
 		wl_down(wlc->wl);
 		return;
 	}
@@ -2378,7 +2392,8 @@ static void wlc_watchdog(void *arg)
 		return;
 
 	if (DEVICEREMOVED(wlc)) {
-		WL_ERROR("wl%d: %s: dead chip\n", wlc->pub->unit, __func__);
+		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
+			  __func__);
 		wl_down(wlc->wl);
 		return;
 	}
@@ -2494,8 +2509,10 @@ int wlc_up(struct wlc_info *wlc)
 					if (!BSSCFG_STA(bsscfg)
 					    || !bsscfg->enable || !bsscfg->BSS)
 						continue;
-					WL_ERROR("wl%d.%d: wlc_up: rfdisable -> " "wlc_bsscfg_disable()\n",
-						 wlc->pub->unit, idx);
+					wiphy_err(wlc->wiphy, "wl%d.%d: wlc_up"
+						  ": rfdisable -> "
+						  "wlc_bsscfg_disable()\n",
+						   wlc->pub->unit, idx);
 				}
 			}
 		} else
@@ -2599,8 +2616,8 @@ uint wlc_down(struct wlc_info *wlc)
 
 	/* check if we are already in the going down path */
 	if (wlc->going_down) {
-		WL_ERROR("wl%d: %s: Driver going down so return\n",
-			 wlc->pub->unit, __func__);
+		wiphy_err(wlc->wiphy, "wl%d: %s: Driver going down so return"
+			  "\n", wlc->pub->unit, __func__);
 		return 0;
 	}
 	if (!wlc->pub->up)
@@ -2745,8 +2762,8 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 
 	default:
 		/* Error */
-		WL_ERROR("wl%d: %s: invalid gmode %d\n",
-			 wlc->pub->unit, __func__, gmode);
+		wiphy_err(wlc->wiphy, "wl%d: %s: invalid gmode %d\n",
+			  wlc->pub->unit, __func__, gmode);
 		return -BCME_UNSUPPORTED;
 	}
 
@@ -3000,7 +3017,8 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	/* If the device is turned off, then it's not "removed" */
 	if (!wlc->pub->hw_off && DEVICEREMOVED(wlc)) {
-		WL_ERROR("wl%d: %s: dead chip\n", wlc->pub->unit, __func__);
+		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
+			  __func__);
 		wl_down(wlc->wl);
 		return -BCME_ERROR;
 	}
@@ -3035,8 +3053,9 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	default:
 		if ((arg == NULL) || (len <= 0)) {
-			WL_ERROR("wl%d: %s: Command %d needs arguments\n",
-				 wlc->pub->unit, __func__, cmd);
+			wiphy_err(wlc->wiphy, "wl%d: %s: Command %d needs "
+				  "arguments\n",
+				  wlc->pub->unit, __func__, cmd);
 			bcmerror = -BCME_BADARG;
 			goto done;
 		}
@@ -3456,8 +3475,8 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			if ((radiomask == 0) || (radiomask & ~validbits)
 			    || (radioval & ~validbits)
 			    || ((radioval & ~radiomask) != 0)) {
-				WL_ERROR("SET_RADIO with wrong bits 0x%x\n",
-					 val);
+				wiphy_err(wlc->wiphy, "SET_RADIO with wrong "
+					  "bits 0x%x\n", val);
 				bcmerror = -BCME_RANGE;
 				break;
 			}
@@ -4094,7 +4113,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 #endif
 
 	case WLC_LAST:
-		WL_ERROR("%s: WLC_LAST\n", __func__);
+		wiphy_err(wlc->wiphy, "%s: WLC_LAST\n", __func__);
 	}
  done:
 
@@ -4304,8 +4323,8 @@ wlc_iovar_op(struct wlc_info *wlc, const char *name,
 
 	if (!set && (len == sizeof(int)) &&
 	    !(IS_ALIGNED((unsigned long)(arg), (uint) sizeof(int)))) {
-		WL_ERROR("wl%d: %s unaligned get ptr for %s\n",
-			 wlc->pub->unit, __func__, name);
+		wiphy_err(wlc->wiphy, "wl%d: %s unaligned get ptr for %s\n",
+			  wlc->pub->unit, __func__, name);
 		ASSERT(0);
 	}
 
@@ -4518,7 +4537,8 @@ wlc_doiovar(void *hdl, const bcm_iovar_t *vi, u32 actionid,
 		break;
 
 	default:
-		WL_ERROR("wl%d: %s: unsupported\n", wlc->pub->unit, __func__);
+		wiphy_err(wlc->wiphy, "wl%d: %s: unsupported\n",
+			  wlc->pub->unit, __func__);
 		err = -BCME_UNSUPPORTED;
 		break;
 	}
@@ -4732,8 +4752,8 @@ void wlc_statsupd(struct wlc_info *wlc)
 	/* check for rx fifo 0 overflow */
 	delta = (u16) (wlc->core->macstat_snapshot->rxf0ovfl - rxf0ovfl);
 	if (delta)
-		WL_ERROR("wl%d: %u rx fifo 0 overflows!\n",
-			 wlc->pub->unit, delta);
+		wiphy_err(wlc->wiphy, "wl%d: %u rx fifo 0 overflows!\n",
+			  wlc->pub->unit, delta);
 
 	/* check for tx fifo underflows */
 	for (i = 0; i < NFIFO; i++) {
@@ -4741,8 +4761,8 @@ void wlc_statsupd(struct wlc_info *wlc)
 		    (u16) (wlc->core->macstat_snapshot->txfunfl[i] -
 			      txfunfl[i]);
 		if (delta)
-			WL_ERROR("wl%d: %u tx fifo %d underflows!\n",
-				 wlc->pub->unit, delta, i);
+			wiphy_err(wlc->wiphy, "wl%d: %u tx fifo %d underflows!"
+				  "\n", wlc->pub->unit, delta, i);
 	}
 #endif				/* BCMDBG */
 
@@ -4791,7 +4811,7 @@ void wlc_statsupd(struct wlc_info *wlc)
 bool wlc_chipmatch(u16 vendor, u16 device)
 {
 	if (vendor != PCI_VENDOR_ID_BROADCOM) {
-		WL_ERROR("wlc_chipmatch: unknown vendor id %04x\n", vendor);
+		pr_err("wlc_chipmatch: unknown vendor id %04x\n", vendor);
 		return false;
 	}
 
@@ -4803,7 +4823,7 @@ bool wlc_chipmatch(u16 vendor, u16 device)
 	if ((device == BCM43236_D11N_ID) || (device == BCM43236_D11N2G_ID))
 		return true;
 
-	WL_ERROR("wlc_chipmatch: unknown device id %04x\n", device);
+	pr_err("wlc_chipmatch: unknown device id %04x\n", device);
 	return false;
 }
 
@@ -4994,8 +5014,8 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 		p = pktq_peek_tail(q, &eprec);
 		ASSERT(p != NULL);
 		if (eprec > prec) {
-			WL_ERROR("%s: Failing: eprec %d > prec %d\n",
-				 __func__, eprec, prec);
+			wiphy_err(wlc->wiphy, "%s: Failing: eprec %d > prec %d"
+				  "\n", __func__, eprec, prec);
 			return false;
 		}
 	}
@@ -5011,8 +5031,8 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 
 		/* Refuse newer packet unless configured to discard oldest */
 		if (eprec == prec && !discard_oldest) {
-			WL_ERROR("%s: No where to go, prec == %d\n",
-				 __func__, prec);
+			wiphy_err(wlc->wiphy, "%s: No where to go, prec == %d"
+				  "\n", __func__, prec);
 			return false;
 		}
 
@@ -5058,8 +5078,8 @@ void BCMFASTPATH wlc_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 	if (!wlc_prec_enq(wlc, q, sdu, prec)) {
 		if (!EDCF_ENAB(wlc->pub)
 		    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL))
-			WL_ERROR("wl%d: wlc_txq_enq: txq overflow\n",
-				 wlc->pub->unit);
+			wiphy_err(wlc->wiphy, "wl%d: wlc_txq_enq: txq overflow"
+				  "\n", wlc->pub->unit);
 
 		/*
 		 * XXX we might hit this condtion in case
@@ -5245,7 +5265,7 @@ wlc_txfifo(struct wlc_info *wlc, uint fifo, struct sk_buff *p, bool commit,
 		BCMCFID(wlc, frameid);
 
 	if (dma_txfast(wlc->hw->di[fifo], p, commit) < 0) {
-		WL_ERROR("wlc_txfifo: fatal, toss frames !!!\n");
+		wiphy_err(wlc->wiphy, "wlc_txfifo: fatal, toss frames !!!\n");
 	}
 }
 
@@ -5285,8 +5305,9 @@ wlc_compute_airtime(struct wlc_info *wlc, ratespec_t rspec, uint length)
 			usec = (length << 3) / 11;
 			break;
 		default:
-			WL_ERROR("wl%d: wlc_compute_airtime: unsupported rspec 0x%x\n",
-				 wlc->pub->unit, rspec);
+			wiphy_err(wlc->wiphy, "wl%d: wlc_compute_airtime: "
+				  "unsupported rspec 0x%x\n",
+				  wlc->pub->unit, rspec);
 			ASSERT((const char *)"Bad phy_rate" == NULL);
 			break;
 		}
@@ -5303,7 +5324,7 @@ wlc_compute_plcp(struct wlc_info *wlc, ratespec_t rspec, uint length, u8 *plcp)
 	} else if (IS_OFDM(rspec)) {
 		wlc_compute_ofdm_plcp(rspec, length, plcp);
 	} else {
-		wlc_compute_cck_plcp(rspec, length, plcp);
+		wlc_compute_cck_plcp(wlc, rspec, length, plcp);
 	}
 	return;
 }
@@ -5355,7 +5376,8 @@ wlc_compute_ofdm_plcp(ratespec_t rspec, u32 length, u8 *plcp)
  * Broken out for PRQ.
  */
 
-static void wlc_cck_plcp_set(int rate_500, uint length, u8 *plcp)
+static void wlc_cck_plcp_set(struct wlc_info *wlc, int rate_500, uint length,
+			     u8 *plcp)
 {
 	u16 usec = 0;
 	u8 le = 0;
@@ -5382,7 +5404,8 @@ static void wlc_cck_plcp_set(int rate_500, uint length, u8 *plcp)
 		break;
 
 	default:
-		WL_ERROR("wlc_cck_plcp_set: unsupported rate %d\n", rate_500);
+		wiphy_err(wlc->wiphy, "wlc_cck_plcp_set: unsupported rate %d"
+			  "\n", rate_500);
 		rate_500 = WLC_RATE_1M;
 		usec = length << 3;
 		break;
@@ -5400,13 +5423,14 @@ static void wlc_cck_plcp_set(int rate_500, uint length, u8 *plcp)
 }
 
 /* Rate: 802.11 rate code, length: PSDU length in octets */
-static void wlc_compute_cck_plcp(ratespec_t rspec, uint length, u8 *plcp)
+static void wlc_compute_cck_plcp(struct wlc_info *wlc, ratespec_t rspec,
+				 uint length, u8 *plcp)
 {
 	int rate = RSPEC2RATE(rspec);
 
 	ASSERT(IS_CCK(rspec));
 
-	wlc_cck_plcp_set(rate, length, plcp);
+	wlc_cck_plcp_set(wlc, rate, length, plcp);
 }
 
 /* wlc_compute_frame_dur()
@@ -5522,8 +5546,8 @@ u16 BCMFASTPATH wlc_phytxctl1_calc(struct wlc_info *wlc, ratespec_t rspec)
 		bw = RSPEC_GET_BW(rspec);
 		/* 10Mhz is not supported yet */
 		if (bw < PHY_TXC1_BW_20MHZ) {
-			WL_ERROR("wlc_phytxctl1_calc: bw %d is not supported yet, set to 20L\n",
-				 bw);
+			wiphy_err(wlc->wiphy, "wlc_phytxctl1_calc: bw %d is "
+				  "not supported yet, set to 20L\n", bw);
 			bw = PHY_TXC1_BW_20MHZ;
 		}
 
@@ -5548,7 +5572,8 @@ u16 BCMFASTPATH wlc_phytxctl1_calc(struct wlc_info *wlc, ratespec_t rspec)
 		/* get the phyctl byte from rate phycfg table */
 		phycfg = wlc_rate_legacy_phyctl(RSPEC2RATE(rspec));
 		if (phycfg == -1) {
-			WL_ERROR("wlc_phytxctl1_calc: wrong legacy OFDM/CCK rate\n");
+			wiphy_err(wlc->wiphy, "wlc_phytxctl1_calc: wrong "
+				  "legacy OFDM/CCK rate\n");
 			ASSERT(0);
 			phycfg = 0;
 		}
@@ -5698,8 +5723,8 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		/* non-AP STA should never use BCMC queue */
 		ASSERT(queue != TX_BCMC_FIFO);
 		if (queue == TX_BCMC_FIFO) {
-			WL_ERROR("wl%d: %s: ASSERT queue == TX_BCMC!\n",
-				 WLCWLUNIT(wlc), __func__);
+			wiphy_err(wlc->wiphy, "wl%d: %s: ASSERT queue == "
+				  "TX_BCMC!\n", WLCWLUNIT(wlc), __func__);
 			frameid = bcmc_fid_generate(wlc, NULL, txh);
 		} else {
 			/* Increment the counter for first fragment */
@@ -5876,8 +5901,9 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 
 			if ((txrate[k]->flags & IEEE80211_TX_RC_MCS)
 			    && (!IS_MCS(rspec[k]))) {
-				WL_ERROR("wl%d: %s: IEEE80211_TX_RC_MCS != IS_MCS(rspec)\n",
-					 WLCWLUNIT(wlc), __func__);
+				wiphy_err(wlc->wiphy, "wl%d: %s: IEEE80211_TX_"
+					  "RC_MCS != IS_MCS(rspec)\n",
+					  WLCWLUNIT(wlc), __func__);
 				ASSERT(0 && "Rate mismatch");
 			}
 
@@ -6278,16 +6304,18 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 					}
 				}
 			} else
-				WL_ERROR("wl%d: %s txop invalid for rate %d\n",
-					 wlc->pub->unit, fifo_names[queue],
-					 RSPEC2RATE(rspec[0]));
+				wiphy_err(wlc->wiphy, "wl%d: %s txop invalid "
+					  "for rate %d\n",
+					  wlc->pub->unit, fifo_names[queue],
+					  RSPEC2RATE(rspec[0]));
 
 			if (dur > wlc->edcf_txop[ac])
-				WL_ERROR("wl%d: %s: %s txop exceeded phylen %d/%d dur %d/%d\n",
-					 wlc->pub->unit, __func__,
-					 fifo_names[queue],
-					 phylen, wlc->fragthresh[queue],
-					 dur, wlc->edcf_txop[ac]);
+				wiphy_err(wlc->wiphy, "wl%d: %s: %s txop "
+					  "exceeded phylen %d/%d dur %d/%d\n",
+					  wlc->pub->unit, __func__,
+					  fifo_names[queue],
+					  phylen, wlc->fragthresh[queue],
+					  dur, wlc->edcf_txop[ac]);
 		}
 	}
 
@@ -6407,8 +6435,9 @@ void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus)
 		wlc_tbtt(wlc, regs);
 
 	if (macintstatus & MI_GP0) {
-		WL_ERROR("wl%d: PSM microcode watchdog fired at %d (seconds). Resetting.\n",
-			 wlc->pub->unit, wlc->pub->now);
+		wiphy_err(wlc->wiphy, "wl%d: PSM microcode watchdog fired at "
+			  "%d (seconds). Resetting.\n",
+			  wlc->pub->unit, wlc->pub->now);
 
 		printk_once("%s : PSM Watchdog, chipid 0x%x, chiprev 0x%x\n",
 					__func__, wlc->pub->sih->chip,
@@ -6426,9 +6455,9 @@ void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus)
 	}
 
 	if (macintstatus & MI_RFDISABLE) {
-		WL_ERROR("wl%d: MAC Detected a change on the RF Disable Input 0x%x\n",
-			 wlc->pub->unit,
-			 R_REG(&regs->phydebug) & PDBG_RFD);
+		wiphy_err(wlc->wiphy, "wl%d: MAC Detected a change on the RF "
+			  "Disable Input 0x%x\n", wlc->pub->unit,
+			  R_REG(&regs->phydebug) & PDBG_RFD);
 		/* delay the cleanup to wl_down in IBSS case */
 		if ((R_REG(&regs->phydebug) & PDBG_RFD)) {
 			int idx;
@@ -6437,8 +6466,9 @@ void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus)
 				if (!BSSCFG_STA(bsscfg) || !bsscfg->enable
 				    || !bsscfg->BSS)
 					continue;
-				WL_ERROR("wl%d: wlc_dpc: rfdisable -> wlc_bsscfg_disable()\n",
-					 wlc->pub->unit);
+				wiphy_err(wlc->wiphy, "wl%d: wlc_dpc: "
+					  "rfdisable -> wlc_bsscfg_disable()"
+					  "\n", wlc->pub->unit);
 			}
 		}
 	}
@@ -6495,7 +6525,8 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 			 ((txs->
 			   status & TX_STATUS_FRM_RTX_MASK) >>
 			  TX_STATUS_FRM_RTX_SHIFT));
-		WL_ERROR("%s: INTERMEDIATE but not AMPDU\n", __func__);
+		wiphy_err(wlc->wiphy, "%s: INTERMEDIATE but not AMPDU\n",
+			  __func__);
 		return false;
 	}
 
@@ -6517,8 +6548,8 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 
 	if (txs->phyerr) {
 		if (WL_ERROR_ON()) {
-			WL_ERROR("phyerr 0x%x, rate 0x%x\n",
-				 txs->phyerr, txh->MainRates);
+			wiphy_err(wlc->wiphy, "phyerr 0x%x, rate 0x%x\n",
+				  txs->phyerr, txh->MainRates);
 			wlc_print_txdesc(txh);
 		}
 		wlc_print_txstatus(txs);
@@ -6562,7 +6593,7 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 	lastframe = !ieee80211_has_morefrags(h->frame_control);
 
 	if (!lastframe) {
-		WL_ERROR("Not last frame!\n");
+		wiphy_err(wlc->wiphy, "Not last frame!\n");
 	} else {
 		u16 sfbl, lfbl;
 		ieee80211_tx_info_clear_status(tx_info);
@@ -6613,8 +6644,8 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 		ieee80211_tx_status_irqsafe(wlc->pub->ieee_hw, p);
 		wlc->pub->_cnt->ieee_tx_status++;
 	} else {
-		WL_ERROR("%s: Not last frame => not calling tx_status\n",
-			 __func__);
+		wiphy_err(wlc->wiphy, "%s: Not last frame => not calling "
+			  "tx_status\n", __func__);
 	}
 
 	return false;
@@ -6831,7 +6862,7 @@ prep_mac80211_status(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p,
 			rx_status->rate_idx = 11;
 			break;
 		default:
-			WL_ERROR("%s: Unknown rate\n", __func__);
+			wiphy_err(wlc->wiphy, "%s: Unknown rate\n", __func__);
 		}
 
 		/* Determine short preamble and rate_idx */
@@ -6842,7 +6873,8 @@ prep_mac80211_status(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p,
 		} else if (IS_OFDM(rspec)) {
 			rx_status->flag |= RX_FLAG_SHORTPRE;
 		} else {
-			WL_ERROR("%s: Unknown modulation\n", __func__);
+			wiphy_err(wlc->wiphy, "%s: Unknown modulation\n",
+				  __func__);
 		}
 	}
 
@@ -6851,11 +6883,13 @@ prep_mac80211_status(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p,
 
 	if (rxh->RxStatus1 & RXS_DECERR) {
 		rx_status->flag |= RX_FLAG_FAILED_PLCP_CRC;
-		WL_ERROR("%s:  RX_FLAG_FAILED_PLCP_CRC\n", __func__);
+		wiphy_err(wlc->wiphy, "%s:  RX_FLAG_FAILED_PLCP_CRC\n",
+			  __func__);
 	}
 	if (rxh->RxStatus1 & RXS_FCSERR) {
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
-		WL_ERROR("%s:  RX_FLAG_FAILED_FCS_CRC\n", __func__);
+		wiphy_err(wlc->wiphy, "%s:  RX_FLAG_FAILED_FCS_CRC\n",
+			  __func__);
 	}
 }
 
@@ -6893,7 +6927,8 @@ void wlc_bss_list_free(struct wlc_info *wlc, struct wlc_bss_list *bss_list)
 	uint index;
 
 	if (!bss_list) {
-		WL_ERROR("%s: Attempting to free NULL list\n", __func__);
+		wiphy_err(wlc->wiphy, "%s: Attempting to free NULL list\n",
+			  __func__);
 		return;
 	}
 	/* inspect all BSS descriptor */
@@ -6942,8 +6977,8 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 	if (rxh->RxStatus1 & RXS_PBPRES) {
 		if (p->len < 2) {
 			wlc->pub->_cnt->rxrunt++;
-			WL_ERROR("wl%d: wlc_recv: rcvd runt of len %d\n",
-				 wlc->pub->unit, p->len);
+			wiphy_err(wlc->wiphy, "wl%d: wlc_recv: rcvd runt of "
+				  "len %d\n", wlc->pub->unit, p->len);
 			goto toss;
 		}
 		skb_pull(p, 2);
@@ -6954,10 +6989,11 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 
 	if (rxh->RxStatus1 & RXS_FCSERR) {
 		if (wlc->pub->mac80211_state & MAC80211_PROMISC_BCNS) {
-			WL_ERROR("FCSERR while scanning******* - tossing\n");
+			wiphy_err(wlc->wiphy, "FCSERR while scanning******* -"
+				  " tossing\n");
 			goto toss;
 		} else {
-			WL_ERROR("RCSERR!!!\n");
+			wiphy_err(wlc->wiphy, "RCSERR!!!\n");
 			goto toss;
 		}
 	}
@@ -6978,8 +7014,9 @@ void BCMFASTPATH wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
 		    ieee80211_is_mgmt(h->frame_control)) {
 			if ((is_zero_ether_addr(h->addr2) ||
 			     is_multicast_ether_addr(h->addr2))) {
-				WL_ERROR("wl%d: %s: dropping a frame with "
-					 "invalid src mac address, a2: %pM\n",
+				wiphy_err(wlc->wiphy, "wl%d: %s: dropping a "
+					  "frame with invalid src mac address,"
+					  " a2: %pM\n",
 					 wlc->pub->unit, __func__, h->addr2);
 				wlc->pub->_cnt->rxbadsrcmac++;
 				goto toss;
@@ -7058,7 +7095,8 @@ wlc_calc_frame_time(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 
 	if (rate == 0) {
 		ASSERT(0);
-		WL_ERROR("wl%d: WAR: using rate of 1 mbps\n", wlc->pub->unit);
+		wiphy_err(wlc->wiphy, "wl%d: WAR: using rate of 1 mbps\n",
+			  wlc->pub->unit);
 		rate = WLC_RATE_1M;
 	}
 
@@ -7237,8 +7275,9 @@ void wlc_rate_lookup_init(struct wlc_info *wlc, wlc_rateset_t *rateset)
 		rate = (rateset->rates[i] & RATE_MASK);
 
 		if (rate > WLC_MAXRATE) {
-			WL_ERROR("wlc_rate_lookup_init: invalid rate 0x%X in rate set\n",
-				 rateset->rates[i]);
+			wiphy_err(wlc->wiphy, "wlc_rate_lookup_init: invalid "
+				  "rate 0x%X in rate set\n",
+				  rateset->rates[i]);
 			continue;
 		}
 
@@ -7417,8 +7456,8 @@ bool wlc_valid_rate(struct wlc_info *wlc, ratespec_t rspec, int band,
 			return true;
  error:
 	if (verbose) {
-		WL_ERROR("wl%d: wlc_valid_rate: rate spec 0x%x not in hw_rateset\n",
-			 wlc->pub->unit, rspec);
+		wiphy_err(wlc->wiphy, "wl%d: wlc_valid_rate: rate spec 0x%x "
+			  "not in hw_rateset\n", wlc->pub->unit, rspec);
 	}
 
 	return false;
@@ -7500,8 +7539,8 @@ wlc_compute_bcntsfoff(struct wlc_info *wlc, ratespec_t rspec,
 	uint bcntsfoff = 0;
 
 	if (IS_MCS(rspec)) {
-		WL_ERROR("wl%d: recd beacon with mcs rate; rspec 0x%x\n",
-			 wlc->pub->unit, rspec);
+		wiphy_err(wlc->wiphy, "wl%d: recd beacon with mcs rate; rspec "
+			  "0x%x\n", wlc->pub->unit, rspec);
 	} else if (IS_OFDM(rspec)) {
 		/* tx delay from MAC through phy to air (2.1 usec) +
 		 * phy header time (preamble + PLCP SIGNAL == 20 usec) +
@@ -7907,7 +7946,7 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 	if (N_ENAB(wlc->pub) && ismcs) {
 		/* mcs only allowed when nmode */
 		if (stf > PHY_TXC1_MODE_SDM) {
-			WL_ERROR("wl%d: %s: Invalid stf\n",
+			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid stf\n",
 				 WLCWLUNIT(wlc), __func__);
 			bcmerror = -BCME_RANGE;
 			goto done;
@@ -7918,8 +7957,8 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 			if (!CHSPEC_IS40(wlc->home_chanspec) ||
 			    ((stf != PHY_TXC1_MODE_SISO)
 			     && (stf != PHY_TXC1_MODE_CDD))) {
-				WL_ERROR("wl%d: %s: Invalid mcs 32\n",
-					 WLCWLUNIT(wlc), __func__);
+				wiphy_err(wlc->wiphy, "wl%d: %s: Invalid mcs "
+					  "32\n", WLCWLUNIT(wlc), __func__);
 				bcmerror = -BCME_RANGE;
 				goto done;
 			}
@@ -7936,37 +7975,37 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 			if ((stf > PHY_TXC1_MODE_STBC) ||
 			    (!WLC_STBC_CAP_PHY(wlc)
 			     && (stf == PHY_TXC1_MODE_STBC))) {
-				WL_ERROR("wl%d: %s: Invalid STBC\n",
-					 WLCWLUNIT(wlc), __func__);
+				wiphy_err(wlc->wiphy, "wl%d: %s: Invalid STBC"
+					  "\n", WLCWLUNIT(wlc), __func__);
 				bcmerror = -BCME_RANGE;
 				goto done;
 			}
 		}
 	} else if (IS_OFDM(rate)) {
 		if ((stf != PHY_TXC1_MODE_CDD) && (stf != PHY_TXC1_MODE_SISO)) {
-			WL_ERROR("wl%d: %s: Invalid OFDM\n",
-				 WLCWLUNIT(wlc), __func__);
+			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid OFDM\n",
+				  WLCWLUNIT(wlc), __func__);
 			bcmerror = -BCME_RANGE;
 			goto done;
 		}
 	} else if (IS_CCK(rate)) {
 		if ((cur_band->bandtype != WLC_BAND_2G)
 		    || (stf != PHY_TXC1_MODE_SISO)) {
-			WL_ERROR("wl%d: %s: Invalid CCK\n",
-				 WLCWLUNIT(wlc), __func__);
+			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid CCK\n",
+				  WLCWLUNIT(wlc), __func__);
 			bcmerror = -BCME_RANGE;
 			goto done;
 		}
 	} else {
-		WL_ERROR("wl%d: %s: Unknown rate type\n",
-			 WLCWLUNIT(wlc), __func__);
+		wiphy_err(wlc->wiphy, "wl%d: %s: Unknown rate type\n",
+			  WLCWLUNIT(wlc), __func__);
 		bcmerror = -BCME_RANGE;
 		goto done;
 	}
 	/* make sure multiple antennae are available for non-siso rates */
 	if ((stf != PHY_TXC1_MODE_SISO) && (wlc->stf->txstreams == 1)) {
-		WL_ERROR("wl%d: %s: SISO antenna but !SISO request\n",
-			 WLCWLUNIT(wlc), __func__);
+		wiphy_err(wlc->wiphy, "wl%d: %s: SISO antenna but !SISO "
+			  "request\n", WLCWLUNIT(wlc), __func__);
 		bcmerror = -BCME_RANGE;
 		goto done;
 	}
@@ -7996,8 +8035,7 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 	}
 
 	return rspec;
- done:
-	WL_ERROR("Hoark\n");
+done:
 	return rate;
 }
 
@@ -8011,7 +8049,8 @@ wlc_duty_cycle_set(struct wlc_info *wlc, int duty_cycle, bool isOFDM,
 	    isOFDM ? M_TX_IDLE_BUSY_RATIO_X_16_OFDM :
 	    M_TX_IDLE_BUSY_RATIO_X_16_CCK;
 	if (duty_cycle > 100 || duty_cycle < 0) {
-		WL_ERROR("wl%d:  duty cycle value off limit\n", wlc->pub->unit);
+		wiphy_err(wlc->wiphy, "wl%d:  duty cycle value off limit\n",
+			  wlc->pub->unit);
 		return -BCME_RANGE;
 	}
 	if (duty_cycle)
-- 
1.7.4.1


