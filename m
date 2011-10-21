Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1335 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab1JUOQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:16:48 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 06/17] brcm80211: smac: removed down-on-rf-kill
 functionality
Date: Fri, 21 Oct 2011 16:16:24 +0200
Message-ID: <1319206595-17138-7-git-send-email-arend@broadcom.com> (sfid-20111021_161710_033077_CBB97704)
In-Reply-To: <1319206595-17138-1-git-send-email-arend@broadcom.com>
References: <1319206595-17138-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Softmac would bring its interface down on an RF kill switch condition,
without Mac80211 intervention. Because Mac80211 should be the only party
initiating interfaces going up and down, this functionality has been
removed.

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    2 -
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   67 --------------------
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    1 -
 3 files changed, 0 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index fe8f1ec..915b741 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1078,8 +1078,6 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 
 	wl->pub->ieee_hw = hw;
 
-	brcms_c_set_radio_mon(wl->wlc);
-
 	/* register our interrupt handler */
 	if (request_irq(irq, brcms_isr, IRQF_SHARED, KBUILD_MODNAME, wl)) {
 		wiphy_err(wl->wiphy, "wl%d: request_irq() failed\n", unit);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index d185eed..2fecf06 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4194,17 +4194,6 @@ static void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 	}
 }
 
-/* maintain LED behavior in down state */
-static void brcms_c_down_led_upd(struct brcms_c_info *wlc)
-{
-	/*
-	 * maintain LEDs while in down state, turn on sbclk if
-	 * not available yet. Turn on sbclk if necessary
-	 */
-	brcms_b_pllreq(wlc->hw, true, BRCMS_PLLREQ_FLIP);
-	brcms_b_pllreq(wlc->hw, false, BRCMS_PLLREQ_FLIP);
-}
-
 static void brcms_c_radio_monitor_start(struct brcms_c_info *wlc)
 {
 	/* Don't start the timer if HWRADIO feature is disabled */
@@ -4216,28 +4205,6 @@ static void brcms_c_radio_monitor_start(struct brcms_c_info *wlc)
 	brcms_add_timer(wlc->radio_timer, TIMER_INTERVAL_RADIOCHK, true);
 }
 
-static void brcms_c_radio_disable(struct brcms_c_info *wlc)
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
-	if (brcms_deviceremoved(wlc))
-		return;
-
-	brcms_up(wlc->wl);
-}
-
 static bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc)
 {
 	if (!wlc->radio_monitor)
@@ -4260,18 +4227,6 @@ static void brcms_c_radio_hwdisable_upd(struct brcms_c_info *wlc)
 		mboolclr(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE);
 }
 
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
 /* update hwradio status and return it */
 bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc)
 {
@@ -4294,7 +4249,6 @@ static void brcms_c_radio_timer(void *arg)
 	}
 
 	brcms_c_radio_hwdisable_upd(wlc);
-	brcms_c_radio_upd(wlc);
 }
 
 /* common low-level watchdog code */
@@ -4320,18 +4274,6 @@ static void brcms_b_watchdog(void *arg)
 	wlc_phy_watchdog(wlc_hw->band->pi);
 }
 
-static void brcms_c_radio_mon_upd(struct brcms_c_info *wlc)
-{
-	/*
-	 * Stop the radio monitor when the radio is going down.
-	 */
-	if (!wlc->pub->radio_disabled)
-		return;
-	brcms_c_radio_upd(wlc);
-	if (!wlc->pub->radio_disabled)
-		brcms_c_radio_monitor_stop(wlc);
-}
-
 /* common watchdog code */
 static void brcms_c_watchdog(void *arg)
 {
@@ -4352,10 +4294,7 @@ static void brcms_c_watchdog(void *arg)
 	/* increment second count */
 	wlc->pub->now++;
 
-	brcms_c_radio_mon_upd(wlc);
-	/* radio sync: sw/hw --> radio_disable/radio_enable */
 	brcms_c_radio_hwdisable_upd(wlc);
-	brcms_c_radio_upd(wlc);
 	/* if radio is disable, driver may be down, quit here */
 	if (wlc->pub->radio_disabled)
 		return;
@@ -8104,11 +8043,6 @@ int brcms_c_get_tx_power(struct brcms_c_info *wlc)
 	return (int)(qdbm / BRCMS_TXPWR_DB_FACTOR);
 }
 
-void brcms_c_set_radio_mon(struct brcms_c_info *wlc)
-{
-	brcms_c_radio_mon_upd(wlc);
-}
-
 /* Process received frames */
 /*
  * Return true if more frames need to be processed. false otherwise.
@@ -8600,7 +8534,6 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		brcms_c_ht_update_sgi_rx(wlc, 0);
 	}
 
-	brcms_c_radio_mon_upd(wlc);
 	brcms_b_antsel_set(wlc->hw, wlc->asi->antsel_avail);
 
 	if (perr)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 4f8e859..97b9cce 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -596,7 +596,6 @@ extern void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc,
 					u8 interval);
 extern int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr);
 extern int brcms_c_get_tx_power(struct brcms_c_info *wlc);
-extern void brcms_c_set_radio_mon(struct brcms_c_info *wlc);
 extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
 
 #endif				/* _BRCM_PUB_H_ */
-- 
1.7.4.1


