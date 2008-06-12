Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63786 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085AbYFLBtb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:31 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 03/29] iwlwifi: clean up in setup/cancel deferred work
Date: Thu, 12 Jun 2008 09:46:53 +0800
Message-Id: <1213235239-2954-4-git-send-email-yi.zhu@intel.com> (sfid-20080612_034937_963702_8FFDC2F8)
In-Reply-To: <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch makes some clean up in setup/cancel_deferred_work.
iwl_setup_deferred_work does the work that is common to 4965
and 5000, then it calls to HW specific handlers.

This patch also removes uneeded work_struct from iwl_priv.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   33 +++------------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 ++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    3 --
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   41 ++++++++++++++++++++++----
 4 files changed, 43 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e2c2d9f..be6b6eb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -608,26 +608,6 @@ out:
 
 #define REG_RECALIB_PERIOD (60)
 
-/**
- * iwl4965_bg_statistics_periodic - Timer callback to queue statistics
- *
- * This callback is provided in order to send a statistics request.
- *
- * This timer function is continually reset to execute within
- * REG_RECALIB_PERIOD seconds since the last STATISTICS_NOTIFICATION
- * was received.  We need to ensure we receive the statistics in order
- * to update the temperature used for calibrating the TXPOWER.
- */
-static void iwl4965_bg_statistics_periodic(unsigned long data)
-{
-	struct iwl_priv *priv = (struct iwl_priv *)data;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
-
-	iwl_send_statistics_request(priv, CMD_ASYNC);
-}
-
 void iwl4965_rf_kill_ct_config(struct iwl_priv *priv)
 {
 	struct iwl4965_ct_kill_config cmd;
@@ -3469,19 +3449,14 @@ static void iwl4965_rx_handler_setup(struct iwl_priv *priv)
 	priv->rx_handlers[REPLY_COMPRESSED_BA] = iwl4965_rx_reply_compressed_ba;
 }
 
-void iwl4965_hw_setup_deferred_work(struct iwl_priv *priv)
+static void iwl4965_setup_deferred_work(struct iwl_priv *priv)
 {
 	INIT_WORK(&priv->txpower_work, iwl4965_bg_txpower_work);
-	init_timer(&priv->statistics_periodic);
-	priv->statistics_periodic.data = (unsigned long)priv;
-	priv->statistics_periodic.function = iwl4965_bg_statistics_periodic;
 }
 
-void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv)
+static void iwl4965_cancel_deferred_work(struct iwl_priv *priv)
 {
-	del_timer_sync(&priv->statistics_periodic);
-
-	cancel_delayed_work(&priv->init_alive_start);
+	cancel_work_sync(&priv->txpower_work);
 }
 
 
@@ -3506,6 +3481,8 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.txq_agg_enable = iwl4965_txq_agg_enable,
 	.txq_agg_disable = iwl4965_txq_agg_disable,
 	.rx_handler_setup = iwl4965_rx_handler_setup,
+	.setup_deferred_work = iwl4965_setup_deferred_work,
+	.cancel_deferred_work = iwl4965_cancel_deferred_work,
 	.is_valid_rtc_data_addr = iwl4965_hw_valid_rtc_data_addr,
 	.alive_notify = iwl4965_alive_notify,
 	.init_alive_start = iwl4965_init_alive_start,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 192cda2..a86e08b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -116,6 +116,10 @@ struct iwl_lib_ops {
 			       u8 tx_fifo);
 	/* setup Rx handler */
 	void (*rx_handler_setup)(struct iwl_priv *priv);
+	/* setup deferred work */
+	void (*setup_deferred_work)(struct iwl_priv *priv);
+	/* cancel deferred work */
+	void (*cancel_deferred_work)(struct iwl_priv *priv);
 	/* alive notification after init uCode load */
 	void (*init_alive_start)(struct iwl_priv *priv);
 	/* alive notification */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 631931c..9e5a7cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1179,9 +1179,6 @@ struct iwl_priv {
 
 	struct delayed_work init_alive_start;
 	struct delayed_work alive_start;
-	struct delayed_work activity_timer;
-	struct delayed_work thermal_periodic;
-	struct delayed_work gather_stats;
 	struct delayed_work scan_check;
 	struct delayed_work post_associate;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index a8dfdcb..0acd42b 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1647,6 +1647,26 @@ static void iwl4965_bg_beacon_update(struct work_struct *work)
 	iwl4965_send_beacon_cmd(priv);
 }
 
