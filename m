Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618Ab1BUOCm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 09:02:42 -0500
Date: Mon, 21 Feb 2011 15:02:41 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	ath9k-devel@venema.h4ckr.net
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH] ath9k: correct ath9k_hw_set_interrupts
Message-ID: <20110221140210.GA5996@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 4df3071ebd92ef7115b409da64d0eb405d24a631 "ath9k_hw: optimize
interrupt mask changes", changed ath9k_hw_set_interrupts function to
enable interrupts regardless of function argument, what could possibly
be wrong. Correct that behaviour and check "ints" arguments before
enabling interrupts, also disable interrupts if ints do not have
ATH9K_INT_GLOBAL flag set.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/mac.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index c75d40f..5efc869 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -891,7 +891,7 @@ void ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (!(ints & ATH9K_INT_GLOBAL))
-		ath9k_hw_enable_interrupts(ah);
+		ath9k_hw_disable_interrupts(ah);
 
 	ath_dbg(common, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
 
@@ -969,7 +969,8 @@ void ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 			REG_CLR_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
 	}
 
-	ath9k_hw_enable_interrupts(ah);
+	if (ints & ATH9K_INT_GLOBAL)
+		ath9k_hw_enable_interrupts(ah);
 
 	return;
 }
-- 
1.7.1

