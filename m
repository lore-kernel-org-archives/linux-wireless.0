Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49950 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728658AbeIFNxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:53:52 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 07/42] mt76x0: introduce mt76x0_tx_prepare_skb routine
Date: Thu,  6 Sep 2018 11:18:23 +0200
Message-Id: <1536225538-16454-8-git-send-email-sgruszka@redhat.com> (sfid-20180906_112007_770548_7038D5D3)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Add mt76x0_tx_prepare_skb routine as tx txwi handler.
mt76x0_tx_prepare_skb will be used by mt76-usb layer

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  5 ++++-
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     | 15 +++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 8510f120a121..8b0bef9a15e4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -250,5 +250,8 @@ void mt76x0_dma_cleanup(struct mt76x0_dev *dev);
 
 int mt76x0_dma_enqueue_tx(struct mt76x0_dev *dev, struct sk_buff *skb,
 			   struct mt76_wcid *wcid, int hw_q);
-
+int mt76x0_tx_prepare_skb(struct mt76_dev *mdev, void *data,
+			  struct sk_buff *skb, struct mt76_queue *q,
+			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			  u32 *tx_info);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index de2643d54a1e..d6dbd9b8d68b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -116,6 +116,21 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	trace_mt76x0_tx(&dev->mt76, skb, msta, txwi);
 }
 
+int mt76x0_tx_prepare_skb(struct mt76_dev *mdev, void *data,
+			  struct sk_buff *skb, struct mt76_queue *q,
+			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
+			  u32 *tx_info)
+{
+	struct mt76x0_dev *dev = container_of(mdev, struct mt76x0_dev, mt76);
+	int len = skb->len, *hwq_ptr = (int *)data;
+	struct mt76x02_txwi *txwi;
+
+	mt76x02_insert_hdr_pad(skb);
+	txwi = mt76x0_push_txwi(dev, skb, sta, wcid, len);
+
+	return mt76x02_set_txinfo(skb, wcid, q2ep(*hwq_ptr));
+}
+
 void mt76x0_tx_stat(struct work_struct *work)
 {
 	struct mt76x0_dev *dev = container_of(work, struct mt76x0_dev,
-- 
2.7.5
