Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:41680 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab2I0Kio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 06:38:44 -0400
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 20/31] wlcore: spi: use private max-buf-size limit
Date: Thu, 27 Sep 2012 13:37:58 +0300
Message-Id: <1348742289-6587-21-git-send-email-luca@coelho.fi> (sfid-20120927_123900_471855_664BA794)
In-Reply-To: <1348742289-6587-1-git-send-email-luca@coelho.fi>
References: <1348742289-6587-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Limit SPI transmissions to the wl12xx max buffer size, as only 12xx was
tested with SPI.

This allows us to remove the global aggregation buffer constant.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <luca@coelho.fi>
---
 drivers/net/wireless/ti/wlcore/spi.c      |   10 ++++++++--
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    2 --
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 8da4ed2..a519bc3 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -66,7 +66,13 @@
 /* HW limitation: maximum possible chunk size is 4095 bytes */
 #define WSPI_MAX_CHUNK_SIZE    4092
 
-#define WSPI_MAX_NUM_OF_CHUNKS (WL1271_AGGR_BUFFER_SIZE / WSPI_MAX_CHUNK_SIZE)
+/*
+ * only support SPI for 12xx - this code should be reworked when 18xx
+ * support is introduced
+ */
+#define SPI_AGGR_BUFFER_SIZE (4 * PAGE_SIZE)
+
+#define WSPI_MAX_NUM_OF_CHUNKS (SPI_AGGR_BUFFER_SIZE / WSPI_MAX_CHUNK_SIZE)
 
 struct wl12xx_spi_glue {
 	struct device *dev;
@@ -271,7 +277,7 @@ static int __must_check wl12xx_spi_raw_write(struct device *child, int addr,
 	u32 chunk_len;
 	int i;
 
-	WARN_ON(len > WL1271_AGGR_BUFFER_SIZE);
+	WARN_ON(len > SPI_AGGR_BUFFER_SIZE);
 
 	spi_message_init(&m);
 	memset(t, 0, sizeof(t));
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 58fbdca..a7472bf 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -83,8 +83,6 @@
 #define WL1271_AP_BSS_INDEX        0
 #define WL1271_AP_DEF_BEACON_EXP   20
 
-#define WL1271_AGGR_BUFFER_SIZE (5 * PAGE_SIZE)
-
 enum wlcore_state {
 	WLCORE_STATE_OFF,
 	WLCORE_STATE_RESTARTING,
-- 
1.7.10.4

