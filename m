Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52789 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2DXElq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 00:41:46 -0400
Received: by iadi9 with SMTP id i9so442967iad.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 21:41:46 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 24 Apr 2012 00:41:46 -0400
Message-ID: <CAJe1HzND5WO9i2dJt41WP6VPax9=yAjvoENdROLDxo2g4QVm_A@mail.gmail.com> (sfid-20120424_064150_979738_442D0798)
Subject: [PATCH 3.4-rc4 1/1] mwifiex: add support for SD8786 sdio
From: Jason Plum <max@warheads.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jason Plum <max@warheads.net>

Date:   Mon Apr 23 23:54:47 2012 -0400

    mwifiex: add support for SD8786 sdio

        modified:   drivers/net/wireless/mwifiex/Kconfig
        - notate additional chipset
        modified:   drivers/net/wireless/mwifiex/sdio.c
        - add definition of id (0x9116)
        - add to switch for firmware load
        - add MODULE_FIRMWARE
        modified:   drivers/net/wireless/mwifiex/sdio.h
        - add definition of default firmware name

    Signed-off-by: Jason Plum <max@warheads.net>
---

diff --git a/drivers/net/wireless/mwifiex/Kconfig
b/drivers/net/wireless/mwifiex/Kconfig
index 2a078ce..48c4c32 100644
--- a/drivers/net/wireless/mwifiex/Kconfig
+++ b/drivers/net/wireless/mwifiex/Kconfig
@@ -10,12 +10,12 @@ config MWIFIEX
          mwifiex.

 config MWIFIEX_SDIO
-       tristate "Marvell WiFi-Ex Driver for SD8787/SD8797"
+       tristate "Marvell WiFi-Ex Driver for SD8786/SD8787/SD8797"
        depends on MWIFIEX && MMC
        select FW_LOADER
        ---help---
          This adds support for wireless adapters based on Marvell
-         8787/8797 chipsets with SDIO interface.
+         8786/8787/8797 chipsets with SDIO interface.

          If you choose to build it as a module, it will be called
          mwifiex_sdio.
diff --git a/drivers/net/wireless/mwifiex/sdio.c
b/drivers/net/wireless/mwifiex/sdio.c
index f8012e2..74981ab 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -250,6 +250,8 @@ static int mwifiex_sdio_resume(struct device *dev)
        return 0;
 }

+/* Device ID for SD8786 */
+#define SDIO_DEVICE_ID_MARVELL_8786   (0x9116)
 /* Device ID for SD8787 */
 #define SDIO_DEVICE_ID_MARVELL_8787   (0x9119)
 /* Device ID for SD8797 */
@@ -257,6 +259,7 @@ static int mwifiex_sdio_resume(struct device *dev)
