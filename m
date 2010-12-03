Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758618Ab0LCOl4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 09:41:56 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/2] iwlwifi: jiffies based tx queues watchdog
Date: Fri,  3 Dec 2010 15:41:48 +0100
Message-Id: <1291387308-5829-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1291387308-5829-1-git-send-email-sgruszka@redhat.com>
References: <1291387308-5829-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch replace monitor/recover timer by watchdog based on time
stamp. New code allow to discover hangs more precisely.

Timeout values are currently doubled monitoring period values of
previous timer. This have to be tuned based of firmware timing
capabilities.

Tested on 3945, 4965, 5300, 6300.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   21 ++----
 drivers/net/wireless/iwlwifi/iwl-core.c     |  111 ++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |   10 +--
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |   24 ++----
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   16 ++--
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    2 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   21 ++----
 13 files changed, 91 insertions(+), 138 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index fb3e371..3c983e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -228,7 +228,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 		.bt_stats_read = iwl_ucode_bt_stats_read,
 		.reply_tx_error = iwl_reply_tx_error_read,
 	},
-	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
 	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
@@ -262,7 +261,7 @@ static struct iwl_base_params iwl1000_base_params = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 128,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index d39f449..28b28ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -325,6 +325,7 @@ static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
 		return;
 	}
 
+	txq->time_stamp = jiffies;
 	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb);
 	ieee80211_tx_info_clear_status(info);
 
@@ -2730,7 +2731,6 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.isr_ops = {
 		.isr = iwl_isr_legacy,
 	},
-	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl3945_good_plcp_health,
 
 	.debugfs_ops = {
@@ -2773,7 +2773,7 @@ static struct iwl_base_params iwl3945_base_params = {
 	.led_compensation = 64,
 	.broken_powersave = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.tx_power_by_driver = true,
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 6788ceb..3f1e5f1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2198,6 +2198,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 		return;
 	}
 
+	txq->time_stamp = jiffies;
 	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb);
 	memset(&info->status, 0, sizeof(info->status));
 
@@ -2554,7 +2555,6 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.bt_stats_read = iwl_ucode_bt_stats_read,
 		.reply_tx_error = iwl_reply_tx_error_read,
 	},
-	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
 };
 
@@ -2609,7 +2609,7 @@ static struct iwl_base_params iwl4965_base_params = {
 	.led_compensation = 61,
 	.chain_noise_num_beacons = IWL4965_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.temperature_kelvin = true,
 	.max_event_log_size = 512,
 	.tx_power_by_driver = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index cf74edb..8435e5a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -402,7 +402,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 		.bt_stats_read = iwl_ucode_bt_stats_read,
 		.reply_tx_error = iwl_reply_tx_error_read,
 	},
-	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
 	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
@@ -472,7 +471,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 		.bt_stats_read = iwl_ucode_bt_stats_read,
 		.reply_tx_error = iwl_reply_tx_error_read,
 	},
-	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
 	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
@@ -511,7 +509,7 @@ static struct iwl_base_params iwl5000_base_params = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
+	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index ec41f27..0b32ce8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -339,7 +339,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.bt_stats_read = iwl_ucode_bt_stats_read,
 		.reply_tx_error = iwl_reply_tx_error_read,
 	},
-	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
 	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
@@ -412,7 +411,6 @@ static struct iwl_lib_ops iwl6000g2b_lib = {
 		.bt_stats_read = iwl_ucode_bt_stats_read,
 		.reply_tx_error = iwl_reply_tx_error_read,
 	},
-	.recover_from_tx_stall = iwl_bg_monitor_recover,
 	.check_plcp_health = iwl_good_plcp_health,
 	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
@@ -482,7 +480,7 @@ static struct iwl_base_params iwl6000_base_params = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -506,7 +504,7 @@ static struct iwl_base_params iwl6050_base_params = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1500,
-	.monitor_recover_period = IWL_DEF_MONITORING_PERIOD,
+	.wd_timeout = IWL_DEF_WD_TIMEOUT,
 	.max_event_log_size = 1024,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
@@ -529,7 +527,7 @@ static struct iwl_base_params iwl6000_coex_base_params = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
-	.monitor_recover_period = IWL_LONG_MONITORING_PERIOD,
+	.wd_timeout = IWL_LONG_WD_TIMEOUT,
 	.max_event_log_size = 512,
 	.ucode_tracing = true,
 	.sensitivity_calib_by_driver = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 407f0bb..d941910 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -405,6 +405,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 		return;
 	}
 
