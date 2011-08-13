Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38048 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016Ab1HMSSw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:52 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 58/60] iwlagn: move check_stuck_queue to transport layer
Date: Sat, 13 Aug 2011 10:38:34 -0700
Message-Id: <1313257116-2697-59-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201927_701388_092B267D)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This one is really transport related.

==== moves Stanislaw's code to BSD area ====

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-core.c   |   26 +++-----------------------
 drivers/net/wireless/iwlwifi/iwl-shared.h |    3 +++
 drivers/net/wireless/iwlwifi/iwl-trans.c  |   28 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans.h  |    6 ++++++
 5 files changed, 42 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 3f39c5f..5119e45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3255,8 +3255,8 @@ static int iwl_set_hw_params(struct iwl_priv *priv)
 		priv->cfg->base_params->num_of_ampdu_queues;
 	hw_params(priv).shadow_reg_enable =
 		priv->cfg->base_params->shadow_reg_enable;
-	hw_params(priv).sku =
-		priv->cfg->sku;
+	hw_params(priv).sku = priv->cfg->sku;
+	hw_params(priv).wd_timeout = priv->cfg->base_params->wd_timeout;
 
 	/* Device-specific setup */
 	return priv->cfg->lib->set_hw_params(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d7fde63..7aef3b6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1724,32 +1724,12 @@ int iwl_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	return err;
 }
 
-/*
- * On every watchdog tick we check (latest) time stamp. If it does not
- * change during timeout period and queue is not empty we reset firmware.
- */
-static int iwl_check_stuck_queue(struct iwl_priv *priv, int cnt)
+static inline int iwl_check_stuck_queue(struct iwl_priv *priv, int txq)
 {
-	struct iwl_tx_queue *txq = &priv->txq[cnt];
-	struct iwl_queue *q = &txq->q;
-	unsigned long timeout;
-	int ret;
-
-	if (q->read_ptr == q->write_ptr) {
-		txq->time_stamp = jiffies;
-		return 0;
-	}
-
-	timeout = txq->time_stamp +
-		  msecs_to_jiffies(priv->cfg->base_params->wd_timeout);
-
-	if (time_after(jiffies, timeout)) {
-		IWL_ERR(priv, "Queue %d stuck for %u ms.\n",
-				q->id, priv->cfg->base_params->wd_timeout);
-		ret = iwl_force_reset(priv, IWL_FW_RESET, false);
+	if (iwl_trans_check_stuck_queue(trans(priv), txq)) {
+		int ret = iwl_force_reset(priv, IWL_FW_RESET, false);
 		return (ret == -EAGAIN) ? 0 : 1;
 	}
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 0bd6f7d..17a02a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -147,6 +147,7 @@ struct iwl_mod_params {
  * @sw_crypto: 0 for hw, 1 for sw
  * @max_xxx_size: for ucode uses
  * @ct_kill_threshold: temperature threshold
+ * @wd_timeout: TX queues watchdog timeout
  * @calib_init_cfg: setup initial calibrations for the hw
  * @calib_rt_cfg: setup runtime calibrations for the hw
  * @struct iwl_sensitivity_ranges: range of sensitivity values
@@ -169,6 +170,8 @@ struct iwl_hw_params {
 	u32 ct_kill_threshold; /* value in hw-dependent units */
 	u32 ct_kill_exit_threshold; /* value in hw-dependent units */
 				    /* for 1000, 6000 series and up */
+	unsigned int wd_timeout;
+
 	u32 calib_init_cfg;
 	u32 calib_rt_cfg;
 	const struct iwl_sensitivity_ranges *sens;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 7b868c7..6461704 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -1475,6 +1475,33 @@ static int iwl_trans_pcie_wait_tx_queue_empty(struct iwl_trans *trans)
 	return ret;
 }
 
+/*
+ * On every watchdog tick we check (latest) time stamp. If it does not
+ * change during timeout period and queue is not empty we reset firmware.
+ */
+static int iwl_trans_pcie_check_stuck_queue(struct iwl_trans *trans, int cnt)
+{
+	struct iwl_tx_queue *txq = &priv(trans)->txq[cnt];
+	struct iwl_queue *q = &txq->q;
+	unsigned long timeout;
+
+	if (q->read_ptr == q->write_ptr) {
+		txq->time_stamp = jiffies;
+		return 0;
+	}
+
+	timeout = txq->time_stamp +
+		  msecs_to_jiffies(hw_params(trans).wd_timeout);
+
+	if (time_after(jiffies, timeout)) {
+		IWL_ERR(trans, "Queue %d stuck for %u ms.\n", q->id,
+			hw_params(trans).wd_timeout);
+		return 1;
+	}
+
+	return 0;
+}
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 /* create and remove of files */
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
@@ -2055,6 +2082,7 @@ const struct iwl_trans_ops trans_ops_pcie = {
 	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
 
 	.wait_tx_queue_empty = iwl_trans_pcie_wait_tx_queue_empty,
+	.check_stuck_queue = iwl_trans_pcie_check_stuck_queue,
 
 	.suspend = iwl_trans_pcie_suspend,
 	.resume = iwl_trans_pcie_resume,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 45d6dff..6edf2e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -101,6 +101,7 @@ struct iwl_device_cmd;
  * @kick_nic: remove the RESET from the embedded CPU and let it run
  * @free: release all the ressource for the transport layer itself such as
  *        irq, tasklet etc...
+ * @check_stuck_queue: check if a specific queue is stuck
  * @wait_tx_queue_empty: wait until all tx queues are empty
  * @dbgfs_register: add the dbgfs files under this directory. Files will be
  *	automatically deleted.
@@ -143,6 +144,7 @@ struct iwl_trans_ops {
 	void (*free)(struct iwl_trans *trans);
 
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
+	int (*check_stuck_queue)(struct iwl_trans *trans, int q);
 	int (*wait_tx_queue_empty)(struct iwl_trans *trans);
 
 	int (*suspend)(struct iwl_trans *trans);
@@ -259,6 +261,10 @@ static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans)
 	return trans->ops->wait_tx_queue_empty(trans);
 }
 
+static inline int iwl_trans_check_stuck_queue(struct iwl_trans *trans, int q)
+{
+	return trans->ops->check_stuck_queue(trans, q);
+}
 static inline int iwl_trans_dbgfs_register(struct iwl_trans *trans,
 					    struct dentry *dir)
 {
-- 
1.7.0.4

