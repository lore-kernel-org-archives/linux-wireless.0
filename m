Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51400 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab3EZOFN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 May 2013 10:05:13 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 2/3] mac80211: support active monitor interfaces
Date: Sun, 26 May 2013 16:05:06 +0200
Message-Id: <1369577107-87931-2-git-send-email-nbd@openwrt.org> (sfid-20130526_160534_566142_6E571774)
In-Reply-To: <1369577107-87931-1-git-send-email-nbd@openwrt.org>
References: <1369577107-87931-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support them only if the driver advertises support for them via
IEEE80211_HW_SUPPORTS_ACTIVE_MONITOR. Unlike normal monitor interfaces,
they are added to the driver, along with their MAC address.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/net/mac80211.h     |  5 +++++
 net/mac80211/cfg.c         | 11 +++++++----
 net/mac80211/driver-ops.h  |  3 ++-
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/iface.c       | 33 ++++++++++++++++++++++++++-------
 net/mac80211/util.c        |  6 ++++++
 6 files changed, 47 insertions(+), 13 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 885898a..b80c5cd 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1455,6 +1455,10 @@ struct ieee80211_tx_control {
  *
  * @IEEE80211_HW_TIMING_BEACON_ONLY: Use sync timing from beacon frames
  *	only, to allow getting TBTT of a DTIM beacon.
+ *
+ * @IEEE80211_HW_SUPPORTS_ACTIVE_MONITOR: Device supports an active monitor
+ *	interface that responds to unicast packets directed at its MAC
+ *	address.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1484,6 +1488,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_RC_TABLE			= 1<<24,
 	IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF		= 1<<25,
 	IEEE80211_HW_TIMING_BEACON_ONLY			= 1<<26,
+	IEEE80211_HW_SUPPORTS_ACTIVE_MONITOR		= 1<<27,
 };
 
 /**
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
index 169664c..5844f68 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -146,7 +146,8 @@ static inline int drv_add_interface(struct ieee80211_local *local,
 
 	if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
 		    (sdata->vif.type == NL80211_IFTYPE_MONITOR &&
-		     !(local->hw.flags & IEEE80211_HW_WANT_MONITOR_VIF))))
+		     !(local->hw.flags & IEEE80211_HW_WANT_MONITOR_VIF) &&
+			 !(sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE))))
 		return -EINVAL;
 
 	trace_drv_add_interface(local, sdata);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 44be28c..280170a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -892,7 +892,7 @@ struct ieee80211_local {
 	spinlock_t queue_stop_reason_lock;
 
 	int open_count;
-	int monitors, cooked_mntrs;
+	int monitors, cooked_mntrs, active_mntrs;
 	/* number of interfaces with corresponding FIF_ flags */
 	int fif_fcsfail, fif_plcpfail, fif_control, fif_other_bss, fif_pspoll,
 	    fif_probe_req;
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 60f1ce5..234503f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -209,9 +209,11 @@ static int ieee80211_change_mac(struct net_device *dev, void *addr)
 	if (ieee80211_sdata_running(sdata))
 		return -EBUSY;
 
-	ret = ieee80211_verify_mac(sdata->local, sa->sa_data);
-	if (ret)
-		return ret;
+	if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
+		ret = ieee80211_verify_mac(sdata->local, sa->sa_data);
+		if (ret)
+			return ret;
+	}
 
 	ret = eth_mac_addr(dev, sa);
 
@@ -479,9 +481,13 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 	case NL80211_IFTYPE_AP:
 		sdata->bss = &sdata->u.ap;
 		break;
+	case NL80211_IFTYPE_MONITOR:
+		if ((sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE) &&
+		    !(local->hw.flags & IEEE80211_HW_SUPPORTS_ACTIVE_MONITOR))
+			return -EOPNOTSUPP;
+		break;
 	case NL80211_IFTYPE_MESH_POINT:
 	case NL80211_IFTYPE_STATION:
-	case NL80211_IFTYPE_MONITOR:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_P2P_DEVICE:
 		/* no special treatment */
@@ -538,7 +544,13 @@ int ieee80211_do_open(struct wireless_dev *wdev, bool coming_up)
 			break;
 		}
 
-		if (local->monitors == 0 && local->open_count == 0) {
+		if (sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE) {
+			res = drv_add_interface(local, sdata);
+			if (res)
+				goto err_stop;
+
+			local->active_mntrs++;
+		} else if (local->monitors == 0 && local->open_count == 0) {
 			res = ieee80211_add_virtual_monitor(local);
 			if (res)
 				goto err_stop;
@@ -831,6 +843,9 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
 			break;
 		}
 
+		if (sdata->u.mntr_flags & MONITOR_FLAG_ACTIVE)
+			local->active_mntrs--;
+
 		local->monitors--;
 		if (local->monitors == 0) {
 			local->hw.conf.flags &= ~IEEE80211_CONF_MONITOR;
@@ -912,7 +927,11 @@ static void ieee80211_do_stop(struct ieee80211_sub_if_data *sdata,
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
@@ -1061,7 +1080,7 @@ static const struct net_device_ops ieee80211_monitorif_ops = {
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

