Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63956 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab2AEM2t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 07:28:49 -0500
Received: by yenm11 with SMTP id m11so119250yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jan 2012 04:28:48 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Fabio Estevam <festevam@gmail.com>,
	Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] drivers: net: wireless: Fix dependencies for IWM and WIMAX_IWMC3200_SDIO
Date: Thu,  5 Jan 2012 10:28:36 -0200
Message-Id: <1325766516-8040-1-git-send-email-festevam@gmail.com> (sfid-20120105_132852_863485_DDCA82E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix the following build warning:

warning: (IWM && WIMAX_IWMC3200_SDIO) selects IWMC3200TOP which has unmet direct dependencies (MISC_DEVICES && MMC && EXPERIMENTAL)

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/net/wimax/i2400m/Kconfig          |    4 ++--
 drivers/net/wireless/iwmc3200wifi/Kconfig |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wimax/i2400m/Kconfig b/drivers/net/wimax/i2400m/Kconfig
index 3f70338..98348a0 100644
--- a/drivers/net/wimax/i2400m/Kconfig
+++ b/drivers/net/wimax/i2400m/Kconfig
@@ -33,8 +33,8 @@ config WIMAX_I2400M_SDIO
 
 config WIMAX_IWMC3200_SDIO
 	bool "Intel Wireless Multicom WiMAX Connection 3200 over SDIO"
-	depends on WIMAX_I2400M_SDIO
-	select IWMC3200TOP
+	depends on WIMAX_I2400M_SDIO && MMC && EXPERIMENTAL
+	select IWMC3200TOP if MISC_DEVICES
 	help
 	  Select if you have a device based on the Intel Multicom WiMAX
           Connection 3200 over SDIO.
diff --git a/drivers/net/wireless/iwmc3200wifi/Kconfig b/drivers/net/wireless/iwmc3200wifi/Kconfig
index 03f998d..94b0c84 100644
--- a/drivers/net/wireless/iwmc3200wifi/Kconfig
+++ b/drivers/net/wireless/iwmc3200wifi/Kconfig
@@ -3,7 +3,7 @@ config IWM
 	depends on MMC && EXPERIMENTAL
 	depends on CFG80211
 	select FW_LOADER
-	select IWMC3200TOP
+	select IWMC3200TOP if MISC_DEVICES
 	help
 	  The Intel Wireless Multicomm 3200 hardware is a combo
 	  card with GPS, Bluetooth, WiMax and 802.11 radios. It
-- 
1.7.1

