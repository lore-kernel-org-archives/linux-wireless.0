Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:47240 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260AbbBBMsP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 07:48:15 -0500
Received: from [117.216.55.194] (port=15247 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YIGQI-002djK-DM
	for linux-wireless@vger.kernel.org; Mon, 02 Feb 2015 07:48:14 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/6] ath9k: Add support for more WOW patterns
Date: Mon,  2 Feb 2015 18:21:08 +0530
Message-Id: <1422881473-24580-2-git-send-email-sujith@msujith.org> (sfid-20150202_134833_431559_4ADA6D50)
In-Reply-To: <1422881473-24580-1-git-send-email-sujith@msujith.org>
References: <1422881473-24580-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Newer chips like WB222, WB335 support more than
8 user-configurable patterns. This patch adds
support for it by setting up the correct HW
registers.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 48 +++++++++++++----------------
 drivers/net/wireless/ath/ath9k/hw.h         |  1 +
 drivers/net/wireless/ath/ath9k/reg_wow.h    | 34 ++++++++++++++++++++
 3 files changed, 56 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_wow.c b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
index d2a4f6f..4b53d0b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_wow.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
@@ -100,9 +100,11 @@ int ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
 	if (pattern_count >= ah->wow.max_patterns)
 		return -ENOSPC;
 
-	REG_SET_BIT(ah, AR_WOW_PATTERN, BIT(pattern_count));
+	if (pattern_count < MAX_NUM_PATTERN_LEGACY)
+		REG_SET_BIT(ah, AR_WOW_PATTERN, BIT(pattern_count));
+	else
+		REG_SET_BIT(ah, AR_MAC_PCU_WOW4, BIT(pattern_count - 8));
 
