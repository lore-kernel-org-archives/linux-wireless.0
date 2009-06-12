Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:64392 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZFLLPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:15:03 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 04/33] wl12xx: reserve buffer for partition command in struct
	wl12xx
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:14:41 +0300
Message-ID: <20090612111441.8877.77502.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

This is now DMA safe.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/spi.c |   22 ++++++++++++++--------
 drivers/net/wireless/wl12xx/spi.h |    6 +++---
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index abdf171..fb7c52c 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -167,24 +167,26 @@ void wl12xx_spi_init(struct wl12xx *wl)
  *                                    |    |
  *
  */
-void wl12xx_set_partition(struct wl12xx *wl,
+int wl12xx_set_partition(struct wl12xx *wl,
 			  u32 mem_start, u32 mem_size,
 			  u32 reg_start, u32 reg_size)
 {
-	u8 tx_buf[sizeof(u32) + 2 * sizeof(struct wl12xx_partition)];
 	struct wl12xx_partition *partition;
 	struct spi_transfer t;
 	struct spi_message m;
+	size_t len, cmd_len;
 	u32 *cmd;
-	size_t len;
 	int addr;
 
+	cmd_len = sizeof(u32) + 2 * sizeof(struct wl12xx_partition);
+	cmd = kzalloc(cmd_len, GFP_KERNEL);
+	if (!cmd)
+		return -ENOMEM;
+
 	spi_message_init(&m);
 	memset(&t, 0, sizeof(t));
-	memset(tx_buf, 0, sizeof(tx_buf));
 
-	cmd = (u32 *) tx_buf;
-	partition = (struct wl12xx_partition *) (tx_buf + sizeof(u32));
+	partition = (struct wl12xx_partition *) (cmd + 1);
 	addr = HW_ACCESS_PART0_SIZE_ADDR;
 	len = 2 * sizeof(struct wl12xx_partition);
 
@@ -244,11 +246,15 @@ void wl12xx_set_partition(struct wl12xx *wl,
 	wl->virtual_mem_addr = 0;
 	wl->virtual_reg_addr = mem_size;
 
-	t.tx_buf = tx_buf;
-	t.len = sizeof(tx_buf);
+	t.tx_buf = cmd;
+	t.len = cmd_len;
 	spi_message_add_tail(&t, &m);
 
 	spi_sync(wl->spi, &m);
+
+	kfree(cmd);
+
+	return 0;
 }
 
 void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
diff --git a/drivers/net/wireless/wl12xx/spi.h b/drivers/net/wireless/wl12xx/spi.h
index f3f1895..7edb218 100644
--- a/drivers/net/wireless/wl12xx/spi.h
+++ b/drivers/net/wireless/wl12xx/spi.h
@@ -88,9 +88,9 @@ void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val);
 /* INIT and RESET words */
 void wl12xx_spi_reset(struct wl12xx *wl);
 void wl12xx_spi_init(struct wl12xx *wl);
-void wl12xx_set_partition(struct wl12xx *wl,
-			  u32 part_start, u32 part_size,
-			  u32 reg_start,  u32 reg_size);
+int wl12xx_set_partition(struct wl12xx *wl,
+			 u32 part_start, u32 part_size,
+			 u32 reg_start,  u32 reg_size);
 
 static inline u32 wl12xx_read32(struct wl12xx *wl, int addr)
 {

