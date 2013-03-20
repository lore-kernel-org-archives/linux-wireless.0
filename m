Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45707 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab3CTQcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 12:32:39 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v4] mac80211:  Don't restart sta-timer if not running.
Date: Wed, 20 Mar 2013 09:32:34 -0700
Message-Id: <1363797154-16312-1-git-send-email-greearb@candelatech.com> (sfid-20130320_173244_438568_C0316AC8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

I found another crash when deleting lots of virtual stations
in a congested environment.  I think the problem is that
the ieee80211_mlme_notify_scan_completed could call
ieee80211_restart_sta_timer for a stopped interface
that was about to be deleted.  Fix similar problem for
mesh interfaces as well.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
v4:  Fix up mesh as well, add check in calling code instead of
    in the methods that mucks iwth the timers.

:100644 100644 67fcfdf... 02e3d75... M	net/mac80211/mesh.c
:100644 100644 aec786d... 1d237e9... M	net/mac80211/mlme.c
 net/mac80211/mesh.c |    3 ++-
 net/mac80211/mlme.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 67fcfdf..02e3d75 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -779,7 +779,8 @@ void ieee80211_mesh_notify_scan_completed(struct ieee80211_local *local)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
-		if (ieee80211_vif_is_mesh(&sdata->vif))
+		if (ieee80211_sdata_running(sdata)
+		    && ieee80211_vif_is_mesh(&sdata->vif))
 			ieee80211_queue_work(&local->hw, &sdata->work);
 	rcu_read_unlock();
 }
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index aec786d..1d237e9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3054,7 +3054,8 @@ void ieee80211_mlme_notify_scan_completed(struct ieee80211_local *local)
 	/* Restart STA timers */
 	rcu_read_lock();
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
-		ieee80211_restart_sta_timer(sdata);
+		if (ieee80211_sdata_running(sdata))
+			ieee80211_restart_sta_timer(sdata);
 	rcu_read_unlock();
 }
 
-- 
1.7.3.4

