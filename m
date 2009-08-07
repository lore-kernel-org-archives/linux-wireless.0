Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:17727 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394AbZHGWl7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 18:41:59 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/16] iwlwifi: display correct critical temperature infomation
Date: Fri,  7 Aug 2009 15:41:50 -0700
Message-Id: <1249684912-22936-15-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
References: <1249684912-22936-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Do not send CT KILL config command twice and correct critical
temperature informatiom in dmesg

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 44d01a2..36c6e16 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2227,6 +2227,15 @@ void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 
 		ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
 				       sizeof(adv_cmd), &adv_cmd);
+		if (ret)
+			IWL_ERR(priv, "REPLY_CT_KILL_CONFIG_CMD failed\n");
+		else
+			IWL_DEBUG_INFO(priv, "REPLY_CT_KILL_CONFIG_CMD "
+					"succeeded, "
+					"critical temperature enter is %d,"
+					"exit is %d\n",
+				       priv->hw_params.ct_kill_threshold,
+				       priv->hw_params.ct_kill_exit_threshold);
 		break;
 	default:
 		cmd.critical_temperature_R =
@@ -2234,16 +2243,15 @@ void iwl_rf_kill_ct_config(struct iwl_priv *priv)
 
 		ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
 				       sizeof(cmd), &cmd);
+		if (ret)
+			IWL_ERR(priv, "REPLY_CT_KILL_CONFIG_CMD failed\n");
+		else
+			IWL_DEBUG_INFO(priv, "REPLY_CT_KILL_CONFIG_CMD "
+					"succeeded, "
+					"critical temperature is %d\n",
+					priv->hw_params.ct_kill_threshold);
 		break;
 	}
-	ret = iwl_send_cmd_pdu(priv, REPLY_CT_KILL_CONFIG_CMD,
-			       sizeof(cmd), &cmd);
-	if (ret)
-		IWL_ERR(priv, "REPLY_CT_KILL_CONFIG_CMD failed\n");
-	else
-		IWL_DEBUG_INFO(priv, "REPLY_CT_KILL_CONFIG_CMD succeeded, "
-			"critical temperature is %d\n",
-			cmd.critical_temperature_R);
 }
 EXPORT_SYMBOL(iwl_rf_kill_ct_config);
 
-- 
1.5.6.3

