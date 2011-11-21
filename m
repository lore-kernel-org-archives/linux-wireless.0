Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29457 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab1KUG5r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 01:57:47 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Use mutex to protect dma buffer in sync read write
Date: Mon, 21 Nov 2011 12:26:51 +0530
Message-ID: <1321858611-2729-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20111121_075751_014174_D6962ADD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware crashes while starting Soft AP in 32 bit x86 platform.
The reason is that the single dma buffer (ar_sdio->dma_buffer)
is used in ath6kl_sdio_read_write_sync() for unaligned buffer
handling and this function is called in the multiple context
at the same time. So, finally hits dma buffer corruption and
firmware crash.

Mutex is used to protect dma buffer to avoid data corruption.
Spin lock can not used to fix this issue since mmc stack
read/write calls may for sleep.

Observed this issue with recently commited patch
"ath6kl: Claim sdio function only at appropriate places"
861dd058f495973c7ad2a44b8f68f3cc05733eab

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index c2010bf..36cdb18 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -54,6 +54,7 @@ struct ath6kl_sdio {
 	struct work_struct wr_async_work;
 	struct list_head wr_asyncq;
 	spinlock_t wr_async_lock;
+	struct mutex rd_wr_sync_mlock;
 };
 
 #define CMD53_ARG_READ          0
@@ -396,6 +397,7 @@ static int ath6kl_sdio_read_write_sync(struct ath6kl *ar, u32 addr, u8 *buf,
 	if (buf_needs_bounce(buf)) {
 		if (!ar_sdio->dma_buffer)
 			return -ENOMEM;
+		mutex_lock(&ar_sdio->rd_wr_sync_mlock);
 		tbuf = ar_sdio->dma_buffer;
 		memcpy(tbuf, buf, len);
 		bounced = true;
@@ -406,6 +408,9 @@ static int ath6kl_sdio_read_write_sync(struct ath6kl *ar, u32 addr, u8 *buf,
 	if ((request & HIF_READ) && bounced)
 		memcpy(buf, tbuf, len);
 
+	if (bounced)
+		mutex_unlock(&ar_sdio->rd_wr_sync_mlock);
+
 	return ret;
 }
 
@@ -1220,6 +1225,7 @@ static int ath6kl_sdio_probe(struct sdio_func *func,
 	spin_lock_init(&ar_sdio->lock);
 	spin_lock_init(&ar_sdio->scat_lock);
 	spin_lock_init(&ar_sdio->wr_async_lock);
+	mutex_init(&ar_sdio->rd_wr_sync_mlock);
 
 	INIT_LIST_HEAD(&ar_sdio->scat_req);
 	INIT_LIST_HEAD(&ar_sdio->bus_req_freeq);
-- 
1.7.0.4

