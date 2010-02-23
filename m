Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41174 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab0BWWOK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 17:14:10 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH] Revert "iwlwifi: Monitor and recover the aggregation TX flow failure"
Date: Tue, 23 Feb 2010 14:13:00 -0800
Message-Id: <1266963180-613-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

This reverts commit 1db5950f1d0b82e07371b211a48317b8972da063.

The goal of "iwlwifi: Monitor and recover the aggregation TX flow failure"
is to first detect when data transmission stalls and then to recover from
this situation with a reset of the radio or the firmware, depending on how
bad the transmission failures are considered to be.

Unfortunately we have found that this change causes excessive resets with
its current detection algorithm. It also performs its recovery action when
none is really needed, like when we are not associated.

Revert this change until the issues have been addressed.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
We are reverting this change since there is not much time to get this fixed
before 2.6.34 closes. This work will be resubmitted for 2.6.35.

This patch applies against wireless-next-2.6 and is also available from
wireless-next-2.6 branch on
git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

 drivers/net/wireless/iwlwifi/iwl-agn.c |   14 +---------
 drivers/net/wireless/iwlwifi/iwl-dev.h |    3 --
 drivers/net/wireless/iwlwifi/iwl-rx.c  |   46 --------------------------------
 3 files changed, 1 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index c5b724e..1fac015 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2941,21 +2941,10 @@ static int iwl_mac_ampdu_action(struct ieee80211_hw *hw,
 			return ret;
 	case IEEE80211_AMPDU_TX_START:
 		IWL_DEBUG_HT(priv, "start Tx\n");
-		ret = iwl_tx_agg_start(priv, sta->addr, tid, ssn);
-		if (ret == 0) {
-			priv->agg_tids_count++;
-			IWL_DEBUG_HT(priv, "priv->agg_tids_count = %u\n",
-				priv->agg_tids_count);
-		}
-		return ret;
+		return iwl_tx_agg_start(priv, sta->addr, tid, ssn);
 	case IEEE80211_AMPDU_TX_STOP:
 		IWL_DEBUG_HT(priv, "stop Tx\n");
 		ret = iwl_tx_agg_stop(priv, sta->addr, tid);
-		if ((ret == 0) && (priv->agg_tids_count > 0)) {
-			priv->agg_tids_count--;
-			IWL_DEBUG_HT(priv, "priv->agg_tids_count = %u\n",
-				priv->agg_tids_count);
-		}
 		if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 			return 0;
 		else
@@ -3376,7 +3365,6 @@ static int iwl_init_drv(struct iwl_priv *priv)
 	priv->iw_mode = NL80211_IFTYPE_STATION;
 	priv->current_ht_config.smps = IEEE80211_SMPS_STATIC;
 	priv->missed_beacon_threshold = IWL_MISSED_BEACON_THRESHOLD_DEF;
-	priv->agg_tids_count = 0;
 
 	/* initialize force reset */
 	priv->force_reset[IWL_RF_RESET].reset_duration =
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7914d65..ab891b9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1084,9 +1084,6 @@ struct iwl_priv {
 	/* storing the jiffies when the plcp error rate is received */
 	unsigned long plcp_jiffies;
 
-	/* reporting the number of tids has AGG on. 0 means no AGGREGATION */
-	u8 agg_tids_count;
-
 	/* force reset */
 	struct iwl_force_reset force_reset[IWL_MAX_FORCE_RESET];
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index fed554a..aba8f4c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -616,11 +616,6 @@ static void iwl_accumulative_statistics(struct iwl_priv *priv,
 
 #define REG_RECALIB_PERIOD (60)
 
-/* the threshold ratio of actual_ack_cnt to expected_ack_cnt in percent */
-#define ACK_CNT_RATIO (50)
-#define BA_TIMEOUT_CNT (5)
-#define BA_TIMEOUT_MAX (16)
-
 #define PLCP_MSG "plcp_err exceeded %u, %u, %u, %u, %u, %d, %u mSecs\n"
 void iwl_rx_statistics(struct iwl_priv *priv,
 			      struct iwl_rx_mem_buffer *rxb)
@@ -630,9 +625,6 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 	int combined_plcp_delta;
 	unsigned int plcp_msec;
 	unsigned long plcp_received_jiffies;
-	int actual_ack_cnt_delta;
-	int expected_ack_cnt_delta;
-	int ba_timeout_delta;
 
 	IWL_DEBUG_RX(priv, "Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(priv->statistics),
@@ -647,44 +639,6 @@ void iwl_rx_statistics(struct iwl_priv *priv,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	iwl_accumulative_statistics(priv, (__le32 *)&pkt->u.stats);
 #endif
-	actual_ack_cnt_delta = le32_to_cpu(pkt->u.stats.tx.actual_ack_cnt) -
-		le32_to_cpu(priv->statistics.tx.actual_ack_cnt);
-	expected_ack_cnt_delta = le32_to_cpu(
-			pkt->u.stats.tx.expected_ack_cnt) -
-		le32_to_cpu(priv->statistics.tx.expected_ack_cnt);
-	ba_timeout_delta = le32_to_cpu(
-			pkt->u.stats.tx.agg.ba_timeout) -
-		le32_to_cpu(priv->statistics.tx.agg.ba_timeout);
-	if ((priv->agg_tids_count > 0) &&
-		(expected_ack_cnt_delta > 0) &&
-		(((actual_ack_cnt_delta * 100) / expected_ack_cnt_delta) <
-			ACK_CNT_RATIO) &&
-		(ba_timeout_delta > BA_TIMEOUT_CNT)) {
-		IWL_DEBUG_RADIO(priv,
-			"actual_ack_cnt delta = %d, expected_ack_cnt = %d\n",
-			actual_ack_cnt_delta, expected_ack_cnt_delta);
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-		IWL_DEBUG_RADIO(priv, "rx_detected_cnt delta = %d\n",
-			priv->delta_statistics.tx.rx_detected_cnt);
-		IWL_DEBUG_RADIO(priv,
-			"ack_or_ba_timeout_collision delta = %d\n",
-			priv->delta_statistics.tx.ack_or_ba_timeout_collision);
-#endif
-		IWL_DEBUG_RADIO(priv, "agg ba_timeout delta = %d\n",
-			ba_timeout_delta);
-		if ((actual_ack_cnt_delta == 0) &&
-			(ba_timeout_delta >=
-				BA_TIMEOUT_MAX)) {
-			IWL_DEBUG_RADIO(priv,
-				"call iwl_force_reset(IWL_FW_RESET)\n");
-			iwl_force_reset(priv, IWL_FW_RESET);
-		} else {
-			IWL_DEBUG_RADIO(priv,
-				"call iwl_force_reset(IWL_RF_RESET)\n");
-			iwl_force_reset(priv, IWL_RF_RESET);
-		}
-	}
 	/*
 	 * check for plcp_err and trigger radio reset if it exceeds
 	 * the plcp error threshold plcp_delta.
-- 
1.6.3.3

