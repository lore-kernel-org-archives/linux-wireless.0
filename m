Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab2JOSRA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 14:17:00 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Hila Gonen <hila.gonen@intel.com>
Subject: [PATCH 1/3] cfg80211: add wrappers for registered_device_ops
Date: Mon, 15 Oct 2012 20:17:28 +0200
Message-Id: <1350325050-6994-2-git-send-email-johannes@sipsolutions.net> (sfid-20121015_201706_239196_F12A1AA6)
In-Reply-To: <1350325050-6994-1-git-send-email-johannes@sipsolutions.net>
References: <1350325050-6994-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hila Gonen <hila.gonen@intel.com>

This will allow adding central tracing like in mac80211.

Signed-off-by: Hila Gonen <hila.gonen@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/ap.c          |    3 +-
 net/wireless/chan.c        |    3 +-
 net/wireless/core.c        |   10 +-
 net/wireless/ethtool.c     |   15 +-
 net/wireless/ibss.c        |    7 +-
 net/wireless/mesh.c        |   10 +-
 net/wireless/mlme.c        |   26 ++-
 net/wireless/nl80211.c     |  135 +++++------
 net/wireless/rdev-ops.h    |  558 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/scan.c        |    5 +-
 net/wireless/sme.c         |    9 +-
 net/wireless/sysfs.c       |    5 +-
 net/wireless/util.c        |   14 +-
 net/wireless/wext-compat.c |   48 ++--
 14 files changed, 700 insertions(+), 148 deletions(-)
 create mode 100644 net/wireless/rdev-ops.h

diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index fcc60d8..e143505 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -3,6 +3,7 @@
 #include <net/cfg80211.h>
 #include "nl80211.h"
 #include "core.h"
+#include "rdev-ops.h"
 
 
 static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
@@ -23,7 +24,7 @@ static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 	if (!wdev->beacon_interval)
 		return -ENOENT;
 
-	err = rdev->ops->stop_ap(&rdev->wiphy, dev);
+	err = rdev_stop_ap(rdev, dev);
 	if (!err) {
 		wdev->beacon_interval = 0;
 		wdev->channel = NULL;
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 2f876b9..71c3625 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -9,6 +9,7 @@
 #include <linux/export.h>
 #include <net/cfg80211.h>
 #include "core.h"
+#include "rdev-ops.h"
 
 struct ieee80211_channel *
 rdev_freq_to_chan(struct cfg80211_registered_device *rdev,
@@ -92,7 +93,7 @@ int cfg80211_set_monitor_channel(struct cfg80211_registered_device *rdev,
 	if (!chan)
 		return -EINVAL;
 
-	return rdev->ops->set_monitor_channel(&rdev->wiphy, chan, chantype);
+	return rdev_set_monitor_channel(rdev, chan, chantype);
 }
 
 void
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 48c2ea4..f280f48 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -26,6 +26,7 @@
 #include "debugfs.h"
 #include "wext-compat.h"
 #include "ethtool.h"
+#include "rdev-ops.h"
 
 /* name for sysfs, %d is appended */
 #define PHY_NAME "phy"
@@ -216,7 +217,7 @@ static void cfg80211_rfkill_poll(struct rfkill *rfkill, void *data)
 {
 	struct cfg80211_registered_device *rdev = data;
 
-	rdev->ops->rfkill_poll(&rdev->wiphy);
+	rdev_rfkill_poll(rdev);
 }
 
 static int cfg80211_rfkill_set_block(void *data, bool blocked)
@@ -690,7 +691,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	flush_work(&rdev->event_work);
 
 	if (rdev->wowlan && rdev->ops->set_wakeup)
-		rdev->ops->set_wakeup(&rdev->wiphy, false);
+		rdev_set_wakeup(rdev, false);
 	cfg80211_rdev_free_wowlan(rdev);
 }
 EXPORT_SYMBOL(wiphy_unregister);
@@ -964,9 +965,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		if ((wdev->iftype == NL80211_IFTYPE_STATION ||
 		     wdev->iftype == NL80211_IFTYPE_P2P_CLIENT) &&
 		    rdev->ops->set_power_mgmt)
-			if (rdev->ops->set_power_mgmt(wdev->wiphy, dev,
-						      wdev->ps,
-						      wdev->ps_timeout)) {
+			if (rdev_set_power_mgmt(rdev, dev, wdev->ps,
+						wdev->ps_timeout)) {
 				/* assume this means it's off */
 				wdev->ps = false;
 			}
diff --git a/net/wireless/ethtool.c b/net/wireless/ethtool.c
index 7eecdf4..48c48ff 100644
--- a/net/wireless/ethtool.c
+++ b/net/wireless/ethtool.c
@@ -2,6 +2,7 @@
 #include <net/cfg80211.h>
 #include "core.h"
 #include "ethtool.h"
+#include "rdev-ops.h"
 
 static void cfg80211_get_drvinfo(struct net_device *dev,
 					struct ethtool_drvinfo *info)
@@ -47,9 +48,8 @@ static void cfg80211_get_ringparam(struct net_device *dev,
 	memset(rp, 0, sizeof(*rp));
 
 	if (rdev->ops->get_ringparam)
-		rdev->ops->get_ringparam(wdev->wiphy,
-					 &rp->tx_pending, &rp->tx_max_pending,
-					 &rp->rx_pending, &rp->rx_max_pending);
+		rdev_get_ringparam(rdev, &rp->tx_pending, &rp->tx_max_pending,
+				   &rp->rx_pending, &rp->rx_max_pending);
 }
 
 static int cfg80211_set_ringparam(struct net_device *dev,
@@ -62,8 +62,7 @@ static int cfg80211_set_ringparam(struct net_device *dev,
 		return -EINVAL;
 
 	if (rdev->ops->set_ringparam)
-		return rdev->ops->set_ringparam(wdev->wiphy,
-						rp->tx_pending, rp->rx_pending);
+		return rdev_set_ringparam(rdev, rp->tx_pending, rp->rx_pending);
 
 	return -ENOTSUPP;
 }
@@ -73,7 +72,7 @@ static int cfg80211_get_sset_count(struct net_device *dev, int sset)
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	if (rdev->ops->get_et_sset_count)
-		return rdev->ops->get_et_sset_count(wdev->wiphy, dev, sset);
+		return rdev_get_et_sset_count(rdev, dev, sset);
 	return -EOPNOTSUPP;
 }
 
@@ -83,7 +82,7 @@ static void cfg80211_get_stats(struct net_device *dev,
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	if (rdev->ops->get_et_stats)
-		rdev->ops->get_et_stats(wdev->wiphy, dev, stats, data);
+		rdev_get_et_stats(rdev, dev, stats, data);
 }
 
 static void cfg80211_get_strings(struct net_device *dev, u32 sset, u8 *data)
@@ -91,7 +90,7 @@ static void cfg80211_get_strings(struct net_device *dev, u32 sset, u8 *data)
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	if (rdev->ops->get_et_strings)
-		rdev->ops->get_et_strings(wdev->wiphy, dev, sset, data);
+		rdev_get_et_strings(rdev, dev, sset, data);
 }
 
 const struct ethtool_ops cfg80211_ethtool_ops = {
diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index ca5672f..7fda94f 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -11,6 +11,7 @@
 #include <net/cfg80211.h>
 #include "wext-compat.h"
 #include "nl80211.h"
+#include "rdev-ops.h"
 
 
 void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid)
@@ -128,7 +129,7 @@ int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 		return err;
 	}
 
