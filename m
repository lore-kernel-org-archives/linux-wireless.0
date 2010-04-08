Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46883 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933261Ab0DHT1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 052/102] ath9k_hw: rename the PA calib routines to match their families
Date: Thu,  8 Apr 2010 15:26:48 -0400
Message-Id: <1270754858-26266-53-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index b44b305..4018074 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -730,7 +730,7 @@ static void ar9280_hw_olc_temp_compensation(struct ath_hw *ah)
 	}
 }
 
-static void ath9k_hw_9271_pa_cal(struct ath_hw *ah, bool is_reset)
+static void ar9271_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 {
 	u32 regVal;
 	unsigned int i;
@@ -831,7 +831,7 @@ static void ath9k_hw_9271_pa_cal(struct ath_hw *ah, bool is_reset)
 		REG_WRITE(ah, regList[i][0], regList[i][1]);
 }
 
-static inline void ath9k_hw_9285_pa_cal(struct ath_hw *ah, bool is_reset)
+static inline void ar9285_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
 	u32 regVal;
@@ -948,12 +948,12 @@ static void ar9002_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 {
 	if (AR_SREV_9271(ah)) {
 		if (is_reset || !ah->pacal_info.skipcount)
-			ath9k_hw_9271_pa_cal(ah, is_reset);
+			ar9271_hw_pa_cal(ah, is_reset);
 		else
 			ah->pacal_info.skipcount--;
 	} else if (AR_SREV_9285_11_OR_LATER(ah)) {
 		if (is_reset || !ah->pacal_info.skipcount)
-			ath9k_hw_9285_pa_cal(ah, is_reset);
+			ar9285_hw_pa_cal(ah, is_reset);
 		else
 			ah->pacal_info.skipcount--;
 	}
-- 
1.6.3.3

