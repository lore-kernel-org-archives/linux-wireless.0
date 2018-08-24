Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:40974 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726860AbeHXOt7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:49:59 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 08/17] mt76: unify mac_shared_key_setup
Date: Fri, 24 Aug 2018 13:15:12 +0200
Message-Id: <1535109321-17126-9-git-send-email-sgruszka@redhat.com> (sfid-20180824_131553_010396_4A3C0193)
In-Reply-To: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
References: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge mt76x{0,2} mac_shared_key_setup into common code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    | 24 ----------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    |  2 --
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    |  3 ---
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 23 ---------------------
 drivers/net/wireless/mediatek/mt76/mt76xx_mac.c    | 23 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76xx_mac.h    |  2 ++
 9 files changed, 29 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 282796b24acb..b026fc178f89 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -606,27 +606,3 @@ int mt76x0_mac_wcid_set_key(struct mt76x0_dev *dev, u8 idx,
 
 	return 0;
 }
-
-int mt76x0_mac_shared_key_setup(struct mt76x0_dev *dev, u8 vif_idx, u8 key_idx,
-			      struct ieee80211_key_conf *key)
-{
-	enum mt76xx_cipher_type cipher;
-	u8 key_data[32];
-	u32 val;
-
-	cipher = mt76xx_mac_get_key_info(key, key_data);
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
index 5f874fbdd4e4..6fbeae7afb93 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -264,7 +264,7 @@ static int mt76x0_config(struct ieee80211_hw *hw, u32 changed)
 				return ret;
 		}
 
-		return mt76x0_mac_shared_key_setup(dev, mvif->idx, idx, key);
+		return mt76xx_mac_shared_key_setup(&dev->mt76, mvif->idx, idx, key);
 	}
 
 	return mt76x0_mac_wcid_set_key(dev, msta->wcid.idx, key);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index fe0b394fd9ea..d739f1ea1434 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -16,6 +16,7 @@
  */
 
 #include "mt76x2.h"
+#include "mt76xx_mac.h"
 
 void mt76x2_txq_init(struct mt76x2_dev *dev, struct ieee80211_txq *txq)
 {
@@ -223,7 +224,7 @@ int mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 				return ret;
 		}
 
-		return mt76x2_mac_shared_key_setup(dev, mvif->idx, idx, key);
+		return mt76xx_mac_shared_key_setup(&dev->mt76, mvif->idx, idx, key);
 	}
 
 	return mt76x2_mac_wcid_set_key(dev, msta->wcid.idx, key);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 7ea8986b7fb9..61377213257c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -167,7 +167,7 @@ static int mt76x2_mac_reset(struct mt76x2_dev *dev, bool hard)
 
 	for (i = 0; i < 16; i++)
 		for (k = 0; k < 4; k++)
-			mt76x2_mac_shared_key_setup(dev, i, k, NULL);
+			mt76xx_mac_shared_key_setup(&dev->mt76, i, k, NULL);
 
 	for (i = 0; i < 8; i++) {
 		mt76x2_mac_set_bssid(dev, i, null_addr);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
index b692208880c4..947b24718001 100644
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
index 706c9b604fc0..a4099ca34dad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -229,29 +229,6 @@ void mt76x2_send_tx_status(struct mt76x2_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mt76x2_send_tx_status);
 
-int mt76x2_mac_shared_key_setup(struct mt76x2_dev *dev, u8 vif_idx, u8 key_idx,
-				struct ieee80211_key_conf *key)
-{
-	enum mt76xx_cipher_type cipher;
-	u8 key_data[32];
-	u32 val;
-
-	cipher = mt76xx_mac_get_key_info(key, key_data);
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
diff --git a/drivers/net/wireless/mediatek/mt76/mt76xx_mac.c b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.c
index 5b00865c0b81..f10d6f9a0402 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76xx_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.c
@@ -44,3 +44,26 @@ enum mt76xx_cipher_type
 	}
 }
 EXPORT_SYMBOL_GPL(mt76xx_mac_get_key_info);
+
+int mt76xx_mac_shared_key_setup(struct mt76_dev *dev, u8 vif_idx, u8 key_idx,
+				struct ieee80211_key_conf *key)
+{
+	enum mt76xx_cipher_type cipher;
+	u8 key_data[32];
+	u32 val;
+
+	cipher = mt76xx_mac_get_key_info(key, key_data);
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
+EXPORT_SYMBOL_GPL(mt76xx_mac_shared_key_setup);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h
index 237dd13667d4..6377b31c4404 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h
@@ -42,4 +42,6 @@ static inline bool mt76xx_wait_for_mac(struct mt76_dev *dev)
 enum mt76xx_cipher_type
 mt76xx_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data);
 
+int mt76xx_mac_shared_key_setup(struct mt76_dev *dev, u8 vif_idx, u8 key_idx,
+				struct ieee80211_key_conf *key);
 #endif
-- 
1.9.3
