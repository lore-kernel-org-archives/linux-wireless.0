Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35384 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbZFXMJe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 08:09:34 -0400
Message-Id: <20090624120808.469913150@sipsolutions.net>
References: <20090624120745.239294066@sipsolutions.net>
Date: Wed, 24 Jun 2009 14:07:46 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Samuel Ortiz <samuel.ortiz@intel.com>
Subject: [RFC 01/11] cfg80211: connect/disconnect API
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

This patch introduces the cfg80211 connect/disconnect API.
The goal here is to run the AUTH and ASSOC steps in one call.
This is needed for some fullmac cards that run both steps
directly from the target, after the host driver sends a
connect command.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: * everything changed/split up differently

 include/linux/nl80211.h |   32 +++++
 include/net/cfg80211.h  |  100 ++++++++++++++++++
 net/wireless/Makefile   |    2 
 net/wireless/core.c     |   16 ++
 net/wireless/core.h     |    7 +
 net/wireless/nl80211.c  |  264 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |   11 ++
 net/wireless/sme.c      |  206 +++++++++++++++++++++++++++++++++++++
 8 files changed, 633 insertions(+), 5 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2009-06-24 13:53:14.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2009-06-24 13:54:05.000000000 +0200
@@ -242,6 +242,22 @@
  * @NL80211_CMD_LEAVE_IBSS: Leave the IBSS -- no special arguments, the IBSS is
  *	determined by the network interface.
  *
