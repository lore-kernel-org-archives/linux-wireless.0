Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38931 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZFLLPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:15:03 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 05/33] wl12xx: allocate buffer spi read/write command buffer
	kzalloc()
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:14:47 +0300
Message-ID: <20090612111447.8877.10305.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Needed for DMA safe transfers.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/spi.c    |   34 +++++++++++++++++++---------------
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index fb7c52c..9392742 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -263,17 +263,19 @@ void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
 	struct spi_transfer t[3];
 	struct spi_message m;
 	char busy_buf[TNETWIF_READ_OFFSET_BYTES];
-	u32 cmd;
+	u32 *cmd;
 
-	cmd = 0;
-	cmd |= WSPI_CMD_READ;
-	cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
-	cmd |= addr & WSPI_CMD_BYTE_ADDR;
+	cmd = &wl->buffer_cmd;
+
+	*cmd = 0;
+	*cmd |= WSPI_CMD_READ;
+	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
+	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
 
 	spi_message_init(&m);
 	memset(t, 0, sizeof(t));
 
-	t[0].tx_buf = &cmd;
+	t[0].tx_buf = cmd;
 	t[0].len = 4;
 	spi_message_add_tail(&t[0], &m);
 
@@ -290,7 +292,7 @@ void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
 
 	/* FIXME: check busy words */
 
-	wl12xx_dump(DEBUG_SPI, "spi_read cmd -> ", &cmd, sizeof(cmd));
+	wl12xx_dump(DEBUG_SPI, "spi_read cmd -> ", cmd, sizeof(*cmd));
 	wl12xx_dump(DEBUG_SPI, "spi_read buf <- ", buf, len);
 }
 
@@ -299,18 +301,20 @@ void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
 {
 	struct spi_transfer t[2];
 	struct spi_message m;
-	u32 cmd;
+	u32 *cmd;
 
-	cmd = 0;
-	cmd |= WSPI_CMD_WRITE;
-	cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
-	cmd |= addr & WSPI_CMD_BYTE_ADDR;
+	cmd = &wl->buffer_cmd;
+
+	*cmd = 0;
+	*cmd |= WSPI_CMD_WRITE;
+	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
+	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
 
 	spi_message_init(&m);
 	memset(t, 0, sizeof(t));
 
-	t[0].tx_buf = &cmd;
-	t[0].len = sizeof(cmd);
+	t[0].tx_buf = cmd;
+	t[0].len = sizeof(*cmd);
 	spi_message_add_tail(&t[0], &m);
 
 	t[1].tx_buf = buf;
@@ -319,7 +323,7 @@ void wl12xx_spi_write(struct wl12xx *wl, int addr, void *buf,
 
 	spi_sync(wl->spi, &m);
 
-	wl12xx_dump(DEBUG_SPI, "spi_write cmd -> ", &cmd, sizeof(cmd));
+	wl12xx_dump(DEBUG_SPI, "spi_write cmd -> ", cmd, sizeof(*cmd));
 	wl12xx_dump(DEBUG_SPI, "spi_write buf -> ", buf, len);
 }
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index f252a11..5865935 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -384,6 +384,7 @@ struct wl12xx {
 	struct wl12xx_debugfs debugfs;
 
 	u32 buffer_32;
+	u32 buffer_cmd;
 };
 
 int wl12xx_plt_start(struct wl12xx *wl);

