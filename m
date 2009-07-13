Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50868 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbZGMWh7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 18:37:59 -0400
Message-Id: <20090713223413.428759094@sipsolutions.net>
References: <20090713223333.042733013@sipsolutions.net>
Date: Tue, 14 Jul 2009 00:33:35 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] cfg80211: make aware of net namespaces
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to make cfg80211/nl80211 aware of network namespaces,
we have to do the following things:

 * del_virtual_intf method takes an interface index rather
   than a netdev pointer - simply change this

 * nl80211 uses init_net a lot, it changes to use the sender's
   network namespace

 * scan requests use the interface index, hold a netdev pointer
   and reference instead

 * we want a wiphy and its associated virtual interfaces to be
   in one netns together, so
    - we need to be able to change ns for a given interface, so
      export dev_change_net_namespace()
    - for each virtual interface set the NETIF_F_NETNS_LOCAL
      flag, and clear that flag only when the wiphy changes ns,
      to disallow breaking this invariant

 * when a network namespace goes away, we need to reparent the
   wiphy to init_net

 * cfg80211 users that support creating virtual interfaces must
   create them in the wiphy's namespace, currently this affects
   only mac80211

The end result is that you can now switch an entire wiphy into
a different network namespace with the new command
	iw phy#<idx> set netns <pid>
and all virtual interfaces will follow (or the operation fails).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/nl80211.h |    9 ++
 include/net/cfg80211.h  |   40 ++++++++-
 net/core/dev.c          |    1 
 net/mac80211/cfg.c      |   14 ---
 net/wireless/core.c     |   75 ++++++++++++++++-
 net/wireless/core.h     |    5 -
 net/wireless/nl80211.c  |  202 +++++++++++++++++++++++++++++++++---------------
 net/wireless/scan.c     |   22 +----
 net/wireless/sme.c      |    3 
 9 files changed, 272 insertions(+), 99 deletions(-)

