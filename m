Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45081 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079Ab0CKPoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Mar 2010 10:44:55 -0500
Received: by bwz1 with SMTP id 1so156999bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 11 Mar 2010 07:44:54 -0800 (PST)
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kalle.valo@iki.fi>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/4] wl1251: make local symbols static
Date: Thu, 11 Mar 2010 17:44:36 +0200
Message-Id: <1268322276-16640-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make local functions and data static, also constify
some structures. While at it, clean up unneeded includes.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/wl1251_sdio.c |   25 +++++++++----------------
 1 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_sdio.c b/drivers/net/wireless/wl12xx/wl1251_sdio.c
index 9423f22..0aceb91 100644
--- a/drivers/net/wireless/wl12xx/wl1251_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1251_sdio.c
@@ -20,20 +20,10 @@
  * Copyright (C) 2009 Bob Copeland (me@bobcopeland.com)
  */
 #include <linux/module.h>
-#include <linux/crc7.h>
-#include <linux/mod_devicetable.h>
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
@@ -65,7 +55,8 @@ static const struct sdio_device_id wl1251_devices[] = {
 MODULE_DEVICE_TABLE(sdio, wl1251_devices);
 
 
-void wl1251_sdio_read(struct wl1251 *wl, int addr, void *buf, size_t len)
+static void wl1251_sdio_read(struct wl1251 *wl, int addr,
+			     void *buf, size_t len)
 {
 	int ret;
 	struct sdio_func *func = wl_to_func(wl);
@@ -77,7 +68,8 @@ void wl1251_sdio_read(struct wl1251 *wl, int addr, void *buf, size_t len)
 	sdio_release_host(func);
 }
 
-void wl1251_sdio_write(struct wl1251 *wl, int addr, void *buf, size_t len)
+static void wl1251_sdio_write(struct wl1251 *wl, int addr,
+			      void *buf, size_t len)
 {
 	int ret;
 	struct sdio_func *func = wl_to_func(wl);
@@ -89,7 +81,7 @@ void wl1251_sdio_write(struct wl1251 *wl, int addr, void *buf, size_t len)
 	sdio_release_host(func);
 }
 
-void wl1251_sdio_reset(struct wl1251 *wl)
+static void wl1251_sdio_reset(struct wl1251 *wl)
 {
 }
 
@@ -111,11 +103,11 @@ static void wl1251_sdio_disable_irq(struct wl1251 *wl)
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
@@ -123,7 +115,8 @@ struct wl1251_if_operations wl1251_sdio_ops = {
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

