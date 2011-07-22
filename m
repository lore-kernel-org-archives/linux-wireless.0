Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54611 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab1GVFnT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:19 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 19/31] ath6kl: Move scatter information from ath6kl_device to htc_target
Date: Fri, 22 Jul 2011 08:41:52 +0300
Message-ID: <1311313324-6766-21-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074326_430673_C192842B)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif-ops.h |    5 ++---
 drivers/net/wireless/ath/ath6kl/hif.h     |    8 +-------
 drivers/net/wireless/ath/ath6kl/htc.c     |   13 ++++---------
 drivers/net/wireless/ath/ath6kl/htc.h     |    3 +++
 drivers/net/wireless/ath/ath6kl/htc_hif.h |    1 -
 drivers/net/wireless/ath/ath6kl/sdio.c    |   12 ++++++------
 6 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif-ops.h b/drivers/net/wireless/ath/ath6kl/hif-ops.h
index 32890cd..c923979 100644
--- a/drivers/net/wireless/ath/ath6kl/hif-ops.h
+++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
@@ -53,10 +53,9 @@ static inline void hif_scatter_req_add(struct ath6kl *ar,
 	return ar->hif_ops->scatter_req_add(ar, s_req);
 }
 
-static inline int ath6kl_hif_enable_scatter(struct ath6kl *ar,
-					    struct hif_dev_scat_sup_info *info)
+static inline int ath6kl_hif_enable_scatter(struct ath6kl *ar)
 {
-	return ar->hif_ops->enable_scatter(ar, info);
+	return ar->hif_ops->enable_scatter(ar);
 }
 
 static inline int ath6kl_hif_scat_req_rw(struct ath6kl *ar,
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index abb1095..dcbecc9 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -184,11 +184,6 @@ struct hif_scatter_req {
 	struct hif_scatter_item scat_list[1];
 };
 
-struct hif_dev_scat_sup_info {
-	int max_scat_entries;
-	int max_xfer_szper_scatreq;
-};
-
 struct ath6kl_hif_ops {
 	int (*read_write_sync)(struct ath6kl *ar, u32 addr, u8 *buf,
 			       u32 len, u32 request);
@@ -201,8 +196,7 @@ struct ath6kl_hif_ops {
 	struct hif_scatter_req *(*scatter_req_get)(struct ath6kl *ar);
 	void (*scatter_req_add)(struct ath6kl *ar,
 				struct hif_scatter_req *s_req);
-	int (*enable_scatter)(struct ath6kl *ar,
-			      struct hif_dev_scat_sup_info *info);
+	int (*enable_scatter)(struct ath6kl *ar);
 	int (*scat_req_rw) (struct ath6kl *ar,
 			    struct hif_scatter_req *scat_req);
 	void (*cleanup_scatter)(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index ce5c082..ea87a19 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -432,11 +432,8 @@ static void htc_issue_send_bundle(struct htc_endpoint *endpoint,
 {
 	struct htc_target *target = endpoint->target;
 	struct hif_scatter_req *scat_req = NULL;
-	struct hif_dev_scat_sup_info hif_info;
 	int n_scat, n_sent_bundle = 0, tot_pkts_bundle = 0;
 
-	hif_info = target->dev->hif_scat_info;
-
 	while (true) {
 		n_scat = get_queue_depth(queue);
 		n_scat = min(n_scat, target->msg_per_bndl_max);
@@ -2168,19 +2165,17 @@ int htc_get_rxbuf_num(struct htc_target *target, enum htc_endpoint_id endpoint)
 
 static void htc_setup_msg_bndl(struct htc_target *target)
 {
-	struct hif_dev_scat_sup_info *scat_info = &target->dev->hif_scat_info;
-
 	/* limit what HTC can handle */
 	target->msg_per_bndl_max = min(HTC_HOST_MAX_MSG_PER_BUNDLE,
 				       target->msg_per_bndl_max);
 
-	if (ath6kl_hif_enable_scatter(target->dev->ar, scat_info)) {
+	if (ath6kl_hif_enable_scatter(target->dev->ar)) {
 		target->msg_per_bndl_max = 0;
 		return;
 	}
 
 	/* limit bundle what the device layer can handle */
-	target->msg_per_bndl_max = min(scat_info->max_scat_entries,
+	target->msg_per_bndl_max = min(target->max_scat_entries,
 				       target->msg_per_bndl_max);
 
 	ath6kl_dbg(ATH6KL_DBG_TRC,
@@ -2188,10 +2183,10 @@ static void htc_setup_msg_bndl(struct htc_target *target)
 		   target->msg_per_bndl_max);
 
 	/* Max rx bundle size is limited by the max tx bundle size */
-	target->max_rx_bndl_sz = scat_info->max_xfer_szper_scatreq;
+	target->max_rx_bndl_sz = target->max_xfer_szper_scatreq;
 	/* Max tx bundle size if limited by the extended mbox address range */
 	target->max_tx_bndl_sz = min(HIF_MBOX0_EXT_WIDTH,
-				     scat_info->max_xfer_szper_scatreq);
+				     target->max_xfer_szper_scatreq);
 
 	ath6kl_dbg(ATH6KL_DBG_ANY, "max recv: %d max send: %d\n",
 		   target->max_rx_bndl_sz, target->max_tx_bndl_sz);
diff --git a/drivers/net/wireless/ath/ath6kl/htc.h b/drivers/net/wireless/ath/ath6kl/htc.h
index 26e6b93..bf9c725 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.h
+++ b/drivers/net/wireless/ath/ath6kl/htc.h
@@ -533,6 +533,9 @@ struct htc_target {
 
 	u32 block_sz;
 	u32 block_mask;
+
+	int max_scat_entries;
+	int max_xfer_szper_scatreq;
 };
 
 void *htc_create(struct ath6kl *ar);
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.h b/drivers/net/wireless/ath/ath6kl/htc_hif.h
index cf5bee0..47f086c 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.h
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.h
@@ -80,7 +80,6 @@ struct ath6kl_device {
 	struct ath6kl_irq_enable_reg irq_en_reg;
 	u8 pad3[A_CACHE_LINE_PAD];
 	struct htc_target *htc_cnxt;
-	struct hif_dev_scat_sup_info hif_scat_info;
 	int chk_irq_status_cnt;
 	struct ath6kl *ar;
 };
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 44ac68e..3417160 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -663,10 +663,10 @@ static void ath6kl_sdio_cleanup_scatter(struct ath6kl *ar)
 }
 
 /* setup of HIF scatter resources */
-static int ath6kl_sdio_enable_scatter(struct ath6kl *ar,
-				      struct hif_dev_scat_sup_info *pinfo)
+static int ath6kl_sdio_enable_scatter(struct ath6kl *ar)
 {
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
+	struct htc_target *target = ar->htc_target;
 	int ret;
 	bool virt_scat = false;
 
@@ -689,8 +689,8 @@ static int ath6kl_sdio_enable_scatter(struct ath6kl *ar,
 				   MAX_SCATTER_REQUESTS,
 				   MAX_SCATTER_ENTRIES_PER_REQ);
 
-			pinfo->max_scat_entries = MAX_SCATTER_ENTRIES_PER_REQ;
-			pinfo->max_xfer_szper_scatreq =
+			target->max_scat_entries = MAX_SCATTER_ENTRIES_PER_REQ;
+			target->max_xfer_szper_scatreq =
 						MAX_SCATTER_REQ_TRANSFER_SIZE;
 		} else {
 			ath6kl_sdio_cleanup_scatter(ar);
@@ -713,8 +713,8 @@ static int ath6kl_sdio_enable_scatter(struct ath6kl *ar,
 			   "Vitual scatter enabled, max_scat_req:%d, entries:%d\n",
 			   ATH6KL_SCATTER_REQS, ATH6KL_SCATTER_ENTRIES_PER_REQ);
 
-		pinfo->max_scat_entries = ATH6KL_SCATTER_ENTRIES_PER_REQ;
-		pinfo->max_xfer_szper_scatreq =
+		target->max_scat_entries = ATH6KL_SCATTER_ENTRIES_PER_REQ;
+		target->max_xfer_szper_scatreq =
 					ATH6KL_MAX_TRANSFER_SIZE_PER_SCATTER;
 	}
 
-- 
1.7.1

