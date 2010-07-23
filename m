Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25118 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515Ab0GWQN4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 12:13:56 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/10] iwlagn: add statistic notification structure for WiFi/BT devices
Date: Fri, 23 Jul 2010 09:15:30 -0700
Message-Id: <1279901739-10541-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1279901739-10541-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

If its WiFi/BT combo device, the statistics notification sent by
uCode will include the additional BT related statistics counters.

Adding new data structure to support the new layout.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c        |    4 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c        |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c |   28 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c      |   16 ++++----
 drivers/net/wireless/iwlwifi/iwl-commands.h    |   46 +++++++++++++++++++++++-
 6 files changed, 71 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 3a0d0ad..27a776f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1605,8 +1605,8 @@ static int iwl4965_hw_get_temperature(struct iwl_priv *priv)
 	if (!test_bit(STATUS_TEMPERATURE, &priv->status))
 		vt = sign_extend(R4, 23);
 	else
-		vt = sign_extend(le32_to_cpu(
-				priv->_agn.statistics.general.temperature), 23);
+		vt = sign_extend(le32_to_cpu(priv->_agn.statistics.
+				 general.common.temperature), 23);
 
 	IWL_DEBUG_TEMP(priv, "Calib values R[1-3]: %d %d %d R4: %d\n", R1, R2, R3, vt);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 7d89d99..a7077cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -265,7 +265,7 @@ static void iwl5150_temperature(struct iwl_priv *priv)
 	u32 vt = 0;
 	s32 offset =  iwl_temp_calib_to_offset(priv);
 
-	vt = le32_to_cpu(priv->_agn.statistics.general.temperature);
+	vt = le32_to_cpu(priv->_agn.statistics.general.common.temperature);
 	vt = vt / IWL_5150_VOLTAGE_TO_TEMPERATURE_COEFF + offset;
 	/* now vt hold the temperature in Kelvin */
 	priv->temperature = KELVIN_TO_CELSIUS(vt);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
