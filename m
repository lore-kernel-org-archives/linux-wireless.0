Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:36575 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755539AbbBEEtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 23:49:47 -0500
Received: from [117.199.130.171] (port=13666 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YJENu-002ASp-LH
	for linux-wireless@vger.kernel.org; Wed, 04 Feb 2015 23:49:46 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 6/7] ath9k: Clear additional WoW events
Date: Thu,  5 Feb 2015 10:22:43 +0530
Message-Id: <1423111964-19626-7-git-send-email-sujith@msujith.org> (sfid-20150205_054956_921053_F485119A)
In-Reply-To: <1423111964-19626-1-git-send-email-sujith@msujith.org>
References: <1423111964-19626-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The events for patterns 8..15 need to be
cleared on wakeup.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 5 ++++-
 drivers/net/wireless/ath/ath9k/reg_wow.h    | 2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_wow.c b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
index 34763c4..efeb9d7 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_wow.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
@@ -230,10 +230,12 @@ u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
 		AR_PMCTRL_PWR_STATE_D1D3);
 
 	/*
-	 * clear all events
+	 * Clear all events.
 	 */
 	REG_WRITE(ah, AR_WOW_PATTERN,
 		  AR_WOW_CLEAR_EVENTS(REG_READ(ah, AR_WOW_PATTERN)));
+	REG_WRITE(ah, AR_MAC_PCU_WOW4,
+		  AR_WOW_CLEAR_EVENTS2(REG_READ(ah, AR_MAC_PCU_WOW4)));
 
 	/*
 	 * restore the beacon threshold to init value
@@ -251,6 +253,7 @@ u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
 		ath9k_hw_configpcipowersave(ah, false);
 
 	ah->wow.wow_event_mask = 0;
+	ah->wow.wow_event_mask2 = 0;
 
 	return wow_status;
 }
diff --git a/drivers/net/wireless/ath/ath9k/reg_wow.h b/drivers/net/wireless/ath/ath9k/reg_wow.h
index 42ed4ee..4530540 100644
--- a/drivers/net/wireless/ath/ath9k/reg_wow.h
+++ b/drivers/net/wireless/ath/ath9k/reg_wow.h
@@ -90,11 +90,13 @@
                                                AR_WOW_BEACON_FAIL |	\
                                                AR_WOW_KEEP_ALIVE_FAIL))
 
+#define AR_WOW2_PATTERN_EN(x)           ((x & 0xff) << 0)
 #define AR_WOW2_PATTERN_FOUND_SHIFT     8
 #define AR_WOW2_PATTERN_FOUND(x)        (x & (0xff << AR_WOW2_PATTERN_FOUND_SHIFT))
 #define AR_WOW2_PATTERN_FOUND_MASK      ((0xff) << AR_WOW2_PATTERN_FOUND_SHIFT)
 
 #define AR_WOW_STATUS2(x)               (x & AR_WOW2_PATTERN_FOUND_MASK)
+#define AR_WOW_CLEAR_EVENTS2(x)         (x & ~(AR_WOW2_PATTERN_EN(0xff)))
 
 #define AR_WOW_AIFS_CNT(x)              (x & 0xff)
 #define AR_WOW_SLOT_CNT(x)              ((x & 0xff) << 8)
-- 
2.2.2

