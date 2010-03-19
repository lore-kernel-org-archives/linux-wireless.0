Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55370 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942Ab0CSVOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 17:14:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Trieu 'Andrew' Nguyen <trieux.t.nguyen@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 8/9] iwlwifi: Recover TX flow failure
Date: Fri, 19 Mar 2010 14:14:10 -0700
Message-Id: <1269033251-17545-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
References: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Monitors the tx statistics to detect the drop in throughput.
When the throughput drops, the ratio of the actual_ack_count and the
expected_ack_count also drops.  At the same time, the aggregated
ba_timeout (the number of ba timeout retries) also rises.  If the
actual_ack_count/expected_ack_count ratio is 0 and the number of ba
timeout retries rises to BA_TIMEOUT_MAX, no tx packets can be delivered.
Reloading the uCode and bring the system back to normal operational
state.

Signed-off-by: Trieu 'Andrew' Nguyen <trieux.t.nguyen@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   14 ++++++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h |    5 +++
 drivers/net/wireless/iwlwifi/iwl-rx.c  |   50 +++++++++++++++++++++++++++++++-
 3 files changed, 67 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 82b1a3f..e69e625 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2916,10 +2916,21 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 			return ret;
 	case IEEE80211_AMPDU_TX_START:
 		IWL_DEBUG_HT(priv, "start Tx\n");
-		return iwl_tx_agg_start(priv, sta->addr, tid, ssn);
+		ret = iwl_tx_agg_start(priv, sta->addr, tid, ssn);
+		if (ret == 0) {
+			priv->_agn.agg_tids_count++;
+			IWL_DEBUG_HT(priv, "priv->_agn.agg_tids_count = %u\n",
+				     priv->_agn.agg_tids_count);
+		}
+		return ret;
 	case IEEE80211_AMPDU_TX_STOP:
 		IWL_DEBUG_HT(priv, "stop Tx\n");
 		ret = iwl_tx_agg_stop(priv, sta->addr, tid);
+		if ((ret == 0) && (priv->_agn.agg_tids_count > 0)) {
+			priv->_agn.agg_tids_count--;
+			IWL_DEBUG_HT(priv, "priv->_agn.agg_tids_count = %u\n",
+				     priv->_agn.agg_tids_count);
+		}
 		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 			return 0;
 		else
@@ -3303,6 +3314,7 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	priv->iw_mode = NL80211_IFTYPE_STATION;
 	priv->current_ht_config.smps = IEEE80211_SMPS_STATIC;
 	priv->missed_beacon_threshold = IWL_MISSED_BEACON_THRESHOLD_DEF;
+	priv->_agn.agg_tids_count = 0;
 
 	/* initialize force reset */
 	priv->force_reset[IWL_RF_RESET].reset_duration =
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index bb4cba5..e847e61 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1300,6 +1300,11 @@ struct iwl_priv {
 			int ict_index;
 			u32 inta;
 			bool use_ict;
+			/*
+			 * reporting the number of tids has AGG on. 0 means
+			 * no AGGREGATION
+			 */
+			u8 agg_tids_count;
 		} _agn;
 #endif
 	};
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index d368b8d..7aef285 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -616,9 +616,18 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 
 #define REG_RECALIB_PERIOD (60)
 
+/* the threshold ratio of actual_ack_cnt to expected_ack_cnt in percent */
+#define ACK_CNT_RATIO (50)
+#define BA_TIMEOUT_CNT (5)
+#define BA_TIMEOUT_MAX (16)
+
 #define PLCP_MSG "plcp_err exceeded %u, %u, %u, %u, %u, %d, %u mSecs\n"
 /*
- * This function checks for plcp error.
+ * This function checks for plcp error, ACK count ratios, aggregated BA
+ * timeout retries.
+ * - When the ACK count ratio is 0 and aggregated BA timeout retries is
+ * exceeding the BA_TIMEOUT_MAX, it will recover the failure by resetting
+ * the firmware.
  * - When the plcp error is exceeding the thresholds, it will reset the radio
  * to improve the throughput.
  */
@@ -628,6 +637,45 @@ void iwl_recover_from_statistics(struct iwl_priv *priv,
 	int combined_plcp_delta;
 	unsigned int plcp_msec;
 	unsigned long plcp_received_jiffies;
+	int actual_ack_cnt_delta;
+	int expected_ack_cnt_delta;
+	int ba_timeout_delta;
+
+	actual_ack_cnt_delta =
+		le32_to_cpu(pkt->u.stats.tx.actual_ack_cnt) -
+		le32_to_cpu(priv->statistics.tx.actual_ack_cnt);
+	expected_ack_cnt_delta =
+		le32_to_cpu(pkt->u.stats.tx.expected_ack_cnt) -
+		le32_to_cpu(priv->statistics.tx.expected_ack_cnt);
+	ba_timeout_delta =
+		le32_to_cpu(pkt->u.stats.tx.agg.ba_timeout) -
+		le32_to_cpu(priv->statistics.tx.agg.ba_timeout);
+	if ((priv->_agn.agg_tids_count > 0) &&
+	    (expected_ack_cnt_delta > 0) &&
+	    (((actual_ack_cnt_delta * 100) / expected_ack_cnt_delta)
+		< ACK_CNT_RATIO) &&
+	    (ba_timeout_delta > BA_TIMEOUT_CNT)) {
+		IWL_DEBUG_RADIO(priv, "actual_ack_cnt delta = %d,"
+				" expected_ack_cnt = %d\n",
+				actual_ack_cnt_delta, expected_ack_cnt_delta);
+
+#ifdef CONFIG_IWLWIFI_DEBUG
+		IWL_DEBUG_RADIO(priv, "rx_detected_cnt delta = %d\n",
+				priv->delta_statistics.tx.rx_detected_cnt);
+		IWL_DEBUG_RADIO(priv,
+				"ack_or_ba_timeout_collision delta = %d\n",
+				priv->delta_statistics.tx.
+				ack_or_ba_timeout_collision);
+#endif
+		IWL_DEBUG_RADIO(priv, "agg ba_timeout delta = %d\n",
+				ba_timeout_delta);
+		if ((actual_ack_cnt_delta == 0) &&
+		    (ba_timeout_delta >= BA_TIMEOUT_MAX)) {
+			IWL_DEBUG_RADIO(priv,
+					"call iwl_force_reset(IWL_FW_RESET)\n");
+			iwl_force_reset(priv, IWL_FW_RESET);
+		}
+	}
 
 	/*
 	 * check for plcp_err and trigger radio reset if it exceeds
-- 
1.6.3.3

