Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:26010 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab0EXISq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 04:18:46 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/6] wl1271: the core wl1271 module shouldn't depend on SPI_MASTER
Date: Mon, 24 May 2010 11:18:18 +0300
Message-Id: <1274689100-14785-5-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1274689100-14785-1-git-send-email-luciano.coelho@nokia.com>
References: <1274689100-14785-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The core wl1271 module can also be used with SDIO, so it should not depend on
SPI_MASTER.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
index 337fc7b..c6c44ca 100644
--- a/drivers/net/wireless/wl12xx/Kconfig
+++ b/drivers/net/wireless/wl12xx/Kconfig
@@ -41,7 +41,7 @@ config WL1251_SDIO
 
 config WL1271
 	tristate "TI wl1271 support"
-	depends on WL12XX && SPI_MASTER && GENERIC_HARDIRQS
+	depends on WL12XX && GENERIC_HARDIRQS
 	depends on INET
 	select FW_LOADER
 	select CRC7
-- 
1.6.3.3

