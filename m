Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:39244 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab1KKKSt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 05:18:49 -0500
Subject: [PATCH 10/10] ath6kl: enable USB support
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 11 Nov 2011 12:18:45 +0200
Message-ID: <20111111101844.12075.35936.stgit@localhost6.localdomain6> (sfid-20111111_111851_493473_05BF170D)
In-Reply-To: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
References: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now two modules are built, ath6kl_sdio.ko and ath6kl_usb.ko. But the USB
module isn't fully functional yet as HTC layer is missing support and
that's why it's marked as experimental for now.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/Kconfig  |   25 +++++++++++++++++---
 drivers/net/wireless/ath/ath6kl/Makefile |   37 ++++++++++++++++++++----------
 drivers/net/wireless/ath/ath6kl/sdio.c   |    2 +-
 3 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/Kconfig b/drivers/net/wireless/ath/ath6kl/Kconfig
index 3d5f8be..d755a5e 100644
--- a/drivers/net/wireless/ath/ath6kl/Kconfig
+++ b/drivers/net/wireless/ath/ath6kl/Kconfig
@@ -1,12 +1,29 @@
 config ATH6KL
-	tristate "Atheros ath6kl support"
+	tristate "Atheros mobile chipsets support"
+
+config ATH6KL_SDIO
+	tristate "Atheros ath6kl SDIO support"
+	depends on ATH6KL
 	depends on MMC
 	depends on CFG80211
 	---help---
 	  This module adds support for wireless adapters based on
-	  Atheros AR6003 chipset running over SDIO. If you choose to
-	  build it as a module, it will be called ath6kl. Pls note
-	  that AR6002 and AR6001 are not supported by this driver.
+	  Atheros AR6003 and AR6004 chipsets running over SDIO. If you
+	  choose to build it as a module, it will be called ath6kl_sdio.
+	  Please note that AR6002 and AR6001 are not supported by this
+	  driver.
+
+config ATH6KL_USB
+	tristate "Atheros ath6kl USB support"
+	depends on ATH6KL
+	depends on USB
+	depends on CFG80211
+	depends on EXPERIMENTAL
+	---help---
+	  This module adds support for wireless adapters based on
+	  Atheros AR6004 chipset running over USB. This is still under
+	  implementation and it isn't functional. If you choose to
+	  build it as a module, it will be called ath6kl_usb.
 
 config ATH6KL_DEBUG
 	bool "Atheros ath6kl debugging"
diff --git a/drivers/net/wireless/ath/ath6kl/Makefile b/drivers/net/wireless/ath/ath6kl/Makefile
index 7070693..e14cef9 100644
--- a/drivers/net/wireless/ath/ath6kl/Makefile
+++ b/drivers/net/wireless/ath/ath6kl/Makefile
@@ -21,17 +21,30 @@
 # Author(s): ="Atheros"
 #------------------------------------------------------------------------------
 
-obj-$(CONFIG_ATH6KL) := ath6kl.o
-ath6kl-y += debug.o
-ath6kl-y += hif.o
-ath6kl-y += htc.o
-ath6kl-y += bmi.o
-ath6kl-y += cfg80211.o
-ath6kl-y += init.o
-ath6kl-y += main.o
-ath6kl-y += txrx.o
-ath6kl-y += wmi.o
-ath6kl-y += sdio.o
-ath6kl-$(CONFIG_NL80211_TESTMODE) += testmode.o
+obj-$(CONFIG_ATH6KL_SDIO) := ath6kl_sdio.o
+ath6kl_sdio-y += debug.o
+ath6kl_sdio-y += hif.o
+ath6kl_sdio-y += htc.o
+ath6kl_sdio-y += bmi.o
+ath6kl_sdio-y += cfg80211.o
+ath6kl_sdio-y += init.o
+ath6kl_sdio-y += main.o
+ath6kl_sdio-y += txrx.o
+ath6kl_sdio-y += wmi.o
+ath6kl_sdio-y += sdio.o
+ath6kl_sdio-$(CONFIG_NL80211_TESTMODE) += testmode.o
+
+obj-$(CONFIG_ATH6KL_USB) += ath6kl_usb.o
+ath6kl_usb-y += debug.o
+ath6kl_usb-y += hif.o
+ath6kl_usb-y += htc.o
+ath6kl_usb-y += bmi.o
+ath6kl_usb-y += cfg80211.o
+ath6kl_usb-y += init.o
+ath6kl_usb-y += main.o
+ath6kl_usb-y += txrx.o
+ath6kl_usb-y += wmi.o
+ath6kl_usb-y += usb.o
+ath6kl_usb-$(CONFIG_NL80211_TESTMODE) += testmode.o
 
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 2fbe5f4..1d097d0 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1299,7 +1299,7 @@ static const struct sdio_device_id ath6kl_sdio_devices[] = {
 MODULE_DEVICE_TABLE(sdio, ath6kl_sdio_devices);
 
 static struct sdio_driver ath6kl_sdio_driver = {
-	.name = "ath6kl",
+	.name = "ath6kl_sdio",
 	.id_table = ath6kl_sdio_devices,
 	.probe = ath6kl_sdio_probe,
 	.remove = ath6kl_sdio_remove,

