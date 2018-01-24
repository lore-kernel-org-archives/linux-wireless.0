Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48652 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934032AbeAXPTU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:19:20 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 8/8] mt76: validate rx CCMP PN
Date: Wed, 24 Jan 2018 16:19:17 +0100
Message-Id: <20180124151917.70962-8-nbd@nbd.name> (sfid-20180124_161933_713573_40392955)
In-Reply-To: <20180124151917.70962-1-nbd@nbd.name>
References: <20180124151917.70962-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apparently hardware does not perform CCMP PN validation in hardware, so
we need to take care of this in the driver. This is important for
protecting against replay attacks

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c    | 51 ++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h        | 12 +++++-
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c  | 45 ++++++++++++++++-----
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c |  1 +
 5 files changed, 98 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 77f1be161009..c203e7b48c58 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -384,6 +384,27 @@ int mt76_get_survey(struct ieee80211_hw *hw, int idx,
 }
 EXPORT_SYMBOL_GPL(mt76_get_survey);
 
+void mt76_wcid_key_setup(struct mt76_dev *dev, struct mt76_wcid *wcid,
+			 struct ieee80211_key_conf *key)
+{
+	struct ieee80211_key_seq seq;
+	int i;
+
+	wcid->rx_check_pn = false;
+
+	if (!key)
+		return;
+
+	if (key->cipher == WLAN_CIPHER_SUITE_CCMP)
+		wcid->rx_check_pn = true;
+
+	for (i = 0; i < IEEE80211_NUM_TIDS; i++) {
+		ieee80211_get_key_rx_seq(key, i, &seq);
+		memcpy(wcid->rx_key_pn[i], seq.ccmp.pn, sizeof(seq.ccmp.pn));
+	}
+}
+EXPORT_SYMBOL(mt76_wcid_key_setup);
+
 static struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
@@ -410,6 +431,31 @@ static struct ieee80211_sta *mt76_rx_convert(struct sk_buff *skb)
 	return wcid_to_sta(mstat.wcid);
 }
 
