Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:40648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726972AbeH0SoI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Aug 2018 14:44:08 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v2 11/17] mt76: use mac_wcid_set_drop in mt76x0
Date: Mon, 27 Aug 2018 16:56:25 +0200
Message-Id: <1535381791-14908-12-git-send-email-sgruszka@redhat.com> (sfid-20180827_165713_782178_B78E2326)
In-Reply-To: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
References: <1535381791-14908-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mt76x02_mac_wcid_set_drop to common code and use it in mt76x0.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c       |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c       | 11 +++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h       |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c     |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h        |  1 -
 drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c | 11 -----------
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c       |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c         |  2 +-
 8 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 2c15c7ae12ef..a5bdd324f6ec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -175,6 +175,7 @@ mt76x0_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	msta->wcid.idx = idx;
 	msta->wcid.hw_key_idx = -1;
 	mt76x02_mac_wcid_setup(&dev->mt76, idx, mvif->idx, sta->addr);
+	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, false);
 	mt76_clear(dev, MT_WCID_DROP(idx), MT_WCID_DROP_MASK(idx));
 	rcu_assign_pointer(dev->wcid[idx], &msta->wcid);
 	mt76x0_mac_set_ampdu_factor(dev);
@@ -195,7 +196,7 @@ mt76x0_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 	mutex_lock(&dev->mt76.mutex);
 	rcu_assign_pointer(dev->wcid[idx], NULL);
-	mt76_set(dev, MT_WCID_DROP(idx), MT_WCID_DROP_MASK(idx));
+	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, true);
 	dev->wcid_mask[idx / BITS_PER_LONG] &= ~BIT(idx % BITS_PER_LONG);
 	mt76x02_mac_wcid_setup(&dev->mt76, idx, 0, NULL);
 	mt76x0_mac_set_ampdu_factor(dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 119229b2dd71..2242c0d7e200 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -119,3 +119,14 @@ void mt76x02_mac_wcid_setup(struct mt76_dev *dev, u8 idx, u8 vif_idx, u8 *mac)
 	__mt76_wr_copy(dev, MT_WCID_ADDR(idx), &addr, sizeof(addr));
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_wcid_setup);
+
+void mt76x02_mac_wcid_set_drop(struct mt76_dev *dev, u8 idx, bool drop)
+{
+	u32 val = __mt76_rr(dev, MT_WCID_DROP(idx));
+	u32 bit = MT_WCID_DROP_MASK(idx);
+
+	/* prevent unnecessary writes */
+	if ((val & bit) != (bit * drop))
+		__mt76_wr(dev, MT_WCID_DROP(idx), (val & ~bit) | (bit * drop));
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_wcid_set_drop);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 2fb8b581bf4c..7dc11cf70f7e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -47,4 +47,5 @@ int mt76x02_mac_shared_key_setup(struct mt76_dev *dev, u8 vif_idx, u8 key_idx,
 int mt76x02_mac_wcid_set_key(struct mt76_dev *dev, u8 idx,
 			    struct ieee80211_key_conf *key);
 void mt76x02_mac_wcid_setup(struct mt76_dev *dev, u8 idx, u8 vif_idx, u8 *mac);
+void mt76x02_mac_wcid_set_drop(struct mt76_dev *dev, u8 idx, bool drop);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index 706dedee8674..9ef692930d89 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -116,7 +116,7 @@ int mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	msta->wcid.idx = idx;
 	msta->wcid.hw_key_idx = -1;
 	mt76x02_mac_wcid_setup(&dev->mt76, idx, mvif->idx, sta->addr);
-	mt76x2_mac_wcid_set_drop(dev, idx, false);
+	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, false);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		mt76x2_txq_init(dev, sta->txq[i]);
 
@@ -146,7 +146,7 @@ int mt76x2_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	rcu_assign_pointer(dev->wcid[idx], NULL);
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++)
 		mt76_txq_remove(&dev->mt76, sta->txq[i]);
-	mt76x2_mac_wcid_set_drop(dev, idx, true);
+	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, true);
 	mt76_wcid_free(dev->wcid_mask, idx);
 	mt76x02_mac_wcid_setup(&dev->mt76, idx, 0, NULL);
 	mutex_unlock(&dev->mt76.mutex);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
index 1b156a04fb7f..ad22d375c847 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
@@ -170,7 +170,6 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 			   struct ieee80211_sta *sta, int len);
 void mt76x2_mac_wcid_set_rate(struct mt76x2_dev *dev, struct mt76_wcid *wcid,
 			      const struct ieee80211_tx_rate *rate);
-void mt76x2_mac_wcid_set_drop(struct mt76x2_dev *dev, u8 idx, bool drop);
 
 int mt76x2_mac_set_beacon(struct mt76x2_dev *dev, u8 vif_idx,
 			  struct sk_buff *skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index f4e72a280132..f4ae0f157aaa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -383,17 +383,6 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 }
 EXPORT_SYMBOL_GPL(mt76x2_mac_write_txwi);
 
-void mt76x2_mac_wcid_set_drop(struct mt76x2_dev *dev, u8 idx, bool drop)
-{
-	u32 val = mt76_rr(dev, MT_WCID_DROP(idx));
-	u32 bit = MT_WCID_DROP_MASK(idx);
-
-	/* prevent unnecessary writes */
-	if ((val & bit) != (bit * drop))
-		mt76_wr(dev, MT_WCID_DROP(idx), (val & ~bit) | (bit * drop));
-}
-EXPORT_SYMBOL_GPL(mt76x2_mac_wcid_set_drop);
-
 static int
 mt76x2_mac_process_rate(struct mt76_rx_status *status, u16 rate)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 577c6ee39fb8..7d2b4a419566 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -207,7 +207,7 @@ mt76x2_sta_ps(struct mt76_dev *mdev, struct ieee80211_sta *sta, bool ps)
 	int idx = msta->wcid.idx;
 
 	mt76_stop_tx_queues(&dev->mt76, sta, true);
-	mt76x2_mac_wcid_set_drop(dev, idx, ps);
+	mt76x02_mac_wcid_set_drop(&dev->mt76, idx, ps);
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
index 4c907882e8b0..6874db52b846 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
@@ -34,7 +34,7 @@ int mt76x2_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 	int ret;
 
 	if (q == &dev->mt76.q_tx[MT_TXQ_PSD] && wcid && wcid->idx < 128)
-		mt76x2_mac_wcid_set_drop(dev, wcid->idx, false);
+		mt76x02_mac_wcid_set_drop(&dev->mt76, wcid->idx, false);
 
 	mt76x2_mac_write_txwi(dev, txwi, skb, wcid, sta, skb->len);
 
-- 
2.7.5
