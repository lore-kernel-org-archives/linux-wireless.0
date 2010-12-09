Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56542 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab0LIS7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 13:59:01 -0500
Subject: [PATCH 2/3 v2] cfg80211/nl80211: separate unicast/multicast
 default TX keys
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20101209185002.763284359@sipsolutions.net>
References: <20101209184859.155955840@sipsolutions.net>
	 <20101209185002.763284359@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 19:58:59 +0100
Message-ID: <1291921139.3540.37.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Allow userspace to specify that a given key
is default only for unicast and/or multicast
transmissions. Only WEP keys are for both,
WPA/RSN keys set here are GTKs for multicast
only. For more future flexibility, allow to
specify all combiations.

Wireless extensions can only set both so use
nl80211; WEP keys (connect keys) must be set
as default for both (but 802.1X WEP is still
possible).

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2: oops, forgot to heed my own advice of adding the new attributes to
the policies ...

 drivers/net/wireless/iwmc3200wifi/cfg80211.c |    3 
 drivers/net/wireless/libertas/cfg.c          |    3 
 drivers/net/wireless/rndis_wlan.c            |    4 
 include/linux/nl80211.h                      |   27 +++++
 include/net/cfg80211.h                       |    5 -
 net/mac80211/cfg.c                           |    3 
 net/wireless/nl80211.c                       |  125 +++++++++++++++++++++++----
 net/wireless/util.c                          |    3 
 net/wireless/wext-compat.c                   |    8 -
 9 files changed, 152 insertions(+), 29 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2010-12-09 19:54:46.000000000 +0100
+++ wireless-testing/include/linux/nl80211.h	2010-12-09 19:54:50.000000000 +0100
@@ -851,6 +851,10 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_BSS_HTOPMODE: HT operation mode (u16)
  *
+ * @NL80211_ATTR_KEY_DEFAULT_TYPES: A nested attribute containing flags
+ *	attributes, specifying what a key should be set as default as.
+ *	See &enum nl80211_key_default_types.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1029,6 +1033,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_BSS_HT_OPMODE,
 
+	NL80211_ATTR_KEY_DEFAULT_TYPES,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1775,6 +1781,23 @@ enum nl80211_wpa_versions {
 };
 
 /**
+ * enum nl80211_key_default_types - key default types
+ * @__NL80211_KEY_DEFAULT_TYPE_INVALID: invalid
+ * @NL80211_KEY_DEFAULT_TYPE_UNICAST: key should be used as default
+ *	unicast key
+ * @NL80211_KEY_DEFAULT_TYPE_MULTICAST: key should be used as default
+ *	multicast key
+ * @NUM_NL80211_KEY_DEFAULT_TYPES: number of default types
+ */
+enum nl80211_key_default_types {
+	__NL80211_KEY_DEFAULT_TYPE_INVALID,
+	NL80211_KEY_DEFAULT_TYPE_UNICAST,
+	NL80211_KEY_DEFAULT_TYPE_MULTICAST,
+
+	NUM_NL80211_KEY_DEFAULT_TYPES
+};
+
+/**
  * enum nl80211_key_attributes - key attributes
  * @__NL80211_KEY_INVALID: invalid
  * @NL80211_KEY_DATA: (temporal) key data; for TKIP this consists of
@@ -1790,6 +1813,9 @@ enum nl80211_wpa_versions {
  * @NL80211_KEY_TYPE: the key type from enum nl80211_key_type, if not
  *	specified the default depends on whether a MAC address was
  *	given with the command using the key or not (u32)
+ * @NL80211_KEY_DEFAULT_TYPES: A nested attribute containing flags
+ *	attributes, specifying what a key should be set as default as.
+ *	See &enum nl80211_key_default_types.
  * @__NL80211_KEY_AFTER_LAST: internal
  * @NL80211_KEY_MAX: highest key attribute
  */
