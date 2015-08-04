Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754704AbbHDU7B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:01 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 11/37] iwlwifi: mvm: remove command/return value from RX handlers
Date: Tue,  4 Aug 2015 23:43:01 +0300
Message-Id: <1438721007-23283-11-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230050_757087_67F8799E)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the mvm driver, neither the old command nor the return value
are used, so remove them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/coex.c        |  44 +++++-----
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c |  31 +++----
 drivers/net/wireless/iwlwifi/mvm/fw.c          |  13 +--
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c    |  13 +--
 drivers/net/wireless/iwlwifi/mvm/mvm.h         | 107 ++++++++++---------------
 drivers/net/wireless/iwlwifi/mvm/nvm.c         |  11 +--
 drivers/net/wireless/iwlwifi/mvm/ops.c         |  22 ++---
 drivers/net/wireless/iwlwifi/mvm/power.c       |   7 +-
 drivers/net/wireless/iwlwifi/mvm/rx.c          |  20 ++---
 drivers/net/wireless/iwlwifi/mvm/scan.c        |  35 +++-----
 drivers/net/wireless/iwlwifi/mvm/sta.c         |   9 +--
 drivers/net/wireless/iwlwifi/mvm/sta.h         |   5 +-
 drivers/net/wireless/iwlwifi/mvm/tdls.c        |  12 +--
 drivers/net/wireless/iwlwifi/mvm/time-event.c  |   7 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.h  |   5 +-
 drivers/net/wireless/iwlwifi/mvm/tt.c          |  10 +--
 drivers/net/wireless/iwlwifi/mvm/tx.c          |  16 ++--
 drivers/net/wireless/iwlwifi/mvm/utils.c       |   4 +-
 18 files changed, 139 insertions(+), 232 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/coex.c b/drivers/net/wireless/iwlwifi/mvm/coex.c
index b4737e2..e290ac6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex.c
@@ -725,15 +725,17 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 	}
 }
 
-int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
-			     struct iwl_rx_cmd_buffer *rxb,
-			     struct iwl_device_cmd *dev_cmd)
+void iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
+			      struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_bt_coex_profile_notif *notif = (void *)pkt->data;
 
-	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_BT_COEX_SPLIT))
-		return iwl_mvm_rx_bt_coex_notif_old(mvm, rxb, dev_cmd);
+	if (!fw_has_api(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_API_BT_COEX_SPLIT)) {
+		iwl_mvm_rx_bt_coex_notif_old(mvm, rxb);
+		return;
+	}
 
 	IWL_DEBUG_COEX(mvm, "BT Coex Notification received\n");
 	IWL_DEBUG_COEX(mvm, "\tBT ci compliance %d\n", notif->bt_ci_compliance);
@@ -748,12 +750,6 @@ int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
 	memcpy(&mvm->last_bt_notif, notif, sizeof(mvm->last_bt_notif));
 
 	iwl_mvm_bt_coex_notif_handle(mvm);
-
-	/*
-	 * This is an async handler for a notification, returning anything other
-	 * than 0 doesn't make sense even if HCMD failed.
-	 */
-	return 0;
 }
 
 void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
@@ -947,9 +943,8 @@ void iwl_mvm_bt_coex_vif_change(struct iwl_mvm *mvm)
 	iwl_mvm_bt_coex_notif_handle(mvm);
 }
 
-int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
-				  struct iwl_rx_cmd_buffer *rxb,
-				  struct iwl_device_cmd *dev_cmd)
+void iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
+				   struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u32 ant_isolation = le32_to_cpup((void *)pkt->data);
@@ -957,20 +952,23 @@ int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
 	u8 __maybe_unused lower_bound, upper_bound;
 	u8 lut;
 
-	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_BT_COEX_SPLIT))
-		return iwl_mvm_rx_ant_coupling_notif_old(mvm, rxb, dev_cmd);
+	if (!fw_has_api(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_API_BT_COEX_SPLIT)) {
+		iwl_mvm_rx_ant_coupling_notif_old(mvm, rxb);
+		return;
+	}
 
 	if (!iwl_mvm_bt_is_plcr_supported(mvm))
-		return 0;
+		return;
 
 	lockdep_assert_held(&mvm->mutex);
 
 	/* Ignore updates if we are in force mode */
 	if (unlikely(mvm->bt_force_ant_mode != BT_FORCE_ANT_DIS))
-		return 0;
+		return;
 
 	if (ant_isolation ==  mvm->last_ant_isol)
-		return 0;
+		return;
 
 	for (lut = 0; lut < ARRAY_SIZE(antenna_coupling_ranges) - 1; lut++)
 		if (ant_isolation < antenna_coupling_ranges[lut + 1].range)
@@ -989,7 +987,7 @@ int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
 	mvm->last_ant_isol = ant_isolation;
 
 	if (mvm->last_corun_lut == lut)
-		return 0;
+		return;
 
 	mvm->last_corun_lut = lut;
 
@@ -1000,6 +998,8 @@ int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
 	memcpy(&cmd.corun_lut40, antenna_coupling_ranges[lut].lut20,
 	       sizeof(cmd.corun_lut40));
 
