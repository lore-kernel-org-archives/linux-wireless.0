Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:24375 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab0CZKyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:03 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 09/24] wl1271: Update busyword checking mechanism
Date: Fri, 26 Mar 2010 12:53:18 +0200
Message-Id: <1269600813-32145-10-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

After the busy-words, if the firmware did not complete by the end of the
first (fixed) busy-word, a flip of the CS line is required to enable clocking
out the actual read data.

This patch changes the mechanism such that the CS line is flipped after each
busyword.

Also, the busy-word mechanism is finally enabled, and the number of fixed
busywords reduced to the minimum.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h     |    9 +----
 drivers/net/wireless/wl12xx/wl1271_spi.c |   67 ++++++++++-------------------
 2 files changed, 24 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 8f11506..c939680 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -147,14 +147,7 @@ struct wl1271_nvs_file {
  */
 #undef WL1271_80211A_ENABLED
 
-/*
- * FIXME: for the wl1271, a busy word count of 1 here will result in a more
- * optimal SPI interface. There is some SPI bug however, causing RXS time outs
- * with this mode occasionally on boot, so lets have three for now. A value of
- * three should make sure, that the chipset will always be ready, though this
- * will impact throughput and latencies slightly.
- */
-#define WL1271_BUSY_WORD_CNT 3
+#define WL1271_BUSY_WORD_CNT 1
 #define WL1271_BUSY_WORD_LEN (WL1271_BUSY_WORD_CNT * sizeof(u32))
 
 #define WL1271_ELP_HW_STATE_ASLEEP 0
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index 39b7dea..7a7db01 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -166,41 +166,17 @@ static void wl1271_spi_init(struct wl1271 *wl)
 
 #define WL1271_BUSY_WORD_TIMEOUT 1000
 
-/* FIXME: Check busy words, removed due to SPI bug */
-#if 0
-static void wl1271_spi_read_busy(struct wl1271 *wl, void *buf, size_t len)
+static int wl1271_spi_read_busy(struct wl1271 *wl)
 {
 	struct spi_transfer t[1];
 	struct spi_message m;
 	u32 *busy_buf;
 	int num_busy_bytes = 0;
 
-	wl1271_info("spi read BUSY!");
-
-	/*
-	 * Look for the non-busy word in the read buffer, and if found,
-	 * read in the remaining data into the buffer.
-	 */
-	busy_buf = (u32 *)buf;
-	for (; (u32)busy_buf < (u32)buf + len; busy_buf++) {
-		num_busy_bytes += sizeof(u32);
-		if (*busy_buf & 0x1) {
-			spi_message_init(&m);
-			memset(t, 0, sizeof(t));
-			memmove(buf, busy_buf, len - num_busy_bytes);
-			t[0].rx_buf = buf + (len - num_busy_bytes);
-			t[0].len = num_busy_bytes;
-			spi_message_add_tail(&t[0], &m);
-			spi_sync(wl_to_spi(wl), &m);
-			return;
-		}
-	}
-
 	/*
 	 * Read further busy words from SPI until a non-busy word is
 	 * encountered, then read the data itself into the buffer.
 	 */
-	wl1271_info("spi read BUSY-polling needed!");
 
 	num_busy_bytes = WL1271_BUSY_WORD_TIMEOUT;
 	busy_buf = wl->buffer_busyword;
@@ -210,28 +186,21 @@ static void wl1271_spi_read_busy(struct wl1271 *wl, void *buf, size_t len)
 		memset(t, 0, sizeof(t));
 		t[0].rx_buf = busy_buf;
 		t[0].len = sizeof(u32);
+		t[0].cs_change = true;
 		spi_message_add_tail(&t[0], &m);
 		spi_sync(wl_to_spi(wl), &m);
 
-		if (*busy_buf & 0x1) {
-			spi_message_init(&m);
-			memset(t, 0, sizeof(t));
-			t[0].rx_buf = buf;
-			t[0].len = len;
-			spi_message_add_tail(&t[0], &m);
-			spi_sync(wl_to_spi(wl), &m);
-			return;
-		}
+		if (*busy_buf & 0x1)
+			return 0;
 	}
 
 	/* The SPI bus is unresponsive, the read failed. */
-	memset(buf, 0, len);
 	wl1271_error("SPI read busy-word timeout!\n");
+	return -ETIMEDOUT;
 }
-#endif
 
 static void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
-			 size_t len, bool fixed)
+				size_t len, bool fixed)
 {
 	struct spi_transfer t[3];
 	struct spi_message m;
@@ -254,22 +223,32 @@ static void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
 
 	t[0].tx_buf = cmd;
 	t[0].len = 4;
+	t[0].cs_change = true;
 	spi_message_add_tail(&t[0], &m);
 
 	/* Busy and non busy words read */
 	t[1].rx_buf = busy_buf;
 	t[1].len = WL1271_BUSY_WORD_LEN;
+	t[1].cs_change = true;
 	spi_message_add_tail(&t[1], &m);
 
-	t[2].rx_buf = buf;
-	t[2].len = len;
-	spi_message_add_tail(&t[2], &m);
-
 	spi_sync(wl_to_spi(wl), &m);
 
-	/* FIXME: Check busy words, removed due to SPI bug */
-	/* if (!(busy_buf[WL1271_BUSY_WORD_CNT - 1] & 0x1))
-	   wl1271_spi_read_busy(wl, buf, len); */
+	if (!(busy_buf[WL1271_BUSY_WORD_CNT - 1] & 0x1) &&
+	    wl1271_spi_read_busy(wl)) {
+		memset(buf, 0, len);
+		return;
+	}
+
+	spi_message_init(&m);
+	memset(t, 0, sizeof(t));
+
+	t[0].rx_buf = buf;
+	t[0].len = len;
+	t[0].cs_change = true;
+	spi_message_add_tail(&t[0], &m);
+
+	spi_sync(wl_to_spi(wl), &m);
 
 	wl1271_dump(DEBUG_SPI, "spi_read cmd -> ", cmd, sizeof(*cmd));
 	wl1271_dump(DEBUG_SPI, "spi_read buf <- ", buf, len);
-- 
1.6.3.3

