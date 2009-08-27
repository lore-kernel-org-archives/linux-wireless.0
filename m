Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1192 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbZH0VkV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 17:40:21 -0400
Date: Thu, 27 Aug 2009 17:39:21 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: mickflemm@gmail.com, proski@gnu.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix uninitialized value use
	in ath5k_eeprom_read_turbo_modes()
Message-ID: <20090827213921.GB30419@hash.localnet>
References: <20090827023000.21926.90867.stgit@mj.roinet.com> <40f31dec0908270558y2a3a565bvcc7e470b7f2644c6@mail.gmail.com> <b6c5339f0908271117q3a893d4dma9df0ac441091dbf@mail.gmail.com> <43e72e890908271125x378da3abw41e7f73dd8fbfe81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890908271125x378da3abw41e7f73dd8fbfe81@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 27, 2009 at 11:25:03AM -0700, Luis R. Rodriguez wrote:
> > Well, we also don't use the turbo modes at all and that's where the
> > error is (IIRC) so it shouldn't have any impact. :)
> 
> Again, why don't we just remove all that fucking turbo cruft?

OK with me since no one seems to care enough to implement mac80211
support.  I left some of the #defines in place as they are useful
documentation.  Approx. 80 of the lines removed are comments.

   text	   data	    bss	    dec	    hex	filename
 136746	    480	     56	 137282	  21842	ath5k_old.ko
 134913	    480	     56	 135449	  21119	ath5k_new.ko

Disclaimer: only barely tested.

