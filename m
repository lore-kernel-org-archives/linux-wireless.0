Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:42427 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755937AbeBABEc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 20:04:32 -0500
Received: by mail-pf0-f196.google.com with SMTP id b25so14470688pfd.9
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jan 2018 17:04:31 -0800 (PST)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC v4 3/6] nl80211: Implement TX of control port frames
Date: Wed, 31 Jan 2018 19:04:17 -0600
Message-Id: <20180201010420.6102-4-denkenz@gmail.com> (sfid-20180201_020437_479619_BE4C79BC)
In-Reply-To: <20180201010420.6102-1-denkenz@gmail.com>
References: <20180201010420.6102-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit implements the TX side of NL80211_CMD_CONTROL_PORT_FRAME.
Userspace provides the raw EAPoL frame using NL80211_ATTR_FRAME.
Userspace should also provide the destination address and the protocol
type to use when sending the frame.  This is used to implement TX of
Pre-authentication frames.  If CONTROL_PORT_ETHERTYPE_NO_ENCRYPT is
specified, then the driver will be asked not to encrypt the outgoing
frame.

A new EXT_FEATURE flag is introduced so that nl80211 code can check
whether a given wiphy has capability to pass EAPoL frames over NL80211.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 include/net/cfg80211.h       |  9 +++++++
 include/uapi/linux/nl80211.h |  3 +++
 net/wireless/nl80211.c       | 63 +++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/rdev-ops.h      | 15 +++++++++++
 net/wireless/trace.h         | 26 ++++++++++++++++++
 5 files changed, 115 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f3102c6745fd..e1686421fdd7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2958,6 +2958,9 @@ struct cfg80211_external_auth_params {
  *
  * @external_auth: indicates result of offloaded authentication processing from
  *     user space
+ *
+ * @tx_control_port: TX a control port frame (EAPoL).  The noencrypt parameter
+ *	tells the driver that the frame should not be encrypted.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3253,6 +3256,12 @@ struct cfg80211_ops {
 			   const u8 *aa);
 	int     (*external_auth)(struct wiphy *wiphy, struct net_device *dev,
 				 struct cfg80211_external_auth_params *params);
+
+	int	(*tx_control_port)(struct wiphy *wiphy,
+				   struct net_device *dev,
+				   const u8 *buf, size_t len,
+				   const u8 *dest, const __be16 proto,
+				   const bool noencrypt);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 31fc88cb0a2c..5842b3954cfd 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -5009,6 +5009,8 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_LOW_SPAN_SCAN: Driver supports low span scan.
  * @NL80211_EXT_FEATURE_LOW_POWER_SCAN: Driver supports low power scan.
  * @NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN: Driver supports high accuracy scan.
+ * @NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211: Driver supports sending and
+ *     receiving control port frames over NL80211 instead of the netdevice.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5039,6 +5041,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_LOW_SPAN_SCAN,
 	NL80211_EXT_FEATURE_LOW_POWER_SCAN,
 	NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN,
+	NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bffbd2cd2fc3..645c072cc4a3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12515,6 +12515,60 @@ static int nl80211_external_auth(struct sk_buff *skb, struct genl_info *info)
 	return rdev_external_auth(rdev, dev, &params);
 }
 
+static int nl80211_tx_control_port(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	const u8 *buf;
+	size_t len;
+	u8 *dest;
+	u16 proto;
+	bool noencrypt;
+	int err;
+
+	if (!wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_CONTROL_PORT_OVER_NL80211))
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->tx_control_port)
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_FRAME] ||
+	    !info->attrs[NL80211_ATTR_MAC] ||
+	    !info->attrs[NL80211_ATTR_CONTROL_PORT_ETHERTYPE])
+		return -EINVAL;
+
+	wdev_lock(wdev);
+
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+		if (wdev->current_bss)
+			break;
+		err = -ENOTCONN;
+		goto out;
+	default:
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	wdev_unlock(wdev);
+
+	buf = nla_data(info->attrs[NL80211_ATTR_FRAME]);
+	len = nla_len(info->attrs[NL80211_ATTR_FRAME]);
+	dest = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	proto = nla_get_u16(info->attrs[NL80211_ATTR_CONTROL_PORT_ETHERTYPE]);
+	noencrypt =
+		nla_get_flag(info->attrs[NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT]);
+
+	return rdev_tx_control_port(rdev, dev, buf, len,
+				    dest, cpu_to_be16(proto), noencrypt);
+
+ out:
+	wdev_unlock(wdev);
+	return err;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -13418,7 +13472,14 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
-
+	{
+		.cmd = NL80211_CMD_CONTROL_PORT_FRAME,
+		.doit = nl80211_tx_control_port,
+		.policy = nl80211_policy,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 84f23ae015fc..87479a53411b 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -714,6 +714,21 @@ static inline int rdev_mgmt_tx(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_tx_control_port(struct cfg80211_registered_device *rdev,
+				       struct net_device *dev,
+				       const void *buf, size_t len,
+				       const u8 *dest, __be16 proto,
+				       const bool noencrypt)
+{
+	int ret;
+	trace_rdev_tx_control_port(&rdev->wiphy, dev, buf, len,
+				   dest, proto, noencrypt);
+	ret = rdev->ops->tx_control_port(&rdev->wiphy, dev, buf, len,
+					 dest, proto, noencrypt);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline int
 rdev_mgmt_tx_cancel_wait(struct cfg80211_registered_device *rdev,
 			 struct wireless_dev *wdev, u64 cookie)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 24e84dfe54fd..5794cfa371c7 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1882,6 +1882,32 @@ TRACE_EVENT(rdev_mgmt_tx,
 		  BOOL_TO_STR(__entry->dont_wait_for_ack))
 );
 
+TRACE_EVENT(rdev_tx_control_port,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const u8 *buf, size_t len, const u8 *dest, __be16 proto,
+		 bool unencrypted),
+	TP_ARGS(wiphy, netdev, buf, len, dest, proto, unencrypted),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(dest)
+		__field(__be16, proto)
+		__field(bool, unencrypted)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(dest, dest);
+		__entry->proto = proto;
+		__entry->unencrypted = unencrypted;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", " MAC_PR_FMT ","
+		  " proto: %x, unencrypted: %s",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(dest),
+		  be16_to_cpu(__entry->proto),
+		  BOOL_TO_STR(__entry->unencrypted))
+);
+
 TRACE_EVENT(rdev_set_noack_map,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 u16 noack_map),
-- 
2.13.5
