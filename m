Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932761Ab1KJPtg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 10:49:36 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Todd Previte <toddX.a.previte@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 02/27] iwlwifi: Suppress noisy syslog messages when RF_KILL switch engaged
Date: Thu, 10 Nov 2011 06:55:02 -0800
Message-Id: <1320936927-9078-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_165024_230195_0A57F076)
In-Reply-To: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Todd Previte <toddX.a.previte@intel.com>

When a station is associated with an AP and the RF_KILL switch is engaged,
numerous error messages were sent to the system log. The error messages
were the result of the failure(s) of the various submodules to perform
their tasks after the radios were disabled.

To resolve this situation, the messages were modified to use a new macro,
IWL_DEBUG_QUIET_RFKILL. This macro allows for the RF_KILL error messages
to be sent to the log provided that IWL_DEBUG is true and IWL_DL_RADIO
is '1'. For all other cases, the error messages resulting from an RFKILL
event will not be sent to the system log. Messages logged because of an
RFKILL will be tagged with the prefix '(RFKILL)' to clarify the cause of
the error.

Signed-off-by: Todd Previte <toddX.a.previte@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c      |    5 +++--
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h         |   15 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |   10 ++++++----
 4 files changed, 25 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 58a381c..4c52bee 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -45,7 +45,8 @@ static int iwlagn_disable_bss(struct iwl_priv *priv,
 	send->filter_flags = old_filter;
 
 	if (ret)
-		IWL_ERR(priv, "Error clearing ASSOC_MSK on BSS (%d)\n", ret);
+		IWL_DEBUG_QUIET_RFKILL(priv,
+			"Error clearing ASSOC_MSK on BSS (%d)\n", ret);
 
 	return ret;
 }
@@ -124,7 +125,7 @@ static void iwlagn_update_qos(struct iwl_priv *priv,
 			       sizeof(struct iwl_qosparam_cmd),
 			       &ctx->qos_data.def_qos_parm);
 	if (ret)
-		IWL_ERR(priv, "Failed to update QoS\n");
+		IWL_DEBUG_QUIET_RFKILL(priv, "Failed to update QoS\n");
 }
 
 static int iwlagn_update_beacon(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index ed62836..9306768 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -840,7 +840,7 @@ int iwlagn_mac_sta_remove(struct ieee80211_hw *hw,
 			sta->addr);
 	ret = iwl_remove_station(priv, sta_priv->sta_id, sta->addr);
 	if (ret)
-		IWL_ERR(priv, "Error removing station %pM\n",
+		IWL_DEBUG_QUIET_RFKILL(priv, "Error removing station %pM\n",
 			sta->addr);
 	mutex_unlock(&priv->shrd->mutex);
 	IWL_DEBUG_MAC80211(priv, "leave\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 69a77e2..1dddf9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -70,10 +70,25 @@ do {                                            			\
 			       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);	\
 } while (0)
 
+#define IWL_DEBUG_QUIET_RFKILL(p, fmt, args...)			\
+do {									\
+	if (!iwl_is_rfkill(p->shrd))				\
+		dev_printk(KERN_ERR, bus(p)->dev, "%c %s " fmt,	\
+		(in_interrupt() ? 'I' : 'U'), __func__ , ##args);	\
+	else if	(iwl_get_debug_level(p->shrd) & IWL_DL_RADIO)	\
+		dev_printk(KERN_ERR, bus(p)->dev, "(RFKILL) %c %s " fmt, \
+		(in_interrupt() ? 'I' : 'U'), __func__ , ##args);	\
+} while (0)
+
 #else
 #define IWL_DEBUG(m, level, fmt, args...)
 #define IWL_DEBUG_LIMIT(m, level, fmt, args...)
 #define iwl_print_hex_dump(m, level, p, len)
+#define IWL_DEBUG_QUIET_RFKILL(p, fmt, args...)	\
+do {							\
+	if (!iwl_is_rfkill(p->shrd))			\
+		IWL_ERR(p, fmt, ##args);		\
+} while (0)
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 4a0c953..461e1ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -982,7 +982,8 @@ static int iwl_send_cmd_async(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 
 	ret = iwl_enqueue_hcmd(trans, cmd);
 	if (ret < 0) {
-		IWL_ERR(trans, "Error sending %s: enqueue_hcmd failed: %d\n",
+		IWL_DEBUG_QUIET_RFKILL(trans,
+			"Error sending %s: enqueue_hcmd failed: %d\n",
 			  get_cmd_string(cmd->id), ret);
 		return ret;
 	}
@@ -1008,7 +1009,8 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 	if (cmd_idx < 0) {
 		ret = cmd_idx;
 		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
-		IWL_ERR(trans, "Error sending %s: enqueue_hcmd failed: %d\n",
+		IWL_DEBUG_QUIET_RFKILL(trans,
+			"Error sending %s: enqueue_hcmd failed: %d\n",
 			  get_cmd_string(cmd->id), ret);
 		return ret;
 	}
@@ -1022,12 +1024,12 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 				&trans_pcie->txq[trans->shrd->cmd_queue];
 			struct iwl_queue *q = &txq->q;
 
-			IWL_ERR(trans,
+			IWL_DEBUG_QUIET_RFKILL(trans,
 				"Error sending %s: time out after %dms.\n",
 				get_cmd_string(cmd->id),
 				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
 
-			IWL_ERR(trans,
+			IWL_DEBUG_QUIET_RFKILL(trans,
 				"Current CMD queue read_ptr %d write_ptr %d\n",
 				q->read_ptr, q->write_ptr);
 
-- 
1.7.0.4

