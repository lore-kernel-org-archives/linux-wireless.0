Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:55510 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab0G1Rp6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 13:45:58 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/3] ath9k: prevent calibration during off-channel activity
Date: Wed, 28 Jul 2010 19:45:49 +0200
Message-Id: <1280339151-37084-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previously the software scan callback was used to indicate to the hardware,
when it was safe to calibrate. This didn't really work properly, because it
depends on a specific order of software scan callbacks vs. channel changes.
Also, software scans are not the only thing that triggers off-channel
activity, so it's better to use the newly added indication from mac80211 for
this and not use the software scan callback for anything calibration related.

This fixes at least some of the invalid noise floor readings that I've seen
in AP mode on AR9160

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    3 +-
 drivers/net/wireless/ath/ath9k/main.c  |   75 ++++++++++++++++---------------
 drivers/net/wireless/ath/ath9k/recv.c  |    4 +-
 3 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 998ae2c..9e967b1 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -510,13 +510,12 @@ void ath_deinit_leds(struct ath_softc *sc);
 #define SC_OP_BEACONS                BIT(1)
 #define SC_OP_RXAGGR                 BIT(2)
 #define SC_OP_TXAGGR                 BIT(3)
-#define SC_OP_FULL_RESET             BIT(4)
 #define SC_OP_PREAMBLE_SHORT         BIT(5)
 #define SC_OP_PROTECT_ENABLE         BIT(6)
 #define SC_OP_RXFLUSH                BIT(7)
 #define SC_OP_LED_ASSOCIATED         BIT(8)
 #define SC_OP_LED_ON                 BIT(9)
-#define SC_OP_SCANNING               BIT(10)
+#define SC_OP_OFFCHANNEL             BIT(10)
 #define SC_OP_TSF_RESET              BIT(11)
 #define SC_OP_BT_PRIORITY_DETECTED   BIT(12)
 #define SC_OP_BT_SCAN		     BIT(13)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0429dda..c82d8c4 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -154,6 +154,27 @@ void ath9k_ps_restore(struct ath_softc *sc)
 	spin_unlock_irqrestore(&sc->sc_pm_lock, flags);
 }
 
+static void ath_start_ani(struct ath_common *common)
+{
+	struct ath_hw *ah = common->ah;
+	unsigned long timestamp = jiffies_to_msecs(jiffies);
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
+
+	if (!(sc->sc_flags & SC_OP_ANI_RUN))
+		return;
+
+	if (sc->sc_flags & SC_OP_OFFCHANNEL)
+		return;
+
+	common->ani.longcal_timer = timestamp;
+	common->ani.shortcal_timer = timestamp;
+	common->ani.checkani_timer = timestamp;
+
+	mod_timer(&common->ani.timer,
+		  jiffies +
+			msecs_to_jiffies((u32)ah->config.ani_poll_interval));
+}
+
 /*
  * Set/change channels.  If the channel is really being changed, it's done
  * by reseting the chip.  To accomplish this we must first cleanup any pending
@@ -172,6 +193,11 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	if (sc->sc_flags & SC_OP_INVALID)
 		return -EIO;
 
+	del_timer_sync(&common->ani.timer);
+	cancel_work_sync(&sc->paprd_work);
+	cancel_work_sync(&sc->hw_check_work);
+	cancel_delayed_work_sync(&sc->tx_complete_work);
+
 	ath9k_ps_wakeup(sc);
 
 	/*
@@ -191,7 +217,7 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	 * to flush data frames already in queue because of
 	 * changing channel. */
 
-	if (!stopped || (sc->sc_flags & SC_OP_FULL_RESET))
+	if (!stopped || !(sc->sc_flags & SC_OP_OFFCHANNEL))
 		fastcc = false;
 
 	ath_print(common, ATH_DBG_CONFIG,
@@ -212,8 +238,6 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
-	sc->sc_flags &= ~SC_OP_FULL_RESET;
-
 	if (ath_startrecv(sc) != 0) {
 		ath_print(common, ATH_DBG_FATAL,
 			  "Unable to restart recv logic\n");
@@ -225,6 +249,12 @@ int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	ath_update_txpow(sc);
 	ath9k_hw_set_interrupts(ah, ah->imask);
 
+	if (!(sc->sc_flags & SC_OP_OFFCHANNEL)) {
+		ath_start_ani(common);
+		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
+		ath_beacon_config(sc, NULL);
+	}
+
  ps_restore:
 	ath9k_ps_restore(sc);
 	return r;
@@ -439,8 +469,7 @@ set_timer:
 		cal_interval = min(cal_interval, (u32)short_cal_interval);
 
 	mod_timer(&common->ani.timer, jiffies + msecs_to_jiffies(cal_interval));
-	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_PAPRD) &&
-	    !(sc->sc_flags & SC_OP_SCANNING)) {
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_PAPRD) {
 		if (!sc->sc_ah->curchan->paprd_done)
 			ieee80211_queue_work(sc->hw, &sc->paprd_work);
 		else
@@ -448,24 +477,6 @@ set_timer:
 	}
 }
 
