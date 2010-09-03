Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26701 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab0ICTlH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 15:41:07 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH wireless-next-2.6] iwlagn: open/close envlope to force move BT state machine
Date: Fri,  3 Sep 2010 12:43:43 -0700
Message-Id: <1283543023-30269-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

In uCode, BT state machine need to receive open envlope
command before perform calibration; followed by close envlope
command to move to next stage.

Since Linux has two separated uCode, one for init and the second
one for runtime; we use open envlope commands for init uCode to
indicate we are ready to perform calibration operation.
But for runtime uCode, we are not doing any init calibration,
so we issue open/close envlope commands to force uCode move to
"BT COEX ON" state.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
this patch is also available from wireless-2.6 branch on
 git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   34 ++++++++++----------------
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   16 ++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    2 +
 3 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index a7961bf..8bfb049 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -307,6 +307,17 @@ void iwlagn_init_alive_start(struct iwl_priv *priv)
 		goto restart;
 	}
 
+	if (priv->cfg->advanced_bt_coexist) {
+		/*
+		 * Tell uCode we are ready to perform calibration
+		 * need to perform this before any calibration
+		 * no need to close the envlope since we are going
+		 * to load the runtime uCode later.
+		 */
+		iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_OPEN,
+			BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
+
+	}
 	iwlagn_send_calib_cfg(priv);
 	return;
 
@@ -364,7 +375,7 @@ static const u8 iwlagn_bt_prio_tbl[BT_COEX_PRIO_TBL_EVT_MAX] = {
 	0, 0, 0, 0, 0, 0, 0
 };
 
-static void iwlagn_send_prio_tbl(struct iwl_priv *priv)
+void iwlagn_send_prio_tbl(struct iwl_priv *priv)
 {
 	struct iwl_bt_coex_prio_table_cmd prio_tbl_cmd;
 
@@ -375,7 +386,7 @@ static void iwlagn_send_prio_tbl(struct iwl_priv *priv)
 		IWL_ERR(priv, "failed to send BT prio tbl command\n");
 }
 
-static void iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
+void iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 {
 	struct iwl_bt_coex_prot_env_cmd env_cmd;
 
@@ -482,25 +493,6 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	if (priv->cfg->advanced_bt_coexist) {
-		/* Configure Bluetooth device coexistence support */
-		/* need to perform this before any calibration */
-		priv->bt_valid = IWLAGN_BT_ALL_VALID_MSK;
-		priv->kill_ack_mask = IWLAGN_BT_KILL_ACK_MASK_DEFAULT;
-		priv->kill_cts_mask = IWLAGN_BT_KILL_CTS_MASK_DEFAULT;
-		priv->cfg->ops->hcmd->send_bt_config(priv);
-		priv->bt_valid = IWLAGN_BT_VALID_ENABLE_FLAGS;
-
-		if (bt_coex_active && priv->iw_mode != NL80211_IFTYPE_ADHOC) {
-			iwlagn_send_prio_tbl(priv);
-			iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_OPEN,
-				BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
-			iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_CLOSE,
-				BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
-		}
-
-	}
-
 	iwlagn_send_wimax_coex(priv);
 
 	iwlagn_set_Xtal_calib(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index ad0e67f..55ac079 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2813,6 +2813,22 @@ static void iwl_alive_start(struct iwl_priv *priv)
 	if (iwl_is_rfkill(priv))
 		return;
 
+	if (priv->cfg->advanced_bt_coexist) {
+		/* Configure Bluetooth device coexistence support */
+		priv->bt_valid = IWLAGN_BT_ALL_VALID_MSK;
+		priv->kill_ack_mask = IWLAGN_BT_KILL_ACK_MASK_DEFAULT;
+		priv->kill_cts_mask = IWLAGN_BT_KILL_CTS_MASK_DEFAULT;
+		priv->cfg->ops->hcmd->send_bt_config(priv);
+		priv->bt_valid = IWLAGN_BT_VALID_ENABLE_FLAGS;
+		if (bt_coex_active && priv->iw_mode != NL80211_IFTYPE_ADHOC)
+			iwlagn_send_prio_tbl(priv);
+
+		/* FIXME: w/a to force change uCode BT state machine */
+		iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_OPEN,
+			BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
+		iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_CLOSE,
+			BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
+	}
 	ieee80211_wake_queues(priv->hw);
 
 	priv->active_rate = IWL_RATES_MASK;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 7c542a8..ab7c16f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -134,6 +134,8 @@ void iwlagn_rx_calib_complete(struct iwl_priv *priv,
 void iwlagn_init_alive_start(struct iwl_priv *priv);
 int iwlagn_alive_notify(struct iwl_priv *priv);
 int iwl_verify_ucode(struct iwl_priv *priv);
+void iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type);
+void iwlagn_send_prio_tbl(struct iwl_priv *priv);
 
 /* lib */
 void iwl_check_abort_status(struct iwl_priv *priv,
-- 
1.7.0.4