+ * @NL80211_CMD_CONNECT: connection request and notification; this command
+ *	requests to connect to a specified network but without separating
+ *	auth and assoc steps. For this, you need to specify the SSID in a
+ *	%NL80211_ATTR_SSID attribute, and can optionally specify the association
+ *	IEs in %NL80211_ATTR_IE, %NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_MAC,
+ *	%NL80211_ATTR_WIPHY_FREQ and %NL80211_ATTR_CONTROL_PORT.
+ *	It is also sent as an event, with the BSSID and response IEs when the
+ *	connection is established or failed to be established. This can be
+ *	determined by the STATUS_CODE attribute.
+ * @NL80211_CMD_ROAM: request that the card roam (currently not implemented),
+ *	sent as an event when the card/driver roamed by itself.
+ * @NL80211_CMD_DISCONNECT: drop a given connection; also used to notify
+ *	userspace that a connection was dropped by the AP or due to other
+ *	reasons, for this the %NL80211_ATTR_DISCONNECTED_BY_AP and
+ *	%NL80211_ATTR_REASON_CODE attributes are used.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -310,6 +326,10 @@ enum nl80211_commands {
 	NL80211_CMD_JOIN_IBSS,
 	NL80211_CMD_LEAVE_IBSS,
 
+	NL80211_CMD_CONNECT,
+	NL80211_CMD_ROAM,
+	NL80211_CMD_DISCONNECT,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -511,6 +531,14 @@ enum nl80211_commands {
  *	authorized by user space. Otherwise, port is marked authorized by
  *	default in station mode.
  *
+ * @NL80211_ATTR_DISCONNECTED_BY_AP: A flag indicating that the DISCONNECT
+ *	event was due to the AP disconnecting the station, and not due to
+ *	a local disconnect request.
+ * @NL80211_ATTR_STATUS_CODE: StatusCode for the %NL80211_CMD_CONNECT
+ *	event (u16)
+ * @NL80211_ATTR_PRIVACY: Flag attribute, used with connect(), indicating
+ *	that protected APs should be used.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -618,6 +646,10 @@ enum nl80211_attrs {
 	NL80211_ATTR_STA_FLAGS2,
 
 	NL80211_ATTR_CONTROL_PORT,
+	NL80211_ATTR_PRIVACY,
+
+	NL80211_ATTR_DISCONNECTED_BY_AP,
+	NL80211_ATTR_STATUS_CODE,
 
 	/* add attributes here, update the policy in nl80211.c */
 
--- wireless-testing.orig/include/net/cfg80211.h	2009-06-24 13:54:05.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-06-24 13:54:05.000000000 +0200
@@ -738,6 +738,39 @@ struct cfg80211_ibss_params {
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
+ * @privacy: indicates whether privacy-enabled APs should be used
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
+	bool privacy;
+};
+
+/**
  * enum wiphy_params_flags - set_wiphy_params bitfield values
  * WIPHY_PARAM_RETRY_SHORT: wiphy->retry_short has changed
  * WIPHY_PARAM_RETRY_LONG: wiphy->retry_long has changed
@@ -841,6 +874,12 @@ enum tx_power_setting {
  * @deauth: Request to deauthenticate from the specified peer
  * @disassoc: Request to disassociate from the specified peer
  *
+ * @connect: Connect to the ESS with the specified parameters. When connected,
+ *	call cfg80211_connect_result() with status code %WLAN_STATUS_SUCCESS.
+ *	If the connection fails for some reason, call cfg80211_connect_result()
+ *	with the status from the AP.
+ * @disconnect: Disconnect from the BSS/ESS.
+ *
  * @join_ibss: Join the specified IBSS (or create if necessary). Once done, call
  *	cfg80211_ibss_joined(), also call that function when changing BSSID due
  *	to a merge.
@@ -944,6 +983,11 @@ struct cfg80211_ops {
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
@@ -1168,10 +1212,15 @@ struct wireless_dev {
 	struct list_head list;
 	struct net_device *netdev;
 
-	/* currently used for IBSS - might be rearranged in the future */
+	/* currently used for IBSS and SME - might be rearranged later */
 	struct cfg80211_bss *current_bss;
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ssid_len;
+	enum {
+		CFG80211_SME_IDLE,
+		CFG80211_SME_CONNECTING, /* ->connect called */
+		CFG80211_SME_CONNECTED,
+	} sme_state;
 
 #ifdef CONFIG_WIRELESS_EXT
 	/* wext data */
@@ -1705,4 +1754,53 @@ void wiphy_rfkill_start_polling(struct w
  */
 void wiphy_rfkill_stop_polling(struct wiphy *wiphy);
 
+/**
+ * cfg80211_connect_result - notify cfg80211 of connection result
+ *
+ * @dev: network device
+ * @bssid: the BSSID of the AP
+ * @ie: association response IEs (may be %NULL)
+ * @ie_len: assoc response IEs length
+ * @status: status code, 0 for successful connection, use
+ *	%WLAN_STATUS_UNSPECIFIED_FAILURE if your device cannot give you
+ *	the real status code for failures.
+ * @gfp: allocation flags
+ *
+ * It should be called by the underlying driver whenever connect() has
+ * succeeded.
+ */
+void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
+			     u8 *ie, size_t ie_len, u16 status, gfp_t gfp);
+
+/**
+ * cfg80211_roamed - notify cfg80211 of roaming
+ *
+ * @dev: network device
+ * @bssid: the BSSID of the new AP
+ * @ie: association response IEs (may be %NULL)
+ * @ie_len: assoc response IEs length
+ * @gfp: allocation flags
+ *
+ * It should be called by the underlying driver whenever it roamed
+ * from one AP to another while connected.
+ */
+void cfg80211_roamed(struct net_device *dev, const u8 *bssid,
+		     u8 *ie, size_t ie_len, gfp_t gfp);
+
+/**
+ * cfg80211_disconnected - notify cfg80211 that connection was dropped
+ *
+ * @dev: network device
+ * @ie: information elements of the deauth/disassoc frame (may be %NULL)
+ * @ie_len: length of IEs
+ * @reason: reason code for the disconnection, set it to 0 if unknown
+ * @gfp: allocation flags
+ *
+ * After it calls this function, the driver should enter an idle state
+ * and not try to connect to any AP any more.
+ */
+void cfg80211_disconnected(struct net_device *dev, u16 reason,
+			   u8 *ie, size_t ie_len, gfp_t gfp);
+
+
 #endif /* __NET_CFG80211_H */
--- wireless-testing.orig/net/wireless/Makefile	2009-06-24 13:53:14.000000000 +0200
+++ wireless-testing/net/wireless/Makefile	2009-06-24 13:54:05.000000000 +0200
@@ -5,7 +5,7 @@ obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib8
 obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
 obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
 
-cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o ibss.o
+cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o ibss.o sme.o
 cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
 
--- wireless-testing.orig/net/wireless/core.h	2009-06-24 13:53:14.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-06-24 13:54:05.000000000 +0200
@@ -170,6 +170,13 @@ void cfg80211_clear_ibss(struct net_devi
 int cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, bool nowext);
 
+/* SME */
+int cfg80211_connect(struct cfg80211_registered_device *rdev,
+		     struct net_device *dev,
+		     struct cfg80211_connect_params *connect);
+int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
+			struct net_device *dev, u16 reason);
+
 /* internal helpers */
 int cfg80211_validate_key_settings(struct key_params *params, int key_idx,
 				   const u8 *mac_addr);
--- wireless-testing.orig/net/wireless/nl80211.c	2009-06-24 13:54:04.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-06-24 13:54:05.000000000 +0200
@@ -128,6 +128,7 @@ static struct nla_policy nl80211_policy[
 		.len = sizeof(struct nl80211_sta_flag_update),
 	},
 	[NL80211_ATTR_CONTROL_PORT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_PRIVACY] = { .type = NLA_FLAG },
 };
 
 /* IE validation */
@@ -347,6 +348,17 @@ static int nl80211_send_wiphy(struct sk_
 	CMD(join_ibss, JOIN_IBSS);
 
 #undef CMD
+
+	if (dev->ops->connect) {
+		i++;
+		NLA_PUT_U32(msg, i, NL80211_CMD_CONNECT);
+	}
+
+	if (dev->ops->disconnect) {
+		i++;
+		NLA_PUT_U32(msg, i, NL80211_CMD_DISCONNECT);
+	}
+
 	nla_nest_end(msg, nl_cmds);
 
 	return genlmsg_end(msg, hdr);
@@ -3415,6 +3427,129 @@ unlock_rtnl:
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
+	connect.privacy = info->attrs[NL80211_ATTR_PRIVACY];
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
@@ -3628,6 +3763,18 @@ static struct genl_ops nl80211_ops[] = {
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
@@ -3946,6 +4093,123 @@ void nl80211_send_assoc_timeout(struct c
 				  addr, gfp);
 }
 
+void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
+				 struct net_device *netdev, const u8 *bssid,
+				 const u8 *ie, size_t ie_len, u16 status,
+				 gfp_t gfp)
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
+	if (bssid)
+		NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, bssid);
+	NLA_PUT_U16(msg, NL80211_ATTR_STATUS_CODE, status);
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
+void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
+			 struct net_device *netdev, const u8 *bssid,
+			 const u8 *ie, size_t ie_len, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_ROAM);
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
+			       struct net_device *netdev, u16 reason,
+			       u8 *ie, size_t ie_len, bool from_ap, gfp_t gfp)
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
+	if (from_ap && reason)
+		NLA_PUT_U16(msg, NL80211_ATTR_REASON_CODE, reason);
+	if (from_ap)
+		NLA_PUT_FLAG(msg, NL80211_ATTR_DISCONNECTED_BY_AP);
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
 void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, const u8 *bssid,
 			     gfp_t gfp)
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/wireless/sme.c	2009-06-24 13:54:05.000000000 +0200
@@ -0,0 +1,206 @@
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
+
+void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
+			     u8 *ie, size_t ie_len, u16 status, gfp_t gfp)
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
+	if (WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTING))
+		return;
+
+	if (wdev->current_bss) {
+		cfg80211_unhold_bss(wdev->current_bss);
+		cfg80211_put_bss(wdev->current_bss);
+		wdev->current_bss = NULL;
+	}
+
+	if (status == WLAN_STATUS_SUCCESS) {
+		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
+				       wdev->ssid, wdev->ssid_len,
+				       WLAN_CAPABILITY_ESS,
+				       WLAN_CAPABILITY_ESS);
+
+		if (WARN_ON(!bss))
+			return;
+
+		cfg80211_hold_bss(bss);
+		wdev->current_bss = bss;
+
+		wdev->sme_state = CFG80211_SME_CONNECTED;
+	} else {
+		wdev->sme_state = CFG80211_SME_IDLE;
+	}
+
+	nl80211_send_connect_result(wiphy_to_dev(wdev->wiphy), dev, bssid,
+				    ie, ie_len, status, gfp);
+
+#ifdef CONFIG_WIRELESS_EXT
+	if (ie && status == WLAN_STATUS_SUCCESS) {
+		memset(&wrqu, 0, sizeof(wrqu));
+		wrqu.data.length = ie_len;
+		wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, ie);
+	}
+
+	memset(&wrqu, 0, sizeof(wrqu));
+	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+	if (bssid)
+		memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
+	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+#endif
+}
+EXPORT_SYMBOL(cfg80211_connect_result);
+
+void cfg80211_roamed(struct net_device *dev, const u8 *bssid,
+		     u8 *ie, size_t ie_len, gfp_t gfp)
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
+	if (WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTED))
+		return;
+
+	/* internal error -- how did we get to CONNECTED w/o BSS? */
+	if (WARN_ON(!wdev->current_bss)) {
+		return;
+	}
+
+	cfg80211_unhold_bss(wdev->current_bss);
+	cfg80211_put_bss(wdev->current_bss);
+	wdev->current_bss = NULL;
+
+	bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
+			       wdev->ssid, wdev->ssid_len,
+			       WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
+
+	if (WARN_ON(!bss))
+		return;
+
+	cfg80211_hold_bss(bss);
+	wdev->current_bss = bss;
+
+	nl80211_send_roamed(wiphy_to_dev(wdev->wiphy), dev, bssid,
+			    ie, ie_len, gfp);
+
+#ifdef CONFIG_WIRELESS_EXT
+	if (ie) {
+		memset(&wrqu, 0, sizeof(wrqu));
+		wrqu.data.length = ie_len;
+		wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, ie);
+	}
+
+	memset(&wrqu, 0, sizeof(wrqu));
+	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+	memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
+	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+#endif
+}
+EXPORT_SYMBOL(cfg80211_roamed);
+
+static void __cfg80211_disconnected(struct net_device *dev, gfp_t gfp,
+				    u8 *ie, size_t ie_len, u16 reason,
+				    bool from_ap)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+#ifdef CONFIG_WIRELESS_EXT
+	union iwreq_data wrqu;
+#endif
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+		return;
+
+	if (WARN_ON(wdev->sme_state != CFG80211_SME_CONNECTED))
+		return;
+
+	if (wdev->current_bss) {
+		cfg80211_unhold_bss(wdev->current_bss);
+		cfg80211_put_bss(wdev->current_bss);
+	}
+
+	wdev->current_bss = NULL;
+	wdev->sme_state = CFG80211_SME_IDLE;
+
+	nl80211_send_disconnected(wiphy_to_dev(wdev->wiphy), dev,
+				  reason, ie, ie_len, from_ap, gfp);
+
+#ifdef CONFIG_WIRELESS_EXT
+	memset(&wrqu, 0, sizeof(wrqu));
+	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+#endif
+}
+
+void cfg80211_disconnected(struct net_device *dev, u16 reason,
+			   u8 *ie, size_t ie_len, gfp_t gfp)
+{
+	__cfg80211_disconnected(dev, reason, ie, ie_len, true, gfp);
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
+	if (!rdev->ops->connect) {
+		return -EOPNOTSUPP;
+	} else {
+		err = rdev->ops->connect(&rdev->wiphy, dev, connect);
+		if (err)
+			return err;
+		wdev->sme_state = CFG80211_SME_CONNECTING;
+	}
+
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
+
+	if (!rdev->ops->disconnect) {
+		return -EOPNOTSUPP;
+	} else {
+		err = rdev->ops->disconnect(&rdev->wiphy, dev, reason);
+		if (err)
+			return err;
+	}
+
+	__cfg80211_disconnected(dev, 0, NULL, 0, false, GFP_KERNEL);
+
+	return 0;
+}
--- wireless-testing.orig/net/wireless/core.c	2009-06-24 13:54:04.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-06-24 13:54:05.000000000 +0200
@@ -546,6 +546,7 @@ static int cfg80211_netdev_notifier_call
 				"symlink to netdev!\n");
 		}
 		wdev->netdev = dev;
