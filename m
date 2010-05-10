Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39917 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab0EJW21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 May 2010 18:28:27 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 23/47] iwl3945: add plcp error checking
Date: Mon, 10 May 2010 15:27:54 -0700
Message-Id: <1273530498-11876-24-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
References: <1273530498-11876-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Add plcp error checking for 3945. After threshold of plcp
is reached , it resets the radio

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |   67 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 +
 drivers/net/wireless/iwlwifi/iwl-rx.c   |    3 +-
 3 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index a4d842a..05d808b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -390,6 +390,67 @@ static void iwl3945_accumulative_statistics(struct iwl_priv *priv,
 }
 #endif
 
+/**
+ * iwl3945_good_plcp_health - checks for plcp error.
+ *
+ * When the plcp error is exceeding the thresholds, reset the radio
+ * to improve the throughput.
+ */
+static bool iwl3945_good_plcp_health(struct iwl_priv *priv,
+				struct iwl_rx_packet *pkt)
+{
+	bool rc = true;
+	struct iwl3945_notif_statistics current_stat;
+	int combined_plcp_delta;
+	unsigned int plcp_msec;
+	unsigned long plcp_received_jiffies;
+
+	memcpy(&current_stat, pkt->u.raw, sizeof(struct
+			iwl3945_notif_statistics));
+	/*
+	 * check for plcp_err and trigger radio reset if it exceeds
+	 * the plcp error threshold plcp_delta.
+	 */
+	plcp_received_jiffies = jiffies;
+	plcp_msec = jiffies_to_msecs((long) plcp_received_jiffies -
+					(long) priv->plcp_jiffies);
+	priv->plcp_jiffies = plcp_received_jiffies;
+	/*
+	 * check to make sure plcp_msec is not 0 to prevent division
+	 * by zero.
+	 */
+	if (plcp_msec) {
+		combined_plcp_delta =
+			(le32_to_cpu(current_stat.rx.ofdm.plcp_err) -
+			le32_to_cpu(priv->_3945.statistics.rx.ofdm.plcp_err));
+
+		if ((combined_plcp_delta > 0) &&
+			((combined_plcp_delta * 100) / plcp_msec) >
+			priv->cfg->plcp_delta_threshold) {
+			/*
+			 * if plcp_err exceed the threshold, the following
+			 * data is printed in csv format:
+			 *    Text: plcp_err exceeded %d,
+			 *    Received ofdm.plcp_err,
+			 *    Current ofdm.plcp_err,
+			 *    combined_plcp_delta,
+			 *    plcp_msec
+			 */
+			IWL_DEBUG_RADIO(priv, "plcp_err exceeded %u, "
+				"%u, %d, %u mSecs\n",
+				priv->cfg->plcp_delta_threshold,
+				le32_to_cpu(current_stat.rx.ofdm.plcp_err),
+				combined_plcp_delta, plcp_msec);
+			/*
+			 * Reset the RF radio due to the high plcp
+			 * error rate
+			 */
+			rc = false;
+		}
+	}
+	return rc;
+}
+
 void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 		struct iwl_rx_mem_buffer *rxb)
 {
@@ -401,6 +462,7 @@ void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	iwl3945_accumulative_statistics(priv, (__le32 *)&pkt->u.raw);
 #endif
+	iwl_recover_from_statistics(priv, pkt);
 
 	memcpy(&priv->_3945.statistics, pkt->u.raw, sizeof(priv->_3945.statistics));
 }
@@ -2792,6 +2854,7 @@ static struct iwl_lib_ops iwl3945_lib = {
 	.config_ap = iwl3945_config_ap,
 	.manage_ibss_station = iwl3945_manage_ibss_station,
 	.add_bcast_station = iwl3945_add_bcast_station,
+	.check_plcp_health = iwl3945_good_plcp_health,
 
 	.debugfs_ops = {
 		.rx_stats_read = iwl3945_ucode_rx_stats_read,
@@ -2832,7 +2895,7 @@ static struct iwl_cfg iwl3945_bg_cfg = {
 	.ht_greenfield_support = false,
 	.led_compensation = 64,
 	.broken_powersave = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.tx_power_by_driver = true,
@@ -2853,7 +2916,7 @@ static struct iwl_cfg iwl3945_abg_cfg = {
 	.ht_greenfield_support = false,
 	.led_compensation = 64,
 	.broken_powersave = true,
-	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_LONG_THRESHOLD_DEF,
 	.monitor_recover_period = IWL_MONITORING_PERIOD,
 	.max_event_log_size = 512,
 	.tx_power_by_driver = true,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 2f664a3..7a3f949 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -441,6 +441,8 @@ bool iwl_good_plcp_health(struct iwl_priv *priv,
 				 struct iwl_rx_packet *pkt);
 bool iwl_good_ack_health(struct iwl_priv *priv,
 				 struct iwl_rx_packet *pkt);
+void iwl_recover_from_statistics(struct iwl_priv *priv,
+				struct iwl_rx_packet *pkt);
 void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb);
 void iwl_reply_statistics(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index d661fce..c7c8d8a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -397,7 +397,7 @@ bool iwl_good_plcp_health(struct iwl_priv *priv,
 }
 EXPORT_SYMBOL(iwl_good_plcp_health);
 
-static void iwl_recover_from_statistics(struct iwl_priv *priv,
+void iwl_recover_from_statistics(struct iwl_priv *priv,
 				struct iwl_rx_packet *pkt)
 {
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
@@ -428,6 +428,7 @@ static void iwl_recover_from_statistics(struct iwl_priv *priv,
 		}
 	}
 }
+EXPORT_SYMBOL(iwl_recover_from_statistics);
 
 void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
-- 
1.6.3.3

