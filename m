Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59112 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946228Ab3BHLOg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 06:14:36 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] mac80211: explicitly copy channels to VLANs where needed
Date: Fri,  8 Feb 2013 12:14:32 +0100
Message-Id: <1360322072-17239-1-git-send-email-johannes@sipsolutions.net> (sfid-20130208_121440_204800_57254D40)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Currently the code assigns channel contexts to VLANs
(for use by the TX/RX code) when the AP master gets
its channel context assigned. This works fine, but
in the upcoming radar detection work the VLANs don't
require a channel context (during radar detection)
and assigning one to them anyway causes issues with
locking and also inconsistencies -- a VLAN interface
that is added before radar detection would get the
channel context, while one added during it wouldn't.

Fix these issues moving the channel context copying
to a new explicit operation that will not be used
in the radar detection code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c         |  2 ++
 net/mac80211/chan.c        | 52 ++++++++++++++++++++++++++++++----------------
 net/mac80211/ieee80211_i.h |  2 ++
 3 files changed, 38 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 799e706..68eca17 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -933,6 +933,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 					IEEE80211_CHANCTX_SHARED);
 	if (err)
 		return err;
+	ieee80211_vif_copy_chanctx_to_vlans(sdata, false);
 
 	/*
 	 * Apply control port protocol, this allows us to
@@ -1047,6 +1048,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	local->total_ps_buffered -= skb_queue_len(&sdata->u.ap.ps.bc_buf);
 	skb_queue_purge(&sdata->u.ap.ps.bc_buf);
 
+	ieee80211_vif_copy_chanctx_to_vlans(sdata, true);
 	ieee80211_vif_release_channel(sdata);
 
 	return 0;
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index ad35185..bf10da6 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -211,15 +211,6 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 
 	ctx = container_of(conf, struct ieee80211_chanctx, conf);
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP) {
-		struct ieee80211_sub_if_data *vlan;
-
-		/* for the VLAN list */
-		ASSERT_RTNL();
-		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
-			rcu_assign_pointer(vlan->vif.chanctx_conf, NULL);
-	}
-
 	ieee80211_unassign_vif_chanctx(sdata, ctx);
 	if (ctx->refcount == 0)
 		ieee80211_free_chanctx(local, ctx);
@@ -339,15 +330,6 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP) {
-		struct ieee80211_sub_if_data *vlan;
-
-		/* for the VLAN list */
-		ASSERT_RTNL();
-		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
-			rcu_assign_pointer(vlan->vif.chanctx_conf, &ctx->conf);
-	}
-
 	ieee80211_recalc_smps_chanctx(local, ctx);
  out:
 	mutex_unlock(&local->chanctx_mtx);
@@ -430,6 +412,40 @@ void ieee80211_vif_vlan_copy_chanctx(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&local->chanctx_mtx);
 }
 
+void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
+					 bool clear)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sub_if_data *vlan;
+	struct ieee80211_chanctx_conf *conf;
+
+	ASSERT_RTNL();
+
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_AP))
+		return;
+
+	mutex_lock(&local->chanctx_mtx);
+
+	/*
+	 * Check that conf exists, even when clearing this function
+	 * must be called with the AP's channel context still there
+	 * as it would otherwise cause VLANs to have an invalid
+	 * channel context pointer for a while, possibly pointing
+	 * to a channel context that has already been freed.
+	 */
+	conf = rcu_dereference_protected(sdata->vif.chanctx_conf,
+				lockdep_is_held(&local->chanctx_mtx));
+	WARN_ON(!conf);
+
+	if (clear)
+		conf = NULL;
+
+	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+		rcu_assign_pointer(vlan->vif.chanctx_conf, conf);
+
+	mutex_unlock(&local->chanctx_mtx);
+}
+
 void ieee80211_iter_chan_contexts_atomic(
 	struct ieee80211_hw *hw,
 	void (*iter)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 816bebb..f016507 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1614,6 +1614,8 @@ ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
 			       const struct cfg80211_chan_def *chandef);
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vif_vlan_copy_chanctx(struct ieee80211_sub_if_data *sdata);
+void ieee80211_vif_copy_chanctx_to_vlans(struct ieee80211_sub_if_data *sdata,
+					 bool clear);
 
 void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *chanctx);
-- 
1.8.0

