Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51617 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755074Ab2CDX6c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2012 18:58:32 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 22/22] NFC: NCI code identation fixes
Date: Mon,  5 Mar 2012 01:03:54 +0100
Message-Id: <1330905834-6994-23-git-send-email-sameo@linux.intel.com> (sfid-20120305_005836_941258_712D4950)
In-Reply-To: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
References: <1330905834-6994-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 include/net/nfc/nci_core.h |   10 ++--
 net/nfc/nci/core.c         |  113 +++++++++++++++++++++-----------------------
 net/nfc/nci/data.c         |   28 +++++-----
 net/nfc/nci/ntf.c          |   75 ++++++++++++++---------------
 net/nfc/nci/rsp.c          |   17 +++----
 5 files changed, 116 insertions(+), 127 deletions(-)

diff --git a/include/net/nfc/nci_core.h b/include/net/nfc/nci_core.h
index 86fee8b..feba740 100644
--- a/include/net/nfc/nci_core.h
+++ b/include/net/nfc/nci_core.h
@@ -141,17 +141,17 @@ struct nci_dev {
 
 /* ----- NCI Devices ----- */
 struct nci_dev *nci_allocate_device(struct nci_ops *ops,
-				__u32 supported_protocols,
-				int tx_headroom,
-				int tx_tailroom);
+				    __u32 supported_protocols,
+				    int tx_headroom,
+				    int tx_tailroom);
 void nci_free_device(struct nci_dev *ndev);
 int nci_register_device(struct nci_dev *ndev);
 void nci_unregister_device(struct nci_dev *ndev);
 int nci_recv_frame(struct sk_buff *skb);
 
 static inline struct sk_buff *nci_skb_alloc(struct nci_dev *ndev,
-						unsigned int len,
-						gfp_t how)
+					    unsigned int len,
+					    gfp_t how)
 {
 	struct sk_buff *skb;
 
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index a47e90c..9ec065b 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -66,9 +66,8 @@ static void nci_req_cancel(struct nci_dev *ndev, int err)
 
 /* Execute request and wait for completion. */
 static int __nci_request(struct nci_dev *ndev,
-	void (*req)(struct nci_dev *ndev, unsigned long opt),
-	unsigned long opt,
-	__u32 timeout)
+			 void (*req)(struct nci_dev *ndev, unsigned long opt),
+			 unsigned long opt, __u32 timeout)
 {
 	int rc = 0;
 	long completion_rc;
@@ -77,9 +76,9 @@ static int __nci_request(struct nci_dev *ndev,
 
 	init_completion(&ndev->req_completion);
 	req(ndev, opt);
-	completion_rc = wait_for_completion_interruptible_timeout(
-							&ndev->req_completion,
-							timeout);
+	completion_rc =
+		wait_for_completion_interruptible_timeout(&ndev->req_completion,
+							  timeout);
 
 	pr_debug("wait_for_completion return %ld\n", completion_rc);
 
@@ -110,8 +109,9 @@ static int __nci_request(struct nci_dev *ndev,
 }
 
 static inline int nci_request(struct nci_dev *ndev,
-		void (*req)(struct nci_dev *ndev, unsigned long opt),
-		unsigned long opt, __u32 timeout)
+			      void (*req)(struct nci_dev *ndev,
+					  unsigned long opt),
+			      unsigned long opt, __u32 timeout)
 {
 	int rc;
 
@@ -152,14 +152,14 @@ static void nci_init_complete_req(struct nci_dev *ndev, unsigned long opt)
 	/* by default mapping is set to NCI_RF_INTERFACE_FRAME */
 	for (i = 0; i < ndev->num_supported_rf_interfaces; i++) {
 		if (ndev->supported_rf_interfaces[i] ==
-			NCI_RF_INTERFACE_ISO_DEP) {
+		    NCI_RF_INTERFACE_ISO_DEP) {
 			cfg[*num].rf_protocol = NCI_RF_PROTOCOL_ISO_DEP;
 			cfg[*num].mode = NCI_DISC_MAP_MODE_POLL |
 				NCI_DISC_MAP_MODE_LISTEN;
 			cfg[*num].rf_interface = NCI_RF_INTERFACE_ISO_DEP;
 			(*num)++;
 		} else if (ndev->supported_rf_interfaces[i] ==
-			NCI_RF_INTERFACE_NFC_DEP) {
+			   NCI_RF_INTERFACE_NFC_DEP) {
 			cfg[*num].rf_protocol = NCI_RF_PROTOCOL_NFC_DEP;
 			cfg[*num].mode = NCI_DISC_MAP_MODE_POLL |
 				NCI_DISC_MAP_MODE_LISTEN;
@@ -172,8 +172,7 @@ static void nci_init_complete_req(struct nci_dev *ndev, unsigned long opt)
 	}
 
 	nci_send_cmd(ndev, NCI_OP_RF_DISCOVER_MAP_CMD,
-		(1 + ((*num)*sizeof(struct disc_map_config))),
-		&cmd);
+		     (1 + ((*num) * sizeof(struct disc_map_config))), &cmd);
 }
 
 static void nci_rf_discover_req(struct nci_dev *ndev, unsigned long opt)
@@ -184,36 +183,36 @@ static void nci_rf_discover_req(struct nci_dev *ndev, unsigned long opt)
 	cmd.num_disc_configs = 0;
 
 	if ((cmd.num_disc_configs < NCI_MAX_NUM_RF_CONFIGS) &&
-		(protocols & NFC_PROTO_JEWEL_MASK
-		|| protocols & NFC_PROTO_MIFARE_MASK
-		|| protocols & NFC_PROTO_ISO14443_MASK
-		|| protocols & NFC_PROTO_NFC_DEP_MASK)) {
+	    (protocols & NFC_PROTO_JEWEL_MASK
+	     || protocols & NFC_PROTO_MIFARE_MASK
+	     || protocols & NFC_PROTO_ISO14443_MASK
+	     || protocols & NFC_PROTO_NFC_DEP_MASK)) {
 		cmd.disc_configs[cmd.num_disc_configs].rf_tech_and_mode =
-		NCI_NFC_A_PASSIVE_POLL_MODE;
+			NCI_NFC_A_PASSIVE_POLL_MODE;
 		cmd.disc_configs[cmd.num_disc_configs].frequency = 1;
 		cmd.num_disc_configs++;
 	}
 
 	if ((cmd.num_disc_configs < NCI_MAX_NUM_RF_CONFIGS) &&
-		(protocols & NFC_PROTO_ISO14443_MASK)) {
+	    (protocols & NFC_PROTO_ISO14443_MASK)) {
 		cmd.disc_configs[cmd.num_disc_configs].rf_tech_and_mode =
-		NCI_NFC_B_PASSIVE_POLL_MODE;
+			NCI_NFC_B_PASSIVE_POLL_MODE;
 		cmd.disc_configs[cmd.num_disc_configs].frequency = 1;
 		cmd.num_disc_configs++;
 	}
 
 	if ((cmd.num_disc_configs < NCI_MAX_NUM_RF_CONFIGS) &&
-		(protocols & NFC_PROTO_FELICA_MASK
-		|| protocols & NFC_PROTO_NFC_DEP_MASK)) {
+	    (protocols & NFC_PROTO_FELICA_MASK
+	     || protocols & NFC_PROTO_NFC_DEP_MASK)) {
 		cmd.disc_configs[cmd.num_disc_configs].rf_tech_and_mode =
-		NCI_NFC_F_PASSIVE_POLL_MODE;
+			NCI_NFC_F_PASSIVE_POLL_MODE;
 		cmd.disc_configs[cmd.num_disc_configs].frequency = 1;
 		cmd.num_disc_configs++;
 	}
 
 	nci_send_cmd(ndev, NCI_OP_RF_DISCOVER_CMD,
-		(1 + (cmd.num_disc_configs*sizeof(struct disc_config))),
-		&cmd);
+		     (1 + (cmd.num_disc_configs * sizeof(struct disc_config))),
+		     &cmd);
 }
 
 struct nci_rf_discover_select_param {
@@ -224,7 +223,7 @@ struct nci_rf_discover_select_param {
 static void nci_rf_discover_select_req(struct nci_dev *ndev, unsigned long opt)
 {
 	struct nci_rf_discover_select_param *param =
-				(struct nci_rf_discover_select_param *)opt;
+		(struct nci_rf_discover_select_param *)opt;
 	struct nci_rf_discover_select_cmd cmd;
 
 	cmd.rf_discovery_id = param->rf_discovery_id;
@@ -245,8 +244,7 @@ static void nci_rf_discover_select_req(struct nci_dev *ndev, unsigned long opt)
 	}
 
 	nci_send_cmd(ndev, NCI_OP_RF_DISCOVER_SELECT_CMD,
-			sizeof(struct nci_rf_discover_select_cmd),
-			&cmd);
+		     sizeof(struct nci_rf_discover_select_cmd), &cmd);
 }
 
 static void nci_rf_deactivate_req(struct nci_dev *ndev, unsigned long opt)
