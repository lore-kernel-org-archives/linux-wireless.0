Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42439 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab1AURwl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 12:52:41 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH] ath9k: add missing ps wakeup/restore calls
Date: Fri, 21 Jan 2011 18:52:38 +0100
Message-Id: <1295632358-27754-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are several places where ath_reset() was called without proper
calls to ath9k_ps_wakeup/ath9k_ps_restore. To fix this, add those calls
directly to ath_reset and drop them from callers where it makes sense.

Also add them to the config callback around ath_update_txpow to fix a
crash that happens when the tx power changed before any vif is brought up.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/main.c |    8 +++++---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 --
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 086043c..f21e956 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -596,14 +596,12 @@ void ath9k_tasklet(unsigned long data)
 	u32 status = sc->intrstatus;
 	u32 rxmask;
 
-	ath9k_ps_wakeup(sc);
-
 	if (status & ATH9K_INT_FATAL) {
 		ath_reset(sc, true);
-		ath9k_ps_restore(sc);
 		return;
 	}
 
+	ath9k_ps_wakeup(sc);
 	spin_lock(&sc->sc_pcu_lock);
 
 	/*
@@ -980,6 +978,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	/* Stop ANI */
 	del_timer_sync(&common->ani.timer);
 
+	ath9k_ps_wakeup(sc);
 	spin_lock_bh(&sc->sc_pcu_lock);
 
 	ieee80211_stop_queues(hw);
@@ -1026,6 +1025,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 
 	/* Start ANI */
 	ath_start_ani(common);
+	ath9k_ps_restore(sc);
 
 	return r;
 }
@@ -1751,7 +1751,9 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
 		sc->config.txpowlimit = 2 * conf->power_level;
+		ath9k_ps_wakeup(sc);
 		ath_update_txpow(sc);
+		ath9k_ps_restore(sc);
 	}
 
 	if (disable_radio) {
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 0ddfdbc..412806b 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2101,9 +2101,7 @@ static void ath_tx_complete_poll_work(struct work_struct *work)
 	if (needreset) {
 		ath_dbg(ath9k_hw_common(sc->sc_ah), ATH_DBG_RESET,
 			"tx hung, resetting the chip\n");
-		ath9k_ps_wakeup(sc);
 		ath_reset(sc, true);
-		ath9k_ps_restore(sc);
 	}
 
 	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work,
-- 
1.7.3.2

