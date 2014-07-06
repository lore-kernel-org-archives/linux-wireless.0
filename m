Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:57271 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaGFJgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:40 -0400
Received: by mail-we0-f172.google.com with SMTP id u57so3175109wes.31
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:39 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/40] iwlwifi: mvm: BT Coex - convert the sw boost update to new API
Date: Sun,  6 Jul 2014 12:35:48 +0300
Message-Id: <1404639376-3792-12-git-send-email-egrumbach@gmail.com> (sfid-20140706_115952_211723_54B4B115)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

No need to send the big BT_COEX_CMD command, we have now
a much thiner command that updates only what is needed.
Adapt the code to that, and open the patch to the updates.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c | 58 +++++++++------------------------
 1 file changed, 16 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 23f639a..3854330 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -609,19 +609,12 @@ send_cmd:
 	return ret;
 }
 
-static int iwl_mvm_bt_udpate_ctrl_kill_msk(struct iwl_mvm *mvm,
-					   bool reduced_tx_power)
+static int iwl_mvm_bt_udpate_sw_boost(struct iwl_mvm *mvm,
+				      bool reduced_tx_power)
 {
 	enum iwl_bt_kill_msk bt_kill_msk;
-	struct iwl_bt_coex_cmd_old *bt_cmd;
+	struct iwl_bt_coex_sw_boost_update_cmd cmd = {};
 	struct iwl_bt_coex_profile_notif *notif = &mvm->last_bt_notif;
-	struct iwl_host_cmd cmd = {
-		.id = BT_CONFIG,
-		.data[0] = &bt_cmd,
-		.len = { sizeof(*bt_cmd), },
-		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-	};
-	int ret = 0;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -651,26 +644,22 @@ static int iwl_mvm_bt_udpate_ctrl_kill_msk(struct iwl_mvm *mvm,
 
 	mvm->bt_kill_msk = bt_kill_msk;
 
-	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
-	if (!bt_cmd)
-		return -ENOMEM;
-	cmd.data[0] = bt_cmd;
-	bt_cmd->flags = cpu_to_le32(BT_COEX_NW_OLD);
+	cmd.boost_values[0].kill_ack_msk =
+		cpu_to_le32(iwl_bt_ack_kill_msk[bt_kill_msk]);
+	cmd.boost_values[0].kill_cts_msk =
+		cpu_to_le32(iwl_bt_cts_kill_msk[bt_kill_msk]);
 
-	bt_cmd->kill_ack_msk = cpu_to_le32(iwl_bt_ack_kill_msk[bt_kill_msk]);
-	bt_cmd->kill_cts_msk = cpu_to_le32(iwl_bt_cts_kill_msk[bt_kill_msk]);
-	bt_cmd->valid_bit_msk |= cpu_to_le32(BT_VALID_ENABLE |
-					     BT_VALID_KILL_ACK |
-					     BT_VALID_KILL_CTS);
+	cmd.boost_values[1].kill_ack_msk = cmd.boost_values[0].kill_ack_msk;
+	cmd.boost_values[2].kill_cts_msk = cmd.boost_values[0].kill_cts_msk;
+	cmd.boost_values[1].kill_ack_msk = cmd.boost_values[0].kill_ack_msk;
+	cmd.boost_values[2].kill_cts_msk = cmd.boost_values[0].kill_cts_msk;
 
 	IWL_DEBUG_COEX(mvm, "ACK Kill msk = 0x%08x, CTS Kill msk = 0x%08x\n",
 		       iwl_bt_ack_kill_msk[bt_kill_msk],
 		       iwl_bt_cts_kill_msk[bt_kill_msk]);
 
-	ret = iwl_mvm_send_cmd(mvm, &cmd);
-
-	kfree(bt_cmd);
-	return ret;
+	return iwl_mvm_send_cmd_pdu(mvm, BT_COEX_UPDATE_SW_BOOST, 0,
+				    sizeof(cmd), &cmd);
 }
 
 static int iwl_mvm_bt_coex_reduced_txp(struct iwl_mvm *mvm, u8 sta_id,
@@ -986,7 +975,7 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 	 */
 	data.reduced_tx_power = data.reduced_tx_power && data.num_bss_ifaces;
 
-	if (iwl_mvm_bt_udpate_ctrl_kill_msk(mvm, data.reduced_tx_power))
+	if (iwl_mvm_bt_udpate_sw_boost(mvm, data.reduced_tx_power))
 		IWL_ERR(mvm, "Failed to update the ctrl_kill_msk\n");
 }
 
@@ -995,14 +984,11 @@ int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
 			     struct iwl_device_cmd *dev_cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_bt_coex_profile_notif_old *notif = (void *)pkt->data;
+	struct iwl_bt_coex_profile_notif *notif = (void *)pkt->data;
 
 	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_mvm_rx_bt_coex_notif_old(mvm, rxb, dev_cmd);
 
-	/* TODO */
-	return 0;
-
 	IWL_DEBUG_COEX(mvm, "BT Coex Notification received\n");
 	IWL_DEBUG_COEX(mvm, "\tBT ci compliance %d\n", notif->bt_ci_compliance);
 	IWL_DEBUG_COEX(mvm, "\tBT primary_ch_lut %d\n",
@@ -1085,9 +1071,6 @@ void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return;
 	}
 
-	/* TODO */
-	return;
-
 	lockdep_assert_held(&mvm->mutex);
 
 	/* Ignore updates if we are in force mode */
@@ -1133,7 +1116,7 @@ void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	 */
 	data.reduced_tx_power = data.reduced_tx_power && data.num_bss_ifaces;
 
-	if (iwl_mvm_bt_udpate_ctrl_kill_msk(mvm, data.reduced_tx_power))
+	if (iwl_mvm_bt_udpate_sw_boost(mvm, data.reduced_tx_power))
 		IWL_ERR(mvm, "Failed to update the ctrl_kill_msk\n");
 }
 
@@ -1149,9 +1132,6 @@ u16 iwl_mvm_coex_agg_time_limit(struct iwl_mvm *mvm,
 	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_mvm_coex_agg_time_limit_old(mvm, sta);
 
-	/* TODO */
-	return LINK_QUAL_AGG_TIME_LIMIT_DEF;
-
 	if (le32_to_cpu(mvm->last_bt_notif.bt_activity_grading) <
 	    BT_HIGH_TRAFFIC)
 		return LINK_QUAL_AGG_TIME_LIMIT_DEF;
@@ -1213,9 +1193,6 @@ bool iwl_mvm_bt_coex_is_tpc_allowed(struct iwl_mvm *mvm,
 	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_mvm_bt_coex_is_tpc_allowed_old(mvm, band);
 
-	/* TODO */
-	return false;
-
 	if (band != IEEE80211_BAND_2GHZ)
 		return false;
 
@@ -1261,9 +1238,6 @@ void iwl_mvm_bt_coex_vif_change(struct iwl_mvm *mvm)
 		return;
 	}
 
-	/* TODO */
-	return;
-
 	iwl_mvm_bt_coex_notif_handle(mvm);
 }
 
-- 
1.8.3.2

