Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41725 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854Ab0FOEw5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 00:52:57 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 21:52:57 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19479.1933.521344.310442@gargle.gargle.HOWL>
Date: Tue, 15 Jun 2010 10:24:37 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k_htc: Fix ampdu_action callback
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that ampdu_action() can sleep, remove all
the driver hacks and just issue WMI commands
to the target.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   20 +----
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    3 -
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   93 +++++++------------------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   21 +++++-
 4 files changed, 45 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index c584fbd..58f52a1 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -223,15 +223,6 @@ struct ath9k_htc_sta {
 	enum tid_aggr_state tid_state[ATH9K_HTC_MAX_TID];
 };
 
-struct ath9k_htc_aggr_work {
-	u16 tid;
-	u8 sta_addr[ETH_ALEN];
-	struct ieee80211_hw *hw;
-	struct ieee80211_vif *vif;
-	enum ieee80211_ampdu_mlme_action action;
-	struct mutex mutex;
-};
-
 #define ATH9K_HTC_RXBUF 256
 #define HTC_RX_FRAME_HEADER_SIZE 40
 
@@ -331,11 +322,10 @@ struct htc_beacon_config {
 #define OP_LED_ON         BIT(4)
 #define OP_PREAMBLE_SHORT BIT(5)
 #define OP_PROTECT_ENABLE BIT(6)
-#define OP_TXAGGR         BIT(7)
-#define OP_ASSOCIATED     BIT(8)
-#define OP_ENABLE_BEACON  BIT(9)
-#define OP_LED_DEINIT     BIT(10)
-#define OP_UNPLUGGED      BIT(11)
+#define OP_ASSOCIATED     BIT(7)
+#define OP_ENABLE_BEACON  BIT(8)
+#define OP_LED_DEINIT     BIT(9)
+#define OP_UNPLUGGED      BIT(10)
 
 struct ath9k_htc_priv {
 	struct device *dev;
@@ -376,8 +366,6 @@ struct ath9k_htc_priv {
 	struct ath9k_htc_rx rx;
 	struct tasklet_struct tx_tasklet;
 	struct sk_buff_head tx_queue;
-	struct ath9k_htc_aggr_work aggr_work;
-	struct delayed_work ath9k_aggr_work;
 	struct delayed_work ath9k_ani_work;
 	struct work_struct ps_work;
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index d339e5f..a63ae88 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -606,7 +606,6 @@ static void ath9k_init_misc(struct ath9k_htc_priv *priv)
 	if (priv->ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
 		memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
 
-	priv->op_flags |= OP_TXAGGR;
 	priv->ah->opmode = NL80211_IFTYPE_STATION;
 }
 
@@ -638,14 +637,12 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv, u16 devid)
 	spin_lock_init(&priv->beacon_lock);
 	spin_lock_init(&priv->tx_lock);
 	mutex_init(&priv->mutex);
-	mutex_init(&priv->aggr_work.mutex);
 	mutex_init(&priv->htc_pm_lock);
 	tasklet_init(&priv->wmi_tasklet, ath9k_wmi_tasklet,
 		     (unsigned long)priv);
 	tasklet_init(&priv->rx_tasklet, ath9k_rx_tasklet,
 		     (unsigned long)priv);
 	tasklet_init(&priv->tx_tasklet, ath9k_tx_tasklet, (unsigned long)priv);
-	INIT_DELAYED_WORK(&priv->ath9k_aggr_work, ath9k_htc_aggr_work);
 	INIT_DELAYED_WORK(&priv->ath9k_ani_work, ath9k_ani_work);
 	INIT_WORK(&priv->ps_work, ath9k_ps_work);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index b9206e4..05445d8 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -438,13 +438,13 @@ static void ath9k_htc_update_rate(struct ath9k_htc_priv *priv,
 			  bss_conf->bssid, be32_to_cpu(trate.capflags));
 }
 
-static int ath9k_htc_aggr_oper(struct ath9k_htc_priv *priv,
-			       struct ieee80211_vif *vif,
-			       u8 *sta_addr, u8 tid, bool oper)
+int ath9k_htc_tx_aggr_oper(struct ath9k_htc_priv *priv,
+			   struct ieee80211_vif *vif,
+			   struct ieee80211_sta *sta,
+			   enum ieee80211_ampdu_mlme_action action, u16 tid)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_htc_target_aggr aggr;
-	struct ieee80211_sta *sta = NULL;
 	struct ath9k_htc_sta *ista;
 	int ret = 0;
 	u8 cmd_rsp;
@@ -453,72 +453,28 @@ static int ath9k_htc_aggr_oper(struct ath9k_htc_priv *priv,
 		return -EINVAL;
 
 	memset(&aggr, 0, sizeof(struct ath9k_htc_target_aggr));
-
-	rcu_read_lock();
-
-	/* Check if we are able to retrieve the station */
-	sta = ieee80211_find_sta(vif, sta_addr);
-	if (!sta) {
-		rcu_read_unlock();
-		return -EINVAL;
-	}
-
 	ista = (struct ath9k_htc_sta *) sta->drv_priv;
 
-	if (oper)
-		ista->tid_state[tid] = AGGR_START;
-	else
-		ista->tid_state[tid] = AGGR_STOP;
-
 	aggr.sta_index = ista->index;
-
-	rcu_read_unlock();
-
-	aggr.tidno = tid;
-	aggr.aggr_enable = oper;
+	aggr.tidno = tid & 0xf;
+	aggr.aggr_enable = (action == IEEE80211_AMPDU_TX_START) ? true : false;
 
 	WMI_CMD_BUF(WMI_TX_AGGR_ENABLE_CMDID, &aggr);
 	if (ret)
 		ath_print(common, ATH_DBG_CONFIG,
 			  "Unable to %s TX aggregation for (%pM, %d)\n",
-			  (oper) ? "start" : "stop", sta->addr, tid);
+			  (aggr.aggr_enable) ? "start" : "stop", sta->addr, tid);
 	else
 		ath_print(common, ATH_DBG_CONFIG,
-			  "%s aggregation for (%pM, %d)\n",
-			  (oper) ? "Starting" : "Stopping", sta->addr, tid);
-
-	return ret;
-}
+			  "%s TX aggregation for (%pM, %d)\n",
+			  (aggr.aggr_enable) ? "Starting" : "Stopping",
+			  sta->addr, tid);
 
