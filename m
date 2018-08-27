Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:40634 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727049AbeH0SoE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Aug 2018 14:44:04 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 09/17] mt76: unify mt76x02_mac_wcid_set_key
Date: Mon, 27 Aug 2018 16:56:23 +0200
Message-Id: <1535381791-14908-10-git-send-email-sgruszka@redhat.com> (sfid-20180827_165712_611278_D8536B8C)
In-Reply-To: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
References: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge mt76x{0,2}_mac_wcid_set_key into common code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h          |  3 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    | 41 ----------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    |  2 --
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |  4 +--
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 29 +++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c |  4 +--
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    |  2 --
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 29 ---------------
 9 files changed, 38 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 10959c4669bd..b02b4191ef37 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -423,6 +423,9 @@ struct mt76_rx_status {
 #define mt76_rmw_field(_dev, _reg, _field, _val)	\
 	mt76_rmw(_dev, _reg, _field, FIELD_PREP(_field, _val))
 
+#define __mt76_rmw_field(_dev, _reg, _field, _val)	\
+	__mt76_rmw(_dev, _reg, _field, FIELD_PREP(_field, _val))
+
 #define mt76_hw(dev) (dev)->mt76.hw
 
 bool __mt76_poll(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 6d0a6fb18be9..2fcdedd0cadc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -565,44 +565,3 @@ u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 
 	return len;
 }
-
-int mt76x0_mac_wcid_set_key(struct mt76x0_dev *dev, u8 idx,
-			  struct ieee80211_key_conf *key)
-{
-	enum mt76x02_cipher_type cipher;
-	u8 key_data[32];
-	u8 iv_data[8];
-	u32 val;
-
-	cipher = mt76x02_mac_get_key_info(key, key_data);
-	if (cipher == MT_CIPHER_NONE && key)
-		return -EINVAL;
-
-	trace_mt76x0_set_key(&dev->mt76, idx);
-
-	mt76_wr_copy(dev, MT_WCID_KEY(idx), key_data, sizeof(key_data));
-
-	memset(iv_data, 0, sizeof(iv_data));
-	if (key) {
-		iv_data[3] = key->keyidx << 6;
-		if (cipher >= MT_CIPHER_TKIP) {
-			/* Note: start with 1 to comply with spec,
-			 *	 (see comment on common/cmm_wpa.c:4291).
-			 */
-			iv_data[0] |= 1;
-			iv_data[3] |= 0x20;
-		}
-	}
-	mt76_wr_copy(dev, MT_WCID_IV(idx), iv_data, sizeof(iv_data));
-
-	val = mt76_rr(dev, MT_WCID_ATTR(idx));
-	val &= ~MT_WCID_ATTR_PKEY_MODE & ~MT_WCID_ATTR_PKEY_MODE_EXT;
-	val |= FIELD_PREP(MT_WCID_ATTR_PKEY_MODE, cipher & 7) |
-	       FIELD_PREP(MT_WCID_ATTR_PKEY_MODE_EXT, cipher >> 3);
-	val &= ~MT_WCID_ATTR_PAIRWISE;
-	val |= MT_WCID_ATTR_PAIRWISE *
-		!!(key && key->flags & IEEE80211_KEY_FLAG_PAIRWISE);
-	mt76_wr(dev, MT_WCID_ATTR(idx), val);
-
-	return 0;
-}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
index d44ef1e9a1dd..f8074c477044 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
@@ -138,8 +138,6 @@ struct mt76_txwi {
 
 u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 			u8 *data, void *rxi);
-int mt76x0_mac_wcid_set_key(struct mt76x0_dev *dev, u8 idx,
-			  struct ieee80211_key_conf *key);
 void mt76x0_mac_wcid_set_rate(struct mt76x0_dev *dev, struct mt76_wcid *wcid,
 			    const struct ieee80211_tx_rate *rate);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index fb31c103aeee..5b39f4d28072 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -259,7 +259,7 @@ mt76x0_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	if (!msta) {
 		if (key || wcid->hw_key_idx == idx) {
-			ret = mt76x0_mac_wcid_set_key(dev, wcid->idx, key);
+			ret = mt76x02_mac_wcid_set_key(&dev->mt76, wcid->idx, key);
 			if (ret)
 				return ret;
 		}
@@ -267,7 +267,7 @@ mt76x0_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return mt76x02_mac_shared_key_setup(&dev->mt76, mvif->idx, idx, key);
 	}
 
-	return mt76x0_mac_wcid_set_key(dev, msta->wcid.idx, key);
+	return mt76x02_mac_wcid_set_key(&dev->mt76, msta->wcid.idx, key);
 }
 
 static int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 6d45adc0522f..3261c510a8c8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -67,3 +67,32 @@ int mt76x02_mac_shared_key_setup(struct mt76_dev *dev, u8 vif_idx, u8 key_idx,
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_shared_key_setup);
+
+int mt76x02_mac_wcid_set_key(struct mt76_dev *dev, u8 idx,
+			    struct ieee80211_key_conf *key)
+{
+	enum mt76x02_cipher_type cipher;
+	u8 key_data[32];
+	u8 iv_data[8];
+
+	cipher = mt76x02_mac_get_key_info(key, key_data);
+	if (cipher == MT_CIPHER_NONE && key)
+		return -EOPNOTSUPP;
+
+	__mt76_wr_copy(dev, MT_WCID_KEY(idx), key_data, sizeof(key_data));
+	__mt76_rmw_field(dev, MT_WCID_ATTR(idx), MT_WCID_ATTR_PKEY_MODE, cipher);
+
+	memset(iv_data, 0, sizeof(iv_data));
+	if (key) {
+		__mt76_rmw_field(dev, MT_WCID_ATTR(idx), MT_WCID_ATTR_PAIRWISE,
+				 !!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE));
+		iv_data[3] = key->keyidx << 6;
+		if (cipher >= MT_CIPHER_TKIP)
+			iv_data[3] |= 0x20;
+	}
+
+	__mt76_wr_copy(dev, MT_WCID_IV(idx), iv_data, sizeof(iv_data));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_wcid_set_key);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 6f8b8a1d02cf..aebc7dcf7435 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -44,4 +44,6 @@ mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data);
 
 int mt76x02_mac_shared_key_setup(struct mt76_dev *dev, u8 vif_idx, u8 key_idx,
 				struct ieee80211_key_conf *key);
