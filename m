Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:41848 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932387AbcCOJvd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 05:51:33 -0400
From: Leo Kim <leo.kim@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <Chris.Park@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 6/7] staging: wilc1000: removes goto definitions from wilc_wlan_firmware_download
Date: Tue, 15 Mar 2016 18:48:13 +0900
Message-ID: <1458035294-13001-6-git-send-email-leo.kim@atmel.com> (sfid-20160315_105136_621986_3EBE7807)
In-Reply-To: <1458035294-13001-1-git-send-email-leo.kim@atmel.com>
References: <1458035294-13001-1-git-send-email-leo.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes goto definitions from wilc_wlan_firmware_download function.
Goto '_fail_1' feature is error return.
It returns error type directly without result variable replacement as well.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index ca9054a..ea671a9 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -946,10 +946,8 @@ int wilc_wlan_firmware_download(struct wilc *wilc, const u8 *buffer,
 	blksz = BIT(12);
 
 	dma_buffer = kmalloc(blksz, GFP_KERNEL);
-	if (!dma_buffer) {
-		ret = -EIO;
-		goto _fail_1;
-	}
+	if (!dma_buffer)
+		return -EIO;
 
 	offset = 0;
 	do {
@@ -987,8 +985,6 @@ _fail_:
 
 	kfree(dma_buffer);
 
-_fail_1:
-
 	return (ret < 0) ? ret : 0;
 }
 
-- 
1.9.1

