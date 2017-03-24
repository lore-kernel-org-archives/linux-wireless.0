Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34206 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932085AbdCXEjC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 00:39:02 -0400
From: Pushkar Jambhlekar <pushkar.iit@gmail.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org (open list:STAGING - WILC1000 WIFI
        DRIVER), devel@driverdev.osuosl.org (open list:STAGING SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list),
        Pushkar Jambhlekar <pushkar.iit@gmail.com>
Subject: [PATCH] drivers/staging/wilc1000: Fixing dev_err and removing dev_dbg calls for tracing
Date: Fri, 24 Mar 2017 10:08:41 +0530
Message-Id: <1490330321-7004-1-git-send-email-pushkar.iit@gmail.com> (sfid-20170324_054030_831790_3E5EBF08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dev_err: replacing function name with '%s' and __func__
dev_dbg: Removing calls which are used for tracing a function.

Signed-off-by: Pushkar Jambhlekar <pushkar.iit@gmail.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index ad4eb0f..20dbc21 100644
--- a/drivers/staging/wilc1000/wilc_sdio.c
+++ b/drivers/staging/wilc1000/wilc_sdio.c
@@ -74,7 +74,7 @@ static int wilc_sdio_cmd52(struct wilc *wilc, struct sdio_cmd52 *cmd)
 	sdio_release_host(func);
 
 	if (ret)
-		dev_err(&func->dev, "wilc_sdio_cmd52..failed, err(%d)\n", ret);
+		dev_err(&func->dev, "%s..failed, err(%d)\n", __func__, ret);
 	return ret;
 }
 
@@ -103,7 +103,7 @@ static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53 *cmd)
 	sdio_release_host(func);
 
 	if (ret)
-		dev_err(&func->dev, "wilc_sdio_cmd53..failed, err(%d)\n", ret);
+		dev_err(&func->dev, "%s..failed, err(%d)\n", __func__, ret);
 
 	return ret;
 }
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
