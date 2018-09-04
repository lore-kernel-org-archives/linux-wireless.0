Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39304 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbeIDTHN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:07:13 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 06/22] mt76: unify set_key
Date: Tue,  4 Sep 2018 16:40:59 +0200
Message-Id: <1536072075-6990-7-git-send-email-sgruszka@redhat.com> (sfid-20180904_164201_033129_89D965F4)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge mt76x0 and mt76x2 set_key mac80211 callback.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 37 +-----------
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  | 67 ++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h  |  4 ++
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  3 -
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c | 67 ----------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c  |  2 +-
 7 files changed, 74 insertions(+), 108 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index d2e243785b67..f58c7ee332e0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -181,41 +181,6 @@ mt76x0_sw_scan_complete(struct ieee80211_hw *hw,
 				     MT_CALIBRATE_INTERVAL);
 }
 
-static int
-mt76x0_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-		struct ieee80211_vif *vif, struct ieee80211_sta *sta,
-		struct ieee80211_key_conf *key)
-{
-	struct mt76x0_dev *dev = hw->priv;
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
-	struct mt76x02_sta *msta = sta ? (struct mt76x02_sta *) sta->drv_priv : NULL;
-	struct mt76_wcid *wcid = msta ? &msta->wcid : &mvif->group_wcid;
-	int idx = key->keyidx;
-	int ret;
-
-	if (cmd == SET_KEY) {
-		key->hw_key_idx = wcid->idx;
-		wcid->hw_key_idx = idx;
-	} else {
-		if (idx == wcid->hw_key_idx)
-			wcid->hw_key_idx = -1;
-
-		key = NULL;
-	}
-
-	if (!msta) {
-		if (key || wcid->hw_key_idx == idx) {
-			ret = mt76x02_mac_wcid_set_key(&dev->mt76, wcid->idx, key);
-			if (ret)
-				return ret;
-		}
-
-		return mt76x02_mac_shared_key_setup(&dev->mt76, mvif->idx, idx, key);
-	}
-
-	return mt76x02_mac_wcid_set_key(&dev->mt76, msta->wcid.idx, key);
-}
-
 static int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 {
 	struct mt76x0_dev *dev = hw->priv;
@@ -260,7 +225,7 @@ const struct ieee80211_ops mt76x0_ops = {
 	.sta_add = mt76x02_sta_add,
 	.sta_remove = mt76x02_sta_remove,
 	.sta_notify = mt76x0_sta_notify,
-	.set_key = mt76x0_set_key,
+	.set_key = mt76x02_set_key,
 	.conf_tx = mt76x0_conf_tx,
 	.sw_scan_start = mt76x0_sw_scan,
 	.sw_scan_complete = mt76x0_sw_scan_complete,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index b3225024ac72..4375fce0606d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -177,4 +177,71 @@ int mt76x02_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76x02_ampdu_action);
 
+int mt76x02_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+		   struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+		   struct ieee80211_key_conf *key)
+{
+	struct mt76_dev *dev = hw->priv;
+	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
+	struct mt76x02_sta *msta;
+	struct mt76_wcid *wcid;
+	int idx = key->keyidx;
+	int ret;
+
+	/* fall back to sw encryption for unsupported ciphers */
+	switch (key->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+	case WLAN_CIPHER_SUITE_TKIP:
+	case WLAN_CIPHER_SUITE_CCMP:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	/*
+	 * The hardware does not support per-STA RX GTK, fall back
+	 * to software mode for these.
+	 */
+	if ((vif->type == NL80211_IFTYPE_ADHOC ||
+	     vif->type == NL80211_IFTYPE_MESH_POINT) &&
+	    (key->cipher == WLAN_CIPHER_SUITE_TKIP ||
+	     key->cipher == WLAN_CIPHER_SUITE_CCMP) &&
+	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
+		return -EOPNOTSUPP;
+
+	msta = sta ? (struct mt76x02_sta *) sta->drv_priv : NULL;
+	wcid = msta ? &msta->wcid : &mvif->group_wcid;
+
+	if (cmd == SET_KEY) {
+		key->hw_key_idx = wcid->idx;
+		wcid->hw_key_idx = idx;
+		if (key->flags & IEEE80211_KEY_FLAG_RX_MGMT) {
+			key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
+			wcid->sw_iv = true;
+		}
+	} else {
+		if (idx == wcid->hw_key_idx) {
+			wcid->hw_key_idx = -1;
+			wcid->sw_iv = true;
+		}
+
+		key = NULL;
+	}
+	mt76_wcid_key_setup(dev, wcid, key);
+
+	if (!msta) {
+		if (key || wcid->hw_key_idx == idx) {
+			ret = mt76x02_mac_wcid_set_key(dev, wcid->idx, key);
+			if (ret)
+				return ret;
+		}
+
+		return mt76x02_mac_shared_key_setup(dev, mvif->idx, idx, key);
+	}
+
+	return mt76x02_mac_wcid_set_key(dev, msta->wcid.idx, key);
+}
+EXPORT_SYMBOL_GPL(mt76x02_set_key);
+
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 245e32738eeb..31f144d7f6d5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -31,4 +31,8 @@ void mt76x02_vif_init(struct mt76_dev *dev, struct ieee80211_vif *vif,
 
 int mt76x02_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			struct ieee80211_ampdu_params *params);
+
+int mt76x02_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
+		   struct ieee80211_vif *vif, struct ieee80211_sta *sta,
+		   struct ieee80211_key_conf *key);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index b1fdf2825ad7..ada01186d3c3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -256,9 +256,6 @@ int mt76x2_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		      struct ieee80211_sta *sta);
 void mt76x2_remove_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif);
