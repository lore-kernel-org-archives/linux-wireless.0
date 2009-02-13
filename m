Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbZBMJWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 04:22:49 -0500
Subject: [PATCH] nl80211: lock rtnl around all operations
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 13 Feb 2009 10:22:34 +0100
Message-Id: <1234516954.4219.1.camel@johannes.local> (sfid-20090213_102256_605593_791B9E08)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All operations used to take the rtnl lock inside the other locks,
like this:

	cfg80211_mutex  -->  drv->mutex  -->  rtnl

(cfg80211_mutex is possibly dropped after drv->mutex is locked)

wext, however, locks around everything:

	rtnl  -->  cfg80211_mutex  -->  drv->mutex

which clearly isn't a good idea, and also makes lockdep warn which
Reinette reported.

Since we cannot change wext, and don't really want to, this patch
changes the lock order in nl80211 to be the same as in wext. To do
this, it uses the new pre_doit/pre_dumpit calls.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Doesn't seem to conflict with Luis's patches for me.

 net/wireless/nl80211.c |   94 +++++++++++++++----------------------------------
 1 file changed, 30 insertions(+), 64 deletions(-)

--- wireless-testing.orig/net/wireless/nl80211.c	2009-02-13 10:10:25.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2009-02-13 10:10:27.000000000 +0100
@@ -20,6 +20,23 @@
 #include "nl80211.h"
 #include "reg.h"
 
+static int nl80211_lock_doit(struct sk_buff *skb, struct genl_info *info)
+{
+	rtnl_lock();
+	return 0;
+}
+
+static int nl80211_lock_dumpit(void)
+{
+	rtnl_lock();
+	return 0;
+}
+
+static void nl80211_unlock(void)
+{
+	rtnl_unlock();
+}
+
 /* the netlink family */
 static struct genl_family nl80211_fam = {
 	.id = GENL_ID_GENERATE,	/* don't bother with a hardcoded ID */
@@ -27,6 +44,10 @@ static struct genl_family nl80211_fam = 
 	.hdrsize = 0,		/* no private header */
 	.version = 1,		/* no particular meaning now */
 	.maxattr = NL80211_ATTR_MAX,
+	.pre_doit = nl80211_lock_doit,
+	.pre_dumpit = nl80211_lock_dumpit,
+	.post_doit = nl80211_unlock,
+	.post_dumpit = nl80211_unlock,
 };
 
 /* internal helper: get drv and dev */
