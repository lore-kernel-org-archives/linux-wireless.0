Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53771 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab3ARFsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 00:48:53 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: [PATCH V9 2/2] cfg80211/nl80211: Enable drivers to implement MAC address based ACL
Date: Fri, 18 Jan 2013 11:18:45 +0530
Message-ID: <1358488125-6154-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20130118_064857_985664_242FD254)
In-Reply-To: <1358488125-6154-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1358488125-6154-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables drivers to implement MAC address based
access control in AP/P2P GO mode. Capable driver advertises
this capability by setting the maximum number of MAC addresses
that driver supports, wiphy->max_acl_mac_addrs.

Driver enables its ACL either with the initial list passed
through NL80211_CMD_START_AP or a list passed through
NL80211_CMD_SET_MAC_ACL. ACL information passed in these
commands contains ACL policy and the list of stations' MAC
address to be configured under this policy. With the ACL policy as
NL80211_ACL_POLICY_ACCEPT_UNLESS_LISTED, driver will reject any
connection request from stations whose MAC address is part of the MAC
list, all stations which are not part of the MAC list will be allowed to
connect. When ACL policy is NL80211_ACL_POLICY_DENY_UNLESS_LISTED,
driver will allow the stations which are part of the MAC list, all other
stations are rejected. When a station's connection request is rejected
due to ACL an event is notified to userspace with reason code
NL80211_CONN_FAIL_BLOCKED_CLIENT in NL80211_CMD_CONN_FAILED. Driver must
make sure to clear its acl list when doing stop_ap.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 include/net/cfg80211.h       |   34 ++++++++++++
 include/uapi/linux/nl80211.h |   56 +++++++++++++++++++-
 net/wireless/core.c          |    5 ++
 net/wireless/nl80211.c       |  117 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |   12 ++++
 net/wireless/trace.h         |   18 +++++++
 6 files changed, 240 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9cd9248..b5c199e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -526,6 +526,22 @@ struct mac_address {
 };
 
 /**
+ * struct cfg80211_acl_data - Access control list data
+ *
+ * @acl_policy: ACL policy to be applied on the station's
+	entry specified by mac_addr
+ * @n_acl_entries: Number of MAC address entries passed
+ * @mac_addrs: List of MAC addresses of stations to be used for ACL
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
@@ -544,6 +560,8 @@ struct mac_address {
  * @inactivity_timeout: time in seconds to determine station's inactivity.
  * @p2p_ctwindow: P2P CT Window
  * @p2p_opp_ps: P2P opportunistic PS
+ * @acl: ACL configuration used by the drivers which has support for
+ *	MAC address based access control
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -560,6 +578,7 @@ struct cfg80211_ap_settings {
 	int inactivity_timeout;
 	u8 p2p_ctwindow;
 	bool p2p_opp_ps;
+	struct cfg80211_acl_data *acl;
 };
 
 /**
@@ -1767,6 +1786,13 @@ struct cfg80211_gtk_rekey_data {
  *
  * @start_p2p_device: Start the given P2P device.
  * @stop_p2p_device: Stop the given P2P device.
+ *
+ * @set_mac_acl: Sets MAC address control list in AP and P2P GO mode.
+ *	Parameters include ACL policy, an array of MAC address of stations
+ *	and the number of MAC addresses. If there is already a list in driver
+ *	this new list replaces the existing one. Driver has to clear its ACL
+ *	when number of MAC addresses entries is passed as 0. Drivers which
+ *	advertise the support for MAC based ACL have to implement this callback.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -1987,6 +2013,9 @@ struct cfg80211_ops {
 				    struct wireless_dev *wdev);
 	void	(*stop_p2p_device)(struct wiphy *wiphy,
 				   struct wireless_dev *wdev);
+
+	int	(*set_mac_acl)(struct wiphy *wiphy, struct net_device *dev,
+			       struct cfg80211_acl_data *params);
 };
 
 /*
@@ -2290,6 +2319,9 @@ struct wiphy_wowlan_support {
  * @ap_sme_capa: AP SME capabilities, flags from &enum nl80211_ap_sme_features.
  * @ht_capa_mod_mask:  Specify what ht_cap values can be over-ridden.
  *	If null, then none can be over-ridden.
+ *
+ * @max_acl_mac_addrs: Maximum number of MAC addresses that the device
+ *	supports for ACL.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -2392,6 +2424,8 @@ struct wiphy {
 	const struct iw_handler_def *wext;
 #endif
 
+	u16 max_acl_mac_addrs;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 5470171..b4f96e0 100644
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
@@ -586,6 +587,16 @@
  * @NL80211_CMD_SET_MCAST_RATE: Change the rate used to send multicast frames
  *	for IBSS or MESH vif.
  *
+ * @NL80211_CMD_SET_MAC_ACL: sets ACL for MAC address based access control.
+ *	This is to be used with the drivers advertising the support of MAC
+ *	address based access control. List of MAC addresses is passed in
+ *	%NL80211_ATTR_MAC_ADDRS and ACL policy is passed in
+ *	%NL80211_ATTR_ACL_POLICY. Driver will enable ACL with this list, if it
+ *	is not already done. The new list will replace any existing list. Driver
+ *	will clear its ACL when the list of MAC addresses passed is empty. This
+ *	command is used in AP/P2P GO mode. Driver has to make sure to clear its
+ *	ACL list during %NL80211_CMD_STOP_AP.
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
@@ -1310,6 +1323,15 @@ enum nl80211_commands {
  *	if not given in START_AP 0 is assumed, if not given in SET_BSS
  *	no change is made.
  *
+ * @NL80211_ATTR_ACL_POLICY: ACL policy, see &enum nl80211_acl_policy_attr.
+ *
+ * @NL80211_ATTR_MAC_ADDRS: Array of nested MAC addresses, used for
+ *	MAC ACL.
+ *
+ * @NL80211_ATTR_MAC_ACL_MAX: u32 attribute to advertise the maximum
+ *	number of MAC addresses that a device can support for MAC
+ *	ACL.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1580,6 +1602,12 @@ enum nl80211_attrs {
 	NL80211_ATTR_P2P_CTWINDOW,
 	NL80211_ATTR_P2P_OPPPS,
 
+	NL80211_ATTR_ACL_POLICY,
+
+	NL80211_ATTR_MAC_ADDRS,
+
+	NL80211_ATTR_MAC_ACL_MAX,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3198,7 +3226,7 @@ enum nl80211_probe_resp_offload_support_attr {
  * enum nl80211_connect_failed_reason - connection request failed reasons
  * @NL80211_CONN_FAIL_MAX_CLIENTS: Maximum number of clients that can be
  *	handled by the AP is reached.
- * @NL80211_CONN_FAIL_BLOCKED_CLIENT: Client's MAC is in the AP's blocklist.
+ * @NL80211_CONN_FAIL_BLOCKED_CLIENT: Connection request is rejected due to ACL.
  */
 enum nl80211_connect_failed_reason {
 	NL80211_CONN_FAIL_MAX_CLIENTS,
@@ -3226,4 +3254,28 @@ enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_AP				= 1<<2,
 };
 
