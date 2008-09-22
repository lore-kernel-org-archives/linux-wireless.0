Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39168 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686AbYIVIOF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 04:14:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Add a few comments about mibevents
Date: Mon, 22 Sep 2008 01:14:02 -0700
Message-ID: <1222071242-21149-1-git-send-email-lrodriguez@atheros.com> (sfid-20080922_101410_655081_3DC31A47)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 0251e59..272c758 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2526,6 +2526,11 @@ static void ath9k_ani_reset(struct ath_hal *ah)
 	}
 }
 
+/*
+ * Process a MIB interrupt.  We may potentially be invoked because
+ * any of the MIB counters overflow/trigger so don't assume we're
+ * here because a PHY error counter triggered.
+ */
 void ath9k_hw_procmibevent(struct ath_hal *ah,
 			   const struct ath9k_node_stats *stats)
 {
@@ -2533,18 +2538,20 @@ void ath9k_hw_procmibevent(struct ath_hal *ah,
 	u32 phyCnt1, phyCnt2;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_ANI, "Processing Mib Intr\n");
-
+	/* Reset these counters regardless */
 	REG_WRITE(ah, AR_FILT_OFDM, 0);
 	REG_WRITE(ah, AR_FILT_CCK, 0);
 	if (!(REG_READ(ah, AR_SLP_MIB_CTRL) & AR_SLP_MIB_PENDING))
 		REG_WRITE(ah, AR_SLP_MIB_CTRL, AR_SLP_MIB_CLEAR);
 
+	/* Clear the mib counters and save them in the stats */
 	ath9k_hw_update_mibstats(ah, &ahp->ah_mibStats);
 	ahp->ah_stats.ast_nodestats = *stats;
 
 	if (!DO_ANI(ah))
 		return;
 
+	/* NB: these are not reset-on-read */
 	phyCnt1 = REG_READ(ah, AR_PHY_ERR_1);
 	phyCnt2 = REG_READ(ah, AR_PHY_ERR_2);
 	if (((phyCnt1 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK) ||
@@ -2552,6 +2559,7 @@ void ath9k_hw_procmibevent(struct ath_hal *ah,
 		struct ar5416AniState *aniState = ahp->ah_curani;
 		u32 ofdmPhyErrCnt, cckPhyErrCnt;
 
+		/* NB: only use ast_ani_*errs with AH_PRIVATE_DIAG */
 		ofdmPhyErrCnt = phyCnt1 - aniState->ofdmPhyErrBase;
 		ahp->ah_stats.ast_ani_ofdmerrs +=
 			ofdmPhyErrCnt - aniState->ofdmPhyErrCount;
@@ -2562,11 +2570,17 @@ void ath9k_hw_procmibevent(struct ath_hal *ah,
 			cckPhyErrCnt - aniState->cckPhyErrCount;
 		aniState->cckPhyErrCount = cckPhyErrCnt;
 
+		/*
+		 * NB: figure out which counter triggered.  If both
+		 * trigger we'll only deal with one as the processing
+		 * clobbers the error counter so the trigger threshold
+		 * check will never be true.
+		 */
 		if (aniState->ofdmPhyErrCount > aniState->ofdmTrigHigh)
 			ath9k_hw_ani_ofdm_err_trigger(ah);
 		if (aniState->cckPhyErrCount > aniState->cckTrigHigh)
 			ath9k_hw_ani_cck_err_trigger(ah);
-
+		/* NB: always restart to insure the h/w counters are reset */
 		ath9k_ani_restart(ah);
 	}
 }
-- 
1.5.6.rc2.15.g457bb.dirty

