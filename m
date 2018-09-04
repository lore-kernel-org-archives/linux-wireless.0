Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46434 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbeIDTIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:08:10 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 18/22] mt76: use mt76_rx_status in mt76x0
Date: Tue,  4 Sep 2018 16:41:11 +0200
Message-Id: <1536072075-6990-19-git-send-email-sgruszka@redhat.com> (sfid-20180904_164255_354856_A0C2D592)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make rx status processing similar to mt76x2.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c   | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt76.h       | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c | 4 ++--
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 2bc386f4387c..639cbafc1d50 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -475,7 +475,7 @@ void mt76_wcid_key_setup(struct mt76_dev *dev, struct mt76_wcid *wcid,
 }
 EXPORT_SYMBOL(mt76_wcid_key_setup);
 
-static struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb)
+struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct mt76_rx_status mstat;
@@ -500,6 +500,7 @@ static struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb)
 
 	return wcid_to_sta(mstat.wcid);
 }
+EXPORT_SYMBOL(mt76_rx_convert);
 
 static int
 mt76_check_ccmp_pn(struct sk_buff *skb)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 53d3c201e610..cdd470952004 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -572,6 +572,8 @@ void mt76_rx_aggr_stop(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tid);
 void mt76_wcid_key_setup(struct mt76_dev *dev, struct mt76_wcid *wcid,
 			 struct ieee80211_key_conf *key);
 
+struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb);
+
 /* internal */
 void mt76_tx_free(struct mt76_dev *dev);
 struct mt76_txwi_cache *mt76_get_txwi(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
index 05e577342a90..f29402861ced 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
@@ -111,6 +111,8 @@ static void mt76x0_rx_process_seg(struct mt76x0_dev *dev, u8 *data,
 	if (!skb)
 		return;
 
+	mt76_rx_convert(skb);
+
 	spin_lock(&dev->mac_lock);
 	ieee80211_rx(dev->mt76.hw, skb);
 	spin_unlock(&dev->mac_lock);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index eecb9d015d70..c1170d4800b4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -196,7 +196,7 @@ void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev)
 }
 
 static void
-mt76_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
+mt76_mac_process_rate(struct mt76_rx_status *status, u16 rate)
 {
 	u8 idx = FIELD_GET(MT_RXWI_RATE_INDEX, rate);
 
@@ -282,7 +282,7 @@ mt76x0_rx_is_our_beacon(struct mt76x0_dev *dev, u8 *data)
 u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 			u8 *data, void *rxi)
 {
-	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
+	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
 	struct mt76x02_rxwi *rxwi = rxi;
 	u32 len, ctl = le32_to_cpu(rxwi->ctl);
 	u16 rate = le16_to_cpu(rxwi->rate);
-- 
2.7.5
