Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56073 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965775Ab3DQJmO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 05:42:14 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix station entry leak/warning while suspending
Date: Wed, 17 Apr 2013 11:42:07 +0200
Message-Id: <1366191727-12395-1-git-send-email-johannes@sipsolutions.net> (sfid-20130417_114220_627188_D0004181)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since Stanislaw's patches, when suspending while connected,
cfg80211 will disconnect. This causes the AP station to be
removed, which uses call_rcu() to clean up. Due to needing
process context, this queues a work struct on the mac80211
workqueue. This will warn and fail when already suspended,
which can happen if the rcu call doesn't happen quickly.

To fix this, replace the synchronize_net() which is really
just synchronize_rcu_expedited() with rcu_barrier(), which
unlike synchronize_rcu() waits until RCU callback have run
and thus avoids this issue.

In theory, this can even happen without Stanislaw's change
to disconnect on suspend since userspace might disconnect
just before suspending, though then it's unlikely that the
call_rcu() will be delayed long enough.

Cc: stable@vger.kernel.org [3.7+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/pm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index d1c021b..4431f0f 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -37,8 +37,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 					IEEE80211_MAX_QUEUE_MAP,
 					IEEE80211_QUEUE_STOP_REASON_SUSPEND);
 
-	/* flush out all packets */
-	synchronize_net();
+	/* flush out all packets and station cleanup call_rcu()s */
+	rcu_barrier();
 
 	ieee80211_flush_queues(local, NULL);
 
-- 
1.8.0

