Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60063 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab0EMJq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 05:46:57 -0400
Received: by wyb32 with SMTP id 32so731401wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 02:46:56 -0700 (PDT)
From: Ohad Ben-Cohen <ohad@wizery.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH] wl1271: remove sdio ARM dependency
Date: Thu, 13 May 2010 12:43:24 +0300
Message-Id: <1273743804-11587-1-git-send-email-ohad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make it possible to use wl1271's SDIO interface on non-ARM platforms.

Fully tested on a x86 platform, compile-tested on ARM.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/net/wireless/wl12xx/Kconfig       |    2 +-
 drivers/net/wireless/wl12xx/wl1271_sdio.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 337fc7b..1516341 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -65,7 +65,7 @@ config WL1271_SPI
 
 config WL1271_SDIO
 	tristate "TI wl1271 SDIO support"
-	depends on WL1271 && MMC && ARM
+	depends on WL1271 && MMC
 	---help---
 	  This module adds support for the SDIO interface of adapters using
 	  TI wl1271 chipset.  Select this if your platform is using
diff --git a/drivers/net/wireless/wl12xx/wl1271_sdio.c b/drivers/net/wireless/wl12xx/wl1271_sdio.c
index d3d6f30..7059b5c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_sdio.c
+++ b/drivers/net/wireless/wl12xx/wl1271_sdio.c
@@ -28,7 +28,7 @@
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
 #include <linux/mmc/card.h>
-#include <plat/gpio.h>
+#include <linux/gpio.h>
 
 #include "wl1271.h"
 #include "wl12xx_80211.h"
-- 
1.7.0.4

