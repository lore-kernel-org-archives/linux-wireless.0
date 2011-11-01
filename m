Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55775 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab1KAMzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 08:55:54 -0400
Received: by ywf7 with SMTP id 7so2185523ywf.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2011 05:55:54 -0700 (PDT)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH v3 1/3] NFC: Update names and structs to NCI spec 1.0 d18
Date: Tue,  1 Nov 2011 14:54:55 +0200
Message-Id: <1320152097-2711-2-git-send-email-ilane@ti.com> (sfid-20111101_135558_902317_D449FB3E)
In-Reply-To: <1320152097-2711-1-git-send-email-ilane@ti.com>
References: <1320152097-2711-1-git-send-email-ilane@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Addition, deletion and modification of NCI constants.
Changes in NCI commands, responses and notifications structures.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 include/net/nfc/nci.h      |  183 ++++++++++++++++++++++++++------------------
 include/net/nfc/nci_core.h |   11 ++-
 net/nfc/nci/core.c         |    7 +-
 net/nfc/nci/data.c         |    5 +-
 net/nfc/nci/lib.c          |    8 +--
 net/nfc/nci/ntf.c          |  137 +++++++++++++++++++++------------
 net/nfc/nci/rsp.c          |   58 +++++++++------
 7 files changed, 244 insertions(+), 165 deletions(-)

diff --git a/include/net/nfc/nci.h b/include/net/nfc/nci.h
index 39b85bc..37fe8b3 100644
--- a/include/net/nfc/nci.h
+++ b/include/net/nfc/nci.h
@@ -33,47 +33,49 @@
 #define NCI_MAX_NUM_RF_CONFIGS					10
 #define NCI_MAX_NUM_CONN					10
 
-/* NCI Status Codes */
-#define	NCI_STATUS_OK						0x00
-#define	NCI_STATUS_REJECTED					0x01
-#define	NCI_STATUS_MESSAGE_CORRUPTED				0x02
-#define	NCI_STATUS_BUFFER_FULL					0x03
-#define	NCI_STATUS_FAILED					0x04
-#define	NCI_STATUS_NOT_INITIALIZED				0x05
-#define	NCI_STATUS_SYNTAX_ERROR					0x06
-#define	NCI_STATUS_SEMANTIC_ERROR				0x07
-#define	NCI_STATUS_UNKNOWN_GID					0x08
-#define	NCI_STATUS_UNKNOWN_OID					0x09
-#define	NCI_STATUS_INVALID_PARAM				0x0a
-#define	NCI_STATUS_MESSAGE_SIZE_EXCEEDED			0x0b
-/* Discovery Specific Status Codes */
-#define	NCI_STATUS_DISCOVERY_ALREADY_STARTED			0xa0
-#define	NCI_STATUS_DISCOVERY_TARGET_ACTIVATION_FAILED		0xa1
+/* Generic Status Codes */
+#define NCI_STATUS_OK						0x00
+#define NCI_STATUS_REJECTED					0x01
+#define NCI_STATUS_RF_FRAME_CORRUPTED				0x02
+#define NCI_STATUS_FAILED					0x03
+#define NCI_STATUS_NOT_INITIALIZED				0x04
+#define NCI_STATUS_SYNTAX_ERROR					0x05
+#define NCI_STATUS_SEMANTIC_ERROR				0x06
+#define NCI_STATUS_UNKNOWN_GID					0x07
+#define NCI_STATUS_UNKNOWN_OID					0x08
+#define NCI_STATUS_INVALID_PARAM				0x09
+#define NCI_STATUS_MESSAGE_SIZE_EXCEEDED			0x0a
+/* RF Discovery Specific Status Codes */
+#define NCI_STATUS_DISCOVERY_ALREADY_STARTED			0xa0
+#define NCI_STATUS_DISCOVERY_TARGET_ACTIVATION_FAILED		0xa1
+#define NCI_STATUS_DISCOVERY_TEAR_DOWN				0xa2
 /* RF Interface Specific Status Codes */
-#define	NCI_STATUS_RF_TRANSMISSION_ERROR			0xb0
-#define	NCI_STATUS_RF_PROTOCOL_ERROR				0xb1
-#define	NCI_STATUS_RF_TIMEOUT_ERROR				0xb2
-#define	NCI_STATUS_RF_LINK_LOSS_ERROR				0xb3
+#define NCI_STATUS_RF_TRANSMISSION_ERROR			0xb0
+#define NCI_STATUS_RF_PROTOCOL_ERROR				0xb1
+#define NCI_STATUS_RF_TIMEOUT_ERROR				0xb2
 /* NFCEE Interface Specific Status Codes */