+/**
+ * enum nl80211_acl_policy_attr - access control policy
+ *
+ * Access control policy is applied on a MAC list set by
+ * %NL80211_CMD_START_AP and %NL80211_CMD_SET_MAC_ACL, to
+ * be used with %NL80211_ATTR_ACL_POLICY.
+ *
+ * @NL80211_ACL_POLICY_ACCEPT_UNLESS_LISTED: Deny stations which are
+ *	listed in ACL, i.e. allow all the stations which are not listed
+ *	in ACL to authenticate.
+ * @NL80211_ACL_POLICY_DENY_UNLESS_LISTED: Allow the stations which are listed
+ *	in ACL, i.e. deny all the stations which are not listed in ACL.
+ * @__NL80211_ACL_POLICY_AFTER_LAST: Internal use
+ * @NL80211_ACL_POLICY_MAX: Highest acl policy attribute
+ */
+enum nl80211_acl_policy_attr {
+	NL80211_ACL_POLICY_ACCEPT_UNLESS_LISTED,
+	NL80211_ACL_POLICY_DENY_UNLESS_LISTED,
+
+	/* Keep last */
+	__NL80211_ACL_POLICY_AFTER_LAST,
+	NL80211_ACL_POLICY_MAX = __NL80211_ACL_POLICY_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 747dd93..d83e8fe 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -470,6 +470,11 @@ int wiphy_register(struct wiphy *wiphy)
 			   ETH_ALEN)))
 		return -EINVAL;
 
+	if (WARN_ON(wiphy->max_acl_mac_addrs &&
+		    (!(wiphy->flags & WIPHY_FLAG_HAVE_AP_SME) ||
+		    !rdev->ops->set_mac_acl)))
+		return -EINVAL;
+
 	if (wiphy->addresses)
 		memcpy(wiphy->perm_addr, wiphy->addresses[0].addr, ETH_ALEN);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9bd8340..fe081a5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -365,6 +365,8 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_SCAN_FLAGS] = { .type = NLA_U32 },
 	[NL80211_ATTR_P2P_CTWINDOW] = { .type = NLA_U8 },
 	[NL80211_ATTR_P2P_OPPPS] = { .type = NLA_U8 },
+	[NL80211_ATTR_ACL_POLICY] = {. type = NLA_U8 },
+	[NL80211_ATTR_MAC_ADDRS] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -1265,6 +1267,11 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 portid, u32 seq, int flag
 		    dev->wiphy.ht_capa_mod_mask))
 		goto nla_put_failure;
 
+	if ((dev->wiphy.flags & WIPHY_FLAG_HAVE_AP_SME) &&
+	    nla_put_u32(msg, NL80211_ATTR_MAC_ACL_MAX,
+			dev->wiphy.max_acl_mac_addrs))
+		goto nla_put_failure;
+
 	return genlmsg_end(msg, hdr);
 
  nla_put_failure:
