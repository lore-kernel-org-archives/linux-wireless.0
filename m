Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:41410 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581Ab1DVL5K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2011 07:57:10 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 22 Apr 2011 04:56:43 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<Senthilkumar.Balasubramanian@Atheros.com>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH] ath9k: Add TSFOOR interrupt stats in debug info
Date: Fri, 22 Apr 2011 17:27:01 +0530
Message-ID: <1303473421-2899-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

This helped the developers to fix an issue of chip not entering network
sleep during idle state, previously this was only available as a debug
message

Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    5 +++++
 drivers/net/wireless/ath/ath9k/debug.h |    4 ++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 34f191e..bad1a87 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -326,6 +326,8 @@ void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status)
 		sc->debug.stats.istats.dtimsync++;
 	if (status & ATH9K_INT_DTIM)
 		sc->debug.stats.istats.dtim++;
+	if (status & ATH9K_INT_TSFOOR)
+		sc->debug.stats.istats.tsfoor++;
 }
 
 static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
@@ -380,8 +382,11 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, sizeof(buf) - len,
 		"%8s: %10u\n", "DTIM", sc->debug.stats.istats.dtim);
 	len += snprintf(buf + len, sizeof(buf) - len,
+		"%8s: %10u\n", "TSFOOR", sc->debug.stats.istats.tsfoor);
+	len += snprintf(buf + len, sizeof(buf) - len,
 		"%8s: %10u\n", "TOTAL", sc->debug.stats.istats.total);
 
+
 	if (len > sizeof(buf))
 		len = sizeof(buf);
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 1f9f8ea..5488a32 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -54,6 +54,9 @@ struct ath_buf;
  * @dtimsync: DTIM sync lossage
  * @dtim: RX Beacon with DTIM
  * @bb_watchdog: Baseband watchdog
+ * @tsfoor: TSF out of range, indicates that the corrected TSF received
+ * from a beacon differs from the PCU's internal TSF by more than a
+ * (programmable) threshold
  */
 struct ath_interrupt_stats {
 	u32 total;
@@ -78,6 +81,7 @@ struct ath_interrupt_stats {
 	u32 dtimsync;
 	u32 dtim;
 	u32 bb_watchdog;
+	u32 tsfoor;
 };
 
 /**
-- 
1.7.0.4

