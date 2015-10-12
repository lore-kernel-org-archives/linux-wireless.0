Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:26467 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbbJLM6Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 08:58:24 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 3/7] ath10k: register per copy engine receive callbacks
Date: Mon, 12 Oct 2015 18:27:02 +0530
Message-ID: <1444654626-3290-4-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151012_145827_143567_C3415D18)
In-Reply-To: <1444654626-3290-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1444654626-3290-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Register receive callbacks for every copy engines (CE) separately
instead of having common receive handler. Some of the copy engines
receives different type of messages (i.e HTT/HTC/pktlog) from target.
Hence to service them accordingly, register per copy engine receive
callbacks.

Reviewed-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
v2: register recv_cb only for rx pipes

 drivers/net/wireless/ath/ath10k/ce.c  |  5 ++---
 drivers/net/wireless/ath/ath10k/ce.h  |  4 ++--
 drivers/net/wireless/ath/ath10k/hif.h | 14 --------------
 drivers/net/wireless/ath/ath10k/htc.c | 13 +------------
 drivers/net/wireless/ath/ath10k/htc.h |  2 +-
 drivers/net/wireless/ath/ath10k/pci.c | 23 ++++++-----------------
 drivers/net/wireless/ath/ath10k/pci.h |  2 --
 7 files changed, 12 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index ae85be8..84220c3 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1076,8 +1076,7 @@ void ath10k_ce_deinit_pipe(struct ath10k *ar, unsigned int ce_id)
 }
 
 int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
-			 const struct ce_attr *attr,
-			 void (*recv_cb)(struct ath10k_ce_pipe *))
+			 const struct ce_attr *attr)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_ce_pipe *ce_state = &ar_pci->ce_states[ce_id];
@@ -1106,7 +1105,7 @@ int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
 		ce_state->send_cb = attr->send_cb;
 
 	if (attr->dest_nentries)
-		ce_state->recv_cb = recv_cb;
+		ce_state->recv_cb = attr->recv_cb;
 
 	if (attr->src_nentries) {
 		ce_state->src_ring = ath10k_ce_alloc_src_ring(ar, ce_id, attr);
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 3829e33..dbb94fd 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -209,8 +209,7 @@ int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
 			const struct ce_attr *attr);
 void ath10k_ce_deinit_pipe(struct ath10k *ar, unsigned int ce_id);
 int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
-			 const struct ce_attr *attr,
-			 void (*recv_cb)(struct ath10k_ce_pipe *));
+			 const struct ce_attr *attr);
 void ath10k_ce_free_pipe(struct ath10k *ar, int ce_id);
 
 /*==================CE Engine Shutdown=======================*/
@@ -278,6 +277,7 @@ struct ce_attr {
 	unsigned int dest_nentries;
 
 	void (*send_cb)(struct ath10k_ce_pipe *);
+	void (*recv_cb)(struct ath10k_ce_pipe *);
 };
 
 #define SR_BA_ADDRESS		0x0000
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 3808920..6e826bb 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -30,11 +30,6 @@ struct ath10k_hif_sg_item {
 	u16 len;
 };
 
