Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36129 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933766AbZJMJuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:50:13 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 10/22] wl1271: Remove busy-word checking
Date: Tue, 13 Oct 2009 12:47:47 +0300
Message-Id: <1255427279-1224-11-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Remove busy-word checking to work around an SPI bug. To reduce the
chance of chipset-busy scenarios, increment the number of fixed busy
words.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h     |    6 ++++--
 drivers/net/wireless/wl12xx/wl1271_spi.c |    6 +++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 648223f..e0ebb1f 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -115,9 +115,11 @@ enum {
 /*
  * FIXME: for the wl1271, a busy word count of 1 here will result in a more
  * optimal SPI interface. There is some SPI bug however, causing RXS time outs
- * with this mode occasionally on boot, so lets have two for now.
+ * with this mode occasionally on boot, so lets have three for now. A value of
+ * three should make sure, that the chipset will always be ready, though this
+ * will impact throughput and latencies slightly.
  */
-#define WL1271_BUSY_WORD_CNT 2
+#define WL1271_BUSY_WORD_CNT 3
 #define WL1271_BUSY_WORD_LEN (WL1271_BUSY_WORD_CNT * sizeof(u32))
 
 #define WL1271_ELP_HW_STATE_ASLEEP 0
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index 4800fdf..3c5aa58 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -294,9 +294,9 @@ void wl1271_spi_raw_read(struct wl1271 *wl, int addr, void *buf,
 
 	spi_sync(wl->spi, &m);
 
-	/* Check busy words */
-	if (!(busy_buf[WL1271_BUSY_WORD_CNT - 1] & 0x1))
-		wl1271_spi_read_busy(wl, buf, len);
+	/* FIXME: Check busy words, removed due to SPI bug */
+	/* if (!(busy_buf[WL1271_BUSY_WORD_CNT - 1] & 0x1))
+	   wl1271_spi_read_busy(wl, buf, len); */
 
 	wl1271_dump(DEBUG_SPI, "spi_read cmd -> ", cmd, sizeof(*cmd));
 	wl1271_dump(DEBUG_SPI, "spi_read buf <- ", buf, len);
-- 
1.5.6.5