-	return iwl_mvm_send_cmd_pdu(mvm, BT_COEX_UPDATE_CORUN_LUT, 0,
-				    sizeof(cmd), &cmd);
+	if (iwl_mvm_send_cmd_pdu(mvm, BT_COEX_UPDATE_CORUN_LUT, 0,
+				 sizeof(cmd), &cmd))
+		IWL_ERR(mvm,
+			"failed to send BT_COEX_UPDATE_CORUN_LUT command\n");
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
index 6ac6de2..61c07b0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
+++ b/drivers/net/wireless/iwlwifi/mvm/coex_legacy.c
@@ -1058,9 +1058,8 @@ static void iwl_mvm_bt_coex_notif_handle(struct iwl_mvm *mvm)
 		IWL_ERR(mvm, "Failed to update the ctrl_kill_msk\n");
 }
 
-int iwl_mvm_rx_bt_coex_notif_old(struct iwl_mvm *mvm,
-				 struct iwl_rx_cmd_buffer *rxb,
-				 struct iwl_device_cmd *dev_cmd)
+void iwl_mvm_rx_bt_coex_notif_old(struct iwl_mvm *mvm,
+				  struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_bt_coex_profile_notif_old *notif = (void *)pkt->data;
@@ -1083,12 +1082,6 @@ int iwl_mvm_rx_bt_coex_notif_old(struct iwl_mvm *mvm,
 	memcpy(&mvm->last_bt_notif_old, notif, sizeof(mvm->last_bt_notif_old));
 
 	iwl_mvm_bt_coex_notif_handle(mvm);
-
-	/*
-	 * This is an async handler for a notification, returning anything other
-	 * than 0 doesn't make sense even if HCMD failed.
-	 */
-	return 0;
 }
 
 static void iwl_mvm_bt_rssi_iterator(void *_data, u8 *mac,
@@ -1250,14 +1243,12 @@ void iwl_mvm_bt_coex_vif_change_old(struct iwl_mvm *mvm)
 	iwl_mvm_bt_coex_notif_handle(mvm);
 }
 
-int iwl_mvm_rx_ant_coupling_notif_old(struct iwl_mvm *mvm,
-				      struct iwl_rx_cmd_buffer *rxb,
-				      struct iwl_device_cmd *dev_cmd)
+void iwl_mvm_rx_ant_coupling_notif_old(struct iwl_mvm *mvm,
+				       struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u32 ant_isolation = le32_to_cpup((void *)pkt->data);
 	u8 __maybe_unused lower_bound, upper_bound;
-	int ret;
 	u8 lut;
 
 	struct iwl_bt_coex_cmd_old *bt_cmd;
@@ -1268,16 +1259,16 @@ int iwl_mvm_rx_ant_coupling_notif_old(struct iwl_mvm *mvm,
 	};
 
 	if (!iwl_mvm_bt_is_plcr_supported(mvm))
-		return 0;
+		return;
 
 	lockdep_assert_held(&mvm->mutex);
 
 	/* Ignore updates if we are in force mode */
 	if (unlikely(mvm->bt_force_ant_mode != BT_FORCE_ANT_DIS))
-		return 0;
+		return;
 
 	if (ant_isolation ==  mvm->last_ant_isol)
-		return 0;
+		return;
 
 	for (lut = 0; lut < ARRAY_SIZE(antenna_coupling_ranges) - 1; lut++)
 		if (ant_isolation < antenna_coupling_ranges[lut + 1].range)
@@ -1296,13 +1287,13 @@ int iwl_mvm_rx_ant_coupling_notif_old(struct iwl_mvm *mvm,
 	mvm->last_ant_isol = ant_isolation;
 
 	if (mvm->last_corun_lut == lut)
-		return 0;
+		return;
 
 	mvm->last_corun_lut = lut;
 
 	bt_cmd = kzalloc(sizeof(*bt_cmd), GFP_KERNEL);
 	if (!bt_cmd)
-		return 0;
+		return;
 	cmd.data[0] = bt_cmd;
 
 	bt_cmd->flags = cpu_to_le32(BT_COEX_NW_OLD);
@@ -1317,8 +1308,8 @@ int iwl_mvm_rx_ant_coupling_notif_old(struct iwl_mvm *mvm,
 	memcpy(bt_cmd->bt4_corun_lut40, antenna_coupling_ranges[lut].lut20,
 	       sizeof(bt_cmd->bt4_corun_lut40));
 
-	ret = iwl_mvm_send_cmd(mvm, &cmd);
+	if (iwl_mvm_send_cmd(mvm, &cmd))
+		IWL_ERR(mvm, "failed to send BT_CONFIG command\n");
 
 	kfree(bt_cmd);
-	return ret;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw.c b/drivers/net/wireless/iwlwifi/mvm/fw.c
index a482ce6..a5dae098 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/iwlwifi/mvm/fw.c
@@ -814,9 +814,8 @@ int iwl_mvm_load_d3_fw(struct iwl_mvm *mvm)
 	return ret;
 }
 
-int iwl_mvm_rx_card_state_notif(struct iwl_mvm *mvm,
-				    struct iwl_rx_cmd_buffer *rxb,
-				    struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_card_state_notif(struct iwl_mvm *mvm,
+				 struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_card_state_notif *card_state_notif = (void *)pkt->data;
@@ -827,13 +826,10 @@ int iwl_mvm_rx_card_state_notif(struct iwl_mvm *mvm,
 			  (flags & SW_CARD_DISABLED) ? "Kill" : "On",
 			  (flags & CT_KILL_CARD_DISABLED) ?
 			  "Reached" : "Not reached");
-
-	return 0;
 }
 
-int iwl_mvm_rx_mfuart_notif(struct iwl_mvm *mvm,
-			    struct iwl_rx_cmd_buffer *rxb,
-			    struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_mfuart_notif(struct iwl_mvm *mvm,
+			     struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mfuart_load_notif *mfuart_notif = (void *)pkt->data;
@@ -844,5 +840,4 @@ int iwl_mvm_rx_mfuart_notif(struct iwl_mvm *mvm,
 		       le32_to_cpu(mfuart_notif->external_ver),
 		       le32_to_cpu(mfuart_notif->status),
 		       le32_to_cpu(mfuart_notif->duration));
-	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 1812dd0..3424315 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1312,9 +1312,8 @@ static void iwl_mvm_csa_count_down(struct iwl_mvm *mvm,
 	}
 }
 
-int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
-			    struct iwl_rx_cmd_buffer *rxb,
-			    struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
+			     struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_extended_beacon_notif *beacon = (void *)pkt->data;
@@ -1365,8 +1364,6 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 			RCU_INIT_POINTER(mvm->csa_tx_blocked_vif, NULL);
 		}
 	}
-
-	return 0;
 }
 
 static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
@@ -1415,9 +1412,8 @@ static void iwl_mvm_beacon_loss_iterator(void *_data, u8 *mac,
 		iwl_mvm_fw_dbg_collect_trig(mvm, trigger, NULL);
 }
 
-int iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
-				    struct iwl_rx_cmd_buffer *rxb,
-				    struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
+				     struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_missed_beacons_notif *mb = (void *)pkt->data;
@@ -1434,5 +1430,4 @@ int iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
 						   IEEE80211_IFACE_ITER_NORMAL,
 						   iwl_mvm_beacon_loss_iterator,
 						   mb);
-	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 40d1bd7..1397e3e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1012,9 +1012,8 @@ static inline void iwl_mvm_wait_for_async_handlers(struct iwl_mvm *mvm)
 /* Statistics */
 void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 				  struct iwl_rx_packet *pkt);
