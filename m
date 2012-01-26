Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63379 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2AZMJZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:09:25 -0500
Received: by mail-we0-f174.google.com with SMTP id b13so321544wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:09:25 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] wl12xx: don't release/claim sdio on suspend/resume
Date: Thu, 26 Jan 2012 14:12:32 +0200
Message-Id: <1327579952-4595-2-git-send-email-eliad@wizery.com> (sfid-20120126_130929_074395_F1394E54)
In-Reply-To: <1327579952-4595-1-git-send-email-eliad@wizery.com>
References: <1327579952-4595-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we reverted to claiming the host only when needed,
we no longer need to release/claim the host on suspend/resume.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 099c2c9..ce3b9a9 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -324,9 +324,6 @@ static int wl1271_suspend(struct device *dev)
 			dev_err(dev, "error while trying to keep power\n");
 			goto out;
 		}
-
-		/* release host */
-		sdio_release_host(func);
 	}
 out:
 	return ret;
@@ -334,15 +331,7 @@ out:
 
 static int wl1271_resume(struct device *dev)
 {
-	struct sdio_func *func = dev_to_sdio_func(dev);
-	struct wl12xx_sdio_glue *glue = sdio_get_drvdata(func);
-	struct wl1271 *wl = platform_get_drvdata(glue->core);
-
 	dev_dbg(dev, "wl1271 resume\n");
-	if (wl->wow_enabled) {
-		/* claim back host */
-		sdio_claim_host(func);
-	}
 
 	return 0;
 }
-- 
1.7.6.401.g6a319

