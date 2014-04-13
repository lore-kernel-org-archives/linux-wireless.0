Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:41948 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbaDMTVB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:21:01 -0400
Received: by mail-wg0-f46.google.com with SMTP id b13so7409985wgh.5
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:21:00 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 34/47] iwlwifi: remove IWL_UCODE_TLV_FLAGS_D3_CONTINUITY_API flag
Date: Sun, 13 Apr 2014 22:19:49 +0300
Message-Id: <1397416802-32403-34-git-send-email-egrumbach@gmail.com> (sfid-20140413_213515_391629_1E833068)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the supported firmwares have this flag set.

Reviewed-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h        |  3 --
 drivers/net/wireless/iwlwifi/mvm/d3.c        | 72 +++++++++-------------------
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h | 17 +------
 drivers/net/wireless/iwlwifi/mvm/ops.c       |  2 +-
 4 files changed, 24 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index f87ab69..fbfdba7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -81,8 +81,6 @@
  *	(rather than two) IPv6 addresses
  * @IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID: not sending a probe with the SSID element
  *	from the probe request template.
- * @IWL_UCODE_TLV_FLAGS_D3_CONTINUITY_API: modified D3 API to allow keeping
- *	connection when going back to D0
  * @IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL: new NS offload (small version)
  * @IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE: new NS offload (large version)
  * @IWL_UCODE_TLV_FLAGS_SCHED_SCAN: this uCode image supports scheduled scan.
@@ -107,7 +105,6 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_SHORT_BL		= BIT(7),
 	IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS	= BIT(10),
 	IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID	= BIT(12),
-	IWL_UCODE_TLV_FLAGS_D3_CONTINUITY_API	= BIT(14),
 	IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_SMALL	= BIT(15),
 	IWL_UCODE_TLV_FLAGS_NEW_NSOFFL_LARGE	= BIT(16),
 	IWL_UCODE_TLV_FLAGS_SCHED_SCAN		= BIT(17),
diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index e56f5a0..5c9f14d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -744,10 +744,8 @@ static int iwl_mvm_get_last_nonqos_seq(struct iwl_mvm *mvm,
 	int err;
 	u32 size;
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_D3_CONTINUITY_API) {
-		cmd.data[0] = &query_cmd;
-		cmd.len[0] = sizeof(query_cmd);
-	}
+	cmd.data[0] = &query_cmd;
+	cmd.len[0] = sizeof(query_cmd);
 
 	err = iwl_mvm_send_cmd(mvm, &cmd);
 	if (err)
@@ -758,10 +756,8 @@ static int iwl_mvm_get_last_nonqos_seq(struct iwl_mvm *mvm,
 		err = -EINVAL;
 	} else {
 		err = le16_to_cpup((__le16 *)cmd.resp_pkt->data);
-		/* new API returns next, not last-used seqno */
-		if (mvm->fw->ucode_capa.flags &
-				IWL_UCODE_TLV_FLAGS_D3_CONTINUITY_API)
-			err = (u16) (err - 0x10);
+		/* firmware returns next, not last-used seqno */
+		err = (u16) (err - 0x10);
 	}
 
 	iwl_free_resp(&cmd);