@@ -256,8 +254,7 @@ static void nci_rf_deactivate_req(struct nci_dev *ndev, unsigned long opt)
 	cmd.type = NCI_DEACTIVATE_TYPE_IDLE_MODE;
 
 	nci_send_cmd(ndev, NCI_OP_RF_DEACTIVATE_CMD,
-			sizeof(struct nci_rf_deactivate_cmd),
-			&cmd);
+		     sizeof(struct nci_rf_deactivate_cmd), &cmd);
 }
 
 static int nci_open_device(struct nci_dev *ndev)
@@ -281,16 +278,16 @@ static int nci_open_device(struct nci_dev *ndev)
 	set_bit(NCI_INIT, &ndev->flags);
 
 	rc = __nci_request(ndev, nci_reset_req, 0,
-				msecs_to_jiffies(NCI_RESET_TIMEOUT));
+			   msecs_to_jiffies(NCI_RESET_TIMEOUT));
 
 	if (!rc) {
 		rc = __nci_request(ndev, nci_init_req, 0,
-				msecs_to_jiffies(NCI_INIT_TIMEOUT));
+				   msecs_to_jiffies(NCI_INIT_TIMEOUT));
 	}
 
 	if (!rc) {
 		rc = __nci_request(ndev, nci_init_complete_req, 0,
-				msecs_to_jiffies(NCI_INIT_TIMEOUT));
+				   msecs_to_jiffies(NCI_INIT_TIMEOUT));
 	}
 
 	clear_bit(NCI_INIT, &ndev->flags);
