Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20096 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758589Ab1FKOzm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Jun 2011 10:55:42 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/18] iwlagn: add debug message for coex related activities
Date: Sat, 11 Jun 2011 07:25:44 -0700
Message-Id: <1307802352-16398-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110611_165554_242697_124AAE06)
In-Reply-To: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1307802352-16398-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding dedicated debug message for coex related activities

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   30 ++++++++++++++--------------
 1 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 90cd647..a8c1e24 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -438,7 +438,7 @@ static void iwlagn_rx_reply_tx(struct iwl_priv *priv,
 		if (tx_resp->bt_kill_count && tx_resp->frame_count == 1 &&
 		    priv->cfg->bt_params &&
 		    priv->cfg->bt_params->advanced_bt_coexist) {
-			IWL_WARN(priv, "receive reply tx with bt_kill\n");
+			IWL_DEBUG_COEX(priv, "receive reply tx with bt_kill\n");
 		}
 		iwlagn_tx_status_reply_tx(priv, agg, tx_resp, txq_id, index);
 
@@ -1713,7 +1713,7 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 
 		if (priv->bt_ch_announce)
 			basic.flags |= IWLAGN_BT_FLAG_CHANNEL_INHIBITION;
-		IWL_DEBUG_INFO(priv, "BT coex flag: 0X%x\n", basic.flags);
+		IWL_DEBUG_COEX(priv, "BT coex flag: 0X%x\n", basic.flags);
 	}
 	priv->bt_enable_flag = basic.flags;
 	if (priv->bt_full_concurrent)
@@ -1723,7 +1723,7 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 		memcpy(basic.bt3_lookup_table, iwlagn_def_3w_lookup,
 			sizeof(iwlagn_def_3w_lookup));
 
