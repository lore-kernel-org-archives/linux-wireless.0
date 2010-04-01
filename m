Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25234 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab0DAIin (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 04:38:43 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/8] wl1271: fix sdio driver name in wl1271_sdio_driver
Date: Thu,  1 Apr 2010 11:38:17 +0300
Message-Id: <1270111104-29549-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
References: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Our SPI driver is called "wl1271_spi" in the driver information structure.
Let's use the same for SDIO so that things are aligned.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_sdio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index abfe75b..d3d6f30 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -255,7 +255,7 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 }
 
 static struct sdio_driver wl1271_sdio_driver = {
-	.name		= "wl1271",
+	.name		= "wl1271_sdio",
 	.id_table	= wl1271_devices,
 	.probe		= wl1271_probe,
 	.remove		= __devexit_p(wl1271_remove),
-- 
1.6.3.3