+static int
+mt76_check_ccmp_pn(struct sk_buff *skb)
+{
+	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
+	struct mt76_wcid *wcid = status->wcid;
+	int ret;
+
+	if (!(status->flag & RX_FLAG_DECRYPTED))
+		return 0;
+
+	if (!wcid || !wcid->rx_check_pn)
+		return 0;
+
+	BUILD_BUG_ON(sizeof(status->iv) != sizeof(wcid->rx_key_pn[0]));
+	ret = memcmp(status->iv, wcid->rx_key_pn[status->tid],
+		     sizeof(status->iv));
+	if (ret <= 0)
+		return -EINVAL; /* replay */
+
+	memcpy(wcid->rx_key_pn[status->tid], status->iv, sizeof(status->iv));
+	status->flag |= RX_FLAG_PN_VALIDATED;
+
+	return 0;
+}
+
 void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
 		      int queue)
 {
@@ -421,6 +467,11 @@ void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
 	    napi = &dev->napi[queue];
 
 	while ((skb = __skb_dequeue(frames)) != NULL) {
+		if (mt76_check_ccmp_pn(skb)) {
+			dev_kfree_skb(skb);
+			continue;
+		}
+
 		sta = mt76_rx_convert(skb);
 		ieee80211_rx_napi(dev->hw, sta, skb, napi);
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index af98bc65c2e1..129015c9d116 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -131,6 +131,9 @@ struct mt76_wcid {
 
 	u8 sta:1;
 
+	u8 rx_check_pn;
+	u8 rx_key_pn[IEEE80211_NUM_TIDS][6];
+
 	__le16 tx_rate;
 	bool tx_rate_set;
 	u8 tx_rate_nss;
@@ -279,12 +282,14 @@ struct mt76_rx_status {
 
 	unsigned long reorder_time;
 
-	u8 aggr;
+	u8 iv[6];
+
+	u8 aggr:1;
 	u8 tid;
 	u16 seqno;
 
-	u32 flag;
 	u16 freq;
+	u32 flag;
 	u8 enc_flags;
 	u8 encoding:2, bw:3;
 	u8 rate_idx;
@@ -413,6 +418,9 @@ int mt76_rx_aggr_start(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tid,
 		       u16 ssn, u8 size);
 void mt76_rx_aggr_stop(struct mt76_dev *dev, struct mt76_wcid *wcid, u8 tid);
 
+void mt76_wcid_key_setup(struct mt76_dev *dev, struct mt76_wcid *wcid,
+			 struct ieee80211_key_conf *key);
+
 /* internal */
 void mt76_tx_free(struct mt76_dev *dev);
 void mt76_put_txwi(struct mt76_dev *dev, struct mt76_txwi_cache *t);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 1e34b578b151..1b00ae4465a2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -131,7 +131,7 @@ mt76_write_mac_initvals(struct mt76x2_dev *dev)
 		{ MT_RX_FILTR_CFG,		0x00015f97 },
 		{ MT_LEGACY_BASIC_RATE,		0x0000017f },
 		{ MT_HT_BASIC_RATE,		0x00004003 },
-		{ MT_PN_PAD_MODE,		0x00000002 },
+		{ MT_PN_PAD_MODE,		0x00000003 },
 		{ MT_TXOP_HLDR_ET,		0x00000002 },
 		{ 0xa44,			0x00000000 },
 		{ MT_HEADER_TRANS_CTRL_REG,	0x00000000 },
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index f56a8f459fe6..701e90a2858a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -257,12 +257,16 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 	txwi->len_ctl = cpu_to_le16(skb->len);
 }
 
-static void mt76x2_remove_hdr_pad(struct sk_buff *skb)
+static void mt76x2_remove_hdr_pad(struct sk_buff *skb, int len)
 {
-	int len = ieee80211_get_hdrlen_from_skb(skb);
+	int hdrlen;
 
-	memmove(skb->data + 2, skb->data, len);
-	skb_pull(skb, 2);
+	if (!len)
+		return;
+
+	hdrlen = ieee80211_get_hdrlen_from_skb(skb);
+	memmove(skb->data + len, skb->data, hdrlen);
+	skb_pull(skb, len);
 }
 
 static struct mt76_wcid *
@@ -287,28 +291,49 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 {
 	struct mt76_rx_status *status = (struct mt76_rx_status *) skb->cb;
 	struct mt76x2_rxwi *rxwi = rxi;
+	u32 rxinfo = le32_to_cpu(rxwi->rxinfo);
 	u32 ctl = le32_to_cpu(rxwi->ctl);
 	u16 rate = le16_to_cpu(rxwi->rate);
 	u16 tid_sn = le16_to_cpu(rxwi->tid_sn);
 	bool unicast = rxwi->rxinfo & cpu_to_le32(MT_RXINFO_UNICAST);
+	int pad_len = 0;
+	u8 pn_len;
 	u8 wcid;
 	int len;
 
+	if (rxinfo & MT_RXINFO_L2PAD)
+		pad_len += 2;
+
+	len = FIELD_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
+	pn_len = FIELD_GET(MT_RXINFO_PN_LEN, rxinfo);
+	if (pn_len) {
+		int offset = ieee80211_get_hdrlen_from_skb(skb) + pad_len;
+		u8 *data = skb->data + offset;
+
+		status->iv[0] = data[7];
+		status->iv[1] = data[6];
+		status->iv[2] = data[5];
+		status->iv[3] = data[4];
+		status->iv[4] = data[1];
+		status->iv[5] = data[0];
+
+		pad_len += pn_len << 2;
+		len -= pn_len << 2;
+	}
+
+	mt76x2_remove_hdr_pad(skb, pad_len);
+
 	wcid = FIELD_GET(MT_RXWI_CTL_WCID, ctl);
 	status->wcid = mt76x2_rx_get_sta_wcid(dev, wcid, unicast);
 
-	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_L2PAD))
-		mt76x2_remove_hdr_pad(skb);
-
-	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_BA))
+	if (rxinfo & MT_RXINFO_BA)
 		status->aggr = true;
 
-	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_DECRYPT)) {
+	if (rxinfo & MT_RXINFO_DECRYPT) {
 		status->flag |= RX_FLAG_DECRYPTED;
 		status->flag |= RX_FLAG_IV_STRIPPED | RX_FLAG_MMIC_STRIPPED;
 	}
 
-	len = FIELD_GET(MT_RXWI_CTL_MPDU_LEN, ctl);
 	if (WARN_ON_ONCE(len > skb->len))
 		return -EINVAL;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 08fe804c6a43..bf26284b9989 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -371,6 +371,7 @@ mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 
 		key = NULL;
 	}
+	mt76_wcid_key_setup(&dev->mt76, wcid, key);
 
 	if (!msta) {
 		if (key || wcid->hw_key_idx == idx) {
-- 
2.14.2