-int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
-			  struct iwl_rx_cmd_buffer *rxb,
-			  struct iwl_device_cmd *cmd);
+void iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
+			   struct iwl_rx_cmd_buffer *rxb);
 int iwl_mvm_request_statistics(struct iwl_mvm *mvm, bool clear);
 void iwl_mvm_accu_radio_stats(struct iwl_mvm *mvm);
 
@@ -1060,27 +1059,19 @@ bool iwl_mvm_bcast_filter_build_cmd(struct iwl_mvm *mvm,
  * FW notifications / CMD responses handlers
  * Convention: iwl_mvm_rx_<NAME OF THE CMD>
  */
-int iwl_mvm_rx_rx_phy_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			  struct iwl_device_cmd *cmd);
-int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-		       struct iwl_device_cmd *cmd);
-int iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-		      struct iwl_device_cmd *cmd);
-int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			struct iwl_device_cmd *cmd);
-int iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
-				  struct iwl_rx_cmd_buffer *rxb,
-				  struct iwl_device_cmd *cmd);
-int iwl_mvm_rx_fw_error(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			  struct iwl_device_cmd *cmd);
-int iwl_mvm_rx_card_state_notif(struct iwl_mvm *mvm,
-				struct iwl_rx_cmd_buffer *rxb,
-				struct iwl_device_cmd *cmd);
-int iwl_mvm_rx_mfuart_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			    struct iwl_device_cmd *cmd);
-int iwl_mvm_rx_shared_mem_cfg_notif(struct iwl_mvm *mvm,
-				    struct iwl_rx_cmd_buffer *rxb,
-				    struct iwl_device_cmd *cmd);
+void iwl_mvm_rx_rx_phy_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_rx_ant_coupling_notif(struct iwl_mvm *mvm,
+				   struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_rx_fw_error(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_rx_card_state_notif(struct iwl_mvm *mvm,
+				 struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_rx_mfuart_notif(struct iwl_mvm *mvm,
+			     struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_rx_shared_mem_cfg_notif(struct iwl_mvm *mvm,
+				     struct iwl_rx_cmd_buffer *rxb);
 
 /* MVM PHY */
 int iwl_mvm_phy_ctxt_add(struct iwl_mvm *mvm, struct iwl_mvm_phy_ctxt *ctxt,
@@ -1107,12 +1098,10 @@ int iwl_mvm_mac_ctxt_remove(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 u32 iwl_mvm_mac_get_queues_mask(struct ieee80211_vif *vif);
 int iwl_mvm_mac_ctxt_beacon_changed(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif);
-int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
-			    struct iwl_rx_cmd_buffer *rxb,
-			    struct iwl_device_cmd *cmd);
-int iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
-				    struct iwl_rx_cmd_buffer *rxb,
-				    struct iwl_device_cmd *cmd);
+void iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
+			     struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
+				     struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_mac_ctxt_recalc_tsf_id(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif);
 unsigned long iwl_mvm_get_used_hw_queues(struct iwl_mvm *mvm,
@@ -1136,29 +1125,24 @@ int iwl_mvm_max_scan_ie_len(struct iwl_mvm *mvm);
 void iwl_mvm_report_scan_aborted(struct iwl_mvm *mvm);
 
 /* Scheduled scan */
-int iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
-					struct iwl_rx_cmd_buffer *rxb,
-					struct iwl_device_cmd *cmd);
-int iwl_mvm_rx_lmac_scan_iter_complete_notif(struct iwl_mvm *mvm,
-					     struct iwl_rx_cmd_buffer *rxb,
-					     struct iwl_device_cmd *cmd);
+void iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
+					 struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_rx_lmac_scan_iter_complete_notif(struct iwl_mvm *mvm,
+					      struct iwl_rx_cmd_buffer *rxb);
 int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 			     struct ieee80211_vif *vif,
 			     struct cfg80211_sched_scan_request *req,
 			     struct ieee80211_scan_ies *ies,
 			     int type);
-int iwl_mvm_rx_scan_match_found(struct iwl_mvm *mvm,
-				struct iwl_rx_cmd_buffer *rxb,
-				struct iwl_device_cmd *cmd);
+void iwl_mvm_rx_scan_match_found(struct iwl_mvm *mvm,
+				 struct iwl_rx_cmd_buffer *rxb);
 
 /* UMAC scan */
 int iwl_mvm_config_scan(struct iwl_mvm *mvm);
-int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
-					struct iwl_rx_cmd_buffer *rxb,
-					struct iwl_device_cmd *cmd);
-int iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
-					     struct iwl_rx_cmd_buffer *rxb,
-					     struct iwl_device_cmd *cmd);
+void iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
+					 struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
+					      struct iwl_rx_cmd_buffer *rxb);
 
 /* MVM debugfs */
 #ifdef CONFIG_IWLWIFI_DEBUGFS
