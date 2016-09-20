Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56502 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754953AbcITObh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 10:31:37 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ayala.beker@intel.com,
        andrei.otcheretianski@intel.com, arend.vanspriel@broadcom.com,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 20 Sep 2016 17:31:15 +0300
Message-Id: <20160920143121.28247-4-luca@coelho.fi> (sfid-20160920_163142_542352_79830710)
In-Reply-To: <20160920143121.28247-1-luca@coelho.fi>
References: <20160920143121.28247-1-luca@coelho.fi>
Subject: [PATCH v3 3/9] cfg80211: add add_nan_func / del_nan_func
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ayala Beker <ayala.beker@intel.com>

A NAN function can be either publish, subscribe or follow
up. Make all the necessary verifications and just pass the
request to the driver.
Allow the user space application that starts NAN to
forbid any other socket to add or remove functions.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Ayala Beker <ayala.beker@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h       |  91 +++++++++++
 include/uapi/linux/nl80211.h | 150 ++++++++++++++++++
 net/wireless/core.c          |   3 +-
 net/wireless/nl80211.c       | 369 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  21 +++
 net/wireless/trace.h         |  39 +++++
 net/wireless/util.c          |  22 +++
 7 files changed, 694 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a3ea4cc..093339c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2306,6 +2306,73 @@ struct cfg80211_nan_conf {
 };
 
 /**
+ * struct cfg80211_nan_func_filter - a NAN function Rx / Tx filter
+ *
+ * @filter: the content of the filter
+ * @len: the length of the filter
+ */
+struct cfg80211_nan_func_filter {
+	const u8 *filter;
+	u8 len;
+};
+
+/**
+ * struct cfg80211_nan_func - a NAN function
+ *
+ * @type: &enum nl80211_nan_function_type
+ * @service_id: the service ID of the function
+ * @publish_type: &nl80211_nan_publish_type
+ * @close_range: if true, the range should be limited. Threshold is
+ *	implementation specific.
+ * @publish_bcast: if true, the solicited publish should be broadcasted
+ * @subscribe_active: if true, the subscribe is active
+ * @followup_id: the instance ID for follow up
+ * @followup_reqid: the requestor instance ID for follow up
+ * @followup_dest: MAC address of the recipient of the follow up
+ * @ttl: time to live counter in DW.
+ * @serv_spec_info: Service Specific Info
+ * @serv_spec_info_len: Service Specific Info length
+ * @srf_include: if true, SRF is inclusive
+ * @srf_bf: Bloom Filter
+ * @srf_bf_len: Bloom Filter length
+ * @srf_bf_idx: Bloom Filter index
+ * @srf_macs: SRF MAC addresses
+ * @srf_num_macs: number of MAC addresses in SRF
+ * @rx_filters: rx filters that are matched with corresponding peer's tx_filter
+ * @tx_filters: filters that should be transmitted in the SDF.
+ * @num_rx_filters: length of &rx_filters.
+ * @num_tx_filters: length of &tx_filters.
+ * @instance_id: driver allocated id of the function.
+ * @cookie: unique NAN function identifier.
+ */
+struct cfg80211_nan_func {
+	enum nl80211_nan_function_type type;
+	u8 service_id[NL80211_NAN_FUNC_SERVICE_ID_LEN];
+	u8 publish_type;
+	bool close_range;
+	bool publish_bcast;
+	bool subscribe_active;
+	u8 followup_id;
+	u8 followup_reqid;
+	struct mac_address followup_dest;
+	u32 ttl;
+	const u8 *serv_spec_info;
+	u8 serv_spec_info_len;
+	bool srf_include;
+	const u8 *srf_bf;
+	u8 srf_bf_len;
+	u8 srf_bf_idx;
+	struct mac_address *srf_macs;
+	int srf_num_macs;
+	struct cfg80211_nan_func_filter *rx_filters;
+	struct cfg80211_nan_func_filter *tx_filters;
+	u8 num_tx_filters;
+	u8 num_rx_filters;
+	u8 instance_id;
+	u64 cookie;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -2595,6 +2662,14 @@ struct cfg80211_nan_conf {
  *	peers must be on the base channel when the call completes.
  * @start_nan: Start the NAN interface.
  * @stop_nan: Stop the NAN interface.
+ * @add_nan_func: Add a NAN function. Returns negative value on failure.
+ *	On success @nan_func ownership is transferred to the driver and
+ *	it may access it outside of the scope of this function. The driver
+ *	should free the @nan_func when no longer needed by calling
+ *	cfg80211_free_nan_func().
+ *	On success the driver should assign an instance_id in the
+ *	provided @nan_func.
+ * @del_nan_func: Delete a NAN function.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2863,6 +2938,10 @@ struct cfg80211_ops {
 	int	(*start_nan)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct cfg80211_nan_conf *conf);
 	void	(*stop_nan)(struct wiphy *wiphy, struct wireless_dev *wdev);
+	int	(*add_nan_func)(struct wiphy *wiphy, struct wireless_dev *wdev,
+				struct cfg80211_nan_func *nan_func);
+	void	(*del_nan_func)(struct wiphy *wiphy, struct wireless_dev *wdev,
+			       u64 cookie);
 };
 
 /*
@@ -3311,6 +3390,8 @@ struct wiphy_iftype_ext_capab {
  * @bss_select_support: bitmask indicating the BSS selection criteria supported
  *	by the driver in the .connect() callback. The bit position maps to the
  *	attribute indices defined in &enum nl80211_bss_select_attr.
+ *
+ * @cookie_counter: unique generic cookie counter, used to identify objects.
  */
 struct wiphy {
 	/* assign these fields before you register the wiphy */
@@ -3440,6 +3521,8 @@ struct wiphy {
 
 	u32 bss_select_support;
 
+	u64 cookie_counter;
+
 	char priv[0] __aligned(NETDEV_ALIGN);
 };
 
@@ -5529,6 +5612,14 @@ wiphy_ext_feature_isset(struct wiphy *wiphy,
 	return (ft_byte & BIT(ftidx % 8)) != 0;
 }
 
+/**
+ * cfg80211_free_nan_func - free NAN function
+ * @f: NAN function that should be freed
+ *
+ * Frees all the NAN function and all it's allocated members.
+ */
+void cfg80211_free_nan_func(struct cfg80211_nan_func *f);
+
 /* ethtool helper */
 void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info);
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index a34eb18..9f3172d 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -847,6 +847,21 @@
  *	After this command NAN functions can be added.
  * @NL80211_CMD_STOP_NAN: Stop the NAN operation, identified by
  *	its %NL80211_ATTR_WDEV interface.
+ * @NL80211_CMD_ADD_NAN_FUNCTION: Add a NAN function. The function is defined
+ *	with %NL80211_ATTR_NAN_FUNC nested attribute. When called, this
+ *	operation returns the strictly positive and unique instance id
+ *	(%NL80211_ATTR_NAN_FUNC_INST_ID) and a cookie (%NL80211_ATTR_COOKIE)
+ *	of the function upon success.
+ *	Since instance ID's can be re-used, this cookie is the right
+ *	way to identify the function. This will avoid races when a termination
+ *	event is handled by the user space after it has already added a new
+ *	function that got the same instance id from the kernel as the one
+ *	which just terminated.
+ *	This cookie may be used in NAN events even before the command
+ *	returns, so userspace shouldn't process NAN events until it processes
+ *	the response to this command.
+ *	Look at %NL80211_ATTR_SOCKET_OWNER as well.
+ * @NL80211_CMD_DEL_NAN_FUNCTION: Delete a NAN function by cookie.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1038,6 +1053,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_START_NAN,
 	NL80211_CMD_STOP_NAN,
+	NL80211_CMD_ADD_NAN_FUNCTION,
+	NL80211_CMD_DEL_NAN_FUNCTION,
 
 	/* add new commands above here */
 
@@ -1893,6 +1910,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_NAN_DUAL: NAN dual band operation config (see
  *	&enum nl80211_nan_dual_band_conf). This attribute is used with
  *	%NL80211_CMD_START_NAN.
+ * @NL80211_ATTR_NAN_FUNC: a function that can be added to NAN. See
+ *	&enum nl80211_nan_func_attributes for description of this nested
+ *	attribute.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2290,6 +2310,7 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_NAN_MASTER_PREF,
 	NL80211_ATTR_NAN_DUAL,
+	NL80211_ATTR_NAN_FUNC,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -4902,4 +4923,133 @@ enum nl80211_nan_dual_band_conf {
 	NL80211_NAN_BAND_5GHZ		= 1 << 2,
 };
 
+/**
+ * enum nl80211_nan_function_type - NAN function type
+ *
+ * Defines the function type of a NAN function
+ *
+ * @NL80211_NAN_FUNC_PUBLISH: function is publish
+ * @NL80211_NAN_FUNC_SUBSCRIBE: function is subscribe
+ * @NL80211_NAN_FUNC_FOLLOW_UP: function is follow-up
+ */
+enum nl80211_nan_function_type {
+	NL80211_NAN_FUNC_PUBLISH,
+	NL80211_NAN_FUNC_SUBSCRIBE,
+	NL80211_NAN_FUNC_FOLLOW_UP,
+
+	/* keep last */
+	__NL80211_NAN_FUNC_TYPE_AFTER_LAST,
+	NL80211_NAN_FUNC_MAX_TYPE = __NL80211_NAN_FUNC_TYPE_AFTER_LAST - 1,
+};
+
+/**
+ * enum nl80211_nan_publish_type - NAN publish tx type
+ *
+ * Defines how to send publish Service Discovery Frames
+ *
+ * @NL80211_NAN_SOLICITED_PUBLISH: publish function is solicited
+ * @NL80211_NAN_UNSOLICITED_PUBLISH: publish function is unsolicited
+ */
+enum nl80211_nan_publish_type {
+	NL80211_NAN_SOLICITED_PUBLISH = 1 << 0,
+	NL80211_NAN_UNSOLICITED_PUBLISH = 1 << 1,
+};
+
+#define NL80211_NAN_FUNC_SERVICE_ID_LEN 6
+#define NL80211_NAN_FUNC_SERVICE_SPEC_INFO_MAX_LEN 0xff
+#define NL80211_NAN_FUNC_SRF_MAX_LEN 0xff
+
+/**
+ * enum nl80211_nan_func_attributes - NAN function attributes
+ * @__NL80211_NAN_FUNC_INVALID: invalid
+ * @NL80211_NAN_FUNC_TYPE: &enum nl80211_nan_function_type (u8).
+ * @NL80211_NAN_FUNC_SERVICE_ID: 6 bytes of the service ID hash as
+ *	specified in NAN spec. This is a binary attribute.
+ * @NL80211_NAN_FUNC_PUBLISH_TYPE: relevant if the function's type is
+ *	publish. Defines the transmission type for the publish Service Discovery
+ *	Frame, see &enum nl80211_nan_publish_type. Its type is u8.
+ * @NL80211_NAN_FUNC_PUBLISH_BCAST: relevant if the function is a solicited
+ *	publish. Should the solicited publish Service Discovery Frame be sent to
+ *	the NAN Broadcast address. This is a flag.
+ * @NL80211_NAN_FUNC_SUBSCRIBE_ACTIVE: relevant if the function's type is
+ *	subscribe. Is the subscribe active. This is a flag.
+ * @NL80211_NAN_FUNC_FOLLOW_UP_ID: relevant if the function's type is follow up.
+ *	The instance ID for the follow up Service Discovery Frame. This is u8.
+ * @NL80211_NAN_FUNC_FOLLOW_UP_REQ_ID: relevant if the function's type
+ *	is follow up. This is a u8.
+ *	The requestor instance ID for the follow up Service Discovery Frame.
+ * @NL80211_NAN_FUNC_FOLLOW_UP_DEST: the MAC address of the recipient of the
+ *	follow up Service Discovery Frame. This is a binary attribute.
+ * @NL80211_NAN_FUNC_CLOSE_RANGE: is this function limited for devices in a
+ *	close range. The range itself (RSSI) is defined by the device.
+ *	This is a flag.
+ * @NL80211_NAN_FUNC_TTL: strictly positive number of DWs this function should
+ *	stay active. If not present infinite TTL is assumed. This is a u32.
+ * @NL80211_NAN_FUNC_SERVICE_INFO: array of bytes describing the service
+ *	specific info. This is a binary attribute.
+ * @NL80211_NAN_FUNC_SRF: Service Receive Filter. This is a nested attribute.
+ *	See &enum nl80211_nan_srf_attributes.
+ * @NL80211_NAN_FUNC_RX_MATCH_FILTER: Receive Matching filter. This is a nested
+ *	attribute. It is a list of binary values.
+ * @NL80211_NAN_FUNC_TX_MATCH_FILTER: Transmit Matching filter. This is a
+ *	nested attribute. It is a list of binary values.
+ * @NL80211_NAN_FUNC_INSTANCE_ID: The instance ID of the function.
+ *	Its type is u8 and it cannot be 0.
+ * @NL80211_NAN_FUNC_TERM_REASON: NAN function termination reason.
+ *	See &enum nl80211_nan_func_term_reason.
+ *
+ * @NUM_NL80211_NAN_FUNC_ATTR: internal
+ * @NL80211_NAN_FUNC_ATTR_MAX: highest NAN function attribute
+ */
+enum nl80211_nan_func_attributes {
+	__NL80211_NAN_FUNC_INVALID,
+	NL80211_NAN_FUNC_TYPE,
+	NL80211_NAN_FUNC_SERVICE_ID,
+	NL80211_NAN_FUNC_PUBLISH_TYPE,
+	NL80211_NAN_FUNC_PUBLISH_BCAST,
+	NL80211_NAN_FUNC_SUBSCRIBE_ACTIVE,
+	NL80211_NAN_FUNC_FOLLOW_UP_ID,
+	NL80211_NAN_FUNC_FOLLOW_UP_REQ_ID,
+	NL80211_NAN_FUNC_FOLLOW_UP_DEST,
+	NL80211_NAN_FUNC_CLOSE_RANGE,
+	NL80211_NAN_FUNC_TTL,
+	NL80211_NAN_FUNC_SERVICE_INFO,
+	NL80211_NAN_FUNC_SRF,
+	NL80211_NAN_FUNC_RX_MATCH_FILTER,
+	NL80211_NAN_FUNC_TX_MATCH_FILTER,
+	NL80211_NAN_FUNC_INSTANCE_ID,
+	NL80211_NAN_FUNC_TERM_REASON,
+
+	/* keep last */
+	NUM_NL80211_NAN_FUNC_ATTR,
+	NL80211_NAN_FUNC_ATTR_MAX = NUM_NL80211_NAN_FUNC_ATTR - 1
+};
+
+/**
+ * enum nl80211_nan_srf_attributes - NAN Service Response filter attributes
+ * @__NL80211_NAN_SRF_INVALID: invalid
+ * @NL80211_NAN_SRF_INCLUDE: present if the include bit of the SRF set.
+ *	This is a flag.
+ * @NL80211_NAN_SRF_BF: Bloom Filter. Present if and only if
+ *	&NL80211_NAN_SRF_MAC_ADDRS isn't present. This attribute is binary.
+ * @NL80211_NAN_SRF_BF_IDX: index of the Bloom Filter. Mandatory if
+ *	&NL80211_NAN_SRF_BF is present. This is a u8.
+ * @NL80211_NAN_SRF_MAC_ADDRS: list of MAC addresses for the SRF. Present if
+ *	and only if &NL80211_NAN_SRF_BF isn't present. This is a nested
+ *	attribute. Each nested attribute is a MAC address.
+ * @NUM_NL80211_NAN_SRF_ATTR: internal
+ * @NL80211_NAN_SRF_ATTR_MAX: highest NAN SRF attribute
+ */
+enum nl80211_nan_srf_attributes {
+	__NL80211_NAN_SRF_INVALID,
+	NL80211_NAN_SRF_INCLUDE,
+	NL80211_NAN_SRF_BF,
+	NL80211_NAN_SRF_BF_IDX,
+	NL80211_NAN_SRF_MAC_ADDRS,
+
+	/* keep last */
+	NUM_NL80211_NAN_SRF_ATTR,
+	NL80211_NAN_SRF_ATTR_MAX = NUM_NL80211_NAN_SRF_ATTR - 1,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 0139872..8201e6d 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -605,7 +605,8 @@ int wiphy_register(struct wiphy *wiphy)
 		return -EINVAL;
 
 	if (WARN_ON((wiphy->interface_modes & BIT(NL80211_IFTYPE_NAN)) &&
-		    (!rdev->ops->start_nan || !rdev->ops->stop_nan)))
+		    (!rdev->ops->start_nan || !rdev->ops->stop_nan ||
+		     !rdev->ops->add_nan_func || !rdev->ops->del_nan_func)))
 		return -EINVAL;
 
 	/*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 0f3bef6..8ec803b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -411,6 +411,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_MU_MIMO_FOLLOW_MAC_ADDR] = { .len = ETH_ALEN },
 	[NL80211_ATTR_NAN_MASTER_PREF] = { .type = NLA_U8 },
 	[NL80211_ATTR_NAN_DUAL] = { .type = NLA_U8 },
+	[NL80211_ATTR_NAN_FUNC] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -504,6 +505,39 @@ nl80211_bss_select_policy[NL80211_BSS_SELECT_ATTR_MAX + 1] = {
 	},
 };
 
+/* policy for NAN function attributes */
+static const struct nla_policy
+nl80211_nan_func_policy[NL80211_NAN_FUNC_ATTR_MAX + 1] = {
+	[NL80211_NAN_FUNC_TYPE] = { .type = NLA_U8 },
+	[NL80211_NAN_FUNC_SERVICE_ID] = { .type = NLA_BINARY,
+				    .len = NL80211_NAN_FUNC_SERVICE_ID_LEN },
+	[NL80211_NAN_FUNC_PUBLISH_TYPE] = { .type = NLA_U8 },
+	[NL80211_NAN_FUNC_PUBLISH_BCAST] = { .type = NLA_FLAG },
+	[NL80211_NAN_FUNC_SUBSCRIBE_ACTIVE] = { .type = NLA_FLAG },
+	[NL80211_NAN_FUNC_FOLLOW_UP_ID] = { .type = NLA_U8 },
+	[NL80211_NAN_FUNC_FOLLOW_UP_REQ_ID] = { .type = NLA_U8 },
+	[NL80211_NAN_FUNC_FOLLOW_UP_DEST] = { .len = ETH_ALEN },
+	[NL80211_NAN_FUNC_CLOSE_RANGE] = { .type = NLA_FLAG },
+	[NL80211_NAN_FUNC_TTL] = { .type = NLA_U32 },
+	[NL80211_NAN_FUNC_SERVICE_INFO] = { .type = NLA_BINARY,
+			.len = NL80211_NAN_FUNC_SERVICE_SPEC_INFO_MAX_LEN },
+	[NL80211_NAN_FUNC_SRF] = { .type = NLA_NESTED },
+	[NL80211_NAN_FUNC_RX_MATCH_FILTER] = { .type = NLA_NESTED },
+	[NL80211_NAN_FUNC_TX_MATCH_FILTER] = { .type = NLA_NESTED },
+	[NL80211_NAN_FUNC_INSTANCE_ID] = { .type = NLA_U8 },
+	[NL80211_NAN_FUNC_TERM_REASON] = { .type = NLA_U8 },
+};
+
+/* policy for Service Response Filter attributes */
+static const struct nla_policy
+nl80211_nan_srf_policy[NL80211_NAN_SRF_ATTR_MAX + 1] = {
+	[NL80211_NAN_SRF_INCLUDE] = { .type = NLA_FLAG },
+	[NL80211_NAN_SRF_BF] = { .type = NLA_BINARY,
+				 .len =  NL80211_NAN_FUNC_SRF_MAX_LEN },
+	[NL80211_NAN_SRF_BF_IDX] = { .type = NLA_U8 },
+	[NL80211_NAN_SRF_MAC_ADDRS] = { .type = NLA_NESTED },
+};
+
 static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 				     struct netlink_callback *cb,
 				     struct cfg80211_registered_device **rdev,
