Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35658 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbdCXHd1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 03:33:27 -0400
From: Pushkar Jambhlekar <pushkar.iit@gmail.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Pushkar Jambhlekar <pushkar.iit@gmail.com>
Subject: [PATCH] drivers/staging/wilc1000: Removing explicit function tracing using dev_dbg/info
Date: Fri, 24 Mar 2017 13:03:12 +0530
Message-Id: <1490340792-9547-1-git-send-email-pushkar.iit@gmail.com> (sfid-20170324_083402_763872_588B1979)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ftrace can be used to trace functions. Removing function tracing using dev_dbg/info

Signed-off-by: Pushkar Jambhlekar <pushkar.iit@gmail.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index ce6c3b4..0189e3e 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -243,15 +243,11 @@ static void wilc_sdio_disable_interrupt(struct wilc *dev)
 	struct sdio_func *func = container_of(dev->dev, struct sdio_func, dev);
 	int ret;
 
-	dev_dbg(&func->dev, "wilc_sdio_disable_interrupt IN\n");
-
 	sdio_claim_host(func);
 	ret = sdio_release_irq(func);
 	if (ret < 0)
 		dev_err(&func->dev, "can't release sdio_irq, err(%d)\n", ret);
 	sdio_release_host(func);
-
-	dev_info(&func->dev, "wilc_sdio_disable_interrupt OUT\n");
 }
 
 /********************************************
-- 
2.7.4
