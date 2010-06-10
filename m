Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42753 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab0FJI0E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 04:26:04 -0400
Message-Id: <20100610082229.444531239@sipsolutions.net>
Date: Thu, 10 Jun 2010 10:21:32 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/23] mac80211: use common work function
References: <20100610082128.641664439@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Even with the previous patch, IBSS, managed
and mesh modes all attach their own work
function to the shared work struct, which
means some duplicated code. Change that to
only have a frame processing function and a
further work function for each of them and
share some common code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ibss.c        |   29 ++-------------------
 net/mac80211/ieee80211_i.h |   11 +++++++
 net/mac80211/iface.c       |   62 +++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/mesh.c        |   20 ++------------
 net/mac80211/mlme.c        |   35 ++-----------------------
 5 files changed, 84 insertions(+), 73 deletions(-)

--- wireless-testing.orig/net/mac80211/ibss.c	2010-06-09 17:21:07.000000000 +0200
+++ wireless-testing/net/mac80211/ibss.c	2010-06-09 17:21:07.000000000 +0200
@@ -727,8 +727,8 @@ static void ieee80211_rx_mgmt_beacon(str
 	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, true);
 }
 
-static void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
-					  struct sk_buff *skb)
+void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+				   struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_mgmt *mgmt;
@@ -758,29 +758,9 @@ static void ieee80211_ibss_rx_queued_mgm
 	kfree_skb(skb);
 }
 
-static void ieee80211_ibss_work(struct work_struct *work)
+void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, work);
-	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_ibss *ifibss;
-	struct sk_buff *skb;
-
-	if (WARN_ON(local->suspended))
-		return;
-
-	if (!ieee80211_sdata_running(sdata))
-		return;
-
-	if (local->scanning)
-		return;
-
-	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_ADHOC))
-		return;
-	ifibss = &sdata->u.ibss;
-
-	while ((skb = skb_dequeue(&sdata->skb_queue)))
-		ieee80211_ibss_rx_queued_mgmt(sdata, skb);
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 
 	if (!test_and_clear_bit(IEEE80211_IBSS_REQ_RUN, &ifibss->request))
 		return;
@@ -846,7 +826,6 @@ void ieee80211_ibss_setup_sdata(struct i
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 
-	INIT_WORK(&sdata->work, ieee80211_ibss_work);
 	setup_timer(&ifibss->timer, ieee80211_ibss_timer,
 		    (unsigned long) sdata);
 }
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2010-06-09 17:21:07.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2010-06-09 17:21:07.000000000 +0200
@@ -995,6 +995,9 @@ void ieee80211_sta_process_chanswitch(st
 				      u64 timestamp);
 void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata);
 void ieee80211_sta_restart(struct ieee80211_sub_if_data *sdata);
+void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata);
+void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+				  struct sk_buff *skb);
 
 /* IBSS code */
 void ieee80211_ibss_notify_scan_completed(struct ieee80211_local *local);
@@ -1009,6 +1012,14 @@ int ieee80211_ibss_join(struct ieee80211
 int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata);
 void ieee80211_ibss_quiesce(struct ieee80211_sub_if_data *sdata);
 void ieee80211_ibss_restart(struct ieee80211_sub_if_data *sdata);
+void ieee80211_ibss_work(struct ieee80211_sub_if_data *sdata);
+void ieee80211_ibss_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+				   struct sk_buff *skb);
+
+/* mesh code */
+void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+				   struct sk_buff *skb);
 
 /* scan/BSS handling */
 void ieee80211_scan_work(struct work_struct *work);
--- wireless-testing.orig/net/mac80211/iface.c	2010-06-09 17:21:07.000000000 +0200
+++ wireless-testing/net/mac80211/iface.c	2010-06-09 17:21:07.000000000 +0200
@@ -701,6 +701,67 @@ static void ieee80211_if_setup(struct ne
 	dev->destructor = free_netdev;
 }
 
+static void ieee80211_iface_work(struct work_struct *work)
+{
+	struct ieee80211_sub_if_data *sdata =
+		container_of(work, struct ieee80211_sub_if_data, work);
+	struct ieee80211_local *local = sdata->local;
+	struct sk_buff *skb;
+
+	if (!ieee80211_sdata_running(sdata))
+		return;
+
+	if (local->scanning)
+		return;
+
+	/*
+	 * ieee80211_queue_work() should have picked up most cases,
+	 * here we'll pick the rest.
+	 */
+	if (WARN(local->suspended,
+		 "interface work scheduled while going to suspend\n"))
+		return;
+
+	/* first process frames */
+	while ((skb = skb_dequeue(&sdata->skb_queue))) {
+		switch (sdata->vif.type) {
+		case NL80211_IFTYPE_STATION:
+			ieee80211_sta_rx_queued_mgmt(sdata, skb);
+			break;
+		case NL80211_IFTYPE_ADHOC:
+			ieee80211_ibss_rx_queued_mgmt(sdata, skb);
+			break;
+		case NL80211_IFTYPE_MESH_POINT:
+			if (!ieee80211_vif_is_mesh(&sdata->vif))
+				break;
+			ieee80211_mesh_rx_queued_mgmt(sdata, skb);
+			break;
+		default:
+			WARN(1, "frame for unexpected interface type");
+			kfree_skb(skb);
+			break;
+		}
+	}
+
+	/* then other type-dependent work */
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_STATION:
+		ieee80211_sta_work(sdata);
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		ieee80211_ibss_work(sdata);
+		break;
+	case NL80211_IFTYPE_MESH_POINT:
+		if (!ieee80211_vif_is_mesh(&sdata->vif))
+			break;
+		ieee80211_mesh_work(sdata);
+		break;
+	default:
+		break;
+	}
+}
+
+
 /*
  * Helper function to initialise an interface to a specific type.
  */
