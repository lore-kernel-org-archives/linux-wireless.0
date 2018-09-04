Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57088 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbeIDTI3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:08:29 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 22/22] mt76: partially unify filling txwi fields
Date: Tue,  4 Sep 2018 16:41:15 +0200
Message-Id: <1536072075-6990-23-git-send-email-sgruszka@redhat.com> (sfid-20180904_164318_480684_D02E7B84)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge code filing txwi fields the same way on mt76x0 and mt76x2.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     | 44 ++--------------------
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 42 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |  3 +-
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 35 +----------------
 4 files changed, 48 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index 92d06cca0266..0dab1c6528f9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -65,8 +65,6 @@ mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
 	struct ieee80211_tx_rate *rate = &info->control.rates[0];
 	struct mt76x02_txwi *txwi;
 	unsigned long flags;
-	u16 txwi_flags = 0;
-	u32 pkt_id;
 	u16 rate_ctl;
 	u8 nss;
 
@@ -86,47 +84,11 @@ mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
 	}
 	spin_unlock_irqrestore(&dev->mt76.lock, flags);
 
+	txwi->wcid = wcid->idx;
 	txwi->rate = cpu_to_le16(rate_ctl);
+	txwi->pktid = (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) ? 1 : 0;
 
-	if (info->flags & IEEE80211_TX_CTL_LDPC)
-		txwi->rate |= cpu_to_le16(MT_RXWI_RATE_LDPC);
-	if ((info->flags & IEEE80211_TX_CTL_STBC) && nss == 1)
-		txwi->rate |= cpu_to_le16(MT_RXWI_RATE_STBC);
-	if (nss > 1 && sta && sta->smps_mode == IEEE80211_SMPS_DYNAMIC)
-		txwi_flags |= MT_TXWI_FLAGS_MMPS;
-
-	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
-		txwi->ack_ctl |= MT_TXWI_ACK_CTL_REQ;
-		pkt_id = 1;
-	} else {
-		pkt_id = 0;
-	}
-
-	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
-		pkt_id |= MT_TXWI_PKTID_PROBE;
-
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
-		txwi->ack_ctl |= MT_TXWI_ACK_CTL_NSEQ;
-
-	if ((info->flags & IEEE80211_TX_CTL_AMPDU) && sta) {
-		u8 ba_size = IEEE80211_MIN_AMPDU_BUF;
-
-		ba_size <<= sta->ht_cap.ampdu_factor;
-		ba_size = min_t(int, 7, ba_size - 1);
-		if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) {
-			ba_size = 0;
-		} else {
-			txwi_flags |= MT_TXWI_FLAGS_AMPDU;
-			txwi_flags |= FIELD_PREP(MT_TXWI_FLAGS_MPDU_DENSITY,
-						 sta->ht_cap.ampdu_density);
-		}
-		txwi->ack_ctl |= FIELD_PREP(MT_TXWI_ACK_CTL_BA_WINDOW, ba_size);
-	}
-
-	txwi->wcid = wcid->idx;
-	txwi->flags |= cpu_to_le16(txwi_flags);
-	txwi->len_ctl = cpu_to_le16(pkt_len);
-	txwi->pktid = pkt_id;
+	mt76x02_mac_fill_txwi(txwi, skb, sta, pkt_len, nss);
 
 	return txwi;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index f80290d4442a..0b12299c7a41 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -156,6 +156,48 @@ void mt76x02_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq)
 }
 EXPORT_SYMBOL_GPL(mt76x02_txq_init);
 