---
 drivers/net/wireless/ath/ath5k/ath5k.h    |   84 +-------
 drivers/net/wireless/ath/ath5k/attach.c   |    1 -
 drivers/net/wireless/ath/ath5k/base.c     |    7 -
 drivers/net/wireless/ath/ath5k/caps.c     |    6 -
 drivers/net/wireless/ath/ath5k/eeprom.c   |   68 +------
 drivers/net/wireless/ath/ath5k/eeprom.h   |    7 -
 drivers/net/wireless/ath/ath5k/initvals.c |  335 ++++++++++++++---------------
 drivers/net/wireless/ath/ath5k/pcu.c      |   16 +-
 drivers/net/wireless/ath/ath5k/phy.c      |   26 +---
 drivers/net/wireless/ath/ath5k/qcu.c      |   57 ++----
 drivers/net/wireless/ath/ath5k/reset.c    |  115 ++--------
 11 files changed, 223 insertions(+), 499 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 1275ba0..cf432ce 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -349,73 +349,11 @@ struct ath5k_srev_name {
 /* IEEE defs */
 #define IEEE80211_MAX_LEN       2500
 
-/* TODO add support to mac80211 for vendor-specific rates and modes */
-
-/*
- * Some of this information is based on Documentation from:
- *
- * http://madwifi.org/wiki/ChipsetFeatures/SuperAG
- *
- * Modulation for Atheros' eXtended Range - range enhancing extension that is
- * supposed to double the distance an Atheros client device can keep a
- * connection with an Atheros access point. This is achieved by increasing
- * the receiver sensitivity up to, -105dBm, which is about 20dB above what
- * the 802.11 specifications demand. In addition, new (proprietary) data rates
- * are introduced: 3, 2, 1, 0.5 and 0.25 MBit/s.
- *
- * Please note that can you either use XR or TURBO but you cannot use both,
- * they are exclusive.
- *
- */
-#define MODULATION_XR 		0x00000200
-/*
- * Modulation for Atheros' Turbo G and Turbo A, its supposed to provide a
- * throughput transmission speed up to 40Mbit/s-60Mbit/s at a 108Mbit/s
- * signaling rate achieved through the bonding of two 54Mbit/s 802.11g
- * channels. To use this feature your Access Point must also suport it.
- * There is also a distinction between "static" and "dynamic" turbo modes:
- *
- * - Static: is the dumb version: devices set to this mode stick to it until
- *     the mode is turned off.
- * - Dynamic: is the intelligent version, the network decides itself if it
- *     is ok to use turbo. As soon as traffic is detected on adjacent channels
- *     (which would get used in turbo mode), or when a non-turbo station joins
- *     the network, turbo mode won't be used until the situation changes again.
- *     Dynamic mode is achieved by Atheros' Adaptive Radio (AR) feature which
- *     monitors the used radio band in order to decide whether turbo mode may
- *     be used or not.
- *
- * This article claims Super G sticks to bonding of channels 5 and 6 for
- * USA:
- *
- * http://www.pcworld.com/article/id,113428-page,1/article.html
- *
- * The channel bonding seems to be driver specific though. In addition to
- * deciding what channels will be used, these "Turbo" modes are accomplished
- * by also enabling the following features:
- *
- * - Bursting: allows multiple frames to be sent at once, rather than pausing
- *     after each frame. Bursting is a standards-compliant feature that can be
- *     used with any Access Point.
- * - Fast frames: increases the amount of information that can be sent per
- *     frame, also resulting in a reduction of transmission overhead. It is a
- *     proprietary feature that needs to be supported by the Access Point.
- * - Compression: data frames are compressed in real time using a Lempel Ziv
- *     algorithm. This is done transparently. Once this feature is enabled,
- *     compression and decompression takes place inside the chipset, without
- *     putting additional load on the host CPU.
- *
- */
-#define MODULATION_TURBO	0x00000080
-
 enum ath5k_driver_mode {
 	AR5K_MODE_11A		=	0,
-	AR5K_MODE_11A_TURBO	=	1,
-	AR5K_MODE_11B		=	2,
-	AR5K_MODE_11G		=	3,
-	AR5K_MODE_11G_TURBO	=	4,
-	AR5K_MODE_XR		=	0,
-	AR5K_MODE_MAX		=	5
+	AR5K_MODE_11B		=	1,
+	AR5K_MODE_11G		=	2,
+	AR5K_MODE_MAX		=	3
 };
 
 enum ath5k_ant_mode {
@@ -506,7 +444,6 @@ enum ath5k_tx_queue_id {
 	AR5K_TX_QUEUE_ID_CAB		= 6, /*IEEE80211_TX_QUEUE_AFTER_BEACON*/
 	AR5K_TX_QUEUE_ID_BEACON		= 7, /*IEEE80211_TX_QUEUE_BEACON*/
 	AR5K_TX_QUEUE_ID_UAPSD		= 8,
-	AR5K_TX_QUEUE_ID_XR_DATA	= 9,
 };
 
 /*
@@ -696,11 +633,6 @@ struct ath5k_gain {
 #define	CHANNEL_A	(CHANNEL_5GHZ|CHANNEL_OFDM)
 #define	CHANNEL_B	(CHANNEL_2GHZ|CHANNEL_CCK)
 #define	CHANNEL_G	(CHANNEL_2GHZ|CHANNEL_OFDM)
-#define	CHANNEL_T	(CHANNEL_5GHZ|CHANNEL_OFDM|CHANNEL_TURBO)
-#define	CHANNEL_TG	(CHANNEL_2GHZ|CHANNEL_OFDM|CHANNEL_TURBO)
-#define	CHANNEL_108A	CHANNEL_T
-#define	CHANNEL_108G	CHANNEL_TG
-#define	CHANNEL_X	(CHANNEL_5GHZ|CHANNEL_OFDM|CHANNEL_XR)
 
 #define	CHANNEL_ALL 	(CHANNEL_OFDM|CHANNEL_CCK|CHANNEL_2GHZ|CHANNEL_5GHZ| \
 		CHANNEL_TURBO)
@@ -712,7 +644,6 @@ struct ath5k_gain {
  * Used internaly for reset_tx_queue).
  * Also see struct struct ieee80211_channel.
  */
-#define IS_CHAN_XR(_c)	((_c->hw_value & CHANNEL_XR) != 0)
 #define IS_CHAN_B(_c)	((_c->hw_value & CHANNEL_B) != 0)
 
 /*
@@ -1035,7 +966,6 @@ struct ath5k_hw {
 
 	enum nl80211_iftype	ah_op_mode;
 	struct ieee80211_channel *ah_current_channel;
-	bool			ah_turbo;
 	bool			ah_calibration;
 	bool			ah_single_chip;
 	bool			ah_aes_support;
@@ -1315,18 +1245,18 @@ extern int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower);
  * Translate usec to hw clock units
  * TODO: Half/quarter rate
  */
-static inline unsigned int ath5k_hw_htoclock(unsigned int usec, bool turbo)
+static inline unsigned int ath5k_hw_htoclock(unsigned int usec)
 {
-	return turbo ? (usec * 80) : (usec * 40);
+	return (usec * 40);
 }
 
 /*
  * Translate hw clock units to usec
  * TODO: Half/quarter rate
  */
-static inline unsigned int ath5k_hw_clocktoh(unsigned int clock, bool turbo)
+static inline unsigned int ath5k_hw_clocktoh(unsigned int clock)
 {
-	return turbo ? (clock / 80) : (clock / 40);
+	return (clock / 40);
 }
 
 /*
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 4819f39..49d973b 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -126,7 +126,6 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	 */
 	ah->ah_op_mode = NL80211_IFTYPE_STATION;
 	ah->ah_radar.r_enabled = AR5K_TUNE_RADAR_ALERT;
-	ah->ah_turbo = false;
 	ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
 	ah->ah_imr = 0;
 	ah->ah_atim_window = 0;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 94d46fd..b1804e5 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -924,14 +924,12 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 
 	switch (mode) {
 	case AR5K_MODE_11A:
-	case AR5K_MODE_11A_TURBO:
 		/* 1..220, but 2GHz frequencies are filtered by check_channel */
 		size = 220 ;
 		chfreq = CHANNEL_5GHZ;
 		break;
 	case AR5K_MODE_11B:
 	case AR5K_MODE_11G:
-	case AR5K_MODE_11G_TURBO:
 		size = 26;
 		chfreq = CHANNEL_2GHZ;
 		break;
@@ -960,11 +958,6 @@ ath5k_copy_channels(struct ath5k_hw *ah,
 		case AR5K_MODE_11G:
 			channels[count].hw_value = chfreq | CHANNEL_OFDM;
 			break;
-		case AR5K_MODE_11A_TURBO:
-		case AR5K_MODE_11G_TURBO:
-			channels[count].hw_value = chfreq |
-				CHANNEL_OFDM | CHANNEL_TURBO;
-			break;
 		case AR5K_MODE_11B:
 			channels[count].hw_value = CHANNEL_B;
 		}
diff --git a/drivers/net/wireless/ath/ath5k/caps.c b/drivers/net/wireless/ath/ath5k/caps.c
index 367a6c7..2b9ffbb 100644
--- a/drivers/net/wireless/ath/ath5k/caps.c
+++ b/drivers/net/wireless/ath/ath5k/caps.c
@@ -50,7 +50,6 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 
 		/* Set supported modes */
 		__set_bit(AR5K_MODE_11A, ah->ah_capabilities.cap_mode);
-		__set_bit(AR5K_MODE_11A_TURBO, ah->ah_capabilities.cap_mode);
 	} else {
 		/*
 		 * XXX The tranceiver supports frequencies from 4920 to 6100GHz
@@ -75,11 +74,6 @@ int ath5k_hw_set_capabilities(struct ath5k_hw *ah)
 			/* Set supported modes */
 			__set_bit(AR5K_MODE_11A,
 					ah->ah_capabilities.cap_mode);
-			__set_bit(AR5K_MODE_11A_TURBO,
-					ah->ah_capabilities.cap_mode);
-			if (ah->ah_version == AR5K_AR5212)
-				__set_bit(AR5K_MODE_11G_TURBO,
-						ah->ah_capabilities.cap_mode);
 		}
 
 		/* Enable  802.11b if a 2GHz capable radio (2111/5112) is
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 8af477d..ccc5897 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -311,9 +311,7 @@ static int ath5k_eeprom_read_modes(struct ath5k_hw *ah, u32 *offset,
 		AR5K_EEPROM_READ(o++, val);
 		ee->ee_false_detect[mode] = (val >> 6) & 0x7f;
 
-		if (mode == AR5K_EEPROM_MODE_11A)
-			ee->ee_xr_power[mode] = val & 0x3f;
-		else {
+		if (mode != AR5K_EEPROM_MODE_11A) {
 			ee->ee_ob[mode][0] = val & 0x7;
 			ee->ee_db[mode][0] = (val >> 3) & 0x7;
 		}
@@ -390,9 +388,8 @@ static int ath5k_eeprom_read_modes(struct ath5k_hw *ah, u32 *offset,
 		if (ee->ee_pwr_cal_g[1].freq != AR5K_EEPROM_CHANNEL_DIS)
 			ee->ee_n_piers[mode]++;
 
+		/* turbo/xr */
 		AR5K_EEPROM_READ(o++, val);
-		ee->ee_turbo_max_power[mode] = val & 0x7f;
-		ee->ee_xr_power[mode] = (val >> 7) & 0x3f;
 
 		AR5K_EEPROM_READ(o++, val);
 		ee->ee_pwr_cal_g[2].freq =
@@ -421,59 +418,6 @@ done:
 	return 0;
 }
 
-/*
- * Read turbo mode information on newer EEPROM versions
- */
-static int
-ath5k_eeprom_read_turbo_modes(struct ath5k_hw *ah,
-			      u32 *offset, unsigned int mode)
-{
-	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
-	u32 o = *offset;
-	u16 val;
-	int ret;
-
-	if (ee->ee_version < AR5K_EEPROM_VERSION_5_0)
-		return 0;
-
-	switch (mode){
-	case AR5K_EEPROM_MODE_11A:
-		ee->ee_switch_settling_turbo[mode] = (val >> 6) & 0x7f;
-
-		ee->ee_atn_tx_rx_turbo[mode] = (val >> 13) & 0x7;
-		AR5K_EEPROM_READ(o++, val);
-		ee->ee_atn_tx_rx_turbo[mode] |= (val & 0x7) << 3;
-		ee->ee_margin_tx_rx_turbo[mode] = (val >> 3) & 0x3f;
-
-		ee->ee_adc_desired_size_turbo[mode] = (val >> 9) & 0x7f;
-		AR5K_EEPROM_READ(o++, val);
-		ee->ee_adc_desired_size_turbo[mode] |= (val & 0x1) << 7;
-		ee->ee_pga_desired_size_turbo[mode] = (val >> 1) & 0xff;
-
-		if (AR5K_EEPROM_EEMAP(ee->ee_misc0) >=2)
-			ee->ee_pd_gain_overlap = (val >> 9) & 0xf;
-		break;
-	case AR5K_EEPROM_MODE_11G:
-		ee->ee_switch_settling_turbo[mode] = (val >> 8) & 0x7f;
-
-		ee->ee_atn_tx_rx_turbo[mode] = (val >> 15) & 0x7;
-		AR5K_EEPROM_READ(o++, val);
-		ee->ee_atn_tx_rx_turbo[mode] |= (val & 0x1f) << 1;
-		ee->ee_margin_tx_rx_turbo[mode] = (val >> 5) & 0x3f;
-
-		ee->ee_adc_desired_size_turbo[mode] = (val >> 11) & 0x7f;
-		AR5K_EEPROM_READ(o++, val);
-		ee->ee_adc_desired_size_turbo[mode] |= (val & 0x7) << 5;
-		ee->ee_pga_desired_size_turbo[mode] = (val >> 3) & 0xff;
-		break;
-	}
-
-	/* return new offset */
-	*offset = o;
-
-	return 0;
-}
-
 /* Read mode-specific data (except power calibration data) */
 static int
 ath5k_eeprom_init_modes(struct ath5k_hw *ah)
@@ -491,9 +435,6 @@ ath5k_eeprom_init_modes(struct ath5k_hw *ah)
 	mode_offset[AR5K_EEPROM_MODE_11B] = AR5K_EEPROM_MODES_11B(ah->ah_ee_version);
 	mode_offset[AR5K_EEPROM_MODE_11G] = AR5K_EEPROM_MODES_11G(ah->ah_ee_version);
 
-	ee->ee_turbo_max_power[AR5K_EEPROM_MODE_11A] =
-		AR5K_EEPROM_HDR_T_5GHZ_DBM(ee->ee_header);
-
 	for (mode = AR5K_EEPROM_MODE_11A; mode <= AR5K_EEPROM_MODE_11G; mode++) {
 		offset = mode_offset[mode];
 
@@ -504,10 +445,6 @@ ath5k_eeprom_init_modes(struct ath5k_hw *ah)
 		ret = ath5k_eeprom_read_modes(ah, &offset, mode);
 		if (ret)
 			return ret;
-
-		ret = ath5k_eeprom_read_turbo_modes(ah, &offset, mode);
-		if (ret)
-			return ret;
 	}
 
 	/* override for older eeprom versions for better performance */
@@ -1640,7 +1577,6 @@ ath5k_eeprom_read_ctl_info(struct ath5k_hw *ah)
 	for(i = 0; i < ee->ee_ctls; i++) {
 		switch(ee->ee_ctl[i] & AR5K_CTL_MODE_M) {
 		case AR5K_CTL_11A:
-		case AR5K_CTL_TURBO:
 			ctl_mode = AR5K_EEPROM_MODE_11A;
 			break;
 		default:
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index 0123f35..0ca1758 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -410,8 +410,6 @@ struct ath5k_eeprom_info {
 	u16	ee_i_cal[AR5K_EEPROM_N_MODES];
 	u16	ee_q_cal[AR5K_EEPROM_N_MODES];
 	u16	ee_fixed_bias[AR5K_EEPROM_N_MODES];
-	u16	ee_turbo_max_power[AR5K_EEPROM_N_MODES];
-	u16	ee_xr_power[AR5K_EEPROM_N_MODES];
 	u16	ee_switch_settling[AR5K_EEPROM_N_MODES];
 	u16	ee_atn_tx_rx[AR5K_EEPROM_N_MODES];
 	u16	ee_ant_control[AR5K_EEPROM_N_MODES][AR5K_EEPROM_N_PCDAC];
@@ -426,9 +424,6 @@ struct ath5k_eeprom_info {
 	u16	ee_x_gain[AR5K_EEPROM_N_MODES];
 	u16	ee_i_gain[AR5K_EEPROM_N_MODES];
 	u16	ee_margin_tx_rx[AR5K_EEPROM_N_MODES];
-	u16	ee_switch_settling_turbo[AR5K_EEPROM_N_MODES];
-	u16	ee_margin_tx_rx_turbo[AR5K_EEPROM_N_MODES];
-	u16	ee_atn_tx_rx_turbo[AR5K_EEPROM_N_MODES];
 
 	/* Power calibration data */
 	u16	ee_false_detect[AR5K_EEPROM_N_MODES];
@@ -458,8 +453,6 @@ struct ath5k_eeprom_info {
 	s16	ee_noise_floor_thr[AR5K_EEPROM_N_MODES];
 	s8	ee_adc_desired_size[AR5K_EEPROM_N_MODES];
 	s8	ee_pga_desired_size[AR5K_EEPROM_N_MODES];
-	s8	ee_adc_desired_size_turbo[AR5K_EEPROM_N_MODES];
-	s8	ee_pga_desired_size_turbo[AR5K_EEPROM_N_MODES];
 	s8	ee_pd_gain_overlap;
 
 	/* Spur mitigation data (fbin values for spur channels) */
diff --git a/drivers/net/wireless/ath/ath5k/initvals.c b/drivers/net/wireless/ath/ath5k/initvals.c
index 18eb519..7126048 100644
--- a/drivers/net/wireless/ath/ath5k/initvals.c
+++ b/drivers/net/wireless/ath/ath5k/initvals.c
@@ -391,76 +391,76 @@ static const struct ath5k_ini ar5211_ini[] = {
  */
 static const struct ath5k_ini_mode ar5211_ini_mode[] = {
 	{ AR5K_TXCFG,
-	/*	  a	    aTurbo	  b	  g (OFDM)    */
-	   { 0x00000015, 0x00000015, 0x0000001d, 0x00000015 } },
+	/*	  a	    b	  g (OFDM)    */
+	   { 0x00000015, 0x0000001d, 0x00000015 } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(0),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(1),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(2),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(3),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(4),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(5),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(6),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(7),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(8),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(9),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_DCU_GBL_IFS_SLOT,
-	   { 0x00000168, 0x000001e0, 0x000001b8, 0x00000168 } },
+	   { 0x00000168, 0x000001b8, 0x00000168 } },
 	{ AR5K_DCU_GBL_IFS_SIFS,
-	   { 0x00000230, 0x000001e0, 0x000000b0, 0x00000230 } },
+	   { 0x00000230, 0x000000b0, 0x00000230 } },
 	{ AR5K_DCU_GBL_IFS_EIFS,
-	   { 0x00000d98, 0x00001180, 0x00001f48, 0x00000d98 } },
+	   { 0x00000d98, 0x00001f48, 0x00000d98 } },
 	{ AR5K_DCU_GBL_IFS_MISC,
-	   { 0x0000a0e0, 0x00014068, 0x00005880, 0x0000a0e0 } },
+	   { 0x0000a0e0, 0x00005880, 0x0000a0e0 } },
 	{ AR5K_TIME_OUT,
-	   { 0x04000400, 0x08000800, 0x20003000, 0x04000400 } },
+	   { 0x04000400, 0x20003000, 0x04000400 } },
 	{ AR5K_USEC_5211,
-	   { 0x0e8d8fa7, 0x0e8d8fcf, 0x01608f95, 0x0e8d8fa7 } },
+	   { 0x0e8d8fa7, 0x01608f95, 0x0e8d8fa7 } },
 	{ AR5K_PHY_TURBO,
-	   { 0x00000000, 0x00000003, 0x00000000, 0x00000000 } },
+	   { 0x00000000, 0x00000000, 0x00000000 } },
 	{ AR5K_PHY(8),
-	   { 0x02020200, 0x02020200, 0x02010200, 0x02020200 } },
+	   { 0x02020200, 0x02010200, 0x02020200 } },
 	{ AR5K_PHY(9),
-	   { 0x00000e0e, 0x00000e0e, 0x00000707, 0x00000e0e } },
+	   { 0x00000e0e, 0x00000707, 0x00000e0e } },
 	{ AR5K_PHY(10),
-	   { 0x0a020001, 0x0a020001, 0x05010000, 0x0a020001 } },
+	   { 0x0a020001, 0x05010000, 0x0a020001 } },
 	{ AR5K_PHY(13),
-	   { 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },
+	   { 0x00000e0e, 0x00000e0e, 0x00000e0e } },
 	{ AR5K_PHY(14),
-	   { 0x00000007, 0x00000007, 0x0000000b, 0x0000000b } },
+	   { 0x00000007, 0x0000000b, 0x0000000b } },
 	{ AR5K_PHY(17),
-	   { 0x1372169c, 0x137216a5, 0x137216a8, 0x1372169c } },
+	   { 0x1372169c, 0x137216a8, 0x1372169c } },
 	{ AR5K_PHY(18),
-	   { 0x0018ba67, 0x0018ba67, 0x0018ba69, 0x0018ba69 } },
+	   { 0x0018ba67, 0x0018ba69, 0x0018ba69 } },
 	{ AR5K_PHY(20),
-	   { 0x0c28b4e0, 0x0c28b4e0, 0x0c28b4e0, 0x0c28b4e0 } },
+	   { 0x0c28b4e0, 0x0c28b4e0, 0x0c28b4e0 } },
 	{ AR5K_PHY_SIG,
-	   { 0x7e800d2e, 0x7e800d2e, 0x7ec00d2e, 0x7e800d2e } },
+	   { 0x7e800d2e, 0x7ec00d2e, 0x7e800d2e } },
 	{ AR5K_PHY_AGCCOARSE,
-	   { 0x31375d5e, 0x31375d5e, 0x313a5d5e, 0x31375d5e } },
+	   { 0x31375d5e, 0x313a5d5e, 0x31375d5e } },
 	{ AR5K_PHY_AGCCTL,
-	   { 0x0000bd10, 0x0000bd10, 0x0000bd38, 0x0000bd10 } },
+	   { 0x0000bd10, 0x0000bd38, 0x0000bd10 } },
 	{ AR5K_PHY_NF,
-	   { 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00 } },
+	   { 0x0001ce00, 0x0001ce00, 0x0001ce00 } },
 	{ AR5K_PHY_RX_DELAY,
-	   { 0x00002710, 0x00002710, 0x0000157c, 0x00002710 } },
+	   { 0x00002710, 0x0000157c, 0x00002710 } },
 	{ AR5K_PHY(70),
-	   { 0x00000190, 0x00000190, 0x00000084, 0x00000190 } },
+	   { 0x00000190, 0x00000084, 0x00000190 } },
 	{ AR5K_PHY_FRAME_CTL_5211,
-	   { 0x6fe01020, 0x6fe01020, 0x6fe00920, 0x6fe01020 } },
+	   { 0x6fe01020, 0x6fe00920, 0x6fe01020 } },
 	{ AR5K_PHY_PCDAC_TXPOWER_BASE,
-	   { 0x05ff14ff, 0x05ff14ff, 0x05ff14ff, 0x05ff19ff } },
+	   { 0x05ff14ff, 0x05ff14ff, 0x05ff19ff } },
 	{ AR5K_RF_BUFFER_CONTROL_4,
-	   { 0x00000010, 0x00000014, 0x00000010, 0x00000010 } },
+	   { 0x00000010, 0x00000010, 0x00000010 } },
 };
 
 /* Initial register settings for AR5212 */
