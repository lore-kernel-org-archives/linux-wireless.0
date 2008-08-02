Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25760 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbYHBXtS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 19:49:18 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 16:49:18 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<jouni.malinen@atheros.com>,
	Sujith Manoharan <smanoharan@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Sujith <Sujith.Manoharan@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 06/12] ath9k: Pass channel mode when setting a channel
Date: Sat, 2 Aug 2008 16:48:58 -0700
Message-ID: <1217720944-23234-7-git-send-email-lrodriguez@atheros.com> (sfid-20080803_014921_152551_9D40552F)
In-Reply-To: <1217720944-23234-6-git-send-email-lrodriguez@atheros.com>
References: <1217720944-23234-1-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-2-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-3-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-4-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-5-git-send-email-lrodriguez@atheros.com>
 <1217720944-23234-6-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <smanoharan@atheros.com>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    9 ++-
 drivers/net/wireless/ath9k/main.c  |  132 +++++++++++++++---------------------
 2 files changed, 60 insertions(+), 81 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index c99c6ba..8e86e11 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -424,6 +424,7 @@ struct hal_11n_rate_series {
 struct hal_channel {
 	u_int16_t channel;
 	u_int32_t channelFlags;
+	u_int32_t chanmode;
 	u_int8_t privFlags;
 	int8_t maxRegTxPower;
 	int8_t maxTxPower;
@@ -517,10 +518,10 @@ struct ath9k_channel {
 			  || (((_c)->channelFlags & CHANNEL_HT40MINUS) != 0))
 #define IS_CHAN_HT(_c) (IS_CHAN_HT20((_c)) || IS_CHAN_HT40((_c)))
 #define IS_CHAN_IN_PUBLIC_SAFETY_BAND(_c) ((_c) > 4940 && (_c) < 4990)
-#define IS_CHAN_A_5MHZ_SPACED(_c) \
-	((((_c)->channelFlags & CHANNEL_5GHZ) != 0) && \
-	(((_c)->channel % 20) != 0) &&	\
-	(((_c)->channel % 10) != 0))
+#define IS_CHAN_A_5MHZ_SPACED(_c)			\
+	((((_c)->channelFlags & CHANNEL_5GHZ) != 0) &&	\
+	 (((_c)->channel % 20) != 0) &&			\
+	 (((_c)->channel % 10) != 0))
 
 struct hal_keyval {
 	u_int8_t kv_type;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index a5ece47..b899611 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -41,27 +41,57 @@ static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 	{ 0 }
 };
 
-static int ath_check_chanflags(struct ieee80211_channel *chan,
-			       u_int32_t mode,
-			       struct ath_softc *sc)
+static int ath_get_chanflags(struct ath_softc *sc,
+			     struct ieee80211_channel *chan)
 {
-	struct ieee80211_hw *hw = sc->hw;
-	struct ieee80211_supported_band *band;
-	struct ieee80211_channel *band_channel;
 	int i;
 
-	band = hw->wiphy->bands[chan->band];
+	for (i = 0; i < sc->sc_ah->ah_nchan; i++) {
+		if (sc->sc_ah->ah_channels[i].channel == chan->center_freq)
+			return sc->sc_ah->ah_channels[i].channelFlags;
+	}
 
-	for (i = 0; i < band->n_channels; i++) {
-		band_channel = &band->channels[i];
+	return 0;
+}
 
-		if ((band_channel->center_freq == chan->center_freq) &&
-		    ((band_channel->hw_value & mode) == mode))
-			return 1;
+static u_int32_t ath_get_extchanmode(struct ath_softc *sc,
+				     struct ieee80211_channel *chan)
+{
+	u_int32_t chanmode = 0;
+	u_int8_t ext_chan_offset = sc->sc_ht_info.ext_chan_offset;
+	enum hal_ht_macmode tx_chan_width = sc->sc_ht_info.tx_chan_width;
+
+	switch (chan->band) {
+	case IEEE80211_BAND_2GHZ:
+		if ((ext_chan_offset == IEEE80211_HT_IE_CHA_SEC_NONE) &&
+		    (tx_chan_width == HAL_HT_MACMODE_20))
+			chanmode = CHANNEL_G_HT20;
+		if ((ext_chan_offset == IEEE80211_HT_IE_CHA_SEC_ABOVE) &&
+		    (tx_chan_width == HAL_HT_MACMODE_2040))
+			chanmode = CHANNEL_G_HT40PLUS;
+		if ((ext_chan_offset == IEEE80211_HT_IE_CHA_SEC_BELOW) &&
+		    (tx_chan_width == HAL_HT_MACMODE_2040))
+			chanmode = CHANNEL_G_HT40MINUS;
+		break;
+	case IEEE80211_BAND_5GHZ:
+		if ((ext_chan_offset == IEEE80211_HT_IE_CHA_SEC_NONE) &&
+		    (tx_chan_width == HAL_HT_MACMODE_20))
+			chanmode = CHANNEL_A_HT20;
+		if ((ext_chan_offset == IEEE80211_HT_IE_CHA_SEC_ABOVE) &&
+		    (tx_chan_width == HAL_HT_MACMODE_2040))
+			chanmode = CHANNEL_A_HT40PLUS;
+		if ((ext_chan_offset == IEEE80211_HT_IE_CHA_SEC_BELOW) &&
+		    (tx_chan_width == HAL_HT_MACMODE_2040))
+			chanmode = CHANNEL_A_HT40MINUS;
+		break;
+	default:
+		break;
 	}
-	return 0;
+
+	return chanmode;
 }
 
+
 static int ath_setkey_tkip(struct ath_softc *sc,
 			   struct ieee80211_key_conf *key,
 			   struct hal_keyval *hk,
@@ -313,7 +343,9 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	/* setup initial channel */
 
 	hchan.channel = curchan->center_freq;
-	hchan.channelFlags = ath_chan2flags(curchan, sc);
+	hchan.channelFlags = ath_get_chanflags(sc, curchan);
+	hchan.chanmode = (curchan->band == IEEE80211_BAND_2GHZ) ?
+		CHANNEL_G : CHANNEL_A;
 
 	/* open ath_dev */
 	error = ath_open(sc, &hchan);
@@ -465,7 +497,9 @@ static int ath9k_config(struct ieee80211_hw *hw,
 		curchan->center_freq);
 
 	hchan.channel = curchan->center_freq;
-	hchan.channelFlags = ath_chan2flags(curchan, sc);
+	hchan.channelFlags = ath_get_chanflags(sc, curchan);
+	hchan.chanmode = (curchan->band == IEEE80211_BAND_2GHZ) ?
+		CHANNEL_G : CHANNEL_A;
 	sc->sc_config.txpowlimit = 2 * conf->power_level;
 
 	/* set h/w channel */
@@ -804,7 +838,12 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 			curchan->center_freq);
 
 		hchan.channel = curchan->center_freq;
-		hchan.channelFlags = ath_chan2flags(curchan, sc);
+		hchan.channelFlags = ath_get_chanflags(sc, curchan);
+		if (hw->conf.ht_conf.ht_supported)
+			hchan.chanmode = ath_get_extchanmode(sc, curchan);
+		else
+			hchan.chanmode = (curchan->band == IEEE80211_BAND_2GHZ)
+				? CHANNEL_G : CHANNEL_A;
 
 		/* set h/w channel */
 		if (ath_set_channel(sc, &hchan) < 0)
@@ -961,67 +1000,6 @@ static struct ieee80211_ops ath9k_ops = {
 	.ampdu_action       = ath9k_ampdu_action
 };
 
-u_int32_t ath_chan2flags(struct ieee80211_channel *chan,
-				struct ath_softc *sc)
-{
-	struct ieee80211_hw *hw = sc->hw;
-	struct ath_ht_info *ht_info = &sc->sc_ht_info;
-
-	if (sc->sc_scanning) {
-		if (chan->band == IEEE80211_BAND_5GHZ) {
-			if (ath_check_chanflags(chan, CHANNEL_A_HT20, sc))
-				return CHANNEL_A_HT20;
-			else
-				return CHANNEL_A;
-		} else {
-			if (ath_check_chanflags(chan, CHANNEL_G_HT20, sc))
-				return CHANNEL_G_HT20;
-			else if (ath_check_chanflags(chan, CHANNEL_G, sc))
-				return CHANNEL_G;
-			else
-				return CHANNEL_B;
-		}
-	} else {
-		if (chan->band == IEEE80211_BAND_2GHZ) {
-			if (!hw->conf.ht_conf.ht_supported) {
-				if (ath_check_chanflags(chan, CHANNEL_G, sc))
-					return CHANNEL_G;
-				else
-					return CHANNEL_B;
-			}
-			if ((ht_info->ext_chan_offset ==
-			     IEEE80211_HT_IE_CHA_SEC_NONE) &&
-			    (ht_info->tx_chan_width == HAL_HT_MACMODE_20))
-				return CHANNEL_G_HT20;
-			if ((ht_info->ext_chan_offset ==
-			     IEEE80211_HT_IE_CHA_SEC_ABOVE) &&
-			    (ht_info->tx_chan_width == HAL_HT_MACMODE_2040))
-				return CHANNEL_G_HT40PLUS;
-			if ((ht_info->ext_chan_offset ==
-			     IEEE80211_HT_IE_CHA_SEC_BELOW) &&
-			    (ht_info->tx_chan_width == HAL_HT_MACMODE_2040))
-				return CHANNEL_G_HT40MINUS;
-			return CHANNEL_B;
-		} else {
-			if (!hw->conf.ht_conf.ht_supported)
-				return CHANNEL_A;
-			if ((ht_info->ext_chan_offset ==
-			     IEEE80211_HT_IE_CHA_SEC_NONE) &&
-			    (ht_info->tx_chan_width == HAL_HT_MACMODE_20))
-				return CHANNEL_A_HT20;
-			if ((ht_info->ext_chan_offset ==
-			     IEEE80211_HT_IE_CHA_SEC_ABOVE) &&
-			    (ht_info->tx_chan_width == HAL_HT_MACMODE_2040))
-				return CHANNEL_A_HT40PLUS;
-			if ((ht_info->ext_chan_offset ==
-			     IEEE80211_HT_IE_CHA_SEC_BELOW) &&
-			    (ht_info->tx_chan_width == HAL_HT_MACMODE_2040))
-				return CHANNEL_A_HT40MINUS;
-			return CHANNEL_A;
-		}
-	}
-}
-
 void ath_get_beaconconfig(struct ath_softc *sc,
 			  int if_id,
 			  struct ath_beacon_config *conf)
-- 
1.5.6.rc2.15.g457bb.dirty

