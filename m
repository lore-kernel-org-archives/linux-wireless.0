Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45518 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753192AbdLNPjU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 10:39:20 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH 04/14] mt76x2: fix transmission of encrypted management frames
Date: Thu, 14 Dec 2017 16:39:08 +0100
Message-Id: <20171214153918.43774-5-nbd@nbd.name> (sfid-20171214_163953_019545_5DAAFDFB)
In-Reply-To: <20171214153918.43774-1-nbd@nbd.name>
References: <20171214153918.43774-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hardware encryption seems to break encrypted unicast mgmt tx.
Unfortunately the hardware TXWI header does not have a bit to indicate
that a frame is software encrypted, so sw-encrypted frames need to use a
different WCID. For that to work, the CCMP PN needs to be generated in
software, which makes things a bit slower, so only do it for keys that
also need to tx management frames.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76.h        |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c  | 16 ++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c |  8 +++++++-
 drivers/net/wireless/mediatek/mt76/mt76x2_tx.c   |  6 ++++--
 4 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index aa0880bbea7f..f88d9a15210a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -129,6 +129,7 @@ struct mt76_wcid {
 	bool tx_rate_set;
 	u8 tx_rate_nss;
 	s8 max_txpwr_adj;
+	bool sw_iv;
 };
 
 struct mt76_txq {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index f7c0df0759f7..a7416a01baa4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -171,10 +171,12 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_tx_rate *rate = &info->control.rates[0];
+	struct ieee80211_key_conf *key = info->control.hw_key;
 	u16 rate_ht_mask = FIELD_PREP(MT_RXWI_RATE_PHY, BIT(1) | BIT(2));
 	u16 txwi_flags = 0;
 	u8 nss;
 	s8 txpwr_adj, max_txpwr_adj;
+	u8 ccmp_pn[8];
 
 	memset(txwi, 0, sizeof(*txwi));
 
@@ -185,6 +187,20 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 
 	txwi->pktid = 1;
 
+	if (wcid && wcid->sw_iv && key) {
+		u64 pn = atomic64_inc_return(&key->tx_pn);
+		ccmp_pn[0] = pn;
+		ccmp_pn[1] = pn >> 8;
+		ccmp_pn[2] = 0;
+		ccmp_pn[3] = 0x20 | (key->keyidx << 6);
+		ccmp_pn[4] = pn >> 16;
+		ccmp_pn[5] = pn >> 24;
+		ccmp_pn[6] = pn >> 32;
+		ccmp_pn[7] = pn >> 40;
+		txwi->iv = *((u32 *) &ccmp_pn[0]);
+		txwi->eiv = *((u32 *) &ccmp_pn[1]);
+	}
+
 	spin_lock_bh(&dev->mt76.lock);
 	if (wcid && (rate->idx < 0 || !rate->count)) {
 		txwi->rate = wcid->tx_rate;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 88fe5e0de0b9..02dd2cafa52f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -343,9 +343,15 @@ mt76x2_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	if (cmd == SET_KEY) {
 		key->hw_key_idx = wcid->idx;
 		wcid->hw_key_idx = idx;
+		if (key->flags & IEEE80211_KEY_FLAG_RX_MGMT) {
+			key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
+			wcid->sw_iv = true;
+		}
 	} else {
-		if (idx == wcid->hw_key_idx)
+		if (idx == wcid->hw_key_idx) {
 			wcid->hw_key_idx = -1;
+			wcid->sw_iv = true;
+		}
 
 		key = NULL;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
index 1a32e1fb8743..534e4bf9a34c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
@@ -36,7 +36,9 @@ void mt76x2_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 
 		msta = (struct mt76x2_sta *) control->sta->drv_priv;
 		wcid = &msta->wcid;
-	} else if (vif) {
+	}
+
+	if (vif || (!info->control.hw_key && wcid->hw_key_idx != -1)) {
 		struct mt76x2_vif *mvif;
 
 		mvif = (struct mt76x2_vif *) vif->drv_priv;
@@ -166,7 +168,7 @@ int mt76x2_tx_prepare_skb(struct mt76_dev *mdev, void *txwi,
 	*tx_info = FIELD_PREP(MT_TXD_INFO_QSEL, qsel) |
 		   MT_TXD_INFO_80211;
 
-	if (!wcid || wcid->hw_key_idx == 0xff)
+	if (!wcid || wcid->hw_key_idx == 0xff || wcid->sw_iv)
 		*tx_info |= MT_TXD_INFO_WIV;
 
 	return 0;
-- 
2.14.2
