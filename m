Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34604 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553Ab2HCTVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 15:21:41 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so1800271pbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Aug 2012 12:21:41 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 2/4] mac80211: remove ieee80211_clean_sdata()
Date: Fri,  3 Aug 2012 12:21:33 -0700
Message-Id: <1344021695-12859-2-git-send-email-thomas@cozybit.com> (sfid-20120803_212147_973168_A3A60CEC)
In-Reply-To: <1344021695-12859-1-git-send-email-thomas@cozybit.com>
References: <1344021695-12859-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function was only used by mesh, and not really needed since any
interface-specific cleanup already happens in the netdev handlers.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/iface.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index b6c5a92..22e2923 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1148,18 +1148,6 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	ieee80211_debugfs_add_netdev(sdata);
 }
 
-static void ieee80211_clean_sdata(struct ieee80211_sub_if_data *sdata)
-{
-	switch (sdata->vif.type) {
-	case NL80211_IFTYPE_MESH_POINT:
-		mesh_path_flush_by_iface(sdata);
-		break;
-
-	default:
-		break;
-	}
-}
-
 static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 					   enum nl80211_iftype type)
 {
@@ -1495,9 +1483,6 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 	list_del_rcu(&sdata->list);
 	mutex_unlock(&sdata->local->iflist_mtx);
 
-	/* clean up type-dependent data */
-	ieee80211_clean_sdata(sdata);
-
 	synchronize_rcu();
 	unregister_netdevice(sdata->dev);
 }
@@ -1517,8 +1502,6 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
 		list_del(&sdata->list);
 
-		ieee80211_clean_sdata(sdata);
-
 		unregister_netdevice_queue(sdata->dev, &unreg_list);
 	}
 	mutex_unlock(&local->iflist_mtx);
-- 
1.7.5.4

