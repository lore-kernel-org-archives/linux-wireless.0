Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28001 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbbJLM6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 08:58:06 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 2/7] ath10k: register per copy engine send completion callbacks
Date: Mon, 12 Oct 2015 18:27:01 +0530
Message-ID: <1444654626-3290-3-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151012_145809_982983_4FE01AC8)
In-Reply-To: <1444654626-3290-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1444654626-3290-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Register send completion callbacks for every copy engines (CE) separately
instead of having common completion handler. Since some of the copy
engines delivers different type of messages, per-CE callbacks help to
service them differently.

Reviewed-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
v2: register send_cb only for tx pipes

 drivers/net/wireless/ath/ath10k/ce.c  |  3 +--
 drivers/net/wireless/ath/ath10k/ce.h  |  3 ++-
 drivers/net/wireless/ath/ath10k/hif.h |  2 --
 drivers/net/wireless/ath/ath10k/htc.c |  7 ++-----
 drivers/net/wireless/ath/ath10k/htc.h |  2 +-
 drivers/net/wireless/ath/ath10k/pci.c | 13 +++++++------
 6 files changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index 8d7ab1c..ae85be8 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1077,7 +1077,6 @@ void ath10k_ce_deinit_pipe(struct ath10k *ar, unsigned int ce_id)
 
 int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
 			 const struct ce_attr *attr,
-			 void (*send_cb)(struct ath10k_ce_pipe *),
 			 void (*recv_cb)(struct ath10k_ce_pipe *))
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -1104,7 +1103,7 @@ int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
 	ce_state->src_sz_max = attr->src_sz_max;
 
 	if (attr->src_nentries)
-		ce_state->send_cb = send_cb;
+		ce_state->send_cb = attr->send_cb;
 
 	if (attr->dest_nentries)
 		ce_state->recv_cb = recv_cb;
diff --git a/drivers/net/wireless/ath/ath10k/ce.h b/drivers/net/wireless/ath/ath10k/ce.h
index 5c903e15..3829e33 100644
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -210,7 +210,6 @@ int ath10k_ce_init_pipe(struct ath10k *ar, unsigned int ce_id,
 void ath10k_ce_deinit_pipe(struct ath10k *ar, unsigned int ce_id);
 int ath10k_ce_alloc_pipe(struct ath10k *ar, int ce_id,
 			 const struct ce_attr *attr,
-			 void (*send_cb)(struct ath10k_ce_pipe *),
 			 void (*recv_cb)(struct ath10k_ce_pipe *));
 void ath10k_ce_free_pipe(struct ath10k *ar, int ce_id);
 
@@ -277,6 +276,8 @@ struct ce_attr {
 
 	/* #entries in destination ring - Must be a power of 2 */
 	unsigned int dest_nentries;
+
+	void (*send_cb)(struct ath10k_ce_pipe *);
 };
 
 #define SR_BA_ADDRESS		0x0000
diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 0c92e02..3808920 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -31,8 +31,6 @@ struct ath10k_hif_sg_item {
 };
 
 struct ath10k_hif_cb {
-	int (*tx_completion)(struct ath10k *ar,
-			     struct sk_buff *wbuf);
 	int (*rx_completion)(struct ath10k *ar,
 			     struct sk_buff *wbuf);
 };
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 97c24b2..89c0e40 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -181,22 +181,20 @@ err_pull:
 	return ret;
 }
 
-int ath10k_htc_tx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
+void ath10k_htc_tx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_htc *htc = &ar->htc;
 	struct ath10k_skb_cb *skb_cb;
 	struct ath10k_htc_ep *ep;
 
 	if (WARN_ON_ONCE(!skb))
-		return 0;
+		return;
 
 	skb_cb = ATH10K_SKB_CB(skb);
 	ep = &htc->endpoint[skb_cb->eid];
 
 	ath10k_htc_notify_tx_completion(ep, skb);
 	/* the skb now belongs to the completion handler */
-
-	return 0;
 }
 EXPORT_SYMBOL(ath10k_htc_tx_completion_handler);
 
@@ -851,7 +849,6 @@ int ath10k_htc_init(struct ath10k *ar)
 
 	/* setup HIF layer callbacks */
 	htc_callbacks.rx_completion = ath10k_htc_rx_completion_handler;
