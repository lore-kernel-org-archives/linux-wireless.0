Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:9523 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758706Ab0GWQN4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 12:13:56 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/10] iwlagn: Add support for bluetooth statistics notification
Date: Fri, 23 Jul 2010 09:15:32 -0700
Message-Id: <1279901739-10541-4-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

WiFi/BT combo devices has different statistics notification
structure, adding the support here to make sure the structure
align correctly.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c   |   64 +++++++---
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |  134 +++++++++++++------
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c      |  167 +++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   14 ++-
 drivers/net/wireless/iwlwifi/iwl-calib.h       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-dev.h         |    4 +
 7 files changed, 271 insertions(+), 119 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 90033e8..c4c5691 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -605,8 +605,7 @@ void iwl_init_sensitivity(struct iwl_priv *priv)
 	IWL_DEBUG_CALIB(priv, "<<return 0x%X\n", ret);
 }
 
-void iwl_sensitivity_calibration(struct iwl_priv *priv,
-				    struct iwl_notif_statistics *resp)
+void iwl_sensitivity_calibration(struct iwl_priv *priv, void *resp)
 {
 	u32 rx_enable_time;
 	u32 fa_cck;
@@ -616,8 +615,8 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv,
 	u32 norm_fa_ofdm;
 	u32 norm_fa_cck;
 	struct iwl_sensitivity_data *data = NULL;
-	struct statistics_rx_non_phy *rx_info = &(resp->rx.general);
-	struct statistics_rx *statistics = &(resp->rx);
+	struct statistics_rx_non_phy *rx_info;
+	struct statistics_rx_phy *ofdm, *cck;
 	unsigned long flags;
 	struct statistics_general_data statis;
 
@@ -632,6 +631,16 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv,
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
+	if (priv->cfg->bt_statistics) {
+		rx_info = &(((struct iwl_bt_notif_statistics *)resp)->
+			      rx.general.common);
+		ofdm = &(((struct iwl_bt_notif_statistics *)resp)->rx.ofdm);
+		cck = &(((struct iwl_bt_notif_statistics *)resp)->rx.cck);
+	} else {
+		rx_info = &(((struct iwl_notif_statistics *)resp)->rx.general);
+		ofdm = &(((struct iwl_notif_statistics *)resp)->rx.ofdm);
+		cck = &(((struct iwl_notif_statistics *)resp)->rx.cck);
+	}
 	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
 		IWL_DEBUG_CALIB(priv, "<< invalid data.\n");
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -640,23 +649,23 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv,
 
 	/* Extract Statistics: */
 	rx_enable_time = le32_to_cpu(rx_info->channel_load);
-	fa_cck = le32_to_cpu(statistics->cck.false_alarm_cnt);
-	fa_ofdm = le32_to_cpu(statistics->ofdm.false_alarm_cnt);
-	bad_plcp_cck = le32_to_cpu(statistics->cck.plcp_err);
-	bad_plcp_ofdm = le32_to_cpu(statistics->ofdm.plcp_err);
+	fa_cck = le32_to_cpu(cck->false_alarm_cnt);
+	fa_ofdm = le32_to_cpu(ofdm->false_alarm_cnt);
+	bad_plcp_cck = le32_to_cpu(cck->plcp_err);
+	bad_plcp_ofdm = le32_to_cpu(ofdm->plcp_err);
 
 	statis.beacon_silence_rssi_a =
-			le32_to_cpu(statistics->general.beacon_silence_rssi_a);
+			le32_to_cpu(rx_info->beacon_silence_rssi_a);
 	statis.beacon_silence_rssi_b =
-			le32_to_cpu(statistics->general.beacon_silence_rssi_b);
+			le32_to_cpu(rx_info->beacon_silence_rssi_b);
 	statis.beacon_silence_rssi_c =
-			le32_to_cpu(statistics->general.beacon_silence_rssi_c);
+			le32_to_cpu(rx_info->beacon_silence_rssi_c);
 	statis.beacon_energy_a =
-			le32_to_cpu(statistics->general.beacon_energy_a);
+			le32_to_cpu(rx_info->beacon_energy_a);
 	statis.beacon_energy_b =
-			le32_to_cpu(statistics->general.beacon_energy_b);
+			le32_to_cpu(rx_info->beacon_energy_b);
 	statis.beacon_energy_c =
-			le32_to_cpu(statistics->general.beacon_energy_c);
+			le32_to_cpu(rx_info->beacon_energy_c);
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -728,8 +737,7 @@ static inline u8 find_first_chain(u8 mask)
  * 1)  Which antennas are connected.
  * 2)  Differential rx gain settings to balance the 3 receivers.
  */
