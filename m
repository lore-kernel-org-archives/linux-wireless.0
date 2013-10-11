Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55811 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754683Ab3JKVbK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 17:31:10 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH v2 10/10] ath9k_hw: remove references to hw->conf
Date: Fri, 11 Oct 2013 23:31:01 +0200
Message-Id: <1381527061-43758-10-git-send-email-nbd@openwrt.org> (sfid-20131011_233118_155886_5DD46B7F)
In-Reply-To: <1381527061-43758-1-git-send-email-nbd@openwrt.org>
References: <1381527061-43758-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Accessing it to get the current operating channel is racy and in the way
of further channel handling related changes

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c |  2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |  2 +-
 drivers/net/wireless/ath/ath9k/calib.c      |  8 +++-----
 drivers/net/wireless/ath/ath9k/hw.c         | 21 +++++++++------------
 drivers/net/wireless/ath/ath9k/hw.h         |  2 +-
 5 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index b197bf2..ff415e8 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -672,7 +672,7 @@ static void ar5008_hw_set_channel_regs(struct ath_hw *ah,
 	}
 	REG_WRITE(ah, AR_PHY_TURBO, phymode);
 
-	ath9k_hw_set11nmac2040(ah);
+	ath9k_hw_set11nmac2040(ah, chan);
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 312c868..f3adafd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -564,7 +564,7 @@ static void ar9003_hw_set_channel_regs(struct ath_hw *ah,
 	REG_WRITE(ah, AR_PHY_GEN_CTRL, phymode);
 
 	/* Configure MAC for 20/40 operation */
-	ath9k_hw_set11nmac2040(ah);
+	ath9k_hw_set11nmac2040(ah, chan);
 
 	/* global transmit timeout (25 TUs default)*/
 	REG_WRITE(ah, AR_GTXTO, 25 << AR_GTXTO_TIMEOUT_LIMIT_S);
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index fe23026..d8db74b 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -186,7 +186,6 @@ void ath9k_hw_reset_calibration(struct ath_hw *ah,
 bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_conf *conf = &common->hw->conf;
 	struct ath9k_cal_list *currCal = ah->cal_list_curr;
 
 	if (!ah->caldata)
@@ -208,7 +207,7 @@ bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 		return true;
 
 	ath_dbg(common, CALIBRATE, "Resetting Cal %d state for channel %u\n",
-		currCal->calData->calType, conf->chandef.chan->center_freq);
+		currCal->calData->calType, ah->curchan->chan->center_freq);
 
 	ah->caldata->CalValid &= ~currCal->calData->calType;
 	currCal->calState = CAL_WAITING;
@@ -242,7 +241,6 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	int32_t val;
 	u8 chainmask = (ah->rxchainmask << 3) | ah->rxchainmask;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_conf *conf = &common->hw->conf;
 	s16 default_nf = ath9k_hw_get_default_nf(ah, chan);
 
 	if (ah->caldata)
@@ -252,7 +250,7 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 		if (chainmask & (1 << i)) {
 			s16 nfval;
 
-			if ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf))
+			if ((i >= AR5416_MAX_CHAINS) && !IS_CHAN_HT40(chan))
 				continue;
 
 			if (h)