+	txq->time_stamp = jiffies;
 	info = IEEE80211_SKB_CB(txq->txb[txq->q.read_ptr].skb);
 	memset(&info->status, 0, sizeof(info->status));
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 50cee2b..744f352 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2654,13 +2654,8 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	/* After the ALIVE response, we can send host commands to the uCode */
 	set_bit(STATUS_ALIVE, &priv->status);
 
-	if (priv->cfg->ops->lib->recover_from_tx_stall) {
-		/* Enable timer to monitor the driver queues */
-		mod_timer(&priv->monitor_recover,
-			jiffies +
-			msecs_to_jiffies(
-			  priv->cfg->base_params->monitor_recover_period));
-	}
+	/* Enable watchdog to monitor the driver tx queues */
+	iwl_setup_watchdog(priv);
 
 	if (iwl_is_rfkill(priv))
 		return;
@@ -2755,8 +2750,7 @@ static void __iwl_down(struct iwl_priv *priv)
 
 	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
 	 * to prevent rearm timer */
-	if (priv->cfg->ops->lib->recover_from_tx_stall)
-		del_timer_sync(&priv->monitor_recover);
+	del_timer_sync(&priv->watchdog);
 
 	iwl_clear_ucode_stations(priv, NULL);
 	iwl_dealloc_bcast_stations(priv);
@@ -3742,12 +3736,9 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	priv->ucode_trace.data = (unsigned long)priv;
 	priv->ucode_trace.function = iwl_bg_ucode_trace;
 
-	if (priv->cfg->ops->lib->recover_from_tx_stall) {
-		init_timer(&priv->monitor_recover);
-		priv->monitor_recover.data = (unsigned long)priv;
-		priv->monitor_recover.function =
-			priv->cfg->ops->lib->recover_from_tx_stall;
-	}
+	init_timer(&priv->watchdog);
+	priv->watchdog.data = (unsigned long)priv;
+	priv->watchdog.function = iwl_bg_watchdog;
 
 	if (!priv->cfg->base_params->use_isr_legacy)
 		tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c41f5a8..d62b925 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1894,77 +1894,58 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL(iwl_mac_change_interface);
 
-/**
- * iwl_bg_monitor_recover - Timer callback to check for stuck queue and recover
- *
- * During normal condition (no queue is stuck), the timer is continually set to
- * execute every monitor_recover_period milliseconds after the last timer
- * expired.  When the queue read_ptr is at the same place, the timer is
- * shorten to 100mSecs.  This is
- *      1) to reduce the chance that the read_ptr may wrap around (not stuck)
- *      2) to detect the stuck queues quicker before the station and AP can
- *      disassociate each other.
- *
- * This function monitors all the tx queues and recover from it if any
- * of the queues are stuck.
- * 1. It first check the cmd queue for stuck conditions.  If it is stuck,
- *      it will recover by resetting the firmware and return.
- * 2. Then, it checks for station association.  If it associates it will check
- *      other queues.  If any queue is stuck, it will recover by resetting
- *      the firmware.
- * Note: It the number of times the queue read_ptr to be at the same place to
- *      be MAX_REPEAT+1 in order to consider to be stuck.
- */
 /*
- * The maximum number of times the read pointer of the tx queue at the
- * same place without considering to be stuck.
+ * On every watchdog tick we check (latest) time stamp. If it does not
+ * change during timeout period and queue is not empty we reset firmware.
  */
