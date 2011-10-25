Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17557 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab1JYLQq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Oct 2011 07:16:46 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: Fix noise floor calibration timeout on fast channel change
Date: Tue, 25 Oct 2011 16:47:36 +0530
Message-ID: <1319541456-2147-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111025_131651_033172_A5602682)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During the fast channel change noise floor values are being loaded
twice at init_cal and after channel_change. The commit "ath9k_hw:
Improve fast channel change for AR9003 chips" overlooked it that
caused failure to load nf while doing bgscan. This patch performs noise
floor calibration after the fast and full reset.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    4 ----
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    3 ---
 drivers/net/wireless/ath/ath9k/hw.c           |    3 +++
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index e0ab065..88279e3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -868,10 +868,6 @@ static bool ar9002_hw_init_cal(struct ath_hw *ah, struct ath9k_channel *chan)
 	/* Do PA Calibration */
 	ar9002_hw_pa_cal(ah, true);
 
-	/* Do NF Calibration after DC offset and other calibrations */
-	ath9k_hw_loadnf(ah, chan);
-	ath9k_hw_start_nfcal(ah, true);
-
 	if (ah->caldata)
 		ah->caldata->nfcal_pending = true;
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index a4cd161..12a730d 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1085,9 +1085,6 @@ skip_tx_iqcal:
 		ar9003_hw_rtt_disable(ah);
 	}
 
-	ath9k_hw_loadnf(ah, chan);
-	ath9k_hw_start_nfcal(ah, true);
-
 	/* Initialize list pointers */
 	ah->cal_list = ah->cal_list_last = ah->cal_list_curr = NULL;
 	ah->supp_cals = IQ_MISMATCH_CAL;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 8c36938..a67c456 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1724,6 +1724,9 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_init_cal(ah, chan))
 		return -EIO;
 
+	ath9k_hw_loadnf(ah, chan);
+	ath9k_hw_start_nfcal(ah, true);
+
 	ENABLE_REGWRITE_BUFFER(ah);
 
 	ath9k_hw_restore_chainmask(ah);
-- 
1.7.7

