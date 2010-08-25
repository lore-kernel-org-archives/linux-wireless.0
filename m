Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42203 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab0HYMqC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 08:46:02 -0400
Subject: [PATCH 2.6.36] mac80211: delete work timer
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 14:47:38 +0200
Message-ID: <1282740458.3685.26.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The new workqueue changes helped me find this bug
that's been lingering since the changes to the work
processing in mac80211 -- the work timer is never
deleted properly. Do that to avoid having it fire
after all data structures have been freed. It can't
be re-armed because all it will do, if running, is
schedule the work, but that gets flushed later and
won't have anything to do since all work items are
gone by now (by way of interface removal).

Cc: stable@kernel.org [2.6.34+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
This might clash with Christian's fix? But the fixup should be easy.

 net/mac80211/main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- wireless-testing.orig/net/mac80211/main.c	2010-08-25 14:36:21.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-08-25 14:41:50.000000000 +0200
@@ -812,6 +812,12 @@ void ieee80211_unregister_hw(struct ieee
 
 	rtnl_unlock();
 
+	/*
+	 * Now all work items will be gone, but the
+	 * timer might still be armed, so delete it
+	 */
+	del_timer_sync(&local->work_timer);
+
 	cancel_work_sync(&local->reconfig_filter);
 
 	ieee80211_clear_tx_pending(local);


