Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60874 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932068AbcGCT7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jul 2016 15:59:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org
Date: Sun,  3 Jul 2016 22:48:51 +0300
Message-Id: <1467575332-32112-12-git-send-email-luca@coelho.fi> (sfid-20160703_215919_976134_309810AA)
In-Reply-To: <467405215.1837.15.camel@coelho.fi>
References: <467405215.1837.15.camel@coelho.fi>
Subject: [PATCH 12/13] iwlwifi: mvm: Support CSA countdown offloading
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Add support CSA countdown offloading. When CSA starts, the driver
specifies the offsets to the eCSA and CSA IEs in the beacon template
command and the fw performs the countdown.
The fw notifies the driver when the channel switch flow
should be performed.
Beacon sent notifications are not used anymore.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h   |   4 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |  27 +++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |  12 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c  | 108 ++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  10 ++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   5 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |  26 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        |  13 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |  13 ++-
 9 files changed, 197 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
index 3f5029e..eb18de8 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h
@@ -311,6 +311,9 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_capa_t;
  * @IWL_UCODE_TLV_CAPA_EXTENDED_DTS_MEASURE: extended DTS measurement
  * @IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS: supports short PM timeouts
  * @IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT: supports bt-coex Multi-priority LUT
+ * @IWL_UCODE_TLV_CAPA_CSA_AND_TBTT_OFFLOAD: the firmware supports CSA
+ *	countdown offloading. Beacon notifications are not sent to the host.
+ *	The fw also offloads TBTT alignment.
  * @IWL_UCODE_TLV_CAPA_BEACON_ANT_SELECTION: firmware will decide on what
  *	antenna the beacon should be transmitted
  * @IWL_UCODE_TLV_CAPA_BEACON_STORING: firmware will store the latest beacon
