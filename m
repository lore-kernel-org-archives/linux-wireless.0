Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54294 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1950225AbdDYU1T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:27:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:38 +0300
Message-Id: <20170425202243.7844-21-luca@coelho.fi> (sfid-20170425_222741_034571_5F16576C)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 20/25] iwlwifi: mvm: support station type API
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Support change to ADD_STA API to support station types.
Each station is assigned its type.
This simplifies FW handling of the broadcast and multicast
stations:
* broadcast station is identified by its type and not the mac
  address.
* multicast queue is no longer treated differently. The opening
  and closing of it is done by referring to its station.
  There is no need to specify it in the MAC command.
* When disabling TX to all station driver can disable the traffic
  on multicast station, so FW doesn't have to do it.
Change is backward compatible.
Change the order of adding and removing the stations according to
FW requirements.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |  2 +
 .../net/wireless/intel/iwlwifi/mvm/fw-api-mac.h    |  5 +-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-sta.h    | 24 ++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  |  6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 31 +++++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 84 +++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |  7 +-
 7 files changed, 132 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 287e83eb30d9..44419e82da1b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -243,6 +243,7 @@ typedef unsigned int __bitwise iwl_ucode_tlv_api_t;
  *	scan request.
  * @IWL_UCODE_TLV_API_TKIP_MIC_KEYS: This ucode supports version 2 of
  *	ADD_MODIFY_STA_KEY_API_S_VER_2.
+ * @IWL_UCODE_TLV_API_STA_TYPE: This ucode supports station type assignement.
  *
  * @NUM_IWL_UCODE_TLV_API: number of bits used
  */
@@ -253,6 +254,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_NEW_VERSION		= (__force iwl_ucode_tlv_api_t)20,
 	IWL_UCODE_TLV_API_SCAN_TSF_REPORT	= (__force iwl_ucode_tlv_api_t)28,
 	IWL_UCODE_TLV_API_TKIP_MIC_KEYS		= (__force iwl_ucode_tlv_api_t)29,
+	IWL_UCODE_TLV_API_STA_TYPE		= (__force iwl_ucode_tlv_api_t)30,
 
 	NUM_IWL_UCODE_TLV_API
 #ifdef __CHECKER__
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
index d3cdd889c85c..970b030ed28d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
@@ -157,7 +157,8 @@ enum iwl_tsf_id {
  * @bi_reciprocal: 2^32 / bi
  * @dtim_interval: dtim transmit time in TU
  * @dtim_reciprocal: 2^32 / dtim_interval
- * @mcast_qid: queue ID for multicast traffic
+ * @mcast_qid: queue ID for multicast traffic.
+ *	NOTE: obsolete from VER2 and on
  * @beacon_template: beacon template ID
  */
 struct iwl_mac_data_ap {
@@ -169,7 +170,7 @@ struct iwl_mac_data_ap {
 	__le32 dtim_reciprocal;
 	__le32 mcast_qid;
 	__le32 beacon_template;
-} __packed; /* AP_MAC_DATA_API_S_VER_1 */
+} __packed; /* AP_MAC_DATA_API_S_VER_2 */
 
 /**
  * struct iwl_mac_data_ibss - configuration data for IBSS MAC context
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
index a20ac4d9e63e..421b9dd1fb66 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-sta.h
@@ -310,6 +310,24 @@ struct iwl_mvm_add_sta_cmd_v7 {
 } __packed; /* ADD_STA_CMD_API_S_VER_7 */
 
 /**
+ * enum iwl_sta_type - FW station types
+ * ( REPLY_ADD_STA = 0x18 )
+ * @IWL_STA_LINK: Link station - normal RX and TX traffic.
+ * @IWL_STA_GENERAL_PURPOSE: General purpose. In AP mode used for beacons
+ *	and probe responses.
+ * @IWL_STA_MULTICAST: multicast traffic,
+ * @IWL_STA_TDLS_LINK: TDLS link station
+ * @IWL_STA_AUX_ACTIVITY: auxilary station (scan, ROC and so on).
+ */
+enum iwl_sta_type {
+	IWL_STA_LINK,
+	IWL_STA_GENERAL_PURPOSE,
+	IWL_STA_MULTICAST,
+	IWL_STA_TDLS_LINK,
+	IWL_STA_AUX_ACTIVITY,
+};
+
+/**
  * struct iwl_mvm_add_sta_cmd - Add/modify a station in the fw's sta table.
  * ( REPLY_ADD_STA = 0x18 )
  * @add_modify: 1: modify existing, 0: add new station
@@ -333,6 +351,7 @@ struct iwl_mvm_add_sta_cmd_v7 {
  * @sleep_tx_count: number of packets to transmit to station even though it is
  *	asleep. Used to synchronise PS-poll and u-APSD responses while ucode
  *	keeps track of STA sleep state.
+ * @station_type: type of this station. See &enum iwl_sta_type.
  * @sleep_state_flags: Look at %iwl_sta_sleep_flag.
  * @assoc_id: assoc_id to be sent in VHT PLCP (9-bit), for grp use 0, for AP
  *	mac-addr.
@@ -367,14 +386,15 @@ struct iwl_mvm_add_sta_cmd {
 	u8 remove_immediate_ba_tid;
 	__le16 add_immediate_ba_ssn;
 	__le16 sleep_tx_count;
-	__le16 sleep_state_flags;
+	u8 sleep_state_flags;
+	u8 station_type;
 	__le16 assoc_id;
 	__le16 beamform_flags;
 	__le32 tfd_queue_msk;
 	__le16 rx_ba_window;
 	u8 sp_length;
 	u8 uapsd_acs;
-} __packed; /* ADD_STA_CMD_API_S_VER_9 */
+} __packed; /* ADD_STA_CMD_API_S_VER_10 */
 
 /**
  * struct iwl_mvm_add_sta_key_common - add/modify sta key common part
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 2476af904f5e..0f1831b41915 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -907,7 +907,7 @@ static int iwl_mvm_mac_ctxt_cmd_listener(struct iwl_mvm *mvm,
 
 	/* Allocate sniffer station */
 	ret = iwl_mvm_allocate_int_sta(mvm, &mvm->snif_sta, tfd_queue_msk,
-				       vif->type);
+				       vif->type, IWL_STA_GENERAL_PURPOSE);
 	if (ret)
 		return ret;
 
