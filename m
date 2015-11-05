Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:26979 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030300AbbKEFgS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 00:36:18 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH RESEND 29/38] staging: wilc1000: remove goto from linux_wlan_start_firmware
Date: Thu, 5 Nov 2015 14:36:30 +0900
Message-ID: <1446701799-24870-29-git-send-email-glen.lee@atmel.com> (sfid-20151105_063756_645905_F259D402)
In-Reply-To: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
References: <1446701799-24870-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch remove goto feature from linux_wlan_start_firmware function.
Goto feature is return result.
So, remove goto functions and it was replaced with the return value directly.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 893c741..fcc8119 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -529,19 +529,18 @@ static int linux_wlan_start_firmware(struct net_device *dev)
 	ret = wilc_wlan_start();
 	if (ret < 0) {
 		PRINT_ER("Failed to start Firmware\n");
-		goto _fail_;
+		return ret;
 	}
 
 	PRINT_D(INIT_DBG, "Waiting for Firmware to get ready ...\n");
 	ret = linux_wlan_lock_timeout(&wilc->sync_event, 5000);
 	if (ret) {
 		PRINT_D(INIT_DBG, "Firmware start timed out");
-		goto _fail_;
+		return ret;
 	}
 	PRINT_D(INIT_DBG, "Firmware successfully started\n");
 
-_fail_:
-	return ret;
+	return 0;
 }
 static int linux_wlan_firmware_download(struct net_device *dev)
 {
-- 
1.9.1