-static void ath_start_ani(struct ath_common *common)
-{
-	struct ath_hw *ah = common->ah;
-	unsigned long timestamp = jiffies_to_msecs(jiffies);
-	struct ath_softc *sc = (struct ath_softc *) common->priv;
-
-	if (!(sc->sc_flags & SC_OP_ANI_RUN))
-		return;
-
-	common->ani.longcal_timer = timestamp;
-	common->ani.shortcal_timer = timestamp;
-	common->ani.checkani_timer = timestamp;
-
-	mod_timer(&common->ani.timer,
-		  jiffies +
-			msecs_to_jiffies((u32)ah->config.ani_poll_interval));
-}
-
 /*
  * Update tx/rx chainmask. For legacy association,
  * hard code chainmask to 1x1, for 11n association, use
@@ -477,7 +488,7 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	if ((sc->sc_flags & SC_OP_SCANNING) || is_ht ||
+	if ((sc->sc_flags & SC_OP_OFFCHANNEL) || is_ht ||
 	    (ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE)) {
 		common->tx_chainmask = ah->caps.tx_chainmask;
 		common->rx_chainmask = ah->caps.rx_chainmask;
@@ -1579,6 +1590,10 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 		aphy->chan_idx = pos;
 		aphy->chan_is_ht = conf_is_ht(conf);
+		if (hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
+			sc->sc_flags |= SC_OP_OFFCHANNEL;
+		else
+			sc->sc_flags &= ~SC_OP_OFFCHANNEL;
 
 		if (aphy->state == ATH_WIPHY_SCAN ||
 		    aphy->state == ATH_WIPHY_ACTIVE)
@@ -1990,7 +2005,6 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	mutex_lock(&sc->mutex);
 	if (ath9k_wiphy_scanning(sc)) {
@@ -2007,11 +2021,6 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 
 	aphy->state = ATH_WIPHY_SCAN;
 	ath9k_wiphy_pause_all_forced(sc, aphy);
-	sc->sc_flags |= SC_OP_SCANNING;
-	del_timer_sync(&common->ani.timer);
-	cancel_work_sync(&sc->paprd_work);
-	cancel_work_sync(&sc->hw_check_work);
-	cancel_delayed_work_sync(&sc->tx_complete_work);
 	mutex_unlock(&sc->mutex);
 }
 
@@ -2023,15 +2032,9 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	mutex_lock(&sc->mutex);
 	aphy->state = ATH_WIPHY_ACTIVE;
-	sc->sc_flags &= ~SC_OP_SCANNING;
-	sc->sc_flags |= SC_OP_FULL_RESET;
-	ath_start_ani(common);
-	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
-	ath_beacon_config(sc, NULL);
 	mutex_unlock(&sc->mutex);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index da0cfe9..4125ca2 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -292,7 +292,7 @@ static void ath_edma_start_recv(struct ath_softc *sc)
 
 	ath_opmode_init(sc);
 
-	ath9k_hw_startpcureceive(sc->sc_ah, (sc->sc_flags & SC_OP_SCANNING));
+	ath9k_hw_startpcureceive(sc->sc_ah, (sc->sc_flags & SC_OP_OFFCHANNEL));
 }
 
 static void ath_edma_stop_recv(struct ath_softc *sc)
@@ -498,7 +498,7 @@ int ath_startrecv(struct ath_softc *sc)
 start_recv:
 	spin_unlock_bh(&sc->rx.rxbuflock);
 	ath_opmode_init(sc);
-	ath9k_hw_startpcureceive(ah, (sc->sc_flags & SC_OP_SCANNING));
+	ath9k_hw_startpcureceive(ah, (sc->sc_flags & SC_OP_OFFCHANNEL));
 
 	return 0;
 }
-- 
1.6.4.2

