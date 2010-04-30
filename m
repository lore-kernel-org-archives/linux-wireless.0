Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:19515 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075Ab0D3XAg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Apr 2010 19:00:36 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 6/8] iwlwifi: set AMPDU status variables correctly
Date: Fri, 30 Apr 2010 16:00:23 -0700
Message-Id: <1272668425-3753-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1272668425-3753-1-git-send-email-reinette.chatre@intel.com>
References: <1272668425-3753-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Halperin <dhalperi@cs.washington.edu>

The TX status code is currently abusing the ampdu_ack_map field (a bitmap) to
count the number of successfully received frames.  The comments in mac80211.h
show there are actually three different, relevant variables, of which we are
currently using two, both incorrectly. Fix this by making

- ampdu_ack_len -> the number of ACKed frames (i.e. successes)
- ampdu_ack_map -> the bitmap
- ampdu_len -> the total number of frames sent (i.e., attempts)

to match the header file (and verified with ath9k's usage) and updating Intel's
RS code to match.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |   10 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    5 +++--
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index 8f8d5e3..f01f242 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -867,14 +867,14 @@ static void rs_tx_status(void *priv_r, struct ieee80211_supported_band *sband,
 		rs_get_tbl_info_from_mcs(tx_rate, priv->band, &tbl_type,
 				&rs_index);
 		rs_collect_tx_data(curr_tbl, rs_index,
-				   info->status.ampdu_ack_len,
-				   info->status.ampdu_ack_map);
+				   info->status.ampdu_len,
+				   info->status.ampdu_ack_len);
 
 		/* Update success/fail counts if not searching for new mode */
 		if (lq_sta->stay_in_tbl) {
-			lq_sta->total_success += info->status.ampdu_ack_map;
-			lq_sta->total_failed += (info->status.ampdu_ack_len -
-					info->status.ampdu_ack_map);
+			lq_sta->total_success += info->status.ampdu_ack_len;
+			lq_sta->total_failed += (info->status.ampdu_len -
+					info->status.ampdu_ack_len);
 		}
 	} else {
 	/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 95e263f..c2a5c85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1233,8 +1233,9 @@ static int iwlagn_tx_status_reply_compressed_ba(struct iwl_priv *priv,
 	memset(&info->status, 0, sizeof(info->status));
 	info->flags |= IEEE80211_TX_STAT_ACK;
 	info->flags |= IEEE80211_TX_STAT_AMPDU;
-	info->status.ampdu_ack_map = successes;
-	info->status.ampdu_ack_len = agg->frame_count;
+	info->status.ampdu_ack_len = successes;
+	info->status.ampdu_ack_map = bitmap;
+	info->status.ampdu_len = agg->frame_count;
 	iwlagn_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
 
 	IWL_DEBUG_TX_REPLY(priv, "Bitmap %llx\n", (unsigned long long)bitmap);
-- 
1.6.3.3

