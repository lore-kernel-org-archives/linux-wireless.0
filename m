Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55108 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282Ab1GVFnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH 12/31] ath6kl: Refactor ath6kl_sdio_read_write_sync()
Date: Fri, 22 Jul 2011 08:41:45 +0300
Message-ID: <1311313324-6766-14-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074304_745692_BA840D74)
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
 drivers/net/wireless/ath/ath6kl/sdio.c |   51 ++++++++++++++++++-------------
 1 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 686f091..6c66613 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -128,6 +128,33 @@ static int ath6kl_sdio_func0_cmd52_wr_byte(struct mmc_card *card,
 	return mmc_wait_for_cmd(card->host, &io_cmd, 0);
 }
 
+static int ath6kl_sdio_io(struct sdio_func *func, u32 request, u32 addr,
+			  u8 *buf, u32 len)
+{
+	int ret = 0;
+
+	if (request & HIF_WRITE) {
+		if (addr >= HIF_MBOX_BASE_ADDR &&
+		    addr <= HIF_MBOX_END_ADDR)
+			addr += (HIF_MBOX_WIDTH - len);
+
+		if (addr == HIF_MBOX0_EXT_BASE_ADDR)
+			addr += HIF_MBOX0_EXT_WIDTH - len;
+
+		if (request & HIF_FIXED_ADDRESS)
+			ret = sdio_writesb(func, addr, buf, len);
+		else
+			ret = sdio_memcpy_toio(func, addr, buf, len);
+	} else {
+		if (request & HIF_FIXED_ADDRESS)
+			ret = sdio_readsb(func, buf, addr, len);
+		else
+			ret = sdio_memcpy_fromio(func, buf, addr, len);
+	}
+
+	return ret;
+}
+
 static struct bus_request *ath6kl_sdio_alloc_busreq(struct ath6kl_sdio *ar_sdio)
 {
 	struct bus_request *bus_req;
@@ -355,27 +382,9 @@ static int ath6kl_sdio_read_write_sync(struct ath6kl *ar, u32 addr, u8 *buf,
 		tbuf = buf;
 
 	sdio_claim_host(ar_sdio->func);
-	if (request & HIF_WRITE) {
-		if (addr >= HIF_MBOX_BASE_ADDR &&
-		    addr <= HIF_MBOX_END_ADDR)
-			addr += (HIF_MBOX_WIDTH - len);
-
-		if (addr == HIF_MBOX0_EXT_BASE_ADDR)
-			addr += HIF_MBOX0_EXT_WIDTH - len;
-
-		if (request & HIF_FIXED_ADDRESS)
-			ret = sdio_writesb(ar_sdio->func, addr, tbuf, len);
-		else
-			ret = sdio_memcpy_toio(ar_sdio->func, addr, tbuf, len);
-	} else {
-		if (request & HIF_FIXED_ADDRESS)
-			ret = sdio_readsb(ar_sdio->func, tbuf, addr, len);
-		else
-			ret = sdio_memcpy_fromio(ar_sdio->func, tbuf,
-						 addr, len);
-		if (bounced)
-			memcpy(buf, tbuf, len);
-	}
+	ret = ath6kl_sdio_io(ar_sdio->func, request, addr, tbuf, len);
+	if ((request & HIF_READ) && bounced)
+		memcpy(buf, tbuf, len);
 	sdio_release_host(ar_sdio->func);
 
 	return ret;
-- 
1.7.1

