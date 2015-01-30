Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59044 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531AbbA3Ncv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:32:51 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgo-004FiR-1s
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:32:50 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 08/17] ath9k: Remove unused BMISS processing
Date: Fri, 30 Jan 2015 19:05:28 +0530
Message-Id: <1422624937-4810-9-git-send-email-sujith@msujith.org> (sfid-20150130_143351_257656_E640C6CF)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The various variables tracking bmiss interrupts
are not really used anywhere except in a debug
message. Remove them since they have no functional
purpose.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  2 --
 drivers/net/wireless/ath/ath9k/main.c  |  9 ---------
 drivers/net/wireless/ath/ath9k/wow.c   | 18 ------------------
 3 files changed, 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 4209d7b..803a7d4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -1043,8 +1043,6 @@ struct ath_softc {
 	s16 tx99_power;
 
 #ifdef CONFIG_ATH9K_WOW
-	atomic_t wow_got_bmiss_intr;
-	atomic_t wow_sleep_proc_intr; /* in the middle of WoW sleep ? */
 	u32 wow_intr_before_sleep;
 #endif
 };
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 62b0bf4..9ede991 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -555,15 +555,6 @@ irqreturn_t ath_isr(int irq, void *dev)
 	    (status & ATH9K_INT_BB_WATCHDOG))
 		goto chip_reset;
 
-#ifdef CONFIG_ATH9K_WOW
-	if (status & ATH9K_INT_BMISS) {
-		if (atomic_read(&sc->wow_sleep_proc_intr) == 0) {
-			atomic_inc(&sc->wow_got_bmiss_intr);
-			atomic_dec(&sc->wow_sleep_proc_intr);
-		}
-	}
-#endif
-
 	if (status & ATH9K_INT_SWBA)
 		tasklet_schedule(&sc->bcon_tasklet);
 
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index c0c564d..fa60dbb 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -269,7 +269,6 @@ int ath9k_suspend(struct ieee80211_hw *hw,
 
 	ath9k_ps_restore(sc);
 	ath_dbg(common, WOW, "Suspend with WoW triggers: 0x%x\n", triggers);
-	atomic_inc(&sc->wow_sleep_proc_intr);
 
 	set_bit(ATH_OP_WOW_ENABLED, &common->op_flags);
 fail_wow:
@@ -299,19 +298,6 @@ int ath9k_resume(struct ieee80211_hw *hw)
 
 	wow_status = ath9k_hw_wow_wakeup(ah);
 
-	if (atomic_read(&sc->wow_got_bmiss_intr) == 0) {
-		/*
-		 * some devices may not pick beacon miss
-		 * as the reason they woke up so we add
-		 * that here for that shortcoming.
-		 */
-		wow_status |= AH_WOW_BEACON_MISS;
-		atomic_dec(&sc->wow_got_bmiss_intr);
-		ath_dbg(common, ANY, "Beacon miss interrupt picked up during WoW sleep\n");
-	}
-
-	atomic_dec(&sc->wow_sleep_proc_intr);
-
 	if (wow_status) {
 		ath_dbg(common, ANY, "Waking up due to WoW triggers %s with WoW status = %x\n",
 			ath9k_hw_wow_event_to_string(wow_status), wow_status);
@@ -347,10 +333,6 @@ void ath9k_init_wow(struct ieee80211_hw *hw)
 
 	if (sc->driver_data & ATH9K_PCI_WOW) {
 		hw->wiphy->wowlan = &ath9k_wowlan_support;
-
-		atomic_set(&sc->wow_sleep_proc_intr, -1);
-		atomic_set(&sc->wow_got_bmiss_intr, -1);
-
 		device_init_wakeup(sc->dev, 1);
 	}
 }
-- 
2.2.2

