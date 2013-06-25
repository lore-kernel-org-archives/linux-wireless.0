Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60337 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab3FYUdf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 16:33:35 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, <tony@atomide.com>
Subject: [PATCH 4/5] wlcore: always use one-shot IRQ
Date: Tue, 25 Jun 2013 23:33:25 +0300
Message-ID: <1372192406-29430-5-git-send-email-coelho@ti.com> (sfid-20130625_224130_818664_C04B9A6C)
In-Reply-To: <1372192406-29430-1-git-send-email-coelho@ti.com>
References: <1372192406-29430-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we are now using threaded IRQs without the primary handler, we
need to set IRQF_ONESHOT, otherwise our request will fail.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d306cd5..bc1cff3 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5927,7 +5927,8 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 
 	wl->irq = platform_get_irq(pdev, 0);
 	wl->if_ops = pdev_data->if_ops;
-	wl->irq_flags = pdata->irq_flags;
+	/* Since we don't use the primary handler, we must set ONESHOT */
+	wl->irq_flags = pdata->irq_flags | IRQF_ONESHOT;
 
 	ret = request_threaded_irq(wl->irq, NULL, wlcore_irq,
 				   wl->irq_flags, pdev->name, wl);
-- 
1.7.10.4

