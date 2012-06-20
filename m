Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46186 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab2FTSRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 14:17:38 -0400
Message-ID: <1340216254.19321.2.camel@jlt3.sipsolutions.net> (sfid-20120620_201742_007771_5AD03DC8)
Subject: [PATCH] mac80211: fix double-start of remain-on-channel
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: eliad <eliad@wizery.com>
Date: Wed, 20 Jun 2012 20:17:34 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a remain-on-channel item is deleted, we remove it
from the list and then start the next item. However,
if it wasn't actually the first item then calling
ieee80211_start_next_roc() is wrong as it will start
the first item -- even if that was already started.

Fix the two places that do this and add a warning to
prevent the problem from reoccurring.

Reported-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c        |    3 ++-
 net/mac80211/offchannel.c |    6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a6abcd4..03aff23 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2362,7 +2362,8 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 
 		list_del(&found->list);
 
-		ieee80211_start_next_roc(local);
+		if (found->started)
+			ieee80211_start_next_roc(local);
 		mutex_unlock(&local->mtx);
 
 		ieee80211_roc_notify_destroy(found);
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index febce7f..7f93626 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -262,6 +262,9 @@ void ieee80211_start_next_roc(struct ieee80211_local *local)
 	roc = list_first_entry(&local->roc_list, struct ieee80211_roc_work,
 			       list);
 
+	if (WARN_ON_ONCE(roc->started))
+		return;
+
 	if (local->ops->remain_on_channel) {
 		int ret, duration = roc->duration;
 
@@ -377,7 +380,8 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 
 		ieee80211_recalc_idle(local);
 
-		ieee80211_start_next_roc(local);
+		if (roc->started)
+			ieee80211_start_next_roc(local);
 	}
 
  out_unlock:
-- 
1.7.10