-	htc_callbacks.tx_completion = ath10k_htc_tx_completion_handler;
 	htc->ar = ar;
 
 	/* Get HIF default pipe for HTC message exchange */
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index d1fc8e7..77b669e 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -355,7 +355,7 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 int ath10k_htc_send(struct ath10k_htc *htc, enum ath10k_htc_ep_id eid,
 		    struct sk_buff *packet);
 struct sk_buff *ath10k_htc_alloc_skb(struct ath10k *ar, int size);
-int ath10k_htc_tx_completion_handler(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_htc_tx_completion_handler(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb);
 
 #endif
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index a41d66e..11f4dcb 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -104,6 +104,7 @@ static int ath10k_pci_bmi_wait(struct ath10k_ce_pipe *tx_pipe,
 			       struct ath10k_ce_pipe *rx_pipe,
 			       struct bmi_xfer *xfer);
 static int ath10k_pci_qca99x0_chip_reset(struct ath10k *ar);
+static void ath10k_pci_htc_tx_cb(struct ath10k_ce_pipe *ce_state);
 
 static const struct ce_attr host_ce_config_wlan[] = {
 	/* CE0: host->target HTC control and raw streams */
@@ -112,6 +113,7 @@ static const struct ce_attr host_ce_config_wlan[] = {
 		.src_nentries = 16,
 		.src_sz_max = 256,
 		.dest_nentries = 0,
+		.send_cb = ath10k_pci_htc_tx_cb,
 	},
 
 	/* CE1: target->host HTT + HTC control */
@@ -136,6 +138,7 @@ static const struct ce_attr host_ce_config_wlan[] = {
 		.src_nentries = 32,
 		.src_sz_max = 2048,
 		.dest_nentries = 0,
+		.send_cb = ath10k_pci_htc_tx_cb,
 	},
 
 	/* CE4: host->target HTT */
@@ -144,6 +147,7 @@ static const struct ce_attr host_ce_config_wlan[] = {
 		.src_nentries = CE_HTT_H2T_MSG_SRC_NENTRIES,
 		.src_sz_max = 256,
 		.dest_nentries = 0,
+		.send_cb = ath10k_pci_htc_tx_cb,
 	},
 
 	/* CE5: unused */
@@ -1144,11 +1148,9 @@ static int ath10k_pci_diag_write32(struct ath10k *ar, u32 address, u32 value)
 }
 
 /* Called by lower (CE) layer when a send to Target completes. */
-static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state)
+static void ath10k_pci_htc_tx_cb(struct ath10k_ce_pipe *ce_state)
 {
 	struct ath10k *ar = ce_state->ar;
-	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
-	struct ath10k_hif_cb *cb = &ar_pci->msg_callbacks_current;
 	struct sk_buff_head list;
 	struct sk_buff *skb;
 	u32 ce_data;
@@ -1166,7 +1168,7 @@ static void ath10k_pci_ce_send_done(struct ath10k_ce_pipe *ce_state)
 	}
 
 	while ((skb = __skb_dequeue(&list)))
-		cb->tx_completion(ar, skb);
+		ath10k_htc_tx_completion_handler(ar, skb);
 }
 
 /* Called by lower (CE) layer when data is received from the Target. */
@@ -1622,7 +1624,7 @@ static void ath10k_pci_tx_pipe_cleanup(struct ath10k_pci_pipe *pci_pipe)
 
 		ce_ring->per_transfer_context[i] = NULL;
 
-		ar_pci->msg_callbacks_current.tx_completion(ar, skb);
+		ath10k_htc_tx_completion_handler(ar, skb);
 	}
 }
 
@@ -2043,7 +2045,6 @@ static int ath10k_pci_alloc_pipes(struct ath10k *ar)
 		pipe->hif_ce_state = ar;
 
 		ret = ath10k_ce_alloc_pipe(ar, i, &host_ce_config_wlan[i],
-					   ath10k_pci_ce_send_done,
 					   ath10k_pci_ce_recv_data);
 		if (ret) {
 			ath10k_err(ar, "failed to allocate copy engine pipe %d: %d\n",
-- 
2.6.0

