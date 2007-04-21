Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbXDUJSB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2007 05:18:01 -0400
Subject: [PATCH] cfg80211/nl80211: use rtnl
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Sat, 21 Apr 2007 11:20:35 +0200
Message-Id: <1177147235.5941.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because the wext/no-rtnl patch was controversial at this time, this patch
adds rtnl locking to cfg80211 so all calls to driver/stack operations are
made with rtnl held.

Once wext compat support in cfg80211 is mature enough and cfg80211 can fully
replace wext, this will be revisited.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/cfg80211.h |    4 ++++
 net/wireless/nl80211.c |   19 +++++++++++++++++++
 net/wireless/sysfs.c   |    4 ++++
 3 files changed, 27 insertions(+)

--- wireless-dev.orig/include/net/cfg80211.h	2007-04-21 10:51:54.540655118 +0200
+++ wireless-dev/include/net/cfg80211.h	2007-04-21 10:53:18.160655118 +0200
@@ -86,6 +86,10 @@ struct wiphy;
  * All callbacks except where otherwise noted should return 0
  * on success or a negative error code.
  *
+ * All operations are currently invoked under rtnl for consistency with the
+ * wireless extensions but this is subject to reevaluation as soon as this
+ * code is used more widely and we have a first user without wext.
+ *
  * @add_virtual_intf: create a new virtual interface with the given name
  *
  * @del_virtual_intf: remove the virtual interface determined by ifindex.
--- wireless-dev.orig/net/wireless/nl80211.c	2007-04-21 10:48:26.340655118 +0200
+++ wireless-dev/net/wireless/nl80211.c	2007-04-21 11:01:02.490655118 +0200
@@ -12,6 +12,7 @@
 #include <linux/if_ether.h>
 #include <linux/ieee80211.h>
 #include <linux/nl80211.h>
+#include <linux/rtnetlink.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
 #include "core.h"
@@ -312,8 +313,10 @@ static int nl80211_add_virt_intf(struct 
 		goto unlock;
 	}
 
+	rtnl_lock();
 	err = drv->ops->add_virtual_intf(&drv->wiphy,
 		nla_data(info->attrs[NL80211_ATTR_IFNAME]), type);
+	rtnl_unlock();
 
  unlock:
 	cfg80211_put_dev(drv);
@@ -337,7 +340,9 @@ static int nl80211_del_virt_intf(struct 
 		goto out;
 	}
 
+	rtnl_lock();
 	err = drv->ops->del_virtual_intf(&drv->wiphy, ifindex);
+	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
@@ -369,7 +374,9 @@ static int nl80211_change_virt_intf(stru
 		goto unlock;
 	}
 
+	rtnl_lock();
 	err = drv->ops->change_virtual_intf(&drv->wiphy, ifindex, type);
+	rtnl_unlock();
 
  unlock:
 	cfg80211_put_dev(drv);
@@ -394,7 +401,9 @@ static int nl80211_get_association(struc
 		goto out_put_drv;
 	}
 
+	rtnl_lock();
 	err = drv->ops->get_association(&drv->wiphy, dev, bssid);
+	rtnl_unlock();
 	if (err < 0)
 		goto out_put_drv;
 
@@ -464,7 +473,9 @@ static int nl80211_associate(struct sk_b
 		assoc_params.valid |= ASSOC_PARAMS_TIMEOUT;
 	}
 
+	rtnl_lock();
 	err = drv->ops->associate(&drv->wiphy, dev, &assoc_params);
+	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
@@ -499,7 +510,9 @@ static int nl80211_disassoc_deauth(struc
 		goto out;
 	}
 
+	rtnl_lock();
 	err = act(&drv->wiphy, dev);
+	rtnl_unlock();
  out:
 	cfg80211_put_dev(drv);
 	dev_put(dev);
@@ -566,7 +579,9 @@ static int nl80211_get_auth_list(struct 
 
 	cb.skb = msg;
 	cb.idx = 1;
+	rtnl_lock();
 	err = drv->ops->get_auth_list(&drv->wiphy, dev, &cb, add_bssid);
+	rtnl_unlock();
 	if (err)
 		goto msg_free;
 
@@ -680,7 +695,9 @@ static int nl80211_initiate_scan(struct 
 	params.channels = channels;
 	params.n_channels = count;
 
+	rtnl_lock();
 	err = drv->ops->initiate_scan(&drv->wiphy, dev, &params);
+	rtnl_unlock();
 
 	kfree(channels);
  out:
@@ -769,7 +786,9 @@ static int nl80211_key_cmd(struct sk_buf
 		params.macaddress = NULL;
 	}
 
+	rtnl_lock();
 	err = act(&drv->wiphy, dev, &params);
+	rtnl_unlock();
 
  out:
 	cfg80211_put_dev(drv);
--- wireless-dev.orig/net/wireless/sysfs.c	2007-04-21 10:53:26.160655118 +0200
+++ wireless-dev/net/wireless/sysfs.c	2007-04-21 10:53:54.400655118 +0200
@@ -51,8 +51,10 @@ static ssize_t _store_add_iface(struct d
 	if (!rdev->ops->add_virtual_intf)
 		return -ENOSYS;
 
+	rtnl_lock();
 	res = rdev->ops->add_virtual_intf(&rdev->wiphy, (char*)buf,
 					  NL80211_IFTYPE_UNSPECIFIED);
+	rtnl_unlock();
 
 	return res ? res : len;
 }
@@ -77,7 +79,9 @@ static ssize_t _store_remove_iface(struc
 	ifidx = netdev->ifindex;
 	dev_put(netdev);
 
+	rtnl_lock();
 	res = rdev->ops->del_virtual_intf(&rdev->wiphy, ifidx);
+	rtnl_unlock();
 
 	return res ? res : len;
 }


