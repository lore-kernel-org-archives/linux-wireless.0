Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54088 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1LTO4e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 09:56:34 -0500
Received: by yenm11 with SMTP id m11so4040485yen.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 06:56:34 -0800 (PST)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH 1/2] NFC: Update names and structs to NCI spec 1.0 d22
Date: Tue, 20 Dec 2011 16:57:40 +0200
Message-Id: <1324393061-32173-2-git-send-email-ilane@ti.com> (sfid-20111220_155637_708594_58CDF304)
In-Reply-To: <1324393061-32173-1-git-send-email-ilane@ti.com>
References: <1324393061-32173-1-git-send-email-ilane@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Addition, deletion, and modification of NCI constants.
Changes in NCI commands, responses, and notifications structures.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 include/net/nfc/nci.h      |   43 +++++++++++++++----------------------------
 include/net/nfc/nci_core.h |    6 ++++--
 net/nfc/nci/core.c         |   22 ++++++++++++----------
 net/nfc/nci/lib.c          |    3 ---
 net/nfc/nci/ntf.c          |   26 ++++++++++++++++++--------
 net/nfc/nci/rsp.c          |   10 ----------
 6 files changed, 49 insertions(+), 61 deletions(-)

diff --git a/include/net/nfc/nci.h b/include/net/nfc/nci.h
index b61eb6c..2a7fdb2 100644
--- a/include/net/nfc/nci.h
+++ b/include/net/nfc/nci.h
@@ -54,11 +54,10 @@
 #define NCI_STATUS_RF_PROTOCOL_ERROR				0xb1
 #define NCI_STATUS_RF_TIMEOUT_ERROR				0xb2
 /* NFCEE Interface Specific Status Codes */
-#define NCI_STATUS_MAX_ACTIVE_NFCEE_INTERFACES_REACHED		0xc0
-#define NCI_STATUS_NFCEE_INTERFACE_ACTIVATION_FAILED		0xc1
-#define NCI_STATUS_NFCEE_TRANSMISSION_ERROR			0xc2
-#define NCI_STATUS_NFCEE_PROTOCOL_ERROR				0xc3
-#define NCI_STATUS_NFCEE_TIMEOUT_ERROR				0xc4
+#define NCI_STATUS_NFCEE_INTERFACE_ACTIVATION_FAILED		0xc0
+#define NCI_STATUS_NFCEE_TRANSMISSION_ERROR			0xc1
+#define NCI_STATUS_NFCEE_PROTOCOL_ERROR				0xc2
+#define NCI_STATUS_NFCEE_TIMEOUT_ERROR				0xc3
 
 /* NCI RF Technology and Mode */
 #define NCI_NFC_A_PASSIVE_POLL_MODE				0x00
@@ -66,11 +65,13 @@
 #define NCI_NFC_F_PASSIVE_POLL_MODE				0x02
 #define NCI_NFC_A_ACTIVE_POLL_MODE				0x03
 #define NCI_NFC_F_ACTIVE_POLL_MODE				0x05
+#define NCI_NFC_15693_PASSIVE_POLL_MODE				0x06
 #define NCI_NFC_A_PASSIVE_LISTEN_MODE				0x80
 #define NCI_NFC_B_PASSIVE_LISTEN_MODE				0x81
 #define NCI_NFC_F_PASSIVE_LISTEN_MODE				0x82
 #define NCI_NFC_A_ACTIVE_LISTEN_MODE				0x83
 #define NCI_NFC_F_ACTIVE_LISTEN_MODE				0x85
+#define NCI_NFC_15693_PASSIVE_LISTEN_MODE			0x86
 
 /* NCI RF Technologies */
 #define NCI_NFC_RF_TECHNOLOGY_A					0x00
@@ -83,9 +84,9 @@
 #define NCI_NFC_BIT_RATE_212					0x01
 #define NCI_NFC_BIT_RATE_424					0x02
 #define NCI_NFC_BIT_RATE_848					0x03
-#define NCI_NFC_BIT_RATE_1696					0x04
-#define NCI_NFC_BIT_RATE_3392					0x05
-#define NCI_NFC_BIT_RATE_6784					0x06
+#define NCI_NFC_BIT_RATE_1695					0x04
+#define NCI_NFC_BIT_RATE_3390					0x05
+#define NCI_NFC_BIT_RATE_6780					0x06
 
 /* NCI RF Protocols */
 #define NCI_RF_PROTOCOL_UNKNOWN					0x00
@@ -114,20 +115,6 @@
 /* NCI RF_DISCOVER_MAP_CMD modes */
 #define NCI_DISC_MAP_MODE_POLL					0x01
 #define NCI_DISC_MAP_MODE_LISTEN				0x02
