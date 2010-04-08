Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46889 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab0DHT1q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 054/102] ath9k_hw: move the cal AR9100 calibration settings
Date: Thu,  8 Apr 2010 15:26:50 -0400
Message-Id: <1270754858-26266-55-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The calibration settings should go into the respective
hardware family AR9002 calibration settings callback,
ar9002_hw_init_cal_settings().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2ede866..ac13745 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -596,6 +596,12 @@ static bool ar9003_hw_macversion_supported(u32 macversion)
 
 static void ar9002_hw_init_cal_settings(struct ath_hw *ah)
 {
+	if (AR_SREV_9100(ah)) {
+		ah->iq_caldata.calData = &iq_cal_multi_sample;
+		ah->supp_cals = IQ_MISMATCH_CAL;
+		return;
+	}
+
 	if (AR_SREV_9160_10_OR_LATER(ah)) {
 		if (AR_SREV_9280_10_OR_LATER(ah)) {
 			ah->iq_caldata.calData = &iq_cal_single_sample;
@@ -1045,13 +1051,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 		return -EOPNOTSUPP;
 	}
 
-	if (AR_SREV_9100(ah)) {
-		ah->iq_caldata.calData = &iq_cal_multi_sample;
-		ah->supp_cals = IQ_MISMATCH_CAL;
-		ah->is_pciexpress = false;
-	}
-
-	if (AR_SREV_9271(ah))
+	if (AR_SREV_9271(ah) || AR_SREV_9100(ah))
 		ah->is_pciexpress = false;
 
 	ah->hw_version.phyRev = REG_READ(ah, AR_PHY_CHIP_ID);
-- 
1.6.3.3