-void iwl_chain_noise_calibration(struct iwl_priv *priv,
-				 struct iwl_notif_statistics *stat_resp)
+void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 {
 	struct iwl_chain_noise_data *data = NULL;
 
@@ -753,7 +761,7 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 	u32 active_chains = 0;
 	u8 num_tx_chains;
 	unsigned long flags;
-	struct statistics_rx_non_phy *rx_info = &(stat_resp->rx.general);
+	struct statistics_rx_non_phy *rx_info;
 	u8 first_chain;
 
 	if (priv->disable_chain_noise_cal)
@@ -772,6 +780,13 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
+	if (priv->cfg->bt_statistics) {
+		rx_info = &(((struct iwl_bt_notif_statistics *)stat_resp)->
+			      rx.general.common);
+	} else {
+		rx_info = &(((struct iwl_notif_statistics *)stat_resp)->
+			      rx.general);
+	}
 	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
 		IWL_DEBUG_CALIB(priv, " << Interference data unavailable\n");
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -780,8 +795,19 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv,
 
 	rxon_band24 = !!(priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK);
 	rxon_chnum = le16_to_cpu(priv->staging_rxon.channel);
-	stat_band24 = !!(stat_resp->flag & STATISTICS_REPLY_FLG_BAND_24G_MSK);
-	stat_chnum = le32_to_cpu(stat_resp->flag) >> 16;
+	if (priv->cfg->bt_statistics) {
+		stat_band24 = !!(((struct iwl_bt_notif_statistics *)
+				 stat_resp)->flag &
+				 STATISTICS_REPLY_FLG_BAND_24G_MSK);
+		stat_chnum = le32_to_cpu(((struct iwl_bt_notif_statistics *)
+					 stat_resp)->flag) >> 16;
+	} else {
+		stat_band24 = !!(((struct iwl_notif_statistics *)
+				 stat_resp)->flag &
+				 STATISTICS_REPLY_FLG_BAND_24G_MSK);
+		stat_chnum = le32_to_cpu(((struct iwl_notif_statistics *)
+					 stat_resp)->flag) >> 16;
+	}
 
 	/* Make sure we accumulate data for just the associated channel
 	 *   (even if scanning). */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index 11dd1f7..19d1e5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -31,21 +31,24 @@
 static int iwl_statistics_flag(struct iwl_priv *priv, char *buf, int bufsz)
 {
 	int p = 0;
+	u32 flag;
 
-	p += scnprintf(buf + p, bufsz - p, "Statistics Flag(0x%X):\n",
-		       le32_to_cpu(priv->_agn.statistics.flag));
-	if (le32_to_cpu(priv->_agn.statistics.flag) &
-			UCODE_STATISTICS_CLEAR_MSK)
+	if (priv->cfg->bt_statistics)
+		flag = le32_to_cpu(priv->_agn.statistics_bt.flag);
+	else
+		flag = le32_to_cpu(priv->_agn.statistics.flag);
+
+	p += scnprintf(buf + p, bufsz - p, "Statistics Flag(0x%X):\n", flag);
+	if (flag & UCODE_STATISTICS_CLEAR_MSK)
 		p += scnprintf(buf + p, bufsz - p,
-			       "\tStatistics have been cleared\n");
+		"\tStatistics have been cleared\n");
 	p += scnprintf(buf + p, bufsz - p, "\tOperational Frequency: %s\n",
-		       (le32_to_cpu(priv->_agn.statistics.flag) &
-			UCODE_STATISTICS_FREQUENCY_MSK)
-			? "2.4 GHz" : "5.2 GHz");
+		(flag & UCODE_STATISTICS_FREQUENCY_MSK)
+		? "2.4 GHz" : "5.2 GHz");
 	p += scnprintf(buf + p, bufsz - p, "\tTGj Narrow Band: %s\n",
-		       (le32_to_cpu(priv->_agn.statistics.flag) &
-			UCODE_STATISTICS_NARROW_BAND_MSK)
-			? "enabled" : "disabled");
+		(flag & UCODE_STATISTICS_NARROW_BAND_MSK)
+		 ? "enabled" : "disabled");
+
 	return p;
 }
 
