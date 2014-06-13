Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:60191 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752447AbaFMNaX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 09:30:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net, michal.kazior@tieto.com
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Fri, 13 Jun 2014 16:30:04 +0300
Message-Id: <1402666207-2257-2-git-send-email-luca@coelho.fi> (sfid-20140613_153050_157764_281EBD7B)
In-Reply-To: <1402666207-2257-1-git-send-email-luca@coelho.fi>
References: <1402666207-2257-1-git-send-email-luca@coelho.fi>
Subject: [PATCH v2 1/4] mac80211: don't stop all queues when flushing
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

There is no need to stop all queues when we want to flush specific
queues, so stop only the queues that will be flushed.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7e0dd4b..04e5f5c 100644
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
2.0.0.rc2