@@ -677,89 +677,89 @@ static const struct ath5k_ini ar5212_ini_common_start[] = {
 /* Initial mode-specific settings for AR5212 (Written before ar5212_ini) */
 static const struct ath5k_ini_mode ar5212_ini_mode_start[] = {
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(0),
-	/*	a/XR	   aTurbo	  b	   g (DYN)     gTurbo     */
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	/*	a/XR	   b	   g (DYN)     */
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(1),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(2),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(3),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(4),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(5),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(6),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(7),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(8),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_QUEUE_DFS_LOCAL_IFS(9),
-	   { 0x002ffc0f, 0x002ffc0f, 0x002ffc1f, 0x002ffc0f, 0x002ffc0f } },
+	   { 0x002ffc0f, 0x002ffc1f, 0x002ffc0f } },
 	{ AR5K_DCU_GBL_IFS_SIFS,
-	   { 0x00000230, 0x000001e0, 0x000000b0, 0x00000160, 0x000001e0 } },
+	   { 0x00000230, 0x000000b0, 0x00000160 } },
 	{ AR5K_DCU_GBL_IFS_SLOT,
-	   { 0x00000168, 0x000001e0, 0x000001b8, 0x0000018c, 0x000001e0 } },
+	   { 0x00000168, 0x000001b8, 0x0000018c } },
 	{ AR5K_DCU_GBL_IFS_EIFS,
-	   { 0x00000e60, 0x00001180, 0x00001f1c, 0x00003e38, 0x00001180 } },
+	   { 0x00000e60, 0x00001f1c, 0x00003e38 } },
 	{ AR5K_DCU_GBL_IFS_MISC,
-	   { 0x0000a0e0, 0x00014068, 0x00005880, 0x0000b0e0, 0x00014068 } },
+	   { 0x0000a0e0, 0x00005880, 0x0000b0e0 } },
 	{ AR5K_TIME_OUT,
-	   { 0x03e803e8, 0x06e006e0, 0x04200420, 0x08400840, 0x06e006e0 } },
+	   { 0x03e803e8, 0x04200420, 0x08400840 } },
 	{ AR5K_PHY_TURBO,
-	   { 0x00000000, 0x00000003, 0x00000000, 0x00000000, 0x00000003 } },
+	   { 0x00000000, 0x00000000, 0x00000000 } },
 	{ AR5K_PHY(8),
-	   { 0x02020200, 0x02020200, 0x02010200, 0x02020200, 0x02020200 } },
+	   { 0x02020200, 0x02010200, 0x02020200 } },
 	{ AR5K_PHY_RF_CTL2,
-	   { 0x00000e0e, 0x00000e0e, 0x00000707, 0x00000e0e, 0x00000e0e } },
+	   { 0x00000e0e, 0x00000707, 0x00000e0e } },
 	{ AR5K_PHY_SETTLING,
-	   { 0x1372161c, 0x13721c25, 0x13721722, 0x137216a2, 0x13721c25 } },
+	   { 0x1372161c, 0x13721722, 0x137216a2 } },
 	{ AR5K_PHY_AGCCTL,
-	   { 0x00009d10, 0x00009d10, 0x00009d18, 0x00009d18, 0x00009d10 } },
+	   { 0x00009d10, 0x00009d18, 0x00009d18 } },
 	{ AR5K_PHY_NF,
-	   { 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00, 0x0001ce00 } },
+	   { 0x0001ce00, 0x0001ce00, 0x0001ce00 } },
 	{ AR5K_PHY_WEAK_OFDM_HIGH_THR,
-	   { 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190, 0x409a4190 } },
+	   { 0x409a4190, 0x409a4190, 0x409a4190 } },
 	{ AR5K_PHY(70),
-	   { 0x000001b8, 0x000001b8, 0x00000084, 0x00000108, 0x000001b8 } },
+	   { 0x000001b8, 0x00000084, 0x00000108 } },
 	{ AR5K_PHY_OFDM_SELFCORR,
-	   { 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05, 0x10058a05 } },
+	   { 0x10058a05, 0x10058a05, 0x10058a05 } },
 	{ 0xa230,
-	   { 0x00000000, 0x00000000, 0x00000000, 0x00000108, 0x00000000 } },
+	   { 0x00000000, 0x00000000, 0x00000108 } },
 };
 
 /* Initial mode-specific settings for AR5212 + RF5111 (Written after ar5212_ini) */
 static const struct ath5k_ini_mode rf5111_ini_mode_end[] = {
 	{ AR5K_TXCFG,
-	/*	a/XR	   aTurbo	  b	   g (DYN)     gTurbo     */
-	   { 0x00008015, 0x00008015, 0x00008015, 0x00008015, 0x00008015 } },
+	/*	a/XR	   b	   g (DYN)     */
+	   { 0x00008015, 0x00008015, 0x00008015 } },
 	{ AR5K_USEC_5211,
-	   { 0x128d8fa7, 0x09880fcf, 0x04e00f95, 0x12e00fab, 0x09880fcf } },
+	   { 0x128d8fa7, 0x04e00f95, 0x12e00fab } },
 	{ AR5K_PHY_RF_CTL3,
-	   { 0x0a020001, 0x0a020001, 0x05010100, 0x0a020001, 0x0a020001 } },
+	   { 0x0a020001, 0x05010100, 0x0a020001 } },
 	{ AR5K_PHY_RF_CTL4,
-	   { 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },
+	   { 0x00000e0e, 0x00000e0e, 0x00000e0e } },
 	{ AR5K_PHY_PA_CTL,
-	   { 0x00000007, 0x00000007, 0x0000000b, 0x0000000b, 0x0000000b } },
+	   { 0x00000007, 0x0000000b, 0x0000000b } },
 	{ AR5K_PHY_GAIN,
-	   { 0x0018da5a, 0x0018da5a, 0x0018ca69, 0x0018ca69, 0x0018ca69 } },
+	   { 0x0018da5a, 0x0018ca69, 0x0018ca69 } },
 	{ AR5K_PHY_DESIRED_SIZE,
-	   { 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0 } },
+	   { 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0 } },
 	{ AR5K_PHY_SIG,
-	   { 0x7e800d2e, 0x7e800d2e, 0x7ee84d2e, 0x7ee84d2e, 0x7e800d2e } },
+	   { 0x7e800d2e, 0x7ee84d2e, 0x7ee84d2e } },
 	{ AR5K_PHY_AGCCOARSE,
-	   { 0x3137665e, 0x3137665e, 0x3137665e, 0x3137665e, 0x3137615e } },
+	   { 0x3137665e, 0x3137665e, 0x3137665e } },
 	{ AR5K_PHY_WEAK_OFDM_LOW_THR,
-	   { 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb080, 0x050cb080 } },
+	   { 0x050cb081, 0x050cb081, 0x050cb080 } },
 	{ AR5K_PHY_RX_DELAY,
-	   { 0x00002710, 0x00002710, 0x0000157c, 0x00002af8, 0x00002710 } },
+	   { 0x00002710, 0x0000157c, 0x00002af8 } },
 	{ AR5K_PHY_FRAME_CTL_5211,
-	   { 0xf7b81020, 0xf7b81020, 0xf7b80d20, 0xf7b81020, 0xf7b81020 } },
+	   { 0xf7b81020, 0xf7b80d20, 0xf7b81020 } },
 	{ AR5K_PHY_GAIN_2GHZ,
-	   { 0x642c416a, 0x642c416a, 0x6440416a, 0x6440416a, 0x6440416a } },
+	   { 0x642c416a, 0x6440416a, 0x6440416a } },
 	{ AR5K_PHY_CCK_RX_CTL_4,
-	   { 0x1883800a, 0x1883800a, 0x1873800a, 0x1883800a, 0x1883800a } },
+	   { 0x1883800a, 0x1873800a, 0x1883800a } },
 };
 
 static const struct ath5k_ini rf5111_ini_common_end[] = {
@@ -782,38 +782,38 @@ static const struct ath5k_ini rf5111_ini_common_end[] = {
 /* Initial mode-specific settings for AR5212 + RF5112 (Written after ar5212_ini) */
 static const struct ath5k_ini_mode rf5112_ini_mode_end[] = {
 	{ AR5K_TXCFG,
-	/*	a/XR	   aTurbo	  b	   g (DYN)     gTurbo     */
-	   { 0x00008015, 0x00008015, 0x00008015, 0x00008015, 0x00008015 } },
+	/*	a/XR	   b		g (DYN)     */
+	   { 0x00008015, 0x00008015, 0x00008015 } },
 	{ AR5K_USEC_5211,
-	   { 0x128d93a7, 0x098813cf, 0x04e01395, 0x12e013ab, 0x098813cf } },
+	   { 0x128d93a7, 0x04e01395, 0x12e013ab } },
 	{ AR5K_PHY_RF_CTL3,
-	   { 0x0a020001, 0x0a020001, 0x05020100, 0x0a020001, 0x0a020001 } },
+	   { 0x0a020001, 0x05020100, 0x0a020001 } },
 	{ AR5K_PHY_RF_CTL4,
-	   { 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },
+	   { 0x00000e0e, 0x00000e0e, 0x00000e0e } },
 	{ AR5K_PHY_PA_CTL,
-	   { 0x00000007, 0x00000007, 0x0000000b, 0x0000000b, 0x0000000b } },
+	   { 0x00000007, 0x0000000b, 0x0000000b } },
 	{ AR5K_PHY_GAIN,
-	   { 0x0018da6d, 0x0018da6d, 0x0018ca75, 0x0018ca75, 0x0018ca75 } },
+	   { 0x0018da6d, 0x0018ca75, 0x0018ca75 } },
 	{ AR5K_PHY_DESIRED_SIZE,
-	   { 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0 } },
+	   { 0x0de8b4e0, 0x0de8b4e0, 0x0de8b4e0 } },
 	{ AR5K_PHY_SIG,
-	   { 0x7e800d2e, 0x7e800d2e, 0x7ee80d2e, 0x7ee80d2e, 0x7e800d2e } },
+	   { 0x7e800d2e, 0x7ee80d2e, 0x7ee80d2e } },
 	{ AR5K_PHY_AGCCOARSE,
-	   { 0x3137665e, 0x3137665e, 0x3137665e, 0x3137665e, 0x3137665e } },
+	   { 0x3137665e, 0x3137665e, 0x3137665e } },
 	{ AR5K_PHY_WEAK_OFDM_LOW_THR,
-	   { 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081 } },
+	   { 0x050cb081, 0x050cb081, 0x050cb081 } },
 	{ AR5K_PHY_RX_DELAY,
-	   { 0x000007d0, 0x000007d0, 0x0000044c, 0x00000898, 0x000007d0 } },
+	   { 0x000007d0, 0x0000044c, 0x00000898 } },
 	{ AR5K_PHY_FRAME_CTL_5211,
-	   { 0xf7b81020, 0xf7b81020, 0xf7b80d10, 0xf7b81010, 0xf7b81010 } },
+	   { 0xf7b81020, 0xf7b80d10, 0xf7b81010 } },
 	{ AR5K_PHY_CCKTXCTL,
-	   { 0x00000000, 0x00000000, 0x00000008, 0x00000008, 0x00000008 } },
+	   { 0x00000000, 0x00000008, 0x00000008 } },
 	{ AR5K_PHY_CCK_CROSSCORR,
-	   { 0xd6be6788, 0xd6be6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },
+	   { 0xd6be6788, 0xd03e6788, 0xd03e6788 } },
 	{ AR5K_PHY_GAIN_2GHZ,
-	   { 0x642c0140, 0x642c0140, 0x6442c160, 0x6442c160, 0x6442c160 } },
+	   { 0x642c0140, 0x6442c160, 0x6442c160 } },
 	{ AR5K_PHY_CCK_RX_CTL_4,
-	   { 0x1883800a, 0x1883800a, 0x1873800a, 0x1883800a, 0x1883800a } },
+	   { 0x1883800a, 0x1873800a, 0x1883800a } },
 };
 
 static const struct ath5k_ini rf5112_ini_common_end[] = {
@@ -833,66 +833,66 @@ static const struct ath5k_ini rf5112_ini_common_end[] = {
 /* Initial mode-specific settings for RF5413/5414 (Written after ar5212_ini) */
 static const struct ath5k_ini_mode rf5413_ini_mode_end[] = {
 	{ AR5K_TXCFG,
-	/*	a/XR	   aTurbo	  b	   g (DYN)     gTurbo     */
-	   { 0x00000015, 0x00000015, 0x00000015, 0x00000015, 0x00000015 } },
+	/*	a/XR	   b		g (DYN)     */
+	   { 0x00000015, 0x00000015, 0x00000015 } },
 	{ AR5K_USEC_5211,
-	   { 0x128d93a7, 0x098813cf, 0x04e01395, 0x12e013ab, 0x098813cf } },
+	   { 0x128d93a7, 0x04e01395, 0x12e013ab } },
 	{ AR5K_PHY_RF_CTL3,
-	   { 0x0a020001, 0x0a020001, 0x05020100, 0x0a020001, 0x0a020001 } },
+	   { 0x0a020001, 0x05020100, 0x0a020001 } },
 	{ AR5K_PHY_RF_CTL4,
-	   { 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },
+	   { 0x00000e0e, 0x00000e0e, 0x00000e0e } },
 	{ AR5K_PHY_PA_CTL,
-	   { 0x00000007, 0x00000007, 0x0000000b, 0x0000000b, 0x0000000b } },
+	   { 0x00000007, 0x0000000b, 0x0000000b } },
 	{ AR5K_PHY_GAIN,
-	   { 0x0018fa61, 0x0018fa61, 0x001a1a63, 0x001a1a63, 0x001a1a63 } },
+	   { 0x0018fa61, 0x001a1a63, 0x001a1a63 } },
 	{ AR5K_PHY_DESIRED_SIZE,
-	   { 0x0c98b4e0, 0x0c98b4e0, 0x0c98b0da, 0x0c98b0da, 0x0c98b0da } },
+	   { 0x0c98b4e0, 0x0c98b0da, 0x0c98b0da } },
 	{ AR5K_PHY_SIG,
-	   { 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e } },
+	   { 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e } },
 	{ AR5K_PHY_AGCCOARSE,
-	   { 0x3139605e, 0x3139605e, 0x3139605e, 0x3139605e, 0x3139605e } },
+	   { 0x3139605e, 0x3139605e, 0x3139605e } },
 	{ AR5K_PHY_WEAK_OFDM_LOW_THR,
-	   { 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081 } },
+	   { 0x050cb081, 0x050cb081, 0x050cb081 } },
 	{ AR5K_PHY_RX_DELAY,
-	   { 0x000007d0, 0x000007d0, 0x0000044c, 0x00000898, 0x000007d0 } },
+	   { 0x000007d0, 0x0000044c, 0x00000898 } },
 	{ AR5K_PHY_FRAME_CTL_5211,
-	   { 0xf7b81000, 0xf7b81000, 0xf7b80d00, 0xf7b81000, 0xf7b81000 } },
+	   { 0xf7b81000, 0xf7b80d00, 0xf7b81000 } },
 	{ AR5K_PHY_CCKTXCTL,
-	   { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	   { 0x00000000, 0x00000000, 0x00000000 } },
 	{ AR5K_PHY_CCK_CROSSCORR,
-	   { 0xd6be6788, 0xd6be6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },
+	   { 0xd6be6788, 0xd03e6788, 0xd03e6788 } },
 	{ AR5K_PHY_GAIN_2GHZ,
-	   { 0x002ec1e0, 0x002ec1e0, 0x002ac120, 0x002ac120, 0x002ac120 } },
+	   { 0x002ec1e0, 0x002ac120, 0x002ac120 } },
 	{ AR5K_PHY_CCK_RX_CTL_4,
-	   { 0x1883800a, 0x1883800a, 0x1863800a, 0x1883800a, 0x1883800a } },
+	   { 0x1883800a, 0x1863800a, 0x1883800a } },
 	{ 0xa300,
-	   { 0x18010000, 0x18010000, 0x18010000, 0x18010000, 0x18010000 } },
+	   { 0x18010000, 0x18010000, 0x18010000 } },
 	{ 0xa304,
-	   { 0x30032602, 0x30032602, 0x30032602, 0x30032602, 0x30032602 } },
+	   { 0x30032602, 0x30032602, 0x30032602 } },
 	{ 0xa308,
-	   { 0x48073e06, 0x48073e06, 0x48073e06, 0x48073e06, 0x48073e06 } },
+	   { 0x48073e06, 0x48073e06, 0x48073e06 } },
 	{ 0xa30c,
-	   { 0x560b4c0a, 0x560b4c0a, 0x560b4c0a, 0x560b4c0a, 0x560b4c0a } },
+	   { 0x560b4c0a, 0x560b4c0a, 0x560b4c0a } },
 	{ 0xa310,
-	   { 0x641a600f, 0x641a600f, 0x641a600f, 0x641a600f, 0x641a600f } },
+	   { 0x641a600f, 0x641a600f, 0x641a600f } },
 	{ 0xa314,
-	   { 0x784f6e1b, 0x784f6e1b, 0x784f6e1b, 0x784f6e1b, 0x784f6e1b } },
+	   { 0x784f6e1b, 0x784f6e1b, 0x784f6e1b } },
 	{ 0xa318,
-	   { 0x868f7c5a, 0x868f7c5a, 0x868f7c5a, 0x868f7c5a, 0x868f7c5a } },
+	   { 0x868f7c5a, 0x868f7c5a, 0x868f7c5a } },
 	{ 0xa31c,
-	   { 0x90cf865b, 0x90cf865b, 0x8ecf865b, 0x8ecf865b, 0x8ecf865b } },
+	   { 0x90cf865b, 0x8ecf865b, 0x8ecf865b } },
 	{ 0xa320,
-	   { 0x9d4f970f, 0x9d4f970f, 0x9b4f970f, 0x9b4f970f, 0x9b4f970f } },
+	   { 0x9d4f970f, 0x9b4f970f, 0x9b4f970f } },
 	{ 0xa324,
-	   { 0xa7cfa38f, 0xa7cfa38f, 0xa3cf9f8f, 0xa3cf9f8f, 0xa3cf9f8f } },
+	   { 0xa7cfa38f, 0xa3cf9f8f, 0xa3cf9f8f } },
 	{ 0xa328,
-	   { 0xb55faf1f, 0xb55faf1f, 0xb35faf1f, 0xb35faf1f, 0xb35faf1f } },
+	   { 0xb55faf1f, 0xb35faf1f, 0xb35faf1f } },
 	{ 0xa32c,
-	   { 0xbddfb99f, 0xbddfb99f, 0xbbdfb99f, 0xbbdfb99f, 0xbbdfb99f } },
+	   { 0xbddfb99f, 0xbbdfb99f, 0xbbdfb99f } },
 	{ 0xa330,
-	   { 0xcb7fc53f, 0xcb7fc53f, 0xcb7fc73f, 0xcb7fc73f, 0xcb7fc73f } },
+	   { 0xcb7fc53f, 0xcb7fc73f, 0xcb7fc73f } },
 	{ 0xa334,
-	   { 0xd5ffd1bf, 0xd5ffd1bf, 0xd3ffd1bf, 0xd3ffd1bf, 0xd3ffd1bf } },
+	   { 0xd5ffd1bf, 0xd3ffd1bf, 0xd3ffd1bf } },
 };
 
 static const struct ath5k_ini rf5413_ini_common_end[] = {
@@ -972,38 +972,38 @@ static const struct ath5k_ini rf5413_ini_common_end[] = {
 /* XXX: a mode ? */
 static const struct ath5k_ini_mode rf2413_ini_mode_end[] = {
 	{ AR5K_TXCFG,
-	/*	a/XR	   aTurbo	  b	   g (DYN)     gTurbo     */
-	   { 0x00000015, 0x00000015, 0x00000015, 0x00000015, 0x00000015 } },
+	/*	a/XR	   b		g (DYN)     */
+	   { 0x00000015, 0x00000015, 0x00000015 } },
 	{ AR5K_USEC_5211,
-	   { 0x128d93a7, 0x098813cf, 0x04e01395, 0x12e013ab, 0x098813cf } },
+	   { 0x128d93a7, 0x04e01395, 0x12e013ab } },
 	{ AR5K_PHY_RF_CTL3,
-	   { 0x0a020001, 0x0a020001, 0x05020000, 0x0a020001, 0x0a020001 } },
+	   { 0x0a020001, 0x05020000, 0x0a020001 } },
 	{ AR5K_PHY_RF_CTL4,
-	   { 0x00000e00, 0x00000e00, 0x00000e00, 0x00000e00, 0x00000e00 } },
+	   { 0x00000e00, 0x00000e00, 0x00000e00 } },
 	{ AR5K_PHY_PA_CTL,
-	   { 0x00000002, 0x00000002, 0x0000000a, 0x0000000a, 0x0000000a } },
+	   { 0x00000002, 0x0000000a, 0x0000000a } },
 	{ AR5K_PHY_GAIN,
-	   { 0x0018da6d, 0x0018da6d, 0x001a6a64, 0x001a6a64, 0x001a6a64 } },
+	   { 0x0018da6d, 0x001a6a64, 0x001a6a64 } },
 	{ AR5K_PHY_DESIRED_SIZE,
-	   { 0x0de8b4e0, 0x0de8b4e0, 0x0de8b0da, 0x0c98b0da, 0x0de8b0da } },
+	   { 0x0de8b4e0, 0x0de8b0da, 0x0c98b0da } },
 	{ AR5K_PHY_SIG,
-	   { 0x7e800d2e, 0x7e800d2e, 0x7ee80d2e, 0x7ec80d2e, 0x7e800d2e } },
+	   { 0x7e800d2e, 0x7ee80d2e, 0x7ec80d2e } },
 	{ AR5K_PHY_AGCCOARSE,
-	   { 0x3137665e, 0x3137665e, 0x3137665e, 0x3139605e, 0x3137665e } },
+	   { 0x3137665e, 0x3137665e, 0x3139605e } },
 	{ AR5K_PHY_WEAK_OFDM_LOW_THR,
-	   { 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081 } },
+	   { 0x050cb081, 0x050cb081, 0x050cb081 } },
 	{ AR5K_PHY_RX_DELAY,
-	   { 0x000007d0, 0x000007d0, 0x0000044c, 0x00000898, 0x000007d0 } },
+	   { 0x000007d0, 0x0000044c, 0x00000898 } },
 	{ AR5K_PHY_FRAME_CTL_5211,
-	   { 0xf7b81000, 0xf7b81000, 0xf7b80d00, 0xf7b81000, 0xf7b81000 } },
+	   { 0xf7b81000, 0xf7b80d00, 0xf7b81000 } },
 	{ AR5K_PHY_CCKTXCTL,
-	   { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	   { 0x00000000, 0x00000000, 0x00000000 } },
 	{ AR5K_PHY_CCK_CROSSCORR,
-	   { 0xd6be6788, 0xd6be6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },
+	   { 0xd6be6788, 0xd03e6788, 0xd03e6788 } },
 	{ AR5K_PHY_GAIN_2GHZ,
-	   { 0x002c0140, 0x002c0140, 0x0042c140, 0x0042c140, 0x0042c140 } },
+	   { 0x002c0140, 0x0042c140, 0x0042c140 } },
 	{ AR5K_PHY_CCK_RX_CTL_4,
-	   { 0x1883800a, 0x1883800a, 0x1863800a, 0x1883800a, 0x1883800a } },
+	   { 0x1883800a, 0x1863800a, 0x1883800a } },
 };
 
 static const struct ath5k_ini rf2413_ini_common_end[] = {
@@ -1094,52 +1094,52 @@ static const struct ath5k_ini rf2413_ini_common_end[] = {
 /* XXX: a mode ? */
 static const struct ath5k_ini_mode rf2425_ini_mode_end[] = {
 	{ AR5K_TXCFG,
-	/*	a/XR	   aTurbo	  b	   g (DYN)     gTurbo     */
-	   { 0x00000015, 0x00000015, 0x00000015, 0x00000015, 0x00000015 } },
+	/*	a/XR	   b		g (DYN)     */
+	   { 0x00000015, 0x00000015, 0x00000015 } },
 	{ AR5K_USEC_5211,
-	   { 0x128d93a7, 0x098813cf, 0x04e01395, 0x12e013ab, 0x098813cf } },
+	   { 0x128d93a7, 0x04e01395, 0x12e013ab } },
 	{ AR5K_PHY_TURBO,
-	   { 0x00000000, 0x00000001, 0x00000000, 0x00000000, 0x00000001 } },
+	   { 0x00000000, 0x00000000, 0x00000000 } },
 	{ AR5K_PHY_RF_CTL3,
-	   { 0x0a020001, 0x0a020001, 0x05020100, 0x0a020001, 0x0a020001 } },
+	   { 0x0a020001, 0x05020100, 0x0a020001 } },
 	{ AR5K_PHY_RF_CTL4,
-	   { 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e, 0x00000e0e } },
+	   { 0x00000e0e, 0x00000e0e, 0x00000e0e } },
 	{ AR5K_PHY_PA_CTL,
-	   { 0x00000003, 0x00000003, 0x0000000b, 0x0000000b, 0x0000000b } },
+	   { 0x00000003, 0x0000000b, 0x0000000b } },
 	{ AR5K_PHY_SETTLING,
-	   { 0x1372161c, 0x13721c25, 0x13721722, 0x13721422, 0x13721c25 } },
+	   { 0x1372161c, 0x13721722, 0x13721422 } },
 	{ AR5K_PHY_GAIN,
-	   { 0x0018fa61, 0x0018fa61, 0x00199a65, 0x00199a65, 0x00199a65 } },
+	   { 0x0018fa61, 0x00199a65, 0x00199a65 } },
 	{ AR5K_PHY_DESIRED_SIZE,
-	   { 0x0c98b4e0, 0x0c98b4e0, 0x0c98b0da, 0x0c98b0da, 0x0c98b0da } },
+	   { 0x0c98b4e0, 0x0c98b0da, 0x0c98b0da } },
 	{ AR5K_PHY_SIG,
-	   { 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e } },
+	   { 0x7ec80d2e, 0x7ec80d2e, 0x7ec80d2e } },
 	{ AR5K_PHY_AGCCOARSE,
-	   { 0x3139605e, 0x3139605e, 0x3139605e, 0x3139605e, 0x3139605e } },
+	   { 0x3139605e, 0x3139605e, 0x3139605e } },
 	{ AR5K_PHY_WEAK_OFDM_LOW_THR,
-	   { 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081, 0x050cb081 } },
+	   { 0x050cb081, 0x050cb081, 0x050cb081 } },
 	{ AR5K_PHY_RX_DELAY,
-	   { 0x000007d0, 0x000007d0, 0x0000044c, 0x00000898, 0x000007d0 } },
+	   { 0x000007d0, 0x0000044c, 0x00000898 } },
 	{ AR5K_PHY_FRAME_CTL_5211,
-	   { 0xf7b81000, 0xf7b81000, 0xf7b80d00, 0xf7b81000, 0xf7b81000 } },
+	   { 0xf7b81000, 0xf7b80d00, 0xf7b81000 } },
 	{ AR5K_PHY_CCKTXCTL,
-	   { 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000 } },
+	   { 0x00000000, 0x00000000, 0x00000000 } },
 	{ AR5K_PHY_CCK_CROSSCORR,
-	   { 0xd6be6788, 0xd6be6788, 0xd03e6788, 0xd03e6788, 0xd03e6788 } },
+	   { 0xd6be6788, 0xd03e6788, 0xd03e6788 } },
 	{ AR5K_PHY_GAIN_2GHZ,
-	   { 0x00000140, 0x00000140, 0x0052c140, 0x0052c140, 0x0052c140 } },
+	   { 0x00000140, 0x0052c140, 0x0052c140 } },
 	{ AR5K_PHY_CCK_RX_CTL_4,
-	   { 0x1883800a, 0x1883800a, 0x1863800a, 0x1883800a, 0x1883800a } },
+	   { 0x1883800a, 0x1863800a, 0x1883800a } },
 	{ 0xa324,
-	   { 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf } },
+	   { 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf } },
 	{ 0xa328,
-	   { 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf } },
+	   { 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf } },
 	{ 0xa32c,
-	   { 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf } },
+	   { 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf } },
 	{ 0xa330,
-	   { 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf } },
+	   { 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf } },
 	{ 0xa334,
-	   { 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf } },
+	   { 0xa7cfa7cf, 0xa7cfa7cf, 0xa7cfa7cf } },
 };
 
 static const struct ath5k_ini rf2425_ini_common_end[] = {
@@ -1523,8 +1523,7 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 	/* For AR5211 */
 	} else if (ah->ah_version == AR5K_AR5211) {
 
-		/* AR5K_MODE_11B */
-		if (mode > 2) {
+		if (mode > AR5K_MODE_11B) {
 			ATH5K_ERR(ah->ah_sc,
 				"unsupported channel mode: %d\n", mode);
 			return -EINVAL;
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 2942f13..ab1065f 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -185,7 +185,7 @@ unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah)
 	ATH5K_TRACE(ah->ah_sc);
 
 	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(ah,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK), ah->ah_turbo);
+			AR5K_TIME_OUT), AR5K_TIME_OUT_ACK));
 }
 
 /**
@@ -197,12 +197,12 @@ unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah)
 int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout)
 {
 	ATH5K_TRACE(ah->ah_sc);
-	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_ACK),
-			ah->ah_turbo) <= timeout)
+	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_ACK))
+			<= timeout)
 		return -EINVAL;
 
 	AR5K_REG_WRITE_BITS(ah, AR5K_TIME_OUT, AR5K_TIME_OUT_ACK,
-		ath5k_hw_htoclock(timeout, ah->ah_turbo));
+		ath5k_hw_htoclock(timeout));
 
 	return 0;
 }
@@ -216,7 +216,7 @@ unsigned int ath5k_hw_get_cts_timeout(struct ath5k_hw *ah)
 {
 	ATH5K_TRACE(ah->ah_sc);
 	return ath5k_hw_clocktoh(AR5K_REG_MS(ath5k_hw_reg_read(ah,
-			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS), ah->ah_turbo);
+			AR5K_TIME_OUT), AR5K_TIME_OUT_CTS));
 }
 
 /**
@@ -228,12 +228,12 @@ unsigned int ath5k_hw_get_cts_timeout(struct ath5k_hw *ah)
 int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout)
 {
 	ATH5K_TRACE(ah->ah_sc);
-	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_CTS),
-			ah->ah_turbo) <= timeout)
+	if (ath5k_hw_clocktoh(AR5K_REG_MS(0xffffffff, AR5K_TIME_OUT_CTS))
+			<= timeout)
 		return -EINVAL;
 
 	AR5K_REG_WRITE_BITS(ah, AR5K_TIME_OUT, AR5K_TIME_OUT_CTS,
-			ath5k_hw_htoclock(timeout, ah->ah_turbo));
+			ath5k_hw_htoclock(timeout));
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 1a039f2..e2a5606 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -635,7 +635,7 @@ int ath5k_hw_rfregs_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 	} else if ((channel->hw_value & CHANNEL_5GHZ) ||
 			(ah->ah_radio == AR5K_RF5111)) {
 
-		/* For 11a, Turbo and XR we need to choose
+		/* For 11a, we need to choose
 		 * OB/DB based on frequency range */
 		ee_mode = AR5K_EEPROM_MODE_11A;
 		obdb =	 channel->center_freq >= 5725 ? 3 :
