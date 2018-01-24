Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48668 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934074AbeAXPTV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:19:21 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 2/8] mt76: fix TSF value in probe responses
Date: Wed, 24 Jan 2018 16:19:11 +0100
Message-Id: <20180124151917.70962-2-nbd@nbd.name> (sfid-20180124_161941_922051_60470F37)
In-Reply-To: <20180124151917.70962-1-nbd@nbd.name>
References: <20180124151917.70962-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Like beacons, probe responses need a hardware-generated TSF value. Set
the flag that causes the hw to generate it

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index a7416a01baa4..98219b971463 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -172,6 +172,7 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *rate = &info->control.rates[0];
 	struct ieee80211_key_conf *key = info->control.hw_key;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u16 rate_ht_mask = FIELD_PREP(MT_RXWI_RATE_PHY, BIT(1) | BIT(2));
 	u16 txwi_flags = 0;
 	u8 nss;
@@ -248,6 +249,10 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 				    sta->ht_cap.ampdu_density);
 	}
 
+	if (ieee80211_is_probe_resp(hdr->frame_control) ||
+	    ieee80211_is_beacon(hdr->frame_control))
+		txwi_flags |= MT_TXWI_FLAGS_TS;
+
 	txwi->flags |= cpu_to_le16(txwi_flags);
 	txwi->len_ctl = cpu_to_le16(skb->len);
 }
@@ -634,7 +639,6 @@ mt76_write_beacon(struct mt76x2_dev *dev, int offset, struct sk_buff *skb)
 		return -ENOSPC;
 
 	mt76x2_mac_write_txwi(dev, &txwi, skb, NULL, NULL);
-	txwi.flags |= cpu_to_le16(MT_TXWI_FLAGS_TS);
 
 	mt76_wr_copy(dev, offset, &txwi, sizeof(txwi));
 	offset += sizeof(txwi);
-- 
2.14.2