+		wdev->sme_state = CFG80211_SME_IDLE;
 #ifdef CONFIG_WIRELESS_EXT
 		wdev->wext.default_key = -1;
 		wdev->wext.default_mgmt_key = -1;
@@ -553,11 +554,20 @@ static int cfg80211_netdev_notifier_call
 		mutex_unlock(&rdev->devlist_mtx);
 		break;
 	case NETDEV_GOING_DOWN:
-		if (wdev->iftype != NL80211_IFTYPE_ADHOC)
-			break;
 		if (!wdev->ssid_len)
 			break;
-		cfg80211_leave_ibss(rdev, dev, true);
+
+		switch (wdev->iftype) {
+		case NL80211_IFTYPE_ADHOC:
+			cfg80211_leave_ibss(rdev, dev, true);
+			break;
+		case NL80211_IFTYPE_STATION:
+			cfg80211_disconnect(rdev, dev,
+					    WLAN_REASON_DEAUTH_LEAVING);
+			break;
+		default:
+			break;
+		}
 		break;
 	case NETDEV_UP:
 #ifdef CONFIG_WIRELESS_EXT
--- wireless-testing.orig/net/wireless/nl80211.h	2009-06-24 13:54:04.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.h	2009-06-24 13:54:05.000000000 +0200
@@ -31,6 +31,17 @@ void nl80211_send_auth_timeout(struct cf
 void nl80211_send_assoc_timeout(struct cfg80211_registered_device *rdev,
 				struct net_device *netdev,
 				const u8 *addr, gfp_t gfp);
+void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
+				 struct net_device *netdev, const u8 *bssid,
+				 const u8 *ie, size_t ie_len, u16 status,
+				 gfp_t gfp);
+void nl80211_send_roamed(struct cfg80211_registered_device *rdev,
+			 struct net_device *netdev, const u8 *bssid,
+			 const u8 *ie, size_t ie_len, gfp_t gfp);
+void nl80211_send_disconnected(struct cfg80211_registered_device *rdev,
+			       struct net_device *netdev, u16 reason,
+			       u8 *ie, size_t ie_len, bool from_ap, gfp_t gfp);
+
 void
 nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 			    struct net_device *netdev, const u8 *addr,

-- 

