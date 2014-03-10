Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56745 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbaCJS4q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 14:56:46 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath9k_hw: remove ANI function restrictions for AP mode
Date: Mon, 10 Mar 2014 19:56:33 +0100
Message-Id: <1394477793-56380-1-git-send-email-nbd@openwrt.org> (sfid-20140310_195650_033492_FF003124)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The primary purpose of this piece of code was to selectively disable
OFDM weak signal detection. The checks for this are elsewhere, and an
earlier commit relaxed the restrictions for older chips, which are more
sensitive to interference.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 2ce5079..6d47783 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -318,17 +318,6 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 	BUG_ON(aniState == NULL);
 	ah->stats.ast_ani_reset++;
 
-	/* only allow a subset of functions in AP mode */
-	if (ah->opmode == NL80211_IFTYPE_AP) {
-		if (IS_CHAN_2GHZ(chan)) {
-			ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
-					    ATH9K_ANI_FIRSTEP_LEVEL);
-			if (AR_SREV_9300_20_OR_LATER(ah))
-				ah->ani_function |= ATH9K_ANI_MRC_CCK;
-		} else
-			ah->ani_function = 0;
-	}
-
 	ofdm_nil = max_t(int, ATH9K_ANI_OFDM_DEF_LEVEL,
 			 aniState->ofdmNoiseImmunityLevel);
 	cck_nil = max_t(int, ATH9K_ANI_CCK_DEF_LEVEL,
-- 
1.8.3.4 (Apple Git-47)

