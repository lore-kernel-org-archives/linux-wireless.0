Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f196.google.com ([209.85.210.196]:34753 "EHLO
        mail-wj0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755636AbcLBVPV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Dec 2016 16:15:21 -0500
Received: by mail-wj0-f196.google.com with SMTP id xy5so31728672wjc.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Dec 2016 13:15:21 -0800 (PST)
Received: from localhost.localdomain (201.red-83-53-57.dynamicip.rima-tde.net. [83.53.57.201])
        by smtp.gmail.com with ESMTPSA id c187sm5005115wmd.13.2016.12.02.12.56.19
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Dec 2016 12:56:20 -0800 (PST)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH][RFC] cfg80211: NL80211_ATTR_SOCKET_OWNER support for CMD_CONNECT
Date: Fri,  2 Dec 2016 21:56:11 +0100
Message-Id: <20161202205611.14141-1-andrew.zaborowski@intel.com> (sfid-20161202_221617_913447_8760246C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disconnect or deauthenticate when the owning socket is closed if this
flag has been supplied to CMD_CONNECT, CMD_AUTHENTICATE or CMD_ASSOCIATE.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
 include/net/cfg80211.h       |  5 +++++
 include/uapi/linux/nl80211.h |  3 +++
 net/wireless/core.c          | 23 +++++++++++++++++++++++
 net/wireless/mlme.c          |  4 ++++
 net/wireless/nl80211.c       | 29 ++++++++++++++++++++++++++++-
 net/wireless/sme.c           |  4 ++++
 6 files changed, 67 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bd19faa..413f5b5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3764,6 +3764,8 @@ struct cfg80211_cached_keys;
  * @conn: (private) cfg80211 software SME connection state machine data
  * @connect_keys: (private) keys to set after connection is established
  * @conn_bss_type: connecting/connected BSS type
+ * @conn_owner_nlportid: (private) connection owner socket port ID
+ * @disconnect_wk: (private) auto-disconnect work
  * @ibss_fixed: (private) IBSS is using fixed BSSID
  * @ibss_dfs_possible: (private) IBSS may change to a DFS channel
  * @event_list: (private) list for internal event processing
@@ -3795,6 +3797,9 @@ struct wireless_dev {
 	struct cfg80211_conn *conn;
 	struct cfg80211_cached_keys *connect_keys;
 	enum ieee80211_bss_type conn_bss_type;
+	u32 conn_owner_nlportid;
+
+	struct work_struct disconnect_wk;
 
 	struct list_head event_list;
 	spinlock_t event_lock;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 56368e9..12f41b0 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1788,6 +1788,9 @@ enum nl80211_commands {
  *	and remove functions. NAN notifications will be sent in unicast to that
  *	socket. Without this attribute, any socket can add functions and the
  *	notifications will be sent to the %NL80211_MCGRP_NAN multicast group.
+ *	If set during one of: %NL80211_CMD_AUTHENTICATE, %NL80211_CMD_ASSOCIATE
+ *	or %NL80211_CMD_CONNECT the station will deauthenticate when the
+ *	socket is closed.
  *
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 8201e6d..98db6b2 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -357,6 +357,26 @@ static void cfg80211_sched_scan_stop_wk(struct work_struct *work)
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
+	if (wdev->conn_owner_nlportid)
+		cfg80211_disconnect(rdev, wdev->netdev,
+					WLAN_REASON_DEAUTH_LEAVING, true);
+
+	wdev_unlock(wdev);
+}
+
 /* exported functions */
 
 struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
@@ -1117,6 +1137,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
 			dev->priv_flags |= IFF_DONT_BRIDGE;
 
+		INIT_WORK(&wdev->disconnect_wk, cfg80211_disconnect_wk);
+
 		nl80211_notify_iface(rdev, wdev, NL80211_CMD_NEW_INTERFACE);
 		break;
 	case NETDEV_GOING_DOWN:
@@ -1205,6 +1227,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 #ifdef CONFIG_CFG80211_WEXT
 			kzfree(wdev->wext.keys);
 #endif
+			flush_work(&wdev->disconnect_wk);
 		}
 		/*
 		 * synchronise (so that we won't find this netdev
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index cbb48e2..eaf2d1d 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -130,6 +130,8 @@ void cfg80211_auth_timeout(struct net_device *dev, const u8 *addr)
 
 	nl80211_send_auth_timeout(rdev, dev, addr, GFP_KERNEL);
 	cfg80211_sme_auth_timeout(wdev);
+
+	wdev->conn_owner_nlportid = 0;
 }
 EXPORT_SYMBOL(cfg80211_auth_timeout);
 
@@ -146,6 +148,8 @@ void cfg80211_assoc_timeout(struct net_device *dev, struct cfg80211_bss *bss)
 
 	cfg80211_unhold_bss(bss_from_pub(bss));
 	cfg80211_put_bss(wiphy, bss);
+
+	wdev->conn_owner_nlportid = 0;
 }
 EXPORT_SYMBOL(cfg80211_assoc_timeout);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c510810..ccd74c7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7818,6 +7818,10 @@ static int nl80211_authenticate(struct sk_buff *skb, struct genl_info *info)
 				 key.p.key, key.p.key_len, key.idx,
 				 sae_data, sae_data_len);
 	wdev_unlock(dev->ieee80211_ptr);
+
+	if (!err && info->attrs[NL80211_ATTR_SOCKET_OWNER])
+		dev->ieee80211_ptr->conn_owner_nlportid = info->snd_portid;
+
 	return err;
 }
 
@@ -8003,6 +8007,9 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 		wdev_unlock(dev->ieee80211_ptr);
 	}
 
+	if (!err && info->attrs[NL80211_ATTR_SOCKET_OWNER])
+		dev->ieee80211_ptr->conn_owner_nlportid = info->snd_portid;
+
 	return err;
 }
 
@@ -8050,6 +8057,10 @@ static int nl80211_deauthenticate(struct sk_buff *skb, struct genl_info *info)
 	err = cfg80211_mlme_deauth(rdev, dev, bssid, ie, ie_len, reason_code,
 				   local_state_change);
 	wdev_unlock(dev->ieee80211_ptr);
+
+	if (!err)
+		dev->ieee80211_ptr->conn_owner_nlportid = 0;
+
 	return err;
 }
 
@@ -8097,6 +8108,10 @@ static int nl80211_disassociate(struct sk_buff *skb, struct genl_info *info)
 	err = cfg80211_mlme_disassoc(rdev, dev, bssid, ie, ie_len, reason_code,
 				     local_state_change);
 	wdev_unlock(dev->ieee80211_ptr);
+
+	if (!err)
+		dev->ieee80211_ptr->conn_owner_nlportid = 0;
+
 	return err;
 }
 
@@ -8723,6 +8738,10 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	wdev_unlock(dev->ieee80211_ptr);
 	if (err)
 		kzfree(connkeys);
+
+	if (!err && info->attrs[NL80211_ATTR_SOCKET_OWNER])
+		dev->ieee80211_ptr->conn_owner_nlportid = info->snd_portid;
+
 	return err;
 }
 
@@ -14425,13 +14444,21 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
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
index a77db33..e77f5fa 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -718,6 +718,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			cfg80211_put_bss(wdev->wiphy, bss);
 		}
 		cfg80211_sme_free(wdev);
+		wdev->conn_owner_nlportid = 0;
 		return;
 	}
 
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
