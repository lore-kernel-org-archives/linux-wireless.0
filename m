Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:47149 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab3LWHTj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Dec 2013 02:19:39 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org
Subject: [RFC 8/9] ath9k: Fix baseband watchdog reset
Date: Mon, 23 Dec 2013 12:44:25 +0530
Message-Id: <1387782866-19847-9-git-send-email-sujith@msujith.org> (sfid-20131223_081943_301710_EEF823C4)
In-Reply-To: <1387782866-19847-1-git-send-email-sujith@msujith.org>
References: <1387782866-19847-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Do a HW reset only for required signatures.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 894c892..24e2654 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -448,14 +448,8 @@ void ath9k_tasklet(unsigned long data)
 	ath9k_ps_wakeup(sc);
 	spin_lock(&sc->sc_pcu_lock);
 
-	if ((status & ATH9K_INT_FATAL) ||
-	    (status & ATH9K_INT_BB_WATCHDOG)) {
-
-		if (status & ATH9K_INT_FATAL)
-			type = RESET_TYPE_FATAL_INT;
-		else
-			type = RESET_TYPE_BB_WATCHDOG;
-
+	if (status & ATH9K_INT_FATAL) {
+		type = RESET_TYPE_FATAL_INT;
 		ath9k_queue_reset(sc, type);
 
 		/*
@@ -467,6 +461,23 @@ void ath9k_tasklet(unsigned long data)
 		goto out;
 	}
 
+	if ((ah->config.hw_hang_checks & HW_BB_WATCHDOG) &&
+	    (status & ATH9K_INT_BB_WATCHDOG)) {
+		if (ar9003_hw_bb_watchdog_check(ah)) {
+			type = RESET_TYPE_BB_WATCHDOG;
+			ath9k_queue_reset(sc, type);
+
+			/*
+			 * Increment the ref. counter here so that
+			 * interrupts are enabled in the reset routine.
+			 */
+			atomic_inc(&ah->intr_ref_cnt);
+			ath_dbg(common, ANY,
+				"BB_WATCHDOG: Skipping interrupts\n");
+			goto out;
+		}
+	}
+
 	spin_lock_irqsave(&sc->sc_pm_lock, flags);
 	if ((status & ATH9K_INT_TSFOOR) && sc->ps_enabled) {
 		/*
-- 
1.8.5.2

