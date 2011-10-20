Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60923 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1JTJBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 05:01:45 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: Fix radio retention for AR9462
Date: Thu, 20 Oct 2011 14:29:38 +0530
Message-ID: <1319101178-9843-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111020_110149_072081_40A7060E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IQ calibration during fast channel change sometimes failed
with RTT. And also restoring invalid radio retention readings
during init cal could cause failure to set the channel properly.
This patch counts the valid rtt history readings and clears
rtt mask.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 16851cb..a4cd161 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -908,12 +908,15 @@ static bool ar9003_hw_rtt_restore(struct ath_hw *ah, struct ath9k_channel *chan)
 	int i;
 	bool restore;
 
-	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_RTT) || !ah->caldata)
+	if (!ah->caldata)
 		return false;
 
 	hist = &ah->caldata->rtt_hist;
+	if (!hist->num_readings)
+		return false;
+
 	ar9003_hw_rtt_enable(ah);
-	ar9003_hw_rtt_set_mask(ah, 0x10);
+	ar9003_hw_rtt_set_mask(ah, 0x00);
 	for (i = 0; i < AR9300_MAX_CHAINS; i++) {
 		if (!(ah->rxchainmask & (1 << i)))
 			continue;
@@ -1070,6 +1073,7 @@ skip_tx_iqcal:
 		if (is_reusable && (hist->num_readings < RTT_HIST_MAX)) {
 			u32 *table;
 
+			hist->num_readings++;
 			for (i = 0; i < AR9300_MAX_CHAINS; i++) {
 				if (!(ah->rxchainmask & (1 << i)))
 					continue;
-- 
1.7.7

