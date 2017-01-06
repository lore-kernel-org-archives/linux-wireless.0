Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:33284 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932827AbdAFVdx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2017 16:33:53 -0500
Received: by mail-ua0-f196.google.com with SMTP id d5so36879311uag.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jan 2017 13:33:53 -0800 (PST)
Received: from localhost.localdomain ([190.232.43.60])
        by smtp.gmail.com with ESMTPSA id e2sm2059901uae.6.2017.01.06.13.33.51
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Jan 2017 13:33:51 -0800 (PST)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v5] cfg80211: NL80211_ATTR_SOCKET_OWNER support for CMD_CONNECT
Date: Fri,  6 Jan 2017 16:33:43 -0500
Message-Id: <20170106213343.6598-1-andrew.zaborowski@intel.com> (sfid-20170106_223357_427320_4F3F254F)
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
changes in v4:
 - move cfg80211_autodisconnect_wk to sme.c
 - drop two "wdev->conn_owner_nlportid = 0" lines in nl80211.c found redundant
 - use wdev_lock when setting wdev->conn_owner_nlportid
 - drop wdev->netdev check in cfg80211_autodisconnect_wk
changes in v5:
 - in nl80211_netlink_notify schedule disconnect_wk even if another wdev
   is wdev is owned by the nlportid and is being destroyed
 - in cfg80211_mlme_deauth check the bssid is of the current bss or
   disconnect_bssid
 - set disconnect_bssid in nl80211_connect if bssid supplied
---
 include/net/cfg80211.h       |  7 +++++++
 include/uapi/linux/nl80211.h |  2 ++
 net/wireless/core.c          |  3 +++
 net/wireless/core.h          |  1 +
 net/wireless/mlme.c          |  5 +++++
 net/wireless/nl80211.c       | 26 +++++++++++++++++++++++++-
 net/wireless/sme.c           | 33 +++++++++++++++++++++++++++++++++
 7 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 814be4b..57383a1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3837,6 +3837,9 @@ struct cfg80211_cached_keys;
  * @conn: (private) cfg80211 software SME connection state machine data
  * @connect_keys: (private) keys to set after connection is established
  * @conn_bss_type: connecting/connected BSS type
+ * @conn_owner_nlportid: (private) connection owner socket port ID
+ * @disconnect_wk: (private) auto-disconnect work
+ * @disconnect_bssid: (private) the BSSID to use for auto-disconnect
  * @ibss_fixed: (private) IBSS is using fixed BSSID
  * @ibss_dfs_possible: (private) IBSS may change to a DFS channel
  * @event_list: (private) list for internal event processing
@@ -3868,6 +3871,10 @@ struct wireless_dev {
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
index 6b76e3b..455ed9b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1820,6 +1820,8 @@ enum nl80211_commands {
  *	and remove functions. NAN notifications will be sent in unicast to that
  *	socket. Without this attribute, any socket can add functions and the
  *	notifications will be sent to the %NL80211_MCGRP_NAN multicast group.
+ *	If set during %NL80211_CMD_ASSOCIATE or %NL80211_CMD_CONNECT the
+ *	station will deauthenticate when the socket is closed.
  *
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 158c59e..903fc41 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1142,6 +1142,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
 			dev->priv_flags |= IFF_DONT_BRIDGE;
 
+		INIT_WORK(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
+
 		nl80211_notify_iface(rdev, wdev, NL80211_CMD_NEW_INTERFACE);
 		break;
 	case NETDEV_GOING_DOWN:
@@ -1230,6 +1232,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 #ifdef CONFIG_CFG80211_WEXT
 			kzfree(wdev->wext.keys);
 #endif
+			flush_work(&wdev->disconnect_wk);
 		}
 		/*
 		 * synchronise (so that we won't find this netdev
diff --git a/net/wireless/core.h b/net/wireless/core.h
index af6e023..9d1a030 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -400,6 +400,7 @@ void __cfg80211_roamed(struct wireless_dev *wdev,
 		       const u8 *resp_ie, size_t resp_ie_len);
 int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev);
+void cfg80211_autodisconnect_wk(struct work_struct *work);
 
 /* SME implementation */
 void cfg80211_conn_work(struct work_struct *work);
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 4646cf5..1c63a77 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -345,6 +345,11 @@ int cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 	     !ether_addr_equal(wdev->current_bss->pub.bssid, bssid)))
 		return 0;
 
