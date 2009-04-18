Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbZDRXhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 19:37:33 -0400
Subject: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Alina Friedrichsen <x-alina@gmx.net>
In-Reply-To: <1240094996.21583.1.camel@johannes.local> (sfid-20090419_005015_625875_1781AFCD)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD)
Content-Type: text/plain
Date: Sun, 19 Apr 2009 01:37:25 +0200
Message-Id: <1240097845.25826.1.camel@johannes.local> (sfid-20090419_013739_539685_325ECC4E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds IBSS API along with (preliminary) wext handlers.
The wext handlers can only do IBSS so you need to call them
from your own wext handlers if the mode is IBSS.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/nl80211.h    |   11 +
 include/net/cfg80211.h     |   68 +++++++++
 include/net/wireless.h     |   14 ++
 net/wireless/Makefile      |    2 
 net/wireless/core.c        |   16 ++
 net/wireless/core.h        |    8 +
 net/wireless/ibss.c        |  308 +++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.c     |  180 ++++++++++++++++++++++++--
 net/wireless/nl80211.h     |    4 
 net/wireless/wext-compat.c |   30 ++++
 10 files changed, 628 insertions(+), 13 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2009-04-18 23:50:46.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2009-04-19 00:35:58.000000000 +0200
@@ -223,6 +223,14 @@
  *	%NL80211_ATTR_KEY_SEQ to indicate the TSC value of the frame; this
  *	event matches with MLME-MICHAELMICFAILURE.indication() primitive
  *
+ * @NL80211_CMD_JOIN_IBSS: Join a new IBSS -- given at least an SSID, and
+ *	optionally a MAC (as BSSID) and FREQ attribute if those should be
+ *	fixed rather than automatically determined. Can only be executed
+ *	on a network interface that is UP, and fixed BSSID/FREQ may be
+ *	rejected.
+ * @NL80211_CMD_LEAVE_IBSS: Leave the IBSS -- no special arguments, the IBSS is
+ *	determined by the network interface.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -288,6 +296,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_REG_BEACON_HINT,
 
+	NL80211_CMD_JOIN_IBSS,
+	NL80211_CMD_LEAVE_IBSS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
--- wireless-testing.orig/include/net/cfg80211.h	2009-04-18 23:50:46.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-04-19 00:35:58.000000000 +0200
@@ -658,6 +658,27 @@ struct cfg80211_disassoc_request {
 };
 
 /**
+ * struct cfg80211_ibss_params - IBSS parameters
+ *
+ * This structure defines the IBSS parameters for the join_ibss()
+ * method.
+ *
+ * @ssid: The SSID, will always be non-null.
+ * @ssid_len: The length of the SSID, will always be non-zero.
+ * @bssid: Fixed BSSID requested, may be %NULL.
+ * @channel: Fixed channel requested, may be %NULL.
+ * @ie: information element(s) to include in the beacon
+ * @ie_len: length of that
+ */
+struct cfg80211_ibss_params {
+	u8 *ssid;
+	u8 *bssid;
+	struct ieee80211_channel *channel;
+	u8 *ie;
+	u8 ssid_len, ie_len;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -732,6 +753,11 @@ struct cfg80211_disassoc_request {
  * @assoc: Request to (re)associate with the specified peer
  * @deauth: Request to deauthenticate from the specified peer
  * @disassoc: Request to disassociate from the specified peer
+ *
+ * @join_ibss: Join the specified IBSS (or create if necessary). Once done, call
+ *	cfg80211_ibss_joined(), also call that function when changing BSSID due
+ *	to a merge.
+ * @leave_ibss: Leave the IBSS.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy);
@@ -817,6 +843,10 @@ struct cfg80211_ops {
 			  struct cfg80211_deauth_request *req);
 	int	(*disassoc)(struct wiphy *wiphy, struct net_device *dev,
 			    struct cfg80211_disassoc_request *req);
+
+	int	(*join_ibss)(struct wiphy *wiphy, struct net_device *dev,
+			     struct cfg80211_ibss_params *params);
+	int	(*leave_ibss)(struct wiphy *wiphy, struct net_device *dev);
 };
 
 /* temporary wext handlers */
@@ -836,6 +866,28 @@ int cfg80211_wext_giwscan(struct net_dev
 int cfg80211_wext_giwrange(struct net_device *dev,
 			   struct iw_request_info *info,
 			   struct iw_point *data, char *extra);
+int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_freq *freq, char *extra);
+int cfg80211_ibss_wext_giwfreq(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_freq *freq, char *extra);
+int cfg80211_ibss_wext_siwessid(struct net_device *dev,
+				struct iw_request_info *info,
+				struct iw_point *data, char *ssid);
+int cfg80211_ibss_wext_giwessid(struct net_device *dev,
+				struct iw_request_info *info,
+				struct iw_point *data, char *ssid);
+int cfg80211_ibss_wext_siwap(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct sockaddr *ap_addr, char *extra);
+int cfg80211_ibss_wext_giwap(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct sockaddr *ap_addr, char *extra);
+
+/* wext helper for now (to be removed) */
+struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
+					     struct iw_freq *freq);
 
 /**
  * cfg80211_scan_done - notify that scan finished
@@ -981,4 +1033,20 @@ void cfg80211_michael_mic_failure(struct
 				  enum nl80211_key_type key_type, int key_id,
 				  const u8 *tsc);
 
+/**
+ * cfg80211_ibss_joined - notify cfg80211 that device joined an IBSS
+ *
+ * @dev: network device
+ * @bssid: the BSSID of the IBSS joined
+ * @gfp: allocation flags
+ *
+ * This function notifies cfg80211 that the device joined an IBSS or
+ * switched to a different BSSID. Before this function can be called,
+ * either a beacon has to have been received from the IBSS, or one of
+ * the cfg80211_inform_bss{,_frame} functions must have been called
+ * with the locally generated beacon -- this guarantees that there is
+ * always a scan result for this IBSS. cfg80211 will handle the rest.
+ */
+void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp);
+
 #endif /* __NET_CFG80211_H */
