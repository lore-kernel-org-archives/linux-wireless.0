Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728359AbeH2PNd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 11:13:33 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v3 07/16] mt76: unify mac_shared_key_setup
Date: Wed, 29 Aug 2018 13:16:38 +0200
Message-Id: <1535541407-27149-8-git-send-email-sgruszka@redhat.com> (sfid-20180829_131712_854383_EF74DBAD)
In-Reply-To: <1535541407-27149-1-git-send-email-sgruszka@redhat.com>
References: <1535541407-27149-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge mt76x{0,2} mac_shared_key_setup into common code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    | 24 ----------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    |  2 --
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 23 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |  2 ++
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    |  3 ---
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 23 ---------------------
 9 files changed, 29 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 4b5d48246879..6d0a6fb18be9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -606,27 +606,3 @@ int mt76x0_mac_wcid_set_key(struct mt76x0_dev *dev, u8 idx,
 
 	return 0;
 }
-
-int mt76x0_mac_shared_key_setup(struct mt76x0_dev *dev, u8 vif_idx, u8 key_idx,
-			      struct ieee80211_key_conf *key)
-{
-	enum mt76x02_cipher_type cipher;
-	u8 key_data[32];
-	u32 val;
-
-	cipher = mt76x02_mac_get_key_info(key, key_data);
-	if (cipher == MT_CIPHER_NONE && key)
-		return -EINVAL;
-
-	trace_mt76x0_set_shared_key(&dev->mt76, vif_idx, key_idx);
-
-	mt76_wr_copy(dev, MT_SKEY(vif_idx, key_idx),
-			key_data, sizeof(key_data));
-
-	val = mt76_rr(dev, MT_SKEY_MODE(vif_idx));
-	val &= ~(MT_SKEY_MODE_MASK << MT_SKEY_MODE_SHIFT(vif_idx, key_idx));
-	val |= cipher << MT_SKEY_MODE_SHIFT(vif_idx, key_idx);
-	mt76_wr(dev, MT_SKEY_MODE(vif_idx), val);
-
-	return 0;
-}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
index bea067b71c13..d44ef1e9a1dd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
@@ -143,8 +143,6 @@ int mt76x0_mac_wcid_set_key(struct mt76x0_dev *dev, u8 idx,
 void mt76x0_mac_wcid_set_rate(struct mt76x0_dev *dev, struct mt76_wcid *wcid,
 			    const struct ieee80211_tx_rate *rate);
 
-int mt76x0_mac_shared_key_setup(struct mt76x0_dev *dev, u8 vif_idx, u8 key_idx,
-			      struct ieee80211_key_conf *key);
 u16 mt76x0_mac_tx_rate_val(struct mt76x0_dev *dev,
 			 const struct ieee80211_tx_rate *rate, u8 *nss_val);
 struct mt76_tx_status
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 8fc270b94819..fb31c103aeee 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -264,7 +264,7 @@ mt76x0_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 				return ret;
 		}
 
-		return mt76x0_mac_shared_key_setup(dev, mvif->idx, idx, key);
+		return mt76x02_mac_shared_key_setup(&dev->mt76, mvif->idx, idx, key);
 	}
 
 	return mt76x0_mac_wcid_set_key(dev, msta->wcid.idx, key);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 7137fd2a370e..6d45adc0522f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -44,3 +44,26 @@ mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
 	}
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_get_key_info);
+
+int mt76x02_mac_shared_key_setup(struct mt76_dev *dev, u8 vif_idx, u8 key_idx,
+				struct ieee80211_key_conf *key)
+{
+	enum mt76x02_cipher_type cipher;
+	u8 key_data[32];
+	u32 val;
+
+	cipher = mt76x02_mac_get_key_info(key, key_data);
+	if (cipher == MT_CIPHER_NONE && key)
+		return -EOPNOTSUPP;
+
+	val = __mt76_rr(dev, MT_SKEY_MODE(vif_idx));
+	val &= ~(MT_SKEY_MODE_MASK << MT_SKEY_MODE_SHIFT(vif_idx, key_idx));
+	val |= cipher << MT_SKEY_MODE_SHIFT(vif_idx, key_idx);
+	__mt76_wr(dev, MT_SKEY_MODE(vif_idx), val);
+
+	__mt76_wr_copy(dev, MT_SKEY(vif_idx, key_idx), key_data,
+		       sizeof(key_data));
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_shared_key_setup);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index e06a1ff3a77f..6f8b8a1d02cf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -42,4 +42,6 @@ static inline bool mt76x02_wait_for_mac(struct mt76_dev *dev)
 enum mt76x02_cipher_type
 mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data);
 