@@ -1228,7 +1228,9 @@ static void iwl_mvm_mac_ctxt_cmd_fill_ap(struct iwl_mvm *mvm,
 		cpu_to_le32(iwl_mvm_reciprocal(vif->bss_conf.beacon_int *
 					       vif->bss_conf.dtim_period));
 
-	ctxt_ap->mcast_qid = cpu_to_le32(vif->cab_queue);
+	if (!fw_has_api(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_API_STA_TYPE))
+		ctxt_ap->mcast_qid = cpu_to_le32(vif->cab_queue);
 
 	/*
 	 * Only set the beacon time when the MAC is being added, when we
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 8ee5cf1419f4..c121982d781e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1358,7 +1358,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 			 * which shouldn't be in TFD mask anyway
 			 */
 			ret = iwl_mvm_allocate_int_sta(mvm, &mvmvif->mcast_sta,
-						       0, vif->type);
+						       0, vif->type,
+						       IWL_STA_MULTICAST);
 			if (ret)
 				goto out_release;
 		}
@@ -2111,15 +2112,15 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_remove;
 
-	/* Send the bcast station. At this stage the TBTT and DTIM time events
-	 * are added and applied to the scheduler */
-	ret = iwl_mvm_send_add_bcast_sta(mvm, vif);
+	ret = iwl_mvm_add_mcast_sta(mvm, vif);
 	if (ret)
 		goto out_unbind;
 
-	ret = iwl_mvm_add_mcast_sta(mvm, vif);
+	/* Send the bcast station. At this stage the TBTT and DTIM time events
+	 * are added and applied to the scheduler */
+	ret = iwl_mvm_send_add_bcast_sta(mvm, vif);
 	if (ret)
-		goto out_rm_bcast;
+		goto out_rm_mcast;
 
 	/* must be set before quota calculations */
 	mvmvif->ap_ibss_active = true;
@@ -2148,9 +2149,9 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 out_quota_failed:
 	iwl_mvm_power_update_mac(mvm);
 	mvmvif->ap_ibss_active = false;
