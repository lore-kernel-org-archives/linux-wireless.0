Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41503 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446AbYF3J0i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 05:26:38 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 07/33] iwlwifi: move RX stats to core, and move temperature to handler
Date: Mon, 30 Jun 2008 17:23:07 +0800
Message-Id: <1214817813-17639-8-git-send-email-yi.zhu@intel.com> (sfid-20080630_112641_583683_072E49CE)
In-Reply-To: <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-2-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-3-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-4-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-5-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-6-git-send-email-yi.zhu@intel.com>
 <1214817813-17639-7-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch moves RX stats flow to core modules, and moves temperature
calibration to handler since it is not needed in 5000.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   78 ++------------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    7 +++
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-calib.h    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    6 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 ++
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   75 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    6 +-
 9 files changed, 103 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index ab50273..1688803 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -555,8 +555,6 @@ out:
 	return ret;
 }
 
-#define REG_RECALIB_PERIOD (60)
-
 /* Reset differential Rx gains in NIC to prepare for chain noise calibration.
  * Called after every association, but this runs only once!
  *  ... once chain noise is calibrated the first time, it's good forever.  */
@@ -1890,80 +1888,15 @@ static int iwl4965_is_temp_calib_needed(struct iwl_priv *priv)
 	return 1;
 }
 
