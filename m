Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775Ab1BRNAr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 08:00:47 -0500
Date: Fri, 18 Feb 2011 14:00:53 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Subject: [RFC] ath9k correct interrupts ?
Message-ID: <20110218125955.GA4209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not sure if that patch is correct or not. It possibly fix
change from commit 4df3071ebd92ef7115b409da64d0eb405d24a631
"ath9k_hw: optimize interrupt mask changes" that looks
suspicious for me. But from other hand this patch
could be totally wrong. Felix?

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 180170d..2915b11 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -885,7 +885,7 @@ void ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 	struct ath_common *common = ath9k_hw_common(ah);
 
 	if (!(ints & ATH9K_INT_GLOBAL))
-		ath9k_hw_enable_interrupts(ah);
+		ath9k_hw_disable_interrupts(ah);
 
 	ath_dbg(common, ATH_DBG_INTERRUPT, "0x%x => 0x%x\n", omask, ints);
 
@@ -963,7 +963,8 @@ void ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 			REG_CLR_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
 	}
 
-	ath9k_hw_enable_interrupts(ah);
+	if (ints & ATH9K_INT_GLOBAL)
+		ath9k_hw_enable_interrupts(ah);
 
 	return;
 }