@@ -785,10 +781,6 @@ void iwl_mvm_set_last_nonqos_seq(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	mvmvif->seqno_valid = false;
 
-	if (!(mvm->fw->ucode_capa.flags &
-			IWL_UCODE_TLV_FLAGS_D3_CONTINUITY_API))
-		return;
-
 	if (iwl_mvm_send_cmd_pdu(mvm, NON_QOS_TX_COUNTER_CMD, CMD_SYNC,
 				 sizeof(query_cmd), &query_cmd))
 		IWL_ERR(mvm, "failed to set non-QoS seqno\n");
@@ -1277,7 +1269,7 @@ static void iwl_mvm_set_tkip_rx_seq(struct tkip_sc *scs,
 }
 
 static void iwl_mvm_set_key_rx_seq(struct ieee80211_key_conf *key,
-				   struct iwl_wowlan_status_v6 *status)
+				   struct iwl_wowlan_status *status)
 {
 	union iwl_all_tsc_rsc *rsc = &status->gtk.rsc.all_tsc_rsc;
 
@@ -1294,7 +1286,7 @@ static void iwl_mvm_set_key_rx_seq(struct ieee80211_key_conf *key,
 }
 
 struct iwl_mvm_d3_gtk_iter_data {
-	struct iwl_wowlan_status_v6 *status;
+	struct iwl_wowlan_status *status;
 	void *last_gtk;
 	u32 cipher;
 	bool find_phase, unhandled_cipher;
@@ -1370,7 +1362,7 @@ static void iwl_mvm_d3_update_gtks(struct ieee80211_hw *hw,
 
 static bool iwl_mvm_setup_connection_keep(struct iwl_mvm *mvm,
 					  struct ieee80211_vif *vif,
-					  struct iwl_wowlan_status_v6 *status)
+					  struct iwl_wowlan_status *status)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_d3_gtk_iter_data gtkdata = {
@@ -1468,7 +1460,7 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 		.flags = CMD_SYNC | CMD_WANT_SKB,
 	};
 	struct iwl_wowlan_status_data status;
-	struct iwl_wowlan_status_v6 *status_v6;
+	struct iwl_wowlan_status *fw_status;
 	int ret, len, status_size, i;
 	bool keep;
 	struct ieee80211_sta *ap_sta;
@@ -1505,10 +1497,7 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 	if (!cmd.resp_pkt)
 		goto out_unlock;
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_D3_CONTINUITY_API)
-		status_size = sizeof(struct iwl_wowlan_status_v6);
-	else
-		status_size = sizeof(struct iwl_wowlan_status_v4);
+	status_size = sizeof(*fw_status);
 
 	len = iwl_rx_packet_payload_len(cmd.resp_pkt);
 	if (len < status_size) {
@@ -1516,35 +1505,18 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 		goto out_free_resp;
 	}
 
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_D3_CONTINUITY_API) {
-		status_v6 = (void *)cmd.resp_pkt->data;
-
-		status.pattern_number = le16_to_cpu(status_v6->pattern_number);
-		for (i = 0; i < 8; i++)
-			status.qos_seq_ctr[i] =
-				le16_to_cpu(status_v6->qos_seq_ctr[i]);
-		status.wakeup_reasons = le32_to_cpu(status_v6->wakeup_reasons);
-		status.wake_packet_length =
-			le32_to_cpu(status_v6->wake_packet_length);
-		status.wake_packet_bufsize =
-			le32_to_cpu(status_v6->wake_packet_bufsize);
-		status.wake_packet = status_v6->wake_packet;
-	} else {
-		struct iwl_wowlan_status_v4 *status_v4;
-		status_v6 = NULL;
-		status_v4 = (void *)cmd.resp_pkt->data;
-
-		status.pattern_number = le16_to_cpu(status_v4->pattern_number);
-		for (i = 0; i < 8; i++)
-			status.qos_seq_ctr[i] =
-				le16_to_cpu(status_v4->qos_seq_ctr[i]);
-		status.wakeup_reasons = le32_to_cpu(status_v4->wakeup_reasons);
-		status.wake_packet_length =
-			le32_to_cpu(status_v4->wake_packet_length);
-		status.wake_packet_bufsize =
-			le32_to_cpu(status_v4->wake_packet_bufsize);
-		status.wake_packet = status_v4->wake_packet;
-	}
+	fw_status = (void *)cmd.resp_pkt->data;
+
+	status.pattern_number = le16_to_cpu(fw_status->pattern_number);
+	for (i = 0; i < 8; i++)
+		status.qos_seq_ctr[i] =
+			le16_to_cpu(fw_status->qos_seq_ctr[i]);
+	status.wakeup_reasons = le32_to_cpu(fw_status->wakeup_reasons);
+	status.wake_packet_length =
+		le32_to_cpu(fw_status->wake_packet_length);
+	status.wake_packet_bufsize =
+		le32_to_cpu(fw_status->wake_packet_bufsize);
+	status.wake_packet = fw_status->wake_packet;
 
 	if (len != status_size + ALIGN(status.wake_packet_bufsize, 4)) {
 		IWL_ERR(mvm, "Invalid WoWLAN status response!\n");
@@ -1571,7 +1543,7 @@ static bool iwl_mvm_query_wakeup_reasons(struct iwl_mvm *mvm,
 
 	iwl_mvm_report_wakeup_reasons(mvm, vif, &status);
 
-	keep = iwl_mvm_setup_connection_keep(mvm, vif, status_v6);
+	keep = iwl_mvm_setup_connection_keep(mvm, vif, fw_status);
 
 	iwl_free_resp(&cmd);
 	return keep;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
index 10fcc1a..13696fe 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
@@ -345,21 +345,6 @@ enum iwl_wowlan_wakeup_reason {
 	IWL_WOWLAN_WAKEUP_BY_REM_WAKE_WAKEUP_PACKET		= BIT(12),
 }; /* WOWLAN_WAKE_UP_REASON_API_E_VER_2 */
 
-struct iwl_wowlan_status_v4 {
-	__le64 replay_ctr;
-	__le16 pattern_number;
-	__le16 non_qos_seq_ctr;
-	__le16 qos_seq_ctr[8];
-	__le32 wakeup_reasons;
-	__le32 rekey_status;
-	__le32 num_of_gtk_rekeys;
-	__le32 transmitted_ndps;
-	__le32 received_beacons;
-	__le32 wake_packet_length;
-	__le32 wake_packet_bufsize;
-	u8 wake_packet[]; /* can be truncated from _length to _bufsize */
-} __packed; /* WOWLAN_STATUSES_API_S_VER_4 */
-
 struct iwl_wowlan_gtk_status {
 	u8 key_index;
 	u8 reserved[3];
@@ -368,7 +353,7 @@ struct iwl_wowlan_gtk_status {
 	struct iwl_wowlan_rsc_tsc_params_cmd rsc;
 } __packed;
 
-struct iwl_wowlan_status_v6 {
+struct iwl_wowlan_status {
 	struct iwl_wowlan_gtk_status gtk;
 	__le64 replay_ctr;
 	__le16 pattern_number;
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 7cb401b..fd53128 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -1144,7 +1144,7 @@ static void iwl_mvm_d0i3_exit_work(struct work_struct *wk)
 		.id = WOWLAN_GET_STATUSES,
 		.flags = CMD_SYNC | CMD_HIGH_PRIO | CMD_WANT_SKB,
 	};
-	struct iwl_wowlan_status_v6 *status;
+	struct iwl_wowlan_status *status;
 	int ret;
 	u32 disconnection_reasons, wakeup_reasons;
 	__le16 *qos_seq = NULL;
-- 
1.8.3.2

