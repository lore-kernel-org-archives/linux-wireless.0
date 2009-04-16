Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:48025 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbZDPAiK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 20:38:10 -0400
Date: Thu, 16 Apr 2009 03:38:18 +0300
From: Nick Kossifidis <mick@madwifi-project.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Cc: jirislaby@gmail.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Subject: [PATCH 6/7] ath5k: Implement antenna control
Message-ID: <20090416003818.GF4138@makis> (sfid-20090416_023813_999933_5CE792C9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Add code to support the various antenna scenarios supported by hw

 * For now hardcode the default scenario (single or dual omnis with
 tx/rx diversity working and tx antenna handled by session -hw keeps
 track on which antenna it got ack from each ap/station and maps each
 ap/station to one of the antennas-).

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath/ath5k/ath5k.h  |   25 ++++-
 drivers/net/wireless/ath/ath5k/attach.c |    1 -
 drivers/net/wireless/ath/ath5k/base.c   |   66 +++++++++---
 drivers/net/wireless/ath/ath5k/eeprom.c |    8 +-
 drivers/net/wireless/ath/ath5k/eeprom.h |   11 +-
 drivers/net/wireless/ath/ath5k/phy.c    |  174 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath5k/reg.h    |    9 ++-
 drivers/net/wireless/ath/ath5k/reset.c  |   28 +++---
 8 files changed, 271 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 04b7345..33da290 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -209,7 +209,6 @@
 #define AR5K_TUNE_MAX_TXPOWER			63
 #define AR5K_TUNE_DEFAULT_TXPOWER		25
 #define AR5K_TUNE_TPC_TXPOWER			false
-#define AR5K_TUNE_ANT_DIVERSITY			true
 #define AR5K_TUNE_HWTXTRIES			4
 
 #define AR5K_INIT_CARR_SENSE_EN			1
@@ -420,6 +419,17 @@ enum ath5k_driver_mode {
 	AR5K_MODE_MAX		=	5
 };
 
+enum ath5k_ant_mode {
+	AR5K_ANTMODE_DEFAULT	= 0,	/* default antenna setup */
+	AR5K_ANTMODE_FIXED_A	= 1,	/* only antenna A is present */
+	AR5K_ANTMODE_FIXED_B	= 2,	/* only antenna B is present */
+	AR5K_ANTMODE_SINGLE_AP	= 3,	/* sta locked on a single ap */
+	AR5K_ANTMODE_SECTOR_AP	= 4,	/* AP with tx antenna set on tx desc */
+	AR5K_ANTMODE_SECTOR_STA	= 5,	/* STA with tx antenna set on tx desc */
+	AR5K_ANTMODE_DEBUG	= 6,	/* Debug mode -A -> Rx, B-> Tx- */
+	AR5K_ANTMODE_MAX,
+};
+
 
 /****************\
   TX DEFINITIONS
@@ -1051,8 +1061,11 @@ struct ath5k_hw {
 	bool			ah_software_retry;
 	u32			ah_limit_tx_retries;
 
-	u32			ah_antenna[AR5K_EEPROM_N_MODES][AR5K_ANT_MAX];
-	bool			ah_ant_diversity;
+	/* Antenna Control */
+	u32			ah_ant_ctl[AR5K_EEPROM_N_MODES][AR5K_ANT_MAX];
+	u8			ah_ant_mode;
+	u8			ah_tx_ant;
+	u8			ah_def_ant;
 
 	u8			ah_sta_id[ETH_ALEN];
 
@@ -1267,9 +1280,11 @@ extern int ath5k_hw_phy_calibrate(struct ath5k_hw *ah, struct ieee80211_channel
 extern int ath5k_hw_noise_floor_calibration(struct ath5k_hw *ah, short freq);
 /* Misc PHY functions */
 extern u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan);
-extern void ath5k_hw_set_def_antenna(struct ath5k_hw *ah, unsigned int ant);
-extern unsigned int ath5k_hw_get_def_antenna(struct ath5k_hw *ah);
 extern int ath5k_hw_phy_disable(struct ath5k_hw *ah);
+/* Antenna control */
+extern void ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode);
+extern void ath5k_hw_set_def_antenna(struct ath5k_hw *ah, u8 ant);
+extern unsigned int ath5k_hw_get_def_antenna(struct ath5k_hw *ah);
 /* TX power setup */
 extern int ath5k_hw_txpower(struct ath5k_hw *ah, struct ieee80211_channel *channel, u8 ee_mode, u8 txpower);
 extern int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower);
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 70d376c..c41ef58 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -133,7 +133,6 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	ah->ah_cw_min = AR5K_TUNE_CWMIN;
 	ah->ah_limit_tx_retries = AR5K_INIT_TX_RETRY;
 	ah->ah_software_retry = false;