@@ -340,7 +337,7 @@ static int nci_close_device(struct nci_dev *ndev)
 
 	set_bit(NCI_INIT, &ndev->flags);
 	__nci_request(ndev, nci_reset_req, 0,
-				msecs_to_jiffies(NCI_RESET_TIMEOUT));
+		      msecs_to_jiffies(NCI_RESET_TIMEOUT));
 	clear_bit(NCI_INIT, &ndev->flags);
 
 	/* Flush cmd wq */
@@ -396,7 +393,7 @@ static int nci_start_poll(struct nfc_dev *nfc_dev, __u32 protocols)
 	int rc;
 
 	if ((atomic_read(&ndev->state) == NCI_DISCOVERY) ||
-		(atomic_read(&ndev->state) == NCI_W4_ALL_DISCOVERIES)) {
+	    (atomic_read(&ndev->state) == NCI_W4_ALL_DISCOVERIES)) {
 		pr_err("unable to start poll, since poll is already active\n");
 		return -EBUSY;
 	}
@@ -407,17 +404,17 @@ static int nci_start_poll(struct nfc_dev *nfc_dev, __u32 protocols)
 	}
 
 	if ((atomic_read(&ndev->state) == NCI_W4_HOST_SELECT) ||
-		(atomic_read(&ndev->state) == NCI_POLL_ACTIVE)) {
+	    (atomic_read(&ndev->state) == NCI_POLL_ACTIVE)) {
 		pr_debug("target active or w4 select, implicitly deactivate\n");
 
 		rc = nci_request(ndev, nci_rf_deactivate_req, 0,
-			msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
+				 msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
 		if (rc)
 			return -EBUSY;
 	}
 
 	rc = nci_request(ndev, nci_rf_discover_req, protocols,
-		msecs_to_jiffies(NCI_RF_DISC_TIMEOUT));
+			 msecs_to_jiffies(NCI_RF_DISC_TIMEOUT));
 
 	if (!rc)
 		ndev->poll_prots = protocols;