@@ -1802,6 +1828,7 @@ enum nl80211_key_attributes {
 	NL80211_KEY_DEFAULT,
 	NL80211_KEY_DEFAULT_MGMT,
 	NL80211_KEY_TYPE,
+	NL80211_KEY_DEFAULT_TYPES,
 
 	/* keep last */
 	__NL80211_KEY_AFTER_LAST,
--- wireless-testing.orig/drivers/net/wireless/iwmc3200wifi/cfg80211.c	2010-12-09 19:54:46.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwmc3200wifi/cfg80211.c	2010-12-09 19:54:50.000000000 +0100
@@ -225,7 +225,8 @@ static int iwm_cfg80211_del_key(struct w
 
 static int iwm_cfg80211_set_default_key(struct wiphy *wiphy,
 					struct net_device *ndev,
-					u8 key_index)
+					u8 key_index, bool unicast,
+					bool multicast)
 {
 	struct iwm_priv *iwm = ndev_to_iwm(ndev);
 
--- wireless-testing.orig/drivers/net/wireless/libertas/cfg.c	2010-12-09 19:54:46.000000000 +0100
+++ wireless-testing/drivers/net/wireless/libertas/cfg.c	2010-12-09 19:54:50.000000000 +0100
@@ -1422,7 +1422,8 @@ static int lbs_cfg_disconnect(struct wip
 
 static int lbs_cfg_set_default_key(struct wiphy *wiphy,
 				   struct net_device *netdev,
-				   u8 key_index)
+				   u8 key_index, bool unicast,
+				   bool multicast)
 {
 	struct lbs_private *priv = wiphy_priv(wiphy);
 
--- wireless-testing.orig/drivers/net/wireless/rndis_wlan.c	2010-12-09 19:54:46.000000000 +0100
+++ wireless-testing/drivers/net/wireless/rndis_wlan.c	2010-12-09 19:54:50.000000000 +0100
@@ -554,7 +554,7 @@ static int rndis_del_key(struct wiphy *w
 			 u8 key_index, bool pairwise, const u8 *mac_addr);
 
 static int rndis_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
-								u8 key_index);
+				 u8 key_index, bool unicast, bool multicast);
 
 static int rndis_get_station(struct wiphy *wiphy, struct net_device *dev,
 					u8 *mac, struct station_info *sinfo);
@@ -2381,7 +2381,7 @@ static int rndis_del_key(struct wiphy *w
 }
 
 static int rndis_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
-								u8 key_index)
+				 u8 key_index, bool unicast, bool multicast)
 {
 	struct rndis_wlan_private *priv = wiphy_priv(wiphy);
 	struct usbnet *usbdev = priv->usbdev;
--- wireless-testing.orig/include/net/cfg80211.h	2010-12-09 19:54:46.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2010-12-09 19:54:50.000000000 +0100
@@ -1211,7 +1211,7 @@ struct cfg80211_ops {
 			   u8 key_index, bool pairwise, const u8 *mac_addr);
 	int	(*set_default_key)(struct wiphy *wiphy,
 				   struct net_device *netdev,
-				   u8 key_index);
+				   u8 key_index, bool unicast, bool multicast);
 	int	(*set_default_mgmt_key)(struct wiphy *wiphy,
 					struct net_device *netdev,
 					u8 key_index);
@@ -1393,6 +1393,8 @@ struct cfg80211_ops {
  *	control port protocol ethertype. The device also honours the
  *	control_port_no_encrypt flag.
  * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
+ * @WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS: The device supports separate
+ *	unicast and multicast TX keys.
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1404,6 +1406,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
 	WIPHY_FLAG_IBSS_RSN			= BIT(8),
+	WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS= BIT(9),
 };
 
 struct mac_address {
--- wireless-testing.orig/net/wireless/nl80211.c	2010-12-09 19:54:46.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2010-12-09 19:56:01.000000000 +0100
@@ -171,6 +171,7 @@ static const struct nla_policy nl80211_p
 	[NL80211_ATTR_WIPHY_ANTENNA_RX] = { .type = NLA_U32 },
 	[NL80211_ATTR_MCAST_RATE] = { .type = NLA_U32 },
 	[NL80211_ATTR_OFFCHANNEL_TX_OK] = { .type = NLA_FLAG },
+	[NL80211_ATTR_KEY_DEFAULT_TYPES] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -182,6 +183,14 @@ static const struct nla_policy nl80211_k
 	[NL80211_KEY_DEFAULT] = { .type = NLA_FLAG },
 	[NL80211_KEY_DEFAULT_MGMT] = { .type = NLA_FLAG },
 	[NL80211_KEY_TYPE] = { .type = NLA_U32 },
+	[NL80211_KEY_DEFAULT_TYPES] = { .type = NLA_NESTED },
+};
+
+/* policy for the key default flags */
+static const struct nla_policy
+nl80211_key_default_policy[NUM_NL80211_KEY_DEFAULT_TYPES] = {
+	[NL80211_KEY_DEFAULT_TYPE_UNICAST] = { .type = NLA_FLAG },
+	[NL80211_KEY_DEFAULT_TYPE_MULTICAST] = { .type = NLA_FLAG },
 };
 
 /* ifidx get helper */
