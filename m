Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36186 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726389AbeIFNyH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 09:54:07 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 14/42] mt76x0: add mt76x0_queue_rx_skb routine
Date: Thu,  6 Sep 2018 11:18:30 +0200
Message-Id: <1536225538-16454-15-git-send-email-sgruszka@redhat.com> (sfid-20180906_111943_661628_2420B593)
In-Reply-To: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Introduce mt76x0_queue_rx_skb routine as mt76x0 driver
frame rx handler. mt76x0_queue_rx_skb will be run by mt76-usb layer
rx datapath

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h |  3 +++
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     | 15 +++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 8b0bef9a15e4..8a01efb8d499 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -245,6 +245,9 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 void mt76x0_tx_status(struct mt76x0_dev *dev, struct sk_buff *skb);
 void mt76x0_tx_stat(struct work_struct *work);
 
+void mt76x0_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
+			 struct sk_buff *skb);
+
 int mt76x0_dma_init(struct mt76x0_dev *dev);
 void mt76x0_dma_cleanup(struct mt76x0_dev *dev);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index d6dbd9b8d68b..7de739b7c46c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -131,6 +131,21 @@ int mt76x0_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 	return mt76x02_set_txinfo(skb, wcid, q2ep(*hwq_ptr));
 }
 
+void mt76x0_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
+			 struct sk_buff *skb)
+{
+	struct mt76x0_dev *dev = container_of(mdev, struct mt76x0_dev, mt76);
+	void *rxwi = skb->data;
+
+	skb_pull(skb, sizeof(struct mt76x02_rxwi));
+	if (!mt76x0_mac_process_rx(dev, skb, rxwi)) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
+	mt76_rx(&dev->mt76, q, skb);
+}
+
 void mt76x0_tx_stat(struct work_struct *work)
 {
 	struct mt76x0_dev *dev = container_of(work, struct mt76x0_dev,
-- 
2.7.5