@@ -1095,7 +1095,6 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 	}
 
 	ah->ah_current_channel = channel;
-	ah->ah_turbo = channel->hw_value == CHANNEL_T ? true : false;
 
 	return 0;
 }
@@ -1437,8 +1436,6 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 	spur_chan_fbin = AR5K_EEPROM_NO_SPUR;
 	spur_detection_window = AR5K_SPUR_CHAN_WIDTH;
 	/* XXX: Half/Quarter channels ?*/
-	if (channel->hw_value & CHANNEL_TURBO)
-		spur_detection_window *= 2;
 
 	for (i = 0; i < AR5K_EEPROM_N_SPUR_CHANS; i++) {
 		spur_chan_fbin = ee->ee_spur_chans[i][freq_band];
@@ -1483,13 +1480,6 @@ ath5k_hw_set_spur_mitigation_filter(struct ath5k_hw *ah,
 			spur_delta_phase = (spur_offset << 17) / 25;
 			symbol_width = AR5K_SPUR_SYMBOL_WIDTH_BASE_100Hz;
 			break;
-		case CHANNEL_T:
-		case CHANNEL_TG:
-			/* Both sample_freq and chip_freq are 80MHz */
-			spur_delta_phase = (spur_offset << 16) / 25;
-			spur_freq_sigma_delta = (spur_delta_phase >> 10);
-			symbol_width = AR5K_SPUR_SYMBOL_WIDTH_TURBO_100Hz;
-			break;
 		default:
 			return;
 		}
@@ -1774,12 +1764,9 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
 
 	switch (channel->hw_value & CHANNEL_MODES) {
 	case CHANNEL_A:
-	case CHANNEL_T:
-	case CHANNEL_XR:
 		ee_mode = AR5K_EEPROM_MODE_11A;
 		break;
 	case CHANNEL_G:
-	case CHANNEL_TG:
 		ee_mode = AR5K_EEPROM_MODE_11G;
 		break;
 	case CHANNEL_B:
@@ -2221,14 +2208,6 @@ ath5k_get_max_ctl_power(struct ath5k_hw *ah,
 	case CHANNEL_B:
 		ctl_mode |= AR5K_CTL_11B;
 		break;
-	case CHANNEL_T:
-		ctl_mode |= AR5K_CTL_TURBO;
-		break;
-	case CHANNEL_TG:
-		ctl_mode |= AR5K_CTL_TURBOG;
-		break;
-	case CHANNEL_XR:
-		/* Fall through */
 	default:
 		return;
 	}
@@ -3051,12 +3030,9 @@ int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, u8 txpower)
 
 	switch (channel->hw_value & CHANNEL_MODES) {
 	case CHANNEL_A:
-	case CHANNEL_T:
-	case CHANNEL_XR:
 		ee_mode = AR5K_EEPROM_MODE_11A;
 		break;
 	case CHANNEL_G:
-	case CHANNEL_TG:
 		ee_mode = AR5K_EEPROM_MODE_11G;
 		break;
 	case CHANNEL_B:
diff --git a/drivers/net/wireless/ath/ath5k/qcu.c b/drivers/net/wireless/ath/ath5k/qcu.c
index eeebb9a..4372b80 100644
--- a/drivers/net/wireless/ath/ath5k/qcu.c
+++ b/drivers/net/wireless/ath/ath5k/qcu.c
@@ -107,13 +107,6 @@ int ath5k_hw_setup_tx_queue(struct ath5k_hw *ah, enum ath5k_tx_queue queue_type,
 		case AR5K_TX_QUEUE_CAB:
 			queue = AR5K_TX_QUEUE_ID_CAB;
 			break;
-		case AR5K_TX_QUEUE_XR_DATA:
-			if (ah->ah_version != AR5K_AR5212)
-				ATH5K_ERR(ah->ah_sc,
-					"XR data queues only supported in"
-					" 5212!\n");
-			queue = AR5K_TX_QUEUE_ID_XR_DATA;
-			break;
 		default:
 			return -EINVAL;
 		}
@@ -209,47 +202,31 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 			return 0;
 
 		/* Set Slot time */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
-			AR5K_INIT_SLOT_TIME_TURBO : AR5K_INIT_SLOT_TIME,
+		ath5k_hw_reg_write(ah, AR5K_INIT_SLOT_TIME,
 			AR5K_SLOT_TIME);
 		/* Set ACK_CTS timeout */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
-			AR5K_INIT_ACK_CTS_TIMEOUT_TURBO :
+		ath5k_hw_reg_write(ah,
 			AR5K_INIT_ACK_CTS_TIMEOUT, AR5K_SLOT_TIME);
 		/* Set Transmit Latency */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
-			AR5K_INIT_TRANSMIT_LATENCY_TURBO :
+		ath5k_hw_reg_write(ah,
 			AR5K_INIT_TRANSMIT_LATENCY, AR5K_USEC_5210);
 
 		/* Set IFS0 */
-		if (ah->ah_turbo) {
-			 ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS_TURBO +
-				(ah->ah_aifs + tq->tqi_aifs) *
-				AR5K_INIT_SLOT_TIME_TURBO) <<
-				AR5K_IFS0_DIFS_S) | AR5K_INIT_SIFS_TURBO,
-				AR5K_IFS0);
-		} else {
-			ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS +
-				(ah->ah_aifs + tq->tqi_aifs) *
-				AR5K_INIT_SLOT_TIME) << AR5K_IFS0_DIFS_S) |
-				AR5K_INIT_SIFS, AR5K_IFS0);
-		}
+		ath5k_hw_reg_write(ah, ((AR5K_INIT_SIFS +
+			(ah->ah_aifs + tq->tqi_aifs) *
+			AR5K_INIT_SLOT_TIME) << AR5K_IFS0_DIFS_S) |
+			AR5K_INIT_SIFS, AR5K_IFS0);
 
 		/* Set IFS1 */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