-	ah->ah_ant_diversity = AR5K_TUNE_ANT_DIVERSITY;
 
 	/*
 	 * Set the mac version based on the pci id
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9f080a9..536149c 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1283,7 +1283,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 		ieee80211_get_hdrlen_from_skb(skb), AR5K_PKT_TYPE_NORMAL,
 		(sc->power_level * 2),
 		hw_rate,
-		info->control.rates[0].count, keyidx, 0, flags,
+		info->control.rates[0].count, keyidx, ah->ah_tx_ant, flags,
 		cts_rate, duration);
 	if (ret)
 		goto err_unmap;
@@ -2030,7 +2030,8 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	struct	ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ath5k_hw *ah = sc->ah;
 	struct ath5k_desc *ds;
-	int ret, antenna = 0;
+	int ret = 0;
+	u8 antenna;
 	u32 flags;
 
 	bf->skbaddr = pci_map_single(sc->pdev, skb->data, skb->len,
@@ -2044,23 +2045,35 @@ ath5k_beacon_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
 	}
 
 	ds = bf->desc;
+	antenna = ah->ah_tx_ant;
 
 	flags = AR5K_TXDESC_NOACK;
 	if (sc->opmode == NL80211_IFTYPE_ADHOC && ath5k_hw_hasveol(ah)) {
 		ds->ds_link = bf->daddr;	/* self-linked */
 		flags |= AR5K_TXDESC_VEOL;
-		/*
-		 * Let hardware handle antenna switching if txantenna is not set
-		 */
-	} else {
+	} else
 		ds->ds_link = 0;
-		/*
-		 * Switch antenna every 4 beacons if txantenna is not set
-		 * XXX assumes two antennas
-		 */
-		if (antenna == 0)
-			antenna = sc->bsent & 4 ? 2 : 1;
-	}
+
+	/*
+	 * If we use multiple antennas on AP and use
+	 * the Sectored AP scenario, switch antenna every
+	 * 4 beacons to make sure everybody hears our AP.
+	 * When a client tries to associate, hw will keep
+	 * track of the tx antenna to be used for this client
+	 * automaticaly, based on ACKed packets.
+	 *
+	 * Note: AP still listens and transmits RTS on the
+	 * default antenna which is supposed to be an omni.
+	 *
+	 * Note2: On sectored scenarios it's possible to have
+	 * multiple antennas (1omni -the default- and 14 sectors)
+	 * so if we choose to actually support this mode we need
+	 * to allow user to set how many antennas we have and tweak
+	 * the code below to send beacons on all of them.
+	 */
+	if (ah->ah_ant_mode == AR5K_ANTMODE_SECTOR_AP)
+		antenna = sc->bsent & 4 ? 2 : 1;
+
 
 	/* FIXME: If we are in g mode and rate is a CCK rate
 	 * subtract ah->ah_txpower.txp_cck_ofdm_pwr_delta
@@ -2773,12 +2786,16 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
 	struct ieee80211_conf *conf = &hw->conf;
-	int ret;
+	int ret = 0;
 
 	mutex_lock(&sc->lock);
 
 	sc->bintval = conf->beacon_int;
 
+	ret = ath5k_chan_set(sc, conf->channel);
+	if (ret < 0)
+		return ret;
+
 	if ((changed & IEEE80211_CONF_CHANGE_POWER) &&
 	(sc->power_level != conf->power_level)) {
 		sc->power_level = conf->power_level;
@@ -2787,10 +2804,27 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 		ath5k_hw_set_txpower_limit(ah, (conf->power_level * 2));
 	}
 
-	ret = ath5k_chan_set(sc, conf->channel);
+	/* TODO:
+	 * 1) Move this on config_interface and handle each case
+	 * separately eg. when we have only one STA vif, use
+	 * AR5K_ANTMODE_SINGLE_AP
+	 *
+	 * 2) Allow the user to change antenna mode eg. when only
+	 * one antenna is present
+	 *
+	 * 3) Allow the user to set default/tx antenna when possible
+	 *
+	 * 4) Default mode should handle 90% of the cases, together
+	 * with fixed a/b and single AP modes we should be able to
+	 * handle 99%. Sectored modes are extreme cases and i still
+	 * haven't found a usage for them. If we decide to support them,
+	 * then we must allow the user to set how many tx antennas we
+	 * have available
+	 */
+	ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_DEFAULT);
 
 	mutex_unlock(&sc->lock);
