Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:35816 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582AbZHDWG1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 18:06:27 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 15:06:28 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211: fix compilation of mesh (although its disabled)
Date: Tue, 4 Aug 2009 15:06:26 -0700
Message-ID: <1249423586-11525-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh is currently disabled on mac80211, its marked
as broken. This patch gets it to compile though,
to account for the mac80211 workqueue changes.
There was a simple typo in the patches for mesh
for the workqueue migration, but we never compile
tested it as we couldn't even select mesh as its
broken. Lets at least let it compile for those
interested in getting it fixed.

Reported-by: Pat Erley <pat-lkml@erley.org>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Found this out by compiling against compat-wireless which always
had it enabled, heh.

 net/mac80211/mesh.c      |   10 +++++-----
 net/mac80211/mesh_hwmp.c |    4 ++--
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 2f4f518..8c068e2 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -54,7 +54,7 @@ static void ieee80211_mesh_housekeeping_timer(unsigned long data)
 		return;
 	}
 
-	ieee80211_queue_work(local->hw.workqueue, &ifmsh->work);
+	ieee80211_queue_work(&local->hw, &ifmsh->work);
 }
 
 /**
@@ -357,7 +357,7 @@ static void ieee80211_mesh_path_timer(unsigned long data)
 		return;
 	}
 
-	ieee80211_queue_work(local->hw.workqueue, &ifmsh->work);
+	ieee80211_queue_work(&local->hw, &ifmsh->work);
 }
 
 struct mesh_table *mesh_table_grow(struct mesh_table *tbl)
@@ -471,7 +471,7 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	struct ieee80211_local *local = sdata->local;
 
 	ifmsh->housekeeping = true;
-	ieee80211_queue_work(local->hw.workqueue, &ifmsh->work);
+	ieee80211_queue_work(&local->hw, &ifmsh->work);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED);
 }
@@ -619,7 +619,7 @@ void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local)
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
 		if (ieee80211_vif_is_mesh(&sdata->vif))
-			ieee80211_queue_work(local->hw.workqueue, &sdata->u.mesh.work);
+			ieee80211_queue_work(&local->hw, &sdata->u.mesh.work);
 	rcu_read_unlock();
 }
 
@@ -692,7 +692,7 @@ ieee80211_mesh_rx_mgmt(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
 	case IEEE80211_STYPE_PROBE_RESP:
 	case IEEE80211_STYPE_BEACON:
 		skb_queue_tail(&ifmsh->skb_queue, skb);
-		ieee80211_queue_work(local->hw.workqueue, &ifmsh->work);
+		ieee80211_queue_work(&local->hw, &ifmsh->work);
 		return RX_QUEUED;
 	}
 
diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
index 11ab71a..e1a763e 100644
--- a/net/mac80211/mesh_hwmp.c
+++ b/net/mac80211/mesh_hwmp.c
@@ -660,14 +660,14 @@ static void mesh_queue_preq(struct mesh_path *mpath, u8 flags)
 	spin_unlock(&ifmsh->mesh_preq_queue_lock);
 
 	if (time_after(jiffies, ifmsh->last_preq + min_preq_int_jiff(sdata)))
-		ieee80211_queue_work(sdata->local->hw.workqueue, &ifmsh->work);
+		ieee80211_queue_work(&sdata->local->hw, &ifmsh->work);
 
 	else if (time_before(jiffies, ifmsh->last_preq)) {
 		/* avoid long wait if did not send preqs for a long time
 		 * and jiffies wrapped around
 		 */
 		ifmsh->last_preq = jiffies - min_preq_int_jiff(sdata) - 1;
-		ieee80211_queue_work(sdata->local->hw.workqueue, &ifmsh->work);
+		ieee80211_queue_work(&sdata->local->hw, &ifmsh->work);
 	} else
 		mod_timer(&ifmsh->mesh_path_timer, ifmsh->last_preq +
 						min_preq_int_jiff(sdata));
-- 
1.6.3.3