@@ -1197,9 +1181,8 @@ int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				 char *buf, int bufsz);
 
 void iwl_mvm_power_vif_assoc(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
-int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
-					     struct iwl_rx_cmd_buffer *rxb,
-					     struct iwl_device_cmd *cmd);
+void iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
+					      struct iwl_rx_cmd_buffer *rxb);
 
 #ifdef CONFIG_IWLWIFI_LEDS
 int iwl_mvm_leds_init(struct iwl_mvm *mvm);
@@ -1255,9 +1238,8 @@ int _iwl_mvm_exit_d0i3(struct iwl_mvm *mvm);
 
 /* BT Coex */
 int iwl_send_bt_init_conf(struct iwl_mvm *mvm);
-int iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
-			     struct iwl_rx_cmd_buffer *rxb,
-			     struct iwl_device_cmd *cmd);
+void iwl_mvm_rx_bt_coex_notif(struct iwl_mvm *mvm,
+			      struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_bt_rssi_event(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			   enum ieee80211_rssi_event_data);
 void iwl_mvm_bt_coex_vif_change(struct iwl_mvm *mvm);
@@ -1275,9 +1257,8 @@ u8 iwl_mvm_bt_coex_tx_prio(struct iwl_mvm *mvm, struct ieee80211_hdr *hdr,
 bool iwl_mvm_bt_coex_is_shared_ant_avail_old(struct iwl_mvm *mvm);
 void iwl_mvm_bt_coex_vif_change_old(struct iwl_mvm *mvm);
 int iwl_send_bt_init_conf_old(struct iwl_mvm *mvm);
-int iwl_mvm_rx_bt_coex_notif_old(struct iwl_mvm *mvm,
-				 struct iwl_rx_cmd_buffer *rxb,
-				 struct iwl_device_cmd *cmd);
+void iwl_mvm_rx_bt_coex_notif_old(struct iwl_mvm *mvm,
+				  struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_bt_rssi_event_old(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			       enum ieee80211_rssi_event_data);
 u16 iwl_mvm_coex_agg_time_limit_old(struct iwl_mvm *mvm,
@@ -1286,9 +1267,8 @@ bool iwl_mvm_bt_coex_is_mimo_allowed_old(struct iwl_mvm *mvm,
 					 struct ieee80211_sta *sta);
 bool iwl_mvm_bt_coex_is_tpc_allowed_old(struct iwl_mvm *mvm,
 					enum ieee80211_band band);
-int iwl_mvm_rx_ant_coupling_notif_old(struct iwl_mvm *mvm,
-				      struct iwl_rx_cmd_buffer *rxb,
-				      struct iwl_device_cmd *cmd);
+void iwl_mvm_rx_ant_coupling_notif_old(struct iwl_mvm *mvm,
+				       struct iwl_rx_cmd_buffer *rxb);
 
 /* beacon filtering */
 #ifdef CONFIG_IWLWIFI_DEBUGFS
@@ -1377,9 +1357,8 @@ static inline void iwl_mvm_enable_agg_txq(struct iwl_mvm *mvm, int queue,
 /* Thermal management and CT-kill */
 void iwl_mvm_tt_tx_backoff(struct iwl_mvm *mvm, u32 backoff);
 void iwl_mvm_tt_temp_changed(struct iwl_mvm *mvm, u32 temp);
-int iwl_mvm_temp_notif(struct iwl_mvm *mvm,
-		       struct iwl_rx_cmd_buffer *rxb,
-		       struct iwl_device_cmd *cmd);
+void iwl_mvm_temp_notif(struct iwl_mvm *mvm,
+			struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_tt_handler(struct iwl_mvm *mvm);
 void iwl_mvm_tt_initialize(struct iwl_mvm *mvm, u32 min_backoff);
 void iwl_mvm_tt_exit(struct iwl_mvm *mvm);
@@ -1391,9 +1370,8 @@ struct iwl_mcc_update_resp *
 iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 		   enum iwl_mcc_source src_id);
 int iwl_mvm_init_mcc(struct iwl_mvm *mvm);
-int iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
-			       struct iwl_rx_cmd_buffer *rxb,
-			       struct iwl_device_cmd *cmd);
+void iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
+				struct iwl_rx_cmd_buffer *rxb);
 struct ieee80211_regdomain *iwl_mvm_get_regdomain(struct wiphy *wiphy,
 						  const char *alpha2,
 						  enum iwl_mcc_source src_id,
@@ -1432,8 +1410,7 @@ void iwl_mvm_tdls_recv_channel_switch(struct ieee80211_hw *hw,
 void iwl_mvm_tdls_cancel_channel_switch(struct ieee80211_hw *hw,
 					struct ieee80211_vif *vif,
 					struct ieee80211_sta *sta);
-int iwl_mvm_rx_tdls_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			  struct iwl_device_cmd *cmd);
+void iwl_mvm_rx_tdls_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_tdls_ch_switch_work(struct work_struct *work);
 
 struct ieee80211_vif *iwl_mvm_get_bss_vif(struct iwl_mvm *mvm);
diff --git a/drivers/net/wireless/iwlwifi/mvm/nvm.c b/drivers/net/wireless/iwlwifi/mvm/nvm.c
index 2a6be35..6dcdee7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/iwlwifi/mvm/nvm.c
@@ -839,9 +839,8 @@ int iwl_mvm_init_mcc(struct iwl_mvm *mvm)
 	return retval;
 }
 
-int iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
-			       struct iwl_rx_cmd_buffer *rxb,
-			       struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
+				struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mcc_chub_notif *notif = (void *)pkt->data;
@@ -852,7 +851,7 @@ int iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
 	lockdep_assert_held(&mvm->mutex);
 
 	if (WARN_ON_ONCE(!iwl_mvm_is_lar_supported(mvm)))
-		return 0;
+		return;
 
 	mcc[0] = notif->mcc >> 8;
 	mcc[1] = notif->mcc & 0xff;
@@ -864,10 +863,8 @@ int iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
 		      mcc, src);
 	regd = iwl_mvm_get_regdomain(mvm->hw->wiphy, mcc, src, NULL);
 	if (IS_ERR_OR_NULL(regd))
-		return 0;
+		return;
 
 	regulatory_set_wiphy_regd(mvm->hw->wiphy, regd);
 	kfree(regd);
-
-	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 8f896cd..00ca240 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -203,8 +203,7 @@ static void iwl_mvm_nic_config(struct iwl_op_mode *op_mode)
 struct iwl_rx_handlers {
 	u8 cmd_id;
 	bool async;
-	int (*fn)(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-		  struct iwl_device_cmd *cmd);
+	void (*fn)(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 };
 
 #define RX_HANDLER(_cmd_id, _fn, _async)	\
@@ -628,8 +627,7 @@ static void iwl_op_mode_mvm_stop(struct iwl_op_mode *op_mode)
 struct iwl_async_handler_entry {
 	struct list_head list;
 	struct iwl_rx_cmd_buffer rxb;
-	int (*fn)(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-		  struct iwl_device_cmd *cmd);
+	void (*fn)(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 };
 
 void iwl_mvm_async_handlers_purge(struct iwl_mvm *mvm)
@@ -666,9 +664,7 @@ static void iwl_mvm_async_handlers_wk(struct work_struct *wk)
 	spin_unlock_bh(&mvm->async_handlers_lock);
 
 	list_for_each_entry_safe(entry, tmp, &local_list, list) {
-		if (entry->fn(mvm, &entry->rxb, NULL))
-			IWL_WARN(mvm,
-				 "returned value from ASYNC handlers are ignored\n");
+		entry->fn(mvm, &entry->rxb);
 		iwl_free_rxb(&entry->rxb);
 		list_del(&entry->list);
 		kfree(entry);
@@ -715,8 +711,10 @@ static int iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 	u8 i;
 
-	if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD))
-		return iwl_mvm_rx_rx_mpdu(mvm, rxb, cmd);
+	if (likely(pkt->hdr.cmd == REPLY_RX_MPDU_CMD)) {
+		iwl_mvm_rx_rx_mpdu(mvm, rxb);
+		return 0;
+	}
 
 	iwl_mvm_rx_check_trigger(mvm, pkt);
 
@@ -734,8 +732,10 @@ static int iwl_mvm_rx_dispatch(struct iwl_op_mode *op_mode,
 		if (rx_h->cmd_id != pkt->hdr.cmd)
 			continue;
 
-		if (!rx_h->async)
-			return rx_h->fn(mvm, rxb, cmd);
+		if (!rx_h->async) {
+			rx_h->fn(mvm, rxb);
+			return 0;
+		}
 
 		entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 		/* we can't do much... */
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index d2c6ba9..8e2490a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -509,9 +509,8 @@ static void iwl_mvm_power_uapsd_misbehav_ap_iterator(void *_data, u8 *mac,
 		       ETH_ALEN);
 }
 
-int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
-					     struct iwl_rx_cmd_buffer *rxb,
-					     struct iwl_device_cmd *cmd)
+void iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
+					      struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_uapsd_misbehaving_ap_notif *notif = (void *)pkt->data;
@@ -520,8 +519,6 @@ int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
 	ieee80211_iterate_active_interfaces_atomic(
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 		iwl_mvm_power_uapsd_misbehav_ap_iterator, &ap_sta_id);
-
-	return 0;
 }
 
 struct iwl_power_vifs {
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 8f1d93b..73054dd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -71,8 +71,7 @@
  * Copies the phy information in mvm->last_phy_info, it will be used when the
  * actual data will come from the fw in the next packet.
  */
-int iwl_mvm_rx_rx_phy_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			  struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_rx_phy_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
@@ -86,8 +85,6 @@ int iwl_mvm_rx_rx_phy_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 		spin_unlock(&mvm->drv_stats_lock);
 	}
 #endif
-
-	return 0;
 }
 
 /*
@@ -242,8 +239,7 @@ static u32 iwl_mvm_set_mac80211_rx_flag(struct iwl_mvm *mvm,
  *
  * Handles the actual data of the Rx packet from the fw
  */
