Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:6821 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbbIQOd3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 10:33:29 -0400
From: andrei.otcheretianski@intel.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [RFC 3/7] cfg80211: add add_nan_func / rm_nan_func
Date: Thu, 17 Sep 2015 17:32:27 +0300
Message-Id: <1442500351-8780-4-git-send-email-andrei.otcheretianski@intel.com> (sfid-20150917_163350_971471_01451B3A)
In-Reply-To: <1442500351-8780-1-git-send-email-andrei.otcheretianski@intel.com>
References: <1442500351-8780-1-git-send-email-andrei.otcheretianski@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

A NAN function can be either publish, subscribe or follow
up. Make all the necessary verifications and just pass the
request to the driver.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
---
 include/net/cfg80211.h       |  73 ++++++++++-
 include/uapi/linux/nl80211.h | 138 +++++++++++++++++++
 net/wireless/core.c          |   3 +-
 net/wireless/nl80211.c       | 306 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  22 ++++
 net/wireless/trace.h         |  36 +++++
 6 files changed, 575 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index dcf8a74..12203db 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2198,6 +2198,68 @@ struct cfg80211_nan_conf {
 	u8 dual;
 };
 
+/**
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
+ * @discovery_range: if true, the range should be limited. Threshold is
+ *	implementation specific.
+ * @publish_bcast: if true, the solicited publish should transmit BCAST
+ * @subscribe_active: if true, the subscribe is active
+ * @followup_id: the instance ID for follow up
+ * @followup_reqid: the requestor instance ID for follow up
+ * @followup_dest: MAC address of the recipient of the follow up
+ * @ttl: time to live
+ * @serv_spec_info: Service Specific Info
+ * @serv_spec_info_len: Service Specific Info length
+ * @srf_include: if true, SRF is inclusive
+ * @srf_bf: Bloom Filter
+ * @srf_bf_len: Bloom Filter length
+ * @srf_bf_idx: Blook Filter index
+ * @srf_macs: SRF MAC addresses
+ * @srf_num_macs: number of MAC addresses in SRF
+ * @rx_filters: points to an array of &struct cfg80211_nan_func_filter
+ * @tx_filters: points to an array of &struct cfg80211_nan_func_filter
+ * @num_rx_filters: size of &rx_filters.
+ * @num_tx_filters: size of &tx_filters.
+ */
+struct cfg80211_nan_func {
+	enum nl80211_nan_function_type type;
+	u8 service_id[NL80211_NAN_FUNC_SERVICE_ID_LEN];
+	u8 publish_type;
+	bool discovery_range;
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
+	unsigned int num_tx_filters;
+	unsigned int num_rx_filters;
+};
 
 /**
  * struct cfg80211_ops - backend description for wireless configuration
@@ -2469,8 +2531,11 @@ struct cfg80211_nan_conf {
  *
  * @start_nan: Start the NAN interface.
  * @stop_nan: Stop the NAN interface.
- *
-  */
+ * @add_nan_func: Add a nan function. Returns a stricly positive instance id
+ *	upon success. The data in cfg80211_nan_func must not be referenced
+ *	outside the scope of this call.
+ * @rm_nan_func: Remove a nan function.
+ */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
 	int	(*resume)(struct wiphy *wiphy);
@@ -2737,6 +2802,10 @@ struct cfg80211_ops {
 	int	(*start_nan)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct cfg80211_nan_conf *conf);
 	void	(*stop_nan)(struct wiphy *wiphy, struct wireless_dev *wdev);
+	int	(*add_nan_func)(struct wiphy *wiphy, struct wireless_dev *wdev,
+				const struct cfg80211_nan_func *nan_func);
+	void	(*rm_nan_func)(struct wiphy *wiphy, struct wireless_dev *wdev,
+				   u8 instance_id);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 16d9553..699aa89 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -820,6 +820,12 @@
  *	After this command NAN functions can be added.
  * @NL80211_CMD_STOP_NAN: Stop the NAN operation, identified by
  *	its %NL80211_ATTR_WDEV identifier.
