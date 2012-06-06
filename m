Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537Ab2FFNWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:22:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 02/29] iwlwifi: handle race condition in ROC flow
Date: Wed,  6 Jun 2012 15:21:43 +0200
Message-Id: <1338988930-11561-2-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152236_574362_12A0940B)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

When a remain on channel request from mac80211 is followed by
a request to tx a mgmt frame offchannel, it is possible that
the remain on channel expires before the device reported the
tx status for the frame. This causes a race condition in
mac80211.

To fix this, delay the ROC notification to mac80211 until the
device reported the Tx status for all frames in the aux queue.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   18 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    3 ++
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    5 +++
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    1 +
 drivers/net/wireless/iwlwifi/iwl-scan.c   |   51 +++++++++++++++++++++++------
 5 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 3366e2e..ad1d36f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -486,6 +486,9 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	if (sta_priv && sta_priv->client && !is_agg)
 		atomic_inc(&sta_priv->pending_frames);
 
+	if (info->flags & IEEE80211_TX_CTL_TX_OFFCHAN)
+		iwl_scan_offchannel_skb(priv);
+
 	return 0;
 
 drop_unlock_sta:
@@ -1136,6 +1139,7 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 	struct sk_buff *skb;
 	struct iwl_rxon_context *ctx;
 	bool is_agg = (txq_id >= IWLAGN_FIRST_AMPDU_QUEUE);
+	bool is_offchannel_skb;
 
 	tid = (tx_resp->ra_tid & IWLAGN_TX_RES_TID_MSK) >>
 		IWLAGN_TX_RES_TID_POS;
@@ -1149,6 +1153,8 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 
 	__skb_queue_head_init(&skbs);
 
+	is_offchannel_skb = false;
+
 	if (tx_resp->frame_count == 1) {
 		u16 next_reclaimed = le16_to_cpu(tx_resp->seq_ctl);
 		next_reclaimed = SEQ_TO_SN(next_reclaimed + 0x10);
@@ -1225,10 +1231,19 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			if (!is_agg)
 				iwlagn_non_agg_tx_status(priv, ctx, hdr->addr1);
 
+			is_offchannel_skb =
+				(info->flags & IEEE80211_TX_CTL_TX_OFFCHAN);
 			freed++;
 		}
 
 		WARN_ON(!is_agg && freed != 1);
+
+		/*
+		 * An offchannel frame can be send only on the AUX queue, where
+		 * there is no aggregation (and reordering) so it only is single
+		 * skb is expected to be processed.
+		 */
+		WARN_ON(is_offchannel_skb && freed != 1);
 	}
 
 	iwl_check_abort_status(priv, tx_resp->frame_count, status);
@@ -1239,6 +1254,9 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 		ieee80211_tx_status(priv->hw, skb);
 	}
 
+	if (is_offchannel_skb)
+		iwl_scan_offchannel_skb_status(priv);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 5149e6f..cd95a240 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -931,6 +931,9 @@ void iwl_down(struct iwl_priv *priv)
 	priv->ucode_loaded = false;
 	iwl_trans_stop_device(priv->trans);
 
+	/* Set num_aux_in_flight must be done after the transport is stopped */
+	atomic_set(&priv->num_aux_in_flight, 0);
+
 	/* Clear out all status bits but a few that are stable across reset */
 	priv->status &= test_bit(STATUS_RF_KILL_HW, &priv->status) <<
 				STATUS_RF_KILL_HW |
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 79c0fe0..5c1693f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -101,6 +101,7 @@ extern struct iwl_lib_ops iwl6030_lib;
 #define STATUS_CHANNEL_SWITCH_PENDING 11
 #define STATUS_SCAN_COMPLETE	12
 #define STATUS_POWER_PMI	13
+#define STATUS_SCAN_ROC_EXPIRED 14
 
 struct iwl_ucode_capabilities;
 
@@ -255,6 +256,10 @@ int __must_check iwl_scan_initiate(struct iwl_priv *priv,
 				   enum iwl_scan_type scan_type,
 				   enum ieee80211_band band);
 
