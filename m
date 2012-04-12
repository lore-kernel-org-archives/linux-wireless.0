Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58877 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966091Ab2DLV6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:09 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/24] iwlwifi: move iwlagn_fw_error to iwl-agn.c
Date: Thu, 12 Apr 2012 14:54:11 -0700
Message-Id: <1334267661-14654-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235903_854772_615EA8C4)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Move this as part of iwl-core.c cleanup.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   59 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h  |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.c |   59 -------------------------------
 3 files changed, 59 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b0cadcc..5773cbe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2119,6 +2119,65 @@ int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 	return pos;
 }
 
+static void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
+{
+	unsigned int reload_msec;
+	unsigned long reload_jiffies;
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	if (iwl_have_debug_level(IWL_DL_FW_ERRORS))
+		iwl_print_rx_config_cmd(priv, IWL_RXON_CTX_BSS);
+#endif
+
+	/* uCode is no longer loaded. */
+	priv->ucode_loaded = false;
+
+	/* Set the FW error flag -- cleared on iwl_down */
+	set_bit(STATUS_FW_ERROR, &priv->status);
+
+	/* Cancel currently queued command. */
+	clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
+
+	iwl_abort_notification_waits(&priv->notif_wait);
+
+	/* Keep the restart process from trying to send host
+	 * commands by clearing the ready bit */
+	clear_bit(STATUS_READY, &priv->status);
+
+	wake_up(&trans(priv)->wait_command_queue);
+
+	if (!ondemand) {
+		/*
+		 * If firmware keep reloading, then it indicate something
+		 * serious wrong and firmware having problem to recover
+		 * from it. Instead of keep trying which will fill the syslog
+		 * and hang the system, let's just stop it
+		 */
+		reload_jiffies = jiffies;
+		reload_msec = jiffies_to_msecs((long) reload_jiffies -
+					(long) priv->reload_jiffies);
+		priv->reload_jiffies = reload_jiffies;
+		if (reload_msec <= IWL_MIN_RELOAD_DURATION) {
+			priv->reload_count++;
+			if (priv->reload_count >= IWL_MAX_CONTINUE_RELOAD_CNT) {
+				IWL_ERR(priv, "BUG_ON, Stop restarting\n");
+				return;
+			}
+		} else
+			priv->reload_count = 0;
+	}
+
+	if (!test_bit(STATUS_EXIT_PENDING, &priv->status)) {
+		if (iwlagn_mod_params.restart_fw) {
+			IWL_DEBUG_FW_ERRORS(priv,
+				  "Restarting adapter due to uCode error.\n");
+			queue_work(priv->workqueue, &priv->restart);
+		} else
+			IWL_DEBUG_FW_ERRORS(priv,
+				  "Detected FW error, but not restarting\n");
+	}
+}
+
 static void iwl_nic_error(struct iwl_op_mode *op_mode)
 {
 	struct iwl_priv *priv = IWL_OP_MODE_GET_DVM(op_mode);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index ac0e8ba..4552319 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -149,7 +149,6 @@ int iwl_send_calib_results(struct iwl_priv *priv);
 int iwl_calib_set(struct iwl_priv *priv,
 		  const struct iwl_calib_hdr *cmd, int len);
 void iwl_calib_free_results(struct iwl_priv *priv);
-void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
 int iwl_dump_nic_event_log(struct iwl_priv *priv, bool full_log,
 			    char **buf, bool display);
 int iwlagn_hw_valid_rtc_data_addr(u32 addr);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f43a1e5..42789ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -66,65 +66,6 @@ void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 }
 #endif
 
-void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
-{
-	unsigned int reload_msec;
-	unsigned long reload_jiffies;
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	if (iwl_have_debug_level(IWL_DL_FW_ERRORS))
-		iwl_print_rx_config_cmd(priv, IWL_RXON_CTX_BSS);
-#endif
-
-	/* uCode is no longer loaded. */
-	priv->ucode_loaded = false;
-
-	/* Set the FW error flag -- cleared on iwl_down */
-	set_bit(STATUS_FW_ERROR, &priv->status);
-
-	/* Cancel currently queued command. */
-	clear_bit(STATUS_HCMD_ACTIVE, &priv->shrd->status);
-
-	iwl_abort_notification_waits(&priv->notif_wait);
-
-	/* Keep the restart process from trying to send host
-	 * commands by clearing the ready bit */
-	clear_bit(STATUS_READY, &priv->status);
-
-	wake_up(&trans(priv)->wait_command_queue);
-
-	if (!ondemand) {
-		/*
-		 * If firmware keep reloading, then it indicate something
-		 * serious wrong and firmware having problem to recover
-		 * from it. Instead of keep trying which will fill the syslog
-		 * and hang the system, let's just stop it
-		 */
-		reload_jiffies = jiffies;
-		reload_msec = jiffies_to_msecs((long) reload_jiffies -
-					(long) priv->reload_jiffies);
-		priv->reload_jiffies = reload_jiffies;
-		if (reload_msec <= IWL_MIN_RELOAD_DURATION) {
-			priv->reload_count++;
-			if (priv->reload_count >= IWL_MAX_CONTINUE_RELOAD_CNT) {
-				IWL_ERR(priv, "BUG_ON, Stop restarting\n");
-				return;
-			}
-		} else
-			priv->reload_count = 0;
-	}
-
-	if (!test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		if (iwlagn_mod_params.restart_fw) {
-			IWL_DEBUG_FW_ERRORS(priv,
-				  "Restarting adapter due to uCode error.\n");
-			queue_work(priv->workqueue, &priv->restart);
-		} else
-			IWL_DEBUG_FW_ERRORS(priv,
-				  "Detected FW error, but not restarting\n");
-	}
-}
-
 int iwl_set_tx_power(struct iwl_priv *priv, s8 tx_power, bool force)
 {
 	int ret;
-- 
1.7.0.4

