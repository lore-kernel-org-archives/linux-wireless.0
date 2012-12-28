Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:53643 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2L1KVb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Dec 2012 05:21:31 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH V4 2/2] cfg80211/nl80211: Enable drivers to implement mac address based ACL
Date: Fri, 28 Dec 2012 15:51:10 +0530
Message-ID: <1356690070-26612-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20121228_112136_610494_698E48FF)
In-Reply-To: <1356690070-26612-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1356690070-26612-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables drivers to implement mac address based
access control in AP/P2P GO mode. Capable driver advertises
this capability by setting wiphy acl_type.

Driver can enable its ACL either with the initial list passed
through NL80211_CMD_START_AP or a list passed through
NL80211_CMD_SET_MAC_ACL. ACL information passed in these
commands contains acl policy and the list of stations' mac
address to be configured under this policy. With the acl policy as
NL80211_ACL_POLICY_ACCEPT, driver will accept Auth request from any
client matching any one of the mac addresses in the acl list. When
acl policy is NL80211_ACL_POLICY_DENY, driver will reject any Auth
request from the clients having their mac address listed in the acl
list. Event when a black listed client tries to connect is notified
with connection failed reason as NL80211_CONN_FAIL_BLOCKED_CLIENT
in NL80211_CMD_CONN_FAILED. Driver must make sure to clear it's
acl list when doing stop ap.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---

V2:
	- Use max_acl_mac_addrs to advertise the capability
	  instead of defining a new flag in nl80211_ap_sme_features.

V3:
	- Provision for drivers to advertise supporting acl type.
	- Notification when client belongs to no list tries to connect.