-#define	NCI_STATUS_MAX_ACTIVE_NFCEE_INTERFACES_REACHED		0xc0
-#define	NCI_STATUS_NFCEE_INTERFACE_ACTIVATION_FAILED		0xc1
-#define	NCI_STATUS_NFCEE_TRANSMISSION_ERROR			0xc2
-#define	NCI_STATUS_NFCEE_PROTOCOL_ERROR				0xc3
+#define NCI_STATUS_MAX_ACTIVE_NFCEE_INTERFACES_REACHED		0xc0
+#define NCI_STATUS_NFCEE_INTERFACE_ACTIVATION_FAILED		0xc1
+#define NCI_STATUS_NFCEE_TRANSMISSION_ERROR			0xc2
+#define NCI_STATUS_NFCEE_PROTOCOL_ERROR				0xc3
 #define NCI_STATUS_NFCEE_TIMEOUT_ERROR				0xc4
 
-/* NCI RF Technology and Mode */
-#define NCI_NFC_A_PASSIVE_POLL_MODE				0x00
-#define NCI_NFC_B_PASSIVE_POLL_MODE				0x01
-#define NCI_NFC_F_PASSIVE_POLL_MODE				0x02
-#define NCI_NFC_A_ACTIVE_POLL_MODE				0x03
-#define NCI_NFC_F_ACTIVE_POLL_MODE				0x05
-#define NCI_NFC_A_PASSIVE_LISTEN_MODE				0x80
-#define NCI_NFC_B_PASSIVE_LISTEN_MODE				0x81
-#define NCI_NFC_F_PASSIVE_LISTEN_MODE				0x82
-#define NCI_NFC_A_ACTIVE_LISTEN_MODE				0x83
-#define NCI_NFC_F_ACTIVE_LISTEN_MODE				0x85
-
-/* NCI RF Protocols */
+/* RF Technologies */
+#define NCI_NFC_RF_TECHNOLOGY_A					0x00
+#define NCI_NFC_RF_TECHNOLOGY_B					0x01
+#define NCI_NFC_RF_TECHNOLOGY_F					0x02
+#define NCI_NFC_RF_TECHNOLOGY_15693				0x03
+
+/* Bit Rates */
+#define NCI_NFC_BIT_RATE_106					0x00
+#define NCI_NFC_BIT_RATE_212					0x01
+#define NCI_NFC_BIT_RATE_424					0x02
+#define NCI_NFC_BIT_RATE_848					0x03
+#define NCI_NFC_BIT_RATE_1696					0x04
+#define NCI_NFC_BIT_RATE_3392					0x05
+#define NCI_NFC_BIT_RATE_6784					0x06
+
+/* RF Protocols */
 #define NCI_RF_PROTOCOL_UNKNOWN					0x00
 #define NCI_RF_PROTOCOL_T1T					0x01
 #define NCI_RF_PROTOCOL_T2T					0x02
@@ -81,38 +83,54 @@
 #define NCI_RF_PROTOCOL_ISO_DEP					0x04
 #define NCI_RF_PROTOCOL_NFC_DEP					0x05
 
-/* NCI RF Interfaces */
-#define NCI_RF_INTERFACE_RFU					0x00
-#define	NCI_RF_INTERFACE_FRAME					0x01
-#define	NCI_RF_INTERFACE_ISO_DEP				0x02
-#define	NCI_RF_INTERFACE_NFC_DEP				0x03
+/* RF Interfaces */
+#define NCI_RF_INTERFACE_NFCEE_DIRECT				0x00
+#define NCI_RF_INTERFACE_FRAME					0x01
+#define NCI_RF_INTERFACE_ISO_DEP				0x02
+#define NCI_RF_INTERFACE_NFC_DEP				0x03
+
+/* Reset types */
+#define NCI_RESET_TYPE_KEEP_CONFIG				0x00
+#define NCI_RESET_TYPE_RESET_CONFIG				0x01
 
-/* NCI RF_DISCOVER_MAP_CMD modes */
+/* Static RF connection ID */
+#define NCI_STATIC_RF_CONN_ID					0x00
+
+/* RF_DISCOVER_MAP_CMD modes */
 #define NCI_DISC_MAP_MODE_POLL					0x01
 #define NCI_DISC_MAP_MODE_LISTEN				0x02
 #define NCI_DISC_MAP_MODE_BOTH					0x03
 
-/* NCI Discovery Types */
+/* Discovery Types */
 #define NCI_DISCOVERY_TYPE_POLL_A_PASSIVE			0x00
