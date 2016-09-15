Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50982 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759340AbcIOIJP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 04:09:15 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: reject TSPEC TIDs (TSIDs) for aggregation
Date: Thu, 15 Sep 2016 10:09:10 +0200
Message-Id: <1473926950-19648-1-git-send-email-johannes@sipsolutions.net> (sfid-20160915_100920_733483_8D8E803B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since mac80211 doesn't currently support TSIDs 8-15 which can
only be used after QoS TSPEC negotiation (and not even after
WMM negotiation), reject attempts to set up aggregation
sessions for them, which might confuse drivers. In mac80211
we do correctly handle that, but the TSIDs should never get
used anyway, and drivers might not be able to handle it.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-rx.c | 8 +++++++-
 net/mac80211/agg-tx.c | 3 +++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index a9aff6079c42..afa94687d5e1 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -261,10 +261,16 @@ void __ieee80211_start_rx_ba_session(struct sta_info *sta,
 		.timeout = timeout,
 		.ssn = start_seq_num,
 	};
-
 	int i, ret = -EOPNOTSUPP;
 	u16 status = WLAN_STATUS_REQUEST_DECLINED;
 
+	if (tid >= IEEE80211_FIRST_TSPEC_TSID) {
+		ht_dbg(sta->sdata,
+		       "STA %pM requests BA session on unsupported tid %d\n",
+		       sta->sta.addr, tid);
+		goto end_no_lock;
+	}
+
 	if (!sta->sta.ht_cap.ht_supported) {
 		ht_dbg(sta->sdata,
 		       "STA %pM erroneously requests BA session on tid %d w/o QoS\n",
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 5650c46bf91a..45319cc01121 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -584,6 +584,9 @@ int ieee80211_start_tx_ba_session(struct ieee80211_sta *pubsta, u16 tid,
 	    ieee80211_hw_check(&local->hw, TX_AMPDU_SETUP_IN_HW))
 		return -EINVAL;
 
+	if (WARN_ON(tid >= IEEE80211_FIRST_TSPEC_TSID))
+		return -EINVAL;
+
 	ht_dbg(sdata, "Open BA session requested for %pM tid %u\n",
 	       pubsta->addr, tid);
 
-- 
2.8.1
