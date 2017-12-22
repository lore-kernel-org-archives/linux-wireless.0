Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:14170 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752871AbdLVQeN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 11:34:13 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        Srinivas Dasari <dasaris@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 1/3] cfg80211/nl80211: Optional authentication offload to userspace
Date: Fri, 22 Dec 2017 18:33:37 +0200
Message-ID: <1513960419-24780-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20171222_173418_432648_E2EBC93E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Srinivas Dasari <dasaris@qti.qualcomm.com>

This interface allows the host driver to offload the authentication to
user space. This is exclusively defined for host drivers that do not
define separate commands for authentication and association, but rely on
userspace SME (e.g., in wpa_supplicant for the ~WPA_DRIVER_FLAGS_SME
case) for the authentication to happen. This can be used to implement
SAE without full implementation in the kernel/firmware while still being
able to use NL80211_CMD_CONNECT with driver-based BSS selection.

The host driver sends the NL80211_CMD_EXTERNAL_AUTH event to start/abort
the authentication to userspace and status of authentication is further
indicated by user space to host driver through the same command
interface. Such drivers advertise the capability through
NL80211_EXT_FEATURE_EXTERNAL_AUTH. User space entities advertise this
capability through the NL80211_ATTR_EXTERNAL_AUTH_SUPP flag in the
NL80211_CMD_CONNECT request.

Signed-off-by: Srinivas Dasari <dasaris@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       | 44 ++++++++++++++++++++
 include/uapi/linux/nl80211.h | 46 +++++++++++++++++++++
 net/wireless/nl80211.c       | 98 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 15 +++++++
 net/wireless/trace.h         | 22 ++++++++++
 5 files changed, 225 insertions(+)