+void iwl_scan_roc_expired(struct iwl_priv *priv);
+void iwl_scan_offchannel_skb(struct iwl_priv *priv);
+void iwl_scan_offchannel_skb_status(struct iwl_priv *priv);
+
 /* For faster active scanning, scan will move to the next channel if fewer than
  * PLCP_QUIET_THRESH packets are heard on this channel within
  * ACTIVE_QUIET_TIME after sending probe request.  This shortens the dwell
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 7006237..a4936a1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -846,6 +846,7 @@ struct iwl_priv {
 	struct iwl_station_entry stations[IWLAGN_STATION_COUNT];
 	unsigned long ucode_key_table;
 	struct iwl_tid_data tid_data[IWLAGN_STATION_COUNT][IWL_MAX_TID_COUNT];
+	atomic_t num_aux_in_flight;
 
 	u8 mac80211_registered;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 031d8e2..eb0ded7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -101,11 +101,8 @@ static void iwl_complete_scan(struct iwl_priv *priv, bool aborted)
 		ieee80211_scan_completed(priv->hw, aborted);
 	}
 
-	if (priv->scan_type == IWL_SCAN_ROC) {
-		ieee80211_remain_on_channel_expired(priv->hw);
-		priv->hw_roc_channel = NULL;
-		schedule_delayed_work(&priv->hw_roc_disable_work, 10 * HZ);
-	}
+	if (priv->scan_type == IWL_SCAN_ROC)
+		iwl_scan_roc_expired(priv);
 
 	priv->scan_type = IWL_SCAN_NORMAL;
 	priv->scan_vif = NULL;
@@ -134,11 +131,8 @@ static void iwl_process_scan_complete(struct iwl_priv *priv)
 		goto out_settings;
 	}
 
-	if (priv->scan_type == IWL_SCAN_ROC) {
-		ieee80211_remain_on_channel_expired(priv->hw);
-		priv->hw_roc_channel = NULL;
-		schedule_delayed_work(&priv->hw_roc_disable_work, 10 * HZ);
-	}
+	if (priv->scan_type == IWL_SCAN_ROC)
+		iwl_scan_roc_expired(priv);
 
 	if (priv->scan_type != IWL_SCAN_NORMAL && !aborted) {
 		int err;
@@ -1158,3 +1152,40 @@ void iwl_cancel_scan_deferred_work(struct iwl_priv *priv)
 		mutex_unlock(&priv->mutex);
 	}
 }
+
+void iwl_scan_roc_expired(struct iwl_priv *priv)
+{
+	/*
+	 * The status bit should be set here, to prevent a race
+	 * where the atomic_read returns 1, but before the execution continues
+	 * iwl_scan_offchannel_skb_status() checks if the status bit is set
+	 */
+	set_bit(STATUS_SCAN_ROC_EXPIRED, &priv->status);
+
+	if (atomic_read(&priv->num_aux_in_flight) == 0) {
+		ieee80211_remain_on_channel_expired(priv->hw);
+		priv->hw_roc_channel = NULL;
+		schedule_delayed_work(&priv->hw_roc_disable_work,
+				      10 * HZ);
+
+		clear_bit(STATUS_SCAN_ROC_EXPIRED, &priv->status);
+	} else {
+		IWL_DEBUG_SCAN(priv, "ROC done with %d frames in aux\n",
+			       atomic_read(&priv->num_aux_in_flight));
+	}
+}
+
+void iwl_scan_offchannel_skb(struct iwl_priv *priv)
+{
+	WARN_ON(!priv->hw_roc_start_notified);
+	atomic_inc(&priv->num_aux_in_flight);
+}
+
+void iwl_scan_offchannel_skb_status(struct iwl_priv *priv)
+{
+	if (atomic_dec_return(&priv->num_aux_in_flight) == 0 &&
+	    test_bit(STATUS_SCAN_ROC_EXPIRED, &priv->status)) {
+		IWL_DEBUG_SCAN(priv, "0 aux frames. Calling ROC expired\n");
+		iwl_scan_roc_expired(priv);
+	}
+}
-- 
1.7.10

