Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:4582 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755472Ab1DERBc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 13:01:32 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/25] iwlagn: centralize and fix ucode restart
Date: Tue,  5 Apr 2011 09:41:58 -0700
Message-Id: <1302021732-21250-12-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302021732-21250-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The ucode restart has to take into account a number
of things, like clearing the HCMD_ACTIVE and other
status bits, and waking up the wait_command_queue.
Currently, however, there are a number of places
that neither do that, nor actually set the FW error
bit that leads to proper restart handling, which
means that in those cases things will probably just
hang completely.

To clean this up, make all ucode restart go through
a single function, except for the cases where it's
called during firmware loading.

Also fix a bug in wimax coexist restart avoidance,
it needs to first clear the status bits (and it has
to clear the HCMD_ACTIVE one as well) and then wake
up anything waiting on wait_command_queue.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   99 ++++++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    3 +
 drivers/net/wireless/iwlwifi/iwl-tx.c   |    4 +-
 3 files changed, 56 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d778f52..64b28b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -890,10 +890,8 @@ void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 	IWL_DEBUG_RADIO(priv, "u16 assoc_id: 0x%x\n", le16_to_cpu(rxon->assoc_id));
 }
 #endif
-/**
- * iwl_irq_handle_error - called for HW or SW error interrupt from card
- */
-void iwl_irq_handle_error(struct iwl_priv *priv)
+
+void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 {
 	unsigned int reload_msec;
 	unsigned long reload_jiffies;
@@ -904,18 +902,62 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 	/* Cancel currently queued command. */
 	clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
+	/* Keep the restart process from trying to send host
+	 * commands by clearing the ready bit */
+	clear_bit(STATUS_READY, &priv->status);
+
+	wake_up_interruptible(&priv->wait_command_queue);
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
+		if (priv->cfg->mod_params->restart_fw) {
+			IWL_DEBUG(priv, IWL_DL_FW_ERRORS,
+				  "Restarting adapter due to uCode error.\n");
+			queue_work(priv->workqueue, &priv->restart);
+		} else
+			IWL_DEBUG(priv, IWL_DL_FW_ERRORS,
+				  "Detected FW error, but not restarting\n");
+	}
+}
+
+/**
+ * iwl_irq_handle_error - called for HW or SW error interrupt from card
+ */
+void iwl_irq_handle_error(struct iwl_priv *priv)
+{
 	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
 	if (priv->cfg->internal_wimax_coex &&
 	    (!(iwl_read_prph(priv, APMG_CLK_CTRL_REG) &
 			APMS_CLK_VAL_MRB_FUNC_MODE) ||
 	     (iwl_read_prph(priv, APMG_PS_CTRL_REG) &
 			APMG_PS_CTRL_VAL_RESET_REQ))) {
-		wake_up_interruptible(&priv->wait_command_queue);
 		/*
-		 *Keep the restart process from trying to send host
-		 * commands by clearing the INIT status bit
+		 * Keep the restart process from trying to send host
+		 * commands by clearing the ready bit.
 		 */
 		clear_bit(STATUS_READY, &priv->status);
+		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
+		wake_up_interruptible(&priv->wait_command_queue);
 		IWL_ERR(priv, "RF is used by WiMAX\n");
 		return;
 	}
@@ -935,38 +977,7 @@ void iwl_irq_handle_error(struct iwl_priv *priv)
 					&priv->contexts[IWL_RXON_CTX_BSS]);
 #endif
 
-	wake_up_interruptible(&priv->wait_command_queue);
-
-	/* Keep the restart process from trying to send host
-	 * commands by clearing the INIT status bit */
-	clear_bit(STATUS_READY, &priv->status);
-
-	/*
-	 * If firmware keep reloading, then it indicate something
-	 * serious wrong and firmware having problem to recover
-	 * from it. Instead of keep trying which will fill the syslog
-	 * and hang the system, let's just stop it
-	 */
-	reload_jiffies = jiffies;
-	reload_msec = jiffies_to_msecs((long) reload_jiffies -
-				(long) priv->reload_jiffies);
-	priv->reload_jiffies = reload_jiffies;
-	if (reload_msec <= IWL_MIN_RELOAD_DURATION) {
-		priv->reload_count++;
-		if (priv->reload_count >= IWL_MAX_CONTINUE_RELOAD_CNT) {
-			IWL_ERR(priv, "BUG_ON, Stop restarting\n");
-			return;
-		}
-	} else
-		priv->reload_count = 0;
-
-	if (!test_bit(STATUS_EXIT_PENDING, &priv->status)) {
-		IWL_DEBUG(priv, IWL_DL_FW_ERRORS,
-			  "Restarting adapter due to uCode error.\n");
-
-		if (priv->cfg->mod_params->restart_fw)
-			queue_work(priv->workqueue, &priv->restart);
-	}
+	iwlagn_fw_error(priv, false);
 }
 
 static int iwl_apm_stop_master(struct iwl_priv *priv)
@@ -1755,15 +1766,7 @@ int iwl_force_reset(struct iwl_priv *priv, int mode, bool external)
 			break;
 		}
 		IWL_ERR(priv, "On demand firmware reload\n");
-		/* Set the FW error flag -- cleared on iwl_down */
-		set_bit(STATUS_FW_ERROR, &priv->status);
-		wake_up_interruptible(&priv->wait_command_queue);
-		/*
-		 * Keep the restart process from trying to send host
-		 * commands by clearing the INIT status bit
-		 */
-		clear_bit(STATUS_READY, &priv->status);
-		queue_work(priv->workqueue, &priv->restart);
+		iwlagn_fw_error(priv, true);
 		break;
 	}
 	return 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 46c90b3..8bc2346 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -729,4 +729,7 @@ static inline bool iwl_bt_statistics(struct iwl_priv *priv)
 extern bool bt_coex_active;
 extern bool bt_siso_mode;
 
+
+void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand);
+
 #endif /* __iwl_core_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 277c917..b5d51b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -471,7 +471,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		}
 		if (!is_ct_kill) {
 			IWL_ERR(priv, "Restarting adapter due to queue full\n");
-			queue_work(priv->workqueue, &priv->restart);
+			iwlagn_fw_error(priv, false);
 		}
 		return -ENOSPC;
 	}
@@ -584,7 +584,7 @@ static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id,
 		if (nfreed++ > 0) {
 			IWL_ERR(priv, "HCMD skipped: index (%d) %d %d\n", idx,
 					q->write_ptr, q->read_ptr);
-			queue_work(priv->workqueue, &priv->restart);
+			iwlagn_fw_error(priv, false);
 		}
 
 	}
-- 
1.7.0.4

