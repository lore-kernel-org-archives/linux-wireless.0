Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59724 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbZGGCAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 22:00:17 -0400
Message-Id: <20090707015708.828089769@sipsolutions.net>
References: <20090707015604.369008211@sipsolutions.net>
Date: Tue, 07 Jul 2009 03:56:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/9] cfg80211: properly name driver locking
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently we call that cfg80211_put_dev(), but that is
misleading. With the new convention of using 'rdev' for
registered_device variables, also call that function
cfg80211_unlock_rdev().

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c    |    6 ---
 net/wireless/core.h    |    8 +++--
 net/wireless/nl80211.c |   74 ++++++++++++++++++++++++-------------------------
 net/wireless/scan.c    |    6 +--
 4 files changed, 45 insertions(+), 49 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2009-07-07 03:37:03.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-07-07 03:37:05.000000000 +0200
@@ -171,12 +171,6 @@ cfg80211_get_dev_from_ifindex(int ifinde
 	return drv;
 }
 
-void cfg80211_put_dev(struct cfg80211_registered_device *drv)
-{
-	BUG_ON(IS_ERR(drv));
-	mutex_unlock(&drv->mtx);
-}
-
 /* requires cfg80211_mutex to be held */
 int cfg80211_dev_rename(struct cfg80211_registered_device *rdev,
 			char *newname)
