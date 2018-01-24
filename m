Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48648 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933840AbeAXPTU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:19:20 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 4/8] mt76: get station pointer by wcid and pass it to mac80211
Date: Wed, 24 Jan 2018 16:19:13 +0100
Message-Id: <20180124151917.70962-4-nbd@nbd.name> (sfid-20180124_161926_723640_DBD464DC)
In-Reply-To: <20180124151917.70962-1-nbd@nbd.name>
References: <20180124151917.70962-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoids the rhashtable lookup based on the MAC address inside mac80211

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c         |  4 ++++
 drivers/net/wireless/mediatek/mt76/mac80211.c    |  9 ++++++---
 drivers/net/wireless/mediatek/mt76/mt76.h        | 14 ++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c  | 13 +++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c |  1 +
 5 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index e539b3838b94..fd8bea144973 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -392,12 +392,16 @@ mt76_dma_rx_poll(struct napi_struct *napi, int budget)
 	dev = container_of(napi->dev, struct mt76_dev, napi_dev);
 	qid = napi - dev->napi;
 
+	rcu_read_lock();
+
 	do {
 		cur = mt76_dma_rx_process(dev, &dev->q_rx[qid], budget - done);
 		mt76_rx_complete(dev, qid);
 		done += cur;
 	} while (cur && done < budget);
 
+	rcu_read_unlock();
+
 	if (done < budget) {
 		napi_complete(napi);
 		dev->drv->rx_poll_complete(dev, qid);
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 258d2623d1bf..c1982211d658 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -384,7 +384,7 @@ int mt76_get_survey(struct ieee80211_hw *hw, int idx,
 }
 EXPORT_SYMBOL_GPL(mt76_get_survey);
 
-static void
+static struct ieee80211_sta *
 mt76_rx_convert(struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
@@ -407,14 +407,17 @@ mt76_rx_convert(struct sk_buff *skb)
 	BUILD_BUG_ON(sizeof(mstat) > sizeof(skb->cb));
 	BUILD_BUG_ON(sizeof(status->chain_signal) != sizeof(mstat.chain_signal));
 	memcpy(status->chain_signal, mstat.chain_signal, sizeof(mstat.chain_signal));
+
+	return wcid_to_sta(mstat.wcid);
 }
 
 void mt76_rx_complete(struct mt76_dev *dev, enum mt76_rxq_id q)
 {
+	struct ieee80211_sta *sta;
 	struct sk_buff *skb;
 
 	while ((skb = __skb_dequeue(&dev->rx_skb[q])) != NULL) {
-		mt76_rx_convert(skb);
-		ieee80211_rx_napi(dev->hw, NULL, skb, &dev->napi[q]);
+		sta = mt76_rx_convert(skb);
+		ieee80211_rx_napi(dev->hw, sta, skb, &dev->napi[q]);
 	}
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index be4846ee4828..e20c52607c66 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -125,6 +125,8 @@ struct mt76_wcid {
 	u8 idx;
 	u8 hw_key_idx;
 
+	u8 sta:1;
+
 	__le16 tx_rate;
 	bool tx_rate_set;
 	u8 tx_rate_nss;
@@ -251,6 +253,7 @@ struct mt76_rate_power {
 };
 
 struct mt76_rx_status {
+	struct mt76_wcid *wcid;
 	u32 flag;
 	u16 freq;
 	u8 enc_flags;
@@ -343,6 +346,17 @@ mtxq_to_txq(struct mt76_txq *mtxq)
 	return container_of(ptr, struct ieee80211_txq, drv_priv);
 }
 
+static inline struct ieee80211_sta *
+wcid_to_sta(struct mt76_wcid *wcid)
+{
+	void *ptr = wcid;
+
+	if (!wcid || !wcid->sta)
+		return NULL;
+
+	return container_of(ptr, struct ieee80211_sta, drv_priv);
+}
+
 int mt76_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		      struct sk_buff *skb, struct mt76_wcid *wcid,
 		      struct ieee80211_sta *sta);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index 2e12fc0d5c9e..75f2843847d0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -265,6 +265,15 @@ static void mt76x2_remove_hdr_pad(struct sk_buff *skb)
 	skb_pull(skb, 2);
 }
 
+static struct mt76_wcid *
+mt76x2_rx_get_wcid(struct mt76x2_dev *dev, u8 idx)
+{
+	if (idx >= ARRAY_SIZE(dev->wcid))
+		return NULL;
+
+	return rcu_dereference(dev->wcid[idx]);
+}
+
 int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 			  void *rxi)
 {
@@ -272,8 +281,12 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 	struct mt76x2_rxwi *rxwi = rxi;
 	u32 ctl = le32_to_cpu(rxwi->ctl);
 	u16 rate = le16_to_cpu(rxwi->rate);
+	u8 wcid;
 	int len;
 
+	wcid = FIELD_GET(MT_RXWI_CTL_WCID, ctl);
+	status->wcid = mt76x2_rx_get_wcid(dev, wcid);
+
 	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_L2PAD))
 		mt76x2_remove_hdr_pad(skb);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index aa5fbb64e218..2a1cb65c5edb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -273,6 +273,7 @@ mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		goto out;
 	}
 
+	msta->wcid.sta = 1;
 	msta->wcid.idx = idx;
 	msta->wcid.hw_key_idx = -1;
 	mt76x2_mac_wcid_setup(dev, idx, mvif->idx, sta->addr);
-- 
2.14.2
