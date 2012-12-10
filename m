Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48130 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab2LJTCh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 14:02:37 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2 2/2] mac80211: fix AP_VLAN channel context handling
Date: Mon, 10 Dec 2012 20:02:35 +0100
Message-Id: <1355166155-78532-2-git-send-email-nbd@openwrt.org> (sfid-20121210_200241_246807_822911D2)
In-Reply-To: <1355166155-78532-1-git-send-email-nbd@openwrt.org>
References: <1355166155-78532-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When .start_ap is called, copy the channel context to all active AP VLANs.
Also copy the channel context when bringing up/down an AP VLAN if the AP
has been started already.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/cfg.c   |  5 +++++
 net/mac80211/iface.c | 13 ++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a5d4361..b0a20ac 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -915,6 +915,10 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	if (err)
 		return err;
 
+	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+		rcu_assign_pointer(vlan->vif.chanctx_conf,
+				   rcu_access_pointer(sdata->vif.chanctx_conf));
+
 	/*
 	 * Apply control port protocol, this allows us to
 	 * not encrypt dynamic WEP control frames.
@@ -1001,6 +1005,7 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
 	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list) {
 		sta_info_flush(local, vlan);
 		netif_carrier_off(vlan->dev);
+		rcu_assign_pointer(sdata->vif.chanctx_conf, NULL);
 	}
 	netif_carrier_off(dev);
 
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 40c36d5..c2deb2a 100644
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
@@ -587,10 +588,15 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
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
+		ap = get_bss_sdata(sdata);
+		rcu_assign_pointer(sdata->vif.chanctx_conf,
+				   rcu_access_pointer(ap->vif.chanctx_conf));
+		netif_carrier_on(dev);
 		break;
 	case NL80211_IFTYPE_MONITOR:
 		if (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES) {
@@ -839,6 +845,7 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 	switch (sdata->vif.type) {
 	case NL80211_IFTYPE_AP_VLAN:
 		list_del(&sdata->u.vlan.list);
+		rcu_assign_pointer(sdata->vif.chanctx_conf, NULL);
 		/* no need to tell driver */
 		break;
 	case NL80211_IFTYPE_MONITOR:
-- 
1.7.12.2

