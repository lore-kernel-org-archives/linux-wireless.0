Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:45527 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759160Ab1JFTLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 15:11:21 -0400
Received: by mail-bw0-f49.google.com with SMTP id t2so4418851bka.8
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 12:11:19 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/8] wl12xx: add platform driver to the core module
Date: Thu,  6 Oct 2011 22:10:56 +0300
Message-Id: <1317928259-26437-6-git-send-email-coelho@ti.com> (sfid-20111006_211132_190254_B5497C7D)
In-Reply-To: <1317928259-26437-1-git-send-email-coelho@ti.com>
References: <1317928259-26437-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felipe Balbi <balbi@ti.com>

Nnow that we have a platform_device on both glue layers, add a
platform_driver to the core driver.

It's currently an empty platform_driver but more functionality will be
added on later patches.

Signed-off-by: Felipe Balbi <balbi@ti.com>
[forward-ported, cleaned-up and rephrased commit message]
[added platform_driver.driver initialization]
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |   39 ++++++++++++++++++++++++++++++++++++
 1 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 194d7cc..84904bd 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -5041,6 +5041,45 @@ int wl1271_free_hw(struct wl1271 *wl)
 }
 EXPORT_SYMBOL_GPL(wl1271_free_hw);
 
+static int __devinit wl12xx_probe(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int __devexit wl12xx_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static const struct platform_device_id wl12xx_id_table[] __devinitconst = {
+	{ "wl12xx-sdio", 0 },
+	{ "wl12xx-spi", 0 },
+	{  } /* Terminating Entry */
+};
+MODULE_DEVICE_TABLE(platform, wl12xx_id_table);
+
+static struct platform_driver wl12xx_driver = {
+	.probe		= wl12xx_probe,
+	.remove		= __devexit_p(wl12xx_remove),
+	.id_table	= wl12xx_id_table,
+	.driver = {
+		.name	= "wl12xx",
+		.owner	= THIS_MODULE,
+	}
+};
+
+static int __init wl12xx_init(void)
+{
+	return platform_driver_register(&wl12xx_driver);
+}
+module_init(wl12xx_init);
+
+static void __exit wl12xx_exit(void)
+{
+	platform_driver_unregister(&wl12xx_driver);
+}
+module_exit(wl12xx_exit);
+
 u32 wl12xx_debug_level = DEBUG_NONE;
 EXPORT_SYMBOL_GPL(wl12xx_debug_level);
 module_param_named(debug_level, wl12xx_debug_level, uint, S_IRUSR | S_IWUSR);
-- 
1.7.1

