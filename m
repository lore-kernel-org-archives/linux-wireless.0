Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:34511 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbYAPSlK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 13:41:10 -0500
From: Ron Rindjunsky <ron.rindjunsky@intel.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [RFC PATCH 11/12 v2] iwlwifi: A-MPDU Tx conform block Ack rate scaling to mac80211
Date: Wed, 16 Jan 2008 20:40:59 +0200
Message-Id: <12005088653597-git-send-email-ron.rindjunsky@intel.com> (sfid-20080116_184123_382585_FE223608)
In-Reply-To: <1200508860699-git-send-email-ron.rindjunsky@intel.com>
References: <1200508860699-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch uses the changes in ieee80211_tx_status to pass Block Ack data
to rate scaling module, and uses this data in rate scaling calculations

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   85 +++++++++++++++++++---------
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    9 +--
 2 files changed, 60 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
index 4cb10bd..eda0f4d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
@@ -277,7 +277,8 @@ static void rs_rate_scale_clear_window(struct iwl4965_rate_scale_data *window)
  * packets.
  */
 static int rs_collect_tx_data(struct iwl4965_rate_scale_data *windows,
-			      int scale_index, s32 tpt, u32 status)
+			      int scale_index, s32 tpt, int retries,
+			      int successes)
 {
 	struct iwl4965_rate_scale_data *window = NULL;
 	u64 mask;
@@ -298,26 +299,33 @@ static int rs_collect_tx_data(struct iwl4965_rate_scale_data *windows,
 	 * subtract "1" from the success counter (this is the main reason
 	 * we keep these bitmaps!).
 	 */
-	if (window->counter >= win_size) {
-		window->counter = win_size - 1;
-		mask = 1;
-		mask = (mask << (win_size - 1));
-		if ((window->data & mask)) {
-			window->data &= ~mask;
-			window->success_counter = window->success_counter - 1;
+	while (retries > 0) {
+		if (window->counter >= win_size) {
+			window->counter = win_size - 1;
+			mask = 1;
+			mask = (mask << (win_size - 1));
+			if (window->data & mask) {
+				window->data &= ~mask;
+				window->success_counter =
+					window->success_counter - 1;
+			}
 		}
-	}
 
-	/* Increment frames-attempted counter */
-	window->counter = window->counter + 1;
+		/* Increment frames-attempted counter */
+		window->counter++;
+
+		/* Shift bitmap by one frame (throw away oldest history),
+		 * OR in "1", and increment "success" if this
+		 * frame was successful. */
+		mask = window->data;
+		window->data = (mask << 1);
+		if (successes > 0) {
+			window->success_counter = window->success_counter + 1;
+			window->data |= 0x1;
+			successes--;
+		}
 
-	/* Shift bitmap by one frame (throw away oldest history),
-	 * OR in "1", and increment "success" if this frame was successful. */
-	mask = window->data;
-	window->data = (mask << 1);
-	if (status != 0) {
-		window->success_counter = window->success_counter + 1;
-		window->data |= 0x1;
+		retries--;
 	}
 
 	/* Calculate current success ratio, avoid divide-by-0! */
@@ -677,6 +685,11 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1))
 		return;
 
+	/* This packet was aggregated but doesn't carry rate scale info */
+	if ((tx_resp->control.flags & IEEE80211_TXCTL_AMPDU) &&
+	    !(tx_resp->flags & IEEE80211_TX_STATUS_AMPDU))
+		return;
+
 	retries = tx_resp->retry_count;
 
 	if (retries > 15)
@@ -766,7 +779,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 				tpt = search_tbl->expected_tpt[rs_index];
 			else
 				tpt = 0;
-			rs_collect_tx_data(search_win, rs_index, tpt, 0);
+			rs_collect_tx_data(search_win, rs_index, tpt, 1, 0);
 
 		/* Else if type matches "current/active" table,
 		 * add failure to "current/active" history */
@@ -777,7 +790,7 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 				tpt = curr_tbl->expected_tpt[rs_index];
 			else
 				tpt = 0;
-			rs_collect_tx_data(window, rs_index, tpt, 0);
+			rs_collect_tx_data(window, rs_index, tpt, 1, 0);
 		}
 
 		/* If not searching for a new mode, increment failed counter
@@ -818,9 +831,13 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 			tpt = search_tbl->expected_tpt[rs_index];
 		else
 			tpt = 0;
-		rs_collect_tx_data(search_win,
-				    rs_index, tpt, status);
-
+		if (tx_resp->control.flags & IEEE80211_TXCTL_AMPDU)
+			rs_collect_tx_data(search_win, rs_index, tpt,
+					   tx_resp->ampdu_ack_len,
+					   tx_resp->ampdu_ack_map);
+		else
+			rs_collect_tx_data(search_win, rs_index, tpt,
+					   1, status);
 	/* Else if type matches "current/active" table,
 	 * add final tx status to "current/active" history */
 	} else if ((tbl_type.lq_type == curr_tbl->lq_type) &&
@@ -830,16 +847,28 @@ static void rs_tx_status(void *priv_rate, struct net_device *dev,
 			tpt = curr_tbl->expected_tpt[rs_index];
 		else
 			tpt = 0;
-		rs_collect_tx_data(window, rs_index, tpt, status);
+		if (tx_resp->control.flags & IEEE80211_TXCTL_AMPDU)
+			rs_collect_tx_data(window, rs_index, tpt,
+					   tx_resp->ampdu_ack_len,
+					   tx_resp->ampdu_ack_map);
+		else
+			rs_collect_tx_data(window, rs_index, tpt,
+					   1, status);
 	}
 
 	/* If not searching for new mode, increment success/failed counter
 	 * ... these help determine when to start searching again */
 	if (lq_sta->stay_in_tbl) {
-		if (status)
-			lq_sta->total_success++;
-		else
-			lq_sta->total_failed++;
+		if (tx_resp->control.flags & IEEE80211_TXCTL_AMPDU) {
+			lq_sta->total_success += tx_resp->ampdu_ack_map;
+			lq_sta->total_failed +=
+			     (tx_resp->ampdu_ack_len - tx_resp->ampdu_ack_map);
+		} else {
+			if (status)
+				lq_sta->total_success++;
+			else
+				lq_sta->total_failed++;
+		}
 	}
 
 	/* See if there's a better rate or modulation mode to try. */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 347f525..a870385 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -4288,12 +4288,9 @@ static int iwl4965_tx_status_reply_compressed_ba(struct iwl4965_priv *priv,
 
 	tx_status = &priv->txq[scd_flow].txb[agg->start_idx].status;
 	tx_status->flags = IEEE80211_TX_STATUS_ACK;
-	tx_status->retry_count++;
-#ifdef CONFIG_IWL4965_HT_AGG
-	tx_status->flags |= IEEE80211_TX_STATUS_AGG_STATS;
-	tx_status->successes = successes;
-	tx_status->frame_count = agg->frame_count;
-#endif	/* CONFIG_IWL4965_HT_AGG */
+	tx_status->flags |= IEEE80211_TX_STATUS_AMPDU;
+	tx_status->ampdu_ack_map = successes;
+	tx_status->ampdu_ack_len = agg->frame_count;
 	tx_status->control.tx_rate = agg->rate_n_flags;
 
 	IWL_DEBUG_TX_REPLY("Bitmap %llx\n", bitmap);
-- 
1.5.3.3

