Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21922 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752660Ab0CSVOQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 17:14:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Trieu 'Andrew' Nguyen <trieux.t.nguyen@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/9] iwlwifi: Recover TX flow stall due to stuck queue
Date: Fri, 19 Mar 2010 14:14:08 -0700
Message-Id: <1269033251-17545-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
References: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Monitors the internal TX queues periodically.  When a queue is stuck
for some unknown conditions causing the throughput to drop and the
transfer is stop, the driver will force firmware reload and bring the
system back to normal operational state.

The iwlwifi devices behave differently in this regard so this feature is
made part of the ops infrastructure so we can have more control on how to
monitor and recover from tx queue stall case per device.

Signed-off-by: Trieu 'Andrew' Nguyen <trieux.t.nguyen@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c     |    3 +
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    9 +++
 drivers/net/wireless/iwlwifi/iwl-6000.c     |    8 ++
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   16 +++++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   93 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    7 ++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   10 +++
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    2 +
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   16 +++++
 11 files changed, 167 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index e31e8a3..5a9cb70 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -212,6 +212,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 		.set_ct_kill = iwl1000_set_ct_threshold,
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
+	.recover_from_tx_stall = iwl_bg_monitor_recover,
 };
 
 static const struct iwl_ops iwl1000_ops = {
@@ -249,6 +250,7 @@ struct iwl_cfg iwl1000_bgn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 struct iwl_cfg iwl1000_bg_cfg = {
@@ -277,6 +279,7 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_EXT_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 11785e2..21ae61d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2820,6 +2820,7 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.led_compensation = 64,
 	.broken_powersave = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 static struct iwl_cfg iwl3945_abg_cfg = {
@@ -2838,6 +2839,7 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.led_compensation = 64,
 	.broken_powersave = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 DEFINE_PCI_DEVICE_TABLE(iwl3945_hw_card_ids) = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 7f9e448..acca89a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2255,6 +2255,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.led_compensation = 61,
 	.chain_noise_num_beacons = IWL4965_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 /* Module firmware */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 8ab28a7..a01b3c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1499,6 +1499,7 @@ struct iwl_lib_ops iwl5000_lib = {
 		.set_ct_kill = iwl5000_set_ct_threshold,
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
+	.recover_from_tx_stall = iwl_bg_monitor_recover,
 };
 
 static struct iwl_lib_ops iwl5150_lib = {
@@ -1553,6 +1554,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 		.set_ct_kill = iwl5150_set_ct_threshold,
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
+	.recover_from_tx_stall = iwl_bg_monitor_recover,
 };
 
 static const struct iwl_ops iwl5000_ops = {
@@ -1602,6 +1604,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 struct iwl_cfg iwl5100_bgn_cfg = {
@@ -1628,6 +1631,7 @@ struct iwl_cfg iwl5100_bgn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 struct iwl_cfg iwl5100_abg_cfg = {
@@ -1652,6 +1656,7 @@ struct iwl_cfg iwl5100_abg_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 struct iwl_cfg iwl5100_agn_cfg = {
@@ -1678,6 +1683,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 struct iwl_cfg iwl5350_agn_cfg = {
@@ -1704,6 +1710,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 struct iwl_cfg iwl5150_agn_cfg = {
@@ -1730,6 +1737,7 @@ struct iwl_cfg iwl5150_agn_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 struct iwl_cfg iwl5150_abg_cfg = {
@@ -1754,6 +1762,7 @@ struct iwl_cfg iwl5150_abg_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index fb70122..4fbc38c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -278,6 +278,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 		.set_ct_kill = iwl6000_set_ct_threshold,
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
+	.recover_from_tx_stall = iwl_bg_monitor_recover,
 };
 
 static const struct iwl_ops iwl6000_ops = {
@@ -343,6 +344,7 @@ static struct iwl_lib_ops iwl6050_lib = {
 		.set_calib_version = iwl6050_set_calib_version,
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
+	.recover_from_tx_stall = iwl_bg_monitor_recover,
 };
 
 static const struct iwl_ops iwl6050_ops = {
@@ -386,6 +388,7 @@ struct iwl_cfg iwl6000i_2agn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 struct iwl_cfg iwl6000i_2abg_cfg = {
@@ -417,6 +420,7 @@ struct iwl_cfg iwl6000i_2abg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 struct iwl_cfg iwl6000i_2bg_cfg = {
@@ -448,6 +452,7 @@ struct iwl_cfg iwl6000i_2bg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 struct iwl_cfg iwl6050_2agn_cfg = {
@@ -480,6 +485,7 @@ struct iwl_cfg iwl6050_2agn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1500,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 struct iwl_cfg iwl6050_2abg_cfg = {
@@ -511,6 +517,7 @@ struct iwl_cfg iwl6050_2abg_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1500,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 struct iwl_cfg iwl6000_3agn_cfg = {
@@ -543,6 +550,7 @@ struct iwl_cfg iwl6000_3agn_cfg = {
 	.support_ct_kill_exit = true,
 	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
 	.chain_noise_scale = 1000,
+	.monitor_recover_period = IWL_MONITORING_PERIOD,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 93931b6..82b1a3f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2074,6 +2074,13 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	/* After the ALIVE response, we can send host commands to the uCode */
 	set_bit(STATUS_ALIVE, &priv->status);
 
+	if (priv->cfg->ops->lib->recover_from_tx_stall) {
+		/* Enable timer to monitor the driver queues */
+		mod_timer(&priv->monitor_recover,
+			jiffies +
+			msecs_to_jiffies(priv->cfg->monitor_recover_period));
+	}
+
 	if (iwl_is_rfkill(priv))
 		return;
 
@@ -3224,6 +3231,13 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	priv->ucode_trace.data = (unsigned long)priv;
 	priv->ucode_trace.function = iwl_bg_ucode_trace;
 
+	if (priv->cfg->ops->lib->recover_from_tx_stall) {
+		init_timer(&priv->monitor_recover);
+		priv->monitor_recover.data = (unsigned long)priv;
+		priv->monitor_recover.function =
+			priv->cfg->ops->lib->recover_from_tx_stall;
+	}
+
 	if (!priv->cfg->use_isr_legacy)
 		tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
 			iwl_irq_tasklet, (unsigned long)priv);
@@ -3243,6 +3257,8 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_work_sync(&priv->beacon_update);
 	del_timer_sync(&priv->statistics_periodic);
 	del_timer_sync(&priv->ucode_trace);
+	if (priv->cfg->ops->lib->recover_from_tx_stall)
+		del_timer_sync(&priv->monitor_recover);
 }
 
 static void iwl_init_hw_rates(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d4c2a3e..5180fb2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -3051,6 +3051,99 @@ int iwl_force_reset(struct iwl_priv *priv, int mode)
 	}
 	return 0;
 }
+EXPORT_SYMBOL(iwl_force_reset);
+
+/**
+ * iwl_bg_monitor_recover - Timer callback to check for stuck queue and recover
+ *
+ * During normal condition (no queue is stuck), the timer is continually set to
+ * execute every monitor_recover_period milliseconds after the last timer
+ * expired.  When the queue read_ptr is at the same place, the timer is
+ * shorten to 100mSecs.  This is
+ *      1) to reduce the chance that the read_ptr may wrap around (not stuck)
+ *      2) to detect the stuck queues quicker before the station and AP can
+ *      disassociate each other.
+ *
+ * This function monitors all the tx queues and recover from it if any
+ * of the queues are stuck.
+ * 1. It first check the cmd queue for stuck conditions.  If it is stuck,
+ *      it will recover by resetting the firmware and return.
+ * 2. Then, it checks for station association.  If it associates it will check
+ *      other queues.  If any queue is stuck, it will recover by resetting
+ *      the firmware.
+ * Note: It the number of times the queue read_ptr to be at the same place to
+ *      be MAX_REPEAT+1 in order to consider to be stuck.
+ */
+/*
+ * The maximum number of times the read pointer of the tx queue at the
+ * same place without considering to be stuck.
+ */
+#define MAX_REPEAT      (2)
+static int iwl_check_stuck_queue(struct iwl_priv *priv, int cnt)
+{
+	struct iwl_tx_queue *txq;
+	struct iwl_queue *q;
+
+	txq = &priv->txq[cnt];
+	q = &txq->q;
+	/* queue is empty, skip */
+	if (q->read_ptr != q->write_ptr) {
+		if (q->read_ptr == q->last_read_ptr) {
+			/* a queue has not been read from last time */
+			if (q->repeat_same_read_ptr > MAX_REPEAT) {
+				IWL_ERR(priv,
+					"queue %d stuck %d time. Fw reload.\n",
+					q->id, q->repeat_same_read_ptr);
+				q->repeat_same_read_ptr = 0;
+				iwl_force_reset(priv, IWL_FW_RESET);
+			} else {
+				q->repeat_same_read_ptr++;
+				IWL_DEBUG_RADIO(priv,
+						"queue %d, not read %d time\n",
+						q->id,
+						q->repeat_same_read_ptr);
+				mod_timer(&priv->monitor_recover, jiffies +
+					msecs_to_jiffies(IWL_ONE_HUNDRED_MSECS));
+			}
+			return 1;
+		} else {
+			q->last_read_ptr = q->read_ptr;
+			q->repeat_same_read_ptr = 0;
+		}
+	}
+	return 0;
+}
+
+void iwl_bg_monitor_recover(unsigned long data)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)data;
+	int cnt;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	/* monitor and check for stuck cmd queue */
+	if (iwl_check_stuck_queue(priv, IWL_CMD_QUEUE_NUM))
+		return;
+
+	/* monitor and check for other stuck queues */
+	if (iwl_is_associated(priv)) {
+		for (cnt = 0; cnt < priv->hw_params.max_txq_num; cnt++) {
+			/* skip as we already checked the command queue */
+			if (cnt == IWL_CMD_QUEUE_NUM)
+				continue;
+			if (iwl_check_stuck_queue(priv, cnt))
+				return;
+		}
+	}
+	/*
+	 * Reschedule the timer to occur in
+	 * priv->cfg->monitor_recover_period
+	 */
+	mod_timer(&priv->monitor_recover,
+		jiffies + msecs_to_jiffies(priv->cfg->monitor_recover_period));
+}
+EXPORT_SYMBOL(iwl_bg_monitor_recover);
 
 #ifdef CONFIG_PM
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2482a25..c4cd1de 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -191,6 +191,8 @@ struct iwl_lib_ops {
 	struct iwl_temp_ops temp_ops;
 	/* station management */
 	void (*add_bcast_station)(struct iwl_priv *priv);
+	/* recover from tx queue stall */
+	void (*recover_from_tx_stall)(unsigned long data);
 };
 
 struct iwl_led_ops {
@@ -295,6 +297,8 @@ struct iwl_cfg {
 	const bool support_wimax_coexist;
 	u8 plcp_delta_threshold;
 	s32 chain_noise_scale;
+	/* timer period for monitor the driver queues */
+	u32 monitor_recover_period;
 };
 
 /***************************
@@ -568,6 +572,9 @@ static inline u16 iwl_pcie_link_ctl(struct iwl_priv *priv)
 	pci_read_config_word(priv->pci_dev, pos + PCI_EXP_LNKCTL, &pci_lnk_ctl);
 	return pci_lnk_ctl;
 }
+
+void iwl_bg_monitor_recover(unsigned long data);
+
 #ifdef CONFIG_PM
 int iwl_pci_suspend(struct pci_dev *pdev, pm_message_t state);
 int iwl_pci_resume(struct pci_dev *pdev);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9c676ea..bb4cba5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -183,6 +183,10 @@ struct iwl_queue {
 	int n_bd;              /* number of BDs in this queue */
 	int write_ptr;       /* 1-st empty entry (index) host_w*/
 	int read_ptr;         /* last used entry (index) host_r*/
+	/* use for monitoring and recovering the stuck queue */
+	int last_read_ptr;      /* storing the last read_ptr */
+	/* number of time read_ptr and last_read_ptr are the same */
+	u8 repeat_same_read_ptr;
 	dma_addr_t dma_addr;   /* physical addr for BD's */
 	int n_window;	       /* safe queue window */
 	u32 id;
@@ -1044,6 +1048,11 @@ struct iwl_event_log {
 #define IWL_DELAY_NEXT_FORCE_RF_RESET  (HZ*3)
 #define IWL_DELAY_NEXT_FORCE_FW_RELOAD (HZ*5)
 
+/* timer constants use to monitor and recover stuck tx queues in mSecs */
+#define IWL_MONITORING_PERIOD  (1000)
+#define IWL_ONE_HUNDRED_MSECS   (100)
+#define IWL_SIXTY_SECS          (60000)
+
 enum iwl_reset {
 	IWL_RF_RESET = 0,
 	IWL_FW_RESET,
@@ -1354,6 +1363,7 @@ struct iwl_priv {
 	struct work_struct run_time_calib_work;
 	struct timer_list statistics_periodic;
 	struct timer_list ucode_trace;
+	struct timer_list monitor_recover;
 	bool hw_ready;
 
 	struct iwl_event_log event_log;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 045e4a6..34c9838 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -322,6 +322,8 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 		q->high_mark = 2;
 
 	q->write_ptr = q->read_ptr = 0;
+	q->last_read_ptr = 0;
+	q->repeat_same_read_ptr = 0;
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 6687b94..4995134 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -2501,6 +2501,13 @@ static void iwl3945_alive_start(struct iwl_priv *priv)
 	/* After the ALIVE response, we can send commands to 3945 uCode */
 	set_bit(STATUS_ALIVE, &priv->status);
 
+	if (priv->cfg->ops->lib->recover_from_tx_stall) {
+		/* Enable timer to monitor the driver queues */
+		mod_timer(&priv->monitor_recover,
+			jiffies +
+			msecs_to_jiffies(priv->cfg->monitor_recover_period));
+	}
+
 	if (iwl_is_rfkill(priv))
 		return;
 
@@ -3796,6 +3803,13 @@ static void iwl3945_setup_deferred_work(struct iwl_priv *priv)
 
 	iwl3945_hw_setup_deferred_work(priv);
 
+	if (priv->cfg->ops->lib->recover_from_tx_stall) {
+		init_timer(&priv->monitor_recover);
+		priv->monitor_recover.data = (unsigned long)priv;
+		priv->monitor_recover.function =
+			priv->cfg->ops->lib->recover_from_tx_stall;
+	}
+
 	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
 		     iwl3945_irq_tasklet, (unsigned long)priv);
 }
@@ -3808,6 +3822,8 @@ static void iwl3945_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_delayed_work(&priv->scan_check);
 	cancel_delayed_work(&priv->alive_start);
 	cancel_work_sync(&priv->beacon_update);
+	if (priv->cfg->ops->lib->recover_from_tx_stall)
+		del_timer_sync(&priv->monitor_recover);
 }
 
 static struct attribute *iwl3945_sysfs_entries[] = {
-- 
1.6.3.3

