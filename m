Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:55694 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbYLTFzr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 00:55:47 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 21:55:47 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 08/16] ath9k: make request to get the noisefloor threshold band specific
Date: Fri, 19 Dec 2008 21:55:14 -0800
Message-ID: <1229752522-1917-9-git-send-email-lrodriguez@atheros.com> (sfid-20081220_065607_985086_41E2EE8B)
In-Reply-To: <1229752522-1917-8-git-send-email-lrodriguez@atheros.com>
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-3-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-4-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-5-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-6-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-7-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-8-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lets make the request to get the current noise floor threshold
from the EEPROM band specific as it is band specific, not mode
specific.

This also adds a backpointer on the private channel structure
back to the ieee80211_channel structure as this is now needed during
hw reset when it tries to get the current EEPROM noise floor threshold.

Finally we note that calibration always works on the current channel
and because of this the "internal" channel will always be the current
channel. Because this is true we don't need to clear the CHANNEL_CW_INT
flag anymore. This is currently unused but can be used later in AP mode.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    3 ++-
 drivers/net/wireless/ath9k/calib.c |   27 ++++++++++-----------------
 drivers/net/wireless/ath9k/hw.c    |    2 +-
 drivers/net/wireless/ath9k/main.c  |    2 ++
 4 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 823f1d6..8e47802 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -453,6 +453,7 @@ struct ath9k_11n_rate_series {
 	 CHANNEL_HT40MINUS)
 
 struct ath9k_channel {
+	struct ieee80211_channel *chan;
 	u16 channel;
 	u32 channelFlags;
 	u8 privFlags;
@@ -951,7 +952,7 @@ void ath9k_hw_reset_calvalid(struct ath_hal *ah, struct ath9k_channel *chan,
 void ath9k_hw_start_nfcal(struct ath_hal *ah);
 void ath9k_hw_loadnf(struct ath_hal *ah, struct ath9k_channel *chan);
 int16_t ath9k_hw_getnf(struct ath_hal *ah,
-		       struct ath9k_channel *chan);
+		       struct ieee80211_channel *c);
 void ath9k_init_nfcal_hist_buffer(struct ath_hal *ah);
 s16 ath9k_hw_getchan_noise(struct ath_hal *ah, struct ath9k_channel *chan);
 bool ath9k_hw_calibrate(struct ath_hal *ah, struct ath9k_channel *chan,
diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index 3c7454f..c72bf10 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -168,26 +168,18 @@ static void ath9k_hw_do_getnf(struct ath_hal *ah,
 }
 
 static bool getNoiseFloorThresh(struct ath_hal *ah,
-				const struct ath9k_channel *chan,
+				enum ieee80211_band band,
 				int16_t *nft)
 {
-	switch (chan->chanmode) {
-	case CHANNEL_A:
-	case CHANNEL_A_HT20:
-	case CHANNEL_A_HT40PLUS:
-	case CHANNEL_A_HT40MINUS:
+	switch (band) {
+	case IEEE80211_BAND_5GHZ:
 		*nft = (int8_t)ath9k_hw_get_eeprom(ah, EEP_NFTHRESH_5);
 		break;
-	case CHANNEL_B:
-	case CHANNEL_G:
-	case CHANNEL_G_HT20:
-	case CHANNEL_G_HT40PLUS:
-	case CHANNEL_G_HT40MINUS:
+	case IEEE80211_BAND_2GHZ:
 		*nft = (int8_t)ath9k_hw_get_eeprom(ah, EEP_NFTHRESH_2);
 		break;
 	default:
-		DPRINTF(ah->ah_sc, ATH_DBG_CHANNEL,
-			"invalid channel flags 0x%x\n", chan->channelFlags);
+		BUG_ON(1);
 		return false;
 	}
 
@@ -687,11 +679,12 @@ void ath9k_hw_loadnf(struct ath_hal *ah, struct ath9k_channel *chan)
 }
 
 int16_t ath9k_hw_getnf(struct ath_hal *ah,
-		       struct ath9k_channel *chan)
+		       struct ieee80211_channel *c)
 {
 	int16_t nf, nfThresh;
 	int16_t nfarray[NUM_NF_READINGS] = { 0 };
 	struct ath9k_nfcal_hist *h;
+	struct ath9k_channel *chan = (struct ath9k_channel *) c->priv;
 	u8 chainmask;
 
 	if (AR_SREV_9280(ah))
@@ -709,7 +702,7 @@ int16_t ath9k_hw_getnf(struct ath_hal *ah,
 	} else {
 		ath9k_hw_do_getnf(ah, nfarray);
 		nf = nfarray[0];
-		if (getNoiseFloorThresh(ah, chan, &nfThresh)
+		if (getNoiseFloorThresh(ah, c->band, &nfThresh)
 		    && nf > nfThresh) {
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				"noise floor failed detected; "
@@ -805,13 +798,13 @@ bool ath9k_hw_calibrate(struct ath_hal *ah, struct ath9k_channel *chan,
 	}
 
 	if (longcal) {
-		ath9k_hw_getnf(ah, ichan);
+		BUG_ON(chan != ichan);
+		ath9k_hw_getnf(ah, ichan->chan);
 		ath9k_hw_loadnf(ah, ah->ah_curchan);
 		ath9k_hw_start_nfcal(ah);
 
 		if ((ichan->channelFlags & CHANNEL_CW_INT) != 0) {
 			chan->channelFlags |= CHANNEL_CW_INT;
-			ichan->channelFlags &= ~CHANNEL_CW_INT;
 		}
 	}
 
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 60cc0ba..eb0ec06 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2222,7 +2222,7 @@ int ath9k_hw_reset(struct ath_hal *ah, bool bChannelChange)
 		return -EIO;
 
 	if (curchan)
-		ath9k_hw_getnf(ah, curchan);
+		ath9k_hw_getnf(ah, curchan->chan);
 
 	if (bChannelChange &&
 	    (ahp->ah_chipFullSleep != true) &&
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 57d5178..0d47936 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -216,6 +216,7 @@ static int ath_setup_channels(struct ath_softc *sc)
 			chan_2ghz[a].center_freq = c->channel;
 			chan_2ghz[a].max_power = c->maxTxPower;
 			chan_2ghz[a].priv = c;
+			c->chan = &chan_2ghz[a];
 
 			if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
 				chan_2ghz[a].flags |= IEEE80211_CHAN_NO_IBSS;
@@ -231,6 +232,7 @@ static int ath_setup_channels(struct ath_softc *sc)
 			chan_5ghz[b].center_freq = c->channel;
 			chan_5ghz[b].max_power = c->maxTxPower;
 			chan_5ghz[b].priv = c;
+			c->chan = &chan_5ghz[a];
 
 			if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
 				chan_5ghz[b].flags |= IEEE80211_CHAN_NO_IBSS;
-- 
1.5.6.rc2.15.g457bb.dirty

