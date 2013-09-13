Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab3IMKiG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 06:38:06 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 1/5] Revert "mac80211: cleanup suspend/resume on mesh mode"
Date: Fri, 13 Sep 2013 12:36:04 +0200
Message-Id: <1379068568-27552-2-git-send-email-sgruszka@redhat.com> (sfid-20130913_123818_749880_02496B2C)
In-Reply-To: <1379068568-27552-1-git-send-email-sgruszka@redhat.com>
References: <1379068568-27552-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 690205f18fd069898c70d743f498ba42798e5c4e.
---
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/mesh.c        | 57 ++++++++++++++++++++++++++++++++++++++++++++--
 net/mac80211/mesh.h        | 12 ++++++++++
 net/mac80211/mesh_plink.c  | 27 +++++++++++++++++++++-
 net/mac80211/sta_info.h    |  2 ++
 5 files changed, 97 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index b618651..4b7ef89 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -543,6 +543,8 @@ struct ieee80211_if_mesh {
 	struct timer_list mesh_path_timer;
 	struct timer_list mesh_path_root_timer;
 
+	unsigned long timers_running;
+
 	unsigned long wrkq_flags;
 	unsigned long mbss_changed;
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 707ac61..e131293 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -13,6 +13,10 @@
 #include "ieee80211_i.h"
 #include "mesh.h"
 
+#define TMR_RUNNING_HK	0
+#define TMR_RUNNING_MP	1
+#define TMR_RUNNING_MPR	2
+
 static int mesh_allocated;
 static struct kmem_cache *rm_cache;
 
@@ -46,6 +50,11 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
 
 	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
 
+	if (local->quiescing) {
+		set_bit(TMR_RUNNING_HK, &ifmsh->timers_running);
+		return;
+	}
+
 	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
@@ -472,8 +481,15 @@ static void ieee80211_mesh_path_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct ieee80211_local *local = sdata->local;
 
-	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	if (local->quiescing) {
+		set_bit(TMR_RUNNING_MP, &ifmsh->timers_running);
+		return;
+	}
+
+	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
 static void ieee80211_mesh_path_root_timer(unsigned long data)
@@ -481,10 +497,16 @@ static void ieee80211_mesh_path_root_timer(unsigned long data)
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+	struct ieee80211_local *local = sdata->local;
 
 	set_bit(MESH_WORK_ROOT, &ifmsh->wrkq_flags);
 
-	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
+	if (local->quiescing) {
+		set_bit(TMR_RUNNING_MPR, &ifmsh->timers_running);
+		return;
+	}
+
+	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh)
@@ -602,6 +624,35 @@ static void ieee80211_mesh_rootpath(struct ieee80211_sub_if_data *sdata)
 		  round_jiffies(TU_TO_EXP_TIME(interval)));
 }
 
+#ifdef CONFIG_PM
+void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+
+	/* use atomic bitops in case all timers fire at the same time */
+
+	if (del_timer_sync(&ifmsh->housekeeping_timer))
+		set_bit(TMR_RUNNING_HK, &ifmsh->timers_running);
+	if (del_timer_sync(&ifmsh->mesh_path_timer))
+		set_bit(TMR_RUNNING_MP, &ifmsh->timers_running);
+	if (del_timer_sync(&ifmsh->mesh_path_root_timer))
+		set_bit(TMR_RUNNING_MPR, &ifmsh->timers_running);
+}
+
+void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+
+	if (test_and_clear_bit(TMR_RUNNING_HK, &ifmsh->timers_running))
+		add_timer(&ifmsh->housekeeping_timer);
+	if (test_and_clear_bit(TMR_RUNNING_MP, &ifmsh->timers_running))
+		add_timer(&ifmsh->mesh_path_timer);
+	if (test_and_clear_bit(TMR_RUNNING_MPR, &ifmsh->timers_running))
+		add_timer(&ifmsh->mesh_path_root_timer);
+	ieee80211_mesh_root_setup(ifmsh);
+}
+#endif
+
 static int
 ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 {
@@ -810,6 +861,8 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	local->fif_other_bss--;
 	atomic_dec(&local->iff_allmultis);
 	ieee80211_configure_filter(local);
+
+	sdata->u.mesh.timers_running = 0;
 }
 
 static void
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 2bc7fd2..6fd6ed6 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -315,6 +315,8 @@ void mesh_path_timer(unsigned long data);
 void mesh_path_flush_by_nexthop(struct sta_info *sta);
 void mesh_path_discard_frame(struct ieee80211_sub_if_data *sdata,
 			     struct sk_buff *skb);
+void mesh_path_quiesce(struct ieee80211_sub_if_data *sdata);
+void mesh_path_restart(struct ieee80211_sub_if_data *sdata);
 void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata);
 
 bool mesh_action_is_path_sel(struct ieee80211_mgmt *mgmt);
@@ -359,12 +361,22 @@ static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local);
 
+void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata);
+void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata);
+void mesh_plink_quiesce(struct sta_info *sta);
+void mesh_plink_restart(struct sta_info *sta);
 void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata);
 void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_stop(void);
 #else
 static inline void
 ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local) {}
+static inline void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
+{}
+static inline void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
+{}
+static inline void mesh_plink_quiesce(struct sta_info *sta) {}
+static inline void mesh_plink_restart(struct sta_info *sta) {}
 static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
 { return false; }
 static inline void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 6b65d50..2b18cc6 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -540,8 +540,10 @@ static void mesh_plink_timer(unsigned long data)
 	 */
 	sta = (struct sta_info *) data;
 
-	if (sta->sdata->local->quiescing)
+	if (sta->sdata->local->quiescing) {
+		sta->plink_timer_was_running = true;
 		return;
+	}
 
 	spin_lock_bh(&sta->lock);
 	if (sta->ignore_plink_timer) {
@@ -602,6 +604,29 @@ static void mesh_plink_timer(unsigned long data)
 	}
 }
 
+#ifdef CONFIG_PM
+void mesh_plink_quiesce(struct sta_info *sta)
+{
+	if (!ieee80211_vif_is_mesh(&sta->sdata->vif))
+		return;
+
+	/* no kernel mesh sta timers have been initialized */
+	if (sta->sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE)
+		return;
+
+	if (del_timer_sync(&sta->plink_timer))
+		sta->plink_timer_was_running = true;
+}
+
+void mesh_plink_restart(struct sta_info *sta)
+{
+	if (sta->plink_timer_was_running) {
+		add_timer(&sta->plink_timer);
+		sta->plink_timer_was_running = false;
+	}
+}
+#endif
+
 static inline void mesh_plink_timer_set(struct sta_info *sta, int timeout)
 {
 	sta->plink_timer.expires = jiffies + (HZ * timeout / 1000);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 4208dbd..3e750c7 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -282,6 +282,7 @@ struct sta_ampdu_mlme {
  * @plink_state: peer link state
  * @plink_timeout: timeout of peer link
  * @plink_timer: peer link watch timer
+ * @plink_timer_was_running: used by suspend/resume to restore timers
  * @t_offset: timing offset relative to this host
  * @t_offset_setpoint: reference timing offset of this sta to be used when
  * 	calculating clockdrift
@@ -388,6 +389,7 @@ struct sta_info {
 	__le16 reason;
 	u8 plink_retries;
 	bool ignore_plink_timer;
+	bool plink_timer_was_running;
 	enum nl80211_plink_state plink_state;
 	u32 plink_timeout;
 	struct timer_list plink_timer;
-- 
1.8.3.1

