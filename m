Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:49606 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422Ab2CTOzW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 10:55:22 -0400
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 19 Mar 2012 11:25:08 +0100
Subject: [RFC 07/12] mac80211: change conf_is_ht* to take ieee80211_channel_conf
To: <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <e43bfc8e-8493-412d-acd5-6cb01e621391@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_155532_732447_010183A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath9k/ani.c          |    4 ++--
 drivers/net/wireless/ath/ath9k/calib.c        |    4 ++--
 drivers/net/wireless/ath/ath9k/debug.c        |    4 ++--
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    8 ++++----
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    4 ++--
 drivers/net/wireless/ath/ath9k/hw.c           |    4 ++--
 drivers/net/wireless/ath/ath9k/rc.c           |   12 ++++++------
 drivers/net/wireless/ath/ath9k/recv.c         |    2 +-
 drivers/net/wireless/ath/carl9170/mac.c       |    4 ++--
 drivers/net/wireless/ath/carl9170/phy.c       |    8 ++++----
 drivers/net/wireless/b43/main.c               |    4 ++--
 drivers/net/wireless/iwlegacy/4965-mac.c      |    6 +++---
 drivers/net/wireless/iwlegacy/4965-rs.c       |    6 +++---
 drivers/net/wireless/iwlegacy/common.c        |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c     |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c   |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-mac80211.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2800lib.c       |   18 +++++++++---------
 drivers/net/wireless/rt2x00/rt2x00config.c    |    6 +++---
 include/net/mac80211.h                        |   18 +++++++++---------
 net/mac80211/main.c                           |    2 +-
 21 files changed, 70 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 9f7f38f..8739704 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -210,7 +210,7 @@ static void ath9k_hw_ani_ofdm_err_trigger_old(struct ath_hw *ah)
 		return;
 	} else {
 		if ((conf->chan_conf->channel->band == IEEE80211_BAND_2GHZ) &&
-		    !conf_is_ht(conf)) {
+		    !conf_is_ht(conf->chan_conf)) {
 			if (!aniState->ofdmWeakSigDetectOff)
 				ath9k_hw_ani_control(ah,
 				     ATH9K_ANI_OFDM_WEAK_SIGNAL_DETECTION,
@@ -250,7 +250,7 @@ static void ath9k_hw_ani_cck_err_trigger_old(struct ath_hw *ah)
 					     aniState->firstepLevel + 1);
 	} else {
 		if ((conf->chan_conf->channel->band == IEEE80211_BAND_2GHZ) &&
-		    !conf_is_ht(conf)) {
+		    !conf_is_ht(conf->chan_conf)) {
 			if (aniState->firstepLevel > 0)
 				ath9k_hw_ani_control(ah,
 					     ATH9K_ANI_FIRSTEP_LEVEL, 0);
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 75f0ec5..966c621 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -252,7 +252,7 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 		if (chainmask & (1 << i)) {
 			s16 nfval;
 
-			if ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf))
+			if ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf->chan_conf))
 				continue;
 
 			if (h)
@@ -314,7 +314,7 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	ENABLE_REGWRITE_BUFFER(ah);
 	for (i = 0; i < NUM_NF_READINGS; i++) {
 		if (chainmask & (1 << i)) {
-			if ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf))
+			if ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf->chan_conf))
 				continue;
 
 			val = REG_READ(ah, ah->nf_regs[i]);
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 35d1c8e..21f253c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1168,7 +1168,7 @@ static ssize_t read_file_dump_nfcal(struct file *file, char __user *user_buf,
 			"Chain | privNF | # Readings | NF Readings\n");
 	for (i = 0; i < NUM_NF_READINGS; i++) {
 		if (!(chainmask & (1 << i)) ||
-		    ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf)))
+		    ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf->chan_conf)))
 			continue;
 
 		nread = AR_PHY_CCA_FILTERWINDOW_LENGTH - h[i].invalidNFcount;
