Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40432 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbXJYNWz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:22:55 -0400
Received: from [131.234.198.68]
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Il2fj-0000eD-Lc
	for linux-wireless@vger.kernel.org; Thu, 25 Oct 2007 14:22:52 +0100
Message-Id: <20071025093715.724036000@sipsolutions.net> (sfid-20071025_142300_979896_0B4936F5)
References: <20071025093618.440937000@sipsolutions.net>
Date: Thu, 25 Oct 2007 11:36:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [patch 4/9] cfg80211/nl80211: add beacon settings
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the necessary API to nl80211/cfg80211 to allow
changing beaconing settings.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/nl80211.h |   19 ++++++++
 include/net/cfg80211.h  |   27 +++++++++++
 net/wireless/nl80211.c  |  111 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 157 insertions(+)

--- linux-2.6.orig/include/net/cfg80211.h	2007-10-24 11:35:48.392690568 +0200
+++ linux-2.6/include/net/cfg80211.h	2007-10-24 11:35:50.382690568 +0200
@@ -69,6 +69,26 @@ struct key_params {
 	u32 cipher;
 };
 
+/**
+ * struct beacon_parameters - beacon parameters
+ *
+ * Used to configure the beacon for an interface.
+ *
+ * @head: head portion of beacon (before TIM IE)
+ *     or %NULL if not changed
+ * @tail: tail portion of beacon (after TIM IE)
+ *     or %NULL if not changed
+ * @interval: beacon interval or zero if not changed
+ * @dtim_period: DTIM period or zero if not changed
+ * @head_len: length of @head
+ * @tail_len: length of @tail
+ */
+struct beacon_parameters {
+	u8 *head, *tail;
+	int interval, dtim_period;
+	int head_len, tail_len;
+};
+
 /* from net/wireless.h */
 struct wiphy;
 
@@ -103,6 +123,10 @@ struct wiphy;
  *	and @key_index
  *
  * @set_default_key: set the default key on an interface
+ *
+ * @set_beacon: Set the beacon parameters for an access point mode
+ *	interface. The @info parameter can be %NULL when the beacon is
+ *	removed.
  */
 struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
@@ -122,6 +146,9 @@ struct cfg80211_ops {
 	int	(*set_default_key)(struct wiphy *wiphy,
 				   struct net_device *netdev,
 				   u8 key_index);
+
+	int	(*set_beacon)(struct wiphy *wiphy, struct net_device *dev,
+			      struct beacon_parameters *info);
 };
 
 #endif /* __NET_CFG80211_H */
--- linux-2.6.orig/include/linux/nl80211.h	2007-10-24 11:35:48.382690568 +0200
+++ linux-2.6/include/linux/nl80211.h	2007-10-24 11:35:50.392690568 +0200
@@ -47,6 +47,10 @@
  * @NL80211_CMD_DEL_KEY: delete a key identified by %NL80211_ATTR_KEY_IDX
  *	or %NL80211_ATTR_MAC.
  *