-	iwl_mvm_rm_mcast_sta(mvm, vif);
-out_rm_bcast:
 	iwl_mvm_send_rm_bcast_sta(mvm, vif);
+out_rm_mcast:
+	iwl_mvm_rm_mcast_sta(mvm, vif);
 out_unbind:
 	iwl_mvm_binding_remove_vif(mvm, vif);
 out_remove:
@@ -2196,8 +2197,20 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 		iwl_mvm_mac_ctxt_changed(mvm, mvm->p2p_device_vif, false, NULL);
 
 	iwl_mvm_update_quotas(mvm, false, NULL);
-	iwl_mvm_rm_mcast_sta(mvm, vif);
+
+	/*
+	 * This is not very nice, but the simplest:
+	 * For older FWs removing the mcast sta before the bcast station may
+	 * cause assert 0x2b00.
+	 * This is fixed in later FW (which will stop beaconing when removing
+	 * bcast station).
+	 * So make the order of removal depend on the TLV
+	 */
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_STA_TYPE))
+		iwl_mvm_rm_mcast_sta(mvm, vif);
 	iwl_mvm_send_rm_bcast_sta(mvm, vif);
+	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_STA_TYPE))
+		iwl_mvm_rm_mcast_sta(mvm, vif);
 	iwl_mvm_binding_remove_vif(mvm, vif);
 
 	iwl_mvm_power_update_mac(mvm);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 3be7fc01b19f..d06ba5cb7297 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -77,9 +77,11 @@
  */
 static inline int iwl_mvm_add_sta_cmd_size(struct iwl_mvm *mvm)
 {
-	return iwl_mvm_has_new_rx_api(mvm) ?
-		sizeof(struct iwl_mvm_add_sta_cmd) :
-		sizeof(struct iwl_mvm_add_sta_cmd_v7);
+	if (iwl_mvm_has_new_rx_api(mvm) ||
+	    fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_STA_TYPE))
+		return sizeof(struct iwl_mvm_add_sta_cmd);
+	else
+		return sizeof(struct iwl_mvm_add_sta_cmd_v7);
 }
 
 static int iwl_mvm_find_free_sta_id(struct iwl_mvm *mvm,
@@ -126,6 +128,9 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	u32 status;
 	u32 agg_size = 0, mpdu_dens = 0;
 
+	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_STA_TYPE))
+		add_sta_cmd.station_type = mvm_sta->sta_type;
+
 	if (!update || (flags & STA_MODIFY_QUEUES)) {
 		memcpy(&add_sta_cmd.addr, sta->addr, ETH_ALEN);
 
@@ -1342,6 +1347,7 @@ int iwl_mvm_add_sta(struct iwl_mvm *mvm,
 	mvm_sta->max_agg_bufsize = LINK_QUAL_AGG_FRAME_LIMIT_DEF;
 	mvm_sta->tx_protection = 0;
 	mvm_sta->tt_tx_protection = false;
+	mvm_sta->sta_type = sta->tdls ? IWL_STA_TDLS_LINK : IWL_STA_LINK;
 
 	/* HW restart, don't assume the memory has been zeroed */
 	atomic_set(&mvm->pending_frames[sta_id], 0);
@@ -1725,7 +1731,8 @@ int iwl_mvm_rm_sta_id(struct iwl_mvm *mvm,
 
 int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm,
 			     struct iwl_mvm_int_sta *sta,
-			     u32 qmask, enum nl80211_iftype iftype)
+			     u32 qmask, enum nl80211_iftype iftype,
+			     enum iwl_sta_type type)
 {
 	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
 		sta->sta_id = iwl_mvm_find_free_sta_id(mvm, iftype);
@@ -1734,6 +1741,7 @@ int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm,
 	}
 
 	sta->tfd_queue_msk = qmask;
+	sta->type = type;
 
 	/* put a non-NULL value so iterating over the stations won't stop */
 	rcu_assign_pointer(mvm->fw_id_to_mac_id[sta->sta_id], ERR_PTR(-EINVAL));
@@ -1762,6 +1770,8 @@ static int iwl_mvm_add_int_sta_common(struct iwl_mvm *mvm,
 	cmd.sta_id = sta->sta_id;
 	cmd.mac_id_n_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mac_id,
 							     color));
