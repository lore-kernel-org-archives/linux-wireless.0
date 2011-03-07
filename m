Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59154 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab1CGCNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 21:13:36 -0500
Received: by iwn34 with SMTP id 34so3545301iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 18:13:35 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19828.16199.41128.797005@gargle.gargle.HOWL>
Date: Mon, 7 Mar 2011 07:43:27 +0530
To: linux-wireless@vger.kernel.org
CC: ath9k-devel@lists.ath9k.org
Subject: [RFC 08/34] ath9k_htc: Queue WMI events
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Use a queue to handle WMI events and schedule a tasklet
to process the events. This fixes the race between the
WMI event ISR and the SWBA tasklet when the arrival of
WMI events in quick succession could overwrite the SWBA
data before the tasklet from a previous iteration could
have been scheduled. Also, drain the WMI queue properly.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h            |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |   27 +++----
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c   |    3 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c   |    2 -
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |    7 ++-
 drivers/net/wireless/ath/ath9k/wmi.c            |   97 +++++++++++++++--------
 drivers/net/wireless/ath/ath9k/wmi.h            |    7 +-
 7 files changed, 89 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 7cc5cf3..0f72c19 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -494,7 +494,8 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv);
 void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 			     struct ieee80211_vif *vif);
 void ath9k_htc_beacon_reconfig(struct ath9k_htc_priv *priv);
-void ath9k_htc_swba(struct ath9k_htc_priv *priv);
+void ath9k_htc_swba(struct ath9k_htc_priv *priv,
+		    struct wmi_event_swba *swba);
 
 void ath9k_htc_rxep(void *priv, struct sk_buff *skb,
 		    enum htc_endpoint_id ep_id);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 1cd9dd2..0c48498 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -405,10 +405,10 @@ static void ath9k_htc_send_beacon(struct ath9k_htc_priv *priv,
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
@@ -416,10 +416,7 @@ static int ath9k_htc_choose_bslot(struct ath9k_htc_priv *priv)
 
 	intval = priv->cur_beacon_conf.beacon_interval & ATH9K_BEACON_PERIOD;
 
-	spin_lock_irqsave(&priv->wmi->wmi_lock, flags);
-	tsf = priv->wmi->tsf;
-	spin_unlock_irqrestore(&priv->wmi->wmi_lock, flags);
-
+	tsf = be64_to_cpu(swba->tsf);
 	tsftu = TSF_TO_TU(tsf >> 32, tsf);
 	slot = ((tsftu % intval) * ATH9K_HTC_MAX_BCN_VIF) / intval;
 	slot = ATH9K_HTC_MAX_BCN_VIF - slot - 1;
@@ -431,33 +428,31 @@ static int ath9k_htc_choose_bslot(struct ath9k_htc_priv *priv)
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
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index 7e630a8..459ba0d 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -436,6 +436,9 @@ void ath9k_htc_radio_disable(struct ieee80211_hw *hw)
 	/* Stop RX */
 	WMI_CMD(WMI_STOP_RECV_CMDID);
 
+	/* Clear the WMI event queue */
+	ath9k_wmi_event_drain(priv);
+
 	/*
 	 * The MIB counters have to be disabled here,
 	 * since the target doesn't do it.
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index f3a2b56..2250ac5 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -673,8 +673,6 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	spin_lock_init(&priv->tx_lock);
 	mutex_init(&priv->mutex);
 	mutex_init(&priv->htc_pm_lock);
-	tasklet_init(&priv->swba_tasklet, ath9k_swba_tasklet,
-		     (unsigned long)priv);
 	tasklet_init(&priv->rx_tasklet, ath9k_rx_tasklet,
 		     (unsigned long)priv);
 	tasklet_init(&priv->tx_tasklet, ath9k_tx_tasklet,
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 8f38075..81dfe07 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -202,6 +202,8 @@ void ath9k_htc_reset(struct ath9k_htc_priv *priv)
 	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
 	WMI_CMD(WMI_STOP_RECV_CMDID);
 
+	ath9k_wmi_event_drain(priv);
+
 	caldata = &priv->caldata;
 	ret = ath9k_hw_reset(ah, ah->curchan, caldata, false);
 	if (ret) {
@@ -255,6 +257,8 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
 	WMI_CMD(WMI_STOP_RECV_CMDID);
 
+	ath9k_wmi_event_drain(priv);
+
 	ath_dbg(common, ATH_DBG_CONFIG,
 		"(%u MHz) -> (%u MHz), HT: %d, HT40: %d fastcc: %d\n",
 		priv->ah->curchan->channel,
@@ -1172,12 +1176,13 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
 	WMI_CMD(WMI_STOP_RECV_CMDID);
 
-	tasklet_kill(&priv->swba_tasklet);
 	tasklet_kill(&priv->rx_tasklet);
 	tasklet_kill(&priv->tx_tasklet);
 
 	skb_queue_purge(&priv->tx_queue);
 
+	ath9k_wmi_event_drain(priv);
+
 	mutex_unlock(&priv->mutex);
 
 	/* Cancel all the running timers/work .. */
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 768194d..39088be 100644
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
@@ -120,11 +123,64 @@ void ath9k_deinit_wmi(struct ath9k_htc_priv *priv)
 	kfree(priv->wmi);
 }
 
