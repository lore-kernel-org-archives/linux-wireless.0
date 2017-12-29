Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:49590 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751432AbdL2UwX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 15:52:23 -0500
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Solomon Peachy <pizza@shaftnet.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] cw1200: Delete an error message for a failed memory
 allocation in three functions
Message-ID: <b000d5f0-c659-0d04-2c40-e70e25b68b13@users.sourceforge.net> (sfid-20171229_215249_996433_7372DEB2)
Date: Fri, 29 Dec 2017 21:52:15 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 29 Dec 2017 21:48:05 +0100

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/st/cw1200/cw1200_sdio.c | 4 +---
 drivers/net/wireless/st/cw1200/cw1200_spi.c  | 4 +---
 drivers/net/wireless/st/cw1200/fwio.c        | 1 -
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/cw1200_sdio.c b/drivers/net/wireless/st/cw1200/cw1200_sdio.c
index 1037ec62659d..82c6827579a9 100644
--- a/drivers/net/wireless/st/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/st/cw1200/cw1200_sdio.c
@@ -289,10 +289,8 @@ static int cw1200_sdio_probe(struct sdio_func *func,
 		return -ENODEV;
 
 	self = kzalloc(sizeof(*self), GFP_KERNEL);
-	if (!self) {
-		pr_err("Can't allocate SDIO hwbus_priv.\n");
+	if (!self)
 		return -ENOMEM;
-	}
 
 	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
 
diff --git a/drivers/net/wireless/st/cw1200/cw1200_spi.c b/drivers/net/wireless/st/cw1200/cw1200_spi.c
index 412fb6e49aed..7b6d5e5c5a62 100644
--- a/drivers/net/wireless/st/cw1200/cw1200_spi.c
+++ b/drivers/net/wireless/st/cw1200/cw1200_spi.c
@@ -399,10 +399,8 @@ static int cw1200_spi_probe(struct spi_device *func)
 	}
 
 	self = devm_kzalloc(&func->dev, sizeof(*self), GFP_KERNEL);
-	if (!self) {
-		pr_err("Can't allocate SPI hwbus_priv.");
+	if (!self)
 		return -ENOMEM;
-	}
 
 	self->pdata = plat_data;
 	self->func = func;
diff --git a/drivers/net/wireless/st/cw1200/fwio.c b/drivers/net/wireless/st/cw1200/fwio.c
index 30e7646d04af..79dd7a8ffb05 100644
--- a/drivers/net/wireless/st/cw1200/fwio.c
+++ b/drivers/net/wireless/st/cw1200/fwio.c
@@ -153,7 +153,6 @@ static int cw1200_load_firmware_cw1200(struct cw1200_common *priv)
 
 	buf = kmalloc(DOWNLOAD_BLOCK_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!buf) {
-		pr_err("Can't allocate firmware load buffer.\n");
 		ret = -ENOMEM;
 		goto firmware_release;
 	}
-- 
2.15.1
