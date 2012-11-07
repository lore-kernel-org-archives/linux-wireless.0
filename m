Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45182 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2KGNYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 08:24:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/3] mac80211: call driver method when restart completes
Date: Wed,  7 Nov 2012 14:24:42 +0100
Message-Id: <1352294684-19266-2-git-send-email-johannes@sipsolutions.net> (sfid-20121107_142423_809095_AB9D5DE1)
In-Reply-To: <1352294684-19266-1-git-send-email-johannes@sipsolutions.net>
References: <1352294684-19266-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the driver requests a restart (reconfiguration) it
gets all the normal method calls, but can't really tell
why they're happening. Call a new restart_complete op
in the driver when the restart completes, so it could
keep its own state about the restart and clear it there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h    |  6 ++++++
 net/mac80211/driver-ops.h | 10 ++++++++++
 net/mac80211/trace.h      |  5 +++++
 net/mac80211/util.c       |  4 +++-
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 23803ad..e1d8309 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2400,6 +2400,10 @@ enum ieee80211_rate_control_changed {
  *	just "paused" for scanning/ROC, which is indicated by the beacon being
  *	disabled/enabled via @bss_info_changed.
  * @stop_ap: Stop operation on the AP interface.
+ *
+ * @restart_complete: Called after a call to ieee80211_restart_hw(), when the
+ *	reconfiguration has completed. This can help the driver implement the
+ *	reconfiguration step. This callback may sleep.
  */
 struct ieee80211_ops {
 	void (*tx)(struct ieee80211_hw *hw,
@@ -2561,6 +2565,8 @@ struct ieee80211_ops {
 	void (*unassign_vif_chanctx)(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_chanctx_conf *ctx);
+
+	void (*restart_complete)(struct ieee80211_hw *hw);
 };
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 1701ad7..4dc2577 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -961,4 +961,14 @@ static inline void drv_stop_ap(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline void drv_restart_complete(struct ieee80211_local *local)
+{
+	might_sleep();
+
+	trace_drv_restart_complete(local);
+	if (local->ops->restart_complete)
+		local->ops->restart_complete(&local->hw);
+	trace_drv_return_void(local);
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 7794e53..8b91a9f 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1439,6 +1439,11 @@ DEFINE_EVENT(local_sdata_evt, drv_stop_ap,
 	TP_ARGS(local, sdata)
 );
 
+DEFINE_EVENT(local_only_evt, drv_restart_complete,
+	TP_PROTO(struct ieee80211_local *local),
+	TP_ARGS(local)
+);
+
 /*
  * Tracing for API calls that drivers call.
  */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index d94a9d4..ce6a233 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1606,8 +1606,10 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	 * If this is for hw restart things are still running.
 	 * We may want to change that later, however.
 	 */
-	if (!local->suspended)
+	if (!local->suspended) {
+		drv_restart_complete(local);
 		return 0;
+	}
 
 #ifdef CONFIG_PM
 	/* first set suspended false, then resuming */
-- 
1.8.0

