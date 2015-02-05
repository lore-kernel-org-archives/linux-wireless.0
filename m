Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39581 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133AbbBEEtl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 23:49:41 -0500
Received: from [117.199.130.171] (port=13666 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YJENo-002ASp-O8
	for linux-wireless@vger.kernel.org; Wed, 04 Feb 2015 23:49:41 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/7] ath9k: Fix descriptors for keep-alive frame
Date: Thu,  5 Feb 2015 10:22:38 +0530
Message-Id: <1423111964-19626-2-git-send-email-sujith@msujith.org> (sfid-20150205_054952_110576_715F35D7)
In-Reply-To: <1423111964-19626-1-git-send-email-sujith@msujith.org>
References: <1423111964-19626-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Along with AR9462, AR9565 also has an extra field
in the TX descriptor which needs to be zeroed out
for the keep alive frame. This makes the earlier
REG_WRITE redundant, so it can be removed.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_wow.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_wow.c b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
index 86bfc96..5e707c8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_wow.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_wow.c
@@ -74,8 +74,6 @@ static void ath9k_wow_create_keep_alive_pattern(struct ath_hw *ah)
 	for (i = 0; i < KAL_NUM_DESC_WORDS; i++)
 		REG_WRITE(ah, (AR_WOW_KA_DESC_WORD2 + i * 4), ctl[i]);
 
-	REG_WRITE(ah, (AR_WOW_KA_DESC_WORD2 + i * 4), ctl[i]);
-
 	data_word[0] = (KAL_FRAME_TYPE << 2) | (KAL_FRAME_SUB_TYPE << 4) |
 		       (KAL_TO_DS << 8) | (KAL_DURATION_ID << 16);
 	data_word[1] = (ap_mac_addr[3] << 24) | (ap_mac_addr[2] << 16) |
@@ -88,9 +86,11 @@ static void ath9k_wow_create_keep_alive_pattern(struct ath_hw *ah)
 		       (ap_mac_addr[1] << 8) | (ap_mac_addr[0]);
 	data_word[5] = (ap_mac_addr[5] << 8) | (ap_mac_addr[4]);
 
-	if (AR_SREV_9462_20(ah)) {
-		/* AR9462 2.0 has an extra descriptor word (time based
-		 * discard) compared to other chips */
+	if (AR_SREV_9462_20_OR_LATER(ah) || AR_SREV_9565(ah)) {
+		/*
+		 * AR9462 2.0 and AR9565 have an extra descriptor word
+		 * (time based discard) compared to other chips.
+		 */
 		REG_WRITE(ah, (AR_WOW_KA_DESC_WORD2 + (12 * 4)), 0);
 		wow_ka_data_word0 = AR_WOW_TXBUF(13);
 	} else {
@@ -99,7 +99,6 @@ static void ath9k_wow_create_keep_alive_pattern(struct ath_hw *ah)
 
 	for (i = 0; i < KAL_NUM_DATA_WORDS; i++)
 		REG_WRITE(ah, (wow_ka_data_word0 + i*4), data_word[i]);
-
 }
 
 int ath9k_hw_wow_apply_pattern(struct ath_hw *ah, u8 *user_pattern,
-- 
2.2.2

