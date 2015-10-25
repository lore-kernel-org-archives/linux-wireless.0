Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7815 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbbJYJAE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 05:00:04 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 04/10] mac80211: call drv_stop only if driver is started
Date: Sun, 25 Oct 2015 10:59:36 +0200
Message-Id: <1445763582-11421-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_100035_528472_249F3A30)
In-Reply-To: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

If drv_start() fails during hw_restart, all the running
interfaces are being closed/stopped, which results in
drv_stop() being called, although the driver was never
started successfully.

This might cause drivers to perform operations on uninitialized
memory (as they assume it was initialized on drv_start)

Consider the local->started flag, and call the driver's stop()
op only if drv_start() succeeded before.

Move drv_start() and drv_stop() to driver-ops.c, as they are no
longer simple wrappers.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/driver-ops.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/driver-ops.h | 32 ++------------------------------
 net/mac80211/util.c       |  3 ++-
 3 files changed, 48 insertions(+), 31 deletions(-)

diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index a1d5431..9f97343 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -1,4 +1,6 @@
 /*
+ * Copyright 2015 Intel Deutschland GmbH
+ *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
@@ -8,6 +10,48 @@
 #include "trace.h"
 #include "driver-ops.h"
 
+int drv_start(struct ieee80211_local *local)
+{
+	int ret;
+
+	might_sleep();
+
+	if (WARN_ON(local->started))
+		return -EALREADY;
+
+	trace_drv_start(local);
+	local->started = true;
+	/* allow rx frames */
+	smp_mb();
+	ret = local->ops->start(&local->hw);
+	trace_drv_return_int(local, ret);
+
+	if (ret)
+		local->started = false;
+
+	return ret;
+}
+
+void drv_stop(struct ieee80211_local *local)
+{
+	might_sleep();
+
+	if (WARN_ON(!local->started))
+		return;
+
+	trace_drv_stop(local);
+	local->ops->stop(&local->hw);
+	trace_drv_return_void(local);
+
+	/* sync away all work on the tasklet before clearing started */
+	tasklet_disable(&local->tasklet);
+	tasklet_enable(&local->tasklet);
+
+	barrier();
+
+	local->started = false;
+}
+
 int drv_add_interface(struct ieee80211_local *local,
 		      struct ieee80211_sub_if_data *sdata)
 {
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 3098709..f82cfab 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -66,36 +66,8 @@ static inline int drv_get_et_sset_count(struct ieee80211_sub_if_data *sdata,
 	return rv;
 }
 
-static inline int drv_start(struct ieee80211_local *local)
-{
-	int ret;
-
-	might_sleep();
-
-	trace_drv_start(local);
-	local->started = true;
-	smp_mb();
-	ret = local->ops->start(&local->hw);
-	trace_drv_return_int(local, ret);
-	return ret;
-}
-
-static inline void drv_stop(struct ieee80211_local *local)
-{
-	might_sleep();
-
-	trace_drv_stop(local);
-	local->ops->stop(&local->hw);
-	trace_drv_return_void(local);
-
-	/* sync away all work on the tasklet before clearing started */
-	tasklet_disable(&local->tasklet);
-	tasklet_enable(&local->tasklet);
-
-	barrier();
-
-	local->started = false;
-}
+int drv_start(struct ieee80211_local *local);
+void drv_stop(struct ieee80211_local *local);
 
 #ifdef CONFIG_PM
 static inline int drv_suspend(struct ieee80211_local *local,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e936acd..c51ff91 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1665,7 +1665,6 @@ static void ieee80211_handle_reconfig_failure(struct ieee80211_local *local)
 
 	local->resuming = false;
 	local->suspended = false;
-	local->started = false;
 	local->in_reconfig = false;
 
 	/* scheduled scan clearly can't be running any more, but tell
@@ -1764,6 +1763,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	if (suspended && local->in_reconfig && !reconfig_due_to_wowlan)
 		cancel_work_sync(&local->restart_work);
 
+	local->started = false;
+
 	/*
 	 * Upon resume hardware can sometimes be goofy due to
 	 * various platform / driver / bus issues, so restarting
-- 
2.1.4

