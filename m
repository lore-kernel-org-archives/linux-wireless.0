Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39356 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbeIDTHw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:07:52 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 14/22] mt76: unify sta_rate_tbl_update and related helpers
Date: Tue,  4 Sep 2018 16:41:07 +0200
Message-Id: <1536072075-6990-15-git-send-email-sgruszka@redhat.com> (sfid-20180904_164252_882851_DA81AF88)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use common sta_rate_tbl_update on mt76x0 and mt76x2.
mt76x0 do not have support TPC (transmision power control) implmented,
msta->wcid.max_txpwr_adj is only set for mt76x2.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h          |  2 +
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    | 63 +--------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    | 59 --------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 25 +--------
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 61 ++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   | 56 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  | 21 +++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h  |  3 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  5 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c | 19 -------
 drivers/net/wireless/mediatek/mt76/mt76x2_init.c   |  1 +
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.h    | 53 ------------------
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 65 +---------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x2_tx_common.c  |  3 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c  |  2 +-
 18 files changed, 155 insertions(+), 288 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index cef3e513b8f0..53d3c201e610 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -246,6 +246,8 @@ struct mt76_driver_ops {
 
 	void (*sta_ps)(struct mt76_dev *dev, struct ieee80211_sta *sta,
 		       bool ps);
+	s8 (*get_max_txpwr_adj)(struct mt76_dev *dev,
+				const struct ieee80211_tx_rate *rate);
 };
 
 struct mt76_channel_state {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index b5bf22184a69..84fc306d2cbf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -493,6 +493,7 @@ struct mt76x0_dev *mt76x0_alloc_device(struct device *pdev)
 	dev = hw->priv;
 	dev->mt76.dev = pdev;
 	dev->mt76.hw = hw;
+	dev->mt76.drv = NULL;
 	mutex_init(&dev->usb_ctrl_mtx);
 	mutex_init(&dev->reg_atomic_mutex);
 	mutex_init(&dev->hw_atomic_mutex);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 4c4962bcca11..65b04e314621 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -116,67 +116,6 @@ mt76_mac_fill_tx_status(struct mt76x0_dev *dev, struct ieee80211_tx_info *info,
 		info->flags |= IEEE80211_TX_STAT_ACK;
 }
 
-u16 mt76x0_mac_tx_rate_val(struct mt76x0_dev *dev,
-			 const struct ieee80211_tx_rate *rate, u8 *nss_val)
-{
-	u16 rateval;
-	u8 phy, rate_idx;
-	u8 nss = 1;
-	u8 bw = 0;
-
-	if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
-		rate_idx = rate->idx;
-		nss = 1 + (rate->idx >> 4);
-		phy = MT_PHY_TYPE_VHT;
-		if (rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
-			bw = 2;
-		else if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-			bw = 1;
-	} else if (rate->flags & IEEE80211_TX_RC_MCS) {
-		rate_idx = rate->idx;
-		nss = 1 + (rate->idx >> 3);
-		phy = MT_PHY_TYPE_HT;
-		if (rate->flags & IEEE80211_TX_RC_GREEN_FIELD)
-			phy = MT_PHY_TYPE_HT_GF;
-		if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-			bw = 1;
-	} else {
-		const struct ieee80211_rate *r;
-		int band = dev->mt76.chandef.chan->band;
-		u16 val;
-
-		r = &dev->mt76.hw->wiphy->bands[band]->bitrates[rate->idx];
-		if (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
-			val = r->hw_value_short;
-		else
-			val = r->hw_value;
-
-		phy = val >> 8;
-		rate_idx = val & 0xff;
-		bw = 0;
-	}
-
-	rateval = FIELD_PREP(MT_RXWI_RATE_INDEX, rate_idx);
-	rateval |= FIELD_PREP(MT_RXWI_RATE_PHY, phy);
-	rateval |= FIELD_PREP(MT_RXWI_RATE_BW, bw);
-	if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
-		rateval |= MT_RXWI_RATE_SGI;
-
-	*nss_val = nss;
-	return cpu_to_le16(rateval);
-}
-
-void mt76x0_mac_wcid_set_rate(struct mt76x0_dev *dev, struct mt76_wcid *wcid,
-			    const struct ieee80211_tx_rate *rate)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->mt76.lock, flags);
-	wcid->tx_rate = mt76x0_mac_tx_rate_val(dev, rate, &wcid->tx_rate_nss);
-	wcid->tx_rate_set = true;
-	spin_unlock_irqrestore(&dev->mt76.lock, flags);
-}
-
 struct mt76x02_tx_status mt76x0_mac_fetch_tx_status(struct mt76x0_dev *dev)
 {
 	struct mt76x02_tx_status stat = {};
@@ -537,7 +476,7 @@ u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 	spin_lock_bh(&dev->con_mon_lock);
 	if (mt76x0_rx_is_our_beacon(dev, data)) {
 		mt76x0_rx_monitor_beacon(dev, rxwi, rate, rssi);
-	} else if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_U2M)) {
+	} else if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_UNICAST)) {
 		if (dev->avg_rssi == 0)
 			dev->avg_rssi = rssi;
 		else
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
index a6153a1ae206..aee7dc8f258e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
@@ -32,60 +32,6 @@ struct mt76x0_rxwi {
 	__le32 bbp_rxinfo[4];
 } __packed __aligned(4);
 
-#define MT_RXINFO_BA			BIT(0)
-#define MT_RXINFO_DATA			BIT(1)
-#define MT_RXINFO_NULL			BIT(2)
-#define MT_RXINFO_FRAG			BIT(3)
-#define MT_RXINFO_U2M			BIT(4)
-#define MT_RXINFO_MULTICAST		BIT(5)
-#define MT_RXINFO_BROADCAST		BIT(6)
-#define MT_RXINFO_MYBSS			BIT(7)
-#define MT_RXINFO_CRCERR		BIT(8)
-#define MT_RXINFO_ICVERR		BIT(9)
-#define MT_RXINFO_MICERR		BIT(10)
-#define MT_RXINFO_AMSDU			BIT(11)
-#define MT_RXINFO_HTC			BIT(12)
-#define MT_RXINFO_RSSI			BIT(13)
-#define MT_RXINFO_L2PAD			BIT(14)
-#define MT_RXINFO_AMPDU			BIT(15)
-#define MT_RXINFO_DECRYPT		BIT(16)
-#define MT_RXINFO_BSSIDX3		BIT(17)
-#define MT_RXINFO_WAPI_KEY		BIT(18)
-#define MT_RXINFO_PN_LEN		GENMASK(21, 19)
-#define MT_RXINFO_SW_PKT_80211		BIT(22)
-#define MT_RXINFO_TCP_SUM_BYPASS	BIT(28)
-#define MT_RXINFO_IP_SUM_BYPASS		BIT(29)
-#define MT_RXINFO_TCP_SUM_ERR		BIT(30)
-#define MT_RXINFO_IP_SUM_ERR		BIT(31)
-
-#define MT_RXWI_CTL_WCID		GENMASK(7, 0)
-#define MT_RXWI_CTL_KEY_IDX		GENMASK(9, 8)
-#define MT_RXWI_CTL_BSS_IDX		GENMASK(12, 10)
-#define MT_RXWI_CTL_UDF			GENMASK(15, 13)
-#define MT_RXWI_CTL_MPDU_LEN		GENMASK(27, 16)
-#define MT_RXWI_CTL_TID			GENMASK(31, 28)
-
-#define MT_RXWI_FRAG			GENMASK(3, 0)
-#define MT_RXWI_SN			GENMASK(15, 4)
-
-#define MT_RXWI_RATE_INDEX		GENMASK(5, 0)
-#define MT_RXWI_RATE_LDPC		BIT(6)
-#define MT_RXWI_RATE_BW			GENMASK(8, 7)
-#define MT_RXWI_RATE_SGI		BIT(9)
-#define MT_RXWI_RATE_STBC		BIT(10)
-#define MT_RXWI_RATE_LDPC_ETXBF		BIT(11)
-#define MT_RXWI_RATE_SND		BIT(12)
-#define MT_RXWI_RATE_PHY		GENMASK(15, 13)
-
-#define MT_RATE_INDEX_VHT_IDX		GENMASK(3, 0)
-#define MT_RATE_INDEX_VHT_NSS		GENMASK(5, 4)
-
-#define MT_RXWI_GAIN_RSSI_VAL		GENMASK(5, 0)
-#define MT_RXWI_GAIN_RSSI_LNA_ID	GENMASK(7, 6)
-#define MT_RXWI_ANT_AUX_LNA		BIT(7)
-
-#define MT_RXWI_EANT_ENC_ANT_ID		GENMASK(7, 0)
-
 enum mt76_phy_bandwidth {
 	MT_PHY_BW_20,
 	MT_PHY_BW_40,
@@ -138,11 +84,6 @@ struct mt76_txwi {
 
 u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 			u8 *data, void *rxi);
-void mt76x0_mac_wcid_set_rate(struct mt76x0_dev *dev, struct mt76_wcid *wcid,
-			    const struct ieee80211_tx_rate *rate);
-
-u16 mt76x0_mac_tx_rate_val(struct mt76x0_dev *dev,
-			 const struct ieee80211_tx_rate *rate, u8 *nss_val);
 struct mt76x02_tx_status
 mt76x0_mac_fetch_tx_status(struct mt76x0_dev *dev);
 void mt76x0_send_tx_status(struct mt76x0_dev *dev, struct mt76x02_tx_status *stat, u8 *update);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 809ee41e7121..a14f03b1ac54 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -156,29 +156,6 @@ static int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	return 0;
 }
 
-static void
-mt76_sta_rate_tbl_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			 struct ieee80211_sta *sta)
-{
-	struct mt76x0_dev *dev = hw->priv;
-	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
-	struct ieee80211_sta_rates *rates;
-	struct ieee80211_tx_rate rate = {};
-
-	rcu_read_lock();
-	rates = rcu_dereference(sta->rates);
-
-	if (!rates)
-		goto out;
-
-	rate.idx = rates->rate[0].idx;
-	rate.flags = rates->rate[0].flags;
-	mt76x0_mac_wcid_set_rate(dev, &msta->wcid, &rate);
-
-out:
-	rcu_read_unlock();
-}
-
 const struct ieee80211_ops mt76x0_ops = {
 	.tx = mt76x0_tx,
 	.start = mt76x0_start,
@@ -195,6 +172,6 @@ const struct ieee80211_ops mt76x0_ops = {
 	.sw_scan_start = mt76x0_sw_scan,
 	.sw_scan_complete = mt76x0_sw_scan_complete,
 	.ampdu_action = mt76x02_ampdu_action,
-	.sta_rate_tbl_update = mt76_sta_rate_tbl_update,
+	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.set_rts_threshold = mt76x0_set_rts_threshold,
 };
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index ce80763ec557..eeb298719329 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -93,7 +93,7 @@ mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
 		rate_ctl = wcid->tx_rate;
 		nss = wcid->tx_rate_nss;
 	} else {
-		rate_ctl = mt76x0_mac_tx_rate_val(dev, rate, &nss);
+		rate_ctl = mt76x02_mac_tx_rate_val(&dev->mt76, rate, &nss);
 	}
 	spin_unlock_irqrestore(&dev->mt76.lock, flags);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 67c53089229e..d67e12bd23a7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -155,3 +155,64 @@ void mt76x02_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq)
 	mt76_txq_init(dev, txq);
 }
 EXPORT_SYMBOL_GPL(mt76x02_txq_init);
