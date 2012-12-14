Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56698 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab2LNL7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 06:59:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] mac80211: clean up association better in suspend
Date: Fri, 14 Dec 2012 12:59:27 +0100
Message-Id: <1355486368-14563-3-git-send-email-johannes@sipsolutions.net> (sfid-20121214_125915_139847_17E91682)
In-Reply-To: <1355486368-14563-1-git-send-email-johannes@sipsolutions.net>
References: <1355486368-14563-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When suspending, bss_info_changed() is called to
disable beacons, but managed mode interfaces are
simply removed (bss_info_changed() is called with
"no change" only). This can lead to problems.

To fix this and copy the BSS configuration, clear
it during suspend and restore it on resume.

Change-Id: Ie1b7f6343fe59dfbff886b9720e4c15686d7fda7
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  5 +++++
 net/mac80211/pm.c          | 13 ++++++++++---
 net/mac80211/util.c        |  5 +++++
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8baaeda..0360b74 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -785,6 +785,11 @@ struct ieee80211_sub_if_data {
 		struct dentry *default_mgmt_key;
 	} debugfs;
 #endif
+
+#ifdef CONFIG_PM
+	struct ieee80211_bss_conf suspend_bss_conf;
+#endif
+
 	/* must be last, dynamically sized area in this! */
 	struct ieee80211_vif vif;
 };
diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index f321783..f3a9e5f 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -121,6 +121,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	/* remove all interfaces */
 	list_for_each_entry(sdata, &local->interfaces, list) {
+		u32 changed = BSS_CHANGED_BEACON_ENABLED;
+
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 
@@ -129,14 +131,19 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		case NL80211_IFTYPE_MONITOR:
 			/* skip these */
 			continue;
+		case NL80211_IFTYPE_STATION:
+			changed = BSS_CHANGED_ASSOC;
+			/* fall through */
 		default:
 			ieee80211_quiesce(sdata);
 			break;
 		}
 
-		/* disable beaconing */
-		ieee80211_bss_info_change_notify(sdata,
-			BSS_CHANGED_BEACON_ENABLED);
+		sdata->suspend_bss_conf = sdata->vif.bss_conf;
+		memset(&sdata->vif.bss_conf, 0, sizeof(sdata->vif.bss_conf));
+
+		/* disable beaconing or remove association */
+		ieee80211_bss_info_change_notify(sdata, changed);
 
 		if (sdata->vif.type == NL80211_IFTYPE_AP &&
 		    rcu_access_pointer(sdata->u.ap.beacon))
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 6ba0c66..c170b9d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1533,6 +1533,11 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 			  BSS_CHANGED_IDLE |
 			  BSS_CHANGED_TXPOWER;
 
+#ifdef CONFIG_PM
+		if (local->resuming)
+			sdata->vif.bss_conf = sdata->suspend_bss_conf;
+#endif
+
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_STATION:
 			changed |= BSS_CHANGED_ASSOC |
-- 
1.8.0

