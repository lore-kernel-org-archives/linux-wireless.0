Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15047 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755439Ab0KYBia (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 20:38:30 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 11/12] iwlagn: use different kill mask when SCO active
Date: Wed, 24 Nov 2010 17:32:47 -0800
Message-Id: <1290648768-10075-12-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1290648768-10075-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

use different kill_ack_mask and kill_cts_mask when detect SCO
is active.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   32 ++++++++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-commands.h |    1 +
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index f8fe5f4..3342513 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1814,6 +1814,7 @@ void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
 		bt_cmd.prio_boost = 0;
 	bt_cmd.kill_ack_mask = priv->kill_ack_mask;
 	bt_cmd.kill_cts_mask = priv->kill_cts_mask;
+
 	bt_cmd.valid = priv->bt_valid;
 	bt_cmd.tx_prio_boost = 0;
 	bt_cmd.rx_prio_boost = 0;
@@ -1996,24 +1997,29 @@ static void iwlagn_print_uartmsg(struct iwl_priv *priv,
 			BT_UART_MSG_FRAME7CONNECTABLE_POS);
 }
 
-static void iwlagn_set_kill_ack_msk(struct iwl_priv *priv,
-				     struct iwl_bt_uart_msg *uart_msg)
+static void iwlagn_set_kill_msk(struct iwl_priv *priv,
+				struct iwl_bt_uart_msg *uart_msg)
 {
-	u8 kill_ack_msk;
+	u8 kill_msk;
 	static const __le32 bt_kill_ack_msg[2] = {
-			cpu_to_le32(0xFFFFFFF), cpu_to_le32(0xFFFFFC00) };
-
-	kill_ack_msk = (((BT_UART_MSG_FRAME3A2DP_MSK |
-			BT_UART_MSG_FRAME3SNIFF_MSK |
-			BT_UART_MSG_FRAME3SCOESCO_MSK) &
-			uart_msg->frame3) == 0) ? 1 : 0;
-	if (priv->kill_ack_mask != bt_kill_ack_msg[kill_ack_msk]) {
+		IWLAGN_BT_KILL_ACK_MASK_DEFAULT,
+		IWLAGN_BT_KILL_ACK_CTS_MASK_SCO };
+	static const __le32 bt_kill_cts_msg[2] = {
+		IWLAGN_BT_KILL_CTS_MASK_DEFAULT,
+		IWLAGN_BT_KILL_ACK_CTS_MASK_SCO };
+
+	kill_msk = (BT_UART_MSG_FRAME3SCOESCO_MSK & uart_msg->frame3)
+		? 1 : 0;
+	if (priv->kill_ack_mask != bt_kill_ack_msg[kill_msk] ||
+	    priv->kill_cts_mask != bt_kill_cts_msg[kill_msk]) {
 		priv->bt_valid |= IWLAGN_BT_VALID_KILL_ACK_MASK;
-		priv->kill_ack_mask = bt_kill_ack_msg[kill_ack_msk];
+		priv->kill_ack_mask = bt_kill_ack_msg[kill_msk];
+		priv->bt_valid |= IWLAGN_BT_VALID_KILL_CTS_MASK;
+		priv->kill_cts_mask = bt_kill_cts_msg[kill_msk];
+
 		/* schedule to send runtime bt_config */
 		queue_work(priv->workqueue, &priv->bt_runtime_config);
 	}
-
 }
 
 void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
@@ -2064,7 +2070,7 @@ void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 		}
 	}
 
-	iwlagn_set_kill_ack_msk(priv, uart_msg);
+	iwlagn_set_kill_msk(priv, uart_msg);
 
 	/* FIXME: based on notification, adjust the prio_boost */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index c9448cb..f893d4a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2453,6 +2453,7 @@ struct iwl_bt_cmd {
 
 #define IWLAGN_BT_KILL_ACK_MASK_DEFAULT	cpu_to_le32(0xffff0000)
 #define IWLAGN_BT_KILL_CTS_MASK_DEFAULT	cpu_to_le32(0xffff0000)
+#define IWLAGN_BT_KILL_ACK_CTS_MASK_SCO	cpu_to_le32(0xffffffff)
 
 #define IWLAGN_BT3_PRIO_SAMPLE_DEFAULT	2
 
-- 
1.7.0.4

