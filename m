Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26998 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030300AbbKEFgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:36:23 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 30/38] staging: wilc1000: remove goto from linux_wlan_firmware_download
Date: Thu, 5 Nov 2015 14:36:31 +0900
Message-ID: <1446701799-24870-30-git-send-email-glen.lee@atmel.com> (sfid-20151105_063757_237173_58439D78)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch remove goto feature from linux_wlan_firmware_download function.
Goto feature is return result.
So, remove goto functions and it was replaced with the return value directly.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index fcc8119..003165d 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -553,14 +553,13 @@ static int linux_wlan_firmware_download(struct net_device *dev)
 
 	if (!wilc->firmware) {
 		PRINT_ER("Firmware buffer is NULL\n");
-		ret = -ENOBUFS;
-		goto _FAIL_;
+		return -ENOBUFS;
 	}
 	PRINT_D(INIT_DBG, "Downloading Firmware ...\n");
 	ret = wilc_wlan_firmware_download(wilc->firmware->data,
 					  wilc->firmware->size);
 	if (ret < 0)
-		goto _FAIL_;
+		return ret;
 
 	PRINT_D(INIT_DBG, "Freeing FW buffer ...\n");
 	PRINT_D(INIT_DBG, "Releasing firmware\n");
@@ -568,8 +567,7 @@ static int linux_wlan_firmware_download(struct net_device *dev)
 
 	PRINT_D(INIT_DBG, "Download Succeeded\n");
 
-_FAIL_:
-	return ret;
+	return 0;
 }
 
 static int linux_wlan_init_test_config(struct net_device *dev, struct wilc *p_nic)
-- 
1.9.1

