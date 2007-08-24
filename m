Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbXHXMbu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 08:31:50 -0400
Message-Id: <20070824122909.925191000@sipsolutions.net>
References: <20070824122705.549190000@sipsolutions.net>
Date: Fri, 24 Aug 2007 14:27:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/15] cfg80211: add hook for changing default key index
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This introduces a new nl80211 command for setting the default
key index on an interface.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/nl80211.h |    3 +++
 include/net/cfg80211.h  |    3 +++
 net/wireless/core.c     |    4 ++--
 net/wireless/nl80211.c  |   41 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 49 insertions(+), 2 deletions(-)

--- wireless-dev.orig/include/linux/nl80211.h	2007-08-24 13:02:58.569420431 +0200
+++ wireless-dev/include/linux/nl80211.h	2007-08-24 13:03:00.549420431 +0200
@@ -45,6 +45,7 @@
  * @NL80211_CMD_ADD_KEY: add a key with given %NL80211_ATTR_KEY_DATA,
  *	%NL80211_ATTR_KEY_IDX, %NL80211_ATTR_MAC and %NL80211_ATTR_KEY_CIPHER
  *	attributes.
+ * @NL80211_SET_DEFAULT_KEY: set the default key index
  * @NL80211_CMD_DEL_KEY: delete a key identified by %NL80211_ATTR_KEY_IDX
  *	or %NL80211_ATTR_MAC.
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -89,6 +90,8 @@ enum nl80211_commands {
 	NL80211_CMD_ADD_KEY,
 	/* %input: ifindex, key_idx|mac */
 	NL80211_CMD_DEL_KEY,
+	/* %input: ifindex, key_idx */
+	NL80211_CMD_SET_DEFAULT_KEY,
 
 	/* add commands here */
 
--- wireless-dev.orig/include/net/cfg80211.h	2007-08-24 13:02:58.569420431 +0200
+++ wireless-dev/include/net/cfg80211.h	2007-08-24 13:03:00.559420431 +0200
@@ -159,6 +159,7 @@ struct wiphy;
  *		   is to be passed to that callback
  * @add_key: add a key using &struct key_params
  * @del_key: delete a key using info from &struct key_params
+ * @set_default_key: set default key index (0..3)
  */
 struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
@@ -188,6 +189,8 @@ struct cfg80211_ops {
 			   struct key_params *params);
 	int	(*del_key)(struct wiphy *wiphy, struct net_device *dev,
 			   struct key_params *params);
+	int	(*set_default_key)(struct wiphy *wiphy, struct net_device *dev,
+				   u8 key_idx);
 };
 
 
--- wireless-dev.orig/net/wireless/nl80211.c	2007-08-24 13:02:58.569420431 +0200
+++ wireless-dev/net/wireless/nl80211.c	2007-08-24 13:03:00.559420431 +0200
@@ -153,6 +153,7 @@ static int nl80211_get_cmdlist(struct sk
 	CHECK_CMD(get_auth_list, GET_AUTH_LIST);
 	CHECK_CMD(add_key, ADD_KEY);
 	CHECK_CMD(del_key, DEL_KEY);
+	CHECK_CMD(set_default_key, SET_DEFAULT_KEY);
 
 	nla_nest_end(msg, start);
 
@@ -851,6 +852,40 @@ static int nl80211_del_key(struct sk_buf
 	return err;
 }
 
+static int nl80211_set_default_key(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	u8 key_idx;
+
+	if (!info->attrs[NL80211_ATTR_KEY_IDX])
+		return -EINVAL;
+
+	key_idx = nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
+
+	if (key_idx > 3)
+		return -EINVAL;
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->set_default_key) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	rtnl_lock();
+	err = drv->ops->set_default_key(&drv->wiphy, dev, key_idx);
+	rtnl_unlock();
+
+ out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+
 static struct genl_ops nl80211_ops[] = {
 	{
 		.cmd = NL80211_CMD_RENAME_WIPHY,
@@ -969,6 +1004,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_DEFAULT_KEY,
+		.doit = nl80211_set_default_key,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 
--- wireless-dev.orig/net/wireless/core.c	2007-08-24 13:02:58.579420431 +0200
+++ wireless-dev/net/wireless/core.c	2007-08-24 13:03:00.559420431 +0200
@@ -213,8 +213,8 @@ struct wiphy *wiphy_new(struct cfg80211_
 	drv->ops = ops;
 	drv->alive = 0;
 
-	WARN_ON(!ops->add_key && ops->del_key);
-	WARN_ON(ops->add_key && !ops->del_key);
+	WARN_ON(!ops->add_key && (ops->del_key || ops->set_default_key));
+	WARN_ON(ops->add_key && !(ops->del_key && ops->set_default_key));
 
 	mutex_lock(&cfg80211_drv_mutex);
 	idr_pre_get(&cfg80211_drivers, GFP_KERNEL);

-- 

