Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:50685 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaEUJrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 05:47:18 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] ath9k: Handle multiple keys while setting tx filters
Date: Wed, 21 May 2014 15:17:30 +0530
Message-ID: <1400665650-24320-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140521_114722_199051_28FB9E66)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The keycache index is used to abort transmission for given station
when it goes to sleep state. But the commit "ath9k_hw: Abort transmission
for sleeping station" is not handling multi-key station. Fix that.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  2 ++
 drivers/net/wireless/ath/ath9k/main.c  | 44 +++++++++++++++++++++++++---------
 2 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 20dd344..6debe32 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -274,6 +274,8 @@ struct ath_node {
 #ifdef CONFIG_ATH9K_STATION_STATISTICS
 	struct ath_rx_rate_stats rx_rate_stats;
 #endif
+	u8 key_idx[4];
+	u8 num_keys;
 };
 
 struct ath_tx_control {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 47d442a..768910b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -421,6 +421,8 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
 	an->sc = sc;
 	an->sta = sta;
 	an->vif = vif;
+	memset(&an->key_idx, 0, sizeof(an->key_idx));
+	an->num_keys = 0;
 
 	ath_tx_node_init(sc, an);
 }
@@ -1461,8 +1463,10 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 		return 0;
 
 	key = ath_key_config(common, vif, sta, &ps_key);
-	if (key > 0)
+	if (key > 0) {
 		an->ps_key = key;
+		an->key_idx[an->num_keys++] = key;
+	}
 
 	return 0;
 }
@@ -1480,6 +1484,7 @@ static void ath9k_del_ps_key(struct ath_softc *sc,
 
 	ath_key_delete(common, &ps_key);
 	an->ps_key = 0;
+	an->key_idx[--an->num_keys] = 0;
 }
 
 static int ath9k_sta_remove(struct ieee80211_hw *hw,
@@ -1494,6 +1499,16 @@ static int ath9k_sta_remove(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static inline void ath9k_sta_set_tx_filter(struct ath_hw *ah,
+					   struct ath_node *an,
+					   bool set)
+{
+	int i;
+
+	for (i = 0; i < an->num_keys; i++)
+		ath9k_hw_set_tx_filter(ah, an->key_idx[i], set);
+}
+
 static void ath9k_sta_notify(struct ieee80211_hw *hw,
 			 struct ieee80211_vif *vif,
 			 enum sta_notify_cmd cmd,
@@ -1506,12 +1521,10 @@ static void ath9k_sta_notify(struct ieee80211_hw *hw,
 	case STA_NOTIFY_SLEEP:
 		an->sleeping = true;
 		ath_tx_aggr_sleep(sta, sc, an);
-		if (an->ps_key > 0)
-			ath9k_hw_set_tx_filter(sc->sc_ah, an->ps_key, true);
+		ath9k_sta_set_tx_filter(sc->sc_ah, an, true);
 		break;
 	case STA_NOTIFY_AWAKE:
-		if (an->ps_key > 0)
-			ath9k_hw_set_tx_filter(sc->sc_ah, an->ps_key, false);
+		ath9k_sta_set_tx_filter(sc->sc_ah, an, false);
 		an->sleeping = false;
 		ath_tx_aggr_wakeup(sc, an);
 		break;
@@ -1567,7 +1580,8 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	int ret = 0;
+	struct ath_node *an = NULL;
+	int ret = 0, i;
 
 	if (ath9k_modparam_nohwcrypt)
 		return -ENOSPC;
@@ -1589,7 +1603,9 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
-	ath_dbg(common, CONFIG, "Set HW Key\n");
+	ath_dbg(common, CONFIG, "Set HW Key %d\n", cmd);
+	if (sta)
+		an = (struct ath_node *)sta->drv_priv;
 
 	switch (cmd) {
 	case SET_KEY:
@@ -1597,9 +1613,9 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 			ath9k_del_ps_key(sc, vif, sta);
 
 		ret = ath_key_config(common, vif, sta, key);
-		if (sta && (ret > 0))
-			((struct ath_node *)sta->drv_priv)->ps_key = ret;
 		if (ret >= 0) {
+			if (an && ((an->num_keys + 1) < 4))
+				an->key_idx[an->num_keys++] = ret;
 			key->hw_key_idx = ret;
 			/* push IV and Michael MIC generation to stack */
 			key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
@@ -1613,8 +1629,14 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 		break;
 	case DISABLE_KEY:
 		ath_key_delete(common, key);
-		if (sta)
-			((struct ath_node *)sta->drv_priv)->ps_key = 0;
+		if (!an)
+			break;
+		for (i = 0; i < an->num_keys; i++) {
+			if (an->key_idx[i] != key->hw_key_idx)
+				continue;
+			an->key_idx[i] = 0;
+			break;
+		}
 		break;
 	default:
 		ret = -EINVAL;
-- 
1.9.3

