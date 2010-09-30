Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52920 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab0I3N2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 09:28:39 -0400
Received: by mail-fx0-f46.google.com with SMTP id 4so674500fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 06:28:38 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	Ohad Ben-Cohen <ohad@wizery.com>, Ido Yariv <ido@wizery.com>
Subject: [PATCH v3 1/3] wl1271: Handle large SPI transfers
Date: Thu, 30 Sep 2010 15:28:26 +0200
Message-Id: <1285853308-24290-2-git-send-email-ido@wizery.com>
In-Reply-To: <1285853308-24290-1-git-send-email-ido@wizery.com>
References: <1285853308-24290-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The HW supports up to 4095 bytes transfers via SPI. The SPI read & write
operations do not handle larger transfers, causing the HW to stall in such
cases.

Fix this by fragmenting large transfers into smaller chunks, and
transferring each one separately.

Signed-off-by: Ido Yariv <ido@wizery.com>
Tested-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_spi.c |  140 ++++++++++++++++++------------
 1 files changed, 86 insertions(+), 54 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index 75cbf36..ef80168 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -63,6 +63,11 @@
 		((WL1271_BUSY_WORD_LEN - 4) / sizeof(u32))
 #define HW_ACCESS_WSPI_INIT_CMD_MASK  0
 
+/* HW limitation: maximum possible chunk size is 4095 bytes */
+#define WSPI_MAX_CHUNK_SIZE    4092
+
+#define WSPI_MAX_NUM_OF_CHUNKS (WL1271_AGGR_BUFFER_SIZE / WSPI_MAX_CHUNK_SIZE)
+
 static inline struct spi_device *wl_to_spi(struct wl1271 *wl)
 {
 	return wl->if_priv;
@@ -202,90 +207,117 @@ static int wl1271_spi_read_busy(struct wl1271 *wl)
 static void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
 				size_t len, bool fixed)
 {
-	struct spi_transfer t[3];
+	struct spi_transfer t[2];
 	struct spi_message m;
 	u32 *busy_buf;
 	u32 *cmd;
+	u32 chunk_len;
 
-	cmd = &wl->buffer_cmd;
-	busy_buf = wl->buffer_busyword;
+	while (len > 0) {
+		chunk_len = min((size_t)WSPI_MAX_CHUNK_SIZE, len);
 
-	*cmd = 0;
-	*cmd |= WSPI_CMD_READ;
-	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
-	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
+		cmd = &wl->buffer_cmd;
+		busy_buf = wl->buffer_busyword;
 
-	if (fixed)
-		*cmd |= WSPI_CMD_FIXED;
+		*cmd = 0;
+		*cmd |= WSPI_CMD_READ;
+		*cmd |= (chunk_len << WSPI_CMD_BYTE_LENGTH_OFFSET) &
+			WSPI_CMD_BYTE_LENGTH;
+		*cmd |= addr & WSPI_CMD_BYTE_ADDR;
 
-	spi_message_init(&m);
-	memset(t, 0, sizeof(t));
+		if (fixed)
+			*cmd |= WSPI_CMD_FIXED;
 
-	t[0].tx_buf = cmd;
-	t[0].len = 4;
-	t[0].cs_change = true;
-	spi_message_add_tail(&t[0], &m);
+		spi_message_init(&m);
+		memset(t, 0, sizeof(t));
 
-	/* Busy and non busy words read */
-	t[1].rx_buf = busy_buf;
-	t[1].len = WL1271_BUSY_WORD_LEN;
-	t[1].cs_change = true;
-	spi_message_add_tail(&t[1], &m);
+		t[0].tx_buf = cmd;
+		t[0].len = 4;
+		t[0].cs_change = true;
+		spi_message_add_tail(&t[0], &m);
 
-	spi_sync(wl_to_spi(wl), &m);
+		/* Busy and non busy words read */
+		t[1].rx_buf = busy_buf;
+		t[1].len = WL1271_BUSY_WORD_LEN;
+		t[1].cs_change = true;
+		spi_message_add_tail(&t[1], &m);
 
-	if (!(busy_buf[WL1271_BUSY_WORD_CNT - 1] & 0x1) &&
-	    wl1271_spi_read_busy(wl)) {
-		memset(buf, 0, len);
-		return;
-	}
+		spi_sync(wl_to_spi(wl), &m);
 
-	spi_message_init(&m);
-	memset(t, 0, sizeof(t));
+		if (!(busy_buf[WL1271_BUSY_WORD_CNT - 1] & 0x1) &&
+		    wl1271_spi_read_busy(wl)) {
+			memset(buf, 0, chunk_len);
+			return;
+		}
 
-	t[0].rx_buf = buf;
-	t[0].len = len;
-	t[0].cs_change = true;
-	spi_message_add_tail(&t[0], &m);
+		spi_message_init(&m);
+		memset(t, 0, sizeof(t));
 
-	spi_sync(wl_to_spi(wl), &m);
+		t[0].rx_buf = buf;
+		t[0].len = chunk_len;
+		t[0].cs_change = true;
+		spi_message_add_tail(&t[0], &m);
+
+		spi_sync(wl_to_spi(wl), &m);
 
-	wl1271_dump(DEBUG_SPI, "spi_read cmd -> ", cmd, sizeof(*cmd));
-	wl1271_dump(DEBUG_SPI, "spi_read buf <- ", buf, len);
+		wl1271_dump(DEBUG_SPI, "spi_read cmd -> ", cmd, sizeof(*cmd));
+		wl1271_dump(DEBUG_SPI, "spi_read buf <- ", buf, chunk_len);
+
+		if (!fixed)
+			addr += chunk_len;
+		buf += chunk_len;
+		len -= chunk_len;
+	}
 }
 
 static void wl1271_spi_raw_write(struct wl1271 *wl, int addr, void *buf,
 			  size_t len, bool fixed)
 {
-	struct spi_transfer t[2];
+	struct spi_transfer t[2 * WSPI_MAX_NUM_OF_CHUNKS];
 	struct spi_message m;
+	u32 commands[WSPI_MAX_NUM_OF_CHUNKS];
 	u32 *cmd;
+	u32 chunk_len;
+	int i;
 
-	cmd = &wl->buffer_cmd;
-
-	*cmd = 0;
-	*cmd |= WSPI_CMD_WRITE;
-	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
-	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
-
-	if (fixed)
-		*cmd |= WSPI_CMD_FIXED;
+	WARN_ON(len > WL1271_AGGR_BUFFER_SIZE);
 
 	spi_message_init(&m);
 	memset(t, 0, sizeof(t));
 
-	t[0].tx_buf = cmd;
-	t[0].len = sizeof(*cmd);
-	spi_message_add_tail(&t[0], &m);
+	cmd = &commands[0];
+	i = 0;
+	while (len > 0) {
+		chunk_len = min((size_t)WSPI_MAX_CHUNK_SIZE, len);
 
-	t[1].tx_buf = buf;
-	t[1].len = len;
-	spi_message_add_tail(&t[1], &m);
+		*cmd = 0;
+		*cmd |= WSPI_CMD_WRITE;
+		*cmd |= (chunk_len << WSPI_CMD_BYTE_LENGTH_OFFSET) &
+			WSPI_CMD_BYTE_LENGTH;
+		*cmd |= addr & WSPI_CMD_BYTE_ADDR;
 
-	spi_sync(wl_to_spi(wl), &m);
+		if (fixed)
+			*cmd |= WSPI_CMD_FIXED;
+
+		t[i].tx_buf = cmd;
+		t[i].len = sizeof(*cmd);
+		spi_message_add_tail(&t[i++], &m);
+
+		t[i].tx_buf = buf;
+		t[i].len = chunk_len;
+		spi_message_add_tail(&t[i++], &m);
 
-	wl1271_dump(DEBUG_SPI, "spi_write cmd -> ", cmd, sizeof(*cmd));
-	wl1271_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
+		wl1271_dump(DEBUG_SPI, "spi_write cmd -> ", cmd, sizeof(*cmd));
+		wl1271_dump(DEBUG_SPI, "spi_write buf -> ", buf, chunk_len);
+
+		if (!fixed)
+			addr += chunk_len;
+		buf += chunk_len;
+		len -= chunk_len;
+		cmd++;
+	}
+
+	spi_sync(wl_to_spi(wl), &m);
 }
 
 static irqreturn_t wl1271_irq(int irq, void *cookie)
-- 
1.7.0.4

