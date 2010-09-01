Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34781 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983Ab0IAV2E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 17:28:04 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>, Ido Yariv <ido@wizery.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Russell King <linux@arm.linux.org.uk>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v5 4/7] wireless: wl1271: take irq info from private board data
Date: Thu,  2 Sep 2010 00:26:47 +0300
Message-Id: <1283376410-9999-5-git-send-email-ohad@wizery.com>
In-Reply-To: <1283376410-9999-1-git-send-email-ohad@wizery.com>
References: <1283376410-9999-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the hard coded irq information, and instead take
the irq information from the board's platform data.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_sdio.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index c41293a..7f4461c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -29,14 +29,12 @@
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/card.h>
 #include <linux/gpio.h>
+#include <linux/wl12xx.h>
 
 #include "wl1271.h"
 #include "wl12xx_80211.h"
 #include "wl1271_io.h"
 
-
-#define RX71_WL1271_IRQ_GPIO		42
-
 #ifndef SDIO_VENDOR_ID_TI
 #define SDIO_VENDOR_ID_TI		0x0097
 #endif
@@ -186,6 +184,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 				  const struct sdio_device_id *id)
 {
 	struct ieee80211_hw *hw;
+	struct wl12xx_platform_data wlan_data;
 	struct wl1271 *wl;
 	int ret;
 
@@ -205,13 +204,14 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	/* Grab access to FN0 for ELP reg. */
 	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
 
-	wl->irq = gpio_to_irq(RX71_WL1271_IRQ_GPIO);
-	if (wl->irq < 0) {
-		ret = wl->irq;
-		wl1271_error("could not get irq!");
+	ret = wl12xx_get_platform_data(&wlan_data);
+	if (ret) {
+		wl1271_error("missing wlan data (needed for irq/ref_clk)!");
 		goto out_free;
 	}
 
+	wl->irq = wlan_data.irq;
+
 	ret = request_irq(wl->irq, wl1271_irq, 0, DRIVER_NAME, wl);
 	if (ret < 0) {
 		wl1271_error("request_irq() failed: %d", ret);
-- 
1.7.0.4

