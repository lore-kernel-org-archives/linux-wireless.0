Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37374 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab3JJMPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Oct 2013 08:15:21 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 02/10] ath9k_hw: remove direct accesses to channel mode flags
Date: Thu, 10 Oct 2013 14:15:04 +0200
Message-Id: <1381407312-72719-2-git-send-email-nbd@openwrt.org> (sfid-20131010_141536_087355_6D91371E)
In-Reply-To: <1381407312-72719-1-git-send-email-nbd@openwrt.org>
References: <1381407312-72719-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use wrappers where available. Simplifies code and helps with further
improvements to the channel data structure

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ani.c          |   6 +-
 drivers/net/wireless/ath/ath9k/ar5008_phy.c   |  35 ++-------
 drivers/net/wireless/ath/ath9k/ar9002_hw.c    |  26 +------
 drivers/net/wireless/ath/ath9k/ar9003_phy.c   | 105 ++++++--------------------
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |  26 +------
 drivers/net/wireless/ath/ath9k/hw.c           |   7 +-
 drivers/net/wireless/ath/ath9k/hw.h           |   2 +
 drivers/net/wireless/ath/ath9k/mci.c          |   8 +-
 drivers/net/wireless/ath/ath9k/xmit.c         |   3 +-
 9 files changed, 49 insertions(+), 169 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index be466b0..d28923b 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -338,10 +338,9 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 		    aniState->cckNoiseImmunityLevel !=
 		    ATH9K_ANI_CCK_DEF_LEVEL) {
 			ath_dbg(common, ANI,
-				"Restore defaults: opmode %u chan %d Mhz/0x%x is_scanning=%d ofdm:%d cck:%d\n",
+				"Restore defaults: opmode %u chan %d Mhz is_scanning=%d ofdm:%d cck:%d\n",
 				ah->opmode,
 				chan->channel,
-				chan->channelFlags,
 				is_scanning,
 				aniState->ofdmNoiseImmunityLevel,
 				aniState->cckNoiseImmunityLevel);
@@ -354,10 +353,9 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scanning)
 		 * restore historical levels for this channel
 		 */
 		ath_dbg(common, ANI,
-			"Restore history: opmode %u chan %d Mhz/0x%x is_scanning=%d ofdm:%d cck:%d\n",
+			"Restore history: opmode %u chan %d Mhz is_scanning=%d ofdm:%d cck:%d\n",
 			ah->opmode,
 			chan->channel,
-			chan->channelFlags,
 			is_scanning,
 			aniState->ofdmNoiseImmunityLevel,
 			aniState->cckNoiseImmunityLevel);
diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index cb6435e..2bfa6fb 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -666,8 +666,7 @@ static void ar5008_hw_set_channel_regs(struct ath_hw *ah,
 	if (IS_CHAN_HT40(chan)) {
 		phymode |= AR_PHY_FC_DYN2040_EN;
 
-		if ((chan->chanmode == CHANNEL_A_HT40PLUS) ||
-		    (chan->chanmode == CHANNEL_G_HT40PLUS))
+		if (IS_CHAN_HT40PLUS(chan))
 			phymode |= AR_PHY_FC_DYN2040_PRI_CH;
 
 	}
@@ -691,31 +690,12 @@ static int ar5008_hw_process_ini(struct ath_hw *ah,
 	int i, regWrites = 0;
 	u32 modesIndex, freqIndex;
 
-	switch (chan->chanmode) {
-	case CHANNEL_A:
-	case CHANNEL_A_HT20:
-		modesIndex = 1;
+	if (IS_CHAN_5GHZ(chan)) {
 		freqIndex = 1;
-		break;
-	case CHANNEL_A_HT40PLUS:
-	case CHANNEL_A_HT40MINUS:
-		modesIndex = 2;
-		freqIndex = 1;
-		break;
-	case CHANNEL_G:
-	case CHANNEL_G_HT20:
-	case CHANNEL_B:
-		modesIndex = 4;
-		freqIndex = 2;
-		break;
-	case CHANNEL_G_HT40PLUS:
-	case CHANNEL_G_HT40MINUS:
-		modesIndex = 3;
+		modesIndex = IS_CHAN_HT40(chan) ? 2 : 1;
+	} else {
 		freqIndex = 2;
-		break;
-
-	default:
-		return -EINVAL;
+		modesIndex = IS_CHAN_HT40(chan) ? 3 : 4;
 	}
 
 	/*
@@ -1218,12 +1198,11 @@ static void ar5008_hw_ani_cache_ini_regs(struct ath_hw *ah)
 
 	iniDef = &aniState->iniDef;
 
-	ath_dbg(common, ANI, "ver %d.%d opmode %u chan %d Mhz/0x%x\n",
+	ath_dbg(common, ANI, "ver %d.%d opmode %u chan %d Mhz\n",
 		ah->hw_version.macVersion,
 		ah->hw_version.macRev,
 		ah->opmode,
-		chan->channel,
-		chan->channelFlags);
+		chan->channel);
 
 	val = REG_READ(ah, AR_PHY_SFCORR);
 	iniDef->m1Thresh = MS(val, AR_PHY_SFCORR_M1_THRESH);
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index fb61b08..5c95fd9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -419,28 +419,10 @@ void ar9002_hw_load_ani_reg(struct ath_hw *ah, struct ath9k_channel *chan)
 	u32 modesIndex;
 	int i;
 
-	switch (chan->chanmode) {
-	case CHANNEL_A:
-	case CHANNEL_A_HT20:
-		modesIndex = 1;
-		break;
-	case CHANNEL_A_HT40PLUS:
-	case CHANNEL_A_HT40MINUS:
-		modesIndex = 2;
-		break;
-	case CHANNEL_G:
-	case CHANNEL_G_HT20:
-	case CHANNEL_B:
-		modesIndex = 4;
-		break;
-	case CHANNEL_G_HT40PLUS:
-	case CHANNEL_G_HT40MINUS:
-		modesIndex = 3;
-		break;
-
-	default:
-		return;
-	}
+	if (IS_CHAN_5GHZ(chan))
+		modesIndex = IS_CHAN_HT40(chan) ? 2 : 1;
+	else
+		modesIndex = IS_CHAN_HT40(chan) ? 3 : 4;
 
 	ENABLE_REGWRITE_BUFFER(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 0131ba2..7249844 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -551,8 +551,7 @@ static void ar9003_hw_set_channel_regs(struct ath_hw *ah,
 	if (IS_CHAN_HT40(chan)) {
 		phymode |= AR_PHY_GC_DYN2040_EN;
 		/* Configure control (primary) channel at +-10MHz */
-		if ((chan->chanmode == CHANNEL_A_HT40PLUS) ||
-		    (chan->chanmode == CHANNEL_G_HT40PLUS))
+		if (IS_CHAN_HT40PLUS(chan))
 			phymode |= AR_PHY_GC_DYN2040_PRI_CH;
 
 	}
@@ -682,41 +681,22 @@ static int ar9550_hw_get_modes_txgain_index(struct ath_hw *ah,
 {
 	int ret;
 
-	switch (chan->chanmode) {
-	case CHANNEL_A:
-	case CHANNEL_A_HT20:
-		if (chan->channel <= 5350)
-			ret = 1;
-		else if ((chan->channel > 5350) && (chan->channel <= 5600))
-			ret = 3;
+	if (IS_CHAN_2GHZ(chan)) {
+		if (IS_CHAN_HT40(chan))
+			return 7;
 		else
-			ret = 5;
-		break;
-
-	case CHANNEL_A_HT40PLUS:
-	case CHANNEL_A_HT40MINUS:
-		if (chan->channel <= 5350)
-			ret = 2;
-		else if ((chan->channel > 5350) && (chan->channel <= 5600))
-			ret = 4;
-		else
-			ret = 6;
-		break;
-
-	case CHANNEL_G:
-	case CHANNEL_G_HT20:
-	case CHANNEL_B:
-		ret = 8;
-		break;
+			return 8;
+	}
 
-	case CHANNEL_G_HT40PLUS:
-	case CHANNEL_G_HT40MINUS:
-		ret = 7;
-		break;
+	if (chan->channel <= 5350)
+		ret = 1;
+	else if ((chan->channel > 5350) && (chan->channel <= 5600))
+		ret = 3;
+	else
+		ret = 5;
 
-	default:
-		ret = -EINVAL;
-	}
+	if (IS_CHAN_HT40(chan))
+		ret++;
 
 	return ret;
 }
@@ -727,28 +707,10 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	unsigned int regWrites = 0, i;
 	u32 modesIndex;
 
-	switch (chan->chanmode) {
-	case CHANNEL_A:
-	case CHANNEL_A_HT20:
-		modesIndex = 1;
-		break;
-	case CHANNEL_A_HT40PLUS:
-	case CHANNEL_A_HT40MINUS:
-		modesIndex = 2;
-		break;
-	case CHANNEL_G:
-	case CHANNEL_G_HT20:
-	case CHANNEL_B:
-		modesIndex = 4;
-		break;
-	case CHANNEL_G_HT40PLUS:
-	case CHANNEL_G_HT40MINUS:
-		modesIndex = 3;
-		break;
-
-	default:
-		return -EINVAL;
-	}
+	if (IS_CHAN_5GHZ(chan))
+		modesIndex = IS_CHAN_HT40(chan) ? 2 : 1;
+	else
+		modesIndex = IS_CHAN_HT40(chan) ? 3 : 4;
 
 	/*
 	 * SOC, MAC, BB, RADIO initvals.
@@ -1273,12 +1235,11 @@ static void ar9003_hw_ani_cache_ini_regs(struct ath_hw *ah)
 	aniState = &ah->ani;
 	iniDef = &aniState->iniDef;
 
-	ath_dbg(common, ANI, "ver %d.%d opmode %u chan %d Mhz/0x%x\n",
+	ath_dbg(common, ANI, "ver %d.%d opmode %u chan %d Mhz\n",
 		ah->hw_version.macVersion,
 		ah->hw_version.macRev,
 		ah->opmode,
-		chan->channel,
-		chan->channelFlags);
+		chan->channel);
 
 	val = REG_READ(ah, AR_PHY_SFCORR);
 	iniDef->m1Thresh = MS(val, AR_PHY_SFCORR_M1_THRESH);
@@ -1536,28 +1497,10 @@ static int ar9003_hw_fast_chan_change(struct ath_hw *ah,
 	unsigned int regWrites = 0;
 	u32 modesIndex;
 
-	switch (chan->chanmode) {
-	case CHANNEL_A:
-	case CHANNEL_A_HT20:
-		modesIndex = 1;
-		break;
-	case CHANNEL_A_HT40PLUS:
-	case CHANNEL_A_HT40MINUS:
-		modesIndex = 2;
-		break;
-	case CHANNEL_G:
-	case CHANNEL_G_HT20:
-	case CHANNEL_B:
-		modesIndex = 4;
-		break;
-	case CHANNEL_G_HT40PLUS:
-	case CHANNEL_G_HT40MINUS:
-		modesIndex = 3;
-		break;
-
-	default:
-		return -EINVAL;
-	}
+	if (IS_CHAN_5GHZ(chan))
+		modesIndex = IS_CHAN_HT40(chan) ? 2 : 1;
+	else
+		modesIndex = IS_CHAN_HT40(chan) ? 3 : 4;
 
 	if (modesIndex == ah->modes_index) {
 		*ini_reloaded = false;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index d442581..fa71af1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -24,30 +24,10 @@
 static enum htc_phymode ath9k_htc_get_curmode(struct ath9k_htc_priv *priv,
 					      struct ath9k_channel *ichan)
 {
-	enum htc_phymode mode;
-
-	mode = -EINVAL;
-
-	switch (ichan->chanmode) {
-	case CHANNEL_G:
-	case CHANNEL_G_HT20:
-	case CHANNEL_G_HT40PLUS:
-	case CHANNEL_G_HT40MINUS:
-		mode = HTC_MODE_11NG;
-		break;
-	case CHANNEL_A:
-	case CHANNEL_A_HT20:
-	case CHANNEL_A_HT40PLUS:
-	case CHANNEL_A_HT40MINUS:
-		mode = HTC_MODE_11NA;
-		break;
-	default:
-		break;
-	}
-
-	WARN_ON(mode < 0);
+	if (IS_CHAN_5GHZ(ichan))
+		return HTC_MODE_11NA;
 
-	return mode;
+	return HTC_MODE_11NG;
 }
 
 bool ath9k_htc_setpower(struct ath9k_htc_priv *priv,
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f11e838..7c4d600 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -294,8 +294,7 @@ void ath9k_hw_get_channel_centers(struct ath_hw *ah,
 		return;
 	}
 
-	if ((chan->chanmode == CHANNEL_A_HT40PLUS) ||
-	    (chan->chanmode == CHANNEL_G_HT40PLUS)) {
+	if (IS_CHAN_HT40PLUS(chan)) {
 		centers->synth_center =
 			chan->channel + HT40_CHANNEL_CENTER_SHIFT;
 		extoff = 1;
@@ -1510,9 +1509,7 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	int r;
 
 	if (pCap->hw_caps & ATH9K_HW_CAP_FCC_BAND_SWITCH) {
-		u32 cur = ah->curchan->channelFlags & (CHANNEL_2GHZ | CHANNEL_5GHZ);
-		u32 new = chan->channelFlags & (CHANNEL_2GHZ | CHANNEL_5GHZ);
-		band_switch = (cur != new);
+		band_switch = IS_CHAN_5GHZ(ah->curchan) != IS_CHAN_5GHZ(chan);
 		mode_diff = (chan->chanmode != ah->curchan->chanmode);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 2babf93..102b3b6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -463,6 +463,8 @@ struct ath9k_channel {
 			  ((_c)->chanmode == CHANNEL_G_HT40PLUS) ||	\
 			  ((_c)->chanmode == CHANNEL_G_HT40MINUS))
 #define IS_CHAN_HT(_c) (IS_CHAN_HT20((_c)) || IS_CHAN_HT40((_c)))
+#define IS_CHAN_HT40PLUS(_c) ((_c)->chanmode & CHANNEL_HT40PLUS)
+#define IS_CHAN_HT40MINUS(_c) ((_c)->chanmode & CHANNEL_HT40MINUS)
 
 enum ath9k_power_mode {
 	ATH9K_PM_AWAKE = 0,
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 815bee2..0ac1b5f 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -661,9 +661,9 @@ void ath9k_mci_update_wlan_channels(struct ath_softc *sc, bool allow_all)
 	chan_start = wlan_chan - 10;
 	chan_end = wlan_chan + 10;
 
-	if (chan->chanmode == CHANNEL_G_HT40PLUS)
+	if (IS_CHAN_HT40PLUS(chan))
 		chan_end += 20;
-	else if (chan->chanmode == CHANNEL_G_HT40MINUS)
+	else if (IS_CHAN_HT40MINUS(chan))
 		chan_start -= 20;
 
 	/* adjust side band */
@@ -707,11 +707,11 @@ void ath9k_mci_set_txpower(struct ath_softc *sc, bool setchannel,
 
 	if (setchannel) {
 		struct ath9k_hw_cal_data *caldata = &sc->caldata;
-		if ((caldata->chanmode == CHANNEL_G_HT40PLUS) &&
+		if (IS_CHAN_HT40PLUS(ah->curchan) &&
 		    (ah->curchan->channel > caldata->channel) &&
 		    (ah->curchan->channel <= caldata->channel + 20))
 			return;
-		if ((caldata->chanmode == CHANNEL_G_HT40MINUS) &&
+		if (IS_CHAN_HT40MINUS(ah->curchan) &&
 		    (ah->curchan->channel < caldata->channel) &&
 		    (ah->curchan->channel >= caldata->channel - 20))
 			return;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 1ce8af2..08ba590 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2037,8 +2037,7 @@ u8 ath_txchainmask_reduction(struct ath_softc *sc, u8 chainmask, u32 rate)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath9k_channel *curchan = ah->curchan;
 
-	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) &&
-	    (curchan->channelFlags & CHANNEL_5GHZ) &&
+	if ((ah->caps.hw_caps & ATH9K_HW_CAP_APM) && IS_CHAN_5GHZ(curchan) &&
 	    (chainmask == 0x7) && (rate < 0x90))
 		return 0x3;
 	else if (AR_SREV_9462(ah) && ath9k_hw_btcoex_is_enabled(ah) &&
-- 
1.8.0.2

