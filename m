Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50845 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab1DHPuM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:50:12 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/16] iwlagn: remove un-necessary function pointer
Date: Fri,  8 Apr 2011 08:30:22 -0700
Message-Id: <1302276636-12802-3-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After driver split, no need to use function pointer for those event and
register dump function.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    4 ----
 drivers/net/wireless/iwlwifi/iwl-2000.c    |    4 ----
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    7 -------
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    8 --------
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    2 --
 drivers/net/wireless/iwlwifi/iwl-core.c    |   10 ++++------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    8 ++------
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |   21 ++++++++-------------
 8 files changed, 14 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 4323d27..cb2f871 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -182,10 +182,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.dump_nic_event_log = iwl_dump_nic_event_log,
-	.dump_nic_error_log = iwl_dump_nic_error_log,
-	.dump_csr = iwl_dump_csr,
-	.dump_fh = iwl_dump_fh,
 	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.apm_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 564477d..e73ac80 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -262,10 +262,6 @@ static struct iwl_lib_ops iwl2000_lib = {
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.dump_nic_event_log = iwl_dump_nic_event_log,
-	.dump_nic_error_log = iwl_dump_nic_error_log,
-	.dump_csr = iwl_dump_csr,
-	.dump_fh = iwl_dump_fh,
 	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl2030_hw_channel_switch,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 4dafc58..4c8f72a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -350,10 +350,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.dump_nic_event_log = iwl_dump_nic_event_log,
-	.dump_nic_error_log = iwl_dump_nic_error_log,
-	.dump_csr = iwl_dump_csr,
-	.dump_fh = iwl_dump_fh,
 	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl5000_hw_channel_switch,
@@ -406,9 +402,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.dump_nic_event_log = iwl_dump_nic_event_log,
-	.dump_nic_error_log = iwl_dump_nic_error_log,
-	.dump_csr = iwl_dump_csr,
 	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl5000_hw_channel_switch,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 9fb2a42..80a335f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -289,10 +289,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.dump_nic_event_log = iwl_dump_nic_event_log,
-	.dump_nic_error_log = iwl_dump_nic_error_log,
-	.dump_csr = iwl_dump_csr,
-	.dump_fh = iwl_dump_fh,
 	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl6000_hw_channel_switch,
@@ -347,10 +343,6 @@ static struct iwl_lib_ops iwl6030_lib = {
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
-	.dump_nic_event_log = iwl_dump_nic_event_log,
-	.dump_nic_error_log = iwl_dump_nic_error_log,
-	.dump_csr = iwl_dump_csr,
-	.dump_fh = iwl_dump_fh,
 	.send_tx_power = iwlagn_send_tx_power,
 	.update_chain_flags = iwl_update_chain_flags,
 	.set_channel_switch = iwl6000_hw_channel_switch,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 016b79e..290a208 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -173,8 +173,6 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv);
 int iwlagn_wait_tx_queue_empty(struct iwl_priv *priv);
 int iwlagn_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
 void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control);
-void iwl_dump_csr(struct iwl_priv *priv);
-int iwl_dump_fh(struct iwl_priv *priv, char **buf, bool display);
 
 /* rx */
 void iwlagn_rx_queue_restock(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c46be36..5e7281c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -965,12 +965,10 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 	IWL_ERR(priv, "Loaded firmware version: %s\n",
 		priv->hw->wiphy->fw_version);
 
-	priv->cfg->ops->lib->dump_nic_error_log(priv);
-	if (priv->cfg->ops->lib->dump_csr)
-		priv->cfg->ops->lib->dump_csr(priv);
-	if (priv->cfg->ops->lib->dump_fh)
-		priv->cfg->ops->lib->dump_fh(priv, NULL, false);
-	priv->cfg->ops->lib->dump_nic_event_log(priv, false, NULL, false);
+	iwl_dump_nic_error_log(priv);
+	iwl_dump_csr(priv);
+	iwl_dump_fh(priv, NULL, false);
+	iwl_dump_nic_event_log(priv, false, NULL, false);
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_get_debug_level(priv) & IWL_DL_FW_ERRORS)
 		iwl_print_rx_config_cmd(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 82939f8..43d4c92 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -171,12 +171,6 @@ struct iwl_lib_ops {
 	void (*cancel_deferred_work)(struct iwl_priv *priv);
 	/* check validity of rtc data address */
 	int (*is_valid_rtc_data_addr)(u32 addr);
-
-	int (*dump_nic_event_log)(struct iwl_priv *priv,
-				  bool full_log, char **buf, bool display);
-	void (*dump_nic_error_log)(struct iwl_priv *priv);
-	void (*dump_csr)(struct iwl_priv *priv);
-	int (*dump_fh)(struct iwl_priv *priv, char **buf, bool display);
 	int (*set_channel_switch)(struct iwl_priv *priv,
 				  struct ieee80211_channel_switch *ch_switch);
 	/* power management */
@@ -598,6 +592,8 @@ extern const struct dev_pm_ops iwl_pm_ops;
 void iwl_dump_nic_error_log(struct iwl_priv *priv);
 int iwl_dump_nic_event_log(struct iwl_priv *priv,
 			   bool full_log, char **buf, bool display);
+void iwl_dump_csr(struct iwl_priv *priv);
+int iwl_dump_fh(struct iwl_priv *priv, char **buf, bool display);
 #ifdef CONFIG_IWLWIFI_DEBUG
 void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 			     struct iwl_rxon_context *ctx);
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 92f6efd..93a8699 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -437,8 +437,7 @@ static ssize_t iwl_dbgfs_log_event_read(struct file *file,
 	int pos = 0;
 	ssize_t ret = -ENOMEM;
 
-	ret = pos = priv->cfg->ops->lib->dump_nic_event_log(
-					priv, true, &buf, true);
+	ret = pos = iwl_dump_nic_event_log(priv, true, &buf, true);
 	if (buf) {
 		ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 		kfree(buf);
@@ -462,8 +461,7 @@ static ssize_t iwl_dbgfs_log_event_write(struct file *file,
 	if (sscanf(buf, "%d", &event_log_flag) != 1)
 		return -EFAULT;
 	if (event_log_flag == 1)
-		priv->cfg->ops->lib->dump_nic_event_log(priv, true,
-							NULL, false);
+		iwl_dump_nic_event_log(priv, true, NULL, false);
 
 	return count;
 }
@@ -1268,8 +1266,7 @@ static ssize_t iwl_dbgfs_csr_write(struct file *file,
 	if (sscanf(buf, "%d", &csr) != 1)
 		return -EFAULT;
 
-	if (priv->cfg->ops->lib->dump_csr)
-		priv->cfg->ops->lib->dump_csr(priv);
+	iwl_dump_csr(priv);
 
 	return count;
 }
@@ -1359,13 +1356,11 @@ static ssize_t iwl_dbgfs_fh_reg_read(struct file *file,
 	int pos = 0;
 	ssize_t ret = -EFAULT;
 
-	if (priv->cfg->ops->lib->dump_fh) {
-		ret = pos = priv->cfg->ops->lib->dump_fh(priv, &buf, true);
-		if (buf) {
-			ret = simple_read_from_buffer(user_buf,
-						      count, ppos, buf, pos);
-			kfree(buf);
-		}
+	ret = pos = iwl_dump_fh(priv, &buf, true);
+	if (buf) {
+		ret = simple_read_from_buffer(user_buf,
+					      count, ppos, buf, pos);
+		kfree(buf);
 	}
 
 	return ret;
-- 
1.7.0.4