@@ -430,17 +427,17 @@ static void nci_stop_poll(struct nfc_dev *nfc_dev)
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 
 	if ((atomic_read(&ndev->state) != NCI_DISCOVERY) &&
-		(atomic_read(&ndev->state) != NCI_W4_ALL_DISCOVERIES)) {
+	    (atomic_read(&ndev->state) != NCI_W4_ALL_DISCOVERIES)) {
 		pr_err("unable to stop poll, since poll is not active\n");
 		return;
 	}
 
 	nci_request(ndev, nci_rf_deactivate_req, 0,
-		msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
+		    msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
 }
 
 static int nci_activate_target(struct nfc_dev *nfc_dev, __u32 target_idx,
-				__u32 protocol)
+			       __u32 protocol)
 {
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 	struct nci_rf_discover_select_param param;
@@ -451,7 +448,7 @@ static int nci_activate_target(struct nfc_dev *nfc_dev, __u32 target_idx,
 	pr_debug("target_idx %d, protocol 0x%x\n", target_idx, protocol);
 
 	if ((atomic_read(&ndev->state) != NCI_W4_HOST_SELECT) &&
-		(atomic_read(&ndev->state) != NCI_POLL_ACTIVE)) {
+	    (atomic_read(&ndev->state) != NCI_POLL_ACTIVE)) {
 		pr_err("there is no available target to activate\n");
 		return -EINVAL;
 	}
@@ -494,8 +491,8 @@ static int nci_activate_target(struct nfc_dev *nfc_dev, __u32 target_idx,
 			param.rf_protocol = NCI_RF_PROTOCOL_NFC_DEP;
 
 		rc = nci_request(ndev, nci_rf_discover_select_req,
-				(unsigned long)&param,
-				msecs_to_jiffies(NCI_RF_DISC_SELECT_TIMEOUT));
+				 (unsigned long)&param,
+				 msecs_to_jiffies(NCI_RF_DISC_SELECT_TIMEOUT));
 	}
 
 	if (!rc)
@@ -519,14 +516,13 @@ static void nci_deactivate_target(struct nfc_dev *nfc_dev, __u32 target_idx)
 
 	if (atomic_read(&ndev->state) == NCI_POLL_ACTIVE) {
 		nci_request(ndev, nci_rf_deactivate_req, 0,
-			msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
+			    msecs_to_jiffies(NCI_RF_DEACTIVATE_TIMEOUT));
 	}
 }
 
 static int nci_data_exchange(struct nfc_dev *nfc_dev, __u32 target_idx,
-						struct sk_buff *skb,
-						data_exchange_cb_t cb,
-						void *cb_context)
+			     struct sk_buff *skb,
+			     data_exchange_cb_t cb, void *cb_context)
 {
 	struct nci_dev *ndev = nfc_get_drvdata(nfc_dev);
 	int rc;
@@ -571,9 +567,8 @@ static struct nfc_ops nci_nfc_ops = {
  * @supported_protocols: NFC protocols supported by the device
  */
 struct nci_dev *nci_allocate_device(struct nci_ops *ops,
-					__u32 supported_protocols,
-					int tx_headroom,
-					int tx_tailroom)
+				    __u32 supported_protocols,
+				    int tx_headroom, int tx_tailroom)
 {
 	struct nci_dev *ndev;
 
@@ -594,9 +589,9 @@ struct nci_dev *nci_allocate_device(struct nci_ops *ops,
 	ndev->tx_tailroom = tx_tailroom;
 
 	ndev->nfc_dev = nfc_allocate_device(&nci_nfc_ops,
-						supported_protocols,
-						tx_headroom + NCI_DATA_HDR_SIZE,
-						tx_tailroom);
+					    supported_protocols,
+					    tx_headroom + NCI_DATA_HDR_SIZE,
+					    tx_tailroom);
 	if (!ndev->nfc_dev)
 		goto free_exit;
 
@@ -668,9 +663,9 @@ int nci_register_device(struct nci_dev *ndev)
 	skb_queue_head_init(&ndev->tx_q);
 
 	setup_timer(&ndev->cmd_timer, nci_cmd_timer,
-			(unsigned long) ndev);
+		    (unsigned long) ndev);
 	setup_timer(&ndev->data_timer, nci_data_timer,
-			(unsigned long) ndev);
+		    (unsigned long) ndev);
 
 	mutex_init(&ndev->req_lock);
 
@@ -719,7 +714,7 @@ int nci_recv_frame(struct sk_buff *skb)
 	pr_debug("len %d\n", skb->len);
 
 	if (!ndev || (!test_bit(NCI_UP, &ndev->flags)
-		&& !test_bit(NCI_INIT, &ndev->flags))) {
+		      && !test_bit(NCI_INIT, &ndev->flags))) {
 		kfree_skb(skb);
 		return -ENXIO;
 	}
@@ -799,7 +794,7 @@ static void nci_tx_work(struct work_struct *work)
 
 		/* Check if data flow control is used */
 		if (atomic_read(&ndev->credits_cnt) !=
-				NCI_DATA_FLOW_CONTROL_NOT_USED)
+		    NCI_DATA_FLOW_CONTROL_NOT_USED)
 			atomic_dec(&ndev->credits_cnt);
 
 		pr_debug("NCI TX: MT=data, PBF=%d, conn_id=%d, plen=%d\n",
@@ -810,7 +805,7 @@ static void nci_tx_work(struct work_struct *work)
 		nci_send_frame(skb);
 
 		mod_timer(&ndev->data_timer,
-			jiffies + msecs_to_jiffies(NCI_DATA_TIMEOUT));
+			  jiffies + msecs_to_jiffies(NCI_DATA_TIMEOUT));
 	}
 }
 
@@ -879,6 +874,6 @@ static void nci_cmd_work(struct work_struct *work)
 		nci_send_frame(skb);
 
 		mod_timer(&ndev->cmd_timer,
-			jiffies + msecs_to_jiffies(NCI_CMD_TIMEOUT));
+			  jiffies + msecs_to_jiffies(NCI_CMD_TIMEOUT));
 	}
 }
