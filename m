Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab3B1Jz0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 04:55:26 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v3 5/6] mac80211: cleanup suspend/resume on mesh mode
Date: Thu, 28 Feb 2013 10:55:29 +0100
Message-Id: <1362045330-2018-5-git-send-email-sgruszka@redhat.com> (sfid-20130228_105530_697592_5BF8CCFB)
In-Reply-To: <1362045330-2018-1-git-send-email-sgruszka@redhat.com>
References: <1362045330-2018-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove not used any longer suspend/resume code.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/ieee80211_i.h |  2 --
 net/mac80211/mesh.c        | 57 ++--------------------------------------------
 net/mac80211/mesh.h        | 12 ----------
 net/mac80211/mesh_plink.c  | 27 +---------------------
 net/mac80211/sta_info.h    |  2 --
 5 files changed, 3 insertions(+), 97 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e73f7b8..8d9b45c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -540,8 +540,6 @@ struct ieee80211_if_mesh {
 	struct timer_list mesh_path_timer;
 	struct timer_list mesh_path_root_timer;
 
-	unsigned long timers_running;
-
 	unsigned long wrkq_flags;
 
 	u8 mesh_id[IEEE80211_MAX_MESH_ID_LEN];
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 29ce2aa..f5d1afa 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -13,10 +13,6 @@
 #include "ieee80211_i.h"
 #include "mesh.h"
 
-#define TMR_RUNNING_HK	0
-#define TMR_RUNNING_MP	1
-#define TMR_RUNNING_MPR	2
-
 static int mesh_allocated;
 static struct kmem_cache *rm_cache;
 
@@ -50,11 +46,6 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
 
 	set_bit(MESH_WORK_HOUSEKEEPING, &ifmsh->wrkq_flags);
 
-	if (local->quiescing) {
-		set_bit(TMR_RUNNING_HK, &ifmsh->timers_running);
-		return;
-	}
-
 	ieee80211_queue_work(&local->hw, &sdata->work);
 }
 
@@ -479,15 +470,8 @@ static void ieee80211_mesh_path_timer(unsigned long data)
 {
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct ieee80211_local *local = sdata->local;
-
-	if (local->quiescing) {
-		set_bit(TMR_RUNNING_MP, &ifmsh->timers_running);
-		return;
-	}
 
-	ieee80211_queue_work(&local->hw, &sdata->work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 }
 
 static void ieee80211_mesh_path_root_timer(unsigned long data)
@@ -495,16 +479,10 @@ static void ieee80211_mesh_path_root_timer(unsigned long data)
 	struct ieee80211_sub_if_data *sdata =
 		(struct ieee80211_sub_if_data *) data;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	struct ieee80211_local *local = sdata->local;
 
 	set_bit(MESH_WORK_ROOT, &ifmsh->wrkq_flags);
 
-	if (local->quiescing) {
-		set_bit(TMR_RUNNING_MPR, &ifmsh->timers_running);
-		return;
-	}
-
-	ieee80211_queue_work(&local->hw, &sdata->work);
+	ieee80211_queue_work(&sdata->local->hw, &sdata->work);
 }
 
 void ieee80211_mesh_root_setup(struct ieee80211_if_mesh *ifmsh)
@@ -622,35 +600,6 @@ static void ieee80211_mesh_rootpath(struct ieee80211_sub_if_data *sdata)
 		  round_jiffies(TU_TO_EXP_TIME(interval)));
 }
 
-#ifdef CONFIG_PM
-void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-
-	/* use atomic bitops in case all timers fire at the same time */
-
-	if (del_timer_sync(&ifmsh->housekeeping_timer))
-		set_bit(TMR_RUNNING_HK, &ifmsh->timers_running);
-	if (del_timer_sync(&ifmsh->mesh_path_timer))
-		set_bit(TMR_RUNNING_MP, &ifmsh->timers_running);
-	if (del_timer_sync(&ifmsh->mesh_path_root_timer))
-		set_bit(TMR_RUNNING_MPR, &ifmsh->timers_running);
-}
-
-void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
-{
-	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-
-	if (test_and_clear_bit(TMR_RUNNING_HK, &ifmsh->timers_running))
-		add_timer(&ifmsh->housekeeping_timer);
-	if (test_and_clear_bit(TMR_RUNNING_MP, &ifmsh->timers_running))
-		add_timer(&ifmsh->mesh_path_timer);
-	if (test_and_clear_bit(TMR_RUNNING_MPR, &ifmsh->timers_running))
-		add_timer(&ifmsh->mesh_path_root_timer);
-	ieee80211_mesh_root_setup(ifmsh);
-}
-#endif
-
 static int
 ieee80211_mesh_build_beacon(struct ieee80211_if_mesh *ifmsh)
 {
@@ -871,8 +820,6 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	local->fif_other_bss--;
 	atomic_dec(&local->iff_allmultis);
 	ieee80211_configure_filter(local);
-
-	sdata->u.mesh.timers_running = 0;
 }
 
 static void
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index 336c88a..6ffabbe 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -313,8 +313,6 @@ void mesh_path_timer(unsigned long data);
 void mesh_path_flush_by_nexthop(struct sta_info *sta);
 void mesh_path_discard_frame(struct ieee80211_sub_if_data *sdata,
 			     struct sk_buff *skb);
