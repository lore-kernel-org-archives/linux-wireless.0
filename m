Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:50867 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720AbbBEEtq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 23:49:46 -0500
Received: from [117.199.130.171] (port=13666 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YJENt-002ASp-Er
	for linux-wireless@vger.kernel.org; Wed, 04 Feb 2015 23:49:45 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 5/7] ath9k: Handle additional patterns on wakeup
Date: Thu,  5 Feb 2015 10:22:42 +0530
Message-Id: <1423111964-19626-6-git-send-email-sujith@msujith.org> (sfid-20150205_054955_051894_1E863896)
In-Reply-To: <1423111964-19626-1-git-send-email-sujith@msujith.org>
References: <1423111964-19626-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Handle the user-configured patterns in the range 8..15
when waking up and update wow_status correctly.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 16 ++++++++++++----
 drivers/net/wireless/ath/ath9k/reg_wow.h    |  8 +++++++-
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_wow.c b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
index bf3378f0..34763c4 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_wow.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
@@ -186,18 +186,17 @@ u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
 	u32 val = 0, rval;
 
 	/*
-	 * read the WoW status register to know
-	 * the wakeup reason
+	 * Read the WoW status register to know
+	 * the wakeup reason.
 	 */
 	rval = REG_READ(ah, AR_WOW_PATTERN);
 	val = AR_WOW_STATUS(rval);
 
 	/*
-	 * mask only the WoW events that we have enabled. Sometimes
+	 * Mask only the WoW events that we have enabled. Sometimes
 	 * we have spurious WoW events from the AR_WOW_PATTERN
 	 * register. This mask will clean it up.
 	 */
-
 	val &= ah->wow.wow_event_mask;
 
 	if (val) {
@@ -211,6 +210,15 @@ u32 ath9k_hw_wow_wakeup(struct ath_hw *ah)
 			wow_status |= AH_WOW_BEACON_MISS;
 	}
 
+	rval = REG_READ(ah, AR_MAC_PCU_WOW4);
+	val = AR_WOW_STATUS2(rval);
+	val &= ah->wow.wow_event_mask2;
+
+	if (val) {
+		if (AR_WOW2_PATTERN_FOUND(val))
+			wow_status |= AH_WOW_USER_PATTERN_EN;
+	}
+
 	/*
 	 * set and clear WOW_PME_CLEAR registers for the chip to
 	 * generate next wow signal.
diff --git a/drivers/net/wireless/ath/ath9k/reg_wow.h b/drivers/net/wireless/ath/ath9k/reg_wow.h
index 3abfca5..42ed4ee 100644
--- a/drivers/net/wireless/ath/ath9k/reg_wow.h
+++ b/drivers/net/wireless/ath/ath9k/reg_wow.h
@@ -72,7 +72,7 @@
 #define AR_WOW_MAC_INTR_EN              0x00040000
 #define AR_WOW_MAGIC_EN                 0x00010000
 #define AR_WOW_PATTERN_EN(x)            (x & 0xff)
-#define AR_WOW_PAT_FOUND_SHIFT  8
+#define AR_WOW_PAT_FOUND_SHIFT          8
 #define AR_WOW_PATTERN_FOUND(x)         (x & (0xff << AR_WOW_PAT_FOUND_SHIFT))
 #define AR_WOW_PATTERN_FOUND_MASK       ((0xff) << AR_WOW_PAT_FOUND_SHIFT)
 #define AR_WOW_MAGIC_PAT_FOUND          0x00020000
@@ -90,6 +90,12 @@
                                                AR_WOW_BEACON_FAIL |	\
                                                AR_WOW_KEEP_ALIVE_FAIL))
 
+#define AR_WOW2_PATTERN_FOUND_SHIFT     8
+#define AR_WOW2_PATTERN_FOUND(x)        (x & (0xff << AR_WOW2_PATTERN_FOUND_SHIFT))
+#define AR_WOW2_PATTERN_FOUND_MASK      ((0xff) << AR_WOW2_PATTERN_FOUND_SHIFT)
+
+#define AR_WOW_STATUS2(x)               (x & AR_WOW2_PATTERN_FOUND_MASK)
+
 #define AR_WOW_AIFS_CNT(x)              (x & 0xff)
 #define AR_WOW_SLOT_CNT(x)              ((x & 0xff) << 8)
 #define AR_WOW_KEEP_ALIVE_CNT(x)        ((x & 0xff) << 16)
-- 
2.2.2

