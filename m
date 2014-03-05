Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:36836 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbaCEMT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2014 07:19:26 -0500
Received: by mail-ea0-f170.google.com with SMTP id g15so992084eak.29
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2014 04:19:25 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: protect AP VLAN list with local->mtx
Date: Wed,  5 Mar 2014 13:14:08 +0100
Message-Id: <1394021648-22605-1-git-send-email-michal.kazior@tieto.com> (sfid-20140305_131931_110870_0F869A13)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was impossible to change chanctx of master AP
for AP VLANs because the copy function requires
RTNL which can't be simply taken in mac80211 code
due to possible deadlocks.

This is required for future chanctx reservation
that re-bind vifs to new chanctx. This requires
safe AP VLAN iteration without RTNL.

Now VLANs can be iterated while holding either
RTNL or local->mtx because the list is modified
while holding both of these locks.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/cfg.c         | 5 +++--
 net/mac80211/chan.c        | 2 +-
 net/mac80211/ieee80211_i.h | 4 ++--
 net/mac80211/iface.c       | 9 ++++++++-
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index aaa59d7..adf66a5 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -975,10 +975,11 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->radar_required = params->radar_required;
 	err = ieee80211_vif_use_channel(sdata, &params->chandef,
 					IEEE80211_CHANCTX_SHARED);
+	if (!err)
+		ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
 	mutex_unlock(&local->mtx);
 	if (err)
 		return err;
-	ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
 
 	/*
 	 * Apply control port protocol, this allows us to
@@ -1131,8 +1132,8 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps.bc_buf);
 	skb_queue_purge(&sdata->u.ap.ps.bc_buf);
 
-	ieee80211_vif_copy_chanctx_to_vlans(sdata, true);
 	mutex_lock(&local->mtx);
+	ieee80211_vif_copy_chanctx_to_vlans(sdata, true);
 	ieee80211_vif_release_channel(sdata);
 	mutex_unlock(&local->mtx);
 
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 42c6592..fdbb932 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -689,7 +689,7 @@ void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_sub_if_data *vlan;
 	struct ieee80211_chanctx_conf *conf;
 
-	ASSERT_RTNL();
+	lockdep_assert_held(&local->mtx);
 
 	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_AP))
 		return;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 8603dfb..2f662ca 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -260,7 +260,7 @@ struct ieee80211_if_ap {
 
 	/* to be used after channel switch. */
 	struct cfg80211_beacon_data *next_beacon;
-	struct list_head vlans;
+	struct list_head vlans; /* write-protected with RTNL and local->mtx */
 
 	struct ps_data ps;
 	atomic_t num_mcast_sta; /* number of stations receiving multicast */
@@ -276,7 +276,7 @@ struct ieee80211_if_wds {
 };
 
 struct ieee80211_if_vlan {
-	struct list_head list;
+	struct list_head list; /* write-protected with RTNL and local->mtx */
 
 	/* used for all tx if the VLAN is configured to 4-addr mode */
 	struct sta_info __rcu *sta;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index be198f4..c34095b 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -492,7 +492,9 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		if (!sdata->bss)
 			return -ENOLINK;
 
+		mutex_lock(&local->mtx);
 		list_add(&sdata->u.vlan.list, &sdata->bss->vlans);
+		mutex_unlock(&local->mtx);
 
 		master = container_of(sdata->bss,
 				      struct ieee80211_sub_if_data, u.ap);
@@ -722,8 +724,11 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 		drv_stop(local);
  err_del_bss:
 	sdata->bss = NULL;
-	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+		mutex_lock(&local->mtx);
 		list_del(&sdata->u.vlan.list);
+		mutex_unlock(&local->mtx);
+	}
 	/* might already be clear but that doesn't matter */
 	clear_bit(SDATA_STATE_RUNNING, &sdata->state);
 	return res;
@@ -875,7 +880,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
+		mutex_lock(&local->mtx);
 		list_del(&sdata->u.vlan.list);
+		mutex_unlock(&local->mtx);
 		rcu_assign_pointer(sdata->vif.chanctx_conf, NULL);
 		/* no need to tell driver */
 		break;
-- 
1.8.5.3