+	if (ether_addr_equal(wdev->disconnect_bssid, bssid) ||
+	    (wdev->current_bss &&
+	     ether_addr_equal(wdev->current_bss->pub.bssid, bssid)))
+		wdev->conn_owner_nlportid = 0;
+
 	return rdev_deauth(rdev, dev, &req);
 }
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ef5eff93..cc05d36 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8053,8 +8053,17 @@ static int nl80211_associate(struct sk_buff *skb, struct genl_info *info)
 	err = nl80211_crypto_settings(rdev, info, &req.crypto, 1);
 	if (!err) {
 		wdev_lock(dev->ieee80211_ptr);
+
 		err = cfg80211_mlme_assoc(rdev, dev, chan, bssid,
 					  ssid, ssid_len, &req);
+
+		if (!err && info->attrs[NL80211_ATTR_SOCKET_OWNER]) {
+			dev->ieee80211_ptr->conn_owner_nlportid =
+				info->snd_portid;
+			memcpy(dev->ieee80211_ptr->disconnect_bssid,
+			       bssid, ETH_ALEN);
+		}
+
 		wdev_unlock(dev->ieee80211_ptr);
 	}
 
@@ -8773,11 +8782,24 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	wdev_lock(dev->ieee80211_ptr);
+
 	err = cfg80211_connect(rdev, dev, &connect, connkeys,
 			       connect.prev_bssid);
-	wdev_unlock(dev->ieee80211_ptr);
 	if (err)
 		kzfree(connkeys);
+
+	if (!err && info->attrs[NL80211_ATTR_SOCKET_OWNER]) {
+		dev->ieee80211_ptr->conn_owner_nlportid = info->snd_portid;
+		if (connect.bssid)
+			memcpy(dev->ieee80211_ptr->disconnect_bssid,
+			       connect.bssid, ETH_ALEN);
+		else
+			memset(dev->ieee80211_ptr->disconnect_bssid,
+			       0, ETH_ALEN);
+	}
+
+	wdev_unlock(dev->ieee80211_ptr);
+
 	return err;
 }
 
@@ -14519,6 +14541,8 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 
 			if (wdev->owner_nlportid == notify->portid)
 				schedule_destroy_work = true;
+			else if (wdev->conn_owner_nlportid == notify->portid)
+				schedule_work(&wdev->disconnect_wk);
 		}
 
 		spin_lock_bh(&rdev->beacon_registrations_lock);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 5e0d193..4669391 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -727,6 +727,7 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 		kzfree(wdev->connect_keys);
 		wdev->connect_keys = NULL;
 		wdev->ssid_len = 0;
+		wdev->conn_owner_nlportid = 0;
 		if (bss) {
 			cfg80211_unhold_bss(bss_from_pub(bss));
 			cfg80211_put_bss(wdev->wiphy, bss);
@@ -955,6 +956,7 @@ void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 
 	wdev->current_bss = NULL;
 	wdev->ssid_len = 0;
+	wdev->conn_owner_nlportid = 0;
 
 	nl80211_send_disconnected(rdev, dev, reason, ie, ie_len, from_ap);
 
@@ -1098,6 +1100,8 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 	kzfree(wdev->connect_keys);
 	wdev->connect_keys = NULL;
 
+	wdev->conn_owner_nlportid = 0;
+
 	if (wdev->conn)
 		err = cfg80211_sme_disconnect(wdev, reason);
 	else if (!rdev->ops->disconnect)
@@ -1107,3 +1111,32 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 
 	return err;
 }
+
+/*
+ * Used to clean up after the connection / connection attempt owner socket
+ * disconnects
+ */
+void cfg80211_autodisconnect_wk(struct work_struct *work)
+{
+	struct wireless_dev *wdev =
+		container_of(work, struct wireless_dev, disconnect_wk);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
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
+					    WLAN_REASON_DEAUTH_LEAVING, true);
+		else
+			cfg80211_mlme_deauth(rdev, wdev->netdev,
+					     wdev->disconnect_bssid, NULL, 0,
+					     WLAN_REASON_DEAUTH_LEAVING, false);
+	}
+
+	wdev_unlock(wdev);
+}
-- 
2.9.3
