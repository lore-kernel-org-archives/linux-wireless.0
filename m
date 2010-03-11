Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46908 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab0CKB2c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 20:28:32 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 11/14] ath9k_hw: add a helper for phy error counter reads
Date: Wed, 10 Mar 2010 20:28:28 -0500
Message-Id: <1268270911-24568-12-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
References: <1268270911-24568-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This lets us now share more ANI routines accross different
chipsets.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 52852fc..7e87cf4 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -316,6 +316,14 @@ static void ath9k_hw_update_phy_err_count(struct ath_hw *ah,
 	ath9k_hw_update_phy_err2_count(ah, phy_err_count2, reset_masks);
 }
 
+static void ath9k_hw_get_phy_err_count(struct ath_hw *ah,
+				       u32 *phy_err_count1,
+				       u32 *phy_err_count2)
+{
+	*phy_err_count1 = REG_READ(ah, AR_PHY_ERR_1);
+	*phy_err_count2 = REG_READ(ah, AR_PHY_ERR_2);
+}
+
 static void ath9k_ani_restart(struct ath_hw *ah)
 {
 	struct ar5416AniState *aniState;
@@ -653,9 +661,7 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah,
 	aniState->listenTime += listenTime;
 
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
-
-	phyCnt1 = REG_READ(ah, AR_PHY_ERR_1);
-	phyCnt2 = REG_READ(ah, AR_PHY_ERR_2);
+	ath9k_hw_get_phy_err_count(ah, &phyCnt1, &phyCnt2);
 
 	if (phyCnt1 < aniState->ofdmPhyErrBase ||
 	    phyCnt2 < aniState->cckPhyErrBase) {
@@ -807,8 +813,8 @@ void ath9k_hw_procmibevent(struct ath_hw *ah)
 		return;
 
 	/* NB: these are not reset-on-read */
-	phyCnt1 = REG_READ(ah, AR_PHY_ERR_1);
-	phyCnt2 = REG_READ(ah, AR_PHY_ERR_2);
+	ath9k_hw_get_phy_err_count(ah, &phyCnt1, &phyCnt2);
+
 	if (((phyCnt1 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK) ||
 	    ((phyCnt2 & AR_MIBCNT_INTRMASK) == AR_MIBCNT_INTRMASK)) {
 		struct ar5416AniState *aniState = ah->curani;
-- 
1.6.3.3

