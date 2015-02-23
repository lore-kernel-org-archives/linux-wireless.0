Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:35056 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbbBWOL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 09:11:58 -0500
Received: by pabrd3 with SMTP id rd3so20708112pab.2
        for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2015 06:11:57 -0800 (PST)
From: Rohan Joyce <rojoyce.github@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] nl80211: add NL80211_CMD_GET_TSF
Date: Mon, 23 Feb 2015 21:57:12 +0800
Message-Id: <1424699832-19284-2-git-send-email-rojoyce.github@gmail.com> (sfid-20150223_151201_815020_CABEA63C)
In-Reply-To: <1424699832-19284-1-git-send-email-rojoyce.github@gmail.com>
References: <1424699832-19284-1-git-send-email-rojoyce.github@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a command NL80211_CMD_GET_TSF that retrieves the 64 bit time
synchronisation value for an interface. It returns the value in a uint64
attribute of type NL80211_ATTR_TSF.

Signed-off-by: Rohan Joyce <rojoyce.github@gmail.com>
---
 include/net/cfg80211.h       |  6 ++++++
 include/uapi/linux/nl80211.h | 10 ++++++++++
 net/mac80211/cfg.c           | 16 +++++++++++++++
 net/wireless/nl80211.c       | 47 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 11 +++++++++++
 net/wireless/trace.h         | 18 +++++++++++++++++
 6 files changed, 108 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 64e09e1..9425d11 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2415,6 +2415,9 @@ struct cfg80211_qos_map {
  *	and returning to the base channel for communication with the AP.
  * @tdls_cancel_channel_switch: Stop channel-switching with a TDLS peer. Both
  *	peers must be on the base channel when the call completes.
+ *
+ * @get_tsf: Get the current value of the time synchronization function for the
+ *	given interface
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2678,6 +2681,9 @@ struct cfg80211_ops {
 	void	(*tdls_cancel_channel_switch)(struct wiphy *wiphy,
 					      struct net_device *dev,
 					      const u8 *addr);
+
+	int     (*get_tsf)(struct wiphy *wiphy, struct net_device *dev,
+			   u64 *tsf);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 68b294e..a8d228e 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -798,6 +798,10 @@
  *	as an event to indicate changes for devices with wiphy-specific regdom
  *	management.
  *
+ * @NL80211_CMD_GET_TSF: Get timing synchronisation function value for the
+ *	interface identified by %NL80211_ATTR_IFINDEX. The command returns
+ *	the value in a %NL80211_ATTR_TSF.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -984,6 +988,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_WIPHY_REG_CHANGE,
 
+	NL80211_CMD_GET_TSF,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -1740,6 +1746,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_SCHED_SCAN_DELAY: delay before a scheduled scan (or a
  *	WoWLAN net-detect scan) is started, u32 in seconds.
  *
+ * @NL80211_ATTR_TSF: time synchronization function value, u64.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2107,6 +2115,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SCHED_SCAN_DELAY,
 
+	NL80211_ATTR_TSF,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index dd4ff36..77a823f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3734,6 +3734,21 @@ static int ieee80211_del_tx_ts(struct wiphy *wiphy, struct net_device *dev,
 	return -ENOENT;
 }
 
+static int ieee80211_get_tsf(struct wiphy *wiphy, struct net_device *dev,
+			     u64 *tsf)
+{
+	struct ieee80211_local *local = wiphy_priv(wiphy);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+
+	if (!local->ops->get_tsf)
+		return -EOPNOTSUPP;
+
+	*tsf = drv_get_tsf(local, sdata);
+
+	return 0;
+}
+
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -3818,4 +3833,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_ap_chanwidth = ieee80211_set_ap_chanwidth,
 	.add_tx_ts = ieee80211_add_tx_ts,
 	.del_tx_ts = ieee80211_del_tx_ts,
+	.get_tsf = ieee80211_get_tsf,
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e9ad9d9..cadd954 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -399,6 +399,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type = NLA_FLAG },
 	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },
 	[NL80211_ATTR_SCHED_SCAN_DELAY] = { .type = NLA_U32 },
+	[NL80211_ATTR_TSF] = { .type = NLA_U64 },
 };
 
 /* policy for the key attributes */
@@ -1534,6 +1535,7 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			if (rdev->wiphy.features &
 					NL80211_FEATURE_SUPPORTS_WMM_ADMISSION)
 				CMD(add_tx_ts, ADD_TX_TS);
+			CMD(get_tsf, GET_TSF);
 		}
 		/* add into the if now */
 #undef CMD
@@ -10145,6 +10147,43 @@ static int nl80211_tdls_cancel_channel_switch(struct sk_buff *skb,
 	return 0;
 }
 
+static int nl80211_get_tsf(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct sk_buff *msg;
+	void *hdr;
+	u64 tsf;
+	int err;
+
+	if (!rdev->ops->get_tsf)
+		return -EOPNOTSUPP;
+
+	err = rdev_get_tsf(rdev, dev, &tsf);
+	if (err)
+		return err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
+			     NL80211_CMD_GET_TSF);
+	if (!hdr)
+		goto nla_put_failure;
+
+	if (nla_put_u64(msg, NL80211_ATTR_TSF, tsf))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+	return genlmsg_reply(msg, info);
+
+ nla_put_failure:
+	err = -ENOBUFS;
+	nlmsg_free(msg);
+	return err;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -10960,6 +10999,14 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_GET_TSF,
+		.doit = nl80211_get_tsf,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	}
 };
 
 /* notification functions */
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 35cfb71..9729da9 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1017,4 +1017,15 @@ rdev_tdls_cancel_channel_switch(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline int rdev_get_tsf(struct cfg80211_registered_device *rdev,
+			       struct net_device *dev, u64 *tsf)
+{
+	int ret = -EOPNOTSUPP;
+	if (rdev->ops->get_tsf) {
+		ret = rdev->ops->get_tsf(&rdev->wiphy, dev, tsf);
+		trace_rdev_get_tsf(&rdev->wiphy, dev, *tsf);
+	}
+	return ret;
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index b17b369..4dc800d 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2077,6 +2077,24 @@ TRACE_EVENT(rdev_tdls_cancel_channel_switch,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(addr))
 );
 
+TRACE_EVENT(rdev_get_tsf,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
+		 u64 tsf),
+	TP_ARGS(wiphy, netdev, tsf),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		__field(u64, tsf)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		__entry->tsf = tsf;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", tsf: %llu",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->tsf)
+);
+
 /*************************************************************
  *	     cfg80211 exported functions traces		     *
  *************************************************************/
-- 
2.1.0

