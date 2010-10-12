Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:40832 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932477Ab0JLOIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 10:08:10 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/3] ath9k_hw: fix division by zero in the ANI monitor code
Date: Tue, 12 Oct 2010 16:08:01 +0200
Message-Id: <1286892483-71182-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit "ath9k_hw: remove code duplication in phy error counter handling"
split off some duplicate code into a separate function, but did not have a
return code for aborting ANI processing based on counter values.
This introduced a divide by zero issue.
This patch adds the missing return code check in ath9k_hw_ani_monitor

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 3aa8fb1..9297f57 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -633,7 +633,7 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 	REGWRITE_BUFFER_FLUSH(ah);
 }
 
-static void ath9k_hw_ani_read_counters(struct ath_hw *ah)
+static bool ath9k_hw_ani_read_counters(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ar5416AniState *aniState = &ah->curchan->ani;
@@ -646,10 +646,10 @@ static void ath9k_hw_ani_read_counters(struct ath_hw *ah)
 	ath_hw_cycle_counters_update(common);
 	listenTime = ath_hw_get_listen_time(common);
 
-	if (listenTime < 0) {
+	if (listenTime <= 0) {
 		ah->stats.ast_ani_lneg++;
 		ath9k_ani_restart(ah);
-		return;
+		return false;
 	}
 
 	if (!use_new_ani(ah)) {
@@ -683,7 +683,7 @@ static void ath9k_hw_ani_read_counters(struct ath_hw *ah)
 			REG_WRITE(ah, AR_PHY_ERR_MASK_2,
 				  AR_PHY_ERR_CCK_TIMING);
 		}
-		return;
+		return false;
 	}
 
 	ofdmPhyErrCnt = phyCnt1 - ofdm_base;
@@ -695,7 +695,7 @@ static void ath9k_hw_ani_read_counters(struct ath_hw *ah)
 	ah->stats.ast_ani_cckerrs +=
 		cckPhyErrCnt - aniState->cckPhyErrCount;
 	aniState->cckPhyErrCount = cckPhyErrCnt;
-
+	return true;
 }
 
 void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan)
@@ -711,7 +711,8 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan)
 	if (WARN_ON(!aniState))
 		return;
 
-	ath9k_hw_ani_read_counters(ah);
+	if (!ath9k_hw_ani_read_counters(ah))
+		return;
 
 	ofdmPhyErrRate = aniState->ofdmPhyErrCount * 1000 /
 			 aniState->listenTime;
-- 
1.7.2.2

