Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31025 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbaFEQ3p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 12:29:45 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/3] mac80211: don't stop all queues when flushing
Date: Thu,  5 Jun 2014 19:26:05 +0300
Message-Id: <1401985567-27336-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140605_182948_422755_5F5B7445)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

There is no need to stop all queues when we want to flush specific
queues, so stop only the queues that will be flushed.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 6886601..6d29e40 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -551,12 +551,12 @@ void ieee80211_flush_queues(struct ieee80211_local *local,
 		queues = BIT(local->hw.queues) - 1;
 	}
 
-	ieee80211_stop_queues_by_reason(&local->hw, IEEE80211_MAX_QUEUE_MAP,
+	ieee80211_stop_queues_by_reason(&local->hw, queues,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH);
 
 	drv_flush(local, sdata, queues, false);
 
-	ieee80211_wake_queues_by_reason(&local->hw, IEEE80211_MAX_QUEUE_MAP,
+	ieee80211_wake_queues_by_reason(&local->hw, queues,
 					IEEE80211_QUEUE_STOP_REASON_FLUSH);
 }
 
-- 
1.9.1

