Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58685 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757424Ab1INTXS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 15:23:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 1/3] ath9k: fix enabling interrupts after a hardware error interrupt
Date: Wed, 14 Sep 2011 21:23:01 +0200
Message-Id: <1316028183-33734-1-git-send-email-nbd@openwrt.org> (sfid-20110914_212323_850843_63E47282)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The interrupt handler increases the interrupt disable refcount, so the
tasklet needs to always call ath9k_hw_enable_interrupts.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8a17cff5..a3c3316 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -669,15 +669,15 @@ void ath9k_tasklet(unsigned long data)
 	u32 status = sc->intrstatus;
 	u32 rxmask;
 
+	ath9k_ps_wakeup(sc);
+	spin_lock(&sc->sc_pcu_lock);
+
 	if ((status & ATH9K_INT_FATAL) ||
 	    (status & ATH9K_INT_BB_WATCHDOG)) {
 		ieee80211_queue_work(sc->hw, &sc->hw_reset_work);
-		return;
+		goto out;
 	}
 
-	ath9k_ps_wakeup(sc);
-	spin_lock(&sc->sc_pcu_lock);
-
 	/*
 	 * Only run the baseband hang check if beacons stop working in AP or
 	 * IBSS mode, because it has a high false positive rate. For station
@@ -725,6 +725,7 @@ void ath9k_tasklet(unsigned long data)
 		if (status & ATH9K_INT_GENTIMER)
 			ath_gen_timer_isr(sc->sc_ah);
 
+out:
 	/* re-enable hardware interrupt */
 	ath9k_hw_enable_interrupts(ah);
 
-- 
1.7.3.2