-	return ret;
+	return 0;
 }
 
 static int
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index cadcdae..6387676 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -208,16 +208,16 @@ static int ath5k_eeprom_read_ants(struct ath5k_hw *ah, u32 *offset,
 	ee->ee_ant_control[mode][i++]	= (val >> 6) & 0x3f;
 	ee->ee_ant_control[mode][i++]	= val & 0x3f;
 
-	/* Get antenna modes */
-	ah->ah_antenna[mode][0] =
+	/* Get antenna switch tables */
+	ah->ah_ant_ctl[mode][AR5K_ANT_CTL] =
 	    (ee->ee_ant_control[mode][0] << 4);
-	ah->ah_antenna[mode][AR5K_ANT_FIXED_A] =
+	ah->ah_ant_ctl[mode][AR5K_ANT_SWTABLE_A] =
 	     ee->ee_ant_control[mode][1] 	|
 	    (ee->ee_ant_control[mode][2] << 6) 	|
 	    (ee->ee_ant_control[mode][3] << 12) |
 	    (ee->ee_ant_control[mode][4] << 18) |
 	    (ee->ee_ant_control[mode][5] << 24);
-	ah->ah_antenna[mode][AR5K_ANT_FIXED_B] =
+	ah->ah_ant_ctl[mode][AR5K_ANT_SWTABLE_B] =
 	     ee->ee_ant_control[mode][6] 	|
 	    (ee->ee_ant_control[mode][7] << 6) 	|
 	    (ee->ee_ant_control[mode][8] << 12) |
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index 46e4d22..64be73a 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -240,11 +240,11 @@ enum ath5k_eeprom_freq_bands{
 #define AR5K_EEPROM_READ_HDR(_o, _v)					\
 	AR5K_EEPROM_READ(_o, ah->ah_capabilities.cap_eeprom._v);	\
 
-enum ath5k_ant_setting {
-	AR5K_ANT_VARIABLE	= 0,	/* variable by programming */
-	AR5K_ANT_FIXED_A	= 1,	/* fixed to 11a frequencies */
-	AR5K_ANT_FIXED_B	= 2,	/* fixed to 11b frequencies */
-	AR5K_ANT_MAX		= 3,
+enum ath5k_ant_table {
+	AR5K_ANT_CTL		= 0,	/* Idle switch table settings */
+	AR5K_ANT_SWTABLE_A	= 1,	/* Switch table for antenna A */
+	AR5K_ANT_SWTABLE_B	= 2,	/* Switch table for antenna B */
+	AR5K_ANT_MAX,
 };
 
 enum ath5k_ctl_mode {
@@ -461,6 +461,7 @@ struct ath5k_eeprom_info {
 	/* Spur mitigation data (fbin values for spur channels) */
 	u16	ee_spur_chans[AR5K_EEPROM_N_SPUR_CHANS][AR5K_EEPROM_N_FREQ_BANDS];
 
+	/* Antenna raw switch tables */
 	u32	ee_antenna[AR5K_EEPROM_N_MODES][AR5K_ANT_MAX];
 };
 
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index bb61b8e..7e666e6 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1414,25 +1414,189 @@ u16 ath5k_hw_radio_revision(struct ath5k_hw *ah, unsigned int chan)
 	return ret;
 }
 
+/*****************\
+* Antenna control *
+\*****************/
+
 void /*TODO:Boundary check*/
-ath5k_hw_set_def_antenna(struct ath5k_hw *ah, unsigned int ant)
+ath5k_hw_set_def_antenna(struct ath5k_hw *ah, u8 ant)
 {
 	ATH5K_TRACE(ah->ah_sc);
-	/*Just a try M.F.*/
+
 	if (ah->ah_version != AR5K_AR5210)
-		ath5k_hw_reg_write(ah, ant, AR5K_DEFAULT_ANTENNA);
+		ath5k_hw_reg_write(ah, ant & 0x7, AR5K_DEFAULT_ANTENNA);
 }
 
 unsigned int ath5k_hw_get_def_antenna(struct ath5k_hw *ah)
 {
 	ATH5K_TRACE(ah->ah_sc);
-	/*Just a try M.F.*/
+
 	if (ah->ah_version != AR5K_AR5210)
-		return ath5k_hw_reg_read(ah, AR5K_DEFAULT_ANTENNA);
+		return ath5k_hw_reg_read(ah, AR5K_DEFAULT_ANTENNA) & 0x7;
 
 	return false; /*XXX: What do we return for 5210 ?*/
 }
 
+/*
+ * Enable/disable fast rx antenna diversity
+ */
+void
+ath5k_hw_set_fast_div(struct ath5k_hw *ah, u8 ee_mode, bool enable)
+{
+	switch (ee_mode) {
+	case AR5K_EEPROM_MODE_11G:
+		/* XXX: This is set to
+		 * disabled on initvals !!! */
+	case AR5K_EEPROM_MODE_11A:
+		if (enable)
+			AR5K_REG_DISABLE_BITS(ah, AR5K_PHY_AGCCTL,
+					AR5K_PHY_AGCCTL_OFDM_DIV_DIS);
+		else
+			AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
+					AR5K_PHY_AGCCTL_OFDM_DIV_DIS);
+		break;
+	case AR5K_EEPROM_MODE_11B:
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
+					AR5K_PHY_AGCCTL_OFDM_DIV_DIS);
+		break;
+	default:
+		return;
+	}
+
+	if (enable) {
+		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_RESTART,
+				AR5K_PHY_RESTART_DIV_GC, 0xc);
+
+		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_FAST_ANT_DIV,
+					AR5K_PHY_FAST_ANT_DIV_EN);
+	} else {
+		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_RESTART,
+				AR5K_PHY_RESTART_DIV_GC, 0x8);
+
+		AR5K_REG_DISABLE_BITS(ah, AR5K_PHY_FAST_ANT_DIV,
+					AR5K_PHY_FAST_ANT_DIV_EN);
+	}
+}
+
+/*
+ * Set antenna operating mode
+ */
+void
+ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
+{
+	struct ieee80211_channel *channel = &ah->ah_current_channel;
+	bool use_def_for_tx, update_def_on_tx, use_def_for_rts, fast_div;
+	bool use_def_for_sg;
+	u8 def_ant, tx_ant, ee_mode;
+	u32 sta_id1 = 0;
+
+	def_ant = ah->ah_def_ant;
+
+	ATH5K_TRACE(ah->ah_sc);
+
+	switch (channel->hw_value & CHANNEL_MODES) {
+	case CHANNEL_A:
+	case CHANNEL_T:
+	case CHANNEL_XR:
+		ee_mode = AR5K_EEPROM_MODE_11A;
+		break;
+	case CHANNEL_G:
+	case CHANNEL_TG:
+		ee_mode = AR5K_EEPROM_MODE_11G;
+		break;
+	case CHANNEL_B:
+		ee_mode = AR5K_EEPROM_MODE_11B;
+		break;
+	default:
+		ATH5K_ERR(ah->ah_sc,
+			"invalid channel: %d\n", channel->center_freq);
+		return;
+	}
+
+	switch (ant_mode) {
+	case AR5K_ANTMODE_DEFAULT:
+		tx_ant = 0;
+		use_def_for_tx = false;
+		update_def_on_tx = false;
+		use_def_for_rts = false;
+		use_def_for_sg = false;
+		fast_div = true;
+		break;
+	case AR5K_ANTMODE_FIXED_A:
+		def_ant = 1;
+		tx_ant = 0;
+		use_def_for_tx = true;
+		update_def_on_tx = false;
+		use_def_for_rts = true;
+		use_def_for_sg = true;
+		fast_div = false;
+		break;
+	case AR5K_ANTMODE_FIXED_B:
+		def_ant = 2;
+		tx_ant = 0;
+		use_def_for_tx = true;
+		update_def_on_tx = false;
+		use_def_for_rts = true;
+		use_def_for_sg = true;
+		fast_div = false;
+		break;
+	case AR5K_ANTMODE_SINGLE_AP:
+		def_ant = 1;	/* updated on tx */
+		tx_ant = 0;
+		use_def_for_tx = true;
+		update_def_on_tx = true;
+		use_def_for_rts = true;
+		use_def_for_sg = true;
+		fast_div = true;
+		break;
+	case AR5K_ANTMODE_SECTOR_AP:
+		tx_ant = 1;	/* variable */
+		use_def_for_tx = false;
+		update_def_on_tx = false;
+		use_def_for_rts = true;
+		use_def_for_sg = false;
+		fast_div = false;
+		break;
+	case AR5K_ANTMODE_SECTOR_STA:
+		tx_ant = 1;	/* variable */
+		use_def_for_tx = true;
+		update_def_on_tx = false;
+		use_def_for_rts = true;
+		use_def_for_sg = false;
+		fast_div = true;
+		break;
+	case AR5K_ANTMODE_DEBUG:
+		def_ant = 1;
+		tx_ant = 2;
+		use_def_for_tx = false;
+		update_def_on_tx = false;
+		use_def_for_rts = false;
+		use_def_for_sg = false;
+		fast_div = false;
+		break;
+	default:
+		return;
+	}
+
+	ah->ah_tx_ant = tx_ant;
+	ah->ah_ant_mode = ant_mode;
+
+	sta_id1 |= use_def_for_tx ? AR5K_STA_ID1_DEFAULT_ANTENNA : 0;
+	sta_id1 |= update_def_on_tx ? AR5K_STA_ID1_DESC_ANTENNA : 0;
+	sta_id1 |= use_def_for_rts ? AR5K_STA_ID1_RTS_DEF_ANTENNA : 0;
+	sta_id1 |= use_def_for_sg ? AR5K_STA_ID1_SELFGEN_DEF_ANT : 0;
+
+	AR5K_REG_DISABLE_BITS(ah, AR5K_STA_ID1, AR5K_STA_ID1_ANTENNA_SETTINGS);
+
+	if (sta_id1)
+		AR5K_REG_ENABLE_BITS(ah, AR5K_STA_ID1, sta_id1);
+
+	/* Note: set diversity before default antenna
+	 * because it won't work correctly */
+	ath5k_hw_set_fast_div(ah, ee_mode, fast_div);
+	ath5k_hw_set_def_antenna(ah, def_ant);
+}
+
 
 /****************\
 * TX power setup *
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 7070d15..6809b54 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -1148,6 +1148,11 @@
 #define AR5K_STA_ID1_CBCIV_ENDIAN	0x40000000	/* ??? */
 #define AR5K_STA_ID1_KEYSRCH_MCAST	0x80000000	/* Do key cache search for mcast frames */
 