-void ath9k_swba_tasklet(unsigned long data)
+void ath9k_wmi_event_drain(struct ath9k_htc_priv *priv)
 {
-	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
+	unsigned long flags;
 
-	ath9k_htc_swba(priv);
+	tasklet_kill(&priv->wmi->wmi_event_tasklet);
+	spin_lock_irqsave(&priv->wmi->wmi_lock, flags);
+	__skb_queue_purge(&priv->wmi->wmi_event_queue);
+	spin_unlock_irqrestore(&priv->wmi->wmi_lock, flags);
+}
+
+void ath9k_wmi_event_tasklet(unsigned long data)
+{
+	struct wmi *wmi = (struct wmi *)data;
+	struct ath9k_htc_priv *priv = wmi->drv_priv;
+	struct wmi_cmd_hdr *hdr;
+	void *wmi_event;
+	struct wmi_event_swba *swba;
+	struct sk_buff *skb = NULL;
+	unsigned long flags;
+	u16 cmd_id;
+#ifdef CONFIG_ATH9K_HTC_DEBUGFS
+	__be32 txrate;
+#endif
+
+	do {
+		spin_lock_irqsave(&wmi->wmi_lock, flags);
+		skb = __skb_dequeue(&wmi->wmi_event_queue);
+		if (!skb) {
+			spin_unlock_irqrestore(&wmi->wmi_lock, flags);
+			return;
+		}
+		spin_unlock_irqrestore(&wmi->wmi_lock, flags);
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
+
+		kfree_skb(skb);
+	} while (1);
 }
 
 void ath9k_fatal_work(struct work_struct *work)
@@ -153,11 +209,6 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
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
@@ -166,32 +217,10 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
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
+		spin_lock(&wmi->wmi_lock);
+		__skb_queue_tail(&wmi->wmi_event_queue, skb);
+		spin_unlock(&wmi->wmi_lock);
+		tasklet_schedule(&wmi->wmi_event_tasklet);
 		return;
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index 24f16fa..ee675dd 100644
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
@@ -123,8 +123,9 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 		  u8 *cmd_buf, u32 cmd_len,
 		  u8 *rsp_buf, u32 rsp_len,
 		  u32 timeout);
-void ath9k_swba_tasklet(unsigned long data);
+void ath9k_wmi_event_tasklet(unsigned long data);
 void ath9k_fatal_work(struct work_struct *work);
+void ath9k_wmi_event_drain(struct ath9k_htc_priv *priv);
 
 #define WMI_CMD(_wmi_cmd)						\
 	do {								\
-- 
1.7.4.1

