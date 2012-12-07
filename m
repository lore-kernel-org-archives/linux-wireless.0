Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29452 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755741Ab2LGER4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 23:17:56 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC V3 2/2] cfg80211/nl80211: Enable drivers to implement mac address based ACL
Date: Fri, 7 Dec 2012 09:47:30 +0530
Message-ID: <1354853850-10537-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20121207_051801_324574_BA059799)
In-Reply-To: <1354853850-10537-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1354853850-10537-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables drivers to implement mac address based
access control in AP/P2P GO mode. There is a new flag in
nl80211_ap_sme_features (NL80211_AP_SME_FEATURE_MAC_ACL)
for drivers to advertise this capability. There are two acl
policies, white and black list under which an acl list can
be configured in the driver. Driver has to advertise the
maximum number of mac address entries in acl list through
max_acl_mac_addrs of wiphy.

Driver can enable its ACL either with the initial list passed
through NL80211_CMD_START_AP or a list passed through
NL80211_CMD_SET_MAC_ACL. ACL information passed in these
commands is an array of acl configuration containing acl
policy and list of mac address. With the acl policy as
NL80211_ACL_POLICY_ACCEPT, driver will accept Auth request
from any client matching any one of the mac addresses in the acl list.
When acl policy is NL80211_ACL_POLICY_DENY, driver will reject any
Auth request from the clients having their mac address listed in the
acl list. Driver must make sure to clear it's acl list when doing
stop ap.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---

