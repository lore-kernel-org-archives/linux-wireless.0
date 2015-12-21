Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:11348 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbbLUFQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2015 00:16:17 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 12/46] staging: wilc1000: linux_wlan_sdio.c: fix checkpatch warning line over 80
Date: Mon, 21 Dec 2015 14:18:16 +0900
Message-ID: <1450675130-17866-13-git-send-email-glen.lee@atmel.com> (sfid-20151221_063058_697169_503EFF34)
In-Reply-To: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
References: <1450675130-17866-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes checkpatch warning line over 80 characters.

Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan_sdio.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan_sdio.c b/drivers/staging/wilc1000/linux_wlan_sdio.c
index 66cdca2..78e6808 100644
--- a/drivers/staging/wilc1000/linux_wlan_sdio.c
+++ b/drivers/staging/wilc1000/linux_wlan_sdio.c
@@ -74,9 +74,11 @@ int wilc_sdio_cmd53(struct wilc *wilc, sdio_cmd53_t *cmd)
 		size = cmd->count;
 
 	if (cmd->read_write) {  /* write */
-		ret = sdio_memcpy_toio(func, cmd->address, (void *)cmd->buffer, size);
+		ret = sdio_memcpy_toio(func, cmd->address,
+				       (void *)cmd->buffer, size);
 	} else {        /* read */
-		ret = sdio_memcpy_fromio(func, (void *)cmd->buffer, cmd->address,  size);
+		ret = sdio_memcpy_fromio(func, (void *)cmd->buffer,
+					 cmd->address,  size);
 	}
 
 	sdio_release_host(func);
@@ -90,7 +92,8 @@ int wilc_sdio_cmd53(struct wilc *wilc, sdio_cmd53_t *cmd)
 	return 1;
 }
 
-static int linux_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
+static int linux_sdio_probe(struct sdio_func *func,
+			    const struct sdio_device_id *id)
 {
 	struct wilc *wilc;
 	int gpio;
@@ -126,7 +129,9 @@ static struct sdio_driver wilc1000_sdio_driver = {
 	.probe		= linux_sdio_probe,
 	.remove		= linux_sdio_remove,
 };
-module_driver(wilc1000_sdio_driver, sdio_register_driver, sdio_unregister_driver);
+module_driver(wilc1000_sdio_driver,
+	      sdio_register_driver,
+	      sdio_unregister_driver);
 MODULE_LICENSE("GPL");
 
 int wilc_sdio_enable_interrupt(struct wilc *dev)
-- 
1.9.1