-#define NCI_DISC_MAP_MODE_BOTH					0x03
-
-/* NCI Discovery Types */
-#define NCI_DISCOVERY_TYPE_POLL_A_PASSIVE			0x00
-#define NCI_DISCOVERY_TYPE_POLL_B_PASSIVE			0x01
-#define NCI_DISCOVERY_TYPE_POLL_F_PASSIVE			0x02
-#define NCI_DISCOVERY_TYPE_POLL_A_ACTIVE			0x03
-#define NCI_DISCOVERY_TYPE_POLL_F_ACTIVE			0x05
-#define NCI_DISCOVERY_TYPE_WAKEUP_A_ACTIVE			0x09
-#define NCI_DISCOVERY_TYPE_LISTEN_A_PASSIVE			0x80
-#define NCI_DISCOVERY_TYPE_LISTEN_B_PASSIVE			0x81
-#define NCI_DISCOVERY_TYPE_LISTEN_F_PASSIVE			0x82
-#define NCI_DISCOVERY_TYPE_LISTEN_A_ACTIVE			0x83
-#define NCI_DISCOVERY_TYPE_LISTEN_F_ACTIVE			0x85
 
 /* NCI Deactivation Type */
 #define NCI_DEACTIVATE_TYPE_IDLE_MODE				0x00
