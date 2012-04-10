Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48416 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754422Ab2DJAuX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 20:50:23 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/11] iwlwifi: split force_reset debugfs file
Date: Mon,  9 Apr 2012 17:46:57 -0700
Message-Id: <1334018821-30416-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120410_025045_189095_1699EAAF)
In-Reply-To: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Split the force_reset debugfs file into two
different files:
 * "rf_reset" triggers a reset of the RF when
   written to and exposes statistics on RF
   resets when read
 * fw_restart triggers a firmware restart when
   written to and lives in the transport

This cleans up all sources of firmware restart
to originate within the transport layer and
allows us to simplify some code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c        |    6 --
 drivers/net/wireless/iwlwifi/iwl-agn.h        |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.c       |   71 ++++++------------------
 drivers/net/wireless/iwlwifi/iwl-core.h       |    1 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c    |   64 ++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-dev.h        |   16 ++----
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c |   16 ++++++
 8 files changed, 62 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index ef3758d..eb7ecb5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -307,7 +307,7 @@ static void iwlagn_recover_from_statistics(struct iwl_priv *priv,
 
 	if (iwlagn_mod_params.plcp_check &&
 	    !iwlagn_good_plcp_health(priv, cur_ofdm, cur_ofdm_ht, msecs))
-		iwl_force_reset(priv, IWL_RF_RESET, false);
+		iwl_force_rf_reset(priv, false);
 }
 
 /* Calculate noise level, based on measurements during network silence just
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 20c6476..c41c4c5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1329,12 +1329,6 @@ static int iwl_init_drv(struct iwl_priv *priv)
 
 	priv->ucode_owner = IWL_OWNERSHIP_DRIVER;
 
-	/* initialize force reset */
-	priv->force_reset[IWL_RF_RESET].reset_duration =
-		IWL_DELAY_NEXT_FORCE_RF_RESET;
-	priv->force_reset[IWL_FW_RESET].reset_duration =
-		IWL_DELAY_NEXT_FORCE_FW_RELOAD;
-
 	priv->rx_statistics_jiffies = jiffies;
 
 	/* Choose which receivers/antennas to use */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 5100162..da5ea1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -195,6 +195,7 @@ u8 iwl_toggle_tx_ant(struct iwl_priv *priv, u8 ant_idx, u8 valid);
 /* scan */
 void iwlagn_post_scan(struct iwl_priv *priv);
 void iwlagn_disable_roc(struct iwl_priv *priv);
+int iwl_force_rf_reset(struct iwl_priv *priv, bool external);
 
 /* bt coex */
 void iwlagn_send_advance_bt_config(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 6fc1841..6a02ade 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -746,15 +746,30 @@ void iwl_update_stats(struct iwl_priv *priv, bool is_tx, __le16 fc, u16 len)
 }
 #endif
 
