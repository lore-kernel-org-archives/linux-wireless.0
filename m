Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:37908 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751080AbeETIPh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 20 May 2018 04:15:37 -0400
Received: by mail-wr0-f194.google.com with SMTP id 94-v6so13027898wrf.5
        for <linux-wireless@vger.kernel.org>; Sun, 20 May 2018 01:15:37 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC v2 03/18] mt76x2: move utility routines in mt76x2.h
Date: Sun, 20 May 2018 10:15:07 +0200
Message-Id: <20180520081522.10163-4-lorenzo.bianconi@redhat.com> (sfid-20180520_101543_068404_1CF5B44D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to reuse them supporting mt76x2u based devices, move
mt76x2_wait_for_mac, wait_for_wpdma and mt76x2_channel_silent in
mt76x2.h

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2.h      | 40 ++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c | 28 -----------------
 drivers/net/wireless/mediatek/mt76/mt76x2_phy.c  |  9 ------
 3 files changed, 40 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index a31602d9310e..ec4396583a94 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -148,6 +148,23 @@ struct mt76x2_sta {
 	int n_frames;
 };
 
+static inline bool mt76x2_wait_for_mac(struct mt76x2_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < 500; i++) {
+		switch (mt76_rr(dev, MT_MAC_CSR0)) {
+		case 0:
+		case ~0:
+			break;
+		default:
+			return true;
+		}
+		usleep_range(5000, 10000);
+	}
+	return false;
+}
+
 static inline bool is_mt7612(struct mt76x2_dev *dev)
 {
 	return mt76_chip(&dev->mt76) == 0x7612;
@@ -155,6 +172,14 @@ static inline bool is_mt7612(struct mt76x2_dev *dev)
 
 void mt76x2_set_irq_mask(struct mt76x2_dev *dev, u32 clear, u32 set);
 
+static inline bool mt76x2_channel_silent(struct mt76x2_dev *dev)
+{
+	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
+
+	return ((chan->flags & IEEE80211_CHAN_RADAR) &&
+		chan->dfs_state != NL80211_DFS_AVAILABLE);
+}
+
 static inline void mt76x2_irq_enable(struct mt76x2_dev *dev, u32 mask)
 {
 	mt76x2_set_irq_mask(dev, 0, mask);
@@ -165,6 +190,21 @@ static inline void mt76x2_irq_disable(struct mt76x2_dev *dev, u32 mask)
 	mt76x2_set_irq_mask(dev, mask, 0);
 }
 
+static inline bool mt76x2_wait_for_bbp(struct mt76x2_dev *dev)
+{
+	return mt76_poll_msec(dev, MT_MAC_STATUS,
+			      MT_MAC_STATUS_TX | MT_MAC_STATUS_RX,
+			      0, 100);
+}
+
+static inline bool wait_for_wpdma(struct mt76x2_dev *dev)
+{
+	return mt76_poll(dev, MT_WPDMA_GLO_CFG,
+			 MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
+			 MT_WPDMA_GLO_CFG_RX_DMA_BUSY,
+			 0, 1000);
+}
+
 extern const struct ieee80211_ops mt76x2_ops;
 
 struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 276c6b6bec95..0aedd507f856 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -24,34 +24,6 @@ struct mt76x2_reg_pair {
 	u32 value;
 };
 
-static bool
-mt76x2_wait_for_mac(struct mt76x2_dev *dev)
-{
-	int i;
-
-	for (i = 0; i < 500; i++) {
-		switch (mt76_rr(dev, MT_MAC_CSR0)) {
-		case 0:
-		case ~0:
-			break;
-		default:
-			return true;
-		}
-		usleep_range(5000, 10000);
-	}
-
-	return false;
-}
-
-static bool
-wait_for_wpdma(struct mt76x2_dev *dev)
-{
-	return mt76_poll(dev, MT_WPDMA_GLO_CFG,
-			 MT_WPDMA_GLO_CFG_TX_DMA_BUSY |
-			 MT_WPDMA_GLO_CFG_RX_DMA_BUSY,
-			 0, 1000);
-}
-
 static void
 mt76x2_mac_pbf_init(struct mt76x2_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
index c1c38ca3330a..62785bea7a6a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_phy.c
@@ -176,15 +176,6 @@ void mt76x2_phy_set_txpower(struct mt76x2_dev *dev)
 		mt76x2_tx_power_mask(t.ht[6], t.vht[8], t.vht[8], 0));
 }
 
-static bool
-mt76x2_channel_silent(struct mt76x2_dev *dev)
-{
-	struct ieee80211_channel *chan = dev->mt76.chandef.chan;
-
-	return ((chan->flags & IEEE80211_CHAN_RADAR) &&
-		chan->dfs_state != NL80211_DFS_AVAILABLE);
-}
-
 static bool
 mt76x2_phy_tssi_init_cal(struct mt76x2_dev *dev)
 {
-- 
2.16.3
