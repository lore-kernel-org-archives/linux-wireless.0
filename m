Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:50030 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3CDHOc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 02:14:32 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] ath9k_hw: Remove CHANNEL_CW_INT
Date: Mon,  4 Mar 2013 12:42:52 +0530
Message-Id: <1362381175-9634-1-git-send-email-sujith@msujith.org> (sfid-20130304_081442_407522_15E374E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This flag is used for indicating channel interference and
we currently do nothing with it, so remove it.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/calib.c | 4 +---
 drivers/net/wireless/ath/ath9k/hw.c    | 6 ++----
 drivers/net/wireless/ath/ath9k/hw.h    | 1 -
 3 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 1e85085..7bdd726 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -369,7 +369,6 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	struct ieee80211_channel *c = chan->chan;
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 
-	chan->channelFlags &= (~CHANNEL_CW_INT);
 	if (REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF) {
 		ath_dbg(common, CALIBRATE,
 			"NF did not complete in calibration window\n");
@@ -384,7 +383,6 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 		ath_dbg(common, CALIBRATE,
 			"noise floor failed detected; detected %d, threshold %d\n",
 			nf, nfThresh);
-		chan->channelFlags |= CHANNEL_CW_INT;
 	}
 
 	if (!caldata) {
@@ -410,7 +408,7 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 	int i, j;
 
 	ah->caldata->channel = chan->channel;
-	ah->caldata->channelFlags = chan->channelFlags & ~CHANNEL_CW_INT;
+	ah->caldata->channelFlags = chan->channelFlags;
 	ah->caldata->chanmode = chan->chanmode;
 	h = ah->caldata->nfCalHist;
 	default_nf = ath9k_hw_get_default_nf(ah, chan);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7b485e4..fd4b7c5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1763,10 +1763,8 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		ath9k_hw_getnf(ah, ah->curchan);
 
 	ah->caldata = caldata;
-	if (caldata &&
-	    (chan->channel != caldata->channel ||
-	     (chan->channelFlags & ~CHANNEL_CW_INT) !=
-	     (caldata->channelFlags & ~CHANNEL_CW_INT))) {
+	if (caldata && (chan->channel != caldata->channel ||
+			chan->channelFlags != caldata->channelFlags)) {
 		/* Operating channel changed, reset channel calibration data */
 		memset(caldata, 0, sizeof(*caldata));
 		ath9k_init_nfcal_hist_buffer(ah, chan);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 784e81c..30e62d9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -363,7 +363,6 @@ enum ath9k_int {
 	ATH9K_INT_NOCARD = 0xffffffff
 };
 
-#define CHANNEL_CW_INT    0x00002
 #define CHANNEL_CCK       0x00020
 #define CHANNEL_OFDM      0x00040
 #define CHANNEL_2GHZ      0x00080
-- 
1.8.1.5

