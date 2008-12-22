Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbYLVDip (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 22:38:45 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 05/10] iwl3945: switch to the iwl-core send_card_state routine
Date: Mon, 22 Dec 2008 11:31:18 +0800
Message-Id: <1229916683-9772-6-git-send-email-yi.zhu@intel.com> (sfid-20081222_043855_360272_B8E5F20D)
In-Reply-To: <1229916683-9772-5-git-send-email-yi.zhu@intel.com>
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-2-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-3-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-4-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-5-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

Switch iwl3945 to use iwl-core:send_card_state routine.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    3 ++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   34 +--------------------------
 3 files changed, 6 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d3bcbba..eaae79b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1370,7 +1370,7 @@ EXPORT_SYMBOL(iwl_rf_kill_ct_config);
  * When in the 'halt' state, the card is shut down and must be fully
  * restarted to come back on.
  */
-static int iwl_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_flag)
+int iwl_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_flag)
 {
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_CARD_STATE_CMD,
@@ -1381,6 +1381,7 @@ static int iwl_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_flag)
 
 	return iwl_send_cmd(priv, &cmd);
 }
+EXPORT_SYMBOL(iwl_send_card_state);
 
 void iwl_radio_kill_sw_disable_radio(struct iwl_priv *priv)
 {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 7c3a20a..2abda89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -342,6 +342,9 @@ int iwl_send_cmd_pdu_async(struct iwl_priv *priv, u8 id, u16 len,
 
 int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
 
+int iwl_send_card_state(struct iwl_priv *priv, u32 flags,
+			u8 meta_flag);
+
 /*****************************************************
  * PCI						     *
  *****************************************************/
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 408a6d0..7cace6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1078,38 +1078,6 @@ static int iwl3945_send_scan_abort(struct iwl_priv *priv)
 	return rc;
 }
 
-static int iwl3945_card_state_sync_callback(struct iwl_priv *priv,
-					struct iwl_cmd *cmd,
-					struct sk_buff *skb)
-{
-	return 1;
-}
-
-/*
- * CARD_STATE_CMD
- *
- * Use: Sets the device's internal card state to enable, disable, or halt
- *
- * When in the 'enable' state the card operates as normal.
- * When in the 'disable' state, the card enters into a low power mode.
- * When in the 'halt' state, the card is shut down and must be fully
- * restarted to come back on.
- */
-static int iwl3945_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_flag)
-{
-	struct iwl_host_cmd cmd = {
-		.id = REPLY_CARD_STATE_CMD,
-		.len = sizeof(u32),
-		.data = &flags,
-		.meta.flags = meta_flag,
-	};
-
-	if (meta_flag & CMD_ASYNC)
-		cmd.meta.u.callback = iwl3945_card_state_sync_callback;
-
-	return iwl3945_send_cmd(priv, &cmd);
-}
-
 static int iwl3945_add_sta_sync_callback(struct iwl_priv *priv,
 				     struct iwl_cmd *cmd, struct sk_buff *skb)
 {
@@ -2548,7 +2516,7 @@ static void iwl3945_radio_kill_sw(struct iwl_priv *priv, int disable_radio)
 			iwl_write32(priv, CSR_UCODE_DRV_GP1_SET,
 				    CSR_UCODE_SW_BIT_RFKILL);
 			spin_unlock_irqrestore(&priv->lock, flags);
-			iwl3945_send_card_state(priv, CARD_STATE_CMD_DISABLE, 0);
+			iwl_send_card_state(priv, CARD_STATE_CMD_DISABLE, 0);
 			set_bit(STATUS_RF_KILL_SW, &priv->status);
 		}
 		return;
-- 
1.5.3.6

