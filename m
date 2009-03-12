Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53888 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379AbZCLIzU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 04:55:20 -0400
Subject: [PATCH] nl80211: rework locking
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 09:55:09 +0100
Message-Id: <1236848109.4175.13.camel@johannes.local> (sfid-20090312_095525_333925_66A0E552)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I added scanning to cfg80211, we got a lock dependency like this:
	rtnl --> cfg80211_mtx

nl80211, on the other hand, has the reverse lock dependency:
	cfg80211_mtx --> rtnl

which clearly is a bad idea. This patch reworks nl80211 to take these
two locks in the other order to fix the possible, and easily
triggerable, deadlock.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
WARNING: This patch invalidates all nl80211 patches that have been
	 posted to date!! All nl80211 patches must be reworked to
	 take locks in this order!

resend, sorry, forgot list.

 net/wireless/nl80211.c |  271 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 166 insertions(+), 105 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-03-12 09:29:59.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2009-03-12 09:47:03.000000000 +0100
@@ -575,9 +575,12 @@ static int nl80211_set_interface(struct 
 
 	memset(&params, 0, sizeof(params));
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto unlock_rtnl;
+
 	ifindex = dev->ifindex;
 	type = dev->ieee80211_ptr->iftype;
 	dev_put(dev);
@@ -614,17 +617,17 @@ static int nl80211_set_interface(struct 
 		if (!err)
 			flags = &_flags;
 	}
-	rtnl_lock();
+
 	err = drv->ops->change_virtual_intf(&drv->wiphy, ifindex,
 					    type, flags, &params);
 
 	dev = __dev_get_by_index(&init_net, ifindex);
 	WARN_ON(!dev || (!err && dev->ieee80211_ptr->iftype != type));
 
-	rtnl_unlock();
-
  unlock:
 	cfg80211_put_dev(drv);
+ unlock_rtnl:
+	rtnl_unlock();
 	return err;
 }
 
@@ -647,9 +650,13 @@ static int nl80211_new_interface(struct 
 			return -EINVAL;
 	}
 
+	rtnl_lock();
+
 	drv = cfg80211_get_dev_from_info(info);
-	if (IS_ERR(drv))
-		return PTR_ERR(drv);
+	if (IS_ERR(drv)) {
+		err = PTR_ERR(drv);
+		goto unlock_rtnl;
+	}
 
 	if (!drv->ops->add_virtual_intf ||
 	    !(drv->wiphy.interface_modes & (1 << type))) {
@@ -663,18 +670,17 @@ static int nl80211_new_interface(struct 
 		params.mesh_id_len = nla_len(info->attrs[NL80211_ATTR_MESH_ID]);
 	}
 
-	rtnl_lock();
 	err = parse_monitor_flags(type == NL80211_IFTYPE_MONITOR ?
 				  info->attrs[NL80211_ATTR_MNTR_FLAGS] : NULL,
 				  &flags);
 	err = drv->ops->add_virtual_intf(&drv->wiphy,
 		nla_data(info->attrs[NL80211_ATTR_IFNAME]),
 		type, err ? NULL : &flags, &params);
-	rtnl_unlock();
-
 
  unlock:
 	cfg80211_put_dev(drv);
+ unlock_rtnl:
+	rtnl_unlock();
 	return err;
 }
 
