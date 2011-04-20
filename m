Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:39037 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab1DTF2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 01:28:06 -0400
Received: by pxi2 with SMTP id 2so318340pxi.10
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 22:28:05 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19886.28538.315039.261736@gargle.gargle.HOWL>
Date: Wed, 20 Apr 2011 11:00:34 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 1/5] ath9k: Fix warnings from -Wunused-but-set-variable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ani.c            |    6 ------
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c  |    2 --
 drivers/net/wireless/ath/ath9k/ar9003_phy.c     |    6 +-----
 drivers/net/wireless/ath/ath9k/eeprom_9287.c    |    3 +--
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    6 +++---
 drivers/net/wireless/ath/ath9k/htc_drv_gpio.c   |    4 ++++
 drivers/net/wireless/ath/ath9k/htc_drv_main.c   |   11 ++++++++++-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c   |    2 --
 drivers/net/wireless/ath/ath9k/hw.c             |    4 +---
 drivers/net/wireless/ath/ath9k/rc.c             |   12 ++++--------
 drivers/net/wireless/ath/ath9k/recv.c           |    3 +--
 11 files changed, 25 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
index 2e31c77..5a1f4f5 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -899,12 +899,6 @@ void ath9k_hw_ani_init(struct ath_hw *ah)
 	 * check here default level should not modify INI setting.
 	 */
 	if (use_new_ani(ah)) {
-		const struct ani_ofdm_level_entry *entry_ofdm;
-		const struct ani_cck_level_entry *entry_cck;
-
-		entry_ofdm = &ofdm_level_table[ATH9K_ANI_OFDM_DEF_LEVEL];
-		entry_cck = &cck_level_table[ATH9K_ANI_CCK_DEF_LEVEL];
-
 		ah->aniperiod = ATH9K_ANI_PERIOD_NEW;
 		ah->config.ani_poll_interval = ATH9K_ANI_POLLINTERVAL_NEW;
 	} else {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 6eadf97..78cc8e6 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3217,7 +3217,6 @@ static int ar9300_compress_decision(struct ath_hw *ah,
 				    u8 *word, int length, int mdata_size)
 {
 	struct ath_common *common = ath9k_hw_common(ah);
-	u8 *dptr;
 	const struct ar9300_eeprom *eep = NULL;
 
 	switch (code) {
@@ -3235,7 +3234,6 @@ static int ar9300_compress_decision(struct ath_hw *ah,
 		break;
 	case _CompressBlock:
 		if (reference == 0) {
-			dptr = mptr;
 		} else {
 			eep = ar9003_eeprom_struct_find_by_id(reference);
 			if (eep == NULL) {
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 1bc33f5..3113aa8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -599,29 +599,25 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	struct ath_regulatory *regulatory = ath9k_hw_regulatory(ah);
 	unsigned int regWrites = 0, i;
 	struct ieee80211_channel *channel = chan->chan;
-	u32 modesIndex, freqIndex;
+	u32 modesIndex;
 
 	switch (chan->chanmode) {
 	case CHANNEL_A:
 	case CHANNEL_A_HT20:
 		modesIndex = 1;
-		freqIndex = 1;
 		break;
 	case CHANNEL_A_HT40PLUS:
 	case CHANNEL_A_HT40MINUS:
 		modesIndex = 2;
-		freqIndex = 1;
 		break;
 	case CHANNEL_G:
 	case CHANNEL_G_HT20:
 	case CHANNEL_B:
 		modesIndex = 4;
-		freqIndex = 2;
 		break;
 	case CHANNEL_G_HT40PLUS:
 	case CHANNEL_G_HT40MINUS:
 		modesIndex = 3;
-		freqIndex = 2;
 		break;
 
 	default:
diff --git a/drivers/net/wireless/ath/ath9k/eeprom_9287.c b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
index 1357975..b87db47 100644
--- a/drivers/net/wireless/ath/ath9k/eeprom_9287.c
+++ b/drivers/net/wireless/ath/ath9k/eeprom_9287.c
@@ -319,10 +319,9 @@ static void ath9k_hw_set_ar9287_power_cal_table(struct ath_hw *ah,
 	u16 numXpdGain, xpdMask;
 	u16 xpdGainValues[AR5416_NUM_PD_GAINS] = {0, 0, 0, 0};
 	u32 reg32, regOffset, regChainOffset, regval;
-	int16_t modalIdx, diff = 0;
+	int16_t diff = 0;
 	struct ar9287_eeprom *pEepData = &ah->eeprom.map9287;
 
-	modalIdx = IS_CHAN_2GHZ(chan) ? 1 : 0;
 	xpdMask = pEepData->modalHeader.xpdGain;
 
 	if ((pEepData->baseEepHeader.version & AR9287_EEP_VER_MINOR_MASK) >=
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index a157107..0ded2c6 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -74,7 +74,7 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 	__be32 htc_imask = 0;
 	u64 tsf;
 	int num_beacons, offset, dtim_dec_count, cfp_dec_count;
-	int ret;
+	int ret __attribute__ ((unused));
 	u8 cmd_rsp;
 
 	memset(&bs, 0, sizeof(bs));
@@ -190,7 +190,7 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
 	enum ath9k_int imask = 0;
 	u32 nexttbtt, intval, tsftu;
 	__be32 htc_imask = 0;
-	int ret;
+	int ret __attribute__ ((unused));
 	u8 cmd_rsp;
 	u64 tsf;
 
@@ -246,7 +246,7 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
 	enum ath9k_int imask = 0;
 	u32 nexttbtt, intval, tsftu;
 	__be32 htc_imask = 0;
-	int ret;
+	int ret __attribute__ ((unused));
 	u8 cmd_rsp;
 	u64 tsf;
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
index dc0b33d..138f8e1 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_gpio.c
@@ -74,6 +74,10 @@ static void ath_btcoex_period_work(struct work_struct *work)
 	aggr = priv->op_flags & OP_BT_PRIORITY_DETECTED;
 
 	WMI_CMD_BUF(WMI_AGGR_LIMIT_CMD, &aggr);
+	if (ret) {
+		ath_err(common, "Unable to set BTCOEX parameters\n");
+		return;
+	}
 
 	ath9k_cmn_btcoex_bt_stomp(common, is_btscan ? ATH_BTCOEX_STOMP_ALL :
 			btcoex->bt_stomp_type);
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 4de3864..7cff554 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -332,6 +332,11 @@ static void __ath9k_htc_remove_monitor_interface(struct ath9k_htc_priv *priv)
 	memcpy(&hvif.myaddr, common->macaddr, ETH_ALEN);
 	hvif.index = priv->mon_vif_idx;
 	WMI_CMD_BUF(WMI_VAP_REMOVE_CMDID, &hvif);
+	if (ret) {
+		ath_err(common, "Unable to remove monitor interface at idx: %d\n",
+			priv->mon_vif_idx);
+	}
+
 	priv->nvifs--;
 	priv->vif_slot &= ~(1 << priv->mon_vif_idx);
 }
@@ -964,7 +969,7 @@ static void ath9k_htc_stop(struct ieee80211_hw *hw)
 	struct ath9k_htc_priv *priv = hw->priv;
 	struct ath_hw *ah = priv->ah;
 	struct ath_common *common = ath9k_hw_common(ah);
-	int ret = 0;
+	int ret __attribute__ ((unused));
 	u8 cmd_rsp;
 
 	mutex_lock(&priv->mutex);
@@ -1135,6 +1140,10 @@ static void ath9k_htc_remove_interface(struct ieee80211_hw *hw,
 	memcpy(&hvif.myaddr, vif->addr, ETH_ALEN);
 	hvif.index = avp->index;
 	WMI_CMD_BUF(WMI_VAP_REMOVE_CMDID, &hvif);
+	if (ret) {
+		ath_err(common, "Unable to remove interface at idx: %d\n",
+			avp->index);
+	}
 	priv->nvifs--;
 	priv->vif_slot &= ~(1 << avp->index);
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 723a3a9..a898dac 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -446,7 +446,6 @@ static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rate;
 	struct ieee80211_conf *cur_conf = &priv->hw->conf;
-	struct ieee80211_supported_band *sband;
 	bool txok;
 	int slot;
 
@@ -461,7 +460,6 @@ static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
 	tx_info = IEEE80211_SKB_CB(skb);
 	vif = tx_info->control.vif;
 	rate = &tx_info->status.rates[0];
-	sband = priv->hw->wiphy->bands[cur_conf->channel->band];
 
 	memset(&tx_info->status, 0, sizeof(tx_info->status));
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 045abd5..7a9d4a4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1793,7 +1793,7 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_btcoex_hw *btcoex_hw = &ah->btcoex_hw;
 
-	u16 capField = 0, eeval;
+	u16 eeval;
 	u8 ant_div_ctl1, tx_chainmask, rx_chainmask;
 
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_0);
@@ -1804,8 +1804,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 		eeval |= AR9285_RDEXT_DEFAULT;
 	regulatory->current_rd_ext = eeval;
 
-	capField = ah->eep_ops->get_eeprom(ah, EEP_OP_CAP);
-
 	if (ah->opmode != NL80211_IFTYPE_AP &&
 	    ah->hw_version.subvendorid == AR_SUBVENDOR_ID_NEW_A) {
 		if (regulatory->current_rd == 0x64 ||
diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 1809409..4ccbf2d 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -854,14 +854,13 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	ath_rc_rate_set_rtscts(sc, rate_table, tx_info);
 }
 
-static bool ath_rc_update_per(struct ath_softc *sc,
+static void ath_rc_update_per(struct ath_softc *sc,
 			      const struct ath_rate_table *rate_table,
 			      struct ath_rate_priv *ath_rc_priv,
 				  struct ieee80211_tx_info *tx_info,
 			      int tx_rate, int xretries, int retries,
 			      u32 now_msec)
 {
-	bool state_change = false;
 	int count, n_bad_frames;
 	u8 last_per;
 	static const u32 nretry_to_per_lookup[10] = {
@@ -992,8 +991,6 @@ static bool ath_rc_update_per(struct ath_softc *sc,
 
 		}
 	}
-
-	return state_change;
 }
 
 static void ath_debug_stat_retries(struct ath_rate_priv *rc, int rix,
@@ -1017,7 +1014,6 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	u32 now_msec = jiffies_to_msecs(jiffies);
 	int rate;
 	u8 last_per;
-	bool state_change = false;
 	const struct ath_rate_table *rate_table = ath_rc_priv->rate_table;
 	int size = ath_rc_priv->rate_table_size;
 
@@ -1027,9 +1023,9 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	last_per = ath_rc_priv->per[tx_rate];
 
 	/* Update PER first */
-	state_change = ath_rc_update_per(sc, rate_table, ath_rc_priv,
-					 tx_info, tx_rate, xretries,
-					 retries, now_msec);
+	ath_rc_update_per(sc, rate_table, ath_rc_priv,
+			  tx_info, tx_rate, xretries,
+			  retries, now_msec);
 
 	/*
 	 * If this rate looks bad (high PER) then stop using it for
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index f69dcdf..abb9cd6 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -1339,7 +1339,7 @@ static void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 	struct ath_hw_antcomb_conf div_ant_conf;
 	struct ath_ant_comb *antcomb = &sc->ant_comb;
 	int alt_ratio = 0, alt_rssi_avg = 0, main_rssi_avg = 0, curr_alt_set;
-	int curr_main_set, curr_bias;
+	int curr_main_set;
 	int main_rssi = rs->rs_rssi_ctl0;
 	int alt_rssi = rs->rs_rssi_ctl1;
 	int rx_ant_conf,  main_ant_conf;
@@ -1393,7 +1393,6 @@ static void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs)
 	ath9k_hw_antdiv_comb_conf_get(sc->sc_ah, &div_ant_conf);
 	curr_alt_set = div_ant_conf.alt_lna_conf;
 	curr_main_set = div_ant_conf.main_lna_conf;
-	curr_bias = div_ant_conf.fast_div_bias;
 
 	antcomb->count++;
 
-- 
1.7.4.4

