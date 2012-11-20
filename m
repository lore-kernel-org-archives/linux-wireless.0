Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:25561 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab2KTM75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 07:59:57 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/3] ath9k: Process FATAL interrupts at first
Date: Tue, 20 Nov 2012 18:29:59 +0530
Message-ID: <1353416401-5328-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121120_140001_824623_15ADE08F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FATAL and WATCHDOG interrupts should be processed first followed
by others.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9594b6f..e59d8e3 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -494,17 +494,6 @@ irqreturn_t ath_isr(int irq, void *dev)
 	if (status & SCHED_INTR)
 		sched = true;
 
-#ifdef CONFIG_PM_SLEEP
-	if (status & ATH9K_INT_BMISS) {
-		if (atomic_read(&sc->wow_sleep_proc_intr) == 0) {
-			ath_dbg(common, ANY, "during WoW we got a BMISS\n");
-			atomic_inc(&sc->wow_got_bmiss_intr);
-			atomic_dec(&sc->wow_sleep_proc_intr);
-		}
-	ath_dbg(common, INTERRUPT, "beacon miss interrupt\n");
-	}
-#endif
-
 	/*
 	 * If a FATAL or RXORN interrupt is received, we have to reset the
 	 * chip immediately.
@@ -523,7 +512,15 @@ irqreturn_t ath_isr(int irq, void *dev)
 
 		goto chip_reset;
 	}
-
+#ifdef CONFIG_PM_SLEEP
+	if (status & ATH9K_INT_BMISS) {
+		if (atomic_read(&sc->wow_sleep_proc_intr) == 0) {
+			ath_dbg(common, ANY, "during WoW we got a BMISS\n");
+			atomic_inc(&sc->wow_got_bmiss_intr);
+			atomic_dec(&sc->wow_sleep_proc_intr);
+		}
+	}
+#endif
 	if (status & ATH9K_INT_SWBA)
 		tasklet_schedule(&sc->bcon_tasklet);
 
-- 
1.8.0

