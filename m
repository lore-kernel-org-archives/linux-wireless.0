Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50212 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S941512AbcJSPS2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 11:18:28 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 13:07:50 +0300
Message-Id: <20161019100755.23874-6-luca@coelho.fi> (sfid-20161019_171833_540529_0C142B7E)
In-Reply-To: <20161019100755.23874-1-luca@coelho.fi>
References: <20161019100755.23874-1-luca@coelho.fi>
Subject: [PATCH 05/10] iwlwifi: mvm: use firmware station PM notification for AP_LINK_PS
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When using RSS on 9000 series devices, we can't rely on processing the
received frames for station powersave handling, since they could be
processed on different CPUs and out of order.

In order to still manage the powersave of stations, the firmware sends
a notification on sleep->wake, wake->sleep and - for U-APSD - frames
received with PM while already sleeping (with the TID.)

With this, the driver can set AP_LINK_PS, which is required for real
parallel RX. In addition, this requires checking for PS-Poll frames
and calling ieee80211_sta_pspoll() appropriately.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h | 26 ++++++++
 .../net/wireless/intel/iwlwifi/mvm/fw-api-sta.h    |  9 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 70 ++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  3 +
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 13 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |  1 +
 9 files changed, 119 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index ceec5ca..1ad0ec1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -293,6 +293,7 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  *	is supported.
  * @IWL_UCODE_TLV_CAPA_BT_COEX_RRC: supports BT Coex RRC
  * @IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT: supports gscan
+ * @IWL_UCODE_TLV_CAPA_STA_PM_NOTIF: firmware will send STA PM notification
  * @IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE: extended DTS measurement
  * @IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS: supports short PM timeouts
  * @IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT: supports bt-coex Multi-priority LUT
@@ -342,6 +343,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_LAR_MULTI_MCC		= (__force iwl_ucode_tlv_capa_t)29,
 	IWL_UCODE_TLV_CAPA_BT_COEX_RRC			= (__force iwl_ucode_tlv_capa_t)30,
 	IWL_UCODE_TLV_CAPA_GSCAN_SUPPORT		= (__force iwl_ucode_tlv_capa_t)31,
+	IWL_UCODE_TLV_CAPA_STA_PM_NOTIF			= (__force iwl_ucode_tlv_capa_t)38,
 	IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE		= (__force iwl_ucode_tlv_capa_t)64,
 	IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS		= (__force iwl_ucode_tlv_capa_t)65,
 	IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT		= (__force iwl_ucode_tlv_capa_t)67,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
index acc5cd5..b530fa4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h
@@ -474,4 +474,30 @@ struct iwl_mvm_internal_rxq_notif {
 	u8 data[];
 } __packed;
 
+/**
+ * enum iwl_mvm_pm_event - type of station PM event
+ * @IWL_MVM_PM_EVENT_AWAKE: station woke up
+ * @IWL_MVM_PM_EVENT_ASLEEP: station went to sleep
+ * @IWL_MVM_PM_EVENT_UAPSD: station sent uAPSD trigger
+ * @IWL_MVM_PM_EVENT_PS_POLL: station sent PS-Poll
+ */
+enum iwl_mvm_pm_event {
+	IWL_MVM_PM_EVENT_AWAKE,
+	IWL_MVM_PM_EVENT_ASLEEP,
+	IWL_MVM_PM_EVENT_UAPSD,
+	IWL_MVM_PM_EVENT_PS_POLL,
+}; /* PEER_PM_NTFY_API_E_VER_1 */
+
+/**
+ * struct iwl_mvm_pm_state_notification - station PM state notification
+ * @sta_id: station ID of the station changing state
+ * @type: the new powersave state, see IWL_MVM_PM_EVENT_ above
+ */
+struct iwl_mvm_pm_state_notification {
+	u8 sta_id;
+	u8 type;
+	/* private: */
+	u16 reserved;
+} __packed; /* PEER_PM_NTFY_API_S_VER_1 */
+
 #endif /* __fw_api_rx_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