@@ -1425,7 +1425,7 @@ static int open_file_bb_mac_samps(struct inode *inode, struct file *file)
 
 		for (i = 0; i < NUM_NF_READINGS; i++) {
 			if (!(chainmask & (1 << i)) ||
-			    ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf)))
+			    ((i >= AR5416_MAX_CHAINS) && !conf_is_ht40(conf->chan_conf)))
 				continue;
 
 			nread = AR_PHY_CCA_FILTERWINDOW_LENGTH -
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 241def0..890a580 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -269,7 +269,7 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 	ath_dbg(common, CONFIG,
 		"(%u MHz) -> (%u MHz), HT: %d, HT40: %d fastcc: %d\n",
 		priv->ah->curchan->channel,
-		channel->center_freq, conf_is_ht(conf), conf_is_ht40(conf),
+		channel->center_freq, conf_is_ht(conf->chan_conf), conf_is_ht40(conf->chan_conf),
 		fastcc);
 
 	if (!fastcc)
@@ -623,12 +623,12 @@ static void ath9k_htc_setup_rate(struct ath9k_htc_priv *priv,
 		if (sta->ht_cap.mcs.rx_mask[1])
 			caps |= WLAN_RC_DS_FLAG;
 		if ((sta->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
-		     (conf_is_ht40(&priv->hw->conf)))
+		     (conf_is_ht40(priv->hw->conf.chan_conf)))
 			caps |= WLAN_RC_40_FLAG;
-		if (conf_is_ht40(&priv->hw->conf) &&
+		if (conf_is_ht40(priv->hw->conf.chan_conf) &&
 		    (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_40))
 			caps |= WLAN_RC_SGI_FLAG;
-		else if (conf_is_ht20(&priv->hw->conf) &&
+		else if (conf_is_ht20(priv->hw->conf.chan_conf) &&
 			 (sta->ht_cap.cap & IEEE80211_HT_CAP_SGI_20))
 			caps |= WLAN_RC_SGI_FLAG;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index b1e106f..1bad6dc 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -416,7 +416,7 @@ static void ath9k_htc_check_tx_aggr(struct ath9k_htc_priv *priv,
 		return;
 	}
 
-	if (sta && conf_is_ht(&priv->hw->conf) &&
+	if (sta && conf_is_ht(priv->hw->conf.chan_conf) &&
 	    !(skb->protocol == cpu_to_be16(ETH_P_PAE))) {
 		if (ieee80211_is_data_qos(fc)) {
 			u8 *qc, tid;
@@ -879,7 +879,7 @@ u32 ath9k_htc_calcrxfilter(struct ath9k_htc_priv *priv)
 	else
 		rfilt |= ATH9K_RX_FILTER_BEACON;
 
-	if (conf_is_ht(&priv->hw->conf)) {
+	if (conf_is_ht(priv->hw->conf.chan_conf)) {
 		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
 		rfilt |= ATH9K_RX_FILTER_UNCOMP_BA_BAR;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b42e61b..11b9c23 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -101,7 +101,7 @@ static void ath9k_hw_set_clockrate(struct ath_hw *ah)
 	else
 		clockrate = ATH9K_CLOCK_RATE_5GHZ_OFDM;
 
-	if (conf_is_ht40(conf))
+	if (conf_is_ht40(conf->chan_conf))
 		clockrate *= 2;
 
 	if (ah->curchan) {
@@ -2771,7 +2771,7 @@ void ath9k_hw_set11nmac2040(struct ath_hw *ah)
 	struct ieee80211_conf *conf = &ath9k_hw_common(ah)->hw->conf;
 	u32 macmode;
 
-	if (conf_is_ht40(conf) && !ah->config.cwm_ignore_extcca)
+	if (conf_is_ht40(conf->chan_conf) && !ah->config.cwm_ignore_extcca)
 		macmode = AR_2040_JOINED_RX_CLEAR;
 	else
 		macmode = 0;
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index b1c58f0..2cf91eb 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -715,7 +715,7 @@ static void ath_rc_rate_set_series(const struct ath_rate_table *rate_table,
 	if (WLAN_RC_PHY_HT(rate_table->info[rix].phy)) {
 		rate->flags |= IEEE80211_TX_RC_MCS;
 		if (WLAN_RC_PHY_40(rate_table->info[rix].phy) &&
-		    conf_is_ht40(&txrc->hw->conf))
+		    conf_is_ht40(txrc->hw->conf.chan_conf))
 			rate->flags |= IEEE80211_TX_RC_40_MHZ_WIDTH;
 		if (WLAN_RC_PHY_SGI(rate_table->info[rix].phy))
 			rate->flags |= IEEE80211_TX_RC_SHORT_GI;
@@ -741,7 +741,7 @@ static void ath_rc_rate_set_rtscts(struct ath_softc *sc,
 	/* All protection frames are transmited at 2Mb/s for 802.11g,
 	 * otherwise we transmit them at 1Mb/s */
 	if (sc->hw->conf.chan_conf->channel->band == IEEE80211_BAND_2GHZ &&
-	    !conf_is_ht(&sc->hw->conf))
+	    !conf_is_ht(sc->hw->conf.chan_conf))
 		enable_g_protection = 1;
 
 	/*
@@ -798,11 +798,11 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	 * We don't need to check our own device's capabilities as our own
 	 * ht capabilities would have already been intersected with our peer's.
 	 */
-	if (conf_is_ht(&sc->hw->conf) &&
+	if (conf_is_ht(sc->hw->conf.chan_conf) &&
 	    (sta->ht_cap.cap & IEEE80211_HT_CAP_LDPC_CODING))
 		tx_info->flags |= IEEE80211_TX_CTL_LDPC;
 
-	if (conf_is_ht(&sc->hw->conf) &&
+	if (conf_is_ht(sc->hw->conf.chan_conf) &&
 	    (sta->ht_cap.cap & IEEE80211_HT_CAP_TX_STBC))
 		tx_info->flags |= (1 << IEEE80211_TX_CTL_STBC_SHIFT);
 
@@ -869,7 +869,7 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	 * above conditions.
 	 */
 	if ((sc->hw->conf.chan_conf->channel->band == IEEE80211_BAND_2GHZ) &&
-	    (conf_is_ht(&sc->hw->conf))) {
+	    (conf_is_ht(sc->hw->conf.chan_conf))) {
 		u8 dot11rate = rate_table->info[rix].dot11rate;
 		u8 phy = rate_table->info[rix].phy;
 		if (i == 4 &&
@@ -1371,7 +1371,7 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 			 long_retry);
 
 	/* Check if aggregation has to be enabled for this tid */
-	if (conf_is_ht(&sc->hw->conf) &&
+	if (conf_is_ht(sc->hw->conf.chan_conf) &&
 	    !(skb->protocol == cpu_to_be16(ETH_P_PAE))) {
 		if (ieee80211_is_data_qos(fc) &&
 		    skb_get_queue_mapping(skb) != IEEE80211_AC_VO) {
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 0420df4..becd2bc 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -457,7 +457,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	    (sc->rx.rxfilter & FIF_PSPOLL))
 		rfilt |= ATH9K_RX_FILTER_PSPOLL;
 
-	if (conf_is_ht(&sc->hw->conf))
+	if (conf_is_ht(sc->hw->conf.chan_conf))
 		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
 
 	if (sc->nvifs > 1 || (sc->rx.rxfilter & FIF_OTHER_BSS)) {
diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
index 91f6bfa..4c875ee 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -45,7 +45,7 @@ int carl9170_set_dyn_sifs_ack(struct ar9170 *ar)
 {
 	u32 val;
 
-	if (conf_is_ht40(&ar->hw->conf))
+	if (conf_is_ht40(ar->hw->conf.chan_conf))
 		val = 0x010a;
 	else {
 		if (ar->hw->conf.chan_conf->channel->band == IEEE80211_BAND_2GHZ)
@@ -61,7 +61,7 @@ int carl9170_set_rts_cts_rate(struct ar9170 *ar)
 {
 	u32 rts_rate, cts_rate;
 
-	if (conf_is_ht(&ar->hw->conf)) {
+	if (conf_is_ht(ar->hw->conf.chan_conf)) {
 		/* 12 mbit OFDM */
 		rts_rate = 0x1da;
 		cts_rate = 0x10a;
diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index 976ec51..d23bfdc 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -545,7 +545,7 @@ static int carl9170_init_phy(struct ar9170 *ar, enum ieee80211_band band)
 	int i, err;
 	u32 val;
 	bool is_2ghz = band == IEEE80211_BAND_2GHZ;
-	bool is_40mhz = conf_is_ht40(&ar->hw->conf);
+	bool is_40mhz = conf_is_ht40(ar->hw->conf.chan_conf);
 
 	carl9170_regwrite_begin(ar);
 
@@ -1583,10 +1583,10 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 
 	bw = nl80211_to_carl(_bw);
 
-	if (conf_is_ht(&ar->hw->conf))
+	if (conf_is_ht(ar->hw->conf.chan_conf))
 		new_ht |= CARL9170FW_PHY_HT_ENABLE;
 
-	if (conf_is_ht40(&ar->hw->conf))
+	if (conf_is_ht40(ar->hw->conf.chan_conf))
 		new_ht |= CARL9170FW_PHY_HT_DYN2040;
 
 	/* may be NULL at first setup */
@@ -1695,7 +1695,7 @@ int carl9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 	freqpar = carl9170_get_hw_dyn_params(channel, bw);
 
 	rf.ht_settings = new_ht;
-	if (conf_is_ht40(&ar->hw->conf))
+	if (conf_is_ht40(ar->hw->conf.chan_conf))
 		SET_VAL(CARL9170FW_PHY_HT_EXT_CHAN_OFF, rf.ht_settings, offs);
 
 	rf.freq = cpu_to_le32(channel->center_freq * 1000);
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index afc2c02..734df65 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3828,9 +3828,9 @@ static int b43_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	phy = &dev->phy;
 
-	if (conf_is_ht(conf))
+	if (conf_is_ht(conf->chan_conf))
 		phy->is_40mhz =
-			(conf_is_ht40_minus(conf) || conf_is_ht40_plus(conf));
+			(conf_is_ht40_minus(conf->chan_conf) || conf_is_ht40_plus(conf->chan_conf));
 	else
 		phy->is_40mhz = false;
 
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 7b54dbb..3dfa989 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -6049,13 +6049,13 @@ il4965_mac_channel_switch(struct ieee80211_hw *hw,
 	il->current_ht_config.smps = conf->smps_mode;
 
 	/* Configure HT40 channels */
-	il->ht.enabled = conf_is_ht(conf);
+	il->ht.enabled = conf_is_ht(conf->chan_conf);
 	if (il->ht.enabled) {
-		if (conf_is_ht40_minus(conf)) {
+		if (conf_is_ht40_minus(conf->chan_conf)) {
 			il->ht.extension_chan_offset =
 			    IEEE80211_HT_PARAM_CHA_SEC_BELOW;
 			il->ht.is_40mhz = true;
-		} else if (conf_is_ht40_plus(conf)) {
+		} else if (conf_is_ht40_plus(conf->chan_conf)) {
 			il->ht.extension_chan_offset =
 			    IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
 			il->ht.is_40mhz = true;
diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index f8921fa..34a3670 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -1180,7 +1180,7 @@ il4965_rs_switch_to_mimo2(struct il_priv *il, struct il_lq_sta *lq_sta,
 	s32 rate;
 	s8 is_green = lq_sta->is_green;
 
-	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
+	if (!conf_is_ht(conf->chan_conf) || !sta->ht_cap.ht_supported)
 		return -1;
 
 	if (((sta->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) >> 2) ==
@@ -1234,7 +1234,7 @@ il4965_rs_switch_to_siso(struct il_priv *il, struct il_lq_sta *lq_sta,
 	u8 is_green = lq_sta->is_green;
 	s32 rate;
 
-	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
+	if (!conf_is_ht(conf->chan_conf) || !sta->ht_cap.ht_supported)
 		return -1;
 
 	D_RATE("LQ: try to switch to SISO\n");
@@ -2097,7 +2097,7 @@ lq_update:
 		 * stay with best antenna legacy modulation for a while
 		 * before next round of mode comparisons. */
 		tbl1 = &(lq_sta->lq_info[lq_sta->active_tbl]);
-		if (is_legacy(tbl1->lq_type) && !conf_is_ht(conf) &&
+		if (is_legacy(tbl1->lq_type) && !conf_is_ht(conf->chan_conf) &&
 		    lq_sta->action_counter > tbl1->max_search) {
 			D_RATE("LQ: STAY in legacy table\n");
 			il4965_rs_set_stay_in_table(il, 1, lq_sta);
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index c2d73c9..b401885 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -5002,16 +5002,16 @@ il_mac_config(struct ieee80211_hw *hw, u32 changed)
 		spin_lock_irqsave(&il->lock, flags);
 
 		/* Configure HT40 channels */
-		if (il->ht.enabled != conf_is_ht(conf)) {
-			il->ht.enabled = conf_is_ht(conf);
+		if (il->ht.enabled != conf_is_ht(conf->chan_conf)) {
+			il->ht.enabled = conf_is_ht(conf->chan_conf);
 			ht_changed = true;
 		}
 		if (il->ht.enabled) {
-			if (conf_is_ht40_minus(conf)) {
+			if (conf_is_ht40_minus(conf->chan_conf)) {
 				il->ht.extension_chan_offset =
 				    IEEE80211_HT_PARAM_CHA_SEC_BELOW;
 				il->ht.is_40mhz = true;
-			} else if (conf_is_ht40_plus(conf)) {
+			} else if (conf_is_ht40_plus(conf->chan_conf)) {
 				il->ht.extension_chan_offset =
 				    IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
 				il->ht.is_40mhz = true;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 2b3d16d..6df91a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -1283,7 +1283,7 @@ static int rs_switch_to_mimo2(struct iwl_priv *priv,
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
 	struct iwl_rxon_context *ctx = sta_priv->ctx;
 
-	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
+	if (!conf_is_ht(conf->chan_conf) || !sta->ht_cap.ht_supported)
 		return -1;
 
 	if (((sta->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
@@ -1339,7 +1339,7 @@ static int rs_switch_to_mimo3(struct iwl_priv *priv,
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
 	struct iwl_rxon_context *ctx = sta_priv->ctx;
 
-	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
+	if (!conf_is_ht(conf->chan_conf) || !sta->ht_cap.ht_supported)
 		return -1;
 
 	if (((sta->ht_cap.cap & IEEE80211_HT_CAP_SM_PS) >> 2)
@@ -1396,7 +1396,7 @@ static int rs_switch_to_siso(struct iwl_priv *priv,
 	struct iwl_station_priv *sta_priv = (void *)sta->drv_priv;
 	struct iwl_rxon_context *ctx = sta_priv->ctx;
 
-	if (!conf_is_ht(conf) || !sta->ht_cap.ht_supported)
+	if (!conf_is_ht(conf->chan_conf) || !sta->ht_cap.ht_supported)
 		return -1;
 
 	IWL_DEBUG_RATE(priv, "LQ: try to switch to SISO\n");
@@ -2628,7 +2628,7 @@ lq_update:
 		 * stay with best antenna legacy modulation for a while
 		 * before next round of mode comparisons. */
 		tbl1 = &(lq_sta->lq_info[lq_sta->active_tbl]);
-		if (is_legacy(tbl1->lq_type) && !conf_is_ht(conf) &&
+		if (is_legacy(tbl1->lq_type) && !conf_is_ht(conf->chan_conf) &&
 		    lq_sta->action_counter > tbl1->max_search) {
 			IWL_DEBUG_RATE(priv, "LQ: STAY in legacy table\n");
 			rs_set_stay_in_table(priv, 1, lq_sta);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index ce575d9..db66c9f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -523,11 +523,11 @@ int iwlagn_commit_rxon(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 void iwlagn_config_ht40(struct ieee80211_conf *conf,
 	struct iwl_rxon_context *ctx)
 {
-	if (conf_is_ht40_minus(conf)) {
+	if (conf_is_ht40_minus(conf->chan_conf)) {
 		ctx->ht.extension_chan_offset =
 			IEEE80211_HT_PARAM_CHA_SEC_BELOW;
 		ctx->ht.is_40mhz = true;
-	} else if (conf_is_ht40_plus(conf)) {
+	} else if (conf_is_ht40_plus(conf->chan_conf)) {
 		ctx->ht.extension_chan_offset =
 			IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
 		ctx->ht.is_40mhz = true;
@@ -588,8 +588,8 @@ int iwlagn_mac_config(struct ieee80211_hw *hw, u32 changed)
 
 		for_each_context(priv, ctx) {
 			/* Configure HT40 channels */
-			if (ctx->ht.enabled != conf_is_ht(conf))
-				ctx->ht.enabled = conf_is_ht(conf);
+			if (ctx->ht.enabled != conf_is_ht(conf->chan_conf))
+				ctx->ht.enabled = conf_is_ht(conf->chan_conf);
 
 			if (ctx->ht.enabled) {
 				/* if HT40 is used, it should not change
diff --git a/drivers/net/wireless/iwlwifi/iwl-mac80211.c b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
index b6805f8..2a6bfa5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-mac80211.c
+++ b/drivers/net/wireless/iwlwifi/iwl-mac80211.c
@@ -879,7 +879,7 @@ static void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
 	priv->current_ht_config.smps = conf->smps_mode;
 
 	/* Configure HT40 channels */
-	ctx->ht.enabled = conf_is_ht(conf);
+	ctx->ht.enabled = conf_is_ht(conf->chan_conf);
 	if (ctx->ht.enabled)
 		iwlagn_config_ht40(conf, ctx);
 	else
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 59cd5d7..512e7bc 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1619,7 +1619,7 @@ static void rt2800_config_channel_rf2xxx(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&rf->rf4, RF4_TXPOWER_G, info->default_power2);
 	}
 
-	rt2x00_set_field32(&rf->rf4, RF4_HT40, conf_is_ht40(conf));
+	rt2x00_set_field32(&rf->rf4, RF4_HT40, conf_is_ht40(conf->chan_conf));
 
 	rt2800_rf_write(rt2x00dev, 1, rf->rf1);
 	rt2800_rf_write(rt2x00dev, 2, rf->rf2);
@@ -1713,10 +1713,10 @@ static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
 
 	if (rt2x00_rt(rt2x00dev, RT3390)) {
-		calib_tx = conf_is_ht40(conf) ? 0x68 : 0x4f;
-		calib_rx = conf_is_ht40(conf) ? 0x6f : 0x4f;
+		calib_tx = conf_is_ht40(conf->chan_conf) ? 0x68 : 0x4f;
+		calib_rx = conf_is_ht40(conf->chan_conf) ? 0x6f : 0x4f;
 	} else {
-		if (conf_is_ht40(conf)) {
+		if (conf_is_ht40(conf->chan_conf)) {
 			calib_tx = drv_data->calibration_bw40;
 			calib_rx = drv_data->calibration_bw40;
 		} else {
@@ -1843,7 +1843,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&rfcsr, RFCSR23_FREQ_OFFSET, rt2x00dev->freq_offset);
 	rt2800_rfcsr_write(rt2x00dev, 23, rfcsr);
 
-	if (conf_is_ht40(conf)) {
+	if (conf_is_ht40(conf->chan_conf)) {
 		rt2800_rfcsr_write(rt2x00dev, 24, drv_data->calibration_bw40);
 		rt2800_rfcsr_write(rt2x00dev, 31, drv_data->calibration_bw40);
 	} else {
@@ -2082,7 +2082,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	}
 
 	rt2800_register_read(rt2x00dev, TX_BAND_CFG, &reg);
-	rt2x00_set_field32(&reg, TX_BAND_CFG_HT40_MINUS, conf_is_ht40_minus(conf));
+	rt2x00_set_field32(&reg, TX_BAND_CFG_HT40_MINUS, conf_is_ht40_minus(conf->chan_conf));
 	rt2x00_set_field32(&reg, TX_BAND_CFG_A, rf->channel > 14);
 	rt2x00_set_field32(&reg, TX_BAND_CFG_BG, rf->channel <= 14);
 	rt2800_register_write(rt2x00dev, TX_BAND_CFG, reg);
@@ -2123,15 +2123,15 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_rfcsr_write(rt2x00dev, 8, 0x80);
 
 	rt2800_bbp_read(rt2x00dev, 4, &bbp);
-	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 2 * conf_is_ht40(conf));
+	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 2 * conf_is_ht40(conf->chan_conf));
 	rt2800_bbp_write(rt2x00dev, 4, bbp);
 
 	rt2800_bbp_read(rt2x00dev, 3, &bbp);
-	rt2x00_set_field8(&bbp, BBP3_HT40_MINUS, conf_is_ht40_minus(conf));
+	rt2x00_set_field8(&bbp, BBP3_HT40_MINUS, conf_is_ht40_minus(conf->chan_conf));
 	rt2800_bbp_write(rt2x00dev, 3, bbp);
 
 	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860C)) {
-		if (conf_is_ht40(conf)) {
+		if (conf_is_ht40(conf->chan_conf)) {
 			rt2800_bbp_write(rt2x00dev, 69, 0x1a);
 			rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 			rt2800_bbp_write(rt2x00dev, 73, 0x16);
diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index 1d0c232..a329333 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -189,9 +189,9 @@ static u16 rt2x00ht_center_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Adjust center channel to HT40+ and HT40- operation.
 	 */
-	if (conf_is_ht40_plus(conf))
+	if (conf_is_ht40_plus(conf->chan_conf))
 		center_channel += 2;
-	else if (conf_is_ht40_minus(conf))
+	else if (conf_is_ht40_minus(conf->chan_conf))
 		center_channel -= (center_channel == 14) ? 1 : 2;
 
 	for (i = 0; i < spec->num_channels; i++)
@@ -217,7 +217,7 @@ void rt2x00lib_config(struct rt2x00_dev *rt2x00dev,
 	libconf.conf = conf;
 
 	if (ieee80211_flags & IEEE80211_CONF_CHANGE_CHANNEL) {
-		if (conf_is_ht40(conf)) {
+		if (conf_is_ht40(conf->chan_conf)) {
 			set_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags);
 			hw_value = rt2x00ht_center_channel(rt2x00dev, conf);
 		} else {
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9527a48..c114b18 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3655,33 +3655,33 @@ int ieee80211_rate_control_register(struct rate_control_ops *ops);
 void ieee80211_rate_control_unregister(struct rate_control_ops *ops);
 
 static inline bool
-conf_is_ht20(struct ieee80211_conf *conf)
+conf_is_ht20(struct ieee80211_channel_conf *conf)
 {
-	return conf->chan_conf->channel_type == NL80211_CHAN_HT20;
+	return conf->channel_type == NL80211_CHAN_HT20;
 }
 
 static inline bool
-conf_is_ht40_minus(struct ieee80211_conf *conf)
+conf_is_ht40_minus(struct ieee80211_channel_conf *conf)
 {
-	return conf->chan_conf->channel_type == NL80211_CHAN_HT40MINUS;
+	return conf->channel_type == NL80211_CHAN_HT40MINUS;
 }
 
 static inline bool
-conf_is_ht40_plus(struct ieee80211_conf *conf)
+conf_is_ht40_plus(struct ieee80211_channel_conf *conf)
 {
-	return conf->chan_conf->channel_type == NL80211_CHAN_HT40PLUS;
+	return conf->channel_type == NL80211_CHAN_HT40PLUS;
 }
 
 static inline bool
-conf_is_ht40(struct ieee80211_conf *conf)
+conf_is_ht40(struct ieee80211_channel_conf *conf)
 {
 	return conf_is_ht40_minus(conf) || conf_is_ht40_plus(conf);
 }
 
 static inline bool
-conf_is_ht(struct ieee80211_conf *conf)
+conf_is_ht(struct ieee80211_channel_conf *conf)
 {
-	return conf->chan_conf->channel_type != NL80211_CHAN_NO_HT;
+	return conf->channel_type != NL80211_CHAN_NO_HT;
 }
 
 static inline enum nl80211_iftype
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 584f4d9..f9c6d33 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -139,7 +139,7 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
 		changed |= IEEE80211_CONF_CHANGE_CHANNEL;
 	}
 
-	if (!conf_is_ht(&local->hw.conf)) {
+	if (!conf_is_ht(&chan_state->conf)) {
 		/*
 		 * mac80211.h documents that this is only valid
 		 * when the channel is set to an HT type, and
-- 
1.7.0.4

