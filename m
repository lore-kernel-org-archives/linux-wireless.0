Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:43624 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaGFJgn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:43 -0400
Received: by mail-wi0-f175.google.com with SMTP id r20so14466423wiv.14
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:42 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/40] iwlwifi: mvm: BT Coex - convert reduced Tx power to new API
Date: Sun,  6 Jul 2014 12:35:50 +0300
Message-Id: <1404639376-3792-14-git-send-email-egrumbach@gmail.com> (sfid-20140706_115954_731665_1600C3FD)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

No need to send the big BT_COEX_CMD command, we have now
a much thiner command that updates only what is needed.
Adapt the code to that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 216357a..95b86cf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -665,19 +665,11 @@ static int iwl_mvm_bt_udpate_sw_boost(struct iwl_mvm *mvm,
 static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 				       bool enable)
 {
-	struct iwl_bt_coex_cmd_old *bt_cmd;
-	/* Send ASYNC since this can be sent from an atomic context */
-	struct iwl_host_cmd cmd = {
-		.id = BT_CONFIG,
-		.len = { sizeof(*bt_cmd), },
-		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-		.flags = CMD_ASYNC,
-	};
+	struct iwl_bt_coex_reduced_txp_update_cmd cmd = {};
 	struct iwl_mvm_sta *mvmsta;
+	u32 value;
 	int ret;
 
-	return 0;
-
 	mvmsta = iwl_mvm_sta_from_staid_protected(mvm, sta_id);
 	if (!mvmsta)
 		return 0;
@@ -686,27 +678,20 @@ static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 	if (mvmsta->bt_reduced_txpower == enable)
 		return 0;
 
-	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_ATOMIC);
-	if (!bt_cmd)
-		return -ENOMEM;
-	cmd.data[0] = bt_cmd;
-	bt_cmd->flags = cpu_to_le32(BT_COEX_NW_OLD);
-
-	bt_cmd->valid_bit_msk =
-		cpu_to_le32(BT_VALID_ENABLE | BT_VALID_REDUCED_TX_POWER);
-	bt_cmd->bt_reduced_tx_power = sta_id;
+	value = mvmsta->sta_id;
 
 	if (enable)
-		bt_cmd->bt_reduced_tx_power |= BT_REDUCED_TX_POWER_BIT;
+		value |= BT_REDUCED_TX_POWER_BIT;
 
 	IWL_DEBUG_COEX(mvm, "%sable reduced Tx Power for sta %d\n",
 		       enable ? "en" : "dis", sta_id);
 
+	cmd.reduced_txp = cpu_to_le32(value);
 	mvmsta->bt_reduced_txpower = enable;
 
-	ret = iwl_mvm_send_cmd(mvm, &cmd);
+	ret = iwl_mvm_send_cmd_pdu(mvm, BT_COEX_UPDATE_REDUCED_TXP, CMD_ASYNC,
+				   sizeof(cmd), &cmd);
 
-	kfree(bt_cmd);
 	return ret;
 }
 
-- 
1.8.3.2

