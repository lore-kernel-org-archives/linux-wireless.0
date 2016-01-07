Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:39244 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbcAGMsE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:48:04 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ayala Beker <ayala.beker@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/21] iwlwifi: mvm: don't ask beacons when P2P GO vif and no assoc sta
Date: Thu,  7 Jan 2016 14:47:35 +0200
Message-Id: <1452170861-10060-15-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_140653_108685_DC8B9C0B)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

The commit below called iwl_mvm_mac_ctxt_changed() to handle
a case that the vif is a P2P GO.
However iwl_mvm_mac_ctxt_cmd_go() ignores the number of
associated stations and asks the FW to pass beacons anyways.

Fix this by checking ap_assoc_sta_count parameter, in iwl_mvm_mac_ctxt_cmd_go()
as well, and ask the FW to pass beacons only when there's
at least one associated station.

Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 44 ++++++++++-------------
 1 file changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 448b9c9..bf1e5eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -717,6 +717,8 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 		cpu_to_le32(vif->bss_conf.use_short_slot ?
 			    MAC_FLG_SHORT_SLOT : 0);
 
+	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP);
+
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		u8 txf = iwl_mvm_ac_to_tx_fifo[i];
 
@@ -730,11 +732,26 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 		cmd->ac[txf].fifos_mask = BIT(txf);
 	}
 
-	/* in AP mode, the MCAST FIFO takes the EDCA params from VO */
-	if (vif->type == NL80211_IFTYPE_AP)
+	if (vif->type == NL80211_IFTYPE_AP) {
+		/* in AP mode, the MCAST FIFO takes the EDCA params from VO */
 		cmd->ac[IWL_MVM_TX_FIFO_VO].fifos_mask |=
 			BIT(IWL_MVM_TX_FIFO_MCAST);
 
+		/*
+		 * in AP mode, pass probe requests and beacons from other APs
+		 * (needed for ht protection); when there're no any associated
+		 * station don't ask FW to pass beacons to prevent unnecessary
+		 * wake-ups.
+		 */
+		cmd->filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST);
+		if (mvmvif->ap_assoc_sta_count) {
+			cmd->filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
+			IWL_DEBUG_HC(mvm, "Asking FW to pass beacons\n");
+		} else {
+			IWL_DEBUG_HC(mvm, "No need to receive beacons\n");
+		}
+	}
+
 	if (vif->bss_conf.qos)
 		cmd->qos_flags |= cpu_to_le32(MAC_QOS_FLG_UPDATE_EDCA);
 
@@ -748,8 +765,6 @@ static void iwl_mvm_mac_ctxt_cmd_common(struct iwl_mvm *mvm,
 		cmd->qos_flags |= cpu_to_le32(MAC_QOS_FLG_TGN);
 	if (ht_enabled)
 		iwl_mvm_mac_ctxt_set_ht_flags(mvm, vif, cmd);
-
-	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP);
 }
 
 static int iwl_mvm_mac_ctxt_send_cmd(struct iwl_mvm *mvm,
@@ -1156,7 +1171,6 @@ static int iwl_mvm_mac_ctxt_cmd_ap(struct iwl_mvm *mvm,
 				   struct ieee80211_vif *vif,
 				   u32 action)
 {
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mac_ctx_cmd cmd = {};
 
 	WARN_ON(vif->type != NL80211_IFTYPE_AP || vif->p2p);
@@ -1164,19 +1178,6 @@ static int iwl_mvm_mac_ctxt_cmd_ap(struct iwl_mvm *mvm,
 	/* Fill the common data for all mac context types */
 	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, NULL, action);
 
-	/*
-	 * pass probe requests and beacons from other APs (needed
-	 * for ht protection); when there're no any associated station
-	 * don't ask FW to pass beacons to prevent unnecessary wake-ups.
-	 */
-	cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST);
-	if (mvmvif->ap_assoc_sta_count) {
-		cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_BEACON);
-		IWL_DEBUG_HC(mvm, "Asking FW to pass beacons\n");
-	} else {
-		IWL_DEBUG_HC(mvm, "No need to receive beacons\n");
-	}
-
 	/* Fill the data specific for ap mode */
 	iwl_mvm_mac_ctxt_cmd_fill_ap(mvm, vif, &cmd.ap,
 				     action == FW_CTXT_ACTION_ADD);
@@ -1196,13 +1197,6 @@ static int iwl_mvm_mac_ctxt_cmd_go(struct iwl_mvm *mvm,
 	/* Fill the common data for all mac context types */
 	iwl_mvm_mac_ctxt_cmd_common(mvm, vif, &cmd, NULL, action);
 
-	/*
-	 * pass probe requests and beacons from other APs (needed
-	 * for ht protection)
-	 */
-	cmd.filter_flags |= cpu_to_le32(MAC_FILTER_IN_PROBE_REQUEST |
-					MAC_FILTER_IN_BEACON);
-
 	/* Fill the data specific for GO mode */
 	iwl_mvm_mac_ctxt_cmd_fill_ap(mvm, vif, &cmd.go.ap,
 				     action == FW_CTXT_ACTION_ADD);
-- 
2.5.0

