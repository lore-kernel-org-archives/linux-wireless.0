Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:45631 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753998AbeE1Igu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 04:36:50 -0400
Received: by mail-wr0-f195.google.com with SMTP id w3-v6so18899259wrl.12
        for <linux-wireless@vger.kernel.org>; Mon, 28 May 2018 01:36:50 -0700 (PDT)
From: Eyal Reizer <eyalreizer@gmail.com>
To: kvalo@codeaurora.org, tony@atomide.com, nsekhar@ti.com,
        linux-wireless@vger.kernel.org
Cc: Eyal Reizer <eyalr@ti.com>
Subject: [PATCH v2] wlcore: sdio: check for valid platform device data before suspend
Date: Mon, 28 May 2018 11:36:42 +0300
Message-Id: <1527496602-25214-1-git-send-email-eyalr@ti.com> (sfid-20180528_103705_164323_CB083787)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the wl pointer can be null In case only wlcore_sdio is probed while
no WiLink module is successfully probed, as in the case of mounting a
wl12xx module while using a device tree file configured with wl18xx
related settings.
In this case the system was crashing in wl1271_suspend() as platform
device data is not set.
Make sure wl the pointer is valid before using it.

Signed-off-by: Eyal Reizer <eyalr@ti.com>
---
Changes since v1: Remove extra characters after signed-of-by

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
