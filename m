Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:42264 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508Ab1BGLbB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 06:31:01 -0500
From: juuso.oikarinen@nokia.com
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: Allow wl12xx interrupts to wake up the host
Date: Mon,  7 Feb 2011 13:30:54 +0200
Message-Id: <1297078254-4664-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Currently the wl12xx interrupts are not configured to wake up the host, which
leads to reduced performance.

Add calls to enable waking up the host for the wl12xx irq.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/sdio.c |    2 ++
 drivers/net/wireless/wl12xx/spi.c  |    2 ++
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index d5e8748..fc0235a 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -84,12 +84,14 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 
 static void wl1271_sdio_disable_interrupts(struct wl1271 *wl)
 {
+	disable_irq_wake(wl->irq);
 	disable_irq(wl->irq);
 }
 
 static void wl1271_sdio_enable_interrupts(struct wl1271 *wl)
 {
 	enable_irq(wl->irq);
+	enable_irq_wake(wl->irq);
 }
 
 static void wl1271_sdio_reset(struct wl1271 *wl)
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 0132dad..85ad1bb 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -80,12 +80,14 @@ static struct device *wl1271_spi_wl_to_dev(struct wl1271 *wl)
 
 static void wl1271_spi_disable_interrupts(struct wl1271 *wl)
 {
+	disable_irq_wake(wl->irq);
 	disable_irq(wl->irq);
 }
 
 static void wl1271_spi_enable_interrupts(struct wl1271 *wl)
 {
 	enable_irq(wl->irq);
+	enable_irq_wake(wl->irq);
 }
 
 static void wl1271_spi_reset(struct wl1271 *wl)
-- 
1.7.1

