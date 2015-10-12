Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42418 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbbJLM6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 08:58:54 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 5/7] ath10k: Configure copy engine 5 for HTT messages
Date: Mon, 12 Oct 2015 18:27:04 +0530
Message-ID: <1444654626-3290-6-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151012_145858_556631_050492DC)
In-Reply-To: <1444654626-3290-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1444654626-3290-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently target to host (T2H) HTT messages are received at copy engine 1.
These messages are processed by HTC layer in both host and target.
To avoid HTC level processing overhead in both host and target,
the unused copy engine 5 is being used for receiving HTT T2H messages.
This will speedup the receive data processing as well as htt tx completion.
Hence host and target copy engine configuration tables are updated
to enable CE5 pipe. The in-direction HTT mapping is now pointing to CE5
for all HTT T2H.

Moreover HTT send completion messages are polled from HTC handler
as CE 4 is not interrupt-driven. For faster tx completion, CE4 polling
needs to be done whenever CE pipe which transports HTT Rx (target->host)
is processed. This avoids overhead of polling HTT messages from HTC
layer. Servicing CE 4 faster is helping to solve "failed to transmit
packet, dropping: -105".

Reviewed-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
v2:
 * fix invalid dma memory access (ATH10K_SKB_RXCB is used instead of
   ATH10K_SKB_CB in htt_tx_cb)
 * Process CE 4 send completion first before processing rx

 drivers/net/wireless/ath/ath10k/pci.c | 70 +++++++++++++++++++++++++++++------
 1 file changed, 59 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index efeb766..447c4c6 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -106,6 +106,8 @@ static int ath10k_pci_bmi_wait(struct ath10k_ce_pipe *tx_pipe,
 static int ath10k_pci_qca99x0_chip_reset(struct ath10k *ar);
 static void ath10k_pci_htc_tx_cb(struct ath10k_ce_pipe *ce_state);
 static void ath10k_pci_htc_rx_cb(struct ath10k_ce_pipe *ce_state);
+static void ath10k_pci_htt_tx_cb(struct ath10k_ce_pipe *ce_state);
+static void ath10k_pci_htt_rx_cb(struct ath10k_ce_pipe *ce_state);
 
 static const struct ce_attr host_ce_config_wlan[] = {
 	/* CE0: host->target HTC control and raw streams */
@@ -150,15 +152,16 @@ static const struct ce_attr host_ce_config_wlan[] = {
 		.src_nentries = CE_HTT_H2T_MSG_SRC_NENTRIES,
 		.src_sz_max = 256,
 		.dest_nentries = 0,
-		.send_cb = ath10k_pci_htc_tx_cb,
+		.send_cb = ath10k_pci_htt_tx_cb,
 	},
 
-	/* CE5: unused */
+	/* CE5: target->host HTT (HIF->HTT) */
 	{
 		.flags = CE_ATTR_FLAGS,
 		.src_nentries = 0,
-		.src_sz_max = 0,
-		.dest_nentries = 0,
+		.src_sz_max = 512,
+		.dest_nentries = 512,
+		.recv_cb = ath10k_pci_htt_rx_cb,
 	},
 
 	/* CE6: target autonomous hif_memcpy */
@@ -264,12 +267,12 @@ static const struct ce_pipe_config target_ce_config_wlan[] = {
 
 	/* NB: 50% of src nentries, since tx has 2 frags */
 
-	/* CE5: unused */
+	/* CE5: target->host HTT (HIF->HTT) */
 	{
 		.pipenum = __cpu_to_le32(5),
-		.pipedir = __cpu_to_le32(PIPEDIR_OUT),
+		.pipedir = __cpu_to_le32(PIPEDIR_IN),
 		.nentries = __cpu_to_le32(32),
-		.nbytes_max = __cpu_to_le32(2048),
+		.nbytes_max = __cpu_to_le32(512),
 		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
 		.reserved = __cpu_to_le32(0),
 	},
@@ -403,7 +406,7 @@ static const struct service_to_pipe target_service_to_ce_map_wlan[] = {
 	{
 		__cpu_to_le32(ATH10K_HTC_SVC_ID_HTT_DATA_MSG),
 		__cpu_to_le32(PIPEDIR_IN),	/* in = DL = target -> host */
-		__cpu_to_le32(1),
+		__cpu_to_le32(5),
 	},
 
 	/* (Additions here) */
@@ -1174,8 +1177,9 @@ static void ath10k_pci_htc_tx_cb(struct ath10k_ce_pipe *ce_state)
 		ath10k_htc_tx_completion_handler(ar, skb);
 }
 
-/* Called by lower (CE) layer when data is received from the Target. */
-static void ath10k_pci_htc_rx_cb(struct ath10k_ce_pipe *ce_state)
+static void ath10k_pci_process_rx_cb(struct ath10k_ce_pipe *ce_state,
+				     void (*callback)(struct ath10k *ar,
+						      struct sk_buff *skb))
 {
 	struct ath10k *ar = ce_state->ar;
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -1214,12 +1218,56 @@ static void ath10k_pci_htc_rx_cb(struct ath10k_ce_pipe *ce_state)
 		ath10k_dbg_dump(ar, ATH10K_DBG_PCI_DUMP, NULL, "pci rx: ",
 				skb->data, skb->len);
 
-		ath10k_htc_rx_completion_handler(ar, skb);
+		callback(ar, skb);
 	}
 
 	ath10k_pci_rx_post_pipe(pipe_info);
 }
 
+/* Called by lower (CE) layer when data is received from the Target. */
+static void ath10k_pci_htc_rx_cb(struct ath10k_ce_pipe *ce_state)
+{
+	ath10k_pci_process_rx_cb(ce_state, ath10k_htc_rx_completion_handler);
+}
+
+/* Called by lower (CE) layer when a send to HTT Target completes. */
+static void ath10k_pci_htt_tx_cb(struct ath10k_ce_pipe *ce_state)
+{
+	struct ath10k *ar = ce_state->ar;
+	struct sk_buff *skb;
+	u32 ce_data;
+	unsigned int nbytes;
+	unsigned int transfer_id;
+
+	while (ath10k_ce_completed_send_next(ce_state, (void **)&skb, &ce_data,
+					     &nbytes, &transfer_id) == 0) {
+		/* no need to call tx completion for NULL pointers */
+		if (!skb)
+			continue;
+
+		dma_unmap_single(ar->dev, ATH10K_SKB_CB(skb)->paddr,
+				 skb->len, DMA_TO_DEVICE);
+		ath10k_htt_hif_tx_complete(ar, skb);
+	}
+}
+
+static void ath10k_pci_htt_rx_deliver(struct ath10k *ar, struct sk_buff *skb)
+{
+	skb_pull(skb, sizeof(struct ath10k_htc_hdr));
+	ath10k_htt_t2h_msg_handler(ar, skb);
+}
+
+/* Called by lower (CE) layer when HTT data is received from the Target. */
+static void ath10k_pci_htt_rx_cb(struct ath10k_ce_pipe *ce_state)
+{
+	/* CE4 polling needs to be done whenever CE pipe which transports
+	 * HTT Rx (target->host) is processed.
+	 */
+	ath10k_ce_per_engine_service(ce_state->ar, 4);
+
+	ath10k_pci_process_rx_cb(ce_state, ath10k_pci_htt_rx_deliver);
+}
+
 static int ath10k_pci_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
 				struct ath10k_hif_sg_item *items, int n_items)
 {
-- 
2.6.0

