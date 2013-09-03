Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59404 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3ICOeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 10:34:37 -0400
Received: by mail-wg0-f52.google.com with SMTP id m14so3335492wgh.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Sep 2013 07:34:36 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 12/12] wlcore: always register dummy hardirq
Date: Tue,  3 Sep 2013 17:34:08 +0300
Message-Id: <1378218848-7853-12-git-send-email-eliad@wizery.com> (sfid-20130903_163443_122397_16DC7C42)
In-Reply-To: <1378218848-7853-1-git-send-email-eliad@wizery.com>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

This keeps the kernel happy when using edge-irqs and requesting a
threaded irq.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index d952593..a537483 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5997,6 +5997,11 @@ static const struct wiphy_wowlan_support wlcore_wowlan_support = {
 };
 #endif
 
+static irqreturn_t wlcore_hardirq(int irq, void *cookie)
+{
+	return IRQ_WAKE_THREAD;
+}
+
 static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 {
 	struct wl1271 *wl = context;
@@ -6005,6 +6010,7 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	struct wl12xx_platform_data *pdata = pdev_data->pdata;
 	unsigned long irqflags;
 	int ret;
+	irq_handler_t hardirq_fn = NULL;
 
 	if (fw) {
 		wl->nvs = kmemdup(fw->data, fw->size, GFP_KERNEL);
@@ -6033,12 +6039,14 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	wl->platform_quirks = pdata->platform_quirks;
 	wl->if_ops = pdev_data->if_ops;
 
-	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
+	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ) {
 		irqflags = IRQF_TRIGGER_RISING;
-	else
+		hardirq_fn = wlcore_hardirq;
+	} else {
 		irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
+	}
 
-	ret = request_threaded_irq(wl->irq, NULL, wlcore_irq,
+	ret = request_threaded_irq(wl->irq, hardirq_fn, wlcore_irq,
 				   irqflags, pdev->name, wl);
 	if (ret < 0) {
 		wl1271_error("request_irq() failed: %d", ret);
-- 
1.8.3.rc1.35.g9b79519