-	err = rdev->ops->join_ibss(&rdev->wiphy, dev, params);
+	err = rdev_join_ibss(rdev, dev, params);
 	if (err) {
 		wdev->connect_keys = NULL;
 		wdev->sme_state = CFG80211_SME_IDLE;
@@ -175,7 +176,7 @@ static void __cfg80211_clear_ibss(struct net_device *dev, bool nowext)
 	 */
 	if (rdev->ops->del_key)
 		for (i = 0; i < 6; i++)
-			rdev->ops->del_key(wdev->wiphy, dev, i, false, NULL);
+			rdev_del_key(rdev, dev, i, false, NULL);
 
 	if (wdev->current_bss) {
 		cfg80211_unhold_bss(wdev->current_bss);
@@ -211,7 +212,7 @@ int __cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
 	if (!wdev->ssid_len)
 		return -ENOLINK;
 
-	err = rdev->ops->leave_ibss(&rdev->wiphy, dev);
+	err = rdev_leave_ibss(rdev, dev);
 
 	if (err)
 		return err;
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index c384e77..a18bb34 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -3,6 +3,7 @@
 #include <net/cfg80211.h>
 #include "nl80211.h"
 #include "core.h"
+#include "rdev-ops.h"
 
 /* Default values, timeouts in ms */
 #define MESH_TTL 		31
@@ -160,7 +161,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (err)
 		return err;
 
-	err = rdev->ops->join_mesh(&rdev->wiphy, dev, conf, setup);
+	err = rdev_join_mesh(rdev, dev, conf, setup);
 	if (!err) {
 		memcpy(wdev->ssid, setup->mesh_id, setup->mesh_id_len);
 		wdev->mesh_id_len = setup->mesh_id_len;
@@ -220,9 +221,8 @@ int cfg80211_set_mesh_freq(struct cfg80211_registered_device *rdev,
 		if (err)
 			return err;
 
-		err = rdev->ops->libertas_set_mesh_channel(&rdev->wiphy,
-							   wdev->netdev,
-							   channel);
+		err = rdev_libertas_set_mesh_channel(rdev, wdev->netdev,
+						     channel);
 		if (!err)
 			wdev->channel = channel;
 
@@ -267,7 +267,7 @@ static int __cfg80211_leave_mesh(struct cfg80211_registered_device *rdev,
 	if (!wdev->mesh_id_len)
 		return -ENOTCONN;
 
-	err = rdev->ops->leave_mesh(&rdev->wiphy, dev);
+	err = rdev_leave_mesh(rdev, dev);
 	if (!err) {
 		wdev->mesh_id_len = 0;
 		wdev->channel = NULL;
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 39f0405..fbbdf2a 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -15,6 +15,8 @@
 #include <net/iw_handler.h>
 #include "core.h"
 #include "nl80211.h"
+#include "rdev-ops.h"
+
 
 void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len)
 {
@@ -310,7 +312,7 @@ int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 	if (err)
 		goto out;
 
-	err = rdev->ops->auth(&rdev->wiphy, dev, &req);
+	err = rdev_auth(rdev, dev, &req);
 
 out:
 	cfg80211_put_bss(req.bss);
@@ -415,7 +417,7 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 	if (err)
 		goto out;
 
-	err = rdev->ops->assoc(&rdev->wiphy, dev, &req);
+	err = rdev_assoc(rdev, dev, &req);
 
 out:
 	if (err) {
@@ -477,7 +479,7 @@ int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 		return 0;
 	}
 
-	return rdev->ops->deauth(&rdev->wiphy, dev, &req);
+	return rdev_deauth(rdev, dev, &req);
 }
 
 int cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
@@ -522,7 +524,7 @@ static int __cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
 	else
 		return -ENOTCONN;
 
-	return rdev->ops->disassoc(&rdev->wiphy, dev, &req);
+	return rdev_disassoc(rdev, dev, &req);
 }
 
 int cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
@@ -563,7 +565,7 @@ void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
 
 	memcpy(bssid, wdev->current_bss->pub.bssid, ETH_ALEN);
 	req.bssid = bssid;
-	rdev->ops->deauth(&rdev->wiphy, dev, &req);
+	rdev_deauth(rdev, dev, &req);
 
 	if (wdev->current_bss) {
 		cfg80211_unhold_bss(wdev->current_bss);
@@ -693,7 +695,7 @@ int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_pid,
 	list_add(&nreg->list, &wdev->mgmt_registrations);
 
 	if (rdev->ops->mgmt_frame_register)
-		rdev->ops->mgmt_frame_register(wiphy, wdev, frame_type, true);
+		rdev_mgmt_frame_register(rdev, wdev, frame_type, true);
 
  out:
 	spin_unlock_bh(&wdev->mgmt_registrations_lock);
@@ -716,8 +718,8 @@ void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlpid)
 		if (rdev->ops->mgmt_frame_register) {
 			u16 frame_type = le16_to_cpu(reg->frame_type);
 
-			rdev->ops->mgmt_frame_register(wiphy, wdev,
-						       frame_type, false);
+			rdev_mgmt_frame_register(rdev, wdev,
+						 frame_type, false);
 		}
 
 		list_del(&reg->list);
@@ -843,10 +845,10 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 		return -EINVAL;
 
 	/* Transmit the Action frame as requested by user space */
-	return rdev->ops->mgmt_tx(&rdev->wiphy, wdev, chan, offchan,
-				  channel_type, channel_type_valid,
-				  wait, buf, len, no_cck, dont_wait_for_ack,
-				  cookie);
+	return rdev_mgmt_tx(rdev, wdev, chan, offchan,
+			    channel_type, channel_type_valid,
+			    wait, buf, len, no_cck, dont_wait_for_ack,
+			    cookie);
 }
 
 bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 38a1a57..c390490 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -22,6 +22,7 @@
 #include "core.h"
 #include "nl80211.h"
 #include "reg.h"
+#include "rdev-ops.h"
 
 static int nl80211_crypto_settings(struct cfg80211_registered_device *rdev,
 				   struct genl_info *info,
@@ -945,7 +946,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 	     dev->wiphy.available_antennas_rx) && dev->ops->get_antenna) {
 		u32 tx_ant = 0, rx_ant = 0;
 		int res;
-		res = dev->ops->get_antenna(&dev->wiphy, &tx_ant, &rx_ant);
+		res = rdev_get_antenna(dev, &tx_ant, &rx_ant);
 		if (!res) {
 			if (nla_put_u32(msg, NL80211_ATTR_WIPHY_ANTENNA_TX,
 					tx_ant) ||
@@ -1459,7 +1460,7 @@ static int nl80211_set_wds_peer(struct sk_buff *skb, struct genl_info *info)
 		return -EOPNOTSUPP;
 
 	bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
-	return rdev->ops->set_wds_peer(wdev->wiphy, dev, bssid);
+	return rdev_set_wds_peer(rdev, dev, bssid);
 }
 
 
@@ -1564,9 +1565,8 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			if (result)
 				goto bad_res;
 
-			result = rdev->ops->set_txq_params(&rdev->wiphy,
-							   netdev,
-							   &txq_params);
+			result = rdev_set_txq_params(rdev, netdev,
+						     &txq_params);
 			if (result)
 				goto bad_res;
 		}
@@ -1601,7 +1601,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 			mbm = nla_get_u32(info->attrs[idx]);
 		}
 
-		result = rdev->ops->set_tx_power(&rdev->wiphy, type, mbm);
+		result = rdev_set_tx_power(rdev, type, mbm);
 		if (result)
 			goto bad_res;
 	}
@@ -1630,7 +1630,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		tx_ant = tx_ant & rdev->wiphy.available_antennas_tx;
 		rx_ant = rx_ant & rdev->wiphy.available_antennas_rx;
 
-		result = rdev->ops->set_antenna(&rdev->wiphy, tx_ant, rx_ant);
+		result = rdev_set_antenna(rdev, tx_ant, rx_ant);
 		if (result)
 			goto bad_res;
 	}
@@ -1715,7 +1715,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		if (changed & WIPHY_PARAM_COVERAGE_CLASS)
 			rdev->wiphy.coverage_class = coverage_class;
 
