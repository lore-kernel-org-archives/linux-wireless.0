Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46786 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2AHIyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jan 2012 03:54:05 -0500
Received: by ggdk6 with SMTP id k6so1234586ggd.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jan 2012 00:54:03 -0800 (PST)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH] NFC: Export new attributes sensb_res and sensf_res
Date: Sun,  8 Jan 2012 10:56:01 +0200
Message-Id: <1326012961-29832-1-git-send-email-ilane@ti.com> (sfid-20120108_095409_892600_00373FD4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Export new attributes sensb_res for tech B and sensf_res
for tech F in the target info (returned as a response to
NFC_CMD_GET_TARGET).

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 include/linux/nfc.h   |    4 ++
 include/net/nfc/nci.h |   19 ++++++++
 include/net/nfc/nfc.h |    6 +++
 net/nfc/nci/ntf.c     |  111 +++++++++++++++++++++++++++++++++++++++++++------
 net/nfc/netlink.c     |    6 +++
 5 files changed, 133 insertions(+), 13 deletions(-)

diff --git a/include/linux/nfc.h b/include/linux/nfc.h
index 01d4e5d..c9da5cf 100644
--- a/include/linux/nfc.h
+++ b/include/linux/nfc.h
@@ -89,6 +89,8 @@ enum nfc_commands {
  * @NFC_ATTR_TARGET_SEL_RES: NFC-A targets extra information (useful if the
  *	target is not NFC-Forum compliant)
  * @NFC_ATTR_TARGET_NFCID1: NFC-A targets identifier, max 10 bytes
+ * @NFC_ATTR_TARGET_SENSB_RES: NFC-B targets extra information, max 12 bytes
+ * @NFC_ATTR_TARGET_SENSF_RES: NFC-F targets extra information, max 18 bytes
  * @NFC_ATTR_COMM_MODE: Passive or active mode
  * @NFC_ATTR_RF_MODE: Initiator or target
  */
@@ -101,6 +103,8 @@ enum nfc_attrs {
 	NFC_ATTR_TARGET_SENS_RES,
 	NFC_ATTR_TARGET_SEL_RES,
 	NFC_ATTR_TARGET_NFCID1,
+	NFC_ATTR_TARGET_SENSB_RES,
+	NFC_ATTR_TARGET_SENSF_RES,
 	NFC_ATTR_COMM_MODE,
 	NFC_ATTR_RF_MODE,
 /* private: internal use only */
diff --git a/include/net/nfc/nci.h b/include/net/nfc/nci.h
index 2be95e2..34f5ed2 100644
--- a/include/net/nfc/nci.h
+++ b/include/net/nfc/nci.h
@@ -275,11 +275,27 @@ struct rf_tech_specific_params_nfca_poll {
 	__u8	sel_res;
 } __packed;
 
+struct rf_tech_specific_params_nfcb_poll {
+	__u8	sensb_res_len;
+	__u8	sensb_res[12];	/* 11 or 12 Bytes */
+} __packed;
+
+struct rf_tech_specific_params_nfcf_poll {
+	__u8	bit_rate;
+	__u8	sensf_res_len;
+	__u8	sensf_res[18];	/* 16 or 18 Bytes */
+} __packed;
+
 struct activation_params_nfca_poll_iso_dep {
 	__u8	rats_res_len;
 	__u8	rats_res[20];
 };
 
+struct activation_params_nfcb_poll_iso_dep {
+	__u8	attrib_res_len;
+	__u8	attrib_res[50];
+};
+
 struct nci_rf_intf_activated_ntf {
 	__u8	rf_discovery_id;
 	__u8	rf_interface;
@@ -291,6 +307,8 @@ struct nci_rf_intf_activated_ntf {
 
 	union {
 		struct rf_tech_specific_params_nfca_poll nfca_poll;
+		struct rf_tech_specific_params_nfcb_poll nfcb_poll;
+		struct rf_tech_specific_params_nfcf_poll nfcf_poll;
 	} rf_tech_specific_params;
 
 	__u8	data_exch_rf_tech_and_mode;
@@ -300,6 +318,7 @@ struct nci_rf_intf_activated_ntf {
 
 	union {
 		struct activation_params_nfca_poll_iso_dep nfca_poll_iso_dep;
+		struct activation_params_nfcb_poll_iso_dep nfcb_poll_iso_dep;
 	} activation_params;
 
 } __packed;
diff --git a/include/net/nfc/nfc.h b/include/net/nfc/nfc.h
index 8696b77..d8aef2e 100644
--- a/include/net/nfc/nfc.h
+++ b/include/net/nfc/nfc.h
@@ -66,6 +66,8 @@ struct nfc_ops {
 #define NFC_TARGET_IDX_ANY -1
 #define NFC_MAX_GT_LEN 48
 #define NFC_MAX_NFCID1_LEN 10
+#define NFC_MAX_SENSB_RES_LEN 12
+#define NFC_MAX_SENSF_RES_LEN 18
 
 struct nfc_target {
 	u32 idx;
@@ -74,6 +76,10 @@ struct nfc_target {
 	u8 sel_res;
 	u8 nfcid1_len;
 	u8 nfcid1[NFC_MAX_NFCID1_LEN];
+	u8 sensb_res_len;
+	u8 sensb_res[NFC_MAX_SENSB_RES_LEN];
+	u8 sensf_res_len;
+	u8 sensf_res[NFC_MAX_SENSF_RES_LEN];
 };
 
 struct nfc_genl_data {
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index b16a8dc..5b2b013 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -115,15 +115,53 @@ static __u8 *nci_extract_rf_params_nfca_passive_poll(struct nci_dev *ndev,
 	return data;
 }
 
+static __u8 *nci_extract_rf_params_nfcb_passive_poll(struct nci_dev *ndev,
+			struct nci_rf_intf_activated_ntf *ntf, __u8 *data)
+{
+	struct rf_tech_specific_params_nfcb_poll *nfcb_poll;
+
+	nfcb_poll = &ntf->rf_tech_specific_params.nfcb_poll;
+
+	nfcb_poll->sensb_res_len = *data++;
+
+	pr_debug("sensb_res_len %d\n", nfcb_poll->sensb_res_len);
+
+	memcpy(nfcb_poll->sensb_res, data, nfcb_poll->sensb_res_len);
+	data += nfcb_poll->sensb_res_len;
+
+	return data;
+}
+
+static __u8 *nci_extract_rf_params_nfcf_passive_poll(struct nci_dev *ndev,
+			struct nci_rf_intf_activated_ntf *ntf, __u8 *data)
+{
+	struct rf_tech_specific_params_nfcf_poll *nfcf_poll;
+
+	nfcf_poll = &ntf->rf_tech_specific_params.nfcf_poll;
+
+	nfcf_poll->bit_rate = *data++;
+	nfcf_poll->sensf_res_len = *data++;
+
+	pr_debug("bit_rate %d, sensf_res_len %d\n",
+		nfcf_poll->bit_rate, nfcf_poll->sensf_res_len);
+
+	memcpy(nfcf_poll->sensf_res, data, nfcf_poll->sensf_res_len);
+	data += nfcf_poll->sensf_res_len;
+
+	return data;
+}
+
 static int nci_extract_activation_params_iso_dep(struct nci_dev *ndev,
 			struct nci_rf_intf_activated_ntf *ntf, __u8 *data)
 {
 	struct activation_params_nfca_poll_iso_dep *nfca_poll;
+	struct activation_params_nfcb_poll_iso_dep *nfcb_poll;
 
 	switch (ntf->activation_rf_tech_and_mode) {
 	case NCI_NFC_A_PASSIVE_POLL_MODE:
 		nfca_poll = &ntf->activation_params.nfca_poll_iso_dep;
 		nfca_poll->rats_res_len = *data++;
+		pr_debug("rats_res_len %d\n", nfca_poll->rats_res_len);
 		if (nfca_poll->rats_res_len > 0) {
 			memcpy(nfca_poll->rats_res,
 				data,
@@ -131,6 +169,18 @@ static int nci_extract_activation_params_iso_dep(struct nci_dev *ndev,
 		}
 		break;
 
+	case NCI_NFC_B_PASSIVE_POLL_MODE:
+		nfcb_poll = &ntf->activation_params.nfcb_poll_iso_dep;
+		nfcb_poll->attrib_res_len = *data++;
+		pr_debug("attrib_res_len %d\n",
+			nfcb_poll->attrib_res_len);
+		if (nfcb_poll->attrib_res_len > 0) {
+			memcpy(nfcb_poll->attrib_res,
+				data,
+				nfcb_poll->attrib_res_len);
+		}
+		break;
+
 	default:
 		pr_err("unsupported activation_rf_tech_and_mode 0x%x\n",
 		       ntf->activation_rf_tech_and_mode);
@@ -145,21 +195,14 @@ static void nci_target_found(struct nci_dev *ndev,
 {
 	struct nfc_target nfc_tgt;
 
-	if (ntf->rf_protocol == NCI_RF_PROTOCOL_T2T)	/* T2T MifareUL */
+	memset(&nfc_tgt, 0, sizeof(nfc_tgt));
+
+	if (ntf->rf_protocol == NCI_RF_PROTOCOL_T2T)
 		nfc_tgt.supported_protocols = NFC_PROTO_MIFARE_MASK;
-	else if (ntf->rf_protocol == NCI_RF_PROTOCOL_ISO_DEP)	/* 4A */
+	else if (ntf->rf_protocol == NCI_RF_PROTOCOL_ISO_DEP)
 		nfc_tgt.supported_protocols = NFC_PROTO_ISO14443_MASK;
-	else
-		nfc_tgt.supported_protocols = 0;
-
-	nfc_tgt.sens_res = ntf->rf_tech_specific_params.nfca_poll.sens_res;
-	nfc_tgt.sel_res = ntf->rf_tech_specific_params.nfca_poll.sel_res;
-	nfc_tgt.nfcid1_len = ntf->rf_tech_specific_params.nfca_poll.nfcid1_len;
-	if (nfc_tgt.nfcid1_len > 0) {
-		memcpy(nfc_tgt.nfcid1,
-			ntf->rf_tech_specific_params.nfca_poll.nfcid1,
-			nfc_tgt.nfcid1_len);
-	}
+	else if (ntf->rf_protocol == NCI_RF_PROTOCOL_T3T)
+		nfc_tgt.supported_protocols = NFC_PROTO_FELICA_MASK;
 
 	if (!(nfc_tgt.supported_protocols & ndev->poll_prots)) {
 		pr_debug("the target found does not have the desired protocol\n");
@@ -169,6 +212,38 @@ static void nci_target_found(struct nci_dev *ndev,
 	pr_debug("new target found,  supported_protocols 0x%x\n",
 		 nfc_tgt.supported_protocols);
 
+	if (ntf->activation_rf_tech_and_mode == NCI_NFC_A_PASSIVE_POLL_MODE) {
+		nfc_tgt.sens_res =
+			ntf->rf_tech_specific_params.nfca_poll.sens_res;
+		nfc_tgt.sel_res =
+			ntf->rf_tech_specific_params.nfca_poll.sel_res;
+		nfc_tgt.nfcid1_len =
+			ntf->rf_tech_specific_params.nfca_poll.nfcid1_len;
+		if (nfc_tgt.nfcid1_len > 0) {
+			memcpy(nfc_tgt.nfcid1,
+				ntf->rf_tech_specific_params.nfca_poll.nfcid1,
+				nfc_tgt.nfcid1_len);
+		}
+	} else if (ntf->activation_rf_tech_and_mode ==
+						NCI_NFC_B_PASSIVE_POLL_MODE) {
+		nfc_tgt.sensb_res_len =
+			ntf->rf_tech_specific_params.nfcb_poll.sensb_res_len;
+		if (nfc_tgt.sensb_res_len > 0) {
+			memcpy(nfc_tgt.sensb_res,
+			       ntf->rf_tech_specific_params.nfcb_poll.sensb_res,
+			       nfc_tgt.sensb_res_len);
+		}
+	} else if (ntf->activation_rf_tech_and_mode ==
+						NCI_NFC_F_PASSIVE_POLL_MODE) {
+		nfc_tgt.sensf_res_len =
+			ntf->rf_tech_specific_params.nfcf_poll.sensf_res_len;
+		if (nfc_tgt.sensf_res_len > 0) {
+			memcpy(nfc_tgt.sensf_res,
+			       ntf->rf_tech_specific_params.nfcf_poll.sensf_res,
+			       nfc_tgt.sensf_res_len);
+		}
+	}
+
 	ndev->target_available_prots = nfc_tgt.supported_protocols;
 	ndev->max_data_pkt_payload_size = ntf->max_data_pkt_payload_size;
 	ndev->initial_num_credits = ntf->initial_num_credits;
@@ -215,6 +290,16 @@ static void nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 				&ntf, data);
 			break;
 
+		case NCI_NFC_B_PASSIVE_POLL_MODE:
+			data = nci_extract_rf_params_nfcb_passive_poll(ndev,
+				&ntf, data);
+			break;
+
+		case NCI_NFC_F_PASSIVE_POLL_MODE:
+			data = nci_extract_rf_params_nfcf_passive_poll(ndev,
+				&ntf, data);
+			break;
+
 		default:
 			pr_err("unsupported activation_rf_tech_and_mode 0x%x\n",
 			       ntf.activation_rf_tech_and_mode);
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 6989dfa..07f0348 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -70,6 +70,12 @@ static int nfc_genl_send_target(struct sk_buff *msg, struct nfc_target *target,
 	if (target->nfcid1_len > 0)
 		NLA_PUT(msg, NFC_ATTR_TARGET_NFCID1, target->nfcid1_len,
 				target->nfcid1);
+	if (target->sensb_res_len > 0)
+		NLA_PUT(msg, NFC_ATTR_TARGET_SENSB_RES, target->sensb_res_len,
+				target->sensb_res);
+	if (target->sensf_res_len > 0)
+		NLA_PUT(msg, NFC_ATTR_TARGET_SENSF_RES, target->sensf_res_len,
+				target->sensf_res);
 
 	return genlmsg_end(msg, hdr);
 
-- 
1.7.0.4