-			AR5K_INIT_PROTO_TIME_CNTRL_TURBO :
+		ath5k_hw_reg_write(ah,
 			AR5K_INIT_PROTO_TIME_CNTRL, AR5K_IFS1);
 		/* Set AR5K_PHY_SETTLING */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
-			(ath5k_hw_reg_read(ah, AR5K_PHY_SETTLING) & ~0x7F)
-			| 0x38 :
+		ath5k_hw_reg_write(ah,
 			(ath5k_hw_reg_read(ah, AR5K_PHY_SETTLING) & ~0x7F)
 			| 0x1C,
 			AR5K_PHY_SETTLING);
 		/* Set Frame Control Register */
-		ath5k_hw_reg_write(ah, ah->ah_turbo ?
-			(AR5K_PHY_FRAME_CTL_INI | AR5K_PHY_TURBO_MODE |
-			AR5K_PHY_TURBO_SHORT | 0x2020) :
+		ath5k_hw_reg_write(ah,
 			(AR5K_PHY_FRAME_CTL_INI | 0x1020),
 			AR5K_PHY_FRAME_CTL_5210);
 	}
@@ -260,14 +237,8 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 	cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN;
 	cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX;
 	ah->ah_aifs = AR5K_TUNE_AIFS;
-	/*XR is only supported on 5212*/
-	if (IS_CHAN_XR(ah->ah_current_channel) &&
-			ah->ah_version == AR5K_AR5212) {
-		cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN_XR;
-		cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX_XR;
-		ah->ah_aifs = AR5K_TUNE_AIFS_XR;
 	/*B mode is not supported on 5210*/
-	} else if (IS_CHAN_B(ah->ah_current_channel) &&
+	if (IS_CHAN_B(ah->ah_current_channel) &&
 			ah->ah_version != AR5K_AR5210) {
 		cw_min = ah->ah_cw_min = AR5K_TUNE_CWMIN_11B;
 		cw_max = ah->ah_cw_max = AR5K_TUNE_CWMAX_11B;
@@ -523,7 +494,7 @@ unsigned int ath5k_hw_get_slot_time(struct ath5k_hw *ah)
 	ATH5K_TRACE(ah->ah_sc);
 	if (ah->ah_version == AR5K_AR5210)
 		return ath5k_hw_clocktoh(ath5k_hw_reg_read(ah,
-				AR5K_SLOT_TIME) & 0xffff, ah->ah_turbo);
+				AR5K_SLOT_TIME) & 0xffff);
 	else
 		return ath5k_hw_reg_read(ah, AR5K_DCU_GBL_IFS_SLOT) & 0xffff;
 }
