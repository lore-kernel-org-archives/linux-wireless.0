Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58198 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab2LJR5j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 12:57:39 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 2/2] mac80211: fix AP_VLAN channel context handling
Date: Mon, 10 Dec 2012 18:57:36 +0100
Message-Id: <1355162256-34131-2-git-send-email-nbd@openwrt.org> (sfid-20121210_185750_689444_B172CEF6)
In-Reply-To: <1355162256-34131-1-git-send-email-nbd@openwrt.org>
References: <1355162256-34131-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When .start_ap is called, copy the channel context to all active AP VLANs.
Also copy the channel context when bringing up/down an AP VLAN if the AP
has been started already.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/cfg.c         |  7 +++++++
 net/mac80211/chan.c        | 38 +++++++++++++++++++++++++++++++++-----
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/iface.c       | 13 ++++++++++---
 4 files changed, 52 insertions(+), 8 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a5d4361..da31909 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -915,6 +915,12 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (err)
 		return err;
 
+	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
+		err = ieee80211_vif_copy_channel(vlan, sdata);
+		if (err)
+			return err;
+	}
+
 	/*
 	 * Apply control port protocol, this allows us to
 	 * not encrypt dynamic WEP control frames.
@@ -1001,6 +1007,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
 		sta_info_flush(local, vlan);
 		netif_carrier_off(vlan->dev);
+		ieee80211_vif_release_channel(vlan);
 	}
 	netif_carrier_off(dev);
 
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 53f0312..bc504f0 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -119,14 +119,17 @@ static int ieee80211_assign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
-	ret = drv_assign_vif_chanctx(local, sdata, ctx);
-	if (ret)
-		return ret;
+	if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN) {
+		ret = drv_assign_vif_chanctx(local, sdata, ctx);
+		if (ret)
+			return ret;
+	}
 
 	rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
 	ctx->refcount++;
 
-	ieee80211_recalc_txpower(sdata);
+	if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
+		ieee80211_recalc_txpower(sdata);
 
 	return 0;
 }
@@ -174,7 +177,8 @@ static void ieee80211_unassign_vif_chanctx(struct ieee80211_sub_if_data *sdata,
 	ctx->refcount--;
 	rcu_assign_pointer(sdata->vif.chanctx_conf, NULL);
 
-	drv_unassign_vif_chanctx(local, sdata, ctx);
+	if (sdata->vif.type != NL80211_IFTYPE_AP_VLAN)
+		drv_unassign_vif_chanctx(local, sdata, ctx);
 
 	if (ctx->refcount > 0) {
 		ieee80211_recalc_chanctx_chantype(sdata->local, ctx);
@@ -285,6 +289,30 @@ void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 	drv_change_chanctx(local, chanctx, IEEE80211_CHANCTX_CHANGE_RX_CHAINS);
 }
 
+int ieee80211_vif_copy_channel(struct ieee80211_sub_if_data *sdata,
+			       struct ieee80211_sub_if_data *parent)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *conf;
+	struct ieee80211_chanctx *ctx;
+
+	int ret;
+
+	mutex_lock(&local->chanctx_mtx);
+	conf = rcu_dereference_protected(parent->vif.chanctx_conf,
+					 lockdep_is_held(&local->chanctx_mtx));
+	if (!conf) {
+		ret = -ENOENT;
+		goto out;
+	}
+
+	ctx = container_of(conf, struct ieee80211_chanctx, conf);
+	ret = ieee80211_assign_vif_chanctx(sdata, ctx);
+out:
+	mutex_unlock(&local->chanctx_mtx);
+	return ret;
+}
+
 int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 			      const struct cfg80211_chan_def *chandef,
 			      enum ieee80211_chanctx_mode mode)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 42d0d02..d223841 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1628,6 +1628,8 @@ ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 			  const struct cfg80211_chan_def *chandef,
 			  enum ieee80211_chanctx_mode mode);
 void ieee80211_vif_release_channel(struct ieee80211_sub_if_data *sdata);
+int ieee80211_vif_copy_channel(struct ieee80211_sub_if_data *sdata,
+			       struct ieee80211_sub_if_data *parent);
 
 void ieee80211_recalc_smps_chanctx(struct ieee80211_local *local,
 				   struct ieee80211_chanctx *chanctx);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 40c36d5..1da2f23 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -508,6 +508,7 @@ static void ieee80211_del_virtual_monitor(struct ieee80211_local *local)
 int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+	struct ieee80211_sub_if_data *ap_sdata;
 	struct net_device *dev = wdev->netdev;
 	struct ieee80211_local *local = sdata->local;
 	struct sta_info *sta;
@@ -587,10 +588,14 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
 		/* no need to tell driver, but set carrier */
-		if (rtnl_dereference(sdata->bss->beacon))
-			netif_carrier_on(dev);
-		else
+		if (!rtnl_dereference(sdata->bss->beacon)) {
 			netif_carrier_off(dev);
+			break;
+		}
+
+		ap_sdata = get_bss_sdata(sdata);
+		ieee80211_vif_copy_channel(sdata, ap_sdata);
+		netif_carrier_on(dev);
 		break;
 	case NL80211_IFTYPE_MONITOR:
 		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) {
@@ -839,6 +844,8 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
 		list_del(&sdata->u.vlan.list);
+		netif_carrier_off(sdata->dev);
+		ieee80211_vif_release_channel(sdata);
 		/* no need to tell driver */
 		break;
 	case NL80211_IFTYPE_MONITOR:
-- 
1.7.12.2

