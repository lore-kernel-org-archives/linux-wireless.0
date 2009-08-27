Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:33278 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbZH0VAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 17:00:42 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, juuso.oikarinen@nokia.com,
	kalle.valo@nokia.com
Subject: [PATCH 07/13] wl1271: Implementation for SPI busy word checking
Date: Fri, 28 Aug 2009 00:00:01 +0300
Message-Id: <1251406807-31495-8-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
References: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch adds implementation for checking for SPI busy words - i.e.
honoring a delay request from the WLAN chipset upon reading
registers/memory.

To optimized the average SPI ready by 32 bits, also configure the number
of busywords to one to disable the "fixed-busy-word" functionality.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h     |   10 +++-
 drivers/net/wireless/wl12xx/wl1271_spi.c |   69 +++++++++++++++++++++++++++++-
 2 files changed, 75 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index c455dcb..957da8c 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -107,7 +107,13 @@ enum {
 #define WL1271_FW_NAME "wl1271-fw.bin"
 #define WL1271_NVS_NAME "wl1271-nvs.bin"
 
-#define WL1271_BUSY_WORD_LEN 8
+/*
+ * FIXME: for the wl1271, a busy word count of 1 here will result in a more
+ * optimal SPI interface. There is some SPI bug however, causing RXS time outs
+ * with this mode occasionally on boot, so lets have two for now.
+ */
+#define WL1271_BUSY_WORD_CNT 2
+#define WL1271_BUSY_WORD_LEN (WL1271_BUSY_WORD_CNT * sizeof(u32))
 
 #define WL1271_ELP_HW_STATE_ASLEEP 0
 #define WL1271_ELP_HW_STATE_IRQ    1
@@ -389,7 +395,7 @@ struct wl1271 {
 
 	u32 buffer_32;
 	u32 buffer_cmd;
-	u8 buffer_busyword[WL1271_BUSY_WORD_LEN];
+	u32 buffer_busyword[WL1271_BUSY_WORD_CNT];
 	struct wl1271_rx_descriptor *rx_descriptor;
 
 	struct wl1271_fw_status *fw_status;
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index 4a12880..504991a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -244,12 +244,75 @@ int wl1271_set_partition(struct wl1271 *wl,
 	return 0;
 }
 
+#define WL1271_BUSY_WORD_TIMEOUT 1000
+
+void wl1271_spi_read_busy(struct wl1271 *wl, void *buf, size_t len)
+{
+	struct spi_transfer t[1];
+	struct spi_message m;
+	u32 *busy_buf;
+	int num_busy_bytes = 0;
+
+	wl1271_info("spi read BUSY!");
+
+	/*
+	 * Look for the non-busy word in the read buffer, and if found,
+	 * read in the remaining data into the buffer.
+	 */
+	busy_buf = (u32 *)buf;
+	for (; (u32)busy_buf < (u32)buf + len; busy_buf++) {
+		num_busy_bytes += sizeof(u32);
+		if (*busy_buf & 0x1) {
+			spi_message_init(&m);
+			memset(t, 0, sizeof(t));
+			memmove(buf, busy_buf, len - num_busy_bytes);
+			t[0].rx_buf = buf + (len - num_busy_bytes);
+			t[0].len = num_busy_bytes;
+			spi_message_add_tail(&t[0], &m);
+			spi_sync(wl->spi, &m);
+			return;
+		}
+	}
+
+	/*
+	 * Read further busy words from SPI until a non-busy word is
+	 * encountered, then read the data itself into the buffer.
+	 */
+	wl1271_info("spi read BUSY-polling needed!");
+
+	num_busy_bytes = WL1271_BUSY_WORD_TIMEOUT;
+	busy_buf = wl->buffer_busyword;
+	while (num_busy_bytes) {
+		num_busy_bytes--;
+		spi_message_init(&m);
+		memset(t, 0, sizeof(t));
+		t[0].rx_buf = busy_buf;
+		t[0].len = sizeof(u32);
+		spi_message_add_tail(&t[0], &m);
+		spi_sync(wl->spi, &m);
+
+		if (*busy_buf & 0x1) {
+			spi_message_init(&m);
+			memset(t, 0, sizeof(t));
+			t[0].rx_buf = buf;
+			t[0].len = len;
+			spi_message_add_tail(&t[0], &m);
+			spi_sync(wl->spi, &m);
+			return;
+		}
+	}
+
+	/* The SPI bus is unresponsive, the read failed. */
+	memset(buf, 0, len);
+	wl1271_error("SPI read busy-word timeout!\n");
+}
+
 void wl1271_spi_read(struct wl1271 *wl, int addr, void *buf,
 		     size_t len, bool fixed)
 {
 	struct spi_transfer t[3];
 	struct spi_message m;
-	u8 *busy_buf;
+	u32 *busy_buf;
 	u32 *cmd;
 
 	cmd = &wl->buffer_cmd;
@@ -281,7 +344,9 @@ void wl1271_spi_read(struct wl1271 *wl, int addr, void *buf,
 
 	spi_sync(wl->spi, &m);
 
-	/* FIXME: check busy words */
+	/* Check busy words */
+	if (!(busy_buf[WL1271_BUSY_WORD_CNT - 1] & 0x1))
+		wl1271_spi_read_busy(wl, buf, len);
 
 	wl1271_dump(DEBUG_SPI, "spi_read cmd -> ", cmd, sizeof(*cmd));
 	wl1271_dump(DEBUG_SPI, "spi_read buf <- ", buf, len);
-- 
1.5.6.5

