Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36270 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752474AbdBUMiC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 07:38:02 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>
Subject: [RFC v2 2/2] cfg80211: support 4-way handshake offloading for 802.1X
Date: Tue, 21 Feb 2017 13:37:58 +0100
Message-Id: <20170221123758.5339-2-johannes@sipsolutions.net> (sfid-20170221_133806_852202_FDC3A251)
In-Reply-To: <20170221123758.5339-1-johannes@sipsolutions.net>
References: <20170221123758.5339-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Add API for setting the PMK to the driver. For FT support, allow
setting also the PMK-R0 Name.

This can be used by drivers that support 4-Way handshake offload
while IEEE802.1X authentication is managed by upper layers.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h    |  3 ++
 include/net/cfg80211.h       | 27 ++++++++++++
 include/uapi/linux/nl80211.h | 24 ++++++++++-
 net/wireless/core.c          |  5 +++
 net/wireless/nl80211.c       | 99 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 25 +++++++++++
 net/wireless/trace.h         | 60 +++++++++++++++++++++++++++
 7 files changed, 241 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 2049e983a994..fb1f533e75b3 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2356,8 +2356,11 @@ enum ieee80211_sa_query_action {
 
 #define WLAN_MAX_KEY_LEN		32
 
+#define WLAN_PMK_NAME_LEN		16
 #define WLAN_PMKID_LEN			16
+#define WLAN_PMK_LEN_EAP_LEAP		16
 #define WLAN_PMK_LEN			32
+#define WLAN_PMK_LEN_SUITE_B_192	48
 
 #define WLAN_OUI_WFA			0x506f9a
 #define WLAN_OUI_TYPE_WFA_P2P		9
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4ca968927d60..a68c6db6ac55 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2507,6 +2507,23 @@ struct cfg80211_nan_func {
 };
 
 /**
+ * struct cfg80211_pmk_conf - PMK configuration
+ *
+ * @aa: authenticator address
+ * @pmk_len: PMK length in bytes.
+ * @pmk: the PMK material
+ * @pmk_r0_name: PMK-R0 Name. NULL if not applicable (i.e., the PMK
+ *	is not PMK-R0). When pmk_r0_name is not NULL, the pmk field
+ *	holds PMK-R0.
+ */
+struct cfg80211_pmk_conf {
+	const u8 *aa;
+	u8 pmk_len;
+	const u8 *pmk;
+	const u8 *pmk_r0_name;
+};
+
+/**
  * struct cfg80211_ops - backend description for wireless configuration
  *
  * This struct is registered by fullmac card drivers and/or wireless stacks
@@ -2823,6 +2840,11 @@ struct cfg80211_nan_func {
  *	All other parameters must be ignored.
  *
  * @set_multicast_to_unicast: configure multicast to unicast conversion for BSS
+ *
+ * @set_pmk: configure the PMK to be used for offloaded 4-Way handshake.
+ *	(invoked with the wireless_dev mutex held)
+ * @del_pmk: delete the previously configured PMK for the given authenticator.
+ *	(invoked with the wireless_dev mutex held)
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3111,6 +3133,11 @@ struct cfg80211_ops {
 	int	(*set_multicast_to_unicast)(struct wiphy *wiphy,
 					    struct net_device *dev,
 					    const bool enabled);
+
+	int	(*set_pmk)(struct wiphy *wiphy, struct net_device *dev,
+			   const struct cfg80211_pmk_conf *conf);
+	int	(*del_pmk)(struct wiphy *wiphy, struct net_device *dev,
+			   const u8 *aa);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index bb5e1904a107..89295fc2336b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -901,6 +901,14 @@
  *	does not result in a change for the current association. Currently,
  *	only the %NL80211_ATTR_IE data is used and updated with this command.
  *
+ * @NL80211_CMD_SET_PMK: For offloaded 4-Way handshake, set the PMK or PMK-R0
+ *	for the given authenticator address (specified with &NL80211_ATTR_MAC).
+ *	When &NL80211_ATTR_PMKR0_NAME is set, &NL80211_ATTR_PMK specifies the
+ *	PMK-R0, otherwise it specifies the PMK.
+ * @NL80211_CMD_DEL_PMK: For offloaded 4-Way handshake, delete the previously
+ *	configured PMK for the authenticator address identified by
+ *	&NL80211_ATTR_MAC.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1100,6 +1108,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_UPDATE_CONNECT_PARAMS,
 
+	NL80211_CMD_SET_PMK,
+	NL80211_CMD_DEL_PMK,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2012,8 +2023,12 @@ enum nl80211_commands {
  *	u32 attribute with an &enum nl80211_timeout_reason value. This is used,
  *	e.g., with %NL80211_CMD_CONNECT event.
  *
- * @NL80211_ATTR_PMK: PSK for offloaded 4-Way Handshake. Relevant only
- *	with %NL80211_CMD_CONNECT (for WPA/WPA2-PSK networks).
+ * @NL80211_ATTR_PMK: PMK for offloaded 4-Way Handshake. Relevant with
+ *	%NL80211_CMD_CONNECT (for WPA/WPA2-PSK networks) when PSK is used, or
+ *	with %NL80211_CMD_SET_PMK when 802.1X authentication is used.
+ *	When &NL80211_ATTR_PMKR0_NAME is specified, this attribute specifies
+ *	the PMK-R0.
+ * @NL80211_ATTR_PMKR0_NAME: PMK-R0 Name for offloaded FT.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -2427,6 +2442,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_TIMEOUT_REASON,
 
 	NL80211_ATTR_PMK,
+	NL80211_ATTR_PMKR0_NAME,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -4767,6 +4783,9 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK: Device supports doing 4-way
  *	handshake with PSK in station mode (PSK is passed as part of the connect
  *	and associate commands).
+ * @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X: Device supports doing 4-way
+ *	handshake with 802.1X in station mode (needs to pass EAP frames to
+ *	the host and accept the set_pmk/del_pmk commands).
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4787,6 +4806,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI,
 	NL80211_EXT_FEATURE_CQM_RSSI_LIST,
 	NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK,
+	NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 76e664144c8e..65f4b4d4a805 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -691,6 +691,11 @@ int wiphy_register(struct wiphy *wiphy)
 		    (wiphy->bss_select_support & ~(BIT(__NL80211_BSS_SELECT_ATTR_AFTER_LAST) - 2))))
 		return -EINVAL;
 
+	if (WARN_ON(wiphy_ext_feature_isset(&rdev->wiphy,
+					    NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X) &&
+		    (!rdev->ops->set_pmk || !rdev->ops->del_pmk)))
+		return -EINVAL;
+
 	if (wiphy->addresses)
 		memcpy(wiphy->perm_addr, wiphy->addresses[0].addr, ETH_ALEN);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 494b50b3eb71..f67098559c3b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12075,6 +12075,90 @@ static int nl80211_set_multicast_to_unicast(struct sk_buff *skb,
 	return rdev_set_multicast_to_unicast(rdev, dev, enabled);
 }
 
+static int nl80211_set_pmk(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_pmk_conf pmk_conf = {};
+	int ret;
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
+		return -EOPNOTSUPP;
+
+	if (!wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X))
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_MAC] || !info->attrs[NL80211_ATTR_PMK])
+		return -EINVAL;
+
+	wdev_lock(wdev);
+	if (!wdev->current_bss) {
+		ret = -ENOTCONN;
+		goto out;
+	}
+
+	pmk_conf.aa = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	if (memcmp(pmk_conf.aa, wdev->current_bss->pub.bssid, ETH_ALEN)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	pmk_conf.pmk = nla_data(info->attrs[NL80211_ATTR_PMK]);
+	pmk_conf.pmk_len = nla_len(info->attrs[NL80211_ATTR_PMK]);
+	if (pmk_conf.pmk_len != WLAN_PMK_LEN &&
+	    pmk_conf.pmk_len != WLAN_PMK_LEN_SUITE_B_192) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (info->attrs[NL80211_ATTR_PMKR0_NAME]) {
+		int r0_name_len = nla_len(info->attrs[NL80211_ATTR_PMKR0_NAME]);
+
+		if (r0_name_len != WLAN_PMK_NAME_LEN) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		pmk_conf.pmk_r0_name =
+			nla_data(info->attrs[NL80211_ATTR_PMKR0_NAME]);
+	}
+
+	ret = rdev_set_pmk(rdev, dev, &pmk_conf);
+out:
+	wdev_unlock(wdev);
+	return ret;
+}
+
+static int nl80211_del_pmk(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	const u8 *aa;
+	int ret;
+
+	if (wdev->iftype != NL80211_IFTYPE_STATION &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
+		return -EOPNOTSUPP;
+
+	if (!wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X))
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	wdev_lock(wdev);
+	aa = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	ret = rdev_del_pmk(rdev, dev, aa);
+	wdev_unlock(wdev);
+
+	return ret;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -12950,6 +13034,21 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_SET_PMK,
+		.doit = nl80211_set_pmk,
+		.policy = nl80211_policy,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+	{
+		.cmd = NL80211_CMD_DEL_PMK,
+		.doit = nl80211_del_pmk,
+		.policy = nl80211_policy,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
+
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index f2baf5921091..06698552f1f2 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1165,4 +1165,29 @@ rdev_set_coalesce(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
 }
+
+static inline int rdev_set_pmk(struct cfg80211_registered_device *rdev,
+			       struct net_device *dev,
+			       struct cfg80211_pmk_conf *pmk_conf)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_rdev_set_pmk(&rdev->wiphy, dev, pmk_conf);
+	if (rdev->ops->set_pmk)
+		ret = rdev->ops->set_pmk(&rdev->wiphy, dev, pmk_conf);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline int rdev_del_pmk(struct cfg80211_registered_device *rdev,
+			       struct net_device *dev, const u8 *aa)
+{
+	int ret = -EOPNOTSUPP;
+
+	trace_rdev_del_pmk(&rdev->wiphy, dev, aa);
+	if (rdev->ops->del_pmk)
+		ret = rdev->ops->del_pmk(&rdev->wiphy, dev, aa);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index fd55786f0462..47a5e8d4b113 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2252,6 +2252,66 @@ TRACE_EVENT(rdev_tdls_cancel_channel_switch,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(addr))
 );
 
+TRACE_EVENT(rdev_set_pmk,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 struct cfg80211_pmk_conf *pmk_conf),
+
+	TP_ARGS(wiphy, netdev, pmk_conf),
+
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(aa)
+		__field(u8, pmk_len)
+		__field(u8, pmk_r0_name_len)
+		__dynamic_array(u8, pmk, pmk_conf->pmk_len)
+		__dynamic_array(u8, pmk_r0_name, WLAN_PMK_NAME_LEN)
+	),
+
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(aa, pmk_conf->aa);
+		__entry->pmk_len = pmk_conf->pmk_len;
+		__entry->pmk_r0_name_len =
+		pmk_conf->pmk_r0_name ? WLAN_PMK_NAME_LEN : 0;
+		memcpy(__get_dynamic_array(pmk), pmk_conf->pmk,
+		       pmk_conf->pmk_len);
+		memcpy(__get_dynamic_array(pmk_r0_name), pmk_conf->pmk_r0_name,
+		       pmk_conf->pmk_r0_name ? WLAN_PMK_NAME_LEN : 0);
+	),
+
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " MAC_PR_FMT
+		  "pmk_len=%u, pmk: %s pmk_r0_name: %s", WIPHY_PR_ARG,
+		  NETDEV_PR_ARG, MAC_PR_ARG(aa), __entry->pmk_len,
+		  __print_array(__get_dynamic_array(pmk),
+				__get_dynamic_array_len(pmk), 1),
+		  __entry->pmk_r0_name_len ?
+		  __print_array(__get_dynamic_array(pmk_r0_name),
+				__get_dynamic_array_len(pmk_r0_name), 1) : "")
+);
+
+TRACE_EVENT(rdev_del_pmk,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, const u8 *aa),
+
+	TP_ARGS(wiphy, netdev, aa),
+
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(aa)
+	),
+
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(aa, aa);
+	),
+
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " MAC_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(aa))
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
2.9.3
