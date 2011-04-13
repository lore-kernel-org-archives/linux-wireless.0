Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39974 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab1DMFyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 01:54:15 -0400
Received: by pvg12 with SMTP id 12so108068pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 22:54:15 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19877.15127.8005.789030@gargle.gargle.HOWL>
Date: Wed, 13 Apr 2011 11:26:39 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 36/40] ath9k_htc: Add a timer to cleanup WMI events
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Occasionally, a WMI event would arrive ahead of the TX
URB completion handler. Discarding these events would exhaust
the available TX slots, so handle them by running a timer
cleaning up such events. Also, timeout packets for which TX
completion events have not arrived.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    8 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   12 +++
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |  127 ++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/wmi.c          |    3 +
 drivers/net/wireless/ath/ath9k/wmi.h          |    9 ++
 6 files changed, 159 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index b40753c..b413b46 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -262,7 +262,10 @@ struct ath9k_htc_rx {
 	spinlock_t rxbuflock;
 };
 
-#define ATH9K_HTC_TX_RESERVE   10
+#define ATH9K_HTC_TX_CLEANUP_INTERVAL 50 /* ms */
+#define ATH9K_HTC_TX_TIMEOUT_INTERVAL 2500 /* ms */
+#define ATH9K_HTC_TX_RESERVE 10
+#define ATH9K_HTC_TX_TIMEOUT_COUNT 20
 #define ATH9K_HTC_TX_THRESHOLD (MAX_TX_BUF_NUM - ATH9K_HTC_TX_RESERVE)
 
 #define ATH9K_HTC_OP_TX_QUEUES_STOP BIT(0)
@@ -279,6 +282,7 @@ struct ath9k_htc_tx {
 	struct sk_buff_head data_vo_queue;
 	struct sk_buff_head tx_failed;
 	DECLARE_BITMAP(tx_slot, MAX_TX_BUF_NUM);
+	struct timer_list cleanup_timer;
 	spinlock_t tx_lock;
 };
 
@@ -287,6 +291,7 @@ struct ath9k_htc_tx_ctl {
 	u8 epid;
 	u8 txok;
 	u8 sta_idx;
+	unsigned long timestamp;
 };
 
 static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
@@ -557,6 +562,7 @@ void ath9k_htc_tx_drain(struct ath9k_htc_priv *priv);
 void ath9k_htc_txstatus(struct ath9k_htc_priv *priv, void *wmi_event);
 void ath9k_htc_tx_failed(struct ath9k_htc_priv *priv);
 void ath9k_tx_failed_tasklet(unsigned long data);
+void ath9k_htc_tx_cleanup_timer(unsigned long data);
 
 int ath9k_rx_init(struct ath9k_htc_priv *priv);
 void ath9k_rx_cleanup(struct ath9k_htc_priv *priv);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index afceeaa..0aec259 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -671,7 +671,6 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	common->priv = priv;
 	common->debug_mask = ath9k_debug;
 
-	spin_lock_init(&priv->wmi->wmi_lock);
 	spin_lock_init(&priv->beacon_lock);
 	spin_lock_init(&priv->tx.tx_lock);
 	mutex_init(&priv->mutex);
@@ -683,6 +682,8 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	INIT_DELAYED_WORK(&priv->ani_work, ath9k_htc_ani_work);
 	INIT_WORK(&priv->ps_work, ath9k_ps_work);
 	INIT_WORK(&priv->fatal_work, ath9k_fatal_work);