V4:
	- Change it accordingly so that at any time the driver can
	  support either white or black list not both.

 include/net/cfg80211.h       |   40 +++++++++++
 include/uapi/linux/nl80211.h |   55 +++++++++++++++-
 net/wireless/core.c          |    6 ++
 net/wireless/nl80211.c       |  152 +++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 251 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 475230b..1c33ce0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -508,6 +508,21 @@ struct mac_address {
 };
 
 /**
+ * struct cfg80211_acl_data - Access control data
+ * @acl_policy: Access control policy to be applied on the station's
+	entry specified by mac_addr
+ * @n_acl_entries: Number of mac address entries passed
+ * @mac_addrs: List of mac addresses of stations to be used for acl
+ */
+struct cfg80211_acl_data {
+	enum nl80211_acl_policy_attr acl_policy;
+	int n_acl_entries;
+
+	/* Keep it last */
+	struct mac_address mac_addrs[];
+};
+
+/**
  * struct cfg80211_ap_settings - AP configuration
  *
  * Used to configure an AP interface.
@@ -524,6 +539,8 @@ struct mac_address {
  * @privacy: the BSS uses privacy
  * @auth_type: Authentication type (algorithm)
  * @inactivity_timeout: time in seconds to determine station's inactivity.
+ * @acl: acl configuration used by the drivers which has support for
+ *	mac address based access control
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -538,6 +555,7 @@ struct cfg80211_ap_settings {
 	bool privacy;
 	enum nl80211_auth_type auth_type;
 	int inactivity_timeout;
+	struct cfg80211_acl_data *acl;
 };
 
 /**
@@ -1732,6 +1750,15 @@ struct cfg80211_gtk_rekey_data {
  *
  * @start_p2p_device: Start the given P2P device.
  * @stop_p2p_device: Stop the given P2P device.
+ *
+ * @set_mac_acl: Set stations' mac address to driver's access control list in
+ *	AP and P2P GO mode. Parameters include acl policy, an array of mac
+ *	address of stations and the number of mac address. If there is already
+ *	a list in driver for this acl policy, this new list replaces the
+ *	existing one. Driver has to clear the acl list for this	acl policy when
+ *	number of mac address entries is passed as 0. Drivers which advertise
+ *	the support for mac address based access control have to implement this
+ *	callback.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1952,6 +1979,9 @@ struct cfg80211_ops {
 				    struct wireless_dev *wdev);
 	void	(*stop_p2p_device)(struct wiphy *wiphy,
 				   struct wireless_dev *wdev);
+
+	int	(*set_mac_acl)(struct wiphy *wiphy, struct net_device *dev,
+			       struct cfg80211_acl_data *params);
 };
 
 /*
@@ -2255,6 +2285,13 @@ struct wiphy_wowlan_support {
  * @ap_sme_capa: AP SME capabilities, flags from &enum nl80211_ap_sme_features.
  * @ht_capa_mod_mask:  Specify what ht_cap values can be over-ridden.
  *	If null, then none can be over-ridden.
+ *
+ * @acl_type: ACL policy that driver supports,
+ *	see &enum nl80211_acl_policy_attr.
+ * @max_acl_mac_addrs: Maximum number of mac addresses that the device
+ *	supports for ACL. Driver having ACL based on MAC address support
+ *	has to fill this. This limit is common for both (white and black)
+ *	the acl policies.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -2357,6 +2394,9 @@ struct wiphy {
 	const struct iw_handler_def *wext;
 #endif
 
+	u8 acl_type;
+	u16 max_acl_mac_addrs;
+
 	char priv[0] __attribute__((__aligned__(NETDEV_ALIGN)));
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 33a4174..eb3c2fa 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -170,7 +170,8 @@
  *	%NL80211_ATTR_HIDDEN_SSID, %NL80211_ATTR_CIPHERS_PAIRWISE,
  *	%NL80211_ATTR_CIPHER_GROUP, %NL80211_ATTR_WPA_VERSIONS,
  *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY,
- *	%NL80211_ATTR_AUTH_TYPE and %NL80211_ATTR_INACTIVITY_TIMEOUT.
+ *	%NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_INACTIVITY_TIMEOUT,
+ *	%NL80211_ATTR_ACL_POLICY and %NL80211_ATTR_MAC_ADDRS.
  *	The channel to use can be set on the interface or be given using the
  *	%NL80211_ATTR_WIPHY_FREQ and the attributes determining channel width.
  * @NL80211_CMD_NEW_BEACON: old alias for %NL80211_CMD_START_AP
@@ -586,6 +587,17 @@
  * @NL80211_CMD_SET_MCAST_RATE: Change the rate used to send multicast frames
  *	for IBSS or MESH vif.
  *
+ * @NL80211_CMD_SET_MAC_ACL: sets acl list for mac address based access control.
+ *	This is to be used with the drivers advertising the support of mac
+ *	address based access control. List of mac address is passed in
+ *	%NL80211_ATTR_MAC_ADDRS and acl policy is passed in
+ *	%NL80211_ATTR_ACL_POLICY. Driver will enable acl with this list,
+ *	if it is not already done. The new list will replace any existing acl
+ *	for a particular acl policy. Driver will clear it's acl when the list
+ *	of mac address passed is empty. This command is used in AP/P2P GO mode.
+ *	Driver has to make sure to clear it's acl list during
+ *	%NL80211_CMD_STOP_AP.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -736,6 +748,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_MCAST_RATE,
 
+	NL80211_CMD_SET_MAC_ACL,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1303,6 +1317,18 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u32)
  *
+ * @NL80211_ATTR_ACL_POLICY: policy of access control list,
+ *	see &enum nl80211_acl_policy_attr.
+ *
+ * @NL80211_ATTR_MAC_ADDRS: Array of nested mac addresses, used for mac acl.
+ *
+ * @NL80211_ATTR_MAC_ACL_MAX: u32 attribute to advertise the maximum
+ *	number of mac addresses that a device can support for MAC
+ *	access control.
+ *
+ * @NL80211_ATTR_ACL_TYPE: u32 attribute containing the supported
+ *	ACL policy, see &enum nl80211_acl_policy_attr.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1570,6 +1596,14 @@ enum nl80211_attrs {
 	NL80211_ATTR_CENTER_FREQ1,
 	NL80211_ATTR_CENTER_FREQ2,
 
+	NL80211_ATTR_ACL_POLICY,
+
+	NL80211_ATTR_MAC_ADDRS,
+
+	NL80211_ATTR_MAC_ACL_MAX,
+
+	NL80211_ATTR_ACL_TYPE,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3194,4 +3228,23 @@ enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_AP				= 1<<2,
 };
 
+/**
+ * enum nl80211_acl_policy_attr - The access control policy which needs to be
+ *	applied on a mac list set by %NL80211_CMD_START_AP and
+ *	%NL80211_CMD_SET_MAC_ACL. To be used with %NL80211_ATTR_ACL_POLICY.
+ *
+ * @NL80211_ACL_POLICY_ACCEPT: Allow the station to authenticate
+ * @NL80211_ACL_POLICY_DENY: Block the station from authentication
+ * @__NL80211_ACL_POLICY_AFTER_LAST: Internal use
+ * @NL80211_ACL_POLICY_MAX: Highest acl policy attribute
+ */
+enum nl80211_acl_policy_attr {
+	NL80211_ACL_POLICY_ACCEPT,
+	NL80211_ACL_POLICY_DENY,
+
+	/* Keep last */
+	__NL80211_ACL_POLICY_AFTER_LAST,
+	NL80211_ACL_POLICY_MAX = __NL80211_ACL_POLICY_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 14d9904..e8f15d9 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -374,6 +374,7 @@ struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
 	rdev->wiphy.coverage_class = 0;
 
 	rdev->wiphy.features = NL80211_FEATURE_SCAN_FLUSH;
+	rdev->wiphy.acl_type = NL80211_ACL_POLICY_MAX + 1;
 
 	return &rdev->wiphy;
 }