+	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_STA_TYPE))
+		cmd.station_type = sta->type;
 
 	if (!iwl_mvm_has_new_tx_api(mvm))
 		cmd.tfd_queue_msk = cpu_to_le32(sta->tfd_queue_msk);
@@ -1826,7 +1836,8 @@ int iwl_mvm_add_aux_sta(struct iwl_mvm *mvm)
 
 	/* Allocate aux station and assign to it the aux queue */
 	ret = iwl_mvm_allocate_int_sta(mvm, &mvm->aux_sta, BIT(mvm->aux_queue),
-				       NL80211_IFTYPE_UNSPECIFIED);
+				       NL80211_IFTYPE_UNSPECIFIED,
+				       IWL_STA_AUX_ACTIVITY);
 	if (ret)
 		return ret;
 
@@ -2025,7 +2036,8 @@ int iwl_mvm_alloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	}
 
 	return iwl_mvm_allocate_int_sta(mvm, &mvmvif->bcast_sta, qmask,
-					ieee80211_vif_type_p2p(vif));
+					ieee80211_vif_type_p2p(vif),
+					IWL_STA_GENERAL_PURPOSE);
 }
 
 /* Allocate a new station entry for the broadcast station to the given vif,
@@ -2111,6 +2123,16 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (WARN_ON(vif->type != NL80211_IFTYPE_AP))
 		return -ENOTSUPP;
 
+	/*
+	 * While in previous FWs we had to exclude cab queue from TFD queue
+	 * mask, now it is needed as any other queue.
+	 */
+	if (!iwl_mvm_has_new_tx_api(mvm) &&
+	    fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_STA_TYPE)) {
+		iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue, 0,
+				   &cfg, timeout);
+		msta->tfd_queue_msk |= BIT(vif->cab_queue);
+	}
 	ret = iwl_mvm_add_int_sta_common(mvm, msta, maddr,
 					 mvmvif->id, mvmvif->color);
 	if (ret) {
@@ -2121,7 +2143,9 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	/*
 	 * Enable cab queue after the ADD_STA command is sent.
 	 * This is needed for a000 firmware which won't accept SCD_QUEUE_CFG
-	 * command with unknown station id.
+	 * command with unknown station id, and for FW that doesn't support
+	 * station API since the cab queue is not included in the
+	 * tfd_queue_mask.
 	 */
 	if (iwl_mvm_has_new_tx_api(mvm)) {
 		int queue = iwl_mvm_tvqm_enable_txq(mvm, vif->cab_queue,
@@ -2129,7 +2153,8 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 						    IWL_MAX_TID_COUNT,
 						    timeout);
 		mvmvif->cab_queue = queue;
-	} else {
+	} else if (!fw_has_api(&mvm->fw->ucode_capa,
+			       IWL_UCODE_TLV_API_STA_TYPE)) {
 		iwl_mvm_enable_txq(mvm, vif->cab_queue, vif->cab_queue, 0,
 				   &cfg, timeout);
 	}
@@ -3452,13 +3477,13 @@ void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 
 	/* Note: this is ignored by firmware not supporting GO uAPSD */
 	if (more_data)
-		cmd.sleep_state_flags |= cpu_to_le16(STA_SLEEP_STATE_MOREDATA);
+		cmd.sleep_state_flags |= STA_SLEEP_STATE_MOREDATA;
 
 	if (reason == IEEE80211_FRAME_RELEASE_PSPOLL) {
 		mvmsta->next_status_eosp = true;
-		cmd.sleep_state_flags |= cpu_to_le16(STA_SLEEP_STATE_PS_POLL);
+		cmd.sleep_state_flags |= STA_SLEEP_STATE_PS_POLL;
 	} else {
-		cmd.sleep_state_flags |= cpu_to_le16(STA_SLEEP_STATE_UAPSD);
+		cmd.sleep_state_flags |= STA_SLEEP_STATE_UAPSD;
 	}
 
 	/* block the Tx queues until the FW updated the sleep Tx count */
@@ -3535,6 +3560,27 @@ void iwl_mvm_sta_modify_disable_tx_ap(struct iwl_mvm *mvm,
 	spin_unlock_bh(&mvm_sta->lock);
 }
 
+static void iwl_mvm_int_sta_modify_disable_tx(struct iwl_mvm *mvm,
+					      struct iwl_mvm_vif *mvmvif,
+					      struct iwl_mvm_int_sta *sta,
+					      bool disable)
+{
+	u32 id = FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color);
+	struct iwl_mvm_add_sta_cmd cmd = {
+		.add_modify = STA_MODE_MODIFY,
+		.sta_id = sta->sta_id,
+		.station_flags = disable ? cpu_to_le32(STA_FLG_DISABLE_TX) : 0,
+		.station_flags_msk = cpu_to_le32(STA_FLG_DISABLE_TX),
+		.mac_id_n_color = cpu_to_le32(id),
+	};
+	int ret;
+
+	ret = iwl_mvm_send_cmd_pdu(mvm, ADD_STA, 0,
+				   iwl_mvm_add_sta_cmd_size(mvm), &cmd);
+	if (ret)
+		IWL_ERR(mvm, "Failed to send ADD_STA command (%d)\n", ret);
+}
+
 void iwl_mvm_modify_all_sta_disable_tx(struct iwl_mvm *mvm,
 				       struct iwl_mvm_vif *mvmvif,
 				       bool disable)