@@ -79,22 +82,43 @@ ssize_t iwl_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 	 * the last statistics notification from uCode
 	 * might not reflect the current uCode activity
 	 */
-	ofdm = &priv->_agn.statistics.rx.ofdm;
-	cck = &priv->_agn.statistics.rx.cck;
-	general = &priv->_agn.statistics.rx.general;
-	ht = &priv->_agn.statistics.rx.ofdm_ht;
-	accum_ofdm = &priv->_agn.accum_statistics.rx.ofdm;
-	accum_cck = &priv->_agn.accum_statistics.rx.cck;
-	accum_general = &priv->_agn.accum_statistics.rx.general;
-	accum_ht = &priv->_agn.accum_statistics.rx.ofdm_ht;
-	delta_ofdm = &priv->_agn.delta_statistics.rx.ofdm;
-	delta_cck = &priv->_agn.delta_statistics.rx.cck;
-	delta_general = &priv->_agn.delta_statistics.rx.general;
-	delta_ht = &priv->_agn.delta_statistics.rx.ofdm_ht;
-	max_ofdm = &priv->_agn.max_delta.rx.ofdm;
-	max_cck = &priv->_agn.max_delta.rx.cck;
-	max_general = &priv->_agn.max_delta.rx.general;
-	max_ht = &priv->_agn.max_delta.rx.ofdm_ht;
+	if (priv->cfg->bt_statistics) {
+		ofdm = &priv->_agn.statistics_bt.rx.ofdm;
+		cck = &priv->_agn.statistics_bt.rx.cck;
+		general = &priv->_agn.statistics_bt.rx.general.common;
+		ht = &priv->_agn.statistics_bt.rx.ofdm_ht;
+		accum_ofdm = &priv->_agn.accum_statistics_bt.rx.ofdm;
+		accum_cck = &priv->_agn.accum_statistics_bt.rx.cck;
+		accum_general =
+			&priv->_agn.accum_statistics_bt.rx.general.common;
+		accum_ht = &priv->_agn.accum_statistics_bt.rx.ofdm_ht;
+		delta_ofdm = &priv->_agn.delta_statistics_bt.rx.ofdm;
+		delta_cck = &priv->_agn.delta_statistics_bt.rx.cck;
+		delta_general =
+			&priv->_agn.delta_statistics_bt.rx.general.common;
+		delta_ht = &priv->_agn.delta_statistics_bt.rx.ofdm_ht;
+		max_ofdm = &priv->_agn.max_delta_bt.rx.ofdm;
+		max_cck = &priv->_agn.max_delta_bt.rx.cck;
+		max_general = &priv->_agn.max_delta_bt.rx.general.common;
+		max_ht = &priv->_agn.max_delta_bt.rx.ofdm_ht;
+	} else {
+		ofdm = &priv->_agn.statistics.rx.ofdm;
+		cck = &priv->_agn.statistics.rx.cck;
+		general = &priv->_agn.statistics.rx.general;
+		ht = &priv->_agn.statistics.rx.ofdm_ht;
+		accum_ofdm = &priv->_agn.accum_statistics.rx.ofdm;
+		accum_cck = &priv->_agn.accum_statistics.rx.cck;
+		accum_general = &priv->_agn.accum_statistics.rx.general;
+		accum_ht = &priv->_agn.accum_statistics.rx.ofdm_ht;
+		delta_ofdm = &priv->_agn.delta_statistics.rx.ofdm;
+		delta_cck = &priv->_agn.delta_statistics.rx.cck;
+		delta_general = &priv->_agn.delta_statistics.rx.general;
+		delta_ht = &priv->_agn.delta_statistics.rx.ofdm_ht;
+		max_ofdm = &priv->_agn.max_delta.rx.ofdm;
+		max_cck = &priv->_agn.max_delta.rx.cck;
+		max_general = &priv->_agn.max_delta.rx.general;
+		max_ht = &priv->_agn.max_delta.rx.ofdm_ht;
+	}
 
 	pos += iwl_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