-struct ath10k_hif_cb {
-	int (*rx_completion)(struct ath10k *ar,
-			     struct sk_buff *wbuf);
-};
-
 struct ath10k_hif_ops {
 	/* send a scatter-gather list to the target */
 	int (*tx_sg)(struct ath10k *ar, u8 pipe_id,
@@ -78,9 +73,6 @@ struct ath10k_hif_ops {
 	 */
 	void (*send_complete_check)(struct ath10k *ar, u8 pipe_id, int force);
 
-	void (*set_callbacks)(struct ath10k *ar,
-			      struct ath10k_hif_cb *callbacks);
-
 	u16 (*get_free_queue_number)(struct ath10k *ar, u8 pipe_id);
 
 	u32 (*read32)(struct ath10k *ar, u32 address);
@@ -161,12 +153,6 @@ static inline void ath10k_hif_send_complete_check(struct ath10k *ar,
 	ar->hif.ops->send_complete_check(ar, pipe_id, force);
 }
 
-static inline void ath10k_hif_set_callbacks(struct ath10k *ar,
-					    struct ath10k_hif_cb *callbacks)
-{
-	ar->hif.ops->set_callbacks(ar, callbacks);
-}
-
 static inline u16 ath10k_hif_get_free_queue_number(struct ath10k *ar,
 						   u8 pipe_id)
 {
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 89c0e40..13d0119 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -302,7 +302,7 @@ static int ath10k_htc_process_trailer(struct ath10k_htc *htc,
 	return status;
 }
 
-int ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
+void ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 {
 	int status = 0;
 	struct ath10k_htc *htc = &ar->htc;
@@ -323,7 +323,6 @@ int ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_warn(ar, "HTC Rx: invalid eid %d\n", eid);
 		ath10k_dbg_dump(ar, ATH10K_DBG_HTC, "htc bad header", "",
 				hdr, sizeof(*hdr));
-		status = -EINVAL;
 		goto out;
 	}
 
@@ -345,7 +344,6 @@ int ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 			    payload_len + sizeof(*hdr));
 		ath10k_dbg_dump(ar, ATH10K_DBG_HTC, "htc bad rx pkt len", "",
 				hdr, sizeof(*hdr));
-		status = -EINVAL;
 		goto out;
 	}
 
@@ -355,7 +353,6 @@ int ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 			   skb->len, payload_len);
 		ath10k_dbg_dump(ar, ATH10K_DBG_HTC, "htc bad rx pkt len",
 				"", hdr, sizeof(*hdr));
-		status = -EINVAL;
 		goto out;
 	}
 
@@ -371,7 +368,6 @@ int ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 		    (trailer_len > payload_len)) {
 			ath10k_warn(ar, "Invalid trailer length: %d\n",
 				    trailer_len);
-			status = -EPROTO;
 			goto out;
 		}
 
@@ -404,7 +400,6 @@ int ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 				 * sending unsolicited messages on the ep 0
 				 */
 				ath10k_warn(ar, "HTC rx ctrl still processing\n");
-				status = -EINVAL;
 				complete(&htc->ctl_resp);
 				goto out;
 			}
@@ -436,8 +431,6 @@ int ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 	skb = NULL;
 out:
 	kfree_skb(skb);
-
-	return status;
 }
 EXPORT_SYMBOL(ath10k_htc_rx_completion_handler);
 
