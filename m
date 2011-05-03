Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2357 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 15/61] staging: brcm80211: removed ASSERTs from
 wlc_main.c
Date: Tue, 3 May 2011 11:35:15 +0200
Message-ID: <1304415361-7813-16-git-send-email-arend@broadcom.com> (sfid-20110503_113642_627888_793CC240)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Driver contains far too many ASSERTs. Functions that were only used
from within removed ASSERTs have also been deleted, such as
wlc_bmac_taclear() in wlc_bmac.c.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |    6 -
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.h |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_main.c |  318 +------------------------
 drivers/staging/brcm80211/brcmsmac/wlc_main.h |    3 -
 4 files changed, 12 insertions(+), 316 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 558f71d..e2dadf0 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -3731,12 +3731,6 @@ void wlc_bmac_pllreq(struct wlc_hw_info *wlc_hw, bool set, mbool req_bit)
 	return;
 }
 
-/* this will be true for all ai chips */
-bool wlc_bmac_taclear(struct wlc_hw_info *wlc_hw, bool ta_ok)
-{
-	return true;
-}
-
 u16 wlc_bmac_rate_shm_offset(struct wlc_hw_info *wlc_hw, u8 rate)
 {
 	u16 table_ptr;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h
index 9c2c658..29785fe 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.h
@@ -176,7 +176,6 @@ extern void wlc_bmac_fifoerrors(struct wlc_hw_info *wlc_hw);
 extern void wlc_bmac_bw_set(struct wlc_hw_info *wlc_hw, u16 bw);
 extern void wlc_bmac_pllreq(struct wlc_hw_info *wlc_hw, bool set,
 			    mbool req_bit);
-extern bool wlc_bmac_taclear(struct wlc_hw_info *wlc_hw, bool ta_ok);
 extern void wlc_bmac_hw_up(struct wlc_hw_info *wlc_hw);
 extern u16 wlc_bmac_rate_shm_offset(struct wlc_hw_info *wlc_hw, u8 rate);
 extern void wlc_bmac_antsel_set(struct wlc_hw_info *wlc_hw, u32 antsel_avail);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index aa0a23c..af51f16 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -419,11 +419,6 @@ static chanspec_t wlc_init_chanspec(struct wlc_info *wlc)
 	    1 | WL_CHANSPEC_BW_20 | WL_CHANSPEC_CTL_SB_NONE |
 	    WL_CHANSPEC_BAND_2G;
 
-	/* make sure the channel is on the supported band if we are band-restricted */
-	if (wlc->bandlocked || NBANDS(wlc) == 1) {
-		ASSERT(CHSPEC_WLCBANDUNIT(chanspec) == wlc->band->bandunit);
-	}
-	ASSERT(wlc_valid_chanspec_db(wlc->cmi, chanspec));
 	return chanspec;
 }
 
@@ -468,7 +463,6 @@ void wlc_init(struct wlc_info *wlc)
 	wlc_bcn_li_upd(wlc);
 	wlc->bcn_wait_prd =
 	    (u8) (wlc_bmac_read_shm(wlc->hw, M_NOSLPZNATDTIM) >> 10);
-	ASSERT(wlc->bcn_wait_prd > 0);
 
 	/* the world is new again, so is our reported rate */
 	wlc_reprate_init(wlc);
@@ -564,7 +558,6 @@ void wlc_init(struct wlc_info *wlc)
 	if (WLC_WME_RETRY_SHORT_GET(wlc, 0) == 0) {	/* Uninitialized; read from HW */
 		int ac;
 
-		ASSERT(wlc->clk);
 		for (ac = 0; ac < AC_COUNT; ac++) {
 			wlc->wme_retries[ac] =
 			    wlc_read_shm(wlc, M_AC_TXLMT_ADDR(ac));
@@ -658,7 +651,6 @@ bool wlc_ps_check(struct wlc_info *wlc)
 			res = false;
 		}
 	}
-	ASSERT(res);
 	return res;
 }
 
@@ -737,8 +729,6 @@ void wlc_switch_shortslot(struct wlc_info *wlc, bool shortslot)
 	int idx;
 	struct wlc_bsscfg *cfg;
 
-	ASSERT(wlc->band->gmode);
-
 	/* use the override if it is set */
 	if (wlc->shortslot_override != WLC_SHORTSLOT_AUTO)
 		shortslot = (wlc->shortslot_override == WLC_SHORTSLOT_ON);
@@ -835,7 +825,6 @@ void wlc_set_chanspec(struct wlc_info *wlc, chanspec_t chanspec)
 	if (!wlc_valid_chanspec_db(wlc->cmi, chanspec)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: Bad channel %d\n",
 			  wlc->pub->unit, __func__, CHSPEC_CHANNEL(chanspec));
-		ASSERT(wlc_valid_chanspec_db(wlc->cmi, chanspec));
 		return;
 	}
 
@@ -860,8 +849,6 @@ void wlc_set_chanspec(struct wlc_info *wlc, chanspec_t chanspec)
 		}
 	}
 
-	ASSERT(N_ENAB(wlc->pub) || !CHSPEC_IS40(chanspec));
-
 	/* sync up phy/radio chanspec */
 	wlc_set_phy_chanspec(wlc, chanspec);
 
@@ -1187,7 +1174,6 @@ void wlc_protection_upd(struct wlc_info *wlc, uint idx, int val)
 		break;
 
 	default:
-		ASSERT(0);
 		break;
 	}
 
