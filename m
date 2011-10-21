Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1374 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754695Ab1JUOQr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:16:47 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH v2 05/17] brcm80211: smac: removed down-on-watchdog MPC
 functionality
Date: Fri, 21 Oct 2011 16:16:23 +0200
Message-ID: <1319206595-17138-6-git-send-email-arend@broadcom.com> (sfid-20111021_161702_856514_D1F707E1)
In-Reply-To: <1319206595-17138-1-git-send-email-arend@broadcom.com>
References: <1319206595-17138-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Softmac would bring its interface down on a certain Minimum Power Save
related condition, without Mac80211 intervention. Because Mac80211 should
be the only party initiating interfaces going up and down, this functionality
has been removed. All notions of 'MPC' have been removed in the code as
well.

Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   45 +++----------------
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |    3 -
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |    2 +-
 drivers/net/wireless/brcm80211/include/defs.h      |    1 -
 5 files changed, 9 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 1781157..fe8f1ec 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -1078,8 +1078,7 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 
 	wl->pub->ieee_hw = hw;
 
-	/* disable mpc */
-	brcms_c_set_radio_mpc(wl->wlc);
+	brcms_c_set_radio_mon(wl->wlc);
 
 	/* register our interrupt handler */
 	if (request_irq(irq, brcms_isr, IRQF_SHARED, KBUILD_MODNAME, wl)) {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index e7d14e4..d185eed 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -43,16 +43,6 @@
 /* radio monitor timer, in unit of ms */
 #define TIMER_INTERVAL_RADIOCHK		800
 
-/* Max MPC timeout, in unit of watchdog */
-#ifndef BRCMS_MPC_MAX_DELAYCNT
-#define BRCMS_MPC_MAX_DELAYCNT		10
-#endif
-
-/* Min MPC timeout, in unit of watchdog */
-#define BRCMS_MPC_MIN_DELAYCNT		1
-/* MPC count threshold level */
-#define BRCMS_MPC_THRESHOLD		3
-
 /* beacon interval, in unit of 1024TU */
 #define BEACON_INTERVAL_DEFAULT		100
 
@@ -4330,17 +4320,13 @@ static void brcms_b_watchdog(void *arg)
 	wlc_phy_watchdog(wlc_hw->band->pi);
 }
 
-static void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
+static void brcms_c_radio_mon_upd(struct brcms_c_info *wlc)
 {
 	/*
-	 * Clear the WL_RADIO_MPC_DISABLE bit when mpc feature is disabled
-	 * in case the WL_RADIO_MPC_DISABLE bit was set. Stop the radio
-	 * monitor also when WL_RADIO_MPC_DISABLE is the only reason that
-	 * the radio is going down.
+	 * Stop the radio monitor when the radio is going down.
 	 */
 	if (!wlc->pub->radio_disabled)
 		return;
-	mboolclr(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE);
 	brcms_c_radio_upd(wlc);
 	if (!wlc->pub->radio_disabled)
 		brcms_c_radio_monitor_stop(wlc);
@@ -4366,17 +4352,8 @@ static void brcms_c_watchdog(void *arg)
 	/* increment second count */
 	wlc->pub->now++;
 
-	/* delay radio disable */
-	if (wlc->mpc_delay_off) {
-		if (--wlc->mpc_delay_off == 0) {
-			mboolset(wlc->pub->radio_disabled,
-				 WL_RADIO_MPC_DISABLE);
-		}
-	}
-
-	/* mpc sync */
-	brcms_c_radio_mpc_upd(wlc);
-	/* radio sync: sw/hw/mpc --> radio_disable/radio_enable */
+	brcms_c_radio_mon_upd(wlc);
+	/* radio sync: sw/hw --> radio_disable/radio_enable */
 	brcms_c_radio_hwdisable_upd(wlc);
 	brcms_c_radio_upd(wlc);
 	/* if radio is disable, driver may be down, quit here */
@@ -4482,9 +4459,6 @@ static void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 	/* WME QoS mode is Auto by default */
 	wlc->pub->_ampdu = AMPDU_AGG_HOST;
 	wlc->pub->bcmerror = 0;
-
-	/* initialize mpc delay */
-	wlc->mpc_delay_off = BRCMS_MPC_MIN_DELAYCNT;
 }
 
 static uint brcms_c_attach_module(struct brcms_c_info *wlc)
