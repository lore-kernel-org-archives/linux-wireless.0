Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20650 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab1GVFmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:42:54 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 10/31] ath6kl: Merge scatter gather setup functions for two method
Date: Fri, 22 Jul 2011 08:41:43 +0300
Message-ID: <1311313324-6766-12-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074302_931375_1297CB16)
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
 drivers/net/wireless/ath/ath6kl/hif.h     |    1 +
 drivers/net/wireless/ath/ath6kl/htc_hif.c |   77 ++---------------------------
 drivers/net/wireless/ath/ath6kl/htc_hif.h |    1 -
 drivers/net/wireless/ath/ath6kl/sdio.c    |   75 ++++++++++++++++++++++------
 4 files changed, 63 insertions(+), 91 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 73340f2..6e0ec4a 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -185,6 +185,7 @@ struct hif_scatter_req {
 struct hif_dev_scat_sup_info {
 	int max_scat_entries;
 	int max_xfer_szper_scatreq;
+	bool virt_scat;
 };
 
 struct ath6kl_hif_ops {
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.c b/drivers/net/wireless/ath/ath6kl/htc_hif.c
index 40853cb..33887cc 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.c
@@ -273,7 +273,7 @@ int ath6kldev_submit_scat_req(struct ath6kl_device *dev,
 		   scat_req->addr, !read ? "async" : "sync",
 		   (read) ? "rd" : "wr");
 
-	if (!read && dev->virt_scat)
+	if (!read && dev->hif_scat_info.virt_scat)
 		status = ath6kldev_cp_scat_dma_buf(scat_req, false);
 
 	if (status) {
@@ -285,7 +285,7 @@ int ath6kldev_submit_scat_req(struct ath6kl_device *dev,
 		return status;
 	}
 
-	if (dev->virt_scat)
+	if (dev->hif_scat_info.virt_scat)
 		status =  ath6kldev_rw_scatter(dev->ar, scat_req);
 	else
 		status = ath6kl_hif_scat_req_rw(dev->ar, scat_req);
@@ -293,7 +293,7 @@ int ath6kldev_submit_scat_req(struct ath6kl_device *dev,
 	if (read) {
 		/* in sync mode, we can touch the scatter request */
 		scat_req->status = status;
-		if (!status && dev->virt_scat)
+		if (!status && dev->hif_scat_info.virt_scat)
 			scat_req->status =
 				ath6kldev_cp_scat_dma_buf(scat_req, true);
 	}
@@ -301,78 +301,9 @@ int ath6kldev_submit_scat_req(struct ath6kl_device *dev,
 	return status;
 }
 
-/*
- * function to set up virtual scatter support if HIF
- * layer has not implemented the interface.
- */
-static int ath6kldev_setup_virt_scat_sup(struct ath6kl_device *dev)
-{
-	struct hif_scatter_req *scat_req;
-	int buf_sz, scat_req_sz, scat_list_sz;
-	int i, status = 0;
-	u8 *virt_dma_buf;
-
-	buf_sz = 2 * L1_CACHE_BYTES + ATH6KL_MAX_TRANSFER_SIZE_PER_SCATTER;
-
-	scat_list_sz = (ATH6KL_SCATTER_ENTRIES_PER_REQ - 1) *
-		       sizeof(struct hif_scatter_item);
-	scat_req_sz = sizeof(*scat_req) + scat_list_sz;
-
-	for (i = 0; i < ATH6KL_SCATTER_REQS; i++) {
-		scat_req = kzalloc(scat_req_sz, GFP_KERNEL);
-
-		if (!scat_req) {
-			status = -ENOMEM;
-			break;
-		}
-
-		virt_dma_buf = kzalloc(buf_sz, GFP_KERNEL);
-		if (!virt_dma_buf) {
-			kfree(scat_req);
-			status = -ENOMEM;
-			break;
-		}
-
-		scat_req->virt_dma_buf =
-			(u8 *)L1_CACHE_ALIGN((unsigned long)virt_dma_buf);
-
-		/* we emulate a DMA bounce interface */
-		hif_scatter_req_add(dev->ar, scat_req);
-	}
-
-	if (status)
-		ath6kl_hif_cleanup_scatter(dev->ar);
-	else {
-		dev->hif_scat_info.max_scat_entries =
-			ATH6KL_SCATTER_ENTRIES_PER_REQ;
-		dev->hif_scat_info.max_xfer_szper_scatreq =
-			ATH6KL_MAX_TRANSFER_SIZE_PER_SCATTER;
-		dev->virt_scat = true;
-	}
-
-	return status;
-}
-
 int ath6kldev_setup_msg_bndl(struct ath6kl_device *dev, int max_msg_per_trans)
 {
-	int status;
-
-	status = ath6kl_hif_enable_scatter(dev->ar, &dev->hif_scat_info);
-
-	if (status) {
-		ath6kl_warn("hif does not support scatter requests (%d)\n",
-			    status);
-
-		/* we can try to use a virtual DMA scatter mechanism */
-		status = ath6kldev_setup_virt_scat_sup(dev);
-	}
-
-	if (!status)
-		ath6kl_dbg(ATH6KL_DBG_ANY, "max scatter items:%d: maxlen:%d\n",
-			   dev->hif_scat_info.max_scat_entries,
-			   dev->hif_scat_info.max_xfer_szper_scatreq);
-
-	return status;
+	return ath6kl_hif_enable_scatter(dev->ar, &dev->hif_scat_info);
 }
 
 static int ath6kldev_proc_counter_intr(struct ath6kl_device *dev)
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.h b/drivers/net/wireless/ath/ath6kl/htc_hif.h
index d770d4e..3514c22 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.h
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.h
@@ -87,7 +87,6 @@ struct ath6kl_device {
 	int (*msg_pending) (struct htc_target *target, u32 lk_ahds[],
 			    int *npkts_fetched);
 	struct hif_dev_scat_sup_info hif_scat_info;
-	bool virt_scat;
 	int max_rx_bndl_sz;
 	int max_tx_bndl_sz;
 	int chk_irq_status_cnt;
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 9220a01..96a112e 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -275,13 +275,17 @@ static int ath6kl_sdio_alloc_prep_scat_req(struct ath6kl_sdio *ar_sdio,
 {
 	struct hif_scatter_req *s_req;
 	struct bus_request *bus_req;
-	int i, scat_req_sz, scat_list_sz, sg_sz = 0;
+	int i, scat_req_sz, scat_list_sz, sg_sz, buf_sz;
+	u8 *virt_buf;
 
 	scat_list_sz = (n_scat_entry - 1) * sizeof(struct hif_scatter_item);
 	scat_req_sz = sizeof(*s_req) + scat_list_sz;
 
 	if (!virt_scat)
 		sg_sz = sizeof(struct scatterlist) * n_scat_entry;
+	else
+		buf_sz =  2 * L1_CACHE_BYTES +
+			  ATH6KL_MAX_TRANSFER_SIZE_PER_SCATTER;
 
 	for (i = 0; i < n_scat_req; i++) {
 		/* allocate the scatter request */
@@ -289,7 +293,16 @@ static int ath6kl_sdio_alloc_prep_scat_req(struct ath6kl_sdio *ar_sdio,
 		if (!s_req)
 			return -ENOMEM;
 
-		if (sg_sz) {
+		if (virt_scat) {
+			virt_buf = kzalloc(buf_sz, GFP_KERNEL);
+			if (!virt_buf) {
+				kfree(s_req);
+				return -ENOMEM;
+			}
+
+			s_req->virt_dma_buf =
+				(u8 *)L1_CACHE_ALIGN((unsigned long)virt_buf);
+		} else {
 			/* allocate sglist */
 			s_req->sgentries = kzalloc(sg_sz, GFP_KERNEL);
 
@@ -303,6 +316,7 @@ static int ath6kl_sdio_alloc_prep_scat_req(struct ath6kl_sdio *ar_sdio,
 		bus_req = ath6kl_sdio_alloc_busreq(ar_sdio);
 		if (!bus_req) {
 			kfree(s_req->sgentries);
+			kfree(s_req->virt_dma_buf);
 			kfree(s_req);
 			return -ENOMEM;
 		}
@@ -629,31 +643,58 @@ static int ath6kl_sdio_enable_scatter(struct ath6kl *ar,
 				      struct hif_dev_scat_sup_info *pinfo)
 {
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
-	int ret = 0;
+	int ret;
+	bool virt_scat = false;
 
 	/* check if host supports scatter and it meets our requirements */
 	if (ar_sdio->func->card->host->max_segs < MAX_SCATTER_ENTRIES_PER_REQ) {
-		ath6kl_err("hif-scatter: host only supports scatter of : %d entries, need: %d\n",
+		ath6kl_err("host only supports scatter of :%d entries, need: %d\n",
 			   ar_sdio->func->card->host->max_segs,
 			   MAX_SCATTER_ENTRIES_PER_REQ);
-		return -EINVAL;
+		virt_scat = true;
+	}
+
+	if (!virt_scat) {
+		ret = ath6kl_sdio_alloc_prep_scat_req(ar_sdio,
+				MAX_SCATTER_ENTRIES_PER_REQ,
+				MAX_SCATTER_REQUESTS, virt_scat);
+
+		if (!ret) {
+			ath6kl_dbg(ATH6KL_DBG_ANY,
+				   "hif-scatter enabled: max scatter req : %d entries: %d\n",
+				   MAX_SCATTER_REQUESTS,
+				   MAX_SCATTER_ENTRIES_PER_REQ);
+
+			pinfo->max_scat_entries = MAX_SCATTER_ENTRIES_PER_REQ;
+			pinfo->max_xfer_szper_scatreq =
+						MAX_SCATTER_REQ_TRANSFER_SIZE;
+		} else {
+			ath6kl_sdio_cleanup_scatter(ar);
+			ath6kl_warn("hif scatter resource setup failed, trying virtual scatter method\n");
+		}
 	}
 
-	ath6kl_dbg(ATH6KL_DBG_ANY,
-		   "hif-scatter enabled: max scatter req : %d entries: %d\n",
-		   MAX_SCATTER_REQUESTS, MAX_SCATTER_ENTRIES_PER_REQ);
+	if (virt_scat || ret) {
+		ret = ath6kl_sdio_alloc_prep_scat_req(ar_sdio,
+				ATH6KL_SCATTER_ENTRIES_PER_REQ,
+				ATH6KL_SCATTER_REQS, virt_scat);
 
-	ret = ath6kl_sdio_alloc_prep_scat_req(ar_sdio,
-					      MAX_SCATTER_ENTRIES_PER_REQ,
-					      MAX_SCATTER_REQUESTS, 0);
-	if (ret) {
-		ath6kl_err("hif-scatter: failed to alloc scatter resources !\n");
-		ath6kl_sdio_cleanup_scatter(ar);
-		return ret;
+		if (ret) {
+			ath6kl_err("failed to alloc virtual scatter resources !\n");
+			ath6kl_sdio_cleanup_scatter(ar);
+			return ret;
+		}
+
+		ath6kl_dbg(ATH6KL_DBG_ANY,
+			   "Vitual scatter enabled, max_scat_req:%d, entries:%d\n",
+			   ATH6KL_SCATTER_REQS, ATH6KL_SCATTER_ENTRIES_PER_REQ);
+
+		pinfo->max_scat_entries = ATH6KL_SCATTER_ENTRIES_PER_REQ;
+		pinfo->max_xfer_szper_scatreq =
+					ATH6KL_MAX_TRANSFER_SIZE_PER_SCATTER;
 	}
 
-	pinfo->max_scat_entries = MAX_SCATTER_ENTRIES_PER_REQ;
-	pinfo->max_xfer_szper_scatreq = MAX_SCATTER_REQ_TRANSFER_SIZE;
+	pinfo->virt_scat = virt_scat;
 
 	return 0;
 }
-- 
1.7.1

