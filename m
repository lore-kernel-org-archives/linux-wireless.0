Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:59098 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbcC3OFm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:05:42 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Aviya Erenfeld <aviya.erenfeld@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/43] iwlwifi: mvm: add LQM vendor command and notification
Date: Wed, 30 Mar 2016 17:04:37 +0300
Message-Id: <1459346715-7954-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160546_191238_11091B5A)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aviya Erenfeld <aviya.erenfeld@intel.com>

LQM stands for Link Quality Measurement. The firmware
will collect a defined set of statitics (see the
notification for details) that allow to know how busy
the medium is. The driver issues a request to the firmware
that includes the duration of the measurement (the firmware
needs to be on channel for that amount of time) and the
timeout (in case the firmware has a lot of offchannel
activities). If the timeout elapses, the firmware will
send partial results which are still valuable.
In case of disassociation / channel switch and alike, the
driver is in charge of stopping the measurements and the
firmware will reply with partial results.

The user space API for now is debugfs only and will be
implmemented in an upcoming patch.

Signed-off-by: Aviya Erenfeld <aviya.erenfeld@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h  |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h   | 62 ++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 10 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      | 12 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  9 +++
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c    | 71 +++++++++++++++++++++++
 6 files changed, 166 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 3a72b97..c82b9416 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -326,6 +326,7 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  *	regular image.
  * @IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG: support getting more shared
  *	memory addresses from the firmware.
+ * @IWL_UCODE_TLV_CAPA_LQM_SUPPORT: supports Link Quality Measurement
  *
  * @NUM_IWL_UCODE_TLV_CAPA: number of bits used
  */
@@ -364,6 +365,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_CTDP_SUPPORT			= (__force iwl_ucode_tlv_capa_t)76,
 	IWL_UCODE_TLV_CAPA_USNIFFER_UNIFIED		= (__force iwl_ucode_tlv_capa_t)77,
 	IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG	= (__force iwl_ucode_tlv_capa_t)80,
