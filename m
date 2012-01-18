Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52002 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2ARLOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 06:14:12 -0500
Received: by yhoo21 with SMTP id o21so633976yho.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2012 03:14:11 -0800 (PST)
From: ilanelias78@gmail.com
To: samuel@sortiz.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH 3/3] NFC: Add NCI multiple targets support
Date: Wed, 18 Jan 2012 13:16:14 +0200
Message-Id: <1326885374-13318-4-git-send-email-ilane@ti.com> (sfid-20120118_121416_064521_5BF18565)
In-Reply-To: <1326885374-13318-1-git-send-email-ilane@ti.com>
References: <1326885374-13318-1-git-send-email-ilane@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

Add the ability to select between multiple targets in NCI.
If only one target is found, it will be auto-activated.
If more than one target is found, then DISCOVER_NTF will be
generated for each target, and the host should select one by
calling DISCOVER_SELECT_CMD. Then, the target will be activated.
If the activation fails, GENERIC_ERROR_NTF is generated.

Signed-off-by: Ilan Elias <ilane@ti.com>
---
 include/net/nfc/nci.h      |   34 +++++-
 include/net/nfc/nci_core.h |    9 +-
 net/nfc/nci/core.c         |   91 +++++++++++--
 net/nfc/nci/ntf.c          |  323 ++++++++++++++++++++++++++++++++------------
 net/nfc/nci/rsp.c          |   17 +++
 5 files changed, 378 insertions(+), 96 deletions(-)

diff --git a/include/net/nfc/nci.h b/include/net/nfc/nci.h
index 34f5ed2..276094b 100644
--- a/include/net/nfc/nci.h
+++ b/include/net/nfc/nci.h
@@ -116,6 +116,11 @@
 #define NCI_DISC_MAP_MODE_POLL					0x01
 #define NCI_DISC_MAP_MODE_LISTEN				0x02
 
+/* NCI Discover Notification Type */
+#define NCI_DISCOVER_NTF_TYPE_LAST				0x00
+#define NCI_DISCOVER_NTF_TYPE_LAST_NFCC				0x01
+#define NCI_DISCOVER_NTF_TYPE_MORE				0x02
+
 /* NCI Deactivation Type */
 #define NCI_DEACTIVATE_TYPE_IDLE_MODE				0x00
 #define NCI_DEACTIVATE_TYPE_SLEEP_MODE				0x01
@@ -207,6 +212,13 @@ struct nci_rf_disc_cmd {
 	struct disc_config		disc_configs[NCI_MAX_NUM_RF_CONFIGS];
 } __packed;
 