+#define	AR5K_STA_ID1_ANTENNA_SETTINGS	(AR5K_STA_ID1_DEFAULT_ANTENNA | \
+					AR5K_STA_ID1_DESC_ANTENNA | \
+					AR5K_STA_ID1_RTS_DEF_ANTENNA | \
+					AR5K_STA_ID1_SELFGEN_DEF_ANT)
+
 /*
  * First BSSID register (MAC address, lower 32bits)
  */
@@ -2028,7 +2033,9 @@
 #define	AR5K_PHY_AGCCTL			0x9860			/* Register address */
 #define	AR5K_PHY_AGCCTL_CAL		0x00000001	/* Enable PHY calibration */
 #define	AR5K_PHY_AGCCTL_NF		0x00000002	/* Enable Noise Floor calibration */
+#define	AR5K_PHY_AGCCTL_OFDM_DIV_DIS	0x00000008	/* Disable antenna diversity on OFDM modes */
 #define	AR5K_PHY_AGCCTL_NF_EN		0x00008000	/* Enable nf calibration to happen (?) */
+#define	AR5K_PHY_AGCTL_FLTR_CAL		0x00010000	/* Allow filter calibration (?) */
 #define	AR5K_PHY_AGCCTL_NF_NOUPDATE	0x00020000	/* Don't update nf automaticaly */
 
 /*
@@ -2528,7 +2535,7 @@
  * PHY CCK Cross-correlator Barker RSSI threshold register [5212+]
  */
 #define AR5K_PHY_CCK_CROSSCORR			0xa208