v2:
- add NL80211_ATTR_EXTERNAL_AUTH_SUPPORTED flag for user space to
  indicate support for offload capability in the NL80211_CMD_CONNECT
  command

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3a4a1a9..582a7e7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1903,11 +1903,15 @@ struct cfg80211_auth_request {
  * @ASSOC_REQ_DISABLE_HT:  Disable HT (802.11n)
  * @ASSOC_REQ_DISABLE_VHT:  Disable VHT
  * @ASSOC_REQ_USE_RRM: Declare RRM capability in this association
+ * @CONNECT_REQ_EXTERNAL_AUTH_SUPP: User space indicates external authentication
+ * capability. Drivers can offload authentication to userspace if this flag is
+ * set. Only applicable for cfg80211_connect() request (connect callback).
  */
 enum cfg80211_assoc_req_flags {
 	ASSOC_REQ_DISABLE_HT		= BIT(0),
 	ASSOC_REQ_DISABLE_VHT		= BIT(1),
 	ASSOC_REQ_USE_RRM		= BIT(2),
+	CONNECT_REQ_EXTERNAL_AUTH_SUPP	= BIT(3),
 };
 
 /**
@@ -2599,6 +2603,30 @@ struct cfg80211_pmk_conf {
 };
 
 /**
+ * struct cfg80211_external_auth_params - External authentication
+ * trigger parameters. Commonly used across the external auth request and
+ * event interfaces.
+ * @action: action type / trigger for external authentication. Only significant
+ * for the event interface (from driver to user space).
+ * @bssid: BSSID of the peer with which the authentication has
+ *      to happen. Used by both the request and event interface.
+ * @ssid: SSID of the AP. Used by both the request and event interface.
+ * @key_mgmt_suite: AKM suite of the respective authentication. Optional for
+ *	the request interface.
+ * @status: status code, %WLAN_STATUS_SUCCESS for successful authentication,
+ *	use %WLAN_STATUS_UNSPECIFIED_FAILURE if user space cannot give you
+ *	the real status code for failures. Used only for the request
+ *	interface from user space to the driver.
+ */
+struct cfg80211_external_auth_params {
+	enum nl80211_external_auth_action action;
+	u8 bssid[ETH_ALEN] __aligned(2);
+	struct cfg80211_ssid ssid;
+	unsigned int key_mgmt_suite;
+	u16 status;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -2921,6 +2949,9 @@ struct cfg80211_pmk_conf {
  *	(invoked with the wireless_dev mutex held)
  * @del_pmk: delete the previously configured PMK for the given authenticator.
  *	(invoked with the wireless_dev mutex held)
+ *
+ * @external_auth: indicates result of offloaded authentication processing from
+ *	user space
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3214,6 +3245,8 @@ struct cfg80211_ops {
 			   const struct cfg80211_pmk_conf *conf);
 	int	(*del_pmk)(struct wiphy *wiphy, struct net_device *dev,
 			   const u8 *aa);
+	int	(*external_auth)(struct wiphy *wiphy, struct net_device *dev,
+				 struct cfg80211_external_auth_params *params);
 };
 
 /*
@@ -6201,6 +6234,17 @@ void cfg80211_nan_func_terminated(struct wireless_dev *wdev,
 /* ethtool helper */
 void cfg80211_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info);
 
+/**
+ * cfg80211_external_auth_request - userspace request for authentication
+ * @netdev: network device
+ * @params: External authentication parameters
+ * @gfp: allocation flags
+ * Returns: 0 on success, < 0 on error
+ */
+int cfg80211_external_auth_request(struct net_device *netdev,
+				   struct cfg80211_external_auth_params *params,
+				   gfp_t gfp);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c587a61..083c6c1 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -992,6 +992,24 @@
  *
  * @NL80211_CMD_RELOAD_REGDB: Request that the regdb firmware file is reloaded.
  *
+ * @NL80211_CMD_EXTERNAL_AUTH: This command/event interface is exclusively
+ *	defined for host drivers that do not define separate commands for
+ *	authentication and association, bute rely on user space SME (e.g., in
+ *	wpa_supplicant for the ~WPA_DRIVER_FLAGS_SME case) for the
+ *	authentication to happen.
+ *
+ *	User space uses the %NL80211_CMD_CONNECT command to the host driver for
+ *	triggering a connection. The host driver selects a BSS and further uses
+ *	this interface to offload only the authentication part to the user
+ *	space. Authentication frames are passed between the driver and user
+ *	space through the %NL80211_CMD_FRAME interface. The status of
+ *	authentication is further indicated by user space to the host driver
+ *	with the %NL80211_CMD_EXTERNAL_AUTH command through
+ *	%NL80211_ATTR_STATUS_CODE attribute. This enables the driver to proceed
+ *	with association on successful authentication. Driver shall use this
+ *	%NL80211_ATTR_STATUS_CODE attribute to report the connect result to
+ *	user space on an authentication failure.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1198,6 +1216,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_RELOAD_REGDB,
 
+	NL80211_CMD_EXTERNAL_AUTH,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2153,6 +2173,16 @@ enum nl80211_commands {
  * @NL80211_ATTR_PMKR0_NAME: PMK-R0 Name for offloaded FT.
  * @NL80211_ATTR_PORT_AUTHORIZED: (reserved)
  *
+ * @NL80211_ATTR_EXTERNAL_AUTH_ACTION: Identify the requested external
+ *	authentication operation (u32 attribute with an
+ *	&enum nl80211_external_auth_action value). This is used with the
+ *	&NL80211_CMD_EXTERNAL_AUTH event.
+ * @NL80211_ATTR_EXTERNAL_AUTH_SUPP: Flag attribute indicating that the user
+ *	space supports external authentication. This attribute shall be used
+ *	only with %NL80211_CMD_CONNECT request. The driver may offload
+ *	authentication processing to user space if this capability is indicated
+ *	in NL80211_CMD_CONNECT requests from the user space.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2579,6 +2609,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_PMKR0_NAME,
 	NL80211_ATTR_PORT_AUTHORIZED,
 
+	NL80211_ATTR_EXTERNAL_AUTH_ACTION,
+	NL80211_ATTR_EXTERNAL_AUTH_SUPP,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4945,6 +4978,7 @@ enum nl80211_feature_flags {
  *	probe request tx deferral and suppression
  * @NL80211_EXT_FEATURE_MFP_OPTIONAL: Driver supports the %NL80211_MFP_OPTIONAL
  *	value in %NL80211_ATTR_USE_MFP.
+ * @NL80211_EXT_FEATURE_EXTERNAL_AUTH: Driver supports external authentication
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4972,6 +5006,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_OCE_PROBE_REQ_HIGH_TX_RATE,
 	NL80211_EXT_FEATURE_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION,
 	NL80211_EXT_FEATURE_MFP_OPTIONAL,
+	NL80211_EXT_FEATURE_EXTERNAL_AUTH,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
@@ -5469,4 +5504,15 @@ enum nl80211_nan_match_attributes {
 	NL80211_NAN_MATCH_ATTR_MAX = NUM_NL80211_NAN_MATCH_ATTR - 1
 };
 
+/**
+ * nl80211_external_auth_action - Action to perform with external
+ *	authentication. Used by NL80211_ATTR_EXTERNAL_AUTH_ACTION.
+ * @NL80211_EXTERNAL_AUTH_START: Start the authentication.
+ * @NL80211_EXTERNAL_AUTH_ABORT: Abort the ongoing authentication.
+ */
+enum nl80211_external_auth_action {
+	NL80211_EXTERNAL_AUTH_START,
+	NL80211_EXTERNAL_AUTH_ABORT,
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b3f8970..41a0373 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -420,6 +420,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_FILS_CACHE_ID] = { .len = 2 },
 	[NL80211_ATTR_PMK] = { .type = NLA_BINARY, .len = PMK_MAX_LEN },
 	[NL80211_ATTR_SCHED_SCAN_MULTI] = { .type = NLA_FLAG },
+	[NL80211_ATTR_EXTERNAL_AUTH_SUPP] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -9147,6 +9148,16 @@ static int nl80211_connect(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
+	if (nla_get_flag(info->attrs[NL80211_ATTR_EXTERNAL_AUTH_SUPP])) {
+		if (wiphy_ext_feature_isset(
+			    &rdev->wiphy, NL80211_EXT_FEATURE_EXTERNAL_AUTH)) {
+			connect.flags |= CONNECT_REQ_EXTERNAL_AUTH_SUPP;
+		} else {
+			kzfree(connkeys);
+			return -EOPNOTSUPP;
+		}
+	}
+
 	wdev_lock(dev->ieee80211_ptr);
 
 	err = cfg80211_connect(rdev, dev, &connect, connkeys,
@@ -12454,6 +12465,43 @@ static int nl80211_del_pmk(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
+static int nl80211_external_auth(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct cfg80211_external_auth_params params;
+
+	if (!wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_EXTERNAL_AUTH) ||
+	    !rdev->ops->external_auth)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_SSID])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_BSSID])
+		return -EINVAL;
+
+	if (!info->attrs[NL80211_ATTR_STATUS_CODE])
+		return -EINVAL;
+
+	memset(&params, 0, sizeof(params));
+
+	params.ssid.ssid_len = nla_len(info->attrs[NL80211_ATTR_SSID]);
+	if (params.ssid.ssid_len == 0 ||
+	    params.ssid.ssid_len > IEEE80211_MAX_SSID_LEN)
+		return -EINVAL;
+	memcpy(params.ssid.ssid, nla_data(info->attrs[NL80211_ATTR_SSID]),
+	       params.ssid.ssid_len);
+
+	memcpy(params.bssid, nla_data(info->attrs[NL80211_ATTR_BSSID]),
+	       ETH_ALEN);
+
+	params.status = nla_get_u16(info->attrs[NL80211_ATTR_STATUS_CODE]);
+
+	return rdev_external_auth(rdev, dev, &params);
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -13349,6 +13397,14 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_EXTERNAL_AUTH,
+		.doit = nl80211_external_auth,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 
 };
 
@@ -15360,6 +15416,48 @@ void nl80211_send_ap_stopped(struct wireless_dev *wdev)
 	nlmsg_free(msg);
 }
 