@@ -560,10 +584,18 @@ ssize_t iwl_ucode_tx_stats_read(struct file *file,
 	  * the last statistics notification from uCode
 	  * might not reflect the current uCode activity
 	  */
-	tx = &priv->_agn.statistics.tx;
-	accum_tx = &priv->_agn.accum_statistics.tx;
-	delta_tx = &priv->_agn.delta_statistics.tx;
-	max_tx = &priv->_agn.max_delta.tx;
+	if (priv->cfg->bt_statistics) {
+		tx = &priv->_agn.statistics_bt.tx;
+		accum_tx = &priv->_agn.accum_statistics_bt.tx;
+		delta_tx = &priv->_agn.delta_statistics_bt.tx;
+		max_tx = &priv->_agn.max_delta_bt.tx;
+	} else {
+		tx = &priv->_agn.statistics.tx;
+		accum_tx = &priv->_agn.accum_statistics.tx;
+		delta_tx = &priv->_agn.delta_statistics.tx;
+		max_tx = &priv->_agn.max_delta.tx;
+	}
+
 	pos += iwl_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos,  "%-32s     current"
 			 "acumulative       delta         max\n",
@@ -777,18 +809,34 @@ ssize_t iwl_ucode_general_stats_read(struct file *file, char __user *user_buf,
 	  * the last statistics notification from uCode
 	  * might not reflect the current uCode activity
 	  */
-	general = &priv->_agn.statistics.general.common;
-	dbg = &priv->_agn.statistics.general.common.dbg;
-	div = &priv->_agn.statistics.general.common.div;
-	accum_general = &priv->_agn.accum_statistics.general.common;
-	delta_general = &priv->_agn.delta_statistics.general.common;
-	max_general = &priv->_agn.max_delta.general.common;
-	accum_dbg = &priv->_agn.accum_statistics.general.common.dbg;
-	delta_dbg = &priv->_agn.delta_statistics.general.common.dbg;
-	max_dbg = &priv->_agn.max_delta.general.common.dbg;
-	accum_div = &priv->_agn.accum_statistics.general.common.div;
-	delta_div = &priv->_agn.delta_statistics.general.common.div;
-	max_div = &priv->_agn.max_delta.general.common.div;
+	if (priv->cfg->bt_statistics) {
+		general = &priv->_agn.statistics_bt.general.common;
+		dbg = &priv->_agn.statistics_bt.general.common.dbg;
+		div = &priv->_agn.statistics_bt.general.common.div;
+		accum_general = &priv->_agn.accum_statistics_bt.general.common;
+		accum_dbg = &priv->_agn.accum_statistics_bt.general.common.dbg;
+		accum_div = &priv->_agn.accum_statistics_bt.general.common.div;
+		delta_general = &priv->_agn.delta_statistics_bt.general.common;
+		max_general = &priv->_agn.max_delta_bt.general.common;
+		delta_dbg = &priv->_agn.delta_statistics_bt.general.common.dbg;
+		max_dbg = &priv->_agn.max_delta_bt.general.common.dbg;
+		delta_div = &priv->_agn.delta_statistics_bt.general.common.div;
+		max_div = &priv->_agn.max_delta_bt.general.common.div;
+	} else {
+		general = &priv->_agn.statistics.general.common;
+		dbg = &priv->_agn.statistics.general.common.dbg;
+		div = &priv->_agn.statistics.general.common.div;
+		accum_general = &priv->_agn.accum_statistics.general.common;
+		accum_dbg = &priv->_agn.accum_statistics.general.common.dbg;
+		accum_div = &priv->_agn.accum_statistics.general.common.div;
+		delta_general = &priv->_agn.delta_statistics.general.common;
+		max_general = &priv->_agn.max_delta.general.common;
+		delta_dbg = &priv->_agn.delta_statistics.general.common.dbg;
+		max_dbg = &priv->_agn.max_delta.general.common.dbg;
+		delta_div = &priv->_agn.delta_statistics.general.common.div;
+		max_div = &priv->_agn.max_delta.general.common.div;
+	}
+
 	pos += iwl_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
 			 "acumulative       delta         max\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index 249b77b..9490ece 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -67,17 +67,22 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
  *   exactly when to expect beacons, therefore only when we're associated. */
 static void iwl_rx_calc_noise(struct iwl_priv *priv)
 {
-	struct statistics_rx_non_phy *rx_info
-				= &(priv->_agn.statistics.rx.general);
+	struct statistics_rx_non_phy *rx_info;
 	int num_active_rx = 0;
 	int total_silence = 0;
-	int bcn_silence_a =
+	int bcn_silence_a, bcn_silence_b, bcn_silence_c;
+	int last_rx_noise;
+
+	if (priv->cfg->bt_statistics)
+		rx_info = &(priv->_agn.statistics_bt.rx.general.common);
+	else
+		rx_info = &(priv->_agn.statistics.rx.general);
+	bcn_silence_a =
 		le32_to_cpu(rx_info->beacon_silence_rssi_a) & IN_BAND_FILTER;
-	int bcn_silence_b =
+	bcn_silence_b =
 		le32_to_cpu(rx_info->beacon_silence_rssi_b) & IN_BAND_FILTER;
-	int bcn_silence_c =
+	bcn_silence_c =
 		le32_to_cpu(rx_info->beacon_silence_rssi_c) & IN_BAND_FILTER;
-	int last_rx_noise;
 
 	if (bcn_silence_a) {
 		total_silence += bcn_silence_a;
@@ -112,17 +117,35 @@ static void iwl_rx_calc_noise(struct iwl_priv *priv)
 static void iwl_accumulative_statistics(struct iwl_priv *priv,
 					__le32 *stats)
 {
-	int i;
+	int i, size;
 	__le32 *prev_stats;
 	u32 *accum_stats;
 	u32 *delta, *max_delta;
+	struct statistics_general_common *general, *accum_general;
+	struct statistics_tx *tx, *accum_tx;
 
-	prev_stats = (__le32 *)&priv->_agn.statistics;
-	accum_stats = (u32 *)&priv->_agn.accum_statistics;
-	delta = (u32 *)&priv->_agn.delta_statistics;
-	max_delta = (u32 *)&priv->_agn.max_delta;
-
-	for (i = sizeof(__le32); i < sizeof(struct iwl_notif_statistics);
+	if (priv->cfg->bt_statistics) {
+		prev_stats = (__le32 *)&priv->_agn.statistics_bt;
+		accum_stats = (u32 *)&priv->_agn.accum_statistics_bt;
+		size = sizeof(struct iwl_bt_notif_statistics);
+		general = &priv->_agn.statistics_bt.general.common;
+		accum_general = &priv->_agn.accum_statistics_bt.general.common;
+		tx = &priv->_agn.statistics_bt.tx;
+		accum_tx = &priv->_agn.accum_statistics_bt.tx;
+		delta = (u32 *)&priv->_agn.delta_statistics_bt;
+		max_delta = (u32 *)&priv->_agn.max_delta_bt;
+	} else {
+		prev_stats = (__le32 *)&priv->_agn.statistics;
+		accum_stats = (u32 *)&priv->_agn.accum_statistics;
+		size = sizeof(struct iwl_notif_statistics);
+		general = &priv->_agn.statistics.general.common;
+		accum_general = &priv->_agn.accum_statistics.general.common;
+		tx = &priv->_agn.statistics.tx;
+		accum_tx = &priv->_agn.accum_statistics.tx;
+		delta = (u32 *)&priv->_agn.delta_statistics;
+		max_delta = (u32 *)&priv->_agn.max_delta;
+	}
+	for (i = sizeof(__le32); i < size;
 	     i += sizeof(__le32), stats++, prev_stats++, delta++,
 	     max_delta++, accum_stats++) {
 		if (le32_to_cpu(*stats) > le32_to_cpu(*prev_stats)) {
@@ -135,18 +158,12 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 	}
 
 	/* reset accumulative statistics for "no-counter" type statistics */
-	priv->_agn.accum_statistics.general.common.temperature =
-		priv->_agn.statistics.general.common.temperature;
-	priv->_agn.accum_statistics.general.common.temperature_m =
-		priv->_agn.statistics.general.common.temperature_m;
-	priv->_agn.accum_statistics.general.common.ttl_timestamp =
-		priv->_agn.statistics.general.common.ttl_timestamp;
-	priv->_agn.accum_statistics.tx.tx_power.ant_a =
-		priv->_agn.statistics.tx.tx_power.ant_a;
-	priv->_agn.accum_statistics.tx.tx_power.ant_b =
-		priv->_agn.statistics.tx.tx_power.ant_b;
-	priv->_agn.accum_statistics.tx.tx_power.ant_c =
-		priv->_agn.statistics.tx.tx_power.ant_c;
+	accum_general->temperature = general->temperature;
+	accum_general->temperature_m = general->temperature_m;
+	accum_general->ttl_timestamp = general->ttl_timestamp;
+	accum_tx->tx_power.ant_a = tx->tx_power.ant_a;
+	accum_tx->tx_power.ant_b = tx->tx_power.ant_b;
+	accum_tx->tx_power.ant_c = tx->tx_power.ant_c;
 }
 #endif
 
@@ -185,11 +202,30 @@ bool iwl_good_plcp_health(struct iwl_priv *priv,
 	 * by zero.
 	 */
 	if (plcp_msec) {
-		combined_plcp_delta =
-			(le32_to_cpu(pkt->u.stats.rx.ofdm.plcp_err) -
-			le32_to_cpu(priv->_agn.statistics.rx.ofdm.plcp_err)) +
-			(le32_to_cpu(pkt->u.stats.rx.ofdm_ht.plcp_err) -
-			le32_to_cpu(priv->_agn.statistics.rx.ofdm_ht.plcp_err));
+		struct statistics_rx_phy *ofdm;
+		struct statistics_rx_ht_phy *ofdm_ht;
+
+		if (priv->cfg->bt_statistics) {
+			ofdm = &pkt->u.stats_bt.rx.ofdm;
+			ofdm_ht = &pkt->u.stats_bt.rx.ofdm_ht;
+			combined_plcp_delta =
+			   (le32_to_cpu(ofdm->plcp_err) -
+			   le32_to_cpu(priv->_agn.statistics_bt.
+				       rx.ofdm.plcp_err)) +
+			   (le32_to_cpu(ofdm_ht->plcp_err) -
+			   le32_to_cpu(priv->_agn.statistics_bt.
+				       rx.ofdm_ht.plcp_err));
+		} else {
+			ofdm = &pkt->u.stats.rx.ofdm;
+			ofdm_ht = &pkt->u.stats.rx.ofdm_ht;
+			combined_plcp_delta =
+			    (le32_to_cpu(ofdm->plcp_err) -
+			    le32_to_cpu(priv->_agn.statistics.
+					rx.ofdm.plcp_err)) +
+			    (le32_to_cpu(ofdm_ht->plcp_err) -
+			    le32_to_cpu(priv->_agn.statistics.
+					rx.ofdm_ht.plcp_err));
+		}
 
 		if ((combined_plcp_delta > 0) &&
 		    ((combined_plcp_delta * 100) / plcp_msec) >
@@ -206,15 +242,14 @@ bool iwl_good_plcp_health(struct iwl_priv *priv,
 			 *    plcp_msec
 			 */
 			IWL_DEBUG_RADIO(priv, "plcp_err exceeded %u, "
-				"%u, %u, %u, %u, %d, %u mSecs\n",
-				priv->cfg->plcp_delta_threshold,
-				le32_to_cpu(pkt->u.stats.rx.ofdm.plcp_err),
-				le32_to_cpu(
-				       priv->_agn.statistics.rx.ofdm.plcp_err),
-				le32_to_cpu(pkt->u.stats.rx.ofdm_ht.plcp_err),
-				le32_to_cpu(
-				  priv->_agn.statistics.rx.ofdm_ht.plcp_err),
-				combined_plcp_delta, plcp_msec);
+				    "%u, %u, %u, %u, %d, %u mSecs\n",
+				    priv->cfg->plcp_delta_threshold,
+				    le32_to_cpu(ofdm->plcp_err),
+				    le32_to_cpu(ofdm->plcp_err),
+				    le32_to_cpu(ofdm_ht->plcp_err),
+				    le32_to_cpu(ofdm_ht->plcp_err),
+				    combined_plcp_delta, plcp_msec);
+
 			rc = false;
 		}
 	}
@@ -227,24 +262,50 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 	int change;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 
+	if (priv->cfg->bt_statistics) {
+		IWL_DEBUG_RX(priv,
+			     "Statistics notification received (%d vs %d).\n",
+			     (int)sizeof(struct iwl_bt_notif_statistics),
+			     le32_to_cpu(pkt->len_n_flags) &
+			     FH_RSCSR_FRAME_SIZE_MSK);
 
-	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
-		     (int)sizeof(priv->_agn.statistics),
-		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
+		change = ((priv->_agn.statistics_bt.general.common.temperature !=
+			   pkt->u.stats_bt.general.common.temperature) ||
+			   ((priv->_agn.statistics_bt.flag &
+			   STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
+			   (pkt->u.stats_bt.flag &
+			   STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+		iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats_bt);
+#endif
 
-	change = ((priv->_agn.statistics.general.common.temperature !=
-		   pkt->u.stats.general.common.temperature) ||
-		  ((priv->_agn.statistics.flag &
-		    STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
-		   (pkt->u.stats.flag & STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
+	} else {
+		IWL_DEBUG_RX(priv,
+			     "Statistics notification received (%d vs %d).\n",
+			     (int)sizeof(struct iwl_notif_statistics),
+			     le32_to_cpu(pkt->len_n_flags) &
+			     FH_RSCSR_FRAME_SIZE_MSK);
 
+		change = ((priv->_agn.statistics.general.common.temperature !=
+			   pkt->u.stats.general.common.temperature) ||
+			   ((priv->_agn.statistics.flag &
+			   STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
+			   (pkt->u.stats.flag &
+			   STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
+		iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
 #endif
+
+	}
+
 	iwl_recover_from_statistics(priv, pkt);
 
-	memcpy(&priv->_agn.statistics, &pkt->u.stats,
-	       sizeof(priv->_agn.statistics));
+	if (priv->cfg->bt_statistics)
+		memcpy(&priv->_agn.statistics_bt, &pkt->u.stats_bt,
+			sizeof(priv->_agn.statistics_bt));
+	else
+		memcpy(&priv->_agn.statistics, &pkt->u.stats,
+			sizeof(priv->_agn.statistics));
 
 	set_bit(STATUS_STATISTICS, &priv->status);
 
@@ -277,6 +338,12 @@ void iwl_reply_statistics(struct iwl_priv *priv,
 			sizeof(struct iwl_notif_statistics));
 		memset(&priv->_agn.max_delta, 0,
 			sizeof(struct iwl_notif_statistics));
+		memset(&priv->_agn.accum_statistics_bt, 0,
+			sizeof(struct iwl_bt_notif_statistics));
+		memset(&priv->_agn.delta_statistics_bt, 0,
+			sizeof(struct iwl_bt_notif_statistics));
+		memset(&priv->_agn.max_delta_bt, 0,
+			sizeof(struct iwl_bt_notif_statistics));
 #endif
 		IWL_DEBUG_RX(priv, "Statistics have been cleared\n");
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7391c63..33a8f13 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3008,9 +3008,17 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 	}
 
 	if (priv->start_calib) {
-		iwl_chain_noise_calibration(priv, &priv->_agn.statistics);
-
-		iwl_sensitivity_calibration(priv, &priv->_agn.statistics);
+		if (priv->cfg->bt_statistics) {
+			iwl_chain_noise_calibration(priv,
+					(void *)&priv->_agn.statistics_bt);
+			iwl_sensitivity_calibration(priv,
+					(void *)&priv->_agn.statistics_bt);
+		} else {
+			iwl_chain_noise_calibration(priv,
+					(void *)&priv->_agn.statistics);
+			iwl_sensitivity_calibration(priv,
+					(void *)&priv->_agn.statistics);
+		}
 	}
 
 	mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.h b/drivers/net/wireless/iwlwifi/iwl-calib.h
index 2b7b1df..ba9523f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.h
@@ -66,10 +66,8 @@
 #include "iwl-core.h"
 #include "iwl-commands.h"
 
-void iwl_chain_noise_calibration(struct iwl_priv *priv,
-				struct iwl_notif_statistics *stat_resp);
-void iwl_sensitivity_calibration(struct iwl_priv *priv,
-				struct iwl_notif_statistics *resp);
+void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp);
+void iwl_sensitivity_calibration(struct iwl_priv *priv, void *resp);
 
 void iwl_init_sensitivity(struct iwl_priv *priv);
 void iwl_reset_run_time_calib(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 4be9063..04b2e29 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3988,6 +3988,7 @@ struct iwl_rx_packet {
 		struct iwl_sleep_notification sleep_notif;
 		struct iwl_spectrum_resp spectrum;
 		struct iwl_notif_statistics stats;
+		struct iwl_bt_notif_statistics stats_bt;
 		struct iwl_compressed_ba_resp compressed_ba;
 		struct iwl_missed_beacon_notif missed_beacon;
 		struct iwl_coex_medium_notification coex_medium_notif;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index dff1b17..297f8d1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1322,10 +1322,14 @@ struct iwl_priv {
 			u32 inst_evtlog_ptr, inst_evtlog_size, inst_errlog_ptr;
 
 			struct iwl_notif_statistics statistics;
+			struct iwl_bt_notif_statistics statistics_bt;
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 			struct iwl_notif_statistics accum_statistics;
 			struct iwl_notif_statistics delta_statistics;
 			struct iwl_notif_statistics max_delta;
+			struct iwl_bt_notif_statistics accum_statistics_bt;
+			struct iwl_bt_notif_statistics delta_statistics_bt;
+			struct iwl_bt_notif_statistics max_delta_bt;
 #endif
 		} _agn;
 #endif
-- 
1.7.0.4

