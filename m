Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:50980 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737Ab3AWOle (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 09:41:34 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id r0NEfXWA019091
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 08:41:33 -0600
Received: from DLEE74.ent.ti.com (dlee74.ent.ti.com [157.170.170.8])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r0NEfXLj025796
	for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 08:41:33 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH 1/5] wlcore: remove unused set_power method
Date: Wed, 23 Jan 2013 16:40:34 +0200
Message-ID: <1358952038-5982-2-git-send-email-coelho@ti.com> (sfid-20130123_154137_908322_1E80F322)
In-Reply-To: <1358952038-5982-1-git-send-email-coelho@ti.com>
References: <1358952038-5982-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no platform-specific set_power method anymore.  Power setting
is done in the bus modules (wlcore_sdio and wlcore_spi).

Signed-off-by: Luciano Coelho <coelho@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c   |    1 -
 drivers/net/wireless/ti/wlcore/wlcore.h |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d42b580..9473cbb 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5998,7 +5998,6 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 
 	wl->irq = platform_get_irq(pdev, 0);
 	wl->platform_quirks = pdata->platform_quirks;
-	wl->set_power = pdata->set_power;
 	wl->if_ops = pdata->ops;
 
 	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index ebd8c6f..af9feca 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -183,7 +183,6 @@ struct wl1271 {
 
 	struct wl1271_if_operations *if_ops;
 
-	void (*set_power)(bool enable);
 	int irq;
 
 	spinlock_t wl_lock;
-- 
1.7.10.4