V3:

	- Change NL80211_ATTR_MAC_ACL_MAX from u16 to u32 as both
	  consumes same space in netlink msg.
	- Check if the capable driver implements set_mac_acl()
	  while registering wiphy.
	- Send acl information in NL80211_CMD_START_AP so that
	  the AP interface will enable acl with the initial list.

 include/net/cfg80211.h       |   48 +++++++++++
 include/uapi/linux/nl80211.h |   70 +++++++++++++++-
 net/wireless/core.c          |    4 +
 net/wireless/nl80211.c       |  182 +++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 299 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 475230b..e0f90de 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -508,6 +508,31 @@ struct mac_address {
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
+	struct mac_address mac_addrs[0];
+};
+
+/**
+ * struct cfg80211_acl_settings - Access control configuration
+ * @acl_data: Acl data for various acl policies
+ * @mac_acl_list: Number of acl configurations
+ */
+struct cfg80211_acl_settings {
+	struct cfg80211_acl_data *acl_data[NL80211_ACL_POLICY_MAX + 1];
+	int num_acl_list;
+};
+
+/**
  * struct cfg80211_ap_settings - AP configuration
  *
  * Used to configure an AP interface.
@@ -524,6 +549,8 @@ struct mac_address {
  * @privacy: the BSS uses privacy
  * @auth_type: Authentication type (algorithm)
  * @inactivity_timeout: time in seconds to determine station's inactivity.
+ * @acl: acl configuration used by the drivers which has support for
+ *	mac address based access control
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -538,6 +565,7 @@ struct cfg80211_ap_settings {
 	bool privacy;
 	enum nl80211_auth_type auth_type;
 	int inactivity_timeout;
+	struct cfg80211_acl_settings acl;
 };
 
 /**
@@ -1732,6 +1760,16 @@ struct cfg80211_gtk_rekey_data {
  *
  * @start_p2p_device: Start the given P2P device.
  * @stop_p2p_device: Stop the given P2P device.
+ *
+ * @set_mac_acl: Set stations' mac address to driver's access control list in
+ *	AP and P2P GO mode. Parameters contains an array of acl configuration
+ *	each containing the acl policy, list of mac addresses and the number
+ *	of mac address entries, and number of array entries. If there is already
+ *	a list in driver for one of the acl policies, this new list replaces the
+ *	existing one for that corresponding acl	policy. Driver has to clear a
+ *	particular acl list when number of mac address entries is passed as 0
+ *	for that acl policy. Drivers which advertise the support for mac address
+ *	based access control have to implement this callback.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1952,6 +1990,9 @@ struct cfg80211_ops {
 				    struct wireless_dev *wdev);
 	void	(*stop_p2p_device)(struct wiphy *wiphy,
 				   struct wireless_dev *wdev);
+
+	int	(*set_mac_acl)(struct wiphy *wiphy, struct net_device *dev,
+			       struct cfg80211_acl_settings *params);
 };
 
 /*
@@ -2255,6 +2296,11 @@ struct wiphy_wowlan_support {
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
@@ -2357,6 +2403,8 @@ struct wiphy {
 	const struct iw_handler_def *wext;
 #endif
 
+	u16 max_acl_mac_addrs;
+
 	char priv[0] __attribute__((__aligned__(NETDEV_ALIGN)));
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 33a4174..f9f5b20 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -170,7 +170,8 @@
  *	%NL80211_ATTR_HIDDEN_SSID, %NL80211_ATTR_CIPHERS_PAIRWISE,
  *	%NL80211_ATTR_CIPHER_GROUP, %NL80211_ATTR_WPA_VERSIONS,
  *	%NL80211_ATTR_AKM_SUITES, %NL80211_ATTR_PRIVACY,
- *	%NL80211_ATTR_AUTH_TYPE and %NL80211_ATTR_INACTIVITY_TIMEOUT.
+ *	%NL80211_ATTR_AUTH_TYPE, %NL80211_ATTR_INACTIVITY_TIMEOUT and
+ *	%NL80211_ATTR_MAC_ACL_LISTS.
  *	The channel to use can be set on the interface or be given using the
  *	%NL80211_ATTR_WIPHY_FREQ and the attributes determining channel width.
  * @NL80211_CMD_NEW_BEACON: old alias for %NL80211_CMD_START_AP
@@ -586,6 +587,16 @@
  * @NL80211_CMD_SET_MCAST_RATE: Change the rate used to send multicast frames
  *	for IBSS or MESH vif.
  *
+ * @NL80211_CMD_SET_MAC_ACL: sets acl list for mac address based access control.
+ *	This is to be used with the drivers advertising the support of mac
+ *	address based access control. ACL information is passed in
+ *	%NL80211_ATTR_MAC_ACL_LISTS. Driver will enable it's ACL with this
+ *	list, if it is not done already. New acl list for an acl policy
+ *	will replace the eixsting one. When a passed list of mac address
+ *	is empty for a particular acl policy, driver has to clear corresponding
+ *	acl list. This command is used in AP/P2P GO mode. Driver has to make
+ *	sure to clear it's acl list during %NL80211_CMD_STOP_AP.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -736,6 +747,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_SET_MCAST_RATE,
 
+	NL80211_CMD_SET_MAC_ACL,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1303,6 +1316,13 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u32)
  *
+ * @NL80211_ATTR_MAC_ACL_LISTS: Nested attribute containing acl configuration,
+ *	see enum nl80211_acl_info_attr.
+ *
+ * @NL80211_ATTR_MAC_ACL_MAX: u32 attribute to advertise the maximum
+ *	number of mac addresses that a device can support for MAC
+ *	access control.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1570,6 +1590,10 @@ enum nl80211_attrs {
 	NL80211_ATTR_CENTER_FREQ1,
 	NL80211_ATTR_CENTER_FREQ2,
 
+	NL80211_ATTR_MAC_ACL_LISTS,
+
+	NL80211_ATTR_MAC_ACL_MAX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3094,11 +3118,12 @@ enum nl80211_tdls_operation {
 
 /*
  * enum nl80211_ap_sme_features - device-integrated AP features
- * Reserved for future use, no bits are defined in
- * NL80211_ATTR_DEVICE_AP_SME yet.
+ * @NL80211_AP_SME_FEATURE_MAC_ACL: Driver does MAC address based access
+ *	control in AP/P2P GO mode.
+ */
 enum nl80211_ap_sme_features {
+	NL80211_AP_SME_FEATURE_MAC_ACL		= 1 << 0,
 };
