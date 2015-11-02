Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:7827 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbbKBIvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 03:51:14 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 30/38] staging: wilc1000: remove goto from linux_wlan_firmware_download
Date: Mon, 2 Nov 2015 17:51:13 +0900
Message-ID: <1446454281-22484-30-git-send-email-glen.lee@atmel.com> (sfid-20151102_101655_784496_49C0D399)
In-Reply-To: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
References: <1446454281-22484-1-git-send-email-glen.lee@atmel.com>
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
 drivers/staging/wilc1000/linux_wlan.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index f091a3c..aaa938f 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -558,14 +558,13 @@ static int linux_wlan_firmware_download(struct net_device *dev)
 
 	if (!wilc->firmware) {
 		PRINT_ER("Firmware buffer is NULL\n");
-		ret = -ENOBUFS;
-		goto _FAIL_;
+		return -ENOBUFS;
 	}
 	PRINT_D(INIT_DBG, "Downloading Firmware ...\n");
 	ret = wilc_wlan_firmware_download(dev, wilc->firmware->data,
 					  wilc->firmware->size);
 	if (ret < 0)
-		goto _FAIL_;
+		return ret;
 
 	PRINT_D(INIT_DBG, "Freeing FW buffer ...\n");
 	PRINT_D(INIT_DBG, "Releasing firmware\n");
@@ -573,7 +572,6 @@ static int linux_wlan_firmware_download(struct net_device *dev)
 
 	PRINT_D(INIT_DBG, "Download Succeeded\n");
 
-_FAIL_:
 	return ret;
 }
 
-- 
1.9.1