+ * @NL80211_CMD_ADD_NAN_FUNCTION: add a NAN function. The function a
+ *	%NL80211_ATTR_NAN_FUNC attribute. When called, this operation returns
+ *	the strictly positive instance id (%NL80211_ATTR_NAN_FUNC_INST_ID) of
+ *	the function upon success.
+ * @NL80211_CMD_RM_NAN_FUNCTION: remove a NAN function based on its instance
+ *	id.
  *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
@@ -1009,6 +1015,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_START_NAN,
 	NL80211_CMD_STOP_NAN,
+	NL80211_CMD_ADD_NAN_FUNCTION,
+	NL80211_CMD_RM_NAN_FUNCTION,
 
 	/* add new commands above here */
 
@@ -1782,6 +1790,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_NAN_DUAL: Optional NaN dual band operation config
  *	(0: device default, 1: 2.4Ghz, 2: Dual). If not provided, the device
  *	will decide. This attribute is used with &NL80211_CMD_START_NAN.
+ * @NL80211_ATTR_NAN_FUNC: a function that can be added to NAN. See
+ *	&enum nl80211_nan_func_attributes for description of this nested
+ *	attribute.
+ * @NL80211_ATTR_NAN_FUNC_INST_ID: the instance id of a %NL80211_ATTR_NAN_FUNC.
+ *	Its type is u8 and it cannot be 0.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2155,6 +2168,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_NAN_MASTER_PREF,
 	NL80211_ATTR_NAN_CLUSTER_ID,
 	NL80211_ATTR_NAN_DUAL,
+	NL80211_ATTR_NAN_FUNC,
+	NL80211_ATTR_NAN_FUNC_INST_ID,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -4617,4 +4632,127 @@ enum nl80211_tdls_peer_capability {
 	NL80211_TDLS_PEER_WMM = 1<<2,
 };
 