-int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-		       struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_rx_status *rx_status;
@@ -271,7 +267,7 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	skb = alloc_skb(128, GFP_ATOMIC);
 	if (!skb) {
 		IWL_ERR(mvm, "alloc_skb failed\n");
-		return 0;
+		return;
 	}
 
 	rx_status = IEEE80211_SKB_RXCB(skb);
@@ -284,14 +280,14 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 		IWL_DEBUG_DROP(mvm, "Bad decryption results 0x%08x\n",
 			       rx_pkt_status);
 		kfree_skb(skb);
-		return 0;
+		return;
 	}
 
 	if ((unlikely(phy_info->cfg_phy_cnt > 20))) {
 		IWL_DEBUG_DROP(mvm, "dsp size out of range [0,20]: %d\n",
 			       phy_info->cfg_phy_cnt);
 		kfree_skb(skb);
-		return 0;
+		return;
 	}
 
 	/*
@@ -431,7 +427,6 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 #endif
 	iwl_mvm_pass_packet_to_mac80211(mvm, skb, hdr, len, ampdu_status,
 					crypt_len, rxb);
-	return 0;
 }
 
 static void iwl_mvm_update_rx_statistics(struct iwl_mvm *mvm,
@@ -623,10 +618,7 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 		iwl_rx_packet_payload_len(pkt));
 }
 
-int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
-			  struct iwl_rx_cmd_buffer *rxb,
-			  struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_statistics(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	iwl_mvm_handle_rx_statistics(mvm, rxb_addr(rxb));
-	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index 5de1449..9c70118 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -327,9 +327,8 @@ static u8 *iwl_mvm_dump_channel_list(struct iwl_scan_results_notif *res,
 	return buf;
 }
 
-int iwl_mvm_rx_lmac_scan_iter_complete_notif(struct iwl_mvm *mvm,
-					     struct iwl_rx_cmd_buffer *rxb,
-					     struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_lmac_scan_iter_complete_notif(struct iwl_mvm *mvm,
+					      struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_lmac_scan_complete_notif *notif = (void *)pkt->data;
@@ -341,17 +340,13 @@ int iwl_mvm_rx_lmac_scan_iter_complete_notif(struct iwl_mvm *mvm,
 		       iwl_mvm_dump_channel_list(notif->results,
 						 notif->scanned_channels, buf,
 						 sizeof(buf)));
-	return 0;
 }
 
-int iwl_mvm_rx_scan_match_found(struct iwl_mvm *mvm,
-				struct iwl_rx_cmd_buffer *rxb,
-				struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_scan_match_found(struct iwl_mvm *mvm,
+				 struct iwl_rx_cmd_buffer *rxb)
 {
 	IWL_DEBUG_SCAN(mvm, "Scheduled scan results\n");
 	ieee80211_sched_scan_results(mvm->hw);
-
-	return 0;
 }
 
 static const char *iwl_mvm_ebs_status_str(enum iwl_scan_ebs_status status)
@@ -368,9 +363,8 @@ static const char *iwl_mvm_ebs_status_str(enum iwl_scan_ebs_status status)
 	}
 }
 
-int iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
-					struct iwl_rx_cmd_buffer *rxb,
-					struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
+					 struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_periodic_scan_complete *scan_notif = (void *)pkt->data;
@@ -426,8 +420,6 @@ int iwl_mvm_rx_lmac_scan_complete_notif(struct iwl_mvm *mvm,
 	mvm->last_ebs_successful =
 			scan_notif->ebs_status == IWL_SCAN_EBS_SUCCESS ||
 			scan_notif->ebs_status == IWL_SCAN_EBS_INACTIVE;
-
-	return 0;
 }
 
 static int iwl_ssid_exist(u8 *ssid, u8 ssid_len, struct iwl_ssid_ie *ssid_list)
@@ -1371,9 +1363,8 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	return ret;
 }
 
-int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
-					struct iwl_rx_cmd_buffer *rxb,
-					struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
+					 struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_umac_scan_complete *notif = (void *)pkt->data;
@@ -1381,7 +1372,7 @@ int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 	bool aborted = (notif->status == IWL_SCAN_OFFLOAD_ABORTED);
 
 	if (WARN_ON(!(mvm->scan_uid_status[uid] & mvm->scan_status)))
-		return 0;
+		return;
 
 	/* if the scan is already stopping, we don't need to notify mac80211 */
 	if (mvm->scan_uid_status[uid] == IWL_MVM_SCAN_REGULAR) {
@@ -1405,13 +1396,10 @@ int iwl_mvm_rx_umac_scan_complete_notif(struct iwl_mvm *mvm,
 		mvm->last_ebs_successful = false;
 
 	mvm->scan_uid_status[uid] = 0;
-
-	return 0;
 }
 
-int iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
-					     struct iwl_rx_cmd_buffer *rxb,
-					     struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
+					      struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_umac_scan_iter_complete_notif *notif = (void *)pkt->data;
@@ -1423,7 +1411,6 @@ int iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
 		       iwl_mvm_dump_channel_list(notif->results,
 						 notif->scanned_channels, buf,
 						 sizeof(buf)));