diff --git a/net/nfc/nci/data.c b/net/nfc/nci/data.c
index 7880ae9..a0bc326 100644
--- a/net/nfc/nci/data.c
+++ b/net/nfc/nci/data.c
@@ -35,8 +35,7 @@
 #include <linux/nfc.h>
 
 /* Complete data exchange transaction and forward skb to nfc core */
-void nci_data_exchange_complete(struct nci_dev *ndev,
-				struct sk_buff *skb,
+void nci_data_exchange_complete(struct nci_dev *ndev, struct sk_buff *skb,
 				int err)
 {
 	data_exchange_cb_t cb = ndev->data_exchange_cb;
@@ -67,9 +66,9 @@ void nci_data_exchange_complete(struct nci_dev *ndev,
 /* ----------------- NCI TX Data ----------------- */
 
 static inline void nci_push_data_hdr(struct nci_dev *ndev,
-					__u8 conn_id,
-					struct sk_buff *skb,
-					__u8 pbf)
+				     __u8 conn_id,
+				     struct sk_buff *skb,
+				     __u8 pbf)
 {
 	struct nci_data_hdr *hdr;
 	int plen = skb->len;
@@ -86,8 +85,8 @@ static inline void nci_push_data_hdr(struct nci_dev *ndev,
 }
 
 static int nci_queue_tx_data_frags(struct nci_dev *ndev,
-					__u8 conn_id,
-					struct sk_buff *skb) {
+				   __u8 conn_id,
+				   struct sk_buff *skb) {
 	int total_len = skb->len;
 	unsigned char *data = skb->data;
 	unsigned long flags;
@@ -105,8 +104,8 @@ static int nci_queue_tx_data_frags(struct nci_dev *ndev,
 			min_t(int, total_len, ndev->max_data_pkt_payload_size);
 
 		skb_frag = nci_skb_alloc(ndev,
-					(NCI_DATA_HDR_SIZE + frag_len),
-					GFP_KERNEL);
+					 (NCI_DATA_HDR_SIZE + frag_len),
+					 GFP_KERNEL);
 		if (skb_frag == NULL) {
 			rc = -ENOMEM;
 			goto free_exit;
@@ -118,7 +117,8 @@ static int nci_queue_tx_data_frags(struct nci_dev *ndev,
 
 		/* second, set the header */
 		nci_push_data_hdr(ndev, conn_id, skb_frag,
-		((total_len == frag_len) ? (NCI_PBF_LAST) : (NCI_PBF_CONT)));
+				  ((total_len == frag_len) ?
+				   (NCI_PBF_LAST) : (NCI_PBF_CONT)));
 
 		__skb_queue_tail(&frags_q, skb_frag);
 
@@ -186,8 +186,8 @@ exit:
 /* ----------------- NCI RX Data ----------------- */
 
 static void nci_add_rx_data_frag(struct nci_dev *ndev,
-				struct sk_buff *skb,
-				__u8 pbf)
+				 struct sk_buff *skb,
+				 __u8 pbf)
 {
 	int reassembly_len;
 	int err = 0;
@@ -211,8 +211,8 @@ static void nci_add_rx_data_frag(struct nci_dev *ndev,
 
 		/* second, combine the two fragments */
 		memcpy(skb_push(skb, reassembly_len),
-				ndev->rx_data_reassembly->data,
-				reassembly_len);
+		       ndev->rx_data_reassembly->data,
+		       reassembly_len);
 
 		/* third, free old reassembly */
 		kfree_skb(ndev->rx_data_reassembly);
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 03e7b46..2e3dee4 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -40,7 +40,7 @@
 /* Handle NCI Notification packets */
 
 static void nci_core_conn_credits_ntf_packet(struct nci_dev *ndev,
-						struct sk_buff *skb)
+					     struct sk_buff *skb)
 {
 	struct nci_core_conn_credit_ntf *ntf = (void *) skb->data;
 	int i;
@@ -62,7 +62,7 @@ static void nci_core_conn_credits_ntf_packet(struct nci_dev *ndev,
 		if (ntf->conn_entries[i].conn_id == NCI_STATIC_RF_CONN_ID) {
 			/* found static rf connection */
 			atomic_add(ntf->conn_entries[i].credits,
-				&ndev->credits_cnt);
+				   &ndev->credits_cnt);
 		}
 	}
 
@@ -72,7 +72,7 @@ static void nci_core_conn_credits_ntf_packet(struct nci_dev *ndev,
 }
 
 static void nci_core_generic_error_ntf_packet(struct nci_dev *ndev,
-						struct sk_buff *skb)
+					      struct sk_buff *skb)
 {
 	__u8 status = skb->data[0];
 
@@ -80,7 +80,7 @@ static void nci_core_generic_error_ntf_packet(struct nci_dev *ndev,
 
 	if (atomic_read(&ndev->state) == NCI_W4_HOST_SELECT) {
 		/* Activation failed, so complete the request
-		(the state remains the same) */
+		   (the state remains the same) */
 		nci_req_complete(ndev, status);
 	}
 }
@@ -101,7 +101,7 @@ static void nci_core_conn_intf_error_ntf_packet(struct nci_dev *ndev,
 
 static __u8 *nci_extract_rf_params_nfca_passive_poll(struct nci_dev *ndev,
 			struct rf_tech_specific_params_nfca_poll *nfca_poll,
-			__u8 *data)
+						     __u8 *data)
 {
 	nfca_poll->sens_res = __le16_to_cpu(*((__u16 *)data));
 	data += 2;
@@ -128,7 +128,7 @@ static __u8 *nci_extract_rf_params_nfca_passive_poll(struct nci_dev *ndev,
 
 static __u8 *nci_extract_rf_params_nfcb_passive_poll(struct nci_dev *ndev,
 			struct rf_tech_specific_params_nfcb_poll *nfcb_poll,
-			__u8 *data)
+						     __u8 *data)
 {
 	nfcb_poll->sensb_res_len = *data++;
 
@@ -142,13 +142,13 @@ static __u8 *nci_extract_rf_params_nfcb_passive_poll(struct nci_dev *ndev,
 
 static __u8 *nci_extract_rf_params_nfcf_passive_poll(struct nci_dev *ndev,
 			struct rf_tech_specific_params_nfcf_poll *nfcf_poll,
-			__u8 *data)
+						     __u8 *data)
 {
 	nfcf_poll->bit_rate = *data++;
 	nfcf_poll->sensf_res_len = *data++;
 
 	pr_debug("bit_rate %d, sensf_res_len %d\n",
-		nfcf_poll->bit_rate, nfcf_poll->sensf_res_len);
+		 nfcf_poll->bit_rate, nfcf_poll->sensf_res_len);
 
 	memcpy(nfcf_poll->sensf_res, data, nfcf_poll->sensf_res_len);
 	data += nfcf_poll->sensf_res_len;
@@ -189,7 +189,7 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		target->nfcid1_len = nfca_poll->nfcid1_len;
 		if (target->nfcid1_len > 0) {
 			memcpy(target->nfcid1, nfca_poll->nfcid1,
-				target->nfcid1_len);
+			       target->nfcid1_len);
 		}
 	} else if (rf_tech_and_mode == NCI_NFC_B_PASSIVE_POLL_MODE) {
 		nfcb_poll = (struct rf_tech_specific_params_nfcb_poll *)params;
@@ -197,7 +197,7 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		target->sensb_res_len = nfcb_poll->sensb_res_len;
 		if (target->sensb_res_len > 0) {
 			memcpy(target->sensb_res, nfcb_poll->sensb_res,
-				target->sensb_res_len);
+			       target->sensb_res_len);
 		}
 	} else if (rf_tech_and_mode == NCI_NFC_F_PASSIVE_POLL_MODE) {
 		nfcf_poll = (struct rf_tech_specific_params_nfcf_poll *)params;
@@ -205,7 +205,7 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 		target->sensf_res_len = nfcf_poll->sensf_res_len;
 		if (target->sensf_res_len > 0) {
 			memcpy(target->sensf_res, nfcf_poll->sensf_res,
-				target->sensf_res_len);
+			       target->sensf_res_len);
 		}
 	} else {
 		pr_err("unsupported rf_tech_and_mode 0x%x\n", rf_tech_and_mode);
@@ -220,7 +220,7 @@ static int nci_add_new_protocol(struct nci_dev *ndev,
 }
 
 static void nci_add_new_target(struct nci_dev *ndev,
-				struct nci_rf_discover_ntf *ntf)
+			       struct nci_rf_discover_ntf *ntf)
 {
 	struct nfc_target *target;
 	int i, rc;
@@ -230,8 +230,8 @@ static void nci_add_new_target(struct nci_dev *ndev,
 		if (target->idx == ntf->rf_discovery_id) {
 			/* This target already exists, add the new protocol */
 			nci_add_new_protocol(ndev, target, ntf->rf_protocol,
-						ntf->rf_tech_and_mode,
-						&ntf->rf_tech_specific_params);
+					     ntf->rf_tech_and_mode,
+					     &ntf->rf_tech_specific_params);
 			return;
 		}
 	}
@@ -245,27 +245,27 @@ static void nci_add_new_target(struct nci_dev *ndev,
 	target = &ndev->targets[ndev->n_targets];
 
 	rc = nci_add_new_protocol(ndev, target, ntf->rf_protocol,
-					ntf->rf_tech_and_mode,
-					&ntf->rf_tech_specific_params);
+				  ntf->rf_tech_and_mode,
+				  &ntf->rf_tech_specific_params);
 	if (!rc) {
 		target->idx = ntf->rf_discovery_id;
 		ndev->n_targets++;
 
 		pr_debug("target_idx %d, n_targets %d\n", target->idx,
-				ndev->n_targets);
+			 ndev->n_targets);
 	}
 }
 
 void nci_clear_target_list(struct nci_dev *ndev)
 {
 	memset(ndev->targets, 0,
-		(sizeof(struct nfc_target)*NCI_MAX_DISCOVERED_TARGETS));
+	       (sizeof(struct nfc_target)*NCI_MAX_DISCOVERED_TARGETS));
 
 	ndev->n_targets = 0;
 }
 
 static void nci_rf_discover_ntf_packet(struct nci_dev *ndev,
-					struct sk_buff *skb)
+				       struct sk_buff *skb)
 {
 	struct nci_rf_discover_ntf ntf;
 	__u8 *data = skb->data;
@@ -280,7 +280,7 @@ static void nci_rf_discover_ntf_packet(struct nci_dev *ndev,
 	pr_debug("rf_protocol 0x%x\n", ntf.rf_protocol);
 	pr_debug("rf_tech_and_mode 0x%x\n", ntf.rf_tech_and_mode);
 	pr_debug("rf_tech_specific_params_len %d\n",
-			ntf.rf_tech_specific_params_len);
+		 ntf.rf_tech_specific_params_len);
 
 	if (ntf.rf_tech_specific_params_len > 0) {
 		switch (ntf.rf_tech_and_mode) {
@@ -318,7 +318,7 @@ static void nci_rf_discover_ntf_packet(struct nci_dev *ndev,
 	} else {
 		atomic_set(&ndev->state, NCI_W4_HOST_SELECT);
 		nfc_targets_found(ndev->nfc_dev, ndev->targets,
-					ndev->n_targets);
+				  ndev->n_targets);
 	}
 }
 
@@ -335,20 +335,17 @@ static int nci_extract_activation_params_iso_dep(struct nci_dev *ndev,
 		pr_debug("rats_res_len %d\n", nfca_poll->rats_res_len);
 		if (nfca_poll->rats_res_len > 0) {
 			memcpy(nfca_poll->rats_res,
-				data,
-				nfca_poll->rats_res_len);
+			       data, nfca_poll->rats_res_len);
 		}
 		break;
 
 	case NCI_NFC_B_PASSIVE_POLL_MODE:
 		nfcb_poll = &ntf->activation_params.nfcb_poll_iso_dep;
 		nfcb_poll->attrib_res_len = *data++;
-		pr_debug("attrib_res_len %d\n",
-			nfcb_poll->attrib_res_len);
+		pr_debug("attrib_res_len %d\n", nfcb_poll->attrib_res_len);
 		if (nfcb_poll->attrib_res_len > 0) {
 			memcpy(nfcb_poll->attrib_res,
-				data,
-				nfcb_poll->attrib_res_len);
+			       data, nfcb_poll->attrib_res_len);
 		}
 		break;
 