+/**
+ * enum nl80211_nan_function_type - NAN function type
+ *
+ * Defines the function type of a NAN function
+ *
+ * @NL80211_NAN_FUNC_PUBLISH: function is publish
+ * @NL80211_NAN_FUNC_SUBSCRIBE: function is subscribe
+ * @NL80211_NAN_FUNC_FOLLOW_UP: function is follow-up
+ * @NL80211_NAN_FUNC_MAX_TYPE: must be last
+ */
+enum nl80211_nan_function_type {
+	NL80211_NAN_FUNC_PUBLISH,
+	NL80211_NAN_FUNC_SUBSCRIBE,
+	NL80211_NAN_FUNC_FOLLOW_UP,
+
+	NL80211_NAN_FUNC_MAX_TYPE,
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
+	NL80211_NAN_SOLICITED_PUBLISH = 1<<0,
+	NL80211_NAN_UNSOLICITED_PUBLISH = 1<<1,
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
+ * @NL80211_NAN_FUNC_PUBLISH_BCAST: relevant if the function's type is publish.
+ *	Should the publish Service Discovery Frame be sent in to NAN Broadcast
+ *	address. This is a flag.
+ * @NL80211_NAN_FUNC_SUBSCRIBE_ACTIVE: relevant if the function's type is
+ *	subscribe. Is the subscribe active. This is a flag.
+ * @NL80211_NAN_FUNC_FOLLOW_UP_ID: relevant if the function's type is follow up.
+ *	The instance ID for the follow up Service Discovery Frame. This is u8.
+ * @NL80211_NAN_FUNC_FOLLOW_UP_REQ_ID: relevant if the function's type
+ *	is follow up. This is a u8.
+ *	The requestor instance ID for the follow up Service Discovery Frame.
+ * @NL80211_NAN_FUNC_FOLLOW_UP_DEST: the MAC address of the recipient of the
+ *	follow up Service Discovery Frame. This is a binary attribute.
+ * @NL80211_NAN_FUNC_DISCOVERY_RANGE: is this function limited for devices in a
+ *	certain range. This is a flag.
+ * @NL80211_NAN_FUNC_TTL: number of DWs this function should stay active. 0 is
+ *	equivalent to no TTL at all. This is a u32.
+ * @NL80211_NAN_FUNC_SERVICE_INFO: array of bytes describing the service
+ *	specific info. This is a binary attribute.
+ * @NL80211_NAN_FUNC_SRF: Service Receive Filter. This is a nested attribute.
+ *	See &enum nl80211_nan_srf_attributes.
+ * @NL80211_NAN_FUNC_RX_MATCH_FILTER: Receive Matching filter. This is a nested
+ *	attribute. It is a list of binary values.
+ * @NL80211_NAN_FUNC_TX_MATCH_FILTER: Transmit Matching filter. This is a
+ *	nested attribute. It is a list of binary values.
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
+	NL80211_NAN_FUNC_DISCOVERY_RANGE,
+	NL80211_NAN_FUNC_TTL,
+	NL80211_NAN_FUNC_SERVICE_INFO,
+	NL80211_NAN_FUNC_SRF,
+	NL80211_NAN_FUNC_RX_MATCH_FILTER,
+	NL80211_NAN_FUNC_TX_MATCH_FILTER,
+
+	/* keep last */
+	NUM_NL80211_NAN_FUNC_ATTR,
+	NL80211_NAN_FUNC_ATTR_MAX = NUM_NL80211_NAN_FUNC_ATTR - 1
+};
+
+/**
+ * enum nl80211_nan_srf_attributes - NAN Service Response filter attributes
+ * @__NL80211_NAN_SRF_INVALID: invalid
+ * @NL80211_NAN_SRF_INCLUDE: true if the include bit of the SRF set.
+ *	This is a flag.
+ * @NL80211_NAN_SRF_TYPE_BF: true if the SRF is a Bloom Filter SRF. If false
+ *	the SRF will be &NL80211_ATTR_MAC_ADDRS. This is a flag.
+ * @NL80211_NAN_SRF_BF: Bloom Filter. Relevant and mandatory if
+ *	&NL80211_NAN_SRF_TYPE_BF is true. This attribute is binary.
+ * @NL80211_NAN_SRF_BF_IDX: index of the Bloom Filter. Relevant and
+ *	mandatory if &NL80211_NAN_SRF_TYPE_BF is true. This is a u8.
+ * @NL80211_NAN_SRF_MAC_ADDRS: list of MAC addresses for the SRF. Relevant and
+ *	mandatory if &NL80211_NAN_SRF_TYPE_BF is false. This is a nested
+ *	attribute. Each nested attribute is a MAC address.
+ * @NUM_NL80211_NAN_SRF_ATTR: internal
+ * @NL80211_NAN_SRF_ATTR_MAX: highest NAN SRF attribute
+ */
+enum nl80211_nan_srf_attributes {
+	__NL80211_NAN_SRF_INVALID,
+	NL80211_NAN_SRF_INCLUDE,
+	NL80211_NAN_SRF_TYPE_BF,
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
index 1e83790..4948a82 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -591,7 +591,8 @@ int wiphy_register(struct wiphy *wiphy)
 		return -EINVAL;
 
 	if (WARN_ON((wiphy->interface_modes & BIT(NL80211_IFTYPE_NAN)) &&
-		    (!rdev->ops->start_nan || !rdev->ops->stop_nan)))
+		    (!rdev->ops->start_nan || !rdev->ops->stop_nan ||
+		     !rdev->ops->add_nan_func || !rdev->ops->rm_nan_func)))
 		return -EINVAL;
 
 	/*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 51bfeb0..d7106d4 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -404,6 +404,8 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_NAN_MASTER_PREF] = { .type = NLA_U8 },
 	[NL80211_ATTR_NAN_CLUSTER_ID] = { .type = NLA_U16 },
 	[NL80211_ATTR_NAN_DUAL] = { .type = NLA_U8 },
+	[NL80211_ATTR_NAN_FUNC] = { .type = NLA_NESTED },
+	[NL80211_ATTR_NAN_FUNC_INST_ID] = { .type = NLA_U8 },
 };
 
 /* policy for the key attributes */
