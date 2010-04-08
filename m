Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46878 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933259Ab0DHT1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 051/102] ath9k_hw: simplify OLC temp compensation for AR9002
Date: Thu,  8 Apr 2010 15:26:47 -0400
Message-Id: <1270754858-26266-52-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We can do the family revision check on the top level caller.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index dae200c..b44b305 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -730,14 +730,6 @@ static void ar9280_hw_olc_temp_compensation(struct ath_hw *ah)
 	}
 }
 
-static void ath9k_olc_temp_compensation(struct ath_hw *ah)
-{
-	if (OLC_FOR_AR9287_10_LATER)
-		ar9287_hw_olc_temp_compensation(ah);
-	else
-		ar9280_hw_olc_temp_compensation(ah);
-}
-
 static void ath9k_hw_9271_pa_cal(struct ath_hw *ah, bool is_reset)
 {
 	u32 regVal;
@@ -969,8 +961,10 @@ static void ar9002_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 
 static void ar9002_hw_olc_temp_compensation(struct ath_hw *ah)
 {
-	if (OLC_FOR_AR9280_20_LATER || OLC_FOR_AR9287_10_LATER)
-		ath9k_olc_temp_compensation(ah);
+	if (OLC_FOR_AR9287_10_LATER)
+		ar9287_hw_olc_temp_compensation(ah);
+	else if (OLC_FOR_AR9280_20_LATER)
+		ar9280_hw_olc_temp_compensation(ah);
 }
 
 bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
-- 
1.6.3.3

