Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:7815 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbbJYJAC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 05:00:02 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/10] mac80211: use freezable workqueue for restart work
Date: Sun, 25 Oct 2015 10:59:35 +0200
Message-Id: <1445763582-11421-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_100029_021729_06B50C3E)
In-Reply-To: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Requesting hw restart during suspend might result
in the restart work being executed after mac80211
and the hw are suspended.

Solve the race by simply scheduling the restart
work on a freezable workqueue.

Note that there can be some cases of reconfiguration
on resume (besides the hardware restart):

* wowlan is not configured -
    All the interfaces removed were removed on suspend,
    and drv_stop() was called. At this point the driver
    shouldn't expect for hw_restart anyway, so we can
    simply cancel it (on resume).

* wowlan is configured, drv_resume() == 1
    There is no definitive expected behavior in this case,
    as each driver might have different expectations (e.g.
    setting some flags on suspend/restart vs. not handling
    spurious recovery).
    For now, simply let the hw_restart work run again after
    resume, and hope the driver will handle it well (or at
    least initiate another hw restart).

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/main.c |  2 +-
 net/mac80211/util.c | 11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 273c96d..858f6b1 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -281,7 +281,7 @@ void ieee80211_restart_hw(struct ieee80211_hw *hw)
 	local->in_reconfig = true;
 	barrier();
 
-	schedule_work(&local->restart_work);
+	queue_work(system_freezable_wq, &local->restart_work);
 }
 EXPORT_SYMBOL(ieee80211_restart_hw);
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7150ae2..e936acd 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -4,6 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2007	Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
+ * Copyright (C) 2015	Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -1754,6 +1755,16 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 #endif
 
 	/*
+	 * In case of hw_restart during suspend (without wowlan),
+	 * cancel restart work, as we are reconfiguring the device
+	 * anyway.
+	 * Note that restart_work is scheduled on a frozen workqueue,
+	 * so we can't deadlock in this case.
+	 */
+	if (suspended && local->in_reconfig && !reconfig_due_to_wowlan)
+		cancel_work_sync(&local->restart_work);
+
+	/*
 	 * Upon resume hardware can sometimes be goofy due to
 	 * various platform / driver / bus issues, so restarting
 	 * the device may at times not work immediately. Propagate
-- 
2.1.4

