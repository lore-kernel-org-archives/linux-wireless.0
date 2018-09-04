Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbeIDTIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:08:14 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 19/22] mt76: unify mac_process_rate
Date: Tue,  4 Sep 2018 16:41:12 +0200
Message-Id: <1536072075-6990-20-git-send-email-sgruszka@redhat.com> (sfid-20180904_164255_999338_D39F8AE6)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge mac_process_rate from mt76x0 and mt76x2.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    | 69 +---------------------
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 68 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |  2 +
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 69 +---------------------
 4 files changed, 72 insertions(+), 136 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index c1170d4800b4..99e2e1225d55 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -196,73 +196,6 @@ void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev)
 }
 
 static void
-mt76_mac_process_rate(struct mt76_rx_status *status, u16 rate)
-{
-	u8 idx = FIELD_GET(MT_RXWI_RATE_INDEX, rate);
-
-	switch (FIELD_GET(MT_RXWI_RATE_PHY, rate)) {
-	case MT_PHY_TYPE_OFDM:
-		if (idx >= 8)
-			idx = 0;
-
-		if (status->band == NL80211_BAND_2GHZ)
-			idx += 4;
-
-		status->rate_idx = idx;
-		return;
-	case MT_PHY_TYPE_CCK:
-		if (idx >= 8) {
-			idx -= 8;
-			status->enc_flags |= RX_ENC_FLAG_SHORTPRE;
-		}
-
-		if (idx >= 4)
-			idx = 0;
-
-		status->rate_idx = idx;
-		return;
-	case MT_PHY_TYPE_HT_GF:
-		status->enc_flags |= RX_ENC_FLAG_HT_GF;
-		/* fall through */
-	case MT_PHY_TYPE_HT:
-		status->encoding = RX_ENC_HT;
-		status->rate_idx = idx;
-		break;
-	case MT_PHY_TYPE_VHT:
-		status->encoding = RX_ENC_VHT;
-		status->rate_idx = FIELD_GET(MT_RATE_INDEX_VHT_IDX, idx);
-		status->nss = FIELD_GET(MT_RATE_INDEX_VHT_NSS, idx) + 1;
-		break;
-	default:
-		WARN_ON(1);
-		return;
-	}
-
-	if (rate & MT_RXWI_RATE_LDPC)
-		status->enc_flags |= RX_ENC_FLAG_LDPC;
-
-	if (rate & MT_RXWI_RATE_SGI)
-		status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
-
-	if (rate & MT_RXWI_RATE_STBC)
-		status->enc_flags |= 1 << RX_ENC_FLAG_STBC_SHIFT;
-
-	switch (FIELD_GET(MT_RXWI_RATE_BW, rate)) {
-	case MT_PHY_BW_20:
-		break;
-	case MT_PHY_BW_40:
-		status->bw = RATE_INFO_BW_40;
-		break;
-	case MT_PHY_BW_80:
-		status->bw = RATE_INFO_BW_80;
-		break;
-	default:
-		WARN_ON(1);
-		break;
-	}
-}
-
-static void
 mt76x0_rx_monitor_beacon(struct mt76x0_dev *dev, struct mt76x02_rxwi *rxwi,
 			  u16 rate, int rssi)
 {
@@ -303,7 +236,7 @@ u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 	status->freq = dev->mt76.chandef.chan->center_freq;
 	status->band = dev->mt76.chandef.chan->band;
 
-	mt76_mac_process_rate(status, rate);
+	mt76x02_mac_process_rate(status, rate);
 
 	spin_lock_bh(&dev->con_mon_lock);
 	if (mt76x0_rx_is_our_beacon(dev, data)) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 873e4701b403..f80290d4442a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -392,3 +392,71 @@ void mt76x02_send_tx_status(struct mt76_dev *dev,
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(mt76x02_send_tx_status);
+
+int
+mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate)
+{
+	u8 idx = FIELD_GET(MT_RXWI_RATE_INDEX, rate);
+
+	switch (FIELD_GET(MT_RXWI_RATE_PHY, rate)) {
+	case MT_PHY_TYPE_OFDM:
+		if (idx >= 8)
+			idx = 0;
+
+		if (status->band == NL80211_BAND_2GHZ)
+			idx += 4;
+
+		status->rate_idx = idx;
+		return 0;
+	case MT_PHY_TYPE_CCK:
+		if (idx >= 8) {
+			idx -= 8;
+			status->enc_flags |= RX_ENC_FLAG_SHORTPRE;
+		}
+
+		if (idx >= 4)
+			idx = 0;
+
+		status->rate_idx = idx;
+		return 0;
+	case MT_PHY_TYPE_HT_GF:
+		status->enc_flags |= RX_ENC_FLAG_HT_GF;
+		/* fall through */
+	case MT_PHY_TYPE_HT:
+		status->encoding = RX_ENC_HT;
+		status->rate_idx = idx;
+		break;
+	case MT_PHY_TYPE_VHT:
+		status->encoding = RX_ENC_VHT;
+		status->rate_idx = FIELD_GET(MT_RATE_INDEX_VHT_IDX, idx);
+		status->nss = FIELD_GET(MT_RATE_INDEX_VHT_NSS, idx) + 1;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (rate & MT_RXWI_RATE_LDPC)
+		status->enc_flags |= RX_ENC_FLAG_LDPC;
+
+	if (rate & MT_RXWI_RATE_SGI)
+		status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
+
+	if (rate & MT_RXWI_RATE_STBC)
+		status->enc_flags |= 1 << RX_ENC_FLAG_STBC_SHIFT;
+
+	switch (FIELD_GET(MT_RXWI_RATE_BW, rate)) {
+	case MT_PHY_BW_20:
+		break;
+	case MT_PHY_BW_40:
+		status->bw = RATE_INFO_BW_40;
+		break;
+	case MT_PHY_BW_80:
+		status->bw = RATE_INFO_BW_80;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_process_rate);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 4ba38f2aa24c..61dd2efb5cbc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -199,4 +199,6 @@ bool mt76x02_mac_load_tx_status(struct mt76_dev *dev,
 			       struct mt76x02_tx_status *stat);
 void mt76x02_send_tx_status(struct mt76_dev *dev,
 			   struct mt76x02_tx_status *stat, u8 *update);
+int
+mt76x02_mac_process_rate(struct mt76_rx_status *status, u16 rate);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index 1ebc3bfa9d6a..039fce3d1daa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -146,73 +146,6 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x02_txwi *txwi,
 }
 EXPORT_SYMBOL_GPL(mt76x2_mac_write_txwi);
 
-static int
-mt76x2_mac_process_rate(struct mt76_rx_status *status, u16 rate)
-{
-	u8 idx = FIELD_GET(MT_RXWI_RATE_INDEX, rate);
-
-	switch (FIELD_GET(MT_RXWI_RATE_PHY, rate)) {
-	case MT_PHY_TYPE_OFDM:
-		if (idx >= 8)
-			idx = 0;
-
-		if (status->band == NL80211_BAND_2GHZ)
-			idx += 4;
-
-		status->rate_idx = idx;
-		return 0;
-	case MT_PHY_TYPE_CCK:
-		if (idx >= 8) {
-			idx -= 8;
-			status->enc_flags |= RX_ENC_FLAG_SHORTPRE;
-		}
-
-		if (idx >= 4)
-			idx = 0;
-
-		status->rate_idx = idx;
-		return 0;
-	case MT_PHY_TYPE_HT_GF:
-		status->enc_flags |= RX_ENC_FLAG_HT_GF;
-		/* fall through */
-	case MT_PHY_TYPE_HT:
-		status->encoding = RX_ENC_HT;
-		status->rate_idx = idx;
-		break;
-	case MT_PHY_TYPE_VHT:
-		status->encoding = RX_ENC_VHT;
-		status->rate_idx = FIELD_GET(MT_RATE_INDEX_VHT_IDX, idx);
-		status->nss = FIELD_GET(MT_RATE_INDEX_VHT_NSS, idx) + 1;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (rate & MT_RXWI_RATE_LDPC)
-		status->enc_flags |= RX_ENC_FLAG_LDPC;
-
-	if (rate & MT_RXWI_RATE_SGI)
-		status->enc_flags |= RX_ENC_FLAG_SHORT_GI;
-
-	if (rate & MT_RXWI_RATE_STBC)
-		status->enc_flags |= 1 << RX_ENC_FLAG_STBC_SHIFT;
-
-	switch (FIELD_GET(MT_RXWI_RATE_BW, rate)) {
-	case MT_PHY_BW_20:
-		break;
-	case MT_PHY_BW_40:
-		status->bw = RATE_INFO_BW_40;
-		break;
-	case MT_PHY_BW_80:
-		status->bw = RATE_INFO_BW_80;
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
 static void mt76x2_remove_hdr_pad(struct sk_buff *skb, int len)
 {
 	int hdrlen;
@@ -345,6 +278,6 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 		sta->inactive_count = 0;
 	}
 
-	return mt76x2_mac_process_rate(status, rate);
+	return mt76x02_mac_process_rate(status, rate);
 }
 EXPORT_SYMBOL_GPL(mt76x2_mac_process_rx);
-- 
2.7.5
