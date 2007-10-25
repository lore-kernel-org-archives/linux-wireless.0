Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40409 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbXJYNW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:22:27 -0400
Received: from [131.234.198.68]
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Il2fJ-0000ch-MP
	for linux-wireless@vger.kernel.org; Thu, 25 Oct 2007 14:22:25 +0100
Message-Id: <20071025093714.132105000@sipsolutions.net> (sfid-20071025_142234_657603_EDAEFCF8)
References: <20071025093618.440937000@sipsolutions.net>
Date: Thu, 25 Oct 2007 11:36:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [patch 1/9] cfg80211/nl80211: introduce key handling
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This introduces key handling to cfg80211/nl80211. Default
and group keys can be added, changed and removed; sequence
counters for each key can be retrieved.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/nl80211.h |   34 +++++
 include/net/cfg80211.h  |   44 +++++++
 net/wireless/core.c     |    3 
 net/wireless/nl80211.c  |  289 ++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 370 insertions(+)

--- linux-2.6.orig/include/linux/nl80211.h	2007-10-24 11:32:36.392690568 +0200
+++ linux-2.6/include/linux/nl80211.h	2007-10-24 11:35:48.382690568 +0200
@@ -37,6 +37,16 @@
  *	userspace to request deletion of a virtual interface, then requires
  *	attribute %NL80211_ATTR_IFINDEX.
  *
