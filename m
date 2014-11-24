Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:33879 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbaKXOgJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:09 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so5878080wiv.5
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:08 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 43/75] iwlwifi: mvm: configure TDLS peers to FW
Date: Mon, 24 Nov 2014 16:34:19 +0200
Message-Id: <1416839691-28533-43-git-send-email-egrumbach@gmail.com> (sfid-20141124_153624_378002_451426C9)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Send a dedicated TDLS_CONFIG command when a TDLS peer joins/leaves. The
fields for the command are mostly place-holders, as most of the FW
functionality is not implemented. In the future the dedicated FW TID
will be used for channel-switching and buffer-sta functionality.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 63 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h    |  7 +++
 drivers/net/wireless/iwlwifi/mvm/ops.c    |  1 +
 drivers/net/wireless/iwlwifi/mvm/tdls.c   | 80 ++++++++++++++++++++++++++++---
 4 files changed, 145 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index a71fad2e..0f3c07a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -131,6 +131,7 @@ enum {
 	/* TDLS */
 	TDLS_CHANNEL_SWITCH_CMD = 0x27,
 	TDLS_CHANNEL_SWITCH_NOTIFICATION = 0xaa,
+	TDLS_CONFIG_CMD = 0xa7,
 
 	/* MAC and Binding commands */
 	MAC_CONTEXT_CMD = 0x28,
@@ -1800,4 +1801,66 @@ struct iwl_tdls_channel_switch_notif {
 	__le32 sta_id;
 } __packed; /* TDLS_STA_CHANNEL_SWITCH_NTFY_API_S_VER_1 */
 
+/**
+ * TDLS station info
+ *
+ * @sta_id: station id of the TDLS peer
+ * @tx_to_peer_tid: TID reserved vs. the peer for FW based Tx
+ * @tx_to_peer_ssn: initial SSN the FW should use for Tx on its TID vs the peer
+ * @is_initiator: 1 if the peer is the TDLS link initiator, 0 otherwise
+ */
+struct iwl_tdls_sta_info {
+	u8 sta_id;
+	u8 tx_to_peer_tid;
+	__le16 tx_to_peer_ssn;
+	__le32 is_initiator;
+} __packed; /* TDLS_STA_INFO_VER_1 */
+
+/**
+ * TDLS basic config command
+ *
+ * @id_and_color: MAC id and color being configured
+ * @tdls_peer_count: amount of currently connected TDLS peers
+ * @tx_to_ap_tid: TID reverved vs. the AP for FW based Tx
+ * @tx_to_ap_ssn: initial SSN the FW should use for Tx on its TID vs. the AP
+ * @sta_info: per-station info. Only the first tdls_peer_count entries are set
+ * @pti_req_data_offset: offset of network-level data for the PTI template
+ * @pti_req_tx_cmd: Tx parameters for PTI request template
+ * @pti_req_template: PTI request template data
+ */
+struct iwl_tdls_config_cmd {
+	__le32 id_and_color; /* mac id and color */
+	u8 tdls_peer_count;
+	u8 tx_to_ap_tid;
+	__le16 tx_to_ap_ssn;
+	struct iwl_tdls_sta_info sta_info[IWL_MVM_TDLS_STA_COUNT];
+
+	__le32 pti_req_data_offset;
+	struct iwl_tx_cmd pti_req_tx_cmd;
+	u8 pti_req_template[0];
+} __packed; /* TDLS_CONFIG_CMD_API_S_VER_1 */
+
+/**
+ * TDLS per-station config information from FW
+ *
+ * @sta_id: station id of the TDLS peer
+ * @tx_to_peer_last_seq: last sequence number used by FW during FW-based Tx to
+ *	the peer
+ */
+struct iwl_tdls_config_sta_info_res {
+	__le16 sta_id;
+	__le16 tx_to_peer_last_seq;
+} __packed; /* TDLS_STA_INFO_RSP_VER_1 */
+
+/**
+ * TDLS config information from FW
+ *
+ * @tx_to_ap_last_seq: last sequence number used by FW during FW-based Tx to AP
+ * @sta_info: per-station TDLS config information
+ */
+struct iwl_tdls_config_res {
+	__le32 tx_to_ap_last_seq;
+	struct iwl_tdls_config_sta_info_res sta_info[IWL_MVM_TDLS_STA_COUNT];
+} __packed; /* TDLS_CONFIG_RSP_API_S_VER_1 */
+
 #endif /* __fw_api_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index db52f65..be0285d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1242,6 +1242,13 @@ int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		      bool added_vif);
 
 /* TDLS */
+
+/*
+ * We use TID 4 (VI) as a FW-used-only TID when TDLS connections are present.
+ * This TID is marked as used vs the AP and all connected TDLS peers.
+ */
+#define IWL_MVM_TDLS_FW_TID 4
+
 int iwl_mvm_tdls_sta_count(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 void iwl_mvm_teardown_tdls_peers(struct iwl_mvm *mvm);
 void iwl_mvm_recalc_tdls_state(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 8ee7362..9f9c767 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -354,6 +354,7 @@ static const char *const iwl_mvm_cmd_strings[REPLY_MAX] = {
 	CMD(SCAN_COMPLETE_UMAC),
 	CMD(TDLS_CHANNEL_SWITCH_CMD),
 	CMD(TDLS_CHANNEL_SWITCH_NOTIFICATION),
+	CMD(TDLS_CONFIG_CMD),
 };
 #undef CMD
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/tdls.c b/drivers/net/wireless/iwlwifi/mvm/tdls.c
index 66c82df..6dc381b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tdls.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tdls.c
@@ -113,17 +113,85 @@ int iwl_mvm_tdls_sta_count(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	return count;
 }
 
+static void iwl_mvm_tdls_config(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct iwl_rx_packet *pkt;
+	struct iwl_tdls_config_res *resp;
+	struct iwl_tdls_config_cmd tdls_cfg_cmd = {};
+	struct iwl_host_cmd cmd = {
+		.id = TDLS_CONFIG_CMD,
+		.flags = CMD_WANT_SKB,
+		.data = { &tdls_cfg_cmd, },
+		.len = { sizeof(struct iwl_tdls_config_cmd), },
+	};
+	struct ieee80211_sta *sta;
+	int ret, i, cnt;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	lockdep_assert_held(&mvm->mutex);
+
+	tdls_cfg_cmd.id_and_color =
+		cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color));
+	tdls_cfg_cmd.tx_to_ap_tid = IWL_MVM_TDLS_FW_TID;
+	tdls_cfg_cmd.tx_to_ap_ssn = cpu_to_le16(0); /* not used for now */
+
+	/* for now the Tx cmd is empty and unused */
+
+	/* populate TDLS peer data */
+	cnt = 0;
+	for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
+		sta = rcu_dereference_protected(mvm->fw_id_to_mac_id[i],
+						lockdep_is_held(&mvm->mutex));
+		if (IS_ERR_OR_NULL(sta) || !sta->tdls)
+			continue;
+
+		tdls_cfg_cmd.sta_info[cnt].sta_id = i;
+		tdls_cfg_cmd.sta_info[cnt].tx_to_peer_tid =
+							IWL_MVM_TDLS_FW_TID;
+		tdls_cfg_cmd.sta_info[cnt].tx_to_peer_ssn = cpu_to_le16(0);
+		tdls_cfg_cmd.sta_info[cnt].is_initiator =
+				cpu_to_le32(sta->tdls_initiator ? 1 : 0);
+
+		cnt++;
+	}
+
+	tdls_cfg_cmd.tdls_peer_count = cnt;
+	IWL_DEBUG_TDLS(mvm, "send TDLS config to FW for %d peers\n", cnt);
+
+	ret = iwl_mvm_send_cmd(mvm, &cmd);
+	if (WARN_ON_ONCE(ret))
+		return;
+
+	pkt = cmd.resp_pkt;
+	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
+		IWL_ERR(mvm, "Bad return from TDLS_CONFIG_COMMAND (0x%08X)\n",
+			pkt->hdr.flags);
+		goto exit;
+	}
+
+	if (WARN_ON_ONCE(iwl_rx_packet_payload_len(pkt) != sizeof(*resp)))
+		goto exit;
+
+	/* we don't really care about the response at this point */
+
+exit:
+	iwl_free_resp(&cmd);
+}
+
 void iwl_mvm_recalc_tdls_state(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			       bool sta_added)
 {
 	int tdls_sta_cnt = iwl_mvm_tdls_sta_count(mvm, vif);
 
-	/*
-	 * Disable ps when the first TDLS sta is added and re-enable it
-	 * when the last TDLS sta is removed
-	 */
-	if ((tdls_sta_cnt == 1 && sta_added) ||
-	    (tdls_sta_cnt == 0 && !sta_added))
+	/* when the first peer joins, send a power update first */
+	if (tdls_sta_cnt == 1 && sta_added)
+		iwl_mvm_power_update_mac(mvm);
+
+	/* configure the FW with TDLS peer info */
+	iwl_mvm_tdls_config(mvm, vif);
+
+	/* when the last peer leaves, send a power update last */
+	if (tdls_sta_cnt == 0 && !sta_added)
 		iwl_mvm_power_update_mac(mvm);
 }
 
-- 
1.9.1

