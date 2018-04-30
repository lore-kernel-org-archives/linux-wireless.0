Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:40600 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753172AbeD3OM4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 10:12:56 -0400
Received: by mail-wm0-f66.google.com with SMTP id j5so14502816wme.5
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2018 07:12:55 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC 03/18] mt76x2: move utility routines in mt76x2.h
Date: Mon, 30 Apr 2018 16:12:18 +0200
Message-Id: <ab5fd734e05a9a3d99f250a9064b5d8d0210fd02.1525096206.git.lorenzo.bianconi@redhat.com> (sfid-20180430_161259_688464_93273411)
In-Reply-To: <cover.1525096206.git.lorenzo.bianconi@redhat.com>
References: <cover.1525096206.git.lorenzo.bianconi@redhat.com>
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
index d21e4a7c1bb9..3d4d07485fab 100644
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
index 038d1fe6c726..0ce40887b19f 100644
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
2.14.3
