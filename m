Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:19464 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab0BVGlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:42 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 02/22] wl1271: Added functions to enable/disable interrupt handling
Date: Mon, 22 Feb 2010 08:38:22 +0200
Message-Id: <1266820722-20202-3-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>

Added/moved enable and disable interrupt handling functions.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |    2 +-
 drivers/net/wireless/wl12xx/wl1271_io.c   |   10 ++++++++++
 drivers/net/wireless/wl12xx/wl1271_io.h   |    3 +++
 drivers/net/wireless/wl12xx/wl1271_main.c |    5 -----
 drivers/net/wireless/wl12xx/wl1271_spi.c  |   10 ++++++++++
 drivers/net/wireless/wl12xx/wl1271_spi.h  |    3 +++
 6 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 2be76ee..7d6d2e6 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -299,7 +299,7 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 
 static void wl1271_boot_enable_interrupts(struct wl1271 *wl)
 {
-	enable_irq(wl->irq);
+	wl1271_enable_interrupts(wl);
 	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK,
 		       WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
 	wl1271_write32(wl, HI_CFG, HI_CFG_DEF_VAL);
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.c b/drivers/net/wireless/wl12xx/wl1271_io.c
index 5cd94d5..b825cfa 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.c
+++ b/drivers/net/wireless/wl12xx/wl1271_io.c
@@ -31,6 +31,16 @@
 #include "wl1271_spi.h"
 #include "wl1271_io.h"
 
+void wl1271_disable_interrupts(struct wl1271 *wl)
+{
+	wl1271_spi_disable_interrupts(wl);
+}
+
+void wl1271_enable_interrupts(struct wl1271 *wl)
+{
+	wl1271_spi_enable_interrupts(wl);
+}
+
 static int wl1271_translate_addr(struct wl1271 *wl, int addr)
 {
 	/*
diff --git a/drivers/net/wireless/wl12xx/wl1271_io.h b/drivers/net/wireless/wl12xx/wl1271_io.h
index 38fce4c..c8b0971 100644
--- a/drivers/net/wireless/wl12xx/wl1271_io.h
+++ b/drivers/net/wireless/wl12xx/wl1271_io.h
@@ -27,6 +27,9 @@
 
 struct wl1271;
 
+void wl1271_disable_interrupts(struct wl1271 *wl);
+void wl1271_enable_interrupts(struct wl1271 *wl);
+
 void wl1271_io_reset(struct wl1271 *wl);
 void wl1271_io_init(struct wl1271 *wl);
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 66319aa..18347c3 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -360,11 +360,6 @@ static int wl1271_plt_init(struct wl1271 *wl)
 	return ret;
 }
 
-static void wl1271_disable_interrupts(struct wl1271 *wl)
-{
-	disable_irq(wl->irq);
-}
-
 static void wl1271_power_off(struct wl1271 *wl)
 {
 	wl->set_power(false);
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index c26726a..b422c9f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -34,6 +34,16 @@
 #include "wl1271_io.h"
 
 
+void wl1271_spi_disable_interrupts(struct wl1271 *wl)
+{
+	disable_irq(wl->irq);
+}
+
+void wl1271_spi_enable_interrupts(struct wl1271 *wl)
+{
+	enable_irq(wl->irq);
+}
+
 void wl1271_spi_reset(struct wl1271 *wl)
 {
 	u8 *cmd;
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.h b/drivers/net/wireless/wl12xx/wl1271_spi.h
index a803596..86ff161 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.h
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.h
@@ -84,6 +84,9 @@
 #define OCP_STATUS_REQ_FAILED 0x20000
 #define OCP_STATUS_RESP_ERROR 0x30000
 
+void wl1271_spi_disable_interrupts(struct wl1271 *wl);
+void wl1271_spi_enable_interrupts(struct wl1271 *wl);
+
 /* Raw target IO, address is not translated */
 void wl1271_spi_raw_write(struct wl1271 *wl, int addr, void *buf,
 		      size_t len, bool fixed);
-- 
1.6.3.3

