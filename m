Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50821 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab0BRL2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:44 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 21/22] wl1271: Added IO reset and init functions
Date: Thu, 18 Feb 2010 13:25:56 +0200
Message-Id: <1266492357-462-22-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Added reset and init functions to IO layer of the driver.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_io.c   |   10 ++++++++++
 drivers/net/wireless/wl12xx/wl1271_io.h   |    2 ++
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 ++--
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_io.c b/drivers/net/wireless/wl12xx/wl1271_io.c
index 00f98bd..5cd94d5 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.c
+++ b/drivers/net/wireless/wl12xx/wl1271_io.c
@@ -115,6 +115,16 @@ int wl1271_set_partition(struct wl1271 *wl,
 	return 0;
 }
 
+void wl1271_io_reset(struct wl1271 *wl)
+{
+	wl1271_spi_reset(wl);
+}
+
+void wl1271_io_init(struct wl1271 *wl)
+{
+	wl1271_spi_init(wl);
+}
+
 void wl1271_raw_write(struct wl1271 *wl, int addr, void *buf,
 		      size_t len, bool fixed)
 {
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.h b/drivers/net/wireless/wl12xx/wl1271_io.h
index 859d571..fa9a0b3 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.h
+++ b/drivers/net/wireless/wl12xx/wl1271_io.h
@@ -27,6 +27,8 @@
 
 struct wl1271;
 
+void wl1271_io_reset(struct wl1271 *wl);
+void wl1271_io_init(struct wl1271 *wl);
 
 /* Raw target IO, address is not translated */
 void wl1271_raw_write(struct wl1271 *wl, int addr, void *buf,
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 4696895..66fb9a0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -648,8 +648,8 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 	msleep(WL1271_PRE_POWER_ON_SLEEP);
 	wl1271_power_on(wl);
 	msleep(WL1271_POWER_ON_SLEEP);
-	wl1271_spi_reset(wl);
-	wl1271_spi_init(wl);
+	wl1271_io_reset(wl);
+	wl1271_io_init(wl);
 
 	/* We don't need a real memory partition here, because we only want
 	 * to use the registers at this point. */
-- 
1.6.3.3