@@ -362,7 +359,7 @@ static int nci_extract_activation_params_iso_dep(struct nci_dev *ndev,
 }
 
 static void nci_target_auto_activated(struct nci_dev *ndev,
-					struct nci_rf_intf_activated_ntf *ntf)
+				      struct nci_rf_intf_activated_ntf *ntf)
 {
 	struct nfc_target *target;
 	int rc;
@@ -370,8 +367,8 @@ static void nci_target_auto_activated(struct nci_dev *ndev,
 	target = &ndev->targets[ndev->n_targets];
 
 	rc = nci_add_new_protocol(ndev, target, ntf->rf_protocol,
-					ntf->activation_rf_tech_and_mode,
-					&ntf->rf_tech_specific_params);
+				  ntf->activation_rf_tech_and_mode,
+				  &ntf->rf_tech_specific_params);
 	if (rc)
 		return;
 
@@ -384,7 +381,7 @@ static void nci_target_auto_activated(struct nci_dev *ndev,
 }
 
 static void nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
-						struct sk_buff *skb)
+					     struct sk_buff *skb)
 {
 	struct nci_rf_intf_activated_ntf ntf;
 	__u8 *data = skb->data;
@@ -405,7 +402,8 @@ static void nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 		 ntf.activation_rf_tech_and_mode);
 	pr_debug("max_data_pkt_payload_size 0x%x\n",
 		 ntf.max_data_pkt_payload_size);