+ * @NL80211_CMD_GET_KEY: Get sequence counter information for a key specified
+ *	by %NL80211_ATTR_KEY_IDX and/or %NL80211_ATTR_MAC.
+ * @NL80211_CMD_SET_KEY: Set key attributes %NL80211_ATTR_KEY_DEFAULT or
+ *	%NL80211_ATTR_KEY_THRESHOLD.
+ * @NL80211_CMD_NEW_KEY: add a key with given %NL80211_ATTR_KEY_DATA,
+ *	%NL80211_ATTR_KEY_IDX, %NL80211_ATTR_MAC and %NL80211_ATTR_KEY_CIPHER
+ *	attributes.
+ * @NL80211_CMD_DEL_KEY: delete a key identified by %NL80211_ATTR_KEY_IDX
+ *	or %NL80211_ATTR_MAC.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -54,6 +64,11 @@ enum nl80211_commands {
 	NL80211_CMD_NEW_INTERFACE,
 	NL80211_CMD_DEL_INTERFACE,
 
+	NL80211_CMD_GET_KEY,
+	NL80211_CMD_SET_KEY,
+	NL80211_CMD_NEW_KEY,
+	NL80211_CMD_DEL_KEY,
+
 	/* add commands here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -75,6 +90,17 @@ enum nl80211_commands {
  * @NL80211_ATTR_IFNAME: network interface name
  * @NL80211_ATTR_IFTYPE: type of virtual interface, see &enum nl80211_iftype
  *
+ * @NL80211_ATTR_MAC: MAC address (various uses)
+ *
+ * @NL80211_ATTR_KEY_DATA: (temporal) key data; for TKIP this consists of
+ *	16 bytes encryption key followed by 8 bytes each for TX and RX MIC
+ *	keys
+ * @NL80211_ATTR_KEY_IDX: key ID (u8, 0-3)
+ * @NL80211_ATTR_KEY_CIPHER: key cipher suite (u32, as defined by IEEE 802.11
+ *	section 7.3.2.25.1, e.g. 0x000FAC04)
+ * @NL80211_ATTR_KEY_SEQ: transmit key sequence number (IV/PN) for TKIP and
+ *	CCMP keys, each six bytes in little endian
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -89,6 +115,14 @@ enum nl80211_attrs {
 	NL80211_ATTR_IFNAME,
 	NL80211_ATTR_IFTYPE,
 
+	NL80211_ATTR_MAC,
+
+	NL80211_ATTR_KEY_DATA,
+	NL80211_ATTR_KEY_IDX,
+	NL80211_ATTR_KEY_CIPHER,
+	NL80211_ATTR_KEY_SEQ,
+	NL80211_ATTR_KEY_DEFAULT,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
--- linux-2.6.orig/net/wireless/nl80211.c	2007-10-24 11:32:36.442690568 +0200
+++ linux-2.6/net/wireless/nl80211.c	2007-10-24 11:35:48.392690568 +0200
@@ -61,6 +61,14 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFNAME] = { .type = NLA_NUL_STRING, .len = IFNAMSIZ-1 },
+
+	[NL80211_ATTR_MAC] = { .type = NLA_BINARY, .len = ETH_ALEN },
+
+	[NL80211_ATTR_KEY_DATA] = { .type = NLA_BINARY,
+				    .len = WLAN_MAX_KEY_LEN },
+	[NL80211_ATTR_KEY_IDX] = { .type = NLA_U8 },
+	[NL80211_ATTR_KEY_CIPHER] = { .type = NLA_U32 },
+	[NL80211_ATTR_KEY_DEFAULT] = { .type = NLA_FLAG },
 };
 
 /* message building helper */
@@ -335,6 +343,263 @@ static int nl80211_del_interface(struct 
 	return err;
 }
 
+struct get_key_cookie {
+	struct sk_buff *msg;
+	int error;
+};
+
+static void get_key_callback(void *c, struct key_params *params)
+{
+	struct get_key_cookie *cookie = c;
+
+	if (params->key)
+		NLA_PUT(cookie->msg, NL80211_ATTR_KEY_DATA,
+			params->key_len, params->key);
+
+	if (params->seq)
+		NLA_PUT(cookie->msg, NL80211_ATTR_KEY_SEQ,
+			params->seq_len, params->seq);
+
+	if (params->cipher)
+		NLA_PUT_U32(cookie->msg, NL80211_ATTR_KEY_CIPHER,
+			    params->cipher);
+
+	return;
+ nla_put_failure:
+	cookie->error = 1;
+}
+
+static int nl80211_get_key(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	u8 key_idx = 0;
+	u8 *mac_addr = NULL;
+	struct get_key_cookie cookie = {
+		.error = 0,
+	};
+	void *hdr;
+	struct sk_buff *msg;
+
+	if (info->attrs[NL80211_ATTR_KEY_IDX])
+		key_idx = nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
+
+	if (key_idx > 3)
+		return -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->get_key) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	hdr = nl80211hdr_put(msg, info->snd_pid, info->snd_seq, 0,
+			     NL80211_CMD_NEW_KEY);
+
+	if (IS_ERR(hdr)) {
+		err = PTR_ERR(hdr);
+		goto out;
+	}
+
+	cookie.msg = msg;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+	NLA_PUT_U8(msg, NL80211_ATTR_KEY_IDX, key_idx);
+	if (mac_addr)
+		NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
+
+	rtnl_lock();
+	err = drv->ops->get_key(&drv->wiphy, dev, key_idx, mac_addr,
+				&cookie, get_key_callback);
+	rtnl_unlock();
+
+	if (err)
+		goto out;
+
+	if (cookie.error)
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+	err = genlmsg_unicast(msg, info->snd_pid);
+	goto out;
+
+ nla_put_failure:
+	err = -ENOBUFS;
+	nlmsg_free(msg);
+ out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_set_key(struct sk_buff *skb, struct genl_info *info)
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
+	/* currently only support setting default key */
+	if (!info->attrs[NL80211_ATTR_KEY_DEFAULT])
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
+static int nl80211_new_key(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	struct key_params params;
+	u8 key_idx = 0;
+	u8 *mac_addr = NULL;
+
+	memset(&params, 0, sizeof(params));
+
+	if (!info->attrs[NL80211_ATTR_KEY_CIPHER])
+		return -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_KEY_DATA]) {
+		params.key = nla_data(info->attrs[NL80211_ATTR_KEY_DATA]);
+		params.key_len = nla_len(info->attrs[NL80211_ATTR_KEY_DATA]);
+	}
+
+	if (info->attrs[NL80211_ATTR_KEY_IDX])
+		key_idx = nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
+
+	params.cipher = nla_get_u32(info->attrs[NL80211_ATTR_KEY_CIPHER]);
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (key_idx > 3)
+		return -EINVAL;
+
+	/*
+	 * Disallow pairwise keys with non-zero index unless it's WEP
+	 * (because current deployments use pairwise WEP keys with
+	 * non-zero indizes but 802.11i clearly specifies to use zero)
+	 */
+	if (mac_addr && key_idx &&
+	    params.cipher != WLAN_CIPHER_SUITE_WEP40 &&
+	    params.cipher != WLAN_CIPHER_SUITE_WEP104)
+		return -EINVAL;
+
+	/* TODO: add definitions for the lengths to linux/ieee80211.h */
+	switch (params.cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+		if (params.key_len != 5)
+			return -EINVAL;
+		break;
+	case WLAN_CIPHER_SUITE_TKIP:
+		if (params.key_len != 32)
+			return -EINVAL;
+		break;
+	case WLAN_CIPHER_SUITE_CCMP:
+		if (params.key_len != 16)
+			return -EINVAL;
+		break;
+	case WLAN_CIPHER_SUITE_WEP104:
+		if (params.key_len != 13)
+			return -EINVAL;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->add_key) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	rtnl_lock();
+	err = drv->ops->add_key(&drv->wiphy, dev, key_idx, mac_addr, &params);
+	rtnl_unlock();
+
+ out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
+
+static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	u8 key_idx = 0;
+	u8 *mac_addr = NULL;
+
+	if (info->attrs[NL80211_ATTR_KEY_IDX])
+		key_idx = nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
+
+	if (key_idx > 3)
+		return -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->del_key) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	rtnl_lock();
+	err = drv->ops->del_key(&drv->wiphy, dev, key_idx, mac_addr);
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
@@ -374,6 +639,30 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_GET_KEY,
+		.doit = nl80211_get_key,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_SET_KEY,
+		.doit = nl80211_set_key,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_NEW_KEY,
+		.doit = nl80211_new_key,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = NL80211_CMD_DEL_KEY,
+		.doit = nl80211_del_key,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };
 
 /* multicast groups */
