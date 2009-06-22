Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:12302 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751857AbZFVRCi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 13:02:38 -0400
Date: Mon, 22 Jun 2009 19:04:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: sameo@linux.intel.com, "Zhu, Yi" <yi.zhu@intel.com>
Subject: [PATCH 1/2 RFC] cfg80211: connect/disconnect API
Message-ID: <20090622170409.GB30147@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch introduces the cfg80211 connect/disconnect API. The goal here is to
run the AUTH and ASSOC steps in one call. This is needed for some fullmac
cards that run both steps directly from the target, after the host driver
sends a connect command.
The connect/disconnect API is emulated through the auth/assoc/deauth hooks for
the cfg80211 devices that can only provide those.
This API also allows us to move some of the wext calls (ESSID, FREQ and AP)
from mac80211 or driver specific wext implementations to the cfg80211 layer.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
---
 include/linux/nl80211.h |   11 ++
 include/net/cfg80211.h  |   96 ++++++++++++++++++-
 net/wireless/Makefile   |    4 
 net/wireless/core.c     |   58 ++++++++---
 net/wireless/core.h     |   11 ++
 net/wireless/mlme.c     |   65 ++++++++++++
 net/wireless/nl80211.c  |  217 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    7 +
 net/wireless/sme.c      |  241 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/wext-sme.c |  238 +++++++++++++++++++++++++++++++++++++++++++++++
 10 files changed, 925 insertions(+), 23 deletions(-)

Index: iwm-2.6/include/linux/nl80211.h
===================================================================
--- iwm-2.6.orig/include/linux/nl80211.h	2009-06-22 18:42:44.000000000 +0200
+++ iwm-2.6/include/linux/nl80211.h	2009-06-22 18:46:30.000000000 +0200
@@ -242,6 +242,14 @@
  * @NL80211_CMD_LEAVE_IBSS: Leave the IBSS -- no special arguments, the IBSS is
  *	determined by the network interface.
  *
+ * @NL80211_CMD_CONNECT: connection request and notification; this command
+ *	requests to connect to a specified network but without separating
+ *	auth and assoc steps. It is also sent when the connection is
+ *	established and possibly when the card roamed.
+ * @NL80211_CMD_DISCONNECT: drop a given connection; also used to notify
+ *	userspace that a connection was dropped by the AP or due to other
+ *	reasons.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -310,6 +318,9 @@ enum nl80211_commands {
 	NL80211_CMD_JOIN_IBSS,
 	NL80211_CMD_LEAVE_IBSS,
 
+	NL80211_CMD_CONNECT,
+	NL80211_CMD_DISCONNECT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
Index: iwm-2.6/include/net/cfg80211.h
===================================================================
--- iwm-2.6.orig/include/net/cfg80211.h	2009-06-22 18:46:24.000000000 +0200
+++ iwm-2.6/include/net/cfg80211.h	2009-06-22 18:46:30.000000000 +0200
@@ -738,6 +738,37 @@ struct cfg80211_ibss_params {
 };
 
 /**
+ * struct cfg80211_connect_params - Connection parameters
+ *
+ * This structure provides information needed to complete IEEE 802.11
+ * authentication and association.
+ *
+ * @channel: The channel to use or %NULL if not specified (auto-select based
+ *	on scan results)
+ * @bssid: The AP BSSID or %NULL if not specified (auto-select based on scan
+ *	results)
+ * @ssid: SSID
+ * @ssid_len: Length of ssid in octets
+ * @auth_type: Authentication type (algorithm)
+ * @assoc_ie: IEs for association request
+ * @assoc_ie_len: Length of assoc_ie in octets
+ * @control_port: Whether user space controls IEEE 802.1X port, i.e.,
+ *	sets/clears %NL80211_STA_FLAG_AUTHORIZED. If true, the driver is
+ *	required to assume that the port is unauthorized until authorized by
+ *	user space. Otherwise, port is marked authorized by default.
+ */
+struct cfg80211_connect_params {
+	struct ieee80211_channel *channel;
+	u8 *bssid;
+	u8 *ssid;
+	size_t ssid_len;
+	enum nl80211_auth_type auth_type;
+	u8 *ie;
+	size_t ie_len;
+	bool control_port;
+};
+
+/**
  * enum wiphy_params_flags - set_wiphy_params bitfield values
  * WIPHY_PARAM_RETRY_SHORT: wiphy->retry_short has changed
  * WIPHY_PARAM_RETRY_LONG: wiphy->retry_long has changed
@@ -841,6 +872,10 @@ enum tx_power_setting {
  * @deauth: Request to deauthenticate from the specified peer
  * @disassoc: Request to disassociate from the specified peer
  *
+ * @connect: Connect to the ESS with the specified parameters.
+ *	When connected, call cfg80211_connected().
+ * @disconnect: Disconnect from the BSS/ESS.
+ *
  * @join_ibss: Join the specified IBSS (or create if necessary). Once done, call
  *	cfg80211_ibss_joined(), also call that function when changing BSSID due
  *	to a merge.
@@ -944,6 +979,11 @@ struct cfg80211_ops {
 	int	(*disassoc)(struct wiphy *wiphy, struct net_device *dev,
 			    struct cfg80211_disassoc_request *req);
 
+	int	(*connect)(struct wiphy *wiphy, struct net_device *dev,
+			   struct cfg80211_connect_params *sme);
+	int	(*disconnect)(struct wiphy *wiphy, struct net_device *dev,
+			      u16 reason_code);
+
 	int	(*join_ibss)(struct wiphy *wiphy, struct net_device *dev,
 			     struct cfg80211_ibss_params *params);
 	int	(*leave_ibss)(struct wiphy *wiphy, struct net_device *dev);
@@ -1168,16 +1208,25 @@ struct wireless_dev {
 	struct list_head list;
 	struct net_device *netdev;
 
-	/* currently used for IBSS - might be rearranged in the future */
+	/* currently used for IBSS and SME - might be rearranged later */
 	struct cfg80211_bss *current_bss;
 	u8 bssid[ETH_ALEN];
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ssid_len;
+	struct ieee80211_channel *channel;
+	struct cfg80211_assoc_request assoc_req;
+	enum {
+		CFG80211_SME_IDLE,
+		CFG80211_SME_AUTH,
+		CFG80211_SME_ASSOC,
+		CFG80211_SME_CONNECTED,
+	} sme_state;
 
 #ifdef CONFIG_WIRELESS_EXT
 	/* wext data */
 	struct {
 		struct cfg80211_ibss_params ibss;
+		struct cfg80211_connect_params connect;
 		u8 bssid[ETH_ALEN];
 		s8 default_key, default_mgmt_key;
 	} wext;
@@ -1459,6 +1508,25 @@ int cfg80211_ibss_wext_giwap(struct net_
 			     struct iw_request_info *info,
 			     struct sockaddr *ap_addr, char *extra);
 
+int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_freq *freq, char *extra);
+int cfg80211_mgd_wext_giwfreq(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_freq *freq, char *extra);
+int cfg80211_mgd_wext_siwessid(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *data, char *ssid);
+int cfg80211_mgd_wext_giwessid(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *data, char *ssid);
+int cfg80211_mgd_wext_siwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *ap_addr, char *extra);
+int cfg80211_mgd_wext_giwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *ap_addr, char *extra);
+
 struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
 					     struct iw_freq *freq);
 
