Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33074 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaGFJgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:36:41 -0400
Received: by mail-wi0-f171.google.com with SMTP id n15so14608391wiw.4
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:36:40 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/40] iwlwifi: mvm: BT Coex - convert the co-running update to new API
Date: Sun,  6 Jul 2014 12:35:49 +0300
Message-Id: <1404639376-3792-13-git-send-email-egrumbach@gmail.com> (sfid-20140706_115954_878872_FA3ED51B)
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
 drivers/net/wireless/iwlwifi/mvm/coex.c | 36 +++++++--------------------------
 1 file changed, 7 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index 3854330..216357a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -1247,23 +1247,13 @@ int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u32 ant_isolation = le32_to_cpup((void *)pkt->data);
+	struct iwl_bt_coex_corun_lut_update_cmd cmd = {};
 	u8 __maybe_unused lower_bound, upper_bound;
-	int ret;
 	u8 lut;
 
-	struct iwl_bt_coex_cmd_old *bt_cmd;
-	struct iwl_host_cmd cmd = {
-		.id = BT_CONFIG,
-		.len = { sizeof(*bt_cmd), },
-		.dataflags = { IWL_HCMD_DFL_NOCOPY, },
-	};
-
 	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_BT_COEX_SPLIT))
 		return iwl_mvm_rx_ant_coupling_notif_old(mvm, rxb, dev_cmd);
 
-	/* TODO */
-	return 0;
-
 	if (!IWL_MVM_BT_COEX_CORUNNING)
 		return 0;
 
@@ -1297,25 +1287,13 @@ int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
 
 	mvm->last_corun_lut = lut;
 
-	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
-	if (!bt_cmd)
-		return 0;
-	cmd.data[0] = bt_cmd;
-
-	bt_cmd->flags = cpu_to_le32(BT_COEX_NW_OLD);
-	bt_cmd->valid_bit_msk |= cpu_to_le32(BT_VALID_ENABLE |
-					     BT_VALID_CORUN_LUT_20 |
-					     BT_VALID_CORUN_LUT_40);
-
 	/* For the moment, use the same LUT for 20GHz and 40GHz */
-	memcpy(bt_cmd->bt4_corun_lut20, antenna_coupling_ranges[lut].lut20,
-	       sizeof(bt_cmd->bt4_corun_lut20));
+	memcpy(&cmd.corun_lut20, antenna_coupling_ranges[lut].lut20,
+	       sizeof(cmd.corun_lut20));
 
-	memcpy(bt_cmd->bt4_corun_lut40, antenna_coupling_ranges[lut].lut20,
-	       sizeof(bt_cmd->bt4_corun_lut40));
+	memcpy(&cmd.corun_lut40, antenna_coupling_ranges[lut].lut20,
+	       sizeof(cmd.corun_lut40));
 
-	ret = iwl_mvm_send_cmd(mvm, &cmd);
-
-	kfree(bt_cmd);
-	return ret;
+	return iwl_mvm_send_cmd_pdu(mvm, BT_COEX_UPDATE_CORUN_LUT, 0,
+				    sizeof(cmd), &cmd);
 }
-- 
1.8.3.2

