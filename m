Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47645 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856Ab1AUDDm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 22:03:42 -0500
Received: by iwn9 with SMTP id 9so1251567iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 19:03:42 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19768.63328.487198.827584@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 08:32:56 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC/WIP 25/33] ath9k_htc: Queue WMI events
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Use a queue to handle WMI events and schedule a tasklet
to process the events. This fixes the race between the
WMI event ISR and the SWBA tasklet when the arrival of
WMI events in quick succession could overwrite the SWBA
data before the tasklet from a previous iteration could
have been scheduled.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   27 +++-----
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |    3 -
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |    1 +
 drivers/net/wireless/ath/ath9k/wmi.c            |   78 +++++++++++++----------
 drivers/net/wireless/ath/ath9k/wmi.h            |    6 +-
 6 files changed, 61 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 3aa73fc..742777e 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -492,7 +492,8 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv);
 void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 			     struct ieee80211_vif *vif);
 void ath9k_htc_beacon_reconfig(struct ath9k_htc_priv *priv);
-void ath9k_htc_swba(struct ath9k_htc_priv *priv);
+void ath9k_htc_swba(struct ath9k_htc_priv *priv,
+		    struct wmi_event_swba *swba);
 
 void ath9k_htc_rxep(void *priv, struct sk_buff *skb,
 		    enum htc_endpoint_id ep_id);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 42a1758..c3eae71 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -404,10 +404,10 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
 	spin_unlock_bh(&priv->beacon_lock);
 }
 
-static int ath9k_htc_choose_bslot(struct ath9k_htc_priv *priv)
+static int ath9k_htc_choose_bslot(struct ath9k_htc_priv *priv,
+				  struct wmi_event_swba *swba)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
-	unsigned long flags;
 	u64 tsf;
 	u32 tsftu;
 	u16 intval;
@@ -415,10 +415,7 @@ static int ath9k_htc_choose_bslot(struct ath9k_htc_priv *priv)
 
 	intval = priv->cur_beacon_conf.beacon_interval & ATH9K_BEACON_PERIOD;
 
-	spin_lock_irqsave(&priv->wmi->wmi_lock, flags);
-	tsf = priv->wmi->tsf;
-	spin_unlock_irqrestore(&priv->wmi->wmi_lock, flags);
-
+	tsf = be64_to_cpu(swba->tsf);
 	tsftu = TSF_TO_TU(tsf >> 32, tsf);
 	slot = ((tsftu % intval) * ATH9K_HTC_MAX_BCN_VIF) / intval;
 	slot = ATH9K_HTC_MAX_BCN_VIF - slot - 1;
@@ -430,33 +427,31 @@ static int ath9k_htc_choose_bslot(struct ath9k_htc_priv *priv)
 	return slot;
 }
 
-void ath9k_htc_swba(struct ath9k_htc_priv *priv)
+void ath9k_htc_swba(struct ath9k_htc_priv *priv,
+		    struct wmi_event_swba *swba)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
-	unsigned long flags;
 	int slot;
 
