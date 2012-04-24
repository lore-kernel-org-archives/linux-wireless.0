Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39524 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758556Ab2DXXv3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 19:51:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/11] iwlwifi: change kill mask based on reduce power state
Date: Tue, 24 Apr 2012 16:46:00 -0700
Message-Id: <1335311164-10252-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120425_015157_306354_28D436A3)
In-Reply-To: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335311164-10252-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In bt coex, consider reduce tx power as part of ack/cts kill mask

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   22 +++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-commands.h |    7 +++++++
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index ac483eb..9fb4c7d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -546,16 +546,19 @@ static bool iwlagn_set_kill_msk(struct iwl_priv *priv,
 				struct iwl_bt_uart_msg *uart_msg)
 {
 	bool need_update = false;
-	u8 kill_msk;
-	static const __le32 bt_kill_ack_msg[2] = {
+	u8 kill_msk = IWL_BT_KILL_REDUCE;
+	static const __le32 bt_kill_ack_msg[3] = {
 		IWLAGN_BT_KILL_ACK_MASK_DEFAULT,
-		IWLAGN_BT_KILL_ACK_CTS_MASK_SCO };
-	static const __le32 bt_kill_cts_msg[2] = {
+		IWLAGN_BT_KILL_ACK_CTS_MASK_SCO,
+		IWLAGN_BT_KILL_ACK_CTS_MASK_REDUCE};
+	static const __le32 bt_kill_cts_msg[3] = {
 		IWLAGN_BT_KILL_CTS_MASK_DEFAULT,
-		IWLAGN_BT_KILL_ACK_CTS_MASK_SCO };
+		IWLAGN_BT_KILL_ACK_CTS_MASK_SCO,
+		IWLAGN_BT_KILL_ACK_CTS_MASK_REDUCE};
 
-	kill_msk = (BT_UART_MSG_FRAME3SCOESCO_MSK & uart_msg->frame3)
-		? 1 : 0;
+	if (!priv->reduced_txpower)
+		kill_msk = (BT_UART_MSG_FRAME3SCOESCO_MSK & uart_msg->frame3)
+			? IWL_BT_KILL_OVERRIDE : IWL_BT_KILL_DEFAULT;
 	if (priv->kill_ack_mask != bt_kill_ack_msg[kill_msk] ||
 	    priv->kill_cts_mask != bt_kill_cts_msg[kill_msk]) {
 		priv->bt_valid |= IWLAGN_BT_VALID_KILL_ACK_MASK;
@@ -643,8 +646,9 @@ int iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
 	}
 
 	/* schedule to send runtime bt_config */
-	if (iwlagn_set_kill_msk(priv, uart_msg) ||
-	    iwlagn_fill_txpower_mode(priv, uart_msg))
+	/* check reduce power before change ack/cts kill mask */
+	if (iwlagn_fill_txpower_mode(priv, uart_msg) ||
+	    iwlagn_set_kill_msk(priv, uart_msg))
 		queue_work(priv->workqueue, &priv->bt_runtime_config);
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index e5dfbfd..83a6930 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -1877,9 +1877,16 @@ struct iwl_bt_cmd {
 
 #define IWLAGN_BT3_T7_DEFAULT		1
 
+enum iwl_bt_kill_idx {
+	IWL_BT_KILL_DEFAULT = 0,
+	IWL_BT_KILL_OVERRIDE = 1,
+	IWL_BT_KILL_REDUCE = 2,
+};
+
 #define IWLAGN_BT_KILL_ACK_MASK_DEFAULT	cpu_to_le32(0xffff0000)
 #define IWLAGN_BT_KILL_CTS_MASK_DEFAULT	cpu_to_le32(0xffff0000)
 #define IWLAGN_BT_KILL_ACK_CTS_MASK_SCO	cpu_to_le32(0xffffffff)
+#define IWLAGN_BT_KILL_ACK_CTS_MASK_REDUCE	cpu_to_le32(0)
 
 #define IWLAGN_BT3_PRIO_SAMPLE_DEFAULT	2
 
-- 
1.7.0.4