+#define NCI_OP_RF_DISCOVER_SELECT_CMD	nci_opcode_pack(NCI_GID_RF_MGMT, 0x04)
+struct nci_rf_discover_select_cmd {
+	__u8	rf_discovery_id;
+	__u8	rf_protocol;
+	__u8	rf_interface;
+} __packed;
+
 #define NCI_OP_RF_DEACTIVATE_CMD	nci_opcode_pack(NCI_GID_RF_MGMT, 0x06)
 struct nci_rf_deactivate_cmd {
 	__u8	type;
@@ -244,6 +256,8 @@ struct nci_core_init_rsp_2 {
 
 #define NCI_OP_RF_DISCOVER_RSP		nci_opcode_pack(NCI_GID_RF_MGMT, 0x03)
 
+#define NCI_OP_RF_DISCOVER_SELECT_RSP	nci_opcode_pack(NCI_GID_RF_MGMT, 0x04)
+
 #define NCI_OP_RF_DEACTIVATE_RSP	nci_opcode_pack(NCI_GID_RF_MGMT, 0x06)
 
 /* --------------------------- */
@@ -260,13 +274,15 @@ struct nci_core_conn_credit_ntf {
 	struct conn_credit_entry	conn_entries[NCI_MAX_NUM_CONN];
 } __packed;
 
+#define NCI_OP_CORE_GENERIC_ERROR_NTF	nci_opcode_pack(NCI_GID_CORE, 0x07)
+
 #define NCI_OP_CORE_INTF_ERROR_NTF	nci_opcode_pack(NCI_GID_CORE, 0x08)
 struct nci_core_intf_error_ntf {
 	__u8	status;
 	__u8	conn_id;
 } __packed;
 
-#define NCI_OP_RF_INTF_ACTIVATED_NTF	nci_opcode_pack(NCI_GID_RF_MGMT, 0x05)
+#define NCI_OP_RF_DISCOVER_NTF		nci_opcode_pack(NCI_GID_RF_MGMT, 0x03)
 struct rf_tech_specific_params_nfca_poll {
 	__u16	sens_res;
 	__u8	nfcid1_len;	/* 0, 4, 7, or 10 Bytes */
@@ -286,6 +302,22 @@ struct rf_tech_specific_params_nfcf_poll {
 	__u8	sensf_res[18];	/* 16 or 18 Bytes */
 } __packed;
 
+struct nci_rf_discover_ntf {
+	__u8	rf_discovery_id;
+	__u8	rf_protocol;
+	__u8	rf_tech_and_mode;
+	__u8	rf_tech_specific_params_len;
+
+	union {
+		struct rf_tech_specific_params_nfca_poll nfca_poll;
+		struct rf_tech_specific_params_nfcb_poll nfcb_poll;
+		struct rf_tech_specific_params_nfcf_poll nfcf_poll;
+	} rf_tech_specific_params;
+
+	__u8	ntf_type;
+} __packed;
+
+#define NCI_OP_RF_INTF_ACTIVATED_NTF	nci_opcode_pack(NCI_GID_RF_MGMT, 0x05)
 struct activation_params_nfca_poll_iso_dep {
 	__u8	rats_res_len;
 	__u8	rats_res[20];
diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index b9c3f8d..86fee8b 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -46,6 +46,8 @@ enum nci_flag {
 enum nci_state {
 	NCI_IDLE,
 	NCI_DISCOVERY,
+	NCI_W4_ALL_DISCOVERIES,
+	NCI_W4_HOST_SELECT,
 	NCI_POLL_ACTIVE,
 };
 
@@ -53,6 +55,7 @@ enum nci_state {
 #define NCI_RESET_TIMEOUT			5000
 #define NCI_INIT_TIMEOUT			5000
 #define NCI_RF_DISC_TIMEOUT			5000
+#define NCI_RF_DISC_SELECT_TIMEOUT		5000
 #define NCI_RF_DEACTIVATE_TIMEOUT		30000
 #define NCI_CMD_TIMEOUT				5000
 #define NCI_DATA_TIMEOUT			700
@@ -66,6 +69,7 @@ struct nci_ops {
 };
 
 #define NCI_MAX_SUPPORTED_RF_INTERFACES		4
+#define NCI_MAX_DISCOVERED_TARGETS		10
 
 /* NCI Core structures */
 struct nci_dev {
@@ -105,9 +109,11 @@ struct nci_dev {
 	void			*driver_data;
 
 	__u32			poll_prots;
-	__u32			target_available_prots;
 	__u32			target_active_prot;
 
+	struct nfc_target	targets[NCI_MAX_DISCOVERED_TARGETS];
+	int			n_targets;
+
 	/* received during NCI_OP_CORE_RESET_RSP */
 	__u8			nci_ver;
 
@@ -178,6 +184,7 @@ int nci_send_cmd(struct nci_dev *ndev, __u16 opcode, __u8 plen, void *payload);
 int nci_send_data(struct nci_dev *ndev, __u8 conn_id, struct sk_buff *skb);
 void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
 				int err);
+void nci_clear_target_list(struct nci_dev *ndev);
 
 /* ----- NCI requests ----- */
 #define NCI_REQ_DONE		0
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 629b768..12d1d4d 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -216,6 +216,39 @@ static void nci_rf_discover_req(struct nci_dev *ndev, unsigned long opt)
 		&cmd);
 }
 
+struct nci_rf_discover_select_param {
+	__u8	rf_discovery_id;
+	__u8	rf_protocol;
+};
+
+static void nci_rf_discover_select_req(struct nci_dev *ndev, unsigned long opt)
+{
+	struct nci_rf_discover_select_param *param =
+				(struct nci_rf_discover_select_param *)opt;
+	struct nci_rf_discover_select_cmd cmd;
+
+	cmd.rf_discovery_id = param->rf_discovery_id;
+	cmd.rf_protocol = param->rf_protocol;
+
+	switch (cmd.rf_protocol) {
+	case NCI_RF_PROTOCOL_ISO_DEP:
+		cmd.rf_interface = NCI_RF_INTERFACE_ISO_DEP;
+		break;
+
+	case NCI_RF_PROTOCOL_NFC_DEP:
+		cmd.rf_interface = NCI_RF_INTERFACE_NFC_DEP;
+		break;
+
+	default:
+		cmd.rf_interface = NCI_RF_INTERFACE_FRAME;
+		break;
+	}
+
+	nci_send_cmd(ndev, NCI_OP_RF_DISCOVER_SELECT_CMD,
+			sizeof(struct nci_rf_discover_select_cmd),
+			&cmd);
+}
+
 static void nci_rf_deactivate_req(struct nci_dev *ndev, unsigned long opt)
 {
 	struct nci_rf_deactivate_cmd cmd;
@@ -264,6 +297,7 @@ static int nci_open_device(struct nci_dev *ndev)
 
 	if (!rc) {
 		set_bit(NCI_UP, &ndev->flags);
+		nci_clear_target_list(ndev);
 		atomic_set(&ndev->state, NCI_IDLE);
 	} else {
 		/* Init failed, cleanup */
@@ -361,7 +395,8 @@ static int nci_start_poll(struct nfc_dev *nfc_dev, __u32 protocols)
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 	int rc;
 
-	if (atomic_read(&ndev->state) == NCI_DISCOVERY) {
+	if ((atomic_read(&ndev->state) == NCI_DISCOVERY) ||
+		(atomic_read(&ndev->state) == NCI_W4_ALL_DISCOVERIES)) {
 		pr_err("unable to start poll, since poll is already active\n");
 		return -EBUSY;
 	}
@@ -371,8 +406,9 @@ static int nci_start_poll(struct nfc_dev *nfc_dev, __u32 protocols)
 		return -EBUSY;
 	}
 
-	if (atomic_read(&ndev->state) == NCI_POLL_ACTIVE) {
-		pr_debug("target is active, implicitly deactivate...\n");
+	if ((atomic_read(&ndev->state) == NCI_W4_HOST_SELECT) ||
+		(atomic_read(&ndev->state) == NCI_POLL_ACTIVE)) {
+		pr_debug("target active or w4 select, implicitly deactivate\n");
 
 		rc = nci_request(ndev, nci_rf_deactivate_req, 0,
 			msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
@@ -393,7 +429,8 @@ static void nci_stop_poll(struct nfc_dev *nfc_dev)
 {
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 
-	if (atomic_read(&ndev->state) != NCI_DISCOVERY) {
+	if ((atomic_read(&ndev->state) != NCI_DISCOVERY) &&
+		(atomic_read(&ndev->state) != NCI_W4_ALL_DISCOVERIES)) {
 		pr_err("unable to stop poll, since poll is not active\n");
 		return;
 	}
@@ -406,10 +443,15 @@ static int nci_activate_target(struct nfc_dev *nfc_dev, __u32 target_idx,
 				__u32 protocol)
 {
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
+	struct nci_rf_discover_select_param param;
+	struct nfc_target *target = 0;
+	int i;
+	int rc = 0;
 
 	pr_debug("target_idx %d, protocol 0x%x\n", target_idx, protocol);
 
-	if (atomic_read(&ndev->state) != NCI_POLL_ACTIVE) {
+	if ((atomic_read(&ndev->state) != NCI_W4_HOST_SELECT) &&
+		(atomic_read(&ndev->state) != NCI_POLL_ACTIVE)) {
 		pr_err("there is no available target to activate\n");
 		return -EINVAL;
 	}
@@ -419,16 +461,47 @@ static int nci_activate_target(struct nfc_dev *nfc_dev, __u32 target_idx,
 		return -EBUSY;
 	}
 
-	if (!(ndev->target_available_prots & (1 << protocol))) {
+	for (i = 0; i < ndev->n_targets; i++) {
+		if (ndev->targets[i].idx == target_idx) {
+			target = &ndev->targets[i];
+			break;
+		}
+	}
+
+	if (!target) {
+		pr_err("unable to find the selected target\n");
+		return -EINVAL;
+	}
+
+	if (!(target->supported_protocols & (1 << protocol))) {
 		pr_err("target does not support the requested protocol 0x%x\n",
 		       protocol);
 		return -EINVAL;
 	}
 
-	ndev->target_active_prot = protocol;
-	ndev->target_available_prots = 0;
+	if (atomic_read(&ndev->state) == NCI_W4_HOST_SELECT) {
+		param.rf_discovery_id = target->idx;
 
-	return 0;
+		if (protocol == NFC_PROTO_JEWEL)
+			param.rf_protocol = NCI_RF_PROTOCOL_T1T;
+		else if (protocol == NFC_PROTO_MIFARE)
+			param.rf_protocol = NCI_RF_PROTOCOL_T2T;
+		else if (protocol == NFC_PROTO_FELICA)
+			param.rf_protocol = NCI_RF_PROTOCOL_T3T;
+		else if (protocol == NFC_PROTO_ISO14443)
+			param.rf_protocol = NCI_RF_PROTOCOL_ISO_DEP;
+		else
+			param.rf_protocol = NCI_RF_PROTOCOL_NFC_DEP;
+
+		rc = nci_request(ndev, nci_rf_discover_select_req,
+				(unsigned long)&param,
+				msecs_to_jiffies(NCI_RF_DISC_SELECT_TIMEOUT));
+	}
+
+	if (!rc)
+		ndev->target_active_prot = protocol;
+
+	return rc;
 }
 
 static void nci_deactivate_target(struct nfc_dev *nfc_dev, __u32 target_idx)
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 8ec3946..03e7b46 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -71,6 +71,20 @@ static void nci_core_conn_credits_ntf_packet(struct nci_dev *ndev,
 		queue_work(ndev->tx_wq, &ndev->tx_work);
 }
 
+static void nci_core_generic_error_ntf_packet(struct nci_dev *ndev,
+						struct sk_buff *skb)
+{
+	__u8 status = skb->data[0];
+
+	pr_debug("status 0x%x\n", status);
+
+	if (atomic_read(&ndev->state) == NCI_W4_HOST_SELECT) {
+		/* Activation failed, so complete the request
+		(the state remains the same) */
+		nci_req_complete(ndev, status);
+	}
+}
+
 static void nci_core_conn_intf_error_ntf_packet(struct nci_dev *ndev,
 						struct sk_buff *skb)
 {
@@ -86,12 +100,9 @@ static void nci_core_conn_intf_error_ntf_packet(struct nci_dev *ndev,
 }
 
 static __u8 *nci_extract_rf_params_nfca_passive_poll(struct nci_dev *ndev,
-			struct nci_rf_intf_activated_ntf *ntf, __u8 *data)
+			struct rf_tech_specific_params_nfca_poll *nfca_poll,
+			__u8 *data)
 {
-	struct rf_tech_specific_params_nfca_poll *nfca_poll;
-
-	nfca_poll = &ntf->rf_tech_specific_params.nfca_poll;
-
 	nfca_poll->sens_res = __le16_to_cpu(*((__u16 *)data));
 	data += 2;
 
@@ -116,12 +127,9 @@ static __u8 *nci_extract_rf_params_nfca_passive_poll(struct nci_dev *ndev,
 }
 
 static __u8 *nci_extract_rf_params_nfcb_passive_poll(struct nci_dev *ndev,
-			struct nci_rf_intf_activated_ntf *ntf, __u8 *data)
+			struct rf_tech_specific_params_nfcb_poll *nfcb_poll,
+			__u8 *data)
 {
-	struct rf_tech_specific_params_nfcb_poll *nfcb_poll;
-
-	nfcb_poll = &ntf->rf_tech_specific_params.nfcb_poll;
-
 	nfcb_poll->sensb_res_len = *data++;
 
 	pr_debug("sensb_res_len %d\n", nfcb_poll->sensb_res_len);
@@ -133,12 +141,9 @@ static __u8 *nci_extract_rf_params_nfcb_passive_poll(struct nci_dev *ndev,
 }
 
 static __u8 *nci_extract_rf_params_nfcf_passive_poll(struct nci_dev *ndev,
-			struct nci_rf_intf_activated_ntf *ntf, __u8 *data)
+			struct rf_tech_specific_params_nfcf_poll *nfcf_poll,
+			__u8 *data)
 {
-	struct rf_tech_specific_params_nfcf_poll *nfcf_poll;
-
-	nfcf_poll = &ntf->rf_tech_specific_params.nfcf_poll;
-
 	nfcf_poll->bit_rate = *data++;
 	nfcf_poll->sensf_res_len = *data++;
 
@@ -151,6 +156,172 @@ static __u8 *nci_extract_rf_params_nfcf_passive_poll(struct nci_dev *ndev,
 	return data;
 }
 
+static int nci_add_new_protocol(struct nci_dev *ndev,
+				struct nfc_target *target,
+				__u8 rf_protocol,
+				__u8 rf_tech_and_mode,
+				void *params)
+{
+	struct rf_tech_specific_params_nfca_poll *nfca_poll;
+	struct rf_tech_specific_params_nfcb_poll *nfcb_poll;
+	struct rf_tech_specific_params_nfcf_poll *nfcf_poll;
+	__u32 protocol;
+
+	if (rf_protocol == NCI_RF_PROTOCOL_T2T)
+		protocol = NFC_PROTO_MIFARE_MASK;
+	else if (rf_protocol == NCI_RF_PROTOCOL_ISO_DEP)
+		protocol = NFC_PROTO_ISO14443_MASK;
+	else if (rf_protocol == NCI_RF_PROTOCOL_T3T)
+		protocol = NFC_PROTO_FELICA_MASK;
+	else
+		protocol = 0;
+
+	if (!(protocol & ndev->poll_prots)) {
+		pr_err("the target found does not have the desired protocol\n");
+		return -EPROTO;
+	}
+
+	if (rf_tech_and_mode == NCI_NFC_A_PASSIVE_POLL_MODE) {
+		nfca_poll = (struct rf_tech_specific_params_nfca_poll *)params;
+
+		target->sens_res = nfca_poll->sens_res;
+		target->sel_res = nfca_poll->sel_res;
+		target->nfcid1_len = nfca_poll->nfcid1_len;
+		if (target->nfcid1_len > 0) {
+			memcpy(target->nfcid1, nfca_poll->nfcid1,
+				target->nfcid1_len);
+		}
+	} else if (rf_tech_and_mode == NCI_NFC_B_PASSIVE_POLL_MODE) {
+		nfcb_poll = (struct rf_tech_specific_params_nfcb_poll *)params;
+
+		target->sensb_res_len = nfcb_poll->sensb_res_len;
+		if (target->sensb_res_len > 0) {
+			memcpy(target->sensb_res, nfcb_poll->sensb_res,
+				target->sensb_res_len);
+		}
+	} else if (rf_tech_and_mode == NCI_NFC_F_PASSIVE_POLL_MODE) {
+		nfcf_poll = (struct rf_tech_specific_params_nfcf_poll *)params;
+
+		target->sensf_res_len = nfcf_poll->sensf_res_len;
+		if (target->sensf_res_len > 0) {
+			memcpy(target->sensf_res, nfcf_poll->sensf_res,
+				target->sensf_res_len);
+		}
+	} else {
+		pr_err("unsupported rf_tech_and_mode 0x%x\n", rf_tech_and_mode);
+		return -EPROTO;
+	}
+
+	target->supported_protocols |= protocol;
+
+	pr_debug("protocol 0x%x\n", protocol);
+
+	return 0;
+}
+
+static void nci_add_new_target(struct nci_dev *ndev,
+				struct nci_rf_discover_ntf *ntf)
+{
+	struct nfc_target *target;
+	int i, rc;
+
+	for (i = 0; i < ndev->n_targets; i++) {
+		target = &ndev->targets[i];
+		if (target->idx == ntf->rf_discovery_id) {
+			/* This target already exists, add the new protocol */
+			nci_add_new_protocol(ndev, target, ntf->rf_protocol,
+						ntf->rf_tech_and_mode,
+						&ntf->rf_tech_specific_params);
+			return;
+		}
+	}
+
+	/* This is a new target, check if we've enough room */
+	if (ndev->n_targets == NCI_MAX_DISCOVERED_TARGETS) {
+		pr_debug("not enough room, ignoring new target...\n");
+		return;
+	}
+
+	target = &ndev->targets[ndev->n_targets];
+
+	rc = nci_add_new_protocol(ndev, target, ntf->rf_protocol,
+					ntf->rf_tech_and_mode,
+					&ntf->rf_tech_specific_params);
+	if (!rc) {
+		target->idx = ntf->rf_discovery_id;
+		ndev->n_targets++;
+
+		pr_debug("target_idx %d, n_targets %d\n", target->idx,
+				ndev->n_targets);
+	}
+}
+
+void nci_clear_target_list(struct nci_dev *ndev)
+{
+	memset(ndev->targets, 0,
+		(sizeof(struct nfc_target)*NCI_MAX_DISCOVERED_TARGETS));
+
+	ndev->n_targets = 0;
+}
+
+static void nci_rf_discover_ntf_packet(struct nci_dev *ndev,
+					struct sk_buff *skb)
+{
+	struct nci_rf_discover_ntf ntf;
+	__u8 *data = skb->data;
+	bool add_target = true;
+
+	ntf.rf_discovery_id = *data++;
+	ntf.rf_protocol = *data++;
+	ntf.rf_tech_and_mode = *data++;
+	ntf.rf_tech_specific_params_len = *data++;
+
+	pr_debug("rf_discovery_id %d\n", ntf.rf_discovery_id);
+	pr_debug("rf_protocol 0x%x\n", ntf.rf_protocol);
+	pr_debug("rf_tech_and_mode 0x%x\n", ntf.rf_tech_and_mode);
+	pr_debug("rf_tech_specific_params_len %d\n",
+			ntf.rf_tech_specific_params_len);
+
+	if (ntf.rf_tech_specific_params_len > 0) {
+		switch (ntf.rf_tech_and_mode) {
+		case NCI_NFC_A_PASSIVE_POLL_MODE:
+			data = nci_extract_rf_params_nfca_passive_poll(ndev,
+				&(ntf.rf_tech_specific_params.nfca_poll), data);
+			break;
+
+		case NCI_NFC_B_PASSIVE_POLL_MODE:
+			data = nci_extract_rf_params_nfcb_passive_poll(ndev,
+				&(ntf.rf_tech_specific_params.nfcb_poll), data);
+			break;
+
+		case NCI_NFC_F_PASSIVE_POLL_MODE:
+			data = nci_extract_rf_params_nfcf_passive_poll(ndev,
+				&(ntf.rf_tech_specific_params.nfcf_poll), data);
+			break;
+
+		default:
+			pr_err("unsupported rf_tech_and_mode 0x%x\n",
+			       ntf.rf_tech_and_mode);
+			data += ntf.rf_tech_specific_params_len;
+			add_target = false;
+		}
+	}
+
+	ntf.ntf_type = *data++;
+	pr_debug("ntf_type %d\n", ntf.ntf_type);
+
+	if (add_target == true)
+		nci_add_new_target(ndev, &ntf);
+
+	if (ntf.ntf_type == NCI_DISCOVER_NTF_TYPE_MORE) {
+		atomic_set(&ndev->state, NCI_W4_ALL_DISCOVERIES);
+	} else {
+		atomic_set(&ndev->state, NCI_W4_HOST_SELECT);
+		nfc_targets_found(ndev->nfc_dev, ndev->targets,
+					ndev->n_targets);
+	}
+}
+
 static int nci_extract_activation_params_iso_dep(struct nci_dev *ndev,
 			struct nci_rf_intf_activated_ntf *ntf, __u8 *data)
 {
@@ -184,74 +355,32 @@ static int nci_extract_activation_params_iso_dep(struct nci_dev *ndev,
 	default:
 		pr_err("unsupported activation_rf_tech_and_mode 0x%x\n",
 		       ntf->activation_rf_tech_and_mode);
-		return -EPROTO;
+		return NCI_STATUS_RF_PROTOCOL_ERROR;
 	}
 
-	return 0;
+	return NCI_STATUS_OK;
 }
 
-static void nci_target_found(struct nci_dev *ndev,
-				struct nci_rf_intf_activated_ntf *ntf)
+static void nci_target_auto_activated(struct nci_dev *ndev,
+					struct nci_rf_intf_activated_ntf *ntf)
 {
-	struct nfc_target nfc_tgt;
+	struct nfc_target *target;
+	int rc;
 
-	memset(&nfc_tgt, 0, sizeof(nfc_tgt));
+	target = &ndev->targets[ndev->n_targets];
 
-	if (ntf->rf_protocol == NCI_RF_PROTOCOL_T2T)
-		nfc_tgt.supported_protocols = NFC_PROTO_MIFARE_MASK;
-	else if (ntf->rf_protocol == NCI_RF_PROTOCOL_ISO_DEP)
-		nfc_tgt.supported_protocols = NFC_PROTO_ISO14443_MASK;
-	else if (ntf->rf_protocol == NCI_RF_PROTOCOL_T3T)
-		nfc_tgt.supported_protocols = NFC_PROTO_FELICA_MASK;
-
-	if (!(nfc_tgt.supported_protocols & ndev->poll_prots)) {
-		pr_debug("the target found does not have the desired protocol\n");
+	rc = nci_add_new_protocol(ndev, target, ntf->rf_protocol,
+					ntf->activation_rf_tech_and_mode,
+					&ntf->rf_tech_specific_params);
+	if (rc)
 		return;
-	}
 
-	pr_debug("new target found,  supported_protocols 0x%x\n",
-		 nfc_tgt.supported_protocols);
-
-	if (ntf->activation_rf_tech_and_mode == NCI_NFC_A_PASSIVE_POLL_MODE) {
-		nfc_tgt.sens_res =
-			ntf->rf_tech_specific_params.nfca_poll.sens_res;
-		nfc_tgt.sel_res =
-			ntf->rf_tech_specific_params.nfca_poll.sel_res;
-		nfc_tgt.nfcid1_len =
-			ntf->rf_tech_specific_params.nfca_poll.nfcid1_len;
-		if (nfc_tgt.nfcid1_len > 0) {
-			memcpy(nfc_tgt.nfcid1,
-				ntf->rf_tech_specific_params.nfca_poll.nfcid1,
-				nfc_tgt.nfcid1_len);
-		}
-	} else if (ntf->activation_rf_tech_and_mode ==
-						NCI_NFC_B_PASSIVE_POLL_MODE) {
-		nfc_tgt.sensb_res_len =
-			ntf->rf_tech_specific_params.nfcb_poll.sensb_res_len;
-		if (nfc_tgt.sensb_res_len > 0) {
-			memcpy(nfc_tgt.sensb_res,
-			       ntf->rf_tech_specific_params.nfcb_poll.sensb_res,
-			       nfc_tgt.sensb_res_len);
-		}
-	} else if (ntf->activation_rf_tech_and_mode ==
-						NCI_NFC_F_PASSIVE_POLL_MODE) {
-		nfc_tgt.sensf_res_len =
-			ntf->rf_tech_specific_params.nfcf_poll.sensf_res_len;
-		if (nfc_tgt.sensf_res_len > 0) {
-			memcpy(nfc_tgt.sensf_res,
-			       ntf->rf_tech_specific_params.nfcf_poll.sensf_res,
-			       nfc_tgt.sensf_res_len);
-		}
-	}
+	target->idx = ntf->rf_discovery_id;
+	ndev->n_targets++;
 
-	ndev->target_available_prots = nfc_tgt.supported_protocols;
-	ndev->max_data_pkt_payload_size = ntf->max_data_pkt_payload_size;
-	ndev->initial_num_credits = ntf->initial_num_credits;
+	pr_debug("target_idx %d, n_targets %d\n", target->idx, ndev->n_targets);
 
-	/* set the available credits to initial value */
-	atomic_set(&ndev->credits_cnt, ndev->initial_num_credits);
-
-	nfc_targets_found(ndev->nfc_dev, &nfc_tgt, 1);
+	nfc_targets_found(ndev->nfc_dev, ndev->targets, ndev->n_targets);
 }
 
 static void nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
@@ -259,9 +388,7 @@ static void nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 {
 	struct nci_rf_intf_activated_ntf ntf;
 	__u8 *data = skb->data;
-	int err = 0;
-
-	atomic_set(&ndev->state, NCI_POLL_ACTIVE);
+	int err = NCI_STATUS_OK;
 
 	ntf.rf_discovery_id = *data++;
 	ntf.rf_interface = *data++;
@@ -286,23 +413,24 @@ static void nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 		switch (ntf.activation_rf_tech_and_mode) {
 		case NCI_NFC_A_PASSIVE_POLL_MODE:
 			data = nci_extract_rf_params_nfca_passive_poll(ndev,
-				&ntf, data);
+				&(ntf.rf_tech_specific_params.nfca_poll), data);
 			break;
 
 		case NCI_NFC_B_PASSIVE_POLL_MODE:
 			data = nci_extract_rf_params_nfcb_passive_poll(ndev,
-				&ntf, data);
+				&(ntf.rf_tech_specific_params.nfcb_poll), data);
 			break;
 
 		case NCI_NFC_F_PASSIVE_POLL_MODE:
 			data = nci_extract_rf_params_nfcf_passive_poll(ndev,
-				&ntf, data);
+				&(ntf.rf_tech_specific_params.nfcf_poll), data);
 			break;
 
 		default:
 			pr_err("unsupported activation_rf_tech_and_mode 0x%x\n",
 			       ntf.activation_rf_tech_and_mode);
-			return;
+			err = NCI_STATUS_RF_PROTOCOL_ERROR;
+			goto exit;
 		}
 	}
 
@@ -334,12 +462,30 @@ static void nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 		default:
 			pr_err("unsupported rf_interface 0x%x\n",
 			       ntf.rf_interface);
-			return;
+			err = NCI_STATUS_RF_PROTOCOL_ERROR;
+			break;
 		}
 	}
 
-	if (!err)
-		nci_target_found(ndev, &ntf);
+exit:
+	if (err == NCI_STATUS_OK) {
+		ndev->max_data_pkt_payload_size = ntf.max_data_pkt_payload_size;
+		ndev->initial_num_credits = ntf.initial_num_credits;
+
+		/* set the available credits to initial value */
+		atomic_set(&ndev->credits_cnt, ndev->initial_num_credits);
+	}
+
+	if (atomic_read(&ndev->state) == NCI_DISCOVERY) {
+		/* A single target was found and activated automatically */
+		atomic_set(&ndev->state, NCI_POLL_ACTIVE);
+		if (err == NCI_STATUS_OK)
+			nci_target_auto_activated(ndev, &ntf);
+	} else {	/* ndev->state == NCI_W4_HOST_SELECT */
+		/* A selected target was activated, so complete the request */
+		atomic_set(&ndev->state, NCI_POLL_ACTIVE);
+		nci_req_complete(ndev, err);
+	}
 }
 
 static void nci_rf_deactivate_ntf_packet(struct nci_dev *ndev,
@@ -349,9 +495,6 @@ static void nci_rf_deactivate_ntf_packet(struct nci_dev *ndev,
 
 	pr_debug("entry, type 0x%x, reason 0x%x\n", ntf->type, ntf->reason);
 
-	atomic_set(&ndev->state, NCI_IDLE);
-	ndev->target_active_prot = 0;
-
 	/* drop tx data queue */
 	skb_queue_purge(&ndev->tx_q);
 
@@ -365,6 +508,8 @@ static void nci_rf_deactivate_ntf_packet(struct nci_dev *ndev,
 	if (test_bit(NCI_DATA_EXCHANGE, &ndev->flags))
 		nci_data_exchange_complete(ndev, NULL, -EIO);
 
+	nci_clear_target_list(ndev);
+	atomic_set(&ndev->state, NCI_IDLE);
 	nci_req_complete(ndev, NCI_STATUS_OK);
 }
 
@@ -386,10 +531,18 @@ void nci_ntf_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		nci_core_conn_credits_ntf_packet(ndev, skb);
 		break;
 
+	case NCI_OP_CORE_GENERIC_ERROR_NTF:
+		nci_core_generic_error_ntf_packet(ndev, skb);
+		break;
+
 	case NCI_OP_CORE_INTF_ERROR_NTF:
 		nci_core_conn_intf_error_ntf_packet(ndev, skb);
 		break;
 
+	case NCI_OP_RF_DISCOVER_NTF:
+		nci_rf_discover_ntf_packet(ndev, skb);
+		break;
+
 	case NCI_OP_RF_INTF_ACTIVATED_NTF:
 		nci_rf_intf_activated_ntf_packet(ndev, skb);
 		break;
diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index cb8bce6..aa63b1e 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -142,6 +142,18 @@ static void nci_rf_disc_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 	nci_req_complete(ndev, status);
 }
 
+static void nci_rf_disc_select_rsp_packet(struct nci_dev *ndev,
+						struct sk_buff *skb)
+{
+	__u8 status = skb->data[0];
+
+	pr_debug("status 0x%x\n", status);
+
+	/* Complete the request on intf_activated_ntf or generic_error_ntf */
+	if (status != NCI_STATUS_OK)
+		nci_req_complete(ndev, status);
+}
+
 static void nci_rf_deactivate_rsp_packet(struct nci_dev *ndev,
 					struct sk_buff *skb)
 {
@@ -152,6 +164,7 @@ static void nci_rf_deactivate_rsp_packet(struct nci_dev *ndev,
 	/* If target was active, complete the request only in deactivate_ntf */
 	if ((status != NCI_STATUS_OK) ||
 		(atomic_read(&ndev->state) != NCI_POLL_ACTIVE)) {
+		nci_clear_target_list(ndev);
 		atomic_set(&ndev->state, NCI_IDLE);
 		nci_req_complete(ndev, status);
 	}
@@ -190,6 +203,10 @@ void nci_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		nci_rf_disc_rsp_packet(ndev, skb);
 		break;
 
+	case NCI_OP_RF_DISCOVER_SELECT_RSP:
+		nci_rf_disc_select_rsp_packet(ndev, skb);
+		break;
+
 	case NCI_OP_RF_DEACTIVATE_RSP:
 		nci_rf_deactivate_rsp_packet(ndev, skb);
 		break;
-- 
1.7.0.4

