Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12564 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756551Ab1AaVxU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:53:20 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/11] iwlagn: remove unsupported BT SCO command
Date: Mon, 31 Jan 2011 13:40:46 -0800
Message-Id: <1296510047-24576-11-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1296510047-24576-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During the period of BT coex changes, REPLY_BT_COEX_SCO host command
is no longer needed to support SCO/eSCO type of traffic. delete it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   24 ------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    5 +----
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c  |    7 +++----
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    1 -
 5 files changed, 4 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index c7d0387..600f417 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1863,21 +1863,6 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 	if (iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG, sizeof(bt_cmd), &bt_cmd))
 		IWL_ERR(priv, "failed to send BT Coex Config\n");
 
-	/*
-	 * When we are doing a restart, need to also reconfigure BT
-	 * SCO to the device. If not doing a restart, bt_sco_active
-	 * will always be false, so there's no need to have an extra
-	 * variable to check for it.
-	 */
-	if (priv->bt_sco_active) {
-		struct iwlagn_bt_sco_cmd sco_cmd = { .flags = 0 };
-
-		if (priv->bt_sco_active)
-			sco_cmd.flags |= IWLAGN_BT_SCO_ACTIVE;
-		if (iwl_send_cmd_pdu(priv, REPLY_BT_COEX_SCO,
-				     sizeof(sco_cmd), &sco_cmd))
-			IWL_ERR(priv, "failed to send BT SCO command\n");
-	}
 }
 
 static void iwlagn_bt_traffic_change_work(struct work_struct *work)
@@ -2069,15 +2054,6 @@ void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 			queue_work(priv->workqueue,
 				   &priv->bt_traffic_change_work);
 		}
-		if (priv->bt_sco_active !=
-		    (uart_msg->frame3 & BT_UART_MSG_FRAME3SCOESCO_MSK)) {
-			priv->bt_sco_active = uart_msg->frame3 &
-				BT_UART_MSG_FRAME3SCOESCO_MSK;
-			if (priv->bt_sco_active)
-				sco_cmd.flags |= IWLAGN_BT_SCO_ACTIVE;
-			iwl_send_cmd_pdu_async(priv, REPLY_BT_COEX_SCO,
-				       sizeof(sco_cmd), &sco_cmd, NULL);
-		}
 	}
 
 	iwlagn_set_kill_msk(priv, uart_msg);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index d62e592..a5daf64 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2780,7 +2780,6 @@ static void __iwl_down(struct iwl_priv *priv)
 			 priv->cfg->bt_params->bt_init_traffic_load;
 	else
 		priv->bt_traffic_load = 0;
-	priv->bt_sco_active = false;
 	priv->bt_full_concurrent = false;
 	priv->bt_ci_compliance = 0;
 
@@ -3099,7 +3098,7 @@ static void iwl_bg_restart(struct work_struct *data)
 
 	if (test_and_clear_bit(STATUS_FW_ERROR, &priv->status)) {
 		struct iwl_rxon_context *ctx;
-		bool bt_sco, bt_full_concurrent;
+		bool bt_full_concurrent;
 		u8 bt_ci_compliance;
 		u8 bt_load;
 		u8 bt_status;
@@ -3118,7 +3117,6 @@ static void iwl_bg_restart(struct work_struct *data)
 		 * re-configure the hw when we reconfigure the BT
 		 * command.
 		 */
-		bt_sco = priv->bt_sco_active;
 		bt_full_concurrent = priv->bt_full_concurrent;
 		bt_ci_compliance = priv->bt_ci_compliance;
 		bt_load = priv->bt_traffic_load;
@@ -3126,7 +3124,6 @@ static void iwl_bg_restart(struct work_struct *data)
 
 		__iwl_down(priv);
 
-		priv->bt_sco_active = bt_sco;
 		priv->bt_full_concurrent = bt_full_concurrent;
 		priv->bt_ci_compliance = bt_ci_compliance;
 		priv->bt_traffic_load = bt_load;
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index c3ab6ba..0a1d4ae 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -178,7 +178,6 @@ enum {
 	REPLY_BT_COEX_PRIO_TABLE = 0xcc,
 	REPLY_BT_COEX_PROT_ENV = 0xcd,
 	REPLY_BT_COEX_PROFILE_NOTIF = 0xce,
-	REPLY_BT_COEX_SCO = 0xcf,
 
 	/* PAN commands */
 	REPLY_WIPAN_PARAMS = 0xb2,
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index bdcb742..bc7a965 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1587,10 +1587,9 @@ static ssize_t iwl_dbgfs_bt_traffic_read(struct file *file,
 			 "last traffic notif: %d\n",
 		priv->bt_status ? "On" : "Off", priv->last_bt_traffic_load);
 	pos += scnprintf(buf + pos, bufsz - pos, "ch_announcement: %d, "
-			 "sco_active: %d, kill_ack_mask: %x, "
-			 "kill_cts_mask: %x\n",
-		priv->bt_ch_announce, priv->bt_sco_active,
-		priv->kill_ack_mask, priv->kill_cts_mask);
+			 "kill_ack_mask: %x, kill_cts_mask: %x\n",
+		priv->bt_ch_announce, priv->kill_ack_mask,
+		priv->kill_cts_mask);
 
 	pos += scnprintf(buf + pos, bufsz - pos, "bluetooth traffic load: ");
 	switch (priv->bt_traffic_load) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index c56b797..ecfbef4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1504,7 +1504,6 @@ struct iwl_priv {
 	u8 bt_status;
 	u8 bt_traffic_load, last_bt_traffic_load;
 	bool bt_ch_announce;
-	bool bt_sco_active;
 	bool bt_full_concurrent;
 	bool bt_ant_couple_ok;
 	__le32 kill_ack_mask;
-- 
1.7.0.4

