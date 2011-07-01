Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26451 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756564Ab1GAPxF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 11:53:05 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/11] iwlagn: call bt_coex directlly
Date: Fri,  1 Jul 2011 08:20:03 -0700
Message-Id: <1309533605-25774-10-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110701_175317_535913_400EE59C)
In-Reply-To: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Call the 2-wire and advanced bt-coex function directly to avoid mistake

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f9127e7..ffb0b19 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -260,7 +260,7 @@ static void iwl_bg_bt_runtime_config(struct work_struct *work)
 	/* dont send host command if rf-kill is on */
 	if (!iwl_is_ready_rf(priv))
 		return;
-	priv->cfg->ops->hcmd->send_bt_config(priv);
+	iwlagn_send_advance_bt_config(priv);
 }
 
 static void iwl_bg_bt_full_concurrency(struct work_struct *work)
@@ -292,7 +292,7 @@ static void iwl_bg_bt_full_concurrency(struct work_struct *work)
 		iwlagn_commit_rxon(priv, ctx);
 	}
 
-	priv->cfg->ops->hcmd->send_bt_config(priv);
+	iwlagn_send_advance_bt_config(priv);
 out:
 	mutex_unlock(&priv->mutex);
 }
@@ -2017,7 +2017,7 @@ int iwl_alive_start(struct iwl_priv *priv)
 		priv->bt_valid = IWLAGN_BT_ALL_VALID_MSK;
 		priv->kill_ack_mask = IWLAGN_BT_KILL_ACK_MASK_DEFAULT;
 		priv->kill_cts_mask = IWLAGN_BT_KILL_CTS_MASK_DEFAULT;
-		priv->cfg->ops->hcmd->send_bt_config(priv);
+		iwlagn_send_advance_bt_config(priv);
 		priv->bt_valid = IWLAGN_BT_VALID_ENABLE_FLAGS;
 		iwlagn_send_prio_tbl(priv);
 
@@ -2030,7 +2030,13 @@ int iwl_alive_start(struct iwl_priv *priv)
 					 BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
 		if (ret)
 			return ret;
+	} else {
+		/*
+		 * default is 2-wire BT coexexistence support
+		 */
+		iwl_send_bt_config(priv);
 	}
+
 	if (priv->hw_params.calib_rt_cfg)
 		iwlagn_send_calib_cfg_rt(priv, priv->hw_params.calib_rt_cfg);
 
@@ -2058,14 +2064,6 @@ int iwl_alive_start(struct iwl_priv *priv)
 			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
 	}
 
-	if (!priv->cfg->bt_params || (priv->cfg->bt_params &&
-	    !priv->cfg->bt_params->advanced_bt_coexist)) {
-		/*
-		 * default is 2-wire BT coexexistence support
-		 */
-		priv->cfg->ops->hcmd->send_bt_config(priv);
-	}
-
 	iwl_reset_run_time_calib(priv);
 
 	set_bit(STATUS_READY, &priv->status);
-- 
1.7.0.4

