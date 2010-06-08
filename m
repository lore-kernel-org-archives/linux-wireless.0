Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47498 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0FHLd5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jun 2010 07:33:57 -0400
Received: by wyi11 with SMTP id 11so3108975wyi.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jun 2010 04:33:55 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH v2] wl1251: fix ELP_CTRL register reads
Date: Tue,  8 Jun 2010 14:33:31 +0300
Message-Id: <1275996811-2475-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reading the ELP_CTRL register with sdio_readb causes problems because
hardware seems to be performing a write using stuff bits in the request
(those bits contain write data in write request). This indicates that it
actually expects RAW (read after write) type of request, so perform that
when reading ELP_CTRL instead. Also cache last written value so we know
what to write when doing RAW request.

Because of the above it was not possible to wake the chip from ELP power
saving mode, PM had to be disabled to have the driver usable in SDIO
mode. After this patch PM is functional.

For backporting to 2.6.34 or earlier, this patch depends on
6c1f716e8154ee9315534782b9b1eedea0559a24, which adds the
required SDIO funcion.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Acked-by: Kalle Valo <kvalo@adurom.com>
---
This is the same as previous version, just updated the commit message.

 drivers/net/wireless/wl12xx/wl1251_sdio.c |   40 ++++++++++++++++++++++++----
 1 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_sdio.c b/drivers/net/wireless/wl12xx/wl1251_sdio.c
index c561332..b901b61 100644
--- a/drivers/net/wireless/wl12xx/wl1251_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1251_sdio.c
@@ -37,11 +37,17 @@
 #define SDIO_DEVICE_ID_TI_WL1251	0x9066
 #endif
 
+struct wl1251_sdio {
+	struct sdio_func *func;
+	u32 elp_val;
+};
+
 static struct wl12xx_platform_data *wl12xx_board_data;
 
 static struct sdio_func *wl_to_func(struct wl1251 *wl)
 {
-	return wl->if_priv;
+	struct wl1251_sdio *wl_sdio = wl->if_priv;
+	return wl_sdio->func;
 }
 
 static void wl1251_sdio_interrupt(struct sdio_func *func)
@@ -90,10 +96,17 @@ static void wl1251_sdio_write(struct wl1251 *wl, int addr,
 static void wl1251_sdio_read_elp(struct wl1251 *wl, int addr, u32 *val)
 {
 	int ret = 0;
-	struct sdio_func *func = wl_to_func(wl);
-
+	struct wl1251_sdio *wl_sdio = wl->if_priv;
+	struct sdio_func *func = wl_sdio->func;
+
+	/*
+	 * The hardware only supports RAW (read after write) access for
+	 * reading, regular sdio_readb won't work here (it interprets
+	 * the unused bits of CMD52 as write data even if we send read
+	 * request).
+	 */
 	sdio_claim_host(func);
-	*val = sdio_readb(func, addr, &ret);
+	*val = sdio_writeb_readb(func, wl_sdio->elp_val, addr, &ret);
 	sdio_release_host(func);
 
 	if (ret)
@@ -103,7 +116,8 @@ static void wl1251_sdio_read_elp(struct wl1251 *wl, int addr, u32 *val)
 static void wl1251_sdio_write_elp(struct wl1251 *wl, int addr, u32 val)
 {
 	int ret = 0;
-	struct sdio_func *func = wl_to_func(wl);
+	struct wl1251_sdio *wl_sdio = wl->if_priv;
+	struct sdio_func *func = wl_sdio->func;
 
 	sdio_claim_host(func);
 	sdio_writeb(func, val, addr, &ret);
@@ -111,6 +125,8 @@ static void wl1251_sdio_write_elp(struct wl1251 *wl, int addr, u32 val)
 
 	if (ret)
 		wl1251_error("sdio_writeb failed (%d)", ret);
+	else
+		wl_sdio->elp_val = val;
 }
 
 static void wl1251_sdio_reset(struct wl1251 *wl)
@@ -197,6 +213,7 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 	int ret;
 	struct wl1251 *wl;
 	struct ieee80211_hw *hw;
+	struct wl1251_sdio *wl_sdio;
 
 	hw = wl1251_alloc_hw();
 	if (IS_ERR(hw))
@@ -204,6 +221,12 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 
 	wl = hw->priv;
 
+	wl_sdio = kzalloc(sizeof(*wl_sdio), GFP_KERNEL);
+	if (wl_sdio == NULL) {
+		ret = -ENOMEM;
+		goto out_free_hw;
+	}
+
 	sdio_claim_host(func);
 	ret = sdio_enable_func(func);
 	if (ret)
@@ -213,7 +236,8 @@ static int wl1251_sdio_probe(struct sdio_func *func,
 	sdio_release_host(func);
 
 	SET_IEEE80211_DEV(hw, &func->dev);
-	wl->if_priv = func;
+	wl_sdio->func = func;
+	wl->if_priv = wl_sdio;
 	wl->if_ops = &wl1251_sdio_ops;
 	wl->set_power = wl1251_sdio_set_power;
 
@@ -259,6 +283,8 @@ disable:
 	sdio_disable_func(func);
 release:
 	sdio_release_host(func);
+	kfree(wl_sdio);
+out_free_hw:
 	wl1251_free_hw(wl);
 	return ret;
 }
@@ -266,9 +292,11 @@ release:
 static void __devexit wl1251_sdio_remove(struct sdio_func *func)
 {
 	struct wl1251 *wl = sdio_get_drvdata(func);
+	struct wl1251_sdio *wl_sdio = wl->if_priv;
 
 	if (wl->irq)
 		free_irq(wl->irq, wl);
+	kfree(wl_sdio);
 	wl1251_free_hw(wl);
 
 	sdio_claim_host(func);
-- 
1.7.0.2

