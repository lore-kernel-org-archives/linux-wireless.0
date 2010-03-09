Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:30615 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753269Ab0CIH4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 02:56:23 -0500
Received: from vs3012.wh2.ocn.ne.jp (125.206.180.183)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0904901382
	for <linux-wireless@vger.kernel.org>; Tue,  9 Mar 2010 16:56:22 +0900 (JST)
Subject: [PATCH 13/13] ath5k: Minor EEPROM documentation updates
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 09 Mar 2010 16:56:21 +0900
Message-ID: <20100309075621.30616.68129.stgit@void>
In-Reply-To: <20100309075124.30616.40896.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are some minor updates for EEPROM, mostly documentation and some small
fixes which have no effect at the moment.

- fixed_bias is not available for B mode.

- AR5K_EEPROM_[RT]X_CHAIN_DIS is 3 bit. this is MIMO and will not be used in
  ath5k, but just to be correct.

- AR5K_EEPROM_JAP_MID_EN added, and shift of following flags adapted.

- added some documentation for EEPROM values and some comments.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/eeprom.c |    4 +
 drivers/net/wireless/ath/ath5k/eeprom.h |   85 +++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath5k/reg.h    |    2 -
 3 files changed, 68 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 10b5226..a3cbfe4 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -329,7 +329,8 @@ static int ath5k_eeprom_read_modes(struct ath5k_hw *ah, u32 *offset,
 	ee->ee_x_gain[mode]		= (val >> 1) & 0xf;
 	ee->ee_xpd[mode]		= val & 0x1;
 
-	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0)
+	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_4_0 &&
+	    mode != AR5K_EEPROM_MODE_11B)
 		ee->ee_fixed_bias[mode] = (val >> 13) & 0x1;
 
 	if (ah->ah_ee_version >= AR5K_EEPROM_VERSION_3_3) {
@@ -339,6 +340,7 @@ static int ath5k_eeprom_read_modes(struct ath5k_hw *ah, u32 *offset,
 		if (mode == AR5K_EEPROM_MODE_11A)
 			ee->ee_xr_power[mode] = val & 0x3f;
 		else {
+			/* b_DB_11[bg] and b_OB_11[bg] */
 			ee->ee_ob[mode][0] = val & 0x7;
 			ee->ee_db[mode][0] = (val >> 3) & 0x7;
 		}
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index 1a65683..c4a6d5f 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -75,9 +75,9 @@
 #define AR5K_EEPROM_HDR_11A(_v)		(((_v) >> AR5K_EEPROM_MODE_11A) & 0x1)
 #define AR5K_EEPROM_HDR_11B(_v)		(((_v) >> AR5K_EEPROM_MODE_11B) & 0x1)
 #define AR5K_EEPROM_HDR_11G(_v)		(((_v) >> AR5K_EEPROM_MODE_11G) & 0x1)
-#define AR5K_EEPROM_HDR_T_2GHZ_DIS(_v)	(((_v) >> 3) & 0x1)	/* Disable turbo for 2Ghz (?) */
-#define AR5K_EEPROM_HDR_T_5GHZ_DBM(_v)	(((_v) >> 4) & 0x7f)	/* Max turbo power for a/XR mode (eeprom_init) */
-#define AR5K_EEPROM_HDR_DEVICE(_v)	(((_v) >> 11) & 0x7)
+#define AR5K_EEPROM_HDR_T_2GHZ_DIS(_v)	(((_v) >> 3) & 0x1)	/* Disable turbo for 2Ghz */
+#define AR5K_EEPROM_HDR_T_5GHZ_DBM(_v)	(((_v) >> 4) & 0x7f)	/* Max turbo power for < 2W power consumption */
+#define AR5K_EEPROM_HDR_DEVICE(_v)	(((_v) >> 11) & 0x7)	/* Device type (1 Cardbus, 2 PCI, 3 MiniPCI, 4 AP) */
 #define AR5K_EEPROM_HDR_RFKILL(_v)	(((_v) >> 14) & 0x1)	/* Device has RFKill support */
 #define AR5K_EEPROM_HDR_T_5GHZ_DIS(_v)	(((_v) >> 15) & 0x1)	/* Disable turbo for 5Ghz */
 
@@ -98,7 +98,7 @@
 
 #define AR5K_EEPROM_MISC1			AR5K_EEPROM_INFO(5)
 #define AR5K_EEPROM_TARGET_PWRSTART(_v)		((_v) & 0xfff)
-#define AR5K_EEPROM_HAS32KHZCRYSTAL(_v)		(((_v) >> 14) & 0x1)
+#define AR5K_EEPROM_HAS32KHZCRYSTAL(_v)		(((_v) >> 14) & 0x1)	/* has 32KHz crystal for sleep mode */
 #define AR5K_EEPROM_HAS32KHZCRYSTAL_OLD(_v)	(((_v) >> 15) & 0x1)
 
 #define AR5K_EEPROM_MISC2			AR5K_EEPROM_INFO(6)
@@ -111,26 +111,27 @@
 
 #define AR5K_EEPROM_MISC4		AR5K_EEPROM_INFO(8)
 #define AR5K_EEPROM_CAL_DATA_START(_v)	(((_v) >> 4) & 0xfff)
-#define AR5K_EEPROM_MASK_R0(_v)		(((_v) >> 2) & 0x3)
-#define AR5K_EEPROM_MASK_R1(_v)		((_v) & 0x3)
+#define AR5K_EEPROM_MASK_R0(_v)		(((_v) >> 2) & 0x3)	/* modes supported by radio 0 (bit 1: G, bit 2: A) */
+#define AR5K_EEPROM_MASK_R1(_v)		((_v) & 0x3)		/* modes supported by radio 1 (bit 1: G, bit 2: A) */
 
 #define AR5K_EEPROM_MISC5		AR5K_EEPROM_INFO(9)
-#define AR5K_EEPROM_COMP_DIS(_v)	((_v) & 0x1)
-#define AR5K_EEPROM_AES_DIS(_v)		(((_v) >> 1) & 0x1)
-#define AR5K_EEPROM_FF_DIS(_v)		(((_v) >> 2) & 0x1)
-#define AR5K_EEPROM_BURST_DIS(_v)	(((_v) >> 3) & 0x1)
-#define AR5K_EEPROM_MAX_QCU(_v)		(((_v) >> 4) & 0xf)
-#define AR5K_EEPROM_HEAVY_CLIP_EN(_v)	(((_v) >> 8) & 0x1)
-#define AR5K_EEPROM_KEY_CACHE_SIZE(_v)	(((_v) >> 12) & 0xf)
+#define AR5K_EEPROM_COMP_DIS(_v)	((_v) & 0x1)		/* disable compression */
+#define AR5K_EEPROM_AES_DIS(_v)		(((_v) >> 1) & 0x1)	/* disable AES */
+#define AR5K_EEPROM_FF_DIS(_v)		(((_v) >> 2) & 0x1)	/* disable fast frames */
+#define AR5K_EEPROM_BURST_DIS(_v)	(((_v) >> 3) & 0x1)	/* disable bursting */
+#define AR5K_EEPROM_MAX_QCU(_v)		(((_v) >> 4) & 0xf)	/* max number of QCUs. defaults to 10 */
+#define AR5K_EEPROM_HEAVY_CLIP_EN(_v)	(((_v) >> 8) & 0x1)	/* enable heayy clipping */
+#define AR5K_EEPROM_KEY_CACHE_SIZE(_v)	(((_v) >> 12) & 0xf)	/* key cache size. defaults to 128 */
 
 #define AR5K_EEPROM_MISC6		AR5K_EEPROM_INFO(10)
-#define AR5K_EEPROM_TX_CHAIN_DIS	((_v) & 0x8)
-#define AR5K_EEPROM_RX_CHAIN_DIS	(((_v) >> 3) & 0x8)
-#define AR5K_EEPROM_FCC_MID_EN		(((_v) >> 6) & 0x1)
-#define AR5K_EEPROM_JAP_U1EVEN_EN	(((_v) >> 7) & 0x1)
-#define AR5K_EEPROM_JAP_U2_EN		(((_v) >> 8) & 0x1)
-#define AR5K_EEPROM_JAP_U1ODD_EN	(((_v) >> 9) & 0x1)
-#define AR5K_EEPROM_JAP_11A_NEW_EN	(((_v) >> 10) & 0x1)
+#define AR5K_EEPROM_TX_CHAIN_DIS	((_v) & 0x7)		/* MIMO chains disabled for TX bitmask */
+#define AR5K_EEPROM_RX_CHAIN_DIS	(((_v) >> 3) & 0x7)	/* MIMO chains disabled for RX bitmask */
+#define AR5K_EEPROM_FCC_MID_EN		(((_v) >> 6) & 0x1)	/* 5.47-5.7GHz supported */
+#define AR5K_EEPROM_JAP_U1EVEN_EN	(((_v) >> 7) & 0x1)	/* Japan UNII1 band (5.15-5.25GHz) on even channels (5180, 5200, 5220, 5240) supported */
+#define AR5K_EEPROM_JAP_U2_EN		(((_v) >> 8) & 0x1)	/* Japan UNII2 band (5.25-5.35GHz) supported */
+#define AR5K_EEPROM_JAP_MID_EN		(((_v) >> 9) & 0x1)	/* Japan band from 5.47-5.7GHz supported */
+#define AR5K_EEPROM_JAP_U1ODD_EN	(((_v) >> 10) & 0x1)	/* Japan UNII2 band (5.15-5.25GHz) on odd channels (5170, 5190, 5210, 5230) supported */
+#define AR5K_EEPROM_JAP_11A_NEW_EN	(((_v) >> 11) & 0x1)	/* Japan A mode enabled (using even channels) */
 
 /* calibration settings */
 #define AR5K_EEPROM_MODES_11A(_v)	AR5K_EEPROM_OFF(_v, 0x00c5, 0x00d4)
@@ -386,7 +387,49 @@ struct ath5k_edge_power {
 	bool flag;
 };
 
-/* EEPROM calibration data */
+/**
+ * struct ath5k_eeprom_info - EEPROM calibration data
+ *
+ * @ee_regdomain: ath/regd.c takes care of COUNTRY_ERD and WORLDWIDE_ROAMING
+ *	flags
+ * @ee_ant_gain: Antenna gain in 0.5dB steps signed [5211 only?]
+ * @ee_cck_ofdm_gain_delta: difference in gainF to output the same power for
+ *	OFDM and CCK packets
+ * @ee_cck_ofdm_power_delta: power difference between OFDM (6Mbps) and CCK
+ *	(11Mbps) rate in G mode. 0.1dB steps
+ * @ee_scaled_cck_delta: for Japan Channel 14: 0.1dB resolution
+ *
+ * @ee_i_cal: Initial I coefficient to correct I/Q mismatch in the receive path
+ * @ee_q_cal: Initial Q coefficient to correct I/Q mismatch in the receive path
+ * @ee_fixed_bias: use ee_ob and ee_db settings or use automatic control
+ * @ee_switch_settling: RX/TX Switch settling time
+ * @ee_atn_tx_rx: Difference in attenuation between TX and RX in 1dB steps
+ * @ee_ant_control: Antenna Control Settings
+ * @ee_ob: Bias current for Output stage of PA
+ *	B/G mode: Index [0] is used for AR2112/5112, otherwise [1]
+ *	A mode: [0] 5.15-5.25 [1] 5.25-5.50 [2] 5.50-5.70 [3] 5.70-5.85 GHz
+ * @ee_db: Bias current for Output stage of PA. see @ee_ob
+ * @ee_tx_end2xlna_enable: Time difference from when BB finishes sending a frame
+ *	to when the external LNA is activated
+ * @ee_tx_end2xpa_disable: Time difference from when BB finishes sending a frame
+ *	to when the external PA switch is deactivated
+ * @ee_tx_frm2xpa_enable: Time difference from when MAC sends frame to when
+ *	external PA switch is activated
+ * @ee_thr_62: Clear Channel Assessment (CCA) sensitivity
+ *	(IEEE802.11a section 17.3.10.5 )
+ * @ee_xlna_gain: Total gain of the LNA (information only)
+ * @ee_xpd: Use external (1) or internal power detector
+ * @ee_x_gain: Gain for external power detector output (differences in EEMAP
+ *	versions!)
+ * @ee_i_gain: Initial gain value after reset
+ * @ee_margin_tx_rx: Margin in dB when final attenuation stage should be used
+ *
+ * @ee_false_detect: Backoff in Sensitivity (dB) on channels with spur signals
+ * @ee_noise_floor_thr: Noise floor threshold in 1dB steps
+ * @ee_adc_desired_size: Desired amplitude for ADC, used by AGC; in 0.5 dB steps
+ * @ee_pga_desired_size: Desired output of PGA (for BB gain) in 0.5 dB steps
+ * @ee_pd_gain_overlap: PD ADC curves need to overlap in 0.5dB steps (ee_map>=2)
+ */
 struct ath5k_eeprom_info {
 
 	/* Header information */
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 1464f89..47f0493 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -1974,7 +1974,7 @@
 #define AR5K_PHY_SETTLING		0x9844			/* Register Address */
 #define	AR5K_PHY_SETTLING_AGC		0x0000007f	/* AGC settling time */
 #define	AR5K_PHY_SETTLING_AGC_S		0
-#define	AR5K_PHY_SETTLING_SWITCH	0x00003f80	/* Switch settlig time */
+#define	AR5K_PHY_SETTLING_SWITCH	0x00003f80	/* Switch settling time */
 #define	AR5K_PHY_SETTLING_SWITCH_S	7
 
 /*