@@ -538,8 +509,8 @@ int ath5k_hw_set_slot_time(struct ath5k_hw *ah, unsigned int slot_time)
 		return -EINVAL;
 
 	if (ah->ah_version == AR5K_AR5210)
-		ath5k_hw_reg_write(ah, ath5k_hw_htoclock(slot_time,
-				ah->ah_turbo), AR5K_SLOT_TIME);
+		ath5k_hw_reg_write(ah, ath5k_hw_htoclock(slot_time),
+				AR5K_SLOT_TIME);
 	else
 		ath5k_hw_reg_write(ah, slot_time, AR5K_DCU_GBL_IFS_SLOT);
 
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 34e13c7..39de9d4 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -62,7 +62,7 @@ static inline int ath5k_hw_write_ofdm_timings(struct ath5k_hw *ah,
 	 * we scale coef by shifting clock value by 24 for
 	 * better precision since we use integers */
 	/* TODO: Half/quarter rate */
-	clock =  ath5k_hw_htoclock(1, channel->hw_value & CHANNEL_TURBO);
+	clock =  ath5k_hw_htoclock(1);
 
 	coef_scaled = ((5 * (clock << 24)) / 2) / channel->center_freq;
 
@@ -119,12 +119,9 @@ static const unsigned int control_rates[] =
  *
  * Note: Band doesn't matter here, if we set the values for OFDM it works
  * on both a and g modes. So all we have to do is set values for all g rates
- * that include all OFDM and CCK rates. If we operate in turbo or xr/half/
- * quarter rate mode, we need to use another set of bitrates (that's why we
- * need the mode parameter) but we don't handle these proprietary modes yet.
+ * that include all OFDM and CCK rates.
  */
-static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah,
-       unsigned int mode)
+static inline void ath5k_hw_write_rate_duration(struct ath5k_hw *ah)
 {
 	struct ath5k_softc *sc = ah->ah_sc;
 	struct ieee80211_rate *rate;
@@ -366,10 +363,9 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
 int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 {
 	struct pci_dev *pdev = ah->ah_sc->pdev;
-	u32 turbo, mode, clock, bus_flags;
+	u32 mode, clock, bus_flags;
 	int ret;
 
-	turbo = 0;
 	mode = 0;
 	clock = 0;
 
@@ -480,15 +476,6 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 			ATH5K_ERR(ah->ah_sc, "invalid radio frequency mode\n");
 			return -EINVAL;
 		}
-
-		if (flags & CHANNEL_TURBO)
-			turbo = AR5K_PHY_TURBO_MODE | AR5K_PHY_TURBO_SHORT;
-	} else { /* Reset the device */
-
-		/* ...enable Atheros turbo mode if requested */
-		if (flags & CHANNEL_TURBO)
-			ath5k_hw_reg_write(ah, AR5K_PHY_TURBO_MODE,
-					AR5K_PHY_TURBO);
 	}
 
 	if (ah->ah_version != AR5K_AR5210) {
@@ -501,7 +488,6 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 
 		/* ...set the PHY operating mode */
 		ath5k_hw_reg_write(ah, mode, AR5K_PHY_MODE);
-		ath5k_hw_reg_write(ah, turbo, AR5K_PHY_TURBO);
 	}
 
 	return 0;
