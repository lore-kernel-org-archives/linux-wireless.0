Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:27132 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305AbbIJJ0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 05:26:36 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 2/5] staging: wilc1000: remove firmware definition
Date: Thu, 10 Sep 2015 18:26:27 +0900
Message-ID: <1441877190-4546-2-git-send-email-tony.cho@atmel.com> (sfid-20150910_112638_362617_615CD543)
In-Reply-To: <1441877190-4546-1-git-send-email-tony.cho@atmel.com>
References: <1441877190-4546-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the firmware definitions, STA_FIRMWARE, AP_FIRMWARE, and
P2P_CONCURRENCY_FIRMWARE from the linux_wlan.c file because they are
defined in the Makefile.

Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index df5ee26..8e19095 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -101,18 +101,6 @@ static struct notifier_block g_dev_notifier = {
 		if (g_linux_wlan->oup.wlan_cleanup != NULL) \
 			g_linux_wlan->oup.wlan_cleanup(); }
 
-#ifndef STA_FIRMWARE
-#define STA_FIRMWARE	"wifi_firmware.bin"
-#endif
-
-#ifndef AP_FIRMWARE
-#define AP_FIRMWARE		"wifi_firmware_ap.bin"
-#endif
-
-#ifndef P2P_CONCURRENCY_FIRMWARE
-#define P2P_CONCURRENCY_FIRMWARE	"wifi_firmware_p2p_concurrency.bin"
-#endif
-
 typedef struct android_wifi_priv_cmd {
 	char *buf;
 	int used_len;
-- 
1.9.1

