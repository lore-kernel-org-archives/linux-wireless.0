Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4989 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab1JLSvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:51 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/22] brcm80211: smac: removed redundant timer function
 parameters
Date: Wed, 12 Oct 2011 20:51:11 +0200
Message-ID: <1318445492-24207-2-git-send-email-arend@broadcom.com> (sfid-20111012_205210_304117_A5C0D3BC)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Parameter 'wl' is already stored in struct brcms_timer, so the number of
function parameters could be decreased.

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   15 ++++++++-------
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    7 +++----
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   13 ++++++-------
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |   12 ++++++------
 drivers/net/wireless/brcm80211/brcmsmac/phy_shim.c |   13 ++++++-------
 drivers/net/wireless/brcm80211/brcmsmac/phy_shim.h |    9 +++------
 6 files changed, 32 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 4dcf9ef..b665aaf 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1478,12 +1478,12 @@ struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
  *
  * precondition: perimeter lock has been acquired
  */
-void brcms_add_timer(struct brcms_info *wl, struct brcms_timer *t, uint ms,
+void brcms_add_timer(struct brcms_timer *t, uint ms,
 		     int periodic)
 {
 #ifdef BCMDBG
 	if (t->set)
-		wiphy_err(wl->wiphy, "%s: Already set. Name: %s, per %d\n",
+		wiphy_err(t->wl->wiphy, "%s: Already set. Name: %s, per %d\n",
 			  __func__, t->name, periodic);
 
 #endif
@@ -1492,7 +1492,7 @@ void brcms_add_timer(struct brcms_info *wl, struct brcms_timer *t, uint ms,
 	t->set = true;
 	t->timer.expires = jiffies + ms * HZ / 1000;
 
-	atomic_inc(&wl->callbacks);
+	atomic_inc(&t->wl->callbacks);
 	add_timer(&t->timer);
 }
 
@@ -1501,14 +1501,14 @@ void brcms_add_timer(struct brcms_info *wl, struct brcms_timer *t, uint ms,
  *
  * precondition: perimeter lock has been acquired
  */
-bool brcms_del_timer(struct brcms_info *wl, struct brcms_timer *t)
+bool brcms_del_timer(struct brcms_timer *t)
 {
 	if (t->set) {
 		t->set = false;
 		if (!del_timer(&t->timer))
 			return false;
 
-		atomic_dec(&wl->callbacks);
+		atomic_dec(&t->wl->callbacks);
 	}
 
 	return true;
@@ -1517,12 +1517,13 @@ bool brcms_del_timer(struct brcms_info *wl, struct brcms_timer *t)
 /*
  * precondition: perimeter lock has been acquired
  */
-void brcms_free_timer(struct brcms_info *wl, struct brcms_timer *t)
+void brcms_free_timer(struct brcms_timer *t)
 {
+	struct brcms_info *wl = t->wl;
 	struct brcms_timer *tmp;
 
 	/* delete the timer in case it is active */
-	brcms_del_timer(wl, t);
+	brcms_del_timer(t);
 
 	if (wl->timers == t) {
 		wl->timers = wl->timers->next;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
index 92256d0..91e5f2a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
@@ -96,10 +96,9 @@ extern bool brcms_rfkill_set_hw_state(struct brcms_info *wl);
 extern struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
 				      void (*fn) (void *arg), void *arg,
 				      const char *name);
-extern void brcms_free_timer(struct brcms_info *wl, struct brcms_timer *timer);
-extern void brcms_add_timer(struct brcms_info *wl, struct brcms_timer *timer,
-			    uint ms, int periodic);
-extern bool brcms_del_timer(struct brcms_info *wl, struct brcms_timer *timer);
+extern void brcms_free_timer(struct brcms_timer *timer);
+extern void brcms_add_timer(struct brcms_timer *timer, uint ms, int periodic);
+extern bool brcms_del_timer(struct brcms_timer *timer);
 extern void brcms_msleep(struct brcms_info *wl, uint ms);
 extern void brcms_dpc(unsigned long data);
 extern void brcms_timer(struct brcms_timer *t);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 5fb999b..665bf80 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4236,8 +4236,7 @@ static void brcms_c_radio_monitor_start(struct brcms_c_info *wlc)
 
 	wlc->radio_monitor = true;
 	brcms_b_pllreq(wlc->hw, true, BRCMS_PLLREQ_RADIO_MON);
-	brcms_add_timer(wlc->wl, wlc->radio_timer, TIMER_INTERVAL_RADIOCHK,
-			true);
+	brcms_add_timer(wlc->radio_timer, TIMER_INTERVAL_RADIOCHK, true);
 }
 
 void brcms_c_radio_disable(struct brcms_c_info *wlc)
@@ -4269,7 +4268,7 @@ bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc)
 
 	wlc->radio_monitor = false;
 	brcms_b_pllreq(wlc->hw, false, BRCMS_PLLREQ_RADIO_MON);
-	return brcms_del_timer(wlc->wl, wlc->radio_timer);
+	return brcms_del_timer(wlc->radio_timer);
 }
 
 /* read hwdisable state and propagate to wlc flag */
@@ -5221,11 +5220,11 @@ static void brcms_c_timers_deinit(struct brcms_c_info *wlc)
 {
 	/* free timer state */
 	if (wlc->wdtimer) {
-		brcms_free_timer(wlc->wl, wlc->wdtimer);
+		brcms_free_timer(wlc->wdtimer);
 		wlc->wdtimer = NULL;
 	}
 	if (wlc->radio_timer) {
-		brcms_free_timer(wlc->wl, wlc->radio_timer);
+		brcms_free_timer(wlc->radio_timer);
 		wlc->radio_timer = NULL;
 	}
 }
@@ -5607,7 +5606,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	brcms_c_wme_retries_write(wlc);
 
 	/* start one second watchdog timer */
-	brcms_add_timer(wlc->wl, wlc->wdtimer, TIMER_INTERVAL_WATCHDOG, true);
+	brcms_add_timer(wlc->wdtimer, TIMER_INTERVAL_WATCHDOG, true);
 	wlc->WDarmed = true;
 
 	/* ensure antenna config is up to date */
@@ -5736,7 +5735,7 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 
 	/* cancel the watchdog timer */
 	if (wlc->WDarmed) {
-		if (!brcms_del_timer(wlc->wl, wlc->wdtimer))
+		if (!brcms_del_timer(wlc->wdtimer))
 			callbacks++;
 		wlc->WDarmed = false;
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
index d54cfdb..a314925 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -442,7 +442,7 @@ static void wlc_phy_timercb_phycal(struct brcms_phy *pi)
 			wlc_phy_cal_perical_mphase_restart(pi);
 		} else
 			wlc_phy_cal_perical_nphy_run(pi, PHY_PERICAL_AUTO);
-		wlapi_add_timer(pi->sh->physhim, pi->phycal_timer, delay, 0);
+		wlapi_add_timer(pi->phycal_timer, delay, 0);
 		return;
 	}
 
@@ -625,7 +625,7 @@ void wlc_phy_detach(struct brcms_phy_pub *pih)
 			return;
 
 		if (pi->phycal_timer) {
-			wlapi_free_timer(pi->sh->physhim, pi->phycal_timer);
+			wlapi_free_timer(pi->phycal_timer);
 			pi->phycal_timer = NULL;
 		}
 
@@ -852,7 +852,7 @@ int wlc_phy_down(struct brcms_phy_pub *pih)
 	int callbacks = 0;
 
 	if (pi->phycal_timer
-	    && !wlapi_del_timer(pi->sh->physhim, pi->phycal_timer))
+	    && !wlapi_del_timer(pi->phycal_timer))
 		callbacks++;
 
 	pi->nphy_iqcal_chanspec_2G = 0;
@@ -2715,7 +2715,7 @@ wlc_phy_papd_decode_epsilon(u32 epsilon, s32 *eps_real, s32 *eps_imag)
 
 void wlc_phy_cal_perical_mphase_reset(struct brcms_phy *pi)
 {
-	wlapi_del_timer(pi->sh->physhim, pi->phycal_timer);
+	wlapi_del_timer(pi->phycal_timer);
 
 	pi->cal_type_override = PHY_PERICAL_AUTO;
 	pi->mphase_cal_phase_id = MPHASE_CAL_STATE_IDLE;
@@ -2730,10 +2730,10 @@ wlc_phy_cal_perical_mphase_schedule(struct brcms_phy *pi, uint delay)
 	    (pi->nphy_perical != PHY_PERICAL_MANUAL))
 		return;
 
-	wlapi_del_timer(pi->sh->physhim, pi->phycal_timer);
+	wlapi_del_timer(pi->phycal_timer);
 
 	pi->mphase_cal_phase_id = MPHASE_CAL_STATE_INIT;
-	wlapi_add_timer(pi->sh->physhim, pi->phycal_timer, delay, 0);
+	wlapi_add_timer(pi->phycal_timer, delay, 0);
 }
 
 void wlc_phy_cal_perical(struct brcms_phy_pub *pih, u8 reason)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy_shim.c b/drivers/net/wireless/brcm80211/brcmsmac/phy_shim.c
