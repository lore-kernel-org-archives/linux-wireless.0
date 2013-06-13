Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:51795 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757435Ab3FMW5M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 18:57:12 -0400
Received: by mail-pd0-f176.google.com with SMTP id t12so7018916pdi.35
        for <linux-wireless@vger.kernel.org>; Thu, 13 Jun 2013 15:57:11 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: open80211s <devel@lists.open80211s.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH v3] mac80211: update mesh beacon on workqueue
Date: Thu, 13 Jun 2013 15:54:41 -0700
Message-Id: <1371164081-5516-1-git-send-email-thomas@cozybit.com> (sfid-20130614_005715_769782_8C76DE43)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of updating the mesh beacon immediately when
requested (which would require the sdata_lock()), defer it
to the mac80211 workqueue.

Fixes yet another deadlock on calling sta_info_flush()
with the sdata_lock() held from ieee80211_stop_mesh(). We
could just drop the sdata_lock() around the
mesh_sta_cleanup() call, but this path is also taken from
several non-locked error paths.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>

---
v3:

	cast u32 as unsigned long endianess (Johannes)
	clear mesh work flags on stop (Johannes)
	test_and_clear_bit() returns a bool
	{set,clear}_bit() takes the bit _number_

 net/mac80211/ieee80211_i.h |    1 +
 net/mac80211/mesh.c        |   53 ++++++++++++++++++++++++++++++++++----------
 net/mac80211/mesh.h        |    2 ++
 3 files changed, 44 insertions(+), 12 deletions(-)

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
index 6c33af4..d5dea94 100644
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
@@ -719,14 +716,18 @@ ieee80211_mesh_rebuild_beacon(struct ieee80211_sub_if_data *sdata)
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
+	unsigned long bits = changed;
+	u32 bit;
+
+	if (!bits)
+		return;
+
+	/* if we race with running work, worst case this work becomes a noop */
+	for_each_set_bit(bit, &bits, sizeof(changed) * BITS_PER_BYTE)
+		set_bit(bit, &ifmsh->mbss_changed);
+	set_bit(MESH_WORK_MBSS_CHANGED, &ifmsh->wrkq_flags);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 }
 
 int ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
@@ -799,6 +800,10 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);
 	del_timer_sync(&sdata->u.mesh.mesh_path_timer);
 
+	/* clear any mesh work (for next join) we may have accrued */
+	ifmsh->wrkq_flags = 0;
+	ifmsh->mbss_changed = 0;
+
 	local->fif_other_bss--;
 	atomic_dec(&local->iff_allmultis);
 	ieee80211_configure_filter(local);
@@ -965,6 +970,28 @@ out:
 	sdata_unlock(sdata);
 }
 
+static void mesh_bss_info_changed(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	u32 bit, changed = 0;
+
+	for_each_set_bit(bit, &ifmsh->mbss_changed,
+			 sizeof(changed) * BITS_PER_BYTE) {
+		clear_bit(bit, &ifmsh->mbss_changed);
+		changed |= BIT(bit);
+	}
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
@@ -995,6 +1022,8 @@ void ieee80211_mesh_work(struct ieee80211_sub_if_data *sdata)
 	if (test_and_clear_bit(MESH_WORK_DRIFT_ADJUST, &ifmsh->wrkq_flags))
 		mesh_sync_adjust_tbtt(sdata);
 
+	if (test_and_clear_bit(MESH_WORK_MBSS_CHANGED, &ifmsh->wrkq_flags))
+		mesh_bss_info_changed(sdata);
 out:
 	sdata_unlock(sdata);
 }
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 01a28bc..53bd870 100644
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