@@ -2481,6 +2488,96 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+/* This function returns an error or the number of nested attributes */
+static int validate_acl_mac_addrs(struct nlattr *nl_attr)
+{
+	struct nlattr *attr;
+	int n_entries = 0, tmp;
+
+	nla_for_each_nested(attr, nl_attr, tmp) {
+		if (nla_len(attr) != ETH_ALEN)
+			return -EINVAL;
+
+		n_entries++;
+	}
+
+	return n_entries;
+}
+
+/*
+ * This function parses ACL information and allocates memory for ACL data.
+ * On successful return, the calling function is responsible to free the
+ * ACL buffer returned by this function.
+ */
+static struct cfg80211_acl_data *parse_acl_data(struct wiphy *wiphy,
+						struct genl_info *info)
+{
+	enum nl80211_acl_policy_attr acl_policy;
+	struct nlattr *attr;
+	struct cfg80211_acl_data *acl;
+	int i = 0, n_entries, tmp;
+
+	if (!info->attrs[NL80211_ATTR_ACL_POLICY])
+		return ERR_PTR(-EINVAL);
+
+	acl_policy = nla_get_u8(info->attrs[NL80211_ATTR_ACL_POLICY]);
+	if (acl_policy > NL80211_ACL_POLICY_MAX)
+		return ERR_PTR(-EINVAL);
+
+	if (!info->attrs[NL80211_ATTR_MAC_ADDRS])
+		return ERR_PTR(-EINVAL);
+
+	n_entries = validate_acl_mac_addrs(info->attrs[NL80211_ATTR_MAC_ADDRS]);
+	if (n_entries < 0)
+		return ERR_PTR(n_entries);
+
+	if (n_entries > wiphy->max_acl_mac_addrs)
+		return ERR_PTR(-ENOTSUPP);
+
+	acl = kzalloc(sizeof(*acl) + (sizeof(struct mac_address) * n_entries),
+		      GFP_KERNEL);
+	if (!acl)
+		return ERR_PTR(-ENOMEM);
+
+	nla_for_each_nested(attr, info->attrs[NL80211_ATTR_MAC_ADDRS], tmp) {
+		memcpy(acl->mac_addrs[i].addr, nla_data(attr), ETH_ALEN);
+		i++;
+	}
+
+	acl->n_acl_entries = n_entries;
+	acl->acl_policy = acl_policy;
+
+	return acl;
+}
+
+static int nl80211_set_mac_acl(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct cfg80211_acl_data *acl;
+	int err;
+
+	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
+	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EOPNOTSUPP;
+
+	if (!dev->ieee80211_ptr->beacon_interval)
+		return -EINVAL;
+
+	if (!rdev->wiphy.max_acl_mac_addrs)
+		return -EOPNOTSUPP;
+
+	acl = parse_acl_data(&rdev->wiphy, info);
+	if (IS_ERR(acl))
+		return PTR_ERR(acl);
+
+	err = rdev_set_mac_acl(rdev, dev, acl);
+
+	kfree(acl);
+
+	return err;
+}
+
 static int nl80211_parse_beacon(struct genl_info *info,
 				struct cfg80211_beacon_data *bcn)
 {
@@ -2724,6 +2821,15 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
+	if (info->attrs[NL80211_ATTR_ACL_POLICY]) {
+		if (!rdev->wiphy.max_acl_mac_addrs)
+			return -ENOTSUPP;
+
+		params.acl = parse_acl_data(&rdev->wiphy, info);
+		if (IS_ERR(params.acl))
+			return PTR_ERR(params.acl);
+	}
+
 	err = rdev_start_ap(rdev, dev, &params);
 	if (!err) {
 		wdev->preset_chandef = params.chandef;
@@ -2732,6 +2838,9 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		wdev->ssid_len = params.ssid_len;
 		memcpy(wdev->ssid, params.ssid, wdev->ssid_len);
 	}
+
+	kfree(params.acl);
+
 	return err;
 }
 
@@ -7792,6 +7901,14 @@ static struct genl_ops nl80211_ops[] = {
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
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 6c0c819..422d382 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -875,4 +875,16 @@ static inline void rdev_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	rdev->ops->stop_p2p_device(&rdev->wiphy, wdev);
 	trace_rdev_return_void(&rdev->wiphy);
 }					
+
+static inline int rdev_set_mac_acl(struct cfg80211_registered_device *rdev,
+				   struct net_device *dev,
+				   struct cfg80211_acl_data *params)
+{
+	int ret;
+
+	trace_rdev_set_mac_acl(&rdev->wiphy, dev, params);
+	ret = rdev->ops->set_mac_acl(&rdev->wiphy, dev, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 2134576..5ddc3f7 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1767,6 +1767,24 @@ DEFINE_EVENT(wiphy_wdev_evt, rdev_stop_p2p_device,
 	TP_ARGS(wiphy, wdev)
 );
 
+TRACE_EVENT(rdev_set_mac_acl,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_acl_data *params),
+	TP_ARGS(wiphy, netdev, params),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(u8, acl_policy)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WIPHY_ASSIGN;
+		__entry->acl_policy = params->acl_policy;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", acl policy: %d",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->acl_policy)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
1.7.0.4