+void mt76x02_mac_fill_txwi(struct mt76x02_txwi *txwi, struct sk_buff *skb,
+			  struct ieee80211_sta *sta, int len, u8 nss)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	u16 txwi_flags = 0;
+
+	if (info->flags & IEEE80211_TX_CTL_LDPC)
+		txwi->rate |= cpu_to_le16(MT_RXWI_RATE_LDPC);
+	if ((info->flags & IEEE80211_TX_CTL_STBC) && nss == 1)
+		txwi->rate |= cpu_to_le16(MT_RXWI_RATE_STBC);
+	if (nss > 1 && sta && sta->smps_mode == IEEE80211_SMPS_DYNAMIC)
+		txwi_flags |= MT_TXWI_FLAGS_MMPS;
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
+		txwi->ack_ctl |= MT_TXWI_ACK_CTL_REQ;
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+		txwi->ack_ctl |= MT_TXWI_ACK_CTL_NSEQ;
+	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
+		txwi->pktid |= MT_TXWI_PKTID_PROBE;
+	if ((info->flags & IEEE80211_TX_CTL_AMPDU) && sta) {
+		u8 ba_size = IEEE80211_MIN_AMPDU_BUF;
+
+		ba_size <<= sta->ht_cap.ampdu_factor;
+		ba_size = min_t(int, 63, ba_size - 1);
+		if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
+			ba_size = 0;
+		txwi->ack_ctl |= FIELD_PREP(MT_TXWI_ACK_CTL_BA_WINDOW, ba_size);
+
+		txwi_flags |= MT_TXWI_FLAGS_AMPDU |
+			 FIELD_PREP(MT_TXWI_FLAGS_MPDU_DENSITY,
+				    sta->ht_cap.ampdu_density);
+	}
+
+	if (ieee80211_is_probe_resp(hdr->frame_control) ||
+	    ieee80211_is_beacon(hdr->frame_control))
+		txwi_flags |= MT_TXWI_FLAGS_TS;
+
+	txwi->flags |= cpu_to_le16(txwi_flags);
+	txwi->len_ctl = cpu_to_le16(len);
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_fill_txwi);
+
 __le16
 mt76x02_mac_tx_rate_val(struct mt76_dev *dev,
 		       const struct ieee80211_tx_rate *rate, u8 *nss_val)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 61dd2efb5cbc..1a5da35702e6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -180,7 +180,8 @@ static inline bool mt76x02_wait_for_mac(struct mt76_dev *dev)
 }
 
 void mt76x02_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq);
-
+void mt76x02_mac_fill_txwi(struct mt76x02_txwi *txwi, struct sk_buff *skb,
+			  struct ieee80211_sta *sta, int len, u8 nss);
 enum mt76x02_cipher_type
 mt76x02_mac_get_key_info(struct ieee80211_key_conf *key, u8 *key_data);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index dbc0e3ef1258..126650742ba4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -61,9 +61,7 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x02_txwi *txwi,
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *rate = &info->control.rates[0];
 	struct ieee80211_key_conf *key = info->control.hw_key;
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u16 rate_ht_mask = FIELD_PREP(MT_RXWI_RATE_PHY, BIT(1) | BIT(2));
-	u16 txwi_flags = 0;
 	u8 nss;
 	s8 txpwr_adj, max_txpwr_adj;
 	u8 ccmp_pn[8];
@@ -112,38 +110,7 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x02_txwi *txwi,
 		 !(txwi->rate & cpu_to_le16(rate_ht_mask)))
 		txwi->txstream = 0x93;
 
-	if (info->flags & IEEE80211_TX_CTL_LDPC)
-		txwi->rate |= cpu_to_le16(MT_RXWI_RATE_LDPC);
-	if ((info->flags & IEEE80211_TX_CTL_STBC) && nss == 1)
-		txwi->rate |= cpu_to_le16(MT_RXWI_RATE_STBC);
-	if (nss > 1 && sta && sta->smps_mode == IEEE80211_SMPS_DYNAMIC)
-		txwi_flags |= MT_TXWI_FLAGS_MMPS;
-	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
-		txwi->ack_ctl |= MT_TXWI_ACK_CTL_REQ;
-	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
-		txwi->ack_ctl |= MT_TXWI_ACK_CTL_NSEQ;
-	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
-		txwi->pktid |= MT_TXWI_PKTID_PROBE;
-	if ((info->flags & IEEE80211_TX_CTL_AMPDU) && sta) {
-		u8 ba_size = IEEE80211_MIN_AMPDU_BUF;
-
-		ba_size <<= sta->ht_cap.ampdu_factor;
-		ba_size = min_t(int, 63, ba_size - 1);
-		if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
-			ba_size = 0;
-		txwi->ack_ctl |= FIELD_PREP(MT_TXWI_ACK_CTL_BA_WINDOW, ba_size);
-
-		txwi_flags |= MT_TXWI_FLAGS_AMPDU |
-			 FIELD_PREP(MT_TXWI_FLAGS_MPDU_DENSITY,
-				    sta->ht_cap.ampdu_density);
-	}
-
-	if (ieee80211_is_probe_resp(hdr->frame_control) ||
-	    ieee80211_is_beacon(hdr->frame_control))
-		txwi_flags |= MT_TXWI_FLAGS_TS;
-
-	txwi->flags |= cpu_to_le16(txwi_flags);
-	txwi->len_ctl = cpu_to_le16(len);
+	mt76x02_mac_fill_txwi(txwi, skb, sta, len, nss);
 }
 EXPORT_SYMBOL_GPL(mt76x2_mac_write_txwi);
 
-- 
2.7.5
