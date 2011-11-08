Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51555 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab1KHN5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 08:57:06 -0500
Received: by faan17 with SMTP id n17so526432faa.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 05:57:04 -0800 (PST)
From: Eyal Shapira <eyal@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: fix SDIO suspend/resume
Date: Tue,  8 Nov 2011 15:56:55 +0200
Message-Id: <1320760615-19794-1-git-send-email-eyal@wizery.com> (sfid-20111108_145710_528662_4D6E85EC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl1271_suspend/resume() accessed the wrong struct and not wl1271
which caused it to think that wow was enabled when it wasn't.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index ed97f9c..468a505 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -289,7 +289,8 @@ static int wl1271_suspend(struct device *dev)
 	/* Tell MMC/SDIO core it's OK to power down the card
 	 * (if it isn't already), but not to remove it completely */
 	struct sdio_func *func = dev_to_sdio_func(dev);
-	struct wl1271 *wl = sdio_get_drvdata(func);
+	struct wl12xx_sdio_glue *glue = sdio_get_drvdata(func);
+	struct wl1271 *wl = platform_get_drvdata(glue->core);
 	mmc_pm_flag_t sdio_flags;
 	int ret = 0;
 
@@ -324,7 +325,8 @@ out:
 static int wl1271_resume(struct device *dev)
 {
 	struct sdio_func *func = dev_to_sdio_func(dev);
-	struct wl1271 *wl = sdio_get_drvdata(func);
+	struct wl12xx_sdio_glue *glue = sdio_get_drvdata(func);
+	struct wl1271 *wl = platform_get_drvdata(glue->core);
 
 	dev_dbg(dev, "wl1271 resume\n");
 	if (wl->wow_enabled) {
-- 
1.7.4.1