+	setup_timer(&priv->tx.cleanup_timer, ath9k_htc_tx_cleanup_timer,
+		    (unsigned long)priv);
 
 	/*
 	 * Cache line size is used to size and align various
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index ae85cc4..4de3864 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -194,6 +194,7 @@ void ath9k_htc_reset(struct ath9k_htc_priv *priv)
 	ath9k_htc_stop_ani(priv);
 	ieee80211_stop_queues(priv->hw);
 
+	del_timer_sync(&priv->tx.cleanup_timer);
 	ath9k_htc_tx_drain(priv);
 
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
@@ -225,6 +226,9 @@ void ath9k_htc_reset(struct ath9k_htc_priv *priv)
 	ath9k_htc_vif_reconfig(priv);
 	ieee80211_wake_queues(priv->hw);
 
+	mod_timer(&priv->tx.cleanup_timer,
+		  jiffies + msecs_to_jiffies(ATH9K_HTC_TX_CLEANUP_INTERVAL));
+
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
 }
@@ -251,6 +255,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 
 	ath9k_htc_ps_wakeup(priv);
 
+	del_timer_sync(&priv->tx.cleanup_timer);
 	ath9k_htc_tx_drain(priv);
 
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
@@ -301,6 +306,9 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	    !(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL))
 		ath9k_htc_vif_reconfig(priv);
 
+	mod_timer(&priv->tx.cleanup_timer,
+		  jiffies + msecs_to_jiffies(ATH9K_HTC_TX_CLEANUP_INTERVAL));
+
 err:
 	ath9k_htc_ps_restore(priv);
 	return ret;
@@ -937,6 +945,9 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 
 	ieee80211_wake_queues(hw);
 
+	mod_timer(&priv->tx.cleanup_timer,
+		  jiffies + msecs_to_jiffies(ATH9K_HTC_TX_CLEANUP_INTERVAL));
+
 	if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE) {
 		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
 					   AR_STOMP_LOW_WLAN_WGHT);
@@ -972,6 +983,7 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 
 	tasklet_kill(&priv->rx_tasklet);
 
+	del_timer_sync(&priv->tx.cleanup_timer);
 	ath9k_htc_tx_drain(priv);
 	ath9k_wmi_event_drain(priv);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index a9b6bb1..86f5ce9 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -495,6 +495,8 @@ static inline void ath9k_htc_tx_drainq(struct ath9k_htc_priv *priv,
 
 void ath9k_htc_tx_drain(struct ath9k_htc_priv *priv)
 {
+	struct ath9k_htc_tx_event *event, *tmp;
+
 	spin_lock_bh(&priv->tx.tx_lock);
 	priv->tx.flags |= ATH9K_HTC_OP_TX_DRAIN;
 	spin_unlock_bh(&priv->tx.tx_lock);
@@ -515,6 +517,16 @@ void ath9k_htc_tx_drain(struct ath9k_htc_priv *priv)
 	ath9k_htc_tx_drainq(priv, &priv->tx.data_vo_queue);
 	ath9k_htc_tx_drainq(priv, &priv->tx.tx_failed);
 
+	/*
+	 * The TX cleanup timer has already been killed.
+	 */
+	spin_lock_bh(&priv->wmi->event_lock);
+	list_for_each_entry_safe(event, tmp, &priv->wmi->pending_tx_events, list) {
+		list_del(&event->list);
+		kfree(event);
+	}
+	spin_unlock_bh(&priv->wmi->event_lock);
+
 	spin_lock_bh(&priv->tx.tx_lock);
 	priv->tx.flags &= ~ATH9K_HTC_OP_TX_DRAIN;
 	spin_unlock_bh(&priv->tx.tx_lock);
@@ -595,6 +607,7 @@ void ath9k_htc_txstatus(struct ath9k_htc_priv *priv, void *wmi_event)
 	struct wmi_event_txstatus *txs = (struct wmi_event_txstatus *)wmi_event;
 	struct __wmi_event_txstatus *__txs;
 	struct sk_buff *skb;
+	struct ath9k_htc_tx_event *tx_pend;
 	int i;
 
 	for (i = 0; i < txs->cnt; i++) {
@@ -603,8 +616,26 @@ void ath9k_htc_txstatus(struct ath9k_htc_priv *priv, void *wmi_event)
 		__txs = &txs->txstatus[i];
 
 		skb = ath9k_htc_tx_get_packet(priv, __txs);
-		if (!skb)
+		if (!skb) {
+			/*
+			 * Store this event, so that the TX cleanup
+			 * routine can check later for the needed packet.
+			 */
+			tx_pend = kzalloc(sizeof(struct ath9k_htc_tx_event),
+					  GFP_ATOMIC);
+			if (!tx_pend)
+				continue;
+
+			memcpy(&tx_pend->txs, __txs,
+			       sizeof(struct __wmi_event_txstatus));
+
+			spin_lock(&priv->wmi->event_lock);
+			list_add_tail(&tx_pend->list,
+				      &priv->wmi->pending_tx_events);
+			spin_unlock(&priv->wmi->event_lock);
+
 			continue;
+		}
 
 		ath9k_htc_tx_process(priv, skb, __txs);
 	}
