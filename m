Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54611 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab1GVFnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:14 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 05/31] ath6kl: Remove endpoint reference from hif_scatter_req
Date: Fri, 22 Jul 2011 08:41:38 +0300
Message-ID: <1311313324-6766-7-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074319_585992_49571219)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Endpoint id ffrom htc_packet can be used instead.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/hif.h     |    3 +--
 drivers/net/wireless/ath/ath6kl/htc.c     |   10 ++++++----
 drivers/net/wireless/ath/ath6kl/htc_hif.c |    6 +++---
 drivers/net/wireless/ath/ath6kl/sdio.c    |    2 +-
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index f202f0d..73340f2 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -169,9 +169,8 @@ struct hif_scatter_req {
 	/* total length of entire transfer */
 	u32 len;
 
-	void (*complete) (struct hif_scatter_req *);
+	void (*complete) (struct htc_target *, struct hif_scatter_req *);
 	int status;
-	struct htc_endpoint *ep;
 	int scat_entries;
 
 	struct bus_request *busrequest;
diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index e65de49..e77e768 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -127,10 +127,10 @@ static void htc_tx_comp_handler(struct htc_target *target,
 	htc_tx_complete(endpoint, &container);
 }
 
-static void htc_async_tx_scat_complete(struct hif_scatter_req *scat_req)
+static void htc_async_tx_scat_complete(struct htc_target *target,
+				       struct hif_scatter_req *scat_req)
 {
-	struct htc_endpoint *endpoint = scat_req->ep;
-	struct htc_target *target = endpoint->target;
+	struct htc_endpoint *endpoint;
 	struct htc_packet *packet;
 	struct list_head tx_compq;
 	int i;
@@ -144,6 +144,9 @@ static void htc_async_tx_scat_complete(struct hif_scatter_req *scat_req)
 	if (scat_req->status)
 		ath6kl_err("send scatter req failed: %d\n", scat_req->status);
 
+	packet = scat_req->scat_list[0].packet;
+	endpoint = &target->endpoint[packet->endpoint];
+
 	/* walk through the scatter list and process */
 	for (i = 0; i < scat_req->scat_entries; i++) {
 		packet = scat_req->scat_list[i].packet;
@@ -465,7 +468,6 @@ static void htc_issue_send_bundle(struct htc_endpoint *endpoint,
 
 		/* send path is always asynchronous */
 		scat_req->complete = htc_async_tx_scat_complete;
-		scat_req->ep = endpoint;
 		n_sent_bundle++;
 		tot_pkts_bundle += scat_req->scat_entries;
 
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.c b/drivers/net/wireless/ath/ath6kl/htc_hif.c
index df904d8..40853cb 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.c
@@ -201,7 +201,7 @@ static void ath6kldev_rw_async_handler(struct htc_target *target,
 
 	ath6kl_add_io_pkt(dev, packet);
 
-	req->complete(req);
+	req->complete(target, req);
 }
 
 static int ath6kldev_rw_scatter(struct ath6kl *ar, struct hif_scatter_req *req)
@@ -243,7 +243,7 @@ out:
 			if (packet != NULL)
 				ath6kl_add_io_pkt(dev, packet);
 			req->status = status;
-			req->complete(req);
+			req->complete(ar->htc_target, req);
 			status = 0;
 		}
 
@@ -279,7 +279,7 @@ int ath6kldev_submit_scat_req(struct ath6kl_device *dev,
 	if (status) {
 		if (!read) {
 			scat_req->status = status;
-			scat_req->complete(scat_req);
+			scat_req->complete(dev->ar->htc_target, scat_req);
 			return 0;
 		}
 		return status;
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index da60738..6fbc27e 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -264,7 +264,7 @@ static int ath6kl_sdio_scat_rw(struct ath6kl_sdio *ar_sdio,
 			   scat_req->status);
 
 	if (scat_req->req & HIF_ASYNCHRONOUS)
-		scat_req->complete(scat_req);
+		scat_req->complete(ar_sdio->ar->htc_target, scat_req);
 
 	return status;
 }
-- 
1.7.1