-	/* set the registers for pattern */
 	for (i = 0; i < MAX_PATTERN_SIZE; i += 4) {
 		memcpy(&pattern_val, user_pattern, 4);
 		REG_WRITE(ah, (AR_WOW_TB_PATTERN(pattern_count) + i),
@@ -110,47 +112,39 @@ int ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
 		user_pattern += 4;
 	}
 
-	/* set the registers for mask */
 	for (i = 0; i < MAX_PATTERN_MASK_SIZE; i += 4) {
 		memcpy(&mask_val, user_mask, 4);
 		REG_WRITE(ah, (AR_WOW_TB_MASK(pattern_count) + i), mask_val);
 		user_mask += 4;
 	}
 
-	/* set the pattern length to be matched
-	 *
-	 * AR_WOW_LENGTH1_REG1
-	 * bit 31:24 pattern 0 length
-	 * bit 23:16 pattern 1 length
-	 * bit 15:8 pattern 2 length
-	 * bit 7:0 pattern 3 length
-	 *
-	 * AR_WOW_LENGTH1_REG2
-	 * bit 31:24 pattern 4 length
-	 * bit 23:16 pattern 5 length
-	 * bit 15:8 pattern 6 length
-	 * bit 7:0 pattern 7 length
-	 *
-	 * the below logic writes out the new
-	 * pattern length for the corresponding
-	 * pattern_count, while masking out the
-	 * other fields
-	 */
-
-	ah->wow.wow_event_mask |= BIT(pattern_count + AR_WOW_PAT_FOUND_SHIFT);
+	if (pattern_count < MAX_NUM_PATTERN_LEGACY)
+		ah->wow.wow_event_mask |=
+			BIT(pattern_count + AR_WOW_PAT_FOUND_SHIFT);
+	else
+		ah->wow.wow_event_mask2 |=
+			BIT((pattern_count - 8) + AR_WOW_PAT_FOUND_SHIFT);
 
 	if (pattern_count < 4) {
-		/* Pattern 0-3 uses AR_WOW_LENGTH1 register */
 		set = (pattern_len & AR_WOW_LENGTH_MAX) <<
 		       AR_WOW_LEN1_SHIFT(pattern_count);
 		clr = AR_WOW_LENGTH1_MASK(pattern_count);
 		REG_RMW(ah, AR_WOW_LENGTH1, set, clr);
-	} else {
-		/* Pattern 4-7 uses AR_WOW_LENGTH2 register */
+	} else if (pattern_count < 8) {
 		set = (pattern_len & AR_WOW_LENGTH_MAX) <<
 		       AR_WOW_LEN2_SHIFT(pattern_count);
 		clr = AR_WOW_LENGTH2_MASK(pattern_count);
 		REG_RMW(ah, AR_WOW_LENGTH2, set, clr);
+	} else if (pattern_count < 12) {
+		set = (pattern_len & AR_WOW_LENGTH_MAX) <<
+		       AR_WOW_LEN3_SHIFT(pattern_count);
+		clr = AR_WOW_LENGTH3_MASK(pattern_count);
+		REG_RMW(ah, AR_WOW_LENGTH3, set, clr);
+	} else if (pattern_count < MAX_NUM_PATTERN) {
+		set = (pattern_len & AR_WOW_LENGTH_MAX) <<
+		       AR_WOW_LEN4_SHIFT(pattern_count);
+		clr = AR_WOW_LENGTH4_MASK(pattern_count);
+		REG_RMW(ah, AR_WOW_LENGTH4, set, clr);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f51a28f..c8b3d8f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -273,6 +273,7 @@ enum ath9k_hw_caps {
 
 struct ath9k_hw_wow {
 	u32 wow_event_mask;
+	u32 wow_event_mask2;
 	u8 max_patterns;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/reg_wow.h b/drivers/net/wireless/ath/ath9k/reg_wow.h
index e6de4a3..83f27f9 100644
--- a/drivers/net/wireless/ath/ath9k/reg_wow.h
+++ b/drivers/net/wireless/ath/ath9k/reg_wow.h
@@ -25,9 +25,39 @@
 #define AR_WOW_KEEP_ALIVE               0x827c
 #define AR_WOW_KEEP_ALIVE_DELAY         0x8288
 #define AR_WOW_PATTERN_MATCH            0x828c
+
+/*
+ * AR_WOW_LENGTH1
+ * bit 31:24 pattern 0 length
+ * bit 23:16 pattern 1 length
+ * bit 15:8 pattern 2 length
+ * bit 7:0 pattern 3 length
+ *
+ * AR_WOW_LENGTH2
+ * bit 31:24 pattern 4 length
+ * bit 23:16 pattern 5 length
+ * bit 15:8 pattern 6 length
+ * bit 7:0 pattern 7 length
+ *
+ * AR_WOW_LENGTH3
+ * bit 31:24 pattern 8 length
+ * bit 23:16 pattern 9 length
+ * bit 15:8 pattern 10 length
+ * bit 7:0 pattern 11 length
+ *
+ * AR_WOW_LENGTH4
+ * bit 31:24 pattern 12 length
+ * bit 23:16 pattern 13 length
+ * bit 15:8 pattern 14 length
+ * bit 7:0 pattern 15 length
+ */
 #define AR_WOW_LENGTH1                  0x8360
 #define AR_WOW_LENGTH2                  0X8364
+#define AR_WOW_LENGTH3                  0X8380
+#define AR_WOW_LENGTH4                  0X8384
+
 #define AR_WOW_PATTERN_MATCH_LT_256B    0x8368
+#define AR_MAC_PCU_WOW4                 0x8370
 
 #define AR_SW_WOW_CONTROL               0x20018
 #define AR_SW_WOW_ENABLE                0x1
@@ -89,5 +119,9 @@
 #define AR_WOW_LENGTH1_MASK(_i)         (AR_WOW_LENGTH_MAX << AR_WOW_LEN1_SHIFT(_i))
 #define AR_WOW_LEN2_SHIFT(_i)           ((0x7 - ((_i) & 0x7)) << 0x3)
 #define AR_WOW_LENGTH2_MASK(_i)         (AR_WOW_LENGTH_MAX << AR_WOW_LEN2_SHIFT(_i))
+#define AR_WOW_LEN3_SHIFT(_i)           ((0xb - ((_i) & 0xb)) << 0x3)
+#define AR_WOW_LENGTH3_MASK(_i)         (AR_WOW_LENGTH_MAX << AR_WOW_LEN3_SHIFT(_i))
+#define AR_WOW_LEN4_SHIFT(_i)           ((0xf - ((_i) & 0xf)) << 0x3)
+#define AR_WOW_LENGTH4_MASK(_i)         (AR_WOW_LENGTH_MAX << AR_WOW_LEN4_SHIFT(_i))
 
 #endif /* REG_WOW_H */
-- 
2.2.2

