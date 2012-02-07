Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4745 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab2BGJdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 04:33:42 -0500
From: Chilam Ng <chilamng@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: prioritize Tx bundling based on AC priorities
Date: Tue, 7 Feb 2012 01:33:00 -0800
Message-ID: <1328607180-551-1-git-send-email-chilamng@qca.qualcomm.com> (sfid-20120207_103420_095257_B89CFAD5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tx bundling is the more efficient use of SDIO bus and allows more packet
transfers with fewer bus transactions, and is a way to improve overall
throughput. However, Tx bundling has only 4 scatter request resources available.
When there are multiple traffic streams of different priorities, it's possible
that lower priority traffic may hog all the scatter requests and lock out the
higher prioirty traffic from bundling.
Tx bundling is now enabled per AC. When an AC do a scatter request and
the remaining scatter request resources is lower than a configurable
threshold, it will disable Tx bundling for all AC's of lower priorities.
When an AC has Tx bundling disabled and has no Tx bundles sent in a
consecutive and configurable number of packets, Tx bundling will be re-enabled
for that AC.

Signed-off-by: Chilam Ng <chilamng@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif.h  |    2 +
 drivers/net/wireless/ath/ath6kl/htc.c  |   77 +++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath6kl/htc.h  |    7 +++-
 drivers/net/wireless/ath/ath6kl/sdio.c |    2 +
 4 files changed, 80 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 699a036..0674b1d 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -197,6 +197,8 @@ struct hif_scatter_req {
 	u8 *virt_dma_buf;
 
 	struct hif_scatter_item scat_list[1];
+
+	u32 scat_q_depth;
 };
 
 struct ath6kl_irq_proc_registers {
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 2d72190..75d7a21 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -22,6 +22,9 @@
 
 #define CALC_TXRX_PADDED_LEN(dev, len)  (__ALIGN_MASK((len), (dev)->block_mask))
 
+/* threshold to re-enable Tx bundling for an AC*/
+#define TX_RESUME_BUNDLE_THRESHOLD	1500
+
 /* Functions for Tx credit handling */
 static void ath6kl_credit_deposit(struct ath6kl_htc_credit_info *cred_info,
 				  struct htc_endpoint_credit_dist *ep_dist,
@@ -744,6 +747,12 @@ static void ath6kl_htc_tx_bundle(struct htc_endpoint *endpoint,
 	struct hif_scatter_req *scat_req = NULL;
 	int n_scat, n_sent_bundle = 0, tot_pkts_bundle = 0;
 	int status;
+	u32 txb_mask;
+	u8 ac = WMM_NUM_AC;
+
+	if ((HTC_CTRL_RSVD_SVC != endpoint->svc_id) ||
+		(WMI_CONTROL_SVC != endpoint->svc_id))
+		ac = target->dev->ar->ep2ac_map[endpoint->eid];
 
 	while (true) {
 		status = 0;
@@ -763,6 +772,31 @@ static void ath6kl_htc_tx_bundle(struct htc_endpoint *endpoint,
 			break;
 		}
 
+		if ((ac < WMM_NUM_AC) && (ac != WMM_AC_BK)) {
+			if (WMM_AC_BE == ac)
+				/*
+				 * BE, BK have priorities and bit
+				 * positions reversed
+				 */
+				txb_mask = (1 << WMM_AC_BK);
+			else
+				/*
+				 * any AC with priority lower than
+				 * itself
+				 */
+				txb_mask = ((1 << ac) - 1);
+		/*
+		 * when the scatter request resources drop below a
+		 * certain threshold, disable Tx bundling for all
+		 * AC's with priority lower than the current requesting
+		 * AC. Otherwise re-enable Tx bundling for them
+		 */
+		if (scat_req->scat_q_depth < ATH6KL_SCATTER_REQS)
+			target->tx_bndl_mask &= ~txb_mask;
+		else
+			target->tx_bndl_mask |= txb_mask;
+		}
+
 		ath6kl_dbg(ATH6KL_DBG_HTC, "htc tx pkts to scatter: %d\n",
 			   n_scat);
 
@@ -806,6 +840,7 @@ static void ath6kl_htc_tx_from_queue(struct htc_target *target,
 	struct htc_packet *packet;
 	int bundle_sent;
 	int n_pkts_bundle;
+	u8 ac = WMM_NUM_AC;
 
 	spin_lock_bh(&target->tx_lock);
 
@@ -823,6 +858,10 @@ static void ath6kl_htc_tx_from_queue(struct htc_target *target,
 	 */
 	INIT_LIST_HEAD(&txq);
 
+	if ((HTC_CTRL_RSVD_SVC != endpoint->svc_id) ||
+		(WMI_CONTROL_SVC != endpoint->svc_id))
+		ac = target->dev->ar->ep2ac_map[endpoint->eid];
+
 	while (true) {
 
 		if (list_empty(&endpoint->txq))
@@ -840,15 +879,18 @@ static void ath6kl_htc_tx_from_queue(struct htc_target *target,
 
 		while (true) {
 			/* try to send a bundle on each pass */
-			if ((target->tx_bndl_enable) &&
+			if ((target->tx_bndl_mask) &&
 			    (get_queue_depth(&txq) >=
 			    HTC_MIN_HTC_MSGS_TO_BUNDLE)) {
 				int temp1 = 0, temp2 = 0;
 
-				ath6kl_htc_tx_bundle(endpoint, &txq,
-						     &temp1, &temp2);
-				bundle_sent += temp1;
-				n_pkts_bundle += temp2;
+				/* check if bundling is enabled for an AC */
+				if (target->tx_bndl_mask & (1 << ac)) {
+					ath6kl_htc_tx_bundle(endpoint, &txq,
+							     &temp1, &temp2);
+					bundle_sent += temp1;
+					n_pkts_bundle += temp2;
+				}
 			}
 
 			if (list_empty(&txq))
@@ -867,6 +909,26 @@ static void ath6kl_htc_tx_from_queue(struct htc_target *target,
 
 		endpoint->ep_st.tx_bundles += bundle_sent;
 		endpoint->ep_st.tx_pkt_bundled += n_pkts_bundle;
+
+		/*
+		 * if an AC has bundling disabled and no tx bundling
+		 * has occured continously for a certain number of TX,
+		 * enable tx bundling for this AC
+		 */
+		if (!bundle_sent) {
+			if (!(target->tx_bndl_mask & (1 << ac)) &&
+				(ac < WMM_NUM_AC)) {
+				if (++target->ac_tx_count[ac] >=
+					TX_RESUME_BUNDLE_THRESHOLD) {
+					target->ac_tx_count[ac] = 0;
+					target->tx_bndl_mask |= (1 << ac);
+				}
+			}
+		} else {
+			/* tx bundling will reset the counter */
+			if (ac < WMM_NUM_AC)
+				target->ac_tx_count[ac] = 0;
+		}
 	}
 
 	endpoint->tx_proc_cnt = 0;
@@ -2517,7 +2579,8 @@ static void htc_setup_msg_bndl(struct htc_target *target)
 		   target->max_rx_bndl_sz, target->max_tx_bndl_sz);
 
 	if (target->max_tx_bndl_sz)
-		target->tx_bndl_enable = true;
+		/* tx_bndl_mask is enabled per AC, each has 1 bit */
+		target->tx_bndl_mask = (1 << WMM_NUM_AC) - 1;
 
 	if (target->max_rx_bndl_sz)
 		target->rx_bndl_enable = true;
@@ -2532,7 +2595,7 @@ static void htc_setup_msg_bndl(struct htc_target *target)
 		 * padding will spill into the next credit buffer
 		 * which is fatal.
 		 */
-		target->tx_bndl_enable = false;
+		target->tx_bndl_mask = 0;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 57672e1..b85716e 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -87,6 +87,8 @@
 #define WMI_DATA_VO_SVC   MAKE_SERVICE_ID(WMI_SERVICE_GROUP, 4)
 #define WMI_MAX_SERVICES  5
 
+#define WMM_NUM_AC  4
+
 /* reserved and used to flush ALL packets */
 #define HTC_TX_PACKET_TAG_ALL          0
 #define HTC_SERVICE_TX_PACKET_TAG      1
@@ -531,7 +533,7 @@ struct htc_target {
 	/* max messages per bundle for HTC */
 	int msg_per_bndl_max;
 
-	bool tx_bndl_enable;
+	u32 tx_bndl_mask;
 	int rx_bndl_enable;
 	int max_rx_bndl_sz;
 	int max_tx_bndl_sz;
@@ -543,6 +545,9 @@ struct htc_target {
 	int max_xfer_szper_scatreq;
 
 	int chk_irq_status_cnt;
+
+	/* counts the number of Tx without bundling continously per AC */
+	u32 ac_tx_count[WMM_NUM_AC];
 };
 
 void *ath6kl_htc_create(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 7bb6107..9f84486 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -601,6 +601,8 @@ static struct hif_scatter_req *ath6kl_sdio_scatter_req_get(struct ath6kl *ar)
 		node = list_first_entry(&ar_sdio->scat_req,
 					struct hif_scatter_req, list);
 		list_del(&node->list);
+
+		node->scat_q_depth = get_queue_depth(&ar_sdio->scat_req);
 	}
 
 	spin_unlock_bh(&ar_sdio->scat_lock);
-- 
1.7.7.2

