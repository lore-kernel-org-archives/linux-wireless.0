Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45012 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbXHXMbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 08:31:55 -0400
Message-Id: <20070824122907.784517000@sipsolutions.net>
References: <20070824122705.549190000@sipsolutions.net>
Date: Fri, 24 Aug 2007 14:27:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 08/15] cfg80211: clean up key add/remove interface
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This cleans up the key add/remove interface in both cfg80211
and nl80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/nl80211.h |   51 ++++++++-----------
 include/net/cfg80211.h  |   13 +++-
 net/wireless/core.c     |    3 +
 net/wireless/nl80211.c  |  125 ++++++++++++++++++++++++++++++++----------------
 4 files changed, 118 insertions(+), 74 deletions(-)

--- wireless-dev.orig/include/linux/nl80211.h	2007-08-24 13:02:50.239420431 +0200
+++ wireless-dev/include/linux/nl80211.h	2007-08-24 13:02:58.569420431 +0200
@@ -43,10 +43,10 @@
  *	%NL80211_ATTR_BSSID, %NL80211_ATTR_CHANNEL, %NL80211_ATTR_PHYMODE,
  *	and %NL80211_ATTR_IE may be given)
  * @NL80211_CMD_ADD_KEY: add a key with given %NL80211_ATTR_KEY_DATA,
