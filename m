Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:37664 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967464AbeEXLfp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 07:35:45 -0400
Received: by mail-wr0-f194.google.com with SMTP id i12-v6so2488948wrc.4
        for <linux-wireless@vger.kernel.org>; Thu, 24 May 2018 04:35:44 -0700 (PDT)
From: Eyal Reizer <eyalreizer@gmail.com>
To: kvalo@codeaurora.org, tony@atomide.com, nsekhar@ti.com,
        linux-wireless@vger.kernel.org
Cc: Eyal Reizer <eyalr@ti.com>
Subject: [PATCH] wlcore: sdio: check for valid platform device data before suspend
Date: Thu, 24 May 2018 14:35:30 +0300
Message-Id: <1527161730-9044-1-git-send-email-eyalr@ti.com> (sfid-20180524_133621_141069_FD03788D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the wl pointer can be null In case only wlcore_sdio is probed while
no WiLink module is successfully probed, as in the case of mounting a
wl12xx module while using a device tree file configured with wl18xx
related settings.
In this case the system was crashing in wl1271_suspend() as platform
device data is not set.
Make sure wl the pointer is valid before using it.

Signed-off-by: Eyal Reizer <eyalr@ti.com>mamai
---
 drivers/net/wireless/ti/wlcore/sdio.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index da701cd..aec6225 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -406,6 +406,11 @@ static int wl1271_suspend(struct device *dev)
 	mmc_pm_flag_t sdio_flags;
 	int ret = 0;
 
+	if (!wl) {
+		dev_err(dev, "no wilink module was probed\n");
+		goto out;
+	}
+
 	dev_dbg(dev, "wl1271 suspend. wow_enabled: %d\n",
 		wl->wow_enabled);
 
-- 
2.7.4
