Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46859 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933251Ab0DHT1p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 047/102] ath9k_hw: add a helper for the OLC tem compensation for AR9002
Date: Thu,  8 Apr 2010 15:26:43 -0400
Message-Id: <1270754858-26266-48-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Open Loop Control temperature compensation changes between our
hardware so use a helper for it.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/calib.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 26bc381..156ae34 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -964,6 +964,12 @@ static void ar9002_hw_pa_cal(struct ath_hw *ah, bool is_reset)
 	}
 }
 
+static void ar9002_hw_olc_temp_compensation(struct ath_hw *ah)
+{
+	if (OLC_FOR_AR9280_20_LATER || OLC_FOR_AR9287_10_LATER)
+		ath9k_olc_temp_compensation(ah);
+}
+
 bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 			u8 rxchainmask, bool longcal)
 {
@@ -989,9 +995,7 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (longcal) {
 		/* Do periodic PAOffset Cal */
 		ar9002_hw_pa_cal(ah, false);
-
-		if (OLC_FOR_AR9280_20_LATER || OLC_FOR_AR9287_10_LATER)
-			ath9k_olc_temp_compensation(ah);
+		ar9002_hw_olc_temp_compensation(ah);
 
 		/* Get the value from the previous NF cal and update history buffer */
 		ath9k_hw_getnf(ah, chan);
-- 
1.6.3.3

