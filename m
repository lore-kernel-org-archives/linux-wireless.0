Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:50936 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab2HBXsD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 19:48:03 -0400
Received: by ghrr11 with SMTP id r11so134556ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2012 16:48:03 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 2/4] mac80211: remove ieee80211_clean_sdata()
Date: Thu,  2 Aug 2012 16:47:52 -0700
Message-Id: <1343951274-24956-2-git-send-email-thomas@cozybit.com> (sfid-20120803_014846_538573_425D31F0)
In-Reply-To: <1343951274-24956-1-git-send-email-thomas@cozybit.com>
References: <1343951274-24956-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function was only used by mesh, and not really needed since any
interface-specific cleanup already happens in the netdev handlers.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/iface.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 80e0765..844a83f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1152,18 +1152,6 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
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
@@ -1499,9 +1487,6 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 	list_del_rcu(&sdata->list);
 	mutex_unlock(&sdata->local->iflist_mtx);
 
-	/* clean up type-dependent data */
-	ieee80211_clean_sdata(sdata);
-
 	synchronize_rcu();
 	unregister_netdevice(sdata->dev);
 }
@@ -1521,8 +1506,6 @@ void ieee80211_remove_interfaces(struct ieee80211_local *local)
 	list_for_each_entry_safe(sdata, tmp, &local->interfaces, list) {
 		list_del(&sdata->list);
 
-		ieee80211_clean_sdata(sdata);
-
 		unregister_netdevice_queue(sdata->dev, &unreg_list);
 	}
 	mutex_unlock(&local->iflist_mtx);
-- 
1.7.5.4

