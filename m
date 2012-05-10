Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46680 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747Ab2EJJQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:16:03 -0400
Received: by mail-wi0-f170.google.com with SMTP id hm4so231590wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:16:02 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 42/78] wl18xx: don't upload NVS to FW
Date: Thu, 10 May 2012 12:13:47 +0300
Message-Id: <1336641263-5761-43-git-send-email-arik@wizery.com> (sfid-20120510_112122_639042_E1EF315C)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In this chip family the NVS file should not be uploaded to FW. In fact,
we encounter strange bugs (sdio errors) when trying to upload it with
certain parameters.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl18xx/main.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index a8b9cea..ddd11d0 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -755,10 +755,6 @@ static int wl18xx_boot(struct wl1271 *wl)
 	if (ret < 0)
 		goto out;
 
-	ret = wlcore_boot_upload_nvs(wl);
-	if (ret < 0)
-		goto out;
-
 	wl18xx_pre_upload(wl);
 
 	ret = wlcore_boot_upload_firmware(wl);
-- 
1.7.9.5

