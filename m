Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:38933 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbZFLLPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:15:04 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 06/33] wl12xx: allocate buffer the spi busy word from struct
	wl12xx
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:14:55 +0300
Message-ID: <20090612111454.8877.38762.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Needed for DMA transfers.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/spi.c    |    5 +++--
 drivers/net/wireless/wl12xx/spi.h    |    3 +--
 drivers/net/wireless/wl12xx/wl12xx.h |    2 ++
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 9392742..bcdcfbc 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -262,10 +262,11 @@ void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
 {
 	struct spi_transfer t[3];
 	struct spi_message m;
-	char busy_buf[TNETWIF_READ_OFFSET_BYTES];
+	u8 *busy_buf;
 	u32 *cmd;
 
 	cmd = &wl->buffer_cmd;
+	busy_buf = wl->buffer_busyword;
 
 	*cmd = 0;
 	*cmd |= WSPI_CMD_READ;
@@ -281,7 +282,7 @@ void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
 
 	/* Busy and non busy words read */
 	t[1].rx_buf = busy_buf;
-	t[1].len = TNETWIF_READ_OFFSET_BYTES;
+	t[1].len = WL12XX_BUSY_WORD_LEN;
 	spi_message_add_tail(&t[1], &m);
 
 	t[2].rx_buf = buf;
diff --git a/drivers/net/wireless/wl12xx/spi.h b/drivers/net/wireless/wl12xx/spi.h
index 7edb218..1a19557 100644
--- a/drivers/net/wireless/wl12xx/spi.h
+++ b/drivers/net/wireless/wl12xx/spi.h
@@ -65,9 +65,8 @@
 
 #define WSPI_INIT_CMD_LEN           8
 
-#define TNETWIF_READ_OFFSET_BYTES  8
 #define HW_ACCESS_WSPI_FIXED_BUSY_LEN \
-		((TNETWIF_READ_OFFSET_BYTES - 4) / sizeof(u32))
+		((WL12XX_BUSY_WORD_LEN - 4) / sizeof(u32))
 #define HW_ACCESS_WSPI_INIT_CMD_MASK  0
 
 
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 5865935..b811020 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -105,6 +105,7 @@ enum {
 				  CFG_RX_AUTH_EN |  \
 				  CFG_RX_ASSOC_EN)
 
+#define WL12XX_BUSY_WORD_LEN 8
 
 struct boot_attr {
 	u32 radio_type;
@@ -385,6 +386,7 @@ struct wl12xx {
 
 	u32 buffer_32;
 	u32 buffer_cmd;
+	u8 buffer_busyword[WL12XX_BUSY_WORD_LEN];
 };
 
 int wl12xx_plt_start(struct wl12xx *wl);

