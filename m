Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58877 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966101Ab2DLV6K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 17:58:10 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 16/24] iwlwifi: move iwl_send_bt_config and mark it static
Date: Thu, 12 Apr 2012 14:54:13 -0700
Message-Id: <1334267661-14654-17-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120412_235904_967798_F05613D0)
In-Reply-To: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334267661-14654-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>

Move this as part of iwl-core.c cleanup.

Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   23 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.c |   23 -----------------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 -
 3 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5773cbe..3d3302a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -726,6 +726,29 @@ static int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant)
 	}
 }
 
+static void iwl_send_bt_config(struct iwl_priv *priv)
+{
+	struct iwl_bt_cmd bt_cmd = {
+		.lead_time = BT_LEAD_TIME_DEF,
+		.max_kill = BT_MAX_KILL_DEF,
+		.kill_ack_mask = 0,
+		.kill_cts_mask = 0,
+	};
+
+	if (!iwlagn_mod_params.bt_coex_active)
+		bt_cmd.flags = BT_COEX_DISABLE;
+	else
+		bt_cmd.flags = BT_COEX_ENABLE;
+
+	priv->bt_enable_flag = bt_cmd.flags;
+	IWL_DEBUG_INFO(priv, "BT coex %s\n",
+		(bt_cmd.flags == BT_COEX_DISABLE) ? "disable" : "active");
+
+	if (iwl_dvm_send_cmd_pdu(priv, REPLY_BT_CONFIG,
+			     CMD_SYNC, sizeof(struct iwl_bt_cmd), &bt_cmd))
+		IWL_ERR(priv, "failed to send BT Coex Config\n");
+}
+
 /**
  * iwl_alive_start - called after REPLY_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 3bd47e7..27121fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -66,29 +66,6 @@ void iwl_print_rx_config_cmd(struct iwl_priv *priv,
 }
 #endif
 
-void iwl_send_bt_config(struct iwl_priv *priv)
-{
-	struct iwl_bt_cmd bt_cmd = {
-		.lead_time = BT_LEAD_TIME_DEF,
-		.max_kill = BT_MAX_KILL_DEF,
-		.kill_ack_mask = 0,
-		.kill_cts_mask = 0,
-	};
-
-	if (!iwlagn_mod_params.bt_coex_active)
-		bt_cmd.flags = BT_COEX_DISABLE;
-	else
-		bt_cmd.flags = BT_COEX_ENABLE;
-
-	priv->bt_enable_flag = bt_cmd.flags;
-	IWL_DEBUG_INFO(priv, "BT coex %s\n",
-		(bt_cmd.flags == BT_COEX_DISABLE) ? "disable" : "active");
-
-	if (iwl_dvm_send_cmd_pdu(priv, REPLY_BT_CONFIG,
-			     CMD_SYNC, sizeof(struct iwl_bt_cmd), &bt_cmd))
-		IWL_ERR(priv, "failed to send BT Coex Config\n");
-}
-
 int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 {
 	struct iwl_statistics_cmd statistics_cmd = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index fdd314f..4d17b85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -153,7 +153,6 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
 
-extern void iwl_send_bt_config(struct iwl_priv *priv);
 extern int iwl_send_statistics_request(struct iwl_priv *priv,
 				       u8 flags, bool clear);
 
-- 
1.7.0.4

