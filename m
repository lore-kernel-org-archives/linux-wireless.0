Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:49280 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab2FPT07 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 15:26:59 -0400
Received: by mail-wg0-f44.google.com with SMTP id dr13so4227687wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2012 12:26:59 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 3/3] wl1251: Fix memory leaks in SPI initialization
Date: Sat, 16 Jun 2012 22:26:48 +0300
Message-Id: <1339874808-9991-4-git-send-email-notasas@gmail.com> (sfid-20120616_212738_606929_62E05886)
In-Reply-To: <1339874808-9991-1-git-send-email-notasas@gmail.com>
References: <1339874808-9991-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes two memory leaks in the SPI initialization code.

Patch based on old maemo patch by:
Yuri Ershov <ext-yuri.ershov@nokia.com>

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/ti/wl1251/spi.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/spi.c b/drivers/net/wireless/ti/wl1251/spi.c
index 87f6305..567660c 100644
--- a/drivers/net/wireless/ti/wl1251/spi.c
+++ b/drivers/net/wireless/ti/wl1251/spi.c
@@ -73,6 +73,8 @@ static void wl1251_spi_reset(struct wl1251 *wl)
 	spi_sync(wl_to_spi(wl), &m);
 
 	wl1251_dump(DEBUG_SPI, "spi reset -> ", cmd, WSPI_INIT_CMD_LEN);
+
+	kfree(cmd);
 }
 
 static void wl1251_spi_wake(struct wl1251 *wl)
@@ -127,6 +129,8 @@ static void wl1251_spi_wake(struct wl1251 *wl)
 	spi_sync(wl_to_spi(wl), &m);
 
 	wl1251_dump(DEBUG_SPI, "spi init -> ", cmd, WSPI_INIT_CMD_LEN);
+
+	kfree(cmd);
 }
 
 static void wl1251_spi_reset_wake(struct wl1251 *wl)
-- 
1.7.0.4

