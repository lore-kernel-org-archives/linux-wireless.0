Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45825 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2LKTt0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 14:49:26 -0500
Message-ID: <1355255384.9819.13.camel@jlt4.sipsolutions.net> (sfid-20121211_204930_159409_C973CA60)
Subject: [PATCH] mac80211: assign VLAN channel contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 11 Dec 2012 20:49:44 +0100
In-Reply-To: <1355255084.9819.12.camel@jlt4.sipsolutions.net> (sfid-20121211_204424_633539_836664E4)
References: <1355162256-34131-1-git-send-email-nbd@openwrt.org>
	 <1355162256-34131-2-git-send-email-nbd@openwrt.org>
	 <1355254666.9819.11.camel@jlt4.sipsolutions.net>
	 (sfid-20121211_203729_024742_AB210C1B) <1355255084.9819.12.camel@jlt4.sipsolutions.net>
	 (sfid-20121211_204424_633539_836664E4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Make AP_VLAN type interfaces track the AP master channel
context so they have one assigned for the various lookups.
Don't give them their own refcount etc. since they're just
slaves to the AP master.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/chan.c        | 38 ++++++++++++++++++++++++++++++++++++++
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/iface.c       | 10 +++++++---
 3 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 53f0312..80e5552 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -4,6 +4,7 @@
 
 #include <linux/nl80211.h>
 #include <linux/export.h>
+#include <linux/rtnetlink.h>
 #include <net/cfg80211.h>
 #include "ieee80211_i.h"
 #include "driver-ops.h"
@@ -197,6 +198,15 @@ static void __ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 
 	ctx = container_of(conf, struct ieee80211_chanctx, conf);
 
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		struct ieee80211_sub_if_data *vlan;
+
+		/* for the VLAN list */
+		ASSERT_RTNL();
+		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+			rcu_assign_pointer(vlan->vif.chanctx_conf, NULL);
+	}
+
 	ieee80211_unassign_vif_chanctx(sdata, ctx);
 	if (ctx->refcount == 0)
 		ieee80211_free_chanctx(local, ctx);
@@ -316,6 +326,15 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
+	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+		struct ieee80211_sub_if_data *vlan;
+
+		/* for the VLAN list */
+		ASSERT_RTNL();
+		list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+			rcu_assign_pointer(vlan->vif.chanctx_conf, &ctx->conf);
+	}
+
 	ieee80211_recalc_smps_chanctx(local, ctx);
  out:
 	mutex_unlock(&local->chanctx_mtx);
@@ -331,6 +350,25 @@ void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata)
 	mutex_unlock(&sdata->local->chanctx_mtx);
 }
 
+void ieee80211_vif_vlan_copy_chanctx(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_sub_if_data *ap;
+	struct ieee80211_chanctx_conf *conf;
+
+	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_AP_VLAN || !sdata->bss))
+		return;
+
+	ap = container_of(sdata->bss, struct ieee80211_sub_if_data, u.ap);
+
+	mutex_lock(&local->chanctx_mtx);
+
+	conf = rcu_dereference_protected(ap->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	rcu_assign_pointer(sdata->vif.chanctx_conf, conf);
+	mutex_unlock(&local->chanctx_mtx);
+}
+
 void ieee80211_iter_chan_contexts_atomic(
 	struct ieee80211_hw *hw,
 	void (*iter)(struct ieee80211_hw *hw,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 53e97dc..2f3893f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1626,6 +1626,7 @@ ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 			  const struct cfg80211_chan_def *chandef,
 			  enum ieee80211_chanctx_mode mode);
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
+void ieee80211_vif_vlan_copy_chanctx(struct ieee80211_sub_if_data *sdata);
 
 void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *chanctx);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 09a80b5..4a293de 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -508,6 +508,7 @@ static void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	struct ieee80211_sub_if_data *ap;
 	struct net_device *dev = wdev->netdev;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
@@ -586,11 +587,13 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
-		/* no need to tell driver, but set carrier */
-		if (rtnl_dereference(sdata->bss->beacon))
+		/* no need to tell driver, but set carrier and chanctx */
+		if (rtnl_dereference(sdata->bss->beacon)) {
+			ieee80211_vif_vlan_copy_chanctx(sdata);
 			netif_carrier_on(dev);
-		else
+		} else {
 			netif_carrier_off(dev);
+		}
 		break;
 	case NL80211_IFTYPE_MONITOR:
 		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) {
@@ -839,6 +842,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
 		list_del(&sdata->u.vlan.list);
+		rcu_assign_pointer(sdata->vif.chanctx_conf, NULL);
 		/* no need to tell driver */
 		break;
 	case NL80211_IFTYPE_MONITOR:
-- 
1.8.0