@@ -478,6 +479,11 @@ int wiphy_register(struct wiphy *wiphy)
 			   ETH_ALEN)))
 		return -EINVAL;
 
+	if (WARN_ON((wiphy->acl_type <= NL80211_ACL_POLICY_MAX) &&
+		    (!(wiphy->flags & WIPHY_FLAG_HAVE_AP_SME) ||
+		     !rdev->ops->set_mac_acl)))
+		return -EINVAL;
+
 	if (wiphy->addresses)
 		memcpy(wiphy->perm_addr, wiphy->addresses[0].addr, ETH_ALEN);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d038fa4..bca200b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -363,6 +363,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_SAE_DATA] = { .type = NLA_BINARY, },
 	[NL80211_ATTR_VHT_CAPABILITY] = { .len = NL80211_VHT_CAPABILITY_LEN },
 	[NL80211_ATTR_SCAN_FLAGS] = { .type = NLA_U32 },
+	[NL80211_ATTR_ACL_POLICY] = {. type = NLA_U8 },
+	[NL80211_ATTR_MAC_ADDRS] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -1263,6 +1265,17 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 portid, u32 seq, int flag
 		    dev->wiphy.ht_capa_mod_mask))
 		goto nla_put_failure;
 
+	if ((dev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME) &&
+	    (dev->wiphy.acl_type <= NL80211_ACL_POLICY_MAX)) {
+		if (nla_put_u32(msg, NL80211_ATTR_ACL_TYPE,
+				dev->wiphy.acl_type))
+			goto nla_put_failure;
+
+		if (nla_put_u32(msg, NL80211_ATTR_MAC_ACL_MAX,
+				dev->wiphy.max_acl_mac_addrs))
+			goto nla_put_failure;
+	}
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
@@ -2535,6 +2548,91 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+/*
+ * This function must either return an error or the number
+ * of nested attributes.
+ */
+static int validate_acl_mac_addrs(struct nlattr *nl_attr)
+{
+	struct nlattr *attr;
+	int n_entries = 0, tmp;
+
+	nla_for_each_nested(attr, nl_attr, tmp) {
+		if (nla_len(attr) != ETH_ALEN)
+			return -EINVAL;
+
+		if (!is_valid_ether_addr(nla_data(attr)))
+			return -EINVAL;
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
+	struct cfg80211_acl_data *acl;
+	enum nl80211_acl_policy_attr acl_policy;
+	struct nlattr *attr;
+	int err, i = 0, tmp, n_entries;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EOPNOTSUPP;
+
+	if (!dev->ieee80211_ptr->beacon_interval)
+		return -EINVAL;
+
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME) ||
+	    rdev->wiphy.acl_type > NL80211_ACL_POLICY_MAX)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_ACL_POLICY])
+		return -EINVAL;
+
+	acl_policy = nla_get_u8(info->attrs[NL80211_ATTR_ACL_POLICY]);
+	if (acl_policy != rdev->wiphy.acl_type)
+		return -ENOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_MAC_ADDRS])
+		return -EINVAL;
+
+	n_entries = validate_acl_mac_addrs(info->attrs[NL80211_ATTR_MAC_ADDRS]);
+	if (n_entries < 0)
+		return n_entries;
+
+	if (n_entries > rdev->wiphy.max_acl_mac_addrs)
+		return -ENOTSUPP;
+
+	acl = kzalloc(sizeof(*acl) + (sizeof(struct mac_address) * n_entries),
+		      GFP_KERNEL);
+	if (!acl)
+		return -ENOMEM;
+
+	nla_for_each_nested(attr, info->attrs[NL80211_ATTR_MAC_ADDRS], tmp) {
+		memcpy(acl->mac_addrs[i].addr, nla_data(attr), ETH_ALEN);
+		i++;
+	}
+
+	acl->n_acl_entries = n_entries;
+	acl->acl_policy = acl_policy;
+
+	if (!rdev->ops->set_mac_acl) {
+		err = -EOPNOTSUPP;
+		goto out_free;
+	}
+
+	err = rdev->ops->set_mac_acl(&rdev->wiphy, dev, acl);
+
+out_free:
+	kfree(acl);
+
+	return err;
+}
+
 static int nl80211_parse_beacon(struct genl_info *info,
 				struct cfg80211_beacon_data *bcn)
 {
@@ -2651,7 +2749,10 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_ap_settings params;
-	int err;
+	enum nl80211_acl_policy_attr acl_policy;
+	struct cfg80211_acl_data *acl = NULL;
+	struct nlattr *attr;
+	int err, i = 0, tmp, n_entries;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
@@ -2752,6 +2853,44 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
+	if (info->attrs[NL80211_ATTR_ACL_POLICY]) {
+		if (rdev->wiphy.acl_type > NL80211_ACL_POLICY_MAX)
+			return -ENOTSUPP;
+
+		acl_policy = nla_get_u8(info->attrs[NL80211_ATTR_ACL_POLICY]);
+		if (acl_policy != rdev->wiphy.acl_type)
+			return -ENOTSUPP;
+
+		if (!info->attrs[NL80211_ATTR_MAC_ADDRS])
+			return -EINVAL;
+
+		n_entries =
+		validate_acl_mac_addrs(info->attrs[NL80211_ATTR_MAC_ADDRS]);
+		if (n_entries < 0)
+			return n_entries;
+
+		if (n_entries > rdev->wiphy.max_acl_mac_addrs)
+			return -ENOTSUPP;
+
+		acl = kzalloc(sizeof(*acl) +
+			      (sizeof(struct mac_address) * n_entries),
+			      GFP_KERNEL);
+		if (!acl)
+			return -ENOMEM;
+
+		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_MAC_ADDRS],
+				    tmp) {
+			memcpy(acl->mac_addrs[i].addr, nla_data(attr),
+			       ETH_ALEN);
+			i++;
+		}
+
+		acl->n_acl_entries = n_entries;
+		acl->acl_policy = acl_policy;
+	}
+
+	params.acl = acl;
+
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
 		wdev->preset_chandef = params.chandef;
@@ -2760,6 +2899,9 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		wdev->ssid_len = params.ssid_len;
 		memcpy(wdev->ssid, params.ssid, wdev->ssid_len);
 	}
+
+	kfree(params.acl);
+
 	return err;
 }
 
@@ -7775,6 +7917,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
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