+int cfg80211_external_auth_request(struct net_device *dev,
+				   struct cfg80211_external_auth_params *params,
+				   gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_EXTERNAL_AUTH);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return -ENOMEM;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	    nla_put_u32(msg, NL80211_ATTR_AKM_SUITES, params->key_mgmt_suite) ||
+	    nla_put_u32(msg, NL80211_ATTR_EXTERNAL_AUTH_ACTION,
+			params->action) ||
+	    nla_put(msg, NL80211_ATTR_BSSID, ETH_ALEN, params->bssid) ||
+	    nla_put(msg, NL80211_ATTR_SSID, params->ssid.ssid_len,
+		    params->ssid.ssid))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_MLME, gfp);
+	return 0;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+	return -ENOBUFS;
+}
+EXPORT_SYMBOL(cfg80211_external_auth_request);
+
 /* initialisation/exit functions */
 
 int __init nl80211_init(void)
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 0c06240..84f23ae 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1190,4 +1190,19 @@ static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
+
+static inline int
+rdev_external_auth(struct cfg80211_registered_device *rdev,
+		   struct net_device *dev,
+		   struct cfg80211_external_auth_params *params)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_rdev_external_auth(&rdev->wiphy, dev, params);
+	if (rdev->ops->external_auth)
+		ret = rdev->ops->external_auth(&rdev->wiphy, dev, params);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index bcfedd3..a30f399 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2319,6 +2319,28 @@ TRACE_EVENT(rdev_del_pmk,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(aa))
 );
 
+TRACE_EVENT(rdev_external_auth,
+	    TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		     struct cfg80211_external_auth_params *params),
+	    TP_ARGS(wiphy, netdev, params),
+	    TP_STRUCT__entry(WIPHY_ENTRY
+			     NETDEV_ENTRY
+			     MAC_ENTRY(bssid)
+			     __array(u8, ssid, IEEE80211_MAX_SSID_LEN + 1)
+			     __field(u16, status)
+	    ),
+	    TP_fast_assign(WIPHY_ASSIGN;
+			   NETDEV_ASSIGN;
+			   MAC_ASSIGN(bssid, params->bssid);
+			   memset(__entry->ssid, 0, IEEE80211_MAX_SSID_LEN + 1);
+			   memcpy(__entry->ssid, params->ssid.ssid,
+				  params->ssid.ssid_len);
+			   __entry->status = params->status;
+	    ),
+	    TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", bssid: " MAC_PR_FMT
+		      ", ssid: %s, status: %u", WIPHY_PR_ARG, NETDEV_PR_ARG,
+		      __entry->bssid, __entry->ssid, __entry->status));
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
2.7.4