@@ -3559,6 +3605,22 @@ void iwl_mvm_modify_all_sta_disable_tx(struct iwl_mvm *mvm,
 
 		iwl_mvm_sta_modify_disable_tx_ap(mvm, sta, disable);
 	}
+
+	if (!fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_STA_TYPE))
+		return;
+
+	/* Need to block/unblock also multicast station */
+	if (mvmvif->mcast_sta.sta_id != IWL_MVM_INVALID_STA)
+		iwl_mvm_int_sta_modify_disable_tx(mvm, mvmvif,
+						  &mvmvif->mcast_sta, disable);
+
+	/*
+	 * Only unblock the broadcast station (FW blocks it for immediate
+	 * quiet, not the driver)
+	 */
+	if (!disable && mvmvif->bcast_sta.sta_id != IWL_MVM_INVALID_STA)
+		iwl_mvm_int_sta_modify_disable_tx(mvm, mvmvif,
+						  &mvmvif->bcast_sta, disable);
 }
 
 void iwl_mvm_csa_client_absent(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index a143a8757e27..2716cb5483bf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -380,6 +380,7 @@ struct iwl_mvm_rxq_dup_data {
  * @tid_disable_agg: bitmap: if bit(tid) is set, the fw won't send ampdus for
  *	tid.
  * @max_agg_bufsize: the maximal size of the AGG buffer for this station
+ * @sta_type: station type
  * @bt_reduced_txpower: is reduced tx power enabled for this station
  * @next_status_eosp: the next reclaimed packet is a PS-Poll response and
  *	we need to signal the EOSP
@@ -416,6 +417,7 @@ struct iwl_mvm_sta {
 	u32 mac_id_n_color;
 	u16 tid_disable_agg;
 	u8 max_agg_bufsize;
+	enum iwl_sta_type sta_type;
 	bool bt_reduced_txpower;
 	bool next_status_eosp;
 	spinlock_t lock;
@@ -453,10 +455,12 @@ iwl_mvm_sta_from_mac80211(struct ieee80211_sta *sta)
  * struct iwl_mvm_int_sta - representation of an internal station (auxiliary or
  * broadcast)
  * @sta_id: the index of the station in the fw (will be replaced by id_n_color)
+ * @type: station type
  * @tfd_queue_msk: the tfd queues used by the station
  */
 struct iwl_mvm_int_sta {
 	u32 sta_id;
+	enum iwl_sta_type type;
 	u32 tfd_queue_msk;
 };
 
@@ -536,7 +540,8 @@ int iwl_mvm_add_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_rm_mcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm,
 			     struct iwl_mvm_int_sta *sta,
-				    u32 qmask, enum nl80211_iftype iftype);
+				    u32 qmask, enum nl80211_iftype iftype,
+				    enum iwl_sta_type type);
 void iwl_mvm_dealloc_bcast_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 void iwl_mvm_dealloc_int_sta(struct iwl_mvm *mvm, struct iwl_mvm_int_sta *sta);
 int iwl_mvm_add_snif_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
-- 
2.11.0
