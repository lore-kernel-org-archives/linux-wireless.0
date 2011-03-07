Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47324 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950Ab1CGCOh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:14:37 -0500
Received: by mail-yx0-f174.google.com with SMTP id 7so1452952yxs.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:14:37 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16260.281994.652408@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:44:28 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 17/34] ath9k_htc: Move TX specific stuff to a separate structure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |   19 ++++++++++++-------
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c |    8 ++++----
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   22 +++++++++++-----------
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   24 ++++++++++++------------
 5 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index b134d41..5f30d91 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -257,6 +257,13 @@ struct ath9k_htc_rx {
 	spinlock_t rxbuflock;
 };
 
+struct ath9k_htc_tx {
+	bool tx_queues_stop;
+	spinlock_t tx_lock;
+
+	struct sk_buff_head tx_queue;
+};
+
 struct ath9k_htc_tx_ctl {
 	u8 type; /* ATH9K_HTC_* */
 };
@@ -427,22 +434,20 @@ struct ath9k_htc_priv {
 	u16 nstations;
 	bool rearm_ani;
 	bool reconfig_beacon;
+	unsigned int rxfilter;
 
 	struct ath9k_hw_cal_data caldata;
+	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
 
 	spinlock_t beacon_lock;
+	struct htc_beacon_config cur_beacon_conf;
 
-	bool tx_queues_stop;
-	spinlock_t tx_lock;
+	struct ath9k_htc_rx rx;
+	struct ath9k_htc_tx tx;
 
-	struct htc_beacon_config cur_beacon_conf;
-	unsigned int rxfilter;
 	struct tasklet_struct swba_tasklet;
 	struct tasklet_struct rx_tasklet;
-	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
-	struct ath9k_htc_rx rx;
 	struct tasklet_struct tx_tasklet;
-	struct sk_buff_head tx_queue;
 	struct delayed_work ani_work;
 	struct work_struct ps_work;
 	struct work_struct fatal_work;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 459ba0d..1f6df4a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -398,9 +398,9 @@ void ath9k_htc_radio_enable(struct ieee80211_hw *hw)
 
 	/* Start TX */
 	htc_start(priv->htc);
-	spin_lock_bh(&priv->tx_lock);
-	priv->tx_queues_stop = false;
-	spin_unlock_bh(&priv->tx_lock);
+	spin_lock_bh(&priv->tx.tx_lock);
+	priv->tx.tx_queues_stop = false;
+	spin_unlock_bh(&priv->tx.tx_lock);
 	ieee80211_wake_queues(hw);
 
 	WMI_CMD(WMI_ENABLE_INTR_CMDID);
@@ -431,7 +431,7 @@ void ath9k_htc_radio_disable(struct ieee80211_hw *hw)
 	ieee80211_stop_queues(hw);
 	htc_stop(priv->htc);
 	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
-	skb_queue_purge(&priv->tx_queue);
+	skb_queue_purge(&priv->tx.tx_queue);
 
 	/* Stop RX */
 	WMI_CMD(WMI_STOP_RECV_CMDID);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 2250ac5..1fa869a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -670,7 +670,7 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 
 	spin_lock_init(&priv->wmi->wmi_lock);
 	spin_lock_init(&priv->beacon_lock);
-	spin_lock_init(&priv->tx_lock);
+	spin_lock_init(&priv->tx.tx_lock);
 	mutex_init(&priv->mutex);
 	mutex_init(&priv->htc_pm_lock);
 	tasklet_init(&priv->rx_tasklet, ath9k_rx_tasklet,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 4002267..ff3a495 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -707,9 +707,9 @@ static int ath9k_htc_tx_aggr_oper(struct ath9k_htc_priv *priv,
 			(aggr.aggr_enable) ? "Starting" : "Stopping",
 			sta->addr, tid);
 
-	spin_lock_bh(&priv->tx_lock);
+	spin_lock_bh(&priv->tx.tx_lock);
 	ista->tid_state[tid] = (aggr.aggr_enable && !ret) ? AGGR_START : AGGR_STOP;
-	spin_unlock_bh(&priv->tx_lock);
+	spin_unlock_bh(&priv->tx.tx_lock);
 
 	return ret;
 }
@@ -853,9 +853,9 @@ static void ath9k_htc_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 			ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_XMIT,
 				"Stopping TX queues\n");
 			ieee80211_stop_queues(hw);
-			spin_lock_bh(&priv->tx_lock);
-			priv->tx_queues_stop = true;
-			spin_unlock_bh(&priv->tx_lock);
+			spin_lock_bh(&priv->tx.tx_lock);
+			priv->tx.tx_queues_stop = true;
+			spin_unlock_bh(&priv->tx.tx_lock);
 		} else {
 			ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_XMIT,
 				"Tx failed\n");
