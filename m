Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:9948 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbbFBTLk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 15:11:40 -0400
From: Jakub Kicinski <moorray3@wp.pl>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH 2/4] mt7601u: watch out for invalid-length frames
Date: Tue,  2 Jun 2015 21:11:26 +0200
Message-Id: <1433272288-6450-2-git-send-email-moorray3@wp.pl> (sfid-20150602_211145_058945_65FEDCF9)
In-Reply-To: <1433272288-6450-1-git-send-email-moorray3@wp.pl>
References: <1433272288-6450-1-git-send-email-moorray3@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

Users of older Ralink devices report that received frames
sometimes have zero length.  Watch out for that.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 drivers/net/wireless/mediatek/mt7601u/dma.c | 14 ++++++++++++--
 drivers/net/wireless/mediatek/mt7601u/mac.c |  8 ++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index 16df67b2e62c..7217da4f1543 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -37,16 +37,20 @@ mt7601u_rx_skb_from_seg(struct mt7601u_dev *dev, struct mt7601u_rxwi *rxwi,
 			void *data, u32 seg_len, u32 truesize, struct page *p)
 {
 	struct sk_buff *skb;
-	u32 true_len;
-	int hdr_len, copy, frag;
+	u32 true_len, hdr_len = 0, copy, frag;
 
 	skb = alloc_skb(p ? 128 : seg_len, GFP_ATOMIC);
 	if (!skb)
 		return NULL;
 
 	true_len = mt76_mac_process_rx(dev, skb, data, rxwi);
+	if (!true_len || true_len > seg_len)
+		goto bad_frame;
 
 	hdr_len = ieee80211_get_hdrlen_from_buf(data, true_len);
+	if (!hdr_len)
+		goto bad_frame;
+
 	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_L2PAD)) {
 		memcpy(skb_put(skb, hdr_len), data, hdr_len);
 
@@ -69,6 +73,12 @@ mt7601u_rx_skb_from_seg(struct mt7601u_dev *dev, struct mt7601u_rxwi *rxwi,
 	}
 
 	return skb;
+
+bad_frame:
+	dev_err_ratelimited(dev->dev, "Error: incorrect frame len:%u hdr:%u\n",
+			    true_len, hdr_len);
+	dev_kfree_skb(skb);
+	return NULL;
 }
 
 static void mt7601u_rx_process_seg(struct mt7601u_dev *dev, u8 *data,
diff --git a/drivers/net/wireless/mediatek/mt7601u/mac.c b/drivers/net/wireless/mediatek/mt7601u/mac.c
index c161bcc6a7fa..7514bce1ac91 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mac.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mac.c
@@ -450,10 +450,14 @@ u32 mt76_mac_process_rx(struct mt7601u_dev *dev, struct sk_buff *skb,
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct mt7601u_rxwi *rxwi = rxi;
-	u32 ctl = le32_to_cpu(rxwi->ctl);
+	u32 len, ctl = le32_to_cpu(rxwi->ctl);
 	u16 rate = le16_to_cpu(rxwi->rate);
 	int rssi;
 
+	len = MT76_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
+	if (len < 10)
+		return 0;
+
 	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_DECRYPT)) {
 		status->flag |= RX_FLAG_DECRYPTED;
 		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
@@ -474,7 +478,7 @@ u32 mt76_mac_process_rx(struct mt7601u_dev *dev, struct sk_buff *skb,
 		dev->avg_rssi = (dev->avg_rssi * 15) / 16 + (rssi << 8);
 	spin_unlock_bh(&dev->con_mon_lock);
 
-	return MT76_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
+	return len;
 }
 
 static enum mt76_cipher_type
-- 
2.1.0

