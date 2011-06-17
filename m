Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:31281 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab1FQIjN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 04:39:13 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 01:38:38 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <rodrigue@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	<susinder@qca.qualcomm.com>, <senthilb@qca.qualcomm.com>,
	<kmuthusa@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: make sure PAPRD training is properly done
Date: Fri, 17 Jun 2011 14:08:42 +0530
Message-ID: <1308299922-14154-1-git-send-email-mshajakhan@atheros.com> (sfid-20110617_103918_244912_C0593B14)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

checking the status of PAPRD_AGC2_POWER(Log(ADC_power) measured after
last gain-change in dB) field suggests whether the PAPRD is completely/properly
done. This is an additional check apart from polling for PAPRD done bit being set.
        Susinder suggests that the ideal power range value should be
0xf0 to 0xfe. With AR9382 we do have the values in this range. to have a
common check for all platforms we take agc2_power should be atleast greater
than 0xe0

Cc: susinder@qca.qualcomm.com
Cc: senthilb@qca.qualcomm.com
Cc: kmuthusa@qca.qualcomm.com
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_paprd.c |   21 ++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/hw.h           |    5 +++--
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
index 2e7f0f2..fc9c08f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_paprd.c
@@ -785,7 +785,26 @@ EXPORT_SYMBOL(ar9003_paprd_init_table);
 
 bool ar9003_paprd_is_done(struct ath_hw *ah)
 {
-	return !!REG_READ_FIELD(ah, AR_PHY_PAPRD_TRAINER_STAT1,
+	int paprd_done, agc2_pwr;
+	paprd_done = REG_READ_FIELD(ah, AR_PHY_PAPRD_TRAINER_STAT1,
 				AR_PHY_PAPRD_TRAINER_STAT1_PAPRD_TRAIN_DONE);
+
+	if (paprd_done == 0x1) {
+		agc2_pwr = REG_READ_FIELD(ah, AR_PHY_PAPRD_TRAINER_STAT1,
+				AR_PHY_PAPRD_TRAINER_STAT1_PAPRD_AGC2_PWR);
+
+		ath_dbg(ath9k_hw_common(ah), ATH_DBG_CALIBRATE,
+			"AGC2_PWR = 0x%x training done = 0x%x\n",
+			agc2_pwr, paprd_done);
+	/*
+	 * agc2_pwr range should not be less than 'IDEAL_AGC2_PWR_CHANGE'
+	 * when the training is completely done, otherwise retraining is
+	 * done to make sure the value is in ideal range
+	 */
+		if (agc2_pwr <= PAPRD_IDEAL_AGC2_PWR_RANGE)
+			paprd_done = 0;
+	}
+
+	return !!paprd_done;
 }
 EXPORT_SYMBOL(ar9003_paprd_is_done);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6a6fb54..66d2225 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -157,8 +157,9 @@
 #define ATH9K_HW_RX_HP_QDEPTH	16
 #define ATH9K_HW_RX_LP_QDEPTH	128
 
-#define PAPRD_GAIN_TABLE_ENTRIES    32
-#define PAPRD_TABLE_SZ              24
+#define PAPRD_GAIN_TABLE_ENTRIES	32
+#define PAPRD_TABLE_SZ			24
+#define PAPRD_IDEAL_AGC2_PWR_RANGE	0xe0
 
 enum ath_hw_txq_subtype {
 	ATH_TXQ_AC_BE = 0,
-- 
1.7.0.4