- */
 
 /**
  * enum nl80211_feature_flags - device/driver features
@@ -3194,4 +3219,41 @@ enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_AP				= 1<<2,
 };
 
+/**
+ * enum nl80211_acl_info_attr - Access control information attributes
+ *
+ * @__NL80211_ACL_ATTR_INVALID: Invalid number for nested attributes
+ * @NL80211_ACL_ATTR_POLICY: Access control policy to be applied on the
+	mac address list, see enum nl80211_acl_policy_attr.
+ * @NL80211_ACL_ATTR_MAC_ADDRS: List of stations' mac addresses for ACL
+ * @__NL80211_ACL_ATTR_AFTER_LAST: Internal
+ * @NL80211_ACL_ATTR_MAX: Highest number of acl attributes
+ */
+enum nl80211_acl_info_attr {
+	__NL80211_ACL_ATTR_INVALID,
+	NL80211_ACL_ATTR_POLICY,
+	NL80211_ACL_ATTR_MAC_ADDRS,
+
+	__NL80211_ACL_ATTR_AFTER_LAST,
+	NL80211_ACL_ATTR_MAX = __NL80211_ACL_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_acl_policy_attr - The access control policy which needs to be
+ *	applied on a mac list set by %NL80211_CMD_START_AP and
+ *	%NL80211_CMD_SET_MAC_ACL. To be used with %NL80211_ACL_ATTR_POLICY.
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
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 14d9904..41be532 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -478,6 +478,10 @@ int wiphy_register(struct wiphy *wiphy)
 			   ETH_ALEN)))
 		return -EINVAL;
 
+	if (WARN_ON((wiphy->ap_sme_capa & NL80211_AP_SME_FEATURE_MAC_ACL) &&
+		    !rdev->ops->set_mac_acl))
+		return -EINVAL;
+
 	if (wiphy->addresses)
 		memcpy(wiphy->perm_addr, wiphy->addresses[0].addr, ETH_ALEN);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d038fa4..f2348bd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -363,6 +363,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_SAE_DATA] = { .type = NLA_BINARY, },
 	[NL80211_ATTR_VHT_CAPABILITY] = { .len = NL80211_VHT_CAPABILITY_LEN },
 	[NL80211_ATTR_SCAN_FLAGS] = { .type = NLA_U32 },
+	[NL80211_ATTR_MAC_ACL_LISTS] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -1263,6 +1264,12 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 portid, u32 seq, int flag
 		    dev->wiphy.ht_capa_mod_mask))
 		goto nla_put_failure;
 
