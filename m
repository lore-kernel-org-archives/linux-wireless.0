Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61200 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320AbaLBSSQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:18:16 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so17912049wgh.20
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:18:15 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/26] iwlwifi: mvm: remove IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID
Date: Tue,  2 Dec 2014 20:10:56 +0200
Message-Id: <1417543877-24193-5-git-send-email-egrumbach@gmail.com> (sfid-20141202_191836_923791_3D58CFF6)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the supported firmwares have this TLV flag set.

Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c         | 56 +++++++++++----------------
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h  |  6 +--
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |  2 +-
 drivers/net/wireless/iwlwifi/mvm/offloading.c |  2 +-
 drivers/net/wireless/iwlwifi/mvm/ops.c        | 19 ++++-----
 5 files changed, 34 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 8970386..c7297c5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -786,32 +786,18 @@ static int iwl_mvm_switch_to_d3(struct iwl_mvm *mvm)
 }
 
 static int
-iwl_mvm_send_wowlan_config_cmd(struct iwl_mvm *mvm,
-			       const struct iwl_wowlan_config_cmd_v3 *cmd)
-{
-	/* start only with the v2 part of the command */
-	u16 cmd_len = sizeof(cmd->common);
-
-	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID)
-		cmd_len = sizeof(*cmd);
-
-	return iwl_mvm_send_cmd_pdu(mvm, WOWLAN_CONFIGURATION, 0,
-				    cmd_len, cmd);
-}
-
-static int
 iwl_mvm_get_wowlan_config(struct iwl_mvm *mvm,
 			  struct cfg80211_wowlan *wowlan,
-			  struct iwl_wowlan_config_cmd_v3 *wowlan_config_cmd,
+			  struct iwl_wowlan_config_cmd *wowlan_config_cmd,
 			  struct ieee80211_vif *vif, struct iwl_mvm_vif *mvmvif,
 			  struct ieee80211_sta *ap_sta)
 {
 	int ret;
 	struct iwl_mvm_sta *mvm_ap_sta = (struct iwl_mvm_sta *)ap_sta->drv_priv;
 
-	/* TODO: wowlan_config_cmd->common.wowlan_ba_teardown_tids */
+	/* TODO: wowlan_config_cmd->wowlan_ba_teardown_tids */
 
-	wowlan_config_cmd->common.is_11n_connection =
+	wowlan_config_cmd->is_11n_connection =
 					ap_sta->ht_cap.ht_supported;
 
 	/* Query the last used seqno and set it */
@@ -819,32 +805,32 @@ iwl_mvm_get_wowlan_config(struct iwl_mvm *mvm,
 	if (ret < 0)
 		return ret;
 
-	wowlan_config_cmd->common.non_qos_seq = cpu_to_le16(ret);
+	wowlan_config_cmd->non_qos_seq = cpu_to_le16(ret);
 
-	iwl_mvm_set_wowlan_qos_seq(mvm_ap_sta, &wowlan_config_cmd->common);
+	iwl_mvm_set_wowlan_qos_seq(mvm_ap_sta, wowlan_config_cmd);
 
 	if (wowlan->disconnect)
-		wowlan_config_cmd->common.wakeup_filter |=
+		wowlan_config_cmd->wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_BEACON_MISS |
 				    IWL_WOWLAN_WAKEUP_LINK_CHANGE);
 	if (wowlan->magic_pkt)
-		wowlan_config_cmd->common.wakeup_filter |=
+		wowlan_config_cmd->wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_MAGIC_PACKET);
 	if (wowlan->gtk_rekey_failure)
-		wowlan_config_cmd->common.wakeup_filter |=
+		wowlan_config_cmd->wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_GTK_REKEY_FAIL);
 	if (wowlan->eap_identity_req)
-		wowlan_config_cmd->common.wakeup_filter |=
+		wowlan_config_cmd->wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_EAP_IDENT_REQ);
 	if (wowlan->four_way_handshake)
-		wowlan_config_cmd->common.wakeup_filter |=
+		wowlan_config_cmd->wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_4WAY_HANDSHAKE);
 	if (wowlan->n_patterns)
-		wowlan_config_cmd->common.wakeup_filter |=
+		wowlan_config_cmd->wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_PATTERN_MATCH);
 
 	if (wowlan->rfkill_release)