index 676222e..5926854 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy_shim.c
@@ -65,21 +65,20 @@ struct wlapi_timer *wlapi_init_timer(struct phy_shim_info *physhim,
 					 arg, name);
 }
 
-void wlapi_free_timer(struct phy_shim_info *physhim, struct wlapi_timer *t)
+void wlapi_free_timer(struct wlapi_timer *t)
 {
-	brcms_free_timer(physhim->wl, (struct brcms_timer *)t);
+	brcms_free_timer((struct brcms_timer *)t);
 }
 
 void
-wlapi_add_timer(struct phy_shim_info *physhim, struct wlapi_timer *t, uint ms,
-		int periodic)
+wlapi_add_timer(struct wlapi_timer *t, uint ms, int periodic)
 {
-	brcms_add_timer(physhim->wl, (struct brcms_timer *)t, ms, periodic);
+	brcms_add_timer((struct brcms_timer *)t, ms, periodic);
 }
 
-bool wlapi_del_timer(struct phy_shim_info *physhim, struct wlapi_timer *t)
+bool wlapi_del_timer(struct wlapi_timer *t)
 {
-	return brcms_del_timer(physhim->wl, (struct brcms_timer *)t);
+	return brcms_del_timer((struct brcms_timer *)t);
 }
 
 void wlapi_intrson(struct phy_shim_info *physhim)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy_shim.h b/drivers/net/wireless/brcm80211/brcmsmac/phy_shim.h
index 8de549d..9168c45 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy_shim.h
@@ -133,12 +133,9 @@ extern void wlc_phy_shim_detach(struct phy_shim_info *physhim);
 extern struct wlapi_timer *wlapi_init_timer(struct phy_shim_info *physhim,
 					    void (*fn) (struct brcms_phy *pi),
 					    void *arg, const char *name);
-extern void wlapi_free_timer(struct phy_shim_info *physhim,
-			     struct wlapi_timer *t);
-extern void wlapi_add_timer(struct phy_shim_info *physhim,
-			    struct wlapi_timer *t, uint ms, int periodic);
-extern bool wlapi_del_timer(struct phy_shim_info *physhim,
-			    struct wlapi_timer *t);
+extern void wlapi_free_timer(struct wlapi_timer *t);
+extern void wlapi_add_timer(struct wlapi_timer *t, uint ms, int periodic);
+extern bool wlapi_del_timer(struct wlapi_timer *t);
 extern void wlapi_intrson(struct phy_shim_info *physhim);
 extern u32 wlapi_intrsoff(struct phy_shim_info *physhim);
 extern void wlapi_intrsrestore(struct phy_shim_info *physhim,
-- 
1.7.4.1