-static void iwl_force_rf_reset(struct iwl_priv *priv)
+int iwl_force_rf_reset(struct iwl_priv *priv, bool external)
 {
+	struct iwl_rf_reset *rf_reset;
+
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return;
+		return -EAGAIN;
 
 	if (!iwl_is_any_associated(priv)) {
 		IWL_DEBUG_SCAN(priv, "force reset rejected: not associated\n");
-		return;
+		return -ENOLINK;
 	}
+
+	rf_reset = &priv->rf_reset;
+	rf_reset->reset_request_count++;
+	if (!external && rf_reset->last_reset_jiffies &&
+	    time_after(rf_reset->last_reset_jiffies +
+		       IWL_DELAY_NEXT_FORCE_RF_RESET, jiffies)) {
+		IWL_DEBUG_INFO(priv, "RF reset rejected\n");
+		rf_reset->reset_reject_count++;
+		return -EAGAIN;
+	}
+	rf_reset->reset_success_count++;
+	rf_reset->last_reset_jiffies = jiffies;
+
 	/*
 	 * There is no easy and better way to force reset the radio,
 	 * the only known method is switching channel which will force to
@@ -766,56 +781,6 @@ static void iwl_force_rf_reset(struct iwl_priv *priv)
 	 */
 	IWL_DEBUG_INFO(priv, "perform radio reset.\n");
 	iwl_internal_short_hw_scan(priv);
-}
-
-
-int iwl_force_reset(struct iwl_priv *priv, int mode, bool external)
-{
-	struct iwl_force_reset *force_reset;
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return -EINVAL;
-
-	if (mode >= IWL_MAX_FORCE_RESET) {
-		IWL_DEBUG_INFO(priv, "invalid reset request.\n");
-		return -EINVAL;
-	}
-	force_reset = &priv->force_reset[mode];
-	force_reset->reset_request_count++;
-	if (!external) {
-		if (force_reset->last_force_reset_jiffies &&
-		    time_after(force_reset->last_force_reset_jiffies +
-		    force_reset->reset_duration, jiffies)) {
-			IWL_DEBUG_INFO(priv, "force reset rejected\n");
-			force_reset->reset_reject_count++;
-			return -EAGAIN;
-		}
-	}
-	force_reset->reset_success_count++;
-	force_reset->last_force_reset_jiffies = jiffies;
-	IWL_DEBUG_INFO(priv, "perform force reset (%d)\n", mode);
-	switch (mode) {
-	case IWL_RF_RESET:
-		iwl_force_rf_reset(priv);
-		break;
-	case IWL_FW_RESET:
-		/*
-		 * if the request is from external(ex: debugfs),
-		 * then always perform the request in regardless the module
-		 * parameter setting
-		 * if the request is from internal (uCode error or driver
-		 * detect failure), then fw_restart module parameter
-		 * need to be check before performing firmware reload
-		 */
-		if (!external && !iwlagn_mod_params.restart_fw) {
-			IWL_DEBUG_INFO(priv, "Cancel firmware reload based on "
-				       "module parameter setting\n");
-			break;
-		}
-		IWL_ERR(priv, "On demand firmware reload\n");
-		iwlagn_fw_error(priv, true);
-		break;
-	}
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index f388dc4..999a806 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -164,7 +164,6 @@ int iwl_scan_cancel(struct iwl_priv *priv);
 void iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
 void iwl_force_scan_end(struct iwl_priv *priv);
 void iwl_internal_short_hw_scan(struct iwl_priv *priv);
-int iwl_force_reset(struct iwl_priv *priv, int mode, bool external);
 void iwl_setup_rx_scan_handlers(struct iwl_priv *priv);
 void iwl_setup_scan_deferred_work(struct iwl_priv *priv);
 void iwl_cancel_scan_deferred_work(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index fceb4e5..de8459a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2273,59 +2273,39 @@ static ssize_t iwl_dbgfs_plcp_delta_write(struct file *file,
 	return count;
 }
 
-static ssize_t iwl_dbgfs_force_reset_read(struct file *file,
-					char __user *user_buf,
-					size_t count, loff_t *ppos)
+static ssize_t iwl_dbgfs_rf_reset_read(struct file *file,
+				       char __user *user_buf,
+				       size_t count, loff_t *ppos)
 {
 	struct iwl_priv *priv = file->private_data;
-	int i, pos = 0;
+	int pos = 0;
 	char buf[300];
 	const size_t bufsz = sizeof(buf);
-	struct iwl_force_reset *force_reset;
+	struct iwl_rf_reset *rf_reset = &priv->rf_reset;
+
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"RF reset statistics\n");
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"\tnumber of reset request: %d\n",
+			rf_reset->reset_request_count);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"\tnumber of reset request success: %d\n",
+			rf_reset->reset_success_count);
+	pos += scnprintf(buf + pos, bufsz - pos,
+			"\tnumber of reset request reject: %d\n",
+			rf_reset->reset_reject_count);
 
-	for (i = 0; i < IWL_MAX_FORCE_RESET; i++) {
-		force_reset = &priv->force_reset[i];
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"Force reset method %d\n", i);
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"\tnumber of reset request: %d\n",
-				force_reset->reset_request_count);
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"\tnumber of reset request success: %d\n",
-				force_reset->reset_success_count);
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"\tnumber of reset request reject: %d\n",
-				force_reset->reset_reject_count);
-		pos += scnprintf(buf + pos, bufsz - pos,
-				"\treset duration: %lu\n",
-				force_reset->reset_duration);
-	}
 	return simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 }
 
