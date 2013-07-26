Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58130 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930Ab3GZI3k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:29:40 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/30] iwlwifi: mvm: don't allocate BT_COEX cmd on stack
Date: Fri, 26 Jul 2013 10:28:27 +0200
Message-Id: <1374827327-3464-11-git-send-email-johannes@sipsolutions.net> (sfid-20130726_103016_957790_D2942663)
In-Reply-To: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
References: <1374827327-3464-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This command will change and be much bigger.
Prepare to that by stop allocating on the stack.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c | 138 +++++++++++++++++++----------
 1 file changed, 92 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
index 3a48cd9..0fad98b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -220,66 +220,87 @@ static const __le32 iwl_single_shared_ant_lookup[BT_COEX_LUT_SIZE] = {
 
 int iwl_send_bt_init_conf(struct iwl_mvm *mvm)
 {
-	struct iwl_bt_coex_cmd cmd = {
-		.max_kill = 5,
-		.bt3_time_t7_value = 1,
-		.bt3_prio_sample_time = 2,
-		.bt3_timer_t2_value = 0xc,
+	struct iwl_bt_coex_cmd *bt_cmd;
+	struct iwl_host_cmd cmd = {
+		.id = BT_CONFIG,
+		.len = { sizeof(*bt_cmd), },
+		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
+		.flags = CMD_SYNC,
 	};
 	int ret;
 
-	cmd.flags = iwlwifi_mod_params.bt_coex_active ?
+	/* go to CALIB state in internal BT-Coex state machine */
+	ret = iwl_send_bt_env(mvm, BT_COEX_ENV_OPEN,
+			      BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
+	if (ret)
+		return ret;
+
+	ret  = iwl_send_bt_env(mvm, BT_COEX_ENV_CLOSE,
+			       BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
+	if (ret)
+		return ret;
+
+	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
+	if (!bt_cmd)
+		return -ENOMEM;
+	cmd.data[0] = bt_cmd;
+
+	bt_cmd->max_kill = 5;
+	bt_cmd->bt3_time_t7_value = 1;
+	bt_cmd->bt3_prio_sample_time = 2;
+	bt_cmd->bt3_timer_t2_value = 0xc;
+
+	bt_cmd->flags = iwlwifi_mod_params.bt_coex_active ?
 			BT_COEX_NW : BT_COEX_DISABLE;
-	cmd.flags |= BT_CH_PRIMARY_EN | BT_SYNC_2_BT_DISABLE;
+	bt_cmd->flags |= BT_CH_PRIMARY_EN | BT_SYNC_2_BT_DISABLE;
 
-	cmd.valid_bit_msk = cpu_to_le16(BT_VALID_ENABLE |
-					BT_VALID_BT_PRIO_BOOST |
-					BT_VALID_MAX_KILL |
-					BT_VALID_3W_TMRS |
-					BT_VALID_KILL_ACK |
-					BT_VALID_KILL_CTS |
-					BT_VALID_REDUCED_TX_POWER |
-					BT_VALID_LUT);
+	bt_cmd->valid_bit_msk = cpu_to_le16(BT_VALID_ENABLE |
+					    BT_VALID_BT_PRIO_BOOST |
+					    BT_VALID_MAX_KILL |
+					    BT_VALID_3W_TMRS |
+					    BT_VALID_KILL_ACK |
+					    BT_VALID_KILL_CTS |
+					    BT_VALID_REDUCED_TX_POWER |
+					    BT_VALID_LUT);
 
 	if (mvm->cfg->bt_shared_single_ant)
-		memcpy(&cmd.decision_lut, iwl_single_shared_ant_lookup,
+		memcpy(&bt_cmd->decision_lut, iwl_single_shared_ant_lookup,
 		       sizeof(iwl_single_shared_ant_lookup));
 	else if (is_loose_coex())
-		memcpy(&cmd.decision_lut, iwl_loose_lookup,
+		memcpy(&bt_cmd->decision_lut, iwl_loose_lookup,
 		       sizeof(iwl_tight_lookup));
 	else
-		memcpy(&cmd.decision_lut, iwl_tight_lookup,
+		memcpy(&bt_cmd->decision_lut, iwl_tight_lookup,
 		       sizeof(iwl_tight_lookup));
 
-	cmd.bt_prio_boost = cpu_to_le32(IWL_BT_DEFAULT_BOOST);
-	cmd.kill_ack_msk =
+	bt_cmd->bt_prio_boost = cpu_to_le32(IWL_BT_DEFAULT_BOOST);
+	bt_cmd->kill_ack_msk =
 		cpu_to_le32(iwl_bt_ack_kill_msk[BT_KILL_MSK_DEFAULT]);
-	cmd.kill_cts_msk =
+	bt_cmd->kill_cts_msk =
 		cpu_to_le32(iwl_bt_cts_kill_msk[BT_KILL_MSK_DEFAULT]);
 
 	memset(&mvm->last_bt_notif, 0, sizeof(mvm->last_bt_notif));
 
-	/* go to CALIB state in internal BT-Coex state machine */
-	ret = iwl_send_bt_env(mvm, BT_COEX_ENV_OPEN,
-			      BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
-	if (ret)
-		return ret;
-
-	ret  = iwl_send_bt_env(mvm, BT_COEX_ENV_CLOSE,
-			       BT_COEX_PRIO_TBL_EVT_INIT_CALIB2);
-	if (ret)
-		return ret;
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
 
-	return iwl_mvm_send_cmd_pdu(mvm, BT_CONFIG, CMD_SYNC,
-				    sizeof(cmd), &cmd);
+	kfree(bt_cmd);
+	return ret;
 }
 
 static int iwl_mvm_bt_udpate_ctrl_kill_msk(struct iwl_mvm *mvm,
 					   bool reduced_tx_power)
 {
 	enum iwl_bt_kill_msk bt_kill_msk;
-	struct iwl_bt_coex_cmd cmd = {};
+	struct iwl_bt_coex_cmd *bt_cmd;
 	struct iwl_bt_coex_profile_notif *notif = &mvm->last_bt_notif;
+	struct iwl_host_cmd cmd = {
+		.id = BT_CONFIG,
+		.data[0] = &bt_cmd,
+		.len = { sizeof(*bt_cmd), },
+		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
+		.flags = CMD_SYNC,
+	};
+	int ret = 0;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -308,24 +329,40 @@ static int iwl_mvm_bt_udpate_ctrl_kill_msk(struct iwl_mvm *mvm,
 		return 0;
 
 	mvm->bt_kill_msk = bt_kill_msk;
-	cmd.kill_ack_msk = cpu_to_le32(iwl_bt_ack_kill_msk[bt_kill_msk]);
-	cmd.kill_cts_msk = cpu_to_le32(iwl_bt_cts_kill_msk[bt_kill_msk]);
-	cmd.valid_bit_msk = cpu_to_le16(BT_VALID_KILL_ACK | BT_VALID_KILL_CTS);
+
+	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
+	if (!bt_cmd)
+		return -ENOMEM;
+	cmd.data[0] = bt_cmd;
+
+	bt_cmd->kill_ack_msk = cpu_to_le32(iwl_bt_ack_kill_msk[bt_kill_msk]);
+	bt_cmd->kill_cts_msk = cpu_to_le32(iwl_bt_cts_kill_msk[bt_kill_msk]);
+	bt_cmd->valid_bit_msk =
+		cpu_to_le16(BT_VALID_KILL_ACK | BT_VALID_KILL_CTS);
 
 	IWL_DEBUG_COEX(mvm, "bt_kill_msk = %d\n", bt_kill_msk);
-	return iwl_mvm_send_cmd_pdu(mvm, BT_CONFIG, CMD_SYNC,
-				    sizeof(cmd), &cmd);
+
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+
+	kfree(bt_cmd);
+	return ret;
 }
 
 static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 				       bool enable)
 {
-	struct iwl_bt_coex_cmd cmd = {
-		.valid_bit_msk = cpu_to_le16(BT_VALID_REDUCED_TX_POWER),
-		.bt_reduced_tx_power = sta_id,
+	struct iwl_bt_coex_cmd *bt_cmd;
+	/* Send ASYNC since this can be sent from an atomic context */
+	struct iwl_host_cmd cmd = {
+		.id = BT_CONFIG,
+		.len = { sizeof(*bt_cmd), },
+		.dataflags = { IWL_HCMD_DFL_DUP, },
+		.flags = CMD_ASYNC,
 	};
+
 	struct ieee80211_sta *sta;
 	struct iwl_mvm_sta *mvmsta;
+	int ret;
 
 	/* This can happen if the station has been removed right now */
 	if (sta_id == IWL_MVM_STATION_COUNT)
@@ -339,17 +376,26 @@ static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
 	if (mvmsta->bt_reduced_txpower == enable)
 		return 0;
 
+	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_ATOMIC);
+	if (!bt_cmd)
+		return -ENOMEM;
+	cmd.data[0] = bt_cmd;
+
+	bt_cmd->valid_bit_msk = cpu_to_le16(BT_VALID_REDUCED_TX_POWER),
+	bt_cmd->bt_reduced_tx_power = sta_id;
+
 	if (enable)
-		cmd.bt_reduced_tx_power |= BT_REDUCED_TX_POWER_BIT;
+		bt_cmd->bt_reduced_tx_power |= BT_REDUCED_TX_POWER_BIT;
 
 	IWL_DEBUG_COEX(mvm, "%sable reduced Tx Power for sta %d\n",
 		       enable ? "en" : "dis", sta_id);
 
 	mvmsta->bt_reduced_txpower = enable;
 
-	/* Send ASYNC since this can be sent from an atomic context */
-	return iwl_mvm_send_cmd_pdu(mvm, BT_CONFIG, CMD_ASYNC,
-				    sizeof(cmd), &cmd);
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+
+	kfree(bt_cmd);
+	return ret;
 }
 
 struct iwl_bt_iterator_data {
-- 
1.8.0

