Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:40755 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZEFHrb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 03:47:31 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH] ath9k: remove redundant AR9285 checks
Date: Wed,  6 May 2009 09:47:30 +0200
Message-Id: <1241596050-9924-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AR_SREV_9285_1[12]_OR_LATER macros already contains the
AR_SREV_9285 check.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/calib.c |    6 +++---
 drivers/net/wireless/ath/ath9k/hw.c    |    3 +--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index a197041..a32d7e7 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -863,7 +863,7 @@ bool ath9k_hw_calibrate(struct ath_hw *ah, struct ath9k_channel *chan,
 	}
 
 	if (longcal) {
-		if (AR_SREV_9285(ah) && AR_SREV_9285_11_OR_LATER(ah))
+		if (AR_SREV_9285_11_OR_LATER(ah))
 			ath9k_hw_9285_pa_cal(ah);
 
 		if (OLC_FOR_AR9280_20_LATER)
@@ -917,7 +917,7 @@ static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 
 bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 {
-	if (AR_SREV_9285(ah) && AR_SREV_9285_12_OR_LATER(ah)) {
+	if (AR_SREV_9285_12_OR_LATER(ah)) {
 		if (!ar9285_clc(ah, chan))
 			return false;
 	} else {
@@ -947,7 +947,7 @@ bool ath9k_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 	}
 
 	/* Do PA Calibration */
-	if (AR_SREV_9285(ah) && AR_SREV_9285_11_OR_LATER(ah))
+	if (AR_SREV_9285_11_OR_LATER(ah))
 		ath9k_hw_9285_pa_cal(ah);
 
 	/* Do NF Calibration after DC offset and other calibrations */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 02f4015..599f63a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1345,8 +1345,7 @@ static int ath9k_hw_process_ini(struct ath_hw *ah,
 	if (AR_SREV_9280(ah))
 		REG_WRITE_ARRAY(&ah->iniModesRxGain, modesIndex, regWrites);
 
-	if (AR_SREV_9280(ah) || (AR_SREV_9285(ah) &&
-	    AR_SREV_9285_12_OR_LATER(ah)))
+	if (AR_SREV_9280(ah) || AR_SREV_9285_12_OR_LATER(ah))
 		REG_WRITE_ARRAY(&ah->iniModesTxGain, modesIndex, regWrites);
 
 	for (i = 0; i < ah->iniCommon.ia_rows; i++) {
-- 
1.5.3.2