-static ssize_t iwl_dbgfs_force_reset_write(struct file *file,
+static ssize_t iwl_dbgfs_rf_reset_write(struct file *file,
 					const char __user *user_buf,
 					size_t count, loff_t *ppos) {
 
 	struct iwl_priv *priv = file->private_data;
-	char buf[8];
-	int buf_size;
-	int reset, ret;
+	int ret;
 
-	memset(buf, 0, sizeof(buf));
-	buf_size = min(count, sizeof(buf) -  1);
-	if (copy_from_user(buf, user_buf, buf_size))
-		return -EFAULT;
-	if (sscanf(buf, "%d", &reset) != 1)
-		return -EINVAL;
-	switch (reset) {
-	case IWL_RF_RESET:
-	case IWL_FW_RESET:
-		ret = iwl_force_reset(priv, reset, true);
-		break;
-	default:
-		return -EINVAL;
-	}
+	ret = iwl_force_rf_reset(priv, true);
 	return ret ? ret : count;
 }
 
@@ -2513,7 +2493,7 @@ DEBUGFS_WRITE_FILE_OPS(clear_traffic_statistics);
 DEBUGFS_READ_WRITE_FILE_OPS(ucode_tracing);
 DEBUGFS_READ_WRITE_FILE_OPS(missed_beacon);
 DEBUGFS_READ_WRITE_FILE_OPS(plcp_delta);
-DEBUGFS_READ_WRITE_FILE_OPS(force_reset);
+DEBUGFS_READ_WRITE_FILE_OPS(rf_reset);
 DEBUGFS_READ_FILE_OPS(rxon_flags);
 DEBUGFS_READ_FILE_OPS(rxon_filter_flags);
 DEBUGFS_WRITE_FILE_OPS(txfifo_flush);
@@ -2571,7 +2551,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(clear_traffic_statistics, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(missed_beacon, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(plcp_delta, dir_debug, S_IWUSR | S_IRUSR);
-	DEBUGFS_ADD_FILE(force_reset, dir_debug, S_IWUSR | S_IRUSR);
+	DEBUGFS_ADD_FILE(rf_reset, dir_debug, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(ucode_rx_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(ucode_tx_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(ucode_general_stats, dir_debug, S_IRUSR);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index caaf14c..58073da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -582,7 +582,6 @@ struct iwl_event_log {
 #define IWL_MAX_PLCP_ERR_THRESHOLD_DISABLE	(0)
 
 #define IWL_DELAY_NEXT_FORCE_RF_RESET  (HZ*3)
-#define IWL_DELAY_NEXT_FORCE_FW_RELOAD (HZ*5)
 
 /* TX queue watchdog timeouts in mSecs */
 #define IWL_WATCHHDOG_DISABLED	(0)
@@ -598,18 +597,11 @@ struct iwl_event_log {
 #define IWL_MAX_CONTINUE_RELOAD_CNT	4
 
 
-enum iwl_reset {
-	IWL_RF_RESET = 0,
-	IWL_FW_RESET,
-	IWL_MAX_FORCE_RESET,
-};
-
-struct iwl_force_reset {
+struct iwl_rf_reset {
 	int reset_request_count;
 	int reset_success_count;
 	int reset_reject_count;
-	unsigned long reset_duration;
-	unsigned long last_force_reset_jiffies;
+	unsigned long last_reset_jiffies;
 };
 
 /* extend beacon time format bit shifting  */
@@ -806,8 +798,8 @@ struct iwl_priv {
 	/*counters */
 	u32 rx_handlers_stats[REPLY_MAX];
 
-	/* force reset */
-	struct iwl_force_reset force_reset[IWL_MAX_FORCE_RESET];
+	/* rf reset */
+	struct iwl_rf_reset rf_reset;
 
 	/* firmware reload counter and timestamp */
 	unsigned long reload_jiffies;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 0220d7f..0a2be25 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -2000,11 +2000,26 @@ static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
 	return ret;
 }
 
+static ssize_t iwl_dbgfs_fw_restart_write(struct file *file,
+					  const char __user *user_buf,
+					  size_t count, loff_t *ppos)
+{
+	struct iwl_trans *trans = file->private_data;
+
+	if (!trans->op_mode)
+		return -EAGAIN;
+
+	iwl_op_mode_nic_error(trans->op_mode);
+
+	return count;
+}
+
 DEBUGFS_READ_WRITE_FILE_OPS(interrupt);
 DEBUGFS_READ_FILE_OPS(fh_reg);
 DEBUGFS_READ_FILE_OPS(rx_queue);
 DEBUGFS_READ_FILE_OPS(tx_queue);
 DEBUGFS_WRITE_FILE_OPS(csr);
+DEBUGFS_WRITE_FILE_OPS(fw_restart);
 
 /*
  * Create the debugfs files and directories
@@ -2018,6 +2033,7 @@ static int iwl_trans_pcie_dbgfs_register(struct iwl_trans *trans,
 	DEBUGFS_ADD_FILE(interrupt, dir, S_IWUSR | S_IRUSR);
 	DEBUGFS_ADD_FILE(csr, dir, S_IWUSR);
 	DEBUGFS_ADD_FILE(fh_reg, dir, S_IRUSR);
+	DEBUGFS_ADD_FILE(fw_restart, dir, S_IWUSR);
 	return 0;
 }
 #else
-- 
1.7.0.4

