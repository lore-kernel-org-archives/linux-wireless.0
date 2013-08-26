Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab3HZHfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Aug 2013 03:35:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix change_interface queue assignments
Date: Mon, 26 Aug 2013 09:35:43 +0200
Message-Id: <1377502543-1160-1-git-send-email-johannes@sipsolutions.net> (sfid-20130826_093555_688213_49CF3306)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Jouni reported that with mac80211_hwsim, multicast TX was causing
crashes due to invalid vif->cab_queue assignment. It turns out that
this is caused by change_interface() getting invoked and not having
the vif->type/vif->p2p assigned correctly before calling the queue
check (ieee80211_check_queues). Fix this by passing the 'external'
interface type to the function and adjusting it accordingly.

While at it, also fix the error path in change_interface, it wasn't
correctly resetting to the external type but using the internal one
instead.

Fortunately this affects on hwsim because all other drivers set the
vif->type/vif->p2p variables when changing iftype. This shouldn't
be needed, but almost all implementations actually do it for their
own internal handling.

Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/iface.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7ca534b..fcecd63 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -308,12 +308,13 @@ static int ieee80211_check_concurrent_iface(struct ieee80211_sub_if_data *sdata,
 	return 0;
 }
 
-static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata)
+static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata,
+				  enum nl80211_iftype iftype)
 {
 	int n_queues = sdata->local->hw.queues;
 	int i;
 
-	if (sdata->vif.type != NL80211_IFTYPE_P2P_DEVICE) {
+	if (iftype != NL80211_IFTYPE_P2P_DEVICE) {
 		for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 			if (WARN_ON_ONCE(sdata->vif.hw_queue[i] ==
 					 IEEE80211_INVAL_HW_QUEUE))
@@ -324,8 +325,9 @@ static int ieee80211_check_queues(struct ieee80211_sub_if_data *sdata)
 		}
 	}
 
-	if ((sdata->vif.type != NL80211_IFTYPE_AP &&
-	     sdata->vif.type != NL80211_IFTYPE_MESH_POINT) ||
+	if ((iftype != NL80211_IFTYPE_AP &&
+	     iftype != NL80211_IFTYPE_P2P_GO &&
+	     iftype != NL80211_IFTYPE_MESH_POINT) ||
 	    !(sdata->local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)) {
 		sdata->vif.cab_queue = IEEE80211_INVAL_HW_QUEUE;
 		return 0;
@@ -408,7 +410,7 @@ int ieee80211_add_virtual_monitor(struct ieee80211_local *local)
 		return ret;
 	}
 
-	ret = ieee80211_check_queues(sdata);
+	ret = ieee80211_check_queues(sdata, NL80211_IFTYPE_MONITOR);
 	if (ret) {
 		kfree(sdata);
 		return ret;
@@ -592,7 +594,8 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			res = drv_add_interface(local, sdata);
 			if (res)
 				goto err_stop;
-			res = ieee80211_check_queues(sdata);
+			res = ieee80211_check_queues(sdata,
+				ieee80211_vif_type_p2p(&sdata->vif));
 			if (res)
 				goto err_del_interface;
 		}
@@ -1389,14 +1392,14 @@ static int ieee80211_runtime_change_iftype(struct ieee80211_sub_if_data *sdata,
 
 	ret = drv_change_interface(local, sdata, internal_type, p2p);
 	if (ret)
-		type = sdata->vif.type;
+		type = ieee80211_vif_type_p2p(&sdata->vif);
 
 	/*
 	 * Ignore return value here, there's not much we can do since
 	 * the driver changed the interface type internally already.
 	 * The warnings will hopefully make driver authors fix it :-)
 	 */
-	ieee80211_check_queues(sdata);
+	ieee80211_check_queues(sdata, type);
 
 	ieee80211_setup_sdata(sdata, type);
 
-- 
1.8.4.rc3