@@ -482,6 +484,38 @@ nl80211_match_policy[NL80211_SCHED_SCAN_MATCH_ATTR_MAX + 1] = {
 	[NL80211_SCHED_SCAN_MATCH_ATTR_RSSI] = { .type = NLA_U32 },
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
+	[NL80211_NAN_FUNC_DISCOVERY_RANGE] = { .type = NLA_FLAG },
+	[NL80211_NAN_FUNC_TTL] = { .type = NLA_U32 },
+	[NL80211_NAN_FUNC_SERVICE_INFO] = { .type = NLA_BINARY,
+					    .len = NL80211_NAN_FUNC_SERVICE_SPEC_INFO_MAX_LEN },
+	[NL80211_NAN_FUNC_SRF] = { .type = NLA_NESTED },
+	[NL80211_NAN_FUNC_RX_MATCH_FILTER] = { .type = NLA_NESTED },
+	[NL80211_NAN_FUNC_TX_MATCH_FILTER] = { .type = NLA_NESTED },
+};
+
+/* policy for Service Response Filter attributes */
+static const struct nla_policy
+nl80211_nan_srf_policy[NL80211_NAN_SRF_ATTR_MAX + 1] = {
+	[NL80211_NAN_SRF_INCLUDE] = { .type = NLA_FLAG },
+	[NL80211_NAN_SRF_TYPE_BF] = { .type = NLA_FLAG },
+	[NL80211_NAN_SRF_BF] = { .type = NLA_BINARY,
+				 .len =  NL80211_NAN_FUNC_SRF_MAX_LEN },
+	[NL80211_NAN_SRF_BF_IDX] = { .type = NLA_U8 },
+	[NL80211_NAN_SRF_MAC_ADDRS] = { .type = NLA_NESTED },
+};
+
 static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 				     struct netlink_callback *cb,
 				     struct cfg80211_registered_device **rdev,
