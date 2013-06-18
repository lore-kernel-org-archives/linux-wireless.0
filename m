Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45970 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3FREql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 00:46:41 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] ath9k: Merge HWTIMER debug level with BTCOEX
Date: Tue, 18 Jun 2013 10:13:39 +0530
Message-Id: <1371530623-15746-1-git-send-email-sujith@msujith.org> (sfid-20130618_064643_582241_D18F0B04)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath.h      | 13 ++++++-------
 drivers/net/wireless/ath/ath9k/hw.c |  6 +++---
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index 4521342..daeafef 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -239,13 +239,12 @@ enum ATH_DEBUG {
 	ATH_DBG_CONFIG		= 0x00000200,
 	ATH_DBG_FATAL		= 0x00000400,
 	ATH_DBG_PS		= 0x00000800,
-	ATH_DBG_HWTIMER		= 0x00001000,
-	ATH_DBG_BTCOEX		= 0x00002000,
-	ATH_DBG_WMI		= 0x00004000,
-	ATH_DBG_BSTUCK		= 0x00008000,
-	ATH_DBG_MCI		= 0x00010000,
-	ATH_DBG_DFS		= 0x00020000,
-	ATH_DBG_WOW		= 0x00040000,
+	ATH_DBG_BTCOEX		= 0x00001000,
+	ATH_DBG_WMI		= 0x00002000,
+	ATH_DBG_BSTUCK		= 0x00004000,
+	ATH_DBG_MCI		= 0x00008000,
+	ATH_DBG_DFS		= 0x00010000,
+	ATH_DBG_WOW		= 0x00020000,
 	ATH_DBG_ANY		= 0xffffffff
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ca9d9cd..5324c33 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3042,7 +3042,7 @@ void ath9k_hw_gen_timer_start(struct ath_hw *ah,
 
 	timer_next = tsf + trig_timeout;
 
-	ath_dbg(ath9k_hw_common(ah), HWTIMER,
+	ath_dbg(ath9k_hw_common(ah), BTCOEX,
 		"current tsf %x period %x timer_next %x\n",
 		tsf, timer_period, timer_next);
 
@@ -3141,7 +3141,7 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 		index = rightmost_index(timer_table, &thresh_mask);
 		timer = timer_table->timers[index];
 		BUG_ON(!timer);
-		ath_dbg(common, HWTIMER, "TSF overflow for Gen timer %d\n",
+		ath_dbg(common, BTCOEX, "TSF overflow for Gen timer %d\n",
 			index);
 		timer->overflow(timer->arg);
 	}
@@ -3150,7 +3150,7 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 		index = rightmost_index(timer_table, &trigger_mask);
 		timer = timer_table->timers[index];
 		BUG_ON(!timer);
-		ath_dbg(common, HWTIMER,
+		ath_dbg(common, BTCOEX,
 			"Gen timer[%d] trigger\n", index);
 		timer->trigger(timer->arg);
 	}
-- 
1.8.3.1

