Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53762 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab0JUXXR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 19:23:17 -0400
Received: by ewy7 with SMTP id 7so322889ewy.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Oct 2010 16:23:16 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH] wl1251: fix module names
Date: Fri, 22 Oct 2010 02:23:08 +0300
Message-Id: <1287703388-31683-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wl1251 move accidently renamed wl1251_sdio and wl1251_spi
modules to just sdio and spi. Restore proper module names.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl1251/Makefile |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl1251/Makefile b/drivers/net/wireless/wl1251/Makefile
index 4fe2468..58b4f93 100644
--- a/drivers/net/wireless/wl1251/Makefile
+++ b/drivers/net/wireless/wl1251/Makefile
@@ -1,6 +1,8 @@
 wl1251-objs		= main.o event.o tx.o rx.o ps.o cmd.o \
 			  acx.o boot.o init.o debugfs.o io.o
+wl1251_spi-objs		+= spi.o
+wl1251_sdio-objs	+= sdio.o
 
-obj-$(CONFIG_WL1251)	+= wl1251.o
-obj-$(CONFIG_WL1251_SPI)	+= spi.o
-obj-$(CONFIG_WL1251_SDIO)	+= sdio.o
+obj-$(CONFIG_WL1251)		+= wl1251.o
+obj-$(CONFIG_WL1251_SPI)	+= wl1251_spi.o
+obj-$(CONFIG_WL1251_SDIO)	+= wl1251_sdio.o
-- 
1.6.3.3