- * 	%NL80211_ATTR_KEY_ID, %NL80211_ATTR_KEY_TYPE, %NL80211_ATTR_MAC and
- *	%NL80211_ATTR_KEY_CIPHER attributes.
- * @NL80211_CMD_DEL_KEY: delete a key identified by %NL80211_ATTR_KEY_ID,
- *	%NL80211_ATTR_KEY_TYPE and %NL80211_ATTR_MAC or all keys.
+ *	%NL80211_ATTR_KEY_IDX, %NL80211_ATTR_MAC and %NL80211_ATTR_KEY_CIPHER
+ *	attributes.
+ * @NL80211_CMD_DEL_KEY: delete a key identified by %NL80211_ATTR_KEY_IDX
+ *	or %NL80211_ATTR_MAC.
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
 enum nl80211_commands {
@@ -85,7 +85,9 @@ enum nl80211_commands {
 	NL80211_CMD_AP_UPDATE_STA,
 	NL80211_CMD_AP_GET_STA_INFO,
 	NL80211_CMD_AP_SET_RATESETS,
+	/* %input: ifindex, key_cipher, key_data, {key_idx, mac} */
 	NL80211_CMD_ADD_KEY,
+	/* %input: ifindex, key_idx|mac */
 	NL80211_CMD_DEL_KEY,
 
 	/* add commands here */
@@ -129,11 +131,13 @@ enum nl80211_commands {
  * @NL80211_ATTR_TRANSMIT_POWER: transmit power in mW
  * @NL80211_ATTR_FRAG_THRESHOLD: fragmentation threshold (bytes)
  * @NL80211_ATTR_FLAG_SCAN_ACTIVE: netlink flag indiciating active scan
- * @NL80211_ATTR_KEY_DATA: temporal key data
- * @NL80211_ATTR_KEY_ID: key ID (u8, 0-3)
- * @NL80211_ATTR_KEY_TYPE: key type (see &enum nl80211_keytype)
- * @NL80211_ATTR_MAC: MAC address
- * @NL80211_ATTR_KEY_CIPHER: key cipher suite (u32)
+ * @NL80211_ATTR_KEY_DATA: (temporal) key data; for TKIP this consists of
+ *	16 bytes encryption key followed by 8 bytes each for TX and RX MIC
+ *	keys
+ * @NL80211_ATTR_KEY_IDX: key ID (u8, 0-3)
+ * @NL80211_ATTR_MAC: MAC address (various uses)
+ * @NL80211_ATTR_KEY_CIPHER: key cipher suite (u32, as defined by IEEE 802.11
+ *	section 7.3.2.25.1, e.g. 0x000FAC04)
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
 enum nl80211_attrs {
@@ -148,6 +152,14 @@ enum nl80211_attrs {
 	/* %type: nulstring */
 	NL80211_ATTR_WIPHY_NAME,
 	NL80211_ATTR_CMDS,
+	/* %type: string */
+	NL80211_ATTR_KEY_DATA,
+	/* %type: u8 */
+	NL80211_ATTR_KEY_IDX,
+	/* %type: string/6/6/mac */
+	NL80211_ATTR_MAC,
+	/* %type: u32 */
+	NL80211_ATTR_KEY_CIPHER,
 	/* %type: u32 */
 	NL80211_ATTR_IFTYPE,
 	NL80211_ATTR_INTERFACE_LIST,
@@ -173,11 +185,6 @@ enum nl80211_attrs {
 	NL80211_ATTR_FRAG_THRESHOLD,
 	NL80211_ATTR_FLAG_SCAN_ACTIVE,
 
-	NL80211_ATTR_KEY_DATA,
-	NL80211_ATTR_KEY_ID,
-	NL80211_ATTR_KEY_TYPE,
-	NL80211_ATTR_MAC,
-	NL80211_ATTR_KEY_CIPHER,
 
 	NL80211_ATTR_BEACON_HEAD,
 	NL80211_ATTR_BEACON_TAIL,
@@ -266,20 +273,4 @@ enum nl80211_bsstype {
 };
 #define NL80211_BSSTYPE_MAX (__NL80211_BSSTYPE_AFTER_LAST - 1)
 
-/**
- * enum nl80211_keytype - key types
- * @NL80211_KEYTYPE_GROUP: group key
- * @NL80211_KEYTYPE_PAIRWISE: pairwise key
- * @NL80211_KEYTYPE_PEER: peer key
- */
-enum nl80211_keytype {
-	NL80211_KEYTYPE_GROUP,
-	NL80211_KEYTYPE_PAIRWISE,
-	NL80211_KEYTYPE_PEER,
-
-	/* keep last */
-	__NL80211_KEYTYPE_AFTER_LAST
-};
-#define NL80211_KEYTYPE_MAX (__NL80211_KEYTYPE_AFTER_LAST - 1)
-
 #endif /* __LINUX_NL80211_H */
--- wireless-dev.orig/include/net/cfg80211.h	2007-08-24 13:02:50.319420431 +0200
+++ wireless-dev/include/net/cfg80211.h	2007-08-24 13:02:58.569420431 +0200
@@ -65,14 +65,21 @@ struct association_params {
 
 /**
  * struct key_params - key information
+ *
+ * Information about a key
+ *
+ * @key: key material
+ * @key_len: length of key material
+ * @key_idx: key index (0-3)
+ * @macaddress: MAC address (for a pairwise key) or %NULL
+ * @cipher: cipher suite selector
  */
 struct key_params {
 	u8 *key;
-	int key_len;
-	int key_id;
-	u32 key_type;
 	u8 *macaddress;
+	int key_len;
 	u32 cipher;
+	u8 key_idx;
 };
 
 
--- wireless-dev.orig/net/wireless/nl80211.c	2007-08-24 13:02:50.339420431 +0200
+++ wireless-dev/net/wireless/nl80211.c	2007-08-24 13:02:58.569420431 +0200
@@ -75,7 +75,7 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
 				      .len = BUS_ID_SIZE-1 },
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
-	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
+	[NL80211_ATTR_BSSID] = { .type = NLA_BINARY, .len = ETH_ALEN },
 	[NL80211_ATTR_SSID] = { .type = NLA_BINARY,
 				.len = IEEE80211_MAX_SSID_LEN },
 	[NL80211_ATTR_CHANNEL] = { .type = NLA_U32 },
@@ -100,9 +100,8 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_BEACON_TAIL] = { .type = NLA_BINARY },
 	[NL80211_ATTR_KEY_DATA] = { .type = NLA_BINARY,
 				    .len = WLAN_MAX_KEY_LEN },
-	[NL80211_ATTR_KEY_ID] = { .type = NLA_U32 },
-	[NL80211_ATTR_KEY_TYPE] = { .type = NLA_U32 },
-	[NL80211_ATTR_MAC] = { .len = ETH_ALEN },
+	[NL80211_ATTR_KEY_IDX] = { .type = NLA_U8 },
+	[NL80211_ATTR_MAC] = { .type = NLA_BINARY, .len = ETH_ALEN },
 	[NL80211_ATTR_KEY_CIPHER] = { .type = NLA_U32 },
 };
 
@@ -736,70 +735,114 @@ static int nl80211_rename_wiphy(struct s
 	return result;
 }
 
-static int nl80211_key_cmd(struct sk_buff *skb, struct genl_info *info)
+static int nl80211_add_key(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *drv;
-	int err, del;
+	int err;
 	struct net_device *dev;
 	struct key_params params;
-	int (*act)(struct wiphy *wiphy, struct net_device *dev,
-		   struct key_params *params);
 
 	memset(&params, 0, sizeof(params));
 
-	if (!info->attrs[NL80211_ATTR_KEY_TYPE])
-		return -EINVAL;
-
 	if (!info->attrs[NL80211_ATTR_KEY_CIPHER])
 		return -EINVAL;
 
-	params.key_type = nla_get_u32(info->attrs[NL80211_ATTR_KEY_TYPE]);
-	if (params.key_type > NL80211_KEYTYPE_MAX)
+	if (info->attrs[NL80211_ATTR_KEY_DATA]) {
+		params.key = nla_data(info->attrs[NL80211_ATTR_KEY_DATA]);
+		params.key_len = nla_len(info->attrs[NL80211_ATTR_KEY_DATA]);
+	}
+
+	if (info->attrs[NL80211_ATTR_KEY_IDX])
+		params.key_idx = nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
+
+	params.cipher = nla_get_u32(info->attrs[NL80211_ATTR_KEY_CIPHER]);
+
+	if (info->attrs[NL80211_ATTR_MAC])
+		params.macaddress = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (params.key_idx > 3)
 		return -EINVAL;
 
-	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
-	if (err)
-		return err;
+	/*
+	 * Disallow pairwise keys with non-zero index unless it's WEP
+	 * (because current deployments use pairwise WEP keys with
+	 * non-zero indizes but RSNA clearly specifies to use zero)
+	 */
+	if (params.macaddress && params.key_idx &&
+	    params.cipher != WLAN_CIPHER_SUITE_WEP40 &&
+	    params.cipher != WLAN_CIPHER_SUITE_WEP104)
+		return -EINVAL;
 
-	switch (info->genlhdr->cmd) {
-	case NL80211_CMD_ADD_KEY:
-		act = drv->ops->add_key;
-		del = 0;
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
 		break;
-	case NL80211_CMD_DEL_KEY:
-		act = drv->ops->del_key;
-		del = 1;
+	case WLAN_CIPHER_SUITE_WEP104:
+		if (params.key_len != 13)
+			return -EINVAL;
 		break;
 	default:
-		act = NULL;
+		return -EINVAL;
 	}
 
-	if (!act) {
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->add_key) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
 
-	if (info->attrs[NL80211_ATTR_KEY_DATA]) {
-		params.key = nla_data(info->attrs[NL80211_ATTR_KEY_DATA]);
-		params.key_len = nla_len(info->attrs[NL80211_ATTR_KEY_DATA]);
-	}
+	rtnl_lock();
+	err = drv->ops->add_key(&drv->wiphy, dev, &params);
+	rtnl_unlock();
 
-	if (info->attrs[NL80211_ATTR_KEY_ID]) {
-		params.key_id = nla_get_u32(info->attrs[NL80211_ATTR_KEY_ID]);
-	} else {
-		params.key_id = -1;
-	}
+ out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
+}
 
-	params.cipher = nla_get_u32(info->attrs[NL80211_ATTR_KEY_CIPHER]);
+static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	struct key_params params;
+
+	memset(&params, 0, sizeof(params));
+
+	if (info->attrs[NL80211_ATTR_KEY_IDX])
+		params.key_idx = nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
+
+	if (params.key_idx > 3)
+		return -EINVAL;
 
-	if (info->attrs[NL80211_ATTR_MAC]) {
+	if (info->attrs[NL80211_ATTR_MAC])
 		params.macaddress = nla_data(info->attrs[NL80211_ATTR_MAC]);
-	} else {
-		params.macaddress = NULL;
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->del_key) {
+		err = -EOPNOTSUPP;
+		goto out;
 	}
 
 	rtnl_lock();
-	err = act(&drv->wiphy, dev, &params);
+	err = drv->ops->del_key(&drv->wiphy, dev, &params);
 	rtnl_unlock();
 
  out:
@@ -916,13 +959,13 @@ static struct genl_ops nl80211_ops[] = {
 */
 	{
 		.cmd = NL80211_CMD_ADD_KEY,
-		.doit = nl80211_key_cmd,
+		.doit = nl80211_add_key,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
 	{
 		.cmd = NL80211_CMD_DEL_KEY,
-		.doit = nl80211_key_cmd,
+		.doit = nl80211_del_key,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
--- wireless-dev.orig/net/wireless/core.c	2007-08-24 13:02:50.399420431 +0200
+++ wireless-dev/net/wireless/core.c	2007-08-24 13:02:58.579420431 +0200
@@ -213,6 +213,9 @@ struct wiphy *wiphy_new(struct cfg80211_
 	drv->ops = ops;
 	drv->alive = 0;
 
+	WARN_ON(!ops->add_key && ops->del_key);
+	WARN_ON(ops->add_key && !ops->del_key);
+
 	mutex_lock(&cfg80211_drv_mutex);
 	idr_pre_get(&cfg80211_drivers, GFP_KERNEL);
 	res = idr_get_new(&cfg80211_drivers, drv, &drv->idx);

-- 