-		wowlan_config_cmd->common.wakeup_filter |=
+		wowlan_config_cmd->wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_RF_KILL_DEASSERT);
 
 	if (wowlan->tcp) {
@@ -852,7 +838,7 @@ iwl_mvm_get_wowlan_config(struct iwl_mvm *mvm,
 		 * Set the "link change" (really "link lost") flag as well
 		 * since that implies losing the TCP connection.
 		 */
-		wowlan_config_cmd->common.wakeup_filter |=
+		wowlan_config_cmd->wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_REMOTE_LINK_LOSS |
 				    IWL_WOWLAN_WAKEUP_REMOTE_SIGNATURE_TABLE |
 				    IWL_WOWLAN_WAKEUP_REMOTE_WAKEUP_PACKET |
@@ -865,7 +851,7 @@ iwl_mvm_get_wowlan_config(struct iwl_mvm *mvm,
 static int
 iwl_mvm_wowlan_config(struct iwl_mvm *mvm,
 		      struct cfg80211_wowlan *wowlan,
-		      struct iwl_wowlan_config_cmd_v3 *wowlan_config_cmd,
+		      struct iwl_wowlan_config_cmd *wowlan_config_cmd,
 		      struct ieee80211_vif *vif, struct iwl_mvm_vif *mvmvif,
 		      struct ieee80211_sta *ap_sta)
 {
@@ -947,7 +933,9 @@ iwl_mvm_wowlan_config(struct iwl_mvm *mvm,
 		}
 	}
 
-	ret = iwl_mvm_send_wowlan_config_cmd(mvm, wowlan_config_cmd);
+	ret = iwl_mvm_send_cmd_pdu(mvm, WOWLAN_CONFIGURATION, 0,
+				   sizeof(*wowlan_config_cmd),
+				   wowlan_config_cmd);
 	if (ret)
 		goto out;
 
@@ -972,7 +960,7 @@ iwl_mvm_netdetect_config(struct iwl_mvm *mvm,
 			 struct cfg80211_sched_scan_request *nd_config,
 			 struct ieee80211_vif *vif)
 {
-	struct iwl_wowlan_config_cmd_v3 wowlan_config_cmd = {};
+	struct iwl_wowlan_config_cmd wowlan_config_cmd = {};
 	int ret;
 
 	ret = iwl_mvm_switch_to_d3(mvm);
@@ -981,10 +969,12 @@ iwl_mvm_netdetect_config(struct iwl_mvm *mvm,
 
 	/* rfkill release can be either for wowlan or netdetect */
 	if (wowlan->rfkill_release)
-		wowlan_config_cmd.common.wakeup_filter |=
+		wowlan_config_cmd.wakeup_filter |=
 			cpu_to_le32(IWL_WOWLAN_WAKEUP_RF_KILL_DEASSERT);
 
-	ret = iwl_mvm_send_wowlan_config_cmd(mvm, &wowlan_config_cmd);
+	ret = iwl_mvm_send_cmd_pdu(mvm, WOWLAN_CONFIGURATION, 0,
+				   sizeof(wowlan_config_cmd),
+				   &wowlan_config_cmd);
 	if (ret)
 		return ret;
 
@@ -1051,7 +1041,7 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 
 		mvm->net_detect = true;
 	} else {
-		struct iwl_wowlan_config_cmd_v3 wowlan_config_cmd = {};
+		struct iwl_wowlan_config_cmd wowlan_config_cmd = {};
 
 		ap_sta = rcu_dereference_protected(
 			mvm->fw_id_to_mac_id[mvmvif->ap_sta_id],
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
index e74cdf2..6d3bea5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
@@ -241,16 +241,12 @@ enum iwl_wowlan_wakeup_filters {
 	IWL_WOWLAN_WAKEUP_BCN_FILTERING			= BIT(16),
 }; /* WOWLAN_WAKEUP_FILTER_API_E_VER_4 */
 
-struct iwl_wowlan_config_cmd_v2 {
+struct iwl_wowlan_config_cmd {
 	__le32 wakeup_filter;
 	__le16 non_qos_seq;
 	__le16 qos_seq[8];
 	u8 wowlan_ba_teardown_tids;
 	u8 is_11n_connection;
-} __packed; /* WOWLAN_CONFIG_API_S_VER_2 */
-
-struct iwl_wowlan_config_cmd_v3 {
-	struct iwl_wowlan_config_cmd_v2 common;
 	u8 offloading_tid;
 	u8 reserved[3];
 } __packed; /* WOWLAN_CONFIG_API_S_VER_3 */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 2ab59b8..09d4833 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1143,7 +1143,7 @@ iwl_mvm_set_last_nonqos_seq(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 }
 #endif
 void iwl_mvm_set_wowlan_qos_seq(struct iwl_mvm_sta *mvm_ap_sta,
-				struct iwl_wowlan_config_cmd_v2 *cmd);
+				struct iwl_wowlan_config_cmd *cmd);
 int iwl_mvm_send_proto_offload(struct iwl_mvm *mvm,
 			       struct ieee80211_vif *vif,
 			       bool disable_offloading,
diff --git a/drivers/net/wireless/iwlwifi/mvm/offloading.c b/drivers/net/wireless/iwlwifi/mvm/offloading.c
index adcbf4c..68b0169 100644
--- a/drivers/net/wireless/iwlwifi/mvm/offloading.c
+++ b/drivers/net/wireless/iwlwifi/mvm/offloading.c
@@ -67,7 +67,7 @@
 #include "mvm.h"
 
 void iwl_mvm_set_wowlan_qos_seq(struct iwl_mvm_sta *mvm_ap_sta,
-				struct iwl_wowlan_config_cmd_v2 *cmd)
+				struct iwl_wowlan_config_cmd *cmd)
 {
 	int i;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index b952e79..daad985 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1000,7 +1000,7 @@ static void iwl_mvm_enter_d0i3_iterator(void *_data, u8 *mac,
 }
 
 static void iwl_mvm_set_wowlan_data(struct iwl_mvm *mvm,
-				    struct iwl_wowlan_config_cmd_v3 *cmd,
+				    struct iwl_wowlan_config_cmd *cmd,
 				    struct iwl_d0i3_iter_data *iter_data)
 {
 	struct ieee80211_sta *ap_sta;
@@ -1016,14 +1016,14 @@ static void iwl_mvm_set_wowlan_data(struct iwl_mvm *mvm,
 		goto out;
 
 	mvm_ap_sta = iwl_mvm_sta_from_mac80211(ap_sta);
-	cmd->common.is_11n_connection = ap_sta->ht_cap.ht_supported;
+	cmd->is_11n_connection = ap_sta->ht_cap.ht_supported;
 	cmd->offloading_tid = iter_data->offloading_tid;
 
 	/*
 	 * The d0i3 uCode takes care of the nonqos counters,
 	 * so configure only the qos seq ones.
 	 */
-	iwl_mvm_set_wowlan_qos_seq(mvm_ap_sta, &cmd->common);
+	iwl_mvm_set_wowlan_qos_seq(mvm_ap_sta, cmd);
 out:
 	rcu_read_unlock();
 }
@@ -1035,14 +1035,11 @@ static int iwl_mvm_enter_d0i3(struct iwl_op_mode *op_mode)
 	struct iwl_d0i3_iter_data d0i3_iter_data = {
 		.mvm = mvm,
 	};
-	struct iwl_wowlan_config_cmd_v3 wowlan_config_cmd = {
-		.common = {
-			.wakeup_filter =
-				cpu_to_le32(IWL_WOWLAN_WAKEUP_RX_FRAME |
-					    IWL_WOWLAN_WAKEUP_BEACON_MISS |
-					    IWL_WOWLAN_WAKEUP_LINK_CHANGE |
-					    IWL_WOWLAN_WAKEUP_BCN_FILTERING),
-		},
+	struct iwl_wowlan_config_cmd wowlan_config_cmd = {
+		.wakeup_filter = cpu_to_le32(IWL_WOWLAN_WAKEUP_RX_FRAME |
+					     IWL_WOWLAN_WAKEUP_BEACON_MISS |
+					     IWL_WOWLAN_WAKEUP_LINK_CHANGE |
+					     IWL_WOWLAN_WAKEUP_BCN_FILTERING),
 	};
 	struct iwl_d3_manager_config d3_cfg_cmd = {
 		.min_sleep_time = cpu_to_le32(1000),
-- 
1.9.1

