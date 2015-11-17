Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:52992 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670AbbKQIYw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 03:24:52 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Gregory Greenman <gregory.greenman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 6/8] mac80211: always set the buf_size in AddBA req to 64
Date: Tue, 17 Nov 2015 10:24:38 +0200
Message-Id: <1447748680-23075-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151117_092509_817970_62315733)
In-Reply-To: <1447748680-23075-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1447748680-23075-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

Advertising reordering window in ADDBA less than 64 can crash some APs,
an example is LinkSys WRT120N (with FW v1.0.07 build 002 Jun 18 2012).
On the other hand, a driver may need to limit Tx A-MPDU size for its own
reasons, like specific HW limitations.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 6 ++++--
 net/mac80211/agg-tx.c  | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index bcb7022..a68051c 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2009,8 +2009,10 @@ enum ieee80211_hw_flags {
  *	it shouldn't be set.
  *
  * @max_tx_aggregation_subframes: maximum number of subframes in an
- *	aggregate an HT driver will transmit, used by the peer as a
- *	hint to size its reorder buffer.
+ *	aggregate an HT driver will transmit. Though ADDBA will advertise
+ *	a constant value of 64 as some older APs can crash if the window
+ *	size is smaller (an example is LinkSys WRT120N with FW v1.0.07
+ *	build 002 Jun 18 2012).
  *
  * @offchannel_tx_hw_queue: HW queue ID to use for offchannel TX
  *	(if %IEEE80211_HW_QUEUE_CONTROL is set)
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index a758eb84..ff75718 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -500,7 +500,7 @@ void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid)
 	/* send AddBA request */
 	ieee80211_send_addba_request(sdata, sta->sta.addr, tid,
 				     tid_tx->dialog_token, start_seq_num,
-				     local->hw.max_tx_aggregation_subframes,
+				     IEEE80211_MAX_AMPDU_BUF,
 				     tid_tx->timeout);
 }
 
@@ -926,6 +926,7 @@ void ieee80211_process_addba_resp(struct ieee80211_local *local,
 	amsdu = capab & IEEE80211_ADDBA_PARAM_AMSDU_MASK;
 	tid = (capab & IEEE80211_ADDBA_PARAM_TID_MASK) >> 2;
 	buf_size = (capab & IEEE80211_ADDBA_PARAM_BUF_SIZE_MASK) >> 6;
+	buf_size = min(buf_size, local->hw.max_tx_aggregation_subframes);
 
 	mutex_lock(&sta->ampdu_mlme.mtx);
 
-- 
2.5.0