-		result = rdev->ops->set_wiphy_params(&rdev->wiphy, changed);
+		result = rdev_set_wiphy_params(rdev, changed);
 		if (result) {
 			rdev->wiphy.retry_short = old_retry_short;
 			rdev->wiphy.retry_long = old_retry_long;
@@ -1767,8 +1767,7 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		struct ieee80211_channel *chan;
 		enum nl80211_channel_type channel_type;
 
-		chan = rdev->ops->get_channel(&rdev->wiphy, wdev,
-					      &channel_type);
+		chan = rdev_get_channel(rdev, wdev, &channel_type);
 		if (chan &&
 		    (nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ,
 				 chan->center_freq) ||
@@ -2016,9 +2015,9 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	err = parse_monitor_flags(type == NL80211_IFTYPE_MONITOR ?
 				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
 				  &flags);
-	wdev = rdev->ops->add_virtual_intf(&rdev->wiphy,
-		nla_data(info->attrs[NL80211_ATTR_IFNAME]),
-		type, err ? NULL : &flags, &params);
+	wdev = rdev_add_virtual_intf(rdev,
+				nla_data(info->attrs[NL80211_ATTR_IFNAME]),
+				type, err ? NULL : &flags, &params);
 	if (IS_ERR(wdev)) {
 		nlmsg_free(msg);
 		return PTR_ERR(wdev);
@@ -2085,7 +2084,7 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 	if (!wdev->netdev)
 		info->user_ptr[1] = NULL;
 
-	return rdev->ops->del_virtual_intf(&rdev->wiphy, wdev);
+	return rdev_del_virtual_intf(rdev, wdev);
 }
 
 static int nl80211_set_noack_map(struct sk_buff *skb, struct genl_info *info)
@@ -2102,7 +2101,7 @@ static int nl80211_set_noack_map(struct sk_buff *skb, struct genl_info *info)
 
 	noack_map = nla_get_u16(info->attrs[NL80211_ATTR_NOACK_MAP]);
 
-	return rdev->ops->set_noack_map(&rdev->wiphy, dev, noack_map);
+	return rdev_set_noack_map(rdev, dev, noack_map);
 }
 
 struct get_key_cookie {
@@ -2212,8 +2211,8 @@ static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
 	    !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
 		return -ENOENT;
 
-	err = rdev->ops->get_key(&rdev->wiphy, dev, key_idx, pairwise,
-				 mac_addr, &cookie, get_key_callback);
+	err = rdev_get_key(rdev, dev, key_idx, pairwise, mac_addr, &cookie,
+			   get_key_callback);
 
 	if (err)
 		goto free_msg;
@@ -2261,7 +2260,7 @@ static int nl80211_set_key(struct sk_buff *skb, struct genl_info *info)
 		if (err)
 			goto out;
 
-		err = rdev->ops->set_default_key(&rdev->wiphy, dev, key.idx,
+		err = rdev_set_default_key(rdev, dev, key.idx,
 						 key.def_uni, key.def_multi);
 
 		if (err)
@@ -2285,8 +2284,7 @@ static int nl80211_set_key(struct sk_buff *skb, struct genl_info *info)
 		if (err)
 			goto out;
 
-		err = rdev->ops->set_default_mgmt_key(&rdev->wiphy,
-						      dev, key.idx);
+		err = rdev_set_default_mgmt_key(rdev, dev, key.idx);
 		if (err)
 			goto out;
 
@@ -2342,9 +2340,9 @@ static int nl80211_new_key(struct sk_buff *skb, struct genl_info *info)
 	wdev_lock(dev->ieee80211_ptr);
 	err = nl80211_key_allowed(dev->ieee80211_ptr);
 	if (!err)
-		err = rdev->ops->add_key(&rdev->wiphy, dev, key.idx,
-					 key.type == NL80211_KEYTYPE_PAIRWISE,
-					 mac_addr, &key.p);
+		err = rdev_add_key(rdev, dev, key.idx,
+				   key.type == NL80211_KEYTYPE_PAIRWISE,
+				    mac_addr, &key.p);
 	wdev_unlock(dev->ieee80211_ptr);
 
 	return err;
@@ -2388,9 +2386,9 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 		err = -ENOENT;
 
 	if (!err)
-		err = rdev->ops->del_key(&rdev->wiphy, dev, key.idx,
-					 key.type == NL80211_KEYTYPE_PAIRWISE,
-					 mac_addr);
+		err = rdev_del_key(rdev, dev, key.idx,
+				   key.type == NL80211_KEYTYPE_PAIRWISE,
+				   mac_addr);
 
 #ifdef CONFIG_CFG80211_WEXT
 	if (!err) {
@@ -2634,7 +2632,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	err = rdev->ops->start_ap(&rdev->wiphy, dev, &params);
+	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
 		wdev->preset_chan = params.channel;
 		wdev->preset_chantype = params.channel_type;
@@ -2666,7 +2664,7 @@ static int nl80211_set_beacon(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	return rdev->ops->change_beacon(&rdev->wiphy, dev, &params);
+	return rdev_change_beacon(rdev, dev, &params);
 }
 
 static int nl80211_stop_ap(struct sk_buff *skb, struct genl_info *info)
@@ -2950,8 +2948,8 @@ static int nl80211_dump_station(struct sk_buff *skb,
 
 	while (1) {
 		memset(&sinfo, 0, sizeof(sinfo));
-		err = dev->ops->dump_station(&dev->wiphy, netdev, sta_idx,
-					     mac_addr, &sinfo);
+		err = rdev_dump_station(dev, netdev, sta_idx,
+					mac_addr, &sinfo);
 		if (err == -ENOENT)
 			break;
 		if (err)
@@ -2996,7 +2994,7 @@ static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->get_station)
 		return -EOPNOTSUPP;
 
-	err = rdev->ops->get_station(&rdev->wiphy, dev, mac_addr, &sinfo);
+	err = rdev_get_station(rdev, dev, mac_addr, &sinfo);
 	if (err)
 		return err;
 
@@ -3173,7 +3171,7 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 
 	/* be aware of params.vlan when changing code here */
 
-	err = rdev->ops->change_station(&rdev->wiphy, dev, mac_addr, &params);
+	err = rdev_change_station(rdev, dev, mac_addr, &params);
 
 	if (params.vlan)
 		dev_put(params.vlan);
@@ -3306,7 +3304,7 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 
 	/* be aware of params.vlan when changing code here */
 
-	err = rdev->ops->add_station(&rdev->wiphy, dev, mac_addr, &params);
+	err = rdev_add_station(rdev, dev, mac_addr, &params);
 
 	if (params.vlan)
 		dev_put(params.vlan);
@@ -3331,7 +3329,7 @@ static int nl80211_del_station(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->del_station)
 		return -EOPNOTSUPP;
 
-	return rdev->ops->del_station(&rdev->wiphy, dev, mac_addr);
+	return rdev_del_station(rdev, dev, mac_addr);
 }
 
 static int nl80211_send_mpath(struct sk_buff *msg, u32 pid, u32 seq,
@@ -3413,8 +3411,8 @@ static int nl80211_dump_mpath(struct sk_buff *skb,
 	}
 
 	while (1) {
-		err = dev->ops->dump_mpath(&dev->wiphy, netdev, path_idx,
-					   dst, next_hop, &pinfo);
+		err = rdev_dump_mpath(dev, netdev, path_idx, dst, next_hop,
+				      &pinfo);
 		if (err == -ENOENT)
 			break;
 		if (err)
@@ -3461,7 +3459,7 @@ static int nl80211_get_mpath(struct sk_buff *skb, struct genl_info *info)
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
 		return -EOPNOTSUPP;
 
-	err = rdev->ops->get_mpath(&rdev->wiphy, dev, dst, next_hop, &pinfo);
+	err = rdev_get_mpath(rdev, dev, dst, next_hop, &pinfo);
 	if (err)
 		return err;
 
@@ -3500,7 +3498,7 @@ static int nl80211_set_mpath(struct sk_buff *skb, struct genl_info *info)
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
 		return -EOPNOTSUPP;
 
-	return rdev->ops->change_mpath(&rdev->wiphy, dev, dst, next_hop);
+	return rdev_change_mpath(rdev, dev, dst, next_hop);
 }
 
 static int nl80211_new_mpath(struct sk_buff *skb, struct genl_info *info)
@@ -3525,7 +3523,7 @@ static int nl80211_new_mpath(struct sk_buff *skb, struct genl_info *info)
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
 		return -EOPNOTSUPP;
 
-	return rdev->ops->add_mpath(&rdev->wiphy, dev, dst, next_hop);
+	return rdev_add_mpath(rdev, dev, dst, next_hop);
 }
 
 static int nl80211_del_mpath(struct sk_buff *skb, struct genl_info *info)
@@ -3540,7 +3538,7 @@ static int nl80211_del_mpath(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->del_mpath)
 		return -EOPNOTSUPP;
 
-	return rdev->ops->del_mpath(&rdev->wiphy, dev, dst);
+	return rdev_del_mpath(rdev, dev, dst);
 }
 
 static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
@@ -3585,7 +3583,7 @@ static int nl80211_set_bss(struct sk_buff *skb, struct genl_info *info)
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
 		return -EOPNOTSUPP;
 
-	return rdev->ops->change_bss(&rdev->wiphy, dev, &params);
+	return rdev_change_bss(rdev, dev, &params);
 }
 
 static const struct nla_policy reg_rule_policy[NL80211_REG_RULE_ATTR_MAX + 1] = {
@@ -3699,8 +3697,7 @@ static int nl80211_get_mesh_config(struct sk_buff *skb,
 	if (!wdev->mesh_id_len)
 		memcpy(&cur_params, &default_mesh_config, sizeof(cur_params));
 	else
-		err = rdev->ops->get_mesh_config(&rdev->wiphy, dev,
-						 &cur_params);
+		err = rdev_get_mesh_config(rdev, dev, &cur_params);
 	wdev_unlock(wdev);
 
 	if (err)
@@ -4002,8 +3999,7 @@ static int nl80211_update_mesh_config(struct sk_buff *skb,
 		err = -ENOLINK;
 
 	if (!err)
-		err = rdev->ops->update_mesh_config(&rdev->wiphy, dev,
-						    mask, &cfg);
+		err = rdev_update_mesh_config(rdev, dev, mask, &cfg);
 
 	wdev_unlock(wdev);
 
@@ -4388,7 +4384,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	request->scan_start = jiffies;
 
 	rdev->scan_req = request;
-	err = rdev->ops->scan(&rdev->wiphy, request);
+	err = rdev_scan(rdev, request);
 
 	if (!err) {
 		nl80211_send_scan_start(rdev, wdev);
@@ -4629,7 +4625,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	request->interval = interval;
 	request->scan_start = jiffies;
 
-	err = rdev->ops->sched_scan_start(&rdev->wiphy, dev, request);
+	err = rdev_sched_scan_start(rdev, dev, request);
 	if (!err) {
 		rdev->sched_scan_req = request;
 		nl80211_send_sched_scan(rdev, dev,
@@ -4872,8 +4868,7 @@ static int nl80211_dump_survey(struct sk_buff *skb,
 	while (1) {
 		struct ieee80211_channel *chan;
 
-		res = dev->ops->dump_survey(&dev->wiphy, netdev, survey_idx,
-					    &survey);
+		res = rdev_dump_survey(dev, netdev, survey_idx, &survey);
 		if (res == -ENOENT)
 			break;
 		if (res)
@@ -5451,7 +5446,7 @@ static int nl80211_testmode_do(struct sk_buff *skb, struct genl_info *info)
 	err = -EOPNOTSUPP;
 	if (rdev->ops->testmode_cmd) {
 		rdev->testmode_info = info;
-		err = rdev->ops->testmode_cmd(&rdev->wiphy,
+		err = rdev_testmode_cmd(rdev,
 				nla_data(info->attrs[NL80211_ATTR_TESTDATA]),
 				nla_len(info->attrs[NL80211_ATTR_TESTDATA]));
 		rdev->testmode_info = NULL;
@@ -5533,8 +5528,7 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
 			genlmsg_cancel(skb, hdr);
 			break;
 		}
-		err = rdev->ops->testmode_dump(&rdev->wiphy, skb, cb,
-					       data, data_len);
+		err = rdev_testmode_dump(rdev, skb, cb, data, data_len);
 		nla_nest_end(skb, tmdata);
 
 		if (err == -ENOBUFS || err == -ENOENT) {
@@ -5839,7 +5833,7 @@ static int nl80211_flush_pmksa(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->flush_pmksa)
 		return -EOPNOTSUPP;
 
-	return rdev->ops->flush_pmksa(&rdev->wiphy, dev);
+	return rdev_flush_pmksa(rdev, dev);
 }
 
 static int nl80211_tdls_mgmt(struct sk_buff *skb, struct genl_info *info)
@@ -5866,10 +5860,10 @@ static int nl80211_tdls_mgmt(struct sk_buff *skb, struct genl_info *info)
 	status_code = nla_get_u16(info->attrs[NL80211_ATTR_STATUS_CODE]);
 	dialog_token = nla_get_u8(info->attrs[NL80211_ATTR_TDLS_DIALOG_TOKEN]);
 
-	return rdev->ops->tdls_mgmt(&rdev->wiphy, dev, peer, action_code,
-				    dialog_token, status_code,
-				    nla_data(info->attrs[NL80211_ATTR_IE]),
-				    nla_len(info->attrs[NL80211_ATTR_IE]));
+	return rdev_tdls_mgmt(rdev, dev, peer, action_code,
+			      dialog_token, status_code,
+			      nla_data(info->attrs[NL80211_ATTR_IE]),
+			      nla_len(info->attrs[NL80211_ATTR_IE]));
 }
 
 static int nl80211_tdls_oper(struct sk_buff *skb, struct genl_info *info)
@@ -5890,7 +5884,7 @@ static int nl80211_tdls_oper(struct sk_buff *skb, struct genl_info *info)
 	operation = nla_get_u8(info->attrs[NL80211_ATTR_TDLS_OPERATION]);
 	peer = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
-	return rdev->ops->tdls_oper(&rdev->wiphy, dev, peer, operation);
+	return rdev_tdls_oper(rdev, dev, peer, operation);
 }
 
 static int nl80211_remain_on_channel(struct sk_buff *skb,
@@ -5945,8 +5939,8 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 		goto free_msg;
 	}
 
-	err = rdev->ops->remain_on_channel(&rdev->wiphy, wdev, chan,
-					   channel_type, duration, &cookie);
+	err = rdev_remain_on_channel(rdev, wdev, chan, channel_type, duration,
+				     &cookie);
 
 	if (err)
 		goto free_msg;
@@ -5980,7 +5974,7 @@ static int nl80211_cancel_remain_on_channel(struct sk_buff *skb,
 
 	cookie = nla_get_u64(info->attrs[NL80211_ATTR_COOKIE]);
 
-	return rdev->ops->cancel_remain_on_channel(&rdev->wiphy, wdev, cookie);
+	return rdev_cancel_remain_on_channel(rdev, wdev, cookie);
 }
 
 static u32 rateset_to_mask(struct ieee80211_supported_band *sband,
@@ -6123,7 +6117,7 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 		}
 	}
 
-	return rdev->ops->set_bitrate_mask(&rdev->wiphy, dev, NULL, &mask);
+	return rdev_set_bitrate_mask(rdev, dev, NULL, &mask);
 }
 
 static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
@@ -6298,7 +6292,7 @@ static int nl80211_tx_mgmt_cancel_wait(struct sk_buff *skb, struct genl_info *in
 
 	cookie = nla_get_u64(info->attrs[NL80211_ATTR_COOKIE]);
 
-	return rdev->ops->mgmt_tx_cancel_wait(&rdev->wiphy, wdev, cookie);
+	return rdev_mgmt_tx_cancel_wait(rdev, wdev, cookie);
 }
 
 static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
@@ -6328,8 +6322,7 @@ static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
 	if (state == wdev->ps)
 		return 0;
 
-	err = rdev->ops->set_power_mgmt(wdev->wiphy, dev, state,
-					wdev->ps_timeout);
+	err = rdev_set_power_mgmt(rdev, dev, state, wdev->ps_timeout);
 	if (!err)
 		wdev->ps = state;
 	return err;
@@ -6409,8 +6402,7 @@ static int nl80211_set_cqm_txe(struct genl_info *info,
 	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
 		return -EOPNOTSUPP;
 
-	return rdev->ops->set_cqm_txe_config(wdev->wiphy, dev,
-					     rate, pkts, intvl);
+	return rdev_set_cqm_txe_config(rdev, dev, rate, pkts, intvl);
 }
 
 static int nl80211_set_cqm_rssi(struct genl_info *info,
@@ -6432,8 +6424,7 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
 	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
 		return -EOPNOTSUPP;
 
-	return rdev->ops->set_cqm_rssi_config(wdev->wiphy, dev,
-					      threshold, hysteresis);
+	return rdev_set_cqm_rssi_config(rdev, dev, threshold, hysteresis);
 }
 
 static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
@@ -6758,7 +6749,7 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 
  set_wakeup:
 	if (rdev->ops->set_wakeup && prev_enabled != !!rdev->wowlan)
-		rdev->ops->set_wakeup(&rdev->wiphy, rdev->wowlan);
+		rdev_set_wakeup(rdev, rdev->wowlan);
 
 	return 0;
  error:
@@ -6814,7 +6805,7 @@ static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 		goto out;
 	}
 
-	err = rdev->ops->set_rekey_data(&rdev->wiphy, dev, &rekey_data);
+	err = rdev_set_rekey_data(rdev, dev, &rekey_data);
  out:
 	wdev_unlock(wdev);
 	return err;
@@ -6873,7 +6864,7 @@ static int nl80211_probe_client(struct sk_buff *skb,
 
 	addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
-	err = rdev->ops->probe_client(&rdev->wiphy, dev, addr, &cookie);
+	err = rdev_probe_client(rdev, dev, addr, &cookie);
 	if (err)
 		goto free_msg;
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
new file mode 100644
index 0000000..b6fad29
--- /dev/null
+++ b/net/wireless/rdev-ops.h
@@ -0,0 +1,558 @@
+#ifndef __CFG80211_RDEV_OPS
+#define __CFG80211_RDEV_OPS
+
+#include <linux/rtnetlink.h>
+#include <net/cfg80211.h>
+#include "core.h"
+
+static inline int rdev_suspend(struct cfg80211_registered_device *rdev)
+{
+	return rdev->ops->suspend(&rdev->wiphy, rdev->wowlan);
+}
+
+static inline int rdev_resume(struct cfg80211_registered_device *rdev)
+{
+	return rdev->ops->resume(&rdev->wiphy);
+}
+
+static inline void rdev_set_wakeup(struct cfg80211_registered_device *rdev,
+				   bool enabled)
+{
+	rdev->ops->set_wakeup(&rdev->wiphy, enabled);
+}
+
+static inline struct wireless_dev
+*rdev_add_virtual_intf(struct cfg80211_registered_device *rdev, char *name,
+		       enum nl80211_iftype type, u32 *flags,
+		       struct vif_params *params)
+{
+	return rdev->ops->add_virtual_intf(&rdev->wiphy, name, type, flags,
+					   params);
+}
+
+static inline int
+rdev_del_virtual_intf(struct cfg80211_registered_device *rdev,
+		      struct wireless_dev *wdev)
+{
+	return rdev->ops->del_virtual_intf(&rdev->wiphy, wdev);
+}
+
+static inline int
+rdev_change_virtual_intf(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev, enum nl80211_iftype type,
+			 u32 *flags, struct vif_params *params)
+{
+	return rdev->ops->change_virtual_intf(&rdev->wiphy, dev, type, flags,
+					      params);
+}
+
+static inline int rdev_add_key(struct cfg80211_registered_device *rdev,
+			       struct net_device *netdev, u8 key_index,
+			       bool pairwise, const u8 *mac_addr,
+			       struct key_params *params)
+{
+	return rdev->ops->add_key(&rdev->wiphy, netdev, key_index, pairwise,
+				  mac_addr, params);
+}
+
+static inline int
+rdev_get_key(struct cfg80211_registered_device *rdev, struct net_device *netdev,
+	     u8 key_index, bool pairwise, const u8 *mac_addr, void *cookie,
+	     void (*callback)(void *cookie, struct key_params*))
+{
+	return rdev->ops->get_key(&rdev->wiphy, netdev, key_index, pairwise,
+				  mac_addr, cookie, callback);
+}
+
+static inline int rdev_del_key(struct cfg80211_registered_device *rdev,
+			       struct net_device *netdev, u8 key_index,
+			       bool pairwise, const u8 *mac_addr)
+{
+	return rdev->ops->del_key(&rdev->wiphy, netdev, key_index, pairwise,
+				  mac_addr);
+}
+
+static inline int
+rdev_set_default_key(struct cfg80211_registered_device *rdev,
+		     struct net_device *netdev, u8 key_index, bool unicast,
+		     bool multicast)
+{
+	return rdev->ops->set_default_key(&rdev->wiphy, netdev, key_index,
+					  unicast, multicast);
+}
+
+static inline int
+rdev_set_default_mgmt_key(struct cfg80211_registered_device *rdev,
+			  struct net_device *netdev, u8 key_index)
+{
+	return rdev->ops->set_default_mgmt_key(&rdev->wiphy, netdev,
+					       key_index);
+}
+
+static inline int rdev_start_ap(struct cfg80211_registered_device *rdev,
+				struct net_device *dev,
+				struct cfg80211_ap_settings *settings)
+{
+	return rdev->ops->start_ap(&rdev->wiphy, dev, settings);
+}
+
+static inline int rdev_change_beacon(struct cfg80211_registered_device *rdev,
+				     struct net_device *dev,
+				     struct cfg80211_beacon_data *info)
+{
+	return rdev->ops->change_beacon(&rdev->wiphy, dev, info);
+}
+
+static inline int rdev_stop_ap(struct cfg80211_registered_device *rdev,
+			       struct net_device *dev)
+{
+	return rdev->ops->stop_ap(&rdev->wiphy, dev);
+}
+
+static inline int rdev_add_station(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev, u8 *mac,
+				   struct station_parameters *params)
+{
+	return rdev->ops->add_station(&rdev->wiphy, dev, mac, params);
+}
+
+static inline int rdev_del_station(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev, u8 *mac)
+{
+	return rdev->ops->del_station(&rdev->wiphy, dev, mac);
+}
+
+static inline int rdev_change_station(struct cfg80211_registered_device *rdev,
+				      struct net_device *dev, u8 *mac,
+				      struct station_parameters *params)
+{
+	return rdev->ops->change_station(&rdev->wiphy, dev, mac, params);
+}
+
+static inline int rdev_get_station(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev, u8 *mac,
+				   struct station_info *sinfo)
+{
+	return rdev->ops->get_station(&rdev->wiphy, dev, mac, sinfo);
+}
+
+static inline int rdev_dump_station(struct cfg80211_registered_device *rdev,
+				    struct net_device *dev, int idx, u8 *mac,
+				    struct station_info *sinfo)
+{
+	return rdev->ops->dump_station(&rdev->wiphy, dev, idx, mac, sinfo);
+}
+
+static inline int rdev_add_mpath(struct cfg80211_registered_device *rdev,
+				 struct net_device *dev, u8 *dst, u8 *next_hop)
+{
+	return rdev->ops->add_mpath(&rdev->wiphy, dev, dst, next_hop);
+}
+
+static inline int rdev_del_mpath(struct cfg80211_registered_device *rdev,
+				 struct net_device *dev, u8 *dst)
+{
+	return rdev->ops->del_mpath(&rdev->wiphy, dev, dst);
+}
+
+static inline int rdev_change_mpath(struct cfg80211_registered_device *rdev,
+				    struct net_device *dev, u8 *dst,
+				    u8 *next_hop)
+{
+	return rdev->ops->change_mpath(&rdev->wiphy, dev, dst, next_hop);
+}
+
+static inline int rdev_get_mpath(struct cfg80211_registered_device *rdev,
+				 struct net_device *dev, u8 *dst, u8 *next_hop,
+				 struct mpath_info *pinfo)
+{
+	return rdev->ops->get_mpath(&rdev->wiphy, dev, dst, next_hop, pinfo);
+}
+
+static inline int rdev_dump_mpath(struct cfg80211_registered_device *rdev,
+				  struct net_device *dev, int idx, u8 *dst,
+				  u8 *next_hop, struct mpath_info *pinfo)
+
+{
+	return rdev->ops->dump_mpath(&rdev->wiphy, dev, idx, dst, next_hop,
+				     pinfo);
+}
+
+static inline int
+rdev_get_mesh_config(struct cfg80211_registered_device *rdev,
+		     struct net_device *dev, struct mesh_config *conf)
+{
+	return rdev->ops->get_mesh_config(&rdev->wiphy, dev, conf);
+}
+
+static inline int
+rdev_update_mesh_config(struct cfg80211_registered_device *rdev,
+			struct net_device *dev, u32 mask,
+			const struct mesh_config *nconf)
+{
+	return rdev->ops->update_mesh_config(&rdev->wiphy, dev, mask, nconf);
+}
+
+static inline int rdev_join_mesh(struct cfg80211_registered_device *rdev,
+				 struct net_device *dev,
+				 const struct mesh_config *conf,
+				 const struct mesh_setup *setup)
+{
+	return rdev->ops->join_mesh(&rdev->wiphy, dev, conf, setup);
+}
+
+
+static inline int rdev_leave_mesh(struct cfg80211_registered_device *rdev,
+				  struct net_device *dev)
+{
+	return rdev->ops->leave_mesh(&rdev->wiphy, dev);
+}
+
+static inline int rdev_change_bss(struct cfg80211_registered_device *rdev,
+				  struct net_device *dev,
+				  struct bss_parameters *params)
+
+{
+	return rdev->ops->change_bss(&rdev->wiphy, dev, params);
+}
+
+static inline int rdev_set_txq_params(struct cfg80211_registered_device *rdev,
+				      struct net_device *dev,
+				      struct ieee80211_txq_params *params)
+
+{
+	return rdev->ops->set_txq_params(&rdev->wiphy, dev, params);
+}
+
+static inline int
+rdev_libertas_set_mesh_channel(struct cfg80211_registered_device *rdev,
+			       struct net_device *dev,
+			       struct ieee80211_channel *chan)
+{
+	return rdev->ops->libertas_set_mesh_channel(&rdev->wiphy, dev, chan);
+}
+
+static inline int
+rdev_set_monitor_channel(struct cfg80211_registered_device *rdev,
+			 struct ieee80211_channel *chan,
+			 enum nl80211_channel_type channel_type)
+{
+	return rdev->ops->set_monitor_channel(&rdev->wiphy, chan,
+					      channel_type);
+}
+
+static inline int rdev_scan(struct cfg80211_registered_device *rdev,
+			    struct cfg80211_scan_request *request)
+{
+	return rdev->ops->scan(&rdev->wiphy, request);
+}
+
+static inline int rdev_auth(struct cfg80211_registered_device *rdev,
+			    struct net_device *dev,
+			    struct cfg80211_auth_request *req)
+{
+	return rdev->ops->auth(&rdev->wiphy, dev, req);
+}
+
+static inline int rdev_assoc(struct cfg80211_registered_device *rdev,
+			     struct net_device *dev,
+			     struct cfg80211_assoc_request *req)
+{
+	return rdev->ops->assoc(&rdev->wiphy, dev, req);
+}
+
+static inline int rdev_deauth(struct cfg80211_registered_device *rdev,
+			      struct net_device *dev,
+			      struct cfg80211_deauth_request *req)
+{
+	return rdev->ops->deauth(&rdev->wiphy, dev, req);
+}
+
+static inline int rdev_disassoc(struct cfg80211_registered_device *rdev,
+				struct net_device *dev,
+				struct cfg80211_disassoc_request *req)
+{
+	return rdev->ops->disassoc(&rdev->wiphy, dev, req);
+}
+
+static inline int rdev_connect(struct cfg80211_registered_device *rdev,
+			       struct net_device *dev,
+			       struct cfg80211_connect_params *sme)
+{
+	return rdev->ops->connect(&rdev->wiphy, dev, sme);
+}
+
+static inline int rdev_disconnect(struct cfg80211_registered_device *rdev,
+				  struct net_device *dev, u16 reason_code)
+{
+	return rdev->ops->disconnect(&rdev->wiphy, dev, reason_code);
+}
+
+static inline int rdev_join_ibss(struct cfg80211_registered_device *rdev,
+				 struct net_device *dev,
+				 struct cfg80211_ibss_params *params)
+{
+	return rdev->ops->join_ibss(&rdev->wiphy, dev, params);
+}
+
+static inline int rdev_leave_ibss(struct cfg80211_registered_device *rdev,
+				  struct net_device *dev)
+{
+	return rdev->ops->leave_ibss(&rdev->wiphy, dev);
+}
+
+static inline int
+rdev_set_wiphy_params(struct cfg80211_registered_device *rdev, u32 changed)
+{
+	return rdev->ops->set_wiphy_params(&rdev->wiphy, changed);
+}
+
+static inline int rdev_set_tx_power(struct cfg80211_registered_device *rdev,
+				    enum nl80211_tx_power_setting type, int mbm)
+{
+	return rdev->ops->set_tx_power(&rdev->wiphy, type, mbm);
+}
+
+static inline int rdev_get_tx_power(struct cfg80211_registered_device *rdev,
+				    int *dbm)
+{
+	return rdev->ops->get_tx_power(&rdev->wiphy, dbm);
+}
+
+static inline int rdev_set_wds_peer(struct cfg80211_registered_device *rdev,
+				    struct net_device *dev, const u8 *addr)
+{
+	return rdev->ops->set_wds_peer(&rdev->wiphy, dev, addr);
+}
+
+static inline void rdev_rfkill_poll(struct cfg80211_registered_device *rdev)
+{
+	rdev->ops->rfkill_poll(&rdev->wiphy);
+}
+
+
+#ifdef CONFIG_NL80211_TESTMODE
+static inline int rdev_testmode_cmd(struct cfg80211_registered_device *rdev,
+				    void *data, int len)
+{
+	return rdev->ops->testmode_cmd(&rdev->wiphy, data, len);
+}
+
+static inline int rdev_testmode_dump(struct cfg80211_registered_device *rdev,
+				     struct sk_buff *skb,
+				     struct netlink_callback *cb, void *data,
+				     int len)
+{
+	return rdev->ops->testmode_dump(&rdev->wiphy, skb, cb, data,
+					len);
+}
+#endif
+
+static inline int
+rdev_set_bitrate_mask(struct cfg80211_registered_device *rdev,
+		      struct net_device *dev, const u8 *peer,
+		      const struct cfg80211_bitrate_mask *mask)
+{
+	return rdev->ops->set_bitrate_mask(&rdev->wiphy, dev, peer, mask);
+}
+
+static inline int rdev_dump_survey(struct cfg80211_registered_device *rdev,
+				   struct net_device *netdev, int idx,
+				   struct survey_info *info)
+{
+	return rdev->ops->dump_survey(&rdev->wiphy, netdev, idx, info);
+}
+
+static inline int rdev_set_pmksa(struct cfg80211_registered_device *rdev,
+				 struct net_device *netdev,
+				 struct cfg80211_pmksa *pmksa)
+{
+	return rdev->ops->set_pmksa(&rdev->wiphy, netdev, pmksa);
+}
+
+static inline int rdev_del_pmksa(struct cfg80211_registered_device *rdev,
+				 struct net_device *netdev,
+				 struct cfg80211_pmksa *pmksa)
+{
+	return rdev->ops->del_pmksa(&rdev->wiphy, netdev, pmksa);
+}
+
+static inline int rdev_flush_pmksa(struct cfg80211_registered_device *rdev,
+				   struct net_device *netdev)
+{
+	return rdev->ops->flush_pmksa(&rdev->wiphy, netdev);
+}
+
+static inline int
+rdev_remain_on_channel(struct cfg80211_registered_device *rdev,
+		       struct wireless_dev *wdev,
+		       struct ieee80211_channel *chan,
+		       enum nl80211_channel_type channel_type,
+		       unsigned int duration, u64 *cookie)
+{
+	return rdev->ops->remain_on_channel(&rdev->wiphy, wdev, chan,
+					    channel_type, duration, cookie);
+}
+
+static inline int
+rdev_cancel_remain_on_channel(struct cfg80211_registered_device *rdev,
+			      struct wireless_dev *wdev, u64 cookie)
+{
+	return rdev->ops->cancel_remain_on_channel(&rdev->wiphy, wdev, cookie);
+}
+
+static inline int rdev_mgmt_tx(struct cfg80211_registered_device *rdev,
+			       struct wireless_dev *wdev,
+			       struct ieee80211_channel *chan, bool offchan,
+			       enum nl80211_channel_type channel_type,
+			       bool channel_type_valid, unsigned int wait,
+			       const u8 *buf, size_t len, bool no_cck,
+			       bool dont_wait_for_ack, u64 *cookie)
+{
+	return rdev->ops->mgmt_tx(&rdev->wiphy, wdev, chan, offchan,
+				  channel_type, channel_type_valid, wait, buf,
+				  len, no_cck, dont_wait_for_ack, cookie);
+}
+
+static inline int
+rdev_mgmt_tx_cancel_wait(struct cfg80211_registered_device *rdev,
+			 struct wireless_dev *wdev, u64 cookie)
+{
+	return rdev->ops->mgmt_tx_cancel_wait(&rdev->wiphy, wdev, cookie);
+}
+
+static inline int rdev_set_power_mgmt(struct cfg80211_registered_device *rdev,
+				      struct net_device *dev, bool enabled,
+				      int timeout)
+{
+	return rdev->ops->set_power_mgmt(&rdev->wiphy, dev, enabled, timeout);
+}
+
+static inline int
+rdev_set_cqm_rssi_config(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev, s32 rssi_thold, u32 rssi_hyst)
+{
+	return rdev->ops->set_cqm_rssi_config(&rdev->wiphy, dev, rssi_thold,
+					      rssi_hyst);
+}
+
+static inline int
+rdev_set_cqm_txe_config(struct cfg80211_registered_device *rdev,
+			struct net_device *dev, u32 rate, u32 pkts, u32 intvl)
+{
+	return rdev->ops->set_cqm_txe_config(&rdev->wiphy, dev, rate, pkts,
+					     intvl);
+}
+
+static inline void
+rdev_mgmt_frame_register(struct cfg80211_registered_device *rdev,
+			 struct wireless_dev *wdev, u16 frame_type, bool reg)
+{
+	rdev->ops->mgmt_frame_register(&rdev->wiphy, wdev , frame_type,
+					      reg);
+}
+
+static inline int rdev_set_antenna(struct cfg80211_registered_device *rdev,
+				   u32 tx_ant, u32 rx_ant)
+{
+	return rdev->ops->set_antenna(&rdev->wiphy, tx_ant, rx_ant);
+}
+
+static inline int rdev_get_antenna(struct cfg80211_registered_device *rdev,
+				   u32 *tx_ant, u32 *rx_ant)
+{
+	return rdev->ops->get_antenna(&rdev->wiphy, tx_ant, rx_ant);
+}
+
+static inline int rdev_set_ringparam(struct cfg80211_registered_device *rdev,
+				     u32 tx, u32 rx)
+{
+	return rdev->ops->set_ringparam(&rdev->wiphy, tx, rx);
+}
+
+static inline void rdev_get_ringparam(struct cfg80211_registered_device *rdev,
+				      u32 *tx, u32 *tx_max, u32 *rx,
+				      u32 *rx_max)
+{
+	rdev->ops->get_ringparam(&rdev->wiphy, tx, tx_max, rx, rx_max);
+}
+
+static inline int
+rdev_sched_scan_start(struct cfg80211_registered_device *rdev,
+		      struct net_device *dev,
+		      struct cfg80211_sched_scan_request *request)
+{
+	return rdev->ops->sched_scan_start(&rdev->wiphy, dev, request);
+}
+
+static inline int rdev_sched_scan_stop(struct cfg80211_registered_device *rdev,
+				       struct net_device *dev)
+{
+	return rdev->ops->sched_scan_stop(&rdev->wiphy, dev);
+}
+
+static inline int rdev_set_rekey_data(struct cfg80211_registered_device *rdev,
+				      struct net_device *dev,
+				      struct cfg80211_gtk_rekey_data *data)
+{
+	return rdev->ops->set_rekey_data(&rdev->wiphy, dev, data);
+}
+
+static inline int rdev_tdls_mgmt(struct cfg80211_registered_device *rdev,
+				 struct net_device *dev, u8 *peer,
+				 u8 action_code, u8 dialog_token,
+				 u16 status_code, const u8 *buf, size_t len)
+{
+	return rdev->ops->tdls_mgmt(&rdev->wiphy, dev, peer, action_code,
+				    dialog_token, status_code, buf, len);
+}
+
+static inline int rdev_tdls_oper(struct cfg80211_registered_device *rdev,
+				 struct net_device *dev, u8 *peer,
+				 enum nl80211_tdls_operation oper)
+{
+	return rdev->ops->tdls_oper(&rdev->wiphy, dev, peer, oper);
+}
+
+static inline int rdev_probe_client(struct cfg80211_registered_device *rdev,
+				    struct net_device *dev, const u8 *peer,
+				    u64 *cookie)
+{
+	return rdev->ops->probe_client(&rdev->wiphy, dev, peer, cookie);
+}
+
+static inline int rdev_set_noack_map(struct cfg80211_registered_device *rdev,
+				     struct net_device *dev, u16 noack_map)
+{
+	return rdev->ops->set_noack_map(&rdev->wiphy, dev, noack_map);
+}
+
+static inline int
+rdev_get_et_sset_count(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev, int sset)
+{
+	return rdev->ops->get_et_sset_count(&rdev->wiphy, dev, sset);
+}
+
+static inline void rdev_get_et_stats(struct cfg80211_registered_device *rdev,
+				     struct net_device *dev,
+				     struct ethtool_stats *stats, u64 *data)
+{
+	rdev->ops->get_et_stats(&rdev->wiphy, dev, stats, data);
+}
+
+static inline void rdev_get_et_strings(struct cfg80211_registered_device *rdev,
+				       struct net_device *dev, u32 sset,
+				       u8 *data)
+{
+	rdev->ops->get_et_strings(&rdev->wiphy, dev, sset, data);
+}
+
+static inline struct ieee80211_channel
+*rdev_get_channel(struct cfg80211_registered_device *rdev,
+		  struct wireless_dev *wdev, enum nl80211_channel_type *type)
+{
+	return rdev->ops->get_channel(&rdev->wiphy, wdev, type);
+}
+
+#endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index a8d5a9a..a957077 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -17,6 +17,7 @@
 #include "core.h"
 #include "nl80211.h"
 #include "wext-compat.h"
+#include "rdev-ops.h"
 
 #define IEEE80211_SCAN_RESULT_EXPIRE	(30 * HZ)
 
@@ -211,7 +212,7 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 	dev = rdev->sched_scan_req->dev;
 
 	if (!driver_initiated) {
-		int err = rdev->ops->sched_scan_stop(&rdev->wiphy, dev);
+		int err = rdev_sched_scan_stop(rdev, dev);
 		if (err)
 			return err;
 	}
@@ -1052,7 +1053,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 			creq->rates[i] = (1 << wiphy->bands[i]->n_bitrates) - 1;
 
 	rdev->scan_req = creq;
-	err = rdev->ops->scan(wiphy, creq);
+	err = rdev_scan(rdev, creq);
 	if (err) {
 		rdev->scan_req = NULL;
 		/* creq will be freed below */
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 07d717e..c749002 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -16,6 +16,7 @@
 #include <net/rtnetlink.h>
 #include "nl80211.h"
 #include "reg.h"
+#include "rdev-ops.h"
 
 struct cfg80211_conn {
 	struct cfg80211_connect_params params;
@@ -142,7 +143,7 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 
 	rdev->scan_req = request;
 
-	err = rdev->ops->scan(wdev->wiphy, request);
+	err = rdev_scan(rdev, request);
 	if (!err) {
 		wdev->conn->state = CFG80211_CONN_SCANNING;
 		nl80211_send_scan_start(rdev, wdev);
@@ -717,7 +718,7 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 	 */
 	if (rdev->ops->del_key)
 		for (i = 0; i < 6; i++)
-			rdev->ops->del_key(wdev->wiphy, dev, i, false, NULL);
+			rdev_del_key(rdev, dev, i, false, NULL);
 
 #ifdef CONFIG_CFG80211_WEXT
 	memset(&wrqu, 0, sizeof(wrqu));
@@ -893,7 +894,7 @@ int __cfg80211_connect(struct cfg80211_registered_device *rdev,
 	} else {
 		wdev->sme_state = CFG80211_SME_CONNECTING;
 		wdev->connect_keys = connkeys;
-		err = rdev->ops->connect(&rdev->wiphy, dev, connect);
+		err = rdev_connect(rdev, dev, connect);
 		if (err) {
 			wdev->connect_keys = NULL;
 			wdev->sme_state = CFG80211_SME_IDLE;
@@ -965,7 +966,7 @@ int __cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 		if (err)
 			return err;
 	} else {
-		err = rdev->ops->disconnect(&rdev->wiphy, dev, reason);
+		err = rdev_disconnect(rdev, dev, reason);
 		if (err)
 			return err;
 	}
diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index ff57459..9bf6d5e 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -16,6 +16,7 @@
 #include <net/cfg80211.h>
 #include "sysfs.h"
 #include "core.h"
+#include "rdev-ops.h"
 
 static inline struct cfg80211_registered_device *dev_to_rdev(
 	struct device *dev)
@@ -94,7 +95,7 @@ static int wiphy_suspend(struct device *dev, pm_message_t state)
 	if (rdev->ops->suspend) {
 		rtnl_lock();
 		if (rdev->wiphy.registered)
-			ret = rdev->ops->suspend(&rdev->wiphy, rdev->wowlan);
+			ret = rdev_suspend(rdev);
 		rtnl_unlock();
 	}
 
@@ -114,7 +115,7 @@ static int wiphy_resume(struct device *dev)
 	if (rdev->ops->resume) {
 		rtnl_lock();
 		if (rdev->wiphy.registered)
-			ret = rdev->ops->resume(&rdev->wiphy);
+			ret = rdev_resume(rdev);
 		rtnl_unlock();
 	}
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index f6e19a3..41da8a1 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -11,6 +11,8 @@
 #include <net/ip.h>
 #include <net/dsfield.h>
 #include "core.h"
+#include "rdev-ops.h"
+
 
 struct ieee80211_rate *
 ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
@@ -703,19 +705,18 @@ void cfg80211_upload_connect_keys(struct wireless_dev *wdev)
 	for (i = 0; i < 6; i++) {
 		if (!wdev->connect_keys->params[i].cipher)
 			continue;
-		if (rdev->ops->add_key(wdev->wiphy, dev, i, false, NULL,
-					&wdev->connect_keys->params[i])) {
+		if (rdev_add_key(rdev, dev, i, false, NULL,
+				 &wdev->connect_keys->params[i])) {
 			netdev_err(dev, "failed to set key %d\n", i);
 			continue;
 		}
 		if (wdev->connect_keys->def == i)
-			if (rdev->ops->set_default_key(wdev->wiphy, dev,
-						       i, true, true)) {
+			if (rdev_set_default_key(rdev, dev, i, true, true)) {
 				netdev_err(dev, "failed to set defkey %d\n", i);
 				continue;
 			}
 		if (wdev->connect_keys->defmgmt == i)
-			if (rdev->ops->set_default_mgmt_key(wdev->wiphy, dev, i))
+			if (rdev_set_default_mgmt_key(rdev, dev, i))
 				netdev_err(dev, "failed to set mgtdef %d\n", i);
 	}
 
@@ -848,8 +849,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		cfg80211_process_rdev_events(rdev);
 	}
 
-	err = rdev->ops->change_virtual_intf(&rdev->wiphy, dev,
-					     ntype, flags, params);
+	err = rdev_change_virtual_intf(rdev, dev, ntype, flags, params);
 
 	WARN_ON(!err && dev->ieee80211_ptr->iftype != ntype);
 
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 494379e..6488d2d 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -19,6 +19,7 @@
 #include <net/cfg80211-wext.h>
 #include "wext-compat.h"
 #include "core.h"
+#include "rdev-ops.h"
 
 int cfg80211_wext_giwname(struct net_device *dev,
 			  struct iw_request_info *info,
@@ -301,8 +302,7 @@ int cfg80211_wext_siwrts(struct net_device *dev,
 	else
 		wdev->wiphy->rts_threshold = rts->value;
 
-	err = rdev->ops->set_wiphy_params(wdev->wiphy,
-					  WIPHY_PARAM_RTS_THRESHOLD);
+	err = rdev_set_wiphy_params(rdev, WIPHY_PARAM_RTS_THRESHOLD);
 	if (err)
 		wdev->wiphy->rts_threshold = orts;
 
@@ -342,8 +342,7 @@ int cfg80211_wext_siwfrag(struct net_device *dev,
 		wdev->wiphy->frag_threshold = frag->value & ~0x1;
 	}
 
-	err = rdev->ops->set_wiphy_params(wdev->wiphy,
-					  WIPHY_PARAM_FRAG_THRESHOLD);
+	err = rdev_set_wiphy_params(rdev, WIPHY_PARAM_FRAG_THRESHOLD);
 	if (err)
 		wdev->wiphy->frag_threshold = ofrag;
 
@@ -396,7 +395,7 @@ static int cfg80211_wext_siwretry(struct net_device *dev,
 	if (!changed)
 		return 0;
 
-	err = rdev->ops->set_wiphy_params(wdev->wiphy, changed);
+	err = rdev_set_wiphy_params(rdev, changed);
 	if (err) {
 		wdev->wiphy->retry_short = oshort;
 		wdev->wiphy->retry_long = olong;
@@ -490,8 +489,8 @@ static int __cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 			    !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))
 				err = -ENOENT;
 			else
-				err = rdev->ops->del_key(&rdev->wiphy, dev, idx,
-							 pairwise, addr);
+				err = rdev_del_key(rdev, dev, idx, pairwise,
+						   addr);
 		}
 		wdev->wext.connect.privacy = false;
 		/*
@@ -525,8 +524,7 @@ static int __cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 
 	err = 0;
 	if (wdev->current_bss)
-		err = rdev->ops->add_key(&rdev->wiphy, dev, idx,
-					 pairwise, addr, params);
+		err = rdev_add_key(rdev, dev, idx, pairwise, addr, params);
 	if (err)
 		return err;
 
@@ -552,8 +550,7 @@ static int __cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 				__cfg80211_leave_ibss(rdev, wdev->netdev, true);
 				rejoin = true;
 			}
-			err = rdev->ops->set_default_key(&rdev->wiphy, dev,
-							 idx, true, true);
+			err = rdev_set_default_key(rdev, dev, idx, true, true);
 		}
 		if (!err) {
 			wdev->wext.default_key = idx;
@@ -566,8 +563,7 @@ static int __cfg80211_set_encryption(struct cfg80211_registered_device *rdev,
 	if (params->cipher == WLAN_CIPHER_SUITE_AES_CMAC &&
 	    (tx_key || (!addr && wdev->wext.default_mgmt_key == -1))) {
 		if (wdev->current_bss)
-			err = rdev->ops->set_default_mgmt_key(&rdev->wiphy,
-							      dev, idx);
+			err = rdev_set_default_mgmt_key(rdev, dev, idx);
 		if (!err)
 			wdev->wext.default_mgmt_key = idx;
 		return err;
@@ -631,8 +627,8 @@ static int cfg80211_wext_siwencode(struct net_device *dev,
 		err = 0;
 		wdev_lock(wdev);
 		if (wdev->current_bss)
-			err = rdev->ops->set_default_key(&rdev->wiphy, dev,
-							 idx, true, true);
+			err = rdev_set_default_key(rdev, dev, idx, true,
+						   true);
 		if (!err)
 			wdev->wext.default_key = idx;
 		wdev_unlock(wdev);
@@ -839,7 +835,7 @@ static int cfg80211_wext_giwfreq(struct net_device *dev,
 		if (!rdev->ops->get_channel)
 			return -EINVAL;
 
-		chan = rdev->ops->get_channel(wdev->wiphy, wdev, &channel_type);
+		chan = rdev_get_channel(rdev, wdev, &channel_type);
 		if (!chan)
 			return -EINVAL;
 		freq->m = chan->center_freq;
@@ -899,7 +895,7 @@ static int cfg80211_wext_siwtxpower(struct net_device *dev,
 		return 0;
 	}
 
-	return rdev->ops->set_tx_power(wdev->wiphy, type, DBM_TO_MBM(dbm));
+	return rdev_set_tx_power(rdev, type, DBM_TO_MBM(dbm));
 }
 
 static int cfg80211_wext_giwtxpower(struct net_device *dev,
@@ -918,7 +914,7 @@ static int cfg80211_wext_giwtxpower(struct net_device *dev,
 	if (!rdev->ops->get_tx_power)
 		return -EOPNOTSUPP;
 
-	err = rdev->ops->get_tx_power(wdev->wiphy, &val);
+	err = rdev_get_tx_power(rdev, &val);
 	if (err)
 		return err;
 
@@ -1158,7 +1154,7 @@ static int cfg80211_wext_siwpower(struct net_device *dev,
 			timeout = wrq->value / 1000;
 	}
 
-	err = rdev->ops->set_power_mgmt(wdev->wiphy, dev, ps, timeout);
+	err = rdev_set_power_mgmt(rdev, dev, ps, timeout);
 	if (err)
 		return err;
 
@@ -1200,7 +1196,7 @@ static int cfg80211_wds_wext_siwap(struct net_device *dev,
 	if (!rdev->ops->set_wds_peer)
 		return -EOPNOTSUPP;
 
-	err = rdev->ops->set_wds_peer(wdev->wiphy, dev, (u8 *) &addr->sa_data);
+	err = rdev_set_wds_peer(rdev, dev, (u8 *)&addr->sa_data);
 	if (err)
 		return err;
 
@@ -1272,7 +1268,7 @@ static int cfg80211_wext_siwrate(struct net_device *dev,
 	if (!match)
 		return -EINVAL;
 
-	return rdev->ops->set_bitrate_mask(wdev->wiphy, dev, NULL, &mask);
+	return rdev_set_bitrate_mask(rdev, dev, NULL, &mask);
 }
 
 static int cfg80211_wext_giwrate(struct net_device *dev,
@@ -1302,7 +1298,7 @@ static int cfg80211_wext_giwrate(struct net_device *dev,
 	if (err)
 		return err;
 
-	err = rdev->ops->get_station(&rdev->wiphy, dev, addr, &sinfo);
+	err = rdev_get_station(rdev, dev, addr, &sinfo);
 	if (err)
 		return err;
 
@@ -1339,7 +1335,7 @@ static struct iw_statistics *cfg80211_wireless_stats(struct net_device *dev)
 	memcpy(bssid, wdev->current_bss->pub.bssid, ETH_ALEN);
 	wdev_unlock(wdev);
 
-	if (rdev->ops->get_station(&rdev->wiphy, dev, bssid, &sinfo))
+	if (rdev_get_station(rdev, dev, bssid, &sinfo))
 		return NULL;
 
 	memset(&wstats, 0, sizeof(wstats));
@@ -1474,19 +1470,19 @@ static int cfg80211_wext_siwpmksa(struct net_device *dev,
 		if (!rdev->ops->set_pmksa)
 			return -EOPNOTSUPP;
 
-		return rdev->ops->set_pmksa(&rdev->wiphy, dev, &cfg_pmksa);
+		return rdev_set_pmksa(rdev, dev, &cfg_pmksa);
 
 	case IW_PMKSA_REMOVE:
 		if (!rdev->ops->del_pmksa)
 			return -EOPNOTSUPP;
 
-		return rdev->ops->del_pmksa(&rdev->wiphy, dev, &cfg_pmksa);
+		return rdev_del_pmksa(rdev, dev, &cfg_pmksa);
 
 	case IW_PMKSA_FLUSH:
 		if (!rdev->ops->flush_pmksa)
 			return -EOPNOTSUPP;
 
-		return rdev->ops->flush_pmksa(&rdev->wiphy, dev);
+		return rdev_flush_pmksa(rdev, dev);
 
 	default:
 		return -EOPNOTSUPP;
-- 
1.7.10.4

