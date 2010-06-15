Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43082 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab0FOARh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 20:17:37 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] ath9k_hw: avoid setting cwmin/cwmax to 0 for IBSS for AR9003
Date: Mon, 14 Jun 2010 20:17:36 -0400
Message-Id: <1276561056-2976-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IBSS requires the cwmin and cwmax to be respected when
we reset the txqueues on AR9003 otherwise the distribution
of beacons will be balanced towards the AR9003 card first
preventing equal contention for air time for other peers
on the IBSS.

Without this IBSS will work but only the AR9003 card will be
be issuing beacons on the IBSS.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/mac.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 1550591..e955bb9 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -555,8 +555,13 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 		REGWRITE_BUFFER_FLUSH(ah);
 		DISABLE_REGWRITE_BUFFER(ah);
 
-		/* cwmin and cwmax should be 0 for beacon queue */
-		if (AR_SREV_9300_20_OR_LATER(ah)) {
+		/*
+		 * cwmin and cwmax should be 0 for beacon queue
+		 * but not for IBSS as we would create an imbalance
+		 * on beaconing fairness for participating nodes.
+		 */
+		if (AR_SREV_9300_20_OR_LATER(ah) &&
+		    ah->opmode != NL80211_IFTYPE_ADHOC) {
 			REG_WRITE(ah, AR_DLCL_IFS(q), SM(0, AR_D_LCL_IFS_CWMIN)
 				  | SM(0, AR_D_LCL_IFS_CWMAX)
 				  | SM(qi->tqi_aifs, AR_D_LCL_IFS_AIFS));
-- 
1.6.3.3

