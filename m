Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2297 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab1JGLud (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 07:50:33 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 12/14] ath9k_hw: Do fast channel change based on reusable calibration results
Date: Fri, 7 Oct 2011 17:17:17 +0530
Message-ID: <1317988039-28632-12-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111007_141655_560134_44A3A21D)
In-Reply-To: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1317988039-28632-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support the fast channel change across band switch only when there
are available of reusable cabliration results. And also observed that
doing agc control calibration on fastcc, sometimes causing calibration
timeout. Hence changing agc control to be run only on full chip reset.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c |    3 +--
 drivers/net/wireless/ath/ath9k/hw.c           |   14 ++++++++++++--
 drivers/net/wireless/ath/ath9k/hw.h           |    1 +
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index d5b671a..3a2fd53 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -1007,8 +1007,7 @@ static bool ar9003_hw_init_cal(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_ACTIVE, AR_PHY_ACTIVE_EN);
 
 skip_tx_iqcal:
-
-	if (run_agc_cal) {
+	if (run_agc_cal || !(ah->ah_flags & AH_FASTCC)) {
 		/* Calibrate the AGC */
 		REG_WRITE(ah, AR_PHY_AGC_CONTROL,
 			  REG_READ(ah, AR_PHY_AGC_CONTROL) |
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 96dc730..e5dbf12 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1455,6 +1455,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	ath9k_hw_spur_mitigate_freq(ah, chan);
 
 	if (edma && (band_switch || mode_diff)) {
+		ah->ah_flags |= AH_FASTCC;
 		if (band_switch || ini_reloaded)
 			ah->eep_ops->set_board_values(ah, chan);
 
@@ -1462,6 +1463,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 
 		if (band_switch || ini_reloaded)
 			ath9k_hw_init_cal(ah, chan);
+		ah->ah_flags &= ~AH_FASTCC;
 	}
 
 	return true;
@@ -1519,6 +1521,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	u32 macStaId1;
 	u64 tsf = 0;
 	int i, r;
+	bool allow_fbs = false;
 
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return -EIO;
@@ -1540,12 +1543,19 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (AR_SREV_9280(ah) && common->bus_ops->ath_bus_type == ATH_PCI)
 		bChannelChange = false;
 
+	if (caldata &&
+	    caldata->done_txiqcal_once &&
+	    caldata->done_txclcal_once &&
+	    caldata->rtt_hist.num_readings)
+		allow_fbs = true;
+
 	if (bChannelChange &&
 	    (ah->chip_fullsleep != true) &&
 	    (ah->curchan != NULL) &&
 	    (chan->channel != ah->curchan->channel) &&
-	    ((chan->channelFlags & CHANNEL_ALL) ==
-	     (ah->curchan->channelFlags & CHANNEL_ALL))) {
+	    (allow_fbs ||
+	     ((chan->channelFlags & CHANNEL_ALL) ==
+	      (ah->curchan->channelFlags & CHANNEL_ALL)))) {
 		if (ath9k_hw_channel_change(ah, chan)) {
 			ath9k_hw_loadnf(ah, ah->curchan);
 			ath9k_hw_start_nfcal(ah, true);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 64f5a92..3ed3619 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -660,6 +660,7 @@ enum ath_cal_list {
 /* ah_flags */
 #define AH_USE_EEPROM   0x1
 #define AH_UNPLUGGED    0x2 /* The card has been physically removed. */
+#define AH_FASTCC       0x4
 
 struct ath_hw {
 	struct ath_ops reg_ops;
-- 
1.7.7

