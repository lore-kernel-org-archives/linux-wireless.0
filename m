Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:58172 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab0JTAJw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 20:09:52 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/3] ath9k: initialize per-channel tx power limits instead of hardcoding them
Date: Wed, 20 Oct 2010 02:09:46 +0200
Message-Id: <1287533386-68715-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1287533386-68715-2-git-send-email-nbd@openwrt.org>
References: <1287533386-68715-1-git-send-email-nbd@openwrt.org>
 <1287533386-68715-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/common.c       |   15 ++++-------
 drivers/net/wireless/ath/ath9k/common.h       |    5 ++-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    4 ++-
 drivers/net/wireless/ath/ath9k/init.c         |   33 +++++++++++++++++++++++++
 4 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index f43a2d9..48b07c3 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -107,12 +107,10 @@ static u32 ath9k_get_extchanmode(struct ieee80211_channel *chan,
 /*
  * Update internal channel flags.
  */
-void ath9k_cmn_update_ichannel(struct ieee80211_hw *hw,
-			       struct ath9k_channel *ichan)
+void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
+			       struct ieee80211_channel *chan,
+			       enum nl80211_channel_type channel_type)
 {
-	struct ieee80211_channel *chan = hw->conf.channel;
-	struct ieee80211_conf *conf = &hw->conf;
-
 	ichan->channel = chan->center_freq;
 	ichan->chan = chan;
 
@@ -124,9 +122,8 @@ void ath9k_cmn_update_ichannel(struct ieee80211_hw *hw,
 		ichan->channelFlags = CHANNEL_5GHZ | CHANNEL_OFDM;
 	}
 
-	if (conf_is_ht(conf))
-		ichan->chanmode = ath9k_get_extchanmode(chan,
-							conf->channel_type);
+	if (channel_type != NL80211_CHAN_NO_HT)
+		ichan->chanmode = ath9k_get_extchanmode(chan, channel_type);
 }
 EXPORT_SYMBOL(ath9k_cmn_update_ichannel);
 
@@ -142,7 +139,7 @@ struct ath9k_channel *ath9k_cmn_get_curchannel(struct ieee80211_hw *hw,
 
 	chan_idx = curchan->hw_value;
 	channel = &ah->channels[chan_idx];
-	ath9k_cmn_update_ichannel(hw, channel);
+	ath9k_cmn_update_ichannel(channel, curchan, hw->conf.channel_type);
 
 	return channel;
 }
diff --git a/drivers/net/wireless/ath/ath9k/common.h b/drivers/net/wireless/ath/ath9k/common.h
index fea3b33..c76c75a 100644
--- a/drivers/net/wireless/ath/ath9k/common.h
+++ b/drivers/net/wireless/ath/ath9k/common.h
@@ -62,8 +62,9 @@ enum ath_stomp_type {
 
 int ath9k_cmn_padpos(__le16 frame_control);
 int ath9k_cmn_get_hw_crypto_keytype(struct sk_buff *skb);
-void ath9k_cmn_update_ichannel(struct ieee80211_hw *hw,
-			       struct ath9k_channel *ichan);
+void ath9k_cmn_update_ichannel(struct ath9k_channel *ichan,
+			       struct ieee80211_channel *chan,
+			       enum nl80211_channel_type channel_type);
 struct ath9k_channel *ath9k_cmn_get_curchannel(struct ieee80211_hw *hw,
 					       struct ath_hw *ah);
 int ath9k_cmn_count_streams(unsigned int chainmask, int max);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 1e5323e..1773bdb 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1397,7 +1397,9 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 		ath_print(common, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
 			  curchan->center_freq);
 
-		ath9k_cmn_update_ichannel(hw, &priv->ah->channels[pos]);
+		ath9k_cmn_update_ichannel(&priv->ah->channels[pos],
+					  hw->conf.channel,
+					  hw->conf.channel_type);
 
 		if (ath9k_htc_set_channel(priv, hw, &priv->ah->channels[pos]) < 0) {
 			ath_print(common, ATH_DBG_FATAL,
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 12f4fd7..1b72720 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -642,6 +642,37 @@ err_hw:
 	return ret;
 }
 
+static void ath9k_init_band_txpower(struct ath_softc *sc, int band)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *chan;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_regulatory *reg = ath9k_hw_regulatory(ah);
+	int i;
+
+	sband = &sc->sbands[band];
+	for (i = 0; i < sband->n_channels; i++) {
+		chan = &sband->channels[i];
+		ah->curchan = &ah->channels[chan->hw_value];
+		ath9k_cmn_update_ichannel(ah->curchan, chan, NL80211_CHAN_HT20);
+		ath9k_hw_set_txpowerlimit(ah, MAX_RATE_POWER, true);
+		chan->max_power = reg->max_power_level / 2;
+	}
+}
+
+static void ath9k_init_txpower_limits(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath9k_channel *curchan = ah->curchan;
+
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
+		ath9k_init_band_txpower(sc, IEEE80211_BAND_2GHZ);
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ)
+		ath9k_init_band_txpower(sc, IEEE80211_BAND_5GHZ);
+
+	ah->curchan = curchan;
+}
+
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -736,6 +767,8 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 	if (error != 0)
 		goto error_rx;
 
+	ath9k_init_txpower_limits(sc);
+
 	/* Register with mac80211 */
 	error = ieee80211_register_hw(hw);
 	if (error)
-- 
1.7.2.2

