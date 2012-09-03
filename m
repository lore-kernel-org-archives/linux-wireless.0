Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11085 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756412Ab2ICMYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 08:24:40 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC 2/2] cfg80211/nl80211: Enable drivers to implement mac address based ACL
Date: Mon, 3 Sep 2012 17:53:57 +0530
Message-ID: <1346675037-17858-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120903_142531_439904_EE35712D)
In-Reply-To: <1346675037-17858-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1346675037-17858-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables drivers to implement mac address based
access control in AP/P2P GO mode. There is a new flag in
nl80211_feature_flags (NL80211_FEATURE_MAC_ACL) for drivers
to advertise this capability. There are two acl policies, white
and black list, under which an acl list can be configured in the
driver. Driver has to advertise the maximum number of mac address
entries in acl list through max_acl_mac_addrs of wiphy.

ACL is enabled/disabled based on attribute NL80211_ATTR_MAC_ACL which
is passed in start_ap. A list of stations' mac addresses is set
using NL80211_CMD_SET_MAC_ACL. Driver may have to make sure to clear
it's acl list when doing start/stop ap.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 include/linux/nl80211.h |   51 +++++++++++++++++++++++-
 include/net/cfg80211.h  |   37 +++++++++++++++++
 net/wireless/nl80211.c  |  102 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 189 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 4584162..8e3eb5d 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -169,7 +169,8 @@
  *	%NL80211_ATTR_HIDDEN_SSID, %NL80211_ATTR_CIPHERS_PAIRWISE,
  *	%NL80211_ATTR_CIPHER_GROUP, %NL80211_ATTR_WPA_VERSIONS,
  *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY,
- *	%NL80211_ATTR_AUTH_TYPE and %NL80211_ATTR_INACTIVITY_TIMEOUT.
+ *	%NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_INACTIVITY_TIMEOUT
+ *	and %NL80211_ATTR_MAC_ACL.
  *	The channel to use can be set on the interface or be given using the
  *	%NL80211_ATTR_WIPHY_FREQ and %NL80211_ATTR_WIPHY_CHANNEL_TYPE attrs.
  * @NL80211_CMD_NEW_BEACON: old alias for %NL80211_CMD_START_AP
@@ -573,6 +574,16 @@
  * @NL80211_CMD_STOP_P2P_DEVICE: Stop the given P2P Device, identified by
  *	its %NL80211_ATTR_WDEV identifier.
  *