@@ -622,6 +653,7 @@ void ath9k_htc_txep(void *drv_priv, struct sk_buff *skb,
 
 	tx_ctl = HTC_SKB_CB(skb);
 	tx_ctl->txok = txok;
+	tx_ctl->timestamp = jiffies;
 
 	if (!txok) {
 		skb_queue_tail(&priv->tx.tx_failed, skb);
@@ -638,6 +670,99 @@ void ath9k_htc_txep(void *drv_priv, struct sk_buff *skb,
 	skb_queue_tail(epid_queue, skb);
 }
 
+static inline bool check_packet(struct ath9k_htc_priv *priv, struct sk_buff *skb)
+{
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_htc_tx_ctl *tx_ctl;
+
+	tx_ctl = HTC_SKB_CB(skb);
+
+	if (time_after(jiffies,
+		       tx_ctl->timestamp +
+		       msecs_to_jiffies(ATH9K_HTC_TX_TIMEOUT_INTERVAL))) {
+		ath_dbg(common, ATH_DBG_XMIT,
+			"Dropping a packet due to TX timeout\n");
+		return true;
+	}
+
+	return false;
+}
+
+static void ath9k_htc_tx_cleanup_queue(struct ath9k_htc_priv *priv,
+				       struct sk_buff_head *epid_queue)
+{
+	bool process = false;
+	unsigned long flags;
+	struct sk_buff *skb, *tmp;
+	struct sk_buff_head queue;
+
+	skb_queue_head_init(&queue);
+
+	spin_lock_irqsave(&epid_queue->lock, flags);
+	skb_queue_walk_safe(epid_queue, skb, tmp) {
+		if (check_packet(priv, skb)) {
+			__skb_unlink(skb, epid_queue);
+			__skb_queue_tail(&queue, skb);
+			process = true;
+		}
+	}
+	spin_unlock_irqrestore(&epid_queue->lock, flags);
+
+	if (process) {
+		skb_queue_walk_safe(&queue, skb, tmp) {
+			__skb_unlink(skb, &queue);
+			ath9k_htc_tx_process(priv, skb, NULL);
+		}
+	}
+}
+
+void ath9k_htc_tx_cleanup_timer(unsigned long data)
+{
+	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *) data;
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+	struct ath9k_htc_tx_event *event, *tmp;
+	struct sk_buff *skb;
+
+	spin_lock(&priv->wmi->event_lock);
+	list_for_each_entry_safe(event, tmp, &priv->wmi->pending_tx_events, list) {
+
+		skb = ath9k_htc_tx_get_packet(priv, &event->txs);
+		if (skb) {
+			ath_dbg(common, ATH_DBG_XMIT,
+				"Found packet for cookie: %d, epid: %d\n",
+				event->txs.cookie,
+				MS(event->txs.ts_rate, ATH9K_HTC_TXSTAT_EPID));
+
+			ath9k_htc_tx_process(priv, skb, &event->txs);
+			list_del(&event->list);
+			kfree(event);
+			continue;
+		}
+
+		if (++event->count >= ATH9K_HTC_TX_TIMEOUT_COUNT) {
+			list_del(&event->list);
+			kfree(event);
+		}
+	}
+	spin_unlock(&priv->wmi->event_lock);
+
+	/*
+	 * Check if status-pending packets have to be cleaned up.
+	 */
+	ath9k_htc_tx_cleanup_queue(priv, &priv->tx.mgmt_ep_queue);
+	ath9k_htc_tx_cleanup_queue(priv, &priv->tx.cab_ep_queue);
+	ath9k_htc_tx_cleanup_queue(priv, &priv->tx.data_be_queue);
+	ath9k_htc_tx_cleanup_queue(priv, &priv->tx.data_bk_queue);
+	ath9k_htc_tx_cleanup_queue(priv, &priv->tx.data_vi_queue);
+	ath9k_htc_tx_cleanup_queue(priv, &priv->tx.data_vo_queue);
+
+	/* Wake TX queues if needed */
+	ath9k_htc_check_wake_queues(priv);
+
+	mod_timer(&priv->tx.cleanup_timer,
+		  jiffies + msecs_to_jiffies(ATH9K_HTC_TX_CLEANUP_INTERVAL));
+}
+
 int ath9k_tx_init(struct ath9k_htc_priv *priv)
 {
 	skb_queue_head_init(&priv->tx.mgmt_ep_queue);
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 3f5a4d1..697e5af 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -91,9 +91,12 @@ struct wmi *ath9k_init_wmi(struct ath9k_htc_priv *priv)
 	wmi->drv_priv = priv;
 	wmi->stopped = false;
 	skb_queue_head_init(&wmi->wmi_event_queue);
+	spin_lock_init(&wmi->wmi_lock);
+	spin_lock_init(&wmi->event_lock);
 	mutex_init(&wmi->op_mutex);
 	mutex_init(&wmi->multi_write_mutex);
 	init_completion(&wmi->cmd_wait);
+	INIT_LIST_HEAD(&wmi->pending_tx_events);
 	tasklet_init(&wmi->wmi_event_tasklet, ath9k_wmi_event_tasklet,
 		     (unsigned long)wmi);
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 44b1738..310d94e 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -130,6 +130,12 @@ struct register_write {
 	__be32 val;
 };
 
+struct ath9k_htc_tx_event {
+	int count;
+	struct __wmi_event_txstatus txs;
+	struct list_head list;
+};
+
 struct wmi {
 	struct ath9k_htc_priv *drv_priv;
 	struct htc_target *htc;
@@ -144,6 +150,9 @@ struct wmi {
 	u32 cmd_rsp_len;
 	bool stopped;
 
+	struct list_head pending_tx_events;
+	spinlock_t event_lock;
+
 	spinlock_t wmi_lock;
 
 	atomic_t mwrite_cnt;
-- 
1.7.4.4

