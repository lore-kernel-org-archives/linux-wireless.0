Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:49645 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3FJUTw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jun 2013 16:19:52 -0400
Received: by mail-pd0-f169.google.com with SMTP id y10so7802132pdj.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jun 2013 13:19:52 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Bob Copeland <me@bobcopeland.com>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v2 2/2] mac80211: update mesh beacon on workqueue
Date: Mon, 10 Jun 2013 13:17:22 -0700
Message-Id: <1370895442-21784-2-git-send-email-thomas@cozybit.com> (sfid-20130610_222109_215668_A331F23D)
In-Reply-To: <1370895442-21784-1-git-send-email-thomas@cozybit.com>
References: <1370895442-21784-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes yet another deadlock on calling sta_info_flush()
with the sdata_lock() held. Should make it easier to
reason about locking in the future, since the sdata_lock()
is now held on all mesh work.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---

v2:
	read all changed bits & drop macro (Johannes)

 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mesh.c        |   44 ++++++++++++++++++++++++++++++++------------
 net/mac80211/mesh.h        |    2 ++
 3 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 7a6f1a0..f79156d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -543,6 +543,7 @@ struct ieee80211_if_mesh {
 	struct timer_list mesh_path_root_timer;
 
 	unsigned long wrkq_flags;
+	unsigned long mbss_changed;
 
 	u8 mesh_id[IEEE80211_MAX_MESH_ID_LEN];
 	size_t mesh_id_len;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d5faf91..2499679 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -161,11 +161,8 @@ void mesh_sta_cleanup(struct sta_info *sta)
 		del_timer_sync(&sta->plink_timer);
 	}
 
-	if (changed) {
-		sdata_lock(sdata);
+	if (changed)
 		ieee80211_mbss_info_change_notify(sdata, changed);
-		sdata_unlock(sdata);
-	}
 }
 
 int mesh_rmc_init(struct ieee80211_sub_if_data *sdata)
@@ -719,14 +716,15 @@ ieee80211_mesh_rebuild_beacon(struct ieee80211_sub_if_data *sdata)
 void ieee80211_mbss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 				       u32 changed)
 {
-	if (sdata->vif.bss_conf.enable_beacon &&
-	    (changed & (BSS_CHANGED_BEACON |
-			BSS_CHANGED_HT |
-			BSS_CHANGED_BASIC_RATES |
-			BSS_CHANGED_BEACON_INT)))
-		if (ieee80211_mesh_rebuild_beacon(sdata))
-			return;
-	ieee80211_bss_info_change_notify(sdata, changed);
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	u32 bit;
+
+	/* if we race with running work, worst case this work becomes a noop */
+	for_each_set_bit(bit, (unsigned long *)&changed,
+			 sizeof(changed) * BITS_PER_BYTE)
+		set_bit(BIT(bit), &ifmsh->mbss_changed);
+	set_bit(MESH_WORK_MBSS_CHANGED, &ifmsh->wrkq_flags);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 }
 
 int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
@@ -969,6 +967,26 @@ out:
 	sdata_unlock(sdata);
 }
 
+static void mesh_bss_info_changed(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	u32 bit, changed = 0;
+
+	for_each_set_bit(bit, (unsigned long *)&ifmsh->mbss_changed,
+			 sizeof(changed) * BITS_PER_BYTE)
+		changed |= test_and_clear_bit(BIT(bit), &ifmsh->mbss_changed);
+
+	if (sdata->vif.bss_conf.enable_beacon &&
+	    (changed & (BSS_CHANGED_BEACON |
+			BSS_CHANGED_HT |
+			BSS_CHANGED_BASIC_RATES |
+			BSS_CHANGED_BEACON_INT)))
+		if (ieee80211_mesh_rebuild_beacon(sdata))
+			return;
+
+	ieee80211_bss_info_change_notify(sdata, changed);
+}
+
 void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
@@ -999,6 +1017,8 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 	if (test_and_clear_bit(MESH_WORK_DRIFT_ADJUST, &ifmsh->wrkq_flags))
 		mesh_sync_adjust_tbtt(sdata);
 
+	if (test_and_clear_bit(MESH_WORK_MBSS_CHANGED, &ifmsh->wrkq_flags))
+		mesh_bss_info_changed(sdata);
 out:
 	sdata_unlock(sdata);
 }
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 8b4d9a3..be28f9b 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -57,6 +57,7 @@ enum mesh_path_flags {
  * grow
  * @MESH_WORK_ROOT: the mesh root station needs to send a frame
  * @MESH_WORK_DRIFT_ADJUST: time to compensate for clock drift relative to other
+ * @MESH_WORK_MBSS_CHANGED: rebuild beacon and notify driver of BSS changes
  * mesh nodes
  */
 enum mesh_deferred_task_flags {
@@ -65,6 +66,7 @@ enum mesh_deferred_task_flags {
 	MESH_WORK_GROW_MPP_TABLE,
 	MESH_WORK_ROOT,
 	MESH_WORK_DRIFT_ADJUST,
+	MESH_WORK_MBSS_CHANGED,
 };
 
 /**
-- 
1.7.10.4

