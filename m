Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33788 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754401Ab3LTQCm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Dec 2013 11:02:42 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath9k_hw: fix TSF offset calculation
Date: Fri, 20 Dec 2013 17:02:24 +0100
Message-Id: <1387555344-92391-1-git-send-email-nbd@openwrt.org> (sfid-20131220_170304_540666_F131B142)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since the unit is microseconds and not milliseconds, tv_sec needs to be
multiplied by 1000000, not 1000.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 160be02..8e24303 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1865,7 +1865,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	/* Save TSF before chip reset, a cold reset clears it */
 	tsf = ath9k_hw_gettsf64(ah);
 	getrawmonotonic(&ts);
-	usec = ts.tv_sec * 1000 + ts.tv_nsec / 1000;
+	usec = ts.tv_sec * 1000000ULL + ts.tv_nsec / 1000;
 
 	saveLedState = REG_READ(ah, AR_CFG_LED) &
 		(AR_CFG_LED_ASSOC_CTL | AR_CFG_LED_MODE_SEL |
@@ -1899,7 +1899,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	/* Restore TSF */
 	getrawmonotonic(&ts);
-	usec = ts.tv_sec * 1000 + ts.tv_nsec / 1000 - usec;
+	usec = ts.tv_sec * 1000000ULL + ts.tv_nsec / 1000 - usec;
 	ath9k_hw_settsf64(ah, tsf + usec);
 
 	if (AR_SREV_9280_20_OR_LATER(ah))
-- 
1.8.3.4 (Apple Git-47)