@@ -355,6 +358,7 @@ enum iwl_ucode_tlv_capa {
 	IWL_UCODE_TLV_CAPA_SHORT_PM_TIMEOUTS		= (__force iwl_ucode_tlv_capa_t)65,
 	IWL_UCODE_TLV_CAPA_BT_MPLUT_SUPPORT		= (__force iwl_ucode_tlv_capa_t)67,
 	IWL_UCODE_TLV_CAPA_MULTI_QUEUE_RX_SUPPORT	= (__force iwl_ucode_tlv_capa_t)68,
+	IWL_UCODE_TLV_CAPA_CSA_AND_TBTT_OFFLOAD		= (__force iwl_ucode_tlv_capa_t)70,
 	IWL_UCODE_TLV_CAPA_BEACON_ANT_SELECTION		= (__force iwl_ucode_tlv_capa_t)71,
 	IWL_UCODE_TLV_CAPA_BEACON_STORING		= (__force iwl_ucode_tlv_capa_t)72,
 	IWL_UCODE_TLV_CAPA_LAR_SUPPORT_V2		= (__force iwl_ucode_tlv_capa_t)73,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
index dadcccd..ee59511 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h
@@ -562,8 +562,8 @@ struct iwl_mvm_ba_notif {
 	u8 reserved1;
 } __packed;
 
-/*
- * struct iwl_mac_beacon_cmd - beacon template command
+/**
+ * struct iwl_mac_beacon_cmd_v6 - beacon template command
  * @tx: the tx commands associated with the beacon frame
  * @template_id: currently equal to the mac context id of the coresponding
  *  mac.
@@ -571,13 +571,34 @@ struct iwl_mvm_ba_notif {
  * @tim_size: the length of the tim IE
  * @frame: the template of the beacon frame
  */
+struct iwl_mac_beacon_cmd_v6 {
+	struct iwl_tx_cmd tx;
+	__le32 template_id;
+	__le32 tim_idx;
+	__le32 tim_size;
+	struct ieee80211_hdr frame[0];
+} __packed; /* BEACON_TEMPLATE_CMD_API_S_VER_6 */
+
+/**
+ * struct iwl_mac_beacon_cmd - beacon template command with offloaded CSA
+ * @tx: the tx commands associated with the beacon frame
+ * @template_id: currently equal to the mac context id of the coresponding
+ *  mac.
+ * @tim_idx: the offset of the tim IE in the beacon
+ * @tim_size: the length of the tim IE
+ * @ecsa_offset: offset to the ECSA IE if present
+ * @csa_offset: offset to the CSA IE if present
+ * @frame: the template of the beacon frame
+ */
 struct iwl_mac_beacon_cmd {
 	struct iwl_tx_cmd tx;
 	__le32 template_id;
 	__le32 tim_idx;
 	__le32 tim_size;
+	__le32 ecsa_offset;
+	__le32 csa_offset;
 	struct ieee80211_hdr frame[0];
-} __packed;
+} __packed; /* BEACON_TEMPLATE_CMD_API_S_VER_7 */
 
 struct iwl_beacon_notif {
 	struct iwl_mvm_tx_resp beacon_notify_hdr;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 41b80ae..b06380d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -314,6 +314,7 @@ enum {
 enum iwl_mac_conf_subcmd_ids {
 	LINK_QUALITY_MEASUREMENT_CMD = 0x1,
 	LINK_QUALITY_MEASUREMENT_COMPLETE_NOTIF = 0xFE,
+	CHANNEL_SWITCH_NOA_NOTIF = 0xFF,
 };
 
 enum iwl_phy_ops_subcmd_ids {
@@ -732,7 +733,7 @@ enum iwl_time_event_type {
 
 	/* P2P GO Events */
 	TE_P2P_GO_ASSOC_PROT,
-	TE_P2P_GO_REPETITIVE_NOA,
+	TE_P2P_GO_REPETITIVET_NOA,
 	TE_P2P_GO_CT_WINDOW,
 
 	/* WiDi Sync Events */
@@ -2111,4 +2112,13 @@ struct iwl_link_qual_msrmnt_notif {
 	__le32 reserved[3];
 } __packed; /* LQM_MEASUREMENT_COMPLETE_NTF_API_S_VER1 */
 
+/**
+ * Channel switch NOA notification
+ *
+ * @id_and_color: ID and color of the MAC
+ */
+struct iwl_channel_switch_noa_notif {
+	__le32 id_and_color;
+} __packed; /* CHANNEL_SWITCH_START_NTFY_API_S_VER_1 */
+
 #endif /* __fw_api_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 7aae068..69c42ce 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1006,7 +1006,7 @@ static int iwl_mvm_mac_ctxt_cmd_p2p_device(struct iwl_mvm *mvm,
 }
 
 static void iwl_mvm_mac_ctxt_set_tim(struct iwl_mvm *mvm,
-				     struct iwl_mac_beacon_cmd *beacon_cmd,
+				     struct iwl_mac_beacon_cmd_v6 *beacon_cmd,
 				     u8 *beacon, u32 frame_size)
 {
 	u32 tim_idx;
@@ -1030,6 +1030,23 @@ static void iwl_mvm_mac_ctxt_set_tim(struct iwl_mvm *mvm,
 	}
 }
 
+static u32 iwl_mvm_find_ie_offset(u8 *beacon, u8 eid, u32 frame_size)
+{
+	struct ieee80211_mgmt *mgmt = (void *)beacon;
+	const u8 *ie;
+
+	if (WARN_ON_ONCE(frame_size <= (mgmt->u.beacon.variable - beacon)))
+		return 0;
+
+	frame_size -= mgmt->u.beacon.variable - beacon;
+
+	ie = cfg80211_find_ie(eid, mgmt->u.beacon.variable, frame_size);
+	if (!ie)
+		return 0;
+
+	return ie - beacon;
+}
+
 static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif,
 					struct sk_buff *beacon)
@@ -1039,7 +1056,10 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 		.id = BEACON_TEMPLATE_CMD,
 		.flags = CMD_ASYNC,
 	};
-	struct iwl_mac_beacon_cmd beacon_cmd = {};
+	union {
+		struct iwl_mac_beacon_cmd_v6 beacon_cmd_v6;
+		struct iwl_mac_beacon_cmd beacon_cmd;
+	} u = {};
 	struct ieee80211_tx_info *info;
 	u32 beacon_skb_len;
 	u32 rate, tx_flags;
@@ -1051,18 +1071,18 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 
 	/* TODO: for now the beacon template id is set to be the mac context id.
 	 * Might be better to handle it as another resource ... */
-	beacon_cmd.template_id = cpu_to_le32((u32)mvmvif->id);
+	u.beacon_cmd_v6.template_id = cpu_to_le32((u32)mvmvif->id);
 	info = IEEE80211_SKB_CB(beacon);
 
 	/* Set up TX command fields */
-	beacon_cmd.tx.len = cpu_to_le16((u16)beacon_skb_len);
-	beacon_cmd.tx.sta_id = mvmvif->bcast_sta.sta_id;
-	beacon_cmd.tx.life_time = cpu_to_le32(TX_CMD_LIFE_TIME_INFINITE);
+	u.beacon_cmd_v6.tx.len = cpu_to_le16((u16)beacon_skb_len);
+	u.beacon_cmd_v6.tx.sta_id = mvmvif->bcast_sta.sta_id;
+	u.beacon_cmd_v6.tx.life_time = cpu_to_le32(TX_CMD_LIFE_TIME_INFINITE);
 	tx_flags = TX_CMD_FLG_SEQ_CTL | TX_CMD_FLG_TSF;
 	tx_flags |=
 		iwl_mvm_bt_coex_tx_prio(mvm, (void *)beacon->data, info, 0) <<
 						TX_CMD_FLG_BT_PRIO_POS;
-	beacon_cmd.tx.tx_flags = cpu_to_le32(tx_flags);
+	u.beacon_cmd_v6.tx.tx_flags = cpu_to_le32(tx_flags);
 
 	if (!fw_has_capa(&mvm->fw->ucode_capa,
 			 IWL_UCODE_TLV_CAPA_BEACON_ANT_SELECTION)) {
@@ -1071,7 +1091,7 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 					     mvm->mgmt_last_antenna_idx);
 	}
 
