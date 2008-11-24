Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16836 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbYKXGle (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 01:41:34 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 23 Nov 2008 22:41:34 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18730.19435.540307.172114@gargle.gargle.HOWL> (sfid-20081124_074137_512264_F75084AB)
Date: Mon, 24 Nov 2008 12:08:35 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/2] ath9k: Use proper TX channel width for setting channels
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX channel width of the BSS can be obtained only after association.
In all cases, default to HT20 if HT is enabled, and set
chan width to HT40 only if the BSS supports it.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    7 +--
 drivers/net/wireless/ath9k/hw.c   |    3 +-
 drivers/net/wireless/ath9k/main.c |  117 ++++++++++++++++++-------------------
 drivers/net/wireless/ath9k/xmit.c |    2 +-
 4 files changed, 60 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 21ee0c2..f0c5437 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -633,11 +633,6 @@ enum PROT_MODE {
 	PROT_M_CTSONLY
 };
 
-struct ath_ht_info {
-	enum ath9k_ht_macmode tx_chan_width;
-	u8 ext_chan_offset;
-};
-
 #define SC_OP_INVALID		BIT(0)
 #define SC_OP_BEACONS		BIT(1)
 #define SC_OP_RXAGGR		BIT(2)
@@ -691,8 +686,8 @@ struct ath_softc {
 	u8 sc_rxotherant;		/* rx's on non-default antenna */
 
 	struct ath9k_node_stats sc_halstats; /* station-mode rssi stats */
-	struct ath_ht_info sc_ht_info;
 	enum ath9k_ht_extprotspacing sc_ht_extprotspacing;
+	enum ath9k_ht_macmode tx_chan_width;
 
 #ifdef CONFIG_SLOW_ANT_DIV
 	struct ath_antdiv sc_antdiv;
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 6593a13..ae7b1d6 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -2233,8 +2233,7 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 	    ((chan->channelFlags & CHANNEL_ALL) ==
 	     (ah->ah_curchan->channelFlags & CHANNEL_ALL)) &&
 	    (!AR_SREV_9280(ah) || (!IS_CHAN_A_5MHZ_SPACED(chan) &&
-				   !IS_CHAN_A_5MHZ_SPACED(ah->
-							  ah_curchan)))) {
+				   !IS_CHAN_A_5MHZ_SPACED(ah->ah_curchan)))) {
 
 		if (ath9k_hw_channel_change(ah, chan, macmode)) {
 			ath9k_hw_loadnf(ah, ah->ah_curchan);
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 8eccc20..6e103d5 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -260,15 +260,6 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 	if (sc->sc_flags & SC_OP_INVALID)
 		return -EIO;
 
-	DPRINTF(sc, ATH_DBG_CONFIG,
-		"%s: %u (%u MHz) -> %u (%u MHz), cflags:%x\n",
-		__func__,
-		ath9k_hw_mhz2ieee(ah, sc->sc_ah->ah_curchan->channel,
-				  sc->sc_ah->ah_curchan->channelFlags),
-		sc->sc_ah->ah_curchan->channel,
-		ath9k_hw_mhz2ieee(ah, hchan->channel, hchan->channelFlags),
-		hchan->channel, hchan->channelFlags);
-
 	if (hchan->channel != sc->sc_ah->ah_curchan->channel ||
 	    hchan->channelFlags != sc->sc_ah->ah_curchan->channelFlags ||
 	    (sc->sc_flags & SC_OP_CHAINMASK_UPDATE) ||
@@ -294,8 +285,14 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 		if (!stopped || (sc->sc_flags & SC_OP_FULL_RESET))
 			fastcc = false;
 
+		DPRINTF(sc, ATH_DBG_CONFIG,
+			"%s: (%u MHz) -> (%u MHz), cflags:%x, chanwidth: %d\n",
+			__func__,
+			sc->sc_ah->ah_curchan->channel,
+			hchan->channel, hchan->channelFlags, sc->tx_chan_width);
+
 		spin_lock_bh(&sc->sc_resetlock);
-		if (!ath9k_hw_reset(ah, hchan, sc->sc_ht_info.tx_chan_width,
+		if (!ath9k_hw_reset(ah, hchan, sc->tx_chan_width,
 				    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 				    sc->sc_ht_extprotspacing, fastcc, &status)) {
 			DPRINTF(sc, ATH_DBG_FATAL,
@@ -626,11 +623,13 @@ static int ath_get_channel(struct ath_softc *sc,
 }
 
 static u32 ath_get_extchanmode(struct ath_softc *sc,
-				     struct ieee80211_channel *chan)
+			       struct ieee80211_channel *chan,
+			       struct ieee80211_bss_conf *bss_conf)
 {
 	u32 chanmode = 0;
-	u8 ext_chan_offset = sc->sc_ht_info.ext_chan_offset;
-	enum ath9k_ht_macmode tx_chan_width = sc->sc_ht_info.tx_chan_width;
+	u8 ext_chan_offset = bss_conf->ht.secondary_channel_offset;
+	enum ath9k_ht_macmode tx_chan_width = (bss_conf->ht.width_40_ok) ?
+		ATH9K_HT_MACMODE_2040 : ATH9K_HT_MACMODE_20;
 
 	switch (chan->band) {
 	case IEEE80211_BAND_2GHZ:
@@ -828,17 +827,17 @@ static void setup_ht_cap(struct ieee80211_sta_ht_cap *ht_info)
 static void ath9k_ht_conf(struct ath_softc *sc,
 			  struct ieee80211_bss_conf *bss_conf)
 {
-	struct ath_ht_info *ht_info = &sc->sc_ht_info;
-
 	if (sc->hw->conf.ht.enabled) {
-		ht_info->ext_chan_offset = bss_conf->ht.secondary_channel_offset;
-
 		if (bss_conf->ht.width_40_ok)
-			ht_info->tx_chan_width = ATH9K_HT_MACMODE_2040;
+			sc->tx_chan_width = ATH9K_HT_MACMODE_2040;
 		else
-			ht_info->tx_chan_width = ATH9K_HT_MACMODE_20;
+			sc->tx_chan_width = ATH9K_HT_MACMODE_20;
 
-		ath9k_hw_set11nmac2040(sc->sc_ah, ht_info->tx_chan_width);
+		ath9k_hw_set11nmac2040(sc->sc_ah, sc->tx_chan_width);
+
+		DPRINTF(sc, ATH_DBG_CONFIG,
+			"%s: BSS Changed HT, chanwidth: %d\n",
+			__func__, sc->tx_chan_width);
 	}
 }
 
@@ -893,26 +892,30 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 			return;
 		}
 
-		if (hw->conf.ht.enabled)
+		if (hw->conf.ht.enabled) {
 			sc->sc_ah->ah_channels[pos].chanmode =
-				ath_get_extchanmode(sc, curchan);
-		else
+				ath_get_extchanmode(sc, curchan, bss_conf);
+
+			if (bss_conf->ht.width_40_ok)
+				sc->tx_chan_width = ATH9K_HT_MACMODE_2040;
+			else
+				sc->tx_chan_width = ATH9K_HT_MACMODE_20;
+		} else {
 			sc->sc_ah->ah_channels[pos].chanmode =
 				(curchan->band == IEEE80211_BAND_2GHZ) ?
 				CHANNEL_G : CHANNEL_A;
+		}
 
 		/* set h/w channel */
 		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0)
 			DPRINTF(sc, ATH_DBG_FATAL,
-				"%s: Unable to set channel\n",
-				__func__);
+				"%s: Unable to set channel\n", __func__);
 		/* Start ANI */
 		mod_timer(&sc->sc_ani.timer,
 			jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
 
 	} else {
-		DPRINTF(sc, ATH_DBG_CONFIG,
-		"%s: Bss Info DISSOC\n", __func__);
+		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Bss Info DISSOC\n", __func__);
 		sc->sc_curaid = 0;
 	}
 }
@@ -1045,7 +1048,7 @@ static void ath_radio_enable(struct ath_softc *sc)
 
 	spin_lock_bh(&sc->sc_resetlock);
 	if (!ath9k_hw_reset(ah, ah->ah_curchan,
-			    sc->sc_ht_info.tx_chan_width,
+			    sc->tx_chan_width,
 			    sc->sc_tx_chainmask,
 			    sc->sc_rx_chainmask,
 			    sc->sc_ht_extprotspacing,
@@ -1103,7 +1106,7 @@ static void ath_radio_disable(struct ath_softc *sc)
 
 	spin_lock_bh(&sc->sc_resetlock);
 	if (!ath9k_hw_reset(ah, ah->ah_curchan,
-			    sc->sc_ht_info.tx_chan_width,
+			    sc->tx_chan_width,
 			    sc->sc_tx_chainmask,
 			    sc->sc_rx_chainmask,
 			    sc->sc_ht_extprotspacing,
@@ -1637,7 +1640,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 
 	spin_lock_bh(&sc->sc_resetlock);
 	if (!ath9k_hw_reset(ah, sc->sc_ah->ah_curchan,
-			    sc->sc_ht_info.tx_chan_width,
+			    sc->tx_chan_width,
 			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 			    sc->sc_ht_extprotspacing, false, &status)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
@@ -1865,8 +1868,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Starting driver with "
 		"initial channel: %d MHz\n", __func__, curchan->center_freq);
 
-	memset(&sc->sc_ht_info, 0, sizeof(struct ath_ht_info));
-
 	/* setup initial channel */
 
 	pos = ath_get_channel(sc, curchan);
@@ -1876,6 +1877,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 		goto error;
 	}
 
+	sc->tx_chan_width = ATH9K_HT_MACMODE_20;
 	sc->sc_ah->ah_channels[pos].chanmode =
 		(curchan->band == IEEE80211_BAND_2GHZ) ? CHANNEL_G : CHANNEL_A;
 	init_channel = &sc->sc_ah->ah_channels[pos];
@@ -1892,7 +1894,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 */
 	spin_lock_bh(&sc->sc_resetlock);
 	if (!ath9k_hw_reset(sc->sc_ah, init_channel,
-			    sc->sc_ht_info.tx_chan_width,
+			    sc->tx_chan_width,
 			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 			    sc->sc_ht_extprotspacing, false, &status)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
@@ -2150,39 +2152,37 @@ static void ath9k_remove_interface(struct ieee80211_hw *hw,
 static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ath_softc *sc = hw->priv;
-	struct ieee80211_channel *curchan = hw->conf.channel;
 	struct ieee80211_conf *conf = &hw->conf;
-	int pos;
-
-	DPRINTF(sc, ATH_DBG_CONFIG, "%s: Set channel: %d MHz\n",
-		__func__,
-		curchan->center_freq);
 
-	/* Update chainmask */
-	ath_update_chainmask(sc, conf->ht.enabled);
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		struct ieee80211_channel *curchan = hw->conf.channel;
+		int pos;
 
-	pos = ath_get_channel(sc, curchan);
-	if (pos == -1) {
-		DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid channel\n", __func__);
-		return -EINVAL;
-	}
+		DPRINTF(sc, ATH_DBG_CONFIG, "%s: Set channel: %d MHz\n",
+			__func__, curchan->center_freq);
 
-	sc->sc_ah->ah_channels[pos].chanmode =
-		(curchan->band == IEEE80211_BAND_2GHZ) ?
-		CHANNEL_G : CHANNEL_A;
+		pos = ath_get_channel(sc, curchan);
+		if (pos == -1) {
+			DPRINTF(sc, ATH_DBG_FATAL, "%s: Invalid channel\n", __func__);
+			return -EINVAL;
+		}
 
-	if (sc->sc_curaid && hw->conf.ht.enabled)
+		sc->tx_chan_width = ATH9K_HT_MACMODE_20;
 		sc->sc_ah->ah_channels[pos].chanmode =
-			ath_get_extchanmode(sc, curchan);
+			(curchan->band == IEEE80211_BAND_2GHZ) ?
+			CHANNEL_G : CHANNEL_A;
+
+		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0)
+			DPRINTF(sc, ATH_DBG_FATAL,
+				"%s: Unable to set channel\n", __func__);
+	}
+
+	if (changed & IEEE80211_CONF_CHANGE_HT)
+		ath_update_chainmask(sc, conf->ht.enabled);
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER)
 		sc->sc_config.txpowlimit = 2 * conf->power_level;
 
-	/* set h/w channel */
-	if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0)
-		DPRINTF(sc, ATH_DBG_FATAL, "%s: Unable to set channel\n",
-			__func__);
-
 	return 0;
 }
 
@@ -2423,11 +2423,8 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 			sc->sc_flags &= ~SC_OP_PROTECT_ENABLE;
 	}
 
-	if (changed & BSS_CHANGED_HT) {
-		DPRINTF(sc, ATH_DBG_CONFIG, "%s: BSS Changed HT\n",
-			__func__);
+	if (changed & BSS_CHANGED_HT)
 		ath9k_ht_conf(sc, bss_conf);
-	}
 
 	if (changed & BSS_CHANGED_ASSOC) {
 		DPRINTF(sc, ATH_DBG_CONFIG, "%s: BSS Changed ASSOC %d\n",
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 3de60c5..413fbdd 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1148,7 +1148,7 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 		spin_lock_bh(&sc->sc_resetlock);
 		if (!ath9k_hw_reset(ah,
 				    sc->sc_ah->ah_curchan,
-				    sc->sc_ht_info.tx_chan_width,
+				    sc->tx_chan_width,
 				    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 				    sc->sc_ht_extprotspacing, true, &status)) {
 
-- 
1.6.0.3

