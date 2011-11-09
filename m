Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52596 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab1KIKJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 05:09:55 -0500
Received: by yenr9 with SMTP id r9so505566yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2011 02:09:54 -0800 (PST)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH v4 2/3] NFC: Removal of unused operations for NCI spec 1.0 d18
Date: Wed,  9 Nov 2011 12:09:15 +0200
Message-Id: <1320833356-19132-3-git-send-email-ilane@ti.com> (sfid-20111109_110958_781849_2B434018)
In-Reply-To: <1320833356-19132-1-git-send-email-ilane@ti.com>
References: <1320833356-19132-1-git-send-email-ilane@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Remove unused NCI operations, e.g. create static rf connection.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 include/net/nfc/nci.h      |   27 ---------------------------
 include/net/nfc/nci_core.h |    4 ----
 net/nfc/nci/core.c         |    6 ------
 net/nfc/nci/ntf.c          |   15 +++------------
 net/nfc/nci/rsp.c          |   25 -------------------------
 5 files changed, 3 insertions(+), 74 deletions(-)

diff --git a/include/net/nfc/nci.h b/include/net/nfc/nci.h
index 0ebf842..0b34fde 100644
--- a/include/net/nfc/nci.h
+++ b/include/net/nfc/nci.h
@@ -193,16 +193,6 @@ struct nci_core_reset_cmd {
 
 #define NCI_OP_CORE_INIT_CMD		nci_opcode_pack(NCI_GID_CORE, 0x01)
 
-#define NCI_OP_CORE_SET_CONFIG_CMD	nci_opcode_pack(NCI_GID_CORE, 0x02)
-
-#define NCI_OP_CORE_CONN_CREATE_CMD	nci_opcode_pack(NCI_GID_CORE, 0x04)
-struct nci_core_conn_create_cmd {
-	__u8	target_handle;
-	__u8	num_target_specific_params;
-} __packed;
-
-#define NCI_OP_CORE_CONN_CLOSE_CMD	nci_opcode_pack(NCI_GID_CORE, 0x06)
-
 #define NCI_OP_RF_DISCOVER_MAP_CMD	nci_opcode_pack(NCI_GID_RF_MGMT, 0x00)
 struct disc_map_config {
 	__u8	rf_protocol;
@@ -262,18 +252,6 @@ struct nci_core_init_rsp_2 {
 	__le32	manufact_specific_info;
 } __packed;
 
-#define NCI_OP_CORE_SET_CONFIG_RSP	nci_opcode_pack(NCI_GID_CORE, 0x02)
-
-#define NCI_OP_CORE_CONN_CREATE_RSP	nci_opcode_pack(NCI_GID_CORE, 0x04)
-struct nci_core_conn_create_rsp {
-	__u8	status;
-	__u8	max_pkt_payload_size;
-	__u8	initial_num_credits;
-	__u8	conn_id;
-} __packed;
-
-#define NCI_OP_CORE_CONN_CLOSE_RSP	nci_opcode_pack(NCI_GID_CORE, 0x06)
-
 #define NCI_OP_RF_DISCOVER_MAP_RSP	nci_opcode_pack(NCI_GID_RF_MGMT, 0x00)
 
 #define NCI_OP_RF_DISCOVER_RSP		nci_opcode_pack(NCI_GID_RF_MGMT, 0x03)
@@ -294,11 +272,6 @@ struct nci_core_conn_credit_ntf {
 	struct conn_credit_entry	conn_entries[NCI_MAX_NUM_CONN];
 } __packed;
 
-#define NCI_OP_RF_FIELD_INFO_NTF	nci_opcode_pack(NCI_GID_CORE, 0x08)
-struct nci_rf_field_info_ntf {
-	__u8	rf_field_status;
-} __packed;
-
 #define NCI_OP_RF_INTF_ACTIVATED_NTF	nci_opcode_pack(NCI_GID_RF_MGMT, 0x05)
 struct rf_tech_specific_params_nfca_poll {
 	__u16	sens_res;
diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 6e6a7be..c92b69d 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -116,10 +116,6 @@ struct nci_dev {
 	__u8			manufact_id;
 	__u32			manufact_specific_info;
 
-	/* received during NCI_OP_CORE_CONN_CREATE_RSP for static conn 0 */
-	__u8			max_pkt_payload_size;
-	__u8			conn_id;
-
 	/* stored during nci_data_exchange */
 	data_exchange_cb_t	data_exchange_cb;
 	void			*data_exchange_cb_context;
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 4b6ae5d..803f6d1 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -139,17 +139,11 @@ static void nci_init_req(struct nci_dev *ndev, unsigned long opt)
 
 static void nci_init_complete_req(struct nci_dev *ndev, unsigned long opt)
 {
-	struct nci_core_conn_create_cmd conn_cmd;
 	struct nci_rf_disc_map_cmd cmd;
 	struct disc_map_config *cfg = cmd.mapping_configs;
 	__u8 *num = &cmd.num_mapping_configs;
 	int i;
 
-	/* create static rf connection */
-	conn_cmd.target_handle = 0;
-	conn_cmd.num_target_specific_params = 0;
-	nci_send_cmd(ndev, NCI_OP_CORE_CONN_CREATE_CMD, 2, &conn_cmd);
-
 	/* set rf mapping configurations */
 	*num = 0;
 
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 6789f48..c1bf541 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -66,14 +66,6 @@ static void nci_core_conn_credits_ntf_packet(struct nci_dev *ndev,
 		queue_work(ndev->tx_wq, &ndev->tx_work);
 }
 
-static void nci_rf_field_info_ntf_packet(struct nci_dev *ndev,
-					struct sk_buff *skb)
-{
-	struct nci_rf_field_info_ntf *ntf = (void *) skb->data;
-
-	nfc_dbg("entry, rf_field_status %d", ntf->rf_field_status);
-}
-
 static __u8 *nci_extract_rf_params_nfca_passive_poll(struct nci_dev *ndev,
 			struct nci_rf_intf_activated_ntf *ntf, __u8 *data)
 {
@@ -251,6 +243,9 @@ static void nci_rf_deactivate_ntf_packet(struct nci_dev *ndev,
 		ndev->rx_data_reassembly = 0;
 	}
 
+	/* set the available credits to initial value */
+	atomic_set(&ndev->credits_cnt, ndev->initial_num_credits);
+
 	/* complete the data exchange transaction, if exists */
 	if (test_bit(NCI_DATA_EXCHANGE, &ndev->flags))
 		nci_data_exchange_complete(ndev, NULL, -EIO);
@@ -274,10 +269,6 @@ void nci_ntf_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		nci_core_conn_credits_ntf_packet(ndev, skb);
 		break;
 
-	case NCI_OP_RF_FIELD_INFO_NTF:
-		nci_rf_field_info_ntf_packet(ndev, skb);
-		break;
-
 	case NCI_OP_RF_INTF_ACTIVATED_NTF:
 		nci_rf_intf_activated_ntf_packet(ndev, skb);
 		break;
diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index 64fc58a..0591f5a 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -128,27 +128,6 @@ exit:
 	nci_req_complete(ndev, rsp_1->status);
 }
 
-static void nci_core_conn_create_rsp_packet(struct nci_dev *ndev,
-						struct sk_buff *skb)
-{
-	struct nci_core_conn_create_rsp *rsp = (void *) skb->data;
-
-	nfc_dbg("entry, status 0x%x", rsp->status);
-
-	if (rsp->status != NCI_STATUS_OK)
-		return;
-
-	ndev->max_pkt_payload_size = rsp->max_pkt_payload_size;
-	ndev->initial_num_credits = rsp->initial_num_credits;
-	ndev->conn_id = rsp->conn_id;
-
-	atomic_set(&ndev->credits_cnt, ndev->initial_num_credits);
-
-	nfc_dbg("max_pkt_payload_size %d", ndev->max_pkt_payload_size);
-	nfc_dbg("initial_num_credits %d", ndev->initial_num_credits);
-	nfc_dbg("conn_id %d", ndev->conn_id);
-}
-
 static void nci_rf_disc_map_rsp_packet(struct nci_dev *ndev,
 					struct sk_buff *skb)
 {
@@ -208,10 +187,6 @@ void nci_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		nci_core_init_rsp_packet(ndev, skb);
 		break;
 
-	case NCI_OP_CORE_CONN_CREATE_RSP:
-		nci_core_conn_create_rsp_packet(ndev, skb);
-		break;
-
 	case NCI_OP_RF_DISCOVER_MAP_RSP:
 		nci_rf_disc_map_rsp_packet(ndev, skb);
 		break;
-- 
1.7.0.4

