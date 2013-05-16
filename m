Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cora.hrz.tu-chemnitz.de ([134.109.228.40]:50059 "EHLO
	cora.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab3EPLCB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 07:02:01 -0400
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv3 12/18] ath9k: use chandef instead of channel_type
Date: Thu, 16 May 2013 13:00:39 +0200
Message-Id: <1368702045-27598-13-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130516_130231_179641_8C7CED97)
In-Reply-To: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1368702045-27598-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To enable support for 5/10 MHz, some internal functions must be
converted from using the (old) channel_type to chandef. This is a good
chance to change all remaining occurences.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 drivers/net/wireless/ath/ath9k/common.c       |   67 +++++++++++++++----------
 drivers/net/wireless/ath/ath9k/common.h       |    3 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    5 +-
 drivers/net/wireless/ath/ath9k/init.c         |    4 +-
 drivers/net/wireless/ath/ath9k/main.c         |    8 ++-
 drivers/net/wireless/ath/ath9k/rc.c           |    4 +-
 6 files changed, 51 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 344fdde..d3063c2 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -49,37 +49,40 @@ int ath9k_cmn_get_hw_crypto_keytype(struct sk_buff *skb)
 }
 EXPORT_SYMBOL(ath9k_cmn_get_hw_crypto_keytype);
 