@@ -314,6 +323,7 @@ struct key_parse {
 	int idx;
 	int type;
 	bool def, defmgmt;
+	bool def_uni, def_multi;
 };
 
 static int nl80211_parse_key_new(struct nlattr *key, struct key_parse *k)
@@ -327,6 +337,13 @@ static int nl80211_parse_key_new(struct
 	k->def = !!tb[NL80211_KEY_DEFAULT];
 	k->defmgmt = !!tb[NL80211_KEY_DEFAULT_MGMT];
 
+	if (k->def) {
+		k->def_uni = true;
+		k->def_multi = true;
+	}
+	if (k->defmgmt)
+		k->def_multi = true;
+
 	if (tb[NL80211_KEY_IDX])
 		k->idx = nla_get_u8(tb[NL80211_KEY_IDX]);
 
@@ -349,6 +366,19 @@ static int nl80211_parse_key_new(struct
 			return -EINVAL;
 	}
 
+	if (tb[NL80211_KEY_DEFAULT_TYPES]) {
+		struct nlattr *kdt[NUM_NL80211_KEY_DEFAULT_TYPES];
+		int err = nla_parse_nested(kdt,
+					   NUM_NL80211_KEY_DEFAULT_TYPES - 1,
+					   tb[NL80211_KEY_DEFAULT_TYPES],
+					   nl80211_key_default_policy);
+		if (err)
+			return err;
+
+		k->def_uni = kdt[NL80211_KEY_DEFAULT_TYPE_UNICAST];
+		k->def_multi = kdt[NL80211_KEY_DEFAULT_TYPE_MULTICAST];
+	}
+
 	return 0;
 }
 
@@ -373,12 +403,32 @@ static int nl80211_parse_key_old(struct
 	k->def = !!info->attrs[NL80211_ATTR_KEY_DEFAULT];
 	k->defmgmt = !!info->attrs[NL80211_ATTR_KEY_DEFAULT_MGMT];
 
+	if (k->def) {
+		k->def_uni = true;
+		k->def_multi = true;
+	}
+	if (k->defmgmt)
+		k->def_multi = true;
+
 	if (info->attrs[NL80211_ATTR_KEY_TYPE]) {
 		k->type = nla_get_u32(info->attrs[NL80211_ATTR_KEY_TYPE]);
 		if (k->type < 0 || k->type >= NUM_NL80211_KEYTYPES)
 			return -EINVAL;
 	}
 
+	if (info->attrs[NL80211_ATTR_KEY_DEFAULT_TYPES]) {
+		struct nlattr *kdt[NUM_NL80211_KEY_DEFAULT_TYPES];
+		int err = nla_parse_nested(
+				kdt, NUM_NL80211_KEY_DEFAULT_TYPES - 1,
+				info->attrs[NL80211_ATTR_KEY_DEFAULT_TYPES],
+				nl80211_key_default_policy);
+		if (err)
+			return err;
+
+		k->def_uni = kdt[NL80211_KEY_DEFAULT_TYPE_UNICAST];
+		k->def_multi = kdt[NL80211_KEY_DEFAULT_TYPE_MULTICAST];
+	}
+
 	return 0;
 }
 