+ * @NL80211_CMD_SET_MAC_ACL: sets a list of mac addresses for access control.
+ *	This is to be used with the drivers advertising the support of mac
+ *	address based access control. The list of mac addresses defined by
+ *	%NL80211_ATTR_MAC_ADDRS would replace any existing acl list in driver
+ *	for a particular acl policy specified by %NL80211_ATTR_ACL_POLICY.
+ *	When the passed list of mac address is empty for a particular acl
+ *	policy,	driver has to clear corresponding acl list. This command is
+ *	used in AP/P2P GO mode. Driver has to make sure its acl lists are
+ *	cleared during %NL80211_CMD_START_AP and NL80211_CMD_STOP_AP.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -719,6 +730,8 @@ enum nl80211_commands {
 	NL80211_CMD_START_P2P_DEVICE,
 	NL80211_CMD_STOP_P2P_DEVICE,
 
+	NL80211_CMD_SET_MAC_ACL,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1262,6 +1275,19 @@ enum nl80211_commands {
  *	was used to provide the hint. For the different types of
  *	allowed user regulatory hints see nl80211_user_reg_hint_type.
  *
+ * @NL80211_ATTR_MAC_ACL: Flag attribute to enable or disable mac address
+ *	based access control in driver, needs to be used with the drivers
+ *	which advertise this support.
+ *
+ * @NL80211_ATTR_MAC_ADDRS: Nested attribute with mac addresses used for ACL.
+ *
+ * @NL80211_ATTR_ACL_POLICY: policy of access control,
+ *	see &enum nl80211_acl_policy_attr.
+ *
+ * @NL80211_ATTR_MAC_ACL_MAX: u16 attribute to advertise the maximum
+ *	number of mac addresses that a device can support for MAC
+ *	access control.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1517,6 +1543,14 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_USER_REG_HINT_TYPE,
 
+	NL80211_ATTR_MAC_ACL,
+
+	NL80211_ATTR_MAC_ADDRS,
+
+	NL80211_ATTR_ACL_POLICY,
+
+	NL80211_ATTR_MAC_ACL_MAX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3015,6 +3049,8 @@ enum nl80211_ap_sme_features {
  *	in the interface combinations, even when it's only used for scan
  *	and remain-on-channel. This could be due to, for example, the
  *	remain-on-channel implementation requiring a channel context.
+ * @NL80211_FEATURE_MAC_ACL: Driver does MAC address based access control
+ *	in AP/P2P GO mode.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3022,6 +3058,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_INACTIVITY_TIMER		= 1 << 2,
 	NL80211_FEATURE_CELL_BASE_REG_HINTS		= 1 << 3,
 	NL80211_FEATURE_P2P_DEVICE_NEEDS_CHANNEL	= 1 << 4,
+	NL80211_FEATURE_MAC_ACL				= 1 << 5,
 };
 
 /**
@@ -3045,4 +3082,16 @@ enum nl80211_probe_resp_offload_support_attr {
 	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U =	1<<3,
 };
 
+/**
+ * enum nl80211_acl_policy_attr - The access control policy which needs to be
+ *	applied on an acl list set by %NL80211_CMD_SET_MAC_ACL. To be used
+ *	with %NL80211_ATTR_ACL_POLICY.
+ *
+ * @NL80211_ACL_POLICY_ACCEPT: Allow the station to authenticate.
+ * @NL80211_ACL_POLICY_DENY: Block the station from authentication
+ */
+enum nl80211_acl_policy_attr {
+	NL80211_ACL_POLICY_ACCEPT,
+	NL80211_ACL_POLICY_DENY,
+};
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fd78d38..4648845 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -436,6 +436,8 @@ struct cfg80211_beacon_data {
  * @hidden_ssid: whether to hide the SSID in Beacon/Probe Response frames
  * @crypto: crypto settings
  * @privacy: the BSS uses privacy
+ * @acl_mac: Enable or disable mac address based acl in driver,
+ *	valid only for the drivers which have this support implemented.
  * @auth_type: Authentication type (algorithm)
  * @inactivity_timeout: time in seconds to determine station's inactivity.
  */
@@ -451,6 +453,7 @@ struct cfg80211_ap_settings {
 	enum nl80211_hidden_ssid hidden_ssid;
 	struct cfg80211_crypto_settings crypto;
 	bool privacy;
+	bool acl_mac;
 	enum nl80211_auth_type auth_type;
 	int inactivity_timeout;
 };
@@ -1420,6 +1423,21 @@ struct mac_address {
 };
 
 /**
+ * struct cfg80211_acl_params - Access control parameters
+ * @acl_policy: Access control policy to be applied on the station's
+ *	entry specified by mac_addr
+ * @n_acl_entries: Number of mac address entries passed
+ * @mac_addrs: List of mac addresses of stations to be used for acl
+ */
+struct cfg80211_acl_params {
+	enum nl80211_acl_policy_attr acl_policy;
+	int n_acl_entries;
+
+	/* Keep it last */
+	struct mac_address mac_addrs[0];
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -1626,6 +1644,15 @@ struct mac_address {
  *
  * @start_p2p_device: Start the given P2P device.
  * @stop_p2p_device: Stop the given P2P device.
+ *
+ * @set_mac_acl: Set stations' mac address to driver's access control list in
+ *	AP and P2P GO mode. Parameters are mac address of list of stations,
+ *	number of entries and acl policy to be used with this list. If there
+ *	is already a list in driver for this acl policy, this new list
+ *	replaces the existing one. When no entry is passed in the list of mac
+ *	address, driver has to clear it's acl list for that acl policy. Drivers
+ *	which advertise the support for mac address based access control have to
+ *	implement this callback.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1847,6 +1874,9 @@ struct cfg80211_ops {
 				    struct wireless_dev *wdev);
 	void	(*stop_p2p_device)(struct wiphy *wiphy,
 				   struct wireless_dev *wdev);
+
+	int	(*set_mac_acl)(struct wiphy *wiphy, struct net_device *dev,
+			       struct cfg80211_acl_params *params);
 };
 
 /*
@@ -2150,6 +2180,11 @@ struct wiphy_wowlan_support {
  * @ap_sme_capa: AP SME capabilities, flags from &enum nl80211_ap_sme_features.
  * @ht_capa_mod_mask:  Specify what ht_cap values can be over-ridden.
  *	If null, then none can be over-ridden.
+ *
+ * @max_acl_mac_addrs: Maximum number of mac addresses that the device
+ *	supports for ACL. Driver having ACL based on MAC address support
+ *	has to fill this. This limit is common for both (white and black)
+ *	the acl policies.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -2252,6 +2287,8 @@ struct wiphy {
 	const struct iw_handler_def *wext;
 #endif
 
+	u16 max_acl_mac_addrs;
+
 	char priv[0] __attribute__((__aligned__(NETDEV_ALIGN)));
 };
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 787aeaa..27e3e7d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -355,6 +355,9 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
 	[NL80211_ATTR_WDEV] = { .type = NLA_U64 },
 	[NL80211_ATTR_USER_REG_HINT_TYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_MAC_ACL] = { .type = NLA_FLAG },
+	[NL80211_ATTR_MAC_ADDRS] = { .type = NLA_NESTED },
+	[NL80211_ATTR_ACL_POLICY] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -1248,6 +1251,11 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		    dev->wiphy.ht_capa_mod_mask))
 		goto nla_put_failure;
 
+	if ((dev->wiphy.features & NL80211_FEATURE_MAC_ACL) &&
+	    nla_put_u16(msg, NL80211_ATTR_MAC_ACL_MAX,
+			dev->wiphy.max_acl_mac_addrs))
+		goto nla_put_failure;
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
@@ -2403,6 +2411,85 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int validate_acl_mac_addrs(struct nlattr *nl_attr)
+{
+	struct nlattr *attr;
+	int n_entries = 0, tmp;
+
+	nla_for_each_nested(attr, nl_attr, tmp) {
+		if (nla_len(attr) != ETH_ALEN)
+			return -1;
+
+		if (is_multicast_ether_addr(nla_data(attr)))
+			return -1;
+
+		n_entries++;
+	}
+
+	return n_entries;
+}
+
+static int nl80211_set_mac_acl(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct cfg80211_acl_params *params;
+	struct nlattr *attr;
+	int n_mac_addrs = 0, i = 0, tmp, err;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EOPNOTSUPP;
+
+	if (!(rdev->wiphy.features & NL80211_FEATURE_MAC_ACL))
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_ACL_POLICY] ||
+	    !info->attrs[NL80211_ATTR_MAC_ADDRS])
+		return -EINVAL;
+
+	n_mac_addrs = validate_acl_mac_addrs(
+			info->attrs[NL80211_ATTR_MAC_ADDRS]);
+	if (n_mac_addrs < 0)
+		return -EINVAL;
+
+	if (n_mac_addrs > rdev->wiphy.max_acl_mac_addrs)
+		return -EINVAL;
+
+	params = kzalloc(sizeof(*params) +
+			(sizeof(*params->mac_addrs) * n_mac_addrs),
+			 GFP_KERNEL);
+
+	if (!params)
+		return -ENOMEM;
+
+	params->acl_policy = nla_get_u8(info->attrs[NL80211_ATTR_ACL_POLICY]);
+	if (params->acl_policy != NL80211_ACL_POLICY_ACCEPT &&
+	    params->acl_policy != NL80211_ACL_POLICY_DENY) {
+		err = -EINVAL;
+		goto out_free;
+	}
+
+	nla_for_each_nested(attr, info->attrs[NL80211_ATTR_MAC_ADDRS], tmp) {
+		memcpy(&params->mac_addrs[i].addr, nla_data(attr), ETH_ALEN);
+		i++;
+	}
+
+	params->n_acl_entries = n_mac_addrs;
+
+	if (!rdev->ops->set_mac_acl) {
+		err = -EOPNOTSUPP;
+		goto out_free;
+	}
+
+	err = rdev->ops->set_mac_acl(&rdev->wiphy, dev, params);
+
+out_free:
+	kfree(params);
+
+	return err;
+}
+
 static int nl80211_parse_beacon(struct genl_info *info,
 				struct cfg80211_beacon_data *bcn)
 {
@@ -2607,6 +2694,13 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
+	if (info->attrs[NL80211_ATTR_MAC_ACL]) {
+		if (!(rdev->wiphy.features & NL80211_FEATURE_MAC_ACL))
+			return -EOPNOTSUPP;
+		params.acl_mac =
+			!!nla_get_u8(info->attrs[NL80211_ATTR_MAC_ACL]);
+	}
+
 	err = rdev->ops->start_ap(&rdev->wiphy, dev, &params);
 	if (!err) {
 		wdev->preset_chan = params.channel;
@@ -7550,6 +7644,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_SET_MAC_ACL,
+		.doit = nl80211_set_mac_acl,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
-- 
1.7.0.4

