Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50987 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0L1I6k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 03:58:40 -0500
Received: by mail-pw0-f46.google.com with SMTP id 3so1001276pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 00:58:40 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19737.42675.933342.224490@gargle.gargle.HOWL>
Date: Tue, 28 Dec 2010 14:28:27 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, Sujith.Manoharan@atheros.com
Subject: [PATCH v2 4/6] ath9k_htc: Handle FATAL events
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The device has to be reset when a FATAL event is received.
Not doing so would leave the card in a non-working state.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    6 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c |    8 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   57 ++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/wmi.c          |   18 +++++++-
 drivers/net/wireless/ath/ath9k/wmi.h          |    3 +-
 5 files changed, 84 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index e6c2f0a..1062274 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -377,7 +377,7 @@ struct ath9k_htc_priv {
 	struct ieee80211_vif *vif;
 	struct htc_beacon_config cur_beacon_conf;
 	unsigned int rxfilter;
-	struct tasklet_struct wmi_tasklet;
+	struct tasklet_struct swba_tasklet;
 	struct tasklet_struct rx_tasklet;
 	struct ieee80211_supported_band sbands[IEEE80211_NUM_BANDS];
 	struct ath9k_htc_rx rx;
@@ -385,6 +385,7 @@ struct ath9k_htc_priv {
 	struct sk_buff_head tx_queue;
 	struct delayed_work ath9k_ani_work;
 	struct work_struct ps_work;
+	struct work_struct fatal_work;
 
 	struct mutex htc_pm_lock;
 	unsigned long ps_usecount;
@@ -419,6 +420,8 @@ static inline void ath_read_cachesize(struct ath_common *common, int *csz)
 	common->bus_ops->read_cachesize(common, csz);
 }
 
+void ath9k_htc_reset(struct ath9k_htc_priv *priv);
+
 void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv);
 void ath9k_htc_beacon_config(struct ath9k_htc_priv *priv,
 			     struct ieee80211_vif *vif);