@@ -10476,6 +10510,325 @@ static int nl80211_stop_nan(struct sk_buff *skb, struct genl_info *info)
 	return 0;
 }
 
+static int validate_nan_filter(struct nlattr *filter_attr)
+{
+	struct nlattr *attr;
+	int len = 0, n_entries = 0, rem;
+
+	nla_for_each_nested(attr, filter_attr, rem) {
+		len += nla_len(attr);
+		n_entries++;
+	}
+
+	if (len >= U8_MAX)
+		return -EINVAL;
+
+	return n_entries;
+}
+
+static int handle_nan_filter(struct nlattr *attr_filter,
+			     struct cfg80211_nan_func *func,
+			     bool tx)
+{
+	struct nlattr *attr;
+	int n_entries, rem, i;
+	struct cfg80211_nan_func_filter *filter;
+
+	n_entries = validate_nan_filter(attr_filter);
+	if (n_entries < 0)
+		return n_entries;
+
+	BUILD_BUG_ON(sizeof(*func->rx_filters) != sizeof(*func->tx_filters));
+
+	filter = kcalloc(n_entries, sizeof(*func->rx_filters), GFP_KERNEL);
+	if (!filter)
+		return -ENOMEM;
+
+	i = 0;
+	nla_for_each_nested(attr, attr_filter, rem) {
+		filter[i].filter = kmemdup(nla_data(attr), nla_len(attr),
+					   GFP_KERNEL);
+		filter[i].len = nla_len(attr);
+		i++;
+	}
+	if (tx) {
+		func->num_tx_filters = n_entries;
+		func->tx_filters = filter;
+	} else {
+		func->num_rx_filters = n_entries;
+		func->rx_filters = filter;
+	}
+
+	return 0;
+}
+
+static int nl80211_nan_add_func(struct sk_buff *skb,
+				struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	struct nlattr *tb[NUM_NL80211_NAN_FUNC_ATTR], *func_attr;
+	struct cfg80211_nan_func *func;
+	struct sk_buff *msg = NULL;
+	void *hdr = NULL;
+	int err = 0;
+
+	if (wdev->iftype != NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
+	if (!wdev->nan_started)
+		return -ENOTCONN;
+
+	if (!info->attrs[NL80211_ATTR_NAN_FUNC])
+		return -EINVAL;
+
+	if (wdev->owner_nlportid &&
+	    wdev->owner_nlportid != info->snd_portid)
+		return -ENOTCONN;
+
+	err = nla_parse(tb, NL80211_NAN_FUNC_ATTR_MAX,
+			nla_data(info->attrs[NL80211_ATTR_NAN_FUNC]),
+			nla_len(info->attrs[NL80211_ATTR_NAN_FUNC]),
+			nl80211_nan_func_policy);
+	if (err)
+		return err;
+
+	func = kzalloc(sizeof(*func), GFP_KERNEL);
+	if (!func)
+		return -ENOMEM;
+
+	func->cookie = wdev->wiphy->cookie_counter++;
+
+	if (!tb[NL80211_NAN_FUNC_TYPE] ||
+	    nla_get_u8(tb[NL80211_NAN_FUNC_TYPE]) > NL80211_NAN_FUNC_MAX_TYPE) {
+		err = -EINVAL;
+		goto out;
+	}
+
+
+	func->type = nla_get_u8(tb[NL80211_NAN_FUNC_TYPE]);
+
+	if (!tb[NL80211_NAN_FUNC_SERVICE_ID]) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	memcpy(func->service_id, nla_data(tb[NL80211_NAN_FUNC_SERVICE_ID]),
+	       sizeof(func->service_id));
+
+	func->close_range =
+		nla_get_flag(tb[NL80211_NAN_FUNC_CLOSE_RANGE]);
+
+	if (tb[NL80211_NAN_FUNC_SERVICE_INFO]) {
+		func->serv_spec_info_len =
+			nla_len(tb[NL80211_NAN_FUNC_SERVICE_INFO]);
+		func->serv_spec_info =
+			kmemdup(nla_data(tb[NL80211_NAN_FUNC_SERVICE_INFO]),
+				func->serv_spec_info_len,
+				GFP_KERNEL);
+		if (!func->serv_spec_info) {
+			err = -ENOMEM;
+			goto out;
+		}
+	}
+
+	if (tb[NL80211_NAN_FUNC_TTL])
+		func->ttl = nla_get_u32(tb[NL80211_NAN_FUNC_TTL]);
+
+	switch (func->type) {
+	case NL80211_NAN_FUNC_PUBLISH:
+		if (!tb[NL80211_NAN_FUNC_PUBLISH_TYPE]) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		func->publish_type =
+			nla_get_u8(tb[NL80211_NAN_FUNC_PUBLISH_TYPE]);
+		func->publish_bcast =
+			nla_get_flag(tb[NL80211_NAN_FUNC_PUBLISH_BCAST]);
+
+		if ((!(func->publish_type & NL80211_NAN_SOLICITED_PUBLISH)) &&
+			func->publish_bcast) {
+			err = -EINVAL;
+			goto out;
+		}
+		break;
+	case NL80211_NAN_FUNC_SUBSCRIBE:
+		func->subscribe_active =
+			nla_get_flag(tb[NL80211_NAN_FUNC_SUBSCRIBE_ACTIVE]);
+		break;
+	case NL80211_NAN_FUNC_FOLLOW_UP:
+		if (!tb[NL80211_NAN_FUNC_FOLLOW_UP_ID] ||
+		    !tb[NL80211_NAN_FUNC_FOLLOW_UP_REQ_ID]) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		func->followup_id =
+			nla_get_u8(tb[NL80211_NAN_FUNC_FOLLOW_UP_ID]);
+		func->followup_reqid =
+			nla_get_u8(tb[NL80211_NAN_FUNC_FOLLOW_UP_REQ_ID]);
+		memcpy(func->followup_dest.addr,
+		       nla_data(tb[NL80211_NAN_FUNC_FOLLOW_UP_DEST]),
+		       sizeof(func->followup_dest.addr));
+		if (func->ttl) {
+			err = -EINVAL;
+			goto out;
+		}
+		break;
+	default:
+		err = -EINVAL;
+		goto out;
+	}
+
+	if (tb[NL80211_NAN_FUNC_SRF]) {
+		struct nlattr *srf_tb[NUM_NL80211_NAN_SRF_ATTR];
+
+		err = nla_parse(srf_tb, NL80211_NAN_SRF_ATTR_MAX,
+				nla_data(tb[NL80211_NAN_FUNC_SRF]),
+				nla_len(tb[NL80211_NAN_FUNC_SRF]), NULL);
+		if (err)
+			goto out;
+
+		func->srf_include =
+			nla_get_flag(srf_tb[NL80211_NAN_SRF_INCLUDE]);
+
+		if (srf_tb[NL80211_NAN_SRF_BF]) {
+			if (srf_tb[NL80211_NAN_SRF_MAC_ADDRS] ||
+			    !srf_tb[NL80211_NAN_SRF_BF_IDX]) {
+				err = -EINVAL;
+				goto out;
+			}
+
+			func->srf_bf_len =
+				nla_len(srf_tb[NL80211_NAN_SRF_BF]);
+			func->srf_bf =
+				kmemdup(nla_data(srf_tb[NL80211_NAN_SRF_BF]),
+					func->srf_bf_len, GFP_KERNEL);
+			if (!func->srf_bf) {
+				err = -ENOMEM;
+				goto out;
+			}
+
+			func->srf_bf_idx =
+				nla_get_u8(srf_tb[NL80211_NAN_SRF_BF_IDX]);
+		} else {
+			struct nlattr *attr, *mac_attr =
+				srf_tb[NL80211_NAN_SRF_MAC_ADDRS];
+			int n_entries, rem, i = 0;
+
+			if (!mac_attr) {
+				err = -EINVAL;
+				goto out;
+			}
+
+			n_entries = validate_acl_mac_addrs(mac_attr);
+			if (n_entries <= 0) {
+				err = -EINVAL;
+				goto out;
+			}
+
+			func->srf_num_macs = n_entries;
+			func->srf_macs =
+				kzalloc(sizeof(*func->srf_macs) * n_entries,
+					GFP_KERNEL);
+			if (!func->srf_macs) {
+				err = -ENOMEM;
+				goto out;
+			}
+
+			nla_for_each_nested(attr, mac_attr, rem)
+				memcpy(func->srf_macs[i++].addr, nla_data(attr),
+				       sizeof(*func->srf_macs));
+		}
+	}
+
+	if (tb[NL80211_NAN_FUNC_TX_MATCH_FILTER]) {
+		err = handle_nan_filter(tb[NL80211_NAN_FUNC_TX_MATCH_FILTER],
+					func, true);
+		if (err)
+			goto out;
+	}
+
+	if (tb[NL80211_NAN_FUNC_RX_MATCH_FILTER]) {
+		err = handle_nan_filter(tb[NL80211_NAN_FUNC_RX_MATCH_FILTER],
+					func, false);
+		if (err)
+			goto out;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
+			     NL80211_CMD_ADD_NAN_FUNCTION);
+	/* This can't really happen - we just allocated 4KB */
+	if (WARN_ON(!hdr)) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = rdev_add_nan_func(rdev, wdev, func);
+out:
+	if (err < 0) {
+		cfg80211_free_nan_func(func);
+		nlmsg_free(msg);
+		return err;
+	}
+
+	/* propagate the instance id and cookie to userspace  */
+	if (nla_put_u64_64bit(msg, NL80211_ATTR_COOKIE, func->cookie,
+			      NL80211_ATTR_PAD))
+		goto nla_put_failure;
+
+	func_attr = nla_nest_start(msg, NL80211_ATTR_NAN_FUNC);
+	if (!func_attr)
+		goto nla_put_failure;
+
+	if (nla_put_u8(msg, NL80211_NAN_FUNC_INSTANCE_ID,
+		       func->instance_id))
+		goto nla_put_failure;
+
+	nla_nest_end(msg, func_attr);
+
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, info);
+
+nla_put_failure:
+	nlmsg_free(msg);
+	return -ENOBUFS;
+}
+
+static int nl80211_nan_del_func(struct sk_buff *skb,
+			       struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	u64 cookie;
+
+	if (wdev->iftype != NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
+	if (!wdev->nan_started)
+		return -ENOTCONN;
+
+	if (!info->attrs[NL80211_ATTR_COOKIE])
+		return -EINVAL;
+
+	if (wdev->owner_nlportid &&
+	    wdev->owner_nlportid != info->snd_portid)
+		return -ENOTCONN;
+
+	cookie = nla_get_u64(info->attrs[NL80211_ATTR_COOKIE]);
+
+	rdev_del_nan_func(rdev, wdev, cookie);
+
+	return 0;
+}
+
 static int nl80211_get_protocol_features(struct sk_buff *skb,
 					 struct genl_info *info)
 {
@@ -11834,6 +12187,22 @@ static const struct genl_ops nl80211_ops[] = {
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
+		.cmd = NL80211_CMD_ADD_NAN_FUNCTION,
+		.doit = nl80211_nan_add_func,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_DEL_NAN_FUNCTION,
+		.doit = nl80211_nan_del_func,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
 		.cmd = NL80211_CMD_SET_MCAST_RATE,
 		.doit = nl80211_set_mcast_rate,
 		.policy = nl80211_policy,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index afb68a8..98c4c3b 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -907,6 +907,27 @@ static inline void rdev_stop_nan(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline int
+rdev_add_nan_func(struct cfg80211_registered_device *rdev,
+		  struct wireless_dev *wdev,
+		  struct cfg80211_nan_func *nan_func)
+{
+	int ret;
+
+	trace_rdev_add_nan_func(&rdev->wiphy, wdev, nan_func);
+	ret = rdev->ops->add_nan_func(&rdev->wiphy, wdev, nan_func);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline void rdev_del_nan_func(struct cfg80211_registered_device *rdev,
+				    struct wireless_dev *wdev, u64 cookie)
+{
+	trace_rdev_del_nan_func(&rdev->wiphy, wdev, cookie);
+	rdev->ops->del_nan_func(&rdev->wiphy, wdev, cookie);
+	trace_rdev_return_void(&rdev->wiphy);
+}
+
 static inline int rdev_set_mac_acl(struct cfg80211_registered_device *rdev,
 				   struct net_device *dev,
 				   struct cfg80211_acl_data *params)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 5f3370f..5608984 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1916,6 +1916,45 @@ DEFINE_EVENT(wiphy_wdev_evt, rdev_stop_nan,
 	TP_ARGS(wiphy, wdev)
 );
 
+TRACE_EVENT(rdev_add_nan_func,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 const struct cfg80211_nan_func *func),
+	TP_ARGS(wiphy, wdev, func),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u8, func_type)
+		__field(u64, cookie)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->func_type = func->type;
+		__entry->cookie = func->cookie
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", type=%u, cookie=%llu",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->func_type,
+		  __entry->cookie)
+);
+
+TRACE_EVENT(rdev_del_nan_func,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 u64 cookie),
+	TP_ARGS(wiphy, wdev, cookie),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u64, cookie)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->cookie = cookie;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", cookie=%llu",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->cookie)
+);
+
 TRACE_EVENT(rdev_set_mac_acl,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 struct cfg80211_acl_data *params),
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 91868e0..91bae35 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1762,6 +1762,28 @@ int cfg80211_get_station(struct net_device *dev, const u8 *mac_addr,
 }
 EXPORT_SYMBOL(cfg80211_get_station);
 
+void cfg80211_free_nan_func(struct cfg80211_nan_func *f)
+{
+	int i;
+
+	if (!f)
+		return;
+
+	kfree(f->serv_spec_info);
+	kfree(f->srf_bf);
+	kfree(f->srf_macs);
+	for (i = 0; i < f->num_rx_filters; i++)
+		kfree(f->rx_filters[i].filter);
+
+	for (i = 0; i < f->num_tx_filters; i++)
+		kfree(f->tx_filters[i].filter);
+
+	kfree(f->rx_filters);
+	kfree(f->tx_filters);
+	kfree(f);
+}
+EXPORT_SYMBOL(cfg80211_free_nan_func);
+
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
 const unsigned char rfc1042_header[] __aligned(2) =
-- 
2.9.3
