Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21922 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab0CSVOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 17:14:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 9/9] iwlwifi: code cleanup for connectivity recovery
Date: Fri, 19 Mar 2010 14:14:11 -0700
Message-Id: <1269033251-17545-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
References: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Split the connectivity check and recovery routine into separated
functions based on the types
   1. iwl_good_ack_health() - check for ack count
   2. iwl_good_plcp_health() - check for plcp error

Based on the type of errors being detected, different recovery methods
will be used to bring the system back to normal operational state.

Because different NIC has different HW and uCode, the behavior is also
different; these functions thus now form part of the ops infrastructure,
so we can have more control on how to monitor and recover from error condition
case per device.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    3 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000.c |    6 +-
 drivers/net/wireless/iwlwifi/iwl-6000.c |    6 +-
 drivers/net/wireless/iwlwifi/iwl-core.h |   11 +++-
 drivers/net/wireless/iwlwifi/iwl-rx.c   |   97 +++++++++++++++++++++----------
 6 files changed, 85 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index c6d6a0c..9e39289 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -213,7 +213,8 @@ static struct iwl_lib_ops iwl1000_lib = {
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
-	.recover_from_statistics = iwl_recover_from_statistics,
+	.check_plcp_health = iwl_good_plcp_health,
+	.check_ack_health = iwl_good_ack_health,
 };
 
 static const struct iwl_ops iwl1000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 5efd60a..3949133 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2221,7 +2221,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.set_ct_kill = iwl4965_set_ct_threshold,
 	},
 	.add_bcast_station = iwl_add_bcast_station,