@@ -766,58 +752,30 @@ static void ath5k_hw_commit_eeprom_settings(struct ath5k_hw *ah,
 		AR5K_PHY_NF_SVAL(ee->ee_noise_floor_thr[ee_mode]),
 		AR5K_PHY_NFTHRES);
 
-	if ((channel->hw_value & CHANNEL_TURBO) &&
-	(ah->ah_ee_version >= AR5K_EEPROM_VERSION_5_0)) {
-		/* Switch settling time (Turbo) */
-		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_SETTLING,
-				AR5K_PHY_SETTLING_SWITCH,
-				ee->ee_switch_settling_turbo[ee_mode]);
+	/* Switch settling time */
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_SETTLING,
+			AR5K_PHY_SETTLING_SWITCH,
+			ee->ee_switch_settling[ee_mode]);
 
-		/* Tx/Rx attenuation (Turbo) */
-		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_GAIN,
-				AR5K_PHY_GAIN_TXRX_ATTEN,
-				ee->ee_atn_tx_rx_turbo[ee_mode]);
+	/* Tx/Rx attenuation */
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_GAIN,
+			AR5K_PHY_GAIN_TXRX_ATTEN,
+			ee->ee_atn_tx_rx[ee_mode]);
 
-		/* ADC/PGA desired size (Turbo) */
-		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_DESIRED_SIZE,
-				AR5K_PHY_DESIRED_SIZE_ADC,
-				ee->ee_adc_desired_size_turbo[ee_mode]);
+	/* ADC/PGA desired size */
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_DESIRED_SIZE,
+			AR5K_PHY_DESIRED_SIZE_ADC,
+			ee->ee_adc_desired_size[ee_mode]);
 