-#define	NCI_DISCOVERY_TYPE_POLL_B_PASSIVE			0x01
-#define	NCI_DISCOVERY_TYPE_POLL_F_PASSIVE			0x02
-#define	NCI_DISCOVERY_TYPE_POLL_A_ACTIVE			0x03
-#define	NCI_DISCOVERY_TYPE_POLL_F_ACTIVE			0x05
-#define	NCI_DISCOVERY_TYPE_WAKEUP_A_PASSIVE			0x06
-#define	NCI_DISCOVERY_TYPE_WAKEUP_B_PASSIVE			0x07
-#define	NCI_DISCOVERY_TYPE_WAKEUP_A_ACTIVE			0x09
-#define	NCI_DISCOVERY_TYPE_LISTEN_A_PASSIVE			0x80
-#define	NCI_DISCOVERY_TYPE_LISTEN_B_PASSIVE			0x81
-#define	NCI_DISCOVERY_TYPE_LISTEN_F_PASSIVE			0x82
-#define	NCI_DISCOVERY_TYPE_LISTEN_A_ACTIVE			0x83
-#define	NCI_DISCOVERY_TYPE_LISTEN_F_ACTIVE			0x85
-
-/* NCI Deactivation Type */
-#define	NCI_DEACTIVATE_TYPE_IDLE_MODE				0x00
-#define	NCI_DEACTIVATE_TYPE_SLEEP_MODE				0x01
-#define	NCI_DEACTIVATE_TYPE_SLEEP_AF_MODE			0x02
-#define	NCI_DEACTIVATE_TYPE_RF_LINK_LOSS			0x03
-#define	NCI_DEACTIVATE_TYPE_DISCOVERY_ERROR			0x04
+#define NCI_DISCOVERY_TYPE_POLL_B_PASSIVE			0x01
+#define NCI_DISCOVERY_TYPE_POLL_F_PASSIVE			0x02
+#define NCI_DISCOVERY_TYPE_POLL_A_ACTIVE			0x03
+#define NCI_DISCOVERY_TYPE_POLL_F_ACTIVE			0x05
+#define NCI_DISCOVERY_TYPE_WAKEUP_A_ACTIVE			0x09
+#define NCI_DISCOVERY_TYPE_LISTEN_A_PASSIVE			0x80
+#define NCI_DISCOVERY_TYPE_LISTEN_B_PASSIVE			0x81
+#define NCI_DISCOVERY_TYPE_LISTEN_F_PASSIVE			0x82
+#define NCI_DISCOVERY_TYPE_LISTEN_A_ACTIVE			0x83
+#define NCI_DISCOVERY_TYPE_LISTEN_F_ACTIVE			0x85
+
+/* RF Technology and Mode */
+#define NCI_NFC_A_PASSIVE_POLL_MODE				0x00
+#define NCI_NFC_B_PASSIVE_POLL_MODE				0x01
+#define NCI_NFC_F_PASSIVE_POLL_MODE				0x02
+#define NCI_NFC_A_ACTIVE_POLL_MODE				0x03
+#define NCI_NFC_F_ACTIVE_POLL_MODE				0x05
+#define NCI_NFC_A_PASSIVE_LISTEN_MODE				0x80
+#define NCI_NFC_B_PASSIVE_LISTEN_MODE				0x81
+#define NCI_NFC_F_PASSIVE_LISTEN_MODE				0x82
+#define NCI_NFC_A_ACTIVE_LISTEN_MODE				0x83
+#define NCI_NFC_F_ACTIVE_LISTEN_MODE				0x85
+
+/* Deactivation Type */
+#define NCI_DEACTIVATE_TYPE_IDLE_MODE				0x00
+#define NCI_DEACTIVATE_TYPE_SLEEP_MODE				0x01
+#define NCI_DEACTIVATE_TYPE_SLEEP_AF_MODE			0x02
+#define NCI_DEACTIVATE_TYPE_DISCOVERY				0x03
 
 /* Message Type (MT) */
 #define NCI_MT_DATA_PKT						0x00
@@ -144,10 +162,10 @@
 #define nci_conn_id(hdr)		(__u8)(((hdr)[0])&0x0f)
 
 /* GID values */
-#define	NCI_GID_CORE						0x0
-#define	NCI_GID_RF_MGMT						0x1
-#define	NCI_GID_NFCEE_MGMT					0x2
-#define	NCI_GID_PROPRIETARY					0xf
+#define NCI_GID_CORE						0x0
+#define NCI_GID_RF_MGMT						0x1
+#define NCI_GID_NFCEE_MGMT					0x2
+#define NCI_GID_PROPRIETARY					0xf
 
 /* ---- NCI Packet structures ---- */
 #define NCI_CTRL_HDR_SIZE					3
