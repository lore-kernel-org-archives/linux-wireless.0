Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:57565 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbbA2BwW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 20:52:22 -0500
Received: from [117.199.141.188] (port=12173 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YGRcm-001zZ7-Me
	for linux-wireless@vger.kernel.org; Wed, 28 Jan 2015 07:21:37 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 6/6] ath9k: Enable manual peak detect calibration
Date: Wed, 28 Jan 2015 17:54:26 +0530
Message-Id: <1422447866-19967-7-git-send-email-sujith@msujith.org> (sfid-20150129_031935_774910_520F8892)
In-Reply-To: <1422447866-19967-1-git-send-email-sujith@msujith.org>
References: <1422447866-19967-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

On some AR955x/QCA953x boards, noise floor calibration
gets stuck and the cause is a hardware/BB issue. To fix
this, peak detect calibration in the HW is disabled
and is done in the driver instead. There a few differences
with the calibration routine for older chips like
AR9331.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 91130c0..174442b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1640,8 +1640,14 @@ static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
 
 skip_tx_iqcal:
 	if (run_agc_cal || !(ah->ah_flags & AH_FASTCC)) {
-		if (AR_SREV_9330_11(ah))
-			ar9003_hw_manual_peak_cal(ah, 0, IS_CHAN_2GHZ(chan));
+		if (AR_SREV_9330_11(ah) || AR_SREV_9531(ah) || AR_SREV_9550(ah)) {
+			for (i = 0; i < AR9300_MAX_CHAINS; i++) {
+				if (!(ah->rxchainmask & (1 << i)))
+					continue;
+				ar9003_hw_manual_peak_cal(ah, i,
+							  IS_CHAN_2GHZ(chan));
+			}
+		}
 
 		/*
 		 * For non-AR9550 chips, we just trigger AGC calibration
-- 
2.2.2

