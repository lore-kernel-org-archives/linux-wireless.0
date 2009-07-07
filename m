Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43522 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbZGGCHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 22:07:44 -0400
Message-Id: <20090707020732.828502810@sipsolutions.net>
References: <20090707020236.921639975@sipsolutions.net>
Date: Tue, 07 Jul 2009 04:02:37 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi
Subject: [RFC 1/2] nl80211: introduce new key attributes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We will soon want to nest key attributes into
some new attribute for configuring static WEP
keys at connect() and ibss_join() time, so we
need nested attributes for that. However, key
attributes right now are 'global'. This patch
thus introduces new nested attributes for the
key settings and functions for parsing them.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/nl80211.h |   35 ++++++++
 net/wireless/nl80211.c  |  203 ++++++++++++++++++++++++++++++++++++------------
 2 files changed, 191 insertions(+), 47 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2009-07-07 03:36:58.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2009-07-07 03:37:07.000000000 +0200
@@ -567,6 +567,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_PREV_BSSID: previous BSSID, to be used by in ASSOCIATE
  *	commands to specify using a reassociate frame
  *
+ * @NL80211_ATTR_KEY: key information in a nested attribute with
+ *	%NL80211_KEY_* sub-attributes
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -692,6 +695,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_PREV_BSSID,
 
+	NL80211_ATTR_KEY,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1320,4 +1325,34 @@ enum nl80211_wpa_versions {
 	NL80211_WPA_VERSION_2 = 1 << 1,
 };
 
+/**
+ * enum nl80211_key_attributes - key attributes
+ * @__NL80211_KEY_INVALID: invalid
+ * @NL80211_KEY_DATA: (temporal) key data; for TKIP this consists of
+ *	16 bytes encryption key followed by 8 bytes each for TX and RX MIC
+ *	keys
+ * @NL80211_KEY_IDX: key ID (u8, 0-3)
+ * @NL80211_KEY_CIPHER: key cipher suite (u32, as defined by IEEE 802.11
+ *	section 7.3.2.25.1, e.g. 0x000FAC04)
+ * @NL80211_KEY_SEQ: transmit key sequence number (IV/PN) for TKIP and
+ *	CCMP keys, each six bytes in little endian
+ * @NL80211_KEY_DEFAULT: flag indicating default key
+ * @NL80211_KEY_DEFAULT_MGMT: flag indicating default management key
+ * @__NL80211_KEY_AFTER_LAST: internal
+ * @NL80211_KEY_MAX: highest key attribute
+ */
+enum nl80211_key_attributes {
+	__NL80211_KEY_INVALID,
+	NL80211_KEY_DATA,
+	NL80211_KEY_IDX,
+	NL80211_KEY_CIPHER,
+	NL80211_KEY_SEQ,
+	NL80211_KEY_DEFAULT,
+	NL80211_KEY_DEFAULT_MGMT,
+
+	/* keep last */
+	__NL80211_KEY_AFTER_LAST,
+	NL80211_KEY_MAX = __NL80211_KEY_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-07 03:37:06.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-07 03:37:07.000000000 +0200
@@ -73,6 +73,7 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_MAC] = { .type = NLA_BINARY, .len = ETH_ALEN },
 	[NL80211_ATTR_PREV_BSSID] = { .type = NLA_BINARY, .len = ETH_ALEN },
 
+	[NL80211_ATTR_KEY] = { .type = NLA_NESTED, },
 	[NL80211_ATTR_KEY_DATA] = { .type = NLA_BINARY,
 				    .len = WLAN_MAX_KEY_LEN },
 	[NL80211_ATTR_KEY_IDX] = { .type = NLA_U8 },
@@ -134,6 +135,18 @@ static struct nla_policy nl80211_policy[
 	[NL80211_ATTR_WPA_VERSIONS] = { .type = NLA_U32 },
 };
 
