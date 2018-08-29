Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33146 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728316AbeH2PNw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 11:13:52 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH v3 16/16] mt76x0: use mt76x02_sta and mt76x02_tx_status
Date: Wed, 29 Aug 2018 13:16:47 +0200
Message-Id: <1535541407-27149-17-git-send-email-sgruszka@redhat.com> (sfid-20180829_131732_133313_4FD5F5DD)
In-Reply-To: <1535541407-27149-1-git-send-email-sgruszka@redhat.com>
References: <1535541407-27149-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use common mt76x02_sta and mt76x02_tx_status structures in mt76x0 sub-driver.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    | 14 +++++++-------
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 21 +++++++++++++--------
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h | 19 -------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/trace.h  |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |  6 +++---
 7 files changed, 28 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index 41c9c7b5deea..24fc4c31667b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -688,7 +688,7 @@ int mt76x0_register_device(struct mt76x0_dev *dev)
 	hw->max_report_rates = 7;
 	hw->max_rate_tries = 1;
 
-	hw->sta_data_size = sizeof(struct mt76_sta);
+	hw->sta_data_size = sizeof(struct mt76x02_sta);
 	hw->vif_data_size = sizeof(struct mt76x02_vif);
 
 	SET_IEEE80211_PERM_ADDR(hw, dev->macaddr);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 2bf5c81ecf10..0931c1821597 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -76,7 +76,7 @@ mt76_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
 
 static void
 mt76_mac_fill_tx_status(struct mt76x0_dev *dev, struct ieee80211_tx_info *info,
-			struct mt76_tx_status *st, int n_frames)
+			struct mt76x02_tx_status *st, int n_frames)
 {
 	struct ieee80211_tx_rate *rate = info->status.rates;
 	int cur_idx, last_rate;
@@ -177,9 +177,9 @@ void mt76x0_mac_wcid_set_rate(struct mt76x0_dev *dev, struct mt76_wcid *wcid,
 	spin_unlock_irqrestore(&dev->mt76.lock, flags);
 }
 
-struct mt76_tx_status mt76x0_mac_fetch_tx_status(struct mt76x0_dev *dev)
+struct mt76x02_tx_status mt76x0_mac_fetch_tx_status(struct mt76x0_dev *dev)
 {
-	struct mt76_tx_status stat = {};
+	struct mt76x02_tx_status stat = {};
 	u32 stat2, stat1;
 
 	stat2 = mt76_rr(dev, MT_TX_STAT_FIFO_EXT);
@@ -198,12 +198,12 @@ struct mt76_tx_status mt76x0_mac_fetch_tx_status(struct mt76x0_dev *dev)
 	return stat;
 }
 
-void mt76x0_send_tx_status(struct mt76x0_dev *dev, struct mt76_tx_status *stat, u8 *update)
+void mt76x0_send_tx_status(struct mt76x0_dev *dev, struct mt76x02_tx_status *stat, u8 *update)
 {
 	struct ieee80211_tx_info info = {};
 	struct ieee80211_sta *sta = NULL;
 	struct mt76_wcid *wcid = NULL;
-	struct mt76_sta *msta = NULL;
+	struct mt76x02_sta *msta = NULL;
 
 	rcu_read_lock();
 	if (stat->wcid < ARRAY_SIZE(dev->wcid))
@@ -211,7 +211,7 @@ void mt76x0_send_tx_status(struct mt76x0_dev *dev, struct mt76_tx_status *stat,
 
 	if (wcid) {
 		void *priv;
-		priv = msta = container_of(wcid, struct mt76_sta, wcid);
+		priv = msta = container_of(wcid, struct mt76x02_sta, wcid);
 		sta = container_of(priv, struct ieee80211_sta, drv_priv);
 	}
 
@@ -413,7 +413,7 @@ void mt76x0_mac_set_ampdu_factor(struct mt76x0_dev *dev)
 		if (!wcid)
 			continue;
 
-		msta = container_of(wcid, struct mt76_sta, wcid);
+		msta = container_of(wcid, struct mt76x02_sta, wcid);
 		sta = container_of(msta, struct ieee80211_sta, drv_priv);
 
 		min_factor = min(min_factor, sta->ht_cap.ampdu_factor);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
index f8074c477044..a6153a1ae206 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
@@ -143,8 +143,8 @@ void mt76x0_mac_wcid_set_rate(struct mt76x0_dev *dev, struct mt76_wcid *wcid,
 
 u16 mt76x0_mac_tx_rate_val(struct mt76x0_dev *dev,
 			 const struct ieee80211_tx_rate *rate, u8 *nss_val);
-struct mt76_tx_status
+struct mt76x02_tx_status
 mt76x0_mac_fetch_tx_status(struct mt76x0_dev *dev);
-void mt76x0_send_tx_status(struct mt76x0_dev *dev, struct mt76_tx_status *stat, u8 *update);
+void mt76x0_send_tx_status(struct mt76x0_dev *dev, struct mt76x02_tx_status *stat, u8 *update);
 
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index fd92a67dc379..a969fa9fcd57 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -161,7 +161,7 @@ mt76x0_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	       struct ieee80211_sta *sta)
 {
 	struct mt76x0_dev *dev = hw->priv;
-	struct mt76_sta *msta = (struct mt76_sta *) sta->drv_priv;
+	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
 	int ret = 0;
 	int idx = 0;
@@ -196,7 +196,7 @@ mt76x0_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta)
 {
 	struct mt76x0_dev *dev = hw->priv;
-	struct mt76_sta *msta = (struct mt76_sta *) sta->drv_priv;
+	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
 	int idx = msta->wcid.idx;
 	int i;
 
@@ -251,7 +251,7 @@ mt76x0_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 {
 	struct mt76x0_dev *dev = hw->priv;
 	struct mt76x02_vif *mvif = (struct mt76x02_vif *) vif->drv_priv;
-	struct mt76_sta *msta = sta ? (struct mt76_sta *) sta->drv_priv : NULL;
+	struct mt76x02_sta *msta = sta ? (struct mt76x02_sta *) sta->drv_priv : NULL;
 	struct mt76_wcid *wcid = msta ? &msta->wcid : &mvif->group_wcid;
 	int idx = key->keyidx;
 	int ret;
@@ -294,12 +294,17 @@ mt76_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 {
 	struct mt76x0_dev *dev = hw->priv;
 	struct ieee80211_sta *sta = params->sta;
+	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
 	enum ieee80211_ampdu_mlme_action action = params->action;
+	struct ieee80211_txq *txq = sta->txq[params->tid];
 	u16 tid = params->tid;
 	u16 *ssn = &params->ssn;
-	struct mt76_sta *msta = (struct mt76_sta *) sta->drv_priv;
+	struct mt76_txq *mtxq;
 
-	WARN_ON(msta->wcid.idx > N_WCIDS);
+	if (!txq)
+		return -EINVAL;
+
+	mtxq = (struct mt76_txq *)txq->drv_priv;
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
@@ -309,13 +314,13 @@ mt76_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		mt76_clear(dev, MT_WCID_ADDR(msta->wcid.idx) + 4, BIT(16 + tid));
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		ieee80211_send_bar(vif, sta->addr, tid, msta->agg_ssn[tid]);
+		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
 		break;
 	case IEEE80211_AMPDU_TX_STOP_FLUSH:
 	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		msta->agg_ssn[tid] = *ssn << 4;
+		mtxq->agg_ssn = *ssn << 4;
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_STOP_CONT:
@@ -331,7 +336,7 @@ mt76_sta_rate_tbl_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 struct ieee80211_sta *sta)
 {
 	struct mt76x0_dev *dev = hw->priv;
-	struct mt76_sta *msta = (struct mt76_sta *) sta->drv_priv;
+	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
 	struct ieee80211_sta_rates *rates;
 	struct ieee80211_tx_rate rate = {};
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index a1b9a705b173..15353a2a921b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -219,25 +219,6 @@ struct mt76x0_wcid {
 	u8 tx_rate_nss;
 };
 
-struct mt76_tx_status {
-	u8 valid:1;
-	u8 success:1;
-	u8 aggr:1;
-	u8 ack_req:1;
-	u8 is_probe:1;
-	u8 wcid;
-	u8 pktid;
-	u8 retry;
-	u16 rate;
-} __packed __aligned(2);
-
-struct mt76_sta {
-	struct mt76_wcid wcid;
-	struct mt76_tx_status status;
-	int n_frames;
-	u16 agg_ssn[IEEE80211_NUM_TIDS];
-};
-
 struct mt76_reg_pair {
 	u32 reg;
 	u32 value;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h b/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
index 8a752a09f2dc..d31ba71b9d5b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/trace.h
@@ -197,13 +197,13 @@ TRACE_EVENT(mt76x0_rx,
 
 TRACE_EVENT(mt76x0_tx,
 	TP_PROTO(struct mt76_dev *dev, struct sk_buff *skb,
-		 struct mt76_sta *sta, struct mt76_txwi *h),
+		 struct mt76x02_sta *sta, struct mt76_txwi *h),
 	TP_ARGS(dev, skb, sta, h),
 	TP_STRUCT__entry(
 		DEV_ENTRY
 		__field_struct(struct mt76_txwi, h)
 		__field(struct sk_buff *, skb)
-		__field(struct mt76_sta *, sta)
+		__field(struct mt76x02_sta *, sta)
 	),
 	TP_fast_assign(
 		DEV_ASSIGN;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index 0c0ac2283c35..fd2baa5cc92d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -149,7 +149,7 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	struct mt76x0_dev *dev = hw->priv;
 	struct ieee80211_vif *vif = info->control.vif;
 	struct ieee80211_sta *sta = control->sta;
-	struct mt76_sta *msta = NULL;
+	struct mt76x02_sta *msta = NULL;
 	struct mt76_wcid *wcid = dev->mon_wcid;
 	struct mt76_txwi *txwi;
 	int pkt_len = skb->len;
@@ -164,7 +164,7 @@ void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
 	}
 
 	if (sta) {
-		msta = (struct mt76_sta *) sta->drv_priv;
+		msta = (struct mt76x02_sta *) sta->drv_priv;
 		wcid = &msta->wcid;
 	} else if (vif && (!info->control.hw_key && wcid->hw_key_idx != 0xff)) {
 		struct mt76x02_vif *mvif = (struct mt76x02_vif *)vif->drv_priv;
@@ -184,7 +184,7 @@ void mt76x0_tx_stat(struct work_struct *work)
 {
 	struct mt76x0_dev *dev = container_of(work, struct mt76x0_dev,
 					       stat_work.work);
-	struct mt76_tx_status stat;
+	struct mt76x02_tx_status stat;
 	unsigned long flags;
 	int cleaned = 0;
 	u8 update = 1;
-- 
2.7.5
