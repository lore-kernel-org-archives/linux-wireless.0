Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53028 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751835AbdFUXu0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 19:50:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/6] mac80211: agg-tx: call drv_wake_tx_queue in proper context
Date: Thu, 22 Jun 2017 01:50:17 +0200
Message-Id: <20170621235022.25362-1-johannes@sipsolutions.net> (sfid-20170622_015031_101372_B49F3704)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since drv_wake_tx_queue() is normally called in the TX path, which
is already in an RCU critical section, we should call it the same
way in the aggregation code path, so if the driver expects to be
able to use RCU, it'll already be protected without having to enter
a nested critical section.

Additionally, disable soft-IRQs, since not doing so could cause
issues in a driver that relies on them already being disabled like
in the other path.

Fixes: ba8c3d6f16a1 ("mac80211: add an intermediate software queue implementation")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/agg-tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index cbd48762256c..4f9dd3e59091 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -226,7 +226,11 @@ ieee80211_agg_start_txq(struct sta_info *sta, int tid, bool enable)
 		clear_bit(IEEE80211_TXQ_AMPDU, &txqi->flags);
 
 	clear_bit(IEEE80211_TXQ_STOP, &txqi->flags);
+	local_bh_disable();
+	rcu_read_lock();
 	drv_wake_tx_queue(sta->sdata->local, txqi);
+	rcu_read_unlock();
+	local_bh_enable();
 }
 
 /*
-- 
2.11.0
