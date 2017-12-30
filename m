Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:49784 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750865AbdL3UeL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Dec 2017 15:34:11 -0500
To: b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] wireless: b43: Delete an error message for a failed memory
 allocation in b43_sdio_probe()
Message-ID: <175d361f-0c00-2a32-c860-a5ad198e74ba@users.sourceforge.net> (sfid-20171230_213430_285492_2571CE77)
Date: Sat, 30 Dec 2017 21:33:44 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 30 Dec 2017 21:23:47 +0100

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/broadcom/b43/sdio.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43/sdio.c b/drivers/net/wireless/broadcom/b43/sdio.c
index 59a521800694..5a6dbcf170f9 100644
--- a/drivers/net/wireless/broadcom/b43/sdio.c
+++ b/drivers/net/wireless/broadcom/b43/sdio.c
@@ -146,7 +146,6 @@ static int b43_sdio_probe(struct sdio_func *func,
 	sdio = kzalloc(sizeof(*sdio), GFP_KERNEL);
 	if (!sdio) {
 		error = -ENOMEM;
-		dev_err(&func->dev, "failed to allocate ssb bus\n");
 		goto err_disable_func;
 	}
 	error = ssb_bus_sdiobus_register(&sdio->ssb, func,
-- 
2.15.1