-#define MAX_REPEAT      (2)
 static int iwl_check_stuck_queue(struct iwl_priv *priv, int cnt)
 {
-	struct iwl_tx_queue *txq;
-	struct iwl_queue *q;
+	struct iwl_tx_queue *txq = &priv->txq[cnt];
+	struct iwl_queue *q = &txq->q;
+	unsigned long timeout;
+	int ret;
 
-	txq = &priv->txq[cnt];
-	q = &txq->q;
-	/* queue is empty, skip */
-	if (q->read_ptr == q->write_ptr)
+	if (q->read_ptr == q->write_ptr) {
+		txq->time_stamp = jiffies;
 		return 0;
+	}
 
-	if (q->read_ptr == q->last_read_ptr) {
-		/* a queue has not been read from last time */
-		if (q->repeat_same_read_ptr > MAX_REPEAT) {
-			IWL_ERR(priv,
-				"queue %d stuck %d time. Fw reload.\n",
-				q->id, q->repeat_same_read_ptr);
-			q->repeat_same_read_ptr = 0;
-			iwl_force_reset(priv, IWL_FW_RESET, false);
-		} else {
-			q->repeat_same_read_ptr++;
-			IWL_DEBUG_RADIO(priv,
-					"queue %d, not read %d time\n",
-					q->id,
-					q->repeat_same_read_ptr);
-			mod_timer(&priv->monitor_recover,
-				jiffies + msecs_to_jiffies(
-				IWL_ONE_HUNDRED_MSECS));
-			return 1;
-		}
-	} else {
-		q->last_read_ptr = q->read_ptr;
-		q->repeat_same_read_ptr = 0;
+	timeout = txq->time_stamp +
+		  msecs_to_jiffies(priv->cfg->base_params->wd_timeout);
+
+	if (time_after(jiffies, timeout)) {
+		IWL_ERR(priv, "Queue %d stuck for %u ms.\n",
+				q->id, priv->cfg->base_params->wd_timeout);
+		ret = iwl_force_reset(priv, IWL_FW_RESET, false);
+		return (ret == -EAGAIN) ? 0 : 1;
 	}
+
 	return 0;
 }
 
-void iwl_bg_monitor_recover(unsigned long data)
+/*
+ * Making watchdog tick be a quarter of timeout assure we will
+ * discover the queue hung between timeout and 1.25*timeout
+ */
+#define IWL_WD_TICK(timeout) ((timeout) / 4)
+
+/*
+ * Watchdog timer callback, we check each tx queue for stuck, if if hung
+ * we reset the firmware. If everything is fine just rearm the timer.
+ */
+void iwl_bg_watchdog(unsigned long data)
 {
 	struct iwl_priv *priv = (struct iwl_priv *)data;
 	int cnt;
+	unsigned long timeout;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
+	timeout = priv->cfg->base_params->wd_timeout;
+	if (timeout == 0)
+		return;
+
 	/* monitor and check for stuck cmd queue */
 	if (iwl_check_stuck_queue(priv, priv->cmd_queue))
 		return;
@@ -1979,17 +1960,23 @@ void iwl_bg_monitor_recover(unsigned long data)
 				return;
 		}
 	}
-	if (priv->cfg->base_params->monitor_recover_period) {
-		/*
-		 * Reschedule the timer to occur in
-		 * priv->cfg->base_params->monitor_recover_period
-		 */
-		mod_timer(&priv->monitor_recover, jiffies + msecs_to_jiffies(
-			  priv->cfg->base_params->monitor_recover_period));
-	}
+
+	mod_timer(&priv->watchdog, jiffies +
+		  msecs_to_jiffies(IWL_WD_TICK(timeout)));
 }
-EXPORT_SYMBOL(iwl_bg_monitor_recover);
+EXPORT_SYMBOL(iwl_bg_watchdog);
+
+void iwl_setup_watchdog(struct iwl_priv *priv)
+{
+	unsigned int timeout = priv->cfg->base_params->wd_timeout;
 
+	if (timeout)
+		mod_timer(&priv->watchdog,
+			  jiffies + msecs_to_jiffies(IWL_WD_TICK(timeout)));
+	else
+		del_timer(&priv->watchdog);
+}
+EXPORT_SYMBOL(iwl_setup_watchdog);
 
 /*
  * extended beacon time format
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 808be73..568920a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -210,8 +210,6 @@ struct iwl_lib_ops {
 
 	/* temperature */
 	struct iwl_temp_ops temp_ops;
-	/* recover from tx queue stall */
-	void (*recover_from_tx_stall)(unsigned long data);
 	/* check for plcp health */
 	bool (*check_plcp_health)(struct iwl_priv *priv,
 					struct iwl_rx_packet *pkt);
@@ -280,7 +278,7 @@ struct iwl_mod_params {
  * @plcp_delta_threshold: plcp error rate threshold used to trigger
  *	radio tuning when there is a high receiving plcp error rate
  * @chain_noise_scale: default chain noise scale used for gain computation
- * @monitor_recover_period: default timer used to check stuck queues
+ * @wd_timeout: TX queues watchdog timeout
  * @temperature_kelvin: temperature report by uCode in kelvin
  * @max_event_log_size: size of event log buffer size for ucode event logging
  * @tx_power_by_driver: tx power calibration performed by driver
@@ -315,8 +313,7 @@ struct iwl_base_params {
 	const bool support_wimax_coexist;
 	u8 plcp_delta_threshold;
 	s32 chain_noise_scale;
-	/* timer period for monitor the driver queues */
-	u32 monitor_recover_period;
+	unsigned int wd_timeout;
 	bool temperature_kelvin;
 	u32 max_event_log_size;
 	const bool tx_power_by_driver;
@@ -546,6 +543,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 			int slots_num, u32 txq_id);
 void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id);
