Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:56471 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757971Ab3CYPaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 11:30:25 -0400
Received: by mail-ee0-f53.google.com with SMTP id c13so538398eek.12
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2013 08:30:23 -0700 (PDT)
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@gmail.com>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: [PATCH 1/3] mac80211: Use a cfg80211_chan_def in ieee80211_hw_conf_chan
Date: Mon, 25 Mar 2013 16:26:57 +0100
Message-Id: <1364225219-18473-2-git-send-email-karl.beldan@gmail.com> (sfid-20130325_163032_270347_A52EC69D)
In-Reply-To: <1364225219-18473-1-git-send-email-karl.beldan@gmail.com>
References: <1364225219-18473-1-git-send-email-karl.beldan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karl Beldan <karl.beldan@rivierawaves.com>

Drivers that don't use chanctxes cannot perform VHT association because
they still use a "backward compatibility" pair of {ieee80211_channel,
nl80211_channel_type} in ieee80211_conf and ieee80211_local.

Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
---
 drivers/net/wireless/adm8211.c                     |    3 +-
 drivers/net/wireless/at76c50x-usb.c                |    4 +-
 drivers/net/wireless/ath/ar5523/ar5523.c           |   14 ++---
 drivers/net/wireless/ath/ath5k/base.c              |    2 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |    4 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |    2 +-
 drivers/net/wireless/ath/ath9k/calib.c             |    2 +-
 drivers/net/wireless/ath/ath9k/common.c            |    5 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   16 +++---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |    8 +--
 drivers/net/wireless/ath/ath9k/hw.c                |    5 +-
 drivers/net/wireless/ath/ath9k/link.c              |    2 +-
 drivers/net/wireless/ath/ath9k/main.c              |   10 ++--
 drivers/net/wireless/ath/ath9k/rc.c                |    4 +-
 drivers/net/wireless/ath/ath9k/recv.c              |    6 +-
 drivers/net/wireless/ath/carl9170/debug.c          |    5 +-
 drivers/net/wireless/ath/carl9170/mac.c            |    8 +--
 drivers/net/wireless/ath/carl9170/main.c           |    9 ++-
 drivers/net/wireless/ath/carl9170/phy.c            |    4 +-
 drivers/net/wireless/b43/b43.h                     |    2 +-
 drivers/net/wireless/b43/main.c                    |    8 +--
 drivers/net/wireless/b43/phy_ht.c                  |    5 +-
 drivers/net/wireless/b43/phy_lcn.c                 |    5 +-
 drivers/net/wireless/b43/phy_n.c                   |    5 +-
 drivers/net/wireless/b43legacy/main.c              |    9 +--
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |    4 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    6 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    4 +-
 drivers/net/wireless/iwlegacy/3945-rs.c            |    2 +-
 drivers/net/wireless/iwlegacy/4965-rs.c            |    2 +-
 drivers/net/wireless/iwlegacy/common.c             |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rs.c              |    2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c            |    9 +--
 drivers/net/wireless/libertas_tf/main.c            |    8 +--
 drivers/net/wireless/mac80211_hwsim.c              |   42 +++++++++-----
 drivers/net/wireless/mwl8k.c                       |   36 ++++++------
 drivers/net/wireless/p54/fwio.c                    |    4 +-
 drivers/net/wireless/p54/main.c                    |    4 +-
 drivers/net/wireless/p54/txrx.c                    |    4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |    8 +--
 drivers/net/wireless/rt2x00/rt2x00config.c         |   10 ++--
 drivers/net/wireless/rt2x00/rt61pci.c              |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c         |    4 +-
 drivers/net/wireless/rtl818x/rtl8180/grf5101.c     |    3 +-
 drivers/net/wireless/rtl818x/rtl8180/max2820.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/rtl8225.c     |    3 +-
 drivers/net/wireless/rtl818x/rtl8180/sa2400.c      |    3 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |    4 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8225.c     |    3 +-
 drivers/net/wireless/rtlwifi/base.c                |    4 +-
 drivers/net/wireless/rtlwifi/core.c                |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |    8 +--
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c       |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |    4 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/trx.c       |    4 +-
 drivers/net/wireless/ti/wl1251/main.c              |    5 +-
 drivers/net/wireless/ti/wlcore/main.c              |    2 +-
 drivers/net/wireless/zd1211rw/zd_mac.c             |    4 +-
 include/net/mac80211.h                             |   15 ++---
 net/mac80211/cfg.c                                 |    7 +--
 net/mac80211/chan.c                                |   11 ++--
 net/mac80211/ieee80211_i.h                         |    3 +-
 net/mac80211/main.c                                |   59 +++++++++++---------
 net/mac80211/mlme.c                                |   24 +++++---
 net/mac80211/scan.c                                |    6 +-
 net/mac80211/trace.h                               |   37 ++++++------
 net/mac80211/tx.c                                  |    4 +-
 net/mac80211/util.c                                |    3 +-
 70 files changed, 292 insertions(+), 242 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 3d339e0..f9a24e5 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1293,7 +1293,8 @@ static int adm8211_config(struct ieee80211_hw *dev, u32 changed)
 {
 	struct adm8211_priv *priv = dev->priv;
 	struct ieee80211_conf *conf = &dev->conf;
-	int channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	int channel =
+		ieee80211_frequency_to_channel(conf->chandef.chan->center_freq);
 
 	if (channel != priv->channel) {
 		priv->channel = channel;
diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 5ac5f7a..34c8a33 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1943,12 +1943,12 @@ static int at76_config(struct ieee80211_hw *hw, u32 changed)
 	struct at76_priv *priv = hw->priv;
 
 	at76_dbg(DBG_MAC80211, "%s(): channel %d",
-		 __func__, hw->conf.channel->hw_value);
+		 __func__, hw->conf.chandef.chan->hw_value);
 	at76_dbg_dump(DBG_MAC80211, priv->bssid, ETH_ALEN, "bssid:");
 
 	mutex_lock(&priv->mtx);
 
-	priv->channel = hw->conf.channel->hw_value;
+	priv->channel = hw->conf.chandef.chan->hw_value;
 
 	if (is_valid_ether_addr(priv->bssid))
 		at76_join(priv);
diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index afd1e36..17d7fec 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -457,14 +457,14 @@ static int ar5523_set_chan(struct ar5523 *ar)
 	memset(&reset, 0, sizeof(reset));
 	reset.flags |= cpu_to_be32(UATH_CHAN_2GHZ);
 	reset.flags |= cpu_to_be32(UATH_CHAN_OFDM);
-	reset.freq = cpu_to_be32(conf->channel->center_freq);
+	reset.freq = cpu_to_be32(conf->chandef.chan->center_freq);
 	reset.maxrdpower = cpu_to_be32(50);	/* XXX */
 	reset.channelchange = cpu_to_be32(1);
 	reset.keeprccontent = cpu_to_be32(0);
 
 	ar5523_dbg(ar, "set chan flags 0x%x freq %d\n",
 		   be32_to_cpu(reset.flags),
-		   conf->channel->center_freq);
+		   conf->chandef.chan->center_freq);
 	return ar5523_cmd_write(ar, WDCMSG_RESET, &reset, sizeof(reset), 0);
 }
 
@@ -594,7 +594,7 @@ static void ar5523_data_rx_cb(struct urb *urb)
 	rx_status = IEEE80211_SKB_RXCB(data->skb);
 	memset(rx_status, 0, sizeof(*rx_status));
 	rx_status->freq = be32_to_cpu(desc->channel);
-	rx_status->band = hw->conf.channel->band;
+	rx_status->band = hw->conf.chandef.chan->band;
 	rx_status->signal = -95 + be32_to_cpu(desc->rssi);
 
 	ieee80211_rx_irqsafe(hw, data->skb);
