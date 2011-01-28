Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:49717 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab1A1GGi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 01:06:38 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 22:06:19 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k: use common API to avoid code duplication
Date: Fri, 28 Jan 2011 11:35:43 +0530
Message-ID: <1296194743-3181-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |    2 -
 drivers/net/wireless/ath/ath9k/main.c    |   72 +----------------------------
 drivers/net/wireless/ath/ath9k/virtual.c |    6 +-
 3 files changed, 6 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 6636f3c..09bea7a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -699,8 +699,6 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc, u16 subsysid,
 		    const struct ath_bus_ops *bus_ops);
 void ath9k_deinit_device(struct ath_softc *sc);
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
-void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
-			   struct ath9k_channel *ichan);
 int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 		    struct ath9k_channel *hchan);
 
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d8dd1ee..253426f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -73,7 +73,7 @@ static struct ath9k_channel *ath_get_curchannel(struct ath_softc *sc,
 
 	chan_idx = curchan->hw_value;
 	channel = &sc->sc_ah->channels[chan_idx];
-	ath9k_update_ichannel(sc, hw, channel);
+	ath9k_cmn_update_ichannel(channel, curchan, hw->conf.channel_type);
 	return channel;
 }
 
@@ -803,48 +803,6 @@ chip_reset:
 #undef SCHED_INTR
 }
 
-static u32 ath_get_extchanmode(struct ath_softc *sc,
-			       struct ieee80211_channel *chan,
-			       enum nl80211_channel_type channel_type)
-{
-	u32 chanmode = 0;
-
-	switch (chan->band) {
-	case IEEE80211_BAND_2GHZ:
-		switch(channel_type) {
-		case NL80211_CHAN_NO_HT:
-		case NL80211_CHAN_HT20:
-			chanmode = CHANNEL_G_HT20;
-			break;
-		case NL80211_CHAN_HT40PLUS:
-			chanmode = CHANNEL_G_HT40PLUS;
-			break;
-		case NL80211_CHAN_HT40MINUS:
-			chanmode = CHANNEL_G_HT40MINUS;
-			break;
-		}
-		break;
-	case IEEE80211_BAND_5GHZ:
-		switch(channel_type) {
-		case NL80211_CHAN_NO_HT:
-		case NL80211_CHAN_HT20:
-			chanmode = CHANNEL_A_HT20;
-			break;
-		case NL80211_CHAN_HT40PLUS:
-			chanmode = CHANNEL_A_HT40PLUS;
-			break;
-		case NL80211_CHAN_HT40MINUS:
-			chanmode = CHANNEL_A_HT40MINUS;
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
 static void ath9k_bss_assoc_info(struct ath_softc *sc,
 				 struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
@@ -1041,30 +999,6 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	return r;
 }
 
-/* XXX: Remove me once we don't depend on ath9k_channel for all
- * this redundant data */
-void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
-			   struct ath9k_channel *ichan)
-{
-	struct ieee80211_channel *chan = hw->conf.channel;
-	struct ieee80211_conf *conf = &hw->conf;
-
-	ichan->channel = chan->center_freq;
-	ichan->chan = chan;
-
-	if (chan->band == IEEE80211_BAND_2GHZ) {
-		ichan->chanmode = CHANNEL_G;
-		ichan->channelFlags = CHANNEL_2GHZ | CHANNEL_OFDM | CHANNEL_G;
-	} else {
-		ichan->chanmode = CHANNEL_A;
-		ichan->channelFlags = CHANNEL_5GHZ | CHANNEL_OFDM;
-	}
-
-	if (conf_is_ht(conf))
-		ichan->chanmode = ath_get_extchanmode(sc, chan,
-					    conf->channel_type);
-}
-
 /**********************/
 /* mac80211 callbacks */
 /**********************/
@@ -1822,8 +1756,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		ath_dbg(common, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
 			curchan->center_freq);
 
-		/* XXX: remove me eventualy */
-		ath9k_update_ichannel(sc, hw, &sc->sc_ah->channels[pos]);
+		ath9k_cmn_update_ichannel(&sc->sc_ah->channels[pos],
+					  curchan, conf->channel_type);
 
 		/* update survey stats for the old channel before switching */
 		spin_lock_irqsave(&common->cc_lock, flags);
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index d205c66..15d5e62 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -233,9 +233,9 @@ void ath9k_wiphy_chan_work(struct work_struct *work)
 
 	/* Change channels */
 	mutex_lock(&sc->mutex);
-	/* XXX: remove me eventually */
-	ath9k_update_ichannel(sc, aphy->hw,
-			      &sc->sc_ah->channels[sc->chan_idx]);
+	ath9k_cmn_update_ichannel(&sc->sc_ah->channels[sc->chan_idx],
+				  sc->hw->conf.channel,
+				  sc->hw->conf.channel_type);
 
 	/* sync hw configuration for hw code */
 	common->hw = aphy->hw;
-- 
1.7.3.5