@@ -1699,4 +1767,30 @@ void wiphy_rfkill_start_polling(struct w
  */
 void wiphy_rfkill_stop_polling(struct wiphy *wiphy);
 
+/**
+ * cfg80211_connected - notify cfg80211 that connection is established.
+ *
+ * @dev: network device
+ * @bssid: the BSSID of the AP
+ * @ie: association response IEs
+ * @ie_len: assoc response IEs length
+ * @gfp: allocation flags
+ *
+ * It should be called by the underlying drivers whenever connect() has
+ * succeeded.
+ */
+void cfg80211_connected(struct net_device *dev, const u8 *bssid,
+			u8 *ie, size_t ie_len, gfp_t gfp);
+
+/**
+ * cfg80211_connected - notify cfg80211 that connection was dropped
+ *
+ * @dev: network device
+ * @gfp: allocation flags
+ * @reason: reason code for the disconnection, set it to 0 when invalid.
+ *
+ */
+void cfg80211_disconnected(struct net_device *dev, gfp_t gfp, u16 reason);
+
+
 #endif /* __NET_CFG80211_H */
Index: iwm-2.6/net/wireless/Makefile
===================================================================
--- iwm-2.6.orig/net/wireless/Makefile	2009-06-22 18:42:44.000000000 +0200
+++ iwm-2.6/net/wireless/Makefile	2009-06-22 18:46:30.000000000 +0200
@@ -5,8 +5,8 @@ obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib8
 obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
 obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
 
-cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o ibss.o
+cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o ibss.o sme.o
 cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
-cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
+cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o wext-sme.o
 
 ccflags-y += -D__CHECK_ENDIAN__
Index: iwm-2.6/net/wireless/core.h
===================================================================
--- iwm-2.6.orig/net/wireless/core.h	2009-06-22 18:42:44.000000000 +0200
+++ iwm-2.6/net/wireless/core.h	2009-06-22 18:46:30.000000000 +0200
@@ -58,6 +58,8 @@ struct cfg80211_registered_device {
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
 	unsigned long suspend_at;
 
+	struct work_struct sme_sm;
+
 #ifdef CONFIG_CFG80211_DEBUGFS
 	/* Debugfs entries */
 	struct wiphy_debugfsdentries {
@@ -170,6 +172,15 @@ void cfg80211_clear_ibss(struct net_devi
 int cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, bool nowext);
 
+/* SME */
+void cfg80211_sme_work(struct work_struct *work);
+
+int cfg80211_connect(struct cfg80211_registered_device *rdev,
+		     struct net_device *dev,
+		     struct cfg80211_connect_params *connect);
+int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
+			struct net_device *dev, u16 reason);
+
 /* internal helpers */
 int cfg80211_validate_key_settings(struct key_params *params, int key_idx,
 				   const u8 *mac_addr);
Index: iwm-2.6/net/wireless/nl80211.c
===================================================================
--- iwm-2.6.orig/net/wireless/nl80211.c	2009-06-22 18:46:24.000000000 +0200
+++ iwm-2.6/net/wireless/nl80211.c	2009-06-22 18:46:30.000000000 +0200
@@ -347,6 +347,17 @@ static int nl80211_send_wiphy(struct sk_
 	CMD(join_ibss, JOIN_IBSS);
 
 #undef CMD
+
+	if (dev->ops->connect || dev->ops->auth) {
+		i++;
+		NLA_PUT_U32(msg, i, NL80211_CMD_CONNECT);
+	}
+
+	if (dev->ops->disconnect || dev->ops->deauth) {
+		i++;
+		NLA_PUT_U32(msg, i, NL80211_CMD_DISCONNECT);
+	}
+
 	nla_nest_end(msg, nl_cmds);
 
 	return genlmsg_end(msg, hdr);
@@ -3415,6 +3426,128 @@ unlock_rtnl:
 	return err;
 }
 
+static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	struct net_device *dev;
+	struct cfg80211_connect_params connect;
+	struct wiphy *wiphy;
+	int err;
+
+	memset(&connect, 0, sizeof(connect));
+
+	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_SSID] ||
+	    !nla_len(info->attrs[NL80211_ATTR_SSID]))
+		return -EINVAL;
+
+	rtnl_lock();
+
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		goto unlock_rtnl;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
+	wiphy = &drv->wiphy;
+
+	connect.bssid = NULL;
+	connect.channel = NULL;
+	connect.auth_type = NL80211_AUTHTYPE_OPEN_SYSTEM;
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		connect.bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	connect.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
+	connect.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
+
+	if (info->attrs[NL80211_ATTR_IE]) {
+		connect.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+		connect.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+	}
+
+	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
+		connect.channel =
+			ieee80211_get_channel(wiphy,
+			    nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
+		if (!connect.channel ||
+		    connect.channel->flags & IEEE80211_CHAN_DISABLED) {
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	if (info->attrs[NL80211_ATTR_AUTH_TYPE]) {
+		connect.auth_type =
+			nla_get_u32(info->attrs[NL80211_ATTR_AUTH_TYPE]);
+		if (!nl80211_valid_auth_type(connect.auth_type)) {
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	connect.control_port = info->attrs[NL80211_ATTR_CONTROL_PORT];
+
+	err = cfg80211_connect(drv, dev, &connect);
+
+out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+unlock_rtnl:
+	rtnl_unlock();
+	return err;
+}
+
+static int nl80211_disconnect(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	struct net_device *dev;
+	int err;
+	u16 reason;
+
+	if (!info->attrs[NL80211_ATTR_REASON_CODE])
+		reason = WLAN_REASON_DEAUTH_LEAVING;
+	else
+		reason = nla_get_u16(info->attrs[NL80211_ATTR_REASON_CODE]);
+
+	if (reason == 0)
+		return -EINVAL;
+
+	rtnl_lock();
+
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		goto unlock_rtnl;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
+	err = cfg80211_disconnect(drv, dev, reason);
+
+out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+unlock_rtnl:
+	rtnl_unlock();
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -3628,6 +3761,18 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_CONNECT,
+		.doit = nl80211_connect,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_DISCONNECT,
+		.doit = nl80211_disconnect,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
 	.name = "mlme",
@@ -3940,6 +4085,78 @@ void nl80211_send_assoc_timeout(struct c
 	nl80211_send_mlme_timeout(rdev, netdev, NL80211_CMD_ASSOCIATE, addr);
 }
 
+void nl80211_send_connected(struct cfg80211_registered_device *rdev,
+			    struct net_device *netdev, const u8 *bssid,
+			    const u8 *ie, size_t ie_len, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_CONNECT);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, bssid);
+	if (ie)
+		NLA_PUT(msg, NL80211_ATTR_IE, ie_len, ie);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+
+}
+
+void nl80211_send_disconnected(struct cfg80211_registered_device *rdev,
+			       struct net_device *netdev, gfp_t gfp, u16 reason)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_DISCONNECT);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	if (reason)
+		NLA_PUT_U16(msg, NL80211_ATTR_REASON_CODE, reason);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+
+}
+
 void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, const u8 *bssid,
 			     gfp_t gfp)
