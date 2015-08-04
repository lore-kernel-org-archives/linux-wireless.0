Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754805AbbHDU7I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:08 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/37] iwlwifi: mvm: move existing UMAC commands to group 1
Date: Tue,  4 Aug 2015 23:43:11 +0300
Message-Id: <1438721007-23283-21-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230018_804695_125C845A)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Existing UMAC commands already use the long header, but are sent
with group 0 and the long header inserted manually. Move them to
the group 1 to take advantage of the header building in the low-
level transport.

Existing firmware ignores the group_id field (it's reserved) and
the first firmware that really supports long command headers can
parse all commands in both group 0 (with short header) and group
1 (with long header.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h       |  5 +++++
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h | 18 ---------------
 drivers/net/wireless/iwlwifi/mvm/fw-api-tof.h  |  5 -----
 drivers/net/wireless/iwlwifi/mvm/scan.c        | 22 ++++++++----------
 drivers/net/wireless/iwlwifi/mvm/tof.c         | 31 ++++++++++----------------
 drivers/net/wireless/iwlwifi/pcie/tx.c         |  3 ++-
 6 files changed, 28 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index df71aa3..8f67004 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -148,6 +148,11 @@ static inline u32 iwl_cmd_id(u8 opcode, u8 groupid, u8 version)
 	return opcode + (groupid << 8) + (version << 16);
 }
 
+/* due to the conversion, this group is special; new groups
+ * should be defined in the appropriate fw-api header files
+ */
+#define IWL_ALWAYS_LONG_GROUP	1
+
 /**
  * struct iwl_cmd_header
  *
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
index 5e4cbdb..4787c32 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -550,18 +550,6 @@ struct iwl_periodic_scan_complete {
 
 /* UMAC Scan API */
 
-/**
- * struct iwl_mvm_umac_cmd_hdr - Command header for UMAC commands
- * @size:	size of the command (not including header)
- * @reserved0:	for future use and alignment
- * @ver:	API version number
- */
-struct iwl_mvm_umac_cmd_hdr {
-	__le16 size;
-	u8 reserved0;
-	u8 ver;
-} __packed;
-
 /* The maximum of either of these cannot exceed 8, because we use an
  * 8-bit mask (see IWL_MVM_SCAN_MASK in mvm.h).
  */
@@ -621,7 +609,6 @@ enum iwl_channel_flags {
 
 /**
  * struct iwl_scan_config
- * @hdr: umac command header
  * @flags:			enum scan_config_flags
  * @tx_chains:			valid_tx antenna - ANT_* definitions
  * @rx_chains:			valid_rx antenna - ANT_* definitions
@@ -639,7 +626,6 @@ enum iwl_channel_flags {
  * @channel_array:		default supported channels
  */
 struct iwl_scan_config {
-	struct iwl_mvm_umac_cmd_hdr hdr;
 	__le32 flags;
 	__le32 tx_chains;
 	__le32 rx_chains;
@@ -734,7 +720,6 @@ struct iwl_scan_req_umac_tail {
 
 /**
  * struct iwl_scan_req_umac
- * @hdr: umac command header
  * @flags: &enum iwl_umac_scan_flags
  * @uid: scan id, &enum iwl_umac_scan_uid_offsets
  * @ooc_priority: out of channel priority - &enum iwl_scan_priority
@@ -753,7 +738,6 @@ struct iwl_scan_req_umac_tail {
  *	&struct iwl_scan_req_umac_tail
  */
 struct iwl_scan_req_umac {
-	struct iwl_mvm_umac_cmd_hdr hdr;
 	__le32 flags;
 	__le32 uid;
 	__le32 ooc_priority;
@@ -775,12 +759,10 @@ struct iwl_scan_req_umac {
 
 /**
  * struct iwl_umac_scan_abort
- * @hdr: umac command header
  * @uid: scan id, &enum iwl_umac_scan_uid_offsets
  * @flags: reserved
  */
 struct iwl_umac_scan_abort {
-	struct iwl_mvm_umac_cmd_hdr hdr;
 	__le32 uid;
 	__le32 flags;
 } __packed; /* SCAN_ABORT_CMD_UMAC_API_S_VER_1 */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-tof.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-tof.h
index 287c9ec..eed6271 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-tof.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-tof.h
@@ -88,7 +88,6 @@ enum iwl_mvm_tof_sub_grp_ids {
  * @is_buf_required: 1 channel estimation buffer required, 0 - otherwise
  */
 struct iwl_tof_config_cmd {
-	struct iwl_mvm_umac_cmd_hdr hdr;
 	__le32 sub_grp_cmd_id;
 	u8 tof_disabled;
 	u8 one_sided_disabled;
@@ -136,7 +135,6 @@ struct iwl_tof_config_cmd {
  * @bssid: Current AP BSSID
  */
 struct iwl_tof_responder_config_cmd {
-	struct iwl_mvm_umac_cmd_hdr hdr;
 	__le32 sub_grp_cmd_id;
 	__le16 burst_period;
 	u8 min_delta_ftm;
@@ -171,7 +169,6 @@ struct iwl_tof_responder_config_cmd {
  *			value to be sent to the AP
  */
 struct iwl_tof_range_req_ext_cmd {
-	struct iwl_mvm_umac_cmd_hdr hdr;
 	__le32 sub_grp_cmd_id;
 	__le16 tsf_timer_offset_msec;
 	__le16 reserved;
@@ -273,7 +270,6 @@ enum iwl_tof_response_mode {
  *		  Bits set to 1 shall be randomized by the UMAC
  */
 struct iwl_tof_range_req_cmd {
-	struct iwl_mvm_umac_cmd_hdr hdr;
 	__le32 sub_grp_cmd_id;
 	u8 request_id;
 	u8 initiator;
@@ -382,7 +378,6 @@ struct iwl_tof_neighbor_report {
  * @request_id: corresponds to a range request
  */
 struct iwl_tof_range_abort_cmd {
-	struct iwl_mvm_umac_cmd_hdr hdr;
 	__le32 sub_grp_cmd_id;
 	u8 request_id;
 	u8 reserved[3];
diff --git a/drivers/net/wireless/iwlwifi/mvm/scan.c b/drivers/net/wireless/iwlwifi/mvm/scan.c
index b891fa5..d34b2e5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -884,9 +884,9 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 	int num_channels =
 		mvm->nvm_data->bands[IEEE80211_BAND_2GHZ].n_channels +
 		mvm->nvm_data->bands[IEEE80211_BAND_5GHZ].n_channels;
-	int ret, i, j = 0, cmd_size, data_size;
+	int ret, i, j = 0, cmd_size;
 	struct iwl_host_cmd cmd = {
-		.id = SCAN_CFG_CMD,
+		.id = iwl_cmd_id(SCAN_CFG_CMD, IWL_ALWAYS_LONG_GROUP, 0),
 	};
 
 	if (WARN_ON(num_channels > mvm->fw->ucode_capa.n_scan_channels))
@@ -898,8 +898,6 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 	if (!scan_config)
 		return -ENOMEM;
 
-	data_size = cmd_size - sizeof(struct iwl_mvm_umac_cmd_hdr);
-	scan_config->hdr.size = cpu_to_le16(data_size);
 	scan_config->flags = cpu_to_le32(SCAN_CONFIG_FLAG_ACTIVATE |
 					 SCAN_CONFIG_FLAG_ALLOW_CHUB_REQS |
 					 SCAN_CONFIG_FLAG_SET_TX_CHAINS |
@@ -1045,8 +1043,6 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		return uid;
 
 	memset(cmd, 0, ksize(cmd));
-	cmd->hdr.size = cpu_to_le16(iwl_mvm_scan_size(mvm) -
-				    sizeof(struct iwl_mvm_umac_cmd_hdr));
 
 	iwl_mvm_scan_umac_dwell(mvm, cmd, params);
 
@@ -1183,7 +1179,7 @@ int iwl_mvm_reg_scan_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
 
 	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
-		hcmd.id = SCAN_REQ_UMAC;
+		hcmd.id = iwl_cmd_id(SCAN_REQ_UMAC, IWL_ALWAYS_LONG_GROUP, 0);
 		ret = iwl_mvm_scan_umac(mvm, vif, &params,
 					IWL_MVM_SCAN_REGULAR);
 	} else {
@@ -1291,7 +1287,7 @@ int iwl_mvm_sched_scan_start(struct iwl_mvm *mvm,
 	iwl_mvm_build_scan_probe(mvm, vif, ies, &params);
 
 	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_UMAC_SCAN)) {
-		hcmd.id = SCAN_REQ_UMAC;
+		hcmd.id = iwl_cmd_id(SCAN_REQ_UMAC, IWL_ALWAYS_LONG_GROUP, 0);
 		ret = iwl_mvm_scan_umac(mvm, vif, &params, IWL_MVM_SCAN_SCHED);
 	} else {
 		hcmd.id = SCAN_OFFLOAD_REQUEST_CMD;
@@ -1369,10 +1365,7 @@ void iwl_mvm_rx_umac_scan_iter_complete_notif(struct iwl_mvm *mvm,
 
 static int iwl_mvm_umac_scan_abort(struct iwl_mvm *mvm, int type)
 {
-	struct iwl_umac_scan_abort cmd = {
-		.hdr.size = cpu_to_le16(sizeof(struct iwl_umac_scan_abort) -
-					sizeof(struct iwl_mvm_umac_cmd_hdr)),
-	};
+	struct iwl_umac_scan_abort cmd = {};
 	int uid, ret;
 
 	lockdep_assert_held(&mvm->mutex);
@@ -1389,7 +1382,10 @@ static int iwl_mvm_umac_scan_abort(struct iwl_mvm *mvm, int type)
 
 	IWL_DEBUG_SCAN(mvm, "Sending scan abort, uid %u\n", uid);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_UMAC, 0, sizeof(cmd), &cmd);
+	ret = iwl_mvm_send_cmd_pdu(mvm,
+				   iwl_cmd_id(SCAN_ABORT_UMAC,
+					      IWL_ALWAYS_LONG_GROUP, 0),
+				   0, sizeof(cmd), &cmd);
 	if (!ret)
 		mvm->scan_uid_status[uid] = type << IWL_MVM_SCAN_STOPPING_SHIFT;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/tof.c b/drivers/net/wireless/iwlwifi/mvm/tof.c
index 5a8e96f..d060e12 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tof.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tof.c
@@ -74,33 +74,21 @@ void iwl_mvm_tof_init(struct iwl_mvm *mvm)
 
 	memset(tof_data, 0, sizeof(*tof_data));
 
-	tof_data->tof_cfg.hdr.size =
-		cpu_to_le16(sizeof(struct iwl_tof_config_cmd) -
-			    sizeof(struct iwl_mvm_umac_cmd_hdr));
 	tof_data->tof_cfg.sub_grp_cmd_id = cpu_to_le32(TOF_CONFIG_CMD);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	if (IWL_MVM_TOF_IS_RESPONDER) {
-		tof_data->responder_cfg.hdr.size =
-			cpu_to_le16(sizeof(struct iwl_tof_responder_config_cmd) -
-				    sizeof(struct iwl_mvm_umac_cmd_hdr));
 		tof_data->responder_cfg.sub_grp_cmd_id =
 			cpu_to_le32(TOF_RESPONDER_CONFIG_CMD);
 		tof_data->responder_cfg.sta_id = IWL_MVM_STATION_COUNT;
 	}
 #endif
 
-	tof_data->range_req.hdr.size =
-		cpu_to_le16(sizeof(struct iwl_tof_range_req_cmd) -
-			    sizeof(struct iwl_mvm_umac_cmd_hdr));
 	tof_data->range_req.sub_grp_cmd_id = cpu_to_le32(TOF_RANGE_REQ_CMD);
 	tof_data->range_req.req_timeout = 1;
 	tof_data->range_req.initiator = 1;
 	tof_data->range_req.report_policy = 3;
 
-	tof_data->range_req_ext.hdr.size =
-		cpu_to_le16(sizeof(struct iwl_tof_range_req_ext_cmd) -
-			    sizeof(struct iwl_mvm_umac_cmd_hdr));
 	tof_data->range_req_ext.sub_grp_cmd_id =
 		cpu_to_le32(TOF_RANGE_REQ_EXT_CMD);
 
@@ -147,15 +135,15 @@ int iwl_mvm_tof_config_cmd(struct iwl_mvm *mvm)
 	}
 
 	mvm->tof_data.active_range_request = IWL_MVM_TOF_RANGE_REQ_MAX_ID;
-	return iwl_mvm_send_cmd_pdu(mvm, TOF_CMD, 0, sizeof(*cmd), cmd);
+	return iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(TOF_CMD,
+						    IWL_ALWAYS_LONG_GROUP, 0),
+				    0, sizeof(*cmd), cmd);
 }
 
 int iwl_mvm_tof_range_abort_cmd(struct iwl_mvm *mvm, u8 id)
 {
 	struct iwl_tof_range_abort_cmd cmd = {
 		.sub_grp_cmd_id = cpu_to_le32(TOF_RANGE_ABORT_CMD),
-		.hdr.size = cpu_to_le16(sizeof(struct iwl_tof_range_abort_cmd) -
-					sizeof(struct iwl_mvm_umac_cmd_hdr)),
 		.request_id = id,
 	};
 
@@ -173,7 +161,9 @@ int iwl_mvm_tof_range_abort_cmd(struct iwl_mvm *mvm, u8 id)
 	/* after abort is sent there's no active request anymore */
 	mvm->tof_data.active_range_request = IWL_MVM_TOF_RANGE_REQ_MAX_ID;
 
-	return iwl_mvm_send_cmd_pdu(mvm, TOF_CMD, 0, sizeof(cmd), &cmd);
+	return iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(TOF_CMD,
+						    IWL_ALWAYS_LONG_GROUP, 0),
+				    0, sizeof(cmd), &cmd);
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
@@ -194,7 +184,9 @@ int iwl_mvm_tof_responder_cmd(struct iwl_mvm *mvm,
 	}
 
 	cmd->sta_id = mvmvif->bcast_sta.sta_id;
-	return iwl_mvm_send_cmd_pdu(mvm, TOF_CMD, 0, sizeof(*cmd), cmd);
+	return iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(TOF_CMD,
+						    IWL_ALWAYS_LONG_GROUP, 0),
+				    0, sizeof(*cmd), cmd);
 }
 #endif
 
@@ -245,8 +237,9 @@ int iwl_mvm_tof_range_request_ext_cmd(struct iwl_mvm *mvm,
 		return -EIO;
 	}
 
-	return iwl_mvm_send_cmd_pdu(mvm, TOF_CMD, 0,
-				    sizeof(mvm->tof_data.range_req_ext),
+	return iwl_mvm_send_cmd_pdu(mvm, iwl_cmd_id(TOF_CMD,
+						    IWL_ALWAYS_LONG_GROUP, 0),
+				    0, sizeof(mvm->tof_data.range_req_ext),
 				    &mvm->tof_data.range_req_ext);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 3a5d54e..601eee1 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1328,7 +1328,8 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 	const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 	u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
 
-	if (WARN(!trans_pcie->wide_cmd_header && group_id != 0,
+	if (WARN(!trans_pcie->wide_cmd_header &&
+		 group_id > IWL_ALWAYS_LONG_GROUP,
 		 "unsupported wide command %#x\n", cmd->id))
 		return -EINVAL;
 
-- 
2.1.4

