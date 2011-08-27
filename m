Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:56415 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1H0JPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 05:15:41 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: Update IFS parameters properly
Date: Sat, 27 Aug 2011 14:46:09 +0530
Message-ID: <1314436569-6855-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110827_111551_282411_CB992D64)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure IFS parameters read from chip in case of
full rate channel and non-AR9287 v1.3+. And also
read the ack and cts timeouts from chip and increase the
timeout when coverage class is defined. For half/Quarter
rate channel, IFS values needs to be reconfigured.
This patch removes the 2GHz workaround done for
acktimeout(64 us) because of reading acktime from chip.
The mentioned IFS parameters for AR9287 v1.3+ was
verified in HT40 2-chanin mode.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 284d2a4..de31f2b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -958,11 +958,11 @@ static bool ath9k_hw_set_global_txtimeout(struct ath_hw *ah, u32 tu)
 void ath9k_hw_init_global_settings(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_conf *conf = &common->hw->conf;
 	const struct ath9k_channel *chan = ah->curchan;
 	int acktimeout;
 	int slottime;
 	int sifstime;
+	u32 ctstimeout;
 	int rx_lat = 0, tx_lat = 0, eifs = 0;
 	u32 reg;
 
@@ -1018,23 +1018,27 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 			sifstime = 10;
 	}
 
-	/* As defined by IEEE 802.11-2007 17.3.8.6 */
-	acktimeout = slottime + sifstime + 3 * ah->coverage_class;
+	if (AR_SREV_9287(ah) && AR_SREV_9287_13_OR_LATER(ah)) {
+		/* Verified values (us) in 2chanin HT40 mode */
+		acktimeout = 64;
+		ctstimeout = 48;
+	} else {
+		acktimeout = MS(REG_READ(ah, AR_TIME_OUT), AR_TIME_OUT_ACK)/
+				common->clockrate;
+		ctstimeout = MS(REG_READ(ah, AR_TIME_OUT), AR_TIME_OUT_CTS)/
+				common->clockrate;
+	}
 
-	/*
-	 * Workaround for early ACK timeouts, add an offset to match the
-	 * initval's 64us ack timeout value.
-	 * This was initially only meant to work around an issue with delayed
-	 * BA frames in some implementations, but it has been found to fix ACK
-	 * timeout issues in other cases as well.
-	 */
-	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ)
-		acktimeout += 64 - sifstime - ah->slottime;
+	if (IS_CHAN_HALF_RATE(chan) || IS_CHAN_QUARTER_RATE(chan))
+		acktimeout = slottime + sifstime + 3 * ah->coverage_class;
+	else
+		acktimeout += 3 * ah->coverage_class;
 
 	ath9k_hw_set_sifs_time(ah, sifstime);
 	ath9k_hw_setslottime(ah, slottime);
 	ath9k_hw_set_ack_timeout(ah, acktimeout);
-	ath9k_hw_set_cts_timeout(ah, acktimeout);
+	ath9k_hw_set_cts_timeout(ah, ctstimeout);
+
 	if (ah->globaltxtimeout != (u32) -1)
 		ath9k_hw_set_global_txtimeout(ah, ah->globaltxtimeout);
 
-- 
1.7.6.1

