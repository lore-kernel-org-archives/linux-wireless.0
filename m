Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37393 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721Ab3JJMPW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Oct 2013 08:15:22 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 05/10] ath9k_hw: simplify channel flags
Date: Thu, 10 Oct 2013 14:15:07 +0200
Message-Id: <1381407312-72719-5-git-send-email-nbd@openwrt.org> (sfid-20131010_141540_003424_7DDE2A0D)
In-Reply-To: <1381407312-72719-1-git-send-email-nbd@openwrt.org>
References: <1381407312-72719-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There was some duplication between channelFlags and chanmode, as well as
a lot of redundant checks based on the combinations of flags.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/calib.c  |  1 -
 drivers/net/wireless/ath/ath9k/common.c | 75 ++++++++-----------------------
 drivers/net/wireless/ath/ath9k/hw.c     | 24 +++-------
 drivers/net/wireless/ath/ath9k/hw.h     | 80 +++++++++++----------------------
 4 files changed, 50 insertions(+), 130 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index d438a03..fe23026 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -408,7 +408,6 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 
 	ah->caldata->channel = chan->channel;
 	ah->caldata->channelFlags = chan->channelFlags;
-	ah->caldata->chanmode = chan->chanmode;
 	h = ah->caldata->nfCalHist;
 	default_nf = ath9k_hw_get_default_nf(ah, chan);
 	for (i = 0; i < NUM_NF_READINGS; i++) {
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index d3063c2..b5ac269 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -49,83 +49,44 @@ int ath9k_cmn_get_hw_crypto_keytype(struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ath9k_cmn_get_hw_crypto_keytype);
 
-static u32 ath9k_get_extchanmode(struct cfg80211_chan_def *chandef)
-{
-	u32 chanmode = 0;
-
-	switch (chandef->chan->band) {
-	case IEEE80211_BAND_2GHZ:
-		switch (chandef->width) {
-		case NL80211_CHAN_WIDTH_20_NOHT:
-		case NL80211_CHAN_WIDTH_20:
-			chanmode = CHANNEL_G_HT20;
-			break;
-		case NL80211_CHAN_WIDTH_40:
-			if (chandef->center_freq1 > chandef->chan->center_freq)
-				chanmode = CHANNEL_G_HT40PLUS;
-			else
-				chanmode = CHANNEL_G_HT40MINUS;
-			break;
-		default:
-			break;
-		}
-		break;
-	case IEEE80211_BAND_5GHZ:
-		switch (chandef->width) {
-		case NL80211_CHAN_WIDTH_20_NOHT:
-		case NL80211_CHAN_WIDTH_20:
-			chanmode = CHANNEL_A_HT20;
-			break;
-		case NL80211_CHAN_WIDTH_40:
-			if (chandef->center_freq1 > chandef->chan->center_freq)
-				chanmode = CHANNEL_A_HT40PLUS;
-			else
-				chanmode = CHANNEL_A_HT40MINUS;
-			break;
-		default:
-			break;
-		}
-		break;
-	default:
-		break;
-	}
-
-	return chanmode;
-}
-
 /*
  * Update internal channel flags.
  */
 void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
 			       struct cfg80211_chan_def *chandef)
 {
-	ichan->channel = chandef->chan->center_freq;
-	ichan->chan = chandef->chan;
-
-	if (chandef->chan->band == IEEE80211_BAND_2GHZ) {
-		ichan->chanmode = CHANNEL_G;
-		ichan->channelFlags = CHANNEL_2GHZ | CHANNEL_OFDM;
-	} else {
-		ichan->chanmode = CHANNEL_A;
-		ichan->channelFlags = CHANNEL_5GHZ | CHANNEL_OFDM;
-	}
+	struct ieee80211_channel *chan = chandef->chan;
+	u16 flags = 0;
+
+	ichan->channel = chan->center_freq;
+	ichan->chan = chan;
+
+	if (chan->band == IEEE80211_BAND_5GHZ)
+		flags |= CHANNEL_5GHZ;
 
 	switch (chandef->width) {
 	case NL80211_CHAN_WIDTH_5:
-		ichan->channelFlags |= CHANNEL_QUARTER;
+		flags |= CHANNEL_QUARTER;
 		break;
 	case NL80211_CHAN_WIDTH_10:
-		ichan->channelFlags |= CHANNEL_HALF;
+		flags |= CHANNEL_HALF;
 		break;
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		break;
 	case NL80211_CHAN_WIDTH_20:
+		flags |= CHANNEL_HT;
+		break;
 	case NL80211_CHAN_WIDTH_40:
-		ichan->chanmode = ath9k_get_extchanmode(chandef);
+		if (chandef->center_freq1 > chandef->chan->center_freq)
+			flags |= CHANNEL_HT40PLUS | CHANNEL_HT;
+		else
+			flags |= CHANNEL_HT40MINUS | CHANNEL_HT;
 		break;
 	default:
 		WARN_ON(1);
 	}
+
+	ichan->channelFlags = flags;
 }
 EXPORT_SYMBOL(ath9k_cmn_update_ichannel);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 40a1132..bc7382f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1156,7 +1156,7 @@ u32 ath9k_regd_get_ctl(struct ath_regulatory *reg, struct ath9k_channel *chan)
 {
 	u32 ctl = ath_regd_get_band_ctl(reg, chan->chan->band);
 
-	if (IS_CHAN_G(chan))
+	if (IS_CHAN_2GHZ(chan))
 		ctl |= CTL_11G;
 	else
 		ctl |= CTL_11A;
@@ -1505,7 +1505,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 
 	if (pCap->hw_caps & ATH9K_HW_CAP_FCC_BAND_SWITCH) {
 		band_switch = IS_CHAN_5GHZ(ah->curchan) != IS_CHAN_5GHZ(chan);
-		mode_diff = (chan->chanmode != ah->curchan->chanmode);
+		mode_diff = (chan->channelFlags != ah->curchan->channelFlags);
 	}
 
 	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
@@ -1814,20 +1814,11 @@ static int ath9k_hw_do_fastcc(struct ath_hw *ah, struct ath9k_channel *chan)
 		goto fail;
 
 	/*
-	 * If cross-band fcc is not supoprted, bail out if
-	 * either channelFlags or chanmode differ.
-	 *
-	 * chanmode will be different if the HT operating mode
-	 * changes because of CSA.
+	 * If cross-band fcc is not supoprted, bail out if channelFlags differ.
 	 */
-	if (!(pCap->hw_caps & ATH9K_HW_CAP_FCC_BAND_SWITCH)) {
-		if ((chan->channelFlags & CHANNEL_ALL) !=
-		    (ah->curchan->channelFlags & CHANNEL_ALL))
-			goto fail;
-
-		if (chan->chanmode != ah->curchan->chanmode)
-			goto fail;
-	}
+	if (!(pCap->hw_caps & ATH9K_HW_CAP_FCC_BAND_SWITCH) &&
+	    chan->channelFlags != ah->curchan->channelFlags)
+		goto fail;
 
 	if (!ath9k_hw_check_alive(ah))
 		goto fail;
@@ -1889,8 +1880,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 
 	ah->caldata = caldata;
 	if (caldata && (chan->channel != caldata->channel ||
-			chan->channelFlags != caldata->channelFlags ||
-			chan->chanmode != caldata->chanmode)) {
+			chan->channelFlags != caldata->channelFlags)) {
 		/* Operating channel changed, reset channel calibration data */
 		memset(caldata, 0, sizeof(*caldata));
 		ath9k_init_nfcal_hist_buffer(ah, chan);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 0e44693..9d04d67 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -369,36 +369,6 @@ enum ath9k_int {
 	ATH9K_INT_NOCARD = 0xffffffff
 };
 
-#define CHANNEL_CCK       0x00020
-#define CHANNEL_OFDM      0x00040
-#define CHANNEL_2GHZ      0x00080
-#define CHANNEL_5GHZ      0x00100
-#define CHANNEL_PASSIVE   0x00200
-#define CHANNEL_DYN       0x00400
-#define CHANNEL_HALF      0x04000
-#define CHANNEL_QUARTER   0x08000
-#define CHANNEL_HT20      0x10000
-#define CHANNEL_HT40PLUS  0x20000
-#define CHANNEL_HT40MINUS 0x40000
-
-#define CHANNEL_A           (CHANNEL_5GHZ|CHANNEL_OFDM)
-#define CHANNEL_B           (CHANNEL_2GHZ|CHANNEL_CCK)
-#define CHANNEL_G           (CHANNEL_2GHZ|CHANNEL_OFDM)
-#define CHANNEL_G_HT20      (CHANNEL_2GHZ|CHANNEL_HT20)
-#define CHANNEL_A_HT20      (CHANNEL_5GHZ|CHANNEL_HT20)
-#define CHANNEL_G_HT40PLUS  (CHANNEL_2GHZ|CHANNEL_HT40PLUS)
-#define CHANNEL_G_HT40MINUS (CHANNEL_2GHZ|CHANNEL_HT40MINUS)
-#define CHANNEL_A_HT40PLUS  (CHANNEL_5GHZ|CHANNEL_HT40PLUS)
-#define CHANNEL_A_HT40MINUS (CHANNEL_5GHZ|CHANNEL_HT40MINUS)
-#define CHANNEL_ALL				\
-	(CHANNEL_OFDM|				\
-	 CHANNEL_CCK|				\
-	 CHANNEL_2GHZ |				\
-	 CHANNEL_5GHZ |				\
-	 CHANNEL_HT20 |				\
-	 CHANNEL_HT40PLUS |			\
-	 CHANNEL_HT40MINUS)
-
 #define MAX_RTT_TABLE_ENTRY     6
 #define MAX_IQCAL_MEASUREMENT	8
 #define MAX_CL_TAB_ENTRY	16
@@ -417,8 +387,7 @@ enum ath9k_cal_flags {
 
 struct ath9k_hw_cal_data {
 	u16 channel;
-	u32 channelFlags;
-	u32 chanmode;
+	u16 channelFlags;
 	unsigned long cal_flags;
 	int32_t CalValid;
 	int8_t iCoff;
@@ -436,33 +405,34 @@ struct ath9k_hw_cal_data {
 struct ath9k_channel {
 	struct ieee80211_channel *chan;
 	u16 channel;
-	u32 channelFlags;
-	u32 chanmode;
+	u16 channelFlags;
 	s16 noisefloor;
 };
 
-#define IS_CHAN_G(_c) ((((_c)->channelFlags & (CHANNEL_G)) == CHANNEL_G) || \
-       (((_c)->channelFlags & CHANNEL_G_HT20) == CHANNEL_G_HT20) || \
-       (((_c)->channelFlags & CHANNEL_G_HT40PLUS) == CHANNEL_G_HT40PLUS) || \
-       (((_c)->channelFlags & CHANNEL_G_HT40MINUS) == CHANNEL_G_HT40MINUS))
-#define IS_CHAN_5GHZ(_c) (((_c)->channelFlags & CHANNEL_5GHZ) != 0)
-#define IS_CHAN_2GHZ(_c) (((_c)->channelFlags & CHANNEL_2GHZ) != 0)
-#define IS_CHAN_HALF_RATE(_c) (((_c)->channelFlags & CHANNEL_HALF) != 0)
-#define IS_CHAN_QUARTER_RATE(_c) (((_c)->channelFlags & CHANNEL_QUARTER) != 0)
+#define CHANNEL_5GHZ		BIT(0)
+#define CHANNEL_HALF		BIT(1)
+#define CHANNEL_QUARTER		BIT(2)
+#define CHANNEL_HT		BIT(3)
+#define CHANNEL_HT40PLUS	BIT(4)
+#define CHANNEL_HT40MINUS	BIT(5)
+
+#define IS_CHAN_5GHZ(_c) (!!((_c)->channelFlags & CHANNEL_5GHZ))
+#define IS_CHAN_2GHZ(_c) (!IS_CHAN_5GHZ(_c))
+
+#define IS_CHAN_HALF_RATE(_c) (!!((_c)->channelFlags & CHANNEL_HALF))
+#define IS_CHAN_QUARTER_RATE(_c) (!!((_c)->channelFlags & CHANNEL_QUARTER))
 #define IS_CHAN_A_FAST_CLOCK(_ah, _c)			\
-	((((_c)->channelFlags & CHANNEL_5GHZ) != 0) &&	\
-	 ((_ah)->caps.hw_caps & ATH9K_HW_CAP_FASTCLOCK))
-
-/* These macros check chanmode and not channelFlags */
-#define IS_CHAN_HT20(_c) (((_c)->chanmode == CHANNEL_A_HT20) ||	\
-			  ((_c)->chanmode == CHANNEL_G_HT20))
-#define IS_CHAN_HT40(_c) (((_c)->chanmode == CHANNEL_A_HT40PLUS) ||	\
-			  ((_c)->chanmode == CHANNEL_A_HT40MINUS) ||	\
-			  ((_c)->chanmode == CHANNEL_G_HT40PLUS) ||	\
-			  ((_c)->chanmode == CHANNEL_G_HT40MINUS))
-#define IS_CHAN_HT(_c) (IS_CHAN_HT20((_c)) || IS_CHAN_HT40((_c)))
-#define IS_CHAN_HT40PLUS(_c) ((_c)->chanmode & CHANNEL_HT40PLUS)
-#define IS_CHAN_HT40MINUS(_c) ((_c)->chanmode & CHANNEL_HT40MINUS)
+	(IS_CHAN_5GHZ(_c) && ((_ah)->caps.hw_caps & ATH9K_HW_CAP_FASTCLOCK))
+
+#define IS_CHAN_HT(_c) ((_c)->channelFlags & CHANNEL_HT)
+
+#define IS_CHAN_HT20(_c) (IS_CHAN_HT(_c) && !IS_CHAN_HT40(_c))
+
+#define IS_CHAN_HT40(_c) \
+	(!!((_c)->channelFlags & (CHANNEL_HT40PLUS | CHANNEL_HT40MINUS)))
+
+#define IS_CHAN_HT40PLUS(_c) ((_c)->channelFlags & CHANNEL_HT40PLUS)
+#define IS_CHAN_HT40MINUS(_c) ((_c)->channelFlags & CHANNEL_HT40MINUS)
 
 enum ath9k_power_mode {
 	ATH9K_PM_AWAKE = 0,
-- 
1.8.0.2

