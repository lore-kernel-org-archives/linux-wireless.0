Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50221 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758283Ab2CTOkI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 10:40:08 -0400
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 19 Mar 2012 10:23:45 +0100
Subject: [RFC 05/12] mac80211: split channel state
To: <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <eaebc457-48ae-45c9-935f-0adfe286275e@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_154017_669317_C1030448)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We split channel state to a separate structure. This makes it easier to
wrap functions around channel operations alone without worrying whether
it's comming from ieee80211_local or ieee80211_sub_if_data.

Later a function: ieee80211_get_channel_state(local, sdata) would be
introduced to proxy access to appropriate ieee80211_channel_state
structure.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/adm8211.c                     |    2 +-
 drivers/net/wireless/at76c50x-usb.c                |    4 +-
 drivers/net/wireless/ath/ath5k/base.c              |    2 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c      |    4 +-
 drivers/net/wireless/ath/ath9k/ani.c               |    4 +-
 drivers/net/wireless/ath/ath9k/beacon.c            |    2 +-
 drivers/net/wireless/ath/ath9k/calib.c             |    2 +-
 drivers/net/wireless/ath/ath9k/common.c            |    4 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c      |   14 +++---
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |    8 ++--
 drivers/net/wireless/ath/ath9k/hw.c                |    4 +-
 drivers/net/wireless/ath/ath9k/main.c              |   10 ++--
 drivers/net/wireless/ath/ath9k/rc.c                |    6 +-
 drivers/net/wireless/ath/ath9k/recv.c              |    6 +-
 drivers/net/wireless/ath/carl9170/debug.c          |    4 +-
 drivers/net/wireless/ath/carl9170/mac.c            |    8 ++--
 drivers/net/wireless/ath/carl9170/main.c           |    6 +-
 drivers/net/wireless/ath/carl9170/phy.c            |    4 +-
 drivers/net/wireless/b43/b43.h                     |    2 +-
 drivers/net/wireless/b43/main.c                    |    8 ++--
 drivers/net/wireless/b43/phy_ht.c                  |    4 +-
 drivers/net/wireless/b43/phy_lcn.c                 |    4 +-
 drivers/net/wireless/b43/phy_n.c                   |    4 +-
 drivers/net/wireless/b43legacy/main.c              |    8 ++--
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |    6 +-
 drivers/net/wireless/iwlegacy/3945-rs.c            |    2 +-
 drivers/net/wireless/iwlegacy/4965-rs.c            |    2 +-
 drivers/net/wireless/iwlegacy/common.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c          |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c        |    2 +-
 drivers/net/wireless/libertas_tf/main.c            |    8 ++--
 drivers/net/wireless/mac80211_hwsim.c              |    8 ++--
 drivers/net/wireless/mwl8k.c                       |   30 +++++-----
 drivers/net/wireless/p54/fwio.c                    |    4 +-
 drivers/net/wireless/p54/main.c                    |    4 +-
 drivers/net/wireless/p54/txrx.c                    |    4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c            |    6 +-
 drivers/net/wireless/rt2x00/rt2x00config.c         |   10 ++--
 drivers/net/wireless/rt2x00/rt61pci.c              |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c              |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/dev.c         |    4 +-
 drivers/net/wireless/rtl818x/rtl8180/grf5101.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/max2820.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/rtl8225.c     |    2 +-
 drivers/net/wireless/rtl818x/rtl8180/sa2400.c      |    2 +-
 drivers/net/wireless/rtl818x/rtl8187/dev.c         |    4 +-
 drivers/net/wireless/rtl818x/rtl8187/rtl8225.c     |    2 +-
 drivers/net/wireless/rtlwifi/base.c                |    4 +-
 drivers/net/wireless/rtlwifi/core.c                |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c       |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c       |    8 ++--
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c       |    4 +-
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c       |    4 +-
 drivers/net/wireless/wl1251/main.c                 |    4 +-
 drivers/net/wireless/wl12xx/main.c                 |   14 +++---
 drivers/net/wireless/zd1211rw/zd_mac.c             |    4 +-
 include/net/mac80211.h                             |   27 ++++++---
 net/mac80211/cfg.c                                 |   54 +++++++++++--------
 net/mac80211/chan.c                                |    8 ++-
 net/mac80211/debugfs.c                             |    5 +-
 net/mac80211/driver-trace.h                        |    4 +-
 net/mac80211/ibss.c                                |   22 +++++---
 net/mac80211/ieee80211_i.h                         |   23 ++++++--
 net/mac80211/iface.c                               |   10 ++--
 net/mac80211/main.c                                |   40 ++++++++------
 net/mac80211/mesh.c                                |   18 ++++---
 net/mac80211/mesh_hwmp.c                           |    3 +-
 net/mac80211/mesh_plink.c                          |    8 ++-
 net/mac80211/mlme.c                                |   55 ++++++++++++--------
 net/mac80211/rate.h                                |    3 +-
 net/mac80211/rc80211_minstrel_ht.c                 |    7 ++-
 net/mac80211/rx.c                                  |    5 +-
 net/mac80211/scan.c                                |    6 ++-
 net/mac80211/tx.c                                  |   15 ++++--
 net/mac80211/util.c                                |   32 ++++++++----
 net/mac80211/work.c                                |   21 ++++----
 76 files changed, 371 insertions(+), 283 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index f5ce562..51ed961 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1293,7 +1293,7 @@ static int adm8211_config(struct ieee80211_hw *dev, u32 changed)
 {
 	struct adm8211_priv *priv = dev->priv;
 	struct ieee80211_conf *conf = &dev->conf;
-	int channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	int channel = ieee80211_frequency_to_channel(conf->chan_conf->channel->center_freq);
 
 	if (channel != priv->channel) {
 		priv->channel = channel;
diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
index 4045e5a..f0aee73 100644
--- a/drivers/net/wireless/at76c50x-usb.c
+++ b/drivers/net/wireless/at76c50x-usb.c
@@ -1973,12 +1973,12 @@ static int at76_config(struct ieee80211_hw *hw, u32 changed)
 	struct at76_priv *priv = hw->priv;
 
 	at76_dbg(DBG_MAC80211, "%s(): channel %d",
-		 __func__, hw->conf.channel->hw_value);
+		 __func__, hw->conf.chan_conf->channel->hw_value);
 	at76_dbg_dump(DBG_MAC80211, priv->bssid, ETH_ALEN, "bssid:");
 
 	mutex_lock(&priv->mtx);
 
-	priv->channel = hw->conf.channel->hw_value;
+	priv->channel = hw->conf.chan_conf->channel->hw_value;
 
 	if (is_valid_ether_addr(priv->bssid))
 		at76_join(priv);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 0e643b0..6dcac46 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2623,7 +2623,7 @@ int ath5k_start(struct ieee80211_hw *hw)
 	 * be followed by initialization of the appropriate bits
 	 * and then setup of the interrupt mask.
 	 */
-	ah->curchan = ah->hw->conf.channel;
+	ah->curchan = ah->hw->conf.chan_conf->channel;
 	ah->imask = AR5K_INT_RXOK
 		| AR5K_INT_RXERR
 		| AR5K_INT_RXEOL
diff --git a/drivers/net/wireless/ath/ath5k/mac80211-ops.c b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
index 5c53299..63fcafc 100644
--- a/drivers/net/wireless/ath/ath5k/mac80211-ops.c
+++ b/drivers/net/wireless/ath/ath5k/mac80211-ops.c
@@ -199,7 +199,7 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 	mutex_lock(&ah->lock);
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		ret = ath5k_chan_set(ah, conf->channel);
+		ret = ath5k_chan_set(ah, conf->chan_conf->channel);
 		if (ret < 0)
 			goto unlock;
 	}
@@ -672,7 +672,7 @@ ath5k_get_survey(struct ieee80211_hw *hw, int idx, struct survey_info *survey)
 
 	memcpy(survey, &ah->survey, sizeof(*survey));
 
-	survey->channel = conf->channel;
+	survey->channel = conf->chan_conf->channel;
 	survey->noise = ah->ah_noise_floor;
 	survey->filled = SURVEY_INFO_NOISE_DBM |
 			SURVEY_INFO_CHANNEL_TIME |
diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index bc56f57..9f7f38f 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -209,7 +209,7 @@ static void ath9k_hw_ani_ofdm_err_trigger_old(struct ath_hw *ah)
 					     aniState->firstepLevel + 1);
 		return;
 	} else {
-		if ((conf->channel->band == IEEE80211_BAND_2GHZ) &&
+		if ((conf->chan_conf->channel->band == IEEE80211_BAND_2GHZ) &&
 		    !conf_is_ht(conf)) {
 			if (!aniState->ofdmWeakSigDetectOff)
 				ath9k_hw_ani_control(ah,
@@ -249,7 +249,7 @@ static void ath9k_hw_ani_cck_err_trigger_old(struct ath_hw *ah)
 			ath9k_hw_ani_control(ah, ATH9K_ANI_FIRSTEP_LEVEL,
 					     aniState->firstepLevel + 1);
 	} else {
-		if ((conf->channel->band == IEEE80211_BAND_2GHZ) &&
+		if ((conf->chan_conf->channel->band == IEEE80211_BAND_2GHZ) &&
 		    !conf_is_ht(conf)) {
 			if (aniState->firstepLevel > 0)
 				ath9k_hw_ani_control(ah,
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 6264182..532b667 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -80,7 +80,7 @@ static void ath_beacon_setup(struct ath_softc *sc, struct ieee80211_vif *vif,
 
 	ath9k_reset_beacon_status(sc);
 
-	sband = &sc->sbands[common->hw->conf.channel->band];
+	sband = &sc->sbands[common->hw->conf.chan_conf->channel->band];
 	rate = sband->bitrates[rateidx].hw_value;
 	if (vif->bss_conf.use_short_preamble)
 		rate |= sband->bitrates[rateidx].hw_value_short;
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 2f4b48e..75f0ec5 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -208,7 +208,7 @@ bool ath9k_hw_reset_calvalid(struct ath_hw *ah)
 		return true;
 
 	ath_dbg(common, CALIBRATE, "Resetting Cal %d state for channel %u\n",
-		currCal->calData->calType, conf->channel->center_freq);
+		currCal->calData->calType, conf->chan_conf->channel->center_freq);
 
 	ah->caldata->CalValid &= ~currCal->calData->calType;
 	currCal->calState = CAL_WAITING;
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 905f1b3..d822d05 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -133,13 +133,13 @@ EXPORT_SYMBOL(ath9k_cmn_update_ichannel);
 struct ath9k_channel *ath9k_cmn_get_curchannel(struct ieee80211_hw *hw,
 					       struct ath_hw *ah)
 {
-	struct ieee80211_channel *curchan = hw->conf.channel;
+	struct ieee80211_channel *curchan = hw->conf.chan_conf->channel;
 	struct ath9k_channel *channel;
 	u8 chan_idx;
 
 	chan_idx = curchan->hw_value;
 	channel = &ah->channels[chan_idx];
-	ath9k_cmn_update_ichannel(channel, curchan, hw->conf.channel_type);
+	ath9k_cmn_update_ichannel(channel, curchan, hw->conf.chan_conf->channel_type);
 
 	return channel;
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 2b8f61c..d66ae61 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -183,7 +183,7 @@ void ath9k_htc_reset(struct ath9k_htc_priv *priv)
 {
 	struct ath_hw *ah = priv->ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_channel *channel = priv->hw->conf.channel;
+	struct ieee80211_channel *channel = priv->hw->conf.chan_conf->channel;
 	struct ath9k_hw_cal_data *caldata = NULL;
 	enum htc_phymode mode;
 	__be16 htc_mode;
@@ -243,7 +243,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &common->hw->conf;
 	bool fastcc;
-	struct ieee80211_channel *channel = hw->conf.channel;
+	struct ieee80211_channel *channel = hw->conf.chan_conf->channel;
 	struct ath9k_hw_cal_data *caldata = NULL;
 	enum htc_phymode mode;
 	__be16 htc_mode;
@@ -599,7 +599,7 @@ static void ath9k_htc_setup_rate(struct ath9k_htc_priv *priv,
 	u32 caps = 0;
 	int i, j;
 
-	sband = priv->hw->wiphy->bands[priv->hw->conf.channel->band];
+	sband = priv->hw->wiphy->bands[priv->hw->conf.chan_conf->channel->band];
 
 	for (i = 0, j = 0; i < sband->n_bitrates; i++) {
 		if (sta->supp_rates[sband->band] & BIT(i)) {
@@ -899,7 +899,7 @@ static int ath9k_htc_start(struct ieee80211_hw *hw)
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath_hw *ah = priv->ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_channel *curchan = hw->conf.channel;
+	struct ieee80211_channel *curchan = hw->conf.chan_conf->channel;
 	struct ath9k_channel *init_channel;
 	int ret = 0;
 	enum htc_phymode mode;
@@ -1211,15 +1211,15 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		struct ieee80211_channel *curchan = hw->conf.channel;
+		struct ieee80211_channel *curchan = hw->conf.chan_conf->channel;
 		int pos = curchan->hw_value;
 
 		ath_dbg(common, CONFIG, "Set channel: %d MHz\n",
 			curchan->center_freq);
 
 		ath9k_cmn_update_ichannel(&priv->ah->channels[pos],
-					  hw->conf.channel,
-					  hw->conf.channel_type);
+					  hw->conf.chan_conf->channel,
+					  hw->conf.chan_conf->channel_type);
 
 		if (ath9k_htc_set_channel(priv, hw, &priv->ah->channels[pos]) < 0) {
 			ath_err(common, "Unable to set channel\n");
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 3e40a64..b1e106f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -490,7 +490,7 @@ static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
 		if (txs->ts_flags & ATH9K_HTC_TXSTAT_SGI)
 			rate->flags |= IEEE80211_TX_RC_SHORT_GI;
 	} else {
-		if (cur_conf->channel->band == IEEE80211_BAND_5GHZ)
+		if (cur_conf->chan_conf->channel->band == IEEE80211_BAND_5GHZ)
 			rate->idx += 4; /* No CCK rates */
 	}
 
@@ -939,7 +939,7 @@ static void ath9k_process_rate(struct ieee80211_hw *hw,
 		return;
 	}
 
-	band = hw->conf.channel->band;
+	band = hw->conf.chan_conf->channel->band;
 	sband = hw->wiphy->bands[band];
 
 	for (i = 0; i < sband->n_bitrates; i++) {
@@ -1078,8 +1078,8 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 		priv->ah->stats.avgbrssi = rxbuf->rxstatus.rs_rssi;
 
 	rx_status->mactime = be64_to_cpu(rxbuf->rxstatus.rs_tstamp);
-	rx_status->band = hw->conf.channel->band;
-	rx_status->freq = hw->conf.channel->center_freq;
+	rx_status->band = hw->conf.chan_conf->channel->band;
+	rx_status->freq = hw->conf.chan_conf->channel->center_freq;
 	rx_status->signal =  rxbuf->rxstatus.rs_rssi + ATH_DEFAULT_NOISE_FLOOR;
 	rx_status->antenna = rxbuf->rxstatus.rs_antenna;
 	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 3022c4e..b42e61b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -94,7 +94,7 @@ static void ath9k_hw_set_clockrate(struct ath_hw *ah)
 		clockrate = 117;
 	else if (!ah->curchan) /* should really check for CCK instead */
 		clockrate = ATH9K_CLOCK_RATE_CCK;
-	else if (conf->channel->band == IEEE80211_BAND_2GHZ)
+	else if (conf->chan_conf->channel->band == IEEE80211_BAND_2GHZ)
 		clockrate = ATH9K_CLOCK_RATE_2GHZ_OFDM;
 	else if (ah->caps.hw_caps & ATH9K_HW_CAP_FASTCLOCK)
 		clockrate = ATH9K_CLOCK_FAST_RATE_5GHZ_OFDM;
@@ -1041,7 +1041,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	 * BA frames in some implementations, but it has been found to fix ACK
 	 * timeout issues in other cases as well.
 	 */
-	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ) {
+	if (conf->chan_conf->channel && conf->chan_conf->channel->band == IEEE80211_BAND_2GHZ) {
 		acktimeout += 64 - sifstime - ah->slottime;
 		ctstimeout += 48 - sifstime - ah->slottime;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3879485..4a324b7 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -409,7 +409,7 @@ static bool ath_paprd_send_frame(struct ath_softc *sc, struct sk_buff *skb, int
 	txctl.txq = sc->tx.txq_map[WME_AC_BE];
 
 	memset(tx_info, 0, sizeof(*tx_info));
-	tx_info->band = hw->conf.channel->band;
+	tx_info->band = hw->conf.chan_conf->channel->band;
 	tx_info->flags |= IEEE80211_TX_CTL_NO_ACK;
 	tx_info->control.rates[0].idx = 0;
 	tx_info->control.rates[0].count = 1;
@@ -983,7 +983,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	struct ieee80211_channel *curchan = hw->conf.channel;
+	struct ieee80211_channel *curchan = hw->conf.chan_conf->channel;
 	struct ath9k_channel *init_channel;
 	int r;
 
@@ -1587,7 +1587,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		struct ieee80211_channel *curchan = hw->conf.channel;
+		struct ieee80211_channel *curchan = hw->conf.chan_conf->channel;
 		int pos = curchan->hw_value;
 		int old_pos = -1;
 		unsigned long flags;
@@ -1601,7 +1601,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			sc->sc_flags &= ~SC_OP_OFFCHANNEL;
 
 		ath_dbg(common, CONFIG, "Set channel: %d MHz type: %d\n",
-			curchan->center_freq, conf->channel_type);
+			curchan->center_freq, conf->chan_conf->channel_type);
 
 		/* update survey stats for the old channel before switching */
 		spin_lock_irqsave(&common->cc_lock, flags);
@@ -1616,7 +1616,7 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 			ath9k_hw_getnf(ah, ah->curchan);
 
 		ath9k_cmn_update_ichannel(&sc->sc_ah->channels[pos],
-					  curchan, conf->channel_type);
+					  curchan, conf->chan_conf->channel_type);
 
 		/*
 		 * If the operating channel changes, change the survey in-use flags
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 4f84849..b1c58f0 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -740,7 +740,7 @@ static void ath_rc_rate_set_rtscts(struct ath_softc *sc,
 
 	/* All protection frames are transmited at 2Mb/s for 802.11g,
 	 * otherwise we transmit them at 1Mb/s */
-	if (sc->hw->conf.channel->band == IEEE80211_BAND_2GHZ &&
+	if (sc->hw->conf.chan_conf->channel->band == IEEE80211_BAND_2GHZ &&
 	    !conf_is_ht(&sc->hw->conf))
 		enable_g_protection = 1;
 
@@ -868,7 +868,7 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	 * So, set fourth rate in series to be same as third one for
 	 * above conditions.
 	 */
-	if ((sc->hw->conf.channel->band == IEEE80211_BAND_2GHZ) &&
+	if ((sc->hw->conf.chan_conf->channel->band == IEEE80211_BAND_2GHZ) &&
 	    (conf_is_ht(&sc->hw->conf))) {
 		u8 dot11rate = rate_table->info[rix].dot11rate;
 		u8 phy = rate_table->info[rix].phy;
@@ -1473,7 +1473,7 @@ static void ath_rate_update(void *priv, struct ieee80211_supported_band *sband,
 
 			ath_dbg(ath9k_hw_common(sc->sc_ah), CONFIG,
 				"Operating HT Bandwidth changed to: %d\n",
-				sc->hw->conf.channel_type);
+				sc->hw->conf.chan_conf->channel_type);
 		}
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index f4ae3ba..0420df4 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -903,7 +903,7 @@ static int ath9k_process_rate(struct ath_common *common,
 	enum ieee80211_band band;
 	unsigned int i = 0;
 
-	band = hw->conf.channel->band;
+	band = hw->conf.chan_conf->channel->band;
 	sband = hw->wiphy->bands[band];
 
 	if (rx_stats->rs_rate & 0x80) {
@@ -998,8 +998,8 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 	if (ath9k_process_rate(common, hw, rx_stats, rx_status))
 		return -EINVAL;
 
-	rx_status->band = hw->conf.channel->band;
-	rx_status->freq = hw->conf.channel->center_freq;
+	rx_status->band = hw->conf.chan_conf->channel->band;
+	rx_status->freq = hw->conf.chan_conf->channel->center_freq;
 	rx_status->signal = ah->noise + rx_stats->rs_rssi;
 	rx_status->antenna = rx_stats->rs_antenna;
 	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index 3c16422..43dd22c 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -659,8 +659,8 @@ static ssize_t carl9170_debugfs_bug_write(struct ar9170 *ar, const char *buf,
 		goto out;
 
 	case 'P':
-		err = carl9170_set_channel(ar, ar->hw->conf.channel,
-			ar->hw->conf.channel_type, CARL9170_RFI_COLD);
+		err = carl9170_set_channel(ar, ar->hw->conf.chan_conf->channel,
+			ar->hw->conf.chan_conf->channel_type, CARL9170_RFI_COLD);
 		if (err < 0)
 			count = err;
 
diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
index 53415bf..91f6bfa 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -48,7 +48,7 @@ int carl9170_set_dyn_sifs_ack(struct ar9170 *ar)
 	if (conf_is_ht40(&ar->hw->conf))
 		val = 0x010a;
 	else {
-		if (ar->hw->conf.channel->band == IEEE80211_BAND_2GHZ)
+		if (ar->hw->conf.chan_conf->channel->band == IEEE80211_BAND_2GHZ)
 			val = 0x105;
 		else
 			val = 0x104;
@@ -66,7 +66,7 @@ int carl9170_set_rts_cts_rate(struct ar9170 *ar)
 		rts_rate = 0x1da;
 		cts_rate = 0x10a;
 	} else {
-		if (ar->hw->conf.channel->band == IEEE80211_BAND_2GHZ) {
+		if (ar->hw->conf.chan_conf->channel->band == IEEE80211_BAND_2GHZ) {
 			/* 11 mbit CCK */
 			rts_rate = 033;
 			cts_rate = 003;
@@ -93,7 +93,7 @@ int carl9170_set_slot_time(struct ar9170 *ar)
 		return 0;
 	}
 
-	if ((ar->hw->conf.channel->band == IEEE80211_BAND_5GHZ) ||
+	if ((ar->hw->conf.chan_conf->channel->band == IEEE80211_BAND_5GHZ) ||
 	    vif->bss_conf.use_short_slot)
 		slottime = 9;
 
@@ -120,7 +120,7 @@ int carl9170_set_mac_rates(struct ar9170 *ar)
 	basic |= (vif->bss_conf.basic_rates & 0xff0) << 4;
 	rcu_read_unlock();
 
-	if (ar->hw->conf.channel->band == IEEE80211_BAND_5GHZ)
+	if (ar->hw->conf.chan_conf->channel->band == IEEE80211_BAND_5GHZ)
 		mandatory = 0xff00; /* OFDM 6/9/12/18/24/36/48/54 */
 	else
 		mandatory = 0xff0f; /* OFDM (6/9../54) + CCK (1/2/5.5/11) */
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 8d2523b..25133a9 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -868,8 +868,8 @@ static int carl9170_op_config(struct ieee80211_hw *hw, u32 changed)
 		if (err)
 			goto out;
 
-		err = carl9170_set_channel(ar, hw->conf.channel,
-			hw->conf.channel_type, CARL9170_RFI_NONE);
+		err = carl9170_set_channel(ar, hw->conf.chan_conf->channel,
+			hw->conf.chan_conf->channel_type, CARL9170_RFI_NONE);
 		if (err)
 			goto out;
 
@@ -887,7 +887,7 @@ static int carl9170_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		err = carl9170_set_mac_tpc(ar, ar->hw->conf.channel);
+		err = carl9170_set_mac_tpc(ar, ar->hw->conf.chan_conf->channel);
 		if (err)
 			goto out;
 	}
diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index b72c09c..976ec51 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1331,7 +1331,7 @@ static void carl9170_calc_ctl(struct ar9170 *ar, u32 freq, enum carl9170_bw bw)
 	 * CTL_ETSI for 2GHz and CTL_FCC for 5GHz.
 	 */
 	ctl_grp = ath_regd_get_band_ctl(&ar->common.regulatory,
-					ar->hw->conf.channel->band);
+					ar->hw->conf.chan_conf->channel->band);
 
 	/* ctl group not found - either invalid band (NO_CTL) or ww roaming */
 	if (ctl_grp == NO_CTL || ctl_grp == SD_NO_CTL)
@@ -1341,7 +1341,7 @@ static void carl9170_calc_ctl(struct ar9170 *ar, u32 freq, enum carl9170_bw bw)
 		/* skip CTL and heavy clip for CTL_MKK and CTL_ETSI */
 		return;
 
-	if (ar->hw->conf.channel->band == IEEE80211_BAND_2GHZ) {
+	if (ar->hw->conf.chan_conf->channel->band == IEEE80211_BAND_2GHZ) {
 		modes = mode_list_2ghz;
 		nr_modes = ARRAY_SIZE(mode_list_2ghz);
 	} else {
diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 67c13af..cdc54e2 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -966,7 +966,7 @@ static inline int b43_is_mode(struct b43_wl *wl, int type)
  */
 static inline enum ieee80211_band b43_current_band(struct b43_wl *wl)
 {
-	return wl->hw->conf.channel->band;
+	return wl->hw->conf.chan_conf->channel->band;
 }
 
 static inline int b43_bus_may_powerdown(struct b43_wldev *wldev)
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index c79e663..afc2c02 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3815,7 +3815,7 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 	dev = wl->current_dev;
 
 	/* Switch the band (if necessary). This might change the active core. */
-	err = b43_switch_band(wl, conf->channel);
+	err = b43_switch_band(wl, conf->chan_conf->channel);
 	if (err)
 		goto out_unlock_mutex;
 
@@ -3845,8 +3845,8 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	/* Switch to the requested channel.
 	 * The firmware takes care of races with the TX handler. */
-	if (conf->channel->hw_value != phy->channel)
-		b43_switch_channel(dev, conf->channel->hw_value);
+	if (conf->chan_conf->channel->hw_value != phy->channel)
+		b43_switch_channel(dev, conf->chan_conf->channel->hw_value);
 
 	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_MONITOR);
 
@@ -4917,7 +4917,7 @@ static int b43_op_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
 
-	survey->channel = conf->channel;
+	survey->channel = conf->chan_conf->channel;
 	survey->filled = SURVEY_INFO_NOISE_DBM;
 	survey->noise = dev->stats.link_noise;
 
diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 7416c5e..3f48cc7 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -525,8 +525,8 @@ static void b43_phy_ht_op_switch_analog(struct b43_wldev *dev, bool on)
 static int b43_phy_ht_op_switch_channel(struct b43_wldev *dev,
 					unsigned int new_channel)
 {
-	struct ieee80211_channel *channel = dev->wl->hw->conf.channel;
-	enum nl80211_channel_type channel_type = dev->wl->hw->conf.channel_type;
+	struct ieee80211_channel *channel = dev->wl->hw->conf.chan_conf->channel;
+	enum nl80211_channel_type channel_type = dev->wl->hw->conf.chan_conf->channel_type;
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
 		if ((new_channel < 1) || (new_channel > 14))
diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index a13e28e..6d8df04 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -808,8 +808,8 @@ static void b43_phy_lcn_op_switch_analog(struct b43_wldev *dev, bool on)
 static int b43_phy_lcn_op_switch_channel(struct b43_wldev *dev,
 					unsigned int new_channel)
 {
-	struct ieee80211_channel *channel = dev->wl->hw->conf.channel;
-	enum nl80211_channel_type channel_type = dev->wl->hw->conf.channel_type;
+	struct ieee80211_channel *channel = dev->wl->hw->conf.chan_conf->channel;
+	enum nl80211_channel_type channel_type = dev->wl->hw->conf.chan_conf->channel_type;
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
 		if ((new_channel < 1) || (new_channel > 14))
diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 1081188..d753578 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -4939,8 +4939,8 @@ static void b43_nphy_op_switch_analog(struct b43_wldev *dev, bool on)
 static int b43_nphy_op_switch_channel(struct b43_wldev *dev,
 				      unsigned int new_channel)
 {
-	struct ieee80211_channel *channel = dev->wl->hw->conf.channel;
-	enum nl80211_channel_type channel_type = dev->wl->hw->conf.channel_type;
+	struct ieee80211_channel *channel = dev->wl->hw->conf.chan_conf->channel;
+	enum nl80211_channel_type channel_type = dev->wl->hw->conf.chan_conf->channel_type;
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
 		if ((new_channel < 1) || (new_channel > 14))
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index df7e16d..be95ae5 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2694,7 +2694,7 @@ static int b43legacy_op_dev_config(struct ieee80211_hw *hw,
 		goto out_unlock_mutex;
 
 	/* Switch the PHY mode (if necessary). */
-	switch (conf->channel->band) {
+	switch (conf->chan_conf->channel->band) {
 	case IEEE80211_BAND_2GHZ:
 		if (phy->type == B43legacy_PHYTYPE_B)
 			new_phymode = B43legacy_PHYMODE_B;
@@ -2722,8 +2722,8 @@ static int b43legacy_op_dev_config(struct ieee80211_hw *hw,
 
 	/* Switch to the requested channel.
 	 * The firmware takes care of races with the TX handler. */
-	if (conf->channel->hw_value != phy->channel)
-		b43legacy_radio_selectchannel(dev, conf->channel->hw_value, 0);
+	if (conf->chan_conf->channel->hw_value != phy->channel)
+		b43legacy_radio_selectchannel(dev, conf->chan_conf->channel->hw_value, 0);
 
 	dev->wl->radiotap_enabled = !!(conf->flags & IEEE80211_CONF_MONITOR);
 
@@ -3532,7 +3532,7 @@ static int b43legacy_op_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
 
-	survey->channel = conf->channel;
+	survey->channel = conf->chan_conf->channel;
 	survey->filled = SURVEY_INFO_NOISE_DBM;
 	survey->noise = dev->stats.link_noise;
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 569ab8a..7bb81fe 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -394,10 +394,10 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 				  new_int);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		if (conf->channel_type == NL80211_CHAN_HT20 ||
-		    conf->channel_type == NL80211_CHAN_NO_HT)
+		if (conf->chan_conf->channel_type == NL80211_CHAN_HT20 ||
+		    conf->chan_conf->channel_type == NL80211_CHAN_NO_HT)
 			err = brcms_c_set_channel(wl->wlc,
-						  conf->channel->hw_value);
+						  conf->chan_conf->channel->hw_value);
 		else
 			err = -ENOTSUPP;
 	}
diff --git a/drivers/net/wireless/iwlegacy/3945-rs.c b/drivers/net/wireless/iwlegacy/3945-rs.c
index 70bee1a..768e7b4 100644
--- a/drivers/net/wireless/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -347,7 +347,7 @@ il3945_rs_rate_init(struct il_priv *il, struct ieee80211_sta *sta, u8 sta_id)
 
 	psta = (struct il3945_sta_priv *)sta->drv_priv;
 	rs_sta = &psta->rs_sta;
-	sband = hw->wiphy->bands[conf->channel->band];
+	sband = hw->wiphy->bands[conf->chan_conf->channel->band];
 
 	rs_sta->il = il;
 
diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index d7e2856..f8921fa 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -2300,7 +2300,7 @@ il4965_rs_rate_init(struct il_priv *il, struct ieee80211_sta *sta, u8 sta_id)
 
 	sta_priv = (struct il_station_priv *)sta->drv_priv;
 	lq_sta = &sta_priv->lq_sta;
-	sband = hw->wiphy->bands[conf->channel->band];
+	sband = hw->wiphy->bands[conf->chan_conf->channel->band];
 
 	lq_sta->lq.sta_id = sta_id;
 
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index e5ac047..c2d73c9 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4943,7 +4943,7 @@ il_mac_config(struct ieee80211_hw *hw, u32 changed)
 	struct il_priv *il = hw->priv;
 	const struct il_channel_info *ch_info;
 	struct ieee80211_conf *conf = &hw->conf;
-	struct ieee80211_channel *channel = conf->channel;
+	struct ieee80211_channel *channel = conf->chan_conf->channel;
 	struct il_ht_config *ht_conf = &il->current_ht_config;
 	unsigned long flags = 0;
 	int ret = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 53f8c51..2b3d16d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -2829,7 +2829,7 @@ void iwl_rs_rate_init(struct iwl_priv *priv, struct ieee80211_sta *sta, u8 sta_i
 
 	sta_priv = (struct iwl_station_priv *) sta->drv_priv;
 	lq_sta = &sta_priv->lq_sta;
-	sband = hw->wiphy->bands[conf->channel->band];
+	sband = hw->wiphy->bands[conf->chan_conf->channel->band];
 
 
 	lq_sta->lq.sta_id = sta_id;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 2e1a317..ce575d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -543,7 +543,7 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
 	struct iwl_rxon_context *ctx;
 	struct ieee80211_conf *conf = &hw->conf;
-	struct ieee80211_channel *channel = conf->channel;
+	struct ieee80211_channel *channel = conf->chan_conf->channel;
 	const struct iwl_channel_info *ch_info;
 	int ret = 0;
 
diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
index a034572..3e629e1 100644
--- a/drivers/net/wireless/libertas_tf/main.c
+++ b/drivers/net/wireless/libertas_tf/main.c
@@ -410,9 +410,9 @@ static int lbtf_op_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 	lbtf_deb_enter(LBTF_DEB_MACOPS);
 
-	if (conf->channel->center_freq != priv->cur_freq) {
-		priv->cur_freq = conf->channel->center_freq;
-		lbtf_set_channel(priv, conf->channel->hw_value);
+	if (conf->chan_conf->channel->center_freq != priv->cur_freq) {
+		priv->cur_freq = conf->chan_conf->channel->center_freq;
+		lbtf_set_channel(priv, conf->chan_conf->channel->hw_value);
 	}
 	lbtf_deb_leave(LBTF_DEB_MACOPS);
 	return 0;
@@ -535,7 +535,7 @@ static int lbtf_op_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
 
-	survey->channel = conf->channel;
+	survey->channel = conf->chan_conf->channel;
 	survey->filled = SURVEY_INFO_NOISE_DBM;
 	survey->noise = priv->noise;
 
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index b7ce6a6..6741028 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -870,15 +870,15 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 	wiphy_debug(hw->wiphy,
 		    "%s (freq=%d/%s idle=%d ps=%d smps=%s)\n",
 		    __func__,
-		    conf->channel->center_freq,
-		    hwsim_chantypes[conf->channel_type],
+		    conf->chan_conf->channel->center_freq,
+		    hwsim_chantypes[conf->chan_conf->channel_type],
 		    !!(conf->flags & IEEE80211_CONF_IDLE),
 		    !!(conf->flags & IEEE80211_CONF_PS),
 		    smps_modes[conf->smps_mode]);
 
 	data->idle = !!(conf->flags & IEEE80211_CONF_IDLE);
 
-	data->channel = conf->channel;
+	data->channel = conf->chan_conf->channel;
 	data->power_level = conf->power_level;
 	if (!data->started || !data->beacon_int)
 		del_timer(&data->beacon_timer);
@@ -1038,7 +1038,7 @@ static int mac80211_hwsim_get_survey(
 		return -ENOENT;
 
 	/* Current channel */
-	survey->channel = conf->channel;
+	survey->channel = conf->chan_conf->channel;
 
 	/*
 	 * Magically conjured noise level --- this is only ok for simulated hardware.
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index ac7c983..216c6e0 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -2760,7 +2760,7 @@ static int mwl8k_cmd_tx_power(struct ieee80211_hw *hw,
 				     struct ieee80211_conf *conf,
 				     unsigned short pwr)
 {
-	struct ieee80211_channel *channel = conf->channel;
+	struct ieee80211_channel *channel = conf->chan_conf->channel;
 	struct mwl8k_cmd_tx_power *cmd;
 	int rc;
 	int i;
@@ -2780,14 +2780,14 @@ static int mwl8k_cmd_tx_power(struct ieee80211_hw *hw,
 
 	cmd->channel = cpu_to_le16(channel->hw_value);
 
-	if (conf->channel_type == NL80211_CHAN_NO_HT ||
-	    conf->channel_type == NL80211_CHAN_HT20) {
+	if (conf->chan_conf->channel_type == NL80211_CHAN_NO_HT ||
+	    conf->chan_conf->channel_type == NL80211_CHAN_HT20) {
 		cmd->bw = cpu_to_le16(0x2);
 	} else {
 		cmd->bw = cpu_to_le16(0x4);
-		if (conf->channel_type == NL80211_CHAN_HT40MINUS)
+		if (conf->chan_conf->channel_type == NL80211_CHAN_HT40MINUS)
 			cmd->sub_ch = cpu_to_le16(0x3);
-		else if (conf->channel_type == NL80211_CHAN_HT40PLUS)
+		else if (conf->chan_conf->channel_type == NL80211_CHAN_HT40PLUS)
 			cmd->sub_ch = cpu_to_le16(0x1);
 	}
 
@@ -2931,7 +2931,7 @@ struct mwl8k_cmd_set_rf_channel {
 static int mwl8k_cmd_set_rf_channel(struct ieee80211_hw *hw,
 				    struct ieee80211_conf *conf)
 {
-	struct ieee80211_channel *channel = conf->channel;
+	struct ieee80211_channel *channel = conf->chan_conf->channel;
 	struct mwl8k_cmd_set_rf_channel *cmd;
 	int rc;
 
@@ -2949,12 +2949,12 @@ static int mwl8k_cmd_set_rf_channel(struct ieee80211_hw *hw,
 	else if (channel->band == IEEE80211_BAND_5GHZ)
 		cmd->channel_flags |= cpu_to_le32(0x00000004);
 
-	if (conf->channel_type == NL80211_CHAN_NO_HT ||
-	    conf->channel_type == NL80211_CHAN_HT20)
+	if (conf->chan_conf->channel_type == NL80211_CHAN_NO_HT ||
+	    conf->chan_conf->channel_type == NL80211_CHAN_HT20)
 		cmd->channel_flags |= cpu_to_le32(0x00000080);
-	else if (conf->channel_type == NL80211_CHAN_HT40MINUS)
+	else if (conf->chan_conf->channel_type == NL80211_CHAN_HT40MINUS)
 		cmd->channel_flags |= cpu_to_le32(0x000001900);
-	else if (conf->channel_type == NL80211_CHAN_HT40PLUS)
+	else if (conf->chan_conf->channel_type == NL80211_CHAN_HT40PLUS)
 		cmd->channel_flags |= cpu_to_le32(0x000000900);
 
 	rc = mwl8k_post_cmd(hw, &cmd->header);
@@ -3818,7 +3818,7 @@ static int mwl8k_cmd_set_new_stn_add(struct ieee80211_hw *hw,
 	memcpy(cmd->mac_addr, sta->addr, ETH_ALEN);
 	cmd->stn_id = cpu_to_le16(sta->aid);
 	cmd->action = cpu_to_le16(MWL8K_STA_ACTION_ADD);
-	if (hw->conf.channel->band == IEEE80211_BAND_2GHZ)
+	if (hw->conf.chan_conf->channel->band == IEEE80211_BAND_2GHZ)
 		rates = sta->supp_rates[IEEE80211_BAND_2GHZ];
 	else
 		rates = sta->supp_rates[IEEE80211_BAND_5GHZ] << 5;
@@ -4229,7 +4229,7 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
 	p->ht_caps = cpu_to_le16(sta->ht_cap.cap);
 	p->extended_ht_caps = (sta->ht_cap.ampdu_factor & 3) |
 		((sta->ht_cap.ampdu_density & 7) << 2);
-	if (hw->conf.channel->band == IEEE80211_BAND_2GHZ)
+	if (hw->conf.chan_conf->channel->band == IEEE80211_BAND_2GHZ)
 		rates = sta->supp_rates[IEEE80211_BAND_2GHZ];
 	else
 		rates = sta->supp_rates[IEEE80211_BAND_5GHZ] << 5;
@@ -4700,7 +4700,7 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			goto out;
 		}
 
-		if (hw->conf.channel->band == IEEE80211_BAND_2GHZ) {
+		if (hw->conf.chan_conf->channel->band == IEEE80211_BAND_2GHZ) {
 			ap_legacy_rates = ap->supp_rates[IEEE80211_BAND_2GHZ];
 		} else {
 			ap_legacy_rates =
@@ -4785,7 +4785,7 @@ mwl8k_bss_info_changed_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		if (idx)
 			idx--;
 
-		if (hw->conf.channel->band == IEEE80211_BAND_2GHZ)
+		if (hw->conf.chan_conf->channel->band == IEEE80211_BAND_2GHZ)
 			rate = mwl8k_rates_24[idx].hw_value;
 		else
 			rate = mwl8k_rates_50[idx].hw_value;
@@ -5060,7 +5060,7 @@ static int mwl8k_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
 
-	survey->channel = conf->channel;
+	survey->channel = conf->chan_conf->channel;
 	survey->filled = SURVEY_INFO_NOISE_DBM;
 	survey->noise = priv->noise;
 
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 18e82b3..533ad8b 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -402,7 +402,7 @@ int p54_scan(struct p54_common *priv, u16 mode, u16 dwell)
 	struct p54_rssi_db_entry *rssi_data;
 	unsigned int i;
 	void *entry;
-	__le16 freq = cpu_to_le16(priv->hw->conf.channel->center_freq);
+	__le16 freq = cpu_to_le16(priv->hw->conf.chan_conf->channel->center_freq);
 
 	skb = p54_alloc_skb(priv, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*head) +
 			    2 + sizeof(*iq_autocal) + sizeof(*body) +
@@ -532,7 +532,7 @@ int p54_scan(struct p54_common *priv, u16 mode, u16 dwell)
 err:
 	wiphy_err(priv->hw->wiphy, "frequency change to channel %d failed.\n",
 		  ieee80211_frequency_to_channel(
-			  priv->hw->conf.channel->center_freq));
+			  priv->hw->conf.chan_conf->channel->center_freq));
 
 	dev_kfree_skb_any(skb);
 	return -EINVAL;
diff --git a/drivers/net/wireless/p54/main.c b/drivers/net/wireless/p54/main.c
index ee8af1f..ecb617f 100644
--- a/drivers/net/wireless/p54/main.c
+++ b/drivers/net/wireless/p54/main.c
@@ -339,7 +339,7 @@ static int p54_config(struct ieee80211_hw *dev, u32 changed)
 		 * TODO: Use the LM_SCAN_TRAP to determine the current
 		 * operating channel.
 		 */
-		priv->curchan = priv->hw->conf.channel;
+		priv->curchan = priv->hw->conf.chan_conf->channel;
 		p54_reset_stats(priv);
 		WARN_ON(p54_fetch_statistics(priv));
 	}
@@ -479,7 +479,7 @@ static void p54_bss_info_changed(struct ieee80211_hw *dev,
 		p54_set_edcf(priv);
 	}
 	if (changed & BSS_CHANGED_BASIC_RATES) {
-		if (dev->conf.channel->band == IEEE80211_BAND_5GHZ)
+		if (dev->conf.chan_conf->channel->band == IEEE80211_BAND_5GHZ)
 			priv->basic_rate_mask = (info->basic_rates << 4);
 		else
 			priv->basic_rate_mask = info->basic_rates;
diff --git a/drivers/net/wireless/p54/txrx.c b/drivers/net/wireless/p54/txrx.c
index a08a6f0..4a29b0d 100644
--- a/drivers/net/wireless/p54/txrx.c
+++ b/drivers/net/wireless/p54/txrx.c
@@ -354,13 +354,13 @@ static int p54_rx_data(struct p54_common *priv, struct sk_buff *skb)
 	rx_status->signal = p54_rssi_to_dbm(priv, hdr->rssi);
 	if (hdr->rate & 0x10)
 		rx_status->flag |= RX_FLAG_SHORTPRE;
-	if (priv->hw->conf.channel->band == IEEE80211_BAND_5GHZ)
+	if (priv->hw->conf.chan_conf->channel->band == IEEE80211_BAND_5GHZ)
 		rx_status->rate_idx = (rate < 4) ? 0 : rate - 4;
 	else
 		rx_status->rate_idx = rate;
 
 	rx_status->freq = freq;
-	rx_status->band =  priv->hw->conf.channel->band;
+	rx_status->band =  priv->hw->conf.chan_conf->channel->band;
 	rx_status->antenna = hdr->antenna;
 
 	tsf32 = le32_to_cpu(hdr->tsf32);
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6c0a12e..e5bcf18 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2628,11 +2628,11 @@ void rt2800_config(struct rt2x00_dev *rt2x00dev,
 	if (flags & IEEE80211_CONF_CHANGE_CHANNEL) {
 		rt2800_config_channel(rt2x00dev, libconf->conf,
 				      &libconf->rf, &libconf->channel);
-		rt2800_config_txpower(rt2x00dev, libconf->conf->channel->band,
+		rt2800_config_txpower(rt2x00dev, libconf->conf->chan_conf->channel->band,
 				      libconf->conf->power_level);
 	}
 	if (flags & IEEE80211_CONF_CHANGE_POWER)
-		rt2800_config_txpower(rt2x00dev, libconf->conf->channel->band,
+		rt2800_config_txpower(rt2x00dev, libconf->conf->chan_conf->channel->band,
 				      libconf->conf->power_level);
 	if (flags & IEEE80211_CONF_CHANGE_RETRY_LIMITS)
 		rt2800_config_retry_limit(rt2x00dev, libconf);
@@ -4845,7 +4845,7 @@ int rt2800_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
 
-	survey->channel = conf->channel;
+	survey->channel = conf->chan_conf->channel;
 
 	rt2800_register_read(rt2x00dev, CH_IDLE_STA, &idle);
 	rt2800_register_read(rt2x00dev, CH_BUSY_STA, &busy);
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 293676b..1d0c232 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -184,7 +184,7 @@ static u16 rt2x00ht_center_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Initialize center channel to current channel.
 	 */
-	center_channel = spec->channels[conf->channel->hw_value].channel;
+	center_channel = spec->channels[conf->chan_conf->channel->hw_value].channel;
 
 	/*
 	 * Adjust center channel to HT40+ and HT40- operation.
@@ -199,7 +199,7 @@ static u16 rt2x00ht_center_channel(struct rt2x00_dev *rt2x00dev,
 			return i;
 
 	WARN_ON(1);
-	return conf->channel->hw_value;
+	return conf->chan_conf->channel->hw_value;
 }
 
 void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
@@ -222,7 +222,7 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 			hw_value = rt2x00ht_center_channel(rt2x00dev, conf);
 		} else {
 			clear_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags);
-			hw_value = conf->channel->hw_value;
+			hw_value = conf->chan_conf->channel->hw_value;
 		}
 
 		memcpy(&libconf.rf,
@@ -274,8 +274,8 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	else
 		clear_bit(CONFIG_POWERSAVING, &rt2x00dev->flags);
 
-	rt2x00dev->curr_band = conf->channel->band;
-	rt2x00dev->curr_freq = conf->channel->center_freq;
+	rt2x00dev->curr_band = conf->chan_conf->channel->band;
+	rt2x00dev->curr_freq = conf->chan_conf->channel->center_freq;
 	rt2x00dev->tx_power = conf->power_level;
 	rt2x00dev->short_retry = conf->short_frame_max_tx_count;
 	rt2x00dev->long_retry = conf->long_frame_max_tx_count;
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index e0c6d11..f5121de 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -847,7 +847,7 @@ static void rt61pci_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 	u16 eeprom;
 	short lna_gain = 0;
 
-	if (libconf->conf->channel->band == IEEE80211_BAND_2GHZ) {
+	if (libconf->conf->chan_conf->channel->band == IEEE80211_BAND_2GHZ) {
 		if (test_bit(CAPABILITY_EXTERNAL_LNA_BG, &rt2x00dev->cap_flags))
 			lna_gain += 14;
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index e477a96..b4f3291 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -739,7 +739,7 @@ static void rt73usb_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 	u16 eeprom;
 	short lna_gain = 0;
 
-	if (libconf->conf->channel->band == IEEE80211_BAND_2GHZ) {
+	if (libconf->conf->chan_conf->channel->band == IEEE80211_BAND_2GHZ) {
 		if (test_bit(CAPABILITY_EXTERNAL_LNA_BG, &rt2x00dev->cap_flags))
 			lna_gain += 14;
 
diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 2f14a5f..0502510 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -145,8 +145,8 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 				signal = priv->rf->calc_rssi(agc, sq);
 			}
 			rx_status.signal = signal;
-			rx_status.freq = dev->conf.channel->center_freq;
-			rx_status.band = dev->conf.channel->band;
+			rx_status.freq = dev->conf.chan_conf->channel->center_freq;
+			rx_status.band = dev->conf.chan_conf->channel->band;
 			rx_status.mactime = le64_to_cpu(entry->tsft);
 			rx_status.flag |= RX_FLAG_MACTIME_MPDU;
 			if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
diff --git a/drivers/net/wireless/rtl818x/rtl8180/grf5101.c b/drivers/net/wireless/rtl818x/rtl8180/grf5101.c
index 5ee7589..54e1d5f 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/grf5101.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/grf5101.c
@@ -82,7 +82,7 @@ static void grf5101_rf_set_channel(struct ieee80211_hw *dev,
 				   struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
-	int channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	int channel = ieee80211_frequency_to_channel(conf->chan_conf->channel->center_freq);
 	u32 txpw = priv->channels[channel - 1].hw_value & 0xFF;
 	u32 chan = channel - 1;
 
diff --git a/drivers/net/wireless/rtl818x/rtl8180/max2820.c b/drivers/net/wireless/rtl818x/rtl8180/max2820.c
index 667b336..4a773ab 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/max2820.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/max2820.c
@@ -95,7 +95,7 @@ static void max2820_rf_set_channel(struct ieee80211_hw *dev,
 {
 	struct rtl8180_priv *priv = dev->priv;
 	int channel = conf ?
-		ieee80211_frequency_to_channel(conf->channel->center_freq) : 1;
+		ieee80211_frequency_to_channel(conf->chan_conf->channel->center_freq) : 1;
 	unsigned int chan_idx = channel - 1;
 	u32 txpw = priv->channels[chan_idx].hw_value & 0xFF;
 	u32 chan = max2820_chan[chan_idx];
diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c b/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
index 7c4574b..b24176b 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
@@ -719,7 +719,7 @@ static void rtl8225_rf_set_channel(struct ieee80211_hw *dev,
 				   struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
-	int chan = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	int chan = ieee80211_frequency_to_channel(conf->chan_conf->channel->center_freq);
 
 	if (priv->rf->init == rtl8225_rf_init)
 		rtl8225_rf_set_tx_power(dev, chan);
diff --git a/drivers/net/wireless/rtl818x/rtl8180/sa2400.c b/drivers/net/wireless/rtl818x/rtl8180/sa2400.c
index 44771a6..24ac295 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/sa2400.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/sa2400.c
@@ -105,7 +105,7 @@ static void sa2400_rf_set_channel(struct ieee80211_hw *dev,
 				  struct ieee80211_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
-	int channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	int channel = ieee80211_frequency_to_channel(conf->chan_conf->channel->center_freq);
 	u32 txpw = priv->channels[channel - 1].hw_value & 0xFF;
 	u32 chan = sa2400_chan[channel - 1];
 
diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c b/drivers/net/wireless/rtl818x/rtl8187/dev.c
index cf53ac9..c6e43e7 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -376,8 +376,8 @@ static void rtl8187_rx_cb(struct urb *urb)
 	rate = (flags >> 20) & 0xF;
 	skb_trim(skb, flags & 0x0FFF);
 	rx_status.rate_idx = rate;
-	rx_status.freq = dev->conf.channel->center_freq;
-	rx_status.band = dev->conf.channel->band;
+	rx_status.freq = dev->conf.chan_conf->channel->center_freq;
+	rx_status.band = dev->conf.chan_conf->channel->band;
 	rx_status.flag |= RX_FLAG_MACTIME_MPDU;
 	if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
 		rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
diff --git a/drivers/net/wireless/rtl818x/rtl8187/rtl8225.c b/drivers/net/wireless/rtl818x/rtl8187/rtl8225.c
index 908903f..2828841 100644
--- a/drivers/net/wireless/rtl818x/rtl8187/rtl8225.c
+++ b/drivers/net/wireless/rtl818x/rtl8187/rtl8225.c
@@ -905,7 +905,7 @@ static void rtl8225_rf_set_channel(struct ieee80211_hw *dev,
 				   struct ieee80211_conf *conf)
 {
 	struct rtl8187_priv *priv = dev->priv;
-	int chan = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	int chan = ieee80211_frequency_to_channel(conf->chan_conf->channel->center_freq);
 
 	if (priv->rf->init == rtl8225_rf_init)
 		rtl8225_rf_set_tx_power(dev, chan);
diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 5100235..7092cf2 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -692,7 +692,7 @@ int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
 	int rate_idx;
 
 	if (false == isht) {
-		if (IEEE80211_BAND_2GHZ == hw->conf.channel->band) {
+		if (IEEE80211_BAND_2GHZ == hw->conf.chan_conf->channel->band) {
 			switch (desc_rate) {
 			case DESC92_RATE1M:
 				rate_idx = 0;
@@ -1339,7 +1339,7 @@ int rtl_send_smps_action(struct ieee80211_hw *hw,
 
 		info->control.rates[0].idx = 0;
 		info->control.sta = sta;
-		info->band = hw->conf.channel->band;
+		info->band = hw->conf.chan_conf->channel->band;
 		rtlpriv->intf_ops->adapter_tx(hw, skb, &tcb_desc);
 	}
 err_free:
diff --git a/drivers/net/wireless/rtlwifi/core.c b/drivers/net/wireless/rtlwifi/core.c
index 278e9f9..48b5594 100644
--- a/drivers/net/wireless/rtlwifi/core.c
+++ b/drivers/net/wireless/rtlwifi/core.c
@@ -318,7 +318,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		struct ieee80211_channel *channel = hw->conf.channel;
+		struct ieee80211_channel *channel = hw->conf.chan_conf->channel;
 		u8 wide_chan = (u8) channel->hw_value;
 
 		/*
@@ -330,7 +330,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 		 *info for cisco1253 bw20, so we modify
 		 *it here based on UPPER & LOWER
 		 */
-		switch (hw->conf.channel_type) {
+		switch (hw->conf.chan_conf->channel_type) {
 		case NL80211_CHAN_HT20:
 		case NL80211_CHAN_NO_HT:
 			/* SC */
@@ -388,7 +388,7 @@ static int rtl_op_config(struct ieee80211_hw *hw, u32 changed)
 		rtlpriv->cfg->ops->switch_channel(hw);
 		rtlpriv->cfg->ops->set_channel_access(hw);
 		rtlpriv->cfg->ops->set_bw_mode(hw,
-					       hw->conf.channel_type);
+					       hw->conf.chan_conf->channel_type);
 	}
 
 	mutex_unlock(&rtlpriv->locks.conf_mutex);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index 37b1363..f1ef817 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -552,8 +552,8 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
 	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
 
-	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->band = hw->conf.channel->band;
+	rx_status->freq = hw->conf.chan_conf->channel->center_freq;
+	rx_status->band = hw->conf.chan_conf->channel->band;
 
 	if (GET_RX_DESC_CRC32(pdesc))
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index 21bc827..c2ed11f 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -324,8 +324,8 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 				   && (GET_RX_DESC_FAGGR(pdesc) == 1));
 	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
 	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
-	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->band = hw->conf.channel->band;
+	rx_status->freq = hw->conf.chan_conf->channel->center_freq;
+	rx_status->band = hw->conf.chan_conf->channel->band;
 	if (GET_RX_DESC_CRC32(pdesc))
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 	if (!GET_RX_DESC_SWDEC(pdesc))
@@ -395,8 +395,8 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	stats.rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(rxdesc);
 	/* TODO: is center_freq changed when doing scan? */
 	/* TODO: Shall we add protection or just skip those two step? */
-	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->band = hw->conf.channel->band;
+	rx_status->freq = hw->conf.chan_conf->channel->center_freq;
+	rx_status->band = hw->conf.chan_conf->channel->band;
 	if (GET_RX_DESC_CRC32(rxdesc))
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 	if (!GET_RX_DESC_SWDEC(rxdesc))
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
index a7f6126..76660c3 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -503,8 +503,8 @@ bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,	struct rtl_stats *stats,
 					 && (GET_RX_DESC_FAGGR(pdesc) == 1));
 	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
 	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
-	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->band = hw->conf.channel->band;
+	rx_status->freq = hw->conf.chan_conf->channel->center_freq;
+	rx_status->band = hw->conf.chan_conf->channel->band;
 	if (GET_RX_DESC_CRC32(pdesc))
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 	if (!GET_RX_DESC_SWDEC(pdesc))
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index 2fd3d13..3ce9cea 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -538,8 +538,8 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 	if (stats->hwerror)
 		return false;
 
-	rx_status->freq = hw->conf.channel->center_freq;
-	rx_status->band = hw->conf.channel->band;
+	rx_status->freq = hw->conf.chan_conf->channel->center_freq;
+	rx_status->band = hw->conf.chan_conf->channel->band;
 
 	hdr = (struct ieee80211_hdr *)(skb->data + stats->rx_drvinfo_size
 	      + stats->rx_bufshift);
diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index 41302c7..004add1 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -591,7 +591,7 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 	int channel, ret = 0;
 
-	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	channel = ieee80211_frequency_to_channel(conf->chan_conf->channel->center_freq);
 
 	wl1251_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d",
 		     channel,
@@ -1214,7 +1214,7 @@ static int wl1251_op_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
  
-	survey->channel = conf->channel;
+	survey->channel = conf->chan_conf->channel;
 	survey->filled = SURVEY_INFO_NOISE_DBM;
 	survey->noise = wl->noise;
  
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 3900236..a37e53e 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2585,15 +2585,15 @@ static int wl12xx_config_vif(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	bool is_ap = (wlvif->bss_type == BSS_TYPE_AP_BSS);
 	int channel, ret;
 
-	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	channel = ieee80211_frequency_to_channel(conf->chan_conf->channel->center_freq);
 
 	/* if the channel changes while joined, join again */
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL &&
-	    ((wlvif->band != conf->channel->band) ||
+	    ((wlvif->band != conf->chan_conf->channel->band) ||
 	     (wlvif->channel != channel))) {
 		/* send all pending packets */
 		wl1271_tx_work_locked(wl);
-		wlvif->band = conf->channel->band;
+		wlvif->band = conf->chan_conf->channel->band;
 		wlvif->channel = channel;
 
 		if (!is_ap) {
@@ -2689,7 +2689,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 	int channel, ret = 0;
 
-	channel = ieee80211_frequency_to_channel(conf->channel->center_freq);
+	channel = ieee80211_frequency_to_channel(conf->chan_conf->channel->center_freq);
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 config ch %d psm %s power %d %s"
 		     " changed 0x%x",
@@ -2712,7 +2712,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	/* we support configuring the channel and band even while off */
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
-		wl->band = conf->channel->band;
+		wl->band = conf->chan_conf->channel->band;
 		wl->channel = channel;
 	}
 
@@ -3813,7 +3813,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			goto sta_not_found;
 
 		/* save the supp_rates of the ap */
-		sta_rate_set = sta->supp_rates[wl->hw->conf.channel->band];
+		sta_rate_set = sta->supp_rates[wl->hw->conf.chan_conf->channel->band];
 		if (sta->ht_cap.ht_supported)
 			sta_rate_set |=
 			    (sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET);
@@ -4195,7 +4195,7 @@ static int wl1271_op_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
 
-	survey->channel = conf->channel;
+	survey->channel = conf->chan_conf->channel;
 	survey->filled = SURVEY_INFO_NOISE_DBM;
 	survey->noise = wl->noise;
 
diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index 9fcde36..3b6232a 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -1154,10 +1154,10 @@ static int zd_op_config(struct ieee80211_hw *hw, u32 changed)
 	struct ieee80211_conf *conf = &hw->conf;
 
 	spin_lock_irq(&mac->lock);
-	mac->channel = conf->channel->hw_value;
+	mac->channel = conf->chan_conf->channel->hw_value;
 	spin_unlock_irq(&mac->lock);
 
-	return zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
+	return zd_chip_set_channel(&mac->chip, conf->chan_conf->channel->hw_value);
 }
 
 static void zd_beacon_done(struct zd_mac *mac)
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9a012be..fa71c97 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -140,6 +140,17 @@ struct ieee80211_low_level_stats {
 };
 
 /**
+ * struct ieee80211_channel_conf - configuration of the channel
+ *
+ * @channel: the channel to tune to
+ * @channel_type: the channel (HT) type
+ */
+struct ieee80211_channel_conf {
+	struct ieee80211_channel *channel;
+	enum nl80211_channel_type channel_type;
+};
+
+/**
  * enum ieee80211_bss_change - BSS change notification flags
  *
  * These flags are used with the bss_info_changed() callback
@@ -804,9 +815,6 @@ enum ieee80211_smps_mode {
  *
  * @power_level: requested transmit power (in dBm)
  *
- * @channel: the channel to tune to
- * @channel_type: the channel (HT) type
- *
  * @long_frame_max_tx_count: Maximum number of transmissions for a "long" frame
  *    (a frame not RTS protected), called "dot11LongRetryLimit" in 802.11,
  *    but actually means the number of transmissions not the number of retries
@@ -814,6 +822,8 @@ enum ieee80211_smps_mode {
  *    frame, called "dot11ShortRetryLimit" in 802.11, but actually means the
  *    number of transmissions not the number of retries
  *
+ * @chan_conf: Channel configuration (eg. what channel we're tuned to)
+ *
  * @smps_mode: spatial multiplexing powersave mode; note that
  *	%IEEE80211_SMPS_STATIC is used when the device is not
  *	configured for an HT channel
@@ -828,8 +838,7 @@ struct ieee80211_conf {
 
 	u8 long_frame_max_tx_count, short_frame_max_tx_count;
 
-	struct ieee80211_channel *channel;
-	enum nl80211_channel_type channel_type;
+	struct ieee80211_channel_conf *chan_conf;
 	enum ieee80211_smps_mode smps_mode;
 };
 
@@ -3649,19 +3658,19 @@ void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
 static inline bool
 conf_is_ht20(struct ieee80211_conf *conf)
 {
-	return conf->channel_type == NL80211_CHAN_HT20;
+	return conf->chan_conf->channel_type == NL80211_CHAN_HT20;
 }
 
 static inline bool
 conf_is_ht40_minus(struct ieee80211_conf *conf)
 {
-	return conf->channel_type == NL80211_CHAN_HT40MINUS;
+	return conf->chan_conf->channel_type == NL80211_CHAN_HT40MINUS;
 }
 
 static inline bool
 conf_is_ht40_plus(struct ieee80211_conf *conf)
 {
-	return conf->channel_type == NL80211_CHAN_HT40PLUS;
+	return conf->chan_conf->channel_type == NL80211_CHAN_HT40PLUS;
 }
 
 static inline bool
@@ -3673,7 +3682,7 @@ conf_is_ht40(struct ieee80211_conf *conf)
 static inline bool
 conf_is_ht(struct ieee80211_conf *conf)
 {
-	return conf->channel_type != NL80211_CHAN_NO_HT;
+	return conf->chan_conf->channel_type != NL80211_CHAN_NO_HT;
 }
 
 static inline enum nl80211_iftype
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 677d659..88cc128 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -327,10 +327,11 @@ static int ieee80211_config_default_mgmt_key(struct wiphy *wiphy,
 
 static void rate_idx_to_bitrate(struct rate_info *rate, struct sta_info *sta, int idx)
 {
+	struct ieee80211_channel_state *chan_state = &sta->local->chan_state;
 	if (!(rate->flags & RATE_INFO_FLAGS_MCS)) {
 		struct ieee80211_supported_band *sband;
 		sband = sta->local->hw.wiphy->bands[
-				sta->local->hw.conf.channel->band];
+				chan_state->conf.channel->band];
 		rate->legacy = sband->bitrates[idx].bitrate;
 	} else
 		rate->mcs = idx;
@@ -736,9 +737,10 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	int i, j;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	u32 mask, set;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[chan_state->oper_channel->band];
 
 	mask = params->sta_flags_mask;
 	set = params->sta_flags_set;
@@ -853,7 +855,7 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 					rates |= BIT(j);
 			}
 		}
-		sta->sta.supp_rates[local->oper_channel->band] = rates;
+		sta->sta.supp_rates[chan_state->oper_channel->band] = rates;
 	}
 
 	if (params->ht_capa)
@@ -1363,10 +1365,12 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 				struct net_device *dev,
 				struct bss_parameters *params)
 {
+	struct ieee80211_channel_state *chan_state;
 	struct ieee80211_sub_if_data *sdata;
 	u32 changed = 0;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	chan_state = &sdata->local->chan_state;
 
 	if (params->use_cts_prot >= 0) {
 		sdata->vif.bss_conf.use_cts_prot = params->use_cts_prot;
@@ -1379,7 +1383,7 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	}
 
 	if (!sdata->vif.bss_conf.use_short_slot &&
-	    sdata->local->hw.conf.channel->band == IEEE80211_BAND_5GHZ) {
+	    chan_state->conf.channel->band == IEEE80211_BAND_5GHZ) {
 		sdata->vif.bss_conf.use_short_slot = true;
 		changed |= BSS_CHANGED_ERP_SLOT;
 	}
@@ -1393,9 +1397,8 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 	if (params->basic_rates) {
 		int i, j;
 		u32 rates = 0;
-		struct ieee80211_local *local = wiphy_priv(wiphy);
 		struct ieee80211_supported_band *sband =
-			wiphy->bands[local->oper_channel->band];
+			wiphy->bands[chan_state->oper_channel->band];
 
 		for (i = 0; i < params->basic_rates_len; i++) {
 			int rate = (params->basic_rates[i] & 0x7f) * 5;
@@ -1469,6 +1472,7 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 				 enum nl80211_channel_type channel_type)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_sub_if_data *sdata = NULL;
 	struct ieee80211_channel *old_oper;
 	enum nl80211_channel_type old_oper_type;
@@ -1481,9 +1485,9 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 	case CHAN_MODE_HOPPING:
 		return -EBUSY;
 	case CHAN_MODE_FIXED:
-		if (local->oper_channel != chan)
+		if (chan_state->oper_channel != chan)
 			return -EBUSY;
-		if (!sdata && local->_oper_channel_type == channel_type)
+		if (!sdata && chan_state->_oper_channel_type == channel_type)
 			return 0;
 		break;
 	case CHAN_MODE_UNDEFINED:
@@ -1492,17 +1496,17 @@ static int ieee80211_set_channel(struct wiphy *wiphy,
 
 	if (sdata)
 		old_vif_oper_type = sdata->vif.bss_conf.channel_type;
-	old_oper_type = local->_oper_channel_type;
+	old_oper_type = chan_state->_oper_channel_type;
 
 	if (!ieee80211_set_channel_type(local, sdata, channel_type))
 		return -EBUSY;
 
-	old_oper = local->oper_channel;
-	local->oper_channel = chan;
+	old_oper = chan_state->oper_channel;
+	chan_state->oper_channel = chan;
 
 	/* Update driver if changes were actually made. */
-	if ((old_oper != local->oper_channel) ||
-	    (old_oper_type != local->_oper_channel_type))
+	if ((old_oper != chan_state->oper_channel) ||
+	    (old_oper_type != chan_state->_oper_channel_type))
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	if (sdata && sdata->vif.type != NL80211_IFTYPE_MONITOR &&
@@ -1594,12 +1598,13 @@ static int ieee80211_assoc(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 
 	switch (ieee80211_get_channel_mode(local, sdata)) {
 	case CHAN_MODE_HOPPING:
 		return -EBUSY;
 	case CHAN_MODE_FIXED:
-		if (local->oper_channel == req->bss->channel)
+		if (chan_state->oper_channel == req->bss->channel)
 			break;
 		return -EBUSY;
 	case CHAN_MODE_UNDEFINED:
@@ -1626,6 +1631,7 @@ static int ieee80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 
 	switch (ieee80211_get_channel_mode(local, sdata)) {
 	case CHAN_MODE_HOPPING:
@@ -1633,7 +1639,7 @@ static int ieee80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	case CHAN_MODE_FIXED:
 		if (!params->channel_fixed)
 			return -EBUSY;
-		if (local->oper_channel == params->channel)
+		if (chan_state->oper_channel == params->channel)
 			break;
 		return -EBUSY;
 	case CHAN_MODE_UNDEFINED:
@@ -1691,7 +1697,8 @@ static int ieee80211_set_tx_power(struct wiphy *wiphy,
 				  enum nl80211_tx_power_setting type, int mbm)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
-	struct ieee80211_channel *chan = local->hw.conf.channel;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
+	struct ieee80211_channel *chan = chan_state->conf.channel;
 	u32 changes = 0;
 
 	switch (type) {
@@ -2025,6 +2032,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct sk_buff *skb;
 	struct sta_info *sta;
 	struct ieee80211_work *wk;
@@ -2039,12 +2047,12 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 			IEEE80211_TX_CTL_REQ_TX_STATUS;
 
 	/* Check that we are on the requested channel for transmission */
-	if (chan != local->tmp_channel &&
-	    chan != local->oper_channel)
+	if (chan != chan_state->tmp_channel &&
+	    chan != chan_state->oper_channel)
 		is_offchan = true;
 	if (channel_type_valid &&
-	    (channel_type != local->tmp_channel_type &&
-	     channel_type != local->_oper_channel_type))
+	    (channel_type != chan_state->tmp_channel_type &&
+	     channel_type != chan_state->_oper_channel_type))
 		is_offchan = true;
 
 	if (chan == local->hw_roc_channel) {
@@ -2296,10 +2304,11 @@ static void ieee80211_tdls_add_ext_capab(struct sk_buff *skb)
 static u16 ieee80211_get_tdls_sta_capab(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	u16 capab;
 
 	capab = 0;
-	if (local->oper_channel->band != IEEE80211_BAND_2GHZ)
+	if (chan_state->oper_channel->band != IEEE80211_BAND_2GHZ)
 		return capab;
 
 	if (!(local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
@@ -2669,8 +2678,9 @@ static struct ieee80211_channel *
 ieee80211_wiphy_get_channel(struct wiphy *wiphy)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 
-	return local->oper_channel;
+	return chan_state->oper_channel;
 }
 
 struct cfg80211_ops mac80211_config_ops = {
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 421c64e..b4b5303 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -68,6 +68,7 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 				struct ieee80211_sub_if_data *sdata,
 				enum nl80211_channel_type chantype)
 {
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_sub_if_data *tmp;
 	enum nl80211_channel_type superchan = NL80211_CHAN_NO_HT;
 	bool result;
@@ -124,7 +125,7 @@ bool ieee80211_set_channel_type(struct ieee80211_local *local,
 		goto out;
 	}
 
-	local->_oper_channel_type = superchan;
+	chan_state->_oper_channel_type = superchan;
 
 	if (sdata)
 		sdata->vif.bss_conf.channel_type = chantype;
@@ -146,15 +147,16 @@ enum nl80211_channel_type ieee80211_get_tx_channel_type(
 				enum nl80211_channel_type channel_type)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 
 	switch (channel_type) {
 	case NL80211_CHAN_HT40PLUS:
-		if (local->hw.conf.channel->flags &
+		if (chan_state->conf.channel->flags &
 				IEEE80211_CHAN_NO_HT40PLUS)
 			return NL80211_CHAN_HT20;
 		break;
 	case NL80211_CHAN_HT40MINUS:
-		if (local->hw.conf.channel->flags &
+		if (chan_state->conf.channel->flags &
 				IEEE80211_CHAN_NO_HT40MINUS)
 			return NL80211_CHAN_HT20;
 		break;
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index cc5b7a6..8ff846a 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -70,7 +70,7 @@ DEBUGFS_READONLY_FILE(user_power, "%d",
 DEBUGFS_READONLY_FILE(power, "%d",
 		      local->hw.conf.power_level);
 DEBUGFS_READONLY_FILE(frequency, "%d",
-		      local->hw.conf.channel->center_freq);
+		      local->chan_state.conf.channel->center_freq);
 DEBUGFS_READONLY_FILE(total_ps_buffered, "%d",
 		      local->total_ps_buffered);
 DEBUGFS_READONLY_FILE(wep_iv, "%#08x",
@@ -101,9 +101,10 @@ static ssize_t channel_type_read(struct file *file, char __user *user_buf,
 		       size_t count, loff_t *ppos)
 {
 	struct ieee80211_local *local = file->private_data;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	const char *buf;
 
-	switch (local->hw.conf.channel_type) {
+	switch (chan_state->conf.channel_type) {
 	case NL80211_CHAN_NO_HT:
 		buf = "no ht\n";
 		break;
diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 21d6f52..0b61a8e 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -247,8 +247,8 @@ TRACE_EVENT(drv_config,
 		__entry->listen_interval = local->hw.conf.listen_interval;
 		__entry->long_frame_max_tx_count = local->hw.conf.long_frame_max_tx_count;
 		__entry->short_frame_max_tx_count = local->hw.conf.short_frame_max_tx_count;
-		__entry->center_freq = local->hw.conf.channel->center_freq;
-		__entry->channel_type = local->hw.conf.channel_type;
+		__entry->center_freq = local->chan_state.conf.channel->center_freq;
+		__entry->channel_type = local->chan_state.conf.channel_type;
 		__entry->smps = local->hw.conf.smps_mode;
 	),
 
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 8bea83b..d2bffcd 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -43,6 +43,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	int rates, i;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
@@ -80,7 +81,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 
 	sdata->drop_unencrypted = capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
 
-	local->oper_channel = chan;
+	chan_state->oper_channel = chan;
 	channel_type = ifibss->channel_type;
 	if (channel_type > NL80211_CHAN_HT20 &&
 	    !cfg80211_can_beacon_sec_chan(local->hw.wiphy, chan, channel_type))
@@ -203,7 +204,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	mod_timer(&ifibss->timer,
 		  round_jiffies(jiffies + IEEE80211_IBSS_MERGE_INTERVAL));
 
-	bss = cfg80211_inform_bss_frame(local->hw.wiphy, local->hw.conf.channel,
+	bss = cfg80211_inform_bss_frame(local->hw.wiphy, chan_state->conf.channel,
 					mgmt, skb->len, 0, GFP_KERNEL);
 	cfg80211_put_bss(bss);
 	netif_carrier_on(sdata->dev);
@@ -297,8 +298,9 @@ ieee80211_ibss_add_sta(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct sta_info *sta;
-	int band = local->hw.conf.channel->band;
+	int band = chan_state->conf.channel->band;
 
 	/*
 	 * XXX: Consider removing the least recently used entry and
@@ -380,6 +382,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 				  bool beacon)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	int freq;
 	struct cfg80211_bss *cbss;
 	struct ieee80211_bss *bss;
@@ -498,7 +501,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		goto put_bss;
 
 	/* different channel */
-	if (cbss->channel != local->oper_channel)
+	if (cbss->channel != chan_state->oper_channel)
 		goto put_bss;
 
 	/* different SSID */
@@ -576,8 +579,9 @@ void ieee80211_ibss_rx_no_sta(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct sta_info *sta;
-	int band = local->hw.conf.channel->band;
+	int band = chan_state->conf.channel->band;
 
 	/*
 	 * XXX: Consider removing the least recently used entry and
@@ -713,6 +717,7 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct cfg80211_bss *cbss;
 	struct ieee80211_channel *chan = NULL;
 	const u8 *bssid = NULL;
@@ -780,13 +785,13 @@ static void ieee80211_sta_find_ibss(struct ieee80211_sub_if_data *sdata)
 
 		if (time_after(jiffies, ifibss->ibss_join_req +
 			       IEEE80211_IBSS_JOIN_TIMEOUT)) {
-			if (!(local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS)) {
+			if (!(chan_state->oper_channel->flags & IEEE80211_CHAN_NO_IBSS)) {
 				ieee80211_sta_create_ibss(sdata);
 				return;
 			}
 			printk(KERN_DEBUG "%s: IBSS not allowed on"
 			       " %d MHz\n", sdata->name,
-			       local->hw.conf.channel->center_freq);
+			       chan_state->conf.channel->center_freq);
 
 			/* No IBSS found - decrease scan interval and continue
 			 * scanning. */
@@ -1051,6 +1056,7 @@ void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local)
 int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_ibss_params *params)
 {
+	struct ieee80211_channel_state *chan_state = &sdata->local->chan_state;
 	struct sk_buff *skb;
 	u32 changed = 0;
 
@@ -1090,7 +1096,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 
 	/* fix ourselves to that channel now already */
 	if (params->channel_fixed) {
-		sdata->local->oper_channel = params->channel;
+		chan_state->oper_channel = params->channel;
 		if (!ieee80211_set_channel_type(sdata->local, sdata,
 					       params->channel_type)) {
 			mutex_unlock(&sdata->u.ibss.mtx);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 69a38be..b459451 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -610,6 +610,22 @@ struct ieee80211_if_mesh {
 	do { } while (0)
 #endif
 
+struct ieee80211_channel_state {
+	/* Hardware state */
+	struct ieee80211_channel_conf conf;
+
+	/* Current operating channel */
+	enum nl80211_channel_type _oper_channel_type;
+	struct ieee80211_channel *oper_channel;
+
+	/* CSA channel; scheduled when, e.g. AP switches channels */
+	struct ieee80211_channel *csa_channel;
+
+	/* Temporary remain-on-channel for off-channel operations */
+	struct ieee80211_channel *tmp_channel;
+	enum nl80211_channel_type tmp_channel_type;
+};
+
 /**
  * enum ieee80211_sub_if_data_flags - virtual interface flags
  *
@@ -972,12 +988,9 @@ struct ieee80211_local {
 	enum mac80211_scan_state next_scan_state;
 	struct delayed_work scan_work;
 	struct ieee80211_sub_if_data *scan_sdata;
-	enum nl80211_channel_type _oper_channel_type;
-	struct ieee80211_channel *oper_channel, *csa_channel;
 
-	/* Temporary remain-on-channel for off-channel operations */
-	struct ieee80211_channel *tmp_channel;
-	enum nl80211_channel_type tmp_channel_type;
+	/* Channel state */
+	struct ieee80211_channel_state chan_state;
 
 	/* SNMP counters */
 	/* dot11CountersTable */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index c7c60ce..4ee77a2 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -390,6 +390,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 			      bool going_down)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	unsigned long flags;
 	struct sk_buff *skb, *tmp;
 	u32 hw_reconf_flags = 0;
@@ -561,11 +562,11 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	/* Re-calculate channel-type, in case there are multiple vifs
 	 * on different channel types.
 	 */
-	orig_ct = local->_oper_channel_type;
+	orig_ct = chan_state->_oper_channel_type;
 	ieee80211_set_channel_type(local, NULL, NL80211_CHAN_NO_HT);
 
 	/* do after stop to avoid reconfiguring when we stop anyway */
-	if (hw_reconf_flags || (orig_ct != local->_oper_channel_type))
+	if (hw_reconf_flags || (orig_ct != chan_state->_oper_channel_type))
 		ieee80211_hw_config(local, hw_reconf_flags);
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
@@ -982,6 +983,7 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 			     enum nl80211_iftype type)
 {
 	int ret;
+	struct ieee80211_channel_state *chan_state = &sdata->local->chan_state;
 
 	ASSERT_RTNL();
 
@@ -989,7 +991,7 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 		return 0;
 
 	/* Setting ad-hoc mode on non-IBSS channel is not supported. */
-	if (sdata->local->oper_channel->flags & IEEE80211_CHAN_NO_IBSS &&
+	if (chan_state->oper_channel->flags & IEEE80211_CHAN_NO_IBSS &&
 	    type == NL80211_IFTYPE_ADHOC)
 		return -EOPNOTSUPP;
 
@@ -1006,7 +1008,7 @@ int ieee80211_if_change_type(struct ieee80211_sub_if_data *sdata,
 	/* reset some values that shouldn't be kept across type changes */
 	sdata->vif.bss_conf.basic_rates =
 		ieee80211_mandatory_rates(sdata,
-			sdata->local->hw.conf.channel->band);
+			chan_state->conf.channel->band);
 	sdata->drop_unencrypted = 0;
 	if (type == NL80211_IFTYPE_STATION)
 		sdata->u.mgd.use_4addr = false;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b581a24..f5ca305 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -94,6 +94,7 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
 
 int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 {
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_channel *chan;
 	int ret = 0;
 	int power;
@@ -111,30 +112,30 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 		/* If scanning on oper channel, use whatever channel-type
 		 * is currently in use.
 		 */
-		if (chan == local->oper_channel)
-			channel_type = local->_oper_channel_type;
+		if (chan == chan_state->oper_channel)
+			channel_type = chan_state->_oper_channel_type;
 		else
 			channel_type = NL80211_CHAN_NO_HT;
-	} else if (local->tmp_channel) {
-		chan = local->tmp_channel;
-		channel_type = local->tmp_channel_type;
+	} else if (chan_state->tmp_channel) {
+		chan = chan_state->tmp_channel;
+		channel_type = chan_state->tmp_channel_type;
 	} else {
-		chan = local->oper_channel;
-		channel_type = local->_oper_channel_type;
+		chan = chan_state->oper_channel;
+		channel_type = chan_state->_oper_channel_type;
 	}
 
-	if (chan != local->oper_channel ||
-	    channel_type != local->_oper_channel_type)
+	if (chan != chan_state->oper_channel ||
+	    channel_type != chan_state->_oper_channel_type)
 		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
 	else
 		local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
 
 	offchannel_flag ^= local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
 
-	if (offchannel_flag || chan != local->hw.conf.channel ||
-	    channel_type != local->hw.conf.channel_type) {
-		local->hw.conf.channel = chan;
-		local->hw.conf.channel_type = channel_type;
+	if (offchannel_flag || chan != chan_state->conf.channel ||
+	    channel_type != chan_state->conf.channel_type) {
+		chan_state->conf.channel = chan;
+		chan_state->conf.channel_type = channel_type;
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
 	}
 
@@ -586,6 +587,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	BUG_ON(!ops->configure_filter);
 	local->ops = ops;
 
+	local->hw.conf.chan_conf = &local->chan_state.conf;
+
 	/* set up some defaults */
 	local->hw.queues = 1;
 	local->hw.max_rates = 1;
@@ -673,6 +676,7 @@ EXPORT_SYMBOL(ieee80211_alloc_hw);
 int ieee80211_register_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	int result, i;
 	enum ieee80211_band band;
 	int channels, max_bitrates;
@@ -704,7 +708,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	/*
 	 * generic code guarantees at least one band,
 	 * set this very early because much code assumes
-	 * that hw.conf.channel is assigned
+	 * that hw.conf.chan_conf->channel is assigned
 	 */
 	channels = 0;
 	max_bitrates = 0;
@@ -715,11 +719,11 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		sband = local->hw.wiphy->bands[band];
 		if (!sband)
 			continue;
-		if (!local->oper_channel) {
+		if (!chan_state->oper_channel) {
 			/* init channel we're on */
-			local->hw.conf.channel =
-			local->oper_channel = &sband->channels[0];
-			local->hw.conf.channel_type = NL80211_CHAN_NO_HT;
+			local->hw.conf.chan_conf->channel =
+			chan_state->oper_channel = &sband->channels[0];
+			local->hw.conf.chan_conf->channel_type = NL80211_CHAN_NO_HT;
 		}
 		channels += sband->n_channels;
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 0e6106e..b512c38 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -77,6 +77,7 @@ bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_dat
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 
 	/*
 	 * As support for each feature is added, check for matching
@@ -99,7 +100,7 @@ bool mesh_matches_local(struct ieee802_11_elems *ie, struct ieee80211_sub_if_dat
 
 	/* disallow peering with mismatched channel types for now */
 	if (ie->ht_info_elem &&
-	    (local->_oper_channel_type !=
+	    (chan_state->_oper_channel_type !=
 	     ieee80211_ht_info_to_channel_type(ie->ht_info_elem)))
 		goto mismatch;
 
@@ -333,18 +334,19 @@ int mesh_add_ds_params_ie(struct sk_buff *skb,
 			  struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_supported_band *sband;
 	u8 *pos;
 
 	if (skb_tailroom(skb) < 3)
 		return -ENOMEM;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[chan_state->conf.channel->band];
 	if (sband->band == IEEE80211_BAND_2GHZ) {
 		pos = skb_put(skb, 2 + 1);
 		*pos++ = WLAN_EID_DS_PARAMS;
 		*pos++ = 1;
-		*pos++ = ieee80211_frequency_to_channel(local->hw.conf.channel->center_freq);
+		*pos++ = ieee80211_frequency_to_channel(chan_state->conf.channel->center_freq);
 	}
 
 	return 0;
@@ -354,12 +356,13 @@ int mesh_add_ht_cap_ie(struct sk_buff *skb,
 		       struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_supported_band *sband;
 	u8 *pos;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[chan_state->oper_channel->band];
 	if (!sband->ht_cap.ht_supported ||
-	    local->_oper_channel_type == NL80211_CHAN_NO_HT)
+	    chan_state->_oper_channel_type == NL80211_CHAN_NO_HT)
 		return 0;
 
 	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_ht_cap))
@@ -375,8 +378,9 @@ int mesh_add_ht_info_ie(struct sk_buff *skb,
 			struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_channel *channel = local->oper_channel;
-	enum nl80211_channel_type channel_type = local->_oper_channel_type;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
+	struct ieee80211_channel *channel = chan_state->oper_channel;
+	enum nl80211_channel_type channel_type = chan_state->_oper_channel_type;
 	struct ieee80211_supported_band *sband =
 				local->hw.wiphy->bands[channel->band];
 	struct ieee80211_sta_ht_cap *ht_cap = &sband->ht_cap;
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 1c6f3d0..9215cca 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -323,6 +323,7 @@ void ieee80211s_update_metric(struct ieee80211_local *local,
 static u32 airtime_link_metric_get(struct ieee80211_local *local,
 				   struct sta_info *sta)
 {
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_supported_band *sband;
 	struct rate_info rinfo;
 	/* This should be adjusted for each device */
@@ -333,7 +334,7 @@ static u32 airtime_link_metric_get(struct ieee80211_local *local,
 	u32 tx_time, estimated_retx;
 	u64 result;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[chan_state->conf.channel->band];
 
 	if (sta->fail_avg >= 100)
 		return MAX_METRIC;
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index aee6014..c0722b0 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -90,10 +90,11 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 					 struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[chan_state->oper_channel->band];
 
 	if (local->num_sta >= MESH_MAX_PLINKS)
 		return NULL;
@@ -108,7 +109,7 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 
 	set_sta_flag(sta, WLAN_STA_WME);
 
-	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+	sta->sta.supp_rates[chan_state->conf.channel->band] = rates;
 	if (elems->ht_cap_elem)
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 						  elems->ht_cap_elem,
@@ -279,6 +280,7 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 		struct ieee802_11_elems *elems)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct sta_info *sta;
 
 	rcu_read_lock();
@@ -303,7 +305,7 @@ void mesh_neighbour_update(u8 *hw_addr, u32 rates,
 	}
 
 	sta->last_rx = jiffies;
-	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
+	sta->sta.supp_rates[chan_state->conf.channel->band] = rates;
 	if (mesh_peer_accepts_plinks(elems) &&
 			sta->plink_state == NL80211_PLINK_LISTEN &&
 			sdata->u.mesh.accepting_plinks &&
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9d0e865..2616bbd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -182,6 +182,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 			       bool beacon_htcap_ie)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 	u32 changed = 0;
@@ -192,14 +193,14 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 	enum nl80211_channel_type rx_channel_type = NL80211_CHAN_NO_HT;
 	enum nl80211_channel_type tx_channel_type;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[chan_state->conf.channel->band];
 	prev_chantype = sdata->vif.bss_conf.channel_type;
 
 
 	hti_cfreq = ieee80211_channel_to_frequency(hti->control_chan,
 						   sband->band);
 	/* check that channel matches the right operating channel */
-	if (local->hw.conf.channel->center_freq != hti_cfreq) {
+	if (chan_state->conf.channel->center_freq != hti_cfreq) {
 		/* Some APs mess this up, evidently.
 		 * Netgear WNDR3700 sometimes reports 4 higher than
 		 * the actual channel, for instance.
@@ -210,7 +211,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		       " hti-cfreq: %d  hti->control_chan: %d"
 		       " band: %d.  Disabling HT.\n",
 		       sdata->name,
-		       local->hw.conf.channel->center_freq,
+		       local->hw.conf.chan_conf->channel->center_freq,
 		       hti_cfreq, hti->control_chan,
 		       sband->band);
 		enable_ht = false;
@@ -236,8 +237,8 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 
 	tx_channel_type = ieee80211_get_tx_channel_type(sdata, rx_channel_type);
 
-	if (local->tmp_channel)
-		local->tmp_channel_type = rx_channel_type;
+	if (chan_state->tmp_channel)
+		chan_state->tmp_channel_type = rx_channel_type;
 
 	if (!ieee80211_set_channel_type(local, sdata, rx_channel_type)) {
 		/* can only fail due to HT40+/- mismatch */
@@ -386,6 +387,7 @@ static void ieee80211_add_ht_ie(struct ieee80211_sub_if_data *sdata,
 static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_mgd_assoc_data *assoc_data = ifmgd->assoc_data;
 	struct sk_buff *skb;
@@ -399,7 +401,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 
 	lockdep_assert_held(&ifmgd->mtx);
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[chan_state->oper_channel->band];
 
 	if (assoc_data->supp_rates_len) {
 		/*
@@ -520,7 +522,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 		*pos++ = WLAN_EID_PWR_CAPABILITY;
 		*pos++ = 2;
 		*pos++ = 0; /* min tx power */
-		*pos++ = local->oper_channel->max_power; /* max tx power */
+		*pos++ = chan_state->oper_channel->max_power; /* max tx power */
 
 		/* 2. supported channels */
 		/* TODO: get this in reg domain format */
@@ -558,7 +560,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata)
 
 	if (!(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		ieee80211_add_ht_ie(sdata, skb, assoc_data->ht_information_ie,
-				    sband, local->oper_channel, ifmgd->ap_smps);
+				    sband, chan_state->oper_channel, ifmgd->ap_smps);
 
 	/* if present, add any custom non-vendor IEs that go after HT */
 	if (assoc_data->ie_len && assoc_data->ie) {
@@ -717,6 +719,7 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 {
 	struct ieee80211_sub_if_data *sdata =
 		container_of(work, struct ieee80211_sub_if_data, u.mgd.chswitch_work);
+	struct ieee80211_channel_state *chan_state = &sdata->local->chan_state;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	if (!ieee80211_sdata_running(sdata))
@@ -726,18 +729,18 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 	if (!ifmgd->associated)
 		goto out;
 
-	sdata->local->oper_channel = sdata->local->csa_channel;
+	chan_state->oper_channel = chan_state->csa_channel;
 	if (!sdata->local->ops->channel_switch) {
 		/* call "hw_config" only if doing sw channel switch */
 		ieee80211_hw_config(sdata->local,
 			IEEE80211_CONF_CHANGE_CHANNEL);
 	} else {
 		/* update the device channel directly */
-		sdata->local->hw.conf.channel = sdata->local->oper_channel;
+		chan_state->conf.channel = chan_state->oper_channel;
 	}
 
 	/* XXX: shouldn't really modify cfg80211-owned data! */
-	ifmgd->associated->channel = sdata->local->oper_channel;
+	ifmgd->associated->channel = chan_state->oper_channel;
 
 	ieee80211_wake_queues_by_reason(&sdata->local->hw,
 					IEEE80211_QUEUE_STOP_REASON_CSA);
@@ -749,9 +752,11 @@ static void ieee80211_chswitch_work(struct work_struct *work)
 void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
 {
 	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_channel_state *chan_state;
 	struct ieee80211_if_managed *ifmgd;
 
 	sdata = vif_to_sdata(vif);
+	chan_state  = &sdata->local->chan_state;
 	ifmgd = &sdata->u.mgd;
 
 	trace_api_chswitch_done(sdata, success);
@@ -762,7 +767,7 @@ void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success)
 		 * good handling of this situation, possibly we
 		 * should just drop the association.
 		 */
-		sdata->local->csa_channel = sdata->local->oper_channel;
+		chan_state->csa_channel = chan_state->oper_channel;
 	}
 
 	ieee80211_queue_work(&sdata->local->hw, &ifmgd->chswitch_work);
@@ -791,6 +796,7 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct cfg80211_bss *cbss =
 		container_of((void *)bss, struct cfg80211_bss, priv);
 	struct ieee80211_channel *new_ch;
+	struct ieee80211_channel_state *chan_state = &sdata->local->chan_state;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	int new_freq = ieee80211_channel_to_frequency(sw_elem->new_ch_num,
 						      cbss->channel->band);
@@ -813,7 +819,7 @@ void ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	if (!new_ch || new_ch->flags & IEEE80211_CHAN_DISABLED)
 		return;
 
-	sdata->local->csa_channel = new_ch;
+	chan_state->csa_channel = new_ch;
 
 	if (sdata->local->ops->channel_switch) {
 		/* use driver's channel switch callback */
@@ -851,7 +857,7 @@ static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 					u16 capab_info, u8 *pwr_constr_elem,
 					u8 pwr_constr_elem_len)
 {
-	struct ieee80211_conf *conf = &sdata->local->hw.conf;
+	struct ieee80211_channel_state *chan_state = &sdata->local->chan_state;
 
 	if (!(capab_info & WLAN_CAPABILITY_SPECTRUM_MGMT))
 		return;
@@ -860,7 +866,7 @@ static void ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 	if (pwr_constr_elem_len != 1)
 		return;
 
-	if ((*pwr_constr_elem <= conf->channel->max_reg_power) &&
+	if ((*pwr_constr_elem <= chan_state->conf.channel->max_reg_power) &&
 	    (*pwr_constr_elem != sdata->local->power_constr_level)) {
 		sdata->local->power_constr_level = *pwr_constr_elem;
 		ieee80211_hw_config(sdata->local, 0);
@@ -1272,6 +1278,7 @@ static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
 					   u16 capab, bool erp_valid, u8 erp)
 {
 	struct ieee80211_bss_conf *bss_conf = &sdata->vif.bss_conf;
+	struct ieee80211_channel_state *chan_state = &sdata->local->chan_state;
 	u32 changed = 0;
 	bool use_protection;
 	bool use_short_preamble;
@@ -1286,7 +1293,7 @@ static u32 ieee80211_handle_bss_capability(struct ieee80211_sub_if_data *sdata,
 	}
 
 	use_short_slot = !!(capab & WLAN_CAPABILITY_SHORT_SLOT_TIME);
-	if (sdata->local->hw.conf.channel->band == IEEE80211_BAND_5GHZ)
+	if (chan_state->conf.channel->band == IEEE80211_BAND_5GHZ)
 		use_short_slot = true;
 
 	if (use_protection != bss_conf->use_cts_prot) {
@@ -1580,6 +1587,7 @@ static void ieee80211_mgd_probe_ap_send(struct ieee80211_sub_if_data *sdata)
 static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 				   bool beacon)
 {
+	struct ieee80211_channel_state *chan_state = &sdata->local->chan_state;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	bool already = false;
 
@@ -1589,7 +1597,7 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
 	if (sdata->local->scanning)
 		return;
 
-	if (sdata->local->tmp_channel)
+	if (chan_state->tmp_channel)
 		return;
 
 	mutex_lock(&ifmgd->mtx);
@@ -1992,6 +2000,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_supported_band *sband;
 	struct sta_info *sta;
 	u8 *pos;
@@ -2045,7 +2054,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		return false;
 	}
 
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	sband = local->hw.wiphy->bands[chan_state->oper_channel->band];
 
 	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
@@ -2331,6 +2340,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	size_t baselen;
 	struct ieee802_11_elems elems;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	u32 changed = 0;
 	bool erp_valid, directed_tim = false;
 	u8 erp_value = 0;
@@ -2344,7 +2354,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	if (baselen > len)
 		return;
 
-	if (rx_status->freq != local->hw.conf.channel->center_freq)
+	if (rx_status->freq != chan_state->conf.channel->center_freq)
 		return;
 
 	if (ifmgd->assoc_data && !ifmgd->assoc_data->have_beacon &&
@@ -2518,7 +2528,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 			return;
 		}
 
-		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+		sband = local->hw.wiphy->bands[chan_state->conf.channel->band];
 
 		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
@@ -3055,6 +3065,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 				     struct cfg80211_bss *cbss, bool assoc)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_bss *bss = (void *)cbss->priv;
 	struct sta_info *sta;
@@ -3081,7 +3092,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 	mutex_unlock(&local->mtx);
 
 	/* switch to the right channel */
-	local->oper_channel = cbss->channel;
+	chan_state->oper_channel = cbss->channel;
 	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
 
 	if (!have_sta) {
@@ -3117,7 +3128,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.basic_rates = basic_rates;
 
 		/* cf. IEEE 802.11 9.2.12 */
-		if (local->oper_channel->band == IEEE80211_BAND_2GHZ &&
+		if (chan_state->oper_channel->band == IEEE80211_BAND_2GHZ &&
 		    have_higher_than_11mbit)
 			sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
 		else
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index fbb1efd..626fb79 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -47,6 +47,7 @@ static inline void rate_control_tx_status(struct ieee80211_local *local,
 static inline void rate_control_rate_init(struct sta_info *sta)
 {
 	struct ieee80211_local *local = sta->sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct rate_control_ref *ref = sta->rate_ctrl;
 	struct ieee80211_sta *ista = &sta->sta;
 	void *priv_sta = sta->rate_ctrl_priv;
@@ -55,7 +56,7 @@ static inline void rate_control_rate_init(struct sta_info *sta)
 	if (!ref)
 		return;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[chan_state->conf.channel->band];
 
 	ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
 	set_sta_flag(sta, WLAN_STA_RATE_CONTROL);
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 00355ef..aa828f4 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -790,9 +790,12 @@ static void
 minstrel_ht_rate_init(void *priv, struct ieee80211_supported_band *sband,
                       struct ieee80211_sta *sta, void *priv_sta)
 {
-	struct minstrel_priv *mp = priv;
+	struct sta_info *stai = container_of(sta, struct sta_info, sta);
+	struct ieee80211_sub_if_data *sdata = stai->sdata;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 
-	minstrel_ht_update_caps(priv, sband, sta, priv_sta, mp->hw->conf.channel_type);
+	minstrel_ht_update_caps(priv, sband, sta, priv_sta, chan_state->conf.channel_type);
 }
 
 static void
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5749c74..98bb52d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2204,6 +2204,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *) rx->skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 	int len = rx->skb->len;
@@ -2273,7 +2274,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 				local, sband, rx->sta,
 				IEEE80211_RC_SMPS_CHANGED,
 				ieee80211_get_tx_channel_type(
-					sdata, local->_oper_channel_type));
+					sdata, chan_state->_oper_channel_type));
 			goto handled;
 		}
 		default:
@@ -2315,7 +2316,7 @@ ieee80211_rx_h_action(struct ieee80211_rx_data *rx)
 
 		goto queue;
 	case WLAN_CATEGORY_SPECTRUM_MGMT:
-		if (local->hw.conf.channel->band != IEEE80211_BAND_5GHZ)
+		if (chan_state->conf.channel->band != IEEE80211_BAND_5GHZ)
 			break;
 
 		if (sdata->vif.type != NL80211_IFTYPE_STATION)
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 33cd169..5e7a1f8 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -182,6 +182,7 @@ ieee80211_bss_info_update(struct ieee80211_local *local,
 ieee80211_rx_result
 ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 {
+	struct ieee80211_channel_state *chan_state = &sdata->local->chan_state;
 	struct ieee80211_rx_status *rx_status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_mgmt *mgmt;
 	struct ieee80211_bss *bss;
@@ -245,7 +246,7 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	if (bss)
 		ieee80211_rx_bss_put(sdata->local, bss);
 
-	if (channel == sdata->local->oper_channel)
+	if (channel == chan_state->oper_channel)
 		return RX_CONTINUE;
 
 	dev_kfree_skb(skb);
@@ -603,7 +604,8 @@ static void ieee80211_scan_state_send_probe(struct ieee80211_local *local,
 {
 	int i;
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
-	enum ieee80211_band band = local->hw.conf.channel->band;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
+	enum ieee80211_band band = chan_state->conf.channel->band;
 
 	for (i = 0; i < local->scan_req->n_ssids; i++)
 		ieee80211_send_probe_req(
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d241d83..ede173e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1133,6 +1133,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		     struct sk_buff *skb)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	int tid;
@@ -1142,7 +1143,7 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	tx->skb = skb;
 	tx->local = local;
 	tx->sdata = sdata;
-	tx->channel = local->hw.conf.channel;
+	tx->channel = chan_state->conf.channel;
 	__skb_queue_head_init(&tx->skbs);
 
 	/*
@@ -1373,6 +1374,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 			 struct sk_buff *skb, bool txpending)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_tx_data tx;
 	ieee80211_tx_result res_prepare;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -1397,7 +1399,7 @@ static bool ieee80211_tx(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-	tx.channel = local->hw.conf.channel;
+	tx.channel = chan_state->conf.channel;
 	info->band = tx.channel->band;
 
 	if (!invoke_tx_handlers(&tx))
@@ -1567,7 +1569,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 					 struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_channel *chan = local->hw.conf.channel;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
+	struct ieee80211_channel *chan = chan_state->conf.channel;
 	struct ieee80211_radiotap_header *prthdr =
 		(struct ieee80211_radiotap_header *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
@@ -2287,13 +2290,14 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 					 u16 *tim_offset, u16 *tim_length)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct sk_buff *skb = NULL;
 	struct ieee80211_tx_info *info;
 	struct ieee80211_sub_if_data *sdata = NULL;
 	struct ieee80211_if_ap *ap = NULL;
 	struct beacon_data *beacon;
 	struct ieee80211_supported_band *sband;
-	enum ieee80211_band band = local->hw.conf.channel->band;
+	enum ieee80211_band band = chan_state->conf.channel->band;
 	struct ieee80211_tx_rate_control txrc;
 
 	sband = local->hw.wiphy->bands[band];
@@ -2652,6 +2656,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct sk_buff *skb = NULL;
 	struct ieee80211_tx_data tx;
 	struct ieee80211_sub_if_data *sdata;
@@ -2695,7 +2700,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 	info = IEEE80211_SKB_CB(skb);
 
 	tx.flags |= IEEE80211_TX_PS_BUFFERED;
-	tx.channel = local->hw.conf.channel;
+	tx.channel = chan_state->conf.channel;
 	info->band = tx.channel->band;
 
 	if (invoke_tx_handlers(&tx))
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e8b6b31..fd398a7 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -110,6 +110,7 @@ int ieee80211_frame_duration(struct ieee80211_local *local,
 			     struct ieee80211_sub_if_data *sdata, size_t len,
 			     int rate, int erp, int short_preamble)
 {
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	int dur;
 
 	/* calculate duration (in microseconds, rounded up to next higher
@@ -121,7 +122,7 @@ int ieee80211_frame_duration(struct ieee80211_local *local,
 	 * DIV_ROUND_UP() operations.
 	 */
 
-	if (local->hw.conf.channel->band == IEEE80211_BAND_5GHZ || erp) {
+	if (chan_state->conf.channel->band == IEEE80211_BAND_5GHZ || erp) {
 		/*
 		 * OFDM:
 		 *
@@ -194,6 +195,7 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 			      const struct ieee80211_tx_info *frame_txctl)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_rate *rate;
 	struct ieee80211_sub_if_data *sdata = NULL;
 	bool short_preamble;
@@ -203,7 +205,7 @@ __le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
 
 	WARN_ON_ONCE(!vif);
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[chan_state->conf.channel->band];
 
 	short_preamble = false;
 
@@ -237,6 +239,7 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 				    const struct ieee80211_tx_info *frame_txctl)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_rate *rate;
 	struct ieee80211_sub_if_data *sdata = NULL;
 	bool short_preamble;
@@ -246,7 +249,7 @@ __le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
 
 	WARN_ON_ONCE(!vif);
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[chan_state->conf.channel->band];
 
 	short_preamble = false;
 
@@ -781,6 +784,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 			       bool bss_notify)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_tx_queue_params qparam;
 	int queue;
 	bool use_11b;
@@ -791,7 +795,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 
 	memset(&qparam, 0, sizeof(qparam));
 
-	use_11b = (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ) &&
+	use_11b = (chan_state->conf.channel->band == IEEE80211_BAND_2GHZ) &&
 		 !(sdata->flags & IEEE80211_SDATA_OPERATING_GMODE);
 
 	for (queue = 0; queue < local->hw.queues; queue++) {
@@ -859,6 +863,7 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 				  const u8 *supp_rates)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	int i, have_higher_than_11mbit = 0;
 
 	/* cf. IEEE 802.11 9.2.12 */
@@ -866,7 +871,7 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
 		if ((supp_rates[i] & 0x7f) * 5 > 110)
 			have_higher_than_11mbit = 1;
 
-	if (local->hw.conf.channel->band == IEEE80211_BAND_2GHZ &&
+	if (chan_state->conf.channel->band == IEEE80211_BAND_2GHZ &&
 	    have_higher_than_11mbit)
 		sdata->flags |= IEEE80211_SDATA_OPERATING_GMODE;
 	else
@@ -879,6 +884,7 @@ u32 ieee80211_mandatory_rates(struct ieee80211_sub_if_data *sdata,
 			      enum ieee80211_band band)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *bitrates;
 	u32 mandatory_rates;
@@ -888,7 +894,7 @@ u32 ieee80211_mandatory_rates(struct ieee80211_sub_if_data *sdata,
 	sband = local->hw.wiphy->bands[band];
 	if (!sband) {
 		WARN_ON(1);
-		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+		sband = local->hw.wiphy->bands[chan_state->conf.channel->band];
 	}
 
 	if (band == IEEE80211_BAND_2GHZ)
@@ -1049,6 +1055,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 					  bool directed)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct sk_buff *skb;
 	struct ieee80211_mgmt *mgmt;
 	size_t buf_len;
@@ -1069,10 +1076,10 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 		chan = 0;
 	else
 		chan = ieee80211_frequency_to_channel(
-			local->hw.conf.channel->center_freq);
+			chan_state->conf.channel->center_freq);
 
 	buf_len = ieee80211_build_preq_ies(local, buf, ie, ie_len,
-					   local->hw.conf.channel->band,
+					   chan_state->conf.channel->band,
 					   ratemask, chan);
 
 	skb = ieee80211_probereq_get(&local->hw, &sdata->vif,
@@ -1117,6 +1124,7 @@ u32 ieee80211_sta_get_rates(struct ieee80211_sub_if_data *sdata,
 			    enum ieee80211_band band)
 {
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *bitrates;
 	size_t num_rates;
@@ -1126,7 +1134,7 @@ u32 ieee80211_sta_get_rates(struct ieee80211_sub_if_data *sdata,
 
 	if (!sband) {
 		WARN_ON(1);
-		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+		sband = local->hw.wiphy->bands[chan_state->conf.channel->band];
 	}
 
 	bitrates = sband->bitrates;
@@ -1691,11 +1699,12 @@ int ieee80211_add_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_supported_band *sband;
 	int rate;
 	u8 i, rates, *pos;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[chan_state->conf.channel->band];
 	rates = sband->n_bitrates;
 	if (rates > 8)
 		rates = 8;
@@ -1718,11 +1727,12 @@ int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_supported_band *sband;
 	int rate;
 	u8 i, exrates, *pos;
 
-	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
+	sband = local->hw.wiphy->bands[chan_state->conf.channel->band];
 	exrates = sband->n_bitrates;
 	if (exrates > 8)
 		exrates -= 8;
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index c6e230e..91114db 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -117,6 +117,7 @@ static void ieee80211_work_work(struct work_struct *work)
 {
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, work_work);
+	struct ieee80211_channel_state *chan_state = &local->chan_state;
 	struct ieee80211_work *wk, *tmp;
 	LIST_HEAD(free_work);
 	enum work_action rma;
@@ -140,18 +141,18 @@ static void ieee80211_work_work(struct work_struct *work)
 		bool started = wk->started;
 
 		/* mark work as started if it's on the current off-channel */
-		if (!started && local->tmp_channel &&
-		    wk->chan == local->tmp_channel &&
-		    wk->chan_type == local->tmp_channel_type) {
+		if (!started && chan_state->tmp_channel &&
+		    wk->chan == chan_state->tmp_channel &&
+		    wk->chan_type == chan_state->tmp_channel_type) {
 			started = true;
 			wk->timeout = jiffies;
 		}
 
-		if (!started && !local->tmp_channel) {
+		if (!started && !chan_state->tmp_channel) {
 			ieee80211_offchannel_stop_vifs(local, true);
 
-			local->tmp_channel = wk->chan;
-			local->tmp_channel_type = wk->chan_type;
+			chan_state->tmp_channel = wk->chan;
+			chan_state->tmp_channel_type = wk->chan_type;
 
 			ieee80211_hw_config(local, 0);
 
@@ -210,14 +211,14 @@ static void ieee80211_work_work(struct work_struct *work)
 	list_for_each_entry(wk, &local->work_list, list) {
 		if (!wk->started)
 			continue;
-		if (wk->chan != local->tmp_channel ||
-		    wk->chan_type != local->tmp_channel_type)
+		if (wk->chan != chan_state->tmp_channel ||
+		    wk->chan_type != chan_state->tmp_channel_type)
 			continue;
 		remain_off_channel = true;
 	}
 
-	if (!remain_off_channel && local->tmp_channel) {
-		local->tmp_channel = NULL;
+	if (!remain_off_channel && chan_state->tmp_channel) {
+		chan_state->tmp_channel = NULL;
 		ieee80211_hw_config(local, 0);
 
 		ieee80211_offchannel_return(local, true);
-- 
1.7.0.4