--- wireless-testing.orig/include/net/cfg80211.h	2009-07-14 00:29:55.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-07-14 00:30:08.000000000 +0200
@@ -542,7 +542,7 @@ struct cfg80211_ssid {
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
  * @wiphy: the wiphy this was for
- * @ifidx: the interface index
+ * @dev: the interface
  */
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -554,7 +554,7 @@ struct cfg80211_scan_request {
 
 	/* internal */
 	struct wiphy *wiphy;
-	int ifidx;
+	struct net_device *dev;
 	bool aborted;
 };
 
@@ -845,7 +845,8 @@ struct cfg80211_bitrate_mask {
  * @resume: wiphy device needs to be resumed
  *
  * @add_virtual_intf: create a new virtual interface with the given name,
- *	must set the struct wireless_dev's iftype.
+ *	must set the struct wireless_dev's iftype. Beware: You must create
+ *	the new netdev in the wiphy's network namespace!
  *
  * @del_virtual_intf: remove the virtual interface determined by ifindex.
  *
@@ -937,7 +938,7 @@ struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
 				    enum nl80211_iftype type, u32 *flags,
 				    struct vif_params *params);
-	int	(*del_virtual_intf)(struct wiphy *wiphy, int ifindex);
+	int	(*del_virtual_intf)(struct wiphy *wiphy, struct net_device *dev);
 	int	(*change_virtual_intf)(struct wiphy *wiphy,
 				       struct net_device *dev,
 				       enum nl80211_iftype type, u32 *flags,
@@ -1088,6 +1089,9 @@ struct cfg80211_ops {
  * @frag_threshold: Fragmentation threshold (dot11FragmentationThreshold);
  *	-1 = fragmentation disabled, only odd values >= 256 used
  * @rts_threshold: RTS threshold (dot11RTSThreshold); -1 = RTS/CTS disabled
+ * @net: the network namespace this wiphy currently lives in
+ * @netnsok: if set to false, do not allow changing the netns of this
+ *	wiphy at all
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -1101,6 +1105,8 @@ struct wiphy {
 	bool custom_regulatory;
 	bool strict_regulatory;
 
+	bool netnsok;
+
 	enum cfg80211_signal_type signal_type;
 
 	int bss_priv_size;
@@ -1139,9 +1145,35 @@ struct wiphy {
 	/* dir in debugfs: ieee80211/<wiphyname> */
 	struct dentry *debugfsdir;
 
+#ifdef CONFIG_NET_NS
+	/* the network namespace this phy lives in currently */
+	struct net *_net;
+#endif
+
 	char priv[0] __attribute__((__aligned__(NETDEV_ALIGN)));
 };
 
+#ifdef CONFIG_NET_NS
+static inline struct net *wiphy_net(struct wiphy *wiphy)
+{
+	return wiphy->_net;
+}
+
+static inline void wiphy_net_set(struct wiphy *wiphy, struct net *net)
+{
+	wiphy->_net = net;
+}
+#else
+static inline struct net *wiphy_net(struct wiphy *wiphy)
+{
+	return &init_net;
+}
+
+static inline void wiphy_net_set(struct wiphy *wiphy, struct net *net)
+{
+}
+#endif
+
 /**
  * wiphy_priv - return priv from wiphy
  *
--- wireless-testing.orig/net/mac80211/cfg.c	2009-07-14 00:29:55.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-07-14 00:30:08.000000000 +0200
@@ -57,19 +57,9 @@ static int ieee80211_add_iface(struct wi
 	return 0;
 }
 
-static int ieee80211_del_iface(struct wiphy *wiphy, int ifindex)
+static int ieee80211_del_iface(struct wiphy *wiphy, struct net_device *dev)
 {
-	struct net_device *dev;
-	struct ieee80211_sub_if_data *sdata;
-
-	/* we're under RTNL */
-	dev = __dev_get_by_index(&init_net, ifindex);
-	if (!dev)
-		return -ENODEV;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	ieee80211_if_remove(sdata);
+	ieee80211_if_remove(IEEE80211_DEV_TO_SUB_IF(dev));
 
 	return 0;
 }
--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-14 00:29:55.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-14 00:30:08.000000000 +0200
@@ -14,8 +14,10 @@
 #include <linux/rtnetlink.h>
 #include <linux/netlink.h>
 #include <linux/etherdevice.h>
+#include <net/net_namespace.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
+#include <net/sock.h>
 #include "core.h"
 #include "nl80211.h"
 #include "reg.h"
@@ -27,24 +29,26 @@ static struct genl_family nl80211_fam = 
 	.hdrsize = 0,		/* no private header */
 	.version = 1,		/* no particular meaning now */
 	.maxattr = NL80211_ATTR_MAX,
+	.netnsok = true,
 };
 
 /* internal helper: get rdev and dev */
-static int get_rdev_dev_by_info_ifindex(struct nlattr **attrs,
+static int get_rdev_dev_by_info_ifindex(struct genl_info *info,
 				       struct cfg80211_registered_device **rdev,
 				       struct net_device **dev)
 {
+	struct nlattr **attrs = info->attrs;
 	int ifindex;
 
 	if (!attrs[NL80211_ATTR_IFINDEX])
 		return -EINVAL;
 
 	ifindex = nla_get_u32(attrs[NL80211_ATTR_IFINDEX]);
-	*dev = dev_get_by_index(&init_net, ifindex);
+	*dev = dev_get_by_index(genl_info_net(info), ifindex);
 	if (!*dev)
 		return -ENODEV;
 
-	*rdev = cfg80211_get_dev_from_ifindex(ifindex);
+	*rdev = cfg80211_get_dev_from_ifindex(genl_info_net(info), ifindex);
 	if (IS_ERR(*rdev)) {
 		dev_put(*dev);
 		return PTR_ERR(*rdev);
@@ -133,6 +137,7 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_PRIVACY] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CIPHER_SUITE_GROUP] = { .type = NLA_U32 },
 	[NL80211_ATTR_WPA_VERSIONS] = { .type = NLA_U32 },
+	[NL80211_ATTR_PID] = { .type = NLA_U32 },
 };
 
 /* policy for the attributes */
@@ -532,6 +537,10 @@ static int nl80211_send_wiphy(struct sk_
 	CMD(deauth, DEAUTHENTICATE);
 	CMD(disassoc, DISASSOCIATE);
 	CMD(join_ibss, JOIN_IBSS);
+	if (dev->wiphy.netnsok) {
+		i++;
+		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
+	}
 
 #undef CMD
 
@@ -562,6 +571,8 @@ static int nl80211_dump_wiphy(struct sk_
 
 	mutex_lock(&cfg80211_mutex);
 	list_for_each_entry(dev, &cfg80211_rdev_list, list) {
+		if (!net_eq(wiphy_net(&dev->wiphy), sock_net(skb->sk)))
+			continue;
 		if (++idx <= start)
 			continue;
 		if (nl80211_send_wiphy(skb, NETLINK_CB(cb->skb).pid,
@@ -867,6 +878,8 @@ static int nl80211_dump_interface(struct
 
 	mutex_lock(&cfg80211_mutex);
 	list_for_each_entry(dev, &cfg80211_rdev_list, list) {
+		if (!net_eq(wiphy_net(&dev->wiphy), sock_net(skb->sk)))
+			continue;
 		if (wp_idx < wp_start) {
 			wp_idx++;
 			continue;
@@ -907,7 +920,7 @@ static int nl80211_get_interface(struct 
 	struct net_device *netdev;
 	int err;
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &dev, &netdev);
+	err = get_rdev_dev_by_info_ifindex(info, &dev, &netdev);
 	if (err)
 		return err;
 
@@ -975,7 +988,7 @@ static int nl80211_set_interface(struct 
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -1098,26 +1111,25 @@ static int nl80211_new_interface(struct 
 static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev;
-	int ifindex, err;
+	int err;
 	struct net_device *dev;
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
-	ifindex = dev->ifindex;
-	dev_put(dev);
 
 	if (!rdev->ops->del_virtual_intf) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	err = rdev->ops->del_virtual_intf(&rdev->wiphy, ifindex);
+	err = rdev->ops->del_virtual_intf(&rdev->wiphy, dev);
 
  out:
 	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
  unlock_rtnl:
 	rtnl_unlock();
 	return err;
@@ -1195,7 +1207,7 @@ static int nl80211_get_key(struct sk_buf
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -1273,7 +1285,7 @@ static int nl80211_set_key(struct sk_buf
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -1332,7 +1344,7 @@ static int nl80211_new_key(struct sk_buf
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -1379,7 +1391,7 @@ static int nl80211_del_key(struct sk_buf
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -1428,7 +1440,7 @@ static int nl80211_addset_beacon(struct 
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -1515,7 +1527,7 @@ static int nl80211_del_beacon(struct sk_
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -1725,13 +1737,13 @@ static int nl80211_dump_station(struct s
 
 	rtnl_lock();
 
-	netdev = __dev_get_by_index(&init_net, ifidx);
+	netdev = __dev_get_by_index(sock_net(skb->sk), ifidx);
 	if (!netdev) {
 		err = -ENODEV;
 		goto out_rtnl;
 	}
 
-	dev = cfg80211_get_dev_from_ifindex(ifidx);
+	dev = cfg80211_get_dev_from_ifindex(sock_net(skb->sk), ifidx);
 	if (IS_ERR(dev)) {
 		err = PTR_ERR(dev);
 		goto out_rtnl;
@@ -1790,7 +1802,7 @@ static int nl80211_get_station(struct sk
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
@@ -1828,14 +1840,16 @@ static int nl80211_get_station(struct sk
 /*
  * Get vlan interface making sure it is on the right wiphy.
  */
-static int get_vlan(struct nlattr *vlanattr,
+static int get_vlan(struct genl_info *info,
 		    struct cfg80211_registered_device *rdev,
 		    struct net_device **vlan)
 {
+	struct nlattr *vlanattr = info->attrs[NL80211_ATTR_STA_VLAN];
 	*vlan = NULL;
 
 	if (vlanattr) {
-		*vlan = dev_get_by_index(&init_net, nla_get_u32(vlanattr));
+		*vlan = dev_get_by_index(genl_info_net(info),
+					 nla_get_u32(vlanattr));
 		if (!*vlan)
 			return -ENODEV;
 		if (!(*vlan)->ieee80211_ptr)
@@ -1890,11 +1904,11 @@ static int nl80211_set_station(struct sk
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
-	err = get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], rdev, &params.vlan);
+	err = get_vlan(info, rdev, &params.vlan);
 	if (err)
 		goto out;
 
@@ -2003,11 +2017,11 @@ static int nl80211_new_station(struct sk
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
-	err = get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], rdev, &params.vlan);
+	err = get_vlan(info, rdev, &params.vlan);
 	if (err)
 		goto out;
 
@@ -2078,7 +2092,7 @@ static int nl80211_del_station(struct sk
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
@@ -2184,13 +2198,13 @@ static int nl80211_dump_mpath(struct sk_
 
 	rtnl_lock();
 
-	netdev = __dev_get_by_index(&init_net, ifidx);
+	netdev = __dev_get_by_index(sock_net(skb->sk), ifidx);
 	if (!netdev) {
 		err = -ENODEV;
 		goto out_rtnl;
 	}
 
-	dev = cfg80211_get_dev_from_ifindex(ifidx);
+	dev = cfg80211_get_dev_from_ifindex(sock_net(skb->sk), ifidx);
 	if (IS_ERR(dev)) {
 		err = PTR_ERR(dev);
 		goto out_rtnl;
@@ -2254,7 +2268,7 @@ static int nl80211_get_mpath(struct sk_b
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
@@ -2313,7 +2327,7 @@ static int nl80211_set_mpath(struct sk_b
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
@@ -2361,7 +2375,7 @@ static int nl80211_new_mpath(struct sk_b
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
@@ -2403,7 +2417,7 @@ static int nl80211_del_mpath(struct sk_b
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
@@ -2454,7 +2468,7 @@ static int nl80211_set_bss(struct sk_buf
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
@@ -2573,7 +2587,7 @@ static int nl80211_get_mesh_params(struc
 	rtnl_lock();
 
 	/* Look up our device */
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
@@ -2690,7 +2704,7 @@ static int nl80211_set_mesh_params(struc
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
@@ -2946,7 +2960,7 @@ static int nl80211_trigger_scan(struct s
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto out_rtnl;
 
@@ -3068,14 +3082,16 @@ static int nl80211_trigger_scan(struct s
 		       request->ie_len);
 	}
 
-	request->ifidx = dev->ifindex;
+	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
 
 	rdev->scan_req = request;
 	err = rdev->ops->scan(&rdev->wiphy, dev, request);
 
-	if (!err)
+	if (!err) {
 		nl80211_send_scan_start(rdev, dev);
+		dev_hold(dev);
+	}
 
  out_free:
 	if (err) {
@@ -3197,11 +3213,11 @@ static int nl80211_dump_scan(struct sk_b
 		cb->args[0] = ifidx;
 	}
 
-	dev = dev_get_by_index(&init_net, ifidx);
+	dev = dev_get_by_index(sock_net(skb->sk), ifidx);
 	if (!dev)
 		return -ENODEV;
 
-	rdev = cfg80211_get_dev_from_ifindex(ifidx);
+	rdev = cfg80211_get_dev_from_ifindex(sock_net(skb->sk), ifidx);
 	if (IS_ERR(rdev)) {
 		err = PTR_ERR(rdev);
 		goto out_put_netdev;
@@ -3311,7 +3327,7 @@ static int nl80211_authenticate(struct s
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -3447,7 +3463,7 @@ static int nl80211_associate(struct sk_b
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -3530,7 +3546,7 @@ static int nl80211_deauthenticate(struct
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -3592,7 +3608,7 @@ static int nl80211_disassociate(struct s
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -3665,7 +3681,7 @@ static int nl80211_join_ibss(struct sk_b
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -3738,7 +3754,7 @@ static int nl80211_leave_ibss(struct sk_
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -3923,7 +3939,7 @@ static int nl80211_connect(struct sk_buf
 		return err;
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -3999,7 +4015,7 @@ static int nl80211_disconnect(struct sk_
 
 	rtnl_lock();
 
-	err = get_rdev_dev_by_info_ifindex(info->attrs, &rdev, &dev);
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
 	if (err)
 		goto unlock_rtnl;
 
@@ -4023,6 +4039,47 @@ unlock_rtnl:
 	return err;
 }
 
+static int nl80211_wiphy_netns(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct net *net;
+	int err;
+	u32 pid;
+
+	if (!info->attrs[NL80211_ATTR_PID])
+		return -EINVAL;
+
+	pid = nla_get_u32(info->attrs[NL80211_ATTR_PID]);
+
+	rtnl_lock();
+
+	rdev = cfg80211_get_dev_from_info(info);
+	if (IS_ERR(rdev)) {
+		err = PTR_ERR(rdev);
+		goto out;
+	}
+
+	net = get_net_ns_by_pid(pid);
+	if (IS_ERR(net)) {
+		err = PTR_ERR(net);
+		goto out;
+	}
+
+	err = 0;
+
+	/* check if anything to do */
+	if (net_eq(wiphy_net(&rdev->wiphy), net))
+		goto out_put_net;
+
+	err = cfg80211_switch_netns(rdev, net);
+ out_put_net:
+	put_net(net);
+ out:
+	cfg80211_unlock_rdev(rdev);
+	rtnl_unlock();
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -4256,6 +4313,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_WIPHY_NETNS,
+		.doit = nl80211_wiphy_netns,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
 	.name = "mlme",
@@ -4287,7 +4350,8 @@ void nl80211_notify_dev_rename(struct cf
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_config_mcgrp.id, GFP_KERNEL);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_config_mcgrp.id, GFP_KERNEL);
 }
 
 static int nl80211_add_scan_req(struct sk_buff *msg,
@@ -4364,7 +4428,8 @@ void nl80211_send_scan_start(struct cfg8
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_scan_mcgrp.id, GFP_KERNEL);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_scan_mcgrp.id, GFP_KERNEL);
 }
 
 void nl80211_send_scan_done(struct cfg80211_registered_device *rdev,
@@ -4382,7 +4447,8 @@ void nl80211_send_scan_done(struct cfg80
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_scan_mcgrp.id, GFP_KERNEL);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_scan_mcgrp.id, GFP_KERNEL);
 }
 
 void nl80211_send_scan_aborted(struct cfg80211_registered_device *rdev,
@@ -4400,7 +4466,8 @@ void nl80211_send_scan_aborted(struct cf
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_scan_mcgrp.id, GFP_KERNEL);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_scan_mcgrp.id, GFP_KERNEL);
 }
 
 /*
@@ -4449,7 +4516,10 @@ void nl80211_send_reg_change_event(struc
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_regulatory_mcgrp.id, GFP_KERNEL);
+	rtnl_lock();
+	genlmsg_multicast_allns(msg, 0, nl80211_regulatory_mcgrp.id,
+				GFP_KERNEL);
+	rtnl_unlock();
 
 	return;
 
@@ -4485,7 +4555,8 @@ static void nl80211_send_mlme_event(stru
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:
@@ -4552,7 +4623,8 @@ static void nl80211_send_mlme_timeout(st
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:
@@ -4610,7 +4682,8 @@ void nl80211_send_connect_result(struct 
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:
@@ -4650,7 +4723,8 @@ void nl80211_send_roamed(struct cfg80211
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:
@@ -4690,7 +4764,8 @@ void nl80211_send_disconnected(struct cf
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, GFP_KERNEL);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, GFP_KERNEL);
 	return;
 
  nla_put_failure:
@@ -4725,7 +4800,8 @@ void nl80211_send_ibss_bssid(struct cfg8
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:
@@ -4765,7 +4841,8 @@ void nl80211_michael_mic_failure(struct 
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:
@@ -4818,7 +4895,10 @@ void nl80211_send_beacon_hint_event(stru
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_regulatory_mcgrp.id, GFP_ATOMIC);
+	rcu_read_lock();
+	genlmsg_multicast_allns(msg, 0, nl80211_regulatory_mcgrp.id,
+				GFP_ATOMIC);
+	rcu_read_unlock();
 
 	return;
 
--- wireless-testing.orig/net/wireless/core.c	2009-07-14 00:30:01.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-07-14 00:30:08.000000000 +0200
@@ -106,7 +106,7 @@ __cfg80211_rdev_from_info(struct genl_in
 
 	if (info->attrs[NL80211_ATTR_IFINDEX]) {
 		ifindex = nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
-		dev = dev_get_by_index(&init_net, ifindex);
+		dev = dev_get_by_index(genl_info_net(info), ifindex);
 		if (dev) {
 			if (dev->ieee80211_ptr)
 				byifidx =
@@ -151,13 +151,13 @@ cfg80211_get_dev_from_info(struct genl_i
 }
 
 struct cfg80211_registered_device *
-cfg80211_get_dev_from_ifindex(int ifindex)
+cfg80211_get_dev_from_ifindex(struct net *net, int ifindex)
 {
 	struct cfg80211_registered_device *rdev = ERR_PTR(-ENODEV);
 	struct net_device *dev;
 
 	mutex_lock(&cfg80211_mutex);
-	dev = dev_get_by_index(&init_net, ifindex);
+	dev = dev_get_by_index(net, ifindex);
 	if (!dev)
 		goto out;
 	if (dev->ieee80211_ptr) {
@@ -222,6 +222,42 @@ int cfg80211_dev_rename(struct cfg80211_
 	return 0;
 }
 
+int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
+			  struct net *net)
+{
+	struct wireless_dev *wdev;
+	int err = 0;
+
+	if (!rdev->wiphy.netnsok)
+		return -EOPNOTSUPP;
+
+	list_for_each_entry(wdev, &rdev->netdev_list, list) {
+		wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
+		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
+		if (err)
+			break;
+		wdev->netdev->features |= NETIF_F_NETNS_LOCAL;
+	}
+
+	if (err) {
+		/* failed -- clean up to old netns */
+		net = wiphy_net(&rdev->wiphy);
+
+		list_for_each_entry_continue_reverse(wdev, &rdev->netdev_list,
+						     list) {
+			wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
+			err = dev_change_net_namespace(wdev->netdev, net,
+							"wlan%d");
+			WARN_ON(err);
+			wdev->netdev->features |= NETIF_F_NETNS_LOCAL;
+		}
+	}
+
+	wiphy_net_set(&rdev->wiphy, net);
+
+	return err;
+}
+
 static void cfg80211_rfkill_poll(struct rfkill *rfkill, void *data)
 {
 	struct cfg80211_registered_device *rdev = data;
@@ -375,6 +411,8 @@ struct wiphy *wiphy_new(const struct cfg
 	rdev->wiphy.dev.class = &ieee80211_class;
 	rdev->wiphy.dev.platform_data = rdev;
 
+	wiphy_net_set(&rdev->wiphy, &init_net);
+
 	rdev->rfkill_ops.set_block = cfg80211_rfkill_set_block;
 	rdev->rfkill = rfkill_alloc(dev_name(&rdev->wiphy.dev),
 				   &rdev->wiphy.dev, RFKILL_TYPE_WLAN,
@@ -615,6 +653,9 @@ static int cfg80211_netdev_notifier_call
 		spin_lock_init(&wdev->event_lock);
 		mutex_lock(&rdev->devlist_mtx);
 		list_add(&wdev->list, &rdev->netdev_list);
+		/* can only change netns with wiphy */
+		dev->features |= NETIF_F_NETNS_LOCAL;
+
 		if (sysfs_create_link(&dev->dev.kobj, &rdev->wiphy.dev.kobj,
 				      "phy80211")) {
 			printk(KERN_ERR "wireless: failed to add phy80211 "
@@ -705,10 +746,32 @@ static struct notifier_block cfg80211_ne
 	.notifier_call = cfg80211_netdev_notifier_call,
 };
 
-static int cfg80211_init(void)
+static void __net_exit cfg80211_pernet_exit(struct net *net)
+{
+	struct cfg80211_registered_device *rdev;
+
+	rtnl_lock();
+	mutex_lock(&cfg80211_mutex);
+	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
+		if (net_eq(wiphy_net(&rdev->wiphy), net))
+			WARN_ON(cfg80211_switch_netns(rdev, &init_net));
+	}
+	mutex_unlock(&cfg80211_mutex);
+	rtnl_unlock();
+}
+
+static struct pernet_operations cfg80211_pernet_ops = {
+	.exit = cfg80211_pernet_exit,
+};
+
+static int __init cfg80211_init(void)
 {
 	int err;
 
+	err = register_pernet_device(&cfg80211_pernet_ops);
+	if (err)
+		goto out_fail_pernet;
+
 	err = wiphy_sysfs_init();
 	if (err)
 		goto out_fail_sysfs;
@@ -736,9 +799,10 @@ out_fail_nl80211:
 out_fail_notifier:
 	wiphy_sysfs_exit();
 out_fail_sysfs:
+	unregister_pernet_device(&cfg80211_pernet_ops);
+out_fail_pernet:
 	return err;
 }
-
 subsys_initcall(cfg80211_init);
 
 static void cfg80211_exit(void)
@@ -748,5 +812,6 @@ static void cfg80211_exit(void)
 	unregister_netdevice_notifier(&cfg80211_netdev_notifier);
 	wiphy_sysfs_exit();
 	regulatory_exit();
+	unregister_pernet_device(&cfg80211_pernet_ops);
 }
 module_exit(cfg80211_exit);
--- wireless-testing.orig/net/wireless/scan.c	2009-07-14 00:29:55.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-07-14 00:30:08.000000000 +0200
@@ -32,9 +32,7 @@ void __cfg80211_scan_done(struct work_st
 	mutex_lock(&rdev->mtx);
 	request = rdev->scan_req;
 
-	dev = dev_get_by_index(&init_net, request->ifidx);
-	if (!dev)
-		goto out;
+	dev = request->dev;
 
 	/*
 	 * This must be before sending the other events!
@@ -60,24 +58,16 @@ void __cfg80211_scan_done(struct work_st
 
 	dev_put(dev);
 
- out:
 	cfg80211_unlock_rdev(rdev);
 	kfree(request);
 }
 
 void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
 {
-	struct net_device *dev = dev_get_by_index(&init_net, request->ifidx);
-	if (WARN_ON(!dev)) {
-		kfree(request);
-		return;
-	}
-
 	WARN_ON(request != wiphy_to_dev(request->wiphy)->scan_req);
 
 	request->aborted = aborted;
 	schedule_work(&wiphy_to_dev(request->wiphy)->scan_done_wk);
-	dev_put(dev);
 }
 EXPORT_SYMBOL(cfg80211_scan_done);
 
@@ -593,7 +583,7 @@ int cfg80211_wext_siwscan(struct net_dev
 	if (!netif_running(dev))
 		return -ENETDOWN;
 
-	rdev = cfg80211_get_dev_from_ifindex(dev->ifindex);
+	rdev = cfg80211_get_dev_from_ifindex(dev_net(dev), dev->ifindex);
 
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
@@ -618,7 +608,7 @@ int cfg80211_wext_siwscan(struct net_dev
 	}
 
 	creq->wiphy = wiphy;
-	creq->ifidx = dev->ifindex;
+	creq->dev = dev;
 	creq->ssids = (void *)(creq + 1);
 	creq->channels = (void *)(creq->ssids + 1);
 	creq->n_channels = n_channels;
@@ -655,8 +645,10 @@ int cfg80211_wext_siwscan(struct net_dev
 	if (err) {
 		rdev->scan_req = NULL;
 		kfree(creq);
-	} else
+	} else {
 		nl80211_send_scan_start(rdev, dev);
+		dev_hold(dev);
+	}
  out:
 	cfg80211_unlock_rdev(rdev);
 	return err;
@@ -949,7 +941,7 @@ int cfg80211_wext_giwscan(struct net_dev
 	if (!netif_running(dev))
 		return -ENETDOWN;
 
-	rdev = cfg80211_get_dev_from_ifindex(dev->ifindex);
+	rdev = cfg80211_get_dev_from_ifindex(dev_net(dev), dev->ifindex);
 
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
--- wireless-testing.orig/include/linux/nl80211.h	2009-07-14 00:29:55.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2009-07-14 00:30:08.000000000 +0200
@@ -262,6 +262,9 @@
  *	reasons, for this the %NL80211_ATTR_DISCONNECTED_BY_AP and
  *	%NL80211_ATTR_REASON_CODE attributes are used.
  *
+ * @NL80211_CMD_SET_WIPHY_NETNS: Set a wiphy's netns. Note that all devices
+ *	associated with this wiphy must be down and will follow.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -336,6 +339,8 @@ enum nl80211_commands {
 	NL80211_CMD_ROAM,
 	NL80211_CMD_DISCONNECT,
 
+	NL80211_CMD_SET_WIPHY_NETNS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -573,6 +578,8 @@ enum nl80211_commands {
  *	and join_ibss(), key information is in a nested attribute each
  *	with %NL80211_KEY_* sub-attributes
  *
+ * @NL80211_ATTR_PID: Process ID of a network namespace.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -701,6 +708,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_KEY,
 	NL80211_ATTR_KEYS,
 
+	NL80211_ATTR_PID,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- wireless-testing.orig/net/core/dev.c	2009-07-14 00:29:55.000000000 +0200
+++ wireless-testing/net/core/dev.c	2009-07-14 00:30:08.000000000 +0200
@@ -5344,6 +5344,7 @@ int dev_change_net_namespace(struct net_
 out:
 	return err;
 }
+EXPORT_SYMBOL_GPL(dev_change_net_namespace);
 
 static int dev_cpu_callback(struct notifier_block *nfb,
 			    unsigned long action,
--- wireless-testing.orig/net/wireless/sme.c	2009-07-14 00:29:55.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-07-14 00:30:08.000000000 +0200
@@ -86,7 +86,7 @@ static int cfg80211_conn_scan(struct wir
 		wdev->conn->params.ssid_len);
 	request->ssids[0].ssid_len = wdev->conn->params.ssid_len;
 
-	request->ifidx = wdev->netdev->ifindex;
+	request->dev = wdev->netdev;
 	request->wiphy = &rdev->wiphy;
 
 	rdev->scan_req = request;
@@ -95,6 +95,7 @@ static int cfg80211_conn_scan(struct wir
 	if (!err) {
 		wdev->conn->state = CFG80211_CONN_SCANNING;
 		nl80211_send_scan_start(rdev, wdev->netdev);
+		dev_hold(wdev->netdev);
 	} else {
 		rdev->scan_req = NULL;
 		kfree(request);
--- wireless-testing.orig/net/wireless/core.h	2009-07-14 00:29:55.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-07-14 00:30:08.000000000 +0200
@@ -170,7 +170,10 @@ struct wiphy *wiphy_idx_to_wiphy(int wip
 
 /* identical to cfg80211_get_dev_from_info but only operate on ifindex */
 extern struct cfg80211_registered_device *
-cfg80211_get_dev_from_ifindex(int ifindex);
+cfg80211_get_dev_from_ifindex(struct net *net, int ifindex);
+
+int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
+			  struct net *net);
 
 static inline void cfg80211_lock_rdev(struct cfg80211_registered_device *rdev)
 {

-- 

