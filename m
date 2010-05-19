Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34631 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab0ESGHK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 02:07:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 18 May 2010 23:07:10 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19443.32502.791626.492686@gargle.gargle.HOWL>
Date: Wed, 19 May 2010 11:32:30 +0530
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Remove deprecated sta_notify commands
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

STA_NOTIFY_ADD and STA_NOTIFY_REMOVE have no users anymore,
and station addition/removal are indicated to drivers
using sta_add() and sta_remove(), which can sleep.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 include/net/mac80211.h    |    6 +-----
 net/mac80211/driver-ops.h |    6 ------
 2 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 389e86a..981d9b4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -881,16 +881,12 @@ struct ieee80211_sta {
  * enum sta_notify_cmd - sta notify command
  *
  * Used with the sta_notify() callback in &struct ieee80211_ops, this
- * indicates addition and removal of a station to station table,
- * or if a associated station made a power state transition.
+ * indicates if an associated station made a power state transition.
  *
- * @STA_NOTIFY_ADD: (DEPRECATED) a station was added to the station table
- * @STA_NOTIFY_REMOVE: (DEPRECATED) a station being removed from the station table
  * @STA_NOTIFY_SLEEP: a station is now sleeping
  * @STA_NOTIFY_AWAKE: a sleeping station woke up
  */
 enum sta_notify_cmd {
-	STA_NOTIFY_ADD, STA_NOTIFY_REMOVE,
 	STA_NOTIFY_SLEEP, STA_NOTIFY_AWAKE,
 };
 
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 5662bb5..14a3b3c 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -254,9 +254,6 @@ static inline int drv_sta_add(struct ieee80211_local *local,
 
 	if (local->ops->sta_add)
 		ret = local->ops->sta_add(&local->hw, &sdata->vif, sta);
-	else if (local->ops->sta_notify)
-		local->ops->sta_notify(&local->hw, &sdata->vif,
-					STA_NOTIFY_ADD, sta);
 
 	trace_drv_sta_add(local, sdata, sta, ret);
 
@@ -271,9 +268,6 @@ static inline void drv_sta_remove(struct ieee80211_local *local,
 
 	if (local->ops->sta_remove)
 		local->ops->sta_remove(&local->hw, &sdata->vif, sta);
-	else if (local->ops->sta_notify)
-		local->ops->sta_notify(&local->hw, &sdata->vif,
-					STA_NOTIFY_REMOVE, sta);
 
 	trace_drv_sta_remove(local, sdata, sta);
 }
-- 
1.7.1

