Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24908 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211Ab1GVFmf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:42:35 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 03/31] ath6kl: Remove struct hif_scatter_req_priv
Date: Fri, 22 Jul 2011 08:41:36 +0300
Message-ID: <1311313324-6766-5-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074240_180743_68214DAA)
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
 drivers/net/wireless/ath/ath6kl/hif.h  |    8 +-----
 drivers/net/wireless/ath/ath6kl/sdio.c |   33 +++++++++++++++----------------
 2 files changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 4c7a7d3..a5cdc71 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -175,7 +175,8 @@ struct hif_scatter_req {
 	struct htc_endpoint *ep;
 	int scat_entries;
 
-	struct hif_scatter_req_priv *req_priv;
+	struct bus_request *busrequest;
+	struct scatterlist *sgentries;
 
 	/* bounce buffer for upper layers to copy to/from */
 	u8 *virt_dma_buf;
@@ -188,11 +189,6 @@ struct hif_dev_scat_sup_info {
 	int max_xfer_szper_scatreq;
 };
 
-struct hif_scatter_req_priv {
-	struct bus_request *busrequest;
-	struct scatterlist sgentries[MAX_SCATTER_ENTRIES_PER_REQ];
-};
-
 struct ath6kl_hif_ops {
 	int (*read_write_sync)(struct ath6kl *ar, u32 addr, u8 *buf,
 			       u32 len, u32 request);
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 559c3a7..da60738 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -163,7 +163,6 @@ static void ath6kl_sdio_free_bus_req(struct ath6kl_sdio *ar_sdio,
 }
 
 static void ath6kl_sdio_setup_scat_data(struct hif_scatter_req *scat_req,
-					struct hif_scatter_req_priv *s_req_priv,
 					struct mmc_data *data)
 {
 	struct scatterlist *sg;
@@ -182,7 +181,7 @@ static void ath6kl_sdio_setup_scat_data(struct hif_scatter_req *scat_req,
 						    MMC_DATA_READ;
 
 	/* fill SG entries */
-	sg = s_req_priv->sgentries;
+	sg = scat_req->sgentries;
 	sg_init_table(sg, scat_req->scat_entries);
 
 	/* assemble SG list */
@@ -206,7 +205,7 @@ static void ath6kl_sdio_setup_scat_data(struct hif_scatter_req *scat_req,
 	}
 
 	/* set scatter-gather table for request */
-	data->sg = s_req_priv->sgentries;
+	data->sg = scat_req->sgentries;
 	data->sg_len = scat_req->scat_entries;
 }
 
@@ -226,7 +225,7 @@ static int ath6kl_sdio_scat_rw(struct ath6kl_sdio *ar_sdio,
 	memset(&cmd, 0, sizeof(struct mmc_command));
 	memset(&data, 0, sizeof(struct mmc_data));
 
-	ath6kl_sdio_setup_scat_data(scat_req, scat_req->req_priv, &data);
+	ath6kl_sdio_setup_scat_data(scat_req, &data);
 
 	opcode = (scat_req->req & HIF_FIXED_ADDRESS) ?
 		  CMD53_ARG_FIXED_ADDRESS : CMD53_ARG_INCR_ADDRESS;
@@ -282,11 +281,10 @@ static void ath6kl_sdio_cleanup_scat_resource(struct ath6kl_sdio *ar_sdio)
 		list_del(&s_req->list);
 		spin_unlock_irqrestore(&ar_sdio->scat_lock, flag);
 
-		if (s_req->req_priv && s_req->req_priv->busrequest)
-			ath6kl_sdio_free_bus_req(ar_sdio,
-						 s_req->req_priv->busrequest);
+		if (s_req->busrequest)
+			ath6kl_sdio_free_bus_req(ar_sdio, s_req->busrequest);
 		kfree(s_req->virt_dma_buf);
-		kfree(s_req->req_priv);
+		kfree(s_req->sgentries);
 		kfree(s_req);
 
 		spin_lock_irqsave(&ar_sdio->scat_lock, flag);
@@ -300,7 +298,7 @@ static int ath6kl_sdio_setup_scat_resource(struct ath6kl_sdio *ar_sdio,
 {
 	struct hif_scatter_req *s_req;
 	struct bus_request *bus_req;
-	int i, scat_req_sz, scat_list_sz;
+	int i, scat_req_sz, scat_list_sz, sg_sz;
 
 	/* check if host supports scatter and it meets our requirements */
 	if (ar_sdio->func->card->host->max_segs < MAX_SCATTER_ENTRIES_PER_REQ) {
@@ -318,16 +316,18 @@ static int ath6kl_sdio_setup_scat_resource(struct ath6kl_sdio *ar_sdio,
 		       sizeof(struct hif_scatter_item);
 	scat_req_sz = sizeof(*s_req) + scat_list_sz;
 
+	sg_sz = sizeof(struct scatterlist) * MAX_SCATTER_ENTRIES_PER_REQ;
+
 	for (i = 0; i < MAX_SCATTER_REQUESTS; i++) {
 		/* allocate the scatter request */
 		s_req = kzalloc(scat_req_sz, GFP_KERNEL);
 		if (!s_req)
 			goto fail_setup_scat;
 
-		/* allocate the private request blob */
-		s_req->req_priv = kzalloc(sizeof(*s_req->req_priv), GFP_KERNEL);
+		/* allocate sglist */
+		s_req->sgentries = kzalloc(sg_sz, GFP_KERNEL);
 
-		if (!s_req->req_priv) {
+		if (!s_req->sgentries) {
 			kfree(s_req);
 			goto fail_setup_scat;
 		}
@@ -335,14 +335,14 @@ static int ath6kl_sdio_setup_scat_resource(struct ath6kl_sdio *ar_sdio,
 		/* allocate a bus request for this scatter request */
 		bus_req = ath6kl_sdio_alloc_busreq(ar_sdio);
 		if (!bus_req) {
-			kfree(s_req->req_priv);
+			kfree(s_req->sgentries);
 			kfree(s_req);
 			goto fail_setup_scat;
 		}
 
 		/* assign the scatter request to this bus request */
 		bus_req->scat_req = s_req;
-		s_req->req_priv->busrequest = bus_req;
+		s_req->busrequest = bus_req;
 		/* add it to the scatter pool */
 		hif_scatter_req_add(ar_sdio->ar, s_req);
 	}
@@ -627,7 +627,6 @@ static int ath6kl_sdio_async_rw_scatter(struct ath6kl *ar,
 					struct hif_scatter_req *scat_req)
 {
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
-	struct hif_scatter_req_priv *req_priv = scat_req->req_priv;
 	u32 request = scat_req->req;
 	int status = 0;
 	unsigned long flags;
@@ -641,11 +640,11 @@ static int ath6kl_sdio_async_rw_scatter(struct ath6kl *ar,
 
 	if (request & HIF_SYNCHRONOUS) {
 		sdio_claim_host(ar_sdio->func);
-		status = ath6kl_sdio_scat_rw(ar_sdio, req_priv->busrequest);
+		status = ath6kl_sdio_scat_rw(ar_sdio, scat_req->busrequest);
 		sdio_release_host(ar_sdio->func);
 	} else {
 		spin_lock_irqsave(&ar_sdio->wr_async_lock, flags);
-		list_add_tail(&req_priv->busrequest->list, &ar_sdio->wr_asyncq);
+		list_add_tail(&scat_req->busrequest->list, &ar_sdio->wr_asyncq);
 		spin_unlock_irqrestore(&ar_sdio->wr_async_lock, flags);
 		queue_work(ar->ath6kl_wq, &ar_sdio->wr_async_work);
 	}
-- 
1.7.1

