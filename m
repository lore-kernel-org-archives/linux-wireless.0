Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:39292 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbeIDTHI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:07:08 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 05/22] mt76: unify ampdu_action
Date: Tue,  4 Sep 2018 16:40:58 +0200
Message-Id: <1536072075-6990-6-git-send-email-sgruszka@redhat.com> (sfid-20180904_164159_797750_39F6C896)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use mt76x2_ampdu_action as common function, mt76x0 ampdu_action was
diffrent, but mt76x2 version should work for this driver as well.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h          |  3 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   | 45 +------------------
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  | 50 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.h  |  3 ++
 drivers/net/wireless/mediatek/mt76/mt76x2.h        |  2 -
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c | 51 ----------------------
 drivers/net/wireless/mediatek/mt76/mt76x2_main.c   |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2u_main.c  |  2 +-
 8 files changed, 59 insertions(+), 99 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 2d0ab28a0977..cb9b9852f32f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -427,6 +427,9 @@ struct mt76_rx_status {
 #define __mt76_rmw(dev, ...)	(dev)->bus->rmw((dev), __VA_ARGS__)
 #define __mt76_wr_copy(dev, ...)	(dev)->bus->copy((dev), __VA_ARGS__)
 
+#define __mt76_set(dev, offset, val)	__mt76_rmw(dev, offset, 0, val)
+#define __mt76_clear(dev, offset, val)	__mt76_rmw(dev, offset, val, 0)
+
 #define mt76_rr(dev, ...)	(dev)->mt76.bus->rr(&((dev)->mt76), __VA_ARGS__)
 #define mt76_wr(dev, ...)	(dev)->mt76.bus->wr(&((dev)->mt76), __VA_ARGS__)
 #define mt76_rmw(dev, ...)	(dev)->mt76.bus->rmw(&((dev)->mt76), __VA_ARGS__)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
index 1b0ddba96ea1..d2e243785b67 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/main.c
@@ -225,49 +225,6 @@ static int mt76x0_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	return 0;
 }
 
-static int
-mt76_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-		  struct ieee80211_ampdu_params *params)
-{
-	struct mt76x0_dev *dev = hw->priv;
-	struct ieee80211_sta *sta = params->sta;
-	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
-	enum ieee80211_ampdu_mlme_action action = params->action;
-	struct ieee80211_txq *txq = sta->txq[params->tid];
-	u16 tid = params->tid;
-	u16 *ssn = &params->ssn;
-	struct mt76_txq *mtxq;
-
-	if (!txq)
-		return -EINVAL;
-
-	mtxq = (struct mt76_txq *)txq->drv_priv;
-
-	switch (action) {
-	case IEEE80211_AMPDU_RX_START:
-		mt76_set(dev, MT_WCID_ADDR(msta->wcid.idx) + 4, BIT(16 + tid));
-		break;
-	case IEEE80211_AMPDU_RX_STOP:
-		mt76_clear(dev, MT_WCID_ADDR(msta->wcid.idx) + 4, BIT(16 + tid));
-		break;
-	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
-		break;
-	case IEEE80211_AMPDU_TX_STOP_FLUSH:
-	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
-		break;
-	case IEEE80211_AMPDU_TX_START:
-		mtxq->agg_ssn = *ssn << 4;
-		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
-		break;
-	case IEEE80211_AMPDU_TX_STOP_CONT:
-		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
-		break;
-	}
-
-	return 0;
-}
-
 static void
 mt76_sta_rate_tbl_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			 struct ieee80211_sta *sta)
@@ -307,7 +264,7 @@ const struct ieee80211_ops mt76x0_ops = {
 	.conf_tx = mt76x0_conf_tx,
 	.sw_scan_start = mt76x0_sw_scan,
 	.sw_scan_complete = mt76x0_sw_scan_complete,
-	.ampdu_action = mt76_ampdu_action,
+	.ampdu_action = mt76x02_ampdu_action,
 	.sta_rate_tbl_update = mt76_sta_rate_tbl_update,
 	.set_rts_threshold = mt76x0_set_rts_threshold,
 };
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 6660ecf58d0a..b3225024ac72 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -127,4 +127,54 @@ void mt76x02_vif_init(struct mt76_dev *dev, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL_GPL(mt76x02_vif_init);
 
+int mt76x02_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			struct ieee80211_ampdu_params *params)
+{
+	enum ieee80211_ampdu_mlme_action action = params->action;
+	struct ieee80211_sta *sta = params->sta;
+	struct mt76_dev *dev = hw->priv;
+	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
+	struct ieee80211_txq *txq = sta->txq[params->tid];
+	u16 tid = params->tid;
+	u16 *ssn = &params->ssn;
+	struct mt76_txq *mtxq;
+
+	if (!txq)
+		return -EINVAL;
+
+	mtxq = (struct mt76_txq *)txq->drv_priv;
+
+	switch (action) {
+	case IEEE80211_AMPDU_RX_START:
+		mt76_rx_aggr_start(dev, &msta->wcid, tid, *ssn, params->buf_size);
+		__mt76_set(dev, MT_WCID_ADDR(msta->wcid.idx) + 4, BIT(16 + tid));
+		break;
+	case IEEE80211_AMPDU_RX_STOP:
+		mt76_rx_aggr_stop(dev, &msta->wcid, tid);
+		__mt76_clear(dev, MT_WCID_ADDR(msta->wcid.idx) + 4, BIT(16 + tid));
+		break;
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		mtxq->aggr = true;
+		mtxq->send_bar = false;
+		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
+		break;
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
+		mtxq->aggr = false;
+		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
+		break;
+	case IEEE80211_AMPDU_TX_START:
+		mtxq->agg_ssn = *ssn << 4;
+		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+		mtxq->aggr = false;
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76x02_ampdu_action);
+
 MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
index 9ed4404930c6..245e32738eeb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.h
@@ -28,4 +28,7 @@ int mt76x02_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 
 void mt76x02_vif_init(struct mt76_dev *dev, struct ieee80211_vif *vif,
 		     unsigned int idx);
+
+int mt76x02_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			struct ieee80211_ampdu_params *params);
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2.h b/drivers/net/wireless/mediatek/mt76/mt76x2.h
index b5cf720612e6..b1fdf2825ad7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2.h
@@ -250,8 +250,6 @@ void mt76x2_init_txpower(struct mt76x2_dev *dev,
 			 struct ieee80211_supported_band *sband);
 void mt76_write_mac_initvals(struct mt76x2_dev *dev);
 