Index: iwm-2.6/net/wireless/sme.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ iwm-2.6/net/wireless/sme.c	2009-06-22 18:46:30.000000000 +0200
@@ -0,0 +1,241 @@
+/*
+ * SME code for cfg80211's connect emulation.
+ *
+ * Copyright 2009	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright (C) 2009   Intel Corporation. All rights reserved.
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/if_arp.h>
+#include <linux/workqueue.h>
+#include <net/cfg80211.h>
+#include <net/rtnetlink.h>
+#include "nl80211.h"
+
+void cfg80211_sme_work(struct work_struct *work)
+{
+	struct cfg80211_registered_device *drv =
+		container_of(work, struct cfg80211_registered_device, sme_sm);
+	struct wireless_dev *wdev;
+
+	rtnl_lock();
+	mutex_lock(&drv->devlist_mtx);
+
+	list_for_each_entry(wdev, &drv->netdev_list, list)
+		if (netif_running(wdev->netdev) &&
+		    wdev->sme_state == CFG80211_SME_ASSOC)
+			drv->ops->assoc(wdev->wiphy, wdev->netdev,
+					&wdev->assoc_req);
+
+	mutex_unlock(&drv->devlist_mtx);
+	rtnl_unlock();
+}
+
+void cfg80211_connected(struct net_device *dev, const u8 *bssid,
+			u8 *ie, size_t ie_len, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_bss *bss;
+#ifdef CONFIG_WIRELESS_EXT
+	union iwreq_data wrqu;
+#endif
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+		return;
+
+	if (WARN_ON(!wdev->ssid_len))
+		return;
+
+	if (memcmp(bssid, wdev->bssid, ETH_ALEN) == 0)
+		return;
+
+	bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
+			       wdev->ssid, wdev->ssid_len,
+			       WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+
+	if (WARN_ON(!bss))
+		return;
+
+	if (wdev->current_bss) {
+		cfg80211_unhold_bss(wdev->current_bss);
+		cfg80211_put_bss(wdev->current_bss);
+	}
+
+	cfg80211_hold_bss(bss);
+	wdev->current_bss = bss;
+	memcpy(wdev->bssid, bssid, ETH_ALEN);
+	wdev->sme_state = CFG80211_SME_CONNECTED;
+
+	nl80211_send_connected(wiphy_to_dev(wdev->wiphy), dev, bssid,
+			       ie, ie_len, gfp);
+
+#ifdef CONFIG_WIRELESS_EXT
+	memset(&wrqu, 0, sizeof(wrqu));
+	wrqu.data.length = ie_len;
+	wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, ie);
+
+	memset(&wrqu, 0, sizeof(wrqu));
+	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+	memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
+	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+#endif
+}
+EXPORT_SYMBOL(cfg80211_connected);
+
+void cfg80211_disconnected(struct net_device *dev, gfp_t gfp, u16 reason)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+#ifdef CONFIG_WIRELESS_EXT
+	union iwreq_data wrqu;
+#endif
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+		return;
+
+	if (WARN_ON(!wdev->ssid_len))
+		return;
+
+	if (wdev->current_bss) {
+		cfg80211_unhold_bss(wdev->current_bss);
+		cfg80211_put_bss(wdev->current_bss);
+	}
+
+	wdev->current_bss = NULL;
+	memset(wdev->bssid, 0, ETH_ALEN);
+	wdev->sme_state = CFG80211_SME_IDLE;
+
+	nl80211_send_disconnected(wiphy_to_dev(wdev->wiphy), dev, gfp, reason);
+
+#ifdef CONFIG_WIRELESS_EXT
+	memset(&wrqu, 0, sizeof(wrqu));
+	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+#endif
+}
+EXPORT_SYMBOL(cfg80211_disconnected);
+
+int cfg80211_connect(struct cfg80211_registered_device *rdev,
+		     struct net_device *dev,
+		     struct cfg80211_connect_params *connect)
+{
+	int err;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (wdev->sme_state != CFG80211_SME_IDLE)
+		return -EALREADY;
+
+#ifdef CONFIG_WIRELESS_EXT
+	wdev->wext.connect.channel = connect->channel;
+#endif
+
+	wdev->channel = connect->channel;
+
+	if (!rdev->ops->connect) {
+		struct wireless_dev *wdev = dev->ieee80211_ptr;
+		struct cfg80211_auth_request auth_req;
+		int err;
+
+		/*
+		 * We split the connect_params into an auth req
+		 * and an assoc req.
+		 */
+		memset(&auth_req, 0, sizeof(auth_req));
+		auth_req.chan = connect->channel;
+		auth_req.peer_addr = connect->bssid;
+		auth_req.ssid = connect->ssid;
+		auth_req.ssid_len = connect->ssid_len;
+		auth_req.auth_type = connect->auth_type;
+		auth_req.ie = connect->ie;
+		auth_req.ie_len = connect->ie_len;
+
+		/*
+		 * Here we cache the assoc request. It will be used
+		 * when the cfg80211 user will call cfg80211_authenticated()
+		 * letting us know that we can move forward and call the
+		 * assoc hook.
+		 */
+		memset(&wdev->assoc_req, 0, sizeof(wdev->assoc_req));
+		if (connect->channel)
+			wdev->assoc_req.chan = kmemdup(connect->channel,
+					       sizeof(struct ieee80211_channel),
+						       GFP_ATOMIC);
+		if (connect->bssid)
+			wdev->assoc_req.peer_addr = kmemdup(connect->bssid,
+							    ETH_ALEN,
+							    GFP_ATOMIC);
+		wdev->assoc_req.ssid = kmemdup(connect->ssid,
+					       connect->ssid_len,
+					       GFP_ATOMIC);
+		wdev->assoc_req.ssid_len = connect->ssid_len;
+		if (connect->ie)
+			wdev->assoc_req.ie = kmemdup(connect->ie,
+						     connect->ie_len,
+						     GFP_ATOMIC);
+		wdev->assoc_req.ie_len = connect->ie_len;
+		wdev->assoc_req.control_port = connect->control_port;
+
+		if (!rdev->ops->auth || !rdev->ops->assoc)
+			return -EOPNOTSUPP;
+
+		err = rdev->ops->auth(&rdev->wiphy, dev, &auth_req);
+		if (err)
+			return err;
+	} else {
+		err = rdev->ops->connect(&rdev->wiphy, dev, connect);
+
+		if (err)
+			return err;
+	}
+
+	wdev->sme_state = CFG80211_SME_AUTH;
+	memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
+	wdev->ssid_len = connect->ssid_len;
+
+	return 0;
+}
+
+int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
+			struct net_device *dev, u16 reason)
+{
+	int err;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (!rdev->ops->disconnect) {
+		struct cfg80211_deauth_request deauth;
+
+		if (!rdev->ops->deauth)
+			return -EOPNOTSUPP;
+
+		memset(&deauth, 0, sizeof(deauth));
+
+		deauth.peer_addr = wdev->bssid;
+		deauth.reason_code = reason;
+
+		err = rdev->ops->deauth(&rdev->wiphy, dev, &deauth);
+
+		if (err)
+			return err;
+	} else {
+		err = rdev->ops->disconnect(&rdev->wiphy, dev, reason);
+
+		if (err)
+			return err;
+	}
+
+	wdev->sme_state = CFG80211_SME_IDLE;
+
+	if (wdev->current_bss) {
+		cfg80211_unhold_bss(wdev->current_bss);
+		cfg80211_put_bss(wdev->current_bss);
+	}
+
+	wdev->current_bss = NULL;
+	wdev->ssid_len = 0;
+	memset(wdev->bssid, 0, ETH_ALEN);
+	kfree(wdev->assoc_req.chan);
+	kfree(wdev->assoc_req.peer_addr);
+	kfree(wdev->assoc_req.ssid);
+	kfree(wdev->assoc_req.ie);
+
+	return 0;
+}
Index: iwm-2.6/net/wireless/wext-sme.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ iwm-2.6/net/wireless/wext-sme.c	2009-06-22 18:46:30.000000000 +0200
@@ -0,0 +1,238 @@
+/*
+ * cfg80211 wext compat for managed mode.
+ *
+ * Copyright 2009	Johannes Berg <johannes@sipsolutions.net>
+ * Copyright (C) 2009   Intel Corporation. All rights reserved.
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/if_arp.h>
+#include <net/cfg80211.h>
+#include "nl80211.h"
+
+static int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
+				     struct wireless_dev *wdev)
+{
+	if (!netif_running(wdev->netdev))
+		return 0;
+
+	if (wdev->wext.connect.ssid_len != 0)
+		return cfg80211_connect(rdev, wdev->netdev,
+					&wdev->wext.connect);
+
+	return 0;
+}
+
+int cfg80211_mgd_wext_siwfreq(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_freq *freq, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct ieee80211_channel *chan;
+	int err;
+
+	/* call only for station! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+		return -EINVAL;
+
+	chan = cfg80211_wext_freq(wdev->wiphy, freq);
+	if (chan && IS_ERR(chan))
+		return PTR_ERR(chan);
+
+	if (chan && (chan->flags & IEEE80211_CHAN_DISABLED))
+		return -EINVAL;
+
+	if (wdev->wext.connect.channel == chan)
+		return 0;
+
+	if (wdev->sme_state != CFG80211_SME_IDLE) {
+		err = cfg80211_disconnect(wiphy_to_dev(wdev->wiphy),
+					  dev, WLAN_REASON_DEAUTH_LEAVING);
+		if (err)
+			return err;
+	}
+
+	wdev->wext.connect.channel = chan;
+
+	if (wdev->sme_state == CFG80211_SME_IDLE &&
+	    wdev->wext.connect.channel) {
+		/* SSID is not set, we just want to switch channel */
+		if (!rdev->ops->set_channel)
+			return -EOPNOTSUPP;
+
+		return rdev->ops->set_channel(wdev->wiphy, chan,
+					      NL80211_CHAN_NO_HT);
+	}
+
+	err = rdev->ops->set_channel(wdev->wiphy, chan,
+				     NL80211_CHAN_NO_HT);
+	if (err)
+		return err;
+
+	return cfg80211_mgd_wext_connect(wiphy_to_dev(wdev->wiphy), wdev);
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_siwfreq);
+
+int cfg80211_mgd_wext_giwfreq(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_freq *freq, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct ieee80211_channel *chan = NULL;
+
+	/* call only for station! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+		return -EINVAL;
+
+	if (wdev->current_bss)
+		chan = wdev->current_bss->channel;
+	else if (wdev->wext.connect.channel)
+		chan = wdev->wext.connect.channel;
+
+	if (chan) {
+		freq->m = chan->center_freq;
+		freq->e = 6;
+		return 0;
+	}
+
+	/* no channel if not joining */
+	return -EINVAL;
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_giwfreq);
+
+int cfg80211_mgd_wext_siwessid(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *data, char *ssid)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	size_t len = data->length;
+	int err;
+
+	/* call only for station! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+		return -EINVAL;
+
+	if (wdev->sme_state != CFG80211_SME_IDLE) {
+		err = cfg80211_disconnect(wiphy_to_dev(wdev->wiphy),
+					  dev, WLAN_REASON_DEAUTH_LEAVING);
+		if (err)
+			return err;
+	}
+
+	/* iwconfig uses nul termination in SSID.. */
+	if (len > 0 && ssid[len - 1] == '\0')
+		len--;
+
+	if (data->flags) {
+		wdev->wext.connect.ssid = wdev->ssid;
+		memcpy(wdev->wext.connect.ssid, ssid, len);
+		wdev->wext.connect.ssid_len = len;
+	} else
+		wdev->wext.connect.ssid_len = 0;
+
+	wdev->wext.connect.control_port = false;
+
+	return cfg80211_mgd_wext_connect(wiphy_to_dev(wdev->wiphy), wdev);
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_siwessid);
+
+int cfg80211_mgd_wext_giwessid(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *data, char *ssid)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	/* call only for station! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+		return -EINVAL;
+
+	data->flags = 0;
+
+	if (wdev->ssid_len) {
+		data->flags = 1;
+		data->length = wdev->ssid_len;
+		memcpy(ssid, wdev->ssid, data->length);
+	} else if (wdev->wext.connect.ssid && wdev->wext.connect.ssid_len) {
+		data->flags = 1;
+		data->length = wdev->wext.connect.ssid_len;
+		memcpy(ssid, wdev->wext.connect.ssid, data->length);
+	} else
+		data->flags = 0;
+
+	return 0;
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_giwessid);
+
+int cfg80211_mgd_wext_siwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *ap_addr, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	u8 *bssid = ap_addr->sa_data;
+	int err;
+
+	/* call only for station! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+		return -EINVAL;
+
+	if (ap_addr->sa_family != ARPHRD_ETHER)
+		return -EINVAL;
+
+	/* automatic mode */
+	if (is_zero_ether_addr(bssid) || is_broadcast_ether_addr(bssid))
+		bssid = NULL;
+
+	/* both automatic */
+	if (!bssid && !wdev->wext.connect.bssid)
+		return 0;
+
+	/* fixed already - and no change */
+	if (wdev->wext.connect.bssid && bssid &&
+	    compare_ether_addr(bssid, wdev->wext.connect.bssid) == 0)
+		return 0;
+
+	if (wdev->sme_state != CFG80211_SME_IDLE) {
+		err = cfg80211_disconnect(wiphy_to_dev(wdev->wiphy),
+					  dev, WLAN_REASON_DEAUTH_LEAVING);
+		if (err)
+			return err;
+	}
+
+	if (bssid) {
+		memcpy(wdev->wext.bssid, bssid, ETH_ALEN);
+		wdev->wext.connect.bssid = wdev->wext.bssid;
+	} else
+		wdev->wext.connect.bssid = NULL;
+
+	return cfg80211_mgd_wext_connect(wiphy_to_dev(wdev->wiphy), wdev);
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_siwap);
+
+int cfg80211_mgd_wext_giwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *ap_addr, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	/* call only for station! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+		return -EINVAL;
+
+	ap_addr->sa_family = ARPHRD_ETHER;
+
+	if (wdev->wext.connect.bssid) {
+		memcpy(ap_addr->sa_data, wdev->wext.connect.bssid, ETH_ALEN);
+		return 0;
+	}
+
+	memcpy(ap_addr->sa_data, wdev->bssid, ETH_ALEN);
+	return 0;
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_giwap);
Index: iwm-2.6/net/wireless/mlme.c
===================================================================
--- iwm-2.6.orig/net/wireless/mlme.c	2009-06-22 18:46:24.000000000 +0200
+++ iwm-2.6/net/wireless/mlme.c	2009-06-22 18:46:30.000000000 +0200
@@ -14,33 +14,90 @@
 
 void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len)
 {
-	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	u16 status_code;
+	struct ieee80211_mgmt *mgmt;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	mgmt = (struct ieee80211_mgmt *)buf;
+	status_code = le16_to_cpu(mgmt->u.auth.status_code);
+
 	nl80211_send_rx_auth(rdev, dev, buf, len);
+
+	if (status_code != WLAN_STATUS_SUCCESS)
+		wdev->sme_state = CFG80211_SME_IDLE;
+	else {
+		wdev->sme_state = CFG80211_SME_ASSOC;
+		schedule_work(&rdev->sme_sm);
+	}
 }
 EXPORT_SYMBOL(cfg80211_send_rx_auth);
 
 void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len)
 {
-	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	u16 status_code;
+	struct ieee80211_mgmt *mgmt;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	mgmt = (struct ieee80211_mgmt *)buf;
+	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
+
 	nl80211_send_rx_assoc(rdev, dev, buf, len);
+
+	if (status_code != WLAN_STATUS_SUCCESS)
+		wdev->sme_state = CFG80211_SME_AUTH;
+	else {
+		u8 *ie = mgmt->u.assoc_resp.variable;
+
+		wdev->sme_state = CFG80211_SME_CONNECTED;
+		cfg80211_connected(dev, mgmt->bssid,
+				   ie, len - (ie - (u8 *) mgmt),
+				   GFP_ATOMIC);
+	}
 }
 EXPORT_SYMBOL(cfg80211_send_rx_assoc);
 
 void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len)
 {
-	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
 	nl80211_send_deauth(rdev, dev, buf, len);
+
+	if (wdev->sme_state == CFG80211_SME_CONNECTED ||
+	    wdev->sme_state == CFG80211_SME_ASSOC) {
+		u16 reason_code;
+		struct ieee80211_mgmt *mgmt;
+
+		mgmt = (struct ieee80211_mgmt *)buf;
+		reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
+
+		cfg80211_disconnected(dev, GFP_ATOMIC, reason_code);
+	}
 }
 EXPORT_SYMBOL(cfg80211_send_deauth);
 
 void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len)
 {
-	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
 	nl80211_send_disassoc(rdev, dev, buf, len);
+
+	if (wdev->sme_state == CFG80211_SME_CONNECTED) {
+		u16 reason_code;
+		struct ieee80211_mgmt *mgmt;
+
+		mgmt = (struct ieee80211_mgmt *)buf;
+		reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
+
+		cfg80211_disconnected(dev, GFP_ATOMIC, reason_code);
+	}
 }
 EXPORT_SYMBOL(cfg80211_send_disassoc);
 
Index: iwm-2.6/net/wireless/core.c
===================================================================
--- iwm-2.6.orig/net/wireless/core.c	2009-06-22 18:46:24.000000000 +0200
+++ iwm-2.6/net/wireless/core.c	2009-06-22 18:46:30.000000000 +0200
@@ -321,6 +321,7 @@ struct wiphy *wiphy_new(const struct cfg
 	}
 
 	INIT_WORK(&drv->rfkill_sync, cfg80211_rfkill_sync_work);
+	INIT_WORK(&drv->sme_sm, cfg80211_sme_work);
 
 	/*
 	 * Initialize wiphy parameters to IEEE 802.11 MIB default values.
@@ -481,6 +482,8 @@ void wiphy_unregister(struct wiphy *wiph
 	/* unlock again before freeing */
 	mutex_unlock(&drv->mtx);
 
