Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33560 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbaEVHFP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 03:05:15 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v3] ath9k: Handle multiple keys while setting tx filters
Date: Thu, 22 May 2014 12:35:49 +0530
Message-ID: <1400742349-13386-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140522_090522_034454_CFB4B061)
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
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/main.c  | 55 +++++++++++++++++++++++++++-------
 2 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 20dd344..b204694 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -274,6 +274,7 @@ struct ath_node {
 #ifdef CONFIG_ATH9K_STATION_STATISTICS
 	struct ath_rx_rate_stats rx_rate_stats;
 #endif
+	u8 key_idx[4];
 };
 
 struct ath_tx_control {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 47d442a..6965cea 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -421,6 +421,7 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
 	an->sc = sc;
 	an->sta = sta;
 	an->vif = vif;
+	memset(&an->key_idx, 0, sizeof(an->key_idx));
 
 	ath_tx_node_init(sc, an);
 }
@@ -1461,8 +1462,10 @@ static int ath9k_sta_add(struct ieee80211_hw *hw,
 		return 0;
 
 	key = ath_key_config(common, vif, sta, &ps_key);
-	if (key > 0)
+	if (key > 0) {
 		an->ps_key = key;
+		an->key_idx[0] = key;
+	}
 
 	return 0;
 }
@@ -1480,6 +1483,7 @@ static void ath9k_del_ps_key(struct ath_softc *sc,
 
 	ath_key_delete(common, &ps_key);
 	an->ps_key = 0;
+	an->key_idx[0] = 0;
 }
 
 static int ath9k_sta_remove(struct ieee80211_hw *hw,
@@ -1494,6 +1498,19 @@ static int ath9k_sta_remove(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static void ath9k_sta_set_tx_filter(struct ath_hw *ah,
+				    struct ath_node *an,
+				    bool set)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(an->key_idx); i++) {
+		if (!an->key_idx[i])
+			continue;
+		ath9k_hw_set_tx_filter(ah, an->key_idx[i], set);
+	}
+}
+
 static void ath9k_sta_notify(struct ieee80211_hw *hw,
 			 struct ieee80211_vif *vif,
 			 enum sta_notify_cmd cmd,
@@ -1506,12 +1523,10 @@ static void ath9k_sta_notify(struct ieee80211_hw *hw,
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
@@ -1567,7 +1582,8 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	int ret = 0;
+	struct ath_node *an = NULL;
+	int ret = 0, i;
 
 	if (ath9k_modparam_nohwcrypt)
 		return -ENOSPC;
@@ -1589,16 +1605,17 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
-	ath_dbg(common, CONFIG, "Set HW Key\n");
+	ath_dbg(common, CONFIG, "Set HW Key %d\n", cmd);
+	if (sta)
+		an = (struct ath_node *)sta->drv_priv;
 
 	switch (cmd) {
 	case SET_KEY:
 		if (sta)
 			ath9k_del_ps_key(sc, vif, sta);
 
+		key->hw_key_idx = 0;
 		ret = ath_key_config(common, vif, sta, key);
-		if (sta && (ret > 0))
-			((struct ath_node *)sta->drv_priv)->ps_key = ret;
 		if (ret >= 0) {
 			key->hw_key_idx = ret;
 			/* push IV and Michael MIC generation to stack */
@@ -1610,11 +1627,27 @@ static int ath9k_set_key(struct ieee80211_hw *hw,
 				key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
 			ret = 0;
 		}
+		if (an && key->hw_key_idx) {
+			for (i = 0; i < ARRAY_SIZE(an->key_idx); i++) {
+				if (an->key_idx[i])
+					continue;
+				an->key_idx[i] = key->hw_key_idx;
+				break;
+			}
+			WARN_ON(i == ARRAY_SIZE(an->key_idx));
+		}
 		break;
 	case DISABLE_KEY:
 		ath_key_delete(common, key);
-		if (sta)
-			((struct ath_node *)sta->drv_priv)->ps_key = 0;
+		if (an) {
+			for (i = 0; i < ARRAY_SIZE(an->key_idx); i++) {
+				if (an->key_idx[i] != key->hw_key_idx)
+					continue;
+				an->key_idx[i] = 0;
+				break;
+			}
+		}
+		key->hw_key_idx = 0;
 		break;
 	default:
 		ret = -EINVAL;
-- 
1.9.3

