Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33124 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728036AbeIFNxi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:53:38 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 01/42] mt76x2: change mt76x2_tx_complete routine signature
Date: Thu,  6 Sep 2018 11:18:17 +0200
Message-Id: <1536225538-16454-2-git-send-email-sgruszka@redhat.com> (sfid-20180906_112024_352955_7AB438CB)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Use mt76_dev instead of mt76x2_dev in mt76x2_tx_complete signature
in order to be reused in mt76x0 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2.h           | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c       | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c | 6 +++---
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c     | 4 +---
 4 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index f275411f0e3d..9f495d4cfb6a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -215,7 +215,7 @@ int mt76x2_tx_queue_mcu(struct mt76x2_dev *dev, enum mt76_txq_id qid,
 			struct sk_buff *skb, int cmd, int seq);
 void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	       struct sk_buff *skb);
-void mt76x2_tx_complete(struct mt76x2_dev *dev, struct sk_buff *skb);
+void mt76x2_tx_complete(struct mt76_dev *dev, struct sk_buff *skb);
 int mt76x2_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 			  struct sk_buff *skb, struct mt76_queue *q,
 			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index 3bb02b55f146..db0cb4a2500b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -73,7 +73,7 @@ mt76x2_mac_queue_txdone(struct mt76x2_dev *dev, struct sk_buff *skb,
 	txi->wcid = txwi->wcid;
 	txi->pktid = txwi->pktid;
 	trace_mac_txdone_add(dev, txwi->wcid, txwi->pktid);
-	mt76x2_tx_complete(dev, skb);
+	mt76x2_tx_complete(&dev->mt76, skb);
 }
 
 void mt76x2_mac_process_tx_status_fifo(struct mt76x2_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
index 056a21b006df..663229dc269d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
@@ -117,17 +117,17 @@ void mt76x2_tx_set_txpwr_auto(struct mt76x2_dev *dev, s8 txpwr)
 }
 EXPORT_SYMBOL_GPL(mt76x2_tx_set_txpwr_auto);
 
-void mt76x2_tx_complete(struct mt76x2_dev *dev, struct sk_buff *skb)
+void mt76x2_tx_complete(struct mt76_dev *dev, struct sk_buff *skb)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
 	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
-		ieee80211_free_txskb(mt76_hw(dev), skb);
+		ieee80211_free_txskb(dev->hw, skb);
 	} else {
 		ieee80211_tx_info_clear_status(info);
 		info->status.rates[0].idx = -1;
 		info->flags |= IEEE80211_TX_STAT_ACK;
-		ieee80211_tx_status(mt76_hw(dev), skb);
+		ieee80211_tx_status(dev->hw, skb);
 	}
 }
 EXPORT_SYMBOL_GPL(mt76x2_tx_complete);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
index ed62d6243bb9..cdc2f2cd9141 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
@@ -102,9 +102,7 @@ int mt76x2u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 void mt76x2u_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
 			     struct mt76_queue_entry *e, bool flush)
 {
-	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
-
 	mt76x2u_remove_dma_hdr(e->skb);
-	mt76x2_tx_complete(dev, e->skb);
+	mt76x2_tx_complete(mdev, e->skb);
 }
 
-- 
2.7.5