-	pr_debug("initial_num_credits 0x%x\n", ntf.initial_num_credits);
+	pr_debug("initial_num_credits 0x%x\n",
+		 ntf.initial_num_credits);
 	pr_debug("rf_tech_specific_params_len %d\n",
 		 ntf.rf_tech_specific_params_len);
 
@@ -441,18 +439,15 @@ static void nci_rf_intf_activated_ntf_packet(struct nci_dev *ndev,
 
 	pr_debug("data_exch_rf_tech_and_mode 0x%x\n",
 		 ntf.data_exch_rf_tech_and_mode);
-	pr_debug("data_exch_tx_bit_rate 0x%x\n",
-		 ntf.data_exch_tx_bit_rate);
-	pr_debug("data_exch_rx_bit_rate 0x%x\n",
-		 ntf.data_exch_rx_bit_rate);
-	pr_debug("activation_params_len %d\n",
-		 ntf.activation_params_len);
+	pr_debug("data_exch_tx_bit_rate 0x%x\n", ntf.data_exch_tx_bit_rate);
+	pr_debug("data_exch_rx_bit_rate 0x%x\n", ntf.data_exch_rx_bit_rate);
+	pr_debug("activation_params_len %d\n", ntf.activation_params_len);
 
 	if (ntf.activation_params_len > 0) {
 		switch (ntf.rf_interface) {
 		case NCI_RF_INTERFACE_ISO_DEP:
 			err = nci_extract_activation_params_iso_dep(ndev,
-				&ntf, data);
+								    &ntf, data);
 			break;
 
 		case NCI_RF_INTERFACE_FRAME:
@@ -489,7 +484,7 @@ exit:
 }
 
 static void nci_rf_deactivate_ntf_packet(struct nci_dev *ndev,
-					struct sk_buff *skb)
+					 struct sk_buff *skb)
 {
 	struct nci_rf_deactivate_ntf *ntf = (void *) skb->data;
 
diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index aa63b1e..3003c33 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -67,19 +67,18 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 	ndev->num_supported_rf_interfaces = rsp_1->num_supported_rf_interfaces;
 
 	if (ndev->num_supported_rf_interfaces >
-			NCI_MAX_SUPPORTED_RF_INTERFACES) {
+	    NCI_MAX_SUPPORTED_RF_INTERFACES) {
 		ndev->num_supported_rf_interfaces =
 			NCI_MAX_SUPPORTED_RF_INTERFACES;
 	}
 
 	memcpy(ndev->supported_rf_interfaces,
-		rsp_1->supported_rf_interfaces,
-		ndev->num_supported_rf_interfaces);
+	       rsp_1->supported_rf_interfaces,
+	       ndev->num_supported_rf_interfaces);
 
 	rsp_2 = (void *) (skb->data + 6 + rsp_1->num_supported_rf_interfaces);
 