@@ -401,6 +451,11 @@ static int nl80211_parse_key(struct genl
 	if (k->def && k->defmgmt)
 		return -EINVAL;
 
+	if (k->defmgmt) {
+		if (k->def_uni || !k->def_multi)
+			return -EINVAL;
+	}
+
 	if (k->idx != -1) {
 		if (k->defmgmt) {
 			if (k->idx < 4 || k->idx > 5)
@@ -450,6 +505,8 @@ nl80211_parse_connkeys(struct cfg80211_r
 				goto error;
 			def = 1;
 			result->def = parse.idx;
+			if (!parse.def_uni || !parse.def_multi)
+				goto error;
 		} else if (parse.defmgmt)
 			goto error;
 		err = cfg80211_validate_key_settings(rdev, &parse.p,
@@ -1575,8 +1632,6 @@ static int nl80211_set_key(struct sk_buf
 	struct key_parse key;
 	int err;
 	struct net_device *dev = info->user_ptr[1];
-	int (*func)(struct wiphy *wiphy, struct net_device *netdev,
-		    u8 key_index);
 
 	err = nl80211_parse_key(info, &key);
 	if (err)
@@ -1589,27 +1644,61 @@ static int nl80211_set_key(struct sk_buf
 	if (!key.def && !key.defmgmt)
 		return -EINVAL;
 
-	if (key.def)
-		func = rdev->ops->set_default_key;
-	else
-		func = rdev->ops->set_default_mgmt_key;
+	wdev_lock(dev->ieee80211_ptr);
 
-	if (!func)
-		return -EOPNOTSUPP;
+	if (key.def) {
+		if (!rdev->ops->set_default_key) {
+			err = -EOPNOTSUPP;
+			goto out;
+		}
 
-	wdev_lock(dev->ieee80211_ptr);
-	err = nl80211_key_allowed(dev->ieee80211_ptr);
-	if (!err)
-		err = func(&rdev->wiphy, dev, key.idx);
+		err = nl80211_key_allowed(dev->ieee80211_ptr);
+		if (err)
+			goto out;
+
+		if (!(rdev->wiphy.flags &
+				WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS)) {
+			if (!key.def_uni || !key.def_multi) {
+				err = -EOPNOTSUPP;
+				goto out;
+			}
+		}
+
+		err = rdev->ops->set_default_key(&rdev->wiphy, dev, key.idx,
+						 key.def_uni, key.def_multi);
+
+		if (err)
+			goto out;
 
 #ifdef CONFIG_CFG80211_WEXT
-	if (!err) {
-		if (func == rdev->ops->set_default_key)
-			dev->ieee80211_ptr->wext.default_key = key.idx;
-		else
-			dev->ieee80211_ptr->wext.default_mgmt_key = key.idx;
-	}
+		dev->ieee80211_ptr->wext.default_key = key.idx;
+#endif
+	} else {
+		if (key.def_uni || !key.def_multi) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		if (!rdev->ops->set_default_mgmt_key) {
+			err = -EOPNOTSUPP;
+			goto out;
+		}
+
+		err = nl80211_key_allowed(dev->ieee80211_ptr);
+		if (err)
+			goto out;
+
+		err = rdev->ops->set_default_mgmt_key(&rdev->wiphy,
+						      dev, key.idx);
+		if (err)
+			goto out;
+
+#ifdef CONFIG_CFG80211_WEXT
+		dev->ieee80211_ptr->wext.default_mgmt_key = key.idx;
 #endif
+	}
+
+ out:
 	wdev_unlock(dev->ieee80211_ptr);
 
 	return err;
--- wireless-testing.orig/net/mac80211/cfg.c	2010-12-09 19:54:46.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2010-12-09 19:54:50.000000000 +0100
@@ -295,7 +295,8 @@ static int ieee80211_get_key(struct wiph
 
 static int ieee80211_config_default_key(struct wiphy *wiphy,
 					struct net_device *dev,
-					u8 key_idx)
+					u8 key_idx, bool uni,
+					bool multi)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
--- wireless-testing.orig/net/wireless/util.c	2010-12-09 19:54:46.000000000 +0100
+++ wireless-testing/net/wireless/util.c	2010-12-09 19:54:50.000000000 +0100
@@ -689,7 +689,8 @@ void cfg80211_upload_connect_keys(struct
 			continue;
 		}
 		if (wdev->connect_keys->def == i)
-			if (rdev->ops->set_default_key(wdev->wiphy, dev, i)) {
+			if (rdev->ops->set_default_key(wdev->wiphy, dev,
+						       i, true, true)) {
 				netdev_err(dev, "failed to set defkey %d\n", i);
 				continue;
 			}
--- wireless-testing.orig/net/wireless/wext-compat.c	2010-12-09 19:54:46.000000000 +0100
+++ wireless-testing/net/wireless/wext-compat.c	2010-12-09 19:54:50.000000000 +0100
@@ -548,8 +548,8 @@ static int __cfg80211_set_encryption(str
 				__cfg80211_leave_ibss(rdev, wdev->netdev, true);
 				rejoin = true;
 			}
-			err = rdev->ops->set_default_key(&rdev->wiphy,
-							 dev, idx);
+			err = rdev->ops->set_default_key(&rdev->wiphy, dev,
+							 idx, true, true);
 		}
 		if (!err) {
 			wdev->wext.default_key = idx;
@@ -627,8 +627,8 @@ int cfg80211_wext_siwencode(struct net_d
 		err = 0;
 		wdev_lock(wdev);
 		if (wdev->current_bss)
-			err = rdev->ops->set_default_key(&rdev->wiphy,
-							 dev, idx);
+			err = rdev->ops->set_default_key(&rdev->wiphy, dev,
+							 idx, true, true);
 		if (!err)
 			wdev->wext.default_key = idx;
 		wdev_unlock(wdev);


