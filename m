Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:58373 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab3LXFTk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Dec 2013 00:19:40 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/11] ath9k: Process BB watchdog events in the tasklet
Date: Tue, 24 Dec 2013 10:44:26 +0530
Message-Id: <1387862067-25457-10-git-send-email-sujith@msujith.org> (sfid-20131224_062002_011703_003BED97)
In-Reply-To: <1387862067-25457-1-git-send-email-sujith@msujith.org>
References: <1387862067-25457-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Move the BB processing code to the tasklet and avoid
doing it in the ISR, there is no real benefit and this
makes the ISR less heavy.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 212652f..3900fa5 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -457,6 +457,11 @@ void ath9k_tasklet(unsigned long data)
 
 	if ((ah->config.hw_hang_checks & HW_BB_WATCHDOG) &&
 	    (status & ATH9K_INT_BB_WATCHDOG)) {
+		spin_lock(&common->cc_lock);
+		ath_hw_cycle_counters_update(common);
+		ar9003_hw_bb_watchdog_dbg_info(ah);
+		spin_unlock(&common->cc_lock);
+
 		if (ar9003_hw_bb_watchdog_check(ah)) {
 			type = RESET_TYPE_BB_WATCHDOG;
 			ath9k_queue_reset(sc, type);
@@ -593,15 +598,8 @@ irqreturn_t ath_isr(int irq, void *dev)
 		goto chip_reset;
 
 	if ((ah->config.hw_hang_checks & HW_BB_WATCHDOG) &&
-	    (status & ATH9K_INT_BB_WATCHDOG)) {
-
-		spin_lock(&common->cc_lock);
-		ath_hw_cycle_counters_update(common);
-		ar9003_hw_bb_watchdog_dbg_info(ah);
-		spin_unlock(&common->cc_lock);
-
+	    (status & ATH9K_INT_BB_WATCHDOG))
 		goto chip_reset;
-	}
 
 #ifdef CONFIG_ATH9K_WOW
 	if (status & ATH9K_INT_BMISS) {
-- 
1.8.5.2

