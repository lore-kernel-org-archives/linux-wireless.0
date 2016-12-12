Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34013 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752488AbcLLQpJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 11:45:09 -0500
Received: by mail-wm0-f67.google.com with SMTP id g23so12438986wme.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Dec 2016 08:45:08 -0800 (PST)
Received: from iss.ger.corp.intel.com ([92.185.195.211])
        by smtp.gmail.com with ESMTPSA id j1sm58075951wjm.26.2016.12.12.08.45.06
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Dec 2016 08:45:06 -0800 (PST)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v3] cfg80211: NL80211_ATTR_SOCKET_OWNER support for CMD_CONNECT
Date: Mon, 12 Dec 2016 17:45:00 +0100
Message-Id: <20161212164500.691-1-andrew.zaborowski@intel.com> (sfid-20161212_174513_083117_405C8DC6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disconnect or deauthenticate when the owning socket is closed if this
flag is supplied to CMD_CONNECT or CMD_ASSOCIATE.  This may be used
to ensure userspace daemon doesn't leave an unmanaged connection behind.

In some situations it would be possible to account for that, to some
degree, in the deamon restart code or in the up/down scripts without
the use of this attribute.  But there will be systems where the daemon
can go away for varying periods without a warning due to local resource
management.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
changes in v2:
 - add wdev.disconnect_bssid so we can deauthenticate from a BSS before
   association finishes
 - dropped CMD_AUTHENTICATE changes
changes in v3:
 - commit message fix
---
 include/net/cfg80211.h       |  7 +++++++
 include/uapi/linux/nl80211.h |  2 ++
 net/wireless/core.c          | 33 +++++++++++++++++++++++++++++++++
 net/wireless/mlme.c          |  2 ++
 net/wireless/nl80211.c       | 28 +++++++++++++++++++++++++++-
 net/wireless/sme.c           |  4 ++++
 6 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bd19faa..ca2e252 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3764,6 +3764,9 @@ struct cfg80211_cached_keys;
  * @conn: (private) cfg80211 software SME connection state machine data
  * @connect_keys: (private) keys to set after connection is established
  * @conn_bss_type: connecting/connected BSS type
+ * @conn_owner_nlportid: (private) connection owner socket port ID
+ * @disconnect_wk: (private) auto-disconnect work
+ * @disconnect_bssid: (private) the BSSID to use for auto-disconnect
  * @ibss_fixed: (private) IBSS is using fixed BSSID
  * @ibss_dfs_possible: (private) IBSS may change to a DFS channel
  * @event_list: (private) list for internal event processing
@@ -3795,6 +3798,10 @@ struct wireless_dev {
 	struct cfg80211_conn *conn;
 	struct cfg80211_cached_keys *connect_keys;
 	enum ieee80211_bss_type conn_bss_type;
+	u32 conn_owner_nlportid;
+
+	struct work_struct disconnect_wk;
+	u8 disconnect_bssid[ETH_ALEN];
 
 	struct list_head event_list;
 	spinlock_t event_lock;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 56368e9..84db1f0 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1788,6 +1788,8 @@ enum nl80211_commands {
  *	and remove functions. NAN notifications will be sent in unicast to that
  *	socket. Without this attribute, any socket can add functions and the
  *	notifications will be sent to the %NL80211_MCGRP_NAN multicast group.
+ *	If set during %NL80211_CMD_ASSOCIATE or %NL80211_CMD_CONNECT the
+ *	station will deauthenticate when the socket is closed.
  *
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 8201e6d..6b8fd68 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -357,6 +357,36 @@ static void cfg80211_sched_scan_stop_wk(struct work_struct *work)
 	rtnl_unlock();
 }
 
+static void cfg80211_disconnect_wk(struct work_struct *work)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+
+	wdev = container_of(work, struct wireless_dev, disconnect_wk);
+	rdev = wiphy_to_rdev(wdev->wiphy);
+
+	if (!wdev->netdev)
+		return;
+
+	wdev_lock(wdev);
+
+	if (wdev->conn_owner_nlportid) {
+		/*
+		 * Use disconnect_bssid if still connecting and ops->disconnect
+		 * not implemented.  Otherwise we can use cfg80211_disconnect.
+		 */
+		if (rdev->ops->disconnect || wdev->current_bss)
+			cfg80211_disconnect(rdev, wdev->netdev,
+					WLAN_REASON_DEAUTH_LEAVING, true);
+		else
+			cfg80211_mlme_deauth(rdev, wdev->netdev,
+					wdev->disconnect_bssid, NULL, 0,
+					WLAN_REASON_DEAUTH_LEAVING, false);
+	}
+
+	wdev_unlock(wdev);
+}
+
 /* exported functions */
 
 struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
@@ -1117,6 +1147,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
 			dev->priv_flags |= IFF_DONT_BRIDGE;
 
+		INIT_WORK(&wdev->disconnect_wk, cfg80211_disconnect_wk);
+
 		nl80211_notify_iface(rdev, wdev, NL80211_CMD_NEW_INTERFACE);
 		break;
 	case NETDEV_GOING_DOWN:
@@ -1205,6 +1237,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 #ifdef CONFIG_CFG80211_WEXT
 			kzfree(wdev->wext.keys);
 #endif
+			flush_work(&wdev->disconnect_wk);
 		}
 		/*
 		 * synchronise (so that we won't find this netdev
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index cbb48e2..9923244 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -328,6 +328,8 @@ int cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 
 	ASSERT_WDEV_LOCK(wdev);
 
+	wdev->conn_owner_nlportid = 0;
+
 	if (local_state_change &&
 	    (!wdev->current_bss ||
 	     !ether_addr_equal(wdev->current_bss->pub.bssid, bssid)))
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c510810..502ae92 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8003,6 +8003,12 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 		wdev_unlock(dev->ieee80211_ptr);
 	}
 
+	if (!err && info->attrs[NL80211_ATTR_SOCKET_OWNER]) {
+		dev->ieee80211_ptr->conn_owner_nlportid = info->snd_portid;
+
+		memcpy(dev->ieee80211_ptr->disconnect_bssid, bssid, ETH_ALEN);
+	}
+
 	return err;
 }
 
@@ -8050,6 +8056,10 @@ static int nl80211_deauthenticate(struct sk_buff *skb, struct genl_info *info)
 	err = cfg80211_mlme_deauth(rdev, dev, bssid, ie, ie_len, reason_code,
 				   local_state_change);
 	wdev_unlock(dev->ieee80211_ptr);
+
+	if (!err)
+		dev->ieee80211_ptr->conn_owner_nlportid = 0;
+
 	return err;
 }
 
@@ -8097,6 +8107,10 @@ static int nl80211_disassociate(struct sk_buff *skb, struct genl_info *info)
 	err = cfg80211_mlme_disassoc(rdev, dev, bssid, ie, ie_len, reason_code,
 				     local_state_change);
 	wdev_unlock(dev->ieee80211_ptr);
+
+	if (!err)
+		dev->ieee80211_ptr->conn_owner_nlportid = 0;
+
 	return err;
 }
 
@@ -8723,6 +8737,10 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	wdev_unlock(dev->ieee80211_ptr);
 	if (err)
 		kzfree(connkeys);
+
+	if (!err && info->attrs[NL80211_ATTR_SOCKET_OWNER])
+		dev->ieee80211_ptr->conn_owner_nlportid = info->snd_portid;
+
 	return err;
 }
 
@@ -14425,13 +14443,21 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 				spin_unlock(&rdev->destroy_list_lock);
 				schedule_work(&rdev->destroy_work);
 			}
-		} else if (schedule_scan_stop) {
+
+			continue;
+		}
+
+		if (schedule_scan_stop) {
 			sched_scan_req->owner_nlportid = 0;
 
 			if (rdev->ops->sched_scan_stop &&
 			    rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
 				schedule_work(&rdev->sched_scan_stop_wk);
 		}
+
+		list_for_each_entry_rcu(wdev, &rdev->wiphy.wdev_list, list)
+			if (wdev->conn_owner_nlportid == notify->portid)
+				schedule_work(&wdev->disconnect_wk);
 	}
 
 	rcu_read_unlock();
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index a77db33..f5cc067 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -713,6 +713,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 		kzfree(wdev->connect_keys);
 		wdev->connect_keys = NULL;
 		wdev->ssid_len = 0;
+		wdev->conn_owner_nlportid = 0;
 		if (bss) {
 			cfg80211_unhold_bss(bss_from_pub(bss));
 			cfg80211_put_bss(wdev->wiphy, bss);
@@ -941,6 +942,7 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 
 	wdev->current_bss = NULL;
 	wdev->ssid_len = 0;
+	wdev->conn_owner_nlportid = 0;
 
 	nl80211_send_disconnected(rdev, dev, reason, ie, ie_len, from_ap);
 
@@ -1084,6 +1086,8 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 	kzfree(wdev->connect_keys);
 	wdev->connect_keys = NULL;
 
+	wdev->conn_owner_nlportid = 0;
+
 	if (wdev->conn)
 		err = cfg80211_sme_disconnect(wdev, reason);
 	else if (!rdev->ops->disconnect)
-- 
2.9.3
