Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22670 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbYLWX7Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 18:59:16 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 15:59:16 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v3 06/16] ath9k: make request to get the noisefloor threshold band specific
Date: Tue, 23 Dec 2008 15:58:41 -0800
Message-ID: <1230076731-22946-7-git-send-email-lrodriguez@atheros.com> (sfid-20081224_005919_729884_FF8F8C37)
In-Reply-To: <1230076731-22946-6-git-send-email-lrodriguez@atheros.com>
References: <1230076731-22946-1-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-2-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-3-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-4-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-5-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-6-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lets make the request to get the current noise floor threshold
from the EEPROM band specific as it is band specific, not mode
specific.

This also adds a backpointer on the private channel structure
back to the ieee80211_channel structure as this is now needed during
ath9k_hw_getnf().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath9k/calib.c |   21 +++++++--------------
 drivers/net/wireless/ath9k/main.c  |    2 ++
 3 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 0f6a99a..78fffdf 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -453,6 +453,7 @@ struct ath9k_11n_rate_series {
 	 CHANNEL_HT40MINUS)
 
 struct ath9k_channel {
+	struct ieee80211_channel *chan;
 	u16 channel;
 	u32 channelFlags;
 	u8 privFlags;
diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index 3c7454f..2a6b8a4 100644
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
 
@@ -692,6 +684,7 @@ int16_t ath9k_hw_getnf(struct ath_hal *ah,
 	int16_t nf, nfThresh;
 	int16_t nfarray[NUM_NF_READINGS] = { 0 };
 	struct ath9k_nfcal_hist *h;
+	struct ieee80211_channel *c = chan->chan;
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
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index bbd7d06..7507d9a 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -218,6 +218,7 @@ static int ath_setup_channels(struct ath_softc *sc)
 			chan_2ghz[a].band = IEEE80211_BAND_2GHZ;
 			chan_2ghz[a].center_freq = c->channel;
 			chan_2ghz[a].max_power = c->maxTxPower;
+			c->chan = &chan_2ghz[a];
 
 			if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
 				chan_2ghz[a].flags |= IEEE80211_CHAN_NO_IBSS;
@@ -233,6 +234,7 @@ static int ath_setup_channels(struct ath_softc *sc)
 			chan_5ghz[b].band = IEEE80211_BAND_5GHZ;
 			chan_5ghz[b].center_freq = c->channel;
 			chan_5ghz[b].max_power = c->maxTxPower;
+			c->chan = &chan_5ghz[a];
 
 			if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
 				chan_5ghz[b].flags |= IEEE80211_CHAN_NO_IBSS;
-- 
1.6.1.rc3.51.g5832d

