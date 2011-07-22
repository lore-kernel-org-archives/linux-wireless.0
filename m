Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54611 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab1GVFnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 13/31] ath6kl: Merge scatter rw request functions into one
Date: Fri, 22 Jul 2011 08:41:46 +0300
Message-ID: <1311313324-6766-15-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074319_071828_66943619)
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
 drivers/net/wireless/ath/ath6kl/htc_hif.c |   99 +----------------------------
 drivers/net/wireless/ath/ath6kl/htc_hif.h |    2 -
 drivers/net/wireless/ath/ath6kl/sdio.c    |   15 ++++-
 3 files changed, 15 insertions(+), 101 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.c b/drivers/net/wireless/ath/ath6kl/htc_hif.c
index 44bee90..c5fb78b 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.c
@@ -24,29 +24,6 @@
 
 #define ATH6KL_TIME_QUANTUM	10  /* in ms */
 
-static void ath6kl_add_io_pkt(struct ath6kl_device *dev,
-			      struct htc_packet *packet)
-{
-	spin_lock_bh(&dev->lock);
-	list_add_tail(&packet->list, &dev->reg_io);
-	spin_unlock_bh(&dev->lock);
-}
-
-static struct htc_packet *ath6kl_get_io_pkt(struct ath6kl_device *dev)
-{
-	struct htc_packet *packet = NULL;
-
-	spin_lock_bh(&dev->lock);
-	if (!list_empty(&dev->reg_io)) {
-		packet = list_first_entry(&dev->reg_io,
-					 struct htc_packet, list);
-		list_del(&packet->list);
-	}
-	spin_unlock_bh(&dev->lock);
-
-	return packet;
-}
-
 static int ath6kldev_cp_scat_dma_buf(struct hif_scatter_req *req, bool from_dma)
 {
 	u8 *buf;
@@ -191,65 +168,6 @@ int ath6kldev_rx_control(struct ath6kl_device *dev, bool enable_rx)
 	return status;
 }
 
-static void ath6kldev_rw_async_handler(struct htc_target *target,
-				       struct htc_packet *packet)
-{
-	struct ath6kl_device *dev = target->dev;
-	struct hif_scatter_req *req = packet->pkt_cntxt;
-
-	req->status = packet->status;
-
-	ath6kl_add_io_pkt(dev, packet);
-
-	req->complete(target, req);
-}
-
-static int ath6kldev_rw_scatter(struct ath6kl *ar, struct hif_scatter_req *req)
-{
-	struct ath6kl_device *dev = ar->htc_target->dev;
-	struct htc_packet *packet = NULL;
-	int status = 0;
-	u32 request = req->req;
-	u8 *virt_dma_buf;
-
-	if (!req->len)
-		return 0;
-
-	if (request & HIF_ASYNCHRONOUS) {
-		/* use an I/O packet to carry this request */
-		packet = ath6kl_get_io_pkt(dev);
-		if (!packet) {
-			status = -ENOMEM;
-			goto out;
-		}
-
-		packet->pkt_cntxt = req;
-		packet->completion = ath6kldev_rw_async_handler;
-		packet->context = ar->htc_target;
-	}
-
-	virt_dma_buf = req->virt_dma_buf;
-
-	if (request & HIF_ASYNCHRONOUS)
-		status = hif_write_async(dev->ar, req->addr, virt_dma_buf,
-					 req->len, request, packet);
-	else
-		status = hif_read_write_sync(dev->ar, req->addr, virt_dma_buf,
-					     req->len, request);
-
-out:
-	if (status)
-		if (request & HIF_ASYNCHRONOUS) {
-			if (packet != NULL)
-				ath6kl_add_io_pkt(dev, packet);
-			req->status = status;
-			req->complete(ar->htc_target, req);
-			status = 0;
-		}
-
-	return status;
-}
-
 int ath6kldev_submit_scat_req(struct ath6kl_device *dev,
 			      struct hif_scatter_req *scat_req, bool read)
 {
@@ -285,10 +203,7 @@ int ath6kldev_submit_scat_req(struct ath6kl_device *dev,
 		return status;
 	}
 
-	if (scat_req->virt_scat)
-		status =  ath6kldev_rw_scatter(dev->ar, scat_req);
-	else
-		status = ath6kl_hif_scat_req_rw(dev->ar, scat_req);
+	status = ath6kl_hif_scat_req_rw(dev->ar, scat_req);
 
 	if (read) {
 		/* in sync mode, we can touch the scatter request */
@@ -699,21 +614,9 @@ int ath6kldev_mask_intrs(struct ath6kl_device *dev)
 int ath6kldev_setup(struct ath6kl_device *dev)
 {
 	int status = 0;
-	int i;
-	struct htc_packet *packet;
 
-	/* initialize our free list of IO packets */
-	INIT_LIST_HEAD(&dev->reg_io);
 	spin_lock_init(&dev->lock);
 
-	/* carve up register I/O packets (these are for ASYNC register I/O ) */
-	for (i = 0; i < ATH6KL_MAX_REG_IO_BUFFERS; i++) {
-		packet = &dev->reg_io_buf[i].packet;
-		set_htc_rxpkt_info(packet, dev, dev->reg_io_buf[i].buf,
-				   ATH6KL_REG_IO_BUFFER_SIZE, 0);
-		ath6kl_add_io_pkt(dev, packet);
-	}
-
 	/*
 	 * NOTE: we actually get the block size of a mailbox other than 0,
 	 * for SDIO the block size on mailbox 0 is artificially set to 1.
diff --git a/drivers/net/wireless/ath/ath6kl/htc_hif.h b/drivers/net/wireless/ath/ath6kl/htc_hif.h
index 3514c22..4cab5fb 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_hif.h
+++ b/drivers/net/wireless/ath/ath6kl/htc_hif.h
@@ -82,8 +82,6 @@ struct ath6kl_device {
 	u32 block_sz;
 	u32 block_mask;
 	struct htc_target *htc_cnxt;
-	struct list_head reg_io;
-	struct ath6kl_async_reg_io_buffer reg_io_buf[ATH6KL_MAX_REG_IO_BUFFERS];
 	int (*msg_pending) (struct htc_target *target, u32 lk_ahds[],
 			    int *npkts_fetched);
 	struct hif_dev_scat_sup_info hif_scat_info;
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 6c66613..44ac68e 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -244,10 +244,21 @@ static int ath6kl_sdio_scat_rw(struct ath6kl_sdio *ar_sdio,
 	struct mmc_data data;
 	struct hif_scatter_req *scat_req;
 	u8 opcode, rw;
-	int status;
+	int status, len;
 
 	scat_req = req->scat_req;
 
+	if (scat_req->virt_scat) {
+		len = scat_req->len;
+		if (scat_req->req & HIF_BLOCK_BASIS)
+			len = round_down(len, HIF_MBOX_BLOCK_SIZE);
+
+		status = ath6kl_sdio_io(ar_sdio->func, scat_req->req,
+					scat_req->addr, scat_req->virt_dma_buf,
+					len);
+		goto scat_complete;
+	}
+
 	memset(&mmc_req, 0, sizeof(struct mmc_request));
 	memset(&cmd, 0, sizeof(struct mmc_command));
 	memset(&data, 0, sizeof(struct mmc_data));
@@ -284,6 +295,8 @@ static int ath6kl_sdio_scat_rw(struct ath6kl_sdio *ar_sdio,
 	mmc_wait_for_req(ar_sdio->func->card->host, &mmc_req);
 
 	status = cmd.error ? cmd.error : data.error;
+
+scat_complete:
 	scat_req->status = status;
 
 	if (scat_req->status)
-- 
1.7.1