-	beacon_cmd.tx.rate_n_flags =
+	u.beacon_cmd_v6.tx.rate_n_flags =
 		cpu_to_le32(BIT(mvm->mgmt_last_antenna_idx) <<
 			    RATE_MCS_ANT_POS);
 
@@ -1079,20 +1099,37 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 		rate = IWL_FIRST_OFDM_RATE;
 	} else {
 		rate = IWL_FIRST_CCK_RATE;
-		beacon_cmd.tx.rate_n_flags |= cpu_to_le32(RATE_MCS_CCK_MSK);
+		u.beacon_cmd_v6.tx.rate_n_flags |=
+					cpu_to_le32(RATE_MCS_CCK_MSK);
 	}
-	beacon_cmd.tx.rate_n_flags |=
+	u.beacon_cmd_v6.tx.rate_n_flags |=
 		cpu_to_le32(iwl_mvm_mac80211_idx_to_hwrate(rate));
 
 	/* Set up TX beacon command fields */
 	if (vif->type == NL80211_IFTYPE_AP)
-		iwl_mvm_mac_ctxt_set_tim(mvm, &beacon_cmd,
+		iwl_mvm_mac_ctxt_set_tim(mvm, &u.beacon_cmd_v6,
 					 beacon->data,
 					 beacon_skb_len);
 
 	/* Submit command */
-	cmd.len[0] = sizeof(beacon_cmd);
-	cmd.data[0] = &beacon_cmd;
+
+	if (fw_has_capa(&mvm->fw->ucode_capa,
+			IWL_UCODE_TLV_CAPA_CSA_AND_TBTT_OFFLOAD)) {
+		u.beacon_cmd.csa_offset =
+			cpu_to_le32(iwl_mvm_find_ie_offset(beacon->data,
+						    WLAN_EID_CHANNEL_SWITCH,
+						    beacon_skb_len));
+		u.beacon_cmd.ecsa_offset =
+			cpu_to_le32(iwl_mvm_find_ie_offset(beacon->data,
+						    WLAN_EID_EXT_CHANSWITCH_ANN,
+						    beacon_skb_len));
+
+		cmd.len[0] = sizeof(u.beacon_cmd);
+	} else {
+		cmd.len[0] = sizeof(u.beacon_cmd_v6);
+	}
+
+	cmd.data[0] = &u;
 	cmd.dataflags[0] = 0;
 	cmd.len[1] = beacon_skb_len;
 	cmd.data[1] = beacon->data;
@@ -1538,3 +1575,48 @@ void iwl_mvm_rx_stored_beacon_notif(struct iwl_mvm *mvm,
 	/* pass it as regular rx to mac80211 */
 	ieee80211_rx_napi(mvm->hw, NULL, skb, NULL);
 }
+
+void iwl_mvm_channel_switch_noa_notif(struct iwl_mvm *mvm,
+				      struct iwl_rx_cmd_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_channel_switch_noa_notif *notif = (void *)pkt->data;
+	struct ieee80211_vif *csa_vif;
+	struct iwl_mvm_vif *mvmvif;
+	int len = iwl_rx_packet_payload_len(pkt);
+	u32 id_n_color;
+
+	if (WARN_ON_ONCE(len < sizeof(*notif)))
+		return;
+
+	rcu_read_lock();
+
+	csa_vif = rcu_dereference(mvm->csa_vif);
+	if (WARN_ON(!csa_vif || !csa_vif->csa_active))
+		goto out_unlock;
+
+	id_n_color = le32_to_cpu(notif->id_and_color);
+
+	mvmvif = iwl_mvm_vif_from_mac80211(csa_vif);
+	if (WARN(FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color) != id_n_color,
+		 "channel switch noa notification on unexpected vif (csa_vif=%d, notif=%d)",
+		 FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color), id_n_color))
+		goto out_unlock;
+
+	IWL_DEBUG_INFO(mvm, "Channel Switch Started Notification\n");
+
+	queue_delayed_work(system_wq, &mvm->cs_tx_unblock_dwork,
+			   msecs_to_jiffies(IWL_MVM_CS_UNBLOCK_TX_TIMEOUT *
+					    csa_vif->bss_conf.beacon_int));
+
+	ieee80211_csa_finish(csa_vif);
+
+	rcu_read_unlock();
+
+	RCU_INIT_POINTER(mvm->csa_vif, NULL);
+
+	return;
+
+out_unlock:
+	rcu_read_unlock();
+}
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index b7014bc..e5cb7db 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1199,6 +1199,7 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 	flush_work(&mvm->async_handlers_wk);
 	flush_work(&mvm->add_stream_wk);
 	cancel_delayed_work_sync(&mvm->fw_dump_wk);
