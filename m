Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59315 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758422Ab0GURew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 13:34:52 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-wireless@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<linux-omap@vger.kernel.org>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	<akpm@linux-foundation.org>, San Mehat <san@google.com>,
	Roger Quadros <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH v2 08/20] wireless: wl1271: take irq info from private board data
Date: Wed, 21 Jul 2010 20:33:42 +0300
Message-Id: <1279733634-21974-9-git-send-email-ohad@wizery.com>
In-Reply-To: <1279733634-21974-1-git-send-email-ohad@wizery.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the hard coded irq information, and instead take
the irq information from the board private data
which is supplied by the sdio function.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/wl1271_sdio.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index 571c6b9..75901a6 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -28,15 +28,14 @@
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/card.h>
+#include <linux/mmc/host.h>
+#include <linux/wl12xx.h>
 #include <plat/gpio.h>
 
 #include "wl1271.h"
 #include "wl12xx_80211.h"
 #include "wl1271_io.h"
 
-
-#define RX71_WL1271_IRQ_GPIO		42
-
 static const struct sdio_device_id wl1271_devices[] = {
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_TI, SDIO_DEVICE_ID_TI_WL1271) },
 	{}
@@ -178,6 +177,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 				  const struct sdio_device_id *id)
 {
 	struct ieee80211_hw *hw;
+	struct wl12xx_platform_data *wlan_data;
 	struct wl1271 *wl;
 	int ret;
 
@@ -197,9 +197,11 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	/* Grab access to FN0 for ELP reg. */
 	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
 
-	wl->irq = gpio_to_irq(RX71_WL1271_IRQ_GPIO);
-	if (wl->irq < 0) {
-		ret = wl->irq;
+	wlan_data = mmc_get_embedded_data(func->card->host);
+	if (wlan_data && wlan_data->irq)
+		wl->irq = wlan_data->irq;
+	else {
+		ret = -EINVAL;
 		wl1271_error("could not get irq!");
 		goto out_free;
 	}
-- 
1.7.0.4

