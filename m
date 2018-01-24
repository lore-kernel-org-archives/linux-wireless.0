Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48672 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934107AbeAXPTV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:19:21 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 3/8] mt76: add an intermediate struct for rx status information
Date: Wed, 24 Jan 2018 16:19:12 +0100
Message-Id: <20180124151917.70962-3-nbd@nbd.name> (sfid-20180124_161942_553926_2BB265FD)
In-Reply-To: <20180124151917.70962-1-nbd@nbd.name>
References: <20180124151917.70962-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparation for passing in more internal rx data via skb->cb

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c   | 29 ++++++++++++++++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76.h       | 13 +++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c |  4 ++--
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 3acf0e175d71..258d2623d1bf 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -384,10 +384,37 @@ int mt76_get_survey(struct ieee80211_hw *hw, int idx,
 }
 EXPORT_SYMBOL_GPL(mt76_get_survey);
 
+static void
+mt76_rx_convert(struct sk_buff *skb)
+{
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct mt76_rx_status mstat;
+
+	mstat = *((struct mt76_rx_status *) skb->cb);
+	memset(status, 0, sizeof(*status));
+
+	status->flag = mstat.flag;
+	status->freq = mstat.freq;
+	status->enc_flags = mstat.enc_flags;
+	status->encoding = mstat.encoding;
+	status->bw = mstat.bw;
+	status->rate_idx = mstat.rate_idx;
+	status->nss = mstat.nss;
+	status->band = mstat.band;
+	status->signal = mstat.signal;
+	status->chains = mstat.chains;
+
+	BUILD_BUG_ON(sizeof(mstat) > sizeof(skb->cb));
+	BUILD_BUG_ON(sizeof(status->chain_signal) != sizeof(mstat.chain_signal));
+	memcpy(status->chain_signal, mstat.chain_signal, sizeof(mstat.chain_signal));
+}
+
 void mt76_rx_complete(struct mt76_dev *dev, enum mt76_rxq_id q)
 {
 	struct sk_buff *skb;
 
-	while ((skb = __skb_dequeue(&dev->rx_skb[q])) != NULL)
+	while ((skb = __skb_dequeue(&dev->rx_skb[q])) != NULL) {
+		mt76_rx_convert(skb);
 		ieee80211_rx_napi(dev->hw, NULL, skb, &dev->napi[q]);
+	}
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index f88d9a15210a..be4846ee4828 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -250,6 +250,19 @@ struct mt76_rate_power {
 	};
 };
 
+struct mt76_rx_status {
+	u32 flag;
+	u16 freq;
+	u8 enc_flags;
+	u8 encoding:2, bw:3;
+	u8 rate_idx;
+	u8 nss;
+	u8 band;
+	u8 signal;
+	u8 chains;
+	s8 chain_signal[IEEE80211_MAX_CHAINS];
+};
+
 #define mt76_rr(dev, ...)	(dev)->mt76.bus->rr(&((dev)->mt76), __VA_ARGS__)
 #define mt76_wr(dev, ...)	(dev)->mt76.bus->wr(&((dev)->mt76), __VA_ARGS__)
 #define mt76_rmw(dev, ...)	(dev)->mt76.bus->rmw(&((dev)->mt76), __VA_ARGS__)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index 98219b971463..2e12fc0d5c9e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -29,7 +29,7 @@ void mt76x2_mac_set_bssid(struct mt76x2_dev *dev, u8 idx, const u8 *addr)
 }
 
 static int
-mt76x2_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
+mt76x2_mac_process_rate(struct mt76_rx_status *status, u16 rate)
 {
 	u8 idx = FIELD_GET(MT_RXWI_RATE_INDEX, rate);
 
@@ -268,7 +268,7 @@ static void mt76x2_remove_hdr_pad(struct sk_buff *skb)
 int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 			  void *rxi)
 {
-	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
 	struct mt76x2_rxwi *rxwi = rxi;
 	u32 ctl = le32_to_cpu(rxwi->ctl);
 	u16 rate = le16_to_cpu(rxwi->rate);
-- 
2.14.2
