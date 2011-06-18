Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1FRQFZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:25 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/25] iwlagn: Remove un-necessary indirect call
Date: Sat, 18 Jun 2011 08:34:07 -0700
Message-Id: <1308411271-26093-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180618_170448_1507069F)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After driver split, no need to make indirect call to txfifo flush function

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c    |    2 --
 drivers/net/wireless/iwlwifi/iwl-2000.c    |    2 --
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    4 ----
 drivers/net/wireless/iwlwifi/iwl-6000.c    |    4 ----
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   12 +++---------
 drivers/net/wireless/iwlwifi/iwl-core.h    |    4 ----
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    5 ++---
 8 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 7aa240e..454b541 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -194,8 +194,6 @@ static struct iwl_lib_ops iwl1000_lib = {
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
-	.txfifo_flush = iwlagn_txfifo_flush,
-	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 };
 
 static const struct iwl_ops iwl1000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 5484ab7..a6a259b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -204,8 +204,6 @@ static struct iwl_lib_ops iwl2000_lib = {
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	},
-	.txfifo_flush = iwlagn_txfifo_flush,
-	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 };
 
 static const struct iwl_ops iwl2000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 4353a65..c71fa44 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -361,8 +361,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
-	.txfifo_flush = iwlagn_txfifo_flush,
-	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 };
 
 static struct iwl_lib_ops iwl5150_lib = {
@@ -391,8 +389,6 @@ static struct iwl_lib_ops iwl5150_lib = {
 	.temp_ops = {
 		.temperature = iwl5150_temperature,
 	 },
-	.txfifo_flush = iwlagn_txfifo_flush,
-	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 };
 
 static const struct iwl_ops iwl5000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 6e5ce44..b3785ec 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -301,8 +301,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
-	.txfifo_flush = iwlagn_txfifo_flush,
-	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 };
 
 static struct iwl_lib_ops iwl6030_lib = {
@@ -333,8 +331,6 @@ static struct iwl_lib_ops iwl6030_lib = {
 	.temp_ops = {
 		.temperature = iwlagn_temperature,
 	 },
-	.txfifo_flush = iwlagn_txfifo_flush,
-	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
 };
 
 static struct iwl_nic_ops iwl6050_nic_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index a8c1e24..3d9e1e8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1546,7 +1546,7 @@ void iwlagn_dev_txfifo_flush(struct iwl_priv *priv, u16 flush_control)
 {
 	mutex_lock(&priv->mutex);
 	ieee80211_stop_queues(priv->hw);
-	if (priv->cfg->ops->lib->txfifo_flush(priv, IWL_DROP_ALL)) {
+	if (iwlagn_txfifo_flush(priv, IWL_DROP_ALL)) {
 		IWL_ERR(priv, "flush request fail\n");
 		goto done;
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0acf929..d66f1c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -440,10 +440,8 @@ static void iwl_bg_tx_flush(struct work_struct *work)
 	if (!iwl_is_ready_rf(priv))
 		return;
 
-	if (priv->cfg->ops->lib->txfifo_flush) {
-		IWL_DEBUG_INFO(priv, "device request: flush all tx frames\n");
-		iwlagn_dev_txfifo_flush(priv, IWL_DROP_ALL);
-	}
+	IWL_DEBUG_INFO(priv, "device request: flush all tx frames\n");
+	iwlagn_dev_txfifo_flush(priv, IWL_DROP_ALL);
 }
 
 /**
@@ -3052,10 +3050,6 @@ static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 	mutex_lock(&priv->mutex);
 	IWL_DEBUG_MAC80211(priv, "enter\n");
 
-	/* do not support "flush" */
-	if (!priv->cfg->ops->lib->txfifo_flush)
-		goto done;
-
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
 		IWL_DEBUG_TX(priv, "Aborting flush due to device shutdown\n");
 		goto done;
@@ -3071,7 +3065,7 @@ static void iwlagn_mac_flush(struct ieee80211_hw *hw, bool drop)
 	 */
 	if (drop) {
 		IWL_DEBUG_MAC80211(priv, "send flush command\n");
-		if (priv->cfg->ops->lib->txfifo_flush(priv, IWL_DROP_ALL)) {
+		if (iwlagn_txfifo_flush(priv, IWL_DROP_ALL)) {
 			IWL_ERR(priv, "flush request fail\n");
 			goto done;
 		}
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 83ec5eb..84f28e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -142,10 +142,6 @@ struct iwl_lib_ops {
 
 	/* temperature */
 	struct iwl_temp_ops temp_ops;
-
-	int (*txfifo_flush)(struct iwl_priv *priv, u16 flush_control);
-	void (*dev_txfifo_flush)(struct iwl_priv *priv, u16 flush_control);
-
 };
 
 /* NIC specific ops */
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index 5f335c7..6f9ebae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -2493,7 +2493,7 @@ static ssize_t iwl_dbgfs_txfifo_flush_write(struct file *file,
 	if (iwl_is_rfkill(priv))
 		return -EFAULT;
 
-	priv->cfg->ops->lib->dev_txfifo_flush(priv, IWL_DROP_ALL);
+	iwlagn_dev_txfifo_flush(priv, IWL_DROP_ALL);
 
 	return count;
 }
@@ -2693,8 +2693,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(ucode_rx_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(ucode_tx_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(ucode_general_stats, dir_debug, S_IRUSR);
-	if (priv->cfg->ops->lib->dev_txfifo_flush)
-		DEBUGFS_ADD_FILE(txfifo_flush, dir_debug, S_IWUSR);
+	DEBUGFS_ADD_FILE(txfifo_flush, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(protection_mode, dir_debug, S_IWUSR | S_IRUSR);
 
 	DEBUGFS_ADD_FILE(sensitivity, dir_debug, S_IRUSR);
-- 
1.7.0.4

