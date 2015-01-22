Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11494 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbbAVVcu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 16:32:50 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: avoid races related to suspend flow
Date: Thu, 22 Jan 2015 23:32:46 +0200
Message-Id: <1421962366-7015-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_223253_900967_2C22985F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we go to suspend, there is complex set of states that
avoids races. The quiescing variable is set whlie
__ieee80211_suspend is running. Then suspended is set.
The code makes sure there is no window without any of these
flags.

The problem is that workers can still be enqueued while we
are quiescing. This leads to situations where the driver is
already suspending and other flows like disassociation are
handled by a worker.

To fix this, we need to check quiescing and suspended flags
in the worker itself and not only before enqueueing it.
I also add here extensive documentation to ease the
understanding of these complex issues.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ieee80211_i.h | 30 ++++++++++++++++++++++++++++++
 net/mac80211/iface.c       |  7 +------
 net/mac80211/util.c        | 15 +++++++++------
 3 files changed, 40 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 6717a56..422d6b5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1929,6 +1929,36 @@ void __ieee80211_flush_queues(struct ieee80211_local *local,
 			      struct ieee80211_sub_if_data *sdata,
 			      unsigned int queues, bool drop);
 
+static inline bool ieee80211_can_run_worker(struct ieee80211_local *local)
+{
+	/*
+	 * If quiescing is set, we are racing with __ieee80211_suspend.
+	 * __ieee80211_suspend flushes the workers after setting quiescing,
+	 * and we check quiescing / suspended before enqueing new workers.
+	 * We should abort the worker to avoid the races below.
+	 */
+	if (local->quiescing)
+		return false;
+
+	/*
+	 * We might already be suspended if the following scenario occurs:
+	 * __ieee80211_suspend		Control path
+	 *
+	 *				if (local->quiescing)
+	 *					return;
+	 * local->quiescing = true;
+	 * flush_workqueue();
+	 *				queue_work(...);
+	 * local->suspended = true;
+	 * local->quiescing = false;
+	 *				worker starts running...
+	 */
+	if (local->suspended)
+		return false;
+
+	return true;
+}
+
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg, u16 status,
 			 const u8 *extra, size_t extra_len, const u8 *bssid,
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index a818b3b..05b7920 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1190,12 +1190,7 @@ static void ieee80211_iface_work(struct work_struct *work)
 	if (local->scanning)
 		return;
 
-	/*
-	 * ieee80211_queue_work() should have picked up most cases,
-	 * here we'll pick the rest.
-	 */
-	if (WARN(local->suspended,
-		 "interface work scheduled while going to suspend\n"))
+	if (!ieee80211_can_run_worker(local))
 		return;
 
 	/* first process frames */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index fbd37d4..c65d03f 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -744,16 +744,19 @@ EXPORT_SYMBOL_GPL(wdev_to_ieee80211_vif);
 
 /*
  * Nothing should have been stuffed into the workqueue during
- * the suspend->resume cycle. If this WARN is seen then there
- * is a bug with either the driver suspend or something in
- * mac80211 stuffing into the workqueue which we haven't yet
- * cleared during mac80211's suspend cycle.
+ * the suspend->resume cycle. Since we can't check each caller
+ * of this function if we are already quiescing / suspended,
+ * check here and don't WARN since this can actually happen when
+ * the rx path (for example) is racing against __ieee80211_suspend
+ * and suspending / quiescing was set after the rx path checked
+ * them.
  */
 static bool ieee80211_can_queue_work(struct ieee80211_local *local)
 {
-	if (WARN(local->suspended && !local->resuming,
-		 "queueing ieee80211 work while going to suspend\n"))
+	if (local->quiescing || (local->suspended && !local->resuming)) {
+		pr_warn("queueing ieee80211 work while going to suspend\n");
 		return false;
+	}
 
 	return true;
 }
-- 
1.9.1