@@ -1266,8 +1252,6 @@ static void wlc_bandinit_ordered(struct wlc_info *wlc, chanspec_t chanspec)
 	 * figure out the right band to park on
 	 */
 	if (wlc->bandlocked || NBANDS(wlc) == 1) {
-		ASSERT(CHSPEC_WLCBANDUNIT(chanspec) == wlc->band->bandunit);
-
 		parkband = wlc->band->bandunit;	/* updated in wlc_bandlock() */
 		band_order[0] = band_order[1] = parkband;
 	} else {
@@ -1323,10 +1307,6 @@ static void WLBANDINITFN(wlc_setband) (struct wlc_info *wlc, uint bandunit)
 	int idx;
 	struct wlc_bsscfg *cfg;
 
-	ASSERT(NBANDS(wlc) > 1);
-	ASSERT(!wlc->bandlocked);
-	ASSERT(bandunit != wlc->band->bandunit || wlc->bandinit_pending);
-
 	wlc->band = wlc->bandstate[bandunit];
 
 	if (!wlc->pub->up)
@@ -1374,8 +1354,6 @@ void wlc_wme_setparams(struct wlc_info *wlc, u16 aci,
 	shm_acparams_t acp_shm;
 	u16 *shm_entry;
 
-	ASSERT(wlc);
-
 	/* Only apply params if the core is out of reset and has clocks */
 	if (!wlc->clk) {
 		wiphy_err(wlc->wiphy, "wl%d: %s : no-clock\n", wlc->pub->unit,
@@ -1387,9 +1365,6 @@ void wlc_wme_setparams(struct wlc_info *wlc, u16 aci,
 
 	do {
 		memset((char *)&acp_shm, 0, sizeof(shm_acparams_t));
-		/* find out which ac this set of params applies to */
-		ASSERT(aci < AC_COUNT);
-
 		/* fill in shm ac params struct */
 		acp_shm.txop = le16_to_cpu(params->txop);
 		/* convert from units of 32us to us for ucode */
@@ -1448,8 +1423,6 @@ void wlc_edcf_setparams(struct wlc_info *wlc, bool suspend)
 	struct ieee80211_tx_queue_params txq_pars;
 	struct ieee80211_tx_queue_params *params = &txq_pars;
 
-	ASSERT(wlc);
-
 	/*
 	 * AP uses AC params from wme_param_ie_ap.
 	 * AP advertises AC params from wme_param_ie.
@@ -1461,7 +1434,6 @@ void wlc_edcf_setparams(struct wlc_info *wlc, bool suspend)
 	for (i_ac = 0; i_ac < AC_COUNT; i_ac++, edcf_acp++) {
 		/* find out which ac this set of params applies to */
 		aci = (edcf_acp->ACI & EDCF_ACI_MASK) >> EDCF_ACI_SHIFT;
-		ASSERT(aci < AC_COUNT);
 		/* set the admission control policy for this AC */
 		if (edcf_acp->ACI & EDCF_ACM_MASK) {
 			wlc->wme_admctl |= 1 << aci;
@@ -2069,7 +2041,6 @@ static void wlc_detach_module(struct wlc_info *wlc)
  */
 uint wlc_detach(struct wlc_info *wlc)
 {
-	uint i;
 	uint callbacks = 0;
 
 	if (wlc == NULL)
@@ -2077,8 +2048,6 @@ uint wlc_detach(struct wlc_info *wlc)
 
 	WL_TRACE("wl%d: %s\n", wlc->pub->unit, __func__);
 
-	ASSERT(!wlc->pub->up);
-
 	callbacks += wlc_bmac_detach(wlc);
 
 	/* delete software timers */
@@ -2117,13 +2086,6 @@ uint wlc_detach(struct wlc_info *wlc)
 	while (wlc->tx_queues != NULL)
 		wlc_txq_free(wlc, wlc->tx_queues);
 
-	/*
-	 * consistency check: wlc_module_register/wlc_module_unregister calls
-	 * should match therefore nothing should be left here.
-	 */
-	for (i = 0; i < WLC_MAXMODULES; i++)
-		ASSERT(wlc->modulecb[i].name[0] == '\0');
-
 	wlc_detach_mfree(wlc);
 	return callbacks;
 }
@@ -2235,8 +2197,6 @@ static void wlc_radio_upd(struct wlc_info *wlc)
 /* maintain LED behavior in down state */
 static void wlc_down_led_upd(struct wlc_info *wlc)
 {
-	ASSERT(!wlc->pub->up);
-
 	/* maintain LEDs while in down state, turn on sbclk if not available yet */
 	/* turn on sbclk if necessary */
 	if (!AP_ENAB(wlc->pub)) {
@@ -2294,8 +2254,6 @@ static void wlc_radio_timer(void *arg)
 	if (wlc->mpc_offcnt < WLC_MPC_MAX_DELAYCNT)
 		wlc->mpc_offcnt++;
 
-	/* validate all the reasons driver could be down and running this radio_timer */
-	ASSERT(wlc->pub->radio_disabled || wlc->down_override);
 	wlc_radio_hwdisable_upd(wlc);
 	wlc_radio_upd(wlc);
 }
@@ -2317,9 +2275,6 @@ bool wlc_radio_monitor_stop(struct wlc_info *wlc)
 	if (!wlc->radio_monitor)
 		return true;
 
-	ASSERT((wlc->pub->wlfeatureflag & WL_SWFL_NOHWRADIO) !=
-	       WL_SWFL_NOHWRADIO);
-
 	wlc->radio_monitor = false;
 	wlc_pllreq(wlc, false, WLC_PLLREQ_RADIO_MON);
 	return wl_del_timer(wlc->wl, wlc->radio_timer);
@@ -2342,31 +2297,6 @@ void wlc_out(struct wlc_info *wlc)
 	wlc->pub->hw_up = false;
 }
 
-#if defined(BCMDBG)
-/* Verify the sanity of wlc->tx_prec_map. This can be done only by making sure that
- * if there is no packet pending for the FIFO, then the corresponding prec bits should be set
- * in prec_map. Of course, ignore this rule when block_datafifo is set
- */
-static bool wlc_tx_prec_map_verify(struct wlc_info *wlc)
-{
-	/* For non-WME, both fifos have overlapping prec_map. So it's an error only if both
-	 * fail the check.
-	 */
-	if (!EDCF_ENAB(wlc->pub)) {
-		if (!(WLC_TX_FIFO_CHECK(wlc, TX_DATA_FIFO) ||
-		      WLC_TX_FIFO_CHECK(wlc, TX_CTL_FIFO)))
-			return false;
-		else
-			return true;
-	}
-
-	return WLC_TX_FIFO_CHECK(wlc, TX_AC_BK_FIFO)
-		&& WLC_TX_FIFO_CHECK(wlc, TX_AC_BE_FIFO)
-		&& WLC_TX_FIFO_CHECK(wlc, TX_AC_VI_FIFO)
-		&& WLC_TX_FIFO_CHECK(wlc, TX_AC_VO_FIFO);
-}
-#endif				/* BCMDBG */
-
 static void wlc_watchdog_by_timer(void *arg)
 {
 	struct wlc_info *wlc = (struct wlc_info *) arg;
@@ -2417,9 +2347,6 @@ static void wlc_watchdog(void *arg)
 	/* radio sync: sw/hw/mpc --> radio_disable/radio_enable */
 	wlc_radio_hwdisable_upd(wlc);
 	wlc_radio_upd(wlc);
-	/* if ismpc, driver should be in down state if up/down is allowed */
-	if (wlc->mpc && wlc_ismpc(wlc))
-		ASSERT(!wlc->pub->up);
 	/* if radio is disable, driver may be down, quit here */
 	if (wlc->pub->radio_disabled)
 		return;
@@ -2452,13 +2379,6 @@ static void wlc_watchdog(void *arg)
 		wlc->tempsense_lasttime = wlc->pub->now;
 		wlc_tempsense_upd(wlc);
 	}
-	/* BMAC_NOTE: for HIGH_ONLY driver, this seems being called after RPC bus failed */
-	ASSERT(wlc_bmac_taclear(wlc->hw, true));
-
-	/* Verify that tx_prec_map and fifos are in sync to avoid lock ups */
-	ASSERT(wlc_tx_prec_map_verify(wlc));
-
-	ASSERT(wlc_ps_check(wlc));
 }
 
 /* make interface operational */
@@ -2515,8 +2435,7 @@ int wlc_up(struct wlc_info *wlc)
 						   wlc->pub->unit, idx);
 				}
 			}
-		} else
-			ASSERT(!status);
+		}
 	}
 
 	if (wlc->pub->radio_disabled) {
@@ -2560,7 +2479,6 @@ int wlc_up(struct wlc_info *wlc)
 	wlc_wme_retries_write(wlc);
 
 	/* start one second watchdog timer */
-	ASSERT(!wlc->WDarmed);
 	wl_add_timer(wlc->wl, wlc->wdtimer, TIMER_INTERVAL_WATCHDOG, true);
 	wlc->WDarmed = true;
 
@@ -2646,9 +2564,6 @@ uint wlc_down(struct wlc_info *wlc)
 	/* cancel all other timers */
 	callbacks += wlc_down_del_timer(wlc);
 
-	/* interrupt must have been blocked */
-	ASSERT((wlc->macintmask == 0) || !wlc->pub->up);
-
 	wlc->pub->up = false;
 
 	wlc_phy_mute_upd(wlc->band->pi, false, PHY_MUTE_ALL);
@@ -2659,7 +2574,6 @@ uint wlc_down(struct wlc_info *wlc)
 	/* flush tx queues */
 	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next) {
 		pktq_flush(&qi->q, true, NULL, 0);
-		ASSERT(pktq_empty(&qi->q));
 	}
 
 	callbacks += wlc_bmac_down_finish(wlc->hw);
