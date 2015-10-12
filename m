Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:2667 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbbJLM7X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 08:59:23 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH v2 7/7] ath10k: remove htc polling for tx completion
Date: Mon, 12 Oct 2015 18:27:06 +0530
Message-ID: <1444654626-3290-8-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20151012_145925_737219_18F04B6C)
In-Reply-To: <1444654626-3290-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1444654626-3290-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since polling for tx completion is handled whenever target to host
messages are received, removing the unnecessary polling mechanism for
send completion at HTC level.

Reviewed-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/hif.h |  9 +++------
 drivers/net/wireless/ath/ath10k/htc.c | 26 +-------------------------
 drivers/net/wireless/ath/ath10k/htc.h |  1 -
 drivers/net/wireless/ath/ath10k/pci.c | 14 +++-----------
 4 files changed, 7 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hif.h b/drivers/net/wireless/ath/ath10k/hif.h
index 633594c..89e7076 100644
--- a/drivers/net/wireless/ath/ath10k/hif.h
+++ b/drivers/net/wireless/ath/ath10k/hif.h
@@ -58,8 +58,7 @@ struct ath10k_hif_ops {
 	void (*stop)(struct ath10k *ar);
 
 	int (*map_service_to_pipe)(struct ath10k *ar, u16 service_id,
-				   u8 *ul_pipe, u8 *dl_pipe,
-				   int *ul_is_polled);
+				   u8 *ul_pipe, u8 *dl_pipe);
 
 	void (*get_default_pipe)(struct ath10k *ar, u8 *ul_pipe, u8 *dl_pipe);
 
@@ -132,12 +131,10 @@ static inline void ath10k_hif_stop(struct ath10k *ar)
 
 static inline int ath10k_hif_map_service_to_pipe(struct ath10k *ar,
 						 u16 service_id,
-						 u8 *ul_pipe, u8 *dl_pipe,
-						 int *ul_is_polled)
+						 u8 *ul_pipe, u8 *dl_pipe)
 {
 	return ar->hif.ops->map_service_to_pipe(ar, service_id,
-						ul_pipe, dl_pipe,
-						ul_is_polled);
+						ul_pipe, dl_pipe);
 }
 
 static inline void ath10k_hif_get_default_pipe(struct ath10k *ar,
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 20e0c48..5b3c6bc 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -23,16 +23,6 @@
 /* Send */
 /********/
 
-static inline void ath10k_htc_send_complete_check(struct ath10k_htc_ep *ep,
-						  int force)
-{
-	/*
-	 * Check whether HIF has any prior sends that have finished,
-	 * have not had the post-processing done.
-	 */
-	ath10k_hif_send_complete_check(ep->htc->ar, ep->ul_pipe_id, force);
-}
-
 static void ath10k_htc_control_tx_complete(struct ath10k *ar,
 					   struct sk_buff *skb)
 {
@@ -328,15 +318,6 @@ void ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 
 	ep = &htc->endpoint[eid];
 
-	/*
-	 * If this endpoint that received a message from the target has
-	 * a to-target HIF pipe whose send completions are polled rather
-	 * than interrupt-driven, this is a good point to ask HIF to check
-	 * whether it has any completed sends to handle.
-	 */
-	if (ep->ul_is_polled)
-		ath10k_htc_send_complete_check(ep, 1);
-
 	payload_len = __le16_to_cpu(hdr->len);
 
 	if (payload_len + sizeof(*hdr) > ATH10K_HTC_MAX_LEN) {
@@ -758,8 +739,7 @@ setup:
 	status = ath10k_hif_map_service_to_pipe(htc->ar,
 						ep->service_id,
 						&ep->ul_pipe_id,
-						&ep->dl_pipe_id,
-						&ep->ul_is_polled);
+						&ep->dl_pipe_id);
 	if (status)
 		return status;
 
@@ -768,10 +748,6 @@ setup:
 		   htc_service_name(ep->service_id), ep->ul_pipe_id,
 		   ep->dl_pipe_id, ep->eid);
 
-	ath10k_dbg(ar, ATH10K_DBG_BOOT,
-		   "boot htc ep %d ul polled %d\n",
-		   ep->eid, ep->ul_is_polled);
-
 	if (disable_credit_flow_ctrl && ep->tx_credit_flow_enabled) {
 		ep->tx_credit_flow_enabled = false;
 		ath10k_dbg(ar, ATH10K_DBG_BOOT,
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index 2ddd41e..e70aa38 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -312,7 +312,6 @@ struct ath10k_htc_ep {
 	int max_ep_message_len;
 	u8 ul_pipe_id;
 	u8 dl_pipe_id;
-	int ul_is_polled; /* call HIF to get tx completions */
 
 	u8 seq_no; /* for debugging */
 	int tx_credits;
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index a2b384b..77da58a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -1451,9 +1451,8 @@ static void ath10k_pci_kill_tasklet(struct ath10k *ar)
 	del_timer_sync(&ar_pci->rx_post_retry);
 }
 
-static int ath10k_pci_hif_map_service_to_pipe(struct ath10k *ar,
-					      u16 service_id, u8 *ul_pipe,
-					      u8 *dl_pipe, int *ul_is_polled)
+static int ath10k_pci_hif_map_service_to_pipe(struct ath10k *ar, u16 service_id,
+					      u8 *ul_pipe, u8 *dl_pipe)
 {
 	const struct service_to_pipe *entry;
 	bool ul_set = false, dl_set = false;
@@ -1494,24 +1493,17 @@ static int ath10k_pci_hif_map_service_to_pipe(struct ath10k *ar,
 	if (WARN_ON(!ul_set || !dl_set))
 		return -ENOENT;
 
-	*ul_is_polled =
-		(host_ce_config_wlan[*ul_pipe].flags & CE_ATTR_DIS_INTR) != 0;
-
 	return 0;
 }
 
 static void ath10k_pci_hif_get_default_pipe(struct ath10k *ar,
 					    u8 *ul_pipe, u8 *dl_pipe)
 {
-	int ul_is_polled;
-
 	ath10k_dbg(ar, ATH10K_DBG_PCI, "pci hif get default pipe\n");
 
 	(void)ath10k_pci_hif_map_service_to_pipe(ar,
 						 ATH10K_HTC_SVC_ID_RSVD_CTRL,
-						 ul_pipe,
-						 dl_pipe,
-						 &ul_is_polled);
+						 ul_pipe, dl_pipe);
 }
 
 static void ath10k_pci_irq_msi_fw_mask(struct ath10k *ar)
-- 
2.6.0