-#define AR5K_PHY_CCK_CROSSCORR_WEAK_SIG_THR	0x0000000f
+#define AR5K_PHY_CCK_CROSSCORR_WEAK_SIG_THR	0x0000003f
 #define AR5K_PHY_CCK_CROSSCORR_WEAK_SIG_THR_S	0
 
 /* Same address is used for antenna diversity activation */
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 9e5c4b4..69d6860 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -699,13 +699,13 @@ static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
 	/* Set antenna idle switch table */
 	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_ANT_CTL,
 			AR5K_PHY_ANT_CTL_SWTABLE_IDLE,
-			(ah->ah_antenna[ee_mode][0] |
+			(ah->ah_ant_ctl[ee_mode][0] |
 			AR5K_PHY_ANT_CTL_TXRX_EN));
 
-	/* Set antenna switch table */
-	ath5k_hw_reg_write(ah, ah->ah_antenna[ee_mode][ant[0]],
+	/* Set antenna switch tables */
+	ath5k_hw_reg_write(ah, ah->ah_ant_ctl[ee_mode][ant[0]],
 		AR5K_PHY_ANT_SWITCH_TABLE_0);
-	ath5k_hw_reg_write(ah, ah->ah_antenna[ee_mode][ant[1]],
+	ath5k_hw_reg_write(ah, ah->ah_ant_ctl[ee_mode][ant[1]],
 		AR5K_PHY_ANT_SWITCH_TABLE_1);
 
 	/* Noise floor threshold */
@@ -1043,17 +1043,15 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 
 		/*
 		 * In case a fixed antenna was set as default
-		 * write the same settings on both AR5K_PHY_ANT_SWITCH_TABLE
-		 * registers.
+		 * use the same switch table twice.
 		 */
-		if (s_ant != 0) {
-			if (s_ant == AR5K_ANT_FIXED_A) /* 1 - Main */
-				ant[0] = ant[1] = AR5K_ANT_FIXED_A;
-			else	/* 2 - Aux */
-				ant[0] = ant[1] = AR5K_ANT_FIXED_B;
-		} else {
-			ant[0] = AR5K_ANT_FIXED_A;
-			ant[1] = AR5K_ANT_FIXED_B;
+		if (ah->ah_ant_mode == AR5K_ANTMODE_FIXED_A)
+				ant[0] = ant[1] = AR5K_ANT_SWTABLE_A;
+		else if (ah->ah_ant_mode == AR5K_ANTMODE_FIXED_B)
+				ant[0] = ant[1] = AR5K_ANT_SWTABLE_B;
+		else {
+			ant[0] = AR5K_ANT_SWTABLE_A;
+			ant[1] = AR5K_ANT_SWTABLE_B;
 		}
 
 		/* Commit values from EEPROM */
@@ -1261,6 +1259,8 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	 */
 	ath5k_hw_noise_floor_calibration(ah, channel->center_freq);
 
+	/* Restore antenna mode */
+	ath5k_hw_set_antenna_mode(ah, ah->ah_ant_mode);
 
 	/*
 	 * Configure QCUs/DCUs