-	.recover_from_statistics = iwl_recover_from_statistics,
+	.check_plcp_health = iwl_good_plcp_health,
 };
 
 static const struct iwl_ops iwl4965_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 75f2a51..2267cad 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1500,7 +1500,8 @@ struct iwl_lib_ops iwl5000_lib = {
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
-	.recover_from_statistics = iwl_recover_from_statistics,
+	.check_plcp_health = iwl_good_plcp_health,
+	.check_ack_health = iwl_good_ack_health,
 };
 
 static struct iwl_lib_ops iwl5150_lib = {
@@ -1556,7 +1557,8 @@ static struct iwl_lib_ops iwl5150_lib = {
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
-	.recover_from_statistics = iwl_recover_from_statistics,
+	.check_plcp_health = iwl_good_plcp_health,
+	.check_ack_health = iwl_good_ack_health,
 };
 
 static const struct iwl_ops iwl5000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index b1f0e5c..d757999 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -279,7 +279,8 @@ static struct iwl_lib_ops iwl6000_lib = {
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
-	.recover_from_statistics = iwl_recover_from_statistics,
+	.check_plcp_health = iwl_good_plcp_health,
+	.check_ack_health = iwl_good_ack_health,
 };
 
 static const struct iwl_ops iwl6000_ops = {
@@ -346,7 +347,8 @@ static struct iwl_lib_ops iwl6050_lib = {
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
-	.recover_from_statistics = iwl_recover_from_statistics,
+	.check_plcp_health = iwl_good_plcp_health,
+	.check_ack_health = iwl_good_ack_health,
 };
 
 static const struct iwl_ops iwl6050_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 4251afb..b3e698b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -193,8 +193,11 @@ struct iwl_lib_ops {
 	void (*add_bcast_station)(struct iwl_priv *priv);
 	/* recover from tx queue stall */
 	void (*recover_from_tx_stall)(unsigned long data);
-	/* recover from errors showed in statistics */
-	void (*recover_from_statistics)(struct iwl_priv *priv,
+	/* check for plcp health */
+	bool (*check_plcp_health)(struct iwl_priv *priv,
+					struct iwl_rx_packet *pkt);
+	/* check for ack health */
+	bool (*check_ack_health)(struct iwl_priv *priv,
 					struct iwl_rx_packet *pkt);
 };
 
@@ -437,7 +440,9 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb);
 void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb);
-void iwl_recover_from_statistics(struct iwl_priv *priv,
+bool iwl_good_plcp_health(struct iwl_priv *priv,
+				 struct iwl_rx_packet *pkt);
+bool iwl_good_ack_health(struct iwl_priv *priv,
 				 struct iwl_rx_packet *pkt);
 void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 7aef285..b6a64d8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -621,24 +621,18 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 #define BA_TIMEOUT_CNT (5)
 #define BA_TIMEOUT_MAX (16)
 
-#define PLCP_MSG "plcp_err exceeded %u, %u, %u, %u, %u, %d, %u mSecs\n"
-/*
- * This function checks for plcp error, ACK count ratios, aggregated BA
- * timeout retries.
- * - When the ACK count ratio is 0 and aggregated BA timeout retries is
- * exceeding the BA_TIMEOUT_MAX, it will recover the failure by resetting
- * the firmware.
- * - When the plcp error is exceeding the thresholds, it will reset the radio
- * to improve the throughput.
+/**
+ * iwl_good_ack_health - checks for ACK count ratios, BA timeout retries.
+ *
+ * When the ACK count ratio is 0 and aggregated BA timeout retries exceeding
+ * the BA_TIMEOUT_MAX, reload firmware and bring system back to normal
+ * operation state.
  */
-void iwl_recover_from_statistics(struct iwl_priv *priv,
-				   struct iwl_rx_packet *pkt)
+bool iwl_good_ack_health(struct iwl_priv *priv,
+				struct iwl_rx_packet *pkt)
 {
-	int combined_plcp_delta;
-	unsigned int plcp_msec;
-	unsigned long plcp_received_jiffies;
-	int actual_ack_cnt_delta;
-	int expected_ack_cnt_delta;
+	bool rc = true;
+	int actual_ack_cnt_delta, expected_ack_cnt_delta;
 	int ba_timeout_delta;
 
 	actual_ack_cnt_delta =
@@ -669,13 +663,27 @@ void iwl_recover_from_statistics(struct iwl_priv *priv,
 #endif
 		IWL_DEBUG_RADIO(priv, "agg ba_timeout delta = %d\n",
 				ba_timeout_delta);
-		if ((actual_ack_cnt_delta == 0) &&
-		    (ba_timeout_delta >= BA_TIMEOUT_MAX)) {
-			IWL_DEBUG_RADIO(priv,
-					"call iwl_force_reset(IWL_FW_RESET)\n");
-			iwl_force_reset(priv, IWL_FW_RESET);
-		}
+		if (!actual_ack_cnt_delta &&
+		    (ba_timeout_delta >= BA_TIMEOUT_MAX))
+			rc = false;
 	}
+	return rc;
+}
+EXPORT_SYMBOL(iwl_good_ack_health);
+
+/**
+ * iwl_good_plcp_health - checks for plcp error.
+ *
+ * When the plcp error is exceeding the thresholds, reset the radio
+ * to improve the throughput.
+ */
+bool iwl_good_plcp_health(struct iwl_priv *priv,
+				struct iwl_rx_packet *pkt)
+{
+	bool rc = true;
+	int combined_plcp_delta;
+	unsigned int plcp_msec;
+	unsigned long plcp_received_jiffies;
 
 	/*
 	 * check for plcp_err and trigger radio reset if it exceeds
@@ -710,7 +718,8 @@ void iwl_recover_from_statistics(struct iwl_priv *priv,
 			 *    combined_plcp_delta,
 			 *    plcp_msec
 			 */
-			IWL_DEBUG_RADIO(priv, PLCP_MSG,
+			IWL_DEBUG_RADIO(priv, "plcp_err exceeded %u, "
+				"%u, %u, %u, %u, %d, %u mSecs\n",
 				priv->cfg->plcp_delta_threshold,
 				le32_to_cpu(pkt->u.stats.rx.ofdm.plcp_err),
 				le32_to_cpu(priv->statistics.rx.ofdm.plcp_err),
@@ -718,15 +727,42 @@ void iwl_recover_from_statistics(struct iwl_priv *priv,
 				le32_to_cpu(
 				  priv->statistics.rx.ofdm_ht.plcp_err),
 				combined_plcp_delta, plcp_msec);
-			/*
-			 * Reset the RF radio due to the high plcp
-			 * error rate
-			 */
-			iwl_force_reset(priv, IWL_RF_RESET);
+			rc = false;
+		}
+	}
+	return rc;
+}
+EXPORT_SYMBOL(iwl_good_plcp_health);
+
+static void iwl_recover_from_statistics(struct iwl_priv *priv,
+				struct iwl_rx_packet *pkt)
+{
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+	if (iwl_is_associated(priv)) {
+		if (priv->cfg->ops->lib->check_ack_health) {
+			if (!priv->cfg->ops->lib->check_ack_health(
+			    priv, pkt)) {
+				/*
+				 * low ack count detected
+				 * restart Firmware
+				 */
+				IWL_ERR(priv, "low ack count detected, "
+					"restart firmware\n");
+				iwl_force_reset(priv, IWL_FW_RESET);
+			}
+		} else if (priv->cfg->ops->lib->check_plcp_health) {
+			if (!priv->cfg->ops->lib->check_plcp_health(
+			    priv, pkt)) {
+				/*
+				 * high plcp error detected
+				 * reset Radio
+				 */
+				iwl_force_reset(priv, IWL_RF_RESET);
+			}
 		}
 	}
 }
-EXPORT_SYMBOL(iwl_recover_from_statistics);
 
 void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
@@ -748,8 +784,7 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
 #endif
-	if (priv->cfg->ops->lib->recover_from_statistics)
-		priv->cfg->ops->lib->recover_from_statistics(priv, pkt);
+	iwl_recover_from_statistics(priv, pkt);
 
 	memcpy(&priv->statistics, &pkt->u.stats, sizeof(priv->statistics));
 
-- 
1.6.3.3

