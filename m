Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56034 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933275AbcISHcj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:32:39 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:24 +0300
Message-Id: <20160919073028.22065-21-luca@coelho.fi> (sfid-20160919_093242_231803_B43AA362)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 21/25] iwlwifi: mvm: move AP-specific code to right function
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need for the common MAC context function to have an
if on AP mode, the values can be overridden in the AP-specific
function later. Clean that up by adding the full command as a
new parameter to the AP-specific function, and doing it there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 42 +++++++++++------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index d742d27..6b962d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -774,26 +774,6 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 		cmd->ac[txf].fifos_mask = BIT(txf);
 	}
 
-	if (vif->type == NL80211_IFTYPE_AP) {
-		/* in AP mode, the MCAST FIFO takes the EDCA params from VO */
-		cmd->ac[IWL_MVM_TX_FIFO_VO].fifos_mask |=
-			BIT(IWL_MVM_TX_FIFO_MCAST);
-
-		/*
-		 * in AP mode, pass probe requests and beacons from other APs
-		 * (needed for ht protection); when there're no any associated
-		 * station don't ask FW to pass beacons to prevent unnecessary
-		 * wake-ups.
-		 */
-		cmd->filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST);
-		if (mvmvif->ap_assoc_sta_count || !mvm->drop_bcn_ap_mode) {
-			cmd->filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
-			IWL_DEBUG_HC(mvm, "Asking FW to pass beacons\n");
-		} else {
-			IWL_DEBUG_HC(mvm, "No need to receive beacons\n");
-		}
-	}
-
 	if (vif->bss_conf.qos)
 		cmd->qos_flags |= cpu_to_le32(MAC_QOS_FLG_UPDATE_EDCA);
 
@@ -1191,6 +1171,7 @@ static void iwl_mvm_mac_ap_iterator(void *_data, u8 *mac,
  */
 static void iwl_mvm_mac_ctxt_cmd_fill_ap(struct iwl_mvm *mvm,
 					 struct ieee80211_vif *vif,
+					 struct iwl_mac_ctx_cmd *cmd,
 					 struct iwl_mac_data_ap *ctxt_ap,
 					 bool add)
 {
@@ -1201,6 +1182,23 @@ static void iwl_mvm_mac_ctxt_cmd_fill_ap(struct iwl_mvm *mvm,
 		.beacon_device_ts = 0
 	};
 
+	/* in AP mode, the MCAST FIFO takes the EDCA params from VO */
+	cmd->ac[IWL_MVM_TX_FIFO_VO].fifos_mask |= BIT(IWL_MVM_TX_FIFO_MCAST);
+
+	/*
+	 * in AP mode, pass probe requests and beacons from other APs
+	 * (needed for ht protection); when there're no any associated
+	 * station don't ask FW to pass beacons to prevent unnecessary
+	 * wake-ups.
+	 */
+	cmd->filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST);
+	if (mvmvif->ap_assoc_sta_count || !mvm->drop_bcn_ap_mode) {
+		cmd->filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
+		IWL_DEBUG_HC(mvm, "Asking FW to pass beacons\n");
+	} else {
+		IWL_DEBUG_HC(mvm, "No need to receive beacons\n");
+	}
+
 	ctxt_ap->bi = cpu_to_le32(vif->bss_conf.beacon_int);
 	ctxt_ap->bi_reciprocal =
 		cpu_to_le32(iwl_mvm_reciprocal(vif->bss_conf.beacon_int));
@@ -1258,7 +1256,7 @@ static int iwl_mvm_mac_ctxt_cmd_ap(struct iwl_mvm *mvm,
 	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, NULL, action);
 
 	/* Fill the data specific for ap mode */
-	iwl_mvm_mac_ctxt_cmd_fill_ap(mvm, vif, &cmd.ap,
+	iwl_mvm_mac_ctxt_cmd_fill_ap(mvm, vif, &cmd, &cmd.ap,
 				     action == FW_CTXT_ACTION_ADD);
 
 	return iwl_mvm_mac_ctxt_send_cmd(mvm, &cmd);
@@ -1277,7 +1275,7 @@ static int iwl_mvm_mac_ctxt_cmd_go(struct iwl_mvm *mvm,
 	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, NULL, action);
 
 	/* Fill the data specific for GO mode */
-	iwl_mvm_mac_ctxt_cmd_fill_ap(mvm, vif, &cmd.go.ap,
+	iwl_mvm_mac_ctxt_cmd_fill_ap(mvm, vif, &cmd, &cmd.go.ap,
 				     action == FW_CTXT_ACTION_ADD);
 
 	cmd.go.ctwin = cpu_to_le32(noa->oppps_ctwindow &
-- 
2.9.3
