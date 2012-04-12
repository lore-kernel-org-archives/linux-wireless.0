Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42045 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762700Ab2DLUgI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 16:36:08 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 1/4] ath9k_hw: remove enable_32kHz_clock
Date: Thu, 12 Apr 2012 22:35:55 +0200
Message-Id: <1334262958-90777-1-git-send-email-nbd@openwrt.org> (sfid-20120412_223619_606762_5BCF29E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is unused and useless

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    1 -
 drivers/net/wireless/ath/ath9k/hw.h |    5 -----
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d1345a8..6fa8128 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -445,7 +445,6 @@ static void ath9k_hw_init_defaults(struct ath_hw *ah)
 		AR_STA_ID1_MCAST_KSRCH;
 	if (AR_SREV_9100(ah))
 		ah->sta_id1_defaults |= AR_STA_ID1_AR9100_BA_FIX;
-	ah->enable_32kHz_clock = DONT_USE_32KHZ;
 	ah->slottime = ATH9K_SLOT_TIME_9;
 	ah->globaltxtimeout = (u32) -1;
 	ah->power_mode = ATH9K_PM_UNDEFINED;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index aa1680a..d85a8de 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -762,11 +762,6 @@ struct ath_hw {
 
 	u32 sta_id1_defaults;
 	u32 misc_mode;
-	enum {
-		AUTO_32KHZ,
-		USE_32KHZ,
-		DONT_USE_32KHZ,
-	} enable_32kHz_clock;
 
 	/* Private to hardware code */
 	struct ath_hw_private_ops private_ops;
-- 
1.7.3.2

