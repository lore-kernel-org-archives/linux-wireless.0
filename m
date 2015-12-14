Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3996 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbbLNO1D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 09:27:03 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: avoid ROC during hw restart
Date: Mon, 14 Dec 2015 16:26:57 +0200
Message-Id: <1450103217-20503-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151214_152708_162038_66C71708)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Defer ROC requests during hw restart, as the driver
might not be fully configured in this stage (e.g.
channel contexts were not added yet)

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/main.c       |  5 +++++
 net/mac80211/offchannel.c |  4 ++++
 net/mac80211/util.c       | 11 +++++++++--
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 6bcf0fa..ed4c8e6 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -256,6 +256,11 @@ static void ieee80211_restart_work(struct work_struct *work)
 	list_for_each_entry(sdata, &local->interfaces, list)
 		flush_delayed_work(&sdata->dec_tailroom_needed_wk);
 	ieee80211_scan_cancel(local);
+
+	/* make sure any new ROC will consider local->in_reconfig */
+	flush_delayed_work(&local->roc_work);
+	flush_work(&local->hw_roc_done);
+
 	ieee80211_reconfig(local);
 	rtnl_unlock();
 }
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index fbc34e9..55a9c5b 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -408,6 +408,10 @@ void ieee80211_start_next_roc(struct ieee80211_local *local)
 		return;
 	}
 
+	/* defer roc if driver is not started (i.e. during reconfig) */
+	if (local->in_reconfig)
+		return;
+
 	roc = list_first_entry(&local->roc_list, struct ieee80211_roc_work,
 			       list);
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index f4b2c04..0186178 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2054,8 +2054,15 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 		cfg80211_sched_scan_stopped_rtnl(local->hw.wiphy);
 
  wake_up:
-	local->in_reconfig = false;
-	barrier();
+	if (local->in_reconfig) {
+		local->in_reconfig = false;
+		barrier();
+
+		/* Restart deferred ROCs */
+		mutex_lock(&local->mtx);
+		ieee80211_start_next_roc(local);
+		mutex_unlock(&local->mtx);
+	}
 
 	if (local->monitors == local->open_count && local->monitors > 0)
 		ieee80211_add_virtual_monitor(local);
-- 
2.5.0