-	return 0;
 }
 
 static int iwl_mvm_umac_scan_abort(struct iwl_mvm *mvm, int type)
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 806b2c2..f7d3921 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1680,9 +1680,8 @@ void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 		IWL_ERR(mvm, "Failed to send ADD_STA command (%d)\n", ret);
 }
 
-int iwl_mvm_rx_eosp_notif(struct iwl_mvm *mvm,
-			  struct iwl_rx_cmd_buffer *rxb,
-			  struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_eosp_notif(struct iwl_mvm *mvm,
+			   struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mvm_eosp_notification *notif = (void *)pkt->data;
@@ -1690,15 +1689,13 @@ int iwl_mvm_rx_eosp_notif(struct iwl_mvm *mvm,
 	u32 sta_id = le32_to_cpu(notif->sta_id);
 
 	if (WARN_ON_ONCE(sta_id >= IWL_MVM_STATION_COUNT))
-		return 0;
+		return;
 
 	rcu_read_lock();
 	sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
 	if (!IS_ERR_OR_NULL(sta))
 		ieee80211_sta_eosp(sta);
 	rcu_read_unlock();
-
-	return 0;
 }
 
 void iwl_mvm_sta_modify_disable_tx(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index 748f5dc..eedb215 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -378,9 +378,8 @@ void iwl_mvm_update_tkip_key(struct iwl_mvm *mvm,
 			     struct ieee80211_sta *sta, u32 iv32,
 			     u16 *phase1key);
 
-int iwl_mvm_rx_eosp_notif(struct iwl_mvm *mvm,
-			  struct iwl_rx_cmd_buffer *rxb,
-			  struct iwl_device_cmd *cmd);
+void iwl_mvm_rx_eosp_notif(struct iwl_mvm *mvm,
+			   struct iwl_rx_cmd_buffer *rxb);
 
 /* AMPDU */
 int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/iwlwifi/mvm/tdls.c b/drivers/net/wireless/iwlwifi/mvm/tdls.c
index a87b506..71802e7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tdls.c
@@ -261,8 +261,7 @@ static void iwl_mvm_tdls_update_cs_state(struct iwl_mvm *mvm,
 		mvm->tdls_cs.cur_sta_id = IWL_MVM_STATION_COUNT;
 }
 
-int iwl_mvm_rx_tdls_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			  struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_tdls_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_tdls_channel_switch_notif *notif = (void *)pkt->data;
@@ -277,17 +276,17 @@ int iwl_mvm_rx_tdls_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	/* can fail sometimes */
 	if (!le32_to_cpu(notif->status)) {
 		iwl_mvm_tdls_update_cs_state(mvm, IWL_MVM_TDLS_SW_IDLE);
-		goto out;
+		return;
 	}
 
 	if (WARN_ON(sta_id >= IWL_MVM_STATION_COUNT))
-		goto out;
+		return;
 
 	sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[sta_id],
 					lockdep_is_held(&mvm->mutex));
 	/* the station may not be here, but if it is, it must be a TDLS peer */
 	if (IS_ERR_OR_NULL(sta) || WARN_ON(!sta->tdls))
-		goto out;
+		return;
 
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
 	vif = mvmsta->vif;
@@ -301,9 +300,6 @@ int iwl_mvm_rx_tdls_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			 msecs_to_jiffies(delay));
 
 	iwl_mvm_tdls_update_cs_state(mvm, IWL_MVM_TDLS_SW_ACTIVE);
-
-out:
-	return 0;
 }
 
 static int
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index d24b6a8..6c05669 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -410,9 +410,8 @@ static int iwl_mvm_aux_roc_te_handle_notif(struct iwl_mvm *mvm,
 /*
  * The Rx handler for time event notifications
  */
-int iwl_mvm_rx_time_event_notif(struct iwl_mvm *mvm,
-				struct iwl_rx_cmd_buffer *rxb,
-				struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_time_event_notif(struct iwl_mvm *mvm,
+				 struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_time_event_notif *notif = (void *)pkt->data;
@@ -433,8 +432,6 @@ int iwl_mvm_rx_time_event_notif(struct iwl_mvm *mvm,
 	}
 unlock:
 	spin_unlock_bh(&mvm->time_event_lock);
-
-	return 0;
 }
 
 static bool iwl_mvm_te_notif(struct iwl_notif_wait_data *notif_wait,
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.h b/drivers/net/wireless/iwlwifi/mvm/time-event.h
index de4fbc6..cbdf8e52a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.h
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.h
@@ -157,9 +157,8 @@ void iwl_mvm_stop_session_protection(struct iwl_mvm *mvm,
 /*
  * iwl_mvm_rx_time_event_notif - handles %TIME_EVENT_NOTIFICATION.
  */
-int iwl_mvm_rx_time_event_notif(struct iwl_mvm *mvm,
-				struct iwl_rx_cmd_buffer *rxb,
-				struct iwl_device_cmd *cmd);
+void iwl_mvm_rx_time_event_notif(struct iwl_mvm *mvm,
+				 struct iwl_rx_cmd_buffer *rxb);
 
 /**
  * iwl_mvm_start_p2p_roc - start remain on channel for p2p device functionality
diff --git a/drivers/net/wireless/iwlwifi/mvm/tt.c b/drivers/net/wireless/iwlwifi/mvm/tt.c
index 80d07db..7e88d39 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tt.c
@@ -154,24 +154,20 @@ static bool iwl_mvm_temp_notif_wait(struct iwl_notif_wait_data *notif_wait,
 	return true;
 }
 
-int iwl_mvm_temp_notif(struct iwl_mvm *mvm,
-		       struct iwl_rx_cmd_buffer *rxb,
-		       struct iwl_device_cmd *cmd)
+void iwl_mvm_temp_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	int temp;
 
 	/* the notification is handled synchronously in ctkill, so skip here */
 	if (test_bit(IWL_MVM_STATUS_HW_CTKILL, &mvm->status))
-		return 0;
+		return;
 
 	temp = iwl_mvm_temp_notif_parse(mvm, pkt);
 	if (temp < 0)
-		return 0;
+		return;
 
 	iwl_mvm_tt_temp_changed(mvm, temp);
-
-	return 0;
 }
 
 static int iwl_mvm_get_temp_cmd(struct iwl_mvm *mvm)
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 7ba7a118..abde484 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -911,8 +911,7 @@ static void iwl_mvm_rx_tx_cmd_agg(struct iwl_mvm *mvm,
 	rcu_read_unlock();
 }
 
-int iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-		      struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mvm_tx_resp *tx_resp = (void *)pkt->data;
@@ -921,8 +920,6 @@ int iwl_mvm_rx_tx_cmd(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 		iwl_mvm_rx_tx_cmd_single(mvm, pkt);
 	else
 		iwl_mvm_rx_tx_cmd_agg(mvm, pkt);
-
-	return 0;
 }
 
 static void iwl_mvm_tx_info_from_ba_notif(struct ieee80211_tx_info *info,
@@ -942,8 +939,7 @@ static void iwl_mvm_tx_info_from_ba_notif(struct ieee80211_tx_info *info,
 		(void *)(uintptr_t)tid_data->rate_n_flags;
 }
 
-int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_mvm_ba_notif *ba_notif = (void *)pkt->data;
@@ -965,7 +961,7 @@ int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	if (WARN_ONCE(sta_id >= IWL_MVM_STATION_COUNT ||
 		      tid >= IWL_MAX_TID_COUNT,
 		      "sta_id %d tid %d", sta_id, tid))
-		return 0;
+		return;
 
 	rcu_read_lock();
 
@@ -974,7 +970,7 @@ int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 	/* Reclaiming frames for a station that has been deleted ? */
 	if (WARN_ON_ONCE(IS_ERR_OR_NULL(sta))) {
 		rcu_read_unlock();
-		return 0;
+		return;
 	}
 
 	mvmsta = iwl_mvm_sta_from_mac80211(sta);
@@ -985,7 +981,7 @@ int iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 			"invalid BA notification: Q %d, tid %d, flow %d\n",
 			tid_data->txq_id, tid, scd_flow);
 		rcu_read_unlock();
-		return 0;
+		return;
 	}
 
 	spin_lock_bh(&mvmsta->lock);
@@ -1072,8 +1068,6 @@ out:
 		skb = __skb_dequeue(&reclaimed_skbs);
 		ieee80211_tx_status(mvm->hw, skb);
 	}
-
-	return 0;
 }
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 03f8e06..3b016f9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -243,8 +243,7 @@ u8 iwl_mvm_mac80211_idx_to_hwrate(int rate_idx)
 	return fw_rate_idx_to_plcp[rate_idx];
 }
 
-int iwl_mvm_rx_fw_error(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
-			  struct iwl_device_cmd *cmd)
+void iwl_mvm_rx_fw_error(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_error_resp *err_resp = (void *)pkt->data;
@@ -256,7 +255,6 @@ int iwl_mvm_rx_fw_error(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 		le32_to_cpu(err_resp->error_service));
 	IWL_ERR(mvm, "FW Error notification: timestamp 0x%16llX\n",
 		le64_to_cpu(err_resp->timestamp));
-	return 0;
 }
 
 /*
-- 
2.1.4