@@ -1153,13 +1153,13 @@ static int ar5523_get_wlan_mode(struct ar5523 *ar,
 	struct ieee80211_sta *sta;
 	u32 sta_rate_set;
 
-	band = ar->hw->wiphy->bands[ar->hw->conf.channel->band];
+	band = ar->hw->wiphy->bands[ar->hw->conf.chandef.chan->band];
 	sta = ieee80211_find_sta(ar->vif, bss_conf->bssid);
 	if (!sta) {
 		ar5523_info(ar, "STA not found!\n");
 		return WLAN_MODE_11b;
 	}
-	sta_rate_set = sta->supp_rates[ar->hw->conf.channel->band];
+	sta_rate_set = sta->supp_rates[ar->hw->conf.chandef.chan->band];
 
 	for (bit = 0; bit < band->n_bitrates; bit++) {
 		if (sta_rate_set & 1) {
@@ -1197,11 +1197,11 @@ static void ar5523_create_rateset(struct ar5523 *ar,
 		ar5523_info(ar, "STA not found. Cannot set rates\n");
 		sta_rate_set = bss_conf->basic_rates;
 	} else
-		sta_rate_set = sta->supp_rates[ar->hw->conf.channel->band];
+		sta_rate_set = sta->supp_rates[ar->hw->conf.chandef.chan->band];
 
 	ar5523_dbg(ar, "sta rate_set = %08x\n", sta_rate_set);
 
-	band = ar->hw->wiphy->bands[ar->hw->conf.channel->band];
+	band = ar->hw->wiphy->bands[ar->hw->conf.chandef.chan->band];
 	for (bit = 0; bit < band->n_bitrates; bit++) {
 		BUG_ON(i >= AR5523_MAX_NRATES);
 		ar5523_dbg(ar, "Considering rate %d : %d\n",
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 1d264c0..9b20d9e 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2639,7 +2639,7 @@ int ath5k_start(struct ieee80211_hw *hw)
 	 * be followed by initialization of the appropriate bits
 	 * and then setup of the interrupt mask.
 	 */
-	ah->curchan = ah->hw->conf.channel;
+	ah->curchan = ah->hw->conf.chandef.chan;
 	ah->imask = AR5K_INT_RXOK
 		| AR5K_INT_RXERR
 		| AR5K_INT_RXEOL
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 4264341..06f86f4 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -202,7 +202,7 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_lock(&ah->lock);
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		ret = ath5k_chan_set(ah, conf->channel);
+		ret = ath5k_chan_set(ah, conf->chandef.chan);
 		if (ret < 0)
 			goto unlock;
 	}
@@ -678,7 +678,7 @@ ath5k_get_survey(struct ieee80211_hw *hw, int idx, struct survey_info *survey)
 
 	memcpy(survey, &ah->survey, sizeof(*survey));
 
-	survey->channel = conf->channel;
+	survey->channel = conf->chandef.chan;
 	survey->noise = ah->ah_noise_floor;
 	survey->filled = SURVEY_INFO_NOISE_DBM |
 			SURVEY_INFO_CHANNEL_TIME |
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 5f05c26..2ff570f 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -79,7 +79,7 @@ static void ath9k_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
 	u8 chainmask = ah->txchainmask;
 	u8 rate = 0;
 
-	sband = &sc->sbands[common->hw->conf.channel->band];
+	sband = &sc->sbands[common->hw->conf.chandef.chan->band];
 	rate = sband->bitrates[rateidx].hw_value;
 	if (vif->bss_conf.use_short_preamble)
 		rate |= sband->bitrates[rateidx].hw_value_short;
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 1e85085..b184f1f 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -208,7 +208,7 @@ bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 		return true;
 
 	ath_dbg(common, CALIBRATE, "Resetting Cal %d state for channel %u\n",
-		currCal->calData->calType, conf->channel->center_freq);
+		currCal->calData->calType, conf->chandef.chan->center_freq);
 
 	ah->caldata->CalValid &= ~currCal->calData->calType;
 	currCal->calState = CAL_WAITING;
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 905f1b3..6c78fe7 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -133,13 +133,14 @@ EXPORT_SYMBOL(ath9k_cmn_update_ichannel);
 struct ath9k_channel *ath9k_cmn_get_curchannel(struct ieee80211_hw *hw,
 					       struct ath_hw *ah)
 {
-	struct ieee80211_channel *curchan = hw->conf.channel;
+	struct ieee80211_channel *curchan = hw->conf.chandef.chan;
 	struct ath9k_channel *channel;
 	u8 chan_idx;
 
 	chan_idx = curchan->hw_value;
 	channel = &ah->channels[chan_idx];
-	ath9k_cmn_update_ichannel(channel, curchan, hw->conf.channel_type);
+	ath9k_cmn_update_ichannel(channel, curchan,
+				  cfg80211_get_chandef_type(&hw->conf.chandef));
 
 	return channel;
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index a8016d7..098e354 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -190,7 +190,7 @@ void ath9k_htc_reset(struct ath9k_htc_priv *priv)
 {
 	struct ath_hw *ah = priv->ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_channel *channel = priv->hw->conf.channel;
+	struct ieee80211_channel *channel = priv->hw->conf.chandef.chan;
 	struct ath9k_hw_cal_data *caldata = NULL;
 	enum htc_phymode mode;
 	__be16 htc_mode;
@@ -250,7 +250,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &common->hw->conf;
 	bool fastcc;
-	struct ieee80211_channel *channel = hw->conf.channel;
+	struct ieee80211_channel *channel = hw->conf.chandef.chan;
 	struct ath9k_hw_cal_data *caldata = NULL;
 	enum htc_phymode mode;
 	__be16 htc_mode;
@@ -602,7 +602,7 @@ static void ath9k_htc_setup_rate(struct ath9k_htc_priv *priv,
 	u32 caps = 0;
 	int i, j;
 
-	sband = priv->hw->wiphy->bands[priv->hw->conf.channel->band];
+	sband = priv->hw->wiphy->bands[priv->hw->conf.chandef.chan->band];
 
 	for (i = 0, j = 0; i < sband->n_bitrates; i++) {
 		if (sta->supp_rates[sband->band] & BIT(i)) {
@@ -904,7 +904,7 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath_hw *ah = priv->ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_channel *curchan = hw->conf.channel;
+	struct ieee80211_channel *curchan = hw->conf.chandef.chan;
 	struct ath9k_channel *init_channel;
 	int ret = 0;
 	enum htc_phymode mode;
@@ -1193,15 +1193,17 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) || chip_reset) {
-		struct ieee80211_channel *curchan = hw->conf.channel;
+		struct ieee80211_channel *curchan = hw->conf.chandef.chan;
+		enum nl80211_channel_type channel_type =
+			cfg80211_get_chandef_type(&hw->conf.chandef);
 		int pos = curchan->hw_value;
 
 		ath_dbg(common, CONFIG, "Set channel: %d MHz\n",
 			curchan->center_freq);
 
 		ath9k_cmn_update_ichannel(&priv->ah->channels[pos],
-					  hw->conf.channel,
-					  hw->conf.channel_type);
+					  hw->conf.chandef.chan,
+					  channel_type);
 
 		if (ath9k_htc_set_channel(priv, hw, &priv->ah->channels[pos]) < 0) {
 			ath_err(common, "Unable to set channel\n");
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 3ad1fd0..306c550 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -490,7 +490,7 @@ static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
 		if (txs->ts_flags & ATH9K_HTC_TXSTAT_SGI)
 			rate->flags |= IEEE80211_TX_RC_SHORT_GI;
 	} else {
-		if (cur_conf->channel->band == IEEE80211_BAND_5GHZ)
+		if (cur_conf->chandef.chan->band == IEEE80211_BAND_5GHZ)
 			rate->idx += 4; /* No CCK rates */
 	}
 
@@ -939,7 +939,7 @@ static void ath9k_process_rate(struct ieee80211_hw *hw,
 		return;
 	}
 
-	band = hw->conf.channel->band;
+	band = hw->conf.chandef.chan->band;
 	sband = hw->wiphy->bands[band];
 
 	for (i = 0; i < sband->n_bitrates; i++) {
@@ -1078,8 +1078,8 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 		priv->ah->stats.avgbrssi = rxbuf->rxstatus.rs_rssi;
 
 	rx_status->mactime = be64_to_cpu(rxbuf->rxstatus.rs_tstamp);
-	rx_status->band = hw->conf.channel->band;
-	rx_status->freq = hw->conf.channel->center_freq;
+	rx_status->band = hw->conf.chandef.chan->band;
+	rx_status->freq = hw->conf.chandef.chan->center_freq;
 	rx_status->signal =  rxbuf->rxstatus.rs_rssi + ATH_DEFAULT_NOISE_FLOOR;
 	rx_status->antenna = rxbuf->rxstatus.rs_antenna;
 	rx_status->flag |= RX_FLAG_MACTIME_END;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 2a2ae40..d5e6a38 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -139,7 +139,7 @@ static void ath9k_hw_set_clockrate(struct ath_hw *ah)
 		clockrate = 117;
 	else if (!ah->curchan) /* should really check for CCK instead */
 		clockrate = ATH9K_CLOCK_RATE_CCK;
-	else if (conf->channel->band == IEEE80211_BAND_2GHZ)
+	else if (conf->chandef.chan->band == IEEE80211_BAND_2GHZ)
 		clockrate = ATH9K_CLOCK_RATE_2GHZ_OFDM;
 	else if (ah->caps.hw_caps & ATH9K_HW_CAP_FASTCLOCK)
 		clockrate = ATH9K_CLOCK_FAST_RATE_5GHZ_OFDM;
@@ -1110,7 +1110,8 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	 * BA frames in some implementations, but it has been found to fix ACK
 	 * timeout issues in other cases as well.
 	 */
-	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ &&
+	if (conf->chandef.chan &&
+	    conf->chandef.chan->band == IEEE80211_BAND_2GHZ &&
 	    !IS_CHAN_HALF_RATE(chan) && !IS_CHAN_QUARTER_RATE(chan)) {
 		acktimeout += 64 - sifstime - ah->slottime;
 		ctstimeout += 48 - sifstime - ah->slottime;
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index ade3afb..b1433f5 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -213,7 +213,7 @@ static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int
 	txctl.txq = sc->tx.txq_map[IEEE80211_AC_BE];
 
 	memset(tx_info, 0, sizeof(*tx_info));
-	tx_info->band = hw->conf.channel->band;
+	tx_info->band = hw->conf.chandef.chan->band;
 	tx_info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	tx_info->control.rates[0].idx = 0;
 	tx_info->control.rates[0].count = 1;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 24650fd4..f984a03 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -585,7 +585,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_channel *curchan = hw->conf.channel;
+	struct ieee80211_channel *curchan = hw->conf.chandef.chan;
 	struct ath9k_channel *init_channel;
 	int r;
 
@@ -1184,7 +1184,9 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) || reset_channel) {
-		struct ieee80211_channel *curchan = hw->conf.channel;
+		struct ieee80211_channel *curchan = hw->conf.chandef.chan;
+		enum nl80211_channel_type channel_type =
+			cfg80211_get_chandef_type(&conf->chandef);
 		int pos = curchan->hw_value;
 		int old_pos = -1;
 		unsigned long flags;
@@ -1193,7 +1195,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			old_pos = ah->curchan - &ah->channels[0];
 
 		ath_dbg(common, CONFIG, "Set channel: %d MHz type: %d\n",
-			curchan->center_freq, conf->channel_type);
+			curchan->center_freq, channel_type);
 
 		/* update survey stats for the old channel before switching */
 		spin_lock_irqsave(&common->cc_lock, flags);
@@ -1208,7 +1210,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			ath9k_hw_getnf(ah, ah->curchan);
 
 		ath9k_cmn_update_ichannel(&sc->sc_ah->channels[pos],
-					  curchan, conf->channel_type);
+					  curchan, channel_type);
 
 		/*
 		 * If the operating channel changes, change the survey in-use flags
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 96ac433..aa4d368 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -814,7 +814,7 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	 * So, set fourth rate in series to be same as third one for
 	 * above conditions.
 	 */
-	if ((sc->hw->conf.channel->band == IEEE80211_BAND_2GHZ) &&
+	if ((sc->hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ) &&
 	    (conf_is_ht(&sc->hw->conf))) {
 		u8 dot11rate = rate_table->info[rix].dot11rate;
 		u8 phy = rate_table->info[rix].phy;
@@ -1328,7 +1328,7 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 
 		ath_dbg(ath9k_hw_common(sc->sc_ah), CONFIG,
 			"Operating HT Bandwidth changed to: %d\n",
-			sc->hw->conf.channel_type);
+			cfg80211_get_chandef_type(&sc->hw->conf.chandef));
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index ee156e5..c90ca57 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -859,7 +859,7 @@ static int ath9k_process_rate(struct ath_common *common,
 	unsigned int i = 0;
 	struct ath_softc __maybe_unused *sc = common->priv;
 
-	band = hw->conf.channel->band;
+	band = hw->conf.chandef.chan->band;
 	sband = hw->wiphy->bands[band];
 
 	if (rx_stats->rs_rate & 0x80) {
@@ -954,8 +954,8 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 	if (ath9k_process_rate(common, hw, rx_stats, rx_status))
 		return -EINVAL;
 
-	rx_status->band = hw->conf.channel->band;
-	rx_status->freq = hw->conf.channel->center_freq;
+	rx_status->band = hw->conf.chandef.chan->band;
+	rx_status->freq = hw->conf.chandef.chan->center_freq;
 	rx_status->signal = ah->noise + rx_stats->rs_rssi;
 	rx_status->antenna = rx_stats->rs_antenna;
 	rx_status->flag |= RX_FLAG_MACTIME_END;
diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index 93fe600..7741fe8 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -654,8 +654,9 @@ static ssize_t carl9170_debugfs_bug_write(struct ar9170 *ar, const char *buf,
 		goto out;
 
 	case 'P':
-		err = carl9170_set_channel(ar, ar->hw->conf.channel,
-			ar->hw->conf.channel_type, CARL9170_RFI_COLD);
+		err = carl9170_set_channel(ar, ar->hw->conf.chandef.chan,
+			cfg80211_get_chandef_type(&ar->hw->conf.chandef),
+			CARL9170_RFI_COLD);
 		if (err < 0)
 			count = err;
 
diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
index 24d75ab..a2f00570 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -48,7 +48,7 @@ int carl9170_set_dyn_sifs_ack(struct ar9170 *ar)
 	if (conf_is_ht40(&ar->hw->conf))
 		val = 0x010a;
 	else {
-		if (ar->hw->conf.channel->band == IEEE80211_BAND_2GHZ)
+		if (ar->hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
 			val = 0x105;
 		else
 			val = 0x104;
@@ -66,7 +66,7 @@ int carl9170_set_rts_cts_rate(struct ar9170 *ar)
 		rts_rate = 0x1da;
 		cts_rate = 0x10a;
 	} else {
-		if (ar->hw->conf.channel->band == IEEE80211_BAND_2GHZ) {
+		if (ar->hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ) {
 			/* 11 mbit CCK */
 			rts_rate = 033;
 			cts_rate = 003;
@@ -93,7 +93,7 @@ int carl9170_set_slot_time(struct ar9170 *ar)
 		return 0;
 	}
 
-	if ((ar->hw->conf.channel->band == IEEE80211_BAND_5GHZ) ||
+	if ((ar->hw->conf.chandef.chan->band == IEEE80211_BAND_5GHZ) ||
 	    vif->bss_conf.use_short_slot)
 		slottime = 9;
 
@@ -120,7 +120,7 @@ int carl9170_set_mac_rates(struct ar9170 *ar)
 	basic |= (vif->bss_conf.basic_rates & 0xff0) << 4;
 	rcu_read_unlock();
 
-	if (ar->hw->conf.channel->band == IEEE80211_BAND_5GHZ)
+	if (ar->hw->conf.chandef.chan->band == IEEE80211_BAND_5GHZ)
 		mandatory = 0xff00; /* OFDM 6/9/12/18/24/36/48/54 */
 	else
 		mandatory = 0xff0f; /* OFDM (6/9../54) + CCK (1/2/5.5/11) */
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 08b1931..4e268b1 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -929,6 +929,9 @@ static int carl9170_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+		enum nl80211_channel_type channel_type =
+			cfg80211_get_chandef_type(&hw->conf.chandef);
+
 		/* adjust slot time for 5 GHz */
 		err = carl9170_set_slot_time(ar);
 		if (err)
@@ -938,8 +941,8 @@ static int carl9170_op_config(struct ieee80211_hw *hw, u32 changed)
 		if (err)
 			goto out;
 
-		err = carl9170_set_channel(ar, hw->conf.channel,
-			hw->conf.channel_type, CARL9170_RFI_NONE);
+		err = carl9170_set_channel(ar, hw->conf.chandef.chan,
+					   channel_type, CARL9170_RFI_NONE);
 		if (err)
 			goto out;
 
@@ -957,7 +960,7 @@ static int carl9170_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		err = carl9170_set_mac_tpc(ar, ar->hw->conf.channel);
+		err = carl9170_set_mac_tpc(ar, ar->hw->conf.chandef.chan);
 		if (err)
 			goto out;
 	}
diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index b72c09c..c5f1fdd 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1331,7 +1331,7 @@ static void carl9170_calc_ctl(struct ar9170 *ar, u32 freq, enum carl9170_bw bw)
 	 * CTL_ETSI for 2GHz and CTL_FCC for 5GHz.
 	 */
 	ctl_grp = ath_regd_get_band_ctl(&ar->common.regulatory,
-					ar->hw->conf.channel->band);
+					ar->hw->conf.chandef.chan->band);
 
 	/* ctl group not found - either invalid band (NO_CTL) or ww roaming */
 	if (ctl_grp == NO_CTL || ctl_grp == SD_NO_CTL)
@@ -1341,7 +1341,7 @@ static void carl9170_calc_ctl(struct ar9170 *ar, u32 freq, enum carl9170_bw bw)
 		/* skip CTL and heavy clip for CTL_MKK and CTL_ETSI */
 		return;
 
-	if (ar->hw->conf.channel->band == IEEE80211_BAND_2GHZ) {
+	if (ar->hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ) {
 		modes = mode_list_2ghz;
 		nr_modes = ARRAY_SIZE(mode_list_2ghz);
 	} else {
diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 10e288d..6a4bd8c 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -972,7 +972,7 @@ static inline int b43_is_mode(struct b43_wl *wl, int type)
  */
 static inline enum ieee80211_band b43_current_band(struct b43_wl *wl)
 {
-	return wl->hw->conf.channel->band;
+	return wl->hw->conf.chandef.chan->band;
 }
 
 static inline int b43_bus_may_powerdown(struct b43_wldev *wldev)
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 0568273..d135e89 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3848,7 +3848,7 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 	dev = wl->current_dev;
 
 	/* Switch the band (if necessary). This might change the active core. */
-	err = b43_switch_band(wl, conf->channel);
+	err = b43_switch_band(wl, conf->chandef.chan);
 	if (err)
 		goto out_unlock_mutex;
 
@@ -3878,8 +3878,8 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	/* Switch to the requested channel.
 	 * The firmware takes care of races with the TX handler. */
-	if (conf->channel->hw_value != phy->channel)
-		b43_switch_channel(dev, conf->channel->hw_value);
+	if (conf->chandef.chan->hw_value != phy->channel)
+		b43_switch_channel(dev, conf->chandef.chan->hw_value);
 
 	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_MONITOR);
 
@@ -5002,7 +5002,7 @@ static int b43_op_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
 
-	survey->channel = conf->channel;
+	survey->channel = conf->chandef.chan;
 	survey->filled = SURVEY_INFO_NOISE_DBM;
 	survey->noise = dev->stats.link_noise;
 
diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 7416c5e..016682e 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -525,8 +525,9 @@ static void b43_phy_ht_op_switch_analog(struct b43_wldev *dev, bool on)
 static int b43_phy_ht_op_switch_channel(struct b43_wldev *dev,
 					unsigned int new_channel)
 {
-	struct ieee80211_channel *channel = dev->wl->hw->conf.channel;
-	enum nl80211_channel_type channel_type = dev->wl->hw->conf.channel_type;
+	struct ieee80211_channel *channel = dev->wl->hw->conf.chandef.chan;
+	enum nl80211_channel_type channel_type =
+		cfg80211_get_chandef_type(&dev->wl->hw->conf.chandef);
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
 		if ((new_channel < 1) || (new_channel > 14))
diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index a13e28e..0bafa3b 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -808,8 +808,9 @@ static void b43_phy_lcn_op_switch_analog(struct b43_wldev *dev, bool on)
 static int b43_phy_lcn_op_switch_channel(struct b43_wldev *dev,
 					unsigned int new_channel)
 {
-	struct ieee80211_channel *channel = dev->wl->hw->conf.channel;
-	enum nl80211_channel_type channel_type = dev->wl->hw->conf.channel_type;
+	struct ieee80211_channel *channel = dev->wl->hw->conf.chandef.chan;
+	enum nl80211_channel_type channel_type =
+		cfg80211_get_chandef_type(&dev->wl->hw->conf.chandef);
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
 		if ((new_channel < 1) || (new_channel > 14))
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 3c35382..949a3bd 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -5530,8 +5530,9 @@ static void b43_nphy_op_switch_analog(struct b43_wldev *dev, bool on)
 static int b43_nphy_op_switch_channel(struct b43_wldev *dev,
 				      unsigned int new_channel)
 {
-	struct ieee80211_channel *channel = dev->wl->hw->conf.channel;
-	enum nl80211_channel_type channel_type = dev->wl->hw->conf.channel_type;
+	struct ieee80211_channel *channel = dev->wl->hw->conf.chandef.chan;
+	enum nl80211_channel_type channel_type =
+		cfg80211_get_chandef_type(&dev->wl->hw->conf.chandef);
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
 		if ((new_channel < 1) || (new_channel > 14))
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index 8c3f70e..5726688 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2720,7 +2720,7 @@ static int b43legacy_op_dev_config(struct ieee80211_hw *hw,
 		goto out_unlock_mutex;
 
 	/* Switch the PHY mode (if necessary). */
-	switch (conf->channel->band) {
+	switch (conf->chandef.chan->band) {
 	case IEEE80211_BAND_2GHZ:
 		if (phy->type == B43legacy_PHYTYPE_B)
 			new_phymode = B43legacy_PHYMODE_B;
@@ -2748,8 +2748,9 @@ static int b43legacy_op_dev_config(struct ieee80211_hw *hw,
 
 	/* Switch to the requested channel.
 	 * The firmware takes care of races with the TX handler. */
-	if (conf->channel->hw_value != phy->channel)
-		b43legacy_radio_selectchannel(dev, conf->channel->hw_value, 0);
+	if (conf->chandef.chan->hw_value != phy->channel)
+		b43legacy_radio_selectchannel(dev, conf->chandef.chan->hw_value,
+					      0);
 
 	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_MONITOR);
 
@@ -3558,7 +3559,7 @@ static int b43legacy_op_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
 
-	survey->channel = conf->channel;
+	survey->channel = conf->chandef.chan;
 	survey->filled = SURVEY_INFO_NOISE_DBM;
 	survey->noise = dev->stats.link_noise;
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 10ee314..cc87926 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -379,7 +379,7 @@ brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm, u16 chanspec,
 			 u8 local_constraint_qdbm)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
-	struct ieee80211_channel *ch = wlc->pub->ieee_hw->conf.channel;
+	struct ieee80211_channel *ch = wlc->pub->ieee_hw->conf.chandef.chan;
 	struct txpwr_limits txpwr;
 
 	brcms_c_channel_reg_limits(wlc_cm, chanspec, &txpwr);
@@ -404,7 +404,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 		       struct txpwr_limits *txpwr)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
-	struct ieee80211_channel *ch = wlc->pub->ieee_hw->conf.channel;
+	struct ieee80211_channel *ch = wlc->pub->ieee_hw->conf.chandef.chan;
 	uint i;
 	uint chan;
 	int maxpwr;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index aa5f43f..70731d2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -414,10 +414,10 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 				  new_int);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		if (conf->channel_type == NL80211_CHAN_HT20 ||
-		    conf->channel_type == NL80211_CHAN_NO_HT)
+		if (conf->chandef.width == NL80211_CHAN_WIDTH_20 ||
+		    conf->chandef.width == NL80211_CHAN_WIDTH_20_NOHT)
 			err = brcms_c_set_channel(wl->wlc,
-						  conf->channel->hw_value);
+						  conf->chandef.chan->hw_value);
 		else
 			err = -ENOTSUPP;
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 8ef02dc..e0dc183 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -5099,7 +5099,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	wlc->pub->up = true;
 
 	if (wlc->bandinit_pending) {
-		ch = wlc->pub->ieee_hw->conf.channel;
+		ch = wlc->pub->ieee_hw->conf.chandef.chan;
 		brcms_c_suspend_mac_and_wait(wlc);
 		brcms_c_set_chanspec(wlc, ch20mhz_chspec(ch->hw_value));
 		wlc->bandinit_pending = false;
@@ -7748,7 +7748,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 {
 	struct bcma_device *core = wlc->hw->d11core;
-	struct ieee80211_channel *ch = wlc->pub->ieee_hw->conf.channel;
+	struct ieee80211_channel *ch = wlc->pub->ieee_hw->conf.chandef.chan;
 	u16 chanspec;
 
 	brcms_dbg_info(core, "wl%d\n", wlc->pub->unit);
diff --git a/drivers/net/wireless/iwlegacy/3945-rs.c b/drivers/net/wireless/iwlegacy/3945-rs.c
index d4fd29a..c9f197d 100644
--- a/drivers/net/wireless/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -347,7 +347,7 @@ il3945_rs_rate_init(struct il_priv *il, struct ieee80211_sta *sta, u8 sta_id)
 
 	psta = (struct il3945_sta_priv *)sta->drv_priv;
 	rs_sta = &psta->rs_sta;
-	sband = hw->wiphy->bands[conf->channel->band];
+	sband = hw->wiphy->bands[conf->chandef.chan->band];
 
 	rs_sta->il = il;
 
diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index e8324b5..1d92a59 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -2299,7 +2299,7 @@ il4965_rs_rate_init(struct il_priv *il, struct ieee80211_sta *sta, u8 sta_id)
 
 	sta_priv = (struct il_station_priv *)sta->drv_priv;
 	lq_sta = &sta_priv->lq_sta;
-	sband = hw->wiphy->bands[conf->channel->band];
+	sband = hw->wiphy->bands[conf->chandef.chan->band];
 
 	lq_sta->lq.sta_id = sta_id;
 
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 722bfb5..025d8b0 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4974,7 +4974,7 @@ il_mac_config(struct ieee80211_hw *hw, u32 changed)
 	struct il_priv *il = hw->priv;
 	const struct il_channel_info *ch_info;
 	struct ieee80211_conf *conf = &hw->conf;
-	struct ieee80211_channel *channel = conf->channel;
+	struct ieee80211_channel *channel = conf->chandef.chan;
 	struct il_ht_config *ht_conf = &il->current_ht_config;
 	unsigned long flags = 0;
 	int ret = 0;
diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c b/drivers/net/wireless/iwlwifi/dvm/rs.c
index abe3042..907bd6e 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -2831,7 +2831,7 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 
 	sta_priv = (struct iwl_station_priv *) sta->drv_priv;
 	lq_sta = &sta_priv->lq_sta;
-	sband = hw->wiphy->bands[conf->channel->band];
+	sband = hw->wiphy->bands[conf->chandef.chan->band];
 
 
 	lq_sta->lq.sta_id = sta_id;
diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index 23be948..085c589 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -78,8 +78,9 @@ void iwl_connection_init_rx_config(struct iwl_priv *priv,
 		ctx->staging.flags |= RXON_FLG_SHORT_PREAMBLE_MSK;
 #endif
 
-	ctx->staging.channel = cpu_to_le16(priv->hw->conf.channel->hw_value);
-	priv->band = priv->hw->conf.channel->band;
+	ctx->staging.channel =
+		cpu_to_le16(priv->hw->conf.chandef.chan->hw_value);
+	priv->band = priv->hw->conf.chandef.chan->band;
 
 	iwl_set_flags_for_band(priv, ctx, priv->band, ctx->vif);
 
@@ -951,7 +952,7 @@ static void iwl_calc_basic_rates(struct iwl_priv *priv,
 		unsigned long basic = ctx->vif->bss_conf.basic_rates;
 		int i;
 
-		sband = priv->hw->wiphy->bands[priv->hw->conf.channel->band];
+		sband = priv->hw->wiphy->bands[priv->hw->conf.chandef.chan->band];
 
 		for_each_set_bit(i, &basic, BITS_PER_LONG) {
 			int hw = sband->bitrates[i].hw_value;
@@ -1181,7 +1182,7 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_rxon_context *ctx;
 	struct ieee80211_conf *conf = &hw->conf;
-	struct ieee80211_channel *channel = conf->channel;
+	struct ieee80211_channel *channel = conf->chandef.chan;
 	int ret = 0;
 
 	IWL_DEBUG_MAC80211(priv, "enter: changed %#x\n", changed);
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index 7001856..088de9d 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -412,9 +412,9 @@ static int lbtf_op_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 	lbtf_deb_enter(LBTF_DEB_MACOPS);
 
-	if (conf->channel->center_freq != priv->cur_freq) {
-		priv->cur_freq = conf->channel->center_freq;
-		lbtf_set_channel(priv, conf->channel->hw_value);
+	if (conf->chandef.chan->center_freq != priv->cur_freq) {
+		priv->cur_freq = conf->chandef.chan->center_freq;
+		lbtf_set_channel(priv, conf->chandef.chan->hw_value);
 	}
 	lbtf_deb_leave(LBTF_DEB_MACOPS);
 	return 0;
@@ -537,7 +537,7 @@ static int lbtf_op_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
 
-	survey->channel = conf->channel;
+	survey->channel = conf->chandef.chan;
 	survey->filled = SURVEY_INFO_NOISE_DBM;
 	survey->noise = priv->noise;
 
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0064d38..4ac5486 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1062,11 +1062,13 @@ out:
 	return HRTIMER_NORESTART;
 }
 
-static const char *hwsim_chantypes[] = {
-	[NL80211_CHAN_NO_HT] = "noht",
-	[NL80211_CHAN_HT20] = "ht20",
-	[NL80211_CHAN_HT40MINUS] = "ht40-",
-	[NL80211_CHAN_HT40PLUS] = "ht40+",
+static const char * const hwsim_chanwidths[] = {
+	[NL80211_CHAN_WIDTH_20_NOHT] = "noht",
+	[NL80211_CHAN_WIDTH_20] = "ht20",
+	[NL80211_CHAN_WIDTH_40] = "ht40",
+	[NL80211_CHAN_WIDTH_80] = "vht80",
+	[NL80211_CHAN_WIDTH_80P80] = "vht80p80",
+	[NL80211_CHAN_WIDTH_160] = "vht160",
 };
 
 static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
@@ -1080,18 +1082,28 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 		[IEEE80211_SMPS_DYNAMIC] = "dynamic",
 	};
 
-	wiphy_debug(hw->wiphy,
-		    "%s (freq=%d/%s idle=%d ps=%d smps=%s)\n",
-		    __func__,
-		    conf->channel ? conf->channel->center_freq : 0,
-		    hwsim_chantypes[conf->channel_type],
-		    !!(conf->flags & IEEE80211_CONF_IDLE),
-		    !!(conf->flags & IEEE80211_CONF_PS),
-		    smps_modes[conf->smps_mode]);
+	if (conf->chandef.chan)
+		wiphy_debug(hw->wiphy,
+			    "%s (freq=%d(%d - %d)/%s idle=%d ps=%d smps=%s)\n",
+			    __func__,
+			    conf->chandef.chan->center_freq,
+			    conf->chandef.center_freq1,
+			    conf->chandef.center_freq2,
+			    hwsim_chanwidths[conf->chandef.width],
+			    !!(conf->flags & IEEE80211_CONF_IDLE),
+			    !!(conf->flags & IEEE80211_CONF_PS),
+			    smps_modes[conf->smps_mode]);
+	else
+		wiphy_debug(hw->wiphy,
+			    "%s (freq=0 idle=%d ps=%d smps=%s)\n",
+			    __func__,
+			    !!(conf->flags & IEEE80211_CONF_IDLE),
+			    !!(conf->flags & IEEE80211_CONF_PS),
+			    smps_modes[conf->smps_mode]);
 
 	data->idle = !!(conf->flags & IEEE80211_CONF_IDLE);
 
-	data->channel = conf->channel;
+	data->channel = conf->chandef.chan;
 
 	WARN_ON(data->channel && channels > 1);
 
@@ -1277,7 +1289,7 @@ static int mac80211_hwsim_get_survey(
 		return -ENOENT;
 
 	/* Current channel */
-	survey->channel = conf->channel;
+	survey->channel = conf->chandef.chan;
 
 	/*
 	 * Magically conjured noise level --- this is only ok for simulated hardware.
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 091d9a6..9f9a144 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2837,7 +2837,9 @@ static int mwl8k_cmd_tx_power(struct ieee80211_hw *hw,
 				     struct ieee80211_conf *conf,
 				     unsigned short pwr)
 {
-	struct ieee80211_channel *channel = conf->channel;
+	struct ieee80211_channel *channel = conf->chandef.chan;
+	enum nl80211_channel_type channel_type =
+		cfg80211_get_chandef_type(&conf->chandef);
 	struct mwl8k_cmd_tx_power *cmd;
 	int rc;
 	int i;
@@ -2857,14 +2859,14 @@ static int mwl8k_cmd_tx_power(struct ieee80211_hw *hw,
 
 	cmd->channel = cpu_to_le16(channel->hw_value);
 
-	if (conf->channel_type == NL80211_CHAN_NO_HT ||
-	    conf->channel_type == NL80211_CHAN_HT20) {
+	if (channel_type == NL80211_CHAN_NO_HT ||
+	    channel_type == NL80211_CHAN_HT20) {
 		cmd->bw = cpu_to_le16(0x2);
 	} else {
 		cmd->bw = cpu_to_le16(0x4);
-		if (conf->channel_type == NL80211_CHAN_HT40MINUS)
+		if (channel_type == NL80211_CHAN_HT40MINUS)
 			cmd->sub_ch = cpu_to_le16(0x3);
-		else if (conf->channel_type == NL80211_CHAN_HT40PLUS)
+		else if (channel_type == NL80211_CHAN_HT40PLUS)
 			cmd->sub_ch = cpu_to_le16(0x1);
 	}
 
@@ -3008,7 +3010,9 @@ struct mwl8k_cmd_set_rf_channel {
 static int mwl8k_cmd_set_rf_channel(struct ieee80211_hw *hw,
 				    struct ieee80211_conf *conf)
 {
-	struct ieee80211_channel *channel = conf->channel;
+	struct ieee80211_channel *channel = conf->chandef.chan;
+	enum nl80211_channel_type channel_type =
+		cfg80211_get_chandef_type(&conf->chandef);
 	struct mwl8k_cmd_set_rf_channel *cmd;
 	int rc;
 
@@ -3026,12 +3030,12 @@ static int mwl8k_cmd_set_rf_channel(struct ieee80211_hw *hw,
 	else if (channel->band == IEEE80211_BAND_5GHZ)
 		cmd->channel_flags |= cpu_to_le32(0x00000004);
 
-	if (conf->channel_type == NL80211_CHAN_NO_HT ||
-	    conf->channel_type == NL80211_CHAN_HT20)
+	if (channel_type == NL80211_CHAN_NO_HT ||
+	    channel_type == NL80211_CHAN_HT20)
 		cmd->channel_flags |= cpu_to_le32(0x00000080);
-	else if (conf->channel_type == NL80211_CHAN_HT40MINUS)
+	else if (channel_type == NL80211_CHAN_HT40MINUS)
 		cmd->channel_flags |= cpu_to_le32(0x000001900);
-	else if (conf->channel_type == NL80211_CHAN_HT40PLUS)
+	else if (channel_type == NL80211_CHAN_HT40PLUS)
 		cmd->channel_flags |= cpu_to_le32(0x000000900);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
@@ -3950,7 +3954,7 @@ static int mwl8k_cmd_set_new_stn_add(struct ieee80211_hw *hw,
 	memcpy(cmd->mac_addr, sta->addr, ETH_ALEN);
 	cmd->stn_id = cpu_to_le16(sta->aid);
 	cmd->action = cpu_to_le16(MWL8K_STA_ACTION_ADD);
-	if (hw->conf.channel->band == IEEE80211_BAND_2GHZ)
+	if (hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
 		rates = sta->supp_rates[IEEE80211_BAND_2GHZ];
 	else
 		rates = sta->supp_rates[IEEE80211_BAND_5GHZ] << 5;
@@ -4385,7 +4389,7 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
 	p->ht_caps = cpu_to_le16(sta->ht_cap.cap);
 	p->extended_ht_caps = (sta->ht_cap.ampdu_factor & 3) |
 		((sta->ht_cap.ampdu_density & 7) << 2);
-	if (hw->conf.channel->band == IEEE80211_BAND_2GHZ)
+	if (hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
 		rates = sta->supp_rates[IEEE80211_BAND_2GHZ];
 	else
 		rates = sta->supp_rates[IEEE80211_BAND_5GHZ] << 5;
@@ -4868,7 +4872,7 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			goto out;
 		}
 
-		if (hw->conf.channel->band == IEEE80211_BAND_2GHZ) {
+		if (hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ) {
 			ap_legacy_rates = ap->supp_rates[IEEE80211_BAND_2GHZ];
 		} else {
 			ap_legacy_rates =
@@ -4900,7 +4904,7 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			if (idx)
 				idx--;
 
-			if (hw->conf.channel->band == IEEE80211_BAND_2GHZ)
+			if (hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
 				rate = mwl8k_rates_24[idx].hw_value;
 			else
 				rate = mwl8k_rates_50[idx].hw_value;
@@ -4973,7 +4977,7 @@ mwl8k_bss_info_changed_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		if (idx)
 			idx--;
 
-		if (hw->conf.channel->band == IEEE80211_BAND_2GHZ)
+		if (hw->conf.chandef.chan->band == IEEE80211_BAND_2GHZ)
 			rate = mwl8k_rates_24[idx].hw_value;
 		else
 			rate = mwl8k_rates_50[idx].hw_value;
@@ -5246,7 +5250,7 @@ static int mwl8k_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
 
-	survey->channel = conf->channel;
+	survey->channel = conf->chandef.chan;
 	survey->filled = SURVEY_INFO_NOISE_DBM;
 	survey->noise = priv->noise;
 
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 9ba8510..b3879fb 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -402,7 +402,7 @@ int p54_scan(struct p54_common *priv, u16 mode, u16 dwell)
 	struct p54_rssi_db_entry *rssi_data;
 	unsigned int i;
 	void *entry;
-	__le16 freq = cpu_to_le16(priv->hw->conf.channel->center_freq);
+	__le16 freq = cpu_to_le16(priv->hw->conf.chandef.chan->center_freq);
 
 	skb = p54_alloc_skb(priv, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*head) +
 			    2 + sizeof(*iq_autocal) + sizeof(*body) +
@@ -532,7 +532,7 @@ int p54_scan(struct p54_common *priv, u16 mode, u16 dwell)
 err:
 	wiphy_err(priv->hw->wiphy, "frequency change to channel %d failed.\n",
 		  ieee80211_frequency_to_channel(
-			  priv->hw->conf.channel->center_freq));
+			  priv->hw->conf.chandef.chan->center_freq));
 
 	dev_kfree_skb_any(skb);
 	return -EINVAL;
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index ee654a6..067e6f2 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -340,7 +340,7 @@ static int p54_config(struct ieee80211_hw *dev, u32 changed)
 		 * TODO: Use the LM_SCAN_TRAP to determine the current
 		 * operating channel.
 		 */
-		priv->curchan = priv->hw->conf.channel;
+		priv->curchan = priv->hw->conf.chandef.chan;
 		p54_reset_stats(priv);
 		WARN_ON(p54_fetch_statistics(priv));
 	}
@@ -480,7 +480,7 @@ static void p54_bss_info_changed(struct ieee80211_hw *dev,
 		p54_set_edcf(priv);
 	}
 	if (changed & BSS_CHANGED_BASIC_RATES) {
-		if (dev->conf.channel->band == IEEE80211_BAND_5GHZ)
+		if (dev->conf.chandef.chan->band == IEEE80211_BAND_5GHZ)
 			priv->basic_rate_mask = (info->basic_rates << 4);
 		else
 			priv->basic_rate_mask = info->basic_rates;
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index 12f0a34..f95de0d 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -354,13 +354,13 @@ static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
 	rx_status->signal = p54_rssi_to_dbm(priv, hdr->rssi);
 	if (hdr->rate & 0x10)
 		rx_status->flag |= RX_FLAG_SHORTPRE;
-	if (priv->hw->conf.channel->band == IEEE80211_BAND_5GHZ)
+	if (priv->hw->conf.chandef.chan->band == IEEE80211_BAND_5GHZ)
 		rx_status->rate_idx = (rate < 4) ? 0 : rate - 4;
 	else
 		rx_status->rate_idx = rate;
 
 	rx_status->freq = freq;
-	rx_status->band =  priv->hw->conf.channel->band;
+	rx_status->band =  priv->hw->conf.chandef.chan->band;
 	rx_status->antenna = hdr->antenna;
 
 	tsf32 = le32_to_cpu(hdr->tsf32);
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a658b4b..34456b4 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2763,7 +2763,7 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 
 void rt2800_gain_calibration(struct rt2x00_dev *rt2x00dev)
 {
-	rt2800_config_txpower(rt2x00dev, rt2x00dev->hw->conf.channel,
+	rt2800_config_txpower(rt2x00dev, rt2x00dev->hw->conf.chandef.chan,
 			      rt2x00dev->tx_power);
 }
 EXPORT_SYMBOL_GPL(rt2800_gain_calibration);
@@ -2898,11 +2898,11 @@ void rt2800_config(struct rt2x00_dev *rt2x00dev,
 	if (flags & IEEE80211_CONF_CHANGE_CHANNEL) {
 		rt2800_config_channel(rt2x00dev, libconf->conf,
 				      &libconf->rf, &libconf->channel);
-		rt2800_config_txpower(rt2x00dev, libconf->conf->channel,
+		rt2800_config_txpower(rt2x00dev, libconf->conf->chandef.chan,
 				      libconf->conf->power_level);
 	}
 	if (flags & IEEE80211_CONF_CHANGE_POWER)
-		rt2800_config_txpower(rt2x00dev, libconf->conf->channel,
+		rt2800_config_txpower(rt2x00dev, libconf->conf->chandef.chan,
 				      libconf->conf->power_level);
 	if (flags & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
 		rt2800_config_retry_limit(rt2x00dev, libconf);
@@ -5563,7 +5563,7 @@ int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
 
-	survey->channel = conf->channel;
+	survey->channel = conf->chandef.chan;
 
 	rt2800_register_read(rt2x00dev, CH_IDLE_STA, &idle);
 	rt2800_register_read(rt2x00dev, CH_BUSY_STA, &busy);
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 49a63e9..8cb43f8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -184,7 +184,7 @@ static u16 rt2x00ht_center_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Initialize center channel to current channel.
 	 */
-	center_channel = spec->channels[conf->channel->hw_value].channel;
+	center_channel = spec->channels[conf->chandef.chan->hw_value].channel;
 
 	/*
 	 * Adjust center channel to HT40+ and HT40- operation.
@@ -199,7 +199,7 @@ static u16 rt2x00ht_center_channel(struct rt2x00_dev *rt2x00dev,
 			return i;
 
 	WARN_ON(1);
-	return conf->channel->hw_value;
+	return conf->chandef.chan->hw_value;
 }
 
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
@@ -227,7 +227,7 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 			hw_value = rt2x00ht_center_channel(rt2x00dev, conf);
 		} else {
 			clear_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags);
-			hw_value = conf->channel->hw_value;
+			hw_value = conf->chandef.chan->hw_value;
 		}
 
 		memcpy(&libconf.rf,
@@ -279,8 +279,8 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	else
 		clear_bit(CONFIG_POWERSAVING, &rt2x00dev->flags);
 
-	rt2x00dev->curr_band = conf->channel->band;
-	rt2x00dev->curr_freq = conf->channel->center_freq;
+	rt2x00dev->curr_band = conf->chandef.chan->band;
+	rt2x00dev->curr_freq = conf->chandef.chan->center_freq;
 	rt2x00dev->tx_power = conf->power_level;
 	rt2x00dev->short_retry = conf->short_frame_max_tx_count;
 	rt2x00dev->long_retry = conf->long_frame_max_tx_count;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index f95792c..f85035c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -847,7 +847,7 @@ static void rt61pci_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 	u16 eeprom;
 	short lna_gain = 0;
 
-	if (libconf->conf->channel->band == IEEE80211_BAND_2GHZ) {
+	if (libconf->conf->chandef.chan->band == IEEE80211_BAND_2GHZ) {
 		if (test_bit(CAPABILITY_EXTERNAL_LNA_BG, &rt2x00dev->cap_flags))
 			lna_gain += 14;
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 24eec66..a3387b1 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -739,7 +739,7 @@ static void rt73usb_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 	u16 eeprom;
 	short lna_gain = 0;
 
-	if (libconf->conf->channel->band == IEEE80211_BAND_2GHZ) {
+	if (libconf->conf->chandef.chan->band == IEEE80211_BAND_2GHZ) {
 		if (test_bit(CAPABILITY_EXTERNAL_LNA_BG, &rt2x00dev->cap_flags))
 			lna_gain += 14;
 
diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 1b3c284..91a04e2 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -147,8 +147,8 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 				signal = priv->rf->calc_rssi(agc, sq);
 			}
 			rx_status.signal = signal;
-			rx_status.freq = dev->conf.channel->center_freq;
-			rx_status.band = dev->conf.channel->band;
+			rx_status.freq = dev->conf.chandef.chan->center_freq;
+			rx_status.band = dev->conf.chandef.chan->band;
 			rx_status.mactime = le64_to_cpu(entry->tsft);
 			rx_status.flag |= RX_FLAG_MACTIME_START;
 			if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
diff --git a/drivers/net/wireless/rtl818x/rtl8180/grf5101.c b/drivers/net/wireless/rtl818x/rtl8180/grf5101.c
index 5ee7589..077ff92 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/grf5101.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/grf5101.c
@@ -82,7 +82,8 @@ static void grf5101_rf_set_channel(struct ieee80211_hw *dev,
 				   struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
-	int channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	int channel =
+		ieee80211_frequency_to_channel(conf->chandef.chan->center_freq);
 	u32 txpw = priv->channels[channel - 1].hw_value & 0xFF;
 	u32 chan = channel - 1;
 
diff --git a/drivers/net/wireless/rtl818x/rtl8180/max2820.c b/drivers/net/wireless/rtl818x/rtl8180/max2820.c
index 667b336..4715000 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/max2820.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/max2820.c
@@ -95,7 +95,7 @@ static void max2820_rf_set_channel(struct ieee80211_hw *dev,
 {
 	struct rtl8180_priv *priv = dev->priv;
 	int channel = conf ?
-		ieee80211_frequency_to_channel(conf->channel->center_freq) : 1;
+		ieee80211_frequency_to_channel(conf->chandef.chan->center_freq) : 1;
 	unsigned int chan_idx = channel - 1;
 	u32 txpw = priv->channels[chan_idx].hw_value & 0xFF;
 	u32 chan = max2820_chan[chan_idx];
diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c b/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
index 7c4574b..cc2a541 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
@@ -719,7 +719,8 @@ static void rtl8225_rf_set_channel(struct ieee80211_hw *dev,
 				   struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
-	int chan = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	int chan =
+		ieee80211_frequency_to_channel(conf->chandef.chan->center_freq);
 
 	if (priv->rf->init == rtl8225_rf_init)
 		rtl8225_rf_set_tx_power(dev, chan);
diff --git a/drivers/net/wireless/rtl818x/rtl8180/sa2400.c b/drivers/net/wireless/rtl818x/rtl8180/sa2400.c
index 44771a62..b3ec40f 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/sa2400.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/sa2400.c
@@ -105,7 +105,8 @@ static void sa2400_rf_set_channel(struct ieee80211_hw *dev,
 				  struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
-	int channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	int channel =
+		ieee80211_frequency_to_channel(conf->chandef.chan->center_freq);
 	u32 txpw = priv->channels[channel - 1].hw_value & 0xFF;
 	u32 chan = sa2400_chan[channel - 1];
 
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index 4574bd2..f49220e 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -379,8 +379,8 @@ static void rtl8187_rx_cb(struct urb *urb)
 	rate = (flags >> 20) & 0xF;
 	skb_trim(skb, flags & 0x0FFF);
 	rx_status.rate_idx = rate;
-	rx_status.freq = dev->conf.channel->center_freq;
-	rx_status.band = dev->conf.channel->band;
+	rx_status.freq = dev->conf.chandef.chan->center_freq;
+	rx_status.band = dev->conf.chandef.chan->band;
 	rx_status.flag |= RX_FLAG_MACTIME_START;
 	if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
 		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
diff --git a/drivers/net/wireless/rtl818x/rtl8187/rtl8225.c b/drivers/net/wireless/rtl818x/rtl8187/rtl8225.c
index 908903f..f0bf35f 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/rtl8225.c
@@ -905,7 +905,8 @@ static void rtl8225_rf_set_channel(struct ieee80211_hw *dev,
 				   struct ieee80211_conf *conf)
 {
 	struct rtl8187_priv *priv = dev->priv;
-	int chan = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	int chan =
+		ieee80211_frequency_to_channel(conf->chandef.chan->center_freq);
 
 	if (priv->rf->init == rtl8225_rf_init)
 		rtl8225_rf_set_tx_power(dev, chan);
diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 99c5cea..0e7866d 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -691,7 +691,7 @@ int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
 	int rate_idx;
 
 	if (false == isht) {
-		if (IEEE80211_BAND_2GHZ == hw->conf.channel->band) {
+		if (IEEE80211_BAND_2GHZ == hw->conf.chandef.chan->band) {
 			switch (desc_rate) {
 			case DESC92_RATE1M:
 				rate_idx = 0;
@@ -1365,7 +1365,7 @@ int rtl_send_smps_action(struct ieee80211_hw *hw,
 		rtlpriv->cfg->ops->update_rate_tbl(hw, sta, 0);
 
 		info->control.rates[0].idx = 0;
-		info->band = hw->conf.channel->band;
+		info->band = hw->conf.chandef.chan->band;
 		rtlpriv->intf_ops->adapter_tx(hw, sta, skb, &tcb_desc);
 	}
 err_free:
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index b5a7a26..64a41ec 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -320,7 +320,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		struct ieee80211_channel *channel = hw->conf.channel;
+		struct ieee80211_channel *channel = hw->conf.chandef.chan;
 		u8 wide_chan = (u8) channel->hw_value;
 
 		/*
@@ -332,7 +332,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 		 *info for cisco1253 bw20, so we modify
 		 *it here based on UPPER & LOWER
 		 */
-		switch (hw->conf.channel_type) {
+		switch (cfg80211_get_chandef_type(&hw->conf.chandef)) {
 		case NL80211_CHAN_HT20:
 		case NL80211_CHAN_NO_HT:
 			/* SC */
@@ -390,7 +390,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 		rtlpriv->cfg->ops->switch_channel(hw);
 		rtlpriv->cfg->ops->set_channel_access(hw);
 		rtlpriv->cfg->ops->set_bw_mode(hw,
-					       hw->conf.channel_type);
+				cfg80211_get_chandef_type(&hw->conf.chandef));
 	}
 
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index b9b1a6e..27e4ebd 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -544,8 +544,8 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
 	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
 
-	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->band = hw->conf.channel->band;
+	rx_status->freq = hw->conf.chandef.chan->center_freq;
+	rx_status->band = hw->conf.chandef.chan->band;
 
 	if (GET_RX_DESC_CRC32(pdesc))
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index b6222ee..f0dada5 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -324,8 +324,8 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 				   && (GET_RX_DESC_FAGGR(pdesc) == 1));
 	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
 	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
-	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->band = hw->conf.channel->band;
+	rx_status->freq = hw->conf.chandef.chan->center_freq;
+	rx_status->band = hw->conf.chandef.chan->band;
 	if (GET_RX_DESC_CRC32(pdesc))
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 	if (!GET_RX_DESC_SWDEC(pdesc))
@@ -395,8 +395,8 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	stats.rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(rxdesc);
 	/* TODO: is center_freq changed when doing scan? */
 	/* TODO: Shall we add protection or just skip those two step? */
-	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->band = hw->conf.channel->band;
+	rx_status->freq = hw->conf.chandef.chan->center_freq;
+	rx_status->band = hw->conf.chandef.chan->band;
 	if (GET_RX_DESC_CRC32(rxdesc))
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 	if (!GET_RX_DESC_SWDEC(rxdesc))
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
index 941080e..b8ec718 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -499,8 +499,8 @@ bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,	struct rtl_stats *stats,
 					 && (GET_RX_DESC_FAGGR(pdesc) == 1));
 	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
 	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
-	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->band = hw->conf.channel->band;
+	rx_status->freq = hw->conf.chandef.chan->center_freq;
+	rx_status->band = hw->conf.chandef.chan->band;
 	if (GET_RX_DESC_CRC32(pdesc))
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 	if (!GET_RX_DESC_SWDEC(pdesc))
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index 7b0a2e7..0b074f1 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -538,8 +538,8 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 	if (stats->hwerror)
 		return false;
 
-	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->band = hw->conf.channel->band;
+	rx_status->freq = hw->conf.chandef.chan->center_freq;
+	rx_status->band = hw->conf.chandef.chan->band;
 
 	hdr = (struct ieee80211_hdr *)(skb->data + stats->rx_drvinfo_size
 	      + stats->rx_bufshift);
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
index ac08129..601261d 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/trx.c
@@ -304,8 +304,8 @@ bool rtl8723ae_rx_query_desc(struct ieee80211_hw *hw,
 
 	status->is_cck = RTL8723E_RX_HAL_IS_CCK_RATE(status->rate);
 
-	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->band = hw->conf.channel->band;
+	rx_status->freq = hw->conf.chandef.chan->center_freq;
+	rx_status->band = hw->conf.chandef.chan->band;
 
 	hdr = (struct ieee80211_hdr *)(skb->data + status->rx_drvinfo_size
 		+ status->rx_bufshift);
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index bbbf68c..3291ffa 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -572,7 +572,8 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 	int channel, ret = 0;
 
-	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	channel = ieee80211_frequency_to_channel(
+			conf->chandef.chan->center_freq);
 
 	wl1251_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d",
 		     channel,
@@ -1223,7 +1224,7 @@ static int wl1251_op_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
  
-	survey->channel = conf->channel;
+	survey->channel = conf->chandef.chan;
 	survey->filled = SURVEY_INFO_NOISE_DBM;
 	survey->noise = wl->noise;
  
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index a9f7041..c26cb09 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4474,7 +4474,7 @@ static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
 
-	survey->channel = conf->channel;
+	survey->channel = conf->chandef.chan;
 	survey->filled = 0;
 	return 0;
 }
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 114364b..c6208a7 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -1156,10 +1156,10 @@ static int zd_op_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 
 	spin_lock_irq(&mac->lock);
-	mac->channel = conf->channel->hw_value;
+	mac->channel = conf->chandef.chan->hw_value;
 	spin_unlock_irq(&mac->lock);
 
-	return zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
+	return zd_chip_set_channel(&mac->chip, conf->chandef.chan->hw_value);
 }
 
 static void zd_beacon_done(struct zd_mac *mac)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9b53617..2cb6669 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1001,8 +1001,7 @@ struct ieee80211_conf {
 
 	u8 long_frame_max_tx_count, short_frame_max_tx_count;
 
-	struct ieee80211_channel *channel;
-	enum nl80211_channel_type channel_type;
+	struct cfg80211_chan_def chandef;
 	bool radar_enabled;
 	enum ieee80211_smps_mode smps_mode;
 };
@@ -4203,31 +4202,33 @@ void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
 static inline bool
 conf_is_ht20(struct ieee80211_conf *conf)
 {
-	return conf->channel_type == NL80211_CHAN_HT20;
+	return conf->chandef.width == NL80211_CHAN_WIDTH_20;
 }
 
 static inline bool
 conf_is_ht40_minus(struct ieee80211_conf *conf)
 {
-	return conf->channel_type == NL80211_CHAN_HT40MINUS;
+	return conf->chandef.width == NL80211_CHAN_WIDTH_40 &&
+	       conf->chandef.center_freq1 < conf->chandef.chan->center_freq;
 }
 
 static inline bool
 conf_is_ht40_plus(struct ieee80211_conf *conf)
 {
-	return conf->channel_type == NL80211_CHAN_HT40PLUS;
+	return conf->chandef.width == NL80211_CHAN_WIDTH_40 &&
+	       conf->chandef.center_freq1 > conf->chandef.chan->center_freq;
 }
 
 static inline bool
 conf_is_ht40(struct ieee80211_conf *conf)
 {
-	return conf_is_ht40_minus(conf) || conf_is_ht40_plus(conf);
+	return conf->chandef.width == NL80211_CHAN_WIDTH_40;
 }
 
 static inline bool
 conf_is_ht(struct ieee80211_conf *conf)
 {
-	return conf->channel_type != NL80211_CHAN_NO_HT;
+	return conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT;
 }
 
 static inline enum nl80211_iftype
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 50aaf25..6e43feb 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -805,8 +805,7 @@ static int ieee80211_set_monitor_channel(struct wiphy *wiphy,
 					IEEE80211_CHANCTX_EXCLUSIVE);
 		}
 	} else if (local->open_count == local->monitors) {
-		local->_oper_channel = chandef->chan;
-		local->_oper_channel_type = cfg80211_get_chandef_type(chandef);
+		local->_oper_chandef = *chandef;
 		ieee80211_hw_config(local, 0);
 	}
 
@@ -3373,9 +3372,7 @@ static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
 		if (local->use_chanctx)
 			*chandef = local->monitor_chandef;
 		else
-			cfg80211_chandef_create(chandef,
-						local->_oper_channel,
-						local->_oper_channel_type);
+			*chandef = local->_oper_chandef;
 		ret = 0;
 	}
 	rcu_read_unlock();
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 78c0d90..8024874 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -22,7 +22,7 @@ static void ieee80211_change_chanctx(struct ieee80211_local *local,
 	drv_change_chanctx(local, ctx, IEEE80211_CHANCTX_CHANGE_WIDTH);
 
 	if (!local->use_chanctx) {
-		local->_oper_channel_type = cfg80211_get_chandef_type(chandef);
+		local->_oper_chandef = *chandef;
 		ieee80211_hw_config(local, 0);
 	}
 }
@@ -77,9 +77,7 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
 	ctx->mode = mode;
 
 	if (!local->use_chanctx) {
-		local->_oper_channel_type =
-			cfg80211_get_chandef_type(chandef);
-		local->_oper_channel = chandef->chan;
+		local->_oper_chandef = *chandef;
 		ieee80211_hw_config(local, 0);
 	} else {
 		err = drv_add_chanctx(local, ctx);
@@ -106,7 +104,10 @@ static void ieee80211_free_chanctx(struct ieee80211_local *local,
 	WARN_ON_ONCE(ctx->refcount != 0);
 
 	if (!local->use_chanctx) {
-		local->_oper_channel_type = NL80211_CHAN_NO_HT;
+		struct cfg80211_chan_def *chandef = &local->_oper_chandef;
+		chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
+		chandef->center_freq1 = chandef->chan->center_freq;
+		chandef->center_freq2 = 0;
 		ieee80211_hw_config(local, 0);
 	} else {
 		drv_remove_chanctx(local, ctx);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 55155e3..0b77333 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1022,8 +1022,7 @@ struct ieee80211_local {
 	struct ieee80211_sub_if_data __rcu *scan_sdata;
 	struct ieee80211_channel *csa_channel;
 	/* For backward compatibility only -- do not use */
-	struct ieee80211_channel *_oper_channel;
-	enum nl80211_channel_type _oper_channel_type;
+	struct cfg80211_chan_def _oper_chandef;
 
 	/* Temporary remain-on-channel for off-channel operations */
 	struct ieee80211_channel *tmp_channel;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index c6f81ec..25a87f4 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -95,42 +95,47 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
 static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_channel *chan;
+	struct cfg80211_chan_def chandef = {};
 	u32 changed = 0;
 	int power;
-	enum nl80211_channel_type channel_type;
 	u32 offchannel_flag;
 
 	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
+
 	if (local->scan_channel) {
-		chan = local->scan_channel;
+		chandef.chan = local->scan_channel;
 		/* If scanning on oper channel, use whatever channel-type
 		 * is currently in use.
 		 */
-		if (chan == local->_oper_channel)
-			channel_type = local->_oper_channel_type;
-		else
-			channel_type = NL80211_CHAN_NO_HT;
+		if (chandef.chan == local->_oper_chandef.chan) {
+			chandef = local->_oper_chandef;
+		} else {
+			chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
+			chandef.center_freq1 = chandef.chan->center_freq;
+		}
 	} else if (local->tmp_channel) {
-		chan = local->tmp_channel;
-		channel_type = NL80211_CHAN_NO_HT;
-	} else {
-		chan = local->_oper_channel;
-		channel_type = local->_oper_channel_type;
-	}
-
-	if (chan != local->_oper_channel ||
-	    channel_type != local->_oper_channel_type)
+		chandef.chan = local->tmp_channel;
+		chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
+		chandef.center_freq1 = chandef.chan->center_freq;
+	} else
+		chandef = local->_oper_chandef;
+
+	WARN(!cfg80211_chandef_valid(&chandef),
+	     "control:%d MHz width:%d center: %d/%d MHz",
+	     chandef.chan->center_freq, chandef.width,
+	     chandef.center_freq1, chandef.center_freq2);
+
+	if (!cfg80211_chandef_identical(&chandef, &local->_oper_chandef))
 		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
 	else
 		local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
 
 	offchannel_flag ^= local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 
-	if (offchannel_flag || chan != local->hw.conf.channel ||
-	    channel_type != local->hw.conf.channel_type) {
-		local->hw.conf.channel = chan;
-		local->hw.conf.channel_type = channel_type;
+	if (offchannel_flag ||
+	    !cfg80211_chandef_identical(&local->hw.conf.chandef,
+					&local->_oper_chandef)) {
+		local->hw.conf.chandef = chandef;
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
 	}
 
@@ -146,7 +151,7 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 		changed |= IEEE80211_CONF_CHANGE_SMPS;
 	}
 
-	power = chan->max_power;
+	power = chandef.chan->max_power;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
@@ -738,11 +743,15 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		sband = local->hw.wiphy->bands[band];
 		if (!sband)
 			continue;
-		if (!local->use_chanctx && !local->_oper_channel) {
+		if (!local->use_chanctx && !local->_oper_chandef.chan) {
 			/* init channel we're on */
-			local->hw.conf.channel =
-			local->_oper_channel = &sband->channels[0];
-			local->hw.conf.channel_type = NL80211_CHAN_NO_HT;
+			struct cfg80211_chan_def chandef = {
+				.chan = &sband->channels[0],
+				.width = NL80211_CHAN_NO_HT,
+				.center_freq1 = sband->channels[0].center_freq,
+				.center_freq2 = 0
+			};
+			local->hw.conf.chandef = local->_oper_chandef = chandef;
 		}
 		cfg80211_chandef_create(&local->monitor_chandef,
 					&sband->channels[0],
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8b3e852..ab51976 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -988,6 +988,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
+	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (!ieee80211_sdata_running(sdata))
@@ -997,21 +998,30 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	if (!ifmgd->associated)
 		goto out;
 
-	sdata->local->_oper_channel = sdata->local->csa_channel;
-	if (!sdata->local->ops->channel_switch) {
+	/*
+	 * FIXME: Here we are downgrading to NL80211_CHAN_WIDTH_20_NOHT
+	 * and don't adjust our ht/vht settings
+	 * This is wrong - we should behave according to the CSA params
+	 */
+	local->_oper_chandef.chan = local->csa_channel;
+	local->_oper_chandef.width = NL80211_CHAN_WIDTH_20_NOHT;
+	local->_oper_chandef.center_freq1 =
+		local->_oper_chandef.chan->center_freq;
+	local->_oper_chandef.center_freq2 = 0;
+
+	if (!local->ops->channel_switch) {
 		/* call "hw_config" only if doing sw channel switch */
-		ieee80211_hw_config(sdata->local,
-			IEEE80211_CONF_CHANGE_CHANNEL);
+		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 	} else {
 		/* update the device channel directly */
-		sdata->local->hw.conf.channel = sdata->local->_oper_channel;
+		local->hw.conf.chandef = local->_oper_chandef;
 	}
 
 	/* XXX: shouldn't really modify cfg80211-owned data! */
-	ifmgd->associated->channel = sdata->local->_oper_channel;
+	ifmgd->associated->channel = local->_oper_chandef.chan;
 
 	/* XXX: wait for a beacon first? */
-	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+	ieee80211_wake_queues_by_reason(&local->hw,
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
  out:
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index cb34cbb..581764f 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -384,7 +384,7 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 {
 	int i;
 	struct ieee80211_sub_if_data *sdata;
-	enum ieee80211_band band = local->hw.conf.channel->band;
+	enum ieee80211_band band = local->hw.conf.chandef.chan->band;
 	u32 tx_flags;
 
 	tx_flags = IEEE80211_TX_INTFL_OFFCHAN_TX_OK;
@@ -401,7 +401,7 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 			local->scan_req->ssids[i].ssid_len,
 			local->scan_req->ie, local->scan_req->ie_len,
 			local->scan_req->rates[band], false,
-			tx_flags, local->hw.conf.channel, true);
+			tx_flags, local->hw.conf.chandef.chan, true);
 
 	/*
 	 * After sending probe requests, wait for probe responses
@@ -467,7 +467,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	if (local->ops->hw_scan) {
 		__set_bit(SCAN_HW_SCANNING, &local->scanning);
 	} else if ((req->n_channels == 1) &&
-		   (req->channels[0] == local->_oper_channel)) {
+		   (req->channels[0] == local->_oper_chandef.chan)) {
 		/*
 		 * If we are scanning only on the operating channel
 		 * then we do not need to stop normal activities
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index d79e374..8286dce 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -28,27 +28,27 @@
 #define VIF_PR_FMT	" vif:%s(%d%s)"
 #define VIF_PR_ARG	__get_str(vif_name), __entry->vif_type, __entry->p2p ? "/p2p" : ""
 
-#define CHANDEF_ENTRY	__field(u32, control_freq)				\
-			__field(u32, chan_width)				\
-			__field(u32, center_freq1)				\
+#define CHANDEF_ENTRY	__field(u32, control_freq)					\
+			__field(u32, chan_width)					\
+			__field(u32, center_freq1)					\
 			__field(u32, center_freq2)
-#define CHANDEF_ASSIGN(c)							\
-			__entry->control_freq = (c)->chan->center_freq;		\
-			__entry->chan_width = (c)->width;			\
-			__entry->center_freq1 = (c)->center_freq1;		\
+#define CHANDEF_ASSIGN(c)								\
+			__entry->control_freq = (c)->chan ? (c)->chan->center_freq : 0;	\
+			__entry->chan_width = (c)->width;				\
+			__entry->center_freq1 = (c)->center_freq1;			\
 			__entry->center_freq2 = (c)->center_freq2;
 #define CHANDEF_PR_FMT	" control:%d MHz width:%d center: %d/%d MHz"
-#define CHANDEF_PR_ARG	__entry->control_freq, __entry->chan_width,		\
+#define CHANDEF_PR_ARG	__entry->control_freq, __entry->chan_width,			\
 			__entry->center_freq1, __entry->center_freq2
 
-#define CHANCTX_ENTRY	CHANDEF_ENTRY						\
-			__field(u8, rx_chains_static)				\
+#define CHANCTX_ENTRY	CHANDEF_ENTRY							\
+			__field(u8, rx_chains_static)					\
 			__field(u8, rx_chains_dynamic)
-#define CHANCTX_ASSIGN	CHANDEF_ASSIGN(&ctx->conf.def)				\
-			__entry->rx_chains_static = ctx->conf.rx_chains_static;	\
+#define CHANCTX_ASSIGN	CHANDEF_ASSIGN(&ctx->conf.def)					\
+			__entry->rx_chains_static = ctx->conf.rx_chains_static;		\
 			__entry->rx_chains_dynamic = ctx->conf.rx_chains_dynamic
 #define CHANCTX_PR_FMT	CHANDEF_PR_FMT " chains:%d/%d"
-#define CHANCTX_PR_ARG	CHANDEF_PR_ARG,						\
+#define CHANCTX_PR_ARG	CHANDEF_PR_ARG,							\
 			__entry->rx_chains_static, __entry->rx_chains_dynamic
 
 
@@ -286,8 +286,7 @@ TRACE_EVENT(drv_config,
 		__field(u16, listen_interval)
 		__field(u8, long_frame_max_tx_count)
 		__field(u8, short_frame_max_tx_count)
-		__field(int, center_freq)
-		__field(int, channel_type)
+		CHANDEF_ENTRY
 		__field(int, smps)
 	),
 
@@ -303,15 +302,13 @@ TRACE_EVENT(drv_config,
 			local->hw.conf.long_frame_max_tx_count;
 		__entry->short_frame_max_tx_count =
 			local->hw.conf.short_frame_max_tx_count;
-		__entry->center_freq = local->hw.conf.channel ?
-					local->hw.conf.channel->center_freq : 0;
-		__entry->channel_type = local->hw.conf.channel_type;
+		CHANDEF_ASSIGN(&local->hw.conf.chandef)
 		__entry->smps = local->hw.conf.smps_mode;
 	),
 
 	TP_printk(
-		LOCAL_PR_FMT " ch:%#x freq:%d",
-		LOCAL_PR_ARG, __entry->changed, __entry->center_freq
+		LOCAL_PR_FMT " ch:%#x" CHANDEF_PR_FMT,
+		LOCAL_PR_ARG, __entry->changed, CHANDEF_PR_ARG
 	)
 );
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 2a6ae80..38ffa1c 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1709,7 +1709,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	if (chanctx_conf)
 		chan = chanctx_conf->def.chan;
 	else if (!local->use_chanctx)
-		chan = local->_oper_channel;
+		chan = local->_oper_chandef.chan;
 	else
 		goto fail_rcu;
 
@@ -1843,7 +1843,7 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 		 * This is the exception! WDS style interfaces are prohibited
 		 * when channel contexts are in used so this must be valid
 		 */
-		band = local->hw.conf.channel->band;
+		band = local->hw.conf.chandef.chan->band;
 		break;
 #ifdef CONFIG_MAC80211_MESH
 	case NL80211_IFTYPE_MESH_POINT:
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 90cc2b8..1734cd2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2171,8 +2171,7 @@ void ieee80211_dfs_radar_detected_work(struct work_struct *work)
 		/* currently not handled */
 		WARN_ON(1);
 	else {
-		cfg80211_chandef_create(&chandef, local->hw.conf.channel,
-					local->hw.conf.channel_type);
+		chandef = local->hw.conf.chandef;
 		cfg80211_radar_event(local->hw.wiphy, &chandef, GFP_KERNEL);
 	}
 }
-- 
1.7.10.GIT

