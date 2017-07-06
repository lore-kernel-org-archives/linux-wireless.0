Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33517 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750896AbdGFOlo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:41:44 -0400
Received: by mail-pg0-f66.google.com with SMTP id u62so501156pgb.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 07:41:44 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [v3 03/21] rsi: fix sdio card reset problem
Date: Thu,  6 Jul 2017 20:07:06 +0530
Message-Id: <1499351844-2046-4-git-send-email-amitkarwar@gmail.com> (sfid-20170706_164147_450248_888CB69B)
In-Reply-To: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
References: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

card reset is not working with recent kernels. Using
host->card->ocr instead of host->ocr_avail solved the problem.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index e5ea99b..b5ac503 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -219,26 +219,18 @@ static void rsi_reset_card(struct sdio_func *pfunction)
 	if (err)
 		rsi_dbg(ERR_ZONE, "%s: CMD0 failed : %d\n", __func__, err);
 
-	if (!host->ocr_avail) {
-		/* Issue CMD5, arg = 0 */
-		err = rsi_issue_sdiocommand(pfunction,
-					    SD_IO_SEND_OP_COND,
-					    0,
-					    (MMC_RSP_R4 | MMC_CMD_BCR),
-					    &resp);
-		if (err)
-			rsi_dbg(ERR_ZONE, "%s: CMD5 failed : %d\n",
-				__func__, err);
-		host->ocr_avail = resp;
-	}
+	/* Issue CMD5, arg = 0 */
+	err = rsi_issue_sdiocommand(pfunction,	SD_IO_SEND_OP_COND, 0,
+				    (MMC_RSP_R4 | MMC_CMD_BCR), &resp);
+	if (err)
+		rsi_dbg(ERR_ZONE, "%s: CMD5 failed : %d\n", __func__, err);
+	card->ocr = resp;
 
 	/* Issue CMD5, arg = ocr. Wait till card is ready  */
 	for (i = 0; i < 100; i++) {
-		err = rsi_issue_sdiocommand(pfunction,
-					    SD_IO_SEND_OP_COND,
-					    host->ocr_avail,
-					    (MMC_RSP_R4 | MMC_CMD_BCR),
-					    &resp);
+		err = rsi_issue_sdiocommand(pfunction, SD_IO_SEND_OP_COND,
+					    card->ocr,
+					    (MMC_RSP_R4 | MMC_CMD_BCR), &resp);
 		if (err) {
 			rsi_dbg(ERR_ZONE, "%s: CMD5 failed : %d\n",
 				__func__, err);
-- 
2.7.4
