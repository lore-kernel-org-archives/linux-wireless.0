Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32411 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbZHGEPU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 00:15:20 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2009 21:15:22 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19067.43622.886009.551755@gargle.gargle.HOWL>
Date: Fri, 7 Aug 2009 09:45:34 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 11/12] ath9k: Change DEBUG level for certain interrupts
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Occurrence of AR_ISR_RXORN, AR_INTR_SYNC_RADM_CPL_TIMEOUT
and AR_INTR_SYNC_LOCAL_TIMEOUT should be visible.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6514dc7..0e83e98 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3182,7 +3182,7 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 		}
 
 		if (isr & AR_ISR_RXORN) {
-			DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
+			DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 				"receive FIFO overrun interrupt\n");
 		}
 
@@ -3218,14 +3218,14 @@ bool ath9k_hw_getisr(struct ath_hw *ah, enum ath9k_int *masked)
 			*masked |= ATH9K_INT_FATAL;
 		}
 		if (sync_cause & AR_INTR_SYNC_RADM_CPL_TIMEOUT) {
-			DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
+			DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 				"AR_INTR_SYNC_RADM_CPL_TIMEOUT\n");
 			REG_WRITE(ah, AR_RC, AR_RC_HOSTIF);
 			REG_WRITE(ah, AR_RC, 0);
 			*masked |= ATH9K_INT_FATAL;
 		}
 		if (sync_cause & AR_INTR_SYNC_LOCAL_TIMEOUT) {
-			DPRINTF(ah->ah_sc, ATH_DBG_INTERRUPT,
+			DPRINTF(ah->ah_sc, ATH_DBG_ANY,
 				"AR_INTR_SYNC_LOCAL_TIMEOUT\n");
 		}
 
-- 
1.6.4