+int mt76x02_mac_wcid_set_key(struct mt76_dev *dev, u8 idx,
+			    struct ieee80211_key_conf *key);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index 56cceeac78d8..1de191c4f6a0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -219,7 +219,7 @@ int mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 	if (!msta) {
 		if (key || wcid->hw_key_idx == idx) {
-			ret = mt76x2_mac_wcid_set_key(dev, wcid->idx, key);
+			ret = mt76x02_mac_wcid_set_key(&dev->mt76, wcid->idx, key);
 			if (ret)
 				return ret;
 		}
@@ -227,7 +227,7 @@ int mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		return mt76x02_mac_shared_key_setup(&dev->mt76, mvif->idx, idx, key);
 	}
 
-	return mt76x2_mac_wcid_set_key(dev, msta->wcid.idx, key);
+	return mt76x02_mac_wcid_set_key(&dev->mt76, msta->wcid.idx, key);
 }
 EXPORT_SYMBOL_GPL(mt76x2_set_key);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
index 4be2e0e64847..77dd01da9bb9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
@@ -169,8 +169,6 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_sta *sta, int len);
 void mt76x2_mac_wcid_setup(struct mt76x2_dev *dev, u8 idx, u8 vif_idx, u8 *mac);
-int mt76x2_mac_wcid_set_key(struct mt76x2_dev *dev, u8 idx,
-			    struct ieee80211_key_conf *key);
 void mt76x2_mac_wcid_set_rate(struct mt76x2_dev *dev, struct mt76_wcid *wcid,
 			      const struct ieee80211_tx_rate *rate);
 void mt76x2_mac_wcid_set_drop(struct mt76x2_dev *dev, u8 idx, bool drop);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index 7359ef647268..c218434af347 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -229,35 +229,6 @@ void mt76x2_send_tx_status(struct mt76x2_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mt76x2_send_tx_status);
 
-int mt76x2_mac_wcid_set_key(struct mt76x2_dev *dev, u8 idx,
-			    struct ieee80211_key_conf *key)
-{
-	enum mt76x02_cipher_type cipher;
-	u8 key_data[32];
-	u8 iv_data[8];
-
-	cipher = mt76x02_mac_get_key_info(key, key_data);
-	if (cipher == MT_CIPHER_NONE && key)
-		return -EOPNOTSUPP;
-
-	mt76_rmw_field(dev, MT_WCID_ATTR(idx), MT_WCID_ATTR_PKEY_MODE, cipher);
-	mt76_wr_copy(dev, MT_WCID_KEY(idx), key_data, sizeof(key_data));
-
-	memset(iv_data, 0, sizeof(iv_data));
-	if (key) {
-		mt76_rmw_field(dev, MT_WCID_ATTR(idx), MT_WCID_ATTR_PAIRWISE,
-			       !!(key->flags & IEEE80211_KEY_FLAG_PAIRWISE));
-		iv_data[3] = key->keyidx << 6;
-		if (cipher >= MT_CIPHER_TKIP)
-			iv_data[3] |= 0x20;
-	}
-
-	mt76_wr_copy(dev, MT_WCID_IV(idx), iv_data, sizeof(iv_data));
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mt76x2_mac_wcid_set_key);
-
 static __le16
 mt76x2_mac_tx_rate_val(struct mt76x2_dev *dev,
 		       const struct ieee80211_tx_rate *rate, u8 *nss_val)
-- 
2.7.5
