Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44218 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932742Ab0BCRc0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2010 12:32:26 -0500
From: <wey-yi.w.guy@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH v3 1/1] mac80211: tear down all agg queues when restart/reconfig hw
Date: Wed,  3 Feb 2010 09:28:55 -0800
Message-Id: <1265218135-11434-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When there is a need to restart/reconfig hw, tear down all the
aggregation queues and let the mac80211 and driver get in-sync to have
the opportunity to re-establish the aggregation queues again.

Need to wait until driver re-establish all the station information before tear
down the aggregation queues, driver(at least iwlwifi driver) will reject the 
stop aggregation queue request if station is not ready. But also need to make
sure the aggregation queues are tear down before waking up the queues, so 
mac80211 will not sending frames with aggregation bit set.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
v2: add rcu_read_lock()
v3: move the tear_down function before wake_queues.
---
 net/mac80211/util.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index ca170b4..6c10094 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1180,6 +1180,14 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		}
 	}
 
+	rcu_read_lock();
+	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
+		list_for_each_entry_rcu(sta, &local->sta_list, list) {
+			ieee80211_sta_tear_down_BA_sessions(sta);
+		}
+	}
+	rcu_read_unlock();
+
 	/* add back keys */
 	list_for_each_entry(sdata, &local->interfaces, list)
 		if (ieee80211_sdata_running(sdata))
-- 
1.5.6.3

