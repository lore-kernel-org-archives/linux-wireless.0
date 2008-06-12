Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42591 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbYFLBt6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 21:49:58 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 22/29] iwlwifi: cleans up scanning code
Date: Thu, 12 Jun 2008 09:47:12 +0800
Message-Id: <1213235239-2954-23-git-send-email-yi.zhu@intel.com> (sfid-20080612_041913_220661_D54DCD68)
In-Reply-To: <1213235239-2954-22-git-send-email-yi.zhu@intel.com>
References: <1213235239-2954-1-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-2-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-3-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-4-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-5-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-6-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-7-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-8-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-9-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-10-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-11-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-12-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-13-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-14-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-15-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-16-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-17-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-18-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-19-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-20-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-21-git-send-email-yi.zhu@intel.com>
 <1213235239-2954-22-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch
1. cleans up scanning code.
2. It adds round robin of TX antannas/chains.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-commands.h |   14 +--
 drivers/net/wireless/iwlwifi/iwl-core.c     |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   33 +-----
 drivers/net/wireless/iwlwifi/iwl-scan.c     |  178 +++++++++++++++------------
 5 files changed, 107 insertions(+), 120 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 058e764..6613d32 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -281,16 +281,7 @@ struct iwl_cmd_header {
 #define RATE_MCS_ANT_C_MSK    0x10000
 #define RATE_MCS_ANT_ABC_MSK  0x1C000
 
-
-/**
- * struct iwl4965_tx_power - txpower format used in REPLY_SCAN_CMD
- *
- * Scan uses only one transmitter, so only one analog/dsp gain pair is needed.
- */
-struct iwl4965_tx_power {
-	u8 tx_gain;		/* gain for analog radio */
-	u8 dsp_atten;		/* gain for DSP */
-} __attribute__ ((packed));
+#define RATE_MCS_ANT_INIT_IND   1
 
 #define POWER_TABLE_NUM_ENTRIES			33
 #define POWER_TABLE_NUM_HT_OFDM_ENTRIES		32
@@ -2128,7 +2119,8 @@ struct iwl_scan_channel {
 	 */
 	u8 type;
 	u8 channel;	/* band is selected by iwl4965_scan_cmd "flags" field */
-	struct iwl4965_tx_power tpc;
+	u8 tx_gain;		/* gain for analog radio */
+	u8 dsp_atten;		/* gain for DSP */
 	__le16 active_dwell;	/* in 1024-uSec TU (time units), typ 5-50 */
 	__le16 passive_dwell;	/* in 1024-uSec TU (time units), typ 20-500 */
 } __attribute__ ((packed));
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 7e20f46..9794904 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -874,6 +874,7 @@ int iwl_init_drv(struct iwl_priv *priv)
 
 	/* Choose which receivers/antennas to use */
 	iwl_set_rxon_chain(priv);
+	iwl_init_scan_params(priv);
 
 	if (priv->cfg->mod_params->enable_qos)
 		priv->qos_data.qos_enable = 1;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2eb08f3..8d9fde6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -267,6 +267,7 @@ static inline __le32 iwl_hw_set_rate_n_flags(u8 rate, u32 flags)
 /*******************************************************************************
  * Scanning
  ******************************************************************************/
+void iwl_init_scan_params(struct iwl_priv *priv);
 int iwl_scan_cancel(struct iwl_priv *priv);
 int iwl_scan_cancel_timeout(struct iwl_priv *priv, unsigned long ms);
 const char *iwl_escape_essid(const char *essid, u8 essid_len);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 69765c9..ef74159 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -157,35 +157,11 @@ struct iwl4965_channel_tgh_info {
 	s64 last_radar_time;
 };
 
-/* current Tx power values to use, one for each rate for each channel.
- * requested power is limited by:
- * -- regulatory EEPROM limits for this channel
- * -- hardware capabilities (clip-powers)
- * -- spectrum management
- * -- user preference (e.g. iwconfig)
- * when requested power is set, base power index must also be set. */
-struct iwl4965_channel_power_info {
-	struct iwl4965_tx_power tpc;	/* actual radio and DSP gain settings */
-	s8 power_table_index;	/* actual (compenst'd) index into gain table */
-	s8 base_power_index;	/* gain index for power at factory temp. */
-	s8 requested_power;	/* power (dBm) requested for this chnl/rate */
-};
-
-/* current scan Tx power values to use, one for each scan rate for each
- * channel. */
-struct iwl4965_scan_power_info {
-	struct iwl4965_tx_power tpc;	/* actual radio and DSP gain settings */
-	s8 power_table_index;	/* actual (compenst'd) index into gain table */
-	s8 requested_power;	/* scan pwr (dBm) requested for chnl/rate */
-};
-
 /*
  * One for each channel, holds all channel setup data
  * Some of the fields (e.g. eeprom and flags/max_power_avg) are redundant
  *     with one another!
  */
-#define IWL4965_MAX_RATE (33)
-
 struct iwl_channel_info {
 	struct iwl4965_channel_tgd_info tgd;
 	struct iwl4965_channel_tgh_info tgh;
@@ -204,11 +180,6 @@ struct iwl_channel_info {
 	u8 band_index;	  /* 0-4, maps channel to band1/2/3/4/5 */
 	enum ieee80211_band band;
 
-	/* Radio/DSP gain settings for each "normal" data Tx rate.
-	 * These include, in addition to RF and DSP gain, a few fields for
-	 *   remembering/modifying gain settings (indexes). */
-	struct iwl4965_channel_power_info power_info[IWL4965_MAX_RATE];
-
 	/* FAT channel info */
 	s8 fat_max_power_avg;	/* (dBm) regul. eeprom, normal Tx, any rate */
 	s8 fat_curr_txpow;	/* (dBm) regulatory/spectrum/user (not h/w) */
@@ -216,9 +187,6 @@ struct iwl_channel_info {
 	s8 fat_scan_power;	/* (dBm) eeprom, direct scans, any rate */
 	u8 fat_flags;		/* flags copied from EEPROM */
 	u8 fat_extension_channel; /* HT_IE_EXT_CHANNEL_* */
-
-	/* Radio/DSP gain settings for each scan rate, for directed scans. */
-	struct iwl4965_scan_power_info scan_pwr_info[IWL_NUM_SCAN_RATES];
 };
 
 struct iwl4965_clip_group {
@@ -974,6 +942,7 @@ struct iwl_priv {
 	u8 direct_ssid_len;
 	u8 direct_ssid[IW_ESSID_MAX_SIZE];
 	struct iwl_scan_cmd *scan;
+	u32 scan_tx_ant[IEEE80211_NUM_BANDS];
 
 	/* spinlock */
 	spinlock_t lock;	/* protect general shared data */
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 7b9475b..5ca181f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -58,7 +58,9 @@
 #define IWL_PASSIVE_DWELL_BASE      (100)
 #define IWL_CHANNEL_TUNE_TIME       5
 
-
+static int scan_tx_ant[3] = {
+	RATE_MCS_ANT_A_MSK, RATE_MCS_ANT_B_MSK, RATE_MCS_ANT_C_MSK
+};
 
 static int iwl_is_empty_essid(const char *essid, int essid_len)
 {
@@ -385,8 +387,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		scan_ch->channel =
 			ieee80211_frequency_to_channel(channels[i].center_freq);
 
-		ch_info = iwl_get_channel_info(priv, band,
-					 scan_ch->channel);
+		ch_info = iwl_get_channel_info(priv, band, scan_ch->channel);
 		if (!is_channel_valid(ch_info)) {
 			IWL_DEBUG_SCAN("Channel %d is INVALID for this SKU.\n",
 				       scan_ch->channel);
@@ -395,9 +396,9 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 
 		if (!is_active || is_channel_passive(ch_info) ||
 		    (channels[i].flags & IEEE80211_CHAN_PASSIVE_SCAN))
-			scan_ch->type = 0;	/* passive */
+			scan_ch->type = 0;
 		else
-			scan_ch->type = 1;	/* active */
+			scan_ch->type = 1;
 
 		if (scan_ch->type & 1)
 			scan_ch->type |= (direct_mask << 1);
@@ -406,17 +407,15 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 		scan_ch->passive_dwell = cpu_to_le16(passive_dwell);
 
 		/* Set txpower levels to defaults */
-		scan_ch->tpc.dsp_atten = 110;
-		/* scan_pwr_info->tpc.dsp_atten; */
+		scan_ch->dsp_atten = 110;
 
-		/*scan_pwr_info->tpc.tx_gain; */
 		if (band == IEEE80211_BAND_5GHZ)
-			scan_ch->tpc.tx_gain = ((1 << 5) | (3 << 3)) | 3;
+			scan_ch->tx_gain = ((1 << 5) | (3 << 3)) | 3;
 		else {
-			scan_ch->tpc.tx_gain = ((1 << 5) | (5 << 3));
+			scan_ch->tx_gain = ((1 << 5) | (5 << 3));
 			/* NOTE: if we were doing 6Mb OFDM for scans we'd use
 			 * power level:
-			 * scan_ch->tpc.tx_gain = ((1 << 5) | (2 << 3)) | 3;
+			 * scan_ch->tx_gain = ((1 << 5) | (2 << 3)) | 3;
 			 */
 		}
 
@@ -434,6 +433,14 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
 	return added;
 }
 
+void iwl_init_scan_params(struct iwl_priv *priv)
+{
+	if (!priv->scan_tx_ant[IEEE80211_BAND_5GHZ])
+		priv->scan_tx_ant[IEEE80211_BAND_5GHZ] = RATE_MCS_ANT_INIT_IND;
+	if (!priv->scan_tx_ant[IEEE80211_BAND_2GHZ])
+		priv->scan_tx_ant[IEEE80211_BAND_2GHZ] = RATE_MCS_ANT_INIT_IND;
+}
+
 int iwl_scan_initiate(struct iwl_priv *priv)
 {
 	if (priv->iw_mode == IEEE80211_IF_TYPE_AP) {
@@ -522,7 +529,7 @@ static u16 iwl_supported_rate_to_ie(u8 *ie, u16 supported_rate,
 
 
 static void iwl_ht_cap_to_ie(const struct ieee80211_supported_band *sband,
-			u8 *pos, int *left)
+			     u8 *pos, int *left)
 {
 	struct ieee80211_ht_cap *ht_cap;
 
@@ -547,10 +554,11 @@ static void iwl_ht_cap_to_ie(const struct ieee80211_supported_band *sband,
 /**
  * iwl_fill_probe_req - fill in all required fields and IE for probe request
  */
+
 static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 				  enum ieee80211_band band,
 				  struct ieee80211_mgmt *frame,
-				  int left, int is_direct)
+				  int left)
 {
 	int len = 0;
 	u8 *pos = NULL;
@@ -558,12 +566,12 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 	const struct ieee80211_supported_band *sband =
 						iwl_get_hw_mode(priv, band);
 
+
 	/* Make sure there is enough space for the probe request,
 	 * two mandatory IEs and the data */
 	left -= 24;
 	if (left < 0)
 		return 0;
-	len += 24;
 
 	frame->frame_control = cpu_to_le16(IEEE80211_STYPE_PROBE_REQ);
 	memcpy(frame->da, iwl_bcast_addr, ETH_ALEN);
@@ -571,38 +579,25 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 	memcpy(frame->bssid, iwl_bcast_addr, ETH_ALEN);
 	frame->seq_ctrl = 0;
 
-	/* fill in our indirect SSID IE */
+	len += 24;
+
 	/* ...next IE... */
+	pos = &frame->u.probe_req.variable[0];
 
+	/* fill in our indirect SSID IE */
 	left -= 2;
 	if (left < 0)
 		return 0;
-	len += 2;
-	pos = &(frame->u.probe_req.variable[0]);
 	*pos++ = WLAN_EID_SSID;
 	*pos++ = 0;
 
-	/* fill in our direct SSID IE... */
-	if (is_direct) {
-		/* ...next IE... */
-		left -= 2 + priv->essid_len;
-		if (left < 0)
-			return 0;
-		/* ... fill it in... */
-		*pos++ = WLAN_EID_SSID;
-		*pos++ = priv->essid_len;
-		memcpy(pos, priv->essid, priv->essid_len);
-		pos += priv->essid_len;
-		len += 2 + priv->essid_len;
-	}
+	len += 2;
 
 	/* fill in supported rate */
-	/* ...next IE... */
 	left -= 2;
 	if (left < 0)
 		return 0;
 
-	/* ... fill it in... */
 	*pos++ = WLAN_EID_SUPP_RATES;
 	*pos = 0;
 
@@ -614,15 +609,16 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 
 	cck_rates = IWL_CCK_RATES_MASK & active_rates;
 	ret_rates = iwl_supported_rate_to_ie(pos, cck_rates,
-			active_rate_basic, &left);
+					     active_rate_basic, &left);
 	active_rates &= ~ret_rates;
 
 	ret_rates = iwl_supported_rate_to_ie(pos, active_rates,
-				 active_rate_basic, &left);
+					     active_rate_basic, &left);
 	active_rates &= ~ret_rates;
 
 	len += 2 + *pos;
 	pos += (*pos) + 1;
+
 	if (active_rates == 0)
 		goto fill_end;
 
@@ -634,27 +630,46 @@ static u16 iwl_fill_probe_req(struct iwl_priv *priv,
 	/* ... fill it in... */
 	*pos++ = WLAN_EID_EXT_SUPP_RATES;
 	*pos = 0;
-	iwl_supported_rate_to_ie(pos, active_rates,
-				 active_rate_basic, &left);
-	if (*pos > 0)
+	iwl_supported_rate_to_ie(pos, active_rates, active_rate_basic, &left);
+	if (*pos > 0) {
 		len += 2 + *pos;
+		pos += (*pos) + 1;
+	} else {
+		pos--;
+	}
 
  fill_end:
-	/* fill in HT IE */
+
 	left -= 2;
 	if (left < 0)
 		return 0;
 
 	*pos++ = WLAN_EID_HT_CAPABILITY;
 	*pos = 0;
-
 	iwl_ht_cap_to_ie(sband, pos, &left);
-
 	if (*pos > 0)
 		len += 2 + *pos;
+
 	return (u16)len;
 }
 
+static u32 iwl_scan_tx_ant(struct iwl_priv *priv, enum ieee80211_band band)
+{
+	int i, ind;
+
+	ind = priv->scan_tx_ant[band];
+	for (i = 0; i < priv->hw_params.tx_chains_num; i++) {
+		ind = (ind+1) >= priv->hw_params.tx_chains_num ? 0 : ind+1;
+		if (priv->hw_params.valid_tx_ant & (1 << ind)) {
+			priv->scan_tx_ant[band] = ind;
+			break;
+		}
+	}
+
+	return scan_tx_ant[ind];
+}
+
+
 static void iwl_bg_request_scan(struct work_struct *data)
 {
 	struct iwl_priv *priv =
@@ -666,10 +681,12 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	};
 	struct iwl_scan_cmd *scan;
 	struct ieee80211_conf *conf = NULL;
+	int ret = 0;
+	u32 tx_ant;
 	u16 cmd_len;
 	enum ieee80211_band band;
 	u8 direct_mask;
-	int ret = 0;
+	u8 rx_chain = 0x7; /* bitmap: ABC chains */
 
 	conf = ieee80211_get_hw_conf(priv->hw);
 
@@ -761,25 +778,23 @@ static void iwl_bg_request_scan(struct work_struct *data)
 
 	/* We should add the ability for user to lock to PASSIVE ONLY */
 	if (priv->one_direct_scan) {
-		IWL_DEBUG_SCAN
-		    ("Kicking off one direct scan for '%s'\n",
-		     iwl_escape_essid(priv->direct_ssid,
-				      priv->direct_ssid_len));
+		IWL_DEBUG_SCAN("Start direct scan for '%s'\n",
+				iwl_escape_essid(priv->direct_ssid,
+				priv->direct_ssid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->direct_ssid_len;
 		memcpy(scan->direct_scan[0].ssid,
 		       priv->direct_ssid, priv->direct_ssid_len);
 		direct_mask = 1;
 	} else if (!iwl_is_associated(priv) && priv->essid_len) {
-		IWL_DEBUG_SCAN
-		  ("Kicking off one direct scan for '%s' when not associated\n",
-		   iwl_escape_essid(priv->essid, priv->essid_len));
+		IWL_DEBUG_SCAN("Start direct scan for '%s' (not associated)\n",
+				iwl_escape_essid(priv->essid, priv->essid_len));
 		scan->direct_scan[0].id = WLAN_EID_SSID;
 		scan->direct_scan[0].len = priv->essid_len;
 		memcpy(scan->direct_scan[0].ssid, priv->essid, priv->essid_len);
 		direct_mask = 1;
 	} else {
-		IWL_DEBUG_SCAN("Kicking off one indirect scan.\n");
+		IWL_DEBUG_SCAN("Start indirect scan.\n");
 		direct_mask = 0;
 	}
 
@@ -790,64 +805,73 @@ static void iwl_bg_request_scan(struct work_struct *data)
 
 	switch (priv->scan_bands) {
 	case 2:
+		band = IEEE80211_BAND_2GHZ;
 		scan->flags = RXON_FLG_BAND_24G_MSK | RXON_FLG_AUTO_DETECT_MSK;
-		scan->tx_cmd.rate_n_flags =
+		tx_ant = iwl_scan_tx_ant(priv, band);
+		if (priv->active_rxon.flags & RXON_FLG_CHANNEL_MODE_PURE_40_MSK)
+			scan->tx_cmd.rate_n_flags =
+				iwl_hw_set_rate_n_flags(IWL_RATE_6M_PLCP,
+							tx_ant);
+		else
+			scan->tx_cmd.rate_n_flags =
 				iwl_hw_set_rate_n_flags(IWL_RATE_1M_PLCP,
-							RATE_MCS_ANT_B_MSK|
+							tx_ant |
 							RATE_MCS_CCK_MSK);
-
 		scan->good_CRC_th = 0;
-		band = IEEE80211_BAND_2GHZ;
 		break;
 
 	case 1:
+		band = IEEE80211_BAND_5GHZ;
+		tx_ant = iwl_scan_tx_ant(priv, band);
 		scan->tx_cmd.rate_n_flags =
 				iwl_hw_set_rate_n_flags(IWL_RATE_6M_PLCP,
-							RATE_MCS_ANT_B_MSK);
+							tx_ant);
 		scan->good_CRC_th = IWL_GOOD_CRC_TH;
-		band = IEEE80211_BAND_5GHZ;
-		break;
 
+		/* Force use of chains B and C (0x6) for scan Rx for 4965
+		 * Avoid A (0x1) because of its off-channel reception on A-band.
+		 * MIMO is not used here, but value is required */
+		if ((priv->hw_rev & CSR_HW_REV_TYPE_MSK) == CSR_HW_REV_TYPE_4965)
+			rx_chain = 0x6;
+
+		break;
 	default:
 		IWL_WARNING("Invalid scan band count\n");
 		goto done;
 	}
 
-	/* We don't build a direct scan probe request; the uCode will do
-	 * that based on the direct_mask added to each channel entry */
+	scan->rx_chain = RXON_RX_CHAIN_DRIVER_FORCE_MSK |
+				cpu_to_le16((0x7 << RXON_RX_CHAIN_VALID_POS) |
+				(rx_chain << RXON_RX_CHAIN_FORCE_SEL_POS) |
+				(0x7 << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS));
+
 	cmd_len = iwl_fill_probe_req(priv, band,
-					(struct ieee80211_mgmt *)scan->data,
-					IWL_MAX_SCAN_SIZE - sizeof(*scan), 0);
+				     (struct ieee80211_mgmt *)scan->data,
+				     IWL_MAX_SCAN_SIZE - sizeof(*scan));
 
 	scan->tx_cmd.len = cpu_to_le16(cmd_len);
-	/* select Rx chains */
-
-	/* Force use of chains B and C (0x6) for scan Rx.
-	 * Avoid A (0x1) because of its off-channel reception on A-band.
-	 * MIMO is not used here, but value is required to make uCode happy. */
-	scan->rx_chain = RXON_RX_CHAIN_DRIVER_FORCE_MSK |
-			cpu_to_le16((0x7 << RXON_RX_CHAIN_VALID_POS) |
-			(0x6 << RXON_RX_CHAIN_FORCE_SEL_POS) |
-			(0x7 << RXON_RX_CHAIN_FORCE_MIMO_SEL_POS));
 
 	if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR)
 		scan->filter_flags = RXON_FILTER_PROMISC_MSK;
 
+	scan->filter_flags |= (RXON_FILTER_ACCEPT_GRP_MSK |
+			       RXON_FILTER_BCON_AWARE_MSK);
+
 	if (direct_mask)
 		scan->channel_count =
-			iwl_get_channels_for_scan(
-				priv, band, 1, /* active */
-				direct_mask,
+			iwl_get_channels_for_scan(priv, band, 1, /* active */
+						  direct_mask,
 				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
 	else
 		scan->channel_count =
-			iwl_get_channels_for_scan(
-				priv, band, 0, /* passive */
-				direct_mask,
+			iwl_get_channels_for_scan(priv, band, 0, /* passive */
+						  direct_mask,
 				(void *)&scan->data[le16_to_cpu(scan->tx_cmd.len)]);
+	if (scan->channel_count == 0) {
+		IWL_DEBUG_SCAN("channel count %d\n", scan->channel_count);
+		goto done;
+	}
 
-	scan->filter_flags |= (RXON_FILTER_ACCEPT_GRP_MSK |
-			       RXON_FILTER_BCON_AWARE_MSK);
 	cmd.len += le16_to_cpu(scan->tx_cmd.len) +
 	    scan->channel_count * sizeof(struct iwl_scan_channel);
 	cmd.data = scan;
-- 
1.5.3.6