+/**
+ * iwl4965_bg_statistics_periodic - Timer callback to queue statistics
+ *
+ * This callback is provided in order to send a statistics request.
+ *
+ * This timer function is continually reset to execute within
+ * REG_RECALIB_PERIOD seconds since the last STATISTICS_NOTIFICATION
+ * was received.  We need to ensure we receive the statistics in order
+ * to update the temperature used for calibrating the TXPOWER.
+ */
+static void iwl4965_bg_statistics_periodic(unsigned long data)
+{
+	struct iwl_priv *priv = (struct iwl_priv *)data;
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	iwl_send_statistics_request(priv, CMD_ASYNC);
+}
+
 static void iwl4965_rx_beacon_notif(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb)
 {
@@ -2887,7 +2907,7 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	queue_work(priv->workqueue, &priv->restart);
 }
 
-static void iwl4965_cancel_deferred_work(struct iwl_priv *priv);
+static void iwl_cancel_deferred_work(struct iwl_priv *priv);
 
 static void __iwl4965_down(struct iwl_priv *priv)
 {
@@ -2991,7 +3011,7 @@ static void iwl4965_down(struct iwl_priv *priv)
 	__iwl4965_down(priv);
 	mutex_unlock(&priv->mutex);
 
-	iwl4965_cancel_deferred_work(priv);
+	iwl_cancel_deferred_work(priv);
 }
 
 #define MAX_HW_RESTARTS 5
@@ -5022,7 +5042,7 @@ static DEVICE_ATTR(status, S_IRUGO, show_status, NULL);
  *
  *****************************************************************************/
 
-static void iwl4965_setup_deferred_work(struct iwl_priv *priv)
+static void iwl_setup_deferred_work(struct iwl_priv *priv)
 {
 	priv->workqueue = create_workqueue(DRV_NAME);
 
@@ -5043,21 +5063,28 @@ static void iwl4965_setup_deferred_work(struct iwl_priv *priv)
 	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
 	INIT_DELAYED_WORK(&priv->scan_check, iwl4965_bg_scan_check);
 
-	iwl4965_hw_setup_deferred_work(priv);
+	if (priv->cfg->ops->lib->setup_deferred_work)
+		priv->cfg->ops->lib->setup_deferred_work(priv);
+
+	init_timer(&priv->statistics_periodic);
+	priv->statistics_periodic.data = (unsigned long)priv;
+	priv->statistics_periodic.function = iwl4965_bg_statistics_periodic;
 
 	tasklet_init(&priv->irq_tasklet, (void (*)(unsigned long))
 		     iwl4965_irq_tasklet, (unsigned long)priv);
 }
 
-static void iwl4965_cancel_deferred_work(struct iwl_priv *priv)
+static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 {
-	iwl4965_hw_cancel_deferred_work(priv);
+	if (priv->cfg->ops->lib->cancel_deferred_work)
+		priv->cfg->ops->lib->cancel_deferred_work(priv);
 
 	cancel_delayed_work_sync(&priv->init_alive_start);
 	cancel_delayed_work(&priv->scan_check);
 	cancel_delayed_work(&priv->alive_start);
 	cancel_delayed_work(&priv->post_associate);
 	cancel_work_sync(&priv->beacon_update);
+	del_timer_sync(&priv->statistics_periodic);
 }
 
 static struct attribute *iwl4965_sysfs_entries[] = {
@@ -5269,7 +5296,7 @@ static int iwl4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	}
 
 
-	iwl4965_setup_deferred_work(priv);
+	iwl_setup_deferred_work(priv);
 	iwl4965_setup_rx_handlers(priv);
 
 	/********************
-- 
1.5.3.6