@@ -5455,7 +5429,6 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 	if (!wlc->pub->up)
 		return callbacks;
 
-	/* in between, mpc could try to bring down again.. */
 	wlc->going_down = true;
 
 	callbacks += brcms_b_bmac_down_prep(wlc->hw);
@@ -8131,9 +8104,9 @@ int brcms_c_get_tx_power(struct brcms_c_info *wlc)
 	return (int)(qdbm / BRCMS_TXPWR_DB_FACTOR);
 }
 
-void brcms_c_set_radio_mpc(struct brcms_c_info *wlc)
+void brcms_c_set_radio_mon(struct brcms_c_info *wlc)
 {
-	brcms_c_radio_mpc_upd(wlc);
+	brcms_c_radio_mon_upd(wlc);
 }
 
 /* Process received frames */
@@ -8442,9 +8415,6 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	/* enable the RF Disable Delay timer */
 	W_REG(&wlc->regs->rfdisabledly, RFDISABLE_DEFAULT);
 
-	/* initialize mpc delay */
-	wlc->mpc_delay_off = BRCMS_MPC_MIN_DELAYCNT;
-
 	/*
 	 * Initialize WME parameters; if they haven't been set by some other
 	 * mechanism (IOVar, etc) then read them from the hardware.
@@ -8630,8 +8600,7 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		brcms_c_ht_update_sgi_rx(wlc, 0);
 	}
 
-	/* initialize radio_mpc_disable according to wlc->mpc */
-	brcms_c_radio_mpc_upd(wlc);
+	brcms_c_radio_mon_upd(wlc);
 	brcms_b_antsel_set(wlc->hw, wlc->asi->antsel_avail);
 
 	if (perr)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index fc5852f..9a7535d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -427,7 +427,6 @@ struct brcms_txq_info {
  * bandinit_pending: track band init in auto band.
  * radio_monitor: radio timer is running.
  * going_down: down path intermediate variable.
- * mpc_delay_off: delay radio disable by # of watchdog cnt.
  * wdtimer: timer for watchdog routine.
  * radio_timer: timer for hw radio button monitor routine.
  * monitor: monitor (MPDU sniffing) mode.
@@ -518,8 +517,6 @@ struct brcms_c_info {
 	bool radio_monitor;
 	bool going_down;
 
-	u8 mpc_delay_off;
-
 	struct brcms_timer *wdtimer;
 	struct brcms_timer *radio_timer;
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 2e09216..4f8e859 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -596,7 +596,7 @@ extern void brcms_c_set_beacon_listen_interval(struct brcms_c_info *wlc,
 					u8 interval);
 extern int brcms_c_set_tx_power(struct brcms_c_info *wlc, int txpwr);
 extern int brcms_c_get_tx_power(struct brcms_c_info *wlc);
-extern void brcms_c_set_radio_mpc(struct brcms_c_info *wlc);
+extern void brcms_c_set_radio_mon(struct brcms_c_info *wlc);
 extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
 
 #endif				/* _BRCM_PUB_H_ */
diff --git a/drivers/net/wireless/brcm80211/include/defs.h b/drivers/net/wireless/brcm80211/include/defs.h
index 1e5f310..f0d8c04 100644
--- a/drivers/net/wireless/brcm80211/include/defs.h
+++ b/drivers/net/wireless/brcm80211/include/defs.h
@@ -62,7 +62,6 @@
 
 #define WL_RADIO_SW_DISABLE		(1<<0)
 #define WL_RADIO_HW_DISABLE		(1<<1)
-#define WL_RADIO_MPC_DISABLE		(1<<2)
 /* some countries don't support any channel */
 #define WL_RADIO_COUNTRY_DISABLE	(1<<3)
 
-- 
1.7.4.1