+ * @NL80211_CMD_SET_BEACON: set the beacon on an access point device using
+ *	the %NL80211_ATTR_BEACON_INTERVAL, %NL80211_ATTR_DTIM_PERIOD,
+ *	%NL80211_BEACON_HEAD and %NL80211_BEACON_TAIL attributes.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -69,6 +73,11 @@ enum nl80211_commands {
 	NL80211_CMD_NEW_KEY,
 	NL80211_CMD_DEL_KEY,
 
+	NL80211_CMD_GET_BEACON, /* ? */
+	NL80211_CMD_SET_BEACON,
+	NL80211_CMD_NEW_BEACON, /* ? */
+	NL80211_CMD_DEL_BEACON, /* ? */
+
 	/* add commands here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -101,6 +110,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_KEY_SEQ: transmit key sequence number (IV/PN) for TKIP and
  *	CCMP keys, each six bytes in little endian
  *
+ * @NL80211_ATTR_BEACON_INTERVAL: beacon interval in TU
+ * @NL80211_ATTR_DTIM_PERIOD: DTIM period for beaconing
+ * @NL80211_ATTR_BEACON_HEAD: portion of the beacon before the TIM IE
+ * @NL80211_ATTR_BEACON_TAIL: portion of the beacon after the TIM IE
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -123,6 +137,11 @@ enum nl80211_attrs {
 	NL80211_ATTR_KEY_SEQ,
 	NL80211_ATTR_KEY_DEFAULT,
 
+	NL80211_ATTR_BEACON_INTERVAL,
+	NL80211_ATTR_DTIM_PERIOD,
+	NL80211_ATTR_BEACON_HEAD,
+	NL80211_ATTR_BEACON_TAIL,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- linux-2.6.orig/net/wireless/nl80211.c	2007-10-24 11:35:48.392690568 +0200
+++ linux-2.6/net/wireless/nl80211.c	2007-10-24 11:35:50.392690568 +0200
@@ -69,6 +69,13 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_KEY_IDX] = { .type = NLA_U8 },
 	[NL80211_ATTR_KEY_CIPHER] = { .type = NLA_U32 },
 	[NL80211_ATTR_KEY_DEFAULT] = { .type = NLA_FLAG },
+
+	[NL80211_ATTR_BEACON_INTERVAL] = { .type = NLA_U32 },
+	[NL80211_ATTR_DTIM_PERIOD] = { .type = NLA_U32 },
+	[NL80211_ATTR_BEACON_HEAD] = { .type = NLA_BINARY,
+				       .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_BEACON_TAIL] = { .type = NLA_BINARY,
+				       .len = IEEE80211_MAX_DATA_LEN },
 };
 
 /* message building helper */
@@ -600,6 +607,91 @@ static int nl80211_del_key(struct sk_buf
 	return err;
 }
 
+static int nl80211_set_beacon(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	struct beacon_parameters params;
+	int haveinfo = 0;
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->set_beacon) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	memset(&params, 0, sizeof(params));
+
+	if (info->attrs[NL80211_ATTR_BEACON_INTERVAL]) {
+		params.interval =
+		    nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
+		haveinfo = 1;
+	}
+
+	if (info->attrs[NL80211_ATTR_DTIM_PERIOD]) {
+		params.dtim_period =
+		    nla_get_u32(info->attrs[NL80211_ATTR_DTIM_PERIOD]);
+		haveinfo = 1;
+	}
+
+	if (info->attrs[NL80211_ATTR_BEACON_HEAD]) {
+		params.head = nla_data(info->attrs[NL80211_ATTR_BEACON_HEAD]);
+		params.head_len =
+		    nla_len(info->attrs[NL80211_ATTR_BEACON_HEAD]);
+		haveinfo = 1;
+	}
+
+	if (info->attrs[NL80211_ATTR_BEACON_TAIL]) {
+		params.tail = nla_data(info->attrs[NL80211_ATTR_BEACON_TAIL]);
+		params.tail_len =
+		    nla_len(info->attrs[NL80211_ATTR_BEACON_TAIL]);
+		haveinfo = 1;
+	}
+
+	if (!haveinfo) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	rtnl_lock();
+	err = drv->ops->set_beacon(&drv->wiphy, dev, &params);
+	rtnl_unlock();
+
+ out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_del_beacon(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->set_beacon) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	rtnl_lock();
+	err = drv->ops->set_beacon(&drv->wiphy, dev, NULL);
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
 		.cmd = NL80211_CMD_GET_WIPHY,
@@ -663,6 +755,25 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_BEACON,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.doit = nl80211_set_beacon,
+	},
+	{
+		.cmd = NL80211_CMD_NEW_BEACON,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		/* really the same right now */
+		.doit = nl80211_set_beacon,
+	},
+	{
+		.cmd = NL80211_CMD_DEL_BEACON,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.doit = nl80211_del_beacon,
+	},
 };
 
 /* multicast groups */

-- 

