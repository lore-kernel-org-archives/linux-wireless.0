Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37995 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1GVFok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:44:40 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 11/31] ath6kl: Moe virt_scat from hif_dev_scat_sup_info to hif_scatter_req
Date: Fri, 22 Jul 2011 08:41:44 +0300
Message-ID: <1311313324-6766-13-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074443_305940_165D3A8E)
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
 drivers/net/wireless/ath/ath6kl/hif.h     |    3 ++-
 drivers/net/wireless/ath/ath6kl/htc_hif.c |    6 +++---
 drivers/net/wireless/ath/ath6kl/sdio.c    |    4 ++--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 6e0ec4a..abb1095 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -169,6 +169,8 @@ struct hif_scatter_req {
 	/* total length of entire transfer */
 	u32 len;
 
+	bool virt_scat;
+
 	void (*complete) (struct htc_target *, struct hif_scatter_req *);
 	int status;
 	int scat_entries;
@@ -185,7 +187,6 @@ struct hif_scatter_req {
 struct hif_dev_scat_sup_info {
 	int max_scat_entries;
 	int max_xfer_szper_scatreq;
-	bool virt_scat;
 };
 
 struct ath6kl_hif_ops {
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.c b/drivers/net/wireless/ath/ath6kl/htc_hif.c
index 33887cc..44bee90 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.c
@@ -273,7 +273,7 @@ int ath6kldev_submit_scat_req(struct ath6kl_device *dev,
 		   scat_req->addr, !read ? "async" : "sync",
 		   (read) ? "rd" : "wr");
 
-	if (!read && dev->hif_scat_info.virt_scat)
+	if (!read && scat_req->virt_scat)
 		status = ath6kldev_cp_scat_dma_buf(scat_req, false);
 
 	if (status) {
@@ -285,7 +285,7 @@ int ath6kldev_submit_scat_req(struct ath6kl_device *dev,
 		return status;
 	}
 
-	if (dev->hif_scat_info.virt_scat)
+	if (scat_req->virt_scat)
 		status =  ath6kldev_rw_scatter(dev->ar, scat_req);
 	else
 		status = ath6kl_hif_scat_req_rw(dev->ar, scat_req);
@@ -293,7 +293,7 @@ int ath6kldev_submit_scat_req(struct ath6kl_device *dev,
 	if (read) {
 		/* in sync mode, we can touch the scatter request */
 		scat_req->status = status;
-		if (!status && dev->hif_scat_info.virt_scat)
+		if (!status && scat_req->virt_scat)
 			scat_req->status =
 				ath6kldev_cp_scat_dma_buf(scat_req, true);
 	}
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 96a112e..686f091 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -325,6 +325,8 @@ static int ath6kl_sdio_alloc_prep_scat_req(struct ath6kl_sdio *ar_sdio,
 		bus_req->scat_req = s_req;
 		s_req->busrequest = bus_req;
 
+		s_req->virt_scat = virt_scat;
+
 		/* add it to the scatter pool */
 		hif_scatter_req_add(ar_sdio->ar, s_req);
 	}
@@ -694,8 +696,6 @@ static int ath6kl_sdio_enable_scatter(struct ath6kl *ar,
 					ATH6KL_MAX_TRANSFER_SIZE_PER_SCATTER;
 	}
 
-	pinfo->virt_scat = virt_scat;
-
 	return 0;
 }
 
-- 
1.7.1

