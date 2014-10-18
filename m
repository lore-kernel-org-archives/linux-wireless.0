Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:49124
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751422AbaJRRCR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2014 13:02:17 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 04/10] ath9k: clean up debugfs print of reset causes
Date: Sat, 18 Oct 2014 19:02:06 +0200
Message-Id: <1413651732-69783-4-git-send-email-nbd@openwrt.org> (sfid-20141018_190237_746125_F2193826)
In-Reply-To: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
References: <1413651732-69783-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reduce code duplication

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c | 48 +++++++++++++++-------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 46f20a3..cf4a98b 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -852,36 +852,30 @@ static ssize_t read_file_reset(struct file *file, char __user *user_buf,
 			       size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
+	static const char * const reset_cause[__RESET_TYPE_MAX] = {
+		[RESET_TYPE_BB_HANG] = "Baseband Hang",
+		[RESET_TYPE_BB_WATCHDOG] = "Baseband Watchdog",
+		[RESET_TYPE_FATAL_INT] = "Fatal HW Error",
+		[RESET_TYPE_TX_ERROR] = "TX HW error",
+		[RESET_TYPE_TX_GTT] = "Transmit timeout",
+		[RESET_TYPE_TX_HANG] = "TX Path Hang",
+		[RESET_TYPE_PLL_HANG] = "PLL RX Hang",
+		[RESET_TYPE_MAC_HANG] = "MAC Hang",
+		[RESET_TYPE_BEACON_STUCK] = "Stuck Beacon",
+		[RESET_TYPE_MCI] = "MCI Reset",
+	};
 	char buf[512];
 	unsigned int len = 0;
+	int i;
 
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "Baseband Hang",
-			 sc->debug.stats.reset[RESET_TYPE_BB_HANG]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "Baseband Watchdog",
-			 sc->debug.stats.reset[RESET_TYPE_BB_WATCHDOG]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "Fatal HW Error",
-			 sc->debug.stats.reset[RESET_TYPE_FATAL_INT]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "TX HW error",
-			 sc->debug.stats.reset[RESET_TYPE_TX_ERROR]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "TX Path Hang",
-			 sc->debug.stats.reset[RESET_TYPE_TX_HANG]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "PLL RX Hang",
-			 sc->debug.stats.reset[RESET_TYPE_PLL_HANG]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "MAC Hang",
-			 sc->debug.stats.reset[RESET_TYPE_MAC_HANG]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "Stuck Beacon",
-			 sc->debug.stats.reset[RESET_TYPE_BEACON_STUCK]);
-	len += scnprintf(buf + len, sizeof(buf) - len,
-			 "%17s: %2d\n", "MCI Reset",
-			 sc->debug.stats.reset[RESET_TYPE_MCI]);
+	for (i = 0; i < ARRAY_SIZE(reset_cause); i++) {
+		if (!reset_cause[i])
+		    continue;
+
+		len += scnprintf(buf + len, sizeof(buf) - len,
+				 "%17s: %2d\n", reset_cause[i],
+				 sc->debug.stats.reset[i]);
+	}
 
 	if (len > sizeof(buf))
 		len = sizeof(buf);
-- 
2.0.4