+	cancel_work_sync(&drv->sme_sm);
+
 	cfg80211_debugfs_drv_del(drv);
 
 	/* If this device got a regulatory hint tell core its
@@ -526,54 +529,77 @@ static int cfg80211_netdev_notifier_call
 					 void *ndev)
 {
 	struct net_device *dev = ndev;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev;
 
-	if (!dev->ieee80211_ptr)
+	if (!wdev)
 		return NOTIFY_DONE;
 
-	rdev = wiphy_to_dev(dev->ieee80211_ptr->wiphy);
+	rdev = wiphy_to_dev(wdev->wiphy);
 
-	WARN_ON(dev->ieee80211_ptr->iftype == NL80211_IFTYPE_UNSPECIFIED);
+	WARN_ON(wdev->iftype == NL80211_IFTYPE_UNSPECIFIED);
 
 	switch (state) {
 	case NETDEV_REGISTER:
 		mutex_lock(&rdev->devlist_mtx);
-		list_add(&dev->ieee80211_ptr->list, &rdev->netdev_list);
+		list_add(&wdev->list, &rdev->netdev_list);
 		if (sysfs_create_link(&dev->dev.kobj, &rdev->wiphy.dev.kobj,
 				      "phy80211")) {
 			printk(KERN_ERR "wireless: failed to add phy80211 "
 				"symlink to netdev!\n");
 		}
-		dev->ieee80211_ptr->netdev = dev;
+		wdev->netdev = dev;
+		wdev->sme_state = CFG80211_SME_IDLE;
+
 #ifdef CONFIG_WIRELESS_EXT
-		dev->ieee80211_ptr->wext.default_key = -1;
-		dev->ieee80211_ptr->wext.default_mgmt_key = -1;
+		wdev->wext.default_key = -1;
+		wdev->wext.default_mgmt_key = -1;
 #endif
 		mutex_unlock(&rdev->devlist_mtx);
 		break;
 	case NETDEV_GOING_DOWN:
-		if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC)
+		if (!wdev->ssid_len)
+			break;
+
+		switch (wdev->iftype) {
+		case NL80211_IFTYPE_ADHOC:
+			cfg80211_leave_ibss(rdev, dev, true);
+			break;
+		case NL80211_IFTYPE_STATION:
+			cfg80211_disconnect(rdev, dev,
+					    WLAN_REASON_DEAUTH_LEAVING);
 			break;
-		if (!dev->ieee80211_ptr->ssid_len)
+		default:
 			break;
-		cfg80211_leave_ibss(rdev, dev, true);
+		}
+
 		break;
 	case NETDEV_UP:
 #ifdef CONFIG_WIRELESS_EXT
-		if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC)
+		switch (wdev->iftype) {
+		case NL80211_IFTYPE_ADHOC:
+			if (wdev->wext.ibss.ssid_len &&
+			    cfg80211_join_ibss(rdev, dev, &wdev->wext.ibss))
+				return NOTIFY_STOP;
 			break;
-		if (!dev->ieee80211_ptr->wext.ibss.ssid_len)
+		case NL80211_IFTYPE_STATION:
+			if (wdev->wext.connect.ssid_len &&
+			    cfg80211_connect(rdev, dev, &wdev->wext.connect))
+				return NOTIFY_STOP;
 			break;
-		cfg80211_join_ibss(rdev, dev, &dev->ieee80211_ptr->wext.ibss);
-		break;
+		default:
+			break;
+		}
 #endif
+		break;
 	case NETDEV_UNREGISTER:
 		mutex_lock(&rdev->devlist_mtx);
-		if (!list_empty(&dev->ieee80211_ptr->list)) {
+		if (!list_empty(&wdev->list)) {
 			sysfs_remove_link(&dev->dev.kobj, "phy80211");
-			list_del_init(&dev->ieee80211_ptr->list);
+			list_del_init(&wdev->list);
 		}
 		mutex_unlock(&rdev->devlist_mtx);
+		wdev->sme_state = CFG80211_SME_IDLE;
 		break;
 	case NETDEV_PRE_UP:
 		if (rfkill_blocked(rdev->rfkill))
Index: iwm-2.6/net/wireless/nl80211.h
===================================================================
--- iwm-2.6.orig/net/wireless/nl80211.h	2009-06-22 18:42:44.000000000 +0200
+++ iwm-2.6/net/wireless/nl80211.h	2009-06-22 18:46:30.000000000 +0200
@@ -31,6 +31,13 @@ extern void nl80211_send_auth_timeout(st
 extern void nl80211_send_assoc_timeout(struct cfg80211_registered_device *rdev,
 				       struct net_device *netdev,
 				       const u8 *addr);
+void nl80211_send_connected(struct cfg80211_registered_device *rdev,
+			    struct net_device *netdev, const u8 *bssid,
+			    const u8 *ie, size_t ie_len, gfp_t gfp);
+void nl80211_send_disconnected(struct cfg80211_registered_device *rdev,
+			       struct net_device *netdev, gfp_t gfp,
+			       u16 reason);
+
 extern void
 nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 			    struct net_device *netdev, const u8 *addr,
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
