Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:44429 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaBCU6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:18 -0500
Received: by mail-ee0-f43.google.com with SMTP id c41so3882601eek.16
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:17 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/62] iwlwifi: mvm: implement AP/GO uAPSD support
Date: Mon,  3 Feb 2014 22:57:07 +0200
Message-Id: <1391461088-8082-1-git-send-email-egrumbach@gmail.com> (sfid-20140203_215822_242034_F59F38A8)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Newer firmware will support uAPSD clients in AP/GO mode, so complete
the driver support for it. The way it works is described in comments
in the code, but basically the driver just has to pass down all the
mac80211 requests and do accounting on agg/non-agg queues properly.

For older firmware, this doesn't change anything as it ignores the
fields used by the new firmware, and we only advertise uAPSD support
when the firmware does.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h         |    2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h |   31 +++--
 drivers/net/wireless/iwlwifi/mvm/fw-api.h     |    1 +
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   |   59 +++++++--
 drivers/net/wireless/iwlwifi/mvm/ops.c        |    3 +
 drivers/net/wireless/iwlwifi/mvm/sta.c        |  171 ++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/mvm/sta.h        |   57 ++++++---
 drivers/net/wireless/iwlwifi/mvm/tx.c         |   23 ++++
 8 files changed, 270 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 5f1493c..7263277 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -95,6 +95,7 @@
  * @IWL_UCODE_TLV_FLAGS_P2P_PS: P2P client power save is supported (only on a
  *	single bound interface).
  * @IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD: P2P client supports uAPSD power save
+ * @IWL_UCODE_TLV_FLAGS_GO_UAPSD: AP/GO interfaces support uAPSD clients
  */
 enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_PAN			= BIT(0),
@@ -119,6 +120,7 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_P2P_PS		= BIT(21),
 	IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT	= BIT(24),
 	IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD	= BIT(26),
+	IWL_UCODE_TLV_FLAGS_GO_UAPSD		= BIT(30),
 };
 
 /* The default calibrate table size if not specified by firmware file */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