@@ -9860,6 +9894,262 @@ static int nl80211_stop_nan(struct sk_buff *skb, struct genl_info *info)
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
+		return -EINVAL;
+
+	BUILD_BUG_ON(sizeof(*func->rx_filters) != sizeof(*func->tx_filters));
+
+	filter = kcalloc(n_entries, sizeof(*func->rx_filters), GFP_KERNEL);
+	if (!filter)
+		return -ENOMEM;
+
+	i = 0;
+	nla_for_each_nested(attr, attr_filter, rem) {
+		filter[i].filter = nla_data(attr);
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
+	struct nlattr *tb[NUM_NL80211_NAN_FUNC_ATTR];
+	struct cfg80211_nan_func func = {};
+	struct sk_buff *msg = NULL;
+	void *hdr = NULL;
+	int err, inst_id = 0;
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
+	err = nla_parse(tb, NL80211_NAN_FUNC_ATTR_MAX,
+			nla_data(info->attrs[NL80211_ATTR_NAN_FUNC]),
+			nla_len(info->attrs[NL80211_ATTR_NAN_FUNC]),
+			nl80211_nan_func_policy);
+
+	if (err)
+		return err;
+
+	if (!tb[NL80211_NAN_FUNC_TYPE] ||
+	    nla_get_u8(tb[NL80211_NAN_FUNC_TYPE]) >= NL80211_NAN_FUNC_MAX_TYPE)
+		return -EINVAL;
+
+	func.type = nla_get_u8(tb[NL80211_NAN_FUNC_TYPE]);
+
+	if (!tb[NL80211_NAN_FUNC_SERVICE_ID])
+		return -EINVAL;
+
+	memcpy(func.service_id, nla_data(tb[NL80211_NAN_FUNC_SERVICE_ID]),
+	       sizeof(func.service_id));
+
+	func.discovery_range =
+		nla_get_flag(tb[NL80211_NAN_FUNC_DISCOVERY_RANGE]);
+
+	if (tb[NL80211_NAN_FUNC_SERVICE_INFO]) {
+		func.serv_spec_info_len =
+			nla_len(tb[NL80211_NAN_FUNC_SERVICE_INFO]);
+		func.serv_spec_info =
+			nla_data(tb[NL80211_NAN_FUNC_SERVICE_INFO]);
+	}
+
+	if (tb[NL80211_NAN_FUNC_TTL])
+		func.ttl = nla_get_u32(tb[NL80211_NAN_FUNC_TTL]);
+
+	switch (func.type) {
+	case NL80211_NAN_FUNC_PUBLISH:
+		if (!tb[NL80211_NAN_FUNC_PUBLISH_TYPE])
+			return -EINVAL;
+
+		func.publish_type = nla_get_u8(tb[NL80211_NAN_FUNC_PUBLISH_TYPE]);
+		func.publish_bcast =
+			nla_get_flag(tb[NL80211_NAN_FUNC_PUBLISH_BCAST]);
+
+		if ((!(func.publish_type & NL80211_NAN_SOLICITED_PUBLISH)) &&
+		    func.publish_bcast)
+			return -EINVAL;
+		break;
+	case NL80211_NAN_FUNC_SUBSCRIBE:
+		func.subscribe_active =
+			nla_get_flag(tb[NL80211_NAN_FUNC_SUBSCRIBE_ACTIVE]);
+		break;
+	case NL80211_NAN_FUNC_FOLLOW_UP:
+		if (!tb[NL80211_NAN_FUNC_FOLLOW_UP_ID] ||
+		    !tb[NL80211_NAN_FUNC_FOLLOW_UP_REQ_ID])
+			return -EINVAL;
+
+		func.followup_id =
+			nla_get_u8(tb[NL80211_NAN_FUNC_FOLLOW_UP_ID]);
+		func.followup_reqid =
+			nla_get_u8(tb[NL80211_NAN_FUNC_FOLLOW_UP_REQ_ID]);
+		memcpy(func.followup_dest.addr,
+		       nla_data(tb[NL80211_NAN_FUNC_FOLLOW_UP_DEST]),
+		       sizeof(func.followup_dest.addr));
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (tb[NL80211_NAN_FUNC_SRF]) {
+		struct nlattr *srf_tb[NUM_NL80211_NAN_SRF_ATTR];
+
+		err = nla_parse(srf_tb, NL80211_NAN_SRF_ATTR_MAX,
+				nla_data(tb[NL80211_NAN_FUNC_SRF]),
+				nla_len(tb[NL80211_NAN_FUNC_SRF]), NULL);
+		if (err)
+			return err;
+
+		func.srf_include =
+			nla_get_flag(srf_tb[NL80211_NAN_SRF_INCLUDE]);
+
+		if (nla_get_flag(srf_tb[NL80211_NAN_SRF_TYPE_BF])) {
+			if (!srf_tb[NL80211_NAN_SRF_BF] ||
+			    !srf_tb[NL80211_NAN_SRF_BF_IDX])
+				return -EINVAL;
+
+			func.srf_bf_len =
+				nla_len(srf_tb[NL80211_NAN_SRF_TYPE_BF]);
+			func.srf_bf =
+				nla_data(srf_tb[NL80211_NAN_SRF_TYPE_BF]);
+			func.srf_bf_idx =
+				nla_get_u8(srf_tb[NL80211_NAN_SRF_BF_IDX]);
+		} else {
+			struct nlattr *attr, *mac_attr =
+				srf_tb[NL80211_NAN_SRF_MAC_ADDRS];
+			int n_entries, rem, i = 0;
+
+			if (!mac_attr)
+				return -EINVAL;
+
+			n_entries = validate_acl_mac_addrs(mac_attr);
+			if (n_entries <= 0)
+				return -EINVAL;
+
+			func.srf_num_macs = n_entries;
+			func.srf_macs =
+				kzalloc(sizeof(*func.srf_macs) * n_entries,
+					GFP_KERNEL);
+			if (!func.srf_macs)
+				return -ENOMEM;
+
+			nla_for_each_nested(attr, mac_attr, rem)
+				memcpy(func.srf_macs[i++].addr, nla_data(attr),
+				       sizeof(*func.srf_macs));
+		}
+	}
+
+	err = handle_nan_filter(tb[NL80211_NAN_FUNC_TX_MATCH_FILTER],
+				&func, true);
+	if (err)
+		goto out;
+
+	err = handle_nan_filter(tb[NL80211_NAN_FUNC_RX_MATCH_FILTER],
+				&func, false);
+	if (err)
+		goto out;
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
+		err = -ENOBUFS;
+		goto out;
+	}
+
+	inst_id = rdev_add_nan_func(rdev, wdev, &func);
+out:
+	kfree(func.srf_macs);
+	kfree(func.rx_filters);
+	kfree(func.tx_filters);
+
+	if (inst_id < 0) {
+		nlmsg_free(msg);
+		return inst_id;
+	}
+
+	/* propagate the instance id to userspace  */
+	if (WARN_ON(nla_put_u8(msg, NL80211_ATTR_NAN_FUNC_INST_ID, inst_id)))
+		err = -ENOBUFS;
+
+	if (hdr && msg) {
+		genlmsg_end(msg, hdr);
+		err = genlmsg_reply(msg, info);
+	}
+
+	return err;
+}
+
+static int nl80211_nan_rm_func(struct sk_buff *skb,
+			       struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct wireless_dev *wdev = info->user_ptr[1];
+	u8 instance_id;
+
+	if (wdev->iftype != NL80211_IFTYPE_NAN)
+		return -EOPNOTSUPP;
+
+	if (!wdev->nan_started)
+		return -ENOTCONN;
+
+	if (!info->attrs[NL80211_ATTR_NAN_FUNC_INST_ID])
+		return -EINVAL;
+
+	instance_id = nla_get_u8(info->attrs[NL80211_ATTR_NAN_FUNC_INST_ID]);
+
+	rdev_rm_nan_func(rdev, wdev, instance_id);
+
+	return 0;
+}
+
 static int nl80211_get_protocol_features(struct sk_buff *skb,
 					 struct genl_info *info)
 {
@@ -11208,6 +11498,22 @@ static const struct genl_ops nl80211_ops[] = {
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
+		.cmd = NL80211_CMD_RM_NAN_FUNCTION,
+		.doit = nl80211_nan_rm_func,
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
index b0eb221..782755d 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -899,6 +899,28 @@ static inline void rdev_stop_nan(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline int
+rdev_add_nan_func(struct cfg80211_registered_device *rdev,
+		  struct wireless_dev *wdev,
+		  const struct cfg80211_nan_func *nan_func)
+{
+	int ret;
+
+	trace_rdev_add_nan_func(&rdev->wiphy, wdev, nan_func);
+	ret = rdev->ops->add_nan_func(&rdev->wiphy, wdev, nan_func);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline void rdev_rm_nan_func(struct cfg80211_registered_device *rdev,
+				    struct wireless_dev *wdev,
+				    u8 instance_id)
+{
+	trace_rdev_rm_nan_func(&rdev->wiphy, wdev, instance_id);
+	rdev->ops->rm_nan_func(&rdev->wiphy, wdev, instance_id);
+	trace_rdev_return_void(&rdev->wiphy);
+}
+
 static inline int rdev_set_mac_acl(struct cfg80211_registered_device *rdev,
 				   struct net_device *dev,
 				   struct cfg80211_acl_data *params)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 1e1fa34..6c185ef 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1878,6 +1878,42 @@ DEFINE_EVENT(wiphy_wdev_evt, rdev_stop_nan,
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
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->func_type = func->type;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", type=%u",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->func_type)
+);
+
+TRACE_EVENT(rdev_rm_nan_func,
+	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
+		 u8 instance_id),
+	TP_ARGS(wiphy, wdev, instance_id),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		WDEV_ENTRY
+		__field(u8, instance_id)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		WDEV_ASSIGN;
+		__entry->instance_id = instance_id;
+	),
+	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT ", instance id=%u",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, __entry->instance_id)
+);
+
 TRACE_EVENT(rdev_set_mac_acl,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 struct cfg80211_acl_data *params),
-- 
1.8.3

