Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:35248 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbZHFNZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 09:25:41 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id n76DP9Pi019088
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2009 16:25:34 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: kalle.valo@nokia.com, juuso.oikarinen@nokia.com
Subject: [PATCH 2/2] wl1271: add wl1271 to Kconfig and the Makefile
Date: Thu,  6 Aug 2009 16:25:29 +0300
Message-Id: <1249565129-12677-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1249565129-12677-1-git-send-email-luciano.coelho@nokia.com>
References: <1249565129-12677-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support for the wl1271 driver in the Kconfig and in the
Makefile.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/Kconfig  |   12 ++++++++++++
 drivers/net/wireless/wl12xx/Makefile |    6 ++++++
 2 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 82a0f97..af31eab 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -16,3 +16,15 @@ config WL1251
 
 	  If you choose to build a module, it'll be called wl1251. Say N if
 	  unsure.
+
+config WL1271
+	tristate "TI wl1271 support"
+	depends on WL12XX && SPI_MASTER && GENERIC_HARDIRQS
+	select FW_LOADER
+	select CRC7
+	---help---
+	  This module adds support for wireless adapters based on the
+	  TI wl1271 chipset.
+
+	  If you choose to build a module, it'll be called wl1271. Say N if
+	  unsure.
diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index d5595a8..ecb8833 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -3,3 +3,9 @@ wl1251-objs		= wl1251_main.o wl1251_spi.o wl1251_event.o \
 			  wl1251_acx.o wl1251_boot.o wl1251_init.o \
 			  wl1251_ops.o wl1251_debugfs.o
 obj-$(CONFIG_WL1251)	+= wl1251.o
+
+wl1271-objs		= wl1271_main.o  wl1271_spi.o wl1271_cmd.o  \
+			  wl1271_event.o wl1271_tx.o  wl1271_rx.o   \
+			  wl1271_ps.o    wl1271_acx.o wl1271_boot.o \
+			  wl1271_init.o  wl1271_debugfs.o
+obj-$(CONFIG_WL1271)	+= wl1271.o
-- 
1.5.6.5