@@ -719,6 +780,7 @@ static void ieee80211_setup_sdata(struct
 	sdata->dev->type = ARPHRD_ETHER;
 
 	skb_queue_head_init(&sdata->skb_queue);
+	INIT_WORK(&sdata->work, ieee80211_iface_work);
 
 	switch (type) {
 	case NL80211_IFTYPE_AP:
--- wireless-testing.orig/net/mac80211/mesh.c	2010-06-09 17:21:07.000000000 +0200
+++ wireless-testing/net/mac80211/mesh.c	2010-06-09 17:21:07.000000000 +0200
@@ -596,8 +596,8 @@ static void ieee80211_mesh_rx_mgmt_actio
 	}
 }
 
-static void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
-					  struct sk_buff *skb)
+void ieee80211_mesh_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+				   struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *rx_status;
 	struct ieee80211_if_mesh *ifmsh;
@@ -624,22 +624,9 @@ static void ieee80211_mesh_rx_queued_mgm
 	kfree_skb(skb);
 }
 
-static void ieee80211_mesh_work(struct work_struct *work)
+void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, work);
-	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct sk_buff *skb;
-
-	if (!ieee80211_sdata_running(sdata))
-		return;
-
-	if (local->scanning)
-		return;
-
-	while ((skb = skb_dequeue(&sdata->skb_queue)))
-		ieee80211_mesh_rx_queued_mgmt(sdata, skb);
 
 	if (ifmsh->preq_queue_len &&
 	    time_after(jiffies,
@@ -674,7 +661,6 @@ void ieee80211_mesh_init_sdata(struct ie
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 
-	INIT_WORK(&sdata->work, ieee80211_mesh_work);
 	setup_timer(&ifmsh->housekeeping_timer,
 		    ieee80211_mesh_housekeeping_timer,
 		    (unsigned long) sdata);
--- wireless-testing.orig/net/mac80211/mlme.c	2010-06-09 17:21:07.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2010-06-09 17:21:07.000000000 +0200
@@ -1660,8 +1660,8 @@ ieee80211_rx_result ieee80211_sta_rx_mgm
 	return RX_DROP_MONITOR;
 }
 
-static void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
-					 struct sk_buff *skb)
+void ieee80211_sta_rx_queued_mgmt(struct ieee80211_sub_if_data *sdata,
+				  struct sk_buff *skb)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_rx_status *rx_status;
@@ -1819,36 +1819,10 @@ static void ieee80211_sta_timer(unsigned
 	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
-static void ieee80211_sta_work(struct work_struct *work)
+void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 {
-	struct ieee80211_sub_if_data *sdata =
-		container_of(work, struct ieee80211_sub_if_data, work);
 	struct ieee80211_local *local = sdata->local;
-	struct ieee80211_if_managed *ifmgd;
-	struct sk_buff *skb;
-
-	if (!ieee80211_sdata_running(sdata))
-		return;
-
-	if (local->scanning)
-		return;
-
-	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
-		return;
-
-	/*
-	 * ieee80211_queue_work() should have picked up most cases,
-	 * here we'll pick the rest.
-	 */
-	if (WARN(local->suspended, "STA MLME work scheduled while "
-		 "going to suspend\n"))
-		return;
-
-	ifmgd = &sdata->u.mgd;
-
-	/* first process frames to avoid timing out while a frame is pending */
-	while ((skb = skb_dequeue(&sdata->skb_queue)))
-		ieee80211_sta_rx_queued_mgmt(sdata, skb);
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
 	/* then process the rest of the work */
 	mutex_lock(&ifmgd->mtx);
@@ -1989,7 +1963,6 @@ void ieee80211_sta_setup_sdata(struct ie
 	struct ieee80211_if_managed *ifmgd;
 
 	ifmgd = &sdata->u.mgd;
-	INIT_WORK(&sdata->work, ieee80211_sta_work);
 	INIT_WORK(&ifmgd->monitor_work, ieee80211_sta_monitor_work);
 	INIT_WORK(&ifmgd->chswitch_work, ieee80211_chswitch_work);
 	INIT_WORK(&ifmgd->beacon_connection_loss_work,


