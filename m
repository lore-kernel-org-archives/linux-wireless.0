Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4413 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933AbZDVDow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 23:44:52 -0400
From: Bob Copeland <me@bobcopeland.com>
To: kalle.valo@nokia.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/3] wl12xx: remove struct platform device
Date: Tue, 21 Apr 2009 23:44:20 -0400
Message-Id: <1240371860-9001-3-git-send-email-me@bobcopeland.com> (sfid-20090422_054521_385116_B13B81D9)
In-Reply-To: <1240371860-9001-1-git-send-email-me@bobcopeland.com>
References: <1240371860-9001-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As far as I can tell this was only for the sysfs file, so now
that it's gone we can kill the wl12xx_device struct.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/acx.c  |    1 -
 drivers/net/wireless/wl12xx/cmd.c  |    1 -
 drivers/net/wireless/wl12xx/main.c |   31 ++-----------------------------
 drivers/net/wireless/wl12xx/spi.c  |    1 -
 4 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index b90310d..be01417 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1,7 +1,6 @@
 #include "acx.h"
 
 #include <linux/module.h>
-#include <linux/platform_device.h>
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
 
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 93eb843..2f07bf2 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1,7 +1,6 @@
 #include "cmd.h"
 
 #include <linux/module.h>
-#include <linux/platform_device.h>
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7f2da39..0bfa3da 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/firmware.h>
 #include <linux/delay.h>
@@ -1103,21 +1102,6 @@ static int wl12xx_init_ieee80211(struct wl12xx *wl)
 	return 0;
 }
 
-static void wl12xx_device_release(struct device *dev)
-{
-
-}
-
-static struct platform_device wl12xx_device = {
-	.name		= "wl12xx",
-	.id		= -1,
-
-	/* device model insists to have a release function */
-	.dev            = {
-		.release = wl12xx_device_release,
-	},
-};
-
 #define WL12XX_DEFAULT_CHANNEL 1
 static int __devinit wl12xx_probe(struct spi_device *spi)
 {
@@ -1238,20 +1222,13 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 
 	disable_irq(gpio_to_irq(wl->config->irq_gpio));
 
-	ret = platform_device_register(&wl12xx_device);
-	if (ret) {
-		wl12xx_error("couldn't register platform device");
-		goto out_irq;
-	}
-	dev_set_drvdata(&wl12xx_device.dev, wl);
-
 	ret = wl12xx_init_ieee80211(wl);
 	if (ret)
-		goto out_platform;
+		goto out_irq;
 
 	ret = wl12xx_register_hw(wl);
 	if (ret)
-		goto out_platform;
+		goto out_irq;
 
 	ret = wl12xx_nl_register();
 	if (ret)
@@ -1265,9 +1242,6 @@ static int __devinit wl12xx_probe(struct spi_device *spi)
 	ieee80211_unregister_hw(hw);
 	wl->mac80211_registered = false;
 
- out_platform:
-	platform_device_unregister(&wl12xx_device);
-
  out_irq:
 	free_irq(gpio_to_irq(wl->config->irq_gpio), wl);
 
@@ -1288,7 +1262,6 @@ static int __devexit wl12xx_remove(struct spi_device *spi)
 	struct wl12xx *wl = dev_get_drvdata(&spi->dev);
 
 	ieee80211_unregister_hw(wl->hw);
-	platform_device_unregister(&wl12xx_device);
 	free_irq(gpio_to_irq(wl->config->irq_gpio), wl);
 	gpio_free(wl->config->power_gpio);
 	gpio_free(wl->config->irq_gpio);
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 939aae7..4b4688e 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -22,7 +22,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/platform_device.h>
 #include <linux/crc7.h>
 #include <linux/spi/spi.h>
 
-- 
1.6.0.6