-int mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-		   struct ieee80211_vif *vif, struct ieee80211_sta *sta,
-		   struct ieee80211_key_conf *key);
 int mt76x2_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   u16 queue, const struct ieee80211_tx_queue_params *params);
 void mt76x2_txq_init(struct mt76x2_dev *dev, struct ieee80211_txq *txq);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index c458781a70aa..7f05aebf67ec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -27,73 +27,6 @@ void mt76x2_remove_interface(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL_GPL(mt76x2_remove_interface);
 
-int mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
-		   struct ieee80211_vif *vif, struct ieee80211_sta *sta,
-		   struct ieee80211_key_conf *key)
-{
-	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
-	struct mt76x02_sta *msta;
-	struct mt76_wcid *wcid;
-	int idx = key->keyidx;
-	int ret;
-
-	/* fall back to sw encryption for unsupported ciphers */
-	switch (key->cipher) {
-	case WLAN_CIPHER_SUITE_WEP40:
-	case WLAN_CIPHER_SUITE_WEP104:
-	case WLAN_CIPHER_SUITE_TKIP:
-	case WLAN_CIPHER_SUITE_CCMP:
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	/*
-	 * The hardware does not support per-STA RX GTK, fall back
-	 * to software mode for these.
-	 */
-	if ((vif->type == NL80211_IFTYPE_ADHOC ||
-	     vif->type == NL80211_IFTYPE_MESH_POINT) &&
-	    (key->cipher == WLAN_CIPHER_SUITE_TKIP ||
-	     key->cipher == WLAN_CIPHER_SUITE_CCMP) &&
-	    !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE))
-		return -EOPNOTSUPP;
-
-	msta = sta ? (struct mt76x02_sta *) sta->drv_priv : NULL;
-	wcid = msta ? &msta->wcid : &mvif->group_wcid;
-
-	if (cmd == SET_KEY) {
-		key->hw_key_idx = wcid->idx;
-		wcid->hw_key_idx = idx;
-		if (key->flags & IEEE80211_KEY_FLAG_RX_MGMT) {
-			key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
-			wcid->sw_iv = true;
-		}
-	} else {
-		if (idx == wcid->hw_key_idx) {
-			wcid->hw_key_idx = -1;
-			wcid->sw_iv = true;
-		}
-
-		key = NULL;
-	}
-	mt76_wcid_key_setup(&dev->mt76, wcid, key);
-
-	if (!msta) {
-		if (key || wcid->hw_key_idx == idx) {
-			ret = mt76x02_mac_wcid_set_key(&dev->mt76, wcid->idx, key);
-			if (ret)
-				return ret;
-		}
-
-		return mt76x02_mac_shared_key_setup(&dev->mt76, mvif->idx, idx, key);
-	}
-
-	return mt76x02_mac_wcid_set_key(&dev->mt76, msta->wcid.idx, key);
-}
-EXPORT_SYMBOL_GPL(mt76x2_set_key);
-
 int mt76x2_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   u16 queue, const struct ieee80211_tx_queue_params *params)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 137bd73c473a..143d8abed403 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -320,7 +320,7 @@ const struct ieee80211_ops mt76x2_ops = {
 	.bss_info_changed = mt76x2_bss_info_changed,
 	.sta_add = mt76x02_sta_add,
 	.sta_remove = mt76x02_sta_remove,
-	.set_key = mt76x2_set_key,
+	.set_key = mt76x02_set_key,
 	.conf_tx = mt76x2_conf_tx,
 	.sw_scan_start = mt76x2_sw_scan,
 	.sw_scan_complete = mt76x2_sw_scan_complete,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
index b358ee46a4a3..62d0eb75cac3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
@@ -167,7 +167,7 @@ const struct ieee80211_ops mt76x2u_ops = {
 	.remove_interface = mt76x2_remove_interface,
 	.sta_add = mt76x02_sta_add,
 	.sta_remove = mt76x02_sta_remove,
-	.set_key = mt76x2_set_key,
+	.set_key = mt76x02_set_key,
 	.ampdu_action = mt76x02_ampdu_action,
 	.config = mt76x2u_config,
 	.wake_tx_queue = mt76_wake_tx_queue,
-- 
2.7.5
