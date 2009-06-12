Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:65197 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756933AbZFLLS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:18:26 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 26/33] wl12xx: rename driver to wl1251
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:17:06 +0300
Message-ID: <20090612111706.8877.29722.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Rename driver to wl1251.ko in preparation for wl1271 driver.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
---

 drivers/net/wireless/wl12xx/Kconfig  |   17 ++++++++++++-----
 drivers/net/wireless/wl12xx/Makefile |    4 ++--
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index a82c4cd..3040f9f 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -1,11 +1,18 @@
-config WL12XX
-	tristate "TI wl1251/wl1271 support"
-	depends on MAC80211 && WLAN_80211 && SPI_MASTER && GENERIC_HARDIRQS && EXPERIMENTAL
+menuconfig WL12XX
+	boolean "TI wl12xx driver support"
+	depends on MAC80211 && WLAN_80211 && EXPERIMENTAL
+	---help---
+	  This will enable TI wl12xx driver support. The drivers make 
+	  use of the mac80211 stack.
+
+config WL1251
+	tristate "TI wl1251 support"
+	depends on WL12XX && SPI_MASTER && GENERIC_HARDIRQS
 	select FW_LOADER
 	select CRC7
 	---help---
 	  This module adds support for wireless adapters based on
-	  TI wl1251/wl1271 chipsets.
+	  TI wl1251 chipset.
 
-	  If you choose to build a module, it'll be called wl12xx. Say N if
+	  If you choose to build a module, it'll be called wl1251. Say N if
 	  unsure.
diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index bb2f252..f94970c 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -1,4 +1,4 @@
-wl12xx-objs		= main.o spi.o event.o wl1251_tx.o rx.o \
+wl1251-objs		= main.o spi.o event.o wl1251_tx.o rx.o \
 			  ps.o cmd.o acx.o boot.o init.o wl1251_ops.o  \
 			  debugfs.o
-obj-$(CONFIG_WL12XX)	+= wl12xx.o
+obj-$(CONFIG_WL1251)	+= wl1251.o