@@ -2667,13 +2581,6 @@ uint wlc_down(struct wlc_info *wlc)
 	/* wlc_bmac_down_finish has done wlc_coredisable(). so clk is off */
 	wlc->clk = false;
 
-#ifdef BCMDBG
-	/* Since all the packets should have been freed,
-	 * all callbacks should have been called
-	 */
-	for (i = 1; i <= wlc->pub->tunables->maxpktcb; i++)
-		ASSERT(wlc->pkt_callback[i].fn == NULL);
-#endif
 	wlc->going_down = false;
 	return callbacks;
 }
@@ -2860,7 +2767,6 @@ int wlc_set_nmode(struct wlc_info *wlc, s32 nmode)
 	int err;
 
 	err = wlc_nmode_validate(wlc, nmode);
-	ASSERT(err == 0);
 	if (err)
 		return err;
 
@@ -2889,7 +2795,6 @@ int wlc_set_nmode(struct wlc_info *wlc, s32 nmode)
 			nmode = WL_11N_2x2;
 	case WL_11N_2x2:
 	case WL_11N_3x3:
-		ASSERT(WLC_PHY_11N_CAP(wlc->band));
 		/* force GMODE_AUTO if NMODE is ON */
 		wlc_set_gmode(wlc, GMODE_AUTO, true);
 		if (nmode == WL_11N_3x3)
@@ -2906,7 +2811,6 @@ int wlc_set_nmode(struct wlc_info *wlc, s32 nmode)
 		break;
 
 	default:
-		ASSERT(0);
 		break;
 	}
 
@@ -3023,8 +2927,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		return -BCME_ERROR;
 	}
 
-	ASSERT(!(wlc->pub->hw_off && wlc->pub->up));
-
 	/* default argument is generic integer */
 	pval = arg ? (int *)arg:NULL;
 
@@ -3080,7 +2982,10 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	case WLC_GET_CHANNEL:{
 			channel_info_t *ci = (channel_info_t *) arg;
 
-			ASSERT(len > (int)sizeof(ci));
+			if (len <= (int)sizeof(ci)) {
+				bcmerror = BCME_BUFTOOSHORT;
+				goto done;
+			}
 
 			ci->hw_channel =
 			    CHSPEC_CHANNEL(WLC_BAND_PI_RADIO_CHANSPEC);
@@ -4129,12 +4034,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		}
 
 	}
-	/* BMAC_NOTE: for HIGH_ONLY driver, this seems being called after RPC bus failed */
-	/* In hw_off condition, IOCTLs that reach here are deemed safe but taclear would
-	 * certainly result in getting -1 for register reads. So skip ta_clear altogether
-	 */
-	if (!(wlc->pub->hw_off))
-		ASSERT(wlc_bmac_taclear(wlc->hw, ta_ok) || !ta_ok);
 
 	return bcmerror;
 }
