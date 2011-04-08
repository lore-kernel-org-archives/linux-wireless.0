Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:56990 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423Ab1DHPuP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:50:15 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 15/16] iwlagn: clean up & autodetect statistics
Date: Fri,  8 Apr 2011 08:30:35 -0700
Message-Id: <1302276636-12802-16-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to keep both normal and BT statistics
versions around all the time in memory when we only
use a subset of both. So keep only the subsets that
we need in memory, depending on the debug config).

Also, in doing so, we can remove all the calls to
iwl_bt_statistics() in the driver as we'll just
access the copied statistics now.

Finally, also remove this call from the one place
where it might still be needed and automatically
detect what kind of statistics the device is sending
based on their size. This way, we don't need to keep
track of which devices do what any more, which is
good since this is subject to change based on the
ucode version (as some ucode even for non-BT devices
will in fact use BT statistics).

Warn upon encountering a statistics command from the
ucode that isn't known, so we will find such issues
earlier in the future.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Tested-by: Don Fry <donald.h.fry@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-2000.c        |    1 -
 drivers/net/wireless/iwlwifi/iwl-5000.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c        |    1 -
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c   |   43 +---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.h   |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |  134 ++++-------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c         |   17 +--
 drivers/net/wireless/iwlwifi/iwl-commands.h    |   64 -----
 drivers/net/wireless/iwlwifi/iwl-core.h        |    7 -
 drivers/net/wireless/iwlwifi/iwl-debugfs.c     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h         |   41 +++--
 drivers/net/wireless/iwlwifi/iwl-rx.c          |  298 ++++++++++++-----------
 13 files changed, 243 insertions(+), 376 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 805b039..a31314f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -383,7 +383,6 @@ static struct iwl_ht_params iwl2000_ht_params = {
 };
 
 static struct iwl_bt_params iwl2030_bt_params = {
-	.bt_statistics = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.advanced_bt_coexist = true,
 	.agg_time_limit = BT_AGG_THRESHOLD_DEF,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 357137f..7c28666 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -259,7 +259,7 @@ static void iwl5150_temperature(struct iwl_priv *priv)
 	u32 vt = 0;
 	s32 offset =  iwl_temp_calib_to_offset(priv);
 
-	vt = le32_to_cpu(priv->_agn.statistics.general.common.temperature);
+	vt = le32_to_cpu(priv->statistics.common.temperature);
 	vt = vt / IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF + offset;
 	/* now vt hold the temperature in Kelvin */
 	priv->temperature = KELVIN_TO_CELSIUS(vt);
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 8847b21..0649813 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -489,7 +489,6 @@ static struct iwl_ht_params iwl6000_ht_params = {
 };
 
 static struct iwl_bt_params iwl6000_bt_params = {
-	.bt_statistics = true,
 	/* Due to bluetooth, we transmit 2.4 GHz probes only on antenna A */
 	.advanced_bt_coexist = true,
 	.agg_time_limit = BT_AGG_THRESHOLD_DEF,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 7b761de..0f6bb9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -605,7 +605,7 @@ void iwl_init_sensitivity(struct iwl_priv *priv)
 	IWL_DEBUG_CALIB(priv, "<<return 0x%X\n", ret);
 }
 
-void iwl_sensitivity_calibration(struct iwl_priv *priv, void *resp)
+void iwl_sensitivity_calibration(struct iwl_priv *priv)
 {
 	u32 rx_enable_time;
 	u32 fa_cck;
@@ -631,16 +631,9 @@ void iwl_sensitivity_calibration(struct iwl_priv *priv, void *resp)
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (iwl_bt_statistics(priv)) {
-		rx_info = &(((struct iwl_bt_notif_statistics *)resp)->
-			      rx.general.common);
-		ofdm = &(((struct iwl_bt_notif_statistics *)resp)->rx.ofdm);
-		cck = &(((struct iwl_bt_notif_statistics *)resp)->rx.cck);
-	} else {
-		rx_info = &(((struct iwl_notif_statistics *)resp)->rx.general);
-		ofdm = &(((struct iwl_notif_statistics *)resp)->rx.ofdm);
-		cck = &(((struct iwl_notif_statistics *)resp)->rx.cck);
-	}
+	rx_info = &priv->statistics.rx_non_phy;
+	ofdm = &priv->statistics.rx_ofdm;
+	cck = &priv->statistics.rx_cck;
 	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
 		IWL_DEBUG_CALIB(priv, "<< invalid data.\n");
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -851,7 +844,7 @@ static void iwl_find_disconn_antenna(struct iwl_priv *priv, u32* average_sig,
  * 1)  Which antennas are connected.
  * 2)  Differential rx gain settings to balance the 3 receivers.
  */
-void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
+void iwl_chain_noise_calibration(struct iwl_priv *priv)
 {
 	struct iwl_chain_noise_data *data = NULL;
 
@@ -896,13 +889,9 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	if (iwl_bt_statistics(priv)) {
-		rx_info = &(((struct iwl_bt_notif_statistics *)stat_resp)->
-			      rx.general.common);
-	} else {
-		rx_info = &(((struct iwl_notif_statistics *)stat_resp)->
-			      rx.general);
-	}
+
+	rx_info = &priv->statistics.rx_non_phy;
+
 	if (rx_info->interference_data_flag != INTERFERENCE_DATA_AVAILABLE) {
 		IWL_DEBUG_CALIB(priv, " << Interference data unavailable\n");
 		spin_unlock_irqrestore(&priv->lock, flags);
@@ -911,19 +900,9 @@ void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp)
 
 	rxon_band24 = !!(ctx->staging.flags & RXON_FLG_BAND_24G_MSK);
 	rxon_chnum = le16_to_cpu(ctx->staging.channel);
-	if (iwl_bt_statistics(priv)) {
-		stat_band24 = !!(((struct iwl_bt_notif_statistics *)
-				 stat_resp)->flag &
-				 STATISTICS_REPLY_FLG_BAND_24G_MSK);
-		stat_chnum = le32_to_cpu(((struct iwl_bt_notif_statistics *)
-					 stat_resp)->flag) >> 16;
-	} else {
-		stat_band24 = !!(((struct iwl_notif_statistics *)
-				 stat_resp)->flag &
-				 STATISTICS_REPLY_FLG_BAND_24G_MSK);
-		stat_chnum = le32_to_cpu(((struct iwl_notif_statistics *)
-					 stat_resp)->flag) >> 16;
-	}
+	stat_band24 =
+		!!(priv->statistics.flag & STATISTICS_REPLY_FLG_BAND_24G_MSK);
+	stat_chnum = le32_to_cpu(priv->statistics.flag) >> 16;
 
 	/* Make sure we accumulate data for just the associated channel
 	 *   (even if scanning). */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
index ef4d507..4ef4dd9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.h
@@ -66,8 +66,8 @@
 #include "iwl-core.h"
 #include "iwl-commands.h"
 
-void iwl_chain_noise_calibration(struct iwl_priv *priv, void *stat_resp);
-void iwl_sensitivity_calibration(struct iwl_priv *priv, void *resp);
+void iwl_chain_noise_calibration(struct iwl_priv *priv);
+void iwl_sensitivity_calibration(struct iwl_priv *priv);
 
 void iwl_init_sensitivity(struct iwl_priv *priv);
 void iwl_reset_run_time_calib(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index d1834aa..71a5f31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -39,10 +39,7 @@ static int iwl_statistics_flag(struct iwl_priv *priv, char *buf, int bufsz)
 	int p = 0;
 	u32 flag;
 
-	if (iwl_bt_statistics(priv))
-		flag = le32_to_cpu(priv->_agn.statistics_bt.flag);
-	else
-		flag = le32_to_cpu(priv->_agn.statistics.flag);
+	flag = le32_to_cpu(priv->statistics.flag);
 
 	p += scnprintf(buf + p, bufsz - p, "Statistics Flag(0x%X):\n", flag);
 	if (flag & UCODE_STATISTICS_CLEAR_MSK)
@@ -88,43 +85,22 @@ ssize_t iwl_ucode_rx_stats_read(struct file *file, char __user *user_buf,
 	 * the last statistics notification from uCode
 	 * might not reflect the current uCode activity
 	 */
-	if (iwl_bt_statistics(priv)) {
-		ofdm = &priv->_agn.statistics_bt.rx.ofdm;
-		cck = &priv->_agn.statistics_bt.rx.cck;
-		general = &priv->_agn.statistics_bt.rx.general.common;
-		ht = &priv->_agn.statistics_bt.rx.ofdm_ht;
-		accum_ofdm = &priv->_agn.accum_statistics_bt.rx.ofdm;
-		accum_cck = &priv->_agn.accum_statistics_bt.rx.cck;
-		accum_general =
-			&priv->_agn.accum_statistics_bt.rx.general.common;
-		accum_ht = &priv->_agn.accum_statistics_bt.rx.ofdm_ht;
-		delta_ofdm = &priv->_agn.delta_statistics_bt.rx.ofdm;
-		delta_cck = &priv->_agn.delta_statistics_bt.rx.cck;
-		delta_general =
-			&priv->_agn.delta_statistics_bt.rx.general.common;
-		delta_ht = &priv->_agn.delta_statistics_bt.rx.ofdm_ht;
-		max_ofdm = &priv->_agn.max_delta_bt.rx.ofdm;
-		max_cck = &priv->_agn.max_delta_bt.rx.cck;
-		max_general = &priv->_agn.max_delta_bt.rx.general.common;
-		max_ht = &priv->_agn.max_delta_bt.rx.ofdm_ht;
-	} else {
-		ofdm = &priv->_agn.statistics.rx.ofdm;
-		cck = &priv->_agn.statistics.rx.cck;
-		general = &priv->_agn.statistics.rx.general;
-		ht = &priv->_agn.statistics.rx.ofdm_ht;
-		accum_ofdm = &priv->_agn.accum_statistics.rx.ofdm;
-		accum_cck = &priv->_agn.accum_statistics.rx.cck;
-		accum_general = &priv->_agn.accum_statistics.rx.general;
-		accum_ht = &priv->_agn.accum_statistics.rx.ofdm_ht;
-		delta_ofdm = &priv->_agn.delta_statistics.rx.ofdm;
-		delta_cck = &priv->_agn.delta_statistics.rx.cck;
-		delta_general = &priv->_agn.delta_statistics.rx.general;
-		delta_ht = &priv->_agn.delta_statistics.rx.ofdm_ht;
-		max_ofdm = &priv->_agn.max_delta.rx.ofdm;
-		max_cck = &priv->_agn.max_delta.rx.cck;
-		max_general = &priv->_agn.max_delta.rx.general;
-		max_ht = &priv->_agn.max_delta.rx.ofdm_ht;
-	}
+	ofdm = &priv->statistics.rx_ofdm;
+	cck = &priv->statistics.rx_cck;
+	general = &priv->statistics.rx_non_phy;
+	ht = &priv->statistics.rx_ofdm_ht;
+	accum_ofdm = &priv->accum_stats.rx_ofdm;
+	accum_cck = &priv->accum_stats.rx_cck;
+	accum_general = &priv->accum_stats.rx_non_phy;
+	accum_ht = &priv->accum_stats.rx_ofdm_ht;
+	delta_ofdm = &priv->delta_stats.rx_ofdm;
+	delta_cck = &priv->delta_stats.rx_cck;
+	delta_general = &priv->delta_stats.rx_non_phy;
+	delta_ht = &priv->delta_stats.rx_ofdm_ht;
+	max_ofdm = &priv->max_delta_stats.rx_ofdm;
+	max_cck = &priv->max_delta_stats.rx_cck;
+	max_general = &priv->max_delta_stats.rx_non_phy;
+	max_ht = &priv->max_delta_stats.rx_ofdm_ht;
 
 	pos += iwl_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos,
@@ -531,20 +507,13 @@ ssize_t iwl_ucode_tx_stats_read(struct file *file,
 	}
 
 	/* the statistic information display here is based on
-	  * the last statistics notification from uCode
-	  * might not reflect the current uCode activity
-	  */
-	if (iwl_bt_statistics(priv)) {
-		tx = &priv->_agn.statistics_bt.tx;
-		accum_tx = &priv->_agn.accum_statistics_bt.tx;
-		delta_tx = &priv->_agn.delta_statistics_bt.tx;
-		max_tx = &priv->_agn.max_delta_bt.tx;
-	} else {
-		tx = &priv->_agn.statistics.tx;
-		accum_tx = &priv->_agn.accum_statistics.tx;
-		delta_tx = &priv->_agn.delta_statistics.tx;
-		max_tx = &priv->_agn.max_delta.tx;
-	}
+	 * the last statistics notification from uCode
+	 * might not reflect the current uCode activity
+	 */
+	tx = &priv->statistics.tx;
+	accum_tx = &priv->accum_stats.tx;
+	delta_tx = &priv->delta_stats.tx;
+	max_tx = &priv->max_delta_stats.tx;
 
 	pos += iwl_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos,
@@ -731,36 +700,21 @@ ssize_t iwl_ucode_general_stats_read(struct file *file, char __user *user_buf,
 	}
 
 	/* the statistic information display here is based on
-	  * the last statistics notification from uCode
-	  * might not reflect the current uCode activity
-	  */
-	if (iwl_bt_statistics(priv)) {
-		general = &priv->_agn.statistics_bt.general.common;
-		dbg = &priv->_agn.statistics_bt.general.common.dbg;
-		div = &priv->_agn.statistics_bt.general.common.div;
-		accum_general = &priv->_agn.accum_statistics_bt.general.common;
-		accum_dbg = &priv->_agn.accum_statistics_bt.general.common.dbg;
-		accum_div = &priv->_agn.accum_statistics_bt.general.common.div;
-		delta_general = &priv->_agn.delta_statistics_bt.general.common;
-		max_general = &priv->_agn.max_delta_bt.general.common;
-		delta_dbg = &priv->_agn.delta_statistics_bt.general.common.dbg;
-		max_dbg = &priv->_agn.max_delta_bt.general.common.dbg;
-		delta_div = &priv->_agn.delta_statistics_bt.general.common.div;
-		max_div = &priv->_agn.max_delta_bt.general.common.div;
-	} else {
-		general = &priv->_agn.statistics.general.common;
-		dbg = &priv->_agn.statistics.general.common.dbg;
-		div = &priv->_agn.statistics.general.common.div;
-		accum_general = &priv->_agn.accum_statistics.general.common;
-		accum_dbg = &priv->_agn.accum_statistics.general.common.dbg;
-		accum_div = &priv->_agn.accum_statistics.general.common.div;
-		delta_general = &priv->_agn.delta_statistics.general.common;
-		max_general = &priv->_agn.max_delta.general.common;
-		delta_dbg = &priv->_agn.delta_statistics.general.common.dbg;
-		max_dbg = &priv->_agn.max_delta.general.common.dbg;
-		delta_div = &priv->_agn.delta_statistics.general.common.div;
-		max_div = &priv->_agn.max_delta.general.common.div;
-	}
+	 * the last statistics notification from uCode
+	 * might not reflect the current uCode activity
+	 */
+	general = &priv->statistics.common;
+	dbg = &priv->statistics.common.dbg;
+	div = &priv->statistics.common.div;
+	accum_general = &priv->accum_stats.common;
+	accum_dbg = &priv->accum_stats.common.dbg;
+	accum_div = &priv->accum_stats.common.div;
+	delta_general = &priv->delta_stats.common;
+	max_general = &priv->max_delta_stats.common;
+	delta_dbg = &priv->delta_stats.common.dbg;
+	max_dbg = &priv->max_delta_stats.common.dbg;
+	delta_div = &priv->delta_stats.common.div;
+	max_div = &priv->max_delta_stats.common.div;
 
 	pos += iwl_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos,
@@ -876,8 +830,8 @@ ssize_t iwl_ucode_bt_stats_read(struct file *file,
 	 * the last statistics notification from uCode
 	 * might not reflect the current uCode activity
 	 */
-	bt = &priv->_agn.statistics_bt.general.activity;
-	accum_bt = &priv->_agn.accum_statistics_bt.general.activity;
+	bt = &priv->statistics.bt_activity;
+	accum_bt = &priv->accum_stats.bt_activity;
 
 	pos += iwl_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "Statistics_BT:\n");
@@ -918,10 +872,8 @@ ssize_t iwl_ucode_bt_stats_read(struct file *file,
 
 	pos += scnprintf(buf + pos, bufsz - pos,
 			 "(rx)num_bt_kills:\t\t%u\t\t\t%u\n",
-			 le32_to_cpu(priv->_agn.statistics_bt.rx.
-				general.num_bt_kills),
-			 priv->_agn.accum_statistics_bt.rx.
-				general.num_bt_kills);
+			 le32_to_cpu(priv->statistics.num_bt_kills),
+			 priv->statistics.accum_num_bt_kills);
 
 	ret = simple_read_from_buffer(user_buf, count, ppos, buf, pos);
 	kfree(buf);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index bc5dfe2..e741128 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -549,9 +549,7 @@ int iwlagn_send_tx_power(struct iwl_priv *priv)
 void iwlagn_temperature(struct iwl_priv *priv)
 {
 	/* store temperature from correct statistics (in Celsius) */
-	priv->temperature = le32_to_cpu((iwl_bt_statistics(priv)) ?
-		priv->_agn.statistics_bt.general.common.temperature :
-		priv->_agn.statistics.general.common.temperature);
+	priv->temperature = le32_to_cpu(priv->statistics.common.temperature);
 	iwl_tt_handler(priv);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 23b89c2..20499b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1705,10 +1705,6 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
 	else
 		priv->cmd_queue = IWL_DEFAULT_CMD_QUEUE_NUM;
 
-	if (ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BTSTATS ||
-	    (priv->cfg->bt_params && priv->cfg->bt_params->bt_statistics))
-		priv->bt_statistics = true;
-
 	/* Copy images into buffers for card's bus-master reads ... */
 
 	/* Runtime instructions (first block of data in file) */
@@ -2626,17 +2622,8 @@ static void iwl_bg_run_time_calib_work(struct work_struct *work)
 	}
 
 	if (priv->start_calib) {
-		if (iwl_bt_statistics(priv)) {
-			iwl_chain_noise_calibration(priv,
-					(void *)&priv->_agn.statistics_bt);
-			iwl_sensitivity_calibration(priv,
-					(void *)&priv->_agn.statistics_bt);
-		} else {
-			iwl_chain_noise_calibration(priv,
-					(void *)&priv->_agn.statistics);
-			iwl_sensitivity_calibration(priv,
-					(void *)&priv->_agn.statistics);
-		}
+		iwl_chain_noise_calibration(priv);
+		iwl_sensitivity_calibration(priv);
 	}
 
 	mutex_unlock(&priv->mutex);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index a1a5c1b..0edba8a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2535,53 +2535,6 @@ struct rate_histogram {
 
 /* statistics command response */
 
-struct iwl39_statistics_rx_phy {
-	__le32 ina_cnt;
-	__le32 fina_cnt;
-	__le32 plcp_err;
-	__le32 crc32_err;
-	__le32 overrun_err;
-	__le32 early_overrun_err;
-	__le32 crc32_good;
-	__le32 false_alarm_cnt;
-	__le32 fina_sync_err_cnt;
-	__le32 sfd_timeout;
-	__le32 fina_timeout;
-	__le32 unresponded_rts;
-	__le32 rxe_frame_limit_overrun;
-	__le32 sent_ack_cnt;
-	__le32 sent_cts_cnt;
-} __packed;
-
-struct iwl39_statistics_rx_non_phy {
-	__le32 bogus_cts;	/* CTS received when not expecting CTS */
-	__le32 bogus_ack;	/* ACK received when not expecting ACK */
-	__le32 non_bssid_frames;	/* number of frames with BSSID that
-					 * doesn't belong to the STA BSSID */
-	__le32 filtered_frames;	/* count frames that were dumped in the
-				 * filtering process */
-	__le32 non_channel_beacons;	/* beacons with our bss id but not on
-					 * our serving channel */
-} __packed;
-
-struct iwl39_statistics_rx {
-	struct iwl39_statistics_rx_phy ofdm;
-	struct iwl39_statistics_rx_phy cck;
-	struct iwl39_statistics_rx_non_phy general;
-} __packed;
-
-struct iwl39_statistics_tx {
-	__le32 preamble_cnt;
-	__le32 rx_detected_cnt;
-	__le32 bt_prio_defer_cnt;
-	__le32 bt_prio_kill_cnt;
-	__le32 few_bytes_cnt;
-	__le32 cts_timeout;
-	__le32 ack_timeout;
-	__le32 expected_ack_cnt;
-	__le32 actual_ack_cnt;
-} __packed;
-
 struct statistics_dbg {
 	__le32 burst_check;
 	__le32 burst_count;
@@ -2589,23 +2542,6 @@ struct statistics_dbg {
 	__le32 reserved[3];
 } __packed;
 
-struct iwl39_statistics_div {
-	__le32 tx_on_a;
-	__le32 tx_on_b;
-	__le32 exec_time;
-	__le32 probe_time;
-} __packed;
-
-struct iwl39_statistics_general {
-	__le32 temperature;
-	struct statistics_dbg dbg;
-	__le32 sleep_time;
-	__le32 slots_out;
-	__le32 slots_idle;
-	__le32 ttl_timestamp;
-	struct iwl39_statistics_div div;
-} __packed;
-
 struct statistics_rx_phy {
 	__le32 ina_cnt;
 	__le32 fina_cnt;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 57763c0..6988335 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -279,7 +279,6 @@ struct iwl_base_params {
  * @advanced_bt_coexist: support advanced bt coexist
  * @bt_init_traffic_load: specify initial bt traffic load
  * @bt_prio_boost: default bt priority boost value
- * @bt_statistics: use BT version of statistics notification
  * @agg_time_limit: maximum number of uSec in aggregation
  * @ampdu_factor: Maximum A-MPDU length factor
  * @ampdu_density: Minimum A-MPDU spacing
@@ -289,7 +288,6 @@ struct iwl_bt_params {
 	bool advanced_bt_coexist;
 	u8 bt_init_traffic_load;
 	u8 bt_prio_boost;
-	const bool bt_statistics;
 	u16 agg_time_limit;
 	u8 ampdu_factor;
 	u8 ampdu_density;
@@ -696,11 +694,6 @@ static inline bool iwl_advanced_bt_coexist(struct iwl_priv *priv)
 	       priv->cfg->bt_params->advanced_bt_coexist;
 }
 
-static inline bool iwl_bt_statistics(struct iwl_priv *priv)
-{
-	return priv->bt_statistics;
-}
-
 extern bool bt_coex_active;
 extern bool bt_siso_mode;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index c02f069..897efac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -1751,8 +1751,7 @@ int iwl_dbgfs_register(struct iwl_priv *priv, const char *name)
 	DEBUGFS_ADD_FILE(chain_noise, dir_debug, S_IRUSR);
 	if (priv->cfg->base_params->ucode_tracing)
 		DEBUGFS_ADD_FILE(ucode_tracing, dir_debug, S_IWUSR | S_IRUSR);
-	if (iwl_bt_statistics(priv))
-		DEBUGFS_ADD_FILE(ucode_bt_stats, dir_debug, S_IRUSR);
+	DEBUGFS_ADD_FILE(ucode_bt_stats, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(reply_tx_error, dir_debug, S_IRUSR);
 	DEBUGFS_ADD_FILE(rxon_flags, dir_debug, S_IWUSR);
 	DEBUGFS_ADD_FILE(rxon_filter_flags, dir_debug, S_IWUSR);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7fe68f8..e84534c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -543,13 +543,12 @@ enum iwl_ucode_tlv_type {
  * enum iwl_ucode_tlv_flag - ucode API flags
  * @IWL_UCODE_TLV_FLAGS_PAN: This is PAN capable microcode; this previously
  *	was a separate TLV but moved here to save space.
- * @IWL_UCODE_TLV_FLAGS_BTSTATS: This uCode image uses BT statistics, which
- *	may be true even if the device doesn't have BT.
+ * @IWL_UCODE_TLV_FLAGS_RESERVED_1: reserved
  * @IWL_UCODE_TLV_FLAGS_MFP: This uCode image supports MFP (802.11w).
  */
 enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_PAN		= BIT(0),
-	IWL_UCODE_TLV_FLAGS_BTSTATS	= BIT(1),
+	IWL_UCODE_TLV_FLAGS_RESERVED_1	= BIT(1),
 	IWL_UCODE_TLV_FLAGS_MFP		= BIT(2),
 };
 
@@ -1357,6 +1356,31 @@ struct iwl_priv {
 	u64 timestamp;
 
 	struct {
+		__le32 flag;
+		struct statistics_general_common common;
+		struct statistics_rx_non_phy rx_non_phy;
+		struct statistics_rx_phy rx_ofdm;
+		struct statistics_rx_ht_phy rx_ofdm_ht;
+		struct statistics_rx_phy rx_cck;
+		struct statistics_tx tx;
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+		struct statistics_bt_activity bt_activity;
+		__le32 num_bt_kills, accum_num_bt_kills;
+#endif
+	} statistics;
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	struct {
+		struct statistics_general_common common;
+		struct statistics_rx_non_phy rx_non_phy;
+		struct statistics_rx_phy rx_ofdm;
+		struct statistics_rx_ht_phy rx_ofdm_ht;
+		struct statistics_rx_phy rx_cck;
+		struct statistics_tx tx;
+		struct statistics_bt_activity bt_activity;
+	} accum_stats, delta_stats, max_delta_stats;
+#endif
+
+	struct {
 		/* INT ICT Table */
 		__le32 *ict_tbl;
 		void *ict_tbl_vir;
@@ -1387,19 +1411,9 @@ struct iwl_priv {
 		u8 phy_calib_chain_noise_reset_cmd;
 		u8 phy_calib_chain_noise_gain_cmd;
 
-		struct iwl_notif_statistics statistics;
-		struct iwl_bt_notif_statistics statistics_bt;
 		/* counts reply_tx error */
 		struct reply_tx_error_statistics reply_tx_stats;
 		struct reply_agg_tx_error_statistics reply_agg_tx_stats;
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-		struct iwl_notif_statistics accum_statistics;
-		struct iwl_notif_statistics delta_statistics;
-		struct iwl_notif_statistics max_delta;
-		struct iwl_bt_notif_statistics accum_statistics_bt;
-		struct iwl_bt_notif_statistics delta_statistics_bt;
-		struct iwl_bt_notif_statistics max_delta_bt;
-#endif
 		/* notification wait support */
 		struct list_head notif_waits;
 		spinlock_t notif_wait_lock;
@@ -1424,7 +1438,6 @@ struct iwl_priv {
 	bool bt_ch_announce;
 	bool bt_full_concurrent;
 	bool bt_ant_couple_ok;
-	bool bt_statistics;
 	__le32 kill_ack_mask;
 	__le32 kill_cts_mask;
 	__le16 bt_valid;
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 4472761..b49819c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -390,21 +390,16 @@ static void iwl_rx_beacon_notif(struct iwl_priv *priv,
  * the BA_TIMEOUT_MAX, reload firmware and bring system back to normal
  * operation state.
  */
-static bool iwl_good_ack_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt)
+static bool iwl_good_ack_health(struct iwl_priv *priv,
+				struct statistics_tx *cur)
 {
 	int actual_delta, expected_delta, ba_timeout_delta;
-	struct statistics_tx *cur, *old;
+	struct statistics_tx *old;
 
 	if (priv->_agn.agg_tids_count)
 		return true;
 
-	if (iwl_bt_statistics(priv)) {
-		cur = &pkt->u.stats_bt.tx;
-		old = &priv->_agn.statistics_bt.tx;
-	} else {
-		cur = &pkt->u.stats.tx;
-		old = &priv->_agn.statistics.tx;
-	}
+	old = &priv->statistics.tx;
 
 	actual_delta = le32_to_cpu(cur->actual_ack_cnt) -
 		       le32_to_cpu(old->actual_ack_cnt);
@@ -430,10 +425,10 @@ static bool iwl_good_ack_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt
 		 * DEBUG is not, these will just compile out.
 		 */
 		IWL_DEBUG_RADIO(priv, "rx_detected_cnt delta %d\n",
-				priv->_agn.delta_statistics.tx.rx_detected_cnt);
+				priv->delta_stats.tx.rx_detected_cnt);
 		IWL_DEBUG_RADIO(priv,
 				"ack_or_ba_timeout_collision delta %d\n",
-				priv->_agn.delta_statistics.tx.ack_or_ba_timeout_collision);
+				priv->delta_stats.tx.ack_or_ba_timeout_collision);
 #endif
 
 		if (ba_timeout_delta >= BA_TIMEOUT_MAX)
@@ -450,7 +445,9 @@ static bool iwl_good_ack_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt
  * to improve the throughput.
  */
 static bool iwl_good_plcp_health(struct iwl_priv *priv,
-				 struct iwl_rx_packet *pkt, unsigned int msecs)
+				 struct statistics_rx_phy *cur_ofdm,
+				 struct statistics_rx_ht_phy *cur_ofdm_ht,
+				 unsigned int msecs)
 {
 	int delta;
 	int threshold = priv->cfg->base_params->plcp_delta_threshold;
@@ -460,29 +457,12 @@ static bool iwl_good_plcp_health(struct iwl_priv *priv,
 		return true;
 	}
 
-	if (iwl_bt_statistics(priv)) {
-		struct statistics_rx_bt *cur, *old;
-
-		cur = &pkt->u.stats_bt.rx;
-		old = &priv->_agn.statistics_bt.rx;
-
-		delta = le32_to_cpu(cur->ofdm.plcp_err) -
-			le32_to_cpu(old->ofdm.plcp_err) +
-			le32_to_cpu(cur->ofdm_ht.plcp_err) -
-			le32_to_cpu(old->ofdm_ht.plcp_err);
-	} else {
-		struct statistics_rx *cur, *old;
-
-		cur = &pkt->u.stats.rx;
-		old = &priv->_agn.statistics.rx;
-
-		delta = le32_to_cpu(cur->ofdm.plcp_err) -
-			le32_to_cpu(old->ofdm.plcp_err) +
-			le32_to_cpu(cur->ofdm_ht.plcp_err) -
-			le32_to_cpu(old->ofdm_ht.plcp_err);
-	}
+	delta = le32_to_cpu(cur_ofdm->plcp_err) -
+		le32_to_cpu(priv->statistics.rx_ofdm.plcp_err) +
+		le32_to_cpu(cur_ofdm_ht->plcp_err) -
+		le32_to_cpu(priv->statistics.rx_ofdm_ht.plcp_err);
 
-	/* Can be negative if firmware reseted statistics */
+	/* Can be negative if firmware reset statistics */
 	if (delta <= 0)
 		return true;
 
@@ -497,44 +477,36 @@ static bool iwl_good_plcp_health(struct iwl_priv *priv,
 }
 
 static void iwl_recover_from_statistics(struct iwl_priv *priv,
-					struct iwl_rx_packet *pkt)
+					struct statistics_rx_phy *cur_ofdm,
+					struct statistics_rx_ht_phy *cur_ofdm_ht,
+					struct statistics_tx *tx,
+					unsigned long stamp)
 {
 	const struct iwl_mod_params *mod_params = priv->cfg->mod_params;
 	unsigned int msecs;
-	unsigned long stamp;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	stamp = jiffies;
 	msecs = jiffies_to_msecs(stamp - priv->rx_statistics_jiffies);
 
 	/* Only gather statistics and update time stamp when not associated */
 	if (!iwl_is_any_associated(priv))
-		goto out;
+		return;
 
 	/* Do not check/recover when do not have enough statistics data */
 	if (msecs < 99)
 		return;
 
-	if (mod_params->ack_check && !iwl_good_ack_health(priv, pkt)) {
+	if (mod_params->ack_check && !iwl_good_ack_health(priv, tx)) {
 		IWL_ERR(priv, "low ack count detected, restart firmware\n");
 		if (!iwl_force_reset(priv, IWL_FW_RESET, false))
 			return;
 	}
 
-	if (mod_params->plcp_check && !iwl_good_plcp_health(priv, pkt, msecs))
+	if (mod_params->plcp_check &&
+	    !iwl_good_plcp_health(priv, cur_ofdm, cur_ofdm_ht, msecs))
 		iwl_force_reset(priv, IWL_RF_RESET, false);
-
-out:
-	if (iwl_bt_statistics(priv))
-		memcpy(&priv->_agn.statistics_bt, &pkt->u.stats_bt,
-			sizeof(priv->_agn.statistics_bt));
-	else
-		memcpy(&priv->_agn.statistics, &pkt->u.stats,
-			sizeof(priv->_agn.statistics));
-
-	priv->rx_statistics_jiffies = stamp;
 }
 
 /* Calculate noise level, based on measurements during network silence just
@@ -548,10 +520,8 @@ static void iwl_rx_calc_noise(struct iwl_priv *priv)
 	int bcn_silence_a, bcn_silence_b, bcn_silence_c;
 	int last_rx_noise;
 
-	if (iwl_bt_statistics(priv))
-		rx_info = &(priv->_agn.statistics_bt.rx.general.common);
-	else
-		rx_info = &(priv->_agn.statistics.rx.general);
+	rx_info = &priv->statistics.rx_non_phy;
+
 	bcn_silence_a =
 		le32_to_cpu(rx_info->beacon_silence_rssi_a) & IN_BAND_FILTER;
 	bcn_silence_b =
@@ -583,105 +553,153 @@ static void iwl_rx_calc_noise(struct iwl_priv *priv)
 			last_rx_noise);
 }
 
+#ifdef CONFIG_IWLWIFI_DEBUGFS
 /*
  *  based on the assumption of all statistics counter are in DWORD
  *  FIXME: This function is for debugging, do not deal with
  *  the case of counters roll-over.
  */
-static void iwl_accumulative_statistics(struct iwl_priv *priv,
-					__le32 *stats)
+static void accum_stats(__le32 *prev, __le32 *cur, __le32 *delta,
+			__le32 *max_delta, __le32 *accum, int size)
 {
-#ifdef CONFIG_IWLWIFI_DEBUGFS
-	int i, size;
-	__le32 *prev_stats;
-	u32 *accum_stats;
-	u32 *delta, *max_delta;
-	struct statistics_general_common *general, *accum_general;
-	struct statistics_tx *tx, *accum_tx;
-
-	if (iwl_bt_statistics(priv)) {
-		prev_stats = (__le32 *)&priv->_agn.statistics_bt;
-		accum_stats = (u32 *)&priv->_agn.accum_statistics_bt;
-		size = sizeof(struct iwl_bt_notif_statistics);
-		general = &priv->_agn.statistics_bt.general.common;
-		accum_general = &priv->_agn.accum_statistics_bt.general.common;
-		tx = &priv->_agn.statistics_bt.tx;
-		accum_tx = &priv->_agn.accum_statistics_bt.tx;
-		delta = (u32 *)&priv->_agn.delta_statistics_bt;
-		max_delta = (u32 *)&priv->_agn.max_delta_bt;
-	} else {
-		prev_stats = (__le32 *)&priv->_agn.statistics;
-		accum_stats = (u32 *)&priv->_agn.accum_statistics;
-		size = sizeof(struct iwl_notif_statistics);
-		general = &priv->_agn.statistics.general.common;
-		accum_general = &priv->_agn.accum_statistics.general.common;
-		tx = &priv->_agn.statistics.tx;
-		accum_tx = &priv->_agn.accum_statistics.tx;
-		delta = (u32 *)&priv->_agn.delta_statistics;
-		max_delta = (u32 *)&priv->_agn.max_delta;
-	}
-	for (i = sizeof(__le32); i < size;
-	     i += sizeof(__le32), stats++, prev_stats++, delta++,
-	     max_delta++, accum_stats++) {
-		if (le32_to_cpu(*stats) > le32_to_cpu(*prev_stats)) {
-			*delta = (le32_to_cpu(*stats) -
-				le32_to_cpu(*prev_stats));
-			*accum_stats += *delta;
-			if (*delta > *max_delta)
+	int i;
+
+	for (i = 0;
+	     i < size / sizeof(__le32);
+	     i++, prev++, cur++, delta++, max_delta++, accum++) {
+		if (le32_to_cpu(*cur) > le32_to_cpu(*prev)) {
+			*delta = cpu_to_le32(
+				le32_to_cpu(*cur) - le32_to_cpu(*prev));
+			le32_add_cpu(accum, le32_to_cpu(*delta));
+			if (le32_to_cpu(*delta) > le32_to_cpu(*max_delta))
 				*max_delta = *delta;
 		}
 	}
+}
 
-	/* reset accumulative statistics for "no-counter" type statistics */
-	accum_general->temperature = general->temperature;
-	accum_general->temperature_m = general->temperature_m;
-	accum_general->ttl_timestamp = general->ttl_timestamp;
-	accum_tx->tx_power.ant_a = tx->tx_power.ant_a;
-	accum_tx->tx_power.ant_b = tx->tx_power.ant_b;
-	accum_tx->tx_power.ant_c = tx->tx_power.ant_c;
-#endif
+static void
+iwl_accumulative_statistics(struct iwl_priv *priv,
+			    struct statistics_general_common *common,
+			    struct statistics_rx_non_phy *rx_non_phy,
+			    struct statistics_rx_phy *rx_ofdm,
+			    struct statistics_rx_ht_phy *rx_ofdm_ht,
+			    struct statistics_rx_phy *rx_cck,
+			    struct statistics_tx *tx,
+			    struct statistics_bt_activity *bt_activity)
+{
+#define ACCUM(_name)	\
+	accum_stats((__le32 *)&priv->statistics._name,		\
+		    (__le32 *)_name,				\
+		    (__le32 *)&priv->delta_stats._name,		\
+		    (__le32 *)&priv->max_delta_stats._name,	\
+		    (__le32 *)&priv->accum_stats._name,		\
+		    sizeof(*_name));
+
+	ACCUM(common);
+	ACCUM(rx_non_phy);
+	ACCUM(rx_ofdm);
+	ACCUM(rx_ofdm_ht);
+	ACCUM(rx_cck);
+	ACCUM(tx);
+	if (bt_activity)
+		ACCUM(bt_activity);
+#undef ACCUM
 }
+#else
+static inline void
+iwl_accumulative_statistics(struct iwl_priv *priv,
+			    struct statistics_general_common *common,
+			    struct statistics_rx_non_phy *rx_non_phy,
+			    struct statistics_rx_phy *rx_ofdm,
+			    struct statistics_rx_ht_phy *rx_ofdm_ht,
+			    struct statistics_rx_phy *rx_cck,
+			    struct statistics_tx *tx,
+			    struct statistics_bt_activity *bt_activity)
+{
+}
+#endif
 
 static void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
 {
+	unsigned long stamp = jiffies;
 	const int reg_recalib_period = 60;
 	int change;
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	u32 len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+	__le32 *flag;
+	struct statistics_general_common *common;
+	struct statistics_rx_non_phy *rx_non_phy;
+	struct statistics_rx_phy *rx_ofdm;
+	struct statistics_rx_ht_phy *rx_ofdm_ht;
+	struct statistics_rx_phy *rx_cck;
+	struct statistics_tx *tx;
+	struct statistics_bt_activity *bt_activity;
+
+	len -= sizeof(struct iwl_cmd_header); /* skip header */
+
+	IWL_DEBUG_RX(priv, "Statistics notification received (%d bytes).\n",
+		     len);
+
+	if (len == sizeof(struct iwl_bt_notif_statistics)) {
+		struct iwl_bt_notif_statistics *stats;
+		stats = &pkt->u.stats_bt;
+		flag = &stats->flag;
+		common = &stats->general.common;
+		rx_non_phy = &stats->rx.general.common;
+		rx_ofdm = &stats->rx.ofdm;
+		rx_ofdm_ht = &stats->rx.ofdm_ht;
+		rx_cck = &stats->rx.cck;
+		tx = &stats->tx;
+		bt_activity = &stats->general.activity;
 
-	if (iwl_bt_statistics(priv)) {
-		IWL_DEBUG_RX(priv,
-			     "Statistics notification received (%d vs %d).\n",
-			     (int)sizeof(struct iwl_bt_notif_statistics),
-			     le32_to_cpu(pkt->len_n_flags) &
-			     FH_RSCSR_FRAME_SIZE_MSK);
-
-		change = ((priv->_agn.statistics_bt.general.common.temperature !=
-			   pkt->u.stats_bt.general.common.temperature) ||
-			   ((priv->_agn.statistics_bt.flag &
-			   STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
-			   (pkt->u.stats_bt.flag &
-			   STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
-
-		iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats_bt);
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+		/* handle this exception directly */
+		priv->statistics.num_bt_kills = stats->rx.general.num_bt_kills;
+		le32_add_cpu(&priv->statistics.accum_num_bt_kills,
+			     le32_to_cpu(stats->rx.general.num_bt_kills));
+#endif
+	} else if (len == sizeof(struct iwl_notif_statistics)) {
+		struct iwl_notif_statistics *stats;
+		stats = &pkt->u.stats;
+		flag = &stats->flag;
+		common = &stats->general.common;
+		rx_non_phy = &stats->rx.general;
+		rx_ofdm = &stats->rx.ofdm;
+		rx_ofdm_ht = &stats->rx.ofdm_ht;
+		rx_cck = &stats->rx.cck;
+		tx = &stats->tx;
+		bt_activity = NULL;
 	} else {
-		IWL_DEBUG_RX(priv,
-			     "Statistics notification received (%d vs %d).\n",
-			     (int)sizeof(struct iwl_notif_statistics),
-			     le32_to_cpu(pkt->len_n_flags) &
-			     FH_RSCSR_FRAME_SIZE_MSK);
-
-		change = ((priv->_agn.statistics.general.common.temperature !=
-			   pkt->u.stats.general.common.temperature) ||
-			   ((priv->_agn.statistics.flag &
-			   STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
-			   (pkt->u.stats.flag &
-			   STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
-
-		iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
+		WARN_ONCE(1, "len %d doesn't match BT (%zu) or normal (%zu)\n",
+			  len, sizeof(struct iwl_bt_notif_statistics),
+			  sizeof(struct iwl_notif_statistics));
+		return;
 	}
 
-	iwl_recover_from_statistics(priv, pkt);
+	change = common->temperature != priv->statistics.common.temperature ||
+		 (*flag & STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
+		 (priv->statistics.flag & STATISTICS_REPLY_FLG_HT40_MODE_MSK);
+
+	iwl_accumulative_statistics(priv, common, rx_non_phy, rx_ofdm,
+				    rx_ofdm_ht, rx_cck, tx, bt_activity);
+
+	iwl_recover_from_statistics(priv, rx_ofdm, rx_ofdm_ht, tx, stamp);
+
+	priv->statistics.flag = *flag;
+	memcpy(&priv->statistics.common, common, sizeof(*common));
+	memcpy(&priv->statistics.rx_non_phy, rx_non_phy, sizeof(*rx_non_phy));
+	memcpy(&priv->statistics.rx_ofdm, rx_ofdm, sizeof(*rx_ofdm));
+	memcpy(&priv->statistics.rx_ofdm_ht, rx_ofdm_ht, sizeof(*rx_ofdm_ht));
+	memcpy(&priv->statistics.rx_cck, rx_cck, sizeof(*rx_cck));
+	memcpy(&priv->statistics.tx, tx, sizeof(*tx));
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	if (bt_activity)
+		memcpy(&priv->statistics.bt_activity, bt_activity,
+			sizeof(*bt_activity));
+#endif
+
+	priv->rx_statistics_jiffies = stamp;
 
 	set_bit(STATUS_STATISTICS, &priv->status);
 
@@ -708,18 +726,12 @@ static void iwl_rx_reply_statistics(struct iwl_priv *priv,
 
 	if (le32_to_cpu(pkt->u.stats.flag) & UCODE_STATISTICS_CLEAR_MSK) {
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-		memset(&priv->_agn.accum_statistics, 0,
-			sizeof(struct iwl_notif_statistics));
-		memset(&priv->_agn.delta_statistics, 0,
-			sizeof(struct iwl_notif_statistics));
-		memset(&priv->_agn.max_delta, 0,
-			sizeof(struct iwl_notif_statistics));
-		memset(&priv->_agn.accum_statistics_bt, 0,
-			sizeof(struct iwl_bt_notif_statistics));
-		memset(&priv->_agn.delta_statistics_bt, 0,
-			sizeof(struct iwl_bt_notif_statistics));
-		memset(&priv->_agn.max_delta_bt, 0,
-			sizeof(struct iwl_bt_notif_statistics));
+		memset(&priv->accum_stats, 0,
+			sizeof(priv->accum_stats));
+		memset(&priv->delta_stats, 0,
+			sizeof(priv->delta_stats));
+		memset(&priv->max_delta_stats, 0,
+			sizeof(priv->max_delta_stats));
 #endif
 		IWL_DEBUG_RX(priv, "Statistics have been cleared\n");
 	}
-- 
1.7.0.4

