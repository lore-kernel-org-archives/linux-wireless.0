Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:35986 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578Ab1F3T0g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 15:26:36 -0400
Received: by fxd18 with SMTP id 18so2559976fxd.11
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2011 12:26:35 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Thu, 30 Jun 2011 21:08:43 +0200
Subject: [PATCH] mac80211: fix smatch complains
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Message-Id: <E1QcMuC-0001AU-M4@debian64.daheim> (sfid-20110630_212642_556152_332E7C1A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mlme.c
	l.757 ieee80211_dynamic_ps_enable_work(11)
	variable dereferenced before check 'sdata'

mesh_pathtbl.c
	l.650 mesh_path_del(20) double lock 'bottom_half'
	l.663 mesh_path_del(33) double unlock 'bottom_half'

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 net/mac80211/mesh_pathtbl.c |    4 ++--
 net/mac80211/mlme.c         |    4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index 0d2faac..068ee65 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -647,12 +647,12 @@ int mesh_path_del(u8 *addr, struct ieee80211_sub_if_data *sdata)
 		mpath = node->mpath;
 		if (mpath->sdata == sdata &&
 		    memcmp(addr, mpath->dst, ETH_ALEN) == 0) {
-			spin_lock_bh(&mpath->state_lock);
+			spin_lock(&mpath->state_lock);
 			mpath->flags |= MESH_PATH_RESOLVING;
 			hlist_del_rcu(&node->list);
 			call_rcu(&node->rcu, mesh_path_node_reclaim);
 			atomic_dec(&tbl->entries);
-			spin_unlock_bh(&mpath->state_lock);
+			spin_unlock(&mpath->state_lock);
 			goto enddel;
 		}
 	}
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index b874200..182cda6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -749,7 +749,7 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 		container_of(work, struct ieee80211_local,
 			     dynamic_ps_enable_work);
 	struct ieee80211_sub_if_data *sdata = local->ps_sdata;
-	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_if_managed *ifmgd;
 	unsigned long flags;
 	int q;
 
@@ -757,6 +757,8 @@ void ieee80211_dynamic_ps_enable_work(struct work_struct *work)
 	if (!sdata)
 		return;
 
+	ifmgd = &sdata->u.mgd;
+
 	if (local->hw.conf.flags & IEEE80211_CONF_PS)
 		return;
 
-- 
1.7.5.4