@@ -684,9 +690,11 @@ static int nl80211_del_interface(struct 
 	int ifindex, err;
 	struct net_device *dev;
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto unlock_rtnl;
 	ifindex = dev->ifindex;
 	dev_put(dev);
 
@@ -695,12 +703,12 @@ static int nl80211_del_interface(struct 
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->del_virtual_intf(&drv->wiphy, ifindex);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
+ unlock_rtnl:
+	rtnl_unlock();
 	return err;
 }
 
@@ -752,9 +760,11 @@ static int nl80211_get_key(struct sk_buf
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto unlock_rtnl;
 
 	if (!drv->ops->get_key) {
 		err = -EOPNOTSUPP;
@@ -782,10 +792,8 @@ static int nl80211_get_key(struct sk_buf
 	if (mac_addr)
 		NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
 
-	rtnl_lock();
 	err = drv->ops->get_key(&drv->wiphy, dev, key_idx, mac_addr,
 				&cookie, get_key_callback);
-	rtnl_unlock();
 
 	if (err)
 		goto out;
@@ -803,6 +811,9 @@ static int nl80211_get_key(struct sk_buf
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ unlock_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -831,9 +842,11 @@ static int nl80211_set_key(struct sk_buf
 	    !info->attrs[NL80211_ATTR_KEY_DEFAULT_MGMT])
 		return -EINVAL;
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto unlock_rtnl;
 
 	if (info->attrs[NL80211_ATTR_KEY_DEFAULT])
 		func = drv->ops->set_default_key;
@@ -845,13 +858,15 @@ static int nl80211_set_key(struct sk_buf
 		goto out;
 	}
 
-	rtnl_lock();
 	err = func(&drv->wiphy, dev, key_idx);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+
+ unlock_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -921,22 +936,25 @@ static int nl80211_new_key(struct sk_buf
 		return -EINVAL;
 	}
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto unlock_rtnl;
 
 	if (!drv->ops->add_key) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->add_key(&drv->wiphy, dev, key_idx, mac_addr, &params);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ unlock_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -957,22 +975,26 @@ static int nl80211_del_key(struct sk_buf
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto unlock_rtnl;
 
 	if (!drv->ops->del_key) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->del_key(&drv->wiphy, dev, key_idx, mac_addr);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+
+ unlock_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -986,9 +1008,11 @@ static int nl80211_addset_beacon(struct 
 	struct beacon_parameters params;
 	int haveinfo = 0;
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto unlock_rtnl;
 
 	switch (info->genlhdr->cmd) {
 	case NL80211_CMD_NEW_BEACON:
@@ -1049,13 +1073,14 @@ static int nl80211_addset_beacon(struct 
 		goto out;
 	}
 
-	rtnl_lock();
 	err = call(&drv->wiphy, dev, &params);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ unlock_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -1065,22 +1090,25 @@ static int nl80211_del_beacon(struct sk_
 	int err;
 	struct net_device *dev;
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto unlock_rtnl;
 
 	if (!drv->ops->del_beacon) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->del_beacon(&drv->wiphy, dev);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ unlock_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -1246,14 +1274,18 @@ static int nl80211_dump_station(struct s
 			return -EINVAL;
 	}
 
-	netdev = dev_get_by_index(&init_net, ifidx);
-	if (!netdev)
-		return -ENODEV;
+	rtnl_lock();
+
+	netdev = __dev_get_by_index(&init_net, ifidx);
+	if (!netdev) {
+		err = -ENODEV;
+		goto out_rtnl;
+	}
 
 	dev = cfg80211_get_dev_from_ifindex(ifidx);
 	if (IS_ERR(dev)) {
 		err = PTR_ERR(dev);
-		goto out_put_netdev;
+		goto out_rtnl;
 	}
 
 	if (!dev->ops->dump_station) {
@@ -1261,15 +1293,13 @@ static int nl80211_dump_station(struct s
 		goto out_err;
 	}
 
-	rtnl_lock();
-
 	while (1) {
 		err = dev->ops->dump_station(&dev->wiphy, netdev, sta_idx,
 					     mac_addr, &sinfo);
 		if (err == -ENOENT)
 			break;
 		if (err)
-			goto out_err_rtnl;
+			goto out_err;
 
 		if (nl80211_send_station(skb,
 				NETLINK_CB(cb->skb).pid,
@@ -1285,12 +1315,10 @@ static int nl80211_dump_station(struct s
  out:
 	cb->args[1] = sta_idx;
 	err = skb->len;
- out_err_rtnl:
-	rtnl_unlock();
  out_err:
 	cfg80211_put_dev(dev);
- out_put_netdev:
-	dev_put(netdev);
+ out_rtnl:
+	rtnl_unlock();
 
 	return err;
 }
@@ -1311,19 +1339,18 @@ static int nl80211_get_station(struct sk
 
 	mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto out_rtnl;
 
 	if (!drv->ops->get_station) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->get_station(&drv->wiphy, dev, mac_addr, &sinfo);
-	rtnl_unlock();
-
 	if (err)
 		goto out;
 
@@ -1340,10 +1367,12 @@ static int nl80211_get_station(struct sk
 
  out_free:
 	nlmsg_free(msg);
-
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -1411,9 +1440,11 @@ static int nl80211_set_station(struct sk
 		params.plink_action =
 		    nla_get_u8(info->attrs[NL80211_ATTR_STA_PLINK_ACTION]);
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto out_rtnl;
 
 	err = get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], drv, &params.vlan);
 	if (err)
@@ -1424,15 +1455,16 @@ static int nl80211_set_station(struct sk
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->change_station(&drv->wiphy, dev, mac_addr, &params);
-	rtnl_unlock();
 
  out:
 	if (params.vlan)
 		dev_put(params.vlan);
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -1474,9 +1506,11 @@ static int nl80211_new_station(struct sk
 				&params.station_flags))
 		return -EINVAL;
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto out_rtnl;
 
 	err = get_vlan(info->attrs[NL80211_ATTR_STA_VLAN], drv, &params.vlan);
 	if (err)
@@ -1487,15 +1521,16 @@ static int nl80211_new_station(struct sk
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->add_station(&drv->wiphy, dev, mac_addr, &params);
-	rtnl_unlock();
 
  out:
 	if (params.vlan)
 		dev_put(params.vlan);
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -1509,22 +1544,25 @@ static int nl80211_del_station(struct sk
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto out_rtnl;
 
 	if (!drv->ops->del_station) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->del_station(&drv->wiphy, dev, mac_addr);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -1605,14 +1643,18 @@ static int nl80211_dump_mpath(struct sk_
 			return -EINVAL;
 	}
 
-	netdev = dev_get_by_index(&init_net, ifidx);
-	if (!netdev)
-		return -ENODEV;
+	rtnl_lock();
+
+	netdev = __dev_get_by_index(&init_net, ifidx);
+	if (!netdev) {
+		err = -ENODEV;
+		goto out_rtnl;
+	}
 
 	dev = cfg80211_get_dev_from_ifindex(ifidx);
 	if (IS_ERR(dev)) {
 		err = PTR_ERR(dev);
-		goto out_put_netdev;
+		goto out_rtnl;
 	}
 
 	if (!dev->ops->dump_mpath) {
@@ -1620,15 +1662,13 @@ static int nl80211_dump_mpath(struct sk_
 		goto out_err;
 	}
 
-	rtnl_lock();
-
 	while (1) {
 		err = dev->ops->dump_mpath(&dev->wiphy, netdev, path_idx,
 					   dst, next_hop, &pinfo);
 		if (err == -ENOENT)
 			break;
 		if (err)
-			goto out_err_rtnl;
+			goto out_err;
 
 		if (nl80211_send_mpath(skb, NETLINK_CB(cb->skb).pid,
 				       cb->nlh->nlmsg_seq, NLM_F_MULTI,
@@ -1643,12 +1683,10 @@ static int nl80211_dump_mpath(struct sk_
  out:
 	cb->args[1] = path_idx;
 	err = skb->len;
- out_err_rtnl:
-	rtnl_unlock();
  out_err:
 	cfg80211_put_dev(dev);
- out_put_netdev:
-	dev_put(netdev);
+ out_rtnl:
+	rtnl_unlock();
 
 	return err;
 }
@@ -1670,19 +1708,18 @@ static int nl80211_get_mpath(struct sk_b
 
 	dst = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto out_rtnl;
 
 	if (!drv->ops->get_mpath) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->get_mpath(&drv->wiphy, dev, dst, next_hop, &pinfo);
-	rtnl_unlock();
-
 	if (err)
 		goto out;
 
@@ -1699,10 +1736,12 @@ static int nl80211_get_mpath(struct sk_b
 
  out_free:
 	nlmsg_free(msg);
-
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -1723,22 +1762,25 @@ static int nl80211_set_mpath(struct sk_b
 	dst = nla_data(info->attrs[NL80211_ATTR_MAC]);
 	next_hop = nla_data(info->attrs[NL80211_ATTR_MPATH_NEXT_HOP]);
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto out_rtnl;
 
 	if (!drv->ops->change_mpath) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->change_mpath(&drv->wiphy, dev, dst, next_hop);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 static int nl80211_new_mpath(struct sk_buff *skb, struct genl_info *info)
@@ -1758,22 +1800,25 @@ static int nl80211_new_mpath(struct sk_b
 	dst = nla_data(info->attrs[NL80211_ATTR_MAC]);
 	next_hop = nla_data(info->attrs[NL80211_ATTR_MPATH_NEXT_HOP]);
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto out_rtnl;
 
 	if (!drv->ops->add_mpath) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->add_mpath(&drv->wiphy, dev, dst, next_hop);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -1787,22 +1832,25 @@ static int nl80211_del_mpath(struct sk_b
 	if (info->attrs[NL80211_ATTR_MAC])
 		dst = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto out_rtnl;
 
 	if (!drv->ops->del_mpath) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->del_mpath(&drv->wiphy, dev, dst);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -1835,22 +1883,25 @@ static int nl80211_set_bss(struct sk_buf
 			nla_len(info->attrs[NL80211_ATTR_BSS_BASIC_RATES]);
 	}
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto out_rtnl;
 
 	if (!drv->ops->change_bss) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->change_bss(&drv->wiphy, dev, &params);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -1945,15 +1996,15 @@ static int nl80211_get_mesh_params(struc
 	struct nlattr *pinfoattr;
 	struct sk_buff *msg;
 
+	rtnl_lock();
+
 	/* Look up our device */
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto out_rtnl;
 
 	/* Get the mesh params */
-	rtnl_lock();
 	err = drv->ops->get_mesh_params(&drv->wiphy, dev, &cur_params);
-	rtnl_unlock();
 	if (err)
 		goto out;
 
@@ -2002,13 +2053,16 @@ static int nl80211_get_mesh_params(struc
 	err = genlmsg_unicast(msg, info->snd_pid);
 	goto out;
 
-nla_put_failure:
+ nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 	err = -EMSGSIZE;
-out:
+ out:
 	/* Cleanup */
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -2055,9 +2109,11 @@ static int nl80211_set_mesh_params(struc
 			parent_attr, nl80211_meshconf_params_policy))
 		return -EINVAL;
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto out_rtnl;
 
 	/* This makes sure that there aren't more than 32 mesh config
 	 * parameters (otherwise our bitfield scheme would not work.) */
@@ -2099,13 +2155,14 @@ static int nl80211_set_mesh_params(struc
 			nla_get_u16);
 
 	/* Apply changes */
-	rtnl_lock();
 	err = drv->ops->set_mesh_params(&drv->wiphy, dev, &cfg, mask);
-	rtnl_unlock();
 
 	/* cleanup */
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -2272,19 +2329,22 @@ static int nl80211_set_mgmt_extra_ie(str
 		params.ies_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	}
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto out_rtnl;
 
-	if (drv->ops->set_mgmt_extra_ie) {
-		rtnl_lock();
+	if (drv->ops->set_mgmt_extra_ie)
 		err = drv->ops->set_mgmt_extra_ie(&drv->wiphy, dev, &params);
-		rtnl_unlock();
-	} else
+	else
 		err = -EOPNOTSUPP;
 
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 
@@ -2301,9 +2361,11 @@ static int nl80211_trigger_scan(struct s
 	enum ieee80211_band band;
 	size_t ie_len;
 
+	rtnl_lock();
+
 	err = get_drv_dev_by_info_ifindex(info->attrs, &drv, &dev);
 	if (err)
-		return err;
+		goto out_rtnl;
 
 	wiphy = &drv->wiphy;
 
@@ -2312,11 +2374,9 @@ static int nl80211_trigger_scan(struct s
 		goto out;
 	}
 
-	rtnl_lock();
-
 	if (drv->scan_req) {
 		err = -EBUSY;
-		goto out_unlock;
+		goto out;
 	}
 
 	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
@@ -2324,7 +2384,7 @@ static int nl80211_trigger_scan(struct s
 			n_channels++;
 		if (!n_channels) {
 			err = -EINVAL;
-			goto out_unlock;
+			goto out;
 		}
 	} else {
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++)
@@ -2338,7 +2398,7 @@ static int nl80211_trigger_scan(struct s
 
 	if (n_ssids > wiphy->max_scan_ssids) {
 		err = -EINVAL;
-		goto out_unlock;
+		goto out;
 	}
 
 	if (info->attrs[NL80211_ATTR_IE])
@@ -2352,7 +2412,7 @@ static int nl80211_trigger_scan(struct s
 			+ ie_len, GFP_KERNEL);
 	if (!request) {
 		err = -ENOMEM;
-		goto out_unlock;
+		goto out;
 	}
 
 	request->channels = (void *)((char *)request + sizeof(*request));
@@ -2423,11 +2483,12 @@ static int nl80211_trigger_scan(struct s
 		drv->scan_req = NULL;
 		kfree(request);
 	}
- out_unlock:
-	rtnl_unlock();
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
+ out_rtnl:
+	rtnl_unlock();
+
 	return err;
 }
 