-		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_DESIRED_SIZE,
-				AR5K_PHY_DESIRED_SIZE_PGA,
-				ee->ee_pga_desired_size_turbo[ee_mode]);
+	AR5K_REG_WRITE_BITS(ah, AR5K_PHY_DESIRED_SIZE,
+			AR5K_PHY_DESIRED_SIZE_PGA,
+			ee->ee_pga_desired_size[ee_mode]);
 
-		/* Tx/Rx margin (Turbo) */
+	/* Tx/Rx margin */
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
 		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_GAIN_2GHZ,
-				AR5K_PHY_GAIN_2GHZ_MARGIN_TXRX,
-				ee->ee_margin_tx_rx_turbo[ee_mode]);
-
-	} else {
-		/* Switch settling time */
-		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_SETTLING,
-				AR5K_PHY_SETTLING_SWITCH,
-				ee->ee_switch_settling[ee_mode]);
-
-		/* Tx/Rx attenuation */
-		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_GAIN,
-				AR5K_PHY_GAIN_TXRX_ATTEN,
-				ee->ee_atn_tx_rx[ee_mode]);
-
-		/* ADC/PGA desired size */
-		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_DESIRED_SIZE,
-				AR5K_PHY_DESIRED_SIZE_ADC,
-				ee->ee_adc_desired_size[ee_mode]);
-
-		AR5K_REG_WRITE_BITS(ah, AR5K_PHY_DESIRED_SIZE,
-				AR5K_PHY_DESIRED_SIZE_PGA,
-				ee->ee_pga_desired_size[ee_mode]);
-
-		/* Tx/Rx margin */
-		if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_1)
-			AR5K_REG_WRITE_BITS(ah, AR5K_PHY_GAIN_2GHZ,
-				AR5K_PHY_GAIN_2GHZ_MARGIN_TXRX,
-				ee->ee_margin_tx_rx[ee_mode]);
-	}
+			AR5K_PHY_GAIN_2GHZ_MARGIN_TXRX,
+			ee->ee_margin_tx_rx[ee_mode]);
 
 	/* XPA delays */
 	ath5k_hw_reg_write(ah,
@@ -907,31 +865,6 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 			freq = AR5K_INI_RFGAIN_2GHZ;
 			ee_mode = AR5K_EEPROM_MODE_11B;
 			break;
-		case CHANNEL_T:
-			mode = AR5K_MODE_11A_TURBO;
-			freq = AR5K_INI_RFGAIN_5GHZ;
-			ee_mode = AR5K_EEPROM_MODE_11A;
-			break;
-		case CHANNEL_TG:
-			if (ah->ah_version == AR5K_AR5211) {
-				ATH5K_ERR(ah->ah_sc,
-					"TurboG mode not available on 5211");
-				return -EINVAL;
-			}
-			mode = AR5K_MODE_11G_TURBO;
-			freq = AR5K_INI_RFGAIN_2GHZ;
-			ee_mode = AR5K_EEPROM_MODE_11G;
-			break;
-		case CHANNEL_XR:
-			if (ah->ah_version == AR5K_AR5211) {
-				ATH5K_ERR(ah->ah_sc,
-					"XR mode not available on 5211");
-				return -EINVAL;
-			}
-			mode = AR5K_MODE_XR;
-			freq = AR5K_INI_RFGAIN_5GHZ;
-			ee_mode = AR5K_EEPROM_MODE_11A;
-			break;
 		default:
 			ATH5K_ERR(ah->ah_sc,
 				"invalid channel: %d\n", channel->center_freq);
@@ -1065,7 +998,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		 * mac80211 are integrated */
 		if (ah->ah_version == AR5K_AR5212 &&
 			ah->ah_sc->vif != NULL)
-			ath5k_hw_write_rate_duration(ah, mode);
+			ath5k_hw_write_rate_duration(ah);
 
 		/*
 		 * Write RF buffer
-- 
1.6.2.5


-- 
Bob Copeland %% www.bobcopeland.com

