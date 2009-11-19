Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55634 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbZKSO2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 09:28:08 -0500
Subject: [PATCH 2.6.32] mac80211: fix resume
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Nov 2009 14:29:39 +0100
Message-ID: <1258637379.7094.11.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When mac80211 resumes, it currently first sets suspended
to false so the driver can start doing things and we can
receive frames.

However, if we actually receive frames then it can end
up starting some work which adds timers and then later
runs into a BUG_ON in the timer code because it tries
add_timer() on a pending timer.

Fix this by keeping track of the resuming process by
introducing a new variable 'resuming' which gets set to
true early on instead of setting 'suspended' to false,
and allow queueing work but not receiving frames while
resuming.

Reported-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
It's very likely that this is the bug Maxim was running into, and we
definitely have a bug here when the device starts receiving frames
before we finish ieee80211_reconfig().

 net/mac80211/ieee80211_i.h |    8 ++++++++
 net/mac80211/util.c        |   19 +++++++++----------
 2 files changed, 17 insertions(+), 10 deletions(-)

--- wireless-testing.orig/net/mac80211/util.c	2009-11-19 12:46:18.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-11-19 12:46:33.000000000 +0100
@@ -520,9 +520,9 @@ EXPORT_SYMBOL_GPL(ieee80211_iterate_acti
  */
 static bool ieee80211_can_queue_work(struct ieee80211_local *local)
 {
-        if (WARN(local->suspended, "queueing ieee80211 work while "
-		 "going to suspend\n"))
-                return false;
+	if (WARN(local->suspended && !local->resuming,
+		 "queueing ieee80211 work while going to suspend\n"))
+		return false;
 
 	return true;
 }
@@ -1033,13 +1033,9 @@ int ieee80211_reconfig(struct ieee80211_
 	struct sta_info *sta;
 	unsigned long flags;
 	int res;
-	bool from_suspend = local->suspended;
 
-	/*
-	 * We're going to start the hardware, at that point
-	 * we are no longer suspended and can RX frames.
-	 */
-	local->suspended = false;
+	if (local->suspended)
+		local->resuming = true;
 
 	/* restart hardware */
 	if (local->open_count) {
@@ -1137,11 +1133,14 @@ int ieee80211_reconfig(struct ieee80211_
 	 * If this is for hw restart things are still running.
 	 * We may want to change that later, however.
 	 */
-	if (!from_suspend)
+	if (!local->suspended)
 		return 0;
 
 #ifdef CONFIG_PM
+	/* first set suspended false, then resuming */
 	local->suspended = false;
+	mb();
+	local->resuming = false;
 
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		switch(sdata->vif.type) {
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-11-19 12:46:18.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-11-19 14:22:40.000000000 +0100
@@ -602,6 +602,14 @@ struct ieee80211_local {
 	bool suspended;
 
 	/*
+	 * Resuming is true while suspended, but when we're reprogramming the
+	 * hardware -- at that time it's allowed to use ieee80211_queue_work()
+	 * again even though some other parts of the stack are still suspended
+	 * and we still drop received frames to avoid waking the stack.
+	 */
+	bool resuming;
+
+	/*
 	 * quiescing is true during the suspend process _only_ to
 	 * ease timer cancelling etc.
 	 */


