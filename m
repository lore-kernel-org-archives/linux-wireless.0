Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:50196 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbaBGFAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 00:00:41 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 2/7] ath9k: Check explicitly for IQ calibration
Date: Fri,  7 Feb 2014 10:29:50 +0530
Message-Id: <1391749195-24381-3-git-send-email-sujith@msujith.org> (sfid-20140207_060107_271206_5DDF034A)
In-Reply-To: <1391749195-24381-1-git-send-email-sujith@msujith.org>
References: <1391749195-24381-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

In chips like AR955x, the initvals contain the information
whether IQ calibration is to be done in the HW when an
AGC calibration is triggered. Check if IQ-CAL is enabled
in the initvals before flagging 'txiqcal_done' as true.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 225b758..0ee4250 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1485,7 +1485,12 @@ static bool ar9003_hw_init_cal_soc(struct ath_hw *ah,
 	 * AGC calibration. Specifically, AR9550 in SoC chips.
 	 */
 	if (ah->enabled_cals & TX_IQ_ON_AGC_CAL) {
-		txiqcal_done = true;
+		if (REG_READ_FIELD(ah, AR_PHY_TX_IQCAL_CONTROL_0,
+				   AR_PHY_TX_IQCAL_CONTROL_0_ENABLE_TXIQ_CAL)) {
+				txiqcal_done = true;
+		} else {
+			txiqcal_done = false;
+		}
 		run_agc_cal = true;
 	} else {
 		sep_iq_cal = true;
-- 
1.8.5.3

