Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37985 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab1GVFma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:42:30 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 01/31] ath6kl: cleanup callbacks for different scatter gather method
Date: Fri, 22 Jul 2011 08:41:34 +0300
Message-ID: <1311313324-6766-3-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074233_530314_60D5848A)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Define a hook in ath6kl_hif_ops for hif scatter gather mechanism.
When virtual scatter gather is used, call the respective function
directly.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif-ops.h |    6 ++++++
 drivers/net/wireless/ath/ath6kl/hif.h     |    3 ++-
 drivers/net/wireless/ath/ath6kl/htc_hif.c |    6 ++++--
 drivers/net/wireless/ath/ath6kl/sdio.c    |    7 +++----
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif-ops.h b/drivers/net/wireless/ath/ath6kl/hif-ops.h
index ad49669..32890cd 100644
--- a/drivers/net/wireless/ath/ath6kl/hif-ops.h
+++ b/drivers/net/wireless/ath/ath6kl/hif-ops.h
@@ -59,6 +59,12 @@ static inline int ath6kl_hif_enable_scatter(struct ath6kl *ar,
 	return ar->hif_ops->enable_scatter(ar, info);
 }
 
+static inline int ath6kl_hif_scat_req_rw(struct ath6kl *ar,
+					 struct hif_scatter_req *scat_req)
+{
+	return ar->hif_ops->scat_req_rw(ar, scat_req);
+}
+
 static inline void ath6kl_hif_cleanup_scatter(struct ath6kl *ar)
 {
 	return ar->hif_ops->cleanup_scatter(ar);
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 465876f..4c7a7d3 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -184,7 +184,6 @@ struct hif_scatter_req {
 };
 
 struct hif_dev_scat_sup_info {
-	int (*rw_scat_func) (struct ath6kl *ar, struct hif_scatter_req *);
 	int max_scat_entries;
 	int max_xfer_szper_scatreq;
 };
@@ -208,6 +207,8 @@ struct ath6kl_hif_ops {
 				struct hif_scatter_req *s_req);
 	int (*enable_scatter)(struct ath6kl *ar,
 			      struct hif_dev_scat_sup_info *info);
+	int (*scat_req_rw) (struct ath6kl *ar,
+			    struct hif_scatter_req *scat_req);
 	void (*cleanup_scatter)(struct ath6kl *ar);
 };
 
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.c b/drivers/net/wireless/ath/ath6kl/htc_hif.c
index 1bcaaec..df904d8 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.c
@@ -285,7 +285,10 @@ int ath6kldev_submit_scat_req(struct ath6kl_device *dev,
 		return status;
 	}
 
-	status = dev->hif_scat_info.rw_scat_func(dev->ar, scat_req);
+	if (dev->virt_scat)
+		status =  ath6kldev_rw_scatter(dev->ar, scat_req);
+	else
+		status = ath6kl_hif_scat_req_rw(dev->ar, scat_req);
 
 	if (read) {
 		/* in sync mode, we can touch the scatter request */
@@ -340,7 +343,6 @@ static int ath6kldev_setup_virt_scat_sup(struct ath6kl_device *dev)
 	if (status)
 		ath6kl_hif_cleanup_scatter(dev->ar);
 	else {
-		dev->hif_scat_info.rw_scat_func = ath6kldev_rw_scatter;
 		dev->hif_scat_info.max_scat_entries =
 			ATH6KL_SCATTER_ENTRIES_PER_REQ;
 		dev->hif_scat_info.max_xfer_szper_scatreq =
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index b38732a..d217f1c 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -271,9 +271,9 @@ static int ath6kl_sdio_scat_rw(struct ath6kl_sdio *ar_sdio,
 }
 
 
-/* callback to issue a read-write scatter request */
+/* scatter gather read write request */
 static int ath6kl_sdio_async_rw_scatter(struct ath6kl *ar,
-					struct hif_scatter_req *scat_req)
+				 struct hif_scatter_req *scat_req)
 {
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
 	struct hif_scatter_req_priv *req_priv = scat_req->req_priv;
@@ -379,8 +379,6 @@ static int ath6kl_sdio_setup_scat_resource(struct ath6kl_sdio *ar_sdio,
 		hif_scatter_req_add(ar_sdio->ar, s_req);
 	}
 
-	/* set scatter function pointers */
-	pinfo->rw_scat_func = ath6kl_sdio_async_rw_scatter;
 	pinfo->max_scat_entries = MAX_SCATTER_ENTRIES_PER_REQ;
 	pinfo->max_xfer_szper_scatreq = MAX_SCATTER_REQ_TRANSFER_SIZE;
 
@@ -671,6 +669,7 @@ static const struct ath6kl_hif_ops ath6kl_sdio_ops = {
 	.scatter_req_get = ath6kl_sdio_scatter_req_get,
 	.scatter_req_add = ath6kl_sdio_scatter_req_add,
 	.enable_scatter = ath6kl_sdio_enable_scatter,
+	.scat_req_rw = ath6kl_sdio_async_rw_scatter,
 	.cleanup_scatter = ath6kl_sdio_cleanup_scatter,
 };
 
-- 
1.7.1

