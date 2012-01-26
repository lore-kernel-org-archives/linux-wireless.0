Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:63379 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2AZMJY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:09:24 -0500
Received: by werb13 with SMTP id b13so321544wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:09:23 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] Revert "wl12xx: Change claiming of the SDIO bus"
Date: Thu, 26 Jan 2012 14:12:31 +0200
Message-Id: <1327579952-4595-1-git-send-email-eliad@wizery.com> (sfid-20120126_130927_536256_21799CDA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 393fb560d328cc06e6a5c7b7473901ad724f82e7.

Commit b6ad726 ("mmc: core: Prevent too long response times
for suspend") fails the suspend if the mmc host can't be
claimed before suspend. As the host is claimed by us as long
as the chip is powered on, suspend will always fail.

Revert to claiming the sdio bus only when needed.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index 468a505..099c2c9 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -74,6 +74,8 @@ static void wl12xx_sdio_raw_read(struct device *child, int addr, void *buf,
 	struct wl12xx_sdio_glue *glue = dev_get_drvdata(child->parent);
 	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 
+	sdio_claim_host(func);
+
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		((u8 *)buf)[0] = sdio_f0_readb(func, addr, &ret);
 		dev_dbg(child->parent, "sdio read 52 addr 0x%x, byte 0x%02x\n",
@@ -88,6 +90,8 @@ static void wl12xx_sdio_raw_read(struct device *child, int addr, void *buf,
 			addr, len);
 	}
 
+	sdio_release_host(func);
+
 	if (ret)
 		dev_err(child->parent, "sdio read failed (%d)\n", ret);
 }
@@ -99,6 +103,8 @@ static void wl12xx_sdio_raw_write(struct device *child, int addr, void *buf,
 	struct wl12xx_sdio_glue *glue = dev_get_drvdata(child->parent);
 	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 
+	sdio_claim_host(func);
+
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		sdio_f0_writeb(func, ((u8 *)buf)[0], addr, &ret);
 		dev_dbg(child->parent, "sdio write 52 addr 0x%x, byte 0x%02x\n",
@@ -113,6 +119,8 @@ static void wl12xx_sdio_raw_write(struct device *child, int addr, void *buf,
 			ret = sdio_memcpy_toio(func, addr, buf, len);
 	}
 
+	sdio_release_host(func);
+
 	if (ret)
 		dev_err(child->parent, "sdio write failed (%d)\n", ret);
 }
@@ -136,6 +144,7 @@ static int wl12xx_sdio_power_on(struct wl12xx_sdio_glue *glue)
 
 	sdio_claim_host(func);
 	sdio_enable_func(func);
+	sdio_release_host(func);
 
 out:
 	return ret;
@@ -146,6 +155,7 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
 	int ret;
 	struct sdio_func *func = dev_to_sdio_func(glue->dev);
 
+	sdio_claim_host(func);
 	sdio_disable_func(func);
 	sdio_release_host(func);
 
-- 
1.7.6.401.g6a319

