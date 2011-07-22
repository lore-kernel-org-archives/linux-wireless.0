Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37985 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab1GVFmc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:42:32 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 02/31] ath6kl: Move ath6kl_sdio_async_rw_scatter() down to other hif_ops functions
Date: Fri, 22 Jul 2011 08:41:35 +0300
Message-ID: <1311313324-6766-4-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074238_559920_26086116)
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
 drivers/net/wireless/ath/ath6kl/sdio.c |   63 ++++++++++++++++----------------
 1 files changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index d217f1c..559c3a7 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -270,38 +270,6 @@ static int ath6kl_sdio_scat_rw(struct ath6kl_sdio *ar_sdio,
 	return status;
 }
 
-
-/* scatter gather read write request */
-static int ath6kl_sdio_async_rw_scatter(struct ath6kl *ar,
-				 struct hif_scatter_req *scat_req)
-{
-	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
-	struct hif_scatter_req_priv *req_priv = scat_req->req_priv;
-	u32 request = scat_req->req;
-	int status = 0;
-	unsigned long flags;
-
-	if (!scat_req->len)
-		return -EINVAL;
-
-	ath6kl_dbg(ATH6KL_DBG_SCATTER,
-		"hif-scatter: total len: %d scatter entries: %d\n",
-		scat_req->len, scat_req->scat_entries);
-
-	if (request & HIF_SYNCHRONOUS) {
-		sdio_claim_host(ar_sdio->func);
-		status = ath6kl_sdio_scat_rw(ar_sdio, req_priv->busrequest);
-		sdio_release_host(ar_sdio->func);
-	} else {
-		spin_lock_irqsave(&ar_sdio->wr_async_lock, flags);
-		list_add_tail(&req_priv->busrequest->list, &ar_sdio->wr_asyncq);
-		spin_unlock_irqrestore(&ar_sdio->wr_async_lock, flags);
-		queue_work(ar->ath6kl_wq, &ar_sdio->wr_async_work);
-	}
-
-	return status;
-}
-
 /* clean up scatter support */
 static void ath6kl_sdio_cleanup_scat_resource(struct ath6kl_sdio *ar_sdio)
 {
@@ -654,6 +622,37 @@ static int ath6kl_sdio_enable_scatter(struct ath6kl *ar,
 	return ret;
 }
 
+/* scatter gather read write request */
+static int ath6kl_sdio_async_rw_scatter(struct ath6kl *ar,
+					struct hif_scatter_req *scat_req)
+{
+	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
+	struct hif_scatter_req_priv *req_priv = scat_req->req_priv;
+	u32 request = scat_req->req;
+	int status = 0;
+	unsigned long flags;
+
+	if (!scat_req->len)
+		return -EINVAL;
+
+	ath6kl_dbg(ATH6KL_DBG_SCATTER,
+		"hif-scatter: total len: %d scatter entries: %d\n",
+		scat_req->len, scat_req->scat_entries);
+
+	if (request & HIF_SYNCHRONOUS) {
+		sdio_claim_host(ar_sdio->func);
+		status = ath6kl_sdio_scat_rw(ar_sdio, req_priv->busrequest);
+		sdio_release_host(ar_sdio->func);
+	} else {
+		spin_lock_irqsave(&ar_sdio->wr_async_lock, flags);
+		list_add_tail(&req_priv->busrequest->list, &ar_sdio->wr_asyncq);
+		spin_unlock_irqrestore(&ar_sdio->wr_async_lock, flags);
+		queue_work(ar->ath6kl_wq, &ar_sdio->wr_async_work);
+	}
+
+	return status;
+}
+
 static void ath6kl_sdio_cleanup_scatter(struct ath6kl *ar)
 {
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
-- 
1.7.1

