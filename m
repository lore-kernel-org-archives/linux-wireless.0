Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:34159 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168AbZADRdB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 12:33:01 -0500
Date: Sun, 4 Jan 2009 19:32:52 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Subject: [PATCH] ath5k: Add debug code for EEPROM
Message-ID: <20090104173252.GA5944@makis> (sfid-20090104_183308_536256_507BBCCE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Add debug code for displaying EEPROM data. Tested on various chip combinations, on x86 and IXP43x (armv5te). It has many > 80cols warnings but i 
don't think it'll be more readable if i start breaking lines, it's already messy, after all it's debug code. This code also replaces ath_info tool.

Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/debug.c b/drivers/net/wireless/ath5k/debug.c
index ccaeb5c..f0ef5b3 100644
--- a/drivers/net/wireless/ath5k/debug.c
+++ b/drivers/net/wireless/ath5k/debug.c
@@ -324,6 +324,858 @@ static const struct file_operations fops_reset = {
 	.owner = THIS_MODULE,
 };
 
+/* debugfs: EEPROM stuff */
+
+/* EEPROM Header (common) */
+static ssize_t read_file_eeprom_header(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+
+	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = sc->ah;
+	struct ath5k_eeprom_info ee = ah->ah_capabilities.cap_eeprom;
+	char buf[2000];
+	unsigned int len = 0;
+	u16 eeprom_size;
+	u8 eesize;
+
+	eesize = AR5K_REG_MS(ath5k_hw_reg_read(ah, AR5K_PCICFG),
+						AR5K_PCICFG_EESIZE);
+
+	if (eesize == 0)
+		eeprom_size = 4096 / 8;
+	else if (eesize == 1)
+		eeprom_size = 8192 / 8;
+	else if (eesize == 2)
+		eeprom_size = 16384 / 8;
+	else
+		eeprom_size = 0;
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"/==============[EEPROM Information]=============\\\n");
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"| EEPROM Version:   %1x.%1x |",
+			(ee.ee_version & 0xF000) >> 12, ee.ee_version & 0xFFF);
+	len += snprintf(buf+len, sizeof(buf)-len,
+		" EEPROM Size: %3d kbit |\n", eeprom_size * 8 / 1024);
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"| EEMAP:              %i |", AR5K_EEPROM_EEMAP(ee.ee_misc0));
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		" Reg. Domain:     0x%02X |\n", ee.ee_regdomain);
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"\\===============================================/\n\n");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"/==================[Capabilities]================\\\n");
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"| 802.11a Support:  ");
+	if (AR5K_EEPROM_HDR_11A(ee.ee_header))
+		len += snprintf(buf+len, sizeof(buf)-len, " yes |");
+	else
+		len += snprintf(buf+len, sizeof(buf)-len, " no  |");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		" Turbo-A disabled:");
+	if (AR5K_EEPROM_HDR_T_2GHZ_DIS(ee.ee_header))
+		len += snprintf(buf+len, sizeof(buf)-len, " yes |\n");
+	else
+		len += snprintf(buf+len, sizeof(buf)-len, " no  |\n");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"| 802.11b Support:  ");
+	if (AR5K_EEPROM_HDR_11B(ee.ee_header))
+		len += snprintf(buf+len, sizeof(buf)-len, " yes |");
+	else
+		len += snprintf(buf+len, sizeof(buf)-len, " no  |");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		" Turbo-G disabled:");
+	if (AR5K_EEPROM_HDR_T_2GHZ_DIS(ee.ee_header))
+		len += snprintf(buf+len, sizeof(buf)-len, " yes |\n");
+	else
+		len += snprintf(buf+len, sizeof(buf)-len, " no  |\n");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"| 802.11g Support:  ");
+	if (AR5K_EEPROM_HDR_11G(ee.ee_header))
+		len += snprintf(buf+len, sizeof(buf)-len, " yes |");
+	else
+		len += snprintf(buf+len, sizeof(buf)-len, " no  |");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		" 2GHz XR disabled:");
+	if (AR5K_EEPROM_HDR_XR2_DIS(ee.ee_misc0))
+		len += snprintf(buf+len, sizeof(buf)-len, " yes |\n");
+	else
+		len += snprintf(buf+len, sizeof(buf)-len, " no  |\n");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"| RFKill  Support:  ");
+	if (AR5K_EEPROM_HDR_RFKILL(ee.ee_header))
+		len += snprintf(buf+len, sizeof(buf)-len, " yes |");
+	else
+		len += snprintf(buf+len, sizeof(buf)-len, " no  |");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		" 5GHz XR disabled:");
+	if (AR5K_EEPROM_HDR_XR5_DIS(ee.ee_misc0))
+		len += snprintf(buf+len, sizeof(buf)-len, " yes |\n");
+	else
+		len += snprintf(buf+len, sizeof(buf)-len, " no  |\n");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"| 32kHz   Crystal:  ");
+	if (AR5K_EEPROM_HAS32KHZCRYSTAL(ee.ee_misc1) ||
+	AR5K_EEPROM_HAS32KHZCRYSTAL_OLD(ee.ee_misc1)) {
+		len += snprintf(buf+len, sizeof(buf)-len, " yes |");
+	} else {
+		len += snprintf(buf+len, sizeof(buf)-len, " no  |");
+	}
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		" HW Comp disabled:");
+	if (AR5K_EEPROM_COMP_DIS(ee.ee_misc5))
+		len += snprintf(buf+len, sizeof(buf)-len, " yes |\n");
+	else
+		len += snprintf(buf+len, sizeof(buf)-len, " no  |\n");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"| AES Enc disabled: ");
+	if (AR5K_EEPROM_AES_DIS(ee.ee_misc5))
+		len += snprintf(buf+len, sizeof(buf)-len, " yes |");
+	else
+		len += snprintf(buf+len, sizeof(buf)-len, " no  |");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		" FastFrm disabled:");
+	if (AR5K_EEPROM_FF_DIS(ee.ee_misc5))
+		len += snprintf(buf+len, sizeof(buf)-len, " yes |\n");
+	else
+		len += snprintf(buf+len, sizeof(buf)-len, " no  |\n");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"| Bursting disabled:");
+	if (AR5K_EEPROM_BURST_DIS(ee.ee_misc5))
+		len += snprintf(buf+len, sizeof(buf)-len, " yes |");
+	else
+		len += snprintf(buf+len, sizeof(buf)-len, " no  |");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		" Max avail QCU:   ");
+	len += snprintf(buf+len, sizeof(buf)-len, " %3i |\n",
+			AR5K_EEPROM_MAX_QCU(ee.ee_misc5));
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"| Heavy Clip enable:");
+	if (AR5K_EEPROM_HEAVY_CLIP_EN(ee.ee_misc5))
+		len += snprintf(buf+len, sizeof(buf)-len, " yes |");
+	else
+		len += snprintf(buf+len, sizeof(buf)-len, " no  |");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+				" Keycache size:   ");
+	len += snprintf(buf+len, sizeof(buf)-len, " %3i |\n",
+			AR5K_EEPROM_KEY_CACHE_SIZE(ee.ee_misc5));
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"\\================================================/\n\n");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"/====[Calibration data common for all modes]====\\\n");
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"|                                               |\n");
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"|        CCK/OFDM gain delta:      %2i           |\n",
+	ee.ee_cck_ofdm_gain_delta);
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"|        CCK/OFDM power delta:     %2i           |\n",
+	ee.ee_cck_ofdm_power_delta);
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"|        Scaled CCK delta:         %2i           |\n",
+	ee.ee_scaled_cck_delta);
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"|        2GHz Antenna gain:        %2i           |\n",
+	AR5K_EEPROM_ANT_GAIN_2GHZ(ee.ee_ant_gain));
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"|        5GHz Antenna gain:        %2i           |\n",
+	AR5K_EEPROM_ANT_GAIN_5GHZ(ee.ee_ant_gain));
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"|        Turbo 2W maximum dBm:     %2i           |\n",
+	AR5K_EEPROM_HDR_T_5GHZ_DBM(ee.ee_header));
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"|        Target power start:       0x%03x        |\n",
+	AR5K_EEPROM_TARGET_PWRSTART(ee.ee_misc1));
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"|        EAR Start:                0x%03x        |\n",
+	AR5K_EEPROM_EARSTART(ee.ee_misc0));
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"|                                               |\n");
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"\\===============================================/\n");
+
+	len = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+
+	return len;
+}
+
+static const struct file_operations fops_ee_header = {
+	.read = read_file_eeprom_header,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
+/* EEPROM Header (per mode) */
+static unsigned int dump_calinfo_for_mode(struct ath5k_hw *ah, int mode,
+				char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct ath5k_eeprom_info ee = ah->ah_capabilities.cap_eeprom;
+	unsigned int len = 0;
+	char buf[2000];
+	int i;
+
+	if ((!AR5K_EEPROM_HDR_11A(ee.ee_header) && (mode == AR5K_EEPROM_MODE_11A))
+	|| (!AR5K_EEPROM_HDR_11B(ee.ee_header) && (mode == AR5K_EEPROM_MODE_11B))
+	|| (!AR5K_EEPROM_HDR_11G(ee.ee_header) && (mode == AR5K_EEPROM_MODE_11G))) {
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"Mode not available for your card\n");
+		len = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+		return len;
+	}
+
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"/=========================================================\\\n");
+
+	if (mode == AR5K_EEPROM_MODE_11A)
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"|               Calibration data for 802.11a              |\n");
+
+	if (mode == AR5K_EEPROM_MODE_11B)
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"|               Calibration data for 802.11b              |\n");
+
+	if (mode == AR5K_EEPROM_MODE_11G)
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"|               Calibration data for 802.11g              |\n");
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"|=========================================================|\n");
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"| I power:              0x%02x | Q power:              0x%02x |\n",
+	ee.ee_i_cal[mode], ee.ee_q_cal[mode]);
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"| Use fixed bias:       0x%02x | Max turbo power:      0x%02x |\n",
+	ee.ee_fixed_bias[mode], ee.ee_turbo_max_power[mode]);
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"| Max XR power:         0x%02x | Switch Settling Time: 0x%02x |\n",
+	ee.ee_xr_power[mode], ee.ee_switch_settling[mode]);
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"| Tx/Rx attenuation:    0x%02x | TX end to XLNA On:    0x%02x |\n",
+	ee.ee_atn_tx_rx[mode], ee.ee_tx_end2xlna_enable[mode]);
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"| TX end to XPA Off:    0x%02x | TX end to XPA On:     0x%02x |\n",
+	ee.ee_tx_end2xpa_disable[mode], ee.ee_tx_frm2xpa_enable[mode]);
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"| 62db Threshold:       0x%02x | XLNA gain:            0x%02x |\n",
+	ee.ee_thr_62[mode], ee.ee_xlna_gain[mode]);
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"| XPD:                  0x%02x | XPD gain:             0x%02x |\n",
+	ee.ee_xpd[mode], ee.ee_x_gain[mode]);
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"| I gain:               0x%02x | Tx/Rx margin:         0x%02x |\n",
+	ee.ee_i_gain[mode], ee.ee_margin_tx_rx[mode]);
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"| False detect backoff: 0x%02x | Noise Floor Threshold: %3d |\n",
+	ee.ee_false_detect[mode], ee.ee_noise_floor_thr[mode]);
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"| ADC desired size:      %3d | PGA desired size:      %3d |\n",
+	ee.ee_adc_desired_size[mode], ee.ee_pga_desired_size[mode]);
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"|=========================================================|\n");
+	for (i = 0; i < AR5K_EEPROM_N_PCDAC; i++) {
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"| Antenna control  %2i:  0x%02x |", i,
+		ee.ee_ant_control[mode][i]);
+		i++;
+		len += snprintf(buf+len, sizeof(buf)-len,
+		" Antenna control  %2i:  0x%02x |\n", i,
+		ee.ee_ant_control[mode][i]);
+	}
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"|=========================================================|\n");
+	for (i = 0; i < AR5K_EEPROM_N_OBDB; i++) {
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"| Output Bias current %i:  %2i |", i,
+		ee.ee_ob[mode][i]);
+		len += snprintf(buf+len, sizeof(buf)-len,
+		" Driver Bias current %i:  %2i |\n", i,
+		ee.ee_db[mode][i]);
+	}
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"\\=========================================================/\n");
+
+	if (ee.ee_version >= AR5K_EEPROM_VERSION_5_0 &&
+	(mode == AR5K_EEPROM_MODE_11A || mode == AR5K_EEPROM_MODE_11G)) {
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"/==================== Turbo mode infos ===================\\\n");
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"| Switch Settling time: 0x%02x | Tx/Rx margin:         0x%02x |\n",
+		ee.ee_switch_settling_turbo[mode], ee.ee_margin_tx_rx_turbo[mode]);
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"| Tx/Rx attenuation:    0x%02x | ADC desired size:      %3d |\n",
+		ee.ee_atn_tx_rx_turbo[mode], ee.ee_adc_desired_size_turbo[mode]);
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"| PGA desired size:      %3d |                            |\n",
+		ee.ee_pga_desired_size_turbo[mode]);
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"\\=========================================================/\n");
+	}
+
+	len = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	return len;
+}
+
+static ssize_t read_file_eeprom_header_11a(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = sc->ah;
+	unsigned int len = 0;
+
+	len = dump_calinfo_for_mode(ah, AR5K_EEPROM_MODE_11A, user_buf, count, ppos);
+	return len;
+}
+
+static ssize_t read_file_eeprom_header_11b(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = sc->ah;
+	unsigned int len = 0;
+
+	len = dump_calinfo_for_mode(ah, AR5K_EEPROM_MODE_11B, user_buf, count, ppos);
+	return len;
+}
+
+static ssize_t read_file_eeprom_header_11g(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = sc->ah;
+	unsigned int len = 0;
+
+	len = dump_calinfo_for_mode(ah, AR5K_EEPROM_MODE_11G, user_buf, count, ppos);
+	return len;
+}
+
+static const struct file_operations fops_ee_header_11a = {
+	.read = read_file_eeprom_header_11a,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
+static const struct file_operations fops_ee_header_11b = {
+	.read = read_file_eeprom_header_11b,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
+static const struct file_operations fops_ee_header_11g = {
+	.read = read_file_eeprom_header_11g,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
+
+/* EEPROM channel power calibration info (per mode) */
+static unsigned int dump_pcalinfo_for_mode_rf5111(struct ath5k_hw *ah, int mode,
+				char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct ath5k_eeprom_info ee = ah->ah_capabilities.cap_eeprom;
+	struct ath5k_chan_pcal_info *gen_chan_info;
+	struct ath5k_chan_pcal_info_rf5111 *chan_pcal_info;
+	unsigned int len = 0;
+	char buf[4000];
+	u_int16_t cal_piers;
+	int i, c;
+
+	if ((!AR5K_EEPROM_HDR_11A(ee.ee_header) && (mode == AR5K_EEPROM_MODE_11A))
+	|| (!AR5K_EEPROM_HDR_11B(ee.ee_header) && (mode == AR5K_EEPROM_MODE_11B))
+	|| (!AR5K_EEPROM_HDR_11G(ee.ee_header) && (mode == AR5K_EEPROM_MODE_11G))) {
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"Mode not available for your card\n");
+		len = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+		return len;
+	}
+
+	switch (mode) {
+	case AR5K_EEPROM_MODE_11A:
+		gen_chan_info = ee.ee_pwr_cal_a;
+		cal_piers = ee.ee_n_piers[mode];
+		break;
+	case AR5K_EEPROM_MODE_11B:
+		gen_chan_info = ee.ee_pwr_cal_b;
+		cal_piers = ee.ee_n_piers[mode];
+		break;
+	case AR5K_EEPROM_MODE_11G:
+		gen_chan_info = ee.ee_pwr_cal_g;
+		cal_piers = ee.ee_n_piers[mode];
+		break;
+	default:
+		return len;
+	}
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"/=============================== Per channel power calibration ================================\\\n");
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"| Freq | pwr_0 | pwr_1 | pwr_2 | pwr_3 | pwr_4 | pwr_5 | pwr_6 | pwr_7 | pwr_8 | pwr_9 | pwr10 |\n");
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"|      | pcdac | pcdac | pcdac | pcdac | pcdac | pcdac | pcdac | pcdac | pcdac | pcdac | pcdac |\n");
+
+	for (i = 0; i < cal_piers; i++) {
+		chan_pcal_info = &gen_chan_info[i].rf5111_info;
+
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"|======|=======|=======|=======|=======|=======|=======|=======|=======|=======|=======|=======|\n");
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"| %4i |", gen_chan_info[i].freq);
+		if (ee.ee_version <= AR5K_EEPROM_VERSION_3_3) {
+			for (c = 0; c < AR5K_EEPROM_N_PWR_POINTS_5111; c++) {
+				len += snprintf(buf+len, sizeof(buf)-len,
+					" %2i.%02i |", chan_pcal_info->pwr[c] / 2,
+					chan_pcal_info->pwr[c] % 2 * 50);
+			}
+
+			len += snprintf(buf+len, sizeof(buf)-len, "\n|      |");
+		} else {
+			for (c = 0; c < AR5K_EEPROM_N_PWR_POINTS_5111; c++) {
+				len += snprintf(buf+len, sizeof(buf)-len,
+					" %2i.%02i |", chan_pcal_info->pwr[c] / 4,
+					chan_pcal_info->pwr[c] % 4 * 25);
+			}
+
+			len += snprintf(buf+len, sizeof(buf)-len, "\n|      |");
+		}
+
+		for (c = 0; c < AR5K_EEPROM_N_PWR_POINTS_5111; c++) {
+			len += snprintf(buf+len, sizeof(buf)-len, " [%2i]",
+				 chan_pcal_info->pcdac[c]);
+			len += snprintf(buf+len, sizeof(buf)-len, "  |");
+		}
+
+		len += snprintf(buf+len, sizeof(buf)-len, "\n");
+
+	}
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"\\==============================================================================================/\n");
+	len = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	return len;
+}
+
+static unsigned int dump_pcalinfo_for_mode_rf5112(struct ath5k_hw *ah, int mode,
+				char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct ath5k_eeprom_info ee = ah->ah_capabilities.cap_eeprom;
+	struct ath5k_chan_pcal_info *gen_chan_info;
+	struct ath5k_chan_pcal_info_rf5112 *chan_pcal_info;
+	unsigned int len = 0;
+	char buf[4000];
+	u_int16_t cal_piers;
+	int i, c;
+
+	if ((!AR5K_EEPROM_HDR_11A(ee.ee_header) && (mode == AR5K_EEPROM_MODE_11A))
+	|| (!AR5K_EEPROM_HDR_11B(ee.ee_header) && (mode == AR5K_EEPROM_MODE_11B))
+	|| (!AR5K_EEPROM_HDR_11G(ee.ee_header) && (mode == AR5K_EEPROM_MODE_11G))) {
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"Mode not available for your card\n");
+		len = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+		return len;
+	}
+
+	switch (mode) {
+	case AR5K_EEPROM_MODE_11A:
+		gen_chan_info = ee.ee_pwr_cal_a;
+		cal_piers = ee.ee_n_piers[mode];
+		break;
+	case AR5K_EEPROM_MODE_11B:
+		gen_chan_info = ee.ee_pwr_cal_b;
+		cal_piers = ee.ee_n_piers[mode];
+		break;
+	case AR5K_EEPROM_MODE_11G:
+		gen_chan_info = ee.ee_pwr_cal_g;
+		cal_piers = ee.ee_n_piers[mode];
+		break;
+	default:
+		return len;
+	}
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"/=================== Per channel power calibration ====================\\\n");
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"| Freq | pwr_0 | pwr_1 | pwr_2 | pwr_3 |pwrx3_0|pwrx3_1|pwrx3_2|max_pwr|\n");
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"|      | pcdac | pcdac | pcdac | pcdac | pcdac | pcdac | pcdac |       |\n");
+
+	for (i = 0; i < cal_piers; i++) {
+
+		chan_pcal_info = &gen_chan_info[i].rf5112_info;
+
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"|======|=======|=======|=======|=======|=======|=======|=======|=======|\n");
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"| %4i |", gen_chan_info[i].freq);
+
+		for (c = 0; c < AR5K_EEPROM_N_XPD0_POINTS; c++) {
+			len += snprintf(buf+len, sizeof(buf)-len,
+				" %2i.%02i |", chan_pcal_info->pwr_x0[c] / 4,
+				chan_pcal_info->pwr_x0[c] % 4 * 25);
+		}
+
+		for (c = 0; c < AR5K_EEPROM_N_XPD3_POINTS; c++) {
+			len += snprintf(buf+len, sizeof(buf)-len,
+				" %2i.%02i |", chan_pcal_info->pwr_x3[c] / 4,
+				chan_pcal_info->pwr_x3[c] % 4 * 25);
+		}
+
+		len += snprintf(buf+len, sizeof(buf)-len,
+			" %2i.%02i |\n", gen_chan_info[i].max_pwr / 4,
+			gen_chan_info[i].max_pwr % 4 * 25);
+
+		len += snprintf(buf+len, sizeof(buf)-len, "|      |");
+
+		for (c = 0; c < AR5K_EEPROM_N_XPD0_POINTS; c++) {
+			len += snprintf(buf+len, sizeof(buf)-len, "  [%2i]",
+				chan_pcal_info->pcdac_x0[c]);
+			len += snprintf(buf+len, sizeof(buf)-len,
+				" |");
+		}
+
+		for (c = 0; c < AR5K_EEPROM_N_XPD3_POINTS; c++) {
+			len += snprintf(buf+len, sizeof(buf)-len, "  [%2i]",
+				chan_pcal_info->pcdac_x3[c]);
+			len += snprintf(buf+len, sizeof(buf)-len,
+				" |");
+		}
+
+		len += snprintf(buf+len, sizeof(buf)-len, "       |\n");
+
+	}
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"\\======================================================================/\n");
+	len = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	return len;
+}
+
+static unsigned int dump_pcalinfo_for_mode_rf2413(struct ath5k_hw *ah, int mode,
+				char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct ath5k_eeprom_info ee = ah->ah_capabilities.cap_eeprom;
+	struct ath5k_chan_pcal_info *gen_chan_info;
+	struct ath5k_chan_pcal_info_rf2413 *chan_pcal_info;
+	unsigned int len = 0;
+	char buf[4000];
+	u_int16_t cal_piers;
+	int i, c;
+
+	if ((!AR5K_EEPROM_HDR_11A(ee.ee_header) && (mode == AR5K_EEPROM_MODE_11A))
+	|| (!AR5K_EEPROM_HDR_11B(ee.ee_header) && (mode == AR5K_EEPROM_MODE_11B))
+	|| (!AR5K_EEPROM_HDR_11G(ee.ee_header) && (mode == AR5K_EEPROM_MODE_11G))) {
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"Mode not available for your card\n");
+		len = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+		return len;
+	}
+
+	switch (mode) {
+	case AR5K_EEPROM_MODE_11A:
+		gen_chan_info = ee.ee_pwr_cal_a;
+		cal_piers = ee.ee_n_piers[mode];
+		break;
+	case AR5K_EEPROM_MODE_11B:
+		gen_chan_info = ee.ee_pwr_cal_b;
+		cal_piers = ee.ee_n_piers[mode];
+		break;
+	case AR5K_EEPROM_MODE_11G:
+		gen_chan_info = ee.ee_pwr_cal_g;
+		cal_piers = ee.ee_n_piers[mode];
+		break;
+	default:
+		return len;
+	}
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"/====================== Per channel power calibration ===================\\\n");
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"| Freq |  pwr_i  |    pwr_0    |    pwr_1    |    pwr_2    |    pwr_3    |\n");
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"|      | pddac_i |   pddac_0   |   pddac_1   |   pddac_2   |   pddac_3   |\n");
+
+	for (i = 0; i < cal_piers; i++) {
+
+		chan_pcal_info = &gen_chan_info[i].rf2413_info;
+
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"|======|=========|=============|=============|=============|=============|\n");
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"| %4i |         |             |             |             |             |\n",
+		gen_chan_info[i].freq);
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"|------|---------|-------------|-------------|-------------|-------------|\n");
+		for (c = 0; c < ee.ee_pd_gains[mode]; c++) {
+			len += snprintf(buf+len, sizeof(buf)-len,
+			"|      |    %2i   |    %2i.%02i    |    %2i.%02i    |    %2i.%02i    |    %2i.%02i    |\n",
+				chan_pcal_info->pwr_i[c],
+				chan_pcal_info->pwr[c][0] / 2,
+				chan_pcal_info->pwr[c][0] % 2 * 50,
+				chan_pcal_info->pwr[c][1] / 2,
+				chan_pcal_info->pwr[c][1] % 2 * 50,
+				chan_pcal_info->pwr[c][2] / 2,
+				chan_pcal_info->pwr[c][2] % 2 * 50,
+				chan_pcal_info->pwr[c][3] / 2,
+				chan_pcal_info->pwr[c][3] % 2 * 50);
+
+			len += snprintf(buf+len, sizeof(buf)-len,
+			"|      |   %3i   |      %3i    |      %3i    |      %3i    |      %3i    |\n",
+				chan_pcal_info->pddac_i[c],
+				chan_pcal_info->pddac[c][0],
+				chan_pcal_info->pddac[c][1],
+				chan_pcal_info->pddac[c][2],
+				chan_pcal_info->pddac[c][3]);
+
+			if (c < ee.ee_pd_gains[mode] - 1)
+			len += snprintf(buf+len, sizeof(buf)-len,
+			"|------|---------|-------------|-------------|-------------|-------------|\n");
+		}
+	}
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"\\========================================================================/\n");
+	len = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	return len;
+}
+
+static ssize_t read_file_eeprom_pcalinfo_11a(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = sc->ah;
+	unsigned int len = 0;
+
+	switch (ah->ah_radio) {
+	case AR5K_RF5111:
+		len = dump_pcalinfo_for_mode_rf5111(ah, AR5K_EEPROM_MODE_11A,
+							user_buf, count, ppos);
+		break;
+	case AR5K_RF5112:
+		len = dump_pcalinfo_for_mode_rf5112(ah, AR5K_EEPROM_MODE_11A,
+							user_buf, count, ppos);
+		break;
+	case AR5K_RF2413:
+	case AR5K_RF5413:
+	case AR5K_RF2425:
+		len = dump_pcalinfo_for_mode_rf2413(ah, AR5K_EEPROM_MODE_11A,
+							user_buf, count, ppos);
+		break;
+	default:
+		return 0;
+	}
+
+	return len;
+}
+
+static ssize_t read_file_eeprom_pcalinfo_11b(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = sc->ah;
+	unsigned int len = 0;
+
+	switch (ah->ah_radio) {
+	case AR5K_RF5111:
+		len = dump_pcalinfo_for_mode_rf5111(ah, AR5K_EEPROM_MODE_11B, user_buf, count, ppos);
+		break;
+	case AR5K_RF5112:
+		len = dump_pcalinfo_for_mode_rf5112(ah, AR5K_EEPROM_MODE_11B, user_buf, count, ppos);
+		break;
+	case AR5K_RF2413:
+	case AR5K_RF5413:
+	case AR5K_RF2425:
+		len = dump_pcalinfo_for_mode_rf2413(ah, AR5K_EEPROM_MODE_11B, user_buf, count, ppos);
+		break;
+	default:
+		return 0;
+	}
+
+	return len;
+}
+
+static ssize_t read_file_eeprom_pcalinfo_11g(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = sc->ah;
+	unsigned int len = 0;
+
+	switch (ah->ah_radio) {
+	case AR5K_RF5111:
+		len = dump_pcalinfo_for_mode_rf5111(ah, AR5K_EEPROM_MODE_11G, user_buf, count, ppos);
+		break;
+	case AR5K_RF5112:
+		len = dump_pcalinfo_for_mode_rf5112(ah, AR5K_EEPROM_MODE_11G, user_buf, count, ppos);
+		break;
+	case AR5K_RF2413:
+	case AR5K_RF5413:
+	case AR5K_RF2425:
+		len = dump_pcalinfo_for_mode_rf2413(ah, AR5K_EEPROM_MODE_11G, user_buf, count, ppos);
+		break;
+	default:
+		return 0;
+	}
+
+	return len;
+}
+
+static const struct file_operations fops_ee_pcalinfo_11a = {
+	.read = read_file_eeprom_pcalinfo_11a,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
+static const struct file_operations fops_ee_pcalinfo_11b = {
+	.read = read_file_eeprom_pcalinfo_11b,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
+static const struct file_operations fops_ee_pcalinfo_11g = {
+	.read = read_file_eeprom_pcalinfo_11g,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
+/* EEPROM Per rate power calibration info */
+static unsigned int dump_rate_calinfo_for_mode(struct ath5k_hw *ah, int mode,
+				char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct ath5k_eeprom_info ee = ah->ah_capabilities.cap_eeprom;
+	struct ath5k_rate_pcal_info *rate_pcal_info;
+	u_int16_t rate_target_pwr_num;
+	unsigned int len = 0;
+	char buf[2000];
+	int i;
+
+	if ((!AR5K_EEPROM_HDR_11A(ee.ee_header) && (mode == AR5K_EEPROM_MODE_11A))
+	|| (!AR5K_EEPROM_HDR_11B(ee.ee_header) && (mode == AR5K_EEPROM_MODE_11B))
+	|| (!AR5K_EEPROM_HDR_11G(ee.ee_header) && (mode == AR5K_EEPROM_MODE_11G))) {
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"Mode not available for your card\n");
+		len = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+		return len;
+	}
+
+	switch (mode) {
+	case AR5K_EEPROM_MODE_11A:
+		rate_pcal_info = ee.ee_rate_tpwr_a;
+		rate_target_pwr_num = ee.ee_rate_target_pwr_num[mode];
+		break;
+	case AR5K_EEPROM_MODE_11B:
+		rate_pcal_info = ee.ee_rate_tpwr_b;
+		rate_target_pwr_num = ee.ee_rate_target_pwr_num[mode];
+		break;
+	case AR5K_EEPROM_MODE_11G:
+		rate_pcal_info = ee.ee_rate_tpwr_g;
+		rate_target_pwr_num = ee.ee_rate_target_pwr_num[mode];
+		break;
+	default:
+		return 0;
+	}
+
+	len += snprintf(buf+len, sizeof(buf)-len,
+		"/============== Per rate power calibration ===========\\\n");
+	if (mode == AR5K_EEPROM_MODE_11B)
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"| Freq |   1Mbit/s  | 2Mbit/s  | 5.5Mbit/s | 11Mbit/s |\n");
+	else
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"| Freq | 6-24Mbit/s | 36Mbit/s |  48Mbit/s | 54Mbit/s |\n");
+
+	for (i = 0; i < rate_target_pwr_num; i++) {
+
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"|======|============|==========|===========|==========|\n");
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"| %4i |", rate_pcal_info[i].freq);
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"    %2i.%02i   |", rate_pcal_info[i].target_power_6to24 / 2,
+					rate_pcal_info[i].target_power_6to24 % 2);
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"  %2i.%02i   |", rate_pcal_info[i].target_power_36 / 2,
+					rate_pcal_info[i].target_power_36 % 2);
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"   %2i.%02i   |", rate_pcal_info[i].target_power_48 / 2,
+					rate_pcal_info[i].target_power_48 % 2);
+		len += snprintf(buf+len, sizeof(buf)-len,
+		"  %2i.%02i   |\n", rate_pcal_info[i].target_power_54 / 2,
+					rate_pcal_info[i].target_power_54 % 2);
+	}
+	len += snprintf(buf+len, sizeof(buf)-len,
+	"\\=====================================================/\n");
+	len = simple_read_from_buffer(user_buf, count, ppos, buf, len);
+	return len;
+}
+
+static ssize_t read_file_rate_pcalinfo_11a(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = sc->ah;
+	unsigned int len = 0;
+
+	len = dump_rate_calinfo_for_mode(ah, AR5K_EEPROM_MODE_11A, user_buf, count, ppos);
+	return len;
+}
+
+static ssize_t read_file_rate_pcalinfo_11b(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = sc->ah;
+	unsigned int len = 0;
+
+	len = dump_rate_calinfo_for_mode(ah, AR5K_EEPROM_MODE_11B, user_buf, count, ppos);
+	return len;
+}
+
+static ssize_t read_file_rate_pcalinfo_11g(struct file *file, char __user *user_buf,
+				   size_t count, loff_t *ppos)
+{
+	struct ath5k_softc *sc = file->private_data;
+	struct ath5k_hw *ah = sc->ah;
+	unsigned int len = 0;
+
+	len = dump_rate_calinfo_for_mode(ah, AR5K_EEPROM_MODE_11G, user_buf, count, ppos);
+	return len;
+}
+
+static const struct file_operations fops_ee_rate_pcalinfo_11a = {
+	.read = read_file_rate_pcalinfo_11a,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
+static const struct file_operations fops_ee_rate_pcalinfo_11b = {
+	.read = read_file_rate_pcalinfo_11b,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
+
+static const struct file_operations fops_ee_rate_pcalinfo_11g = {
+	.read = read_file_rate_pcalinfo_11g,
+	.open = ath5k_debugfs_open,
+	.owner = THIS_MODULE,
+};
 
 /* debugfs: debug level */
 
@@ -426,6 +1278,36 @@ ath5k_debug_init_device(struct ath5k_softc *sc)
 	sc->debug.debugfs_tsf = debugfs_create_file("tsf", S_IWUSR | S_IRUGO,
 				sc->debug.debugfs_phydir, sc, &fops_tsf);
 
+	sc->debug.debugfs_ee_header = debugfs_create_file("eeprom_header", S_IRUGO,
+				sc->debug.debugfs_phydir, sc, &fops_ee_header);
+
+	sc->debug.debugfs_ee_header_11a = debugfs_create_file("eeprom_header_11a", S_IRUGO,
+				sc->debug.debugfs_phydir, sc, &fops_ee_header_11a);
+
+	sc->debug.debugfs_ee_header_11b = debugfs_create_file("eeprom_header_11b", S_IRUGO,
+				sc->debug.debugfs_phydir, sc, &fops_ee_header_11b);
+
+	sc->debug.debugfs_ee_header_11g = debugfs_create_file("eeprom_header_11g", S_IRUGO,
+				sc->debug.debugfs_phydir, sc, &fops_ee_header_11g);
+
+	sc->debug.debugfs_ee_pcalinfo_11a = debugfs_create_file("eeprom_chan_pcalinfo_11a", S_IRUGO,
+				sc->debug.debugfs_phydir, sc, &fops_ee_pcalinfo_11a);
+
+	sc->debug.debugfs_ee_pcalinfo_11b = debugfs_create_file("eeprom_chan_pcalinfo_11b", S_IRUGO,
+				sc->debug.debugfs_phydir, sc, &fops_ee_pcalinfo_11b);
+
+	sc->debug.debugfs_ee_pcalinfo_11g = debugfs_create_file("eeprom_chan_pcalinfo_11g", S_IRUGO,
+				sc->debug.debugfs_phydir, sc, &fops_ee_pcalinfo_11g);
+
+	sc->debug.debugfs_ee_rate_pcalinfo_11a = debugfs_create_file("eeprom_rate_pcalinfo_11a", S_IRUGO,
+				sc->debug.debugfs_phydir, sc, &fops_ee_rate_pcalinfo_11a);
+
+	sc->debug.debugfs_ee_rate_pcalinfo_11b = debugfs_create_file("eeprom_rate_pcalinfo_11b", S_IRUGO,
+				sc->debug.debugfs_phydir, sc, &fops_ee_rate_pcalinfo_11b);
+
+	sc->debug.debugfs_ee_rate_pcalinfo_11g = debugfs_create_file("eeprom_rate_pcalinfo_11g", S_IRUGO,
+				sc->debug.debugfs_phydir, sc, &fops_ee_rate_pcalinfo_11g);
+
 	sc->debug.debugfs_beacon = debugfs_create_file("beacon", S_IWUSR | S_IRUGO,
 				sc->debug.debugfs_phydir, sc, &fops_beacon);
 
@@ -446,6 +1328,16 @@ ath5k_debug_finish_device(struct ath5k_softc *sc)
 	debugfs_remove(sc->debug.debugfs_registers);
 	debugfs_remove(sc->debug.debugfs_tsf);
 	debugfs_remove(sc->debug.debugfs_beacon);
+	debugfs_remove(sc->debug.debugfs_ee_header);
+	debugfs_remove(sc->debug.debugfs_ee_header_11a);
+	debugfs_remove(sc->debug.debugfs_ee_header_11b);
+	debugfs_remove(sc->debug.debugfs_ee_header_11g);
+	debugfs_remove(sc->debug.debugfs_ee_pcalinfo_11a);
+	debugfs_remove(sc->debug.debugfs_ee_pcalinfo_11b);
+	debugfs_remove(sc->debug.debugfs_ee_pcalinfo_11g);
+	debugfs_remove(sc->debug.debugfs_ee_rate_pcalinfo_11a);
+	debugfs_remove(sc->debug.debugfs_ee_rate_pcalinfo_11b);
+	debugfs_remove(sc->debug.debugfs_ee_rate_pcalinfo_11g);
 	debugfs_remove(sc->debug.debugfs_reset);
 	debugfs_remove(sc->debug.debugfs_phydir);
 }
diff --git a/drivers/net/wireless/ath5k/debug.h b/drivers/net/wireless/ath5k/debug.h
index ffc5293..c5c88d8 100644
--- a/drivers/net/wireless/ath5k/debug.h
+++ b/drivers/net/wireless/ath5k/debug.h
@@ -73,6 +73,16 @@ struct ath5k_dbg_info {
 	struct dentry		*debugfs_debug;
 	struct dentry		*debugfs_registers;
 	struct dentry		*debugfs_tsf;
+	struct dentry		*debugfs_ee_header;
+	struct dentry		*debugfs_ee_header_11a;
+	struct dentry		*debugfs_ee_header_11b;
+	struct dentry		*debugfs_ee_header_11g;
+	struct dentry		*debugfs_ee_pcalinfo_11a;
+	struct dentry		*debugfs_ee_pcalinfo_11b;
+	struct dentry		*debugfs_ee_pcalinfo_11g;
+	struct dentry		*debugfs_ee_rate_pcalinfo_11a;
+	struct dentry		*debugfs_ee_rate_pcalinfo_11b;
+	struct dentry		*debugfs_ee_rate_pcalinfo_11g;
 	struct dentry		*debugfs_beacon;
 	struct dentry		*debugfs_reset;
 };

