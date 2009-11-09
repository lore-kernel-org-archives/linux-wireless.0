Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47943 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbZKIMmN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 07:42:13 -0500
Received: by mail-bw0-f227.google.com with SMTP id 27so3397119bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 04:42:19 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH 19/21] mac80211: implement a timer to send RANN action frames
Date: Mon,  9 Nov 2009 12:39:39 +0000
Message-Id: <1257770381-7680-20-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RANN (Root Annoucement) frame TX. Send an action frame every second
trying to build a path to all nodes on the mesh.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mesh.c        |   39 +++++++++++++++++++++++++++++++++++++++
 net/mac80211/mesh.h        |    3 +++
 net/mac80211/mesh_hwmp.c   |   11 +++++++++++
 4 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d76dd36..2037d08 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -352,6 +352,7 @@ struct ieee80211_if_mesh {
 	struct work_struct work;
 	struct timer_list housekeeping_timer;
 	struct timer_list mesh_path_timer;
+	struct timer_list mesh_path_root_timer;
 	struct sk_buff_head skb_queue;
 
 	unsigned long timers_running;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 0f3e114..88dcfe3 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -14,6 +14,7 @@
 
 #define IEEE80211_MESH_PEER_INACTIVITY_LIMIT (1800 * HZ)
 #define IEEE80211_MESH_HOUSEKEEPING_INTERVAL (60 * HZ)
+#define IEEE80211_MESH_RANN_INTERVAL	     (1 * HZ)
 
 #define MESHCONF_PP_OFFSET 	0		/* Path Selection Protocol */
 #define MESHCONF_PM_OFFSET	1		/* Path Selection Metric   */
@@ -26,6 +27,7 @@
 
 #define TMR_RUNNING_HK	0
 #define TMR_RUNNING_MP	1
+#define TMR_RUNNING_MPR	2
 
 int mesh_allocated;
 static struct kmem_cache *rm_cache;
@@ -354,6 +356,23 @@ static void ieee80211_mesh_path_timer(unsigned long data)
 	ieee80211_queue_work(&local->hw, &ifmsh->work);
 }
 
+static void ieee80211_mesh_path_root_timer(unsigned long data)
+{
+	struct ieee80211_sub_if_data *sdata =
+		(struct ieee80211_sub_if_data *) data;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct ieee80211_local *local = sdata->local;
+
+	set_bit(MESH_WORK_ROOT, &ifmsh->wrkq_flags);
+
+	if (local->quiescing) {
+		set_bit(TMR_RUNNING_MPR, &ifmsh->timers_running);
+		return;
+	}
+
+	ieee80211_queue_work(&local->hw, &ifmsh->work);
+}
+
 /**
  * ieee80211_fill_mesh_addresses - fill addresses of a locally originated mesh frame
  * @hdr:    	802.11 frame header
@@ -447,6 +466,15 @@ static void ieee80211_mesh_housekeeping(struct ieee80211_sub_if_data *sdata,
 		  round_jiffies(jiffies + IEEE80211_MESH_HOUSEKEEPING_INTERVAL));
 }
 
+static void ieee80211_mesh_rootpath(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+
+	mesh_path_tx_root_frame(sdata);
+	mod_timer(&ifmsh->mesh_path_root_timer,
+		  round_jiffies(jiffies + IEEE80211_MESH_RANN_INTERVAL));
+}
+
 #ifdef CONFIG_PM
 void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
 {
@@ -461,6 +489,8 @@ void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
 		set_bit(TMR_RUNNING_HK, &ifmsh->timers_running);
 	if (del_timer_sync(&ifmsh->mesh_path_timer))
 		set_bit(TMR_RUNNING_MP, &ifmsh->timers_running);
+	if (del_timer_sync(&ifmsh->mesh_path_root_timer))
+		set_bit(TMR_RUNNING_MPR, &ifmsh->timers_running);
 }
 
 void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
@@ -471,6 +501,8 @@ void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
 		add_timer(&ifmsh->housekeeping_timer);
 	if (test_and_clear_bit(TMR_RUNNING_MP, &ifmsh->timers_running))
 		add_timer(&ifmsh->mesh_path_timer);
+	if (test_and_clear_bit(TMR_RUNNING_MPR, &ifmsh->timers_running))
+		add_timer(&ifmsh->mesh_path_root_timer);
 }
 #endif
 
@@ -490,6 +522,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 {
 	del_timer_sync(&sdata->u.mesh.housekeeping_timer);
+	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
 	/*
 	 * If the timer fired while we waited for it, it will have
 	 * requeued the work. Now the work will be running again
@@ -627,6 +660,9 @@ static void ieee80211_mesh_work(struct work_struct *work)
 
 	if (test_and_clear_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags))
 		ieee80211_mesh_housekeeping(sdata, ifmsh);
+
+	if (test_and_clear_bit(MESH_WORK_ROOT, &ifmsh->wrkq_flags))
+		ieee80211_mesh_rootpath(sdata);
 }
 
 void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local)
@@ -683,6 +719,9 @@ void ieee80211_mesh_init_sdata(struct ieee80211_sub_if_data *sdata)
 	setup_timer(&ifmsh->mesh_path_timer,
 		    ieee80211_mesh_path_timer,
 		    (unsigned long) sdata);
+	setup_timer(&ifmsh->mesh_path_root_timer,
+		    ieee80211_mesh_path_root_timer,
+		    (unsigned long) sdata);
 	INIT_LIST_HEAD(&ifmsh->preq_queue.list);
 	spin_lock_init(&ifmsh->mesh_preq_queue_lock);
 }
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index ee687ad..00ee842 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -53,11 +53,13 @@ enum mesh_path_flags {
  * to grow.
  * @MESH_WORK_GROW_MPP_TABLE: the mesh portals table is full and needs to
  * grow
+ * @MESH_WORK_ROOT: the mesh root station needs to send a frame
  */
 enum mesh_deferred_task_flags {
 	MESH_WORK_HOUSEKEEPING,
 	MESH_WORK_GROW_MPATH_TABLE,
 	MESH_WORK_GROW_MPP_TABLE,
+	MESH_WORK_ROOT,
 };
 
 /**
@@ -294,6 +296,7 @@ void mesh_path_discard_frame(struct sk_buff *skb,
 		struct ieee80211_sub_if_data *sdata);
 void mesh_path_quiesce(struct ieee80211_sub_if_data *sdata);
 void mesh_path_restart(struct ieee80211_sub_if_data *sdata);
+void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata);
 
 extern int mesh_paths_generation;
 
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 5d9e8e8..1c6718d 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -1012,3 +1012,14 @@ void mesh_path_timer(unsigned long data)
 endmpathtimer:
 	rcu_read_unlock();
 }
+
+void
+mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+
+	mesh_path_sel_frame_tx(MPATH_RANN, 0, sdata->dev->dev_addr,
+			       cpu_to_le32(++ifmsh->sn),
+			       0, NULL, 0, sdata->dev->broadcast,
+			       0, MESH_TTL, 0, 0, 0, sdata);
+}
-- 
1.5.6.5

