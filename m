Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:49231 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549AbZJLMN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:13:27 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 07/16] wl1271: Add top-register access functions
Date: Mon, 12 Oct 2009 15:08:48 +0300
Message-Id: <1255349337-9776-8-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Add top register access function.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_boot.c |   27 ++---------------
 drivers/net/wireless/wl12xx/wl1271_boot.h |   15 +---------
 drivers/net/wireless/wl12xx/wl1271_spi.c  |   46 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1271_spi.h  |   16 ++++++++++
 4 files changed, 66 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 2eb7836..1a3084c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -419,34 +419,13 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 
 static int wl1271_boot_write_irq_polarity(struct wl1271 *wl)
 {
-	u32 polarity, status, i;
+	u32 polarity;
 
-	wl1271_reg_write32(wl, OCP_POR_CTR, OCP_REG_POLARITY);
-	wl1271_reg_write32(wl, OCP_CMD, OCP_CMD_READ);
-
-	/* Wait until the command is complete (ie. bit 18 is set) */
-	for (i = 0; i < OCP_CMD_LOOP; i++) {
-		polarity = wl1271_reg_read32(wl, OCP_DATA_READ);
-		if (polarity & OCP_READY_MASK)
-			break;
-	}
-	if (i == OCP_CMD_LOOP) {
-		wl1271_error("OCP command timeout!");
-		return -EIO;
-	}
-
-	status = polarity & OCP_STATUS_MASK;
-	if (status != OCP_STATUS_OK) {
-		wl1271_error("OCP command failed (%d)", status);
-		return -EIO;
-	}
+	polarity = wl1271_top_reg_read(wl, OCP_REG_POLARITY);
 
 	/* We use HIGH polarity, so unset the LOW bit */
 	polarity &= ~POLARITY_LOW;
-
-	wl1271_reg_write32(wl, OCP_POR_CTR, OCP_REG_POLARITY);
-	wl1271_reg_write32(wl, OCP_DATA_WRITE, polarity);
-	wl1271_reg_write32(wl, OCP_CMD, OCP_CMD_WRITE);
+	wl1271_top_reg_write(wl, OCP_REG_POLARITY, polarity);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.h b/drivers/net/wireless/wl12xx/wl1271_boot.h
index b0d8fb4..4501653 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.h
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.h
@@ -50,20 +50,7 @@ struct wl1271_static_data {
 #define WU_COUNTER_PAUSE_VAL 0x3FF
 #define WELP_ARM_COMMAND_VAL 0x4
 
-#define OCP_CMD_LOOP  32
-
-#define OCP_CMD_WRITE 0x1
-#define OCP_CMD_READ  0x2
-
-#define OCP_READY_MASK  BIT(18)
-#define OCP_STATUS_MASK (BIT(16) | BIT(17))
-
-#define OCP_STATUS_NO_RESP    0x00000
-#define OCP_STATUS_OK         0x10000
-#define OCP_STATUS_REQ_FAILED 0x20000
-#define OCP_STATUS_RESP_ERROR 0x30000
-
-#define OCP_REG_POLARITY 0x30032
+#define OCP_REG_POLARITY 0x0064
 
 #define CMD_MBOX_ADDRESS 0x407B4
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index 367f2d3..7a7890b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -395,3 +395,49 @@ void wl1271_reg_write32(struct wl1271 *wl, int addr, u32 val)
 {
 	wl1271_write32(wl, wl1271_translate_addr(wl, addr), val);
 }
+
+void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val)
+{
+	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
+	addr = (addr >> 1) + 0x30000;
+	wl1271_reg_write32(wl, OCP_POR_CTR, addr);
+
+	/* write value to OCP_POR_WDATA */
+	wl1271_reg_write32(wl, OCP_DATA_WRITE, val);
+
+	/* write 1 to OCP_CMD */
+	wl1271_reg_write32(wl, OCP_CMD, OCP_CMD_WRITE);
+}
+
+u16 wl1271_top_reg_read(struct wl1271 *wl, int addr)
+{
+	u32 val;
+	int timeout = OCP_CMD_LOOP;
+
+	/* write address >> 1 + 0x30000 to OCP_POR_CTR */
+	addr = (addr >> 1) + 0x30000;
+	wl1271_reg_write32(wl, OCP_POR_CTR, addr);
+
+	/* write 2 to OCP_CMD */
+	wl1271_reg_write32(wl, OCP_CMD, OCP_CMD_READ);
+
+	/* poll for data ready */
+	do {
+		val = wl1271_reg_read32(wl, OCP_DATA_READ);
+		timeout--;
+	} while (!(val & OCP_READY_MASK) && timeout);
+
+	if (!timeout) {
+		wl1271_warning("Top register access timed out.");
+		return 0xffff;
+	}
+
+	/* check data status and return if OK */
+	if ((val & OCP_STATUS_MASK) == OCP_STATUS_OK)
+		return val & 0xffff;
+	else {
+		wl1271_warning("Top register access returned error.");
+		return 0xffff;
+	}
+}
+
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.h b/drivers/net/wireless/wl12xx/wl1271_spi.h
index c58e027..4f1608e 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.h
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.h
@@ -71,6 +71,18 @@
 		((WL1271_BUSY_WORD_LEN - 4) / sizeof(u32))
 #define HW_ACCESS_WSPI_INIT_CMD_MASK  0
 
+#define OCP_CMD_LOOP  32
+
+#define OCP_CMD_WRITE 0x1
+#define OCP_CMD_READ  0x2
+
+#define OCP_READY_MASK  BIT(18)
+#define OCP_STATUS_MASK (BIT(16) | BIT(17))
+
+#define OCP_STATUS_NO_RESP    0x00000
+#define OCP_STATUS_OK         0x10000
+#define OCP_STATUS_REQ_FAILED 0x20000
+#define OCP_STATUS_RESP_ERROR 0x30000
 
 /* Raw target IO, address is not translated */
 void wl1271_spi_write(struct wl1271 *wl, int addr, void *buf,
@@ -92,6 +104,10 @@ void wl1271_spi_reg_write(struct wl1271 *wl, int addr, void *buf, size_t len,
 u32 wl1271_reg_read32(struct wl1271 *wl, int addr);
 void wl1271_reg_write32(struct wl1271 *wl, int addr, u32 val);
 
+/* Top Register IO */
+void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val);
+u16 wl1271_top_reg_read(struct wl1271 *wl, int addr);
+
 /* INIT and RESET words */
 void wl1271_spi_reset(struct wl1271 *wl);
 void wl1271_spi_init(struct wl1271 *wl);
-- 
1.5.6.5