-static u32 ath9k_get_extchanmode(struct ieee80211_channel *chan,
-				 enum nl80211_channel_type channel_type)
+static u32 ath9k_get_extchanmode(struct cfg80211_chan_def *chandef)
 {
 	u32 chanmode = 0;
 
-	switch (chan->band) {
+	switch (chandef->chan->band) {
 	case IEEE80211_BAND_2GHZ:
-		switch (channel_type) {
-		case NL80211_CHAN_NO_HT:
-		case NL80211_CHAN_HT20:
+		switch (chandef->width) {
+		case NL80211_CHAN_WIDTH_20_NOHT:
+		case NL80211_CHAN_WIDTH_20:
 			chanmode = CHANNEL_G_HT20;
 			break;
-		case NL80211_CHAN_HT40PLUS:
-			chanmode = CHANNEL_G_HT40PLUS;
+		case NL80211_CHAN_WIDTH_40:
+			if (chandef->center_freq1 > chandef->chan->center_freq)
+				chanmode = CHANNEL_G_HT40PLUS;
+			else
+				chanmode = CHANNEL_G_HT40MINUS;
 			break;
-		case NL80211_CHAN_HT40MINUS:
-			chanmode = CHANNEL_G_HT40MINUS;
+		default:
 			break;
 		}
 		break;
 	case IEEE80211_BAND_5GHZ:
-		switch (channel_type) {
-		case NL80211_CHAN_NO_HT:
-		case NL80211_CHAN_HT20:
+		switch (chandef->width) {
+		case NL80211_CHAN_WIDTH_20_NOHT:
+		case NL80211_CHAN_WIDTH_20:
 			chanmode = CHANNEL_A_HT20;
 			break;
-		case NL80211_CHAN_HT40PLUS:
-			chanmode = CHANNEL_A_HT40PLUS;
+		case NL80211_CHAN_WIDTH_40:
+			if (chandef->center_freq1 > chandef->chan->center_freq)
+				chanmode = CHANNEL_A_HT40PLUS;
+			else
+				chanmode = CHANNEL_A_HT40MINUS;
 			break;
-		case NL80211_CHAN_HT40MINUS:
-			chanmode = CHANNEL_A_HT40MINUS;
+		default:
 			break;
 		}
 		break;
@@ -94,13 +97,12 @@ static u32 ath9k_get_extchanmode(struct ieee80211_channel *chan,
  * Update internal channel flags.
  */
 void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
-			       struct ieee80211_channel *chan,
-			       enum nl80211_channel_type channel_type)
+			       struct cfg80211_chan_def *chandef)
 {
-	ichan->channel = chan->center_freq;
-	ichan->chan = chan;
+	ichan->channel = chandef->chan->center_freq;
+	ichan->chan = chandef->chan;
 
-	if (chan->band == IEEE80211_BAND_2GHZ) {
+	if (chandef->chan->band == IEEE80211_BAND_2GHZ) {
 		ichan->chanmode = CHANNEL_G;
 		ichan->channelFlags = CHANNEL_2GHZ | CHANNEL_OFDM;
 	} else {
@@ -108,8 +110,22 @@ void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
 		ichan->channelFlags = CHANNEL_5GHZ | CHANNEL_OFDM;
 	}
 
-	if (channel_type != NL80211_CHAN_NO_HT)
-		ichan->chanmode = ath9k_get_extchanmode(chan, channel_type);
+	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_5:
+		ichan->channelFlags |= CHANNEL_QUARTER;
+		break;
+	case NL80211_CHAN_WIDTH_10:
+		ichan->channelFlags |= CHANNEL_HALF;
+		break;
+	case NL80211_CHAN_WIDTH_20_NOHT:
+		break;
+	case NL80211_CHAN_WIDTH_20:
+	case NL80211_CHAN_WIDTH_40:
+		ichan->chanmode = ath9k_get_extchanmode(chandef);
+		break;
+	default:
+		WARN_ON(1);
+	}
 }
 EXPORT_SYMBOL(ath9k_cmn_update_ichannel);
 
@@ -125,8 +141,7 @@ struct ath9k_channel *ath9k_cmn_get_curchannel(struct ieee80211_hw *hw,
 
 	chan_idx = curchan->hw_value;
 	channel = &ah->channels[chan_idx];
-	ath9k_cmn_update_ichannel(channel, curchan,
-				  cfg80211_get_chandef_type(&hw->conf.chandef));
+	ath9k_cmn_update_ichannel(channel, &hw->conf.chandef);
 
 	return channel;
 }
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index 207d069..e039bcb 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -44,8 +44,7 @@
 
 int ath9k_cmn_get_hw_crypto_keytype(struct sk_buff *skb);
 void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
-			       struct ieee80211_channel *chan,
-			       enum nl80211_channel_type channel_type);
+			       struct cfg80211_chan_def *chandef);
 struct ath9k_channel *ath9k_cmn_get_curchannel(struct ieee80211_hw *hw,
 					       struct ath_hw *ah);
 int ath9k_cmn_count_streams(unsigned int chainmask, int max);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 0743a47..8c25c7a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1194,16 +1194,13 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 
 	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) || chip_reset) {
 		struct ieee80211_channel *curchan = hw->conf.chandef.chan;
-		enum nl80211_channel_type channel_type =
-			cfg80211_get_chandef_type(&hw->conf.chandef);
 		int pos = curchan->hw_value;
 
 		ath_dbg(common, CONFIG, "Set channel: %d MHz\n",
 			curchan->center_freq);
 
 		ath9k_cmn_update_ichannel(&priv->ah->channels[pos],
-					  hw->conf.chandef.chan,
-					  channel_type);
+					  &hw->conf.chandef);
 
 		if (ath9k_htc_set_channel(priv, hw, &priv->ah->channels[pos]) < 0) {
 			ath_err(common, "Unable to set channel\n");
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 0237b28..5921194 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -684,13 +684,15 @@ static void ath9k_init_band_txpower(struct ath_softc *sc, int band)
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
 	struct ath_hw *ah = sc->sc_ah;
+	struct cfg80211_chan_def chandef;
 	int i;
 
 	sband = &sc->sbands[band];
 	for (i = 0; i < sband->n_channels; i++) {
 		chan = &sband->channels[i];
 		ah->curchan = &ah->channels[chan->hw_value];
-		ath9k_cmn_update_ichannel(ah->curchan, chan, NL80211_CHAN_HT20);
+		cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_HT20);
+		ath9k_cmn_update_ichannel(ah->curchan, &chandef);
 		ath9k_hw_set_txpowerlimit(ah, MAX_RATE_POWER, true);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a18414b..d21875c 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1194,8 +1194,6 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) || reset_channel) {
 		struct ieee80211_channel *curchan = hw->conf.chandef.chan;
-		enum nl80211_channel_type channel_type =
-			cfg80211_get_chandef_type(&conf->chandef);
 		int pos = curchan->hw_value;
 		int old_pos = -1;
 		unsigned long flags;
@@ -1203,8 +1201,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		if (ah->curchan)
 			old_pos = ah->curchan - &ah->channels[0];
 
-		ath_dbg(common, CONFIG, "Set channel: %d MHz type: %d\n",
-			curchan->center_freq, channel_type);
+		ath_dbg(common, CONFIG, "Set channel: %d MHz width: %d\n",
+			curchan->center_freq, hw->conf.chandef.width);
 
 		/* update survey stats for the old channel before switching */
 		spin_lock_irqsave(&common->cc_lock, flags);
@@ -1219,7 +1217,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			ath9k_hw_getnf(ah, ah->curchan);
 
 		ath9k_cmn_update_ichannel(&sc->sc_ah->channels[pos],
-					  curchan, channel_type);
+					  &conf->chandef);
 
 		/*
 		 * If the operating channel changes, change the survey in-use flags
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index aa4d368..ed57d57 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -1327,8 +1327,8 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 		ath_rc_init(sc, priv_sta);
 
 		ath_dbg(ath9k_hw_common(sc->sc_ah), CONFIG,
-			"Operating HT Bandwidth changed to: %d\n",
-			cfg80211_get_chandef_type(&sc->hw->conf.chandef));
+			"Operating Bandwidth changed to: %d\n",
+			&sc->hw->conf.chandef->width);
 	}
 }
 
-- 
1.7.10.4

