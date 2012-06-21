Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51450 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759026Ab2FUSae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 14:30:34 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/3] ath9k_hw: fix smatch warnings in spur_mitigate
Date: Fri, 22 Jun 2012 00:01:31 +0530
Message-ID: <1340303492-30947-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120621_203038_097762_08DE6F9B)
In-Reply-To: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1340303492-30947-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes below smatch warnings

drivers/net/wireless/ath/ath9k/ar9002_phy.c:275
ar9002_hw_spur_mitigate() Error invalid range 576717 to 471859
drivers/net/wireless/ath/ath9k/ar5008_phy.c:323
ar5008_hw_spur_mitigate() Error invalid range 555746 to 492830
drivers/net/wireless/ath/ath9k/ar5008_phy.c:326
ar5008_hw_spur_mitigate() Error invalid range 587 to 481
drivers/net/wireless/ath/ath9k/ar9003_calib.c:272
ar9003_hw_iqcalibrate() Error invalid range 65 to 63

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c   | 7 ++++---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c   | 9 +++------
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 2 +-
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 874186b..4130035 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -319,11 +319,12 @@ static void ar5008_hw_spur_mitigate(struct ath_hw *ah,
 	       SM(SPUR_RSSI_THRESH, AR_PHY_SPUR_REG_SPUR_RSSI_THRESH));
 	REG_WRITE(ah, AR_PHY_SPUR_REG, new);
 
-	spur_delta_phase = ((bb_spur * 524288) / 100) &
-		AR_PHY_TIMING11_SPUR_DELTA_PHASE;
+	spur_delta_phase = (bb_spur * 524288) / 100;
+	spur_delta_phase &= AR_PHY_TIMING11_SPUR_DELTA_PHASE;
 
 	denominator = IS_CHAN_2GHZ(chan) ? 440 : 400;
-	spur_freq_sd = ((bb_spur * 2048) / denominator) & 0x3ff;
+	spur_freq_sd = (bb_spur * 2048) / denominator;
+	spur_freq_sd &= 0x3ff;
 
 	new = (AR_PHY_TIMING11_USE_SPUR_IN_AGC |
 	       SM(spur_freq_sd, AR_PHY_TIMING11_SPUR_FREQ_SD) |
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 846dd79..58b9ca0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -270,13 +270,10 @@ static void ar9002_hw_spur_mitigate(struct ath_hw *ah,
 	}
 
 	if (IS_CHAN_HT40(chan))
-		spur_delta_phase =
-			((bb_spur * 262144) /
-			 10) & AR_PHY_TIMING11_SPUR_DELTA_PHASE;
+		spur_delta_phase = (bb_spur * 262144) / 10;
 	else
-		spur_delta_phase =
-			((bb_spur * 524288) /
-			 10) & AR_PHY_TIMING11_SPUR_DELTA_PHASE;
+		spur_delta_phase = (bb_spur * 524288) / 10;
+	spur_delta_phase &= AR_PHY_TIMING11_SPUR_DELTA_PHASE;
 
 	denominator = IS_CHAN_2GHZ(chan) ? 44 : 40;
 	spur_freq_sd = ((bb_spur_off * 2048) / denominator) & 0x3ff;
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index d7deb8c..8bee934 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -269,7 +269,7 @@ static void ar9003_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 				qCoff = -63;
 
 			iCoff = iCoff & 0x7f;
-			qCoff = qCoff & 0x7f;
+			qCoff &= 0x7f;
 
 			ath_dbg(common, CALIBRATE,
 				"Chn %d : iCoff = 0x%x  qCoff = 0x%x\n",
-- 
1.7.11

