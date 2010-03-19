Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41167 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808Ab0CSVOQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 17:14:16 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Trieu 'Andrew' Nguyen <trieux.t.nguyen@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 7/9] iwlwifi: move plcp check to separated function
Date: Fri, 19 Mar 2010 14:14:09 -0700
Message-Id: <1269033251-17545-8-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
References: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Move the plcp error checking into stand alone function and pointed by ops
to accommodate devices not needing this recovery.

Signed-off-by: Trieu 'Andrew' Nguyen <trieux.t.nguyen@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-4965.c |    1 +
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 +
 drivers/net/wireless/iwlwifi/iwl-core.h |    5 +++
 drivers/net/wireless/iwlwifi/iwl-rx.c   |   58 +++++++++++++++++++------------
 6 files changed, 47 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 5a9cb70..c6d6a0c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -213,6 +213,7 @@ static struct iwl_lib_ops iwl1000_lib = {
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
+	.recover_from_statistics = iwl_recover_from_statistics,
 };
 
 static const struct iwl_ops iwl1000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index acca89a..5efd60a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2221,6 +2221,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 		.set_ct_kill = iwl4965_set_ct_threshold,
 	},
 	.add_bcast_station = iwl_add_bcast_station,
+	.recover_from_statistics = iwl_recover_from_statistics,
 };
 
 static const struct iwl_ops iwl4965_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index a01b3c5..75f2a51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1500,6 +1500,7 @@ struct iwl_lib_ops iwl5000_lib = {
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
+	.recover_from_statistics = iwl_recover_from_statistics,
 };
 
 static struct iwl_lib_ops iwl5150_lib = {
@@ -1555,6 +1556,7 @@ static struct iwl_lib_ops iwl5150_lib = {
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
+	.recover_from_statistics = iwl_recover_from_statistics,
 };
 
 static const struct iwl_ops iwl5000_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 4fbc38c..b1f0e5c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -279,6 +279,7 @@ static struct iwl_lib_ops iwl6000_lib = {
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
+	.recover_from_statistics = iwl_recover_from_statistics,
 };
 
 static const struct iwl_ops iwl6000_ops = {
@@ -345,6 +346,7 @@ static struct iwl_lib_ops iwl6050_lib = {
 	 },
 	.add_bcast_station = iwl_add_bcast_station,
 	.recover_from_tx_stall = iwl_bg_monitor_recover,
+	.recover_from_statistics = iwl_recover_from_statistics,
 };
 
 static const struct iwl_ops iwl6050_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index c4cd1de..4251afb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -193,6 +193,9 @@ struct iwl_lib_ops {
 	void (*add_bcast_station)(struct iwl_priv *priv);
 	/* recover from tx queue stall */
 	void (*recover_from_tx_stall)(unsigned long data);
+	/* recover from errors showed in statistics */
+	void (*recover_from_statistics)(struct iwl_priv *priv,
+					struct iwl_rx_packet *pkt);
 };
 
 struct iwl_led_ops {
@@ -434,6 +437,8 @@ void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
 			       struct iwl_rx_mem_buffer *rxb);
 void iwl_rx_spectrum_measure_notif(struct iwl_priv *priv,
 					  struct iwl_rx_mem_buffer *rxb);
+void iwl_recover_from_statistics(struct iwl_priv *priv,
+				 struct iwl_rx_packet *pkt);
 void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb);
 void iwl_reply_statistics(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 8116aa0..d368b8d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -617,28 +617,18 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 #define REG_RECALIB_PERIOD (60)
 
 #define PLCP_MSG "plcp_err exceeded %u, %u, %u, %u, %u, %d, %u mSecs\n"
-void iwl_rx_statistics(struct iwl_priv *priv,
-			      struct iwl_rx_mem_buffer *rxb)
+/*
+ * This function checks for plcp error.
+ * - When the plcp error is exceeding the thresholds, it will reset the radio
+ * to improve the throughput.
+ */
+void iwl_recover_from_statistics(struct iwl_priv *priv,
+				   struct iwl_rx_packet *pkt)
 {
-	int change;
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	int combined_plcp_delta;
 	unsigned int plcp_msec;
 	unsigned long plcp_received_jiffies;
 
-	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
-		     (int)sizeof(priv->statistics),
-		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
-
-	change = ((priv->statistics.general.temperature !=
-		   pkt->u.stats.general.temperature) ||
-		  ((priv->statistics.flag &
-		    STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
-		   (pkt->u.stats.flag & STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
-#endif
 	/*
 	 * check for plcp_err and trigger radio reset if it exceeds
 	 * the plcp error threshold plcp_delta.
@@ -659,11 +649,11 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 			le32_to_cpu(priv->statistics.rx.ofdm_ht.plcp_err));
 
 		if ((combined_plcp_delta > 0) &&
-			((combined_plcp_delta * 100) / plcp_msec) >
+		    ((combined_plcp_delta * 100) / plcp_msec) >
 			priv->cfg->plcp_delta_threshold) {
 			/*
-			 * if plcp_err exceed the threshold, the following
-			 * data is printed in csv format:
+			 * if plcp_err exceed the threshold,
+			 * the following data is printed in csv format:
 			 *    Text: plcp_err exceeded %d,
 			 *    Received ofdm.plcp_err,
 			 *    Current ofdm.plcp_err,
@@ -678,9 +668,8 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 				le32_to_cpu(priv->statistics.rx.ofdm.plcp_err),
 				le32_to_cpu(pkt->u.stats.rx.ofdm_ht.plcp_err),
 				le32_to_cpu(
-					priv->statistics.rx.ofdm_ht.plcp_err),
+				  priv->statistics.rx.ofdm_ht.plcp_err),
 				combined_plcp_delta, plcp_msec);
-
 			/*
 			 * Reset the RF radio due to the high plcp
 			 * error rate
@@ -688,6 +677,31 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 			iwl_force_reset(priv, IWL_RF_RESET);
 		}
 	}
+}
+EXPORT_SYMBOL(iwl_recover_from_statistics);
+
+void iwl_rx_statistics(struct iwl_priv *priv,
+			      struct iwl_rx_mem_buffer *rxb)
+{
+	int change;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+
+
+	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
+		     (int)sizeof(priv->statistics),
+		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
+
+	change = ((priv->statistics.general.temperature !=
+		   pkt->u.stats.general.temperature) ||
+		  ((priv->statistics.flag &
+		    STATISTICS_REPLY_FLG_HT40_MODE_MSK) !=
+		   (pkt->u.stats.flag & STATISTICS_REPLY_FLG_HT40_MODE_MSK)));
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+	iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
+#endif
+	if (priv->cfg->ops->lib->recover_from_statistics)
+		priv->cfg->ops->lib->recover_from_statistics(priv, pkt);
 
 	memcpy(&priv->statistics, &pkt->u.stats, sizeof(priv->statistics));
 
-- 
1.6.3.3

