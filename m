Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39524 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758488Ab2DXXv1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 19:51:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/11] iwlwifi: add checking for the condition to reduce tx power
Date: Tue, 24 Apr 2012 16:45:56 -0700
Message-Id: <1335311164-10252-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120425_015155_748139_21EDE376)
In-Reply-To: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When bluetooth coex is active and certain condition matched,
driver need to decide should the tx power been reduce or not.
Adding the logic to manage it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   42 +++++++++++++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    1 +
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 0642186..994a7da 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -541,9 +541,10 @@ static void iwlagn_print_uartmsg(struct iwl_priv *priv,
 			BT_UART_MSG_FRAME7CONNECTABLE_POS);
 }
 
-static void iwlagn_set_kill_msk(struct iwl_priv *priv,
+static bool iwlagn_set_kill_msk(struct iwl_priv *priv,
 				struct iwl_bt_uart_msg *uart_msg)
 {
+	bool need_update = false;
 	u8 kill_msk;
 	static const __le32 bt_kill_ack_msg[2] = {
 		IWLAGN_BT_KILL_ACK_MASK_DEFAULT,
@@ -560,10 +561,39 @@ static void iwlagn_set_kill_msk(struct iwl_priv *priv,
 		priv->kill_ack_mask = bt_kill_ack_msg[kill_msk];
 		priv->bt_valid |= IWLAGN_BT_VALID_KILL_CTS_MASK;
 		priv->kill_cts_mask = bt_kill_cts_msg[kill_msk];
+		need_update = true;
+	}
+	return need_update;
+}
 
-		/* schedule to send runtime bt_config */
-		queue_work(priv->workqueue, &priv->bt_runtime_config);
+static bool iwlagn_fill_txpower_mode(struct iwl_priv *priv,
+				struct iwl_bt_uart_msg *uart_msg)
+{
+	bool need_update = false;
+
+	if (!priv->reduced_txpower &&
+	    !iwl_is_associated(priv, IWL_RXON_CTX_PAN) &&
+	    (uart_msg->frame3 & (BT_UART_MSG_FRAME3ACL_MSK |
+	    BT_UART_MSG_FRAME3OBEX_MSK)) &&
+	    !(uart_msg->frame3 & (BT_UART_MSG_FRAME3SCOESCO_MSK |
+	    BT_UART_MSG_FRAME3SNIFF_MSK | BT_UART_MSG_FRAME3A2DP_MSK))) {
+		/* enabling reduced tx power */
+		priv->reduced_txpower = true;
+		priv->bt_valid |= IWLAGN_BT_VALID_REDUCED_TX_PWR;
+		need_update = true;
+	} else if (priv->reduced_txpower &&
+		   (iwl_is_associated(priv, IWL_RXON_CTX_PAN) ||
+		   (uart_msg->frame3 & (BT_UART_MSG_FRAME3SCOESCO_MSK |
+		   BT_UART_MSG_FRAME3SNIFF_MSK | BT_UART_MSG_FRAME3A2DP_MSK)) ||
+		   !(uart_msg->frame3 & (BT_UART_MSG_FRAME3ACL_MSK |
+		   BT_UART_MSG_FRAME3OBEX_MSK)))) {
+		/* disable reduced tx power */
+		priv->reduced_txpower = false;
+		priv->bt_valid &= ~IWLAGN_BT_VALID_REDUCED_TX_PWR;
+		need_update = true;
 	}
+
+	return need_update;
 }
 
 int iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
@@ -611,7 +641,11 @@ int iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 		}
 	}
 
-	iwlagn_set_kill_msk(priv, uart_msg);
+	/* schedule to send runtime bt_config */
+	if (iwlagn_set_kill_msk(priv, uart_msg) ||
+	    iwlagn_fill_txpower_mode(priv, uart_msg))
+		queue_work(priv->workqueue, &priv->bt_runtime_config);
+
 
 	/* FIXME: based on notification, adjust the prio_boost */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index f70219c..7006237 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -921,6 +921,7 @@ struct iwl_priv {
 	__le32 kill_ack_mask;
 	__le32 kill_cts_mask;
 	__le16 bt_valid;
+	bool reduced_txpower;
 	u16 bt_on_thresh;
 	u16 bt_duration;
 	u16 dynamic_frag_thresh;
-- 
1.7.0.4