+
+__le16
+mt76x02_mac_tx_rate_val(struct mt76_dev *dev,
+		       const struct ieee80211_tx_rate *rate, u8 *nss_val)
+{
+	u16 rateval;
+	u8 phy, rate_idx;
+	u8 nss = 1;
+	u8 bw = 0;
+
+	if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
+		rate_idx = rate->idx;
+		nss = 1 + (rate->idx >> 4);
+		phy = MT_PHY_TYPE_VHT;
+		if (rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+			bw = 2;
+		else if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			bw = 1;
+	} else if (rate->flags & IEEE80211_TX_RC_MCS) {
+		rate_idx = rate->idx;
+		nss = 1 + (rate->idx >> 3);
+		phy = MT_PHY_TYPE_HT;
+		if (rate->flags & IEEE80211_TX_RC_GREEN_FIELD)
+			phy = MT_PHY_TYPE_HT_GF;
+		if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
+			bw = 1;
+	} else {
+		const struct ieee80211_rate *r;
+		int band = dev->chandef.chan->band;
+		u16 val;
+
+		r = &dev->hw->wiphy->bands[band]->bitrates[rate->idx];
+		if (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
+			val = r->hw_value_short;
+		else
+			val = r->hw_value;
+
+		phy = val >> 8;
+		rate_idx = val & 0xff;
+		bw = 0;
+	}
+
+	rateval = FIELD_PREP(MT_RXWI_RATE_INDEX, rate_idx);
+	rateval |= FIELD_PREP(MT_RXWI_RATE_PHY, phy);
+	rateval |= FIELD_PREP(MT_RXWI_RATE_BW, bw);
+	if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
+		rateval |= MT_RXWI_RATE_SGI;
+
+	*nss_val = nss;
+	return cpu_to_le16(rateval);
+}
+EXPORT_SYMBOL_GPL(mt76x02_mac_tx_rate_val);
+
+void mt76x02_mac_wcid_set_rate(struct mt76_dev *dev, struct mt76_wcid *wcid,
+			      const struct ieee80211_tx_rate *rate)
+{
+	spin_lock_bh(&dev->lock);
+	wcid->tx_rate = mt76x02_mac_tx_rate_val(dev, rate, &wcid->tx_rate_nss);
+	wcid->tx_rate_set = true;
+	spin_unlock_bh(&dev->lock);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 551970da9025..fc880ffe3d8b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -53,6 +53,57 @@ struct mt76x02_sta {
 	int inactive_count;
 };
 
+#define MT_RXINFO_BA			BIT(0)
+#define MT_RXINFO_DATA			BIT(1)
+#define MT_RXINFO_NULL			BIT(2)
+#define MT_RXINFO_FRAG			BIT(3)
+#define MT_RXINFO_UNICAST		BIT(4)
+#define MT_RXINFO_MULTICAST		BIT(5)
+#define MT_RXINFO_BROADCAST		BIT(6)
+#define MT_RXINFO_MYBSS			BIT(7)
+#define MT_RXINFO_CRCERR		BIT(8)
+#define MT_RXINFO_ICVERR		BIT(9)
+#define MT_RXINFO_MICERR		BIT(10)
+#define MT_RXINFO_AMSDU			BIT(11)
+#define MT_RXINFO_HTC			BIT(12)
+#define MT_RXINFO_RSSI			BIT(13)
+#define MT_RXINFO_L2PAD			BIT(14)
+#define MT_RXINFO_AMPDU			BIT(15)
+#define MT_RXINFO_DECRYPT		BIT(16)
+#define MT_RXINFO_BSSIDX3		BIT(17)
+#define MT_RXINFO_WAPI_KEY		BIT(18)
+#define MT_RXINFO_PN_LEN		GENMASK(21, 19)
+#define MT_RXINFO_SW_FTYPE0		BIT(22)
+#define MT_RXINFO_SW_FTYPE1		BIT(23)
+#define MT_RXINFO_PROBE_RESP		BIT(24)
+#define MT_RXINFO_BEACON		BIT(25)
+#define MT_RXINFO_DISASSOC		BIT(26)
+#define MT_RXINFO_DEAUTH		BIT(27)
+#define MT_RXINFO_ACTION		BIT(28)
+#define MT_RXINFO_TCP_SUM_ERR		BIT(30)
+#define MT_RXINFO_IP_SUM_ERR		BIT(31)
+
+#define MT_RXWI_CTL_WCID		GENMASK(7, 0)
+#define MT_RXWI_CTL_KEY_IDX		GENMASK(9, 8)
+#define MT_RXWI_CTL_BSS_IDX		GENMASK(12, 10)
+#define MT_RXWI_CTL_UDF			GENMASK(15, 13)
+#define MT_RXWI_CTL_MPDU_LEN		GENMASK(29, 16)
+#define MT_RXWI_CTL_EOF			BIT(31)
+
+#define MT_RXWI_TID			GENMASK(3, 0)
+#define MT_RXWI_SN			GENMASK(15, 4)
+
+#define MT_RXWI_RATE_INDEX		GENMASK(5, 0)
+#define MT_RXWI_RATE_LDPC		BIT(6)
+#define MT_RXWI_RATE_BW			GENMASK(8, 7)
+#define MT_RXWI_RATE_SGI		BIT(9)
+#define MT_RXWI_RATE_STBC		BIT(10)
+#define MT_RXWI_RATE_LDPC_EXSYM		BIT(11)
+#define MT_RXWI_RATE_PHY		GENMASK(15, 13)
+
+#define MT_RATE_INDEX_VHT_IDX		GENMASK(3, 0)
+#define MT_RATE_INDEX_VHT_NSS		GENMASK(5, 4)
+
 static inline bool mt76x02_wait_for_mac(struct mt76_dev *dev)
 {
 	const u32 MAC_CSR0 = 0x1000;
@@ -85,4 +136,9 @@ int mt76x02_mac_wcid_set_key(struct mt76_dev *dev, u8 idx,
 			    struct ieee80211_key_conf *key);
 void mt76x02_mac_wcid_setup(struct mt76_dev *dev, u8 idx, u8 vif_idx, u8 *mac);
 void mt76x02_mac_wcid_set_drop(struct mt76_dev *dev, u8 idx, bool drop);
+void mt76x02_mac_wcid_set_rate(struct mt76_dev *dev, struct mt76_wcid *wcid,
+			      const struct ieee80211_tx_rate *rate);
+__le16
+mt76x02_mac_tx_rate_val(struct mt76_dev *dev,
+		       const struct ieee80211_tx_rate *rate, u8 *nss_val);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 04cd4dc394d5..e98bd874b4d0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -327,4 +327,25 @@ int mt76x02_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76x02_conf_tx);
 
+void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta)
+{
+	struct mt76_dev *dev = hw->priv;
+	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
+	struct ieee80211_sta_rates *rates = rcu_dereference(sta->rates);
+	struct ieee80211_tx_rate rate = {};
+
+	if (!rates)
+		return;
+
+	rate.idx = rates->rate[0].idx;
+	rate.flags = rates->rate[0].flags;
+	mt76x02_mac_wcid_set_rate(dev, &msta->wcid, &rate);
+
+	if (dev->drv && dev->drv->get_max_txpwr_adj)
+		msta->wcid.max_txpwr_adj = dev->drv->get_max_txpwr_adj(dev, &rate);
+}
+EXPORT_SYMBOL_GPL(mt76x02_sta_rate_tbl_update);
+
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index f8890ab7b04e..cff3c8f6393c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -40,4 +40,7 @@ int mt76x02_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		   struct ieee80211_key_conf *key);
 int mt76x02_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   u16 queue, const struct ieee80211_tx_queue_params *params);