+	if ((dev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME) &&
+	    (dev->wiphy.ap_sme_capa & NL80211_AP_SME_FEATURE_MAC_ACL) &&
+	    nla_put_u32(msg, NL80211_ATTR_MAC_ACL_MAX,
+			dev->wiphy.max_acl_mac_addrs))
+		goto nla_put_failure;
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
@@ -2535,6 +2542,156 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
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
+		if (is_multicast_ether_addr(nla_data(attr)))
+			return -EINVAL;
+
+		n_entries++;
+	}
+
+	return n_entries;
+}
+
+static const struct nla_policy mac_acl_policy[NL80211_ACL_ATTR_MAX + 1] = {
+	[NL80211_ACL_ATTR_POLICY]	= { .type = NLA_U8 },
+	[NL80211_ACL_ATTR_MAC_ADDRS]	= { .type = NLA_NESTED },
+};
+
+/*
+ * This functoion parses acl information and fills the configuration.
+ * On a successful return, the caller function is responsible to
+ * free up the memory allocated in this function for acl configuration.
+ */
+static int parse_acl_information(struct cfg80211_registered_device *rdev,
+				 struct nlattr *acl_attr,
+				 struct cfg80211_acl_settings *acl)
+{
+	struct nlattr *nla_acl, *attr, *tb[NL80211_ACL_ATTR_MAX + 1];
+	u8 avail_acl[NL80211_ACL_POLICY_MAX + 1];
+	int tmp_acl, tmp, i = 0, j, n_entries, n_acl = 0;
+	int acl_policy, err;
+
+	memset(avail_acl, 0, sizeof(avail_acl));
+	nla_for_each_nested(nla_acl, acl_attr, tmp_acl) {
+
+		if (n_acl > NL80211_ACL_POLICY_MAX) {
+			err = -EINVAL;
+			goto free_acl;
+		}
+
+		nla_parse_nested(tb, NL80211_ACL_ATTR_MAX, nla_acl,
+				 mac_acl_policy);
+
+		if (!tb[NL80211_ACL_ATTR_POLICY])
+			continue;
+
+		acl_policy = nla_get_u8(tb[NL80211_ACL_ATTR_POLICY]);
+		if (acl_policy > NL80211_ACL_POLICY_MAX)
+			continue;
+
+		/* Skip multiple acl information for the same acl policy */
+		if (avail_acl[acl_policy])
+			continue;
+
+		if (!tb[NL80211_ACL_ATTR_MAC_ADDRS])
+			continue;
+
+		n_entries =
+			validate_acl_mac_addrs(tb[NL80211_ACL_ATTR_MAC_ADDRS]);
+		if (n_entries < 0 || n_entries > rdev->wiphy.max_acl_mac_addrs)
+			continue;
+
+		acl->acl_data[n_acl] =
+			kzalloc(sizeof(struct cfg80211_acl_data) +
+				(n_entries * sizeof(struct mac_address)),
+				GFP_KERNEL);
+		if (!acl->acl_data[n_acl]) {
+			err = -ENOMEM;
+			goto free_acl;
+		}
+
+		j = 0;
+		nla_for_each_nested(attr, tb[NL80211_ACL_ATTR_MAC_ADDRS], tmp) {
+			memcpy(acl->acl_data[n_acl]->mac_addrs[j].addr,
+			       nla_data(attr), ETH_ALEN);
+			j++;
+		}
+
+		acl->acl_data[n_acl]->n_acl_entries = j;
+		acl->acl_data[n_acl]->acl_policy = acl_policy;
+		avail_acl[acl_policy] = 1;
+		n_acl++;
+	}
+
+	if (!n_acl)
+		return -EINVAL;
+
+	acl->num_acl_list = n_acl;
+
+	return 0;
+
+free_acl:
+	for (i = 0; i < n_acl; i++)
+		kfree(acl->acl_data[i]);
+
+	return err;
+}
+
+static int nl80211_set_mac_acl(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct cfg80211_acl_settings acl;
+	int err, i;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EOPNOTSUPP;
+
+	if (!dev->ieee80211_ptr->beacon_interval)
+		return -EINVAL;
+
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME) ||
+	    !(rdev->wiphy.ap_sme_capa & NL80211_AP_SME_FEATURE_MAC_ACL))
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_MAC_ACL_LISTS])
+		return -EINVAL;
+
+	memset(&acl, 0, sizeof(acl));
+
+	err = parse_acl_information(rdev,
+				    info->attrs[NL80211_ATTR_MAC_ACL_LISTS],
+				    &acl);
+	if (err)
+		return err;
+
+	if (!rdev->ops->set_mac_acl) {
+		err = -EOPNOTSUPP;
+		goto out_free;
+	}
+
+	err = rdev->ops->set_mac_acl(&rdev->wiphy, dev, &acl);
+
+out_free:
+	for (i = 0; i < acl.num_acl_list; i++)
+		kfree(acl.acl_data[i]);
+
+	return err;
+}
+
 static int nl80211_parse_beacon(struct genl_info *info,
 				struct cfg80211_beacon_data *bcn)
 {
@@ -2645,13 +2802,14 @@ static bool nl80211_valid_auth_type(struct cfg80211_registered_device *rdev,
 	}
 }
 
+
 static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_ap_settings params;
-	int err;
+	int err, i;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
@@ -2752,6 +2910,16 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
+	if (info->attrs[NL80211_ATTR_MAC_ACL_LISTS]) {
+		if (!(rdev->wiphy.ap_sme_capa & NL80211_AP_SME_FEATURE_MAC_ACL))
+			return -EOPNOTSUPP;
+
+		err = parse_acl_information(rdev,
+				info->attrs[NL80211_ATTR_MAC_ACL_LISTS],
+				&params.acl);
+		if (err)
+			return err;
+	}
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
 		wdev->preset_chandef = params.chandef;
@@ -2760,6 +2928,10 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		wdev->ssid_len = params.ssid_len;
 		memcpy(wdev->ssid, params.ssid, wdev->ssid_len);
 	}
+
+	for (i = 0; i < params.acl.num_acl_list; i++)
+		kfree(params.acl.acl_data[i]);
+
 	return err;
 }
 
@@ -7775,6 +7947,14 @@ static struct genl_ops nl80211_ops[] = {
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