-void ath9k_htc_aggr_work(struct work_struct *work)
-{
-	int ret = 0;
-	struct ath9k_htc_priv *priv =
-		container_of(work, struct ath9k_htc_priv,
-			     ath9k_aggr_work.work);
-	struct ath9k_htc_aggr_work *wk = &priv->aggr_work;
-
-	mutex_lock(&wk->mutex);
-
-	switch (wk->action) {
-	case IEEE80211_AMPDU_TX_START:
-		ret = ath9k_htc_aggr_oper(priv, wk->vif, wk->sta_addr,
-					  wk->tid, true);
-		if (!ret)
-			ieee80211_start_tx_ba_cb_irqsafe(wk->vif, wk->sta_addr,
-							 wk->tid);
-		break;
-	case IEEE80211_AMPDU_TX_STOP:
-		ath9k_htc_aggr_oper(priv, wk->vif, wk->sta_addr,
-				    wk->tid, false);
-		ieee80211_stop_tx_ba_cb_irqsafe(wk->vif, wk->sta_addr, wk->tid);
-		break;
-	default:
-		ath_print(ath9k_hw_common(priv->ah), ATH_DBG_FATAL,
-			  "Unknown AMPDU action\n");
-	}
+	spin_lock_bh(&priv->tx_lock);
+	ista->tid_state[tid] = (aggr.aggr_enable && !ret) ? AGGR_START : AGGR_STOP;
+	spin_unlock_bh(&priv->tx_lock);
 
-	mutex_unlock(&wk->mutex);
+	return ret;
 }
 
 /*********/
@@ -1266,7 +1222,6 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	/* Cancel all the running timers/work .. */
 	cancel_work_sync(&priv->ps_work);
 	cancel_delayed_work_sync(&priv->ath9k_ani_work);
