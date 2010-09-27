Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56035 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932845Ab0I0IiZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:25 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8bvwh023998
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:38:23 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 11/25] wl1271: Release interrupt *after* releasing the driver context
Date: Mon, 27 Sep 2010 11:37:35 +0300
Message-Id: <1285576669-8070-12-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The current order causes driver releasing to fail in various ways, and causes
possible instability.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_sdio.c |    3 +--
 drivers/net/wireless/wl12xx/wl1271_spi.c  |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index f2f0466..4c250d7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -274,9 +274,8 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 {
 	struct wl1271 *wl = sdio_get_drvdata(func);
 
-	free_irq(wl->irq, wl);
-
 	wl1271_unregister_hw(wl);
+	free_irq(wl->irq, wl);
 	wl1271_free_hw(wl);
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index ced0a9e..75cbf36 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -416,9 +416,8 @@ static int __devexit wl1271_remove(struct spi_device *spi)
 {
 	struct wl1271 *wl = dev_get_drvdata(&spi->dev);
 
-	free_irq(wl->irq, wl);
-
 	wl1271_unregister_hw(wl);
+	free_irq(wl->irq, wl);
 	wl1271_free_hw(wl);
 
 	return 0;
-- 
1.6.3.3

