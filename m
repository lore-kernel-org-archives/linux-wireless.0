Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7087 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab0BCA4S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2010 19:56:18 -0500
From: <wey-yi.w.guy@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/1] mac80211: tear down all agg queues when restart/reconfig hw
Date: Tue,  2 Feb 2010 16:52:50 -0800
Message-Id: <1265158370-14797-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When there is a need to restart/reconfig hw, tear down all the
aggregation queues and let the mac80211 and driver get in-sync and have
the opportunity to re-establish the aggregation queues.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 net/mac80211/util.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ca170b4..6116ad0 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1188,6 +1188,11 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	ieee80211_wake_queues_by_reason(hw,
 			IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
+	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
+		list_for_each_entry_rcu(sta, &local->sta_list, list) {
+			ieee80211_sta_tear_down_BA_sessions(sta);
+		}
+	}
 	/*
 	 * If this is for hw restart things are still running.
 	 * We may want to change that later, however.
-- 
1.5.6.3