--- linux-2.6.orig/net/wireless/core.c	2007-10-24 11:32:36.482690568 +0200
+++ linux-2.6/net/wireless/core.c	2007-10-24 11:35:48.392690568 +0200
@@ -184,6 +184,9 @@ struct wiphy *wiphy_new(struct cfg80211_
 	struct cfg80211_registered_device *drv;
 	int alloc_size;
 
+	WARN_ON(!ops->add_key && ops->del_key);
+	WARN_ON(ops->add_key && !ops->del_key);
+
 	alloc_size = sizeof(*drv) + sizeof_priv;
 
 	drv = kzalloc(alloc_size, GFP_KERNEL);
--- linux-2.6.orig/include/net/cfg80211.h	2007-10-24 11:32:36.422690568 +0200
+++ linux-2.6/include/net/cfg80211.h	2007-10-24 11:35:48.392690568 +0200
@@ -49,6 +49,26 @@ extern int ieee80211_radiotap_iterator_n
    struct ieee80211_radiotap_iterator *iterator);
 
 
+ /**
+ * struct key_params - key information
+ *
+ * Information about a key
+ *
+ * @key: key material
+ * @key_len: length of key material
+ * @cipher: cipher suite selector
+ * @seq: sequence counter (IV/PN) for TKIP and CCMP keys, only used
+ *	with the get_key() callback, must be in little endian,
+ *	length given by @seq_len.
+ */
+struct key_params {
+	u8 *key;
+	u8 *seq;
+	int key_len;
+	int seq_len;
+	u32 cipher;
+};
+
 /* from net/wireless.h */
 struct wiphy;
 
@@ -71,6 +91,18 @@ struct wiphy;
  *
  * @change_virtual_intf: change type of virtual interface
  *
+ * @add_key: add a key with the given parameters. @mac_addr will be %NULL
+ *	when adding a group key.
+ *
+ * @get_key: get information about the key with the given parameters.
+ *	@mac_addr will be %NULL when requesting information for a group
+ *	key. All pointers given to the @callback function need not be valid
+ *	after it returns.
+ *
+ * @del_key: remove a key given the @mac_addr (%NULL for a group key)
+ *	and @key_index
+ *
+ * @set_default_key: set the default key on an interface
  */
 struct cfg80211_ops {
 	int	(*add_virtual_intf)(struct wiphy *wiphy, char *name,
@@ -78,6 +110,18 @@ struct cfg80211_ops {
 	int	(*del_virtual_intf)(struct wiphy *wiphy, int ifindex);
 	int	(*change_virtual_intf)(struct wiphy *wiphy, int ifindex,
 				       enum nl80211_iftype type);
+
+	int	(*add_key)(struct wiphy *wiphy, struct net_device *netdev,
+			   u8 key_index, u8 *mac_addr,
+			   struct key_params *params);
+	int	(*get_key)(struct wiphy *wiphy, struct net_device *netdev,
+			   u8 key_index, u8 *mac_addr, void *cookie,
+			   void (*callback)(void *cookie, struct key_params*));
+	int	(*del_key)(struct wiphy *wiphy, struct net_device *netdev,
+			   u8 key_index, u8 *mac_addr);
+	int	(*set_default_key)(struct wiphy *wiphy,
+				   struct net_device *netdev,
+				   u8 key_index);
 };
 
 #endif /* __NET_CFG80211_H */

-- 

