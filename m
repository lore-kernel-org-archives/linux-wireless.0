Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:53403 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482Ab0CLK2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 05:28:49 -0500
Received: by fg-out-1718.google.com with SMTP id 16so470437fgg.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Mar 2010 02:28:47 -0800 (PST)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/4 v2] wl1251: make local symbols static
Date: Fri, 12 Mar 2010 12:28:41 +0200
Message-Id: <1268389721-3375-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make local functions and data static, also constify
some structures. While at it, clean up unneeded includes.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>
---
John, I haven't added you to 'To:' when sent patches 2-4 of this
series as SubmittingPatches requires (sent to the mailing list
only), let me know in case I need to resend them.

 drivers/net/wireless/wl12xx/wl1251_sdio.c |   24 +++++++++---------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_sdio.c b/drivers/net/wireless/wl12xx/wl1251_sdio.c
index 9423f22..cfca232 100644
--- a/drivers/net/wireless/wl12xx/wl1251_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1251_sdio.c
@@ -20,20 +20,11 @@
  * Copyright (C) 2009 Bob Copeland (me@bobcopeland.com)
  */
 #include <linux/module.h>
-#include <linux/crc7.h>
 #include <linux/mod_devicetable.h>
-#include <linux/irq.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
-#include <linux/platform_device.h>
 
 #include "wl1251.h"
-#include "wl12xx_80211.h"
-#include "wl1251_reg.h"
-#include "wl1251_ps.h"
-#include "wl1251_io.h"
-#include "wl1251_tx.h"
-#include "wl1251_debugfs.h"
 
 #ifndef SDIO_VENDOR_ID_TI
 #define SDIO_VENDOR_ID_TI		0x104c
@@ -65,7 +56,8 @@ static const struct sdio_device_id wl1251_devices[] = {
 MODULE_DEVICE_TABLE(sdio, wl1251_devices);
 
 
-void wl1251_sdio_read(struct wl1251 *wl, int addr, void *buf, size_t len)
+static void wl1251_sdio_read(struct wl1251 *wl, int addr,
+			     void *buf, size_t len)
 {
 	int ret;
 	struct sdio_func *func = wl_to_func(wl);
@@ -77,7 +69,8 @@ void wl1251_sdio_read(struct wl1251 *wl, int addr, void *buf, size_t len)
 	sdio_release_host(func);
 }
 
-void wl1251_sdio_write(struct wl1251 *wl, int addr, void *buf, size_t len)
+static void wl1251_sdio_write(struct wl1251 *wl, int addr,
+			      void *buf, size_t len)
 {
 	int ret;
 	struct sdio_func *func = wl_to_func(wl);
@@ -89,7 +82,7 @@ void wl1251_sdio_write(struct wl1251 *wl, int addr, void *buf, size_t len)
 	sdio_release_host(func);
 }
 
-void wl1251_sdio_reset(struct wl1251 *wl)
+static void wl1251_sdio_reset(struct wl1251 *wl)
 {
 }
 
@@ -111,11 +104,11 @@ static void wl1251_sdio_disable_irq(struct wl1251 *wl)
 	sdio_release_host(func);
 }
 
-void wl1251_sdio_set_power(bool enable)
+static void wl1251_sdio_set_power(bool enable)
 {
 }
 
-struct wl1251_if_operations wl1251_sdio_ops = {
+static const struct wl1251_if_operations wl1251_sdio_ops = {
 	.read = wl1251_sdio_read,
 	.write = wl1251_sdio_write,
 	.reset = wl1251_sdio_reset,
@@ -123,7 +116,8 @@ struct wl1251_if_operations wl1251_sdio_ops = {
 	.disable_irq = wl1251_sdio_disable_irq,
 };
 
-int wl1251_sdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
+static int wl1251_sdio_probe(struct sdio_func *func,
+			     const struct sdio_device_id *id)
 {
 	int ret;
 	struct wl1251 *wl;
-- 
1.6.3.3

