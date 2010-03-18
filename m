Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:62426 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab0CRK1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:18 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 03/21] wl1271: Changed SDIO MMC host claiming
Date: Thu, 18 Mar 2010 12:26:28 +0200
Message-Id: <1268908006-16992-4-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Changed driver to keep MMC host claimed while wlan interface is up.
This keeps MMC stack from powering the SDIO device down.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_sdio.c |   27 +++++++++------------------
 1 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index d43e0d4..d9183b6 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -107,7 +107,6 @@ static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
 	int ret;
 	struct sdio_func *func = wl_to_func(wl);
 
-	sdio_claim_host(func);
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		((u8 *)buf)[0] = sdio_f0_readb(func, addr, &ret);
 		wl1271_debug(DEBUG_SPI, "sdio read 52 addr 0x%x, byte 0x%02x",
@@ -126,7 +125,6 @@ static void wl1271_sdio_raw_read(struct wl1271 *wl, int addr, void *buf,
 	if (ret)
 		wl1271_error("sdio read failed (%d)", ret);
 
-	sdio_release_host(func);
 }
 
 static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
@@ -135,7 +133,6 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 	int ret;
 	struct sdio_func *func = wl_to_func(wl);
 
-	sdio_claim_host(func);
 	if (unlikely(addr == HW_ACCESS_ELP_CTRL_REG_ADDR)) {
 		sdio_f0_writeb(func, ((u8 *)buf)[0], addr, &ret);
 		wl1271_debug(DEBUG_SPI, "sdio write 52 addr 0x%x, byte 0x%02x",
@@ -153,11 +150,19 @@ static void wl1271_sdio_raw_write(struct wl1271 *wl, int addr, void *buf,
 	if (ret)
 		wl1271_error("sdio write failed (%d)", ret);
 
-	sdio_release_host(func);
 }
 
 static void wl1271_sdio_set_power(struct wl1271 *wl, bool enable)
 {
+	struct sdio_func *func = wl_to_func(wl);
+
+	if (enable) {
+		sdio_claim_host(func);
+		sdio_enable_func(func);
+	} else {
+		sdio_disable_func(func);
+		sdio_release_host(func);
+	}
 }
 
 static struct wl1271_if_operations sdio_ops = {
@@ -219,22 +224,12 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	if (ret)
 		goto out_irq;
 
-	sdio_claim_host(func);
 	sdio_set_drvdata(func, wl);
 
-	ret = sdio_enable_func(func);
-	if (ret)
-		goto out_release;
-
-	sdio_release_host(func);
-
 	wl1271_notice("initialized");
 
 	return 0;
 
- out_release:
-	sdio_release_host(func);
-
  out_irq:
 	free_irq(wl->irq, wl);
 
@@ -251,10 +246,6 @@ static void __devexit wl1271_remove(struct sdio_func *func)
 
 	ieee80211_unregister_hw(wl->hw);
 
-	sdio_claim_host(func);
-	sdio_disable_func(func);
-	sdio_release_host(func);
-
 	free_irq(wl->irq, wl);
 
 	kfree(wl->target_mem_map);
-- 
1.6.3.3

