Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27918 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab1I3Nuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 09:50:44 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 5/5] ath6kl: Remove unused ar_sdio->dma_buffer
Date: Fri, 30 Sep 2011 19:18:46 +0530
Message-ID: <1317390526-3442-5-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110930_155048_713001_EA196BBF)
In-Reply-To: <1317390526-3442-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1317390526-3442-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 06e3f09..6bef420 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -39,7 +39,6 @@ struct ath6kl_sdio {
 	struct bus_request bus_req[BUS_REQUEST_MAX_NUM];
 
 	struct ath6kl *ar;
-	u8 *dma_buffer;
 
 	/* scatter request list head */
 	struct list_head scat_req;
@@ -777,12 +776,6 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 	if (!ar_sdio)
 		return -ENOMEM;
 
-	ar_sdio->dma_buffer = kzalloc(HIF_DMA_BUFFER_SIZE, GFP_KERNEL);
-	if (!ar_sdio->dma_buffer) {
-		ret = -ENOMEM;
-		goto err_hif;
-	}
-
 	ar_sdio->func = func;
 	sdio_set_drvdata(func, ar_sdio);
 
@@ -806,7 +799,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 	if (!ar) {
 		ath6kl_err("Failed to alloc ath6kl core\n");
 		ret = -ENOMEM;
-		goto err_dma;
+		goto err_hif;
 	}
 
 	ar_sdio->ar = ar;
@@ -866,8 +859,6 @@ err_off:
 	ath6kl_sdio_power_off(ar_sdio);
 err_cfg80211:
 	ath6kl_cfg80211_deinit(ar_sdio->ar);
-err_dma:
-	kfree(ar_sdio->dma_buffer);
 err_hif:
 	kfree(ar_sdio);
 
@@ -891,7 +882,6 @@ static void ath6kl_sdio_remove(struct sdio_func *func)
 
 	ath6kl_sdio_power_off(ar_sdio);
 
-	kfree(ar_sdio->dma_buffer);
 	kfree(ar_sdio);
 }
 
-- 
1.7.0.4

