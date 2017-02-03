Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37962 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751958AbdBCOjb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:39:31 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:38:12 +0200
Message-Id: <20170203143812.7525-26-luca@coelho.fi> (sfid-20170203_153933_905211_B200DAB6)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 25/25] iwlwifi: mvm: support new beacon template command
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Support new version of beacon template command which deprecates
the use of the tx command inside.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h | 29 +++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  | 71 +++++++++++++++-------
 2 files changed, 73 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index 59ca97a11b2b..b38cc073adcc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -672,8 +672,7 @@ struct iwl_mac_beacon_cmd_v6 {
 } __packed; /* BEACON_TEMPLATE_CMD_API_S_VER_6 */
 
 /**
- * struct iwl_mac_beacon_cmd - beacon template command with offloaded CSA
- * @tx: the tx commands associated with the beacon frame
+ * struct iwl_mac_beacon_cmd_data - data of beacon template with offloaded CSA
  * @template_id: currently equal to the mac context id of the coresponding
  *  mac.
  * @tim_idx: the offset of the tim IE in the beacon
@@ -682,16 +681,38 @@ struct iwl_mac_beacon_cmd_v6 {
  * @csa_offset: offset to the CSA IE if present
  * @frame: the template of the beacon frame
  */
-struct iwl_mac_beacon_cmd {
-	struct iwl_tx_cmd tx;
+struct iwl_mac_beacon_cmd_data {
 	__le32 template_id;
 	__le32 tim_idx;
 	__le32 tim_size;
 	__le32 ecsa_offset;
 	__le32 csa_offset;
 	struct ieee80211_hdr frame[0];
+};
+
+/**
+ * struct iwl_mac_beacon_cmd_v7 - beacon template command with offloaded CSA
+ * @tx: the tx commands associated with the beacon frame
+ * @data: see &iwl_mac_beacon_cmd_data
+ */
+struct iwl_mac_beacon_cmd_v7 {
+	struct iwl_tx_cmd tx;
+	struct iwl_mac_beacon_cmd_data data;
 } __packed; /* BEACON_TEMPLATE_CMD_API_S_VER_7 */
 
+/**
+ * struct iwl_mac_beacon_cmd - beacon template command with offloaded CSA
+ * @byte_cnt: byte count of the beacon frame
+ * @flags: for future use
+ * @data: see &iwl_mac_beacon_cmd_data
+ */
+struct iwl_mac_beacon_cmd {
+	__le16 byte_cnt;
+	__le16 flags;
+	__le64 reserved;
+	struct iwl_mac_beacon_cmd_data data;
+} __packed; /* BEACON_TEMPLATE_CMD_API_S_VER_8 */
+
 struct iwl_beacon_notif {
 	struct iwl_mvm_tx_resp beacon_notify_hdr;
 	__le64 tsf;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index bf0555fcf695..99132ea16ede 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -979,7 +979,7 @@ static int iwl_mvm_mac_ctxt_cmd_p2p_device(struct iwl_mvm *mvm,
 }
 
 static void iwl_mvm_mac_ctxt_set_tim(struct iwl_mvm *mvm,
-				     struct iwl_mac_beacon_cmd_v6 *beacon_cmd,
+				     __le32 *tim_index, __le32 *tim_size,
 				     u8 *beacon, u32 frame_size)
 {
 	u32 tim_idx;
@@ -996,8 +996,8 @@ static void iwl_mvm_mac_ctxt_set_tim(struct iwl_mvm *mvm,
 
 	/* If TIM field was found, set variables */
 	if ((tim_idx < (frame_size - 1)) && (beacon[tim_idx] == WLAN_EID_TIM)) {
-		beacon_cmd->tim_idx = cpu_to_le32(tim_idx);
-		beacon_cmd->tim_size = cpu_to_le32((u32)beacon[tim_idx+1]);
+		*tim_index = cpu_to_le32(tim_idx);
+		*tim_size = cpu_to_le32((u32)beacon[tim_idx + 1]);
 	} else {
 		IWL_WARN(mvm, "Unable to find TIM Element in beacon\n");
 	}
@@ -1031,8 +1031,9 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 	};
 	union {
 		struct iwl_mac_beacon_cmd_v6 beacon_cmd_v6;
-		struct iwl_mac_beacon_cmd beacon_cmd;
+		struct iwl_mac_beacon_cmd_v7 beacon_cmd;
 	} u = {};
+	struct iwl_mac_beacon_cmd beacon_cmd;
 	struct ieee80211_tx_info *info;
 	u32 beacon_skb_len;
 	u32 rate, tx_flags;
@@ -1042,6 +1043,46 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 
 	beacon_skb_len = beacon->len;
 
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_CSA_AND_TBTT_OFFLOAD)) {
+		u32 csa_offset, ecsa_offset;
+
+		csa_offset = iwl_mvm_find_ie_offset(beacon->data,
+						    WLAN_EID_CHANNEL_SWITCH,
+						    beacon_skb_len);
+		ecsa_offset =
+			iwl_mvm_find_ie_offset(beacon->data,
+					       WLAN_EID_EXT_CHANSWITCH_ANN,
+					       beacon_skb_len);
+
+		if (iwl_mvm_has_new_tx_api(mvm)) {
+			beacon_cmd.data.template_id =
+				cpu_to_le32((u32)mvmvif->id);
+			beacon_cmd.data.ecsa_offset = cpu_to_le32(ecsa_offset);
+			beacon_cmd.data.csa_offset = cpu_to_le32(csa_offset);
+			beacon_cmd.byte_cnt = cpu_to_le16((u16)beacon_skb_len);
+			if (vif->type == NL80211_IFTYPE_AP)
+				iwl_mvm_mac_ctxt_set_tim(mvm,
+							 &beacon_cmd.data.tim_idx,
+							 &beacon_cmd.data.tim_size,
+							 beacon->data,
+							 beacon_skb_len);
+			cmd.len[0] = sizeof(beacon_cmd);
+			cmd.data[0] = &beacon_cmd;
+			goto send;
+
+		} else {
+			u.beacon_cmd.data.ecsa_offset =
+				cpu_to_le32(ecsa_offset);
+			u.beacon_cmd.data.csa_offset = cpu_to_le32(csa_offset);
+			cmd.len[0] = sizeof(u.beacon_cmd);
+			cmd.data[0] = &u;
+		}
+	} else {
+		cmd.len[0] = sizeof(u.beacon_cmd_v6);
+		cmd.data[0] = &u;
+	}
+
 	/* TODO: for now the beacon template id is set to be the mac context id.
 	 * Might be better to handle it as another resource ... */
 	u.beacon_cmd_v6.template_id = cpu_to_le32((u32)mvmvif->id);
@@ -1080,29 +1121,13 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 
 	/* Set up TX beacon command fields */
 	if (vif->type == NL80211_IFTYPE_AP)
-		iwl_mvm_mac_ctxt_set_tim(mvm, &u.beacon_cmd_v6,
+		iwl_mvm_mac_ctxt_set_tim(mvm, &u.beacon_cmd_v6.tim_idx,
+					 &u.beacon_cmd_v6.tim_size,
 					 beacon->data,
 					 beacon_skb_len);
 
+send:
 	/* Submit command */
-
-	if (fw_has_capa(&mvm->fw->ucode_capa,
-			IWL_UCODE_TLV_CAPA_CSA_AND_TBTT_OFFLOAD)) {
-		u.beacon_cmd.csa_offset =
-			cpu_to_le32(iwl_mvm_find_ie_offset(beacon->data,
-						    WLAN_EID_CHANNEL_SWITCH,
-						    beacon_skb_len));
-		u.beacon_cmd.ecsa_offset =
-			cpu_to_le32(iwl_mvm_find_ie_offset(beacon->data,
-						    WLAN_EID_EXT_CHANSWITCH_ANN,
-						    beacon_skb_len));
-
-		cmd.len[0] = sizeof(u.beacon_cmd);
-	} else {
-		cmd.len[0] = sizeof(u.beacon_cmd_v6);
-	}
-
-	cmd.data[0] = &u;
 	cmd.dataflags[0] = 0;
 	cmd.len[1] = beacon_skb_len;
 	cmd.data[1] = beacon->data;
-- 
2.11.0
