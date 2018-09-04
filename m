Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbeIDTIF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:08:05 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 17/22] mt76: unify send_tx_status and related helpers
Date: Tue,  4 Sep 2018 16:41:10 +0200
Message-Id: <1536072075-6990-18-git-send-email-sgruszka@redhat.com> (sfid-20180904_164254_755599_B1EDCCAC)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Merge send_tx_status and helper functions from mt76x0 and mt76x2.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.c    | 147 --------------------
 drivers/net/wireless/mediatek/mt76/mt76x0/mac.h    |   4 -
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c     |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 151 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.h   |   2 +
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |   2 -
 drivers/net/wireless/mediatek/mt76/mt76x2_mac.c    |   4 +-
 .../net/wireless/mediatek/mt76/mt76x2_mac_common.c | 151 ---------------------
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c  |   2 +-
 9 files changed, 157 insertions(+), 308 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
index 41f681cfc5ef..eecb9d015d70 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.c
@@ -17,153 +17,6 @@
 #include "trace.h"
 #include <linux/etherdevice.h>
 
-static void
-mt76_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
-			 enum nl80211_band band)
-{
-	u8 idx = FIELD_GET(MT_RXWI_RATE_INDEX, rate);
-
-	txrate->idx = 0;
-	txrate->flags = 0;
-	txrate->count = 1;
-
-	switch (FIELD_GET(MT_RXWI_RATE_PHY, rate)) {
-	case MT_PHY_TYPE_OFDM:
-		if (band == NL80211_BAND_2GHZ)
-			idx += 4;
-
-		txrate->idx = idx;
-		return;
-	case MT_PHY_TYPE_CCK:
-		if (idx >= 8)
-			idx -= 8;
-
-		txrate->idx = idx;
-		return;
-	case MT_PHY_TYPE_HT_GF:
-		txrate->flags |= IEEE80211_TX_RC_GREEN_FIELD;
-		/* fall through */
-	case MT_PHY_TYPE_HT:
-		txrate->flags |= IEEE80211_TX_RC_MCS;
-		txrate->idx = idx;
-		break;
-	case MT_PHY_TYPE_VHT:
-		txrate->flags |= IEEE80211_TX_RC_VHT_MCS;
-		txrate->idx = idx;
-		break;
-	default:
-		WARN_ON(1);
-		return;
-	}
-
-	switch (FIELD_GET(MT_RXWI_RATE_BW, rate)) {
-	case MT_PHY_BW_20:
-		break;
-	case MT_PHY_BW_40:
-		txrate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
-		break;
-	case MT_PHY_BW_80:
-		txrate->flags |= IEEE80211_TX_RC_80_MHZ_WIDTH;
-		break;
-	default:
-		WARN_ON(1);
-		return;
-	}
-
-	if (rate & MT_RXWI_RATE_SGI)
-		txrate->flags |= IEEE80211_TX_RC_SHORT_GI;
-}
-
-static void
-mt76_mac_fill_tx_status(struct mt76x0_dev *dev, struct ieee80211_tx_info *info,
-			struct mt76x02_tx_status *st, int n_frames)
-{
-	struct ieee80211_tx_rate *rate = info->status.rates;
-	int cur_idx, last_rate;
-	int i;
-
-	if (!n_frames)
-		return;
-
-	last_rate = min_t(int, st->retry, IEEE80211_TX_MAX_RATES - 1);
-	mt76_mac_process_tx_rate(&rate[last_rate], st->rate,
-				 dev->mt76.chandef.chan->band);
-	if (last_rate < IEEE80211_TX_MAX_RATES - 1)
-		rate[last_rate + 1].idx = -1;
-
-	cur_idx = rate[last_rate].idx + last_rate;
-	for (i = 0; i <= last_rate; i++) {
-		rate[i].flags = rate[last_rate].flags;
-		rate[i].idx = max_t(int, 0, cur_idx - i);
-		rate[i].count = 1;
-	}
-
-	rate[last_rate - 1].count = st->retry + 1 - last_rate;
-
-	info->status.ampdu_len = n_frames;
-	info->status.ampdu_ack_len = st->success ? n_frames : 0;
-
-	if (st->pktid & MT_TXWI_PKTID_PROBE)
-		info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
-
-	if (st->aggr)
-		info->flags |= IEEE80211_TX_CTL_AMPDU |
-			       IEEE80211_TX_STAT_AMPDU;
-
-	if (!st->ack_req)
-		info->flags |= IEEE80211_TX_CTL_NO_ACK;
-	else if (st->success)
-		info->flags |= IEEE80211_TX_STAT_ACK;
-}
-
-void mt76x0_send_tx_status(struct mt76x0_dev *dev, struct mt76x02_tx_status *stat, u8 *update)
-{
-	struct ieee80211_tx_info info = {};
-	struct ieee80211_sta *sta = NULL;
-	struct mt76_wcid *wcid = NULL;
-	struct mt76x02_sta *msta = NULL;
-
-	rcu_read_lock();
-	if (stat->wcid < ARRAY_SIZE(dev->mt76.wcid))
-		wcid = rcu_dereference(dev->mt76.wcid[stat->wcid]);
-
-	if (wcid) {
-		void *priv;
-		priv = msta = container_of(wcid, struct mt76x02_sta, wcid);
-		sta = container_of(priv, struct ieee80211_sta, drv_priv);
-	}
-
-	if (msta && stat->aggr) {
-		u32 stat_val, stat_cache;
-
-		stat_val = stat->rate;
-		stat_val |= ((u32) stat->retry) << 16;
-		stat_cache = msta->status.rate;
-		stat_cache |= ((u32) msta->status.retry) << 16;
-
-		if (*update == 0 && stat_val == stat_cache &&
-		    stat->wcid == msta->status.wcid && msta->n_frames < 32) {
-			msta->n_frames++;
-			goto out;
-		}
-
-		mt76_mac_fill_tx_status(dev, &info, &msta->status,
-					msta->n_frames);
-		msta->status = *stat;
-		msta->n_frames = 1;
-		*update = 0;
-	} else {
-		mt76_mac_fill_tx_status(dev, &info, stat, 1);
-		*update = 1;
-	}
-
-	spin_lock_bh(&dev->mac_lock);
-	ieee80211_tx_status_noskb(dev->mt76.hw, sta, &info);
-	spin_unlock_bh(&dev->mac_lock);
-out:
-	rcu_read_unlock();
-}
-
 void mt76x0_mac_set_protection(struct mt76x0_dev *dev, bool legacy_prot,
 				int ht_mode)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
