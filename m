Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56676 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab1I3QRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 12:17:33 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH V2 3/5] ath6kl: Claim sdio function only at appropriate places
Date: Fri, 30 Sep 2011 21:46:59 +0530
Message-ID: <1317399419-3929-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110930_181737_228764_1A7C80D9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are places where tx_complete callbacks are called with
claiming the sdio function. It is not necessary to hold the
sdio func for longer. This may even affect the host side power
save, if it is supported by the controller.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

V2 -- Commit log change

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 2dd7a88..7695c29 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -134,6 +134,8 @@ static int ath6kl_sdio_io(struct sdio_func *func, u32 request, u32 addr,
 {
 	int ret = 0;
 
+	sdio_claim_host(func);
+
 	if (request & HIF_WRITE) {
 		/* FIXME: looks like ugly workaround for something */
 		if (addr >= HIF_MBOX_BASE_ADDR &&
@@ -155,6 +157,8 @@ static int ath6kl_sdio_io(struct sdio_func *func, u32 request, u32 addr,
 			ret = sdio_memcpy_fromio(func, buf, addr, len);
 	}
 
+	sdio_release_host(func);
+
 	ath6kl_dbg(ATH6KL_DBG_SDIO, "%s addr 0x%x%s buf 0x%p len %d\n",
 		   request & HIF_WRITE ? "wr" : "rd", addr,
 		   request & HIF_FIXED_ADDRESS ? " (fixed)" : "", buf, len);
@@ -287,10 +291,14 @@ static int ath6kl_sdio_scat_rw(struct ath6kl_sdio *ar_sdio,
 	mmc_req.cmd = &cmd;
 	mmc_req.data = &data;
 
+	sdio_claim_host(ar_sdio->func);
+
 	mmc_set_data_timeout(&data, ar_sdio->func->card);
 	/* synchronous call to process request */
 	mmc_wait_for_req(ar_sdio->func->card->host, &mmc_req);
 
+	sdio_release_host(ar_sdio->func);
+
 	status = cmd.error ? cmd.error : data.error;
 
 scat_complete:
@@ -391,11 +399,9 @@ static int ath6kl_sdio_read_write_sync(struct ath6kl *ar, u32 addr, u8 *buf,
 	} else
 		tbuf = buf;
 
-	sdio_claim_host(ar_sdio->func);
 	ret = ath6kl_sdio_io(ar_sdio->func, request, addr, tbuf, len);
 	if ((request & HIF_READ) && bounced)
 		memcpy(buf, tbuf, len);
-	sdio_release_host(ar_sdio->func);
 
 	return ret;
 }
@@ -424,7 +430,6 @@ static void ath6kl_sdio_write_async_work(struct work_struct *work)
 	struct bus_request *req, *tmp_req;
 
 	ar_sdio = container_of(work, struct ath6kl_sdio, wr_async_work);
-	sdio_claim_host(ar_sdio->func);
 
 	spin_lock_bh(&ar_sdio->wr_async_lock);
 	list_for_each_entry_safe(req, tmp_req, &ar_sdio->wr_asyncq, list) {
@@ -434,8 +439,6 @@ static void ath6kl_sdio_write_async_work(struct work_struct *work)
 		spin_lock_bh(&ar_sdio->wr_async_lock);
 	}
 	spin_unlock_bh(&ar_sdio->wr_async_lock);
-
-	sdio_release_host(ar_sdio->func);
 }
 
 static void ath6kl_sdio_irq_handler(struct sdio_func *func)
@@ -618,11 +621,9 @@ static int ath6kl_sdio_async_rw_scatter(struct ath6kl *ar,
 		"hif-scatter: total len: %d scatter entries: %d\n",
 		scat_req->len, scat_req->scat_entries);
 
-	if (request & HIF_SYNCHRONOUS) {
-		sdio_claim_host(ar_sdio->func);
+	if (request & HIF_SYNCHRONOUS)
 		status = ath6kl_sdio_scat_rw(ar_sdio, scat_req->busrequest);
-		sdio_release_host(ar_sdio->func);
-	} else {
+	else {
 		spin_lock_bh(&ar_sdio->wr_async_lock);
 		list_add_tail(&scat_req->busrequest->list, &ar_sdio->wr_asyncq);
 		spin_unlock_bh(&ar_sdio->wr_async_lock);
-- 
1.7.0.4

