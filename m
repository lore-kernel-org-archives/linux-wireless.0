Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59102 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758206Ab3E1LCE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 07:02:04 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2 2/3] mac80211: support active monitor interfaces
Date: Tue, 28 May 2013 13:01:53 +0200
Message-Id: <1369738914-34367-2-git-send-email-nbd@openwrt.org> (sfid-20130528_130208_828810_DCDB48E7)
In-Reply-To: <1369738914-34367-1-git-send-email-nbd@openwrt.org>
References: <1369738914-34367-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support them only if the driver advertises support for them via
IEEE80211_HW_SUPPORTS_ACTIVE_MONITOR. Unlike normal monitor interfaces,
they are added to the driver, along with their MAC address.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/cfg.c        | 11 +++++++----
 net/mac80211/driver-ops.h |  3 ++-
 net/mac80211/iface.c      | 29 +++++++++++++++++++++++------
 net/mac80211/util.c       |  6 ++++++
 4 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1a89c80..7f73859 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -73,16 +73,19 @@ static int ieee80211_change_iface(struct wiphy *wiphy,
 		struct ieee80211_local *local = sdata->local;
 
 		if (ieee80211_sdata_running(sdata)) {
+			u32 mask = MONITOR_FLAG_COOK_FRAMES |
+				   MONITOR_FLAG_ACTIVE;
+
 			/*
-			 * Prohibit MONITOR_FLAG_COOK_FRAMES to be
-			 * changed while the interface is up.
+			 * Prohibit MONITOR_FLAG_COOK_FRAMES and
+			 * MONITOR_FLAG_ACTIVE to be changed while the
+			 * interface is up.
 			 * Else we would need to add a lot of cruft
 			 * to update everything:
 			 *	cooked_mntrs, monitor and all fif_* counters
 			 *	reconfigure hardware
 			 */
-			if ((*flags & MONITOR_FLAG_COOK_FRAMES) !=
-			    (sdata->u.mntr_flags & MONITOR_FLAG_COOK_FRAMES))
+			if ((*flags & mask) != (sdata->u.mntr_flags & mask))
 				return -EBUSY;
 
 			ieee80211_adjust_monitor_flags(sdata, -1);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 169664c..b931c96 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -146,7 +146,8 @@ static inline int drv_add_interface(struct ieee80211_local *local,
 
 	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
 		    (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
-		     !(local->hw.flags & IEEE80211_HW_WANT_MONITOR_VIF))))
+		     !(local->hw.flags & IEEE80211_HW_WANT_MONITOR_VIF) &&
+		     !(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))))
 		return -EINVAL;
 
 	trace_drv_add_interface(local, sdata);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 60f1ce5..47e03e5 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -159,7 +159,8 @@ static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static int ieee80211_verify_mac(struct ieee80211_local *local, u8 *addr)
+static int ieee80211_verify_mac(struct ieee80211_local *local, u8 *addr,
+				bool check_dup)
 {
 	struct ieee80211_sub_if_data *sdata;
 	u64 new, mask, tmp;
@@ -179,10 +180,13 @@ static int ieee80211_verify_mac(struct ieee80211_local *local, u8 *addr)
 		((u64)m[2] << 3*8) | ((u64)m[3] << 2*8) |
 		((u64)m[4] << 1*8) | ((u64)m[5] << 0*8);
 
+	if (!check_dup)
+		return ret;
 
 	mutex_lock(&local->iflist_mtx);
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (sdata->vif.type == NL80211_IFTYPE_MONITOR)
+		if (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
+		    !(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))
 			continue;
 
 		m = sdata->vif.addr;
@@ -204,12 +208,17 @@ static int ieee80211_change_mac(struct net_device *dev, void *addr)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sockaddr *sa = addr;
+	bool check_dup = true;
 	int ret;
 
 	if (ieee80211_sdata_running(sdata))
 		return -EBUSY;
 
-	ret = ieee80211_verify_mac(sdata->local, sa->sa_data);
+	if (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
+	    !(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))
+		check_dup = false;
+
+	ret = ieee80211_verify_mac(sdata->local, sa->sa_data, check_dup);
 	if (ret)
 		return ret;
 
@@ -538,7 +547,11 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			break;
 		}
 
-		if (local->monitors == 0 && local->open_count == 0) {
+		if (sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE) {
+			res = drv_add_interface(local, sdata);
+			if (res)
+				goto err_stop;
+		} else if (local->monitors == 0 && local->open_count == 0) {
 			res = ieee80211_add_virtual_monitor(local);
 			if (res)
 				goto err_stop;
@@ -912,7 +925,11 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 		mutex_lock(&local->mtx);
 		ieee80211_recalc_idle(local);
 		mutex_unlock(&local->mtx);
-		break;
+
+		if (!(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))
+			break;
+
+		/* fall through */
 	default:
 		if (going_down)
 			drv_remove_interface(local, sdata);
@@ -1061,7 +1078,7 @@ static const struct net_device_ops ieee80211_monitorif_ops = {
 	.ndo_start_xmit		= ieee80211_monitor_start_xmit,
 	.ndo_set_rx_mode	= ieee80211_set_multicast_list,
 	.ndo_change_mtu 	= ieee80211_change_mtu,
-	.ndo_set_mac_address 	= eth_mac_addr,
+	.ndo_set_mac_address 	= ieee80211_change_mac,
 	.ndo_select_queue	= ieee80211_monitor_select_queue,
 };
 
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 27e0715..7cbe0db 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -560,6 +560,9 @@ void ieee80211_iterate_active_interfaces(
 	list_for_each_entry(sdata, &local->interfaces, list) {
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_MONITOR:
+			if (!(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))
+				continue;
+			break;
 		case NL80211_IFTYPE_AP_VLAN:
 			continue;
 		default:
@@ -598,6 +601,9 @@ void ieee80211_iterate_active_interfaces_atomic(
 	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_MONITOR:
+			if (!(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))
+				continue;
+			break;
 		case NL80211_IFTYPE_AP_VLAN:
 			continue;
 		default:
-- 
1.8.0.2

