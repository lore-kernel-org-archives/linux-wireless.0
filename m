Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20650 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab1GVFmv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:42:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 09/31] ath6kl: Move down scatter enable and cleanup functions
Date: Fri, 22 Jul 2011 08:41:42 +0300
Message-ID: <1311313324-6766-11-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074256_784060_3DB8F5FB)
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
 drivers/net/wireless/ath/ath6kl/sdio.c |  116 ++++++++++++++++----------------
 1 files changed, 58 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 797a39f..9220a01 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -318,64 +318,6 @@ static int ath6kl_sdio_alloc_prep_scat_req(struct ath6kl_sdio *ar_sdio,
 	return 0;
 }
 
-/* clean up scatter support */
-static void ath6kl_sdio_cleanup_scatter(struct ath6kl *ar)
-{
-	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
-	struct hif_scatter_req *s_req, *tmp_req;
-	unsigned long flag;
-
-	/* empty the free list */
-	spin_lock_irqsave(&ar_sdio->scat_lock, flag);
-	list_for_each_entry_safe(s_req, tmp_req, &ar_sdio->scat_req, list) {
-		list_del(&s_req->list);
-		spin_unlock_irqrestore(&ar_sdio->scat_lock, flag);
-
-		if (s_req->busrequest)
-			ath6kl_sdio_free_bus_req(ar_sdio, s_req->busrequest);
-		kfree(s_req->virt_dma_buf);
-		kfree(s_req->sgentries);
-		kfree(s_req);
-
-		spin_lock_irqsave(&ar_sdio->scat_lock, flag);
-	}
-	spin_unlock_irqrestore(&ar_sdio->scat_lock, flag);
-}
-
-/* setup of HIF scatter resources */
-static int ath6kl_sdio_enable_scatter(struct ath6kl *ar,
-				      struct hif_dev_scat_sup_info *pinfo)
-{
-	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
-	int ret = 0;
-
-	/* check if host supports scatter and it meets our requirements */
-	if (ar_sdio->func->card->host->max_segs < MAX_SCATTER_ENTRIES_PER_REQ) {
-		ath6kl_err("hif-scatter: host only supports scatter of : %d entries, need: %d\n",
-			   ar_sdio->func->card->host->max_segs,
-			   MAX_SCATTER_ENTRIES_PER_REQ);
-		return -EINVAL;
-	}
-
-	ath6kl_dbg(ATH6KL_DBG_ANY,
-		   "hif-scatter enabled: max scatter req : %d entries: %d\n",
-		   MAX_SCATTER_REQUESTS, MAX_SCATTER_ENTRIES_PER_REQ);
-
-	ret = ath6kl_sdio_alloc_prep_scat_req(ar_sdio,
-					      MAX_SCATTER_ENTRIES_PER_REQ,
-					      MAX_SCATTER_REQUESTS, 0);
-	if (ret) {
-		ath6kl_err("hif-scatter: failed to alloc scatter resources !\n");
-		ath6kl_sdio_cleanup_scatter(ar);
-		return ret;
-	}
-
-	pinfo->max_scat_entries = MAX_SCATTER_ENTRIES_PER_REQ;
-	pinfo->max_xfer_szper_scatreq = MAX_SCATTER_REQ_TRANSFER_SIZE;
-
-	return 0;
-}
-
 static int ath6kl_sdio_read_write_sync(struct ath6kl *ar, u32 addr, u8 *buf,
 				       u32 len, u32 request)
 {
@@ -658,6 +600,64 @@ static int ath6kl_sdio_async_rw_scatter(struct ath6kl *ar,
 	return status;
 }
 
+/* clean up scatter support */
+static void ath6kl_sdio_cleanup_scatter(struct ath6kl *ar)
+{
+	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
+	struct hif_scatter_req *s_req, *tmp_req;
+	unsigned long flag;
+
+	/* empty the free list */
+	spin_lock_irqsave(&ar_sdio->scat_lock, flag);
+	list_for_each_entry_safe(s_req, tmp_req, &ar_sdio->scat_req, list) {
+		list_del(&s_req->list);
+		spin_unlock_irqrestore(&ar_sdio->scat_lock, flag);
+
+		if (s_req->busrequest)
+			ath6kl_sdio_free_bus_req(ar_sdio, s_req->busrequest);
+		kfree(s_req->virt_dma_buf);
+		kfree(s_req->sgentries);
+		kfree(s_req);
+
+		spin_lock_irqsave(&ar_sdio->scat_lock, flag);
+	}
+	spin_unlock_irqrestore(&ar_sdio->scat_lock, flag);
+}
+
+/* setup of HIF scatter resources */
+static int ath6kl_sdio_enable_scatter(struct ath6kl *ar,
+				      struct hif_dev_scat_sup_info *pinfo)
+{
+	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
+	int ret = 0;
+
+	/* check if host supports scatter and it meets our requirements */
+	if (ar_sdio->func->card->host->max_segs < MAX_SCATTER_ENTRIES_PER_REQ) {
+		ath6kl_err("hif-scatter: host only supports scatter of : %d entries, need: %d\n",
+			   ar_sdio->func->card->host->max_segs,
+			   MAX_SCATTER_ENTRIES_PER_REQ);
+		return -EINVAL;
+	}
+
+	ath6kl_dbg(ATH6KL_DBG_ANY,
+		   "hif-scatter enabled: max scatter req : %d entries: %d\n",
+		   MAX_SCATTER_REQUESTS, MAX_SCATTER_ENTRIES_PER_REQ);
+
+	ret = ath6kl_sdio_alloc_prep_scat_req(ar_sdio,
+					      MAX_SCATTER_ENTRIES_PER_REQ,
+					      MAX_SCATTER_REQUESTS, 0);
+	if (ret) {
+		ath6kl_err("hif-scatter: failed to alloc scatter resources !\n");
+		ath6kl_sdio_cleanup_scatter(ar);
+		return ret;
+	}
+
+	pinfo->max_scat_entries = MAX_SCATTER_ENTRIES_PER_REQ;
+	pinfo->max_xfer_szper_scatreq = MAX_SCATTER_REQ_TRANSFER_SIZE;
+
+	return 0;
+}
+
 static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.read_write_sync = ath6kl_sdio_read_write_sync,
 	.write_async = ath6kl_sdio_write_async,
-- 
1.7.1