@@ -923,9 +923,9 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 	priv->op_flags &= ~OP_INVALID;
 	htc_start(priv->htc);
 
-	spin_lock_bh(&priv->tx_lock);
-	priv->tx_queues_stop = false;
-	spin_unlock_bh(&priv->tx_lock);
+	spin_lock_bh(&priv->tx.tx_lock);
+	priv->tx.tx_queues_stop = false;
+	spin_unlock_bh(&priv->tx.tx_lock);
 
 	ieee80211_wake_queues(hw);
 
@@ -965,7 +965,7 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	tasklet_kill(&priv->rx_tasklet);
 	tasklet_kill(&priv->tx_tasklet);
 
-	skb_queue_purge(&priv->tx_queue);
+	skb_queue_purge(&priv->tx.tx_queue);
 
 	ath9k_wmi_event_drain(priv);
 
@@ -1563,9 +1563,9 @@ static int ath9k_htc_ampdu_action(struct ieee80211_hw *hw,
 		break;
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		ista = (struct ath9k_htc_sta *) sta->drv_priv;
-		spin_lock_bh(&priv->tx_lock);
+		spin_lock_bh(&priv->tx.tx_lock);
 		ista->tid_state[tid] = AGGR_OPERATIONAL;
-		spin_unlock_bh(&priv->tx_lock);
+		spin_unlock_bh(&priv->tx.tx_lock);
 		break;
 	default:
 		ath_err(ath9k_hw_common(priv->ah), "Unknown AMPDU action\n");
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index ab55dff..6f7987d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -239,10 +239,10 @@ static bool ath9k_htc_check_tx_aggr(struct ath9k_htc_priv *priv,
 {
 	bool ret = false;
 
-	spin_lock_bh(&priv->tx_lock);
+	spin_lock_bh(&priv->tx.tx_lock);
 	if ((tid < ATH9K_HTC_MAX_TID) && (ista->tid_state[tid] == AGGR_STOP))
 		ret = true;
-	spin_unlock_bh(&priv->tx_lock);
+	spin_unlock_bh(&priv->tx.tx_lock);
 
 	return ret;
 }
@@ -257,7 +257,7 @@ void ath9k_tx_tasklet(unsigned long data)
 	struct sk_buff *skb = NULL;
 	__le16 fc;
 
-	while ((skb = skb_dequeue(&priv->tx_queue)) != NULL) {
+	while ((skb = skb_dequeue(&priv->tx.tx_queue)) != NULL) {
 
 		hdr = (struct ieee80211_hdr *) skb->data;
 		fc = hdr->frame_control;
@@ -292,9 +292,9 @@ void ath9k_tx_tasklet(unsigned long data)
 
 				if (ath9k_htc_check_tx_aggr(priv, ista, tid)) {
 					ieee80211_start_tx_ba_session(sta, tid, 0);
-					spin_lock_bh(&priv->tx_lock);
+					spin_lock_bh(&priv->tx.tx_lock);
 					ista->tid_state[tid] = AGGR_PROGRESS;
-					spin_unlock_bh(&priv->tx_lock);
+					spin_unlock_bh(&priv->tx.tx_lock);
 				}
 			}
 		}
@@ -307,16 +307,16 @@ void ath9k_tx_tasklet(unsigned long data)
 	}
 
 	/* Wake TX queues if needed */
-	spin_lock_bh(&priv->tx_lock);
-	if (priv->tx_queues_stop) {
-		priv->tx_queues_stop = false;
-		spin_unlock_bh(&priv->tx_lock);
+	spin_lock_bh(&priv->tx.tx_lock);
+	if (priv->tx.tx_queues_stop) {
+		priv->tx.tx_queues_stop = false;
+		spin_unlock_bh(&priv->tx.tx_lock);
 		ath_dbg(ath9k_hw_common(priv->ah), ATH_DBG_XMIT,
 			"Waking up TX queues\n");
 		ieee80211_wake_queues(priv->hw);
 		return;
 	}
-	spin_unlock_bh(&priv->tx_lock);
+	spin_unlock_bh(&priv->tx.tx_lock);
 }
 
 void ath9k_htc_txep(void *drv_priv, struct sk_buff *skb,
@@ -348,13 +348,13 @@ void ath9k_htc_txep(void *drv_priv, struct sk_buff *skb,
 	if (txok)
 		tx_info->flags |= IEEE80211_TX_STAT_ACK;
 
-	skb_queue_tail(&priv->tx_queue, skb);
+	skb_queue_tail(&priv->tx.tx_queue, skb);
 	tasklet_schedule(&priv->tx_tasklet);
 }
 
 int ath9k_tx_init(struct ath9k_htc_priv *priv)
 {
-	skb_queue_head_init(&priv->tx_queue);
+	skb_queue_head_init(&priv->tx.tx_queue);
 	return 0;
 }
 
-- 
1.7.4.1