+/* policy for the attributes */
+static struct nla_policy
+nl80211_key_policy[NL80211_KEY_MAX + 1] __read_mostly = {
+	[NL80211_KEY_DATA] = { .type = NLA_BINARY,
+				    .len = WLAN_MAX_KEY_LEN },
+	[NL80211_KEY_IDX] = { .type = NLA_U8 },
+	[NL80211_KEY_CIPHER] = { .type = NLA_U32 },
+	[NL80211_KEY_SEQ] = { .type = NLA_BINARY, .len = 8 },
+	[NL80211_KEY_DEFAULT] = { .type = NLA_FLAG },
+	[NL80211_KEY_DEFAULT_MGMT] = { .type = NLA_FLAG },
+};
+
 /* IE validation */
 static bool is_valid_ie_attr(const struct nlattr *attr)
 {
@@ -198,6 +211,100 @@ static int nl80211_msg_put_channel(struc
 
 /* netlink command implementations */
 
+struct key_parse {
+	struct key_params p;
+	int idx;
+	bool def, defmgmt;
+};
+
+static int nl80211_parse_key_new(struct nlattr *key, struct key_parse *k)
+{
+	struct nlattr *tb[NL80211_KEY_MAX + 1];
+	int err = nla_parse_nested(tb, NL80211_KEY_MAX, key,
+				   nl80211_key_policy);
+	if (err)
+		return err;
+
+	k->def = !!tb[NL80211_KEY_DEFAULT];
+	k->defmgmt = !!tb[NL80211_KEY_DEFAULT_MGMT];
+
+	if (tb[NL80211_KEY_IDX])
+		k->idx = nla_get_u8(tb[NL80211_KEY_IDX]);
+
+	if (tb[NL80211_KEY_DATA]) {
+		k->p.key = nla_data(tb[NL80211_KEY_DATA]);
+		k->p.key_len = nla_len(tb[NL80211_KEY_DATA]);
+	}
+
+	if (tb[NL80211_KEY_SEQ]) {
+		k->p.seq = nla_data(tb[NL80211_KEY_SEQ]);
+		k->p.seq_len = nla_len(tb[NL80211_KEY_SEQ]);
+	}
+
+	if (tb[NL80211_KEY_CIPHER])
+		k->p.cipher = nla_get_u32(tb[NL80211_KEY_CIPHER]);
+
+	return 0;
+}
+
+static int nl80211_parse_key_old(struct genl_info *info, struct key_parse *k)
+{
+	if (info->attrs[NL80211_ATTR_KEY_DATA]) {
+		k->p.key = nla_data(info->attrs[NL80211_ATTR_KEY_DATA]);
+		k->p.key_len = nla_len(info->attrs[NL80211_ATTR_KEY_DATA]);
+	}
+
+	if (info->attrs[NL80211_ATTR_KEY_SEQ]) {
+		k->p.seq = nla_data(info->attrs[NL80211_ATTR_KEY_SEQ]);
+		k->p.seq_len = nla_len(info->attrs[NL80211_ATTR_KEY_SEQ]);
+	}
+
+	if (info->attrs[NL80211_ATTR_KEY_IDX])
+		k->idx = nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
+
+	if (info->attrs[NL80211_ATTR_KEY_CIPHER])
+		k->p.cipher = nla_get_u32(info->attrs[NL80211_ATTR_KEY_CIPHER]);
+
+	k->def = !!info->attrs[NL80211_ATTR_KEY_DEFAULT];
+	k->defmgmt = !!info->attrs[NL80211_ATTR_KEY_DEFAULT_MGMT];
+
+	return 0;
+}
+
+static int nl80211_parse_key(struct genl_info *info, struct key_parse *k)
+{
+	int err;
+
+	memset(k, 0, sizeof(*k));
+	k->idx = -1;
+
+	if (info->attrs[NL80211_ATTR_KEY])
+		err = nl80211_parse_key_new(info->attrs[NL80211_ATTR_KEY], k);
+	else
+		err = nl80211_parse_key_old(info, k);
+
+	if (err)
+		return err;
+
+	if (k->def && k->defmgmt)
+		return -EINVAL;
+
+	if (k->idx != -1) {
+		if (k->defmgmt) {
+			if (k->idx < 4 || k->idx > 5)
+				return -EINVAL;
+		} else if (k->def) {
+			if (k->idx < 0 || k->idx > 3)
+				return -EINVAL;
+		} else {
+			if (k->idx < 0 || k->idx > 5)
+				return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			      struct cfg80211_registered_device *dev)
 {
@@ -943,10 +1050,12 @@ static int nl80211_del_interface(struct 
 struct get_key_cookie {
 	struct sk_buff *msg;
 	int error;
+	int idx;
 };
 
 static void get_key_callback(void *c, struct key_params *params)
 {
+	struct nlattr *key;
 	struct get_key_cookie *cookie = c;
 
 	if (params->key)
@@ -961,6 +1070,26 @@ static void get_key_callback(void *c, st
 		NLA_PUT_U32(cookie->msg, NL80211_ATTR_KEY_CIPHER,
 			    params->cipher);
 
+	key = nla_nest_start(cookie->msg, NL80211_ATTR_KEY);
+	if (!key)
+		goto nla_put_failure;
+
+	if (params->key)
+		NLA_PUT(cookie->msg, NL80211_KEY_DATA,
+			params->key_len, params->key);
+
+	if (params->seq)
+		NLA_PUT(cookie->msg, NL80211_KEY_SEQ,
+			params->seq_len, params->seq);
+
+	if (params->cipher)
+		NLA_PUT_U32(cookie->msg, NL80211_KEY_CIPHER,
+			    params->cipher);
+
+	NLA_PUT_U8(cookie->msg, NL80211_ATTR_KEY_IDX, cookie->idx);
+
+	nla_nest_end(cookie->msg, key);
+
 	return;
  nla_put_failure:
 	cookie->error = 1;
@@ -1014,6 +1143,7 @@ static int nl80211_get_key(struct sk_buf
 	}
 
 	cookie.msg = msg;
+	cookie.idx = key_idx;
 
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
 	NLA_PUT_U8(msg, NL80211_ATTR_KEY_IDX, key_idx);
@@ -1048,26 +1178,21 @@ static int nl80211_get_key(struct sk_buf
 static int nl80211_set_key(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev;
+	struct key_parse key;
 	int err;
 	struct net_device *dev;
-	u8 key_idx;
 	int (*func)(struct wiphy *wiphy, struct net_device *netdev,
 		    u8 key_index);
 
-	if (!info->attrs[NL80211_ATTR_KEY_IDX])
-		return -EINVAL;
-
-	key_idx = nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
+	err = nl80211_parse_key(info, &key);
+	if (err)
+		return err;
 
-	if (info->attrs[NL80211_ATTR_KEY_DEFAULT_MGMT]) {
-		if (key_idx < 4 || key_idx > 5)
-			return -EINVAL;
-	} else if (key_idx > 3)
+	if (key.idx < 0)
 		return -EINVAL;
 
-	/* currently only support setting default key */
-	if (!info->attrs[NL80211_ATTR_KEY_DEFAULT] &&
-	    !info->attrs[NL80211_ATTR_KEY_DEFAULT_MGMT])
+	/* only support setting default key */
+	if (!key.def && !key.defmgmt)
 		return -EINVAL;
 
 	rtnl_lock();
@@ -1076,7 +1201,7 @@ static int nl80211_set_key(struct sk_buf
 	if (err)
 		goto unlock_rtnl;
 
-	if (info->attrs[NL80211_ATTR_KEY_DEFAULT])
+	if (key.def)
 		func = rdev->ops->set_default_key;
 	else
 		func = rdev->ops->set_default_mgmt_key;
@@ -1086,13 +1211,13 @@ static int nl80211_set_key(struct sk_buf
 		goto out;
 	}
 
-	err = func(&rdev->wiphy, dev, key_idx);
+	err = func(&rdev->wiphy, dev, key.idx);
 #ifdef CONFIG_WIRELESS_EXT
 	if (!err) {
 		if (func == rdev->ops->set_default_key)
-			dev->ieee80211_ptr->wext.default_key = key_idx;
+			dev->ieee80211_ptr->wext.default_key = key.idx;
 		else
-			dev->ieee80211_ptr->wext.default_mgmt_key = key_idx;
+			dev->ieee80211_ptr->wext.default_mgmt_key = key.idx;
 	}
 #endif
 
@@ -1111,34 +1236,20 @@ static int nl80211_new_key(struct sk_buf
 	struct cfg80211_registered_device *rdev;
 	int err, i;
 	struct net_device *dev;
-	struct key_params params;
-	u8 key_idx = 0;
+	struct key_parse key;
 	u8 *mac_addr = NULL;
 
-	memset(&params, 0, sizeof(params));
+	err = nl80211_parse_key(info, &key);
+	if (err)
+		return err;
 
-	if (!info->attrs[NL80211_ATTR_KEY_CIPHER])
+	if (!key.p.key)
 		return -EINVAL;
 
-	if (info->attrs[NL80211_ATTR_KEY_DATA]) {
-		params.key = nla_data(info->attrs[NL80211_ATTR_KEY_DATA]);
-		params.key_len = nla_len(info->attrs[NL80211_ATTR_KEY_DATA]);
-	}
-
-	if (info->attrs[NL80211_ATTR_KEY_SEQ]) {
-		params.seq = nla_data(info->attrs[NL80211_ATTR_KEY_SEQ]);
-		params.seq_len = nla_len(info->attrs[NL80211_ATTR_KEY_SEQ]);
-	}
-
-	if (info->attrs[NL80211_ATTR_KEY_IDX])
-		key_idx = nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
-
-	params.cipher = nla_get_u32(info->attrs[NL80211_ATTR_KEY_CIPHER]);
-
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
-	if (cfg80211_validate_key_settings(&params, key_idx, mac_addr))
+	if (cfg80211_validate_key_settings(&key.p, key.idx, mac_addr))
 		return -EINVAL;
 
 	rtnl_lock();
@@ -1148,7 +1259,7 @@ static int nl80211_new_key(struct sk_buf
 		goto unlock_rtnl;
 
 	for (i = 0; i < rdev->wiphy.n_cipher_suites; i++)
-		if (params.cipher == rdev->wiphy.cipher_suites[i])
+		if (key.p.cipher == rdev->wiphy.cipher_suites[i])
 			break;
 	if (i == rdev->wiphy.n_cipher_suites) {
 		err = -EINVAL;
@@ -1160,7 +1271,7 @@ static int nl80211_new_key(struct sk_buf
 		goto out;
 	}
 
-	err = rdev->ops->add_key(&rdev->wiphy, dev, key_idx, mac_addr, &params);
+	err = rdev->ops->add_key(&rdev->wiphy, dev, key.idx, mac_addr, &key.p);
 
  out:
 	cfg80211_unlock_rdev(rdev);
@@ -1176,14 +1287,12 @@ static int nl80211_del_key(struct sk_buf
 	struct cfg80211_registered_device *rdev;
 	int err;
 	struct net_device *dev;
-	u8 key_idx = 0;
 	u8 *mac_addr = NULL;
+	struct key_parse key;
 
-	if (info->attrs[NL80211_ATTR_KEY_IDX])
-		key_idx = nla_get_u8(info->attrs[NL80211_ATTR_KEY_IDX]);
-
-	if (key_idx > 5)
-		return -EINVAL;
+	err = nl80211_parse_key(info, &key);
+	if (err)
+		return err;
 
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
@@ -1199,13 +1308,13 @@ static int nl80211_del_key(struct sk_buf
 		goto out;
 	}
 
-	err = rdev->ops->del_key(&rdev->wiphy, dev, key_idx, mac_addr);
+	err = rdev->ops->del_key(&rdev->wiphy, dev, key.idx, mac_addr);
 
 #ifdef CONFIG_WIRELESS_EXT
 	if (!err) {
-		if (key_idx == dev->ieee80211_ptr->wext.default_key)
+		if (key.idx == dev->ieee80211_ptr->wext.default_key)
 			dev->ieee80211_ptr->wext.default_key = -1;
-		else if (key_idx == dev->ieee80211_ptr->wext.default_mgmt_key)
+		else if (key.idx == dev->ieee80211_ptr->wext.default_mgmt_key)
 			dev->ieee80211_ptr->wext.default_mgmt_key = -1;
 	}
 #endif

-- 