@@ -434,6 +437,7 @@ void ath9k_htc_beaconep(void *drv_priv, struct sk_buff *skb,
 void ath9k_htc_station_work(struct work_struct *work);
 void ath9k_htc_aggr_work(struct work_struct *work);
 void ath9k_ani_work(struct work_struct *work);;
+void ath_start_ani(struct ath9k_htc_priv *priv);
 
 int ath9k_tx_init(struct ath9k_htc_priv *priv);
 void ath9k_tx_tasklet(unsigned long data);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 724f545..9150ca6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -142,7 +142,7 @@ static void ath9k_deinit_priv(struct ath9k_htc_priv *priv)
 {
 	ath9k_htc_exit_debug(priv->ah);
 	ath9k_hw_deinit(priv->ah);
-	tasklet_kill(&priv->wmi_tasklet);
+	tasklet_kill(&priv->swba_tasklet);
 	tasklet_kill(&priv->rx_tasklet);
 	tasklet_kill(&priv->tx_tasklet);
 	kfree(priv->ah);
@@ -647,13 +647,15 @@ static int ath9k_init_priv(struct ath9k_htc_priv *priv,
 	spin_lock_init(&priv->tx_lock);
 	mutex_init(&priv->mutex);
 	mutex_init(&priv->htc_pm_lock);
-	tasklet_init(&priv->wmi_tasklet, ath9k_wmi_tasklet,
+	tasklet_init(&priv->swba_tasklet, ath9k_swba_tasklet,
 		     (unsigned long)priv);
 	tasklet_init(&priv->rx_tasklet, ath9k_rx_tasklet,
 		     (unsigned long)priv);
-	tasklet_init(&priv->tx_tasklet, ath9k_tx_tasklet, (unsigned long)priv);
+	tasklet_init(&priv->tx_tasklet, ath9k_tx_tasklet,
+		     (unsigned long)priv);
 	INIT_DELAYED_WORK(&priv->ath9k_ani_work, ath9k_ani_work);
 	INIT_WORK(&priv->ps_work, ath9k_ps_work);
+	INIT_WORK(&priv->fatal_work, ath9k_fatal_work);
 
 	/*
 	 * Cache line size is used to size and align various
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 5f75f70..07f10dd 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -116,6 +116,60 @@ void ath9k_ps_work(struct work_struct *work)
 	ath9k_htc_setpower(priv, ATH9K_PM_NETWORK_SLEEP);
 }
 
+void ath9k_htc_reset(struct ath9k_htc_priv *priv)
+{
+	struct ath_hw *ah = priv->ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_channel *channel = priv->hw->conf.channel;
+	struct ath9k_hw_cal_data *caldata;
+	enum htc_phymode mode;
+	__be16 htc_mode;
+	u8 cmd_rsp;
+	int ret;
+
+	mutex_lock(&priv->mutex);
+	ath9k_htc_ps_wakeup(priv);
+
+	if (priv->op_flags & OP_ASSOCIATED)
+		cancel_delayed_work_sync(&priv->ath9k_ani_work);
+
+	ieee80211_stop_queues(priv->hw);
+	htc_stop(priv->htc);
+	WMI_CMD(WMI_DISABLE_INTR_CMDID);
+	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
+	WMI_CMD(WMI_STOP_RECV_CMDID);
+
+	caldata = &priv->caldata[channel->hw_value];
+	ret = ath9k_hw_reset(ah, ah->curchan, caldata, false);
+	if (ret) {
+		ath_err(common,
+			"Unable to reset device (%u Mhz) reset status %d\n",
+			channel->center_freq, ret);
+	}
+
+	ath_update_txpow(priv);
+
+	WMI_CMD(WMI_START_RECV_CMDID);
+	ath9k_host_rx_init(priv);
+
+	mode = ath9k_htc_get_curmode(priv, ah->curchan);
+	htc_mode = cpu_to_be16(mode);
+	WMI_CMD_BUF(WMI_SET_MODE_CMDID, &htc_mode);
+
+	WMI_CMD(WMI_ENABLE_INTR_CMDID);
+	htc_start(priv->htc);
+
+	if (priv->op_flags & OP_ASSOCIATED) {
+		ath9k_htc_beacon_config(priv, priv->vif);
+		ath_start_ani(priv);
+	}
+
+	ieee80211_wake_queues(priv->hw);
+
+	ath9k_htc_ps_restore(priv);
+	mutex_unlock(&priv->mutex);
+}
+
 static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 				 struct ieee80211_hw *hw,
 				 struct ath9k_channel *hchan)
@@ -690,7 +744,7 @@ void ath9k_htc_debug_remove_root(void)
 /* ANI */
 /*******/
 
-static void ath_start_ani(struct ath9k_htc_priv *priv)
+void ath_start_ani(struct ath9k_htc_priv *priv)
 {
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	unsigned long timestamp = jiffies_to_msecs(jiffies);
@@ -1219,6 +1273,7 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	u8 cmd_rsp;
 
 	/* Cancel all the running timers/work .. */
+	cancel_work_sync(&priv->fatal_work);
 	cancel_work_sync(&priv->ps_work);
 	cancel_delayed_work_sync(&priv->ath9k_led_blink_work);
 	ath9k_led_stop_brightness(priv);
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 573daca..dc862f5 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -120,7 +120,7 @@ void ath9k_deinit_wmi(struct ath9k_htc_priv *priv)
 	kfree(priv->wmi);
 }
 
-void ath9k_wmi_tasklet(unsigned long data)
+void ath9k_swba_tasklet(unsigned long data)
 {
 	struct ath9k_htc_priv *priv = (struct ath9k_htc_priv *)data;
 	struct ath_common *common = ath9k_hw_common(priv->ah);
@@ -131,6 +131,16 @@ void ath9k_wmi_tasklet(unsigned long data)
 
 }
 
+void ath9k_fatal_work(struct work_struct *work)
+{
+	struct ath9k_htc_priv *priv = container_of(work, struct ath9k_htc_priv,
+						   fatal_work);
+	struct ath_common *common = ath9k_hw_common(priv->ah);
+
+	ath_dbg(common, ATH_DBG_FATAL, "FATAL Event received, resetting device\n");
+	ath9k_htc_reset(priv);
+}
+
 static void ath9k_wmi_rsp_callback(struct wmi *wmi, struct sk_buff *skb)
 {
 	skb_pull(skb, sizeof(struct wmi_cmd_hdr));
@@ -163,7 +173,11 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 		switch (cmd_id) {
 		case WMI_SWBA_EVENTID:
 			wmi->beacon_pending = *(u8 *)wmi_event;
-			tasklet_schedule(&wmi->drv_priv->wmi_tasklet);
+			tasklet_schedule(&wmi->drv_priv->swba_tasklet);
+			break;
+		case WMI_FATAL_EVENTID:
+			ieee80211_queue_work(wmi->drv_priv->hw,
+					     &wmi->drv_priv->fatal_work);
 			break;
 		case WMI_TXRATE_EVENTID:
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
diff --git a/drivers/net/wireless/ath/ath9k/wmi.h b/drivers/net/wireless/ath/ath9k/wmi.h
index ac61074..4208427 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.h
+++ b/drivers/net/wireless/ath/ath9k/wmi.h
@@ -117,7 +117,8 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 		  u8 *cmd_buf, u32 cmd_len,
 		  u8 *rsp_buf, u32 rsp_len,
 		  u32 timeout);
-void ath9k_wmi_tasklet(unsigned long data);
+void ath9k_swba_tasklet(unsigned long data);
+void ath9k_fatal_work(struct work_struct *work);
 
 #define WMI_CMD(_wmi_cmd)						\
 	do {								\
-- 
1.7.3.4

