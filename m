Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45581 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbbC3Id7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 04:33:59 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: reject aggregation sessions with non-HT peers
Date: Mon, 30 Mar 2015 10:33:53 +0200
Message-Id: <1427704433-7391-1-git-send-email-johannes@sipsolutions.net> (sfid-20150330_103406_380131_E5FA599C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If a peer or some local agent (rate control, ...) decides to start
an aggregation session but doesn't support HT (which also implies
QoS), reject it.

This is mostly a corner case as such peers normally won't try to
use block-ack sessions and rate control wouldn't start them, but
technically QoS stations could request it according to the spec.

However, since drivers don't really support such non-HT sessions
it's better to reject them.

Also, while at it, move the tracing for TX sessions earlier so it
captures the error cases as well.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c | 8 ++++++++
 net/mac80211/agg-tx.c | 5 ++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index a48bad468880..2c090c507391 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -234,6 +234,14 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 	int i, ret = -EOPNOTSUPP;
 	u16 status = WLAN_STATUS_REQUEST_DECLINED;
 
+	if (!sta->sta.ht_cap.ht_supported) {
+		ht_dbg(sta->sdata,
+		       "STA %pM erroneously requests BA session on tid %d w/o QoS\n",
+		       sta->sta.addr, tid);
+		/* send a response anyway, it's an error case if we get here */
+		goto end_no_lock;
+	}
+
 	if (test_sta_flag(sta, WLAN_STA_BLOCK_BA)) {
 		ht_dbg(sta->sdata,
 		       "Suspend in progress - Denying ADDBA request (%pM tid %d)\n",
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 668524aeb0b2..20522492d8cc 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -509,11 +509,14 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	struct tid_ampdu_tx *tid_tx;
 	int ret = 0;
 
+	trace_api_start_tx_ba_session(pubsta, tid);
+
 	if (WARN(sta->reserved_tid == tid,
 		 "Requested to start BA session on reserved tid=%d", tid))
 		return -EINVAL;
 
-	trace_api_start_tx_ba_session(pubsta, tid);
+	if (!pubsta->ht_cap.ht_supported)
+		return -EINVAL;
 
 	if (WARN_ON_ONCE(!local->ops->ampdu_action))
 		return -EINVAL;
-- 
2.1.4