index 33b6e1e82eaa..abce22a51c87 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mac.h
@@ -17,8 +17,4 @@
 
 u32 mt76x0_mac_process_rx(struct mt76x0_dev *dev, struct sk_buff *skb,
 			u8 *data, void *rxi);
-struct mt76x02_tx_status
-mt76x0_mac_fetch_tx_status(struct mt76x0_dev *dev);
-void mt76x0_send_tx_status(struct mt76x0_dev *dev, struct mt76x02_tx_status *stat, u8 *update);
-
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index 9270469a580d..fa902ac227ec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -193,7 +193,7 @@ void mt76x0_tx_stat(struct work_struct *work)
 		if (!mt76x02_mac_load_tx_status(&dev->mt76, &stat))
 			break;
 
-		mt76x0_send_tx_status(dev, &stat, &update);
+		mt76x02_send_tx_status(&dev->mt76, &stat, &update);
 
 		cleaned++;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index ea1f77579b7c..873e4701b403 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -241,3 +241,154 @@ bool mt76x02_mac_load_tx_status(struct mt76_dev *dev,
 	return true;
 }
 EXPORT_SYMBOL_GPL(mt76x02_mac_load_tx_status);
+
+static int
+mt76x02_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
+			   enum nl80211_band band)
+{
+	u8 idx = FIELD_GET(MT_RXWI_RATE_INDEX, rate);
+
+	txrate->idx = 0;
+	txrate->flags = 0;
+	txrate->count = 1;
+
+	switch (FIELD_GET(MT_RXWI_RATE_PHY, rate)) {
+	case MT_PHY_TYPE_OFDM:
+		if (band == NL80211_BAND_2GHZ)
+			idx += 4;
+
+		txrate->idx = idx;
+		return 0;
+	case MT_PHY_TYPE_CCK:
+		if (idx >= 8)
+			idx -= 8;
+
+		txrate->idx = idx;
+		return 0;
+	case MT_PHY_TYPE_HT_GF:
+		txrate->flags |= IEEE80211_TX_RC_GREEN_FIELD;
+		/* fall through */
+	case MT_PHY_TYPE_HT:
+		txrate->flags |= IEEE80211_TX_RC_MCS;
+		txrate->idx = idx;
+		break;
+	case MT_PHY_TYPE_VHT:
+		txrate->flags |= IEEE80211_TX_RC_VHT_MCS;
+		txrate->idx = idx;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	switch (FIELD_GET(MT_RXWI_RATE_BW, rate)) {
+	case MT_PHY_BW_20:
+		break;
+	case MT_PHY_BW_40:
+		txrate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
+		break;
+	case MT_PHY_BW_80:
+		txrate->flags |= IEEE80211_TX_RC_80_MHZ_WIDTH;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (rate & MT_RXWI_RATE_SGI)
+		txrate->flags |= IEEE80211_TX_RC_SHORT_GI;
+
+	return 0;
+}
+
+static void
+mt76x02_mac_fill_tx_status(struct mt76_dev *dev,
+			  struct ieee80211_tx_info *info,
+			  struct mt76x02_tx_status *st, int n_frames)
+{
+	struct ieee80211_tx_rate *rate = info->status.rates;
+	int cur_idx, last_rate;
+	int i;
+
+	if (!n_frames)
+		return;
+
+	last_rate = min_t(int, st->retry, IEEE80211_TX_MAX_RATES - 1);
+	mt76x02_mac_process_tx_rate(&rate[last_rate], st->rate,
+				   dev->chandef.chan->band);
+	if (last_rate < IEEE80211_TX_MAX_RATES - 1)
+		rate[last_rate + 1].idx = -1;
+
+	cur_idx = rate[last_rate].idx + last_rate;
+	for (i = 0; i <= last_rate; i++) {
+		rate[i].flags = rate[last_rate].flags;
+		rate[i].idx = max_t(int, 0, cur_idx - i);
+		rate[i].count = 1;
+	}
+	rate[last_rate].count = st->retry + 1 - last_rate;
+
+	info->status.ampdu_len = n_frames;
+	info->status.ampdu_ack_len = st->success ? n_frames : 0;
+
+	if (st->pktid & MT_TXWI_PKTID_PROBE)
+		info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
+
+	if (st->aggr)
+		info->flags |= IEEE80211_TX_CTL_AMPDU |
+			       IEEE80211_TX_STAT_AMPDU;
+
+	if (!st->ack_req)
+		info->flags |= IEEE80211_TX_CTL_NO_ACK;
+	else if (st->success)
+		info->flags |= IEEE80211_TX_STAT_ACK;
+}
+
+void mt76x02_send_tx_status(struct mt76_dev *dev,
+			   struct mt76x02_tx_status *stat, u8 *update)
+{
+	struct ieee80211_tx_info info = {};
+	struct ieee80211_sta *sta = NULL;
+	struct mt76_wcid *wcid = NULL;
+	struct mt76x02_sta *msta = NULL;
+
+	rcu_read_lock();
+	if (stat->wcid < ARRAY_SIZE(dev->wcid))
+		wcid = rcu_dereference(dev->wcid[stat->wcid]);
+
+	if (wcid) {
+		void *priv;
+
+		priv = msta = container_of(wcid, struct mt76x02_sta, wcid);
+		sta = container_of(priv, struct ieee80211_sta,
+				   drv_priv);
+	}
+
+	if (msta && stat->aggr) {
+		u32 stat_val, stat_cache;
+
+		stat_val = stat->rate;
+		stat_val |= ((u32) stat->retry) << 16;
+		stat_cache = msta->status.rate;
+		stat_cache |= ((u32) msta->status.retry) << 16;
+
+		if (*update == 0 && stat_val == stat_cache &&
+		    stat->wcid == msta->status.wcid && msta->n_frames < 32) {
+			msta->n_frames++;
+			goto out;
+		}
+
+		mt76x02_mac_fill_tx_status(dev, &info, &msta->status,
+					  msta->n_frames);
+
+		msta->status = *stat;
+		msta->n_frames = 1;
+		*update = 0;
+	} else {
+		mt76x02_mac_fill_tx_status(dev, &info, stat, 1);
+		*update = 1;
+	}
+
+	ieee80211_tx_status_noskb(dev->hw, sta, &info);
+
+out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(mt76x02_send_tx_status);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
index 0547f7db9d3d..4ba38f2aa24c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.h
@@ -197,4 +197,6 @@ mt76x02_mac_tx_rate_val(struct mt76_dev *dev,
 		       const struct ieee80211_tx_rate *rate, u8 *nss_val);
 bool mt76x02_mac_load_tx_status(struct mt76_dev *dev,
 			       struct mt76x02_tx_status *stat);
+void mt76x02_send_tx_status(struct mt76_dev *dev,
+			   struct mt76x02_tx_status *stat, u8 *update);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index 0a29e7ae1a9d..b3a936edfb30 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -241,8 +241,6 @@ void mt76x2_tx_set_txpwr_auto(struct mt76x2_dev *dev, s8 txpwr);
 
 int mt76x2_insert_hdr_pad(struct sk_buff *skb);
 
-void mt76x2_send_tx_status(struct mt76x2_dev *dev,
-			   struct mt76x02_tx_status *stat, u8 *update);
 void mt76x2_reset_wlan(struct mt76x2_dev *dev, bool enable);
 void mt76x2_init_txpower(struct mt76x2_dev *dev,
 			 struct ieee80211_supported_band *sband);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
index b346f17e49d5..3bb02b55f146 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac.c
@@ -51,7 +51,7 @@ void mt76x2_mac_poll_tx_status(struct mt76x2_dev *dev, bool irq)
 		trace_mac_txstat_fetch(dev, &stat);
 
 		if (!irq) {
-			mt76x2_send_tx_status(dev, &stat, &update);
+			mt76x02_send_tx_status(&dev->mt76, &stat, &update);
 			continue;
 		}
 
@@ -82,7 +82,7 @@ void mt76x2_mac_process_tx_status_fifo(struct mt76x2_dev *dev)
 	u8 update = 1;
 
 	while (kfifo_get(&dev->txstatus_fifo, &stat))
-		mt76x2_send_tx_status(dev, &stat, &update);
+		mt76x02_send_tx_status(&dev->mt76, &stat, &update);
 }
 
 void mt76x2_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
index 4cd94bfc9dbc..1ebc3bfa9d6a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mac_common.c
@@ -53,157 +53,6 @@ void mt76x2_mac_stop(struct mt76x2_dev *dev, bool force)
 }
 EXPORT_SYMBOL_GPL(mt76x2_mac_stop);
 
-static int
-mt76x2_mac_process_tx_rate(struct ieee80211_tx_rate *txrate, u16 rate,
-			   enum nl80211_band band)
-{
-	u8 idx = FIELD_GET(MT_RXWI_RATE_INDEX, rate);
-
-	txrate->idx = 0;
-	txrate->flags = 0;
-	txrate->count = 1;
-
-	switch (FIELD_GET(MT_RXWI_RATE_PHY, rate)) {
-	case MT_PHY_TYPE_OFDM:
-		if (band == NL80211_BAND_2GHZ)
-			idx += 4;
-
-		txrate->idx = idx;
-		return 0;
-	case MT_PHY_TYPE_CCK:
-		if (idx >= 8)
-			idx -= 8;
-
-		txrate->idx = idx;
-		return 0;
-	case MT_PHY_TYPE_HT_GF:
-		txrate->flags |= IEEE80211_TX_RC_GREEN_FIELD;
-		/* fall through */
-	case MT_PHY_TYPE_HT:
-		txrate->flags |= IEEE80211_TX_RC_MCS;
-		txrate->idx = idx;
-		break;
-	case MT_PHY_TYPE_VHT:
-		txrate->flags |= IEEE80211_TX_RC_VHT_MCS;
-		txrate->idx = idx;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	switch (FIELD_GET(MT_RXWI_RATE_BW, rate)) {
-	case MT_PHY_BW_20:
-		break;
-	case MT_PHY_BW_40:
-		txrate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
-		break;
-	case MT_PHY_BW_80:
-		txrate->flags |= IEEE80211_TX_RC_80_MHZ_WIDTH;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	if (rate & MT_RXWI_RATE_SGI)
-		txrate->flags |= IEEE80211_TX_RC_SHORT_GI;
-
-	return 0;
-}
-
-static void
-mt76x2_mac_fill_tx_status(struct mt76x2_dev *dev,
-			  struct ieee80211_tx_info *info,
-			  struct mt76x02_tx_status *st, int n_frames)
-{
-	struct ieee80211_tx_rate *rate = info->status.rates;
-	int cur_idx, last_rate;
-	int i;
-
-	if (!n_frames)
-		return;
-
-	last_rate = min_t(int, st->retry, IEEE80211_TX_MAX_RATES - 1);
-	mt76x2_mac_process_tx_rate(&rate[last_rate], st->rate,
-				 dev->mt76.chandef.chan->band);
-	if (last_rate < IEEE80211_TX_MAX_RATES - 1)
-		rate[last_rate + 1].idx = -1;
-
-	cur_idx = rate[last_rate].idx + last_rate;
-	for (i = 0; i <= last_rate; i++) {
-		rate[i].flags = rate[last_rate].flags;
-		rate[i].idx = max_t(int, 0, cur_idx - i);
-		rate[i].count = 1;
-	}
-	rate[last_rate].count = st->retry + 1 - last_rate;
-
-	info->status.ampdu_len = n_frames;
-	info->status.ampdu_ack_len = st->success ? n_frames : 0;
-
-	if (st->pktid & MT_TXWI_PKTID_PROBE)
-		info->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
-
-	if (st->aggr)
-		info->flags |= IEEE80211_TX_CTL_AMPDU |
-			       IEEE80211_TX_STAT_AMPDU;
-
-	if (!st->ack_req)
-		info->flags |= IEEE80211_TX_CTL_NO_ACK;
-	else if (st->success)
-		info->flags |= IEEE80211_TX_STAT_ACK;
-}
-
-void mt76x2_send_tx_status(struct mt76x2_dev *dev,
-			   struct mt76x02_tx_status *stat, u8 *update)
-{
-	struct ieee80211_tx_info info = {};
-	struct ieee80211_sta *sta = NULL;
-	struct mt76_wcid *wcid = NULL;
-	struct mt76x02_sta *msta = NULL;
-
-	rcu_read_lock();
-	if (stat->wcid < ARRAY_SIZE(dev->mt76.wcid))
-		wcid = rcu_dereference(dev->mt76.wcid[stat->wcid]);
-
-	if (wcid) {
-		void *priv;
-
-		priv = msta = container_of(wcid, struct mt76x02_sta, wcid);
-		sta = container_of(priv, struct ieee80211_sta,
-				   drv_priv);
-	}
-
-	if (msta && stat->aggr) {
-		u32 stat_val, stat_cache;
-
-		stat_val = stat->rate;
-		stat_val |= ((u32) stat->retry) << 16;
-		stat_cache = msta->status.rate;
-		stat_cache |= ((u32) msta->status.retry) << 16;
-
-		if (*update == 0 && stat_val == stat_cache &&
-		    stat->wcid == msta->status.wcid && msta->n_frames < 32) {
-			msta->n_frames++;
-			goto out;
-		}
-
-		mt76x2_mac_fill_tx_status(dev, &info, &msta->status,
-					  msta->n_frames);
-
-		msta->status = *stat;
-		msta->n_frames = 1;
-		*update = 0;
-	} else {
-		mt76x2_mac_fill_tx_status(dev, &info, stat, 1);
-		*update = 1;
-	}
-
-	ieee80211_tx_status_noskb(mt76_hw(dev), sta, &info);
-
-out:
-	rcu_read_unlock();
-}
-EXPORT_SYMBOL_GPL(mt76x2_send_tx_status);
-
 void mt76x2_mac_write_txwi(struct mt76x2_dev *dev, struct mt76x02_txwi *txwi,
 			   struct sk_buff *skb, struct mt76_wcid *wcid,
 			   struct ieee80211_sta *sta, int len)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
index 73af4c8a73ae..35cce40c7c90 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
@@ -71,7 +71,7 @@ bool mt76x2u_tx_status_data(struct mt76_dev *mdev, u8 *update)
 	if (!mt76x02_mac_load_tx_status(&dev->mt76, &stat))
 		return false;
 
-	mt76x2_send_tx_status(dev, &stat, update);
+	mt76x02_send_tx_status(&dev->mt76, &stat, update);
 
 	return true;
 }
-- 
2.7.5