@@ -200,7 +187,7 @@ struct nci_core_reset_cmd {
 struct disc_map_config {
 	__u8	rf_protocol;
 	__u8	mode;
-	__u8	rf_interface_type;
+	__u8	rf_interface;
 } __packed;
 
 struct nci_rf_disc_map_cmd {
@@ -211,7 +198,7 @@ struct nci_rf_disc_map_cmd {
 
 #define NCI_OP_RF_DISCOVER_CMD		nci_opcode_pack(NCI_GID_RF_MGMT, 0x03)
 struct disc_config {
-	__u8	type;
+	__u8	rf_tech_and_mode;
 	__u8	frequency;
 } __packed;
 
@@ -249,8 +236,6 @@ struct nci_core_init_rsp_2 {
 	__le16	max_routing_table_size;
 	__u8	max_ctrl_pkt_payload_len;
 	__le16	max_size_for_large_params;
-	__u8	max_data_pkt_payload_size;
-	__u8	initial_num_credits;
 	__u8	manufact_id;
 	__le32	manufact_specific_info;
 } __packed;
@@ -264,7 +249,7 @@ struct nci_core_init_rsp_2 {
 /* --------------------------- */
 /* ---- NCI Notifications ---- */
 /* --------------------------- */
-#define NCI_OP_CORE_CONN_CREDITS_NTF	nci_opcode_pack(NCI_GID_CORE, 0x07)
+#define NCI_OP_CORE_CONN_CREDITS_NTF	nci_opcode_pack(NCI_GID_CORE, 0x06)
 struct conn_credit_entry {
 	__u8	conn_id;
 	__u8	credits;
@@ -291,9 +276,11 @@ struct activation_params_nfca_poll_iso_dep {
 
 struct nci_rf_intf_activated_ntf {
 	__u8	rf_discovery_id;
-	__u8	rf_interface_type;
+	__u8	rf_interface;
 	__u8	rf_protocol;
 	__u8	activation_rf_tech_and_mode;
+	__u8	max_data_pkt_payload_size;
+	__u8	initial_num_credits;
 	__u8	rf_tech_specific_params_len;
 
 	union {
diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index c92b69d..bccd89e 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -111,11 +111,13 @@ struct nci_dev {
 	__u16			max_routing_table_size;
 	__u8			max_ctrl_pkt_payload_len;
 	__u16			max_size_for_large_params;
-	__u8			max_data_pkt_payload_size;
-	__u8			initial_num_credits;
 	__u8			manufact_id;
 	__u32			manufact_specific_info;
 
+	/* received during NCI_OP_RF_INTF_ACTIVATED_NTF */
+	__u8			max_data_pkt_payload_size;
+	__u8			initial_num_credits;
+
 	/* stored during nci_data_exchange */
 	data_exchange_cb_t	data_exchange_cb;
 	void			*data_exchange_cb_context;
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 2deb4ae..7650139 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -154,14 +154,16 @@ static void nci_init_complete_req(struct nci_dev *ndev, unsigned long opt)
 		if (ndev->supported_rf_interfaces[i] ==
 			NCI_RF_INTERFACE_ISO_DEP) {
 			cfg[*num].rf_protocol = NCI_RF_PROTOCOL_ISO_DEP;
-			cfg[*num].mode = NCI_DISC_MAP_MODE_BOTH;
-			cfg[*num].rf_interface_type = NCI_RF_INTERFACE_ISO_DEP;
+			cfg[*num].mode = NCI_DISC_MAP_MODE_POLL |
+				NCI_DISC_MAP_MODE_LISTEN;
+			cfg[*num].rf_interface = NCI_RF_INTERFACE_ISO_DEP;
 			(*num)++;
 		} else if (ndev->supported_rf_interfaces[i] ==
 			NCI_RF_INTERFACE_NFC_DEP) {
 			cfg[*num].rf_protocol = NCI_RF_PROTOCOL_NFC_DEP;
-			cfg[*num].mode = NCI_DISC_MAP_MODE_BOTH;
-			cfg[*num].rf_interface_type = NCI_RF_INTERFACE_NFC_DEP;
+			cfg[*num].mode = NCI_DISC_MAP_MODE_POLL |
+				NCI_DISC_MAP_MODE_LISTEN;
+			cfg[*num].rf_interface = NCI_RF_INTERFACE_NFC_DEP;
 			(*num)++;
 		}
 
@@ -186,16 +188,16 @@ static void nci_rf_discover_req(struct nci_dev *ndev, unsigned long opt)
 		|| protocols & NFC_PROTO_MIFARE_MASK
 		|| protocols & NFC_PROTO_ISO14443_MASK
 		|| protocols & NFC_PROTO_NFC_DEP_MASK)) {
-		cmd.disc_configs[cmd.num_disc_configs].type =
-		NCI_DISCOVERY_TYPE_POLL_A_PASSIVE;
+		cmd.disc_configs[cmd.num_disc_configs].rf_tech_and_mode =
+		NCI_NFC_A_PASSIVE_POLL_MODE;
 		cmd.disc_configs[cmd.num_disc_configs].frequency = 1;
 		cmd.num_disc_configs++;
 	}
 
 	if ((cmd.num_disc_configs < NCI_MAX_NUM_RF_CONFIGS) &&
 		(protocols & NFC_PROTO_ISO14443_MASK)) {
-		cmd.disc_configs[cmd.num_disc_configs].type =
-		NCI_DISCOVERY_TYPE_POLL_B_PASSIVE;
+		cmd.disc_configs[cmd.num_disc_configs].rf_tech_and_mode =
+		NCI_NFC_B_PASSIVE_POLL_MODE;
 		cmd.disc_configs[cmd.num_disc_configs].frequency = 1;
 		cmd.num_disc_configs++;
 	}
@@ -203,8 +205,8 @@ static void nci_rf_discover_req(struct nci_dev *ndev, unsigned long opt)
 	if ((cmd.num_disc_configs < NCI_MAX_NUM_RF_CONFIGS) &&
 		(protocols & NFC_PROTO_FELICA_MASK
 		|| protocols & NFC_PROTO_NFC_DEP_MASK)) {
-		cmd.disc_configs[cmd.num_disc_configs].type =
-		NCI_DISCOVERY_TYPE_POLL_F_PASSIVE;
+		cmd.disc_configs[cmd.num_disc_configs].rf_tech_and_mode =
+		NCI_NFC_F_PASSIVE_POLL_MODE;
 		cmd.disc_configs[cmd.num_disc_configs].frequency = 1;
 		cmd.num_disc_configs++;
 	}
diff --git a/net/nfc/nci/lib.c b/net/nfc/nci/lib.c
index e99adcf..6a63e5e 100644
--- a/net/nfc/nci/lib.c
+++ b/net/nfc/nci/lib.c
@@ -77,9 +77,6 @@ int nci_to_errno(__u8 code)
 	case NCI_STATUS_NFCEE_TIMEOUT_ERROR:
 		return -ETIMEDOUT;
 
-	case NCI_STATUS_MAX_ACTIVE_NFCEE_INTERFACES_REACHED:
-		return -EDQUOT;
-
 	case NCI_STATUS_FAILED:
 	default:
 		return -ENOSYS;
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 003846b..c8813ed 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -52,6 +52,9 @@ static void nci_core_conn_credits_ntf_packet(struct nci_dev *ndev,
 
 	/* update the credits */
 	for (i = 0; i < ntf->num_entries; i++) {
+		ntf->conn_entries[i].conn_id =
+			nci_conn_id(&ntf->conn_entries[i].conn_id);
+
 		pr_debug("entry[%d]: conn_id %d, credits %d\n",
 			 i, ntf->conn_entries[i].conn_id,
 			 ntf->conn_entries[i].credits);
@@ -147,6 +150,11 @@ static void nci_target_found(struct nci_dev *ndev,
 		 nfc_tgt.supported_protocols);
 
 	ndev->target_available_prots = nfc_tgt.supported_protocols;
+	ndev->max_data_pkt_payload_size = ntf->max_data_pkt_payload_size;
+	ndev->initial_num_credits = ntf->initial_num_credits;
+
+	/* set the available credits to initial value */
+	atomic_set(&ndev->credits_cnt, ndev->initial_num_credits);
 
 	nfc_targets_found(ndev->nfc_dev, &nfc_tgt, 1);
 }
@@ -162,16 +170,21 @@ static void nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 	set_bit(NCI_POLL_ACTIVE, &ndev->flags);
 
 	ntf.rf_discovery_id = *data++;
-	ntf.rf_interface_type = *data++;
+	ntf.rf_interface = *data++;
 	ntf.rf_protocol = *data++;
 	ntf.activation_rf_tech_and_mode = *data++;
+	ntf.max_data_pkt_payload_size = *data++;
+	ntf.initial_num_credits = *data++;
 	ntf.rf_tech_specific_params_len = *data++;
 
 	pr_debug("rf_discovery_id %d\n", ntf.rf_discovery_id);
-	pr_debug("rf_interface_type 0x%x\n", ntf.rf_interface_type);
+	pr_debug("rf_interface 0x%x\n", ntf.rf_interface);
 	pr_debug("rf_protocol 0x%x\n", ntf.rf_protocol);
 	pr_debug("activation_rf_tech_and_mode 0x%x\n",
 		 ntf.activation_rf_tech_and_mode);
+	pr_debug("max_data_pkt_payload_size 0x%x\n",
+		 ntf.max_data_pkt_payload_size);
+	pr_debug("initial_num_credits 0x%x\n", ntf.initial_num_credits);
 	pr_debug("rf_tech_specific_params_len %d\n",
 		 ntf.rf_tech_specific_params_len);
 
@@ -204,7 +217,7 @@ static void nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 		 ntf.activation_params_len);
 
 	if (ntf.activation_params_len > 0) {
-		switch (ntf.rf_interface_type) {
+		switch (ntf.rf_interface) {
 		case NCI_RF_INTERFACE_ISO_DEP:
 			err = nci_extract_activation_params_iso_dep(ndev,
 				&ntf, data);
@@ -215,8 +228,8 @@ static void nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 			break;
 
 		default:
-			pr_err("unsupported rf_interface_type 0x%x\n",
-			       ntf.rf_interface_type);
+			pr_err("unsupported rf_interface 0x%x\n",
+			       ntf.rf_interface);
 			return;
 		}
 	}
@@ -244,9 +257,6 @@ static void nci_rf_deactivate_ntf_packet(struct nci_dev *ndev,
 		ndev->rx_data_reassembly = 0;
 	}
 
-	/* set the available credits to initial value */
-	atomic_set(&ndev->credits_cnt, ndev->initial_num_credits);
-
 	/* complete the data exchange transaction, if exists */
 	if (test_bit(NCI_DATA_EXCHANGE, &ndev->flags))
 		nci_data_exchange_complete(ndev, NULL, -EIO);
diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index 3f444c8..2840ae2 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -86,17 +86,11 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		rsp_2->max_ctrl_pkt_payload_len;
 	ndev->max_size_for_large_params =
 		__le16_to_cpu(rsp_2->max_size_for_large_params);
-	ndev->max_data_pkt_payload_size =
-		rsp_2->max_data_pkt_payload_size;
-	ndev->initial_num_credits =
-		rsp_2->initial_num_credits;
 	ndev->manufact_id =
 		rsp_2->manufact_id;
 	ndev->manufact_specific_info =
 		__le32_to_cpu(rsp_2->manufact_specific_info);
 
-	atomic_set(&ndev->credits_cnt, ndev->initial_num_credits);
-
 	pr_debug("nfcc_features 0x%x\n",
 		 ndev->nfcc_features);
 	pr_debug("num_supported_rf_interfaces %d\n",
@@ -117,10 +111,6 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		 ndev->max_ctrl_pkt_payload_len);
 	pr_debug("max_size_for_large_params %d\n",
 		 ndev->max_size_for_large_params);
-	pr_debug("max_data_pkt_payload_size %d\n",
-		 ndev->max_data_pkt_payload_size);
-	pr_debug("initial_num_credits %d\n",
-		 ndev->initial_num_credits);
 	pr_debug("manufact_id 0x%x\n",
 		 ndev->manufact_id);
 	pr_debug("manufact_specific_info 0x%x\n",
-- 
1.7.0.4

