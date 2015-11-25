Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:10101 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbbKYC4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2015 21:56:22 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 01/10] staging: wilc1000: fix rmmod failure
Date: Wed, 25 Nov 2015 11:59:40 +0900
Message-ID: <1448420389-4192-1-git-send-email-glen.lee@atmel.com> (sfid-20151125_035626_251911_27166AFE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes rmmod failure. wilc->firmware needs to be set to NULL because
it is used again to check firmware is released when module exit.

Fixes: 8b8ad7bc90bc ("staging: wilc1000: rename wilc_firmware in the struct wilc")
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/linux_wlan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/linux_wlan.c b/drivers/staging/wilc1000/linux_wlan.c
index 7ccc9b0..92ca072 100644
--- a/drivers/staging/wilc1000/linux_wlan.c
+++ b/drivers/staging/wilc1000/linux_wlan.c
@@ -506,6 +506,7 @@ static int wilc1000_firmware_download(struct net_device *dev)
 	PRINT_D(INIT_DBG, "Freeing FW buffer ...\n");
 	PRINT_D(INIT_DBG, "Releasing firmware\n");
 	release_firmware(wilc->firmware);
+	wilc->firmware = NULL;
 
 	PRINT_D(INIT_DBG, "Download Succeeded\n");
 
-- 
1.9.1

