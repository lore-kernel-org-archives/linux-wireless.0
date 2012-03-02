Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51082 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758569Ab2CBMc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 07:32:26 -0500
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Restrict memcpy to bounce buffer only for write request
Date: Fri, 2 Mar 2012 18:02:08 +0530
Message-ID: <1330691528-2915-1-git-send-email-rmani@qca.qualcomm.com> (sfid-20120302_133230_155126_E392960C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

No need to copy received local buffer content to bounce buffer
(DMA buffer) while performing sync READ operation from the chip.

It's applicable for only WRITE operation.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 346f5dd..e2f42a1 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -405,7 +405,10 @@ static int ath6kl_sdio_read_write_sync(struct ath6kl *ar, u32 addr, u8 *buf,
 			return -ENOMEM;
 		mutex_lock(&ar_sdio->dma_buffer_mutex);
 		tbuf = ar_sdio->dma_buffer;
-		memcpy(tbuf, buf, len);
+
+		if (request & HIF_WRITE)
+			memcpy(tbuf, buf, len);
+
 		bounced = true;
 	} else
 		tbuf = buf;
-- 
1.7.1