@@ -314,7 +312,7 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	ENABLE_REGWRITE_BUFFER(ah);
 	for (i = 0; i < NUM_NF_READINGS; i++) {
 		if (chainmask & (1 << i)) {
-			if ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf))
+			if ((i >= AR5416_MAX_CHAINS) && !IS_CHAN_HT40(chan))
 				continue;
 
 			val = REG_READ(ah, ah->nf_regs[i]);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index bc7382f..dcdbab4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -130,29 +130,29 @@ void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause)
 
 static void ath9k_hw_set_clockrate(struct ath_hw *ah)
 {
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath9k_channel *chan = ah->curchan;
 	unsigned int clockrate;
 
 	/* AR9287 v1.3+ uses async FIFO and runs the MAC at 117 MHz */
 	if (AR_SREV_9287(ah) && AR_SREV_9287_13_OR_LATER(ah))
 		clockrate = 117;
-	else if (!ah->curchan) /* should really check for CCK instead */
+	else if (!chan) /* should really check for CCK instead */
 		clockrate = ATH9K_CLOCK_RATE_CCK;
-	else if (conf->chandef.chan->band == IEEE80211_BAND_2GHZ)
+	else if (IS_CHAN_2GHZ(chan))
 		clockrate = ATH9K_CLOCK_RATE_2GHZ_OFDM;
 	else if (ah->caps.hw_caps & ATH9K_HW_CAP_FASTCLOCK)
 		clockrate = ATH9K_CLOCK_FAST_RATE_5GHZ_OFDM;
 	else
 		clockrate = ATH9K_CLOCK_RATE_5GHZ_OFDM;
 
-	if (conf_is_ht40(conf))
+	if (IS_CHAN_HT40(chan))
 		clockrate *= 2;
 
 	if (ah->curchan) {
-		if (IS_CHAN_HALF_RATE(ah->curchan))
+		if (IS_CHAN_HALF_RATE(chan))
 			clockrate /= 2;
-		if (IS_CHAN_QUARTER_RATE(ah->curchan))
+		if (IS_CHAN_QUARTER_RATE(chan))
 			clockrate /= 4;
 	}
 
@@ -1038,7 +1038,6 @@ static bool ath9k_hw_set_global_txtimeout(struct ath_hw *ah, u32 tu)
 void ath9k_hw_init_global_settings(struct ath_hw *ah)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_conf *conf = &common->hw->conf;
 	const struct ath9k_channel *chan = ah->curchan;
 	int acktimeout, ctstimeout, ack_offset = 0;
 	int slottime;
@@ -1113,8 +1112,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	 * BA frames in some implementations, but it has been found to fix ACK
 	 * timeout issues in other cases as well.
 	 */
-	if (conf->chandef.chan &&
-	    conf->chandef.chan->band == IEEE80211_BAND_2GHZ &&
+	if (IS_CHAN_2GHZ(chan) &&
 	    !IS_CHAN_HALF_RATE(chan) && !IS_CHAN_QUARTER_RATE(chan)) {
 		acktimeout += 64 - sifstime - ah->slottime;
 		ctstimeout += 48 - sifstime - ah->slottime;
@@ -2946,12 +2944,11 @@ void ath9k_hw_set_tsfadjust(struct ath_hw *ah, bool set)
 }
 EXPORT_SYMBOL(ath9k_hw_set_tsfadjust);
 
-void ath9k_hw_set11nmac2040(struct ath_hw *ah)
+void ath9k_hw_set11nmac2040(struct ath_hw *ah, struct ath9k_channel *chan)
 {
-	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
 	u32 macmode;
 
-	if (conf_is_ht40(conf) && !ah->config.cwm_ignore_extcca)
+	if (IS_CHAN_HT40(chan) && !ah->config.cwm_ignore_extcca)
 		macmode = AR_2040_JOINED_RX_CLEAR;
 	else
 		macmode = 0;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 9d04d67..81fcbc7 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1003,7 +1003,7 @@ void ath9k_hw_reset_tsf(struct ath_hw *ah);
 void ath9k_hw_set_tsfadjust(struct ath_hw *ah, bool set);
 void ath9k_hw_init_global_settings(struct ath_hw *ah);
 u32 ar9003_get_pll_sqsum_dvc(struct ath_hw *ah);
-void ath9k_hw_set11nmac2040(struct ath_hw *ah);
+void ath9k_hw_set11nmac2040(struct ath_hw *ah, struct ath9k_channel *chan);
 void ath9k_hw_beaconinit(struct ath_hw *ah, u32 next_beacon, u32 beacon_period);
 void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
 				    const struct ath9k_beacon_state *bs);
-- 
1.8.0.2