--- wireless-testing.orig/net/wireless/core.h	2009-07-07 03:36:58.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-07-07 03:37:05.000000000 +0200
@@ -146,7 +146,7 @@ __cfg80211_drv_from_info(struct genl_inf
  * If successful, it returns non-NULL and also locks
  * the driver's mutex!
  *
- * This means that you need to call cfg80211_put_dev()
+ * This means that you need to call cfg80211_unlock_rdev()
  * before being allowed to acquire &cfg80211_mutex!
  *
  * This is necessary because we need to lock the global
@@ -170,7 +170,11 @@ struct wiphy *wiphy_idx_to_wiphy(int wip
 extern struct cfg80211_registered_device *
 cfg80211_get_dev_from_ifindex(int ifindex);
 
-extern void cfg80211_put_dev(struct cfg80211_registered_device *drv);
+static inline void cfg80211_unlock_rdev(struct cfg80211_registered_device *drv)
+{
+	BUG_ON(IS_ERR(drv) || !drv);
+	mutex_unlock(&drv->mtx);
+}
 
 /* free object */
 extern void cfg80211_dev_free(struct cfg80211_registered_device *drv);
--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-07 03:36:58.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-07 03:37:05.000000000 +0200
@@ -411,14 +411,14 @@ static int nl80211_get_wiphy(struct sk_b
 	if (nl80211_send_wiphy(msg, info->snd_pid, info->snd_seq, 0, dev) < 0)
 		goto out_free;
 
-	cfg80211_put_dev(dev);
+	cfg80211_unlock_rdev(dev);
 
 	return genlmsg_unicast(msg, info->snd_pid);
 
  out_free:
 	nlmsg_free(msg);
  out_err:
-	cfg80211_put_dev(dev);
+	cfg80211_unlock_rdev(dev);
 	return -ENOBUFS;
 }
 
@@ -737,7 +737,7 @@ static int nl80211_get_interface(struct 
 		goto out_free;
 
 	dev_put(netdev);
-	cfg80211_put_dev(dev);
+	cfg80211_unlock_rdev(dev);
 
 	return genlmsg_unicast(msg, info->snd_pid);
 
@@ -745,7 +745,7 @@ static int nl80211_get_interface(struct 
 	nlmsg_free(msg);
  out_err:
 	dev_put(netdev);
-	cfg80211_put_dev(dev);
+	cfg80211_unlock_rdev(dev);
 	return -ENOBUFS;
 }
 
@@ -853,7 +853,7 @@ static int nl80211_set_interface(struct 
 
  unlock:
 	dev_put(dev);
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
  unlock_rtnl:
 	rtnl_unlock();
 	return err;
@@ -906,7 +906,7 @@ static int nl80211_new_interface(struct 
 		type, err ? NULL : &flags, &params);
 
  unlock:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
  unlock_rtnl:
 	rtnl_unlock();
 	return err;
@@ -934,7 +934,7 @@ static int nl80211_del_interface(struct 
 	err = drv->ops->del_virtual_intf(&drv->wiphy, ifindex);
 
  out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
  unlock_rtnl:
 	rtnl_unlock();
 	return err;
@@ -1037,7 +1037,7 @@ static int nl80211_get_key(struct sk_buf
 	err = -ENOBUFS;
 	nlmsg_free(msg);
  out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  unlock_rtnl:
 	rtnl_unlock();
@@ -1097,7 +1097,7 @@ static int nl80211_set_key(struct sk_buf
 #endif
 
  out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
 
  unlock_rtnl:
@@ -1163,7 +1163,7 @@ static int nl80211_new_key(struct sk_buf
 	err = drv->ops->add_key(&drv->wiphy, dev, key_idx, mac_addr, &params);
 
  out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  unlock_rtnl:
 	rtnl_unlock();
@@ -1211,7 +1211,7 @@ static int nl80211_del_key(struct sk_buf
 #endif
 
  out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
 
  unlock_rtnl:
@@ -1306,7 +1306,7 @@ static int nl80211_addset_beacon(struct 
 	err = call(&drv->wiphy, dev, &params);
 
  out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  unlock_rtnl:
 	rtnl_unlock();
@@ -1338,7 +1338,7 @@ static int nl80211_del_beacon(struct sk_
 	err = drv->ops->del_beacon(&drv->wiphy, dev);
 
  out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  unlock_rtnl:
 	rtnl_unlock();
@@ -1572,7 +1572,7 @@ static int nl80211_dump_station(struct s
 	cb->args[1] = sta_idx;
 	err = skb->len;
  out_err:
-	cfg80211_put_dev(dev);
+	cfg80211_unlock_rdev(dev);
  out_rtnl:
 	rtnl_unlock();
 
@@ -1624,7 +1624,7 @@ static int nl80211_get_station(struct sk
  out_free:
 	nlmsg_free(msg);
  out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -1760,7 +1760,7 @@ static int nl80211_set_station(struct sk
  out:
 	if (params.vlan)
 		dev_put(params.vlan);
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -1865,7 +1865,7 @@ static int nl80211_new_station(struct sk
  out:
 	if (params.vlan)
 		dev_put(params.vlan);
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -1904,7 +1904,7 @@ static int nl80211_del_station(struct sk
 	err = drv->ops->del_station(&drv->wiphy, dev, mac_addr);
 
  out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2035,7 +2035,7 @@ static int nl80211_dump_mpath(struct sk_
 	cb->args[1] = path_idx;
 	err = skb->len;
  out_err:
-	cfg80211_put_dev(dev);
+	cfg80211_unlock_rdev(dev);
  out_rtnl:
 	rtnl_unlock();
 
@@ -2093,7 +2093,7 @@ static int nl80211_get_mpath(struct sk_b
  out_free:
 	nlmsg_free(msg);
  out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2142,7 +2142,7 @@ static int nl80211_set_mpath(struct sk_b
 	err = drv->ops->change_mpath(&drv->wiphy, dev, dst, next_hop);
 
  out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2190,7 +2190,7 @@ static int nl80211_new_mpath(struct sk_b
 	err = drv->ops->add_mpath(&drv->wiphy, dev, dst, next_hop);
 
  out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2222,7 +2222,7 @@ static int nl80211_del_mpath(struct sk_b
 	err = drv->ops->del_mpath(&drv->wiphy, dev, dst);
 
  out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2278,7 +2278,7 @@ static int nl80211_set_bss(struct sk_buf
 	err = drv->ops->change_bss(&drv->wiphy, dev, &params);
 
  out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2444,7 +2444,7 @@ static int nl80211_get_mesh_params(struc
 	err = -EMSGSIZE;
  out:
 	/* Cleanup */
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2550,7 +2550,7 @@ static int nl80211_set_mesh_params(struc
 
  out:
 	/* cleanup */
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -2890,7 +2890,7 @@ static int nl80211_trigger_scan(struct s
 		kfree(request);
 	}
  out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
  out_rtnl:
 	rtnl_unlock();
@@ -3007,7 +3007,7 @@ static int nl80211_dump_scan(struct sk_b
 
 	cb->args[1] = idx;
 	err = skb->len;
-	cfg80211_put_dev(dev);
+	cfg80211_unlock_rdev(dev);
  out_put_netdev:
 	dev_put(netdev);
 
@@ -3112,7 +3112,7 @@ static int nl80211_authenticate(struct s
 				 ssid, ssid_len, ie, ie_len);
 
 out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
@@ -3259,7 +3259,7 @@ static int nl80211_associate(struct sk_b
 					  &crypto);
 
 out:
-	cfg80211_put_dev(rdev);
+	cfg80211_unlock_rdev(rdev);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
@@ -3321,7 +3321,7 @@ static int nl80211_deauthenticate(struct
 	err = cfg80211_mlme_deauth(drv, dev, bssid, ie, ie_len, reason_code);
 
 out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
@@ -3383,7 +3383,7 @@ static int nl80211_disassociate(struct s
 	err = cfg80211_mlme_disassoc(drv, dev, bssid, ie, ie_len, reason_code);
 
 out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
@@ -3464,7 +3464,7 @@ static int nl80211_join_ibss(struct sk_b
 	err = cfg80211_join_ibss(drv, dev, &ibss);
 
 out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
@@ -3501,7 +3501,7 @@ static int nl80211_leave_ibss(struct sk_
 	err = cfg80211_leave_ibss(drv, dev, false);
 
 out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
@@ -3538,7 +3538,7 @@ static int nl80211_testmode_do(struct sk
 		rdev->testmode_info = NULL;
 	}
 
-	cfg80211_put_dev(rdev);
+	cfg80211_unlock_rdev(rdev);
 
  unlock_rtnl:
 	rtnl_unlock();
@@ -3707,7 +3707,7 @@ static int nl80211_connect(struct sk_buf
 	err = cfg80211_connect(drv, dev, &connect);
 
 out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
@@ -3748,7 +3748,7 @@ static int nl80211_disconnect(struct sk_
 	err = cfg80211_disconnect(drv, dev, reason, true);
 
 out:
-	cfg80211_put_dev(drv);
+	cfg80211_unlock_rdev(drv);
 	dev_put(dev);
 unlock_rtnl:
 	rtnl_unlock();
--- wireless-testing.orig/net/wireless/scan.c	2009-07-07 03:29:39.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-07-07 03:37:05.000000000 +0200
@@ -28,8 +28,6 @@ void cfg80211_scan_done(struct cfg80211_
 	if (!dev)
 		goto out;
 
-	WARN_ON(request != wiphy_to_dev(request->wiphy)->scan_req);
-
 	/*
 	 * This must be before sending the other events!
 	 * Otherwise, wpa_supplicant gets completely confused with
@@ -636,7 +634,7 @@ int cfg80211_wext_siwscan(struct net_dev
 	} else
 		nl80211_send_scan_start(rdev, dev);
  out:
-	cfg80211_put_dev(rdev);
+	cfg80211_unlock_rdev(rdev);
 	return err;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_siwscan);
@@ -945,7 +943,7 @@ int cfg80211_wext_giwscan(struct net_dev
 	}
 
  out:
-	cfg80211_put_dev(rdev);
+	cfg80211_unlock_rdev(rdev);
 	return res;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_giwscan);

-- 

