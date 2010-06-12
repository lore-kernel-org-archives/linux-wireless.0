Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43218 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab0FLEeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jun 2010 00:34:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 03/24] ath9k_hw: clear MIB interrupt causes when skipping ANI adjustments
Date: Sat, 12 Jun 2010 00:33:41 -0400
Message-Id: <1276317242-15540-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
References: <1276317242-15540-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We get an MIB interrupt when we hit certain PHY error counter
thresholds. If ANI is disabled but the MIB interrupt is enabled
we'll keep around the old MIB interrupt causes.

Since ath9k disables the MIB interrupt when ANI is disabled
this is not a fix, but more of a sanity fix in case we ever
need the MIB interrupt enabled but disabling ANI.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index e879055..66d0b88 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -585,8 +585,15 @@ void ath9k_hw_procmibevent(struct ath_hw *ah)
 	/* Clear the mib counters and save them in the stats */
 	ath9k_hw_update_mibstats(ah, &ah->ah_mibStats);
 
-	if (!DO_ANI(ah))
+	if (!DO_ANI(ah)) {
+		/*
+		 * We must always clear the interrupt cause by
+		 * resetting the phy error regs.
+		 */
+		REG_WRITE(ah, AR_PHY_ERR_1, 0);
+		REG_WRITE(ah, AR_PHY_ERR_2, 0);
 		return;
+	}
 
 	/* NB: these are not reset-on-read */
 	phyCnt1 = REG_READ(ah, AR_PHY_ERR_1);
-- 
1.6.3.3

