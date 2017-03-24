Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36131 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752086AbdCXH27 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Mar 2017 03:28:59 -0400
From: Pushkar Jambhlekar <pushkar.iit@gmail.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Pushkar Jambhlekar <pushkar.iit@gmail.com>
Subject: [PATCH] drivers/staging/wilc1000: Using __func__ instead of hardcoded function name
Date: Fri, 24 Mar 2017 12:58:45 +0530
Message-Id: <1490340525-9458-1-git-send-email-pushkar.iit@gmail.com> (sfid-20170324_082920_851702_36B1437C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dev_err: replacing hardcoded function name with '%s' and __func__

Signed-off-by: Pushkar Jambhlekar <pushkar.iit@gmail.com>
---
 drivers/staging/wilc1000/wilc_sdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_sdio.c b/drivers/staging/wilc1000/wilc_sdio.c
index ad4eb0f..ce6c3b4 100644
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
+		dev_err(&func->dev, "%s..failed, err(%d)\n", __func__,  ret);
 
 	return ret;
 }
-- 
2.7.4