index 1b60fdf..d636478 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
@@ -199,11 +199,14 @@ enum iwl_sta_modify_flag {
  * @STA_SLEEP_STATE_AWAKE:
  * @STA_SLEEP_STATE_PS_POLL:
  * @STA_SLEEP_STATE_UAPSD:
+ * @STA_SLEEP_STATE_MOREDATA: set more-data bit on
+ *	(last) released frame
  */
 enum iwl_sta_sleep_flag {
-	STA_SLEEP_STATE_AWAKE	= 0,
-	STA_SLEEP_STATE_PS_POLL	= BIT(0),
-	STA_SLEEP_STATE_UAPSD	= BIT(1),
+	STA_SLEEP_STATE_AWAKE		= 0,
+	STA_SLEEP_STATE_PS_POLL		= BIT(0),
+	STA_SLEEP_STATE_UAPSD		= BIT(1),
+	STA_SLEEP_STATE_MOREDATA	= BIT(2),
 };
 
 /* STA ID and color bits definitions */
@@ -318,13 +321,15 @@ struct iwl_mvm_add_sta_cmd_v5 {
 } __packed; /* ADD_STA_CMD_API_S_VER_5 */
 
 /**
- * struct iwl_mvm_add_sta_cmd_v6 - Add / modify a station
- * VER_6 of this command is quite similar to VER_5 except
+ * struct iwl_mvm_add_sta_cmd_v7 - Add / modify a station
+ * VER_7 of this command is quite similar to VER_5 except
  * exclusion of all fields related to the security key installation.
+ * It only differs from VER_6 by the "awake_acs" field that is
+ * reserved and ignored in VER_6.
  */
-struct iwl_mvm_add_sta_cmd_v6 {
+struct iwl_mvm_add_sta_cmd_v7 {
 	u8 add_modify;
-	u8 reserved1;
+	u8 awake_acs;
 	__le16 tid_disable_tx;
 	__le32 mac_id_n_color;
 	u8 addr[ETH_ALEN];	/* _STA_ID_MODIFY_INFO_API_S_VER_1 */
@@ -342,7 +347,7 @@ struct iwl_mvm_add_sta_cmd_v6 {
 	__le16 assoc_id;
 	__le16 beamform_flags;
 	__le32 tfd_queue_msk;
-} __packed; /* ADD_STA_CMD_API_S_VER_6 */
+} __packed; /* ADD_STA_CMD_API_S_VER_7 */
 
 /**
  * struct iwl_mvm_add_sta_key_cmd - add/modify sta key
@@ -432,5 +437,15 @@ struct iwl_mvm_wep_key_cmd {
 	struct iwl_mvm_wep_key wep_key[0];
 } __packed; /* SEC_CURR_WEP_KEY_CMD_API_S_VER_2 */
 
+/**
+ * struct iwl_mvm_eosp_notification - EOSP notification from firmware
+ * @remain_frame_count: # of frames remaining, non-zero if SP was cut
+ *	short by GO absence
+ * @sta_id: station ID
+ */
+struct iwl_mvm_eosp_notification {
+	__le32 remain_frame_count;
+	__le32 sta_id;
+} __packed; /* UAPSD_EOSP_NTFY_API_S_VER_1 */
 
 #endif /* __fw_api_sta_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 989d7db..a043a1f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -163,6 +163,7 @@ enum {
 	TX_ANT_CONFIGURATION_CMD = 0x98,
 	BT_CONFIG = 0x9b,
 	STATISTICS_NOTIFICATION = 0x9d,
+	EOSP_NOTIFICATION = 0x9e,
 	REDUCE_TX_POWER_CMD = 0x9f,
 
 	/* RF-KILL commands and notifications */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index c49b507..5b9cfe1 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -203,6 +203,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	hw->wiphy->regulatory_flags |= REGULATORY_CUSTOM_REG |
 				       REGULATORY_DISABLE_BEACON_HINTS;
 
+	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_GO_UAPSD)
+		hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
+
 	hw->wiphy->iface_combinations = iwl_mvm_iface_combinations;
 	hw->wiphy->n_iface_combinations =
 		ARRAY_SIZE(iwl_mvm_iface_combinations);
@@ -305,6 +308,9 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 			   struct sk_buff *skb)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct ieee80211_sta *sta = control->sta;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (void *)skb->data;
 
 	if (iwl_mvm_is_radio_killed(mvm)) {
 		IWL_DEBUG_DROP(mvm, "Dropping - RF/CT KILL\n");
@@ -315,8 +321,16 @@ static void iwl_mvm_mac_tx(struct ieee80211_hw *hw,
 	    !test_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status))
 		goto drop;
 