--- wireless-testing.orig/net/wireless/nl80211.c	2009-04-18 23:50:46.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-04-19 00:35:58.000000000 +0200
@@ -322,6 +322,7 @@ static int nl80211_send_wiphy(struct sk_
 	CMD(assoc, ASSOCIATE);
 	CMD(deauth, DEAUTHENTICATE);
 	CMD(disassoc, DISASSOCIATE);
+	CMD(join_ibss, JOIN_IBSS);
 
 #undef CMD
 	nla_nest_end(msg, nl_cmds);
@@ -665,7 +666,7 @@ static int nl80211_set_interface(struct 
 	struct cfg80211_registered_device *drv;
 	struct vif_params params;
 	int err, ifindex;
-	enum nl80211_iftype type;
+	enum nl80211_iftype otype, ntype;
 	struct net_device *dev;
 	u32 _flags, *flags = NULL;
 	bool change = false;
@@ -679,30 +680,27 @@ static int nl80211_set_interface(struct 
 		goto unlock_rtnl;
 
 	ifindex = dev->ifindex;
-	type = dev->ieee80211_ptr->iftype;
+	otype = ntype = dev->ieee80211_ptr->iftype;
 	dev_put(dev);
 
 	if (info->attrs[NL80211_ATTR_IFTYPE]) {
-		enum nl80211_iftype ntype;
-
 		ntype = nla_get_u32(info->attrs[NL80211_ATTR_IFTYPE]);
-		if (type != ntype)
+		if (otype != ntype)
 			change = true;
-		type = ntype;
-		if (type > NL80211_IFTYPE_MAX) {
+		if (ntype > NL80211_IFTYPE_MAX) {
 			err = -EINVAL;
 			goto unlock;
 		}
 	}
 
 	if (!drv->ops->change_virtual_intf ||
-	    !(drv->wiphy.interface_modes & (1 << type))) {
+	    !(drv->wiphy.interface_modes & (1 << ntype))) {
 		err = -EOPNOTSUPP;
 		goto unlock;
 	}
 
 	if (info->attrs[NL80211_ATTR_MESH_ID]) {
-		if (type != NL80211_IFTYPE_MESH_POINT) {
+		if (ntype != NL80211_IFTYPE_MESH_POINT) {
 			err = -EINVAL;
 			goto unlock;
 		}
@@ -712,7 +710,7 @@ static int nl80211_set_interface(struct 
 	}
 
 	if (info->attrs[NL80211_ATTR_MNTR_FLAGS]) {
-		if (type != NL80211_IFTYPE_MONITOR) {
+		if (ntype != NL80211_IFTYPE_MONITOR) {
 			err = -EINVAL;
 			goto unlock;
 		}
@@ -727,12 +725,17 @@ static int nl80211_set_interface(struct 
 
 	if (change)
 		err = drv->ops->change_virtual_intf(&drv->wiphy, ifindex,
-						    type, flags, &params);
+						    ntype, flags, &params);
 	else
 		err = 0;
 
 	dev = __dev_get_by_index(&init_net, ifindex);
-	WARN_ON(!dev || (!err && dev->ieee80211_ptr->iftype != type));
+	WARN_ON(!dev || (!err && dev->ieee80211_ptr->iftype != ntype));
+
+	if (dev && !err && (ntype != otype)) {
+		if (otype == NL80211_IFTYPE_ADHOC)
+			cfg80211_clear_ibss(dev);
+	}
 
  unlock:
 	cfg80211_put_dev(drv);
@@ -3049,6 +3052,113 @@ unlock_rtnl:
 	return err;
 }
 
+static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	struct net_device *dev;
+	struct cfg80211_ibss_params params;
+	struct wiphy *wiphy;
+	int err;
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
+	if (!drv->ops->join_ibss) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC) {
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
+	memset(&params, 0, sizeof(params));
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		params.bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	params.ssid = nla_data(info->attrs[NL80211_ATTR_SSID]);
+	params.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
+
+	if (info->attrs[NL80211_ATTR_IE]) {
+		params.ie = nla_data(info->attrs[NL80211_ATTR_IE]);
+		params.ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+	}
+
+	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
+		params.channel = ieee80211_get_channel(
+			wiphy,
+			nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]));
+		if (!params.channel ||
+		    params.channel->flags & IEEE80211_CHAN_NO_IBSS) {
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	err = cfg80211_join_ibss(drv, dev, &params);
+
+out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+unlock_rtnl:
+	rtnl_unlock();
+	return err;
+}
+
+static int nl80211_leave_ibss(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	struct net_device *dev;
+	int err;
+
+	rtnl_lock();
+
+	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
+	if (err)
+		goto unlock_rtnl;
+
+	if (!drv->ops->leave_ibss) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (!netif_running(dev)) {
+		err = -ENETDOWN;
+		goto out;
+	}
+
+	err = cfg80211_leave_ibss(drv, dev);
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
@@ -3250,6 +3360,18 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_JOIN_IBSS,
+		.doit = nl80211_join_ibss,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_LEAVE_IBSS,
+		.doit = nl80211_leave_ibss,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
 	.name = "mlme",
@@ -3463,6 +3585,40 @@ void nl80211_send_disassoc(struct cfg802
 				NL80211_CMD_DISASSOCIATE);
 }
 
+void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
+			     struct net_device *netdev, const u8 *bssid,
+			     gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_JOIN_IBSS);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, bssid);
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
+}
+
 void nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,
 				 struct net_device *netdev, const u8 *addr,
 				 enum nl80211_key_type key_type, int key_id,
--- wireless-testing.orig/net/wireless/core.c	2009-04-18 23:50:46.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-04-19 01:13:45.000000000 +0200
@@ -450,6 +450,22 @@ static int cfg80211_netdev_notifier_call
 		dev->ieee80211_ptr->netdev = dev;
 		mutex_unlock(&rdev->devlist_mtx);
 		break;
+	case NETDEV_GOING_DOWN:
+		if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC)
+			break;
+		if (!dev->ieee80211_ptr->ssid_len)
+			break;
+		cfg80211_leave_ibss(rdev, dev);
+		break;
+	case NETDEV_UP:
+#ifdef CONFIG_WIRELESS_EXT
+		if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC)
+			break;
+		if (!dev->ieee80211_ptr->wext.ssid_len)
+			break;
+		cfg80211_join_ibss(rdev, dev, &dev->ieee80211_ptr->wext);
+		break;
+#endif
 	case NETDEV_UNREGISTER:
 		mutex_lock(&rdev->devlist_mtx);
 		if (!list_empty(&dev->ieee80211_ptr->list)) {
--- wireless-testing.orig/net/wireless/Makefile	2009-04-18 23:50:46.000000000 +0200
+++ wireless-testing/net/wireless/Makefile	2009-04-18 23:50:47.000000000 +0200
@@ -5,7 +5,7 @@ obj-$(CONFIG_LIB80211_CRYPT_WEP) += lib8
 obj-$(CONFIG_LIB80211_CRYPT_CCMP) += lib80211_crypt_ccmp.o
 obj-$(CONFIG_LIB80211_CRYPT_TKIP) += lib80211_crypt_tkip.o
 
-cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o
+cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o mlme.o ibss.o
 cfg80211-$(CONFIG_WIRELESS_EXT) += wext-compat.o
 
 ccflags-y += -D__CHECK_ENDIAN__
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ wireless-testing/net/wireless/ibss.c	2009-04-19 00:34:16.000000000 +0200
@@ -0,0 +1,308 @@
+/*
+ * Some IBSS support code for cfg80211.
+ *
+ * Copyright 2009	Johannes Berg <johannes@sipsolutions.net>
+ */
+
+#include <linux/etherdevice.h>
+#include <linux/if_arp.h>
+#include <net/cfg80211.h>
+#include <net/wireless.h>
+#include "nl80211.h"
+
+
+void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_bss *bss;
+#ifdef CONFIG_WIRELESS_EXT
+	union iwreq_data wrqu;
+#endif
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_ADHOC))
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
+			       WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
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
+
+	nl80211_send_ibss_bssid(wiphy_to_dev(wdev->wiphy), dev, bssid, gfp);
+#ifdef CONFIG_WIRELESS_EXT
+	memset(&wrqu, 0, sizeof(wrqu));
+	memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
+	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+#endif
+}
+EXPORT_SYMBOL(cfg80211_ibss_joined);
+
+int cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev,
+		       struct cfg80211_ibss_params *params)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	err = rdev->ops->join_ibss(&rdev->wiphy, dev, params);
+
+	if (err)
+		return err;
+
+	memcpy(wdev->ssid, params->ssid, params->ssid_len);
+	wdev->ssid_len = params->ssid_len;
+
+	return 0;
+}
+
+void cfg80211_clear_ibss(struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (wdev->current_bss) {
+		cfg80211_unhold_bss(wdev->current_bss);
+		cfg80211_put_bss(wdev->current_bss);
+	}
+
+	wdev->current_bss = NULL;
+	wdev->ssid_len = 0;
+	memset(wdev->bssid, 0, ETH_ALEN);
+}
+
+int cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
+			struct net_device *dev)
+{
+	int err;
+
+	err = rdev->ops->leave_ibss(&rdev->wiphy, dev);
+
+	if (err)
+		return err;
+
+	cfg80211_clear_ibss(dev);
+
+	return 0;
+}
+
+#ifdef CONFIG_WIRELESS_EXT
+int cfg80211_ibss_wext_siwfreq(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_freq *freq, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct ieee80211_channel *chan;
+	int err;
+
+	/* call only for ibss! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_ADHOC))
+		return -EINVAL;
+
+	if (!wiphy_to_dev(wdev->wiphy)->ops->join_ibss)
+		return -EOPNOTSUPP;
+
+	chan = cfg80211_wext_freq(wdev->wiphy, freq);
+	if (chan && IS_ERR(chan))
+		return PTR_ERR(chan);
+
+	if (wdev->wext.channel == chan)
+		return 0;
+
+	if (wdev->ssid_len) {
+		err = cfg80211_leave_ibss(wiphy_to_dev(wdev->wiphy), dev);
+		if (err)
+			return err;
+	}
+
+	wdev->wext.channel = chan;
+
+	if (!netif_running(dev))
+		return 0;
+
+	err = 0;
+	if (wdev->wext.ssid_len)
+		err = cfg80211_join_ibss(wiphy_to_dev(wdev->wiphy), dev,
+					 &wdev->wext);
+	return err;
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_siwfreq);
+
+int cfg80211_ibss_wext_giwfreq(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_freq *freq, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct ieee80211_channel *chan = NULL;
+
+	/* call only for ibss! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_ADHOC))
+		return -EINVAL;
+
+	chan = wdev->wext.channel;
+	if (chan)
+		goto ok;
+
+	if (wdev->current_bss) {
+		chan = wdev->current_bss->channel;
+		goto ok;
+	}
+
+	return -EINVAL;
+ ok:
+	freq->m = chan->center_freq;
+	freq->e = 6;
+	return 0;
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_giwfreq);
+
+int cfg80211_ibss_wext_siwessid(struct net_device *dev,
+				struct iw_request_info *info,
+				struct iw_point *data, char *ssid)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	size_t len = data->length;
+	int err;
+
+	/* call only for ibss! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_ADHOC))
+		return -EINVAL;
+
+	if (!wiphy_to_dev(wdev->wiphy)->ops->join_ibss)
+		return -EOPNOTSUPP;
+
+	if (wdev->ssid_len) {
+		err = cfg80211_leave_ibss(wiphy_to_dev(wdev->wiphy), dev);
+		if (err)
+			return err;
+	}
+
+	/* iwconfig uses nul termination in SSID.. */
+	if (len > 0 && ssid[len - 1] == '\0')
+		len--;
+
+	wdev->wext.ssid = wdev->ssid;
+	memcpy(wdev->wext.ssid, ssid, len);
+	wdev->wext.ssid_len = len;
+
+	if (!netif_running(dev))
+		return 0;
+
+	if (!len)
+		return 0;
+
+	return cfg80211_join_ibss(wiphy_to_dev(wdev->wiphy), dev,
+				  &wdev->wext);
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_siwessid);
+
+int cfg80211_ibss_wext_giwessid(struct net_device *dev,
+				struct iw_request_info *info,
+				struct iw_point *data, char *ssid)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	/* call only for ibss! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_ADHOC))
+		return -EINVAL;
+
+	data->flags = 1;
+	data->length = wdev->wext.ssid_len;
+	memcpy(ssid, wdev->wext.ssid, data->length);
+
+	return 0;
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_giwessid);
+
+int cfg80211_ibss_wext_siwap(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct sockaddr *ap_addr, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	u8 *bssid = ap_addr->sa_data;
+	int err;
+
+	/* call only for ibss! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_ADHOC))
+		return -EINVAL;
+
+	if (!wiphy_to_dev(wdev->wiphy)->ops->join_ibss)
+		return -EOPNOTSUPP;
+
+	if (ap_addr->sa_family != ARPHRD_ETHER)
+		return -EINVAL;
+
+	/* automatic mode */
+	if (is_zero_ether_addr(bssid) || is_broadcast_ether_addr(bssid))
+		bssid = NULL;
+
+	/* both automatic */
+	if (!bssid && !wdev->wext.bssid)
+		return 0;
+
+	/* fixed already - and no change */
+	if (wdev->wext.bssid && bssid &&
+	    compare_ether_addr(bssid, wdev->wext.bssid) == 0)
+		return 0;
+
+	if (wdev->ssid_len) {
+		err = cfg80211_leave_ibss(wiphy_to_dev(wdev->wiphy), dev);
+		if (err)
+			return err;
+	}
+
+	if (bssid) {
+		memcpy(wdev->wext_bssid, bssid, ETH_ALEN);
+		wdev->wext.bssid = wdev->wext_bssid;
+	} else
+		wdev->wext.bssid = NULL;
+
+	if (!netif_running(dev))
+		return 0;
+
+	return cfg80211_join_ibss(wiphy_to_dev(wdev->wiphy), dev, &wdev->wext);
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_siwap);
+
+int cfg80211_ibss_wext_giwap(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct sockaddr *ap_addr, char *extra)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	/* call only for ibss! */
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_ADHOC))
+		return -EINVAL;
+
+	ap_addr->sa_family = ARPHRD_ETHER;
+
+	if (wdev->wext.bssid) {
+		memcpy(ap_addr->sa_data, wdev->wext.bssid, ETH_ALEN);
+		return 0;
+	}
+
+	memcpy(ap_addr->sa_data, wdev->bssid, ETH_ALEN);
+	return 0;
+}
+/* temporary symbol - mark GPL - in the future the handler won't be */
+EXPORT_SYMBOL_GPL(cfg80211_ibss_wext_giwap);
+#endif
--- wireless-testing.orig/net/wireless/nl80211.h	2009-04-18 23:50:46.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.h	2009-04-18 23:50:47.000000000 +0200
@@ -34,4 +34,8 @@ nl80211_send_beacon_hint_event(struct wi
 			       struct ieee80211_channel *channel_before,
 			       struct ieee80211_channel *channel_after);
 