-	ndev->max_logical_connections =
-		rsp_2->max_logical_connections;
+	ndev->max_logical_connections = rsp_2->max_logical_connections;
 	ndev->max_routing_table_size =
 		__le16_to_cpu(rsp_2->max_routing_table_size);
 	ndev->max_ctrl_pkt_payload_len =
@@ -121,7 +120,7 @@ exit:
 }
 
 static void nci_rf_disc_map_rsp_packet(struct nci_dev *ndev,
-					struct sk_buff *skb)
+				       struct sk_buff *skb)
 {
 	__u8 status = skb->data[0];
 
@@ -143,7 +142,7 @@ static void nci_rf_disc_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 }
 
 static void nci_rf_disc_select_rsp_packet(struct nci_dev *ndev,
-						struct sk_buff *skb)
+					  struct sk_buff *skb)
 {
 	__u8 status = skb->data[0];
 
@@ -155,7 +154,7 @@ static void nci_rf_disc_select_rsp_packet(struct nci_dev *ndev,
 }
 
 static void nci_rf_deactivate_rsp_packet(struct nci_dev *ndev,
-					struct sk_buff *skb)
+					 struct sk_buff *skb)
 {
 	__u8 status = skb->data[0];
 
@@ -163,7 +162,7 @@ static void nci_rf_deactivate_rsp_packet(struct nci_dev *ndev,
 
 	/* If target was active, complete the request only in deactivate_ntf */
 	if ((status != NCI_STATUS_OK) ||
-		(atomic_read(&ndev->state) != NCI_POLL_ACTIVE)) {
+	    (atomic_read(&ndev->state) != NCI_POLL_ACTIVE)) {
 		nci_clear_target_list(ndev);
 		atomic_set(&ndev->state, NCI_IDLE);
 		nci_req_complete(ndev, status);
-- 
1.7.7.3

