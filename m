Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45526 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753062AbdLNPjU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:39:20 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 03/14] mt76x2: remove some harmless WARN_ONs in tx status and rx path
Date: Thu, 14 Dec 2017 16:39:07 +0100
Message-Id: <20171214153918.43774-4-nbd@nbd.name> (sfid-20171214_163942_369681_E0DE6F0F)
In-Reply-To: <20171214153918.43774-1-nbd@nbd.name>
References: <20171214153918.43774-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Discard affected packets instead. Should reduce the frequency of bogus
bug reports

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c | 28 ++++++++++++-------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index a1f695e9b51c..f7c0df0759f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -28,7 +28,7 @@ void mt76x2_mac_set_bssid(struct mt76x2_dev *dev, u8 idx, const u8 *addr)
 		       get_unaligned_le16(addr + 4));
 }
 
-static void
+static int
 mt76x2_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
 {
 	u8 idx = FIELD_GET(MT_RXWI_RATE_INDEX, rate);
@@ -42,7 +42,7 @@ mt76x2_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
 			idx += 4;
 
 		status->rate_idx = idx;
-		return;
+		return 0;
 	case MT_PHY_TYPE_CCK:
 		if (idx >= 8) {
 			idx -= 8;
@@ -53,7 +53,7 @@ mt76x2_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
 			idx = 0;
 
 		status->rate_idx = idx;
-		return;
+		return 0;
 	case MT_PHY_TYPE_HT_GF:
 		status->enc_flags |= RX_ENC_FLAG_HT_GF;
 		/* fall through */
@@ -67,8 +67,7 @@ mt76x2_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
 		status->nss = FIELD_GET(MT_RATE_INDEX_VHT_NSS, idx) + 1;
 		break;
 	default:
-		WARN_ON(1);
-		return;
+		return -EINVAL;
 	}
 
 	if (rate & MT_RXWI_RATE_LDPC)
@@ -92,6 +91,8 @@ mt76x2_mac_process_rate(struct ieee80211_rx_status *status, u16 rate)
 	default:
 		break;
 	}
+
+	return 0;
 }
 
 static __le16
@@ -272,12 +273,10 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 	status->freq = dev->mt76.chandef.chan->center_freq;
 	status->band = dev->mt76.chandef.chan->band;
 
-	mt76x2_mac_process_rate(status, rate);
-
-	return 0;
+	return mt76x2_mac_process_rate(status, rate);
 }
 
-static void
+static int
 mt76x2_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
 			   enum nl80211_band band)
 {
@@ -293,13 +292,13 @@ mt76x2_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
 			idx += 4;
 
 		txrate->idx = idx;
-		return;
+		return 0;
 	case MT_PHY_TYPE_CCK:
 		if (idx >= 8)
 			idx -= 8;
 
 		txrate->idx = idx;
-		return;
+		return 0;
 	case MT_PHY_TYPE_HT_GF:
 		txrate->flags |= IEEE80211_TX_RC_GREEN_FIELD;
 		/* fall through */
@@ -312,8 +311,7 @@ mt76x2_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
 		txrate->idx = idx;
 		break;
 	default:
-		WARN_ON(1);
-		return;
+		return -EINVAL;
 	}
 
 	switch (FIELD_GET(MT_RXWI_RATE_BW, rate)) {
@@ -326,12 +324,14 @@ mt76x2_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
 		txrate->flags |= IEEE80211_TX_RC_80_MHZ_WIDTH;
 		break;
 	default:
-		WARN_ON(1);
+		return -EINVAL;
 		break;
 	}
 
 	if (rate & MT_RXWI_RATE_SGI)
 		txrate->flags |= IEEE80211_TX_RC_SHORT_GI;
+
+	return 0;
 }
 
 static void
-- 
2.14.2