+	IWL_UCODE_TLV_CAPA_LQM_SUPPORT			= (__force iwl_ucode_tlv_capa_t)81,
 
 	NUM_IWL_UCODE_TLV_CAPA
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 61711b1..e6bd0c8 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -279,6 +279,11 @@ enum {
 /* Please keep this enum *SORTED* by hex value.
  * Needed for binary search, otherwise a warning will be triggered.
  */
+enum iwl_mac_conf_subcmd_ids {
+	LINK_QUALITY_MEASUREMENT_CMD = 0x1,
+	LINK_QUALITY_MEASUREMENT_COMPLETE_NOTIF = 0xFE,
+};
+
 enum iwl_phy_ops_subcmd_ids {
 	CMD_DTS_MEASUREMENT_TRIGGER_WIDE = 0x0,
 	CTDP_CONFIG_CMD = 0x03,
@@ -307,6 +312,7 @@ enum {
 	LEGACY_GROUP = 0x0,
 	LONG_GROUP = 0x1,
 	SYSTEM_GROUP = 0x2,
+	MAC_CONF_GROUP = 0x3,
 	PHY_OPS_GROUP = 0x4,
 	DATA_PATH_GROUP = 0x5,
 	PROT_OFFLOAD_GROUP = 0xb,
@@ -2017,4 +2023,60 @@ struct iwl_stored_beacon_notif {
 	u8 data[MAX_STORED_BEACON_SIZE];
 } __packed; /* WOWLAN_STROED_BEACON_INFO_S_VER_1 */
 
+#define LQM_NUMBER_OF_STATIONS_IN_REPORT 16
+
+enum iwl_lqm_cmd_operatrions {
+	LQM_CMD_OPERATION_START_MEASUREMENT = 0x01,
+	LQM_CMD_OPERATION_STOP_MEASUREMENT = 0x02,
+};
+
+enum iwl_lqm_status {
+	LQM_STATUS_SUCCESS = 0,
+	LQM_STATUS_TIMEOUT = 1,
+	LQM_STATUS_ABORT = 2,
+};
+
+/**
+ * Link Quality Measurement command
+ * @cmd_operatrion: command operation to be performed (start or stop)
+ *	as defined above.
+ * @mac_id: MAC ID the measurement applies to.
+ * @measurement_time: time of the total measurement to be performed, in uSec.
+ * @timeout: maximum time allowed until a response is sent, in uSec.
+ */
+struct iwl_link_qual_msrmnt_cmd {
+	__le32 cmd_operation;
+	__le32 mac_id;
+	__le32 measurement_time;
+	__le32 timeout;
+} __packed /* LQM_CMD_API_S_VER_1 */;
+
+/**
+ * Link Quality Measurement notification
+ *
+ * @frequent_stations_air_time: an array containing the total air time
+ *	(in uSec) used by the most frequently transmitting stations.
+ * @number_of_stations: the number of uniqe stations included in the array
+ *	(a number between 0 to 16)
+ * @total_air_time_other_stations: the total air time (uSec) used by all the
+ *	stations which are not included in the above report.
+ * @time_in_measurement_window: the total time in uSec in which a measurement
+ *	took place.
+ * @tx_frame_dropped: the number of TX frames dropped due to retry limit during
+ *	measurement
+ * @mac_id: MAC ID the measurement applies to.
+ * @status: return status. may be one of the LQM_STATUS_* defined above.
+ * @reserved: reserved.
+ */
+struct iwl_link_qual_msrmnt_notif {
+	__le32 frequent_stations_air_time[LQM_NUMBER_OF_STATIONS_IN_REPORT];
+	__le32 number_of_stations;
+	__le32 total_air_time_other_stations;
+	__le32 time_in_measurement_window;
+	__le32 tx_frame_dropped;
+	__le32 mac_id;
+	__le32 status;
+	__le32 reserved[3];
+} __packed; /* LQM_MEASUREMENT_COMPLETE_NTF_API_S_VER1 */
+
 #endif /* __fw_api_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 76e649c..cff9c16 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1821,6 +1821,11 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 	if (changes & BSS_CHANGED_ASSOC && bss_conf->assoc)
 		iwl_mvm_mac_ctxt_recalc_tsf_id(mvm, vif);
 
+	if (changes & BSS_CHANGED_ASSOC && !bss_conf->assoc &&
+	    mvmvif->lqm_active)
+		iwl_mvm_send_lqm_cmd(vif, LQM_CMD_OPERATION_STOP_MEASUREMENT,
+				     0, 0);
+
 	/*
 	 * If we're not associated yet, take the (new) BSSID before associating
 	 * so the firmware knows. If we're already associated, then use the old
@@ -3628,6 +3633,11 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 
 		break;
 	case NL80211_IFTYPE_STATION:
+		if (mvmvif->lqm_active)
+			iwl_mvm_send_lqm_cmd(vif,
+					     LQM_CMD_OPERATION_STOP_MEASUREMENT,
+					     0, 0);
+
 		/* Schedule the time event to a bit before beacon 1,
 		 * to make sure we're in the new channel when the
 		 * GO/AP arrives.
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 6c67c0f..0668601 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -453,6 +453,12 @@ struct iwl_mvm_vif {
 
 	/* TCP Checksum Offload */
 	netdev_features_t features;
+
+	/*
+	 * link quality measurement - used to check whether this interface
+	 * is in the middle of a link quality measurement
+	 */
+	bool lqm_active;
 };
 
 static inline struct iwl_mvm_vif *
@@ -1637,4 +1643,10 @@ unsigned int iwl_mvm_get_wd_timeout(struct iwl_mvm *mvm,
 void iwl_mvm_connection_loss(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			     const char *errmsg);
 
+/* Link Quality Measurement */
+int iwl_mvm_send_lqm_cmd(struct ieee80211_vif *vif,
+			 enum iwl_lqm_cmd_operatrions operation,
+			 u32 duration, u32 timeout);
+bool iwl_mvm_lqm_active(struct iwl_mvm *mvm);
+
 #endif /* __IWL_MVM_H__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index ccf6ecd..46a22fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -428,6 +428,14 @@ static const struct iwl_hcmd_names iwl_mvm_system_names[] = {
 /* Please keep this array *SORTED* by hex value.
  * Access is done through binary search
  */
+static const struct iwl_hcmd_names iwl_mvm_mac_conf_names[] = {
+	HCMD_NAME(LINK_QUALITY_MEASUREMENT_CMD),
+	HCMD_NAME(LINK_QUALITY_MEASUREMENT_COMPLETE_NOTIF),
+};
+
+/* Please keep this array *SORTED* by hex value.
+ * Access is done through binary search
+ */
 static const struct iwl_hcmd_names iwl_mvm_phy_names[] = {
 	HCMD_NAME(CMD_DTS_MEASUREMENT_TRIGGER_WIDE),
 	HCMD_NAME(CTDP_CONFIG_CMD),
@@ -457,6 +465,7 @@ static const struct iwl_hcmd_arr iwl_mvm_groups[] = {
 	[LEGACY_GROUP] = HCMD_ARR(iwl_mvm_legacy_names),
 	[LONG_GROUP] = HCMD_ARR(iwl_mvm_legacy_names),
 	[SYSTEM_GROUP] = HCMD_ARR(iwl_mvm_system_names),
+	[MAC_CONF_GROUP] = HCMD_ARR(iwl_mvm_mac_conf_names),
 	[PHY_OPS_GROUP] = HCMD_ARR(iwl_mvm_phy_names),
 	[DATA_PATH_GROUP] = HCMD_ARR(iwl_mvm_data_path_names),
 	[PROT_OFFLOAD_GROUP] = HCMD_ARR(iwl_mvm_prot_offload_names),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 53cdc57..2440248 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1079,3 +1079,74 @@ void iwl_mvm_connection_loss(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 out:
 	ieee80211_connection_loss(vif);
 }
+
+int iwl_mvm_send_lqm_cmd(struct ieee80211_vif *vif,
+			 enum iwl_lqm_cmd_operatrions operation,
+			 u32 duration, u32 timeout)
+{
+	struct iwl_mvm_vif *mvm_vif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_link_qual_msrmnt_cmd cmd = {
+		.cmd_operation = cpu_to_le32(operation),
+		.mac_id = cpu_to_le32(mvm_vif->id),
+		.measurement_time = cpu_to_le32(duration),
+		.timeout = cpu_to_le32(timeout),
+	};
+	u32 cmdid =
+		iwl_cmd_id(LINK_QUALITY_MEASUREMENT_CMD, MAC_CONF_GROUP, 0);
+	int ret;
+
+	if (!fw_has_capa(&mvm_vif->mvm->fw->ucode_capa,
+			 IWL_UCODE_TLV_CAPA_LQM_SUPPORT))
+		return -EOPNOTSUPP;
+
+	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
+		return -EINVAL;
+
+	switch (operation) {
+	case LQM_CMD_OPERATION_START_MEASUREMENT:
+		if (iwl_mvm_lqm_active(mvm_vif->mvm))
+			return -EBUSY;
+		if (!vif->bss_conf.assoc)
+			return -EINVAL;
+		mvm_vif->lqm_active = true;
+		break;
+	case LQM_CMD_OPERATION_STOP_MEASUREMENT:
+		if (!iwl_mvm_lqm_active(mvm_vif->mvm))
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ret = iwl_mvm_send_cmd_pdu(mvm_vif->mvm, cmdid, 0, sizeof(cmd),
+				   &cmd);
+
+	/* command failed - roll back lqm_active state */
+	if (ret) {
+		mvm_vif->lqm_active =
+			operation == LQM_CMD_OPERATION_STOP_MEASUREMENT;
+	}
+
+	return ret;
+}
+
+static void iwl_mvm_lqm_active_iterator(void *_data, u8 *mac,
+					struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvm_vif = iwl_mvm_vif_from_mac80211(vif);
+	bool *lqm_active = _data;
+
+	*lqm_active = *lqm_active || mvm_vif->lqm_active;
+}
+
+bool iwl_mvm_lqm_active(struct iwl_mvm *mvm)
+{
+	bool ret = false;
+
+	lockdep_assert_held(&mvm->mutex);
+	ieee80211_iterate_active_interfaces_atomic(
+		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+		iwl_mvm_lqm_active_iterator, &ret);
+
+	return ret;
+}
-- 
2.5.0

