Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35924 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934101AbeAJRJw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Jan 2018 12:09:52 -0500
Received: by mail-pg0-f67.google.com with SMTP id j2so10091943pgv.3
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jan 2018 09:09:52 -0800 (PST)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC v2 4/5] nl80211: Implement TX of control port frames
Date: Wed, 10 Jan 2018 11:09:37 -0600
Message-Id: <20180110170938.2341-5-denkenz@gmail.com> (sfid-20180110_180958_033009_D67159EE)
In-Reply-To: <20180110170938.2341-1-denkenz@gmail.com>
References: <20180110170938.2341-1-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit implements the TX side of NL80211_CMD_CONTROL_PORT_FRAME.
Userspace provides the raw EAPoL frame using NL80211_ATTR_FRAME.
Userspace should also provide the destination address and the protocol
type to use when sending the frame.  This is used to implement TX of
Pre-authentication frames.  If CONTROL_PORT_ETHERTYPE_NO_ENCRYPT is
specified, then the driver will be asked not to encrypt the outgoing
frame.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 include/net/cfg80211.h  |  9 ++++++++
 net/wireless/nl80211.c  | 60 ++++++++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/rdev-ops.h | 15 +++++++++++++
 net/wireless/trace.h    | 25 +++++++++++++++++++++
 4 files changed, 108 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 84cba57dd8d0..5d1afe3579e7 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2924,6 +2924,9 @@ struct cfg80211_pmk_conf {
  *	(invoked with the wireless_dev mutex held)
  * @del_pmk: delete the previously configured PMK for the given authenticator.
  *	(invoked with the wireless_dev mutex held)
+ *
+ * @tx_control_port: TX a control port frame (EAPoL).  The noencrypt parameter
+ *	tells the driver that the frame should not be encrypted.
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3217,6 +3220,12 @@ struct cfg80211_ops {
 			   const struct cfg80211_pmk_conf *conf);
 	int	(*del_pmk)(struct wiphy *wiphy, struct net_device *dev,
 			   const u8 *aa);
+
+	int	(*tx_control_port)(struct wiphy *wiphy,
+				       struct net_device *dev,
+				       const u8 *buf, size_t len,
+				       const u8 *dest, const u16 proto,
+				       const bool noencrypt);
 };
 
 /*
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c0f2bb24e7dd..2c1082c7b1ea 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12474,6 +12474,57 @@ static int nl80211_del_pmk(struct sk_buff *skb, struct genl_info *info)
 	return ret;
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
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_CONTROL_PORT_OVER_NL80211) ||
+	    !rdev->ops->tx_control_port)
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
@@ -13369,7 +13420,14 @@ static const struct genl_ops nl80211_ops[] = {
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
index 0c06240d25af..fbd67e32bb91 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -714,6 +714,21 @@ static inline int rdev_mgmt_tx(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int rdev_tx_control_port(struct cfg80211_registered_device *rdev,
+				       struct net_device *dev,
+				       const void *buf, size_t len,
+				       const u8 *dest, u16 proto,
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
index 48bb1c1eaf67..212c499bf51e 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1882,6 +1882,31 @@ TRACE_EVENT(rdev_mgmt_tx,
 		  BOOL_TO_STR(__entry->dont_wait_for_ack))
 );
 
+TRACE_EVENT(rdev_tx_control_port,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 const u8 *buf, size_t len, const u8 *dest, u16 proto,
+		 bool unencrypted),
+	TP_ARGS(wiphy, netdev, buf, len, dest, proto, unencrypted),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(dest)
+		__field(u16, proto)
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
+		  __entry->proto, BOOL_TO_STR(__entry->unencrypted))
+);
+
 TRACE_EVENT(rdev_set_noack_map,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
 		 u16 noack_map),
-- 
2.13.5
