Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32079 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbYLTFzl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 00:55:41 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 21:55:41 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 06/16] ath9k: start making use of channel->priv
Date: Fri, 19 Dec 2008 21:55:12 -0800
Message-ID: <1229752522-1917-7-git-send-email-lrodriguez@atheros.com> (sfid-20081220_065606_569232_C00DAFB8)
In-Reply-To: <1229752522-1917-6-git-send-email-lrodriguez@atheros.com>
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-3-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-4-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-5-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-6-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We start consolidating our internal channel by linking
it to the standard ieee80211_channel in the private area.
We can now slowly start removing redundant data.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    2 +-
 drivers/net/wireless/ath9k/hw.c    |   50 +++--------------
 drivers/net/wireless/ath9k/main.c  |  106 ++++++++++++++++--------------------
 drivers/net/wireless/ath9k/xmit.c  |    2 +-
 4 files changed, 59 insertions(+), 101 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index d278135..cd11eaf 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -843,7 +843,7 @@ void ath9k_hw_rfdetach(struct ath_hal *ah);
 
 /* HW Reset */
 
-bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
+bool ath9k_hw_reset(struct ath_hal *ah, struct ieee80211_channel *channel,
 		    enum ath9k_ht_macmode macmode,
 		    u8 txchainmask, u8 rxchainmask,
 		    enum ath9k_ht_extprotspacing extprotspacing,
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index d2b0ecf..d9f810a 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -199,46 +199,6 @@ u16 ath9k_hw_computetxtime(struct ath_hal *ah,
 	return txTime;
 }
 
-u32 ath9k_hw_mhz2ieee(struct ath_hal *ah, u32 freq, u32 flags)
-{
-	if (flags & CHANNEL_2GHZ) {
-		if (freq == 2484)
-			return 14;
-		if (freq < 2484)
-			return (freq - 2407) / 5;
-		else
-			return 15 + ((freq - 2512) / 20);
-	} else if (flags & CHANNEL_5GHZ) {
-		if (ath9k_regd_is_public_safety_sku(ah) &&
-		    IS_CHAN_IN_PUBLIC_SAFETY_BAND(freq)) {
-			return ((freq * 10) +
-				(((freq % 5) == 2) ? 5 : 0) - 49400) / 5;
-		} else if ((flags & CHANNEL_A) && (freq <= 5000)) {
-			return (freq - 4000) / 5;
-		} else {
-			return (freq - 5000) / 5;
-		}
-	} else {
-		if (freq == 2484)
-			return 14;
-		if (freq < 2484)
-			return (freq - 2407) / 5;
-		if (freq < 5000) {
-			if (ath9k_regd_is_public_safety_sku(ah)
-			    && IS_CHAN_IN_PUBLIC_SAFETY_BAND(freq)) {
-				return ((freq * 10) +
-					(((freq % 5) ==
-					  2) ? 5 : 0) - 49400) / 5;
-			} else if (freq > 4900) {
-				return (freq - 4000) / 5;
-			} else {
-				return 15 + ((freq - 2512) / 20);
-			}
-		}
-		return (freq - 5000) / 5;
-	}
-}
-
 void ath9k_hw_get_channel_centers(struct ath_hal *ah,
 				  struct ath9k_channel *chan,
 				  struct chan_centers *centers)
@@ -2223,7 +2183,7 @@ static void ath9k_hw_spur_mitigate(struct ath_hal *ah, struct ath9k_channel *cha
 	REG_WRITE(ah, AR_PHY_MASK2_P_61_45, tmp_mask);
 }
 
-bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
+bool ath9k_hw_reset(struct ath_hal *ah, struct ieee80211_channel *channel,
 		    enum ath9k_ht_macmode macmode,
 		    u8 txchainmask, u8 rxchainmask,
 		    enum ath9k_ht_extprotspacing extprotspacing,
@@ -2232,11 +2192,19 @@ bool ath9k_hw_reset(struct ath_hal *ah, struct ath9k_channel *chan,
 	u32 saveLedState;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 	struct ath9k_channel *curchan = ah->ah_curchan;
+	struct ath9k_channel *chan;
 	u32 saveDefAntenna;
 	u32 macStaId1;
 	int ecode;
 	int i, rx_chainmask;
 
+	if (!channel->priv) {
+		ecode = -EINVAL;
+		goto bad;
+	}
+
+	chan = (struct ath9k_channel *) channel->priv;
+
 	ahp->ah_extprotspacing = extprotspacing;
 	ahp->ah_txchainmask = txchainmask;
 	ahp->ah_rxchainmask = rxchainmask;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index dddcb4f..67c7b48 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -215,6 +215,7 @@ static int ath_setup_channels(struct ath_softc *sc)
 			chan_2ghz[a].band = IEEE80211_BAND_2GHZ;
 			chan_2ghz[a].center_freq = c->channel;
 			chan_2ghz[a].max_power = c->maxTxPower;
+			chan_2ghz[a].priv = c;
 
 			if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
 				chan_2ghz[a].flags |= IEEE80211_CHAN_NO_IBSS;
@@ -223,13 +224,13 @@ static int ath_setup_channels(struct ath_softc *sc)
 
 			band_2ghz->n_channels = ++a;
 
-			DPRINTF(sc, ATH_DBG_CONFIG, "2MHz channel: %d, "
-				"channelFlags: 0x%x\n",
-				c->channel, c->channelFlags);
+			DPRINTF(sc, ATH_DBG_CONFIG, "2MHz channel: %d\n",
+				chan_2ghz[a].center_freq);
 		} else if (IS_CHAN_5GHZ(c)) {
 			chan_5ghz[b].band = IEEE80211_BAND_5GHZ;
 			chan_5ghz[b].center_freq = c->channel;
 			chan_5ghz[b].max_power = c->maxTxPower;
+			chan_5ghz[b].priv = c;
 
 			if (c->privFlags & CHANNEL_DISALLOW_ADHOC)
 				chan_5ghz[b].flags |= IEEE80211_CHAN_NO_IBSS;
@@ -238,9 +239,8 @@ static int ath_setup_channels(struct ath_softc *sc)
 
 			band_5ghz->n_channels = ++b;
 
-			DPRINTF(sc, ATH_DBG_CONFIG, "5MHz channel: %d, "
-				"channelFlags: 0x%x\n",
-				c->channel, c->channelFlags);
+			DPRINTF(sc, ATH_DBG_CONFIG, "5MHz channel: %d\n",
+				chan_5ghz[b].center_freq);
 		}
 	}
 
@@ -252,15 +252,21 @@ static int ath_setup_channels(struct ath_softc *sc)
  * by reseting the chip.  To accomplish this we must first cleanup any pending
  * DMA, then restart stuff.
 */
-static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
+static int ath_set_channel(struct ath_softc *sc, struct ieee80211_channel *c)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	bool fastcc = true, stopped;
 	struct ieee80211_hw *hw = sc->hw;
+	struct ath9k_channel *hchan;
 
 	if (sc->sc_flags & SC_OP_INVALID)
 		return -EIO;
 
+	if (!c->priv)
+		return -EINVAL;
+
+	hchan = (struct ath9k_channel *) c->priv;
+
 	if (hchan->channel != sc->sc_ah->ah_curchan->channel ||
 	    hchan->channelFlags != sc->sc_ah->ah_curchan->channelFlags ||
 	    (sc->sc_flags & SC_OP_CHAINMASK_UPDATE) ||
@@ -287,20 +293,20 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 			fastcc = false;
 
 		DPRINTF(sc, ATH_DBG_CONFIG,
-			"(%u MHz) -> (%u MHz), cflags:%x, chanwidth: %d\n",
+			"(%u MHz) -> (%u MHz), chanwidth: %d\n",
 			sc->sc_ah->ah_curchan->channel,
-			hchan->channel, hchan->channelFlags, sc->tx_chan_width);
+			c->center_freq, sc->tx_chan_width);
 
 		spin_lock_bh(&sc->sc_resetlock);
-		if (!ath9k_hw_reset(ah, hchan, sc->tx_chan_width,
+		if (!ath9k_hw_reset(ah, c, sc->tx_chan_width,
 				    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 				    sc->sc_ht_extprotspacing, fastcc, &status)) {
 			DPRINTF(sc, ATH_DBG_FATAL,
 				"Unable to reset channel %u (%uMhz) "
-				"flags 0x%x hal status %u\n",
-				ath9k_hw_mhz2ieee(ah, hchan->channel,
-						  hchan->channelFlags),
-				hchan->channel, hchan->channelFlags, status);
+				"hal status %u\n",
+				ieee80211_frequency_to_channel(c->center_freq),
+				c->center_freq,
+				status);
 			spin_unlock_bh(&sc->sc_resetlock);
 			return -EIO;
 		}
@@ -608,19 +614,6 @@ static irqreturn_t ath_isr(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-static int ath_get_channel(struct ath_softc *sc,
-			   struct ieee80211_channel *chan)
-{
-	int i;
-
-	for (i = 0; i < sc->sc_ah->ah_nchan; i++) {
-		if (sc->sc_ah->ah_channels[i].channel == chan->center_freq)
-			return i;
-	}
-
-	return -1;
-}
-
 static u32 ath_get_extchanmode(struct ath_softc *sc,
 			       struct ieee80211_channel *chan,
 			       enum nl80211_channel_type channel_type)
@@ -1068,10 +1061,11 @@ fail:
 static void ath_radio_enable(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
+	struct ieee80211_channel *c = sc->hw->conf.channel;
 	int status;
 
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, ah->ah_curchan,
+	if (!ath9k_hw_reset(ah, c,
 			    sc->tx_chan_width,
 			    sc->sc_tx_chainmask,
 			    sc->sc_rx_chainmask,
@@ -1079,12 +1073,10 @@ static void ath_radio_enable(struct ath_softc *sc)
 			    false, &status)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to reset channel %u (%uMhz) "
-			"flags 0x%x hal status %u\n",
-			ath9k_hw_mhz2ieee(ah,
-					  ah->ah_curchan->channel,
-					  ah->ah_curchan->channelFlags),
-			ah->ah_curchan->channel,
-			ah->ah_curchan->channelFlags, status);
+			"hal status %u\n",
+			ieee80211_frequency_to_channel(c->center_freq),
+			c->center_freq,
+			status);
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
@@ -1112,9 +1104,10 @@ static void ath_radio_enable(struct ath_softc *sc)
 static void ath_radio_disable(struct ath_softc *sc)
 {
 	struct ath_hal *ah = sc->sc_ah;
+	struct ieee80211_conf *conf = &sc->hw->conf;
+	struct ieee80211_channel *c = conf->channel;
 	int status;
 
-
 	ieee80211_stop_queues(sc->hw);
 
 	/* Disable LED */
@@ -1129,7 +1122,7 @@ static void ath_radio_disable(struct ath_softc *sc)
 	ath_flushrecv(sc);		/* flush recv queue */
 
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, ah->ah_curchan,
+	if (!ath9k_hw_reset(ah, c,
 			    sc->tx_chan_width,
 			    sc->sc_tx_chainmask,
 			    sc->sc_rx_chainmask,
@@ -1137,12 +1130,10 @@ static void ath_radio_disable(struct ath_softc *sc)
 			    false, &status)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to reset channel %u (%uMhz) "
-			"flags 0x%x hal status %u\n",
-			ath9k_hw_mhz2ieee(ah,
-				ah->ah_curchan->channel,
-				ah->ah_curchan->channelFlags),
-			ah->ah_curchan->channel,
-			ah->ah_curchan->channelFlags, status);
+			"hal status %u\n",
+			ieee80211_frequency_to_channel(c->center_freq),
+			c->center_freq,
+			status);
 	}
 	spin_unlock_bh(&sc->sc_resetlock);
 
@@ -1630,7 +1621,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	ath_flushrecv(sc);
 
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(ah, sc->sc_ah->ah_curchan,
+	if (!ath9k_hw_reset(ah, hw->conf.channel,
 			    sc->tx_chan_width,
 			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 			    sc->sc_ht_extprotspacing, false, &status)) {
@@ -1851,24 +1842,23 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	struct ath_softc *sc = hw->priv;
 	struct ieee80211_channel *curchan = hw->conf.channel;
 	struct ath9k_channel *init_channel;
-	int error = 0, pos, status;
+	int error = 0, status;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Starting driver with "
 		"initial channel: %d MHz\n", curchan->center_freq);
 
 	/* setup initial channel */
 
-	pos = ath_get_channel(sc, curchan);
-	if (pos == -1) {
+	if (!curchan->priv) {
 		DPRINTF(sc, ATH_DBG_FATAL, "Invalid channel: %d\n", curchan->center_freq);
 		error = -EINVAL;
 		goto error;
 	}
 
 	sc->tx_chan_width = ATH9K_HT_MACMODE_20;
-	sc->sc_ah->ah_channels[pos].chanmode =
+	init_channel = (struct ath9k_channel *) curchan->priv;
+	init_channel->chanmode =
 		(curchan->band == IEEE80211_BAND_2GHZ) ? CHANNEL_G : CHANNEL_A;
-	init_channel = &sc->sc_ah->ah_channels[pos];
 
 	/* Reset SERDES registers */
 	ath9k_hw_configpcipowersave(sc->sc_ah, 0);
@@ -1881,14 +1871,14 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	 * and then setup of the interrupt mask.
 	 */
 	spin_lock_bh(&sc->sc_resetlock);
-	if (!ath9k_hw_reset(sc->sc_ah, init_channel,
+	if (!ath9k_hw_reset(sc->sc_ah, curchan,
 			    sc->tx_chan_width,
 			    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 			    sc->sc_ht_extprotspacing, false, &status)) {
 		DPRINTF(sc, ATH_DBG_FATAL,
 			"Unable to reset hardware; hal status %u "
-			"(freq %u flags 0x%x)\n", status,
-			init_channel->channel, init_channel->channelFlags);
+			"(freq %u)\n", status,
+			curchan->center_freq);
 		error = -EIO;
 		spin_unlock_bh(&sc->sc_resetlock);
 		goto error;
@@ -2137,14 +2127,14 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_lock(&sc->mutex);
 	if (changed & (IEEE80211_CONF_CHANGE_CHANNEL |
 		       IEEE80211_CONF_CHANGE_HT)) {
-		struct ieee80211_channel *curchan = hw->conf.channel;
-		int pos;
+		struct ieee80211_channel *curchan = conf->channel;
+		struct ath9k_channel *priv_channel;
 
 		DPRINTF(sc, ATH_DBG_CONFIG, "Set channel: %d MHz\n",
 			curchan->center_freq);
 
-		pos = ath_get_channel(sc, curchan);
-		if (pos == -1) {
+		priv_channel = (struct ath9k_channel *) curchan->priv;
+		if (!priv_channel) {
 			DPRINTF(sc, ATH_DBG_FATAL, "Invalid channel: %d\n",
 				curchan->center_freq);
 			mutex_unlock(&sc->mutex);
@@ -2152,7 +2142,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 		}
 
 		sc->tx_chan_width = ATH9K_HT_MACMODE_20;
-		sc->sc_ah->ah_channels[pos].chanmode =
+		priv_channel->chanmode =
 			(curchan->band == IEEE80211_BAND_2GHZ) ?
 			CHANNEL_G : CHANNEL_A;
 
@@ -2161,12 +2151,12 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			    conf->ht.channel_type == NL80211_CHAN_HT40MINUS)
 				sc->tx_chan_width = ATH9K_HT_MACMODE_2040;
 
-			sc->sc_ah->ah_channels[pos].chanmode =
+			priv_channel->chanmode =
 				ath_get_extchanmode(sc, curchan,
 						    conf->ht.channel_type);
 		}
 
-		if (ath_set_channel(sc, &sc->sc_ah->ah_channels[pos]) < 0) {
+		if (ath_set_channel(sc, curchan) < 0) {
 			DPRINTF(sc, ATH_DBG_FATAL, "Unable to set channel\n");
 			mutex_unlock(&sc->mutex);
 			return -EINVAL;
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 8bb125d..030f49d 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -1171,7 +1171,7 @@ static void ath_drain_txdataq(struct ath_softc *sc, bool retry_tx)
 
 		spin_lock_bh(&sc->sc_resetlock);
 		if (!ath9k_hw_reset(ah,
-				    sc->sc_ah->ah_curchan,
+				    sc->hw->conf.channel,
 				    sc->tx_chan_width,
 				    sc->sc_tx_chainmask, sc->sc_rx_chainmask,
 				    sc->sc_ht_extprotspacing, true, &status)) {
-- 
1.5.6.rc2.15.g457bb.dirty

