Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:49932 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab0G3WMG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 18:12:06 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH v2 1/3] ath9k: prevent calibration during off-channel activity
Date: Sat, 31 Jul 2010 00:11:59 +0200
Message-Id: <1280527921-49946-1-git-send-email-nbd@openwrt.org>
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
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath/ath9k/main.c  |   73 +++++++++++++++++---------------
 2 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 998ae2c..11fc69b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -510,7 +510,7 @@ void ath_deinit_leds(struct ath_softc *sc);
 #define SC_OP_BEACONS                BIT(1)
 #define SC_OP_RXAGGR                 BIT(2)
 #define SC_OP_TXAGGR                 BIT(3)
-#define SC_OP_FULL_RESET             BIT(4)
+#define SC_OP_OFFCHANNEL             BIT(4)
 #define SC_OP_PREAMBLE_SHORT         BIT(5)
 #define SC_OP_PROTECT_ENABLE         BIT(6)
 #define SC_OP_RXFLUSH                BIT(7)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6c1d9ef..8387ad5 100644
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
 
+	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL | SC_OP_SCANNING))) {
+		ath_start_ani(common);
+		ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
+		ath_beacon_config(sc, NULL);
+	}
+
  ps_restore:
 	ath9k_ps_restore(sc);
 	return r;
@@ -440,8 +470,7 @@ set_timer:
 		cal_interval = min(cal_interval, (u32)short_cal_interval);
 
 	mod_timer(&common->ani.timer, jiffies + msecs_to_jiffies(cal_interval));
-	if ((sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_PAPRD) &&
-	    !(sc->sc_flags & SC_OP_SCANNING)) {
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_PAPRD) {
 		if (!sc->sc_ah->curchan->paprd_done)
 			ieee80211_queue_work(sc->hw, &sc->paprd_work);
 		else
@@ -449,24 +478,6 @@ set_timer:
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
@@ -478,7 +489,7 @@ void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	if ((sc->sc_flags & SC_OP_SCANNING) || is_ht ||
+	if ((sc->sc_flags & SC_OP_OFFCHANNEL) || is_ht ||
 	    (ah->btcoex_hw.scheme != ATH_BTCOEX_CFG_NONE)) {
 		common->tx_chainmask = ah->caps.tx_chainmask;
 		common->rx_chainmask = ah->caps.rx_chainmask;
@@ -1580,6 +1591,10 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 		aphy->chan_idx = pos;
 		aphy->chan_is_ht = conf_is_ht(conf);
+		if (hw->conf.flags & IEEE80211_CONF_OFFCHANNEL)
+			sc->sc_flags |= SC_OP_OFFCHANNEL;
+		else
+			sc->sc_flags &= ~SC_OP_OFFCHANNEL;
 
 		if (aphy->state == ATH_WIPHY_SCAN ||
 		    aphy->state == ATH_WIPHY_ACTIVE)
@@ -1991,7 +2006,6 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	mutex_lock(&sc->mutex);
 	if (ath9k_wiphy_scanning(sc)) {
@@ -2009,10 +2023,6 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 	aphy->state = ATH_WIPHY_SCAN;
 	ath9k_wiphy_pause_all_forced(sc, aphy);
 	sc->sc_flags |= SC_OP_SCANNING;
-	del_timer_sync(&common->ani.timer);
-	cancel_work_sync(&sc->paprd_work);
-	cancel_work_sync(&sc->hw_check_work);
-	cancel_delayed_work_sync(&sc->tx_complete_work);
 	mutex_unlock(&sc->mutex);
 }
 
@@ -2024,15 +2034,10 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	mutex_lock(&sc->mutex);
 	aphy->state = ATH_WIPHY_ACTIVE;
 	sc->sc_flags &= ~SC_OP_SCANNING;
-	sc->sc_flags |= SC_OP_FULL_RESET;
-	ath_start_ani(common);
-	ieee80211_queue_delayed_work(sc->hw, &sc->tx_complete_work, 0);
-	ath_beacon_config(sc, NULL);
 	mutex_unlock(&sc->mutex);
 }
 
-- 
1.6.4.2

