Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44501 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab2HATMg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 15:12:36 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: clear timer bits when disconnecting
Date: Wed,  1 Aug 2012 21:12:33 +0200
Message-Id: <1343848353-9509-1-git-send-email-johannes@sipsolutions.net> (sfid-20120801_211302_048067_451C91C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's a corner case that can happen when we
suspend with a timer running, then resume and
disconnect. If we connect again, suspend and
resume we might start timers that shouldn't be
running. Reset the timer flags to avoid this.

This affects both mesh and managed modes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh.c |    2 ++
 net/mac80211/mlme.c |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 6fac18c..d60b3d3 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -634,6 +634,8 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 	local->fif_other_bss--;
 	atomic_dec(&local->iff_allmultis);
 	ieee80211_configure_filter(local);
+
+	sdata->u.mesh.timers_running = 0;
 }
 
 static void ieee80211_mesh_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cef0c9e..a4a5acd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1430,6 +1430,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	del_timer_sync(&sdata->u.mgd.bcn_mon_timer);
 	del_timer_sync(&sdata->u.mgd.timer);
 	del_timer_sync(&sdata->u.mgd.chswitch_timer);
+
+	sdata->u.mgd.timers_running = 0;
 }
 
 void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
-- 
1.7.10.4