+void mt76x02_sta_rate_tbl_update(struct ieee80211_hw *hw,
+				struct ieee80211_vif *vif,
+				struct ieee80211_sta *sta);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index ada01186d3c3..faf830585515 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -234,7 +234,7 @@ void mt76x2_sta_ps(struct mt76_dev *dev, struct ieee80211_sta *sta, bool ps);
 
 void mt76x2_update_channel(struct mt76_dev *mdev);
 
-s8 mt76x2_tx_get_max_txpwr_adj(struct mt76x2_dev *dev,
+s8 mt76x2_tx_get_max_txpwr_adj(struct mt76_dev *dev,
 			       const struct ieee80211_tx_rate *rate);
 s8 mt76x2_tx_get_txpwr_adj(struct mt76x2_dev *dev, s8 txpwr, s8 max_txpwr_adj);
 void mt76x2_tx_set_txpwr_auto(struct mt76x2_dev *dev, s8 txpwr);
@@ -259,9 +259,6 @@ void mt76x2_remove_interface(struct ieee80211_hw *hw,
 int mt76x2_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   u16 queue, const struct ieee80211_tx_queue_params *params);
 void mt76x2_txq_init(struct mt76x2_dev *dev, struct ieee80211_txq *txq);
-void mt76x2_sta_rate_tbl_update(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
-				struct ieee80211_sta *sta);
 
 void mt76x2_phy_set_txpower_regs(struct mt76x2_dev *dev,
 				 enum nl80211_band band);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index be4e00fe7586..2db67f7a4bec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -18,25 +18,6 @@
 #include "mt76x2.h"
 #include "mt76x02_mac.h"
 
-void mt76x2_sta_rate_tbl_update(struct ieee80211_hw *hw,
-				struct ieee80211_vif *vif,
-				struct ieee80211_sta *sta)
-{
-	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
-	struct ieee80211_sta_rates *rates = rcu_dereference(sta->rates);
-	struct ieee80211_tx_rate rate = {};
-
-	if (!rates)
-		return;
-
-	rate.idx = rates->rate[0].idx;
-	rate.flags = rates->rate[0].flags;
-	mt76x2_mac_wcid_set_rate(dev, &msta->wcid, &rate);
-	msta->wcid.max_txpwr_adj = mt76x2_tx_get_max_txpwr_adj(dev, &rate);
-}
-EXPORT_SYMBOL_GPL(mt76x2_sta_rate_tbl_update);
-
 void mt76x2_queue_rx_skb(struct mt76_dev *mdev, enum mt76_rxq_id q,
 			 struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
index 1f397c5e64a3..e59af314712c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_init.c
@@ -424,6 +424,7 @@ struct mt76x2_dev *mt76x2_alloc_device(struct device *pdev)
 		.rx_skb = mt76x2_queue_rx_skb,
 		.rx_poll_complete = mt76x2_rx_poll_complete,
 		.sta_ps = mt76x2_sta_ps,
+		.get_max_txpwr_adj = mt76x2_tx_get_max_txpwr_adj,
 	};
 	struct mt76x2_dev *dev;
 	struct mt76_dev *mdev;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
index 14089e8e5a02..62cb34f4f362 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.h
@@ -47,57 +47,6 @@ struct mt76x2_rxwi {
 	__le32 bbp_rxinfo[4];
 };
 
-#define MT_RXINFO_BA			BIT(0)
-#define MT_RXINFO_DATA			BIT(1)
-#define MT_RXINFO_NULL			BIT(2)
-#define MT_RXINFO_FRAG			BIT(3)
-#define MT_RXINFO_UNICAST		BIT(4)
-#define MT_RXINFO_MULTICAST		BIT(5)
-#define MT_RXINFO_BROADCAST		BIT(6)
-#define MT_RXINFO_MYBSS			BIT(7)
-#define MT_RXINFO_CRCERR		BIT(8)
-#define MT_RXINFO_ICVERR		BIT(9)
-#define MT_RXINFO_MICERR		BIT(10)
-#define MT_RXINFO_AMSDU			BIT(11)
-#define MT_RXINFO_HTC			BIT(12)
-#define MT_RXINFO_RSSI			BIT(13)
-#define MT_RXINFO_L2PAD			BIT(14)
-#define MT_RXINFO_AMPDU			BIT(15)
-#define MT_RXINFO_DECRYPT		BIT(16)
-#define MT_RXINFO_BSSIDX3		BIT(17)
-#define MT_RXINFO_WAPI_KEY		BIT(18)
-#define MT_RXINFO_PN_LEN		GENMASK(21, 19)
-#define MT_RXINFO_SW_FTYPE0		BIT(22)
-#define MT_RXINFO_SW_FTYPE1		BIT(23)
-#define MT_RXINFO_PROBE_RESP		BIT(24)
-#define MT_RXINFO_BEACON		BIT(25)
-#define MT_RXINFO_DISASSOC		BIT(26)
-#define MT_RXINFO_DEAUTH		BIT(27)
-#define MT_RXINFO_ACTION		BIT(28)
-#define MT_RXINFO_TCP_SUM_ERR		BIT(30)
-#define MT_RXINFO_IP_SUM_ERR		BIT(31)
-
-#define MT_RXWI_CTL_WCID		GENMASK(7, 0)
-#define MT_RXWI_CTL_KEY_IDX		GENMASK(9, 8)
-#define MT_RXWI_CTL_BSS_IDX		GENMASK(12, 10)
-#define MT_RXWI_CTL_UDF			GENMASK(15, 13)
-#define MT_RXWI_CTL_MPDU_LEN		GENMASK(29, 16)
-#define MT_RXWI_CTL_EOF			BIT(31)
-
-#define MT_RXWI_TID			GENMASK(3, 0)
-#define MT_RXWI_SN			GENMASK(15, 4)
-
-#define MT_RXWI_RATE_INDEX		GENMASK(5, 0)
-#define MT_RXWI_RATE_LDPC		BIT(6)
-#define MT_RXWI_RATE_BW			GENMASK(8, 7)
-#define MT_RXWI_RATE_SGI		BIT(9)
-#define MT_RXWI_RATE_STBC		BIT(10)
-#define MT_RXWI_RATE_LDPC_EXSYM		BIT(11)
-#define MT_RXWI_RATE_PHY		GENMASK(15, 13)
-
-#define MT_RATE_INDEX_VHT_IDX		GENMASK(3, 0)
-#define MT_RATE_INDEX_VHT_NSS		GENMASK(5, 4)
-
 #define MT_TX_PWR_ADJ			GENMASK(3, 0)
 
 enum mt76x2_phy_bandwidth {
@@ -157,8 +106,6 @@ int mt76x2_mac_process_rx(struct mt76x2_dev *dev, struct sk_buff *skb,
 void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_sta *sta, int len);
-void mt76x2_mac_wcid_set_rate(struct mt76x2_dev *dev, struct mt76_wcid *wcid,
-			      const struct ieee80211_tx_rate *rate);
 
 int mt76x2_mac_set_beacon(struct mt76x2_dev *dev, u8 vif_idx,
 			  struct sk_buff *skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index ec2326cd724b..85671244fdf9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -229,67 +229,6 @@ void mt76x2_send_tx_status(struct mt76x2_dev *dev,
 }
 EXPORT_SYMBOL_GPL(mt76x2_send_tx_status);
 
-static __le16
-mt76x2_mac_tx_rate_val(struct mt76x2_dev *dev,
-		       const struct ieee80211_tx_rate *rate, u8 *nss_val)
-{
-	u16 rateval;
-	u8 phy, rate_idx;
-	u8 nss = 1;
-	u8 bw = 0;
-
-	if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
-		rate_idx = rate->idx;
-		nss = 1 + (rate->idx >> 4);
-		phy = MT_PHY_TYPE_VHT;
-		if (rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
-			bw = 2;
-		else if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-			bw = 1;
-	} else if (rate->flags & IEEE80211_TX_RC_MCS) {
-		rate_idx = rate->idx;
-		nss = 1 + (rate->idx >> 3);
-		phy = MT_PHY_TYPE_HT;
-		if (rate->flags & IEEE80211_TX_RC_GREEN_FIELD)
-			phy = MT_PHY_TYPE_HT_GF;
-		if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-			bw = 1;
-	} else {
-		const struct ieee80211_rate *r;
-		int band = dev->mt76.chandef.chan->band;
-		u16 val;
-
-		r = &mt76_hw(dev)->wiphy->bands[band]->bitrates[rate->idx];
-		if (rate->flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE)
-			val = r->hw_value_short;
-		else
-			val = r->hw_value;
-
-		phy = val >> 8;
-		rate_idx = val & 0xff;
-		bw = 0;
-	}
-
-	rateval = FIELD_PREP(MT_RXWI_RATE_INDEX, rate_idx);
-	rateval |= FIELD_PREP(MT_RXWI_RATE_PHY, phy);
-	rateval |= FIELD_PREP(MT_RXWI_RATE_BW, bw);
-	if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
-		rateval |= MT_RXWI_RATE_SGI;
-
-	*nss_val = nss;
-	return cpu_to_le16(rateval);
-}
-
-void mt76x2_mac_wcid_set_rate(struct mt76x2_dev *dev, struct mt76_wcid *wcid,
-			      const struct ieee80211_tx_rate *rate)
-{
-	spin_lock_bh(&dev->mt76.lock);
-	wcid->tx_rate = mt76x2_mac_tx_rate_val(dev, rate, &wcid->tx_rate_nss);
-	wcid->tx_rate_set = true;
-	spin_unlock_bh(&dev->mt76.lock);
-}
-EXPORT_SYMBOL_GPL(mt76x2_mac_wcid_set_rate);
-
 void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_sta *sta, int len)
@@ -333,8 +272,8 @@ void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x2_txwi *txwi,
 		max_txpwr_adj = wcid->max_txpwr_adj;
 		nss = wcid->tx_rate_nss;
 	} else {
-		txwi->rate = mt76x2_mac_tx_rate_val(dev, rate, &nss);
-		max_txpwr_adj = mt76x2_tx_get_max_txpwr_adj(dev, rate);
+		txwi->rate = mt76x02_mac_tx_rate_val(&dev->mt76, rate, &nss);
+		max_txpwr_adj = mt76x2_tx_get_max_txpwr_adj(&dev->mt76, rate);
 	}
 	spin_unlock_bh(&dev->mt76.lock);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 99d9033efa15..7f0a89be154c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -299,7 +299,7 @@ const struct ieee80211_ops mt76x2_ops = {
 	.ampdu_action = mt76x02_ampdu_action,
 	.get_txpower = mt76x2_get_txpower,
 	.wake_tx_queue = mt76_wake_tx_queue,
-	.sta_rate_tbl_update = mt76x2_sta_rate_tbl_update,
+	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.release_buffered_frames = mt76_release_buffered_frames,
 	.set_coverage_class = mt76x2_set_coverage_class,
 	.get_survey = mt76_get_survey,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
index b6c6d657b2b7..17da4ae1032d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx_common.c
@@ -63,9 +63,10 @@ int mt76x2_insert_hdr_pad(struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(mt76x2_insert_hdr_pad);
 
-s8 mt76x2_tx_get_max_txpwr_adj(struct mt76x2_dev *dev,
+s8 mt76x2_tx_get_max_txpwr_adj(struct mt76_dev *mdev,
 			       const struct ieee80211_tx_rate *rate)
 {
+	struct mt76x2_dev *dev = (struct mt76x2_dev *) mdev;
 	s8 max_txpwr;
 
 	if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
index 66a923a32e51..c6855549c312 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
@@ -176,5 +176,5 @@ const struct ieee80211_ops mt76x2u_ops = {
 	.conf_tx = mt76x02_conf_tx,
 	.sw_scan_start = mt76x2u_sw_scan,
 	.sw_scan_complete = mt76x2u_sw_scan_complete,
-	.sta_rate_tbl_update = mt76x2_sta_rate_tbl_update,
+	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 };
-- 
2.7.5
