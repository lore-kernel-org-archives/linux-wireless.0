Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60649 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab1B0WbE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 17:31:04 -0500
Received: by wyg36 with SMTP id 36so3126865wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 14:31:03 -0800 (PST)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH 5/7] wl12xx: Switch to level trigger interrupts
Date: Mon, 28 Feb 2011 00:30:43 +0200
Message-Id: <1298845845-12191-6-git-send-email-ido@wizery.com>
In-Reply-To: <1298845845-12191-1-git-send-email-ido@wizery.com>
References: <1298845845-12191-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The interrupt of the wl12xx is a level interrupt in nature, since the
interrupt line is not auto-reset. However, since resetting the interrupt
requires bus transactions, this cannot be done from an interrupt
context. Thus, requesting a level interrupt would require to disable the
irq and re-enable it after the HW is acknowledged. Since we now request
a threaded irq, this can also be done by specifying the IRQF_ONESHOT
flag.

Triggering on an edge can be problematic in some platforms, if the
sampling frequency is not sufficient for detecting very frequent
interrupts. In case an interrupt is missed, the driver will hang as the
interrupt line will stay high until it is acknowledged by the driver,
which will never happen.

Fix this by requesting a level triggered interrupt, with the
IRQF_ONESHOT flag.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c |    2 +-
 drivers/net/wireless/wl12xx/spi.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 7ee9d29..a4f6417 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -229,7 +229,7 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	wl->ref_clock = wlan_data->board_ref_clock;
 
 	ret = request_threaded_irq(wl->irq, wl1271_hardirq, wl1271_irq,
-				   IRQF_TRIGGER_RISING,
+				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 				   DRIVER_NAME, wl);
 	if (ret < 0) {
 		wl1271_error("request_irq() failed: %d", ret);
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index df5a00f..18cf017 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -409,7 +409,7 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	}
 
 	ret = request_threaded_irq(wl->irq, wl1271_hardirq, wl1271_irq,
-				   IRQF_TRIGGER_RISING,
+				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 				   DRIVER_NAME, wl);
 	if (ret < 0) {
 		wl1271_error("request_irq() failed: %d", ret);
-- 
1.7.1

