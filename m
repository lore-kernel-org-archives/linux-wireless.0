Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45407 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab0EZPT3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 11:19:29 -0400
Subject: [PATCH] mac80211: remove tx status ampdu_ack_map
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 17:19:25 +0200
Message-ID: <1274887165.3658.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's a single use of this struct member, but
as it is write-only it clearly not necessary.
Thus we can free up some space here, even if we
don't need it right now it seems pointless to
carry around the variable.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |    1 -
 include/net/mac80211.h                    |    5 +----
 2 files changed, 1 insertion(+), 5 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2010-05-26 17:16:01.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-agn-tx.c	2010-05-26 17:16:05.000000000 +0200
@@ -1231,7 +1231,6 @@ static int iwlagn_tx_status_reply_compre
 	info->flags |= IEEE80211_TX_STAT_ACK;
 	info->flags |= IEEE80211_TX_STAT_AMPDU;
 	info->status.ampdu_ack_len = successes;
-	info->status.ampdu_ack_map = bitmap;
 	info->status.ampdu_len = agg->frame_count;
 	iwlagn_hwrate_to_tx_control(priv, agg->rate_n_flags, info);
 
--- wireless-testing.orig/include/net/mac80211.h	2010-05-26 17:15:29.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2010-05-26 17:15:56.000000000 +0200
@@ -412,8 +412,6 @@ struct ieee80211_tx_rate {
  * @driver_data: array of driver_data pointers
  * @ampdu_ack_len: number of acked aggregated frames.
  * 	relevant only if IEEE80211_TX_STAT_AMPDU was set.
- * @ampdu_ack_map: block ack bit map for the aggregation.
- * 	relevant only if IEEE80211_TX_STAT_AMPDU was set.
  * @ampdu_len: number of aggregated frames.
  * 	relevant only if IEEE80211_TX_STAT_AMPDU was set.
  * @ack_signal: signal strength of the ACK frame
@@ -448,10 +446,9 @@ struct ieee80211_tx_info {
 		struct {
 			struct ieee80211_tx_rate rates[IEEE80211_TX_MAX_RATES];
 			u8 ampdu_ack_len;
-			u64 ampdu_ack_map;
 			int ack_signal;
 			u8 ampdu_len;
-			/* 7 bytes free */
+			/* 15 bytes free */
 		} status;
 		struct {
 			struct ieee80211_tx_rate driver_rates[