-	spin_lock_irqsave(&priv->wmi->wmi_lock, flags);
-	if (priv->wmi->beacon_pending != 0) {
-		spin_unlock_irqrestore(&priv->wmi->wmi_lock, flags);
+	if (swba->beacon_pending != 0) {
 		priv->cur_beacon_conf.bmiss_cnt++;
 		if (priv->cur_beacon_conf.bmiss_cnt > BSTUCK_THRESHOLD) {
-			ath_dbg(common, ATH_DBG_BEACON,
+			ath_dbg(common, ATH_DBG_BSTUCK,
 				"Beacon stuck, HW reset\n");
-			ath9k_htc_reset(priv);
+			ieee80211_queue_work(priv->hw,
+					     &priv->fatal_work);
 		}
 		return;
 	}
-	spin_unlock_irqrestore(&priv->wmi->wmi_lock, flags);
 
 	if (priv->cur_beacon_conf.bmiss_cnt) {
-		ath_dbg(common, ATH_DBG_BEACON,
+		ath_dbg(common, ATH_DBG_BSTUCK,
 			"Resuming beacon xmit after %u misses\n",
 			priv->cur_beacon_conf.bmiss_cnt);
 		priv->cur_beacon_conf.bmiss_cnt = 0;
 	}
 
-	slot = ath9k_htc_choose_bslot(priv);
+	slot = ath9k_htc_choose_bslot(priv, swba);
 	spin_lock_bh(&priv->beacon_lock);
 	if (priv->cur_beacon_conf.bslot[slot] == NULL) {
 		spin_unlock_bh(&priv->beacon_lock);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index b4ae719..09f8e1e 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -142,7 +142,6 @@ static void ath9k_deinit_priv(struct ath9k_htc_priv *priv)
 {
 	ath9k_htc_exit_debug(priv->ah);
 	ath9k_hw_deinit(priv->ah);
-	tasklet_kill(&priv->swba_tasklet);
 	tasklet_kill(&priv->rx_tasklet);
 	tasklet_kill(&priv->tx_tasklet);
 	kfree(priv->ah);
@@ -676,8 +675,6 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	spin_lock_init(&priv->tx_lock);
 	mutex_init(&priv->mutex);
 	mutex_init(&priv->htc_pm_lock);
-	tasklet_init(&priv->swba_tasklet, ath9k_swba_tasklet,
-		     (unsigned long)priv);
 	tasklet_init(&priv->rx_tasklet, ath9k_rx_tasklet,
 		     (unsigned long)priv);
 	tasklet_init(&priv->tx_tasklet, ath9k_tx_tasklet,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index cc05177..68a7687 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1180,6 +1180,7 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
 	WMI_CMD(WMI_STOP_RECV_CMDID);
 	skb_queue_purge(&priv->tx_queue);
+	skb_queue_purge(&priv->wmi->wmi_event_queue);
 
 	if (ah->btcoex_hw.enabled) {
 		ath9k_hw_btcoex_disable(ah);
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 768194d..9c11d6e 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -102,9 +102,12 @@ struct wmi *ath9k_init_wmi(struct ath9k_htc_priv *priv)
 
 	wmi->drv_priv = priv;
 	wmi->stopped = false;
+	skb_queue_head_init(&wmi->wmi_event_queue);
 	mutex_init(&wmi->op_mutex);
 	mutex_init(&wmi->multi_write_mutex);
 	init_completion(&wmi->cmd_wait);
+	tasklet_init(&wmi->wmi_event_tasklet, ath9k_wmi_event_tasklet,
+		     (unsigned long)wmi);
 
 	return wmi;
 }
@@ -115,16 +118,52 @@ void ath9k_deinit_wmi(struct ath9k_htc_priv *priv)
 
 	mutex_lock(&wmi->op_mutex);
 	wmi->stopped = true;
+	tasklet_kill(&wmi->wmi_event_tasklet);
 	mutex_unlock(&wmi->op_mutex);
 
 	kfree(priv->wmi);
 }
 
-void ath9k_swba_tasklet(unsigned long data)
+void ath9k_wmi_event_tasklet(unsigned long data)
 {
-	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
+	struct wmi *wmi = (struct wmi *)data;
+	struct ath9k_htc_priv *priv = wmi->drv_priv;
+	struct wmi_cmd_hdr *hdr;
+	void *wmi_event;
+	struct wmi_event_swba *swba;
+	struct sk_buff *skb = NULL;
+	u16 cmd_id;
+#ifdef CONFIG_ATH9K_HTC_DEBUGFS
+	__be32 txrate;
+#endif
+
+	while ((skb = skb_dequeue(&wmi->wmi_event_queue)) != NULL) {
+
+		hdr = (struct wmi_cmd_hdr *) skb->data;
+		cmd_id = be16_to_cpu(hdr->command_id);
+		wmi_event = skb_pull(skb, sizeof(struct wmi_cmd_hdr));
+
+		switch (cmd_id) {
+		case WMI_SWBA_EVENTID:
+			swba = (struct wmi_event_swba *) wmi_event;
+			ath9k_htc_swba(priv, swba);
+			break;
+		case WMI_FATAL_EVENTID:
+			ieee80211_queue_work(wmi->drv_priv->hw,
+					     &wmi->drv_priv->fatal_work);
+			break;
+		case WMI_TXRATE_EVENTID:
+#ifdef CONFIG_ATH9K_HTC_DEBUGFS
+			txrate = ((struct wmi_event_txrate *)wmi_event)->txrate;
+			wmi->drv_priv->debug.txrate = be32_to_cpu(txrate);
+#endif
+			break;
+		default:
+			break;
+		}
 
-	ath9k_htc_swba(priv);
+		kfree_skb(skb);
+	}
 }
 
 void ath9k_fatal_work(struct work_struct *work)
@@ -153,11 +192,6 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 	struct wmi *wmi = (struct wmi *) priv;
 	struct wmi_cmd_hdr *hdr;
 	u16 cmd_id;
-	void *wmi_event;
-	struct wmi_event_swba *swba;
-#ifdef CONFIG_ATH9K_HTC_DEBUGFS
-	__be32 txrate;
-#endif
 
 	if (unlikely(wmi->stopped))
 		goto free_skb;
@@ -166,32 +200,8 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 	cmd_id = be16_to_cpu(hdr->command_id);
 
 	if (cmd_id & 0x1000) {
-		wmi_event = skb_pull(skb, sizeof(struct wmi_cmd_hdr));
-		switch (cmd_id) {
-		case WMI_SWBA_EVENTID:
-			swba = (struct wmi_event_swba *) wmi_event;
-
-			spin_lock(&wmi->wmi_lock);
-			wmi->tsf = be64_to_cpu(swba->tsf);
-			wmi->beacon_pending = swba->beacon_pending;
-			spin_unlock(&wmi->wmi_lock);
-
-			tasklet_schedule(&wmi->drv_priv->swba_tasklet);
-			break;
-		case WMI_FATAL_EVENTID:
-			ieee80211_queue_work(wmi->drv_priv->hw,
-					     &wmi->drv_priv->fatal_work);
-			break;
-		case WMI_TXRATE_EVENTID:
-#ifdef CONFIG_ATH9K_HTC_DEBUGFS
-			txrate = ((struct wmi_event_txrate *)wmi_event)->txrate;
-			wmi->drv_priv->debug.txrate = be32_to_cpu(txrate);
-#endif
-			break;
-		default:
-			break;
-		}
-		kfree_skb(skb);
+		skb_queue_tail(&wmi->wmi_event_queue, skb);
+		tasklet_schedule(&wmi->wmi_event_tasklet);
 		return;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 24f16fa..b705961 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -100,13 +100,13 @@ struct wmi {
 	struct mutex op_mutex;
 	struct completion cmd_wait;
 	enum wmi_cmd_id last_cmd_id;
+	struct sk_buff_head wmi_event_queue;
+	struct tasklet_struct wmi_event_tasklet;
 	u16 tx_seq_id;
 	u8 *cmd_rsp_buf;
 	u32 cmd_rsp_len;
 	bool stopped;
 
-	u64 tsf;
-	u8 beacon_pending;
 	spinlock_t wmi_lock;
 
 	atomic_t mwrite_cnt;
@@ -123,7 +123,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 		  u8 *cmd_buf, u32 cmd_len,
 		  u8 *rsp_buf, u32 rsp_len,
 		  u32 timeout);
-void ath9k_swba_tasklet(unsigned long data);
+void ath9k_wmi_event_tasklet(unsigned long data);
 void ath9k_fatal_work(struct work_struct *work);
 
 #define WMI_CMD(_wmi_cmd)						\
-- 
1.7.3.5

