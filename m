Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:65013 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755438Ab0DWE6h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 00:58:37 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 21:58:37 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19409.10470.219183.680579@gargle.gargle.HOWL>
Date: Fri, 23 Apr 2010 10:28:14 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/11] ath9k_hw: Remove pointless ANI deinit
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is no reason to disable the PHY Error / MIB counters
when the module is being unloaded.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c |    9 ---------
 drivers/net/wireless/ath/ath9k/ani.h |    1 -
 drivers/net/wireless/ath/ath9k/hw.c  |    3 ---
 3 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index cec62d3..ba8b20f 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -657,12 +657,3 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 	if (ah->config.enable_ani)
 		ah->proc_phyerr |= HAL_PROCESS_ANI;
 }
-
-void ath9k_hw_ani_disable(struct ath_hw *ah)
-{
-	ath_print(ath9k_hw_common(ah), ATH_DBG_ANI, "Disabling ANI\n");
-
-	ath9k_hw_disable_mib_counters(ah);
-	REG_WRITE(ah, AR_PHY_ERR_1, 0);
-	REG_WRITE(ah, AR_PHY_ERR_2, 0);
-}
diff --git a/drivers/net/wireless/ath/ath9k/ani.h b/drivers/net/wireless/ath/ath9k/ani.h
index 4e1ab94..3356762 100644
--- a/drivers/net/wireless/ath/ath9k/ani.h
+++ b/drivers/net/wireless/ath/ath9k/ani.h
@@ -118,6 +118,5 @@ u32 ath9k_hw_GetMibCycleCountsPct(struct ath_hw *ah, u32 *rxc_pcnt,
 void ath9k_hw_procmibevent(struct ath_hw *ah);
 void ath9k_hw_ani_setup(struct ath_hw *ah);
 void ath9k_hw_ani_init(struct ath_hw *ah);
-void ath9k_hw_ani_disable(struct ath_hw *ah);
 
 #endif /* ANI_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 5a29048..2d18892 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -819,9 +819,6 @@ void ath9k_hw_deinit(struct ath_hw *ah)
 	if (common->state < ATH_HW_INITIALIZED)
 		goto free_hw;
 
-	if (!AR_SREV_9100(ah))
-		ath9k_hw_ani_disable(ah);
-
 	ath9k_hw_setpower(ah, ATH9K_PM_FULL_SLEEP);
 
 free_hw:
-- 
1.7.0.5

