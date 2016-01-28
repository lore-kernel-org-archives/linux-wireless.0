Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20530 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbcA1OTf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jan 2016 09:19:35 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3/3] iwlwifi: mvm: support filtered frames notification
Date: Thu, 28 Jan 2016 16:19:26 +0200
Message-Id: <1453990766-2065-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160128_152030_708474_DEBEABB0)
In-Reply-To: <1453990766-2065-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1453990766-2065-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

During d0i3 frames might be filtered by the FW and this may
cause reordering buffer a delay - as the frames will not be
received and reorder will time out.

Introduce an API function to receive notification of filtered
frames and pass the information to the mac80211.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 22 +++++++++++
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h    |  2 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c    |  4 ++
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c     | 49 +++++++++++++++++++++++++
 4 files changed, 77 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 82049bb..6ae0f4b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -119,6 +119,8 @@ enum {
 	SCAN_ABORT_UMAC = 0xe,
 	SCAN_COMPLETE_UMAC = 0xf,
 
+	BA_WINDOW_STATUS_NOTIFICATION_ID = 0x13,
+
 	/* station table */
 	ADD_STA_KEY = 0x17,
 	ADD_STA = 0x18,
@@ -1271,6 +1273,26 @@ struct iwl_fw_bcast_filter {
 	struct iwl_fw_bcast_filter_attr attrs[MAX_BCAST_FILTER_ATTRS];
 } __packed; /* BCAST_FILTER_S_VER_1 */
 
+#define BA_WINDOW_STREAMS_MAX		16
+#define BA_WINDOW_STATUS_TID_MSK	0x000F
+#define BA_WINDOW_STATUS_STA_ID_POS	4
+#define BA_WINDOW_STATUS_STA_ID_MSK	0x01F0
+#define BA_WINDOW_STATUS_VALID_MSK	BIT(9)
+
+/**
+ * struct iwl_ba_window_status_notif - reordering window's status notification
+ * @bitmap: bitmap of received frames [start_seq_num + 0]..[start_seq_num + 63]
+ * @ra_tid: bit 3:0 - TID, bit 8:4 - STA_ID, bit 9 - valid
+ * @start_seq_num: the start sequence number of the bitmap
+ * @mpdu_rx_count: the number of received MPDUs since entering D0i3
+ */
+struct iwl_ba_window_status_notif {
+	__le64 bitmap[BA_WINDOW_STREAMS_MAX];
+	__le16 ra_tid[BA_WINDOW_STREAMS_MAX];
+	__le32 start_seq_num[BA_WINDOW_STREAMS_MAX];
+	__le16 mpdu_rx_count[BA_WINDOW_STREAMS_MAX];
+} __packed; /* BA_WINDOW_STATUS_NTFY_API_S_VER_1 */
+
 /**
  * struct iwl_fw_bcast_mac - per-mac broadcast filtering configuration.
  * @default_discard: default action for this mac (discard (1) / pass (0)).
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 5f3ac8c..f3bcc87 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1184,6 +1184,8 @@ void iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 			     struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_rx_missed_beacons_notif(struct iwl_mvm *mvm,
 				     struct iwl_rx_cmd_buffer *rxb);
+void iwl_mvm_window_status_notif(struct iwl_mvm *mvm,
+				 struct iwl_rx_cmd_buffer *rxb);
 void iwl_mvm_mac_ctxt_recalc_tsf_id(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif);
 unsigned long iwl_mvm_get_used_hw_queues(struct iwl_mvm *mvm,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 89ea70d..f51ccaf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -235,6 +235,9 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 	RX_HANDLER(ANTENNA_COUPLING_NOTIFICATION,
 		   iwl_mvm_rx_ant_coupling_notif, true),
 
+	RX_HANDLER(BA_WINDOW_STATUS_NOTIFICATION_ID,
+		   iwl_mvm_window_status_notif, false),
+
 	RX_HANDLER(TIME_EVENT_NOTIFICATION, iwl_mvm_rx_time_event_notif, false),
 	RX_HANDLER(MCC_CHUB_UPDATE_CMD, iwl_mvm_rx_chub_update_mcc, true),
 
@@ -289,6 +292,7 @@ static const struct iwl_hcmd_names iwl_mvm_legacy_names[] = {
 	HCMD_NAME(SCAN_COMPLETE_UMAC),
 	HCMD_NAME(TOF_CMD),
 	HCMD_NAME(TOF_NOTIFICATION),
+	HCMD_NAME(BA_WINDOW_STATUS_NOTIFICATION_ID),
 	HCMD_NAME(ADD_STA_KEY),
 	HCMD_NAME(ADD_STA),
 	HCMD_NAME(REMOVE_STA),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 145ec68..f964952 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -622,3 +623,51 @@ void iwl_mvm_rx_statistics(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 {
 	iwl_mvm_handle_rx_statistics(mvm, rxb_addr(rxb));
 }
+
+void iwl_mvm_window_status_notif(struct iwl_mvm *mvm,
+				 struct iwl_rx_cmd_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_ba_window_status_notif *notif = (void *)pkt->data;
+	int i;
+	u32 pkt_len = iwl_rx_packet_payload_len(pkt);
+
+	if (WARN_ONCE(pkt_len != sizeof(*notif),
+		      "Received window status notification of wrong size (%u)\n",
+		      pkt_len))
+		return;
+
+	rcu_read_lock();
+	for (i = 0; i < BA_WINDOW_STREAMS_MAX; i++) {
+		struct ieee80211_sta *sta;
+		u8 sta_id, tid;
+		u64 bitmap;
+		u32 ssn;
+		u16 ratid;
+		u16 received_mpdu;
+
+		ratid = le16_to_cpu(notif->ra_tid[i]);
+		/* check that this TID is valid */
+		if (!(ratid & BA_WINDOW_STATUS_VALID_MSK))
+			continue;
+
+		received_mpdu = le16_to_cpu(notif->mpdu_rx_count[i]);
+		if (received_mpdu == 0)
+			continue;
+
+		tid = ratid & BA_WINDOW_STATUS_TID_MSK;
+		/* get the station */
+		sta_id = (ratid & BA_WINDOW_STATUS_STA_ID_MSK)
+			 >> BA_WINDOW_STATUS_STA_ID_POS;
+		sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
+		if (IS_ERR_OR_NULL(sta))
+			continue;
+		bitmap = le64_to_cpu(notif->bitmap[i]);
+		ssn = le32_to_cpu(notif->start_seq_num[i]);
+
+		/* update mac80211 with the bitmap for the reordering buffer */
+		ieee80211_mark_rx_ba_filtered_frames(sta, tid, ssn, bitmap,
+						     received_mpdu);
+	}
+	rcu_read_unlock();
+}
-- 
2.5.0