-void mesh_path_quiesce(struct ieee80211_sub_if_data *sdata);
-void mesh_path_restart(struct ieee80211_sub_if_data *sdata);
 void mesh_path_tx_root_frame(struct ieee80211_sub_if_data *sdata);
 
 bool mesh_action_is_path_sel(struct ieee80211_mgmt *mgmt);
@@ -359,22 +357,12 @@ static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
 
 void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local);
 
-void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata);
-void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata);
-void mesh_plink_quiesce(struct sta_info *sta);
-void mesh_plink_restart(struct sta_info *sta);
 void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata);
 void mesh_sync_adjust_tbtt(struct ieee80211_sub_if_data *sdata);
 void ieee80211s_stop(void);
 #else
 static inline void
 ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local) {}
-static inline void ieee80211_mesh_quiesce(struct ieee80211_sub_if_data *sdata)
-{}
-static inline void ieee80211_mesh_restart(struct ieee80211_sub_if_data *sdata)
-{}
-static inline void mesh_plink_quiesce(struct sta_info *sta) {}
-static inline void mesh_plink_restart(struct sta_info *sta) {}
 static inline bool mesh_path_sel_is_hwmp(struct ieee80211_sub_if_data *sdata)
 { return false; }
 static inline void mesh_path_flush_by_iface(struct ieee80211_sub_if_data *sdata)
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 07d396d..08df966 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -534,10 +534,8 @@ static void mesh_plink_timer(unsigned long data)
 	 */
 	sta = (struct sta_info *) data;
 
-	if (sta->sdata->local->quiescing) {
-		sta->plink_timer_was_running = true;
+	if (sta->sdata->local->quiescing)
 		return;
-	}
 
 	spin_lock_bh(&sta->lock);
 	if (sta->ignore_plink_timer) {
@@ -598,29 +596,6 @@ static void mesh_plink_timer(unsigned long data)
 	}
 }
 
-#ifdef CONFIG_PM
-void mesh_plink_quiesce(struct sta_info *sta)
-{
-	if (!ieee80211_vif_is_mesh(&sta->sdata->vif))
-		return;
-
-	/* no kernel mesh sta timers have been initialized */
-	if (sta->sdata->u.mesh.security != IEEE80211_MESH_SEC_NONE)
-		return;
-
-	if (del_timer_sync(&sta->plink_timer))
-		sta->plink_timer_was_running = true;
-}
-
-void mesh_plink_restart(struct sta_info *sta)
-{
-	if (sta->plink_timer_was_running) {
-		add_timer(&sta->plink_timer);
-		sta->plink_timer_was_running = false;
-	}
-}
-#endif
-
 static inline void mesh_plink_timer_set(struct sta_info *sta, int timeout)
 {
 	sta->plink_timer.expires = jiffies + (HZ * timeout / 1000);
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 4947341..e5868c3 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -281,7 +281,6 @@ struct sta_ampdu_mlme {
  * @plink_state: peer link state
  * @plink_timeout: timeout of peer link
  * @plink_timer: peer link watch timer
- * @plink_timer_was_running: used by suspend/resume to restore timers
  * @t_offset: timing offset relative to this host
  * @t_offset_setpoint: reference timing offset of this sta to be used when
  * 	calculating clockdrift
@@ -379,7 +378,6 @@ struct sta_info {
 	__le16 reason;
 	u8 plink_retries;
 	bool ignore_plink_timer;
-	bool plink_timer_was_running;
 	enum nl80211_plink_state plink_state;
 	u32 plink_timeout;
 	struct timer_list plink_timer;
-- 
1.7.11.7

