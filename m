Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:58104 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbeHXOuP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:50:15 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 14/17] mt76: unify sta stucture part 1
Date: Fri, 24 Aug 2018 13:15:18 +0200
Message-Id: <1535109321-17126-15-git-send-email-sgruszka@redhat.com> (sfid-20180824_131617_915990_89FA546D)
In-Reply-To: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
References: <1535109321-17126-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First part of unifying mt76xx_sta structure between mt76x0 and mt76x2.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c | 26 +---------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c  |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76xx_mac.c    | 25 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76xx_mac.h    | 21 +++++++++++++++++
 5 files changed, 49 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index fcd9b31d3c56..0b9a1f5103b5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -18,30 +18,6 @@
 #include "mt76x2.h"
 #include "mt76xx_mac.h"
 
-void mt76x2_txq_init(struct mt76x2_dev *dev, struct ieee80211_txq *txq)
-{
-	struct mt76_txq *mtxq;
-
-	if (!txq)
-		return;
-
-	mtxq = (struct mt76_txq *) txq->drv_priv;
-	if (txq->sta) {
-		struct mt76x2_sta *sta;
-
-		sta = (struct mt76x2_sta *) txq->sta->drv_priv;
-		mtxq->wcid = &sta->wcid;
-	} else {
-		struct mt76xx_vif *mvif;
-
-		mvif = (struct mt76xx_vif *) txq->vif->drv_priv;
-		mtxq->wcid = &mvif->group_wcid;
-	}
-
-	mt76_txq_init(&dev->mt76, txq);
-}
-EXPORT_SYMBOL_GPL(mt76x2_txq_init);
-
 int mt76x2_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			struct ieee80211_ampdu_params *params)
 {
@@ -118,7 +94,7 @@ int mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	mt76xx_mac_wcid_setup(&dev->mt76, idx, mvif->idx, sta->addr);
 	mt76xx_mac_wcid_set_drop(&dev->mt76, idx, false);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
-		mt76x2_txq_init(dev, sta->txq[i]);
+		mt76xx_txq_init(&dev->mt76, sta->txq[i]);
 
 	if (vif->type == NL80211_IFTYPE_AP)
 		set_bit(MT_WCID_FLAG_CHECK_PS, &msta->wcid.flags);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 6d25d8209c0b..2ed8279faf47 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -83,7 +83,7 @@
 	mvif->idx = idx;
 	mvif->group_wcid.idx = MT_VIF_WCID(idx);
 	mvif->group_wcid.hw_key_idx = -1;
-	mt76x2_txq_init(dev, vif->txq);
+	mt76xx_txq_init(&dev->mt76, vif->txq);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
index b3aa2404575c..ec439ccada01 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
@@ -58,7 +58,7 @@ static int mt76x2u_add_interface(struct ieee80211_hw *hw,
 	mvif->idx = idx;
 	mvif->group_wcid.idx = MT_VIF_WCID(idx);
 	mvif->group_wcid.hw_key_idx = -1;
-	mt76x2_txq_init(dev, vif->txq);
+	mt76xx_txq_init(&dev->mt76, vif->txq);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76xx_mac.c b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.c
index c495cdc3b9de..2f1153baf075 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76xx_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.c
@@ -17,6 +17,7 @@
 
 #include "mt76.h"
 #include "mt76xx_regs.h"
+#include "mt76xx_mac.h"
 
 enum mt76xx_cipher_type
 mt76xx_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data)
@@ -130,3 +131,27 @@ void mt76xx_mac_wcid_set_drop(struct mt76_dev *dev, u8 idx, bool drop)
 		__mt76_wr(dev, MT_WCID_DROP(idx), (val & ~bit) | (bit * drop));
 }
 EXPORT_SYMBOL_GPL(mt76xx_mac_wcid_set_drop);
+
+void mt76xx_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq)
+{
+	struct mt76_txq *mtxq;
+
+	if (!txq)
+		return;
+
+	mtxq = (struct mt76_txq *) txq->drv_priv;
+	if (txq->sta) {
+		struct mt76xx_sta *sta;
+
+		sta = (struct mt76xx_sta *) txq->sta->drv_priv;
+		mtxq->wcid = &sta->wcid;
+	} else {
+		struct mt76xx_vif *mvif;
+
+		mvif = (struct mt76xx_vif *) txq->vif->drv_priv;
+		mtxq->wcid = &mvif->group_wcid;
+	}
+
+	mt76_txq_init(dev, txq);
+}
+EXPORT_SYMBOL_GPL(mt76xx_txq_init);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h
index e110448d4f5e..8fa177f35b08 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76xx_mac.h
@@ -18,12 +18,31 @@
 #ifndef __MT76XX_MAC_H
 #define __MT76XX_MAC_H
 
+struct mt76xx_tx_status {
+	u8 valid:1;
+	u8 success:1;
+	u8 aggr:1;
+	u8 ack_req:1;
+	u8 wcid;
+	u8 pktid;
+	u8 retry;
+	u16 rate;
+} __packed __aligned(2);
+
 struct mt76xx_vif {
 	u8 idx;
 
 	struct mt76_wcid group_wcid;
 };
 
+struct mt76xx_sta {
+	struct mt76_wcid wcid; /* must be first */
+
+	struct mt76xx_vif *vif;
+	struct mt76xx_tx_status status;
+	int n_frames;
+};
+
 static inline bool mt76xx_wait_for_mac(struct mt76_dev *dev)
 {
 	const u32 MAC_CSR0 = 0x1000;
@@ -45,6 +64,8 @@ static inline bool mt76xx_wait_for_mac(struct mt76_dev *dev)
 	return false;
 }
 
+void mt76xx_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq);
+
 enum mt76xx_cipher_type
 mt76xx_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data);
 
-- 
1.9.3