+void iwl_setup_watchdog(struct iwl_priv *priv);
 /*****************************************************
  * TX power
  ****************************************************/
@@ -625,7 +623,7 @@ static inline u16 iwl_pcie_link_ctl(struct iwl_priv *priv)
 	return pci_lnk_ctl;
 }
 
-void iwl_bg_monitor_recover(unsigned long data);
+void iwl_bg_watchdog(unsigned long data);
 u32 iwl_usecs_to_beacons(struct iwl_priv *priv, u32 usec, u32 beacon_interval);
 __le32 iwl_add_beacon_time(struct iwl_priv *priv, u32 base,
 			   u32 addon, u32 beacon_interval);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 3cc5842..d368363 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1534,32 +1534,26 @@ static ssize_t iwl_dbgfs_ucode_bt_stats_read(struct file *file,
 			user_buf, count, ppos);
 }
 
-static ssize_t iwl_dbgfs_monitor_period_write(struct file *file,
+static ssize_t iwl_dbgfs_wd_timeout_write(struct file *file,
 					const char __user *user_buf,
 					size_t count, loff_t *ppos) {
 
 	struct iwl_priv *priv = file->private_data;
 	char buf[8];
 	int buf_size;
-	int period;
+	int timeout;
 
 	memset(buf, 0, sizeof(buf));
 	buf_size = min(count, sizeof(buf) -  1);
 	if (copy_from_user(buf, user_buf, buf_size))
 		return -EFAULT;
-	if (sscanf(buf, "%d", &period) != 1)
+	if (sscanf(buf, "%d", &timeout) != 1)
 		return -EINVAL;
-	if (period < 0 || period > IWL_MAX_MONITORING_PERIOD)
-		priv->cfg->base_params->monitor_recover_period =
-			IWL_DEF_MONITORING_PERIOD;
-	else
-		priv->cfg->base_params->monitor_recover_period = period;
+	if (timeout < 0 || timeout > IWL_MAX_WD_TIMEOUT)
+		timeout = IWL_DEF_WD_TIMEOUT;
 
-	if (priv->cfg->base_params->monitor_recover_period)
-		mod_timer(&priv->monitor_recover, jiffies + msecs_to_jiffies(
-			  priv->cfg->base_params->monitor_recover_period));
-	else
-		del_timer_sync(&priv->monitor_recover);
+	priv->cfg->base_params->wd_timeout = timeout;
+	iwl_setup_watchdog(priv);
 	return count;
 }
 
@@ -1686,7 +1680,7 @@ DEBUGFS_READ_FILE_OPS(rxon_flags);
 DEBUGFS_READ_FILE_OPS(rxon_filter_flags);
 DEBUGFS_WRITE_FILE_OPS(txfifo_flush);
 DEBUGFS_READ_FILE_OPS(ucode_bt_stats);
-DEBUGFS_WRITE_FILE_OPS(monitor_period);
+DEBUGFS_WRITE_FILE_OPS(wd_timeout);
 DEBUGFS_READ_FILE_OPS(bt_traffic);
 DEBUGFS_READ_WRITE_FILE_OPS(protection_mode);
 DEBUGFS_READ_FILE_OPS(reply_tx_error);
@@ -1763,7 +1757,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(reply_tx_error, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
-	DEBUGFS_ADD_FILE(monitor_period, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(wd_timeout, dir_debug, S_IWUSR);
 	if (priv->cfg->bt_params && priv->cfg->bt_params->advanced_bt_coexist)
 		DEBUGFS_ADD_FILE(bt_traffic, dir_debug, S_IRUSR);
 	if (priv->cfg->base_params->sensitivity_calib_by_driver)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index ea81ced..836f181 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -129,9 +129,6 @@ struct iwl_queue {
 	int write_ptr;       /* 1-st empty entry (index) host_w*/
 	int read_ptr;         /* last used entry (index) host_r*/
 	/* use for monitoring and recovering the stuck queue */
-	int last_read_ptr;      /* storing the last read_ptr */
-	/* number of time read_ptr and last_read_ptr are the same */
-	u8 repeat_same_read_ptr;
 	dma_addr_t dma_addr;   /* physical addr for BD's */
 	int n_window;	       /* safe queue window */
 	u32 id;
@@ -155,6 +152,7 @@ struct iwl_tx_info {
  * @meta: array of meta data for each command/tx buffer
  * @dma_addr_cmd: physical address of cmd/tx buffer array
  * @txb: array of per-TFD driver data
+ * @time_stamp: time (in jiffies) of last read_ptr change
  * @need_update: indicates need to update read/write index
  * @sched_retry: indicates queue is high-throughput aggregation (HT AGG) enabled
  *
@@ -170,6 +168,7 @@ struct iwl_tx_queue {
 	struct iwl_device_cmd **cmd;
 	struct iwl_cmd_meta *meta;
 	struct iwl_tx_info *txb;
+	unsigned long time_stamp;
 	u8 need_update;
 	u8 sched_retry;
 	u8 active;
@@ -1104,11 +1103,10 @@ struct iwl_event_log {
 #define IWL_DELAY_NEXT_FORCE_RF_RESET  (HZ*3)
 #define IWL_DELAY_NEXT_FORCE_FW_RELOAD (HZ*5)
 
-/* timer constants use to monitor and recover stuck tx queues in mSecs */
-#define IWL_DEF_MONITORING_PERIOD	(1000)
-#define IWL_LONG_MONITORING_PERIOD	(5000)
-#define IWL_ONE_HUNDRED_MSECS   (100)
-#define IWL_MAX_MONITORING_PERIOD	(60000)
+/* TX queue watchdog timeouts in mSecs */
+#define IWL_DEF_WD_TIMEOUT	(2000)
+#define IWL_LONG_WD_TIMEOUT	(10000)
+#define IWL_MAX_WD_TIMEOUT	(120000)
 
 /* BT Antenna Coupling Threshold (dB) */
 #define IWL_BT_ANTENNA_COUPLING_THRESHOLD	(35)
@@ -1544,7 +1542,7 @@ struct iwl_priv {
 	struct work_struct run_time_calib_work;
 	struct timer_list statistics_periodic;
 	struct timer_list ucode_trace;
-	struct timer_list monitor_recover;
+	struct timer_list watchdog;
 	bool hw_ready;
 
 	struct iwl_event_log event_log;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 90659bc..073b6ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -263,8 +263,6 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 		q->high_mark = 2;
 
 	q->write_ptr = q->read_ptr = 0;
-	q->last_read_ptr = 0;
-	q->repeat_same_read_ptr = 0;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index cc282aa..371abbf 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2509,13 +2509,8 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	/* After the ALIVE response, we can send commands to 3945 uCode */
 	set_bit(STATUS_ALIVE, &priv->status);
 
-	if (priv->cfg->ops->lib->recover_from_tx_stall) {
-		/* Enable timer to monitor the driver queues */
-		mod_timer(&priv->monitor_recover,
-			jiffies +
-			msecs_to_jiffies(
-			  priv->cfg->base_params->monitor_recover_period));
-	}
+	/* Enable watchdog to monitor the driver tx queues */
+	iwl_setup_watchdog(priv);
 
 	if (iwl_is_rfkill(priv))
 		return;
@@ -2572,8 +2567,7 @@ static void __iwl3945_down(struct iwl_priv *priv)
 
 	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
 	 * to prevent rearm timer */
-	if (priv->cfg->ops->lib->recover_from_tx_stall)
-		del_timer_sync(&priv->monitor_recover);
+	del_timer_sync(&priv->watchdog);
 
 	/* Station information will now be cleared in device */
 	iwl_clear_ucode_stations(priv, NULL);
@@ -3775,12 +3769,9 @@ static void iwl3945_setup_deferred_work(struct iwl_priv *priv)
 
 	iwl3945_hw_setup_deferred_work(priv);
 
-	if (priv->cfg->ops->lib->recover_from_tx_stall) {
-		init_timer(&priv->monitor_recover);
-		priv->monitor_recover.data = (unsigned long)priv;
-		priv->monitor_recover.function =
-			priv->cfg->ops->lib->recover_from_tx_stall;
-	}
+	init_timer(&priv->watchdog);
+	priv->watchdog.data = (unsigned long)priv;
+	priv->watchdog.function = iwl_bg_watchdog;
 
 	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
 		     iwl3945_irq_tasklet, (unsigned long)priv);
-- 
1.7.1