@@ -4183,8 +4082,6 @@ static const bcm_iovar_t *wlc_iovar_lookup(const bcm_iovar_t *table,
 	else
 		lookup_name = name;
 
-	ASSERT(table != NULL);
-
 	for (vi = table; vi->name; vi++) {
 		if (!strcmp(vi->name, lookup_name))
 			return vi;
@@ -4235,9 +4132,6 @@ int wlc_module_register(struct wlc_pub *pub, const bcm_iovar_t *iovars,
 	struct wlc_info *wlc = (struct wlc_info *) pub->wlc;
 	int i;
 
-	ASSERT(name != NULL);
-	ASSERT(i_fn != NULL || w_fn != NULL || d_fn != NULL);
-
 	/* find an empty entry and just add, no duplication check! */
 	for (i = 0; i < WLC_MAXMODULES; i++) {
 		if (wlc->modulecb[i].name[0] == '\0') {
@@ -4252,8 +4146,6 @@ int wlc_module_register(struct wlc_pub *pub, const bcm_iovar_t *iovars,
 		}
 	}
 
-	/* it is time to increase the capacity */
-	ASSERT(i < WLC_MAXMODULES);
 	return -BCME_NORESOURCE;
 }
 
@@ -4266,8 +4158,6 @@ int wlc_module_unregister(struct wlc_pub *pub, const char *name, void *hdl)
 	if (wlc == NULL)
 		return -BCME_NOTFOUND;
 
-	ASSERT(name != NULL);
-
 	for (i = 0; i < WLC_MAXMODULES; i++) {
 		if (!strcmp(wlc->modulecb[i].name, name) &&
 		    (wlc->modulecb[i].hdl == hdl)) {
@@ -4313,23 +4203,11 @@ wlc_iovar_op(struct wlc_info *wlc, const char *name,
 	u32 actionid;
 	int i;
 
-	ASSERT(name != NULL);
-
-	ASSERT(len >= 0);
-
-	/* Get MUST have return space */
-	ASSERT(set || (arg && len));
-
-	ASSERT(!(wlc->pub->hw_off && wlc->pub->up));
-
-	/* Set does NOT take qualifiers */
-	ASSERT(!set || (!params && !p_len));
-
 	if (!set && (len == sizeof(int)) &&
 	    !(IS_ALIGNED((unsigned long)(arg), (uint) sizeof(int)))) {
 		wiphy_err(wlc->wiphy, "wl%d: %s unaligned get ptr for %s\n",
 			  wlc->pub->unit, __func__, name);
-		ASSERT(0);
+		return -BCME_UNSUPPORTED;
 	}
 
 	/* find the given iovar name */
@@ -4342,8 +4220,7 @@ wlc_iovar_op(struct wlc_info *wlc, const char *name,
 	}
 	/* iovar name not found */
 	if (i >= WLC_MAXMODULES) {
-		err = -BCME_UNSUPPORTED;
-		goto exit;
+		return -BCME_UNSUPPORTED;
 	}
 
 	/* set up 'params' pointer in case this is a set command so that
@@ -4368,8 +4245,6 @@ wlc_iovar_op(struct wlc_info *wlc, const char *name,
 	err = wlc->modulecb[i].iovar_fn(wlc->modulecb[i].hdl, vi, actionid,
 					name, params, p_len, arg, len, val_size,
 					wlcif);
-
- exit:
 	return err;
 }
 
@@ -4976,8 +4851,6 @@ int wlc_format_ssid(char *buf, const unsigned char ssid[], uint ssid_len)
 		}
 	}
 	*p = '\0';
-	ASSERT(p < endp);
-
 	return (int)(p - buf);
 }
 #endif				/* defined(BCMDBG) */
@@ -5016,7 +4889,6 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 		eprec = prec;
 	else if (pktq_full(q)) {
 		p = pktq_peek_tail(q, &eprec);
-		ASSERT(p != NULL);
 		if (eprec > prec) {
 			wiphy_err(wlc->wiphy, "%s: Failing: eprec %d > prec %d"
 				  "\n", __func__, eprec, prec);
@@ -5028,9 +4900,6 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 	if (eprec >= 0) {
 		bool discard_oldest;
 
-		/* Detect queueing to unconfigured precedence */
-		ASSERT(!pktq_pempty(q, eprec));
-
 		discard_oldest = AC_BITMAP_TST(wlc->wme_dp, eprec);
 
 		/* Refuse newer packet unless configured to discard oldest */
@@ -5043,8 +4912,6 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 		/* Evict packet according to discard policy */
 		p = discard_oldest ? pktq_pdeq(q, eprec) : pktq_pdeq_tail(q,
 									  eprec);
-		ASSERT(p != NULL);
-
 		/* Increment wme stats */
 		if (WME_ENAB(wlc->pub)) {
 			WLCNTINCR(wlc->pub->_wme_cnt->
@@ -5062,7 +4929,6 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 		p = pktq_penq_head(q, prec, pkt);
 	else
 		p = pktq_penq(q, prec, pkt);
-	ASSERT(p != NULL);
 
 	return true;
 }
@@ -5077,8 +4943,6 @@ void BCMFASTPATH wlc_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 
 	prio = sdu->priority;
 
-	ASSERT(pktq_max(q) >= wlc->pub->tunables->datahiwat);
-
 	if (!wlc_prec_enq(wlc, q, sdu, prec)) {
 		if (!EDCF_ENAB(wlc->pub)
 		    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL))
@@ -5120,18 +4984,10 @@ wlc_sendpkt_mac80211(struct wlc_info *wlc, struct sk_buff *sdu,
 	struct scb *scb = &global_scb;
 	struct ieee80211_hdr *d11_header = (struct ieee80211_hdr *)(sdu->data);
 
-	ASSERT(sdu);
-
 	/* 802.11 standard requires management traffic to go at highest priority */
 	prio = ieee80211_is_data(d11_header->frame_control) ? sdu->priority :
 		MAXPRIO;
 	fifo = prio2fifo[prio];
-
-	ASSERT((uint) skb_headroom(sdu) >= TXOFF);
-	ASSERT(!(sdu->next));
-	ASSERT(!(sdu->prev));
-	ASSERT(fifo < NFIFO);
-
 	pkt = sdu;
 	if (unlikely
 	    (wlc_d11hdrs_mac80211(wlc, hw, pkt, scb, 0, 1, fifo, 0, NULL, 0)))
@@ -5240,7 +5096,6 @@ wlc_txfifo(struct wlc_info *wlc, uint fifo, struct sk_buff *p, bool commit,
 	u16 frameid = INVALIDFID;
 	d11txh_t *txh;
 
-	ASSERT(fifo < NFIFO);
 	txh = (d11txh_t *) (p->data);
 
 	/* When a BC/MC frame is being committed to the BCMC fifo via DMA (NOT PIO), update
@@ -5282,7 +5137,6 @@ wlc_compute_airtime(struct wlc_info *wlc, ratespec_t rspec, uint length)
 
 	if (IS_MCS(rspec)) {
 		/* not supported yet */
-		ASSERT(0);
 	} else if (IS_OFDM(rspec)) {
 		/* nsyms = Ceiling(Nbits / (Nbits/sym))
 		 *
@@ -5312,7 +5166,6 @@ wlc_compute_airtime(struct wlc_info *wlc, ratespec_t rspec, uint length)
 			wiphy_err(wlc->wiphy, "wl%d: wlc_compute_airtime: "
 				  "unsupported rspec 0x%x\n",
 				  wlc->pub->unit, rspec);
-			ASSERT((const char *)"Bad phy_rate" == NULL);
 			break;
 		}
 	}
@@ -5337,7 +5190,6 @@ wlc_compute_plcp(struct wlc_info *wlc, ratespec_t rspec, uint length, u8 *plcp)
 static void wlc_compute_mimo_plcp(ratespec_t rspec, uint length, u8 *plcp)
 {
 	u8 mcs = (u8) (rspec & RSPEC_RATE_MASK);
-	ASSERT(IS_MCS(rspec));
 	plcp[0] = mcs;
 	if (RSPEC_IS40MHZ(rspec) || (mcs == 32))
 		plcp[0] |= MIMO_PLCP_40MHZ;
@@ -5356,12 +5208,8 @@ wlc_compute_ofdm_plcp(ratespec_t rspec, u32 length, u8 *plcp)
 	u32 tmp = 0;
 	int rate = RSPEC2RATE(rspec);
 
-	ASSERT(IS_OFDM(rspec));
-
 	/* encode rate per 802.11a-1999 sec 17.3.4.1, with lsb transmitted first */
 	rate_signal = rate_info[rate] & WLC_RATE_MASK;
-	ASSERT(rate_signal != 0);
-
 	memset(plcp, 0, D11_PHY_HDR_LEN);
 	D11A_PHY_HDR_SRATE((ofdm_phy_hdr_t *) plcp, rate_signal);
 
@@ -5432,8 +5280,6 @@ static void wlc_compute_cck_plcp(struct wlc_info *wlc, ratespec_t rspec,
 {
 	int rate = RSPEC2RATE(rspec);
 
-	ASSERT(IS_CCK(rspec));
-
 	wlc_cck_plcp_set(wlc, rate, length, plcp);
 }
 
@@ -5513,32 +5359,6 @@ wlc_compute_rtscts_dur(struct wlc_info *wlc, bool cts_only, ratespec_t rts_rate,
 	return dur;
 }
 
-static bool wlc_phy_rspec_check(struct wlc_info *wlc, u16 bw, ratespec_t rspec)
-{
-	if (IS_MCS(rspec)) {
-		uint mcs = rspec & RSPEC_RATE_MASK;
-
-		if (mcs < 8) {
-			ASSERT(RSPEC_STF(rspec) < PHY_TXC1_MODE_SDM);
-		} else if ((mcs >= 8) && (mcs <= 23)) {
-			ASSERT(RSPEC_STF(rspec) == PHY_TXC1_MODE_SDM);
-		} else if (mcs == 32) {
-			ASSERT(RSPEC_STF(rspec) < PHY_TXC1_MODE_SDM);
-			ASSERT(bw == PHY_TXC1_BW_40MHZ_DUP);
-		}
-	} else if (IS_OFDM(rspec)) {
-		ASSERT(RSPEC_STF(rspec) < PHY_TXC1_MODE_STBC);
-	} else {
-		ASSERT(IS_CCK(rspec));
-
-		ASSERT((bw == PHY_TXC1_BW_20MHZ)
-		       || (bw == PHY_TXC1_BW_20MHZ_UP));
-		ASSERT(RSPEC_STF(rspec) == PHY_TXC1_MODE_SISO);
-	}
-
-	return true;
-}
-
 u16 BCMFASTPATH wlc_phytxctl1_calc(struct wlc_info *wlc, ratespec_t rspec)
 {
 	u16 phyctl1 = 0;
@@ -5554,8 +5374,6 @@ u16 BCMFASTPATH wlc_phytxctl1_calc(struct wlc_info *wlc, ratespec_t rspec)
 				  "not supported yet, set to 20L\n", bw);
 			bw = PHY_TXC1_BW_20MHZ;
 		}
-
-		wlc_phy_rspec_check(wlc, bw, rspec);
 	}
 
 	if (IS_MCS(rspec)) {
@@ -5578,7 +5396,6 @@ u16 BCMFASTPATH wlc_phytxctl1_calc(struct wlc_info *wlc, ratespec_t rspec)
 		if (phycfg == -1) {
 			wiphy_err(wlc->wiphy, "wlc_phytxctl1_calc: wrong "
 				  "legacy OFDM/CCK rate\n");
-			ASSERT(0);
 			phycfg = 0;
 		}
 		/* set the upper byte of phyctl1 */
@@ -5586,14 +5403,6 @@ u16 BCMFASTPATH wlc_phytxctl1_calc(struct wlc_info *wlc, ratespec_t rspec)
 		    (bw | (phycfg << 8) |
 		     (RSPEC_STF(rspec) << PHY_TXC1_MODE_SHIFT));
 	}
-
-#ifdef BCMDBG
-	/* phy clock must support 40Mhz if tx descriptor uses it */
-	if ((phyctl1 & PHY_TXC1_BW_MASK) >= PHY_TXC1_BW_40MHZ) {
-		ASSERT(CHSPEC_WLC_BW(wlc->chanspec) == WLC_40_MHZ);
-		ASSERT(wlc->chanspec == wlc_phy_chanspec_get(wlc->band->pi));
-	}
-#endif				/* BCMDBG */
 	return phyctl1;
 }
 
@@ -5692,8 +5501,6 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	u16 mimo_txbw;
 	u8 mimo_preamble_type;
 
-	ASSERT(queue < NFIFO);
-
 	/* locate 802.11 MAC header */
 	h = (struct ieee80211_hdr *)(p->data);
 	qos = ieee80211_is_data_qos(h->frame_control);
@@ -5713,7 +5520,6 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 
 	/* Get tx_info */
 	tx_info = IEEE80211_SKB_CB(p);
-	ASSERT(tx_info);
 
 	/* add PLCP */
 	plcp = skb_push(p, D11_PHY_HDR_LEN);
@@ -5725,7 +5531,6 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	/* setup frameid */
 	if (tx_info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
 		/* non-AP STA should never use BCMC queue */
-		ASSERT(queue != TX_BCMC_FIFO);
 		if (queue == TX_BCMC_FIFO) {
 			wiphy_err(wlc->wiphy, "wl%d: %s: ASSERT queue == "
 				  "TX_BCMC!\n", WLCWLUNIT(wlc), __func__);
@@ -5751,13 +5556,9 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	if (SCB_PS(scb) || ieee80211_is_beacon(h->frame_control))
 		mcl |= TXC_IGNOREPMQ;
 
-	ASSERT(hw->max_rates <= IEEE80211_TX_MAX_RATES);
-	ASSERT(hw->max_rates == 2);
-
 	txrate[0] = tx_info->control.rates;
 	txrate[1] = txrate[0] + 1;
 
-	ASSERT(txrate[0]->idx >= 0);
 	/* if rate control algorithm didn't give us a fallback rate, use the primary rate */
 	if (txrate[1]->idx < 0) {
 		txrate[1] = txrate[0];
@@ -5767,7 +5568,6 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		is_mcs[k] =
 		    txrate[k]->flags & IEEE80211_TX_RC_MCS ? true : false;
 		if (!is_mcs[k]) {
-			ASSERT(!(tx_info->flags & IEEE80211_TX_CTL_AMPDU));
 			if ((txrate[k]->idx >= 0)
 			    && (txrate[k]->idx <
 				hw->wiphy->bands[tx_info->band]->n_bitrates)) {
@@ -5779,10 +5579,6 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 				    flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE ?
 				    true : false;
 			} else {
-				ASSERT((txrate[k]->idx >= 0) &&
-				       (txrate[k]->idx <
-					hw->wiphy->bands[tx_info->band]->
-					n_bitrates));
 				rate_val[k] = WLC_RATE_1M;
 			}
 		} else {
@@ -5805,7 +5601,6 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 
 		/* (1) RATE: determine and validate primary rate and fallback rates */
 		if (!RSPEC_ACTIVE(rspec[k])) {
-			ASSERT(RSPEC_ACTIVE(rspec[k]));
 			rspec[k] = WLC_RATE_1M;
 		} else {
 			if (!is_multicast_ether_addr(h->addr1)) {
@@ -5833,7 +5628,6 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 				    && WLC_STF_SS_STBC_TX(wlc, scb)) {
 					u8 stc;
 
-					ASSERT(WLC_STBC_CAP_PHY(wlc));
 					stc = 1;	/* Nss for single stream is always 1 */
 					rspec[k] |=
 					    (PHY_TXC1_MODE_STBC <<
@@ -5866,7 +5660,6 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 					if (wlc->ofdm_40txbw != AUTO)
 						mimo_txbw = wlc->ofdm_40txbw;
 				} else {
-					ASSERT(IS_CCK(rspec[k]));
 					if (wlc->cck_40txbw != AUTO)
 						mimo_txbw = wlc->cck_40txbw;
 				}
@@ -5908,7 +5701,6 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 				wiphy_err(wlc->wiphy, "wl%d: %s: IEEE80211_TX_"
 					  "RC_MCS != IS_MCS(rspec)\n",
 					  WLCWLUNIT(wlc), __func__);
-				ASSERT(0 && "Rate mismatch");
 			}
 
 			if (IS_MCS(rspec[k])) {
@@ -5922,22 +5714,15 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 				}
 			}
 
-			/* mimo bw field MUST now be valid in the rspec (it affects duration calculations) */
-			ASSERT(VALID_RATE_DBG(wlc, rspec[0]));
-
 			/* should be better conditionalized */
 			if (!IS_MCS(rspec[0])
 			    && (tx_info->control.rates[0].
 				flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE))
 				preamble_type[k] = WLC_SHORT_PREAMBLE;
-
-			ASSERT(!IS_MCS(rspec[0])
-			       || WLC_IS_MIMO_PREAMBLE(preamble_type[k]));
 		}
 	} else {
 		for (k = 0; k < hw->max_rates; k++) {
 			/* Set ctrlchbw as 20Mhz */
-			ASSERT(!IS_MCS(rspec[k]));
 			rspec[k] &= ~RSPEC_BW_MASK;
 			rspec[k] |= (PHY_TXC1_BW_20MHZ << RSPEC_BW_SHIFT);
 
@@ -6029,8 +5814,6 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	/* Set fallback rate preamble type */
 	if ((preamble_type[1] == WLC_SHORT_PREAMBLE) ||
 	    (preamble_type[1] == WLC_GF_PREAMBLE)) {
-		ASSERT((preamble_type[1] == WLC_GF_PREAMBLE) ||
-		       (!IS_MCS(rspec[1])));
 		if (RSPEC2RATE(rspec[1]) != WLC_RATE_1M)
 			mch |= TXC_PREAMBLE_DATA_FB_SHORT;
 	}
@@ -6095,7 +5878,6 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		}
 
 		/* RTS PLCP header */
-		ASSERT(IS_ALIGNED((unsigned long)txh->RTSPhyHeader, sizeof(u16)));
 		rts_plcp = txh->RTSPhyHeader;
 		if (use_cts)
 			rts_phylen = DOT11_CTS_LEN + FCS_LEN;
@@ -6178,8 +5960,6 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	phyctl = FRAMETYPE(rspec[0], wlc->mimoft);
 	if ((preamble_type[0] == WLC_SHORT_PREAMBLE) ||
 	    (preamble_type[0] == WLC_GF_PREAMBLE)) {
-		ASSERT((preamble_type[0] == WLC_GF_PREAMBLE)
-		       || !IS_MCS(rspec[0]));
 		if (RSPEC2RATE(rspec[0]) != WLC_RATE_1M)
 			phyctl |= PHY_TXC_SHORT_HDR;
 		wlc->pub->_cnt->txprshort++;
@@ -6223,21 +6003,10 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		}
 	}
 
-	if (IS_MCS(rspec[0]))
-		ASSERT(IS_MCS(rspec[1]));
-
-	ASSERT(!IS_MCS(rspec[0]) ||
-	       ((preamble_type[0] == WLC_MM_PREAMBLE) == (txh->MModeLen != 0)));
-	ASSERT(!IS_MCS(rspec[1]) ||
-	       ((preamble_type[1] == WLC_MM_PREAMBLE) ==
-		(txh->MModeFbrLen != 0)));
-
 	ac = skb_get_queue_mapping(p);
 	if (SCB_WME(scb) && qos && wlc->edcf_txop[ac]) {
 		uint frag_dur, dur, dur_fallback;
 
-		ASSERT(!is_multicast_ether_addr(h->addr1));
-
 		/* WME: Update TXOP threshold */
 		if ((!(tx_info->flags & IEEE80211_TX_CTL_AMPDU)) && (frag == 0)) {
 			frag_dur =
@@ -6428,11 +6197,6 @@ void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus)
 	}
 #endif				/* BCMDBG */
 
-	if (macintstatus & MI_PRQ) {
-		/* Process probe request FIFO */
-		ASSERT(0 && "PRQ Interrupt in non-MBSS");
-	}
-
 	/* TBTT indication */
 	/* ucode only gives either TBTT or DTIM_TBTT, not both */
 	if (macintstatus & (MI_TBTT | MI_DTIM_TBTT))
@@ -6480,8 +6244,6 @@ void wlc_high_dpc(struct wlc_info *wlc, u32 macintstatus)
 	/* send any enq'd tx packets. Just makes sure to jump start tx */
 	if (!pktq_empty(&wlc->active_queue->q))
 		wlc_send_q(wlc, wlc->active_queue);
-
-	ASSERT(wlc_ps_check(wlc));
 }
 
 static void wlc_war16165(struct wlc_info *wlc, bool tx)
@@ -6535,7 +6297,6 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 	}
 
 	queue = txs->frameid & TXFID_QUEUE_MASK;
-	ASSERT(queue < NFIFO);
 	if (queue >= NFIFO) {
 		p = NULL;
 		goto fatal;
@@ -6559,10 +6320,8 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 		wlc_print_txstatus(txs);
 	}
 
-	ASSERT(txs->frameid == cpu_to_le16(txh->TxFrameID));
 	if (txs->frameid != cpu_to_le16(txh->TxFrameID))
 		goto fatal;
-
 	tx_info = IEEE80211_SKB_CB(p);
 	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
 
@@ -6578,7 +6337,6 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 	}
 
 	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-		ASSERT((mcl & TXC_AMPDU_MASK) != TXC_AMPDU_NONE);
 		wlc_ampdu_dotxstatus(wlc->ampdu, scb, p, txs);
 		return false;
 	}
@@ -6655,7 +6413,6 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 	return false;
 
  fatal:
-	ASSERT(0);
 	if (p)
 		pkt_buf_free_skb(p);
 
@@ -6672,7 +6429,6 @@ wlc_txfifo_complete(struct wlc_info *wlc, uint fifo, s8 txpktpend)
 
 	/* There is more room; mark precedences related to this FIFO sendable */
 	WLC_TX_FIFO_ENAB(wlc, fifo);
-	ASSERT(TXPKTPENDGET(wlc, fifo) >= 0);
 
 	if (!TXPKTPENDTOT(wlc)) {
 		if (wlc->block_datafifo & DATA_BLOCK_TX_SUPR)
@@ -6902,9 +6658,6 @@ wlc_recvctl(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p)
 {
 	int len_mpdu;
 	struct ieee80211_rx_status rx_status;
-#if defined(BCMDBG)
-	struct sk_buff *skb = p;
-#endif				/* BCMDBG */
 
 	memset(&rx_status, 0, sizeof(rx_status));
 	prep_mac80211_status(wlc, rxh, p, &rx_status);
@@ -6914,11 +6667,6 @@ wlc_recvctl(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p)
 	skb_pull(p, D11_PHY_HDR_LEN);
 	__skb_trim(p, len_mpdu);
 
-	ASSERT(!(p->next));
-	ASSERT(!(p->prev));
-
-	ASSERT(IS_ALIGNED((unsigned long)skb->data, 2));
-
 	memcpy(IEEE80211_SKB_RXCB(p), &rx_status, sizeof(rx_status));
 	ieee80211_rx_irqsafe(wlc->pub->ieee_hw, p);
 
@@ -7062,7 +6810,6 @@ wlc_calc_lsig_len(struct wlc_info *wlc, ratespec_t ratespec, uint mac_len)
 		/* MCS_TXS(mcs) returns num tx streams - 1 */
 		int tot_streams = (MCS_TXS(mcs) + 1) + RSPEC_STC(ratespec);
 
-		ASSERT(WLC_PHY_11N_CAP(wlc->band));
 		/* the payload duration calculation matches that of regular ofdm */
 		/* 1000Ndbps = kbps * 4 */
 		kNdps =
@@ -7098,7 +6845,6 @@ wlc_calc_frame_time(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 	uint rate = RSPEC2RATE(ratespec);
 
 	if (rate == 0) {
-		ASSERT(0);
 		wiphy_err(wlc->wiphy, "wl%d: WAR: using rate of 1 mbps\n",
 			  wlc->pub->unit);
 		rate = WLC_RATE_1M;
@@ -7110,8 +6856,6 @@ wlc_calc_frame_time(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 	if (IS_MCS(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
 		int tot_streams = MCS_TXS(mcs) + RSPEC_STC(ratespec);
-		ASSERT(WLC_PHY_11N_CAP(wlc->band));
-		ASSERT(WLC_IS_MIMO_PREAMBLE(preamble_type));
 
 		dur = PREN_PREAMBLE + (tot_streams * PREN_PREAMBLE_EXT);
 		if (preamble_type == WLC_MM_PREAMBLE)
@@ -7175,7 +6919,6 @@ wlc_calc_frame_len(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 	if (IS_MCS(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
 		int tot_streams = MCS_TXS(mcs) + RSPEC_STC(ratespec);
-		ASSERT(WLC_PHY_11N_CAP(wlc->band));
 		dur -= PREN_PREAMBLE + (tot_streams * PREN_PREAMBLE_EXT);
 		/* payload calculation matches that of regular ofdm */
 		if (BAND_2G(wlc->band->bandtype))
@@ -7218,8 +6961,6 @@ wlc_calc_ba_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 	 * or equal to the rate of the immediately previous frame in the FES
 	 */
 	rspec = WLC_BASIC_RATE(wlc, rspec);
-	ASSERT(VALID_RATE_DBG(wlc, rspec));
-
 	/* BA len == 32 == 16(ctl hdr) + 4(ba len) + 8(bitmap) + 4(fcs) */
 	return wlc_calc_frame_time(wlc, rspec, preamble_type,
 				   (DOT11_BA_LEN + DOT11_BA_BITMAP_LEN +
@@ -7237,8 +6978,6 @@ wlc_calc_ack_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 	 * or equal to the rate of the immediately previous frame in the FES
 	 */
 	rspec = WLC_BASIC_RATE(wlc, rspec);
-	ASSERT(VALID_RATE_DBG(wlc, rspec));
-
 	/* ACK frame len == 14 == 2(fc) + 2(dur) + 6(ra) + 4(fcs) */
 	dur =
 	    wlc_calc_frame_time(wlc, rspec, preamble_type,
@@ -7304,7 +7043,6 @@ void wlc_rate_lookup_init(struct wlc_info *wlc, wlc_rateset_t *rateset)
 
 	for (i = 0; i < wlc->band->hw_rateset.count; i++) {
 		rate = wlc->band->hw_rateset.rates[i];
-		ASSERT(rate <= WLC_MAXRATE);
 
 		if (br[rate] != 0) {
 			/* This rate is a basic rate.
@@ -7404,7 +7142,6 @@ void wlc_set_ratetable(struct wlc_info *wlc)
 	uint i;
 
 	rs_dflt = wlc_rateset_get_hwrs(wlc);
-	ASSERT(rs_dflt != NULL);
 
 	wlc_rateset_copy(rs_dflt, &rs);
 	wlc_rateset_mcs_upd(&rs, wlc->stf->txstreams);
@@ -7483,7 +7220,6 @@ static void wlc_update_mimo_band_bwcap(struct wlc_info *wlc, u8 bwcap)
 			else
 				band->mimo_cap_40 = false;
 		} else {
-			ASSERT(band->bandtype == WLC_BAND_2G);
 			if (bwcap == WLC_N_BW_40ALL)
 				band->mimo_cap_40 = true;
 			else
@@ -7507,7 +7243,6 @@ void wlc_mod_prb_rsp_rate_table(struct wlc_info *wlc, uint frame_len)
 	sifs = SIFS(wlc->band);
 
 	rs_dflt = wlc_rateset_get_hwrs(wlc);
-	ASSERT(rs_dflt != NULL);
 
 	wlc_rateset_copy(rs_dflt, &rs);
 	wlc_rateset_mcs_upd(&rs, wlc->stf->txstreams);
@@ -7592,10 +7327,6 @@ wlc_bcn_prb_template(struct wlc_info *wlc, u16 type, ratespec_t bcn_rspec,
 	struct ieee80211_mgmt *h;
 	int hdr_len, body_len;
 
-	ASSERT(*len >= 142);
-	ASSERT(type == IEEE80211_STYPE_BEACON ||
-	       type == IEEE80211_STYPE_PROBE_RESP);
-
 	if (MBSS_BCN_ENAB(cfg) && type == IEEE80211_STYPE_BEACON)
 		hdr_len = DOT11_MAC_HDR_LEN;
 	else
@@ -7687,12 +7418,6 @@ void wlc_bss_update_beacon(struct wlc_info *wlc, struct wlc_bsscfg *cfg)
 
 		wlc->bcn_rspec =
 		    wlc_lowest_basic_rspec(wlc, &cfg->current_bss->rateset);
-		ASSERT(wlc_valid_rate
-		       (wlc, wlc->bcn_rspec,
-			CHSPEC_IS2G(cfg->current_bss->
-				    chanspec) ? WLC_BAND_2G : WLC_BAND_5G,
-			true));
-
 		/* update the template and ucode shm */
 		wlc_bcn_prb_template(wlc, IEEE80211_STYPE_BEACON,
 				     wlc->bcn_rspec, cfg, bcn, &len);
@@ -7782,7 +7507,7 @@ wlc_bss_update_probe_resp(struct wlc_info *wlc, struct wlc_bsscfg *cfg,
 		if (suspend)
 			wlc_enable_mac(wlc);
 	} else {		/* Generating probe resp in sw; update local template */
-		ASSERT(0 && "No software probe response support without MBSS");
+		/* error: No software probe response support without MBSS */
 	}
 }
 
@@ -7794,11 +7519,8 @@ int wlc_prep_pdu(struct wlc_info *wlc, struct sk_buff *pdu, uint *fifop)
 	struct ieee80211_hdr *h;
 	struct scb *scb;
 
-	ASSERT(pdu);
 	txh = (d11txh_t *) (pdu->data);
-	ASSERT(txh);
 	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
-	ASSERT(h);
 
 	/* get the pkt queue info. This was put at wlc_sendctl or wlc_send for PDU */
 	fifo = le16_to_cpu(txh->TxFrameID) & TXFID_QUEUE_MASK;
@@ -7900,8 +7622,6 @@ static void wlc_bss_default_init(struct wlc_info *wlc)
 	 * starting from the 2G channels
 	 */
 	chanspec = CH20MHZ_CHSPEC(1);
-	ASSERT(chanspec != INVCHANSPEC);
-
 	wlc->home_chanspec = bi->chanspec = chanspec;
 
 	/* find the band of our default channel */
@@ -8094,10 +7814,7 @@ void wlc_write_shm(struct wlc_info *wlc, uint offset, u16 v)
 void wlc_set_shm(struct wlc_info *wlc, uint offset, u16 v, int len)
 {
 	/* offset and len need to be even */
-	ASSERT((offset & 1) == 0);
-	ASSERT((len & 1) == 0);
-
-	if (len <= 0)
+	if (len <= 0 || (offset & 1) || (len & 1))
 		return;
 
 	wlc_bmac_set_shm(wlc->hw, offset, v, len);
@@ -8110,11 +7827,9 @@ void wlc_set_shm(struct wlc_info *wlc, uint offset, u16 v, int len)
 void wlc_copyto_shm(struct wlc_info *wlc, uint offset, const void *buf, int len)
 {
 	/* offset and len need to be even */
-	ASSERT((offset & 1) == 0);
-	ASSERT((len & 1) == 0);
-
-	if (len <= 0)
+	if (len <= 0 || (offset & 1) || (len & 1))
 		return;
+
 	wlc_bmac_copyto_objmem(wlc->hw, offset, buf, len, OBJADDR_SHM_SEL);
 
 }
@@ -8126,10 +7841,7 @@ void wlc_copyto_shm(struct wlc_info *wlc, uint offset, const void *buf, int len)
 void wlc_copyfrom_shm(struct wlc_info *wlc, uint offset, void *buf, int len)
 {
 	/* offset and len need to be even */
-	ASSERT((offset & 1) == 0);
-	ASSERT((len & 1) == 0);
-
-	if (len <= 0)
+	if (len <= 0 || (offset & 1) || (len & 1))
 		return;
 
 	wlc_bmac_copyfrom_objmem(wlc->hw, offset, buf, len, OBJADDR_SHM_SEL);
@@ -8242,7 +7954,6 @@ wlc_txflowcontrol_prio_isset(struct wlc_info *wlc, struct wlc_txq_info *q,
 	if (prio == ALLPRIO) {
 		prio_mask = TXQ_STOP_FOR_PRIOFC_MASK;
 	} else {
-		ASSERT(prio >= 0 && prio <= MAXPRIO);
 		prio_mask = NBITVAL(prio);
 	}
 
@@ -8261,7 +7972,6 @@ void wlc_txflowcontrol(struct wlc_info *wlc, struct wlc_txq_info *qi,
 	if (prio == ALLPRIO) {
 		prio_bits = TXQ_STOP_FOR_PRIOFC_MASK;
 	} else {
-		ASSERT(prio >= 0 && prio <= MAXPRIO);
 		prio_bits = NBITVAL(prio);
 	}
 
@@ -8298,9 +8008,6 @@ wlc_txflowcontrol_override(struct wlc_info *wlc, struct wlc_txq_info *qi,
 {
 	uint prev_override;
 
-	ASSERT(override != 0);
-	ASSERT((override & TXQ_STOP_FOR_PRIOFC_MASK) == 0);
-
 	prev_override = (qi->stopped & ~TXQ_STOP_FOR_PRIOFC_MASK);
 
 	/* Update the flow control bits and do an early return if there is
@@ -8407,7 +8114,6 @@ static void wlc_txq_free(struct wlc_info *wlc, struct wlc_txq_info *qi)
 	else {
 		while (p != NULL && p->next != qi)
 			p = p->next;
-		ASSERT(p->next == qi);
 		if (p != NULL)
 			p->next = p->next->next;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index a858356..a5e0f5d 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -166,9 +166,6 @@ extern const u8 prio2fifo[];
 #define WLC_PLLREQ_RADIO_MON	0x2	/* hold pll for radio monitor register checking */
 #define WLC_PLLREQ_FLIP		0x4	/* hold/release pll for some short operation */
 
-/* Do we support this rate? */
-#define VALID_RATE_DBG(wlc, rspec) wlc_valid_rate(wlc, rspec, WLC_BAND_AUTO, true)
-
 /*
  * Macros to check if AP or STA is active.
  * AP Active means more than just configured: driver and BSS are "up";
-- 
1.7.4.1