-/* Calculate noise level, based on measurements during network silence just
- *   before arriving beacon.  This measurement can be done only if we know
- *   exactly when to expect beacons, therefore only when we're associated. */
-static void iwl4965_rx_calc_noise(struct iwl_priv *priv)
+static void iwl4965_temperature_calib(struct iwl_priv *priv,
+				      struct iwl_notif_statistics *stats)
 {
-	struct statistics_rx_non_phy *rx_info
-				= &(priv->statistics.rx.general);
-	int num_active_rx = 0;
-	int total_silence = 0;
-	int bcn_silence_a =
-		le32_to_cpu(rx_info->beacon_silence_rssi_a) & IN_BAND_FILTER;
-	int bcn_silence_b =
-		le32_to_cpu(rx_info->beacon_silence_rssi_b) & IN_BAND_FILTER;
-	int bcn_silence_c =
-		le32_to_cpu(rx_info->beacon_silence_rssi_c) & IN_BAND_FILTER;
-
-	if (bcn_silence_a) {
-		total_silence += bcn_silence_a;
-		num_active_rx++;
-	}
-	if (bcn_silence_b) {
-		total_silence += bcn_silence_b;
-		num_active_rx++;
-	}
-	if (bcn_silence_c) {
-		total_silence += bcn_silence_c;
-		num_active_rx++;
-	}
-
-	/* Average among active antennas */
-	if (num_active_rx)
-		priv->last_rx_noise = (total_silence / num_active_rx) - 107;
-	else
-		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
-
-	IWL_DEBUG_CALIB("inband silence a %u, b %u, c %u, dBm %d\n",
-			bcn_silence_a, bcn_silence_b, bcn_silence_c,
-			priv->last_rx_noise);
-}
-
-void iwl4965_hw_rx_statistics(struct iwl_priv *priv,
-			      struct iwl_rx_mem_buffer *rxb)
-{
-	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
-	int change;
 	s32 temp;
-
-	IWL_DEBUG_RX("Statistics notification received (%d vs %d).\n",
-		     (int)sizeof(priv->statistics), pkt->len);
-
-	change = ((priv->statistics.general.temperature !=
-		   pkt->u.stats.general.temperature) ||
+	int change = ((priv->statistics.general.temperature !=
+		   stats->general.temperature) ||
 		  ((priv->statistics.flag &
 		    STATISTICS_REPLY_FLG_FAT_MODE_MSK) !=
-		   (pkt->u.stats.flag & STATISTICS_REPLY_FLG_FAT_MODE_MSK)));
-
-	memcpy(&priv->statistics, &pkt->u.stats, sizeof(priv->statistics));
-
-	set_bit(STATUS_STATISTICS, &priv->status);
-
-	/* Reschedule the statistics timer to occur in
-	 * REG_RECALIB_PERIOD seconds to ensure we get a
-	 * thermal update even if the uCode doesn't give
-	 * us one */
-	mod_timer(&priv->statistics_periodic, jiffies +
-		  msecs_to_jiffies(REG_RECALIB_PERIOD * 1000));
-
-	if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)) &&
-	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
-		iwl4965_rx_calc_noise(priv);
-		queue_work(priv->workqueue, &priv->run_time_calib_work);
-	}
-
-	iwl_leds_background(priv);
+		   (stats->flag & STATISTICS_REPLY_FLG_FAT_MODE_MSK)));
 
 	/* If the hardware hasn't reported a change in
 	 * temperature then don't bother computing a
@@ -3391,6 +3324,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.set_power = iwl4965_set_power,
 	.send_tx_power	= iwl4965_send_tx_power,
 	.update_chain_flags = iwl4965_update_chain_flags,
+	.temperature = iwl4965_temperature_calib,
 };
 
 static struct iwl_ops iwl4965_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 2b48f1b..5abfd56 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1433,6 +1433,12 @@ static int  iwl5000_send_tx_power(struct iwl_priv *priv)
 				       NULL);
 }
 
+static void iwl5000_temperature(struct iwl_priv *priv,
+				struct iwl_notif_statistics *stats)
+{
+	/* store temperature from statistics (in Celsius) */
+	priv->temperature = le32_to_cpu(stats->general.temperature);
+}
 
 static struct iwl_hcmd_ops iwl5000_hcmd = {
 	.rxon_assoc = iwl5000_send_rxon_assoc,
@@ -1462,6 +1468,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.init_alive_start = iwl5000_init_alive_start,
 	.alive_notify = iwl5000_alive_notify,
 	.send_tx_power = iwl5000_send_tx_power,
+	.temperature = iwl5000_temperature,
 	.apm_ops = {
 		.init =	iwl5000_apm_init,
 		.reset = iwl5000_apm_reset,
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index 48f5800..ef49440 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -470,7 +470,7 @@ void iwl_init_sensitivity(struct iwl_priv *priv)
 EXPORT_SYMBOL(iwl_init_sensitivity);
 
 void iwl_sensitivity_calibration(struct iwl_priv *priv,
-				    struct iwl4965_notif_statistics *resp)
+				    struct iwl_notif_statistics *resp)
 {
 	u32 rx_enable_time;
 	u32 fa_cck;
@@ -584,7 +584,7 @@ EXPORT_SYMBOL(iwl_sensitivity_calibration);
  * 2)  Differential rx gain settings to balance the 3 receivers.
  */
 void iwl_chain_noise_calibration(struct iwl_priv *priv,
-			      struct iwl4965_notif_statistics *stat_resp)
+				 struct iwl_notif_statistics *stat_resp)
 {
 	struct iwl_chain_noise_data *data = NULL;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.h b/drivers/net/wireless/iwlwifi/iwl-calib.h
index 5524a29..94c8e31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.h
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.h
@@ -67,9 +67,9 @@
 #include "iwl-commands.h"
 
 void iwl_chain_noise_calibration(struct iwl_priv *priv,
-				struct iwl4965_notif_statistics *stat_resp);
+				struct iwl_notif_statistics *stat_resp);
 void iwl_sensitivity_calibration(struct iwl_priv *priv,
-				struct iwl4965_notif_statistics *resp);
+				struct iwl_notif_statistics *resp);
 
 void iwl_init_sensitivity(struct iwl_priv *priv);
 void iwl_reset_run_time_calib(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 6957b22..9f8446c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2506,7 +2506,7 @@ struct statistics_general {
  */
 #define IWL_STATS_CONF_CLEAR_STATS __constant_cpu_to_le32(0x1)	/* see above */
 #define IWL_STATS_CONF_DISABLE_NOTIF __constant_cpu_to_le32(0x2)/* see above */
-struct iwl4965_statistics_cmd {
+struct iwl_statistics_cmd {
 	__le32 configuration_flags;	/* IWL_STATS_CONF_* */
 } __attribute__ ((packed));
 
@@ -2527,7 +2527,7 @@ struct iwl4965_statistics_cmd {
  */
 #define STATISTICS_REPLY_FLG_BAND_24G_MSK         __constant_cpu_to_le32(0x2)
 #define STATISTICS_REPLY_FLG_FAT_MODE_MSK         __constant_cpu_to_le32(0x8)
-struct iwl4965_notif_statistics {
+struct iwl_notif_statistics {
 	__le32 flag;
 	struct statistics_rx rx;
 	struct statistics_tx tx;
@@ -3000,7 +3000,7 @@ struct iwl_rx_packet {
 		struct iwl_rem_sta_resp rem_sta;
 		struct iwl4965_sleep_notification sleep_notif;
 		struct iwl4965_spectrum_resp spectrum;
-		struct iwl4965_notif_statistics stats;
+		struct iwl_notif_statistics stats;
 		struct iwl4965_compressed_ba_resp compressed_ba;
 		struct iwl4965_missed_beacon_notif missed_beacon;
 		struct iwl5000_calibration calib;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2838093..375afe1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -140,6 +140,8 @@ struct iwl_lib_ops {
 	int (*set_power)(struct iwl_priv *priv, void *cmd);
 	int (*send_tx_power) (struct iwl_priv *priv);
 	void (*update_chain_flags)(struct iwl_priv *priv);
+	void (*temperature) (struct iwl_priv *priv,
+		struct iwl_notif_statistics *stats);
 	/* eeprom operations (as defined in iwl-eeprom.h) */
 	struct iwl_eeprom_ops eeprom_ops;
 };
@@ -218,6 +220,8 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
 /* Handlers */
 void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb);
+void iwl_rx_statistics(struct iwl_priv *priv,
+			      struct iwl_rx_mem_buffer *rxb);
 
 /* TX helpers */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 81ff4c2..fd008ab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -624,8 +624,6 @@ extern int iwl_rxq_stop(struct iwl_priv *priv);
 extern void iwl_txq_ctx_stop(struct iwl_priv *priv);
 extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl_frame *frame, u8 rate);
-extern void iwl4965_hw_rx_statistics(struct iwl_priv *priv,
-				 struct iwl_rx_mem_buffer *rxb);
 extern void iwl4965_disable_events(struct iwl_priv *priv);
 extern void iwl4965_rx_reply_rx(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb);
@@ -994,7 +992,7 @@ struct iwl_priv {
 
 	struct iwl_power_mgr power_data;
 
-	struct iwl4965_notif_statistics statistics;
+	struct iwl_notif_statistics statistics;
 	unsigned long last_statistics_time;
 
 	/* context information */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index c248448..b3ca137 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -466,3 +466,78 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 	}
 }
 EXPORT_SYMBOL(iwl_rx_missed_beacon_notif);
+
+
+/* Calculate noise level, based on measurements during network silence just
+ *   before arriving beacon.  This measurement can be done only if we know
+ *   exactly when to expect beacons, therefore only when we're associated. */
+static void iwl_rx_calc_noise(struct iwl_priv *priv)
+{
+	struct statistics_rx_non_phy *rx_info
+				= &(priv->statistics.rx.general);
+	int num_active_rx = 0;
+	int total_silence = 0;
+	int bcn_silence_a =
+		le32_to_cpu(rx_info->beacon_silence_rssi_a) & IN_BAND_FILTER;
+	int bcn_silence_b =
+		le32_to_cpu(rx_info->beacon_silence_rssi_b) & IN_BAND_FILTER;
+	int bcn_silence_c =
+		le32_to_cpu(rx_info->beacon_silence_rssi_c) & IN_BAND_FILTER;
+
+	if (bcn_silence_a) {
+		total_silence += bcn_silence_a;
+		num_active_rx++;
+	}
+	if (bcn_silence_b) {
+		total_silence += bcn_silence_b;
+		num_active_rx++;
+	}
+	if (bcn_silence_c) {
+		total_silence += bcn_silence_c;
+		num_active_rx++;
+	}
+
+	/* Average among active antennas */
+	if (num_active_rx)
+		priv->last_rx_noise = (total_silence / num_active_rx) - 107;
+	else
+		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;
+
+	IWL_DEBUG_CALIB("inband silence a %u, b %u, c %u, dBm %d\n",
+			bcn_silence_a, bcn_silence_b, bcn_silence_c,
+			priv->last_rx_noise);
+}
+
+#define REG_RECALIB_PERIOD (60)
+
+void iwl_rx_statistics(struct iwl_priv *priv,
+			      struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
+
+	IWL_DEBUG_RX("Statistics notification received (%d vs %d).\n",
+		     (int)sizeof(priv->statistics), pkt->len);
+
+	memcpy(&priv->statistics, &pkt->u.stats, sizeof(priv->statistics));
+
+	set_bit(STATUS_STATISTICS, &priv->status);
+
+	/* Reschedule the statistics timer to occur in
+	 * REG_RECALIB_PERIOD seconds to ensure we get a
+	 * thermal update even if the uCode doesn't give
+	 * us one */
+	mod_timer(&priv->statistics_periodic, jiffies +
+		  msecs_to_jiffies(REG_RECALIB_PERIOD * 1000));
+
+	if (unlikely(!test_bit(STATUS_SCANNING, &priv->status)) &&
+	    (pkt->hdr.cmd == STATISTICS_NOTIFICATION)) {
+		iwl_rx_calc_noise(priv);
+		queue_work(priv->workqueue, &priv->run_time_calib_work);
+	}
+
+	iwl_leds_background(priv);
+
+	if (priv->cfg->ops->lib->temperature)
+		priv->cfg->ops->lib->temperature(priv, &pkt->u.stats);
+}
+EXPORT_SYMBOL(iwl_rx_statistics);
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 0a279d1..13d53f3 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -1387,8 +1387,8 @@ static void iwl4965_setup_rx_handlers(struct iwl_priv *priv)
 	 * statistics request from the host as well as for the periodic
 	 * statistics notifications (after received beacons) from the uCode.
 	 */
-	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl4965_hw_rx_statistics;
-	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl4965_hw_rx_statistics;
+	priv->rx_handlers[REPLY_STATISTICS_CMD] = iwl_rx_statistics;
+	priv->rx_handlers[STATISTICS_NOTIFICATION] = iwl_rx_statistics;
 
 	iwl_setup_rx_scan_handlers(priv);
 
@@ -4130,7 +4130,7 @@ static ssize_t show_statistics(struct device *d,
 			       struct device_attribute *attr, char *buf)
 {
 	struct iwl_priv *priv = dev_get_drvdata(d);
-	u32 size = sizeof(struct iwl4965_notif_statistics);
+	u32 size = sizeof(struct iwl_notif_statistics);
 	u32 len = 0, ofs = 0;
 	u8 *data = (u8 *) & priv->statistics;
 	int rc = 0;
-- 
1.5.3.6