@@ -839,7 +832,6 @@ int ath10k_htc_start(struct ath10k_htc *htc)
 /* registered target arrival callback from the HIF layer */
 int ath10k_htc_init(struct ath10k *ar)
 {
-	struct ath10k_hif_cb htc_callbacks;
 	struct ath10k_htc_ep *ep = NULL;
 	struct ath10k_htc *htc = &ar->htc;
 
@@ -847,14 +839,11 @@ int ath10k_htc_init(struct ath10k *ar)
 
 	ath10k_htc_reset_endpoint_states(htc);
 
-	/* setup HIF layer callbacks */
-	htc_callbacks.rx_completion = ath10k_htc_rx_completion_handler;
 	htc->ar = ar;
 
 	/* Get HIF default pipe for HTC message exchange */
 	ep = &htc->endpoint[ATH10K_HTC_EP_0];
 
-	ath10k_hif_set_callbacks(ar, &htc_callbacks);
 	ath10k_hif_get_default_pipe(ar, &ep->ul_pipe_id, &ep->dl_pipe_id);
 
 	init_completion(&htc->ctl_resp);
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index 77b669e..aed3708 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -356,6 +356,6 @@ int ath10k_htc_send(struct ath10k_htc *htc, enum ath10k_htc_ep_id eid,
 		    struct sk_buff *packet);
 struct sk_buff *ath10k_htc_alloc_skb(struct ath10k *ar, int size);
 void ath10k_htc_tx_completion_handler(struct ath10k *ar, struct sk_buff *skb);
-int ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 11f4dcb..efeb766 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -105,6 +105,7 @@ static int ath10k_pci_bmi_wait(struct ath10k_ce_pipe *tx_pipe,
 			       struct bmi_xfer *xfer);
 static int ath10k_pci_qca99x0_chip_reset(struct ath10k *ar);
 static void ath10k_pci_htc_tx_cb(struct ath10k_ce_pipe *ce_state);
+static void ath10k_pci_htc_rx_cb(struct ath10k_ce_pipe *ce_state);
 
 static const struct ce_attr host_ce_config_wlan[] = {
 	/* CE0: host->target HTC control and raw streams */
@@ -122,6 +123,7 @@ static const struct ce_attr host_ce_config_wlan[] = {
 		.src_nentries = 0,
 		.src_sz_max = 2048,
 		.dest_nentries = 512,
+		.recv_cb = ath10k_pci_htc_rx_cb,
 	},
 
 	/* CE2: target->host WMI */
@@ -130,6 +132,7 @@ static const struct ce_attr host_ce_config_wlan[] = {
 		.src_nentries = 0,
 		.src_sz_max = 2048,
 		.dest_nentries = 128,
+		.recv_cb = ath10k_pci_htc_rx_cb,
 	},
 
 	/* CE3: host->target WMI */
@@ -1172,12 +1175,11 @@ static void ath10k_pci_htc_tx_cb(struct ath10k_ce_pipe *ce_state)
 }
 
 /* Called by lower (CE) layer when data is received from the Target. */
-static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
+static void ath10k_pci_htc_rx_cb(struct ath10k_ce_pipe *ce_state)
 {
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	struct ath10k_pci_pipe *pipe_info =  &ar_pci->pipe_info[ce_state->id];
-	struct ath10k_hif_cb *cb = &ar_pci->msg_callbacks_current;
 	struct sk_buff *skb;
 	struct sk_buff_head list;
 	void *transfer_context;
@@ -1212,7 +1214,7 @@ static void ath10k_pci_ce_recv_data(struct ath10k_ce_pipe *ce_state)
 		ath10k_dbg_dump(ar, ATH10K_DBG_PCI_DUMP, NULL, "pci rx: ",
 				skb->data, skb->len);
 
-		cb->rx_completion(ar, skb);
+		ath10k_htc_rx_completion_handler(ar, skb);
 	}
 
 	ath10k_pci_rx_post_pipe(pipe_info);
@@ -1387,17 +1389,6 @@ static void ath10k_pci_hif_send_complete_check(struct ath10k *ar, u8 pipe,
 	ath10k_ce_per_engine_service(ar, pipe);
 }
 
-static void ath10k_pci_hif_set_callbacks(struct ath10k *ar,
-					 struct ath10k_hif_cb *callbacks)
-{
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-
-	ath10k_dbg(ar, ATH10K_DBG_PCI, "pci hif set callbacks\n");
-
-	memcpy(&ar_pci->msg_callbacks_current, callbacks,
-	       sizeof(ar_pci->msg_callbacks_current));
-}
-
 static void ath10k_pci_kill_tasklet(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -2044,8 +2035,7 @@ static int ath10k_pci_alloc_pipes(struct ath10k *ar)
 		pipe->pipe_num = i;
 		pipe->hif_ce_state = ar;
 
-		ret = ath10k_ce_alloc_pipe(ar, i, &host_ce_config_wlan[i],
-					   ath10k_pci_ce_recv_data);
+		ret = ath10k_ce_alloc_pipe(ar, i, &host_ce_config_wlan[i]);
 		if (ret) {
 			ath10k_err(ar, "failed to allocate copy engine pipe %d: %d\n",
 				   i, ret);
@@ -2474,7 +2464,6 @@ static const struct ath10k_hif_ops ath10k_pci_hif_ops = {
 	.map_service_to_pipe	= ath10k_pci_hif_map_service_to_pipe,
 	.get_default_pipe	= ath10k_pci_hif_get_default_pipe,
 	.send_complete_check	= ath10k_pci_hif_send_complete_check,
-	.set_callbacks		= ath10k_pci_hif_set_callbacks,
 	.get_free_queue_number	= ath10k_pci_hif_get_free_queue_number,
 	.power_up		= ath10k_pci_hif_power_up,
 	.power_down		= ath10k_pci_hif_power_down,
diff --git a/drivers/net/wireless/ath/ath10k/pci.h b/drivers/net/wireless/ath/ath10k/pci.h
index b97a2b7..f91bf33 100644
--- a/drivers/net/wireless/ath/ath10k/pci.h
+++ b/drivers/net/wireless/ath/ath10k/pci.h
@@ -175,8 +175,6 @@ struct ath10k_pci {
 
 	struct ath10k_pci_pipe pipe_info[CE_COUNT_MAX];
 
-	struct ath10k_hif_cb msg_callbacks_current;
-
 	/* Copy Engine used for Diagnostic Accesses */
 	struct ath10k_ce_pipe *ce_diag;
 
-- 
2.6.0