@@ -169,6 +187,9 @@ struct nci_data_hdr {
 /* -----  NCI Commands ---- */
 /* ------------------------ */
 #define NCI_OP_CORE_RESET_CMD		nci_opcode_pack(NCI_GID_CORE, 0x00)
+struct nci_core_reset_cmd {
+	__u8	reset_type;
+} __packed;
 
 #define NCI_OP_CORE_INIT_CMD		nci_opcode_pack(NCI_GID_CORE, 0x01)
 
@@ -218,6 +239,7 @@ struct nci_rf_deactivate_cmd {
 struct nci_core_reset_rsp {
 	__u8	status;
 	__u8	nci_ver;
+	__u8	config_status;
 } __packed;
 
 #define NCI_OP_CORE_INIT_RSP		nci_opcode_pack(NCI_GID_CORE, 0x01)
@@ -232,10 +254,12 @@ struct nci_core_init_rsp_1 {
 struct nci_core_init_rsp_2 {
 	__u8	max_logical_connections;
 	__le16	max_routing_table_size;
-	__u8	max_control_packet_payload_length;
-	__le16	rf_sending_buffer_size;
-	__le16	rf_receiving_buffer_size;
-	__le16	manufacturer_id;
+	__u8	max_ctrl_pkt_payload_len;
+	__le16	max_size_for_large_params;
+	__u8	max_data_pkt_payload_size;
+	__u8	initial_num_credits;
+	__u8	manufact_id;
+	__le32	manufact_specific_info;
 } __packed;
 
 #define NCI_OP_CORE_SET_CONFIG_RSP	nci_opcode_pack(NCI_GID_CORE, 0x02)
@@ -275,7 +299,7 @@ struct nci_rf_field_info_ntf {
 	__u8	rf_field_status;
 } __packed;
 
-#define NCI_OP_RF_ACTIVATE_NTF		nci_opcode_pack(NCI_GID_RF_MGMT, 0x05)
+#define NCI_OP_RF_INTF_ACTIVATED_NTF	nci_opcode_pack(NCI_GID_RF_MGMT, 0x05)
 struct rf_tech_specific_params_nfca_poll {
 	__u16	sens_res;
 	__u8	nfcid1_len;	/* 0, 4, 7, or 10 Bytes */
@@ -289,17 +313,20 @@ struct activation_params_nfca_poll_iso_dep {
 	__u8	rats_res[20];
 };
 
-struct nci_rf_activate_ntf {
-	__u8	target_handle;
+struct nci_rf_intf_activated_ntf {
+	__u8	rf_discovery_id;
+	__u8	rf_interface_type;
 	__u8	rf_protocol;
-	__u8	rf_tech_and_mode;
+	__u8	activation_rf_tech_and_mode;
 	__u8	rf_tech_specific_params_len;
 
 	union {
 		struct rf_tech_specific_params_nfca_poll nfca_poll;
 	} rf_tech_specific_params;
 
-	__u8	rf_interface_type;
+	__u8	data_exch_rf_tech_and_mode;
+	__u8	data_exch_tx_bit_rate;
+	__u8	data_exch_rx_bit_rate;
 	__u8	activation_params_len;
 
 	union {
@@ -309,5 +336,9 @@ struct nci_rf_activate_ntf {
 } __packed;
 
 #define NCI_OP_RF_DEACTIVATE_NTF	nci_opcode_pack(NCI_GID_RF_MGMT, 0x06)
+struct nci_rf_deactivate_ntf {
+	__u8	type;
+	__u8	reason;
+} __packed;
 
 #endif /* __NCI_H */
diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index b8b4bbd..6e6a7be 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -109,14 +109,15 @@ struct nci_dev {
 				[NCI_MAX_SUPPORTED_RF_INTERFACES];
 	__u8			max_logical_connections;
 	__u16			max_routing_table_size;
-	__u8			max_control_packet_payload_length;
-	__u16			rf_sending_buffer_size;
-	__u16			rf_receiving_buffer_size;
-	__u16			manufacturer_id;
+	__u8			max_ctrl_pkt_payload_len;
+	__u16			max_size_for_large_params;
+	__u8			max_data_pkt_payload_size;
+	__u8			initial_num_credits;
+	__u8			manufact_id;
+	__u32			manufact_specific_info;
 
 	/* received during NCI_OP_CORE_CONN_CREATE_RSP for static conn 0 */
 	__u8			max_pkt_payload_size;
-	__u8			initial_num_credits;
 	__u8			conn_id;
 
 	/* stored during nci_data_exchange */
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 4047e29..557fe92 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -125,7 +125,10 @@ static inline int nci_request(struct nci_dev *ndev,
 
 static void nci_reset_req(struct nci_dev *ndev, unsigned long opt)
 {
-	nci_send_cmd(ndev, NCI_OP_CORE_RESET_CMD, 0, NULL);
+	struct nci_core_reset_cmd cmd;
+
+	cmd.reset_type = NCI_RESET_TYPE_RESET_CONFIG;
+	nci_send_cmd(ndev, NCI_OP_CORE_RESET_CMD, 1, &cmd);
 }
 
 static void nci_init_req(struct nci_dev *ndev, unsigned long opt)
@@ -469,7 +472,7 @@ static int nci_data_exchange(struct nfc_dev *nfc_dev, __u32 target_idx,
 	ndev->data_exchange_cb = cb;
 	ndev->data_exchange_cb_context = cb_context;
 
-	rc = nci_send_data(ndev, ndev->conn_id, skb);
+	rc = nci_send_data(ndev, NCI_STATIC_RF_CONN_ID, skb);
 	if (rc)
 		clear_bit(NCI_DATA_EXCHANGE, &ndev->flags);
 
diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index e5ed90f..511fb96 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -95,7 +95,8 @@ static int nci_queue_tx_data_frags(struct nci_dev *ndev,
 	__skb_queue_head_init(&frags_q);
 
 	while (total_len) {
-		frag_len = min_t(int, total_len, ndev->max_pkt_payload_size);
+		frag_len =
+			min_t(int, total_len, ndev->max_data_pkt_payload_size);
 
 		skb_frag = nci_skb_alloc(ndev,
 					(NCI_DATA_HDR_SIZE + frag_len),
@@ -151,7 +152,7 @@ int nci_send_data(struct nci_dev *ndev, __u8 conn_id, struct sk_buff *skb)
 	nfc_dbg("entry, conn_id 0x%x, plen %d", conn_id, skb->len);
 
 	/* check if the packet need to be fragmented */
-	if (skb->len <= ndev->max_pkt_payload_size) {
+	if (skb->len <= ndev->max_data_pkt_payload_size) {
 		/* no need to fragment packet */
 		nci_push_data_hdr(ndev, conn_id, skb, NCI_PBF_LAST);
 
diff --git a/net/nfc/nci/lib.c b/net/nfc/nci/lib.c
index b19dc2f..e99adcf 100644
--- a/net/nfc/nci/lib.c
+++ b/net/nfc/nci/lib.c
@@ -42,12 +42,9 @@ int nci_to_errno(__u8 code)
 	case NCI_STATUS_REJECTED:
 		return -EBUSY;
 
-	case NCI_STATUS_MESSAGE_CORRUPTED:
+	case NCI_STATUS_RF_FRAME_CORRUPTED:
 		return -EBADMSG;
 
-	case NCI_STATUS_BUFFER_FULL:
-		return -ENOBUFS;
-
 	case NCI_STATUS_NOT_INITIALIZED:
 		return -EHOSTDOWN;
 
@@ -80,9 +77,6 @@ int nci_to_errno(__u8 code)
 	case NCI_STATUS_NFCEE_TIMEOUT_ERROR:
 		return -ETIMEDOUT;
 
-	case NCI_STATUS_RF_LINK_LOSS_ERROR:
-		return -ENOLINK;
-
 	case NCI_STATUS_MAX_ACTIVE_NFCEE_INTERFACES_REACHED:
 		return -EDQUOT;
 
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 96633f5..6789f48 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -54,7 +54,7 @@ static void nci_core_conn_credits_ntf_packet(struct nci_dev *ndev,
 			ntf->conn_entries[i].conn_id,
 			ntf->conn_entries[i].credits);
 
-		if (ntf->conn_entries[i].conn_id == ndev->conn_id) {
+		if (ntf->conn_entries[i].conn_id == NCI_STATIC_RF_CONN_ID) {
 			/* found static rf connection */
 			atomic_add(ntf->conn_entries[i].credits,
 				&ndev->credits_cnt);
@@ -74,14 +74,12 @@ static void nci_rf_field_info_ntf_packet(struct nci_dev *ndev,
 	nfc_dbg("entry, rf_field_status %d", ntf->rf_field_status);
 }
 
-static int nci_rf_activate_nfca_passive_poll(struct nci_dev *ndev,
-			struct nci_rf_activate_ntf *ntf, __u8 *data)
+static __u8 *nci_extract_rf_params_nfca_passive_poll(struct nci_dev *ndev,
+			struct nci_rf_intf_activated_ntf *ntf, __u8 *data)
 {
 	struct rf_tech_specific_params_nfca_poll *nfca_poll;
-	struct activation_params_nfca_poll_iso_dep *nfca_poll_iso_dep;
 
 	nfca_poll = &ntf->rf_tech_specific_params.nfca_poll;
-	nfca_poll_iso_dep = &ntf->activation_params.nfca_poll_iso_dep;
 
 	nfca_poll->sens_res = __le16_to_cpu(*((__u16 *)data));
 	data += 2;
@@ -100,32 +98,32 @@ static int nci_rf_activate_nfca_passive_poll(struct nci_dev *ndev,
 	if (nfca_poll->sel_res_len != 0)
 		nfca_poll->sel_res = *data++;
 
-	ntf->rf_interface_type = *data++;
-	ntf->activation_params_len = *data++;
-
-	nfc_dbg("sel_res_len %d, sel_res 0x%x, rf_interface_type %d, activation_params_len %d",
+	nfc_dbg("sel_res_len %d, sel_res 0x%x",
 		nfca_poll->sel_res_len,
-		nfca_poll->sel_res,
-		ntf->rf_interface_type,
-		ntf->activation_params_len);
-
-	switch (ntf->rf_interface_type) {
-	case NCI_RF_INTERFACE_ISO_DEP:
-		nfca_poll_iso_dep->rats_res_len = *data++;
-		if (nfca_poll_iso_dep->rats_res_len > 0) {
-			memcpy(nfca_poll_iso_dep->rats_res,
+		nfca_poll->sel_res);
+
+	return data;
+}
+
+static int nci_extract_activation_params_iso_dep(struct nci_dev *ndev,
+			struct nci_rf_intf_activated_ntf *ntf, __u8 *data)
+{
+	struct activation_params_nfca_poll_iso_dep *nfca_poll;
+
+	switch (ntf->activation_rf_tech_and_mode) {
+	case NCI_NFC_A_PASSIVE_POLL_MODE:
+		nfca_poll = &ntf->activation_params.nfca_poll_iso_dep;
+		nfca_poll->rats_res_len = *data++;
+		if (nfca_poll->rats_res_len > 0) {
+			memcpy(nfca_poll->rats_res,
 				data,
-				nfca_poll_iso_dep->rats_res_len);
+				nfca_poll->rats_res_len);
 		}
 		break;
 
-	case NCI_RF_INTERFACE_FRAME:
-		/* no activation params */
-		break;
-
 	default:
-		nfc_err("unsupported rf_interface_type 0x%x",
-			ntf->rf_interface_type);
+		nfc_err("unsupported activation_rf_tech_and_mode 0x%x",
+			ntf->activation_rf_tech_and_mode);
 		return -EPROTO;
 	}
 
@@ -133,7 +131,7 @@ static int nci_rf_activate_nfca_passive_poll(struct nci_dev *ndev,
 }
 
 static void nci_target_found(struct nci_dev *ndev,
-				struct nci_rf_activate_ntf *ntf)
+				struct nci_rf_intf_activated_ntf *ntf)
 {
 	struct nfc_target nfc_tgt;
 
@@ -141,6 +139,8 @@ static void nci_target_found(struct nci_dev *ndev,
 		nfc_tgt.supported_protocols = NFC_PROTO_MIFARE_MASK;
 	else if (ntf->rf_protocol == NCI_RF_PROTOCOL_ISO_DEP)	/* 4A */
 		nfc_tgt.supported_protocols = NFC_PROTO_ISO14443_MASK;
+	else
+		nfc_tgt.supported_protocols = 0;
 
 	nfc_tgt.sens_res = ntf->rf_tech_specific_params.nfca_poll.sens_res;
 	nfc_tgt.sel_res = ntf->rf_tech_specific_params.nfca_poll.sel_res;
@@ -158,49 +158,86 @@ static void nci_target_found(struct nci_dev *ndev,
 	nfc_targets_found(ndev->nfc_dev, &nfc_tgt, 1);
 }
 
-static void nci_rf_activate_ntf_packet(struct nci_dev *ndev,
-					struct sk_buff *skb)
+static void nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
+						struct sk_buff *skb)
 {
-	struct nci_rf_activate_ntf ntf;
+	struct nci_rf_intf_activated_ntf ntf;
 	__u8 *data = skb->data;
-	int rc = -1;
+	int err = 0;
 
 	clear_bit(NCI_DISCOVERY, &ndev->flags);
 	set_bit(NCI_POLL_ACTIVE, &ndev->flags);
 
-	ntf.target_handle = *data++;
+	ntf.rf_discovery_id = *data++;
+	ntf.rf_interface_type = *data++;
 	ntf.rf_protocol = *data++;
-	ntf.rf_tech_and_mode = *data++;
+	ntf.activation_rf_tech_and_mode = *data++;
 	ntf.rf_tech_specific_params_len = *data++;
 
-	nfc_dbg("target_handle %d, rf_protocol 0x%x, rf_tech_and_mode 0x%x, rf_tech_specific_params_len %d",
-		ntf.target_handle,
-		ntf.rf_protocol,
-		ntf.rf_tech_and_mode,
+	nfc_dbg("rf_discovery_id %d", ntf.rf_discovery_id);
+	nfc_dbg("rf_interface_type 0x%x", ntf.rf_interface_type);
+	nfc_dbg("rf_protocol 0x%x", ntf.rf_protocol);
+	nfc_dbg("activation_rf_tech_and_mode 0x%x",
+		ntf.activation_rf_tech_and_mode);
+	nfc_dbg("rf_tech_specific_params_len %d",
 		ntf.rf_tech_specific_params_len);
 
-	switch (ntf.rf_tech_and_mode) {
-	case NCI_NFC_A_PASSIVE_POLL_MODE:
-		rc = nci_rf_activate_nfca_passive_poll(ndev, &ntf,
-			data);
-		break;
+	if (ntf.rf_tech_specific_params_len > 0) {
+		switch (ntf.activation_rf_tech_and_mode) {
+		case NCI_NFC_A_PASSIVE_POLL_MODE:
+			data = nci_extract_rf_params_nfca_passive_poll(ndev,
+				&ntf, data);
+			break;
+
+		default:
+			nfc_err("unsupported activation_rf_tech_and_mode 0x%x",
+				ntf.activation_rf_tech_and_mode);
+			return;
+		}
+	}
 
-	default:
-		nfc_err("unsupported rf_tech_and_mode 0x%x",
-			ntf.rf_tech_and_mode);
-		return;
+	ntf.data_exch_rf_tech_and_mode = *data++;
+	ntf.data_exch_tx_bit_rate = *data++;
+	ntf.data_exch_rx_bit_rate = *data++;
+	ntf.activation_params_len = *data++;
+
+	nfc_dbg("data_exch_rf_tech_and_mode 0x%x",
+		ntf.data_exch_rf_tech_and_mode);
+	nfc_dbg("data_exch_tx_bit_rate 0x%x",
+		ntf.data_exch_tx_bit_rate);
+	nfc_dbg("data_exch_rx_bit_rate 0x%x",
+		ntf.data_exch_rx_bit_rate);
+	nfc_dbg("activation_params_len %d",
+		ntf.activation_params_len);
+
+	if (ntf.activation_params_len > 0) {
+		switch (ntf.rf_interface_type) {
+		case NCI_RF_INTERFACE_ISO_DEP:
+			err = nci_extract_activation_params_iso_dep(ndev,
+				&ntf, data);
+			break;
+
+		case NCI_RF_INTERFACE_FRAME:
+			/* no activation params */
+			break;
+
+		default:
+			nfc_err("unsupported rf_interface_type 0x%x",
+				ntf.rf_interface_type);
+			return;
+		}
 	}
 
-	if (!rc)
+	if (!err)
 		nci_target_found(ndev, &ntf);
 }
 
 static void nci_rf_deactivate_ntf_packet(struct nci_dev *ndev,
 					struct sk_buff *skb)
 {
-	__u8 type = skb->data[0];
+	struct nci_rf_deactivate_ntf *ntf = (void *) skb->data;
 
-	nfc_dbg("entry, type 0x%x", type);
+	nfc_dbg("entry, type 0x%x, reason 0x%x", ntf->type, ntf->reason);
 
 	clear_bit(NCI_POLL_ACTIVE, &ndev->flags);
 	ndev->target_active_prot = 0;
@@ -241,8 +278,8 @@ void nci_ntf_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		nci_rf_field_info_ntf_packet(ndev, skb);
 		break;
 
-	case NCI_OP_RF_ACTIVATE_NTF:
-		nci_rf_activate_ntf_packet(ndev, skb);
+	case NCI_OP_RF_INTF_ACTIVATED_NTF:
+		nci_rf_intf_activated_ntf_packet(ndev, skb);
 		break;
 
 	case NCI_OP_RF_DEACTIVATE_NTF:
diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index 0403d4c..64fc58a 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -42,10 +42,11 @@ static void nci_core_reset_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 
 	nfc_dbg("entry, status 0x%x", rsp->status);
 
-	if (rsp->status == NCI_STATUS_OK)
+	if (rsp->status == NCI_STATUS_OK) {
 		ndev->nci_ver = rsp->nci_ver;
-
-	nfc_dbg("nci_ver 0x%x", ndev->nci_ver);
+		nfc_dbg("nci_ver 0x%x, config_status 0x%x",
+			rsp->nci_ver, rsp->config_status);
+	}
 
 	nci_req_complete(ndev, rsp->status);
 }
@@ -58,13 +59,13 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 	nfc_dbg("entry, status 0x%x", rsp_1->status);
 
 	if (rsp_1->status != NCI_STATUS_OK)
-		return;
+		goto exit;
 
 	ndev->nfcc_features = __le32_to_cpu(rsp_1->nfcc_features);
 	ndev->num_supported_rf_interfaces = rsp_1->num_supported_rf_interfaces;
 
 	if (ndev->num_supported_rf_interfaces >
-		NCI_MAX_SUPPORTED_RF_INTERFACES) {
+			NCI_MAX_SUPPORTED_RF_INTERFACES) {
 		ndev->num_supported_rf_interfaces =
 			NCI_MAX_SUPPORTED_RF_INTERFACES;
 	}
@@ -73,20 +74,26 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		rsp_1->supported_rf_interfaces,
 		ndev->num_supported_rf_interfaces);
 
-	rsp_2 = (void *) (skb->data + 6 + ndev->num_supported_rf_interfaces);
+	rsp_2 = (void *) (skb->data + 6 + rsp_1->num_supported_rf_interfaces);
 
 	ndev->max_logical_connections =
 		rsp_2->max_logical_connections;
 	ndev->max_routing_table_size =
 		__le16_to_cpu(rsp_2->max_routing_table_size);
-	ndev->max_control_packet_payload_length =
-		rsp_2->max_control_packet_payload_length;
-	ndev->rf_sending_buffer_size =
-		__le16_to_cpu(rsp_2->rf_sending_buffer_size);
-	ndev->rf_receiving_buffer_size =
-		__le16_to_cpu(rsp_2->rf_receiving_buffer_size);
-	ndev->manufacturer_id =
-		__le16_to_cpu(rsp_2->manufacturer_id);
+	ndev->max_ctrl_pkt_payload_len =
+		rsp_2->max_ctrl_pkt_payload_len;
+	ndev->max_size_for_large_params =
+		__le16_to_cpu(rsp_2->max_size_for_large_params);
+	ndev->max_data_pkt_payload_size =
+		rsp_2->max_data_pkt_payload_size;
+	ndev->initial_num_credits =
+		rsp_2->initial_num_credits;
+	ndev->manufact_id =
+		rsp_2->manufact_id;
+	ndev->manufact_specific_info =
+		__le32_to_cpu(rsp_2->manufact_specific_info);
+
+	atomic_set(&ndev->credits_cnt, ndev->initial_num_credits);
 
 	nfc_dbg("nfcc_features 0x%x",
 		ndev->nfcc_features);
@@ -104,15 +111,20 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		ndev->max_logical_connections);
 	nfc_dbg("max_routing_table_size %d",
 		ndev->max_routing_table_size);
-	nfc_dbg("max_control_packet_payload_length %d",
-		ndev->max_control_packet_payload_length);
-	nfc_dbg("rf_sending_buffer_size %d",
-		ndev->rf_sending_buffer_size);
-	nfc_dbg("rf_receiving_buffer_size %d",
-		ndev->rf_receiving_buffer_size);
-	nfc_dbg("manufacturer_id 0x%x",
-		ndev->manufacturer_id);
-
+	nfc_dbg("max_ctrl_pkt_payload_len %d",
+		ndev->max_ctrl_pkt_payload_len);
+	nfc_dbg("max_size_for_large_params %d",
+		ndev->max_size_for_large_params);
+	nfc_dbg("max_data_pkt_payload_size %d",
+		ndev->max_data_pkt_payload_size);
+	nfc_dbg("initial_num_credits %d",
+		ndev->initial_num_credits);
+	nfc_dbg("manufact_id 0x%x",
+		ndev->manufact_id);
+	nfc_dbg("manufact_specific_info 0x%x",
+		ndev->manufact_specific_info);
+
+exit:
 	nci_req_complete(ndev, rsp_1->status);
 }
 
-- 
1.7.0.4

