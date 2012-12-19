Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47640 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab2LSK5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 05:57:01 -0500
Message-ID: <1355914642.9954.6.camel@jlt4.sipsolutions.net> (sfid-20121219_115709_957883_133FA52B)
Subject: Re: [PATCH 2/3] mac80211: clean up association better in suspend
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 19 Dec 2012 11:57:22 +0100
In-Reply-To: <CAB3XZEeGABu9B-Cd27rjrTgtArf3gvV=2KejW+MctSWyGAL4CA@mail.gmail.com> (sfid-20121216_095554_931163_38B85A91)
References: <1355486368-14563-1-git-send-email-johannes@sipsolutions.net>
	 <1355486368-14563-3-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEeGABu9B-Cd27rjrTgtArf3gvV=2KejW+MctSWyGAL4CA@mail.gmail.com>
	 (sfid-20121216_095554_931163_38B85A91)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-12-16 at 10:55 +0200, Eliad Peller wrote:

> > +               case NL80211_IFTYPE_STATION:
> > +                       changed = BSS_CHANGED_ASSOC;
> 
> maybe set it only if associated?

good point

> also, is there really a point in notifying BSS_CHANGED_ASSOC without
> notifying CHANGED_BSSID (and maybe CHANGED_IDLE)?

Hmm, I guess if associated the BSSID will change, and IDLE will change.

I'll add those flags. I guess it depends on how the driver handles it.

I have a feeling we should have a bit smarter managed mode APIs, like I
recently added for AP mode (start_ap/stop_ap), the BSS info change
doesn't make sense to randomly change the BSSID while associated for
example, but it's redundant in that the driver might look at the BSSID
change or the associated change and do something, or treat them
separately (which could lead to confusion & thinking that they can
change separately...)

> > -               /* disable beaconing */
> > -               ieee80211_bss_info_change_notify(sdata,
> > -                       BSS_CHANGED_BEACON_ENABLED);
> > +               sdata->suspend_bss_conf = sdata->vif.bss_conf;
> > +               memset(&sdata->vif.bss_conf, 0, sizeof(sdata->vif.bss_conf));
> 
> it probably doesn't matter much (as you don't notify CHANGED_IDLE),
> but setting vif.idle=0 is probably not your intention here.

Yeah I'll set it to true.

johannes

>From 5fe27effbc755f368c57981fe50143d649541f5b Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Thu, 13 Dec 2012 17:16:45 +0100
Subject: [PATCH] mac80211: clean up association better in suspend

When suspending, bss_info_changed() is called to
disable beacons, but managed mode interfaces are
simply removed (bss_info_changed() is called with
"no change" only). This can lead to problems.

To fix this and copy the BSS configuration, clear
it during suspend and restore it on resume.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ieee80211_i.h |  5 +++++
 net/mac80211/pm.c          | 19 ++++++++++++++++---
 net/mac80211/util.c        |  5 +++++
 3 files changed, 26 insertions(+), 3 deletions(-)

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
index f321783..712c17f 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -121,6 +121,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 
 	/* remove all interfaces */
 	list_for_each_entry(sdata, &local->interfaces, list) {
+		u32 changed = BSS_CHANGED_BEACON_ENABLED;
+
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 
@@ -129,14 +131,25 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan)
 		case NL80211_IFTYPE_MONITOR:
 			/* skip these */
 			continue;
+		case NL80211_IFTYPE_STATION:
+			if (sdata->vif.bss_conf.assoc)
+				changed = BSS_CHANGED_ASSOC |
+					  BSS_CHANGED_BSSID |
+					  BSS_CHANGED_IDLE;
+			else
+				changed = 0;
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
+		sdata->vif.bss_conf.idle = true;
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