-	if (control->sta) {
-		if (iwl_mvm_tx_skb(mvm, skb, control->sta))
+	/* treat non-bufferable MMPDUs as broadcast if sta is sleeping */
+	if (unlikely(info->flags & IEEE80211_TX_CTL_NO_PS_BUFFER &&
+		     ieee80211_is_mgmt(hdr->frame_control) &&
+		     !ieee80211_is_deauth(hdr->frame_control) &&
+		     !ieee80211_is_disassoc(hdr->frame_control) &&
+		     !ieee80211_is_action(hdr->frame_control)))
+		sta = NULL;
+
+	if (sta) {
+		if (iwl_mvm_tx_skb(mvm, skb, sta))
 			goto drop;
 		return;
 	}
@@ -1168,20 +1182,32 @@ static void iwl_mvm_mac_cancel_hw_scan(struct ieee80211_hw *hw,
 
 static void
 iwl_mvm_mac_allow_buffered_frames(struct ieee80211_hw *hw,
-				  struct ieee80211_sta *sta, u16 tid,
+				  struct ieee80211_sta *sta, u16 tids,
 				  int num_frames,
 				  enum ieee80211_frame_release_type reason,
 				  bool more_data)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 
-	/* TODO: how do we tell the fw to send frames for a specific TID */
+	/* Called when we need to transmit (a) frame(s) from mac80211 */
 
-	/*
-	 * The fw will send EOSP notification when the last frame will be
-	 * transmitted.
-	 */
-	iwl_mvm_sta_modify_sleep_tx_count(mvm, sta, reason, num_frames);
+	iwl_mvm_sta_modify_sleep_tx_count(mvm, sta, reason, num_frames,
+					  tids, more_data, false);
+}
+
+static void
+iwl_mvm_mac_release_buffered_frames(struct ieee80211_hw *hw,
+				    struct ieee80211_sta *sta, u16 tids,
+				    int num_frames,
+				    enum ieee80211_frame_release_type reason,
+				    bool more_data)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	/* Called when we need to transmit (a) frame(s) from agg queue */
+
+	iwl_mvm_sta_modify_sleep_tx_count(mvm, sta, reason, num_frames,
+					  tids, more_data, true);
 }
 
 static void iwl_mvm_mac_sta_notify(struct ieee80211_hw *hw,
@@ -1191,11 +1217,25 @@ static void iwl_mvm_mac_sta_notify(struct ieee80211_hw *hw,
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+	int tid;
 
 	switch (cmd) {
 	case STA_NOTIFY_SLEEP:
 		if (atomic_read(&mvm->pending_frames[mvmsta->sta_id]) > 0)
 			ieee80211_sta_block_awake(hw, sta, true);
+		spin_lock_bh(&mvmsta->lock);
+		for (tid = 0; tid < IWL_MAX_TID_COUNT; tid++) {
+			struct iwl_mvm_tid_data *tid_data;
+
+			tid_data = &mvmsta->tid_data[tid];
+			if (tid_data->state != IWL_AGG_ON &&
+			    tid_data->state != IWL_EMPTYING_HW_QUEUE_DELBA)
+				continue;
+			if (iwl_mvm_tid_queued(tid_data) == 0)
+				continue;
+			ieee80211_sta_set_buffered(sta, tid, true);
+		}
+		spin_unlock_bh(&mvmsta->lock);
 		/*
 		 * The fw updates the STA to be asleep. Tx packets on the Tx
 		 * queues to this station will not be transmitted. The fw will
@@ -1914,6 +1954,7 @@ struct ieee80211_ops iwl_mvm_hw_ops = {
 	.sta_state = iwl_mvm_mac_sta_state,
 	.sta_notify = iwl_mvm_mac_sta_notify,
 	.allow_buffered_frames = iwl_mvm_mac_allow_buffered_frames,
+	.release_buffered_frames = iwl_mvm_mac_release_buffered_frames,
 	.set_rts_threshold = iwl_mvm_mac_set_rts_threshold,
 	.sta_rc_update = iwl_mvm_sta_rc_update,
 	.conf_tx = iwl_mvm_mac_conf_tx,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index a3d43de..a65eeb3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -222,6 +222,8 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 
 	RX_HANDLER(TIME_EVENT_NOTIFICATION, iwl_mvm_rx_time_event_notif, false),
 
+	RX_HANDLER(EOSP_NOTIFICATION, iwl_mvm_rx_eosp_notif, false),
+
 	RX_HANDLER(SCAN_REQUEST_CMD, iwl_mvm_rx_scan_response, false),
 	RX_HANDLER(SCAN_COMPLETE_NOTIFICATION, iwl_mvm_rx_scan_complete, false),
 	RX_HANDLER(SCAN_OFFLOAD_COMPLETE,
@@ -284,6 +286,7 @@ static const char *iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(BEACON_NOTIFICATION),
 	CMD(BEACON_TEMPLATE_CMD),
 	CMD(STATISTICS_NOTIFICATION),
+	CMD(EOSP_NOTIFICATION),
 	CMD(REDUCE_TX_POWER_CMD),
 	CMD(TX_ANT_CONFIGURATION_CMD),
 	CMD(D3_CONFIG_CMD),
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index ec18121..af94f75 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -66,27 +66,27 @@
 #include "sta.h"
 #include "rs.h"
 
-static void iwl_mvm_add_sta_cmd_v6_to_v5(struct iwl_mvm_add_sta_cmd_v6 *cmd_v6,
+static void iwl_mvm_add_sta_cmd_v7_to_v5(struct iwl_mvm_add_sta_cmd_v7 *cmd_v7,
 					 struct iwl_mvm_add_sta_cmd_v5 *cmd_v5)
 {
 	memset(cmd_v5, 0, sizeof(*cmd_v5));
 
-	cmd_v5->add_modify = cmd_v6->add_modify;
-	cmd_v5->tid_disable_tx = cmd_v6->tid_disable_tx;
-	cmd_v5->mac_id_n_color = cmd_v6->mac_id_n_color;
-	memcpy(cmd_v5->addr, cmd_v6->addr, ETH_ALEN);
-	cmd_v5->sta_id = cmd_v6->sta_id;
-	cmd_v5->modify_mask = cmd_v6->modify_mask;
-	cmd_v5->station_flags = cmd_v6->station_flags;
-	cmd_v5->station_flags_msk = cmd_v6->station_flags_msk;
-	cmd_v5->add_immediate_ba_tid = cmd_v6->add_immediate_ba_tid;
-	cmd_v5->remove_immediate_ba_tid = cmd_v6->remove_immediate_ba_tid;
-	cmd_v5->add_immediate_ba_ssn = cmd_v6->add_immediate_ba_ssn;
-	cmd_v5->sleep_tx_count = cmd_v6->sleep_tx_count;
-	cmd_v5->sleep_state_flags = cmd_v6->sleep_state_flags;
-	cmd_v5->assoc_id = cmd_v6->assoc_id;
-	cmd_v5->beamform_flags = cmd_v6->beamform_flags;
-	cmd_v5->tfd_queue_msk = cmd_v6->tfd_queue_msk;
+	cmd_v5->add_modify = cmd_v7->add_modify;
+	cmd_v5->tid_disable_tx = cmd_v7->tid_disable_tx;
+	cmd_v5->mac_id_n_color = cmd_v7->mac_id_n_color;
+	memcpy(cmd_v5->addr, cmd_v7->addr, ETH_ALEN);
+	cmd_v5->sta_id = cmd_v7->sta_id;
+	cmd_v5->modify_mask = cmd_v7->modify_mask;
+	cmd_v5->station_flags = cmd_v7->station_flags;
+	cmd_v5->station_flags_msk = cmd_v7->station_flags_msk;
+	cmd_v5->add_immediate_ba_tid = cmd_v7->add_immediate_ba_tid;
+	cmd_v5->remove_immediate_ba_tid = cmd_v7->remove_immediate_ba_tid;
+	cmd_v5->add_immediate_ba_ssn = cmd_v7->add_immediate_ba_ssn;
+	cmd_v5->sleep_tx_count = cmd_v7->sleep_tx_count;
+	cmd_v5->sleep_state_flags = cmd_v7->sleep_state_flags;
+	cmd_v5->assoc_id = cmd_v7->assoc_id;
+	cmd_v5->beamform_flags = cmd_v7->beamform_flags;
+	cmd_v5->tfd_queue_msk = cmd_v7->tfd_queue_msk;
 }
 
 static void
@@ -110,7 +110,7 @@ iwl_mvm_add_sta_key_to_add_sta_cmd_v5(struct iwl_mvm_add_sta_key_cmd *key_cmd,
 }
 
 static int iwl_mvm_send_add_sta_cmd_status(struct iwl_mvm *mvm,
-					   struct iwl_mvm_add_sta_cmd_v6 *cmd,
+					   struct iwl_mvm_add_sta_cmd_v7 *cmd,
 					   int *status)
 {
 	struct iwl_mvm_add_sta_cmd_v5 cmd_v5;
@@ -119,14 +119,14 @@ static int iwl_mvm_send_add_sta_cmd_status(struct iwl_mvm *mvm,
 		return iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA, sizeof(*cmd),
 						   cmd, status);
 
-	iwl_mvm_add_sta_cmd_v6_to_v5(cmd, &cmd_v5);
+	iwl_mvm_add_sta_cmd_v7_to_v5(cmd, &cmd_v5);
 
 	return iwl_mvm_send_cmd_pdu_status(mvm, ADD_STA, sizeof(cmd_v5),
 					   &cmd_v5, status);
 }
 
 static int iwl_mvm_send_add_sta_cmd(struct iwl_mvm *mvm, u32 flags,
-				    struct iwl_mvm_add_sta_cmd_v6 *cmd)
+				    struct iwl_mvm_add_sta_cmd_v7 *cmd)
 {
 	struct iwl_mvm_add_sta_cmd_v5 cmd_v5;
 
@@ -134,7 +134,7 @@ static int iwl_mvm_send_add_sta_cmd(struct iwl_mvm *mvm, u32 flags,
 		return iwl_mvm_send_cmd_pdu(mvm, ADD_STA, flags,
 					    sizeof(*cmd), cmd);
 
-	iwl_mvm_add_sta_cmd_v6_to_v5(cmd, &cmd_v5);
+	iwl_mvm_add_sta_cmd_v7_to_v5(cmd, &cmd_v5);
 
 	return iwl_mvm_send_cmd_pdu(mvm, ADD_STA, flags, sizeof(cmd_v5),
 				    &cmd_v5);
@@ -196,7 +196,7 @@ int iwl_mvm_sta_send_to_fw(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			   bool update)
 {
 	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
-	struct iwl_mvm_add_sta_cmd_v6 add_sta_cmd;
+	struct iwl_mvm_add_sta_cmd_v7 add_sta_cmd;
 	int ret;
 	u32 status;
 	u32 agg_size = 0, mpdu_dens = 0;
@@ -368,7 +368,7 @@ int iwl_mvm_update_sta(struct iwl_mvm *mvm,
 int iwl_mvm_drain_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 		      bool drain)
 {
-	struct iwl_mvm_add_sta_cmd_v6 cmd = {};
+	struct iwl_mvm_add_sta_cmd_v7 cmd = {};
 	int ret;
 	u32 status;
 
@@ -587,13 +587,13 @@ static int iwl_mvm_add_int_sta_common(struct iwl_mvm *mvm,
 				      const u8 *addr,
 				      u16 mac_id, u16 color)
 {
-	struct iwl_mvm_add_sta_cmd_v6 cmd;
+	struct iwl_mvm_add_sta_cmd_v7 cmd;
 	int ret;
 	u32 status;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	memset(&cmd, 0, sizeof(struct iwl_mvm_add_sta_cmd_v6));
+	memset(&cmd, 0, sizeof(struct iwl_mvm_add_sta_cmd_v7));
 	cmd.sta_id = sta->sta_id;
 	cmd.mac_id_n_color = cpu_to_le32(FW_CMD_ID_AND_COLOR(mac_id,
 							     color));
@@ -735,7 +735,7 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		       int tid, u16 ssn, bool start)
 {
 	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
-	struct iwl_mvm_add_sta_cmd_v6 cmd = {};
+	struct iwl_mvm_add_sta_cmd_v7 cmd = {};
 	int ret;
 	u32 status;
 
@@ -794,7 +794,7 @@ static int iwl_mvm_sta_tx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 			      int tid, u8 queue, bool start)
 {
 	struct iwl_mvm_sta *mvm_sta = (void *)sta->drv_priv;
-	struct iwl_mvm_add_sta_cmd_v6 cmd = {};
+	struct iwl_mvm_add_sta_cmd_v7 cmd = {};
 	int ret;
 	u32 status;
 
@@ -833,7 +833,7 @@ static int iwl_mvm_sta_tx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 	return ret;
 }
 
-static const u8 tid_to_ac[] = {
+static const u8 tid_to_mac80211_ac[] = {
 	IEEE80211_AC_BE,
 	IEEE80211_AC_BK,
 	IEEE80211_AC_BK,
@@ -844,6 +844,17 @@ static const u8 tid_to_ac[] = {
 	IEEE80211_AC_VO,
 };
 
+static const u8 tid_to_ucode_ac[] = {
+	AC_BE,
+	AC_BK,
+	AC_BK,
+	AC_BE,
+	AC_VI,
+	AC_VI,
+	AC_VO,
+	AC_VO,
+};
+
 int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			     struct ieee80211_sta *sta, u16 tid, u16 *ssn)
 {
@@ -874,7 +885,7 @@ int iwl_mvm_sta_tx_agg_start(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	}
 
 	/* the new tx queue is still connected to the same mac80211 queue */
-	mvm->queue_to_mac80211[txq_id] = vif->hw_queue[tid_to_ac[tid]];
+	mvm->queue_to_mac80211[txq_id] = vif->hw_queue[tid_to_mac80211_ac[tid]];
 
 	spin_lock_bh(&mvmsta->lock);
 	tid_data = &mvmsta->tid_data[tid];
@@ -916,7 +927,7 @@ int iwl_mvm_sta_tx_agg_oper(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	tid_data->ssn = 0xffff;
 	spin_unlock_bh(&mvmsta->lock);
 
-	fifo = iwl_mvm_ac_to_tx_fifo[tid_to_ac[tid]];
+	fifo = iwl_mvm_ac_to_tx_fifo[tid_to_mac80211_ac[tid]];
 
 	ret = iwl_mvm_sta_tx_agg(mvm, sta, tid, queue, true);
 	if (ret)
@@ -1411,7 +1422,7 @@ void iwl_mvm_sta_modify_ps_wake(struct iwl_mvm *mvm,
 				struct ieee80211_sta *sta)
 {
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-	struct iwl_mvm_add_sta_cmd_v6 cmd = {
+	struct iwl_mvm_add_sta_cmd_v7 cmd = {
 		.add_modify = STA_MODE_MODIFY,
 		.sta_id = mvmsta->sta_id,
 		.station_flags_msk = cpu_to_le32(STA_FLG_PS),
@@ -1427,28 +1438,102 @@ void iwl_mvm_sta_modify_ps_wake(struct iwl_mvm *mvm,
 void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 				       struct ieee80211_sta *sta,
 				       enum ieee80211_frame_release_type reason,
-				       u16 cnt)
+				       u16 cnt, u16 tids, bool more_data,
+				       bool agg)
 {
-	u16 sleep_state_flags =
-		(reason == IEEE80211_FRAME_RELEASE_UAPSD) ?
-			STA_SLEEP_STATE_UAPSD : STA_SLEEP_STATE_PS_POLL;
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
-	struct iwl_mvm_add_sta_cmd_v6 cmd = {
+	struct iwl_mvm_add_sta_cmd_v7 cmd = {
 		.add_modify = STA_MODE_MODIFY,
 		.sta_id = mvmsta->sta_id,
 		.modify_mask = STA_MODIFY_SLEEPING_STA_TX_COUNT,
 		.sleep_tx_count = cpu_to_le16(cnt),
 		.mac_id_n_color = cpu_to_le32(mvmsta->mac_id_n_color),
-		/*
-		 * Same modify mask for sleep_tx_count and sleep_state_flags so
-		 * we must set the sleep_state_flags too.
-		 */
-		.sleep_state_flags = cpu_to_le16(sleep_state_flags),
 	};
-	int ret;
+	int tid, ret;
+	unsigned long _tids = tids;
+
+	/* convert TIDs to ACs - we don't support TSPEC so that's OK
+	 * Note that this field is reserved and unused by firmware not
+	 * supporting GO uAPSD, so it's safe to always do this.
+	 */
+	for_each_set_bit(tid, &_tids, IWL_MAX_TID_COUNT)
+		cmd.awake_acs |= BIT(tid_to_ucode_ac[tid]);
+
+	/* If we're releasing frames from aggregation queues then check if the
+	 * all queues combined that we're releasing frames from have
+	 *  - more frames than the service period, in which case more_data
+	 *    needs to be set
+	 *  - fewer than 'cnt' frames, in which case we need to adjust the
+	 *    firmware command (but do that unconditionally)
+	 */
+	if (agg) {
+		int remaining = cnt;
+
+		spin_lock_bh(&mvmsta->lock);
+		for_each_set_bit(tid, &_tids, IWL_MAX_TID_COUNT) {
+			struct iwl_mvm_tid_data *tid_data;
+			u16 n_queued;
+
+			tid_data = &mvmsta->tid_data[tid];
+			if (WARN(tid_data->state != IWL_AGG_ON &&
+				 tid_data->state != IWL_EMPTYING_HW_QUEUE_DELBA,
+				 "TID %d state is %d\n",
+				 tid, tid_data->state)) {
+				spin_unlock_bh(&mvmsta->lock);
+				ieee80211_sta_eosp(sta);
+				return;
+			}
+
+			n_queued = iwl_mvm_tid_queued(tid_data);
+			if (n_queued > remaining) {
+				more_data = true;
+				remaining = 0;
+				break;
+			}
+			remaining -= n_queued;
+		}
+		spin_unlock_bh(&mvmsta->lock);
+
+		cmd.sleep_tx_count = cpu_to_le16(cnt - remaining);
+		if (WARN_ON(cnt - remaining == 0)) {
+			ieee80211_sta_eosp(sta);
+			return;
+		}
+	}
+
+	/* Note: this is ignored by firmware not supporting GO uAPSD */
+	if (more_data)
+		cmd.sleep_state_flags |= cpu_to_le16(STA_SLEEP_STATE_MOREDATA);
+
+	if (reason == IEEE80211_FRAME_RELEASE_PSPOLL) {
+		mvmsta->next_status_eosp = true;
+		cmd.sleep_state_flags |= cpu_to_le16(STA_SLEEP_STATE_PS_POLL);
+	} else {
+		cmd.sleep_state_flags |= cpu_to_le16(STA_SLEEP_STATE_UAPSD);
+	}
 
-	/* TODO: somehow the fw doesn't seem to take PS_POLL into account */
 	ret = iwl_mvm_send_add_sta_cmd(mvm, CMD_ASYNC, &cmd);
 	if (ret)
 		IWL_ERR(mvm, "Failed to send ADD_STA command (%d)\n", ret);
 }
+
+int iwl_mvm_rx_eosp_notif(struct iwl_mvm *mvm,
+			  struct iwl_rx_cmd_buffer *rxb,
+			  struct iwl_device_cmd *cmd)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_mvm_eosp_notification *notif = (void *)pkt->data;
+	struct ieee80211_sta *sta;
+	u32 sta_id = le32_to_cpu(notif->sta_id);
+
+	if (WARN_ON_ONCE(sta_id >= IWL_MVM_STATION_COUNT))
+		return 0;
+
+	rcu_read_lock();
+	sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
+	if (!IS_ERR_OR_NULL(sta))
+		ieee80211_sta_eosp(sta);
+	rcu_read_unlock();
+
+	return 0;
+}
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index 4968d02..64f9a1b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -195,24 +195,33 @@ struct iwl_mvm;
 /**
  * DOC: AP mode - PS
  *
- * When a station is asleep, the fw will set it as "asleep". All the
- * non-aggregation frames to that station will be dropped by the fw
- * (%TX_STATUS_FAIL_DEST_PS failure code).
+ * When a station is asleep, the fw will set it as "asleep". All frames on
+ * shared queues (i.e. non-aggregation queues) to that station will be dropped
+ * by the fw (%TX_STATUS_FAIL_DEST_PS failure code).
+ *
  * AMPDUs are in a separate queue that is stopped by the fw. We just need to
- * let mac80211 know how many frames we have in these queues so that it can
+ * let mac80211 know when there are frames in these queues so that it can
  * properly handle trigger frames.
- * When the a trigger frame is received, mac80211 tells the driver to send
- * frames from the AMPDU queues or AC queue depending on which queue are
- * delivery-enabled and what TID has frames to transmit (Note that mac80211 has
- * all the knowledege since all the non-agg frames are buffered / filtered, and
- * the driver tells mac80211 about agg frames). The driver needs to tell the fw
- * to let frames out even if the station is asleep. This is done by
- * %iwl_mvm_sta_modify_sleep_tx_count.
- * When we receive a frame from that station with PM bit unset, the
- * driver needs to let the fw know that this station isn't alseep any more.
- * This is done by %iwl_mvm_sta_modify_ps_wake.
- *
- * TODO - EOSP handling
+ *
+ * When a trigger frame is received, mac80211 tells the driver to send frames
+ * from the AMPDU queues or sends frames to non-aggregation queues itself,
+ * depending on which ACs are delivery-enabled and what TID has frames to
+ * transmit. Note that mac80211 has all the knowledege since all the non-agg
+ * frames are buffered / filtered, and the driver tells mac80211 about agg
+ * frames). The driver needs to tell the fw to let frames out even if the
+ * station is asleep. This is done by %iwl_mvm_sta_modify_sleep_tx_count.
+ *
+ * When we receive a frame from that station with PM bit unset, the driver
+ * needs to let the fw know that this station isn't asleep any more. This is
+ * done by %iwl_mvm_sta_modify_ps_wake in response to mac80211 signalling the
+ * station's wakeup.
+ *
+ * For a GO, the Service Period might be cut short due to an absence period
+ * of the GO. In this (and all other cases) the firmware notifies us with the
+ * EOSP_NOTIFICATION, and we notify mac80211 of that. Further frames that we
+ * already sent to the device will be rejected again.
+ *
+ * See also "AP support for powersaving clients" in mac80211.h.
  */
 
 /**
@@ -261,6 +270,12 @@ struct iwl_mvm_tid_data {
 	u16 ssn;
 };
 
+static inline u16 iwl_mvm_tid_queued(struct iwl_mvm_tid_data *tid_data)
+{
+	return ieee80211_sn_sub(IEEE80211_SEQ_TO_SN(tid_data->seq_number),
+				tid_data->next_reclaimed);
+}
+
 /**
  * struct iwl_mvm_sta - representation of a station in the driver
  * @sta_id: the index of the station in the fw (will be replaced by id_n_color)
@@ -270,6 +285,8 @@ struct iwl_mvm_tid_data {
  *	tid.
  * @max_agg_bufsize: the maximal size of the AGG buffer for this station
  * @bt_reduced_txpower: is reduced tx power enabled for this station
+ * @next_status_eosp: the next reclaimed packet is a PS-Poll response and
+ *	we need to signal the EOSP
  * @lock: lock to protect the whole struct. Since %tid_data is access from Tx
  * and from Tx response flow, it needs a spinlock.
  * @tid_data: per tid data. Look at %iwl_mvm_tid_data.
@@ -288,6 +305,7 @@ struct iwl_mvm_sta {
 	u16 tid_disable_agg;
 	u8 max_agg_bufsize;
 	bool bt_reduced_txpower;
+	bool next_status_eosp;
 	spinlock_t lock;
 	struct iwl_mvm_tid_data tid_data[IWL_MAX_TID_COUNT];
 	struct iwl_lq_sta lq_sta;
@@ -345,6 +363,10 @@ void iwl_mvm_update_tkip_key(struct iwl_mvm *mvm,
 			     struct ieee80211_sta *sta, u32 iv32,
 			     u16 *phase1key);
 
+int iwl_mvm_rx_eosp_notif(struct iwl_mvm *mvm,
+			  struct iwl_rx_cmd_buffer *rxb,
+			  struct iwl_device_cmd *cmd);
+
 /* AMPDU */
 int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		       int tid, u16 ssn, bool start);
@@ -375,7 +397,8 @@ void iwl_mvm_sta_modify_ps_wake(struct iwl_mvm *mvm,
 void iwl_mvm_sta_modify_sleep_tx_count(struct iwl_mvm *mvm,
 				       struct ieee80211_sta *sta,
 				       enum ieee80211_frame_release_type reason,
-				       u16 cnt);
+				       u16 cnt, u16 tids, bool more_data,
+				       bool agg);
 int iwl_mvm_drain_sta(struct iwl_mvm *mvm, struct iwl_mvm_sta *mvmsta,
 		      bool drain);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 90378c2..8d18bf2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -377,6 +377,13 @@ int iwl_mvm_tx_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 	tx_cmd = (struct iwl_tx_cmd *)dev_cmd->payload;
 	/* From now on, we cannot access info->control */
 
+	/*
+	 * we handle that entirely ourselves -- for uAPSD the firmware
+	 * will always send a notification, and for PS-Poll responses
+	 * we'll notify mac80211 when getting frame status
+	 */
+	info->flags &= ~IEEE80211_TX_STATUS_EOSP;
+
 	spin_lock(&mvmsta->lock);
 
 	if (ieee80211_is_data_qos(fc) && !ieee80211_is_qos_nullfunc(fc)) {
@@ -437,6 +444,17 @@ static void iwl_mvm_check_ratid_empty(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvmsta->lock);
 
+	if ((tid_data->state == IWL_AGG_ON ||
+	     tid_data->state == IWL_EMPTYING_HW_QUEUE_DELBA) &&
+	    iwl_mvm_tid_queued(tid_data) == 0) {
+		/*
+		 * Now that this aggregation queue is empty tell mac80211 so it
+		 * knows we no longer have frames buffered for the station on
+		 * this TID (for the TIM bitmap calculation.)
+		 */
+		ieee80211_sta_set_buffered(sta, tid, false);
+	}
+
 	if (tid_data->ssn != tid_data->next_reclaimed)
 		return;
 
@@ -674,6 +692,11 @@ static void iwl_mvm_rx_tx_cmd_single(struct iwl_mvm *mvm,
 			iwl_mvm_check_ratid_empty(mvm, sta, tid);
 			spin_unlock_bh(&mvmsta->lock);
 		}
+
+		if (mvmsta->next_status_eosp) {
+			mvmsta->next_status_eosp = false;
+			ieee80211_sta_eosp(sta);
+		}
 	} else {
 		sta = NULL;
 		mvmsta = NULL;
-- 
1.7.9.5

