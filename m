Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51807 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759532Ab0GBSoi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 14:44:38 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5/8] iwlwifi: add support for device tx flush request
Date: Fri,  2 Jul 2010 11:45:37 -0700
Message-Id: <1278096340-2546-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1278096340-2546-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

"Flush" request can come from two different sources, it can either from
mac80211, or from device when the operation is needed. Here
adding the support for device issue "flush" request.

When receive tx complete with status is TX_STATUS_FAIL_RFKILL_FLUSH,
issue REPLY_TXFIFO_FLUSH command to uCode to flush out all the tx frames
in queues.

In this condition, since mac80211 has no knowledge of "flush" operation,
driver need to stop all the tx queues and wait for the operation
completed before wake up the queues for frames transmission.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    2 ++
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   19 ++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   19 +++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    1 +
 8 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 00808ee..96a4888 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -227,6 +227,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.check_plcp_health = iwl_good_plcp_health,
 	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
+	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 };
 
 static const struct iwl_ops iwl1000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 1182498..648d53b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -403,6 +403,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.check_plcp_health = iwl_good_plcp_health,
 	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
+	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 };
 
 static struct iwl_lib_ops iwl5150_lib = {
@@ -467,6 +468,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.check_plcp_health = iwl_good_plcp_health,
 	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
+	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 };
 
 static const struct iwl_ops iwl5000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index e1959fb..79ba7ad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -328,6 +328,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.check_plcp_health = iwl_good_plcp_health,
 	.check_ack_health = iwl_good_ack_health,
 	.txfifo_flush = iwlagn_txfifo_flush,
+	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 };
 
 static const struct iwl_ops iwl6000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 95666e5..74623e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -205,7 +205,9 @@ void iwl_check_abort_status(struct iwl_priv *priv,
 			    u8 frame_count, u32 status)
 {
 	if (frame_count == 1 && status == TX_STATUS_FAIL_RFKILL_FLUSH) {
-		IWL_ERR(priv, "TODO: Implement Tx flush command!!!\n");
+		IWL_ERR(priv, "Tx flush command to flush out all frames\n");
+		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
+			queue_work(priv->workqueue, &priv->tx_flush);
 	}
 }
 
@@ -1498,3 +1500,18 @@ int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 
 	return iwl_send_cmd(priv, &cmd);
 }
+
+void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
+{
+	mutex_lock(&priv->mutex);
+	ieee80211_stop_queues(priv->hw);
+	if (priv->cfg->ops->lib->txfifo_flush(priv, IWL_DROP_ALL)) {
+		IWL_ERR(priv, "flush request fail\n");
+		goto done;
+	}
+	IWL_DEBUG_INFO(priv, "wait transmit/flush all frames\n");
+	iwlagn_wait_tx_queue_empty(priv);
+done:
+	ieee80211_wake_queues(priv->hw);
+	mutex_unlock(&priv->mutex);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c735a39..60af542 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -859,6 +859,24 @@ int iwl_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 	return 0;
 }
 
+static void iwl_bg_tx_flush(struct work_struct *work)
+{
+	struct iwl_priv *priv =
+		container_of(work, struct iwl_priv, tx_flush);
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	/* do nothing if rf-kill is on */
+	if (!iwl_is_ready_rf(priv))
+		return;
+
+	if (priv->cfg->ops->lib->txfifo_flush) {
+		IWL_DEBUG_INFO(priv, "device request: flush all tx frames\n");
+		iwlagn_dev_txfifo_flush(priv, IWL_DROP_ALL);
+	}
+}
+
 /**
  * iwl_setup_rx_handlers - Initialize Rx handler callbacks
  *
@@ -3693,6 +3711,7 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->rx_replenish, iwl_bg_rx_replenish);
 	INIT_WORK(&priv->beacon_update, iwl_bg_beacon_update);
 	INIT_WORK(&priv->run_time_calib_work, iwl_bg_run_time_calib_work);
+	INIT_WORK(&priv->tx_flush, iwl_bg_tx_flush);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 0298642..5c46b2c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -149,6 +149,7 @@ int iwlagn_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 int iwlagn_hw_nic_init(struct iwl_priv *priv);
 int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv);
 int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
+void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 
 /* rx */
 void iwlagn_rx_queue_restock(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index db315b0..fcbba3d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -206,6 +206,7 @@ struct iwl_lib_ops {
 	bool (*check_ack_health)(struct iwl_priv *priv,
 					struct iwl_rx_packet *pkt);
 	int (*txfifo_flush)(struct iwl_priv *priv, u16 flush_control);
+	void (*dev_txfifo_flush)(struct iwl_priv *priv, u16 flush_control);
 
 	struct iwl_debugfs_ops debugfs_ops;
 };
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index df07a14..c637376 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1345,6 +1345,7 @@ struct iwl_priv {
 	struct work_struct ct_enter;
 	struct work_struct ct_exit;
 	struct work_struct start_internal_scan;
+	struct work_struct tx_flush;
 
 	struct tasklet_struct irq_tasklet;
 
-- 
1.7.0.4