index 6c8e3ca..3b5150e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
@@ -179,7 +179,7 @@ enum iwl_sta_key_flag {
  * enum iwl_sta_modify_flag - indicate to the fw what flag are being changed
  * @STA_MODIFY_QUEUE_REMOVAL: this command removes a queue
  * @STA_MODIFY_TID_DISABLE_TX: this command modifies %tid_disable_tx
- * @STA_MODIFY_TX_RATE: unused
+ * @STA_MODIFY_UAPSD_ACS: this command modifies %uapsd_trigger_acs
  * @STA_MODIFY_ADD_BA_TID: this command modifies %add_immediate_ba_tid
  * @STA_MODIFY_REMOVE_BA_TID: this command modifies %remove_immediate_ba_tid
  * @STA_MODIFY_SLEEPING_STA_TX_COUNT: this command modifies %sleep_tx_count
@@ -189,7 +189,7 @@ enum iwl_sta_key_flag {
 enum iwl_sta_modify_flag {
 	STA_MODIFY_QUEUE_REMOVAL		= BIT(0),
 	STA_MODIFY_TID_DISABLE_TX		= BIT(1),
-	STA_MODIFY_TX_RATE			= BIT(2),
+	STA_MODIFY_UAPSD_ACS			= BIT(2),
 	STA_MODIFY_ADD_BA_TID			= BIT(3),
 	STA_MODIFY_REMOVE_BA_TID		= BIT(4),
 	STA_MODIFY_SLEEPING_STA_TX_COUNT	= BIT(5),
@@ -353,6 +353,8 @@ struct iwl_mvm_add_sta_cmd_v7 {
  * @beamform_flags: beam forming controls
  * @tfd_queue_msk: tfd queues used by this station
  * @rx_ba_window: aggregation window size
+ * @scd_queue_bank: queue bank in used. Each bank contains 32 queues. 0 means
+ *	that the queues used by this station are in the first 32.
  *
  * The device contains an internal table of per-station information, with info
  * on security keys, aggregation parameters, and Tx rates for initial Tx
@@ -382,7 +384,8 @@ struct iwl_mvm_add_sta_cmd {
 	__le16 beamform_flags;
 	__le32 tfd_queue_msk;
 	__le16 rx_ba_window;
-	__le16 reserved;
+	u8 scd_queue_bank;
+	u8 uapsd_trigger_acs;
 } __packed; /* ADD_STA_CMD_API_S_VER_8 */
 
 /**
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 9763369..ae12bad 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -332,6 +332,7 @@ enum iwl_data_path_subcmd_ids {
 	DQA_ENABLE_CMD = 0x0,
 	UPDATE_MU_GROUPS_CMD = 0x1,
 	TRIGGER_RX_QUEUES_NOTIF_CMD = 0x2,
+	STA_PM_NOTIF = 0xFD,
 	MU_GROUP_MGMT_NOTIF = 0xFE,
 	RX_QUEUES_NOTIFICATION = 0xFF,
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 318efd8..9eeb2c3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -445,6 +445,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ieee80211_hw_set(hw, NEEDS_UNIQUE_STA_ADDR);
 	if (iwl_mvm_has_new_rx_api(mvm))
 		ieee80211_hw_set(hw, SUPPORTS_REORDERING_BUFFER);
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_STA_PM_NOTIF))
+		ieee80211_hw_set(hw, AP_LINK_PS);
 
 	if (mvm->trans->num_rx_queues > 1)
 		ieee80211_hw_set(hw, USES_RSS);
@@ -2318,10 +2320,9 @@ iwl_mvm_mac_release_buffered_frames(struct ieee80211_hw *hw,
 					  tids, more_data, true);
 }
 
-static void iwl_mvm_mac_sta_notify(struct ieee80211_hw *hw,
-				   struct ieee80211_vif *vif,
-				   enum sta_notify_cmd cmd,
-				   struct ieee80211_sta *sta)
+static void __iwl_mvm_mac_sta_notify(struct ieee80211_hw *hw,
+				     enum sta_notify_cmd cmd,
+				     struct ieee80211_sta *sta)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
@@ -2374,6 +2375,67 @@ static void iwl_mvm_mac_sta_notify(struct ieee80211_hw *hw,
 	spin_unlock_bh(&mvmsta->lock);
 }
 
+static void iwl_mvm_mac_sta_notify(struct ieee80211_hw *hw,
+				   struct ieee80211_vif *vif,
+				   enum sta_notify_cmd cmd,
+				   struct ieee80211_sta *sta)
+{
+	__iwl_mvm_mac_sta_notify(hw, cmd, sta);
+}
+
+void iwl_mvm_sta_pm_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_mvm_pm_state_notification *notif = (void *)pkt->data;
+	struct ieee80211_sta *sta;
+	struct iwl_mvm_sta *mvmsta;
+	bool sleeping = (notif->type != IWL_MVM_PM_EVENT_AWAKE);
+
+	if (WARN_ON(notif->sta_id >= ARRAY_SIZE(mvm->fw_id_to_mac_id)))
+		return;
+
+	rcu_read_lock();
+	sta = mvm->fw_id_to_mac_id[notif->sta_id];
+	if (WARN_ON(IS_ERR_OR_NULL(sta))) {
+		rcu_read_unlock();
+		return;
+	}
+
+	mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+	if (!mvmsta->vif ||
+	    mvmsta->vif->type != NL80211_IFTYPE_AP) {
+		rcu_read_unlock();
+		return;
+	}
+
+	if (mvmsta->sleeping != sleeping) {
+		mvmsta->sleeping = sleeping;
+		__iwl_mvm_mac_sta_notify(mvm->hw,
+			sleeping ? STA_NOTIFY_SLEEP : STA_NOTIFY_AWAKE,
+			sta);
+		ieee80211_sta_ps_transition(sta, sleeping);
+	}
+
+	if (sleeping) {
+		switch (notif->type) {
+		case IWL_MVM_PM_EVENT_AWAKE:
+		case IWL_MVM_PM_EVENT_ASLEEP:
+			break;
+		case IWL_MVM_PM_EVENT_UAPSD:
+			ieee80211_sta_uapsd_trigger(sta, IEEE80211_NUM_TIDS);
+			break;
+		case IWL_MVM_PM_EVENT_PS_POLL:
+			ieee80211_sta_pspoll(sta);
+			break;
+		default:
+			break;
+		}
+	}
+
+	rcu_read_unlock();
+}
+
 static void iwl_mvm_sta_pre_rcu_remove(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index d17cbf6..726ba48 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1418,6 +1418,7 @@ void iwl_mvm_rx_stored_beacon_notif(struct iwl_mvm *mvm,
 				    struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_mu_mimo_grp_notif(struct iwl_mvm *mvm,
 			       struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_sta_pm_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_window_status_notif(struct iwl_mvm *mvm,
 				 struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_mac_ctxt_recalc_tsf_id(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 05fe6dd..e86986f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -306,6 +306,8 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 		       iwl_mvm_rx_stored_beacon_notif, RX_HANDLER_SYNC),
 	RX_HANDLER_GRP(DATA_PATH_GROUP, MU_GROUP_MGMT_NOTIF,
 		       iwl_mvm_mu_mimo_grp_notif, RX_HANDLER_SYNC),
+	RX_HANDLER_GRP(DATA_PATH_GROUP, STA_PM_NOTIF,
+		       iwl_mvm_sta_pm_notif, RX_HANDLER_SYNC),
 };
 #undef RX_HANDLER
 #undef RX_HANDLER_GRP
@@ -452,6 +454,7 @@ static const struct iwl_hcmd_names iwl_mvm_phy_names[] = {
 static const struct iwl_hcmd_names iwl_mvm_data_path_names[] = {
 	HCMD_NAME(UPDATE_MU_GROUPS_CMD),
 	HCMD_NAME(TRIGGER_RX_QUEUES_NOTIF_CMD),
+	HCMD_NAME(STA_PM_NOTIF),
 	HCMD_NAME(MU_GROUP_MGMT_NOTIF),
 	HCMD_NAME(RX_QUEUES_NOTIFICATION),
 };
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 5ec1b96..82ee786 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -203,6 +203,19 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	add_sta_cmd.station_flags |=
 		cpu_to_le32(mpdu_dens << STA_FLG_AGG_MPDU_DENS_SHIFT);
 
+	if (sta->wme) {
+		add_sta_cmd.modify_mask |= STA_MODIFY_UAPSD_ACS;
+
+		if (sta->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BK)
+			add_sta_cmd.uapsd_trigger_acs |= BIT(AC_BK);
+		if (sta->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_BE)
+			add_sta_cmd.uapsd_trigger_acs |= BIT(AC_BE);
+		if (sta->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VI)
+			add_sta_cmd.uapsd_trigger_acs |= BIT(AC_VI);
+		if (sta->uapsd_queues & IEEE80211_WMM_IE_STA_QOSINFO_AC_VO)
+			add_sta_cmd.uapsd_trigger_acs |= BIT(AC_VO);
+	}
+
 	status = ADD_STA_SUCCESS;
 	ret = iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA,
 					  iwl_mvm_add_sta_cmd_size(mvm),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index e068d53..b45c7b9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -436,6 +436,7 @@ struct iwl_mvm_sta {
 
 	bool disable_tx;
 	bool tlc_amsdu;
+	bool sleeping;
 	u8 agg_tids;
 	u8 sleep_tx_count;
 	u8 avg_energy;
-- 
2.9.3