@@ -616,15 +637,13 @@ static int nl80211_set_interface(struct 
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
 	return err;
@@ -665,15 +684,12 @@ static int nl80211_new_interface(struct 
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
@@ -697,9 +713,7 @@ static int nl80211_del_interface(struct 
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->del_virtual_intf(&drv->wiphy, ifindex);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
@@ -784,10 +798,8 @@ static int nl80211_get_key(struct sk_buf
 	if (mac_addr)
 		NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
 
-	rtnl_lock();
 	err = drv->ops->get_key(&drv->wiphy, dev, key_idx, mac_addr,
 				&cookie, get_key_callback);
-	rtnl_unlock();
 
 	if (err)
 		goto out;
@@ -847,9 +859,7 @@ static int nl80211_set_key(struct sk_buf
 		goto out;
 	}
 
-	rtnl_lock();
 	err = func(&drv->wiphy, dev, key_idx);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
@@ -932,9 +942,7 @@ static int nl80211_new_key(struct sk_buf
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->add_key(&drv->wiphy, dev, key_idx, mac_addr, &params);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
@@ -968,9 +976,7 @@ static int nl80211_del_key(struct sk_buf
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->del_key(&drv->wiphy, dev, key_idx, mac_addr);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
@@ -1051,9 +1057,7 @@ static int nl80211_addset_beacon(struct 
 		goto out;
 	}
 
-	rtnl_lock();
 	err = call(&drv->wiphy, dev, &params);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
@@ -1076,9 +1080,7 @@ static int nl80211_del_beacon(struct sk_
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->del_beacon(&drv->wiphy, dev);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
@@ -1257,15 +1259,13 @@ static int nl80211_dump_station(struct s
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
@@ -1281,8 +1281,6 @@ static int nl80211_dump_station(struct s
  out:
 	cb->args[1] = sta_idx;
 	err = skb->len;
- out_err_rtnl:
-	rtnl_unlock();
  out_err:
 	cfg80211_put_dev(dev);
  out_put_netdev:
@@ -1316,9 +1314,7 @@ static int nl80211_get_station(struct sk
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->get_station(&drv->wiphy, dev, mac_addr, &sinfo);
-	rtnl_unlock();
 
 	if (err)
 		goto out;
@@ -1420,9 +1416,7 @@ static int nl80211_set_station(struct sk
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->change_station(&drv->wiphy, dev, mac_addr, &params);
-	rtnl_unlock();
 
  out:
 	if (params.vlan)
@@ -1483,9 +1477,7 @@ static int nl80211_new_station(struct sk
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->add_station(&drv->wiphy, dev, mac_addr, &params);
-	rtnl_unlock();
 
  out:
 	if (params.vlan)
@@ -1514,9 +1506,7 @@ static int nl80211_del_station(struct sk
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->del_station(&drv->wiphy, dev, mac_addr);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
@@ -1616,15 +1606,13 @@ static int nl80211_dump_mpath(struct sk_
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
@@ -1639,8 +1627,6 @@ static int nl80211_dump_mpath(struct sk_
  out:
 	cb->args[1] = path_idx;
 	err = skb->len;
- out_err_rtnl:
-	rtnl_unlock();
  out_err:
 	cfg80211_put_dev(dev);
  out_put_netdev:
@@ -1675,9 +1661,7 @@ static int nl80211_get_mpath(struct sk_b
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->get_mpath(&drv->wiphy, dev, dst, next_hop, &pinfo);
-	rtnl_unlock();
 
 	if (err)
 		goto out;
@@ -1728,9 +1712,7 @@ static int nl80211_set_mpath(struct sk_b
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->change_mpath(&drv->wiphy, dev, dst, next_hop);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
@@ -1763,9 +1745,7 @@ static int nl80211_new_mpath(struct sk_b
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->add_mpath(&drv->wiphy, dev, dst, next_hop);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
@@ -1792,9 +1772,7 @@ static int nl80211_del_mpath(struct sk_b
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->del_mpath(&drv->wiphy, dev, dst);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
@@ -1840,9 +1818,7 @@ static int nl80211_set_bss(struct sk_buf
 		goto out;
 	}
 
-	rtnl_lock();
 	err = drv->ops->change_bss(&drv->wiphy, dev, &params);
-	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
@@ -1933,9 +1909,7 @@ static int nl80211_get_mesh_params(struc
 		return err;
 
 	/* Get the mesh params */
-	rtnl_lock();
 	err = drv->ops->get_mesh_params(&drv->wiphy, dev, &cur_params);
-	rtnl_unlock();
 	if (err)
 		goto out;
 
@@ -2081,9 +2055,7 @@ static int nl80211_set_mesh_params(struc
 			nla_get_u16);
 
 	/* Apply changes */
-	rtnl_lock();
 	err = drv->ops->set_mesh_params(&drv->wiphy, dev, &cfg, mask);
-	rtnl_unlock();
 
 	/* cleanup */
 	cfg80211_put_dev(drv);
@@ -2258,11 +2230,9 @@ static int nl80211_set_mgmt_extra_ie(str
 	if (err)
 		return err;
 
-	if (drv->ops->set_mgmt_extra_ie) {
-		rtnl_lock();
+	if (drv->ops->set_mgmt_extra_ie)
 		err = drv->ops->set_mgmt_extra_ie(&drv->wiphy, dev, &params);
-		rtnl_unlock();
-	} else
+	else
 		err = -EOPNOTSUPP;
 
 	cfg80211_put_dev(drv);
@@ -2293,11 +2263,9 @@ static int nl80211_trigger_scan(struct s
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
@@ -2305,7 +2273,7 @@ static int nl80211_trigger_scan(struct s
 			n_channels++;
 		if (!n_channels) {
 			err = -EINVAL;
-			goto out_unlock;
+			goto out;
 		}
 	} else {
 		for (band = 0; band < IEEE80211_NUM_BANDS; band++)
@@ -2319,7 +2287,7 @@ static int nl80211_trigger_scan(struct s
 
 	if (n_ssids > wiphy->max_scan_ssids) {
 		err = -EINVAL;
-		goto out_unlock;
+		goto out;
 	}
 
 	request = kzalloc(sizeof(*request)
@@ -2327,7 +2295,7 @@ static int nl80211_trigger_scan(struct s
 			+ sizeof(channel) * n_channels, GFP_KERNEL);
 	if (!request) {
 		err = -ENOMEM;
-		goto out_unlock;
+		goto out;
 	}
 
 	request->channels = (void *)((char *)request + sizeof(*request));
@@ -2386,8 +2354,6 @@ static int nl80211_trigger_scan(struct s
 		drv->scan_req = NULL;
 		kfree(request);
 	}
- out_unlock:
-	rtnl_unlock();
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);


