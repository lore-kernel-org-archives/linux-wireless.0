Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:46694 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbbBQJMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 04:12:23 -0500
Received: by mail-wg0-f43.google.com with SMTP id z12so20325528wgg.2
        for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2015 01:12:21 -0800 (PST)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 1/2] ath9k: add per-vif TX power capability
Date: Tue, 17 Feb 2015 10:12:17 +0100
Message-Id: <1424164338-10547-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20150217_101231_568000_345EB69D)
In-Reply-To: <1424164338-10547-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1424164338-10547-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure the HW with highest TX power among all vif when HW TPC has been
enabled in order to add support to per-vif TX power capability. Use lowest
configured power among all interfaces when TPC is disabled

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/debug.c |  5 +++-
 drivers/net/wireless/ath/ath9k/main.c  | 52 ++++++++++++++++++++++++++++------
 3 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0f8e946..7e89236 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -645,6 +645,7 @@ void ath9k_calculate_iter_data(struct ath_softc *sc,
 			       struct ath9k_vif_iter_data *iter_data);
 void ath9k_calculate_summary_state(struct ath_softc *sc,
 				   struct ath_chanctx *ctx);
+void ath9k_set_txpower(struct ath_softc *sc, struct ieee80211_vif *vif);
 
 /*******************/
 /* Beacon Handling */
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 50a2e0a..dbf8f49 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1156,7 +1156,10 @@ static ssize_t write_file_tpc(struct file *file, const char __user *user_buf,
 
 	if (tpc_enabled != ah->tpc_enabled) {
 		ah->tpc_enabled = tpc_enabled;
-		ath9k_hw_set_txpowerlimit(ah, sc->cur_chan->txpower, false);
+
+		mutex_lock(&sc->mutex);
+		ath9k_set_txpower(sc, NULL);
+		mutex_unlock(&sc->mutex);
 	}
 
 	return count;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 98b1e4a..2e2775b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1173,6 +1173,38 @@ void ath9k_calculate_summary_state(struct ath_softc *sc,
 	ath9k_ps_restore(sc);
 }
 
+static void ath9k_tpc_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
+{
+	int *power = (int *)data;
+
+	if (*power < vif->bss_conf.txpower)
+		*power = vif->bss_conf.txpower;
+}
+
+/* Called with sc->mutex held. */
+void ath9k_set_txpower(struct ath_softc *sc, struct ieee80211_vif *vif)
+{
+	int power;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_regulatory *reg = ath9k_hw_regulatory(ah);
+
+	ath9k_ps_wakeup(sc);
+	if (ah->tpc_enabled) {
+		power = (vif) ? vif->bss_conf.txpower : -1;
+		ieee80211_iterate_active_interfaces_atomic(
+				sc->hw, IEEE80211_IFACE_ITER_RESUME_ALL,
+				ath9k_tpc_vif_iter, &power);
+		if (power == -1)
+			power = sc->hw->conf.power_level;
+	} else {
+		power = sc->hw->conf.power_level;
+	}
+	sc->cur_chan->txpower = 2 * power;
+	ath9k_hw_set_txpowerlimit(ah, sc->cur_chan->txpower, false);
+	sc->cur_chan->cur_txpower = reg->max_power_level;
+	ath9k_ps_restore(sc);
+}
+
 static void ath9k_assign_hw_queues(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
@@ -1226,6 +1258,8 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	ath9k_assign_hw_queues(hw, vif);
 
+	ath9k_set_txpower(sc, vif);
+
 	an->sc = sc;
 	an->sta = NULL;
 	an->vif = vif;
@@ -1266,6 +1300,8 @@ static int ath9k_change_interface(struct ieee80211_hw *hw,
 	ath9k_assign_hw_queues(hw, vif);
 	ath9k_calculate_summary_state(sc, avp->chanctx);
 
+	ath9k_set_txpower(sc, vif);
+
 	mutex_unlock(&sc->mutex);
 	return 0;
 }
@@ -1295,6 +1331,8 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 
 	ath9k_calculate_summary_state(sc, avp->chanctx);
 
+	ath9k_set_txpower(sc, NULL);
+
 	mutex_unlock(&sc->mutex);
 }
 
@@ -1398,14 +1436,6 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		ath_chanctx_set_channel(sc, ctx, &hw->conf.chandef);
 	}
 
-	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		ath_dbg(common, CONFIG, "Set power: %d\n", conf->power_level);
-		sc->cur_chan->txpower = 2 * conf->power_level;
-		ath9k_cmn_update_txpow(ah, sc->cur_chan->cur_txpower,
-				       sc->cur_chan->txpower,
-				       &sc->cur_chan->cur_txpower);
-	}
-
 	mutex_unlock(&sc->mutex);
 	ath9k_ps_restore(sc);
 
@@ -1765,6 +1795,12 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & CHECK_ANI)
 		ath_check_ani(sc);
 
+	if (changed & BSS_CHANGED_TXPOWER) {
+		ath_dbg(common, CONFIG, "vif %pM power %d dbm power_type %d\n",
+			vif->addr, bss_conf->txpower, bss_conf->txpower_type);
+		ath9k_set_txpower(sc, vif);
+	}
+
 	mutex_unlock(&sc->mutex);
 	ath9k_ps_restore(sc);
 
-- 
2.1.0