+int mt76x02_mac_shared_key_setup(struct mt76_dev *dev, u8 vif_idx, u8 key_idx,
+				struct ieee80211_key_conf *key);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index fe0b394fd9ea..56cceeac78d8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -16,6 +16,7 @@
  */
 
 #include "mt76x2.h"
+#include "mt76x02_mac.h"
 
 void mt76x2_txq_init(struct mt76x2_dev *dev, struct ieee80211_txq *txq)
 {
@@ -223,7 +224,7 @@ int mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 				return ret;
 		}
 
-		return mt76x2_mac_shared_key_setup(dev, mvif->idx, idx, key);
+		return mt76x02_mac_shared_key_setup(&dev->mt76, mvif->idx, idx, key);
 	}
 
 	return mt76x2_mac_wcid_set_key(dev, msta->wcid.idx, key);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 07ef0a368f1e..1c5c3552a719 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -167,7 +167,7 @@ static int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
 
 	for (i = 0; i < 16; i++)
 		for (k = 0; k < 4; k++)
-			mt76x2_mac_shared_key_setup(dev, i, k, NULL);
+			mt76x02_mac_shared_key_setup(&dev->mt76, i, k, NULL);
 
 	for (i = 0; i < 8; i++) {
 		mt76x2_mac_set_bssid(dev, i, null_addr);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
index 0f07fc1a19ab..4be2e0e64847 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
@@ -175,9 +175,6 @@ void mt76x2_mac_wcid_set_rate(struct mt76x2_dev *dev, struct mt76_wcid *wcid,
 			      const struct ieee80211_tx_rate *rate);
 void mt76x2_mac_wcid_set_drop(struct mt76x2_dev *dev, u8 idx, bool drop);
 
-int mt76x2_mac_shared_key_setup(struct mt76x2_dev *dev, u8 vif_idx, u8 key_idx,
-				struct ieee80211_key_conf *key);
-
 int mt76x2_mac_set_beacon(struct mt76x2_dev *dev, u8 vif_idx,
 			  struct sk_buff *skb);
 void mt76x2_mac_set_beacon_enable(struct mt76x2_dev *dev, u8 vif_idx, bool val);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index 92621fc5fbf8..7359ef647268 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -229,29 +229,6 @@ void mt76x2_send_tx_status(struct mt76x2_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mt76x2_send_tx_status);
 
-int mt76x2_mac_shared_key_setup(struct mt76x2_dev *dev, u8 vif_idx, u8 key_idx,
-				struct ieee80211_key_conf *key)
-{
-	enum mt76x02_cipher_type cipher;
-	u8 key_data[32];
-	u32 val;
-
-	cipher = mt76x02_mac_get_key_info(key, key_data);
-	if (cipher == MT_CIPHER_NONE && key)
-		return -EOPNOTSUPP;
-
-	val = mt76_rr(dev, MT_SKEY_MODE(vif_idx));
-	val &= ~(MT_SKEY_MODE_MASK << MT_SKEY_MODE_SHIFT(vif_idx, key_idx));
-	val |= cipher << MT_SKEY_MODE_SHIFT(vif_idx, key_idx);
-	mt76_wr(dev, MT_SKEY_MODE(vif_idx), val);
-
-	mt76_wr_copy(dev, MT_SKEY(vif_idx, key_idx), key_data,
-		     sizeof(key_data));
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mt76x2_mac_shared_key_setup);
-
 int mt76x2_mac_wcid_set_key(struct mt76x2_dev *dev, u8 idx,
 			    struct ieee80211_key_conf *key)
 {
-- 
2.7.5
