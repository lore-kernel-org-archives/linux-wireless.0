Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54611 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab1GVFnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 06/31] ath6kl: Refactor refactor ath6kl_sdio_setup_scat_resource()
Date: Fri, 22 Jul 2011 08:41:39 +0300
Message-ID: <1311313324-6766-8-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074316_323920_BE29BD96)
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
 drivers/net/wireless/ath/ath6kl/sdio.c |   99 ++++++++++++++++++-------------
 1 files changed, 57 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 6fbc27e..36f25fc 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -269,6 +269,55 @@ static int ath6kl_sdio_scat_rw(struct ath6kl_sdio *ar_sdio,
 	return status;
 }
 
+static int ath6kl_sdio_alloc_prep_scat_req(struct ath6kl_sdio *ar_sdio,
+					   int n_scat_entry, int n_scat_req,
+					   bool virt_scat)
+{
+	struct hif_scatter_req *s_req;
+	struct bus_request *bus_req;
+	int i, scat_req_sz, scat_list_sz, sg_sz = 0;
+
+	scat_list_sz = (n_scat_entry - 1) * sizeof(struct hif_scatter_item);
+	scat_req_sz = sizeof(*s_req) + scat_list_sz;
+
+	if (!virt_scat)
+		sg_sz = sizeof(struct scatterlist) * n_scat_entry;
+
+	for (i = 0; i < n_scat_req; i++) {
+		/* allocate the scatter request */
+		s_req = kzalloc(scat_req_sz, GFP_KERNEL);
+		if (!s_req)
+			return -ENOMEM;
+
+		if (sg_sz) {
+			/* allocate sglist */
+			s_req->sgentries = kzalloc(sg_sz, GFP_KERNEL);
+
+			if (!s_req->sgentries) {
+				kfree(s_req);
+				return -ENOMEM;
+			}
+		}
+
+		/* allocate a bus request for this scatter request */
+		bus_req = ath6kl_sdio_alloc_busreq(ar_sdio);
+		if (!bus_req) {
+			kfree(s_req->sgentries);
+			kfree(s_req);
+			return -ENOMEM;
+		}
+
+		/* assign the scatter request to this bus request */
+		bus_req->scat_req = s_req;
+		s_req->busrequest = bus_req;
+
+		/* add it to the scatter pool */
+		hif_scatter_req_add(ar_sdio->ar, s_req);
+	}
+
+	return 0;
+}
+
 /* clean up scatter support */
 static void ath6kl_sdio_cleanup_scat_resource(struct ath6kl_sdio *ar_sdio)
 {
@@ -296,9 +345,7 @@ static void ath6kl_sdio_cleanup_scat_resource(struct ath6kl_sdio *ar_sdio)
 static int ath6kl_sdio_setup_scat_resource(struct ath6kl_sdio *ar_sdio,
 					   struct hif_dev_scat_sup_info *pinfo)
 {
-	struct hif_scatter_req *s_req;
-	struct bus_request *bus_req;
-	int i, scat_req_sz, scat_list_sz, sg_sz;
+	int ret = 0;
 
 	/* check if host supports scatter and it meets our requirements */
 	if (ar_sdio->func->card->host->max_segs < MAX_SCATTER_ENTRIES_PER_REQ) {
@@ -312,51 +359,19 @@ static int ath6kl_sdio_setup_scat_resource(struct ath6kl_sdio *ar_sdio,
 		   "hif-scatter enabled: max scatter req : %d entries: %d\n",
 		   MAX_SCATTER_REQUESTS, MAX_SCATTER_ENTRIES_PER_REQ);
 
-	scat_list_sz = (MAX_SCATTER_ENTRIES_PER_REQ - 1) *
-		       sizeof(struct hif_scatter_item);
-	scat_req_sz = sizeof(*s_req) + scat_list_sz;
-
-	sg_sz = sizeof(struct scatterlist) * MAX_SCATTER_ENTRIES_PER_REQ;
-
-	for (i = 0; i < MAX_SCATTER_REQUESTS; i++) {
-		/* allocate the scatter request */
-		s_req = kzalloc(scat_req_sz, GFP_KERNEL);
-		if (!s_req)
-			goto fail_setup_scat;
-
-		/* allocate sglist */
-		s_req->sgentries = kzalloc(sg_sz, GFP_KERNEL);
-
-		if (!s_req->sgentries) {
-			kfree(s_req);
-			goto fail_setup_scat;
-		}
-
-		/* allocate a bus request for this scatter request */
-		bus_req = ath6kl_sdio_alloc_busreq(ar_sdio);
-		if (!bus_req) {
-			kfree(s_req->sgentries);
-			kfree(s_req);
-			goto fail_setup_scat;
-		}
-
-		/* assign the scatter request to this bus request */
-		bus_req->scat_req = s_req;
-		s_req->busrequest = bus_req;
-		/* add it to the scatter pool */
-		hif_scatter_req_add(ar_sdio->ar, s_req);
+	ret = ath6kl_sdio_alloc_prep_scat_req(ar_sdio,
+					      MAX_SCATTER_ENTRIES_PER_REQ,
+					      MAX_SCATTER_REQUESTS, 0);
+	if (ret) {
+		ath6kl_err("hif-scatter: failed to alloc scatter resources !\n");
+		ath6kl_sdio_cleanup_scat_resource(ar_sdio);
+		return ret;
 	}
 
 	pinfo->max_scat_entries = MAX_SCATTER_ENTRIES_PER_REQ;
 	pinfo->max_xfer_szper_scatreq = MAX_SCATTER_REQ_TRANSFER_SIZE;
 
 	return 0;
-
-fail_setup_scat:
-	ath6kl_err("hif-scatter: failed to alloc scatter resources !\n");
-	ath6kl_sdio_cleanup_scat_resource(ar_sdio);
-
-	return -ENOMEM;
 }
 
 static int ath6kl_sdio_read_write_sync(struct ath6kl *ar, u32 addr, u8 *buf,
-- 
1.7.1

