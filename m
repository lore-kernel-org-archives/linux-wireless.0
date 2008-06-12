Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20549 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023AbYFLBtd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:33 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 04/29] iwlwifi: add possibility to disable tx_power calibration
Date: Thu, 12 Jun 2008 09:46:54 +0800
Message-Id: <1213235239-2954-5-git-send-email-yi.zhu@intel.com> (sfid-20080612_034940_345990_B0FE1CF6)
In-Reply-To: <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch adds the possibility to disable the tx_power calibration.
In 5000 HW, this calibration is implemented in uCode, hence, it is
disabled in driver by default.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    7 +++++++
 drivers/net/wireless/iwlwifi/iwl-debug.h   |    1 +
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    1 +
 5 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index be6b6eb..6d249bb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2103,8 +2103,9 @@ void iwl4965_hw_rx_statistics(struct iwl_priv *priv,
 	priv->temperature = temp;
 	set_bit(STATUS_TEMPERATURE, &priv->status);
 
-	if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)) &&
-		     iwl4965_is_temp_calib_needed(priv))
+	if (!priv->disable_tx_power_cal &&
+	     unlikely(!test_bit(STATUS_SCANNING, &priv->status)) &&
+	     iwl4965_is_temp_calib_needed(priv))
 		queue_work(priv->workqueue, &priv->txpower_work);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index fc8ad73..31ea363 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1229,6 +1229,12 @@ static u16 iwl5000_get_hcmd_size(u8 cmd_id, u16 len)
 	return len;
 }
 
+static void iwl5000_setup_deferred_work(struct iwl_priv *priv)
+{
+	/* in 5000 the tx power calibration is done in uCode */
+	priv->disable_tx_power_cal = 1;
+}
+
 static void iwl5000_rx_handler_setup(struct iwl_priv *priv)
 {
 	/* init calibration handlers */
@@ -1313,6 +1319,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.txq_inval_byte_cnt_tbl = iwl5000_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwl5000_txq_set_sched,
 	.rx_handler_setup = iwl5000_rx_handler_setup,
+	.setup_deferred_work = iwl5000_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
 	.load_ucode = iwl5000_load_ucode,
 	.init_alive_start = iwl5000_init_alive_start,
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 48563a0..5838480 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -57,6 +57,7 @@ struct iwl_debugfs {
 	struct dir_rf_files {
 		struct dentry *file_disable_sensitivity;
 		struct dentry *file_disable_chain_noise;
+		struct dentry *file_disable_tx_power;
 	} dbgfs_rf_files;
 	u32 sram_offset;
 	u32 sram_len;
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index da6dcb2..ed948dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -388,6 +388,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_BOOL(disable_sensitivity, rf, &priv->disable_sens_cal);
 	DEBUGFS_ADD_BOOL(disable_chain_noise, rf,
 			 &priv->disable_chain_noise_cal);
+	DEBUGFS_ADD_BOOL(disable_tx_power, rf, &priv->disable_tx_power_cal);
 	return 0;
 
 err:
@@ -415,6 +416,7 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv)
 	DEBUGFS_REMOVE(priv->dbgfs->dir_data);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_sensitivity);
 	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_chain_noise);
+	DEBUGFS_REMOVE(priv->dbgfs->dbgfs_rf_files.file_disable_tx_power);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_rf);
 	DEBUGFS_REMOVE(priv->dbgfs->dir_drv);
 	kfree(priv->dbgfs);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 9e5a7cd..bf4b883 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1204,6 +1204,7 @@ struct iwl_priv {
 	struct work_struct txpower_work;
 	u32 disable_sens_cal;
 	u32 disable_chain_noise_cal;
+	u32 disable_tx_power_cal;
 	struct work_struct run_time_calib_work;
 	struct timer_list statistics_periodic;
 }; /*iwl_priv */
-- 
1.5.3.6