-	cancel_delayed_work_sync(&priv->ath9k_aggr_work);
 	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
 	ath9k_led_stop_brightness(priv);
 
@@ -1767,8 +1722,8 @@ static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
 				  u16 tid, u16 *ssn)
 {
 	struct ath9k_htc_priv *priv = hw->priv;
-	struct ath9k_htc_aggr_work *work = &priv->aggr_work;
 	struct ath9k_htc_sta *ista;
+	int ret = 0;
 
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
@@ -1776,26 +1731,26 @@ static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_RX_STOP:
 		break;
 	case IEEE80211_AMPDU_TX_START:
+		ret = ath9k_htc_tx_aggr_oper(priv, vif, sta, action, tid);
+		if (!ret)
+			ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		break;
 	case IEEE80211_AMPDU_TX_STOP:
-		if (!(priv->op_flags & OP_TXAGGR))
-			return -ENOTSUPP;
-		memcpy(work->sta_addr, sta->addr, ETH_ALEN);
-		work->hw = hw;
-		work->vif = vif;
-		work->action = action;
-		work->tid = tid;
-		ieee80211_queue_delayed_work(hw, &priv->ath9k_aggr_work, 0);
+		ath9k_htc_tx_aggr_oper(priv, vif, sta, action, tid);
+		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		ista = (struct ath9k_htc_sta *) sta->drv_priv;
+		spin_lock_bh(&priv->tx_lock);
 		ista->tid_state[tid] = AGGR_OPERATIONAL;
+		spin_unlock_bh(&priv->tx_lock);
 		break;
 	default:
 		ath_print(ath9k_hw_common(priv->ah), ATH_DBG_FATAL,
 			  "Unknown AMPDU action\n");
 	}
 
-	return 0;
+	return ret;
 }
 
 static void ath9k_htc_sw_scan_start(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 89d3848..bd0b4ac 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -187,6 +187,19 @@ int ath9k_htc_tx_start(struct ath9k_htc_priv *priv, struct sk_buff *skb)
 	return htc_send(priv->htc, skb, epid, &tx_ctl);
 }
 
+static bool ath9k_htc_check_tx_aggr(struct ath9k_htc_priv *priv,
+				    struct ath9k_htc_sta *ista, u8 tid)
+{
+	bool ret = false;
+
+	spin_lock_bh(&priv->tx_lock);
+	if ((tid < ATH9K_HTC_MAX_TID) && (ista->tid_state[tid] == AGGR_STOP))
+		ret = true;
+	spin_unlock_bh(&priv->tx_lock);
+
+	return ret;
+}
+
 void ath9k_tx_tasklet(unsigned long data)
 {
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
@@ -216,8 +229,7 @@ void ath9k_tx_tasklet(unsigned long data)
 		/* Check if we need to start aggregation */
 
 		if (sta && conf_is_ht(&priv->hw->conf) &&
-		    (priv->op_flags & OP_TXAGGR)
-		    && !(skb->protocol == cpu_to_be16(ETH_P_PAE))) {
+		    !(skb->protocol == cpu_to_be16(ETH_P_PAE))) {
 			if (ieee80211_is_data_qos(fc)) {
 				u8 *qc, tid;
 				struct ath9k_htc_sta *ista;
@@ -226,10 +238,11 @@ void ath9k_tx_tasklet(unsigned long data)
 				tid = qc[0] & 0xf;
 				ista = (struct ath9k_htc_sta *)sta->drv_priv;
 
-				if ((tid < ATH9K_HTC_MAX_TID) &&
-				    ista->tid_state[tid] == AGGR_STOP) {
+				if (ath9k_htc_check_tx_aggr(priv, ista, tid)) {
 					ieee80211_start_tx_ba_session(sta, tid);
+					spin_lock_bh(&priv->tx_lock);
 					ista->tid_state[tid] = AGGR_PROGRESS;
+					spin_unlock_bh(&priv->tx_lock);
 				}
 			}
 		}
-- 
1.7.1