-int mt76x2_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			struct ieee80211_ampdu_params *params);
 int mt76x2_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		   struct ieee80211_sta *sta);
 int mt76x2_sta_remove(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index 5d5d2701aed8..c458781a70aa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -18,57 +18,6 @@
 #include "mt76x2.h"
 #include "mt76x02_mac.h"
 
-int mt76x2_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-			struct ieee80211_ampdu_params *params)
-{
-	enum ieee80211_ampdu_mlme_action action = params->action;
-	struct ieee80211_sta *sta = params->sta;
-	struct mt76x2_dev *dev = hw->priv;
-	struct mt76x02_sta *msta = (struct mt76x02_sta *) sta->drv_priv;
-	struct ieee80211_txq *txq = sta->txq[params->tid];
-	u16 tid = params->tid;
-	u16 *ssn = &params->ssn;
-	struct mt76_txq *mtxq;
-
-	if (!txq)
-		return -EINVAL;
-
-	mtxq = (struct mt76_txq *)txq->drv_priv;
-
-	switch (action) {
-	case IEEE80211_AMPDU_RX_START:
-		mt76_rx_aggr_start(&dev->mt76, &msta->wcid, tid, *ssn, params->buf_size);
-		mt76_set(dev, MT_WCID_ADDR(msta->wcid.idx) + 4, BIT(16 + tid));
-		break;
-	case IEEE80211_AMPDU_RX_STOP:
-		mt76_rx_aggr_stop(&dev->mt76, &msta->wcid, tid);
-		mt76_clear(dev, MT_WCID_ADDR(msta->wcid.idx) + 4,
-			   BIT(16 + tid));
-		break;
-	case IEEE80211_AMPDU_TX_OPERATIONAL:
-		mtxq->aggr = true;
-		mtxq->send_bar = false;
-		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
-		break;
-	case IEEE80211_AMPDU_TX_STOP_FLUSH:
-	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
-		mtxq->aggr = false;
-		ieee80211_send_bar(vif, sta->addr, tid, mtxq->agg_ssn);
-		break;
-	case IEEE80211_AMPDU_TX_START:
-		mtxq->agg_ssn = *ssn << 4;
-		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
-		break;
-	case IEEE80211_AMPDU_TX_STOP_CONT:
-		mtxq->aggr = false;
-		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
-		break;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(mt76x2_ampdu_action);
-
 void mt76x2_remove_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
index 870ee01fe409..137bd73c473a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_main.c
@@ -325,7 +325,7 @@ const struct ieee80211_ops mt76x2_ops = {
 	.sw_scan_start = mt76x2_sw_scan,
 	.sw_scan_complete = mt76x2_sw_scan_complete,
 	.flush = mt76x2_flush,
-	.ampdu_action = mt76x2_ampdu_action,
+	.ampdu_action = mt76x02_ampdu_action,
 	.get_txpower = mt76x2_get_txpower,
 	.wake_tx_queue = mt76_wake_tx_queue,
 	.sta_rate_tbl_update = mt76x2_sta_rate_tbl_update,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
index 49818e290ccd..b358ee46a4a3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_main.c
@@ -168,7 +168,7 @@ const struct ieee80211_ops mt76x2u_ops = {
 	.sta_add = mt76x02_sta_add,
 	.sta_remove = mt76x02_sta_remove,
 	.set_key = mt76x2_set_key,
-	.ampdu_action = mt76x2_ampdu_action,
+	.ampdu_action = mt76x02_ampdu_action,
 	.config = mt76x2u_config,
 	.wake_tx_queue = mt76_wake_tx_queue,
 	.bss_info_changed = mt76x2u_bss_info_changed,
-- 
2.7.5