+void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
+			     struct net_device *netdev, const u8 *bssid,
+			     gfp_t gfp);
+
 #endif /* __NET_WIRELESS_NL80211_H */
--- wireless-testing.orig/include/net/wireless.h	2009-04-18 23:50:46.000000000 +0200
+++ wireless-testing/include/net/wireless.h	2009-04-19 00:33:15.000000000 +0200
@@ -265,6 +265,8 @@ struct wiphy {
  *
  * @wiphy: pointer to hardware description
  * @iftype: interface type
+ * @list: (private)
+ * @netdev (private)
  */
 struct wireless_dev {
 	struct wiphy *wiphy;
@@ -273,6 +275,18 @@ struct wireless_dev {
 	/* private to the generic wireless code */
 	struct list_head list;
 	struct net_device *netdev;
+
+	/* currently used for IBSS - might be rearranged in the future */
+	struct cfg80211_bss *current_bss;
+	u8 bssid[ETH_ALEN];
+	u8 ssid[IEEE80211_MAX_SSID_LEN];
+	u8 ssid_len;
+
+#ifdef CONFIG_WIRELESS_EXT
+	/* wext data */
+	struct cfg80211_ibss_params wext;
+	u8 wext_bssid[ETH_ALEN];
+#endif
 };
 
 /**
--- wireless-testing.orig/net/wireless/core.h	2009-04-18 23:50:46.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-04-18 23:50:47.000000000 +0200
@@ -144,4 +144,12 @@ void cfg80211_bss_expire(struct cfg80211
 void cfg80211_bss_age(struct cfg80211_registered_device *dev,
                       unsigned long age_secs);
 
+/* IBSS */
+int cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev,
+		       struct cfg80211_ibss_params *params);
+void cfg80211_clear_ibss(struct net_device *dev);
+int cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
+			struct net_device *dev);
+
 #endif /* __NET_WIRELESS_CORE_H */
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-04-18 23:50:46.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-04-18 23:50:47.000000000 +0200
@@ -241,3 +241,33 @@ int cfg80211_wext_giwrange(struct net_de
 	return 0;
 }
 EXPORT_SYMBOL(cfg80211_wext_giwrange);
+
+
+/**
+ * cfg80211_wext_freq - get wext frequency for non-"auto"
+ * @wiphy: the wiphy
+ * @freq: the wext freq encoding
+ *
+ * Returns a channel, %NULL for auto, or an ERR_PTR for errors!
+ */
+struct ieee80211_channel *cfg80211_wext_freq(struct wiphy *wiphy,
+					     struct iw_freq *freq)
+{
+	if (freq->e == 0) {
+		if (freq->m < 0)
+			return NULL;
+		else
+			return ieee80211_get_channel(wiphy,
+				ieee80211_channel_to_frequency(freq->m));
+	} else {
+		int i, div = 1000000;
+		for (i = 0; i < freq->e; i++)
+			div /= 10;
+		if (div > 0)
+			return ieee80211_get_channel(wiphy, freq->m / div);
+		else
+			return ERR_PTR(-EINVAL);
+	}
+
+}
+EXPORT_SYMBOL(cfg80211_wext_freq);


