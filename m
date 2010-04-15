Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756914Ab0DODaz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:55 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 54/97] ath9k_hw: move the cal AR9100 calibration settings
Date: Wed, 14 Apr 2010 23:30:08 -0400
Message-Id: <1271302251-9075-55-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
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
index ec48e7b..51f1e84 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -603,6 +603,12 @@ static bool ar9003_hw_macversion_supported(u32 macversion)
 
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
@@ -1016,13 +1022,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
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

