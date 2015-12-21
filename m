Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:53947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751423AbbLUUw1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 15:52:27 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/45] iwlwifi: mvm: add extended dwell time
Date: Mon, 21 Dec 2015 22:50:35 +0200
Message-Id: <1450731046-2796-34-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151221_220100_341792_786FCA5D)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E949792@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

When doing active scan on crowded channels we are likely to miss probe
responses due to collisions. To overcome this issue we use an extended
dwell time on channels 1, 6 and 11; this dwell time is set to 100.

In case of fragmented scan extended dwell time is the maximum out of
channel time - 44 msec. Fragmented active scan will be addressed later.

Extended dwell time isn't used in sched scan or p2p find.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/fw-api-scan.h   | 22 +++++++-----
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 41 ++++++++++++++++------
 2 files changed, 45 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
index d92712d..f01dab0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-scan.h
@@ -285,6 +285,8 @@ struct iwl_scan_channel_opt {
  * @IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED: all passive scans will be fragmented
  * @IWL_MVM_LMAC_SCAN_FLAGS_RRM_ENABLED: insert WFA vendor-specific TPC report
  *	and DS parameter set IEs into probe requests.
+ * @IWL_MVM_LMAC_SCAN_FLAG_EXTENDED_DWELL: use extended dwell time on channels
+ *	1, 6 and 11.
  * @IWL_MVM_LMAC_SCAN_FLAG_MATCH: Send match found notification on matches
  */
 enum iwl_mvm_lmac_scan_flags {
@@ -295,6 +297,7 @@ enum iwl_mvm_lmac_scan_flags {
 	IWL_MVM_LMAC_SCAN_FLAG_MULTIPLE_SSIDS	= BIT(4),
 	IWL_MVM_LMAC_SCAN_FLAG_FRAGMENTED	= BIT(5),
 	IWL_MVM_LMAC_SCAN_FLAGS_RRM_ENABLED	= BIT(6),
+	IWL_MVM_LMAC_SCAN_FLAG_EXTENDED_DWELL	= BIT(7),
 	IWL_MVM_LMAC_SCAN_FLAG_MATCH		= BIT(9),
 };
 
@@ -322,6 +325,7 @@ enum iwl_scan_priority_ext {
  * @active-dwell: dwell time for active channels
  * @passive-dwell: dwell time for passive channels
  * @fragmented-dwell: dwell time for fragmented passive scan
+ * @extended_dwell: dwell time for channels 1, 6 and 11 (in certain cases)
  * @reserved2: for alignment and future use
  * @rx_chain_selct: PHY_RX_CHAIN_* flags
  * @scan_flags: &enum iwl_mvm_lmac_scan_flags
@@ -346,7 +350,8 @@ struct iwl_scan_req_lmac {
 	u8 active_dwell;
 	u8 passive_dwell;
 	u8 fragmented_dwell;
-	__le16 reserved2;
+	u8 extended_dwell;
+	u8 reserved2;
 	__le16 rx_chain_select;
 	__le32 scan_flags;
 	__le32 max_out_time;
@@ -490,7 +495,7 @@ enum iwl_channel_flags {
  * @dwell_active:		default dwell time for active scan
  * @dwell_passive:		default dwell time for passive scan
  * @dwell_fragmented:		default dwell time for fragmented scan
- * @reserved:			for future use and alignment
+ * @dwell_extended:		default dwell time for channels 1, 6 and 11
  * @mac_addr:			default mac address to be used in probes
  * @bcast_sta_id:		the index of the station in the fw
  * @channel_flags:		default channel flags - enum iwl_channel_flags
@@ -507,7 +512,7 @@ struct iwl_scan_config {
 	u8 dwell_active;
 	u8 dwell_passive;
 	u8 dwell_fragmented;
-	u8 reserved;
+	u8 dwell_extended;
 	u8 mac_addr[ETH_ALEN];
 	u8 bcast_sta_id;
 	u8 channel_flags;
@@ -543,7 +548,8 @@ enum iwl_umac_scan_general_flags {
 	IWL_UMAC_SCAN_GEN_FLAGS_MULTIPLE_SSID	= BIT(6),
 	IWL_UMAC_SCAN_GEN_FLAGS_FRAGMENTED	= BIT(7),
 	IWL_UMAC_SCAN_GEN_FLAGS_RRM_ENABLED	= BIT(8),
-	IWL_UMAC_SCAN_GEN_FLAGS_MATCH		= BIT(9)
+	IWL_UMAC_SCAN_GEN_FLAGS_MATCH		= BIT(9),
+	IWL_UMAC_SCAN_GEN_FLAGS_EXTENDED_DWELL	= BIT(10),
 };
 
 /**
@@ -597,7 +603,7 @@ struct iwl_scan_req_umac_tail {
  * @uid: scan id, &enum iwl_umac_scan_uid_offsets
  * @ooc_priority: out of channel priority - &enum iwl_scan_priority
  * @general_flags: &enum iwl_umac_scan_general_flags
- * @reserved1: for future use and alignment
+ * @extended_dwell: dwell time for channels 1, 6 and 11
  * @active_dwell: dwell time for active scan
  * @passive_dwell: dwell time for passive scan
  * @fragmented_dwell: dwell time for fragmented passive scan
@@ -606,7 +612,7 @@ struct iwl_scan_req_umac_tail {
  * @scan_priority: scan internal prioritization &enum iwl_scan_priority
  * @channel_flags: &enum iwl_scan_channel_flags
  * @n_channels: num of channels in scan request
- * @reserved2: for future use and alignment
+ * @reserved: for future use and alignment
  * @data: &struct iwl_scan_channel_cfg_umac and
  *	&struct iwl_scan_req_umac_tail
  */
@@ -616,7 +622,7 @@ struct iwl_scan_req_umac {
 	__le32 ooc_priority;
 	/* SCAN_GENERAL_PARAMS_API_S_VER_1 */
 	__le32 general_flags;
-	u8 reserved1;
+	u8 extended_dwell;
 	u8 active_dwell;
 	u8 passive_dwell;
 	u8 fragmented_dwell;
@@ -626,7 +632,7 @@ struct iwl_scan_req_umac {
 	/* SCAN_CHANNEL_PARAMS_API_S_VER_1 */
 	u8 channel_flags;
 	u8 n_channels;
-	__le16 reserved2;
+	__le16 reserved;
 	u8 data[];
 } __packed; /* SCAN_REQUEST_CMD_UMAC_API_S_VER_1 */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 87cc993..bee3201 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -82,6 +82,7 @@ struct iwl_mvm_scan_timing_params {
 	u32 dwell_active;
 	u32 dwell_passive;
 	u32 dwell_fragmented;
+	u32 dwell_extended;
 	u32 suspend_time;
 	u32 max_out_time;
 };
@@ -91,6 +92,7 @@ static struct iwl_mvm_scan_timing_params scan_timing[] = {
 		.dwell_active = 10,
 		.dwell_passive = 110,
 		.dwell_fragmented = 44,
+		.dwell_extended = 100,
 		.suspend_time = 0,
 		.max_out_time = 0,
 	},
@@ -98,6 +100,7 @@ static struct iwl_mvm_scan_timing_params scan_timing[] = {
 		.dwell_active = 10,
 		.dwell_passive = 110,
 		.dwell_fragmented = 44,
+		.dwell_extended = 100,
 		.suspend_time = 30,
 		.max_out_time = 120,
 	},
@@ -105,6 +108,7 @@ static struct iwl_mvm_scan_timing_params scan_timing[] = {
 		.dwell_active = 10,
 		.dwell_passive = 110,
 		.dwell_fragmented = 44,
+		.dwell_extended = 100,
 		.suspend_time = 120,
 		.max_out_time = 120,
 	},
@@ -112,6 +116,7 @@ static struct iwl_mvm_scan_timing_params scan_timing[] = {
 		.dwell_active = 10,
 		.dwell_passive = 110,
 		.dwell_fragmented = 44,
+		.dwell_extended = 44,
 		.suspend_time = 95,
 		.max_out_time = 44,
 	},
@@ -716,6 +721,7 @@ static void iwl_mvm_scan_lmac_dwell(struct iwl_mvm *mvm,
 	cmd->active_dwell = scan_timing[params->type].dwell_active;
 	cmd->passive_dwell = scan_timing[params->type].dwell_passive;
 	cmd->fragmented_dwell = scan_timing[params->type].dwell_fragmented;
+	cmd->extended_dwell = scan_timing[params->type].dwell_extended;
 	cmd->max_out_time = cpu_to_le32(scan_timing[params->type].max_out_time);
 	cmd->suspend_time = cpu_to_le32(scan_timing[params->type].suspend_time);
 	cmd->scan_prio = iwl_mvm_scan_priority(mvm, IWL_SCAN_PRIORITY_EXT_6);
@@ -749,8 +755,15 @@ static inline bool iwl_mvm_scan_use_ebs(struct iwl_mvm *mvm,
 		vif->type != NL80211_IFTYPE_P2P_DEVICE);
 }
 
+static inline bool iwl_mvm_is_regular_scan(struct iwl_mvm_scan_params *params)
+{
+	return params->n_scan_plans == 1 &&
+		params->scan_plans[0].iterations == 1;
+}
+
 static int iwl_mvm_scan_lmac_flags(struct iwl_mvm *mvm,
-				   struct iwl_mvm_scan_params *params)
+				   struct iwl_mvm_scan_params *params,
+				   struct ieee80211_vif *vif)
 {
 	int flags = 0;
 
@@ -776,6 +789,10 @@ static int iwl_mvm_scan_lmac_flags(struct iwl_mvm *mvm,
 		flags |= IWL_MVM_LMAC_SCAN_FLAG_ITER_COMPLETE;
 #endif
 
+	if (iwl_mvm_is_regular_scan(params) &&
+	    vif->type != NL80211_IFTYPE_P2P_DEVICE)
+		flags |= IWL_MVM_LMAC_SCAN_FLAG_EXTENDED_DWELL;
+
 	return flags;
 }
 
@@ -804,7 +821,8 @@ static int iwl_mvm_scan_lmac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 
 	cmd->delay = cpu_to_le32(params->delay);
 
-	cmd->scan_flags = cpu_to_le32(iwl_mvm_scan_lmac_flags(mvm, params));
+	cmd->scan_flags = cpu_to_le32(iwl_mvm_scan_lmac_flags(mvm, params,
+							      vif));
 
 	cmd->flags = iwl_mvm_scan_rxon_flags(params->channels[0]->band);
 	cmd->filter_flags = cpu_to_le32(MAC_FILTER_ACCEPT_GRP |
@@ -942,6 +960,7 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 	scan_config->dwell_active = scan_timing[type].dwell_active;
 	scan_config->dwell_passive = scan_timing[type].dwell_passive;
 	scan_config->dwell_fragmented = scan_timing[type].dwell_fragmented;
+	scan_config->dwell_extended = scan_timing[type].dwell_extended;
 
 	memcpy(&scan_config->mac_addr, &mvm->addresses[0].addr, ETH_ALEN);
 
@@ -983,16 +1002,11 @@ static int iwl_mvm_scan_uid_by_status(struct iwl_mvm *mvm, int status)
 	return -ENOENT;
 }
 
-static inline bool iwl_mvm_is_regular_scan(struct iwl_mvm_scan_params *params)
-{
-	return params->n_scan_plans == 1 &&
-		params->scan_plans[0].iterations == 1;
-}
-
 static void iwl_mvm_scan_umac_dwell(struct iwl_mvm *mvm,
 				    struct iwl_scan_req_umac *cmd,
 				    struct iwl_mvm_scan_params *params)
 {
+	cmd->extended_dwell = scan_timing[params->type].dwell_extended;
 	cmd->active_dwell = scan_timing[params->type].dwell_active;
 	cmd->passive_dwell = scan_timing[params->type].dwell_passive;
 	cmd->fragmented_dwell = scan_timing[params->type].dwell_fragmented;
@@ -1027,7 +1041,8 @@ iwl_mvm_umac_scan_cfg_channels(struct iwl_mvm *mvm,
 }
 
 static u32 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
-				   struct iwl_mvm_scan_params *params)
+				   struct iwl_mvm_scan_params *params,
+				   struct ieee80211_vif *vif)
 {
 	int flags = 0;
 
@@ -1055,6 +1070,11 @@ static u32 iwl_mvm_scan_umac_flags(struct iwl_mvm *mvm,
 	if (mvm->scan_iter_notif_enabled)
 		flags |= IWL_UMAC_SCAN_GEN_FLAGS_ITER_COMPLETE;
 #endif
+
+	if (iwl_mvm_is_regular_scan(params) &&
+	    vif->type != NL80211_IFTYPE_P2P_DEVICE)
+		flags |= IWL_UMAC_SCAN_GEN_FLAGS_EXTENDED_DWELL;
+
 	return flags;
 }
 
@@ -1085,7 +1105,8 @@ static int iwl_mvm_scan_umac(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	mvm->scan_uid_status[uid] = type;
 
 	cmd->uid = cpu_to_le32(uid);
-	cmd->general_flags = cpu_to_le32(iwl_mvm_scan_umac_flags(mvm, params));
+	cmd->general_flags = cpu_to_le32(iwl_mvm_scan_umac_flags(mvm, params,
+								 vif));
 
 	if (type == IWL_MVM_SCAN_SCHED)
 		cmd->flags = cpu_to_le32(IWL_UMAC_SCAN_FLAG_PREEMPTIVE);
-- 
2.5.0

