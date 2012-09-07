Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:24319 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932968Ab2IGKYh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 06:24:37 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qca.qualcomm.com>
Subject: [PATCH] ath9k: Add Generic hardware timer interrupt in debugfs
Date: Fri, 7 Sep 2012 15:54:13 +0530
Message-ID: <1347013453-15255-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120907_122455_063840_8807AA13)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Having generic hardware timer interrupt in debugfs
would come handy when we are debugging 3 WIRE
BTCOEX issues.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    3 +++
 drivers/net/wireless/ath/ath9k/debug.h |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 68b643c..ab3bc85 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -373,6 +373,8 @@ void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status)
 		sc->debug.stats.istats.tsfoor++;
 	if (status & ATH9K_INT_MCI)
 		sc->debug.stats.istats.mci++;
+	if (status & ATH9K_INT_GENTIMER)
+		sc->debug.stats.istats.gen_timer++;
 }
 
 static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
@@ -418,6 +420,7 @@ static ssize_t read_file_interrupt(struct file *file, char __user *user_buf,
 	PR_IS("DTIM", dtim);
 	PR_IS("TSFOOR", tsfoor);
 	PR_IS("MCI", mci);
+	PR_IS("GENTIMER", gen_timer);
 	PR_IS("TOTAL", total);
 
 	len += snprintf(buf + len, mxlen - len,
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 8b9d080..61341cd 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -74,6 +74,8 @@ enum ath_reset_type {
  * from a beacon differs from the PCU's internal TSF by more than a
  * (programmable) threshold
  * @local_timeout: Internal bus timeout.
+ * @mci: MCI interrupt, specific to MCI based BTCOEX chipsets
+ * @gen_timer: Generic hardware timer interrupt
  */
 struct ath_interrupt_stats {
 	u32 total;
@@ -100,6 +102,7 @@ struct ath_interrupt_stats {
 	u32 bb_watchdog;
 	u32 tsfoor;
 	u32 mci;
+	u32 gen_timer;
 
 	/* Sync-cause stats */
 	u32 sync_cause_all;
-- 
1.7.0.4