index 5e5c512..11dd1f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-debugfs.c
@@ -759,8 +759,8 @@ ssize_t iwl_ucode_general_stats_read(struct file *file, char __user *user_buf,
 	char *buf;
 	int bufsz = sizeof(struct statistics_general) * 10 + 300;
 	ssize_t ret;
-	struct statistics_general *general, *accum_general;
-	struct statistics_general *delta_general, *max_general;
+	struct statistics_general_common *general, *accum_general;
+	struct statistics_general_common *delta_general, *max_general;
 	struct statistics_dbg *dbg, *accum_dbg, *delta_dbg, *max_dbg;
 	struct statistics_div *div, *accum_div, *delta_div, *max_div;
 
@@ -777,18 +777,18 @@ ssize_t iwl_ucode_general_stats_read(struct file *file, char __user *user_buf,
 	  * the last statistics notification from uCode
 	  * might not reflect the current uCode activity
 	  */
-	general = &priv->_agn.statistics.general;
-	dbg = &priv->_agn.statistics.general.dbg;
-	div = &priv->_agn.statistics.general.div;
-	accum_general = &priv->_agn.accum_statistics.general;
-	delta_general = &priv->_agn.delta_statistics.general;
-	max_general = &priv->_agn.max_delta.general;
-	accum_dbg = &priv->_agn.accum_statistics.general.dbg;
-	delta_dbg = &priv->_agn.delta_statistics.general.dbg;
-	max_dbg = &priv->_agn.max_delta.general.dbg;
-	accum_div = &priv->_agn.accum_statistics.general.div;
-	delta_div = &priv->_agn.delta_statistics.general.div;
-	max_div = &priv->_agn.max_delta.general.div;
+	general = &priv->_agn.statistics.general.common;
+	dbg = &priv->_agn.statistics.general.common.dbg;
+	div = &priv->_agn.statistics.general.common.div;
+	accum_general = &priv->_agn.accum_statistics.general.common;
+	delta_general = &priv->_agn.delta_statistics.general.common;
+	max_general = &priv->_agn.max_delta.general.common;
+	accum_dbg = &priv->_agn.accum_statistics.general.common.dbg;
+	delta_dbg = &priv->_agn.delta_statistics.general.common.dbg;
+	max_dbg = &priv->_agn.max_delta.general.common.dbg;
+	accum_div = &priv->_agn.accum_statistics.general.common.div;
+	delta_div = &priv->_agn.delta_statistics.general.common.div;
+	max_div = &priv->_agn.max_delta.general.common.div;
 	pos += iwl_statistics_flag(priv, buf, bufsz);
 	pos += scnprintf(buf + pos, bufsz - pos, "%-32s     current"
 			 "acumulative       delta         max\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 74623e0..dda71cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -364,7 +364,7 @@ void iwlagn_temperature(struct iwl_priv *priv)
 {
 	/* store temperature from statistics (in Celsius) */
 	priv->temperature =
-		le32_to_cpu(priv->_agn.statistics.general.temperature);
+		le32_to_cpu(priv->_agn.statistics.general.common.temperature);
 	iwl_tt_handler(priv);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index d54edc3..249b77b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -135,12 +135,12 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 	}
 
 	/* reset accumulative statistics for "no-counter" type statistics */
-	priv->_agn.accum_statistics.general.temperature =
-		priv->_agn.statistics.general.temperature;
-	priv->_agn.accum_statistics.general.temperature_m =
-		priv->_agn.statistics.general.temperature_m;
-	priv->_agn.accum_statistics.general.ttl_timestamp =
-		priv->_agn.statistics.general.ttl_timestamp;
+	priv->_agn.accum_statistics.general.common.temperature =
+		priv->_agn.statistics.general.common.temperature;
+	priv->_agn.accum_statistics.general.common.temperature_m =
+		priv->_agn.statistics.general.common.temperature_m;
+	priv->_agn.accum_statistics.general.common.ttl_timestamp =
+		priv->_agn.statistics.general.common.ttl_timestamp;
 	priv->_agn.accum_statistics.tx.tx_power.ant_a =
 		priv->_agn.statistics.tx.tx_power.ant_a;
 	priv->_agn.accum_statistics.tx.tx_power.ant_b =
@@ -232,8 +232,8 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 		     (int)sizeof(priv->_agn.statistics),
 		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
 
-	change = ((priv->_agn.statistics.general.temperature !=
-		   pkt->u.stats.general.temperature) ||
+	change = ((priv->_agn.statistics.general.common.temperature !=
+		   pkt->u.stats.general.common.temperature) ||
 		  ((priv->_agn.statistics.flag &
 		    STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
 		   (pkt->u.stats.flag & STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 83247f7..4be9063 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -3127,6 +3127,13 @@ struct statistics_rx_non_phy {
 	__le32 beacon_energy_c;
 } __attribute__ ((packed));
 
+struct statistics_rx_non_phy_bt {
+	struct statistics_rx_non_phy common;
+	/* additional stats for bt */
+	__le32 num_bt_kills;
+	__le32 reserved[2];
+} __attribute__ ((packed));
+
 struct statistics_rx {
 	struct statistics_rx_phy ofdm;
 	struct statistics_rx_phy cck;
@@ -3134,6 +3141,13 @@ struct statistics_rx {
 	struct statistics_rx_ht_phy ofdm_ht;
 } __attribute__ ((packed));
 
+struct statistics_rx_bt {
+	struct statistics_rx_phy ofdm;
+	struct statistics_rx_phy cck;
+	struct statistics_rx_non_phy_bt general;
+	struct statistics_rx_ht_phy ofdm_ht;
+} __attribute__ ((packed));
+
 /**
  * struct statistics_tx_power - current tx power
  *
@@ -3196,7 +3210,7 @@ struct statistics_div {
 	__le32 reserved2;
 } __attribute__ ((packed));
 
-struct statistics_general {
+struct statistics_general_common {
 	__le32 temperature;   /* radio temperature */
 	__le32 temperature_m; /* for 5000 and up, this is radio voltage */
 	struct statistics_dbg dbg;
@@ -3212,6 +3226,30 @@ struct statistics_general {
 	 *  in order to get out of bad PHY status
 	 */
 	__le32 num_of_sos_states;
+} __attribute__ ((packed));
+
+struct statistics_bt_activity {
+	/* Tx statistics */
+	__le32 hi_priority_tx_req_cnt;
+	__le32 hi_priority_tx_denied_cnt;
+	__le32 lo_priority_tx_req_cnt;
+	__le32 lo_priority_tx_denied_cnt;
+	/* Rx statistics */
+	__le32 hi_priority_rx_req_cnt;
+	__le32 hi_priority_rx_denied_cnt;
+	__le32 lo_priority_rx_req_cnt;
+	__le32 lo_priority_rx_denied_cnt;
+} __attribute__ ((packed));
+
+struct statistics_general {
+	struct statistics_general_common common;
+	__le32 reserved2;
+	__le32 reserved3;
+} __attribute__ ((packed));
+
+struct statistics_general_bt {
+	struct statistics_general_common common;
+	struct statistics_bt_activity activity;
 	__le32 reserved2;
 	__le32 reserved3;
 } __attribute__ ((packed));
@@ -3273,6 +3311,12 @@ struct iwl_notif_statistics {
 	struct statistics_general general;
 } __attribute__ ((packed));
 
+struct iwl_bt_notif_statistics {
+	__le32 flag;
+	struct statistics_rx_bt rx;
+	struct statistics_tx tx;
+	struct statistics_general_bt general;
+} __attribute__ ((packed));
 
 /*
  * MISSED_BEACONS_NOTIFICATION = 0xa2 (notification only, not a command)
-- 
1.7.0.4