-	IWL_DEBUG_INFO(priv, "BT coex %s in %s mode\n",
+	IWL_DEBUG_COEX(priv, "BT coex %s in %s mode\n",
 		       basic.flags ? "active" : "disabled",
 		       priv->bt_full_concurrent ?
 		       "full concurrency" : "3-wire");
@@ -1761,7 +1761,7 @@ static void iwlagn_bt_traffic_change_work(struct work_struct *work)
 	 * coex profile notifications. Ignore that since only bad consequence
 	 * can be not matching debug print with actual state.
 	 */
-	IWL_DEBUG_INFO(priv, "BT traffic load changes: %d\n",
+	IWL_DEBUG_COEX(priv, "BT traffic load changes: %d\n",
 		       priv->bt_traffic_load);
 
 	switch (priv->bt_traffic_load) {
@@ -1813,7 +1813,7 @@ out:
 static void iwlagn_print_uartmsg(struct iwl_priv *priv,
 				struct iwl_bt_uart_msg *uart_msg)
 {
-	IWL_DEBUG_NOTIF(priv, "Message Type = 0x%X, SSN = 0x%X, "
+	IWL_DEBUG_COEX(priv, "Message Type = 0x%X, SSN = 0x%X, "
 			"Update Req = 0x%X",
 		(BT_UART_MSG_FRAME1MSGTYPE_MSK & uart_msg->frame1) >>
 			BT_UART_MSG_FRAME1MSGTYPE_POS,
@@ -1822,7 +1822,7 @@ static void iwlagn_print_uartmsg(struct iwl_priv *priv,
 		(BT_UART_MSG_FRAME1UPDATEREQ_MSK & uart_msg->frame1) >>
 			BT_UART_MSG_FRAME1UPDATEREQ_POS);
 
-	IWL_DEBUG_NOTIF(priv, "Open connections = 0x%X, Traffic load = 0x%X, "
+	IWL_DEBUG_COEX(priv, "Open connections = 0x%X, Traffic load = 0x%X, "
 			"Chl_SeqN = 0x%X, In band = 0x%X",
 		(BT_UART_MSG_FRAME2OPENCONNECTIONS_MSK & uart_msg->frame2) >>
 			BT_UART_MSG_FRAME2OPENCONNECTIONS_POS,
@@ -1833,7 +1833,7 @@ static void iwlagn_print_uartmsg(struct iwl_priv *priv,
 		(BT_UART_MSG_FRAME2INBAND_MSK & uart_msg->frame2) >>
 			BT_UART_MSG_FRAME2INBAND_POS);
 
-	IWL_DEBUG_NOTIF(priv, "SCO/eSCO = 0x%X, Sniff = 0x%X, A2DP = 0x%X, "
+	IWL_DEBUG_COEX(priv, "SCO/eSCO = 0x%X, Sniff = 0x%X, A2DP = 0x%X, "
 			"ACL = 0x%X, Master = 0x%X, OBEX = 0x%X",
 		(BT_UART_MSG_FRAME3SCOESCO_MSK & uart_msg->frame3) >>
 			BT_UART_MSG_FRAME3SCOESCO_POS,
@@ -1848,11 +1848,11 @@ static void iwlagn_print_uartmsg(struct iwl_priv *priv,
 		(BT_UART_MSG_FRAME3OBEX_MSK & uart_msg->frame3) >>
 			BT_UART_MSG_FRAME3OBEX_POS);
 
-	IWL_DEBUG_NOTIF(priv, "Idle duration = 0x%X",
+	IWL_DEBUG_COEX(priv, "Idle duration = 0x%X",
 		(BT_UART_MSG_FRAME4IDLEDURATION_MSK & uart_msg->frame4) >>
 			BT_UART_MSG_FRAME4IDLEDURATION_POS);
 
-	IWL_DEBUG_NOTIF(priv, "Tx Activity = 0x%X, Rx Activity = 0x%X, "
+	IWL_DEBUG_COEX(priv, "Tx Activity = 0x%X, Rx Activity = 0x%X, "
 			"eSCO Retransmissions = 0x%X",
 		(BT_UART_MSG_FRAME5TXACTIVITY_MSK & uart_msg->frame5) >>
 			BT_UART_MSG_FRAME5TXACTIVITY_POS,
@@ -1861,13 +1861,13 @@ static void iwlagn_print_uartmsg(struct iwl_priv *priv,
 		(BT_UART_MSG_FRAME5ESCORETRANSMIT_MSK & uart_msg->frame5) >>
 			BT_UART_MSG_FRAME5ESCORETRANSMIT_POS);
 
-	IWL_DEBUG_NOTIF(priv, "Sniff Interval = 0x%X, Discoverable = 0x%X",
+	IWL_DEBUG_COEX(priv, "Sniff Interval = 0x%X, Discoverable = 0x%X",
 		(BT_UART_MSG_FRAME6SNIFFINTERVAL_MSK & uart_msg->frame6) >>
 			BT_UART_MSG_FRAME6SNIFFINTERVAL_POS,
 		(BT_UART_MSG_FRAME6DISCOVERABLE_MSK & uart_msg->frame6) >>
 			BT_UART_MSG_FRAME6DISCOVERABLE_POS);
 
-	IWL_DEBUG_NOTIF(priv, "Sniff Activity = 0x%X, Page = "
+	IWL_DEBUG_COEX(priv, "Sniff Activity = 0x%X, Page = "
 			"0x%X, Inquiry = 0x%X, Connectable = 0x%X",
 		(BT_UART_MSG_FRAME7SNIFFACTIVITY_MSK & uart_msg->frame7) >>
 			BT_UART_MSG_FRAME7SNIFFACTIVITY_POS,
@@ -1917,10 +1917,10 @@ void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 		return;
 	}
 
-	IWL_DEBUG_NOTIF(priv, "BT Coex notification:\n");
-	IWL_DEBUG_NOTIF(priv, "    status: %d\n", coex->bt_status);
-	IWL_DEBUG_NOTIF(priv, "    traffic load: %d\n", coex->bt_traffic_load);
-	IWL_DEBUG_NOTIF(priv, "    CI compliance: %d\n",
+	IWL_DEBUG_COEX(priv, "BT Coex notification:\n");
+	IWL_DEBUG_COEX(priv, "    status: %d\n", coex->bt_status);
+	IWL_DEBUG_COEX(priv, "    traffic load: %d\n", coex->bt_traffic_load);
+	IWL_DEBUG_COEX(priv, "    CI compliance: %d\n",
 			coex->bt_ci_compliance);
 	iwlagn_print_uartmsg(priv, uart_msg);
 
-- 
1.7.0.4