+	cancel_delayed_work_sync(&mvm->cs_tx_unblock_dwork);
 	iwl_mvm_free_fw_dump_desc(mvm);
 
 	mutex_lock(&mvm->mutex);
@@ -3687,6 +3688,13 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 			goto out_unlock;
 		}
 
+		/* we still didn't unblock tx. prevent new CS meanwhile */
+		if (rcu_dereference_protected(mvm->csa_tx_blocked_vif,
+					      lockdep_is_held(&mvm->mutex))) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+
 		rcu_assign_pointer(mvm->csa_vif, vif);
 
 		if (WARN_ONCE(mvmvif->csa_countdown,
@@ -3695,6 +3703,8 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 			goto out_unlock;
 		}
 
+		mvmvif->csa_target_freq = chsw->chandef.chan->center_freq;
+
 		break;
 	case NL80211_IFTYPE_STATION:
 		if (mvmvif->lqm_active)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 65f9a4b..4b75b92 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -452,6 +452,7 @@ struct iwl_mvm_vif {
 	/* Indicates that CSA countdown may be started */
 	bool csa_countdown;
 	bool csa_failed;
+	u16 csa_target_freq;
 
 	/* TCP Checksum Offload */
 	netdev_features_t features;
@@ -1007,6 +1008,8 @@ struct iwl_mvm {
 	 * clients.
 	 */
 	bool drop_bcn_ap_mode;
+
+	struct delayed_work cs_tx_unblock_dwork;
 };
 
 /* Extract MVM priv from op_mode and _hw */
@@ -1381,6 +1384,8 @@ void iwl_mvm_mac_ctxt_recalc_tsf_id(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif);
 unsigned long iwl_mvm_get_used_hw_queues(struct iwl_mvm *mvm,
 					 struct ieee80211_vif *exclude_vif);
+void iwl_mvm_channel_switch_noa_notif(struct iwl_mvm *mvm,
+				      struct iwl_rx_cmd_buffer *rxb);
 /* Bindings */
 int iwl_mvm_binding_add_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_binding_remove_vif(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 55f114d..ddc4004 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -431,6 +431,7 @@ static const struct iwl_hcmd_names iwl_mvm_system_names[] = {
 static const struct iwl_hcmd_names iwl_mvm_mac_conf_names[] = {
 	HCMD_NAME(LINK_QUALITY_MEASUREMENT_CMD),
 	HCMD_NAME(LINK_QUALITY_MEASUREMENT_COMPLETE_NOTIF),
+	HCMD_NAME(CHANNEL_SWITCH_NOA_NOTIF),
 };
 
 /* Please keep this array *SORTED* by hex value.
@@ -494,6 +495,29 @@ static u32 calc_min_backoff(struct iwl_trans *trans, const struct iwl_cfg *cfg)
 
 static void iwl_mvm_fw_error_dump_wk(struct work_struct *work);
 
+static void iwl_mvm_tx_unblock_dwork(struct work_struct *work)
+{
+	struct iwl_mvm *mvm =
+		container_of(work, struct iwl_mvm, cs_tx_unblock_dwork.work);
+	struct ieee80211_vif *tx_blocked_vif;
+	struct iwl_mvm_vif *mvmvif;
+
+	mutex_lock(&mvm->mutex);
+
+	tx_blocked_vif =
+		rcu_dereference_protected(mvm->csa_tx_blocked_vif,
+					  lockdep_is_held(&mvm->mutex));
+
+	if (!tx_blocked_vif)
+		goto unlock;
+
+	mvmvif = iwl_mvm_vif_from_mac80211(tx_blocked_vif);
+	iwl_mvm_modify_all_sta_disable_tx(mvm, mvmvif, false);
+	RCU_INIT_POINTER(mvm->csa_tx_blocked_vif, NULL);
+unlock:
+	mutex_unlock(&mvm->mutex);
+}
+
 static struct iwl_op_mode *
 iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 		      const struct iwl_fw *fw, struct dentry *dbgfs_dir)
@@ -595,6 +619,8 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 
 	SET_IEEE80211_DEV(mvm->hw, mvm->trans->dev);
 
+	INIT_DELAYED_WORK(&mvm->cs_tx_unblock_dwork, iwl_mvm_tx_unblock_dwork);
+
 	/*
 	 * Populate the state variables that the transport layer needs
 	 * to know about.
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index ab7f7ed..6d096b6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -354,13 +354,22 @@ void iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 	if (sta) {
 		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+		struct ieee80211_vif *tx_blocked_vif =
+			rcu_dereference(mvm->csa_tx_blocked_vif);
 
 		/* We have tx blocked stations (with CS bit). If we heard
 		 * frames from a blocked station on a new channel we can
 		 * TX to it again.
 		 */
-		if (unlikely(mvm->csa_tx_block_bcn_timeout))
-			iwl_mvm_sta_modify_disable_tx_ap(mvm, sta, false);
+		if (unlikely(tx_blocked_vif) &&
+		    mvmsta->vif == tx_blocked_vif) {
+			struct iwl_mvm_vif *mvmvif =
+				iwl_mvm_vif_from_mac80211(tx_blocked_vif);
+
+			if (mvmvif->csa_target_freq == rx_status->freq)
+				iwl_mvm_sta_modify_disable_tx_ap(mvm, sta,
+								 false);
+		}
 
 		rs_update_last_rssi(mvm, &mvmsta->lq_sta, rx_status);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 1f4fef4..d13397a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -817,6 +817,8 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 	if (sta) {
 		struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+		struct ieee80211_vif *tx_blocked_vif =
+			rcu_dereference(mvm->csa_tx_blocked_vif);
 		u8 baid = (u8)((le32_to_cpu(desc->reorder_data) &
 			       IWL_RX_MPDU_REORDER_BAID_MASK) >>
 			       IWL_RX_MPDU_REORDER_BAID_SHIFT);
@@ -826,8 +828,15 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		 * frames from a blocked station on a new channel we can
 		 * TX to it again.
 		 */
-		if (unlikely(mvm->csa_tx_block_bcn_timeout))
-			iwl_mvm_sta_modify_disable_tx_ap(mvm, sta, false);
+		if (unlikely(tx_blocked_vif) &&
+		    tx_blocked_vif == mvmsta->vif) {
+			struct iwl_mvm_vif *mvmvif =
+				iwl_mvm_vif_from_mac80211(tx_blocked_vif);
+
+			if (mvmvif->csa_target_freq == rx_status->freq)
+				iwl_mvm_sta_modify_disable_tx_ap(mvm, sta,
+								 false);
+		}
 
 		rs_update_last_rssi(mvm, &mvmsta->lq_sta, rx_status);
 
-- 
2.8.1

