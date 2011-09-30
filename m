Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:16852 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757130Ab1I3NtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 09:49:13 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/5] ath6kl: Fix possible race in accessing bounce buffer
Date: Fri, 30 Sep 2011 19:18:45 +0530
Message-ID: <1317390526-3442-4-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20110930_154919_964438_EF3C48EC)
In-Reply-To: <1317390526-3442-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1317390526-3442-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is only one bounce buffer (ar_sdio->dma_buffer) which is used
for both read and write without any protection. Fix this race by
allocating bounce buffer every time when it is needed.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 7695c29..06e3f09 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -383,25 +383,29 @@ static int ath6kl_sdio_read_write_sync(struct ath6kl *ar, u32 addr, u8 *buf,
 				       u32 len, u32 request)
 {
 	struct ath6kl_sdio *ar_sdio = ath6kl_sdio_priv(ar);
-	u8  *tbuf = NULL;
 	int ret;
+	u8 *bounce_buf = NULL;
 	bool bounced = false;
 
 	if (request & HIF_BLOCK_BASIS)
 		len = round_down(len, HIF_MBOX_BLOCK_SIZE);
 
 	if (buf_needs_bounce(buf)) {
-		if (!ar_sdio->dma_buffer)
+		bounce_buf = kmalloc(len, GFP_ATOMIC);
+		if (!bounce_buf)
 			return -ENOMEM;
-		tbuf = ar_sdio->dma_buffer;
-		memcpy(tbuf, buf, len);
+		memcpy(bounce_buf, buf, len);
 		bounced = true;
 	} else
-		tbuf = buf;
+		bounce_buf = buf;
+
+	ret = ath6kl_sdio_io(ar_sdio->func, request, addr, bounce_buf, len);
 
-	ret = ath6kl_sdio_io(ar_sdio->func, request, addr, tbuf, len);
 	if ((request & HIF_READ) && bounced)
-		memcpy(buf, tbuf, len);
+		memcpy(buf, bounce_buf, len);
+
+	if (bounced)
+		kfree(bounce_buf);
 
 	return ret;
 }
-- 
1.7.0.4

