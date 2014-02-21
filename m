Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48860 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbaBUKpm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 05:45:42 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath9k: list more reset causes in debugfs
Date: Fri, 21 Feb 2014 11:45:36 +0100
Message-Id: <1392979536-68161-1-git-send-email-nbd@openwrt.org> (sfid-20140221_114546_415183_A0E1B713)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Number of MAC hangs and stuck beacons were missing

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/debug.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index ab7264c..f42ed3b 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -866,6 +866,12 @@ static ssize_t read_file_reset(struct file *file, char __user *user_buf,
 			 "%17s: %2d\n", "PLL RX Hang",
 			 sc->debug.stats.reset[RESET_TYPE_PLL_HANG]);
 	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%17s: %2d\n", "MAC Hang",
+			 sc->debug.stats.reset[RESET_TYPE_MAC_HANG]);
+	len += scnprintf(buf + len, sizeof(buf) - len,
+			 "%17s: %2d\n", "Stuck Beacon",
+			 sc->debug.stats.reset[RESET_TYPE_BEACON_STUCK]);
+	len += scnprintf(buf + len, sizeof(buf) - len,
 			 "%17s: %2d\n", "MCI Reset",
 			 sc->debug.stats.reset[RESET_TYPE_MCI]);
 
-- 
1.8.3.4 (Apple Git-47)

