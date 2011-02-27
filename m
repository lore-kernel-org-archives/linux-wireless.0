Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:56514 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab1B0WbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 17:31:01 -0500
Received: by wwe15 with SMTP id 15so2539007wwe.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Feb 2011 14:31:00 -0800 (PST)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH 3/7] wl12xx: Change claiming of the SDIO bus
Date: Mon, 28 Feb 2011 00:30:41 +0200
Message-Id: <1298845845-12191-4-git-send-email-ido@wizery.com>
In-Reply-To: <1298845845-12191-1-git-send-email-ido@wizery.com>
References: <1298845845-12191-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SDIO bus is claimed and released for each SDIO transaction. In
addition to the few CPU cycles it takes to claim and release the bus, it
may also cause undesired side effects such as the MMC host stopping its
internal clocks.

Since only the wl12xx_sdio driver drives this SDIO card, it is safe to
claim the SDIO host once (on power on), and release it only when turning
the power off.

This patch was inspired by Juuso Oikarinen's (juuso.oikarinen@nokia.com)
patch "wl12xx: Change claiming of the (SDIO) bus".

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index d5e8748..b9c3747 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -106,8 +106,6 @@ static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
 	int ret;
 	struct sdio_func *func = wl_to_func(wl);
 
-	sdio_claim_host(func);
-
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		((u8 *)buf)[0] = sdio_f0_readb(func, addr, &ret);
 		wl1271_debug(DEBUG_SDIO, "sdio read 52 addr 0x%x, byte 0x%02x",
@@ -123,8 +121,6 @@ static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
 		wl1271_dump_ascii(DEBUG_SDIO, "data: ", buf, len);
 	}
 
-	sdio_release_host(func);
-
 	if (ret)
 		wl1271_error("sdio read failed (%d)", ret);
 }
@@ -135,8 +131,6 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 	int ret;
 	struct sdio_func *func = wl_to_func(wl);
 
-	sdio_claim_host(func);
-
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		sdio_f0_writeb(func, ((u8 *)buf)[0], addr, &ret);
 		wl1271_debug(DEBUG_SDIO, "sdio write 52 addr 0x%x, byte 0x%02x",
@@ -152,8 +146,6 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 			ret = sdio_memcpy_toio(func, addr, buf, len);
 	}
 
-	sdio_release_host(func);
-
 	if (ret)
 		wl1271_error("sdio write failed (%d)", ret);
 }
@@ -170,7 +162,6 @@ static int wl1271_sdio_power_on(struct wl1271 *wl)
 
 	sdio_claim_host(func);
 	sdio_enable_func(func);
-	sdio_release_host(func);
 
 out:
 	return ret;
@@ -180,7 +171,6 @@ static int wl1271_sdio_power_off(struct wl1271 *wl)
 {
 	struct sdio_func *func = wl_to_func(wl);
 
-	sdio_claim_host(func);
 	sdio_disable_func(func);
 	sdio_release_host(func);
 
-- 
1.7.1

