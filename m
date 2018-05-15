Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36884 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbeEOFSf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 01:18:35 -0400
From: Sriram R <srirrama@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Sriram R <srirrama@codeaurora.org>
Subject: [RFC 1/2]  nl80211: Add support for collection of per rate rx statistics
Date: Tue, 15 May 2018 10:48:00 +0530
Message-Id: <1526361481-7159-2-git-send-email-srirrama@codeaurora.org> (sfid-20180515_071852_664071_C046F8E9)
In-Reply-To: <1526361481-7159-1-git-send-email-srirrama@codeaurora.org>
References: <1526361481-7159-1-git-send-email-srirrama@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX Statistics per rate, per station can be useful in
understanding the quality of communication with our peers
and can be helpful in evaluating the consistency at which a
specific peer has been communicating in different MCS/BW/NSS
after association at different time periods and in varied environments.

This patch adds support for collecting the rx statistics
from the kernel and providing it to the userspace.

Signed-off-by: Sriram R <srirrama@codeaurora.org>
---
 include/net/cfg80211.h       |  25 +++++++
 include/uapi/linux/nl80211.h |  50 +++++++++++++
 net/wireless/nl80211.c       | 172 +++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  30 ++++++++
 net/wireless/trace.h         |  26 +++++++
 5 files changed, 303 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8db6071..8bd818f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1235,6 +1235,19 @@ struct station_info {
 	s8 avg_ack_signal;
 };
 
+/**
+ * struct sta_rate_stats - per rate statistics of station
+ *
+ * @rate: encoded rate value
+ * @packets: Packet count received at this @rate
+ * @bytes: Total number of bytes received at this @rate
+ */
+struct sta_rate_stats {
+	u32 rate;
+	u32 packets;
+	u64 bytes;
+};
+
 #if IS_ENABLED(CONFIG_CFG80211)
 /**
  * cfg80211_get_station - retrieve information about a given station
@@ -3018,6 +3031,9 @@ struct cfg80211_external_auth_params {
  *
  * @tx_control_port: TX a control port frame (EAPoL).  The noencrypt parameter
  *	tells the driver that the frame should not be encrypted.
+ *
+ * @get_sta_rate_stats: get per-rate stats of the station identified by @mac
+ * @dump_sta_rate_stats: get per-rate stats dump of stations from index @idx
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -3323,6 +3339,15 @@ struct cfg80211_ops {
 				   const u8 *buf, size_t len,
 				   const u8 *dest, const __be16 proto,
 				   const bool noencrypt);
+
+	int	(*get_sta_rate_stats)(struct wiphy *wiphy,
+				      struct net_device *dev, const u8 *mac,
+				      struct sta_rate_stats **rate_stats_buf,
+				      int *len);
+	int	(*dump_sta_rate_stats)(struct wiphy *wiphy,
+				struct net_device *dev,	int idx, u8 *mac,
+				struct sta_rate_stats **rate_stats_buf,
+				int *len);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 83ed1dd..beeca81 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1031,6 +1031,10 @@
  *	&NL80211_ATTR_CHANNEL_WIDTH,&NL80211_ATTR_NSS attributes with its
  *	address(specified in &NL80211_ATTR_MAC).
  *
+ * @NL80211_CMD_GET_RATE_STATS: Get Per rate statistics (rx packets and bytes)
+ *	for a station identified by %NL80211_ATTR_MAC on the interface
+ *	identified by %NL80211_ATTR_IFINDEX.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1243,6 +1247,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_CONTROL_PORT_FRAME,
 
+	NL80211_CMD_GET_RATE_STATS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -2236,6 +2242,10 @@ enum nl80211_commands {
  * @NL80211_ATTR_TXQ_QUANTUM: TXQ scheduler quantum (bytes). Number of bytes
  *      a flow is assigned on each round of the DRR scheduler.
  *
+ * @NL80211_ATTR_RATE_STATS: Indicates the presence of per-rate stats holding
+ *	the info of packets and bytes received per rate identified by
+ *	the attributes in  @nl80211_rate_stats
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2675,6 +2685,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_TXQ_MEMORY_LIMIT,
 	NL80211_ATTR_TXQ_QUANTUM,
 
+	NL80211_ATTR_RATE_STATS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3114,6 +3126,44 @@ enum nl80211_txq_stats {
 };
 
 /**
+ * DOC: per-rate per-station statistics
+ * The nl80211 %NL80211_CMD_GET_RATE_STATS command  provides an interface to
+ * get the statistics of number of packets and bytes received per rate
+ * per station.
+ * The kernel will start collecting this statistics only when it is required
+ * by the userspace application and rate statistics needs to be enabled for
+ * this purpose(TODO: Add comments on interface used to enable rate-stats)
+ * Once enabled, the packet (and corresponding bytes) count received at the
+ * station are recorded per rate on each rx and the userspace application
+ * can get the current stats information using the %NL80211_CMD_GET_RATE_STATS
+ * command.
+ * Note that the rate field which is provided by the statistics is a encoded
+ * value containing the information on VHT/HT/Legacy,BW,NSS,MCS,GI/SGI and this
+ * needs to be extracted/decoded by the userspace application.
+ */
+
+/**
+ * enum nl80211_rate_stats - per-rate stats attributes
+ * @__NL80211_RATE_STATS_INVALID :attribute number 0 is reserved
+ * @NL80211_ATTR_RATE_STATS_RATE :identifier for the encoded rate field.
+ * @NL80211_ATTR_RATE_STATS_RX_PACKETS: Number of packets which are received
+ *	per @rate for this specific station identified by @NL80211_ATTR_MAC.
+ * @NL80211_ATTR_RATE_STATS_RX_BYTES: Number of bytes which are received
+ *	per @rate for this specific station identified by @NL80211_ATTR_MAC.
+ * @NUM_NL80211_ATTR_RATE_STATS: Total number of rate-stats attributes
+ * @NL80211_ATTR_RATE_STATS_MAX: MAX rate-stats attribute number.
+ */
+enum nl80211_rate_stats {
+	__NL80211_RATE_STATS_INVALID,
+	NL80211_ATTR_RATE_STATS_RATE,
+	NL80211_ATTR_RATE_STATS_RX_PACKETS,
+	NL80211_ATTR_RATE_STATS_RX_BYTES,
+
+	/* keep last */
+	NUM_NL80211_ATTR_RATE_STATS,
+	NL80211_ATTR_RATE_STATS_MAX = NUM_NL80211_ATTR_RATE_STATS - 1
+};
+/**
  * enum nl80211_mpath_flags - nl80211 mesh path flags
  *
  * @NL80211_MPATH_FLAG_ACTIVE: the mesh path is active
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index afbe510..fa78d05 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4826,6 +4826,170 @@ static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static int
+nl80211_send_sta_rate_stats(struct sk_buff *msg, u32 cmd, u32 portid,
+			    u32 seq, int flags,
+			    struct cfg80211_registered_device *rdev,
+			    struct net_device *dev, const u8 *mac_addr,
+			    struct sta_rate_stats *rate_stats_buf,
+			    int rate_table_len)
+{
+	void *hdr;
+	struct sta_rate_stats *report;
+	struct nlattr *rstatsattr, *rentryattr;
+	int rid;
+
+	hdr = nl80211hdr_put(msg, portid, seq, flags, cmd);
+	if (!hdr)
+		return -1;
+
+	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr))
+		goto nla_put_failure;
+
+	if (rate_table_len && rate_stats_buf) {
+		rstatsattr = nla_nest_start(msg, NL80211_ATTR_RATE_STATS);
+
+		if (!rstatsattr)
+			goto nla_put_failure;
+
+		report = rate_stats_buf;
+
+		for (rid = 0; rid < rate_table_len ; rid++) {
+			rentryattr = nla_nest_start(msg, rid + 1);
+			if (!rentryattr)
+				goto nla_put_failure;
+
+			nla_put_u32(msg, NL80211_ATTR_RATE_STATS_RATE,
+				    report->rate);
+			nla_put_u32(msg, NL80211_ATTR_RATE_STATS_RX_PACKETS,
+				    report->packets);
+			nla_put_u64_64bit(msg,
+					  NL80211_ATTR_RATE_STATS_RX_BYTES,
+					  report->bytes, NL80211_ATTR_PAD);
+
+			nla_nest_end(msg, rentryattr);
+
+			if (rid + 1 < rate_table_len)
+				report++;
+		}
+
+		nla_nest_end(msg, rstatsattr);
+	}
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static int nl80211_dump_sta_rate_stats(struct sk_buff *skb,
+				       struct netlink_callback *cb)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+	u8 mac_addr[ETH_ALEN];
+	int sta_idx = cb->args[2];
+	int err, num_rate_elems;
+	struct sta_rate_stats *rate_stats_buf = NULL;
+
+	rtnl_lock();
+	err = nl80211_prepare_wdev_dump(skb, cb, &rdev, &wdev);
+	if (err)
+		goto out_err;
+
+	if (!wdev->netdev) {
+		err = -EINVAL;
+		goto out_err;
+	}
+
+	if (!rdev->ops->dump_sta_rate_stats) {
+		err = -EOPNOTSUPP;
+		goto out_err;
+	}
+
+	while (1) {
+		err = rdev_dump_sta_rate_stats(rdev, wdev->netdev, sta_idx,
+					       mac_addr, &rate_stats_buf,
+					       &num_rate_elems);
+		if (err == -ENOENT)
+			break;
+		if (err)
+			goto out_err;
+
+		if (nl80211_send_sta_rate_stats(skb, NL80211_CMD_GET_RATE_STATS,
+						NETLINK_CB(cb->skb).portid,
+						cb->nlh->nlmsg_seq, NLM_F_MULTI,
+						rdev, wdev->netdev, mac_addr,
+						rate_stats_buf,
+						num_rate_elems) < 0) {
+			if (rate_stats_buf)
+				kfree(rate_stats_buf);
+			goto out;
+		}
+
+		sta_idx++;
+
+		if (rate_stats_buf)
+			kfree(rate_stats_buf);
+	}
+
+ out:
+	cb->args[2] = sta_idx;
+	err = skb->len;
+ out_err:
+	rtnl_unlock();
+
+	return err;
+}
+
+static int
+nl80211_get_sta_rate_stats(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	struct sk_buff *msg;
+	u8 *mac_addr = NULL;
+	int err, num_rate_elems;
+	struct sta_rate_stats *rate_stats_buf = NULL;
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	if (!rdev->ops->get_sta_rate_stats)
+		return -EOPNOTSUPP;
+
+	err = rdev_get_sta_rate_stats(rdev, dev, mac_addr,
+				      &rate_stats_buf, &num_rate_elems);
+	if (err)
+		return err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	if (nl80211_send_sta_rate_stats(msg, NL80211_CMD_GET_RATE_STATS,
+					info->snd_portid, info->snd_seq, 0,
+					rdev, dev, mac_addr, rate_stats_buf,
+					num_rate_elems) < 0) {
+		nlmsg_free(msg);
+
+		if (rate_stats_buf)
+			kfree(rate_stats_buf);
+
+		return -ENOBUFS;
+	}
+
+	if (rate_stats_buf)
+		kfree(rate_stats_buf);
+
+	return genlmsg_reply(msg, info);
+}
+
 int cfg80211_check_station_change(struct wiphy *wiphy,
 				  struct station_parameters *params,
 				  enum cfg80211_station_type statype)
@@ -13744,6 +13908,14 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_GET_RATE_STATS,
+		.doit = nl80211_get_sta_rate_stats,
+		.dumpit = nl80211_dump_sta_rate_stats,
+		.policy = nl80211_policy,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_family nl80211_fam __ro_after_init = {
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 364f5d6..1564ad8 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -222,6 +222,36 @@ static inline int rdev_dump_station(struct cfg80211_registered_device *rdev,
 	return ret;
 }
 
+static inline int
+rdev_get_sta_rate_stats(struct cfg80211_registered_device *rdev,
+			struct net_device *dev, const u8 *mac,
+			struct sta_rate_stats **rate_stats_buf,
+			int *len)
+{
+	int ret;
+
+	trace_rdev_get_sta_rate_stats(&rdev->wiphy, dev, mac);
+	ret = rdev->ops->get_sta_rate_stats(&rdev->wiphy, dev, mac,
+					rate_stats_buf, len);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
+static inline int
+rdev_dump_sta_rate_stats(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev, int idx, u8 *mac,
+			 struct sta_rate_stats **rate_stats_buf,
+			 int *len)
+{
+	int ret;
+
+	trace_rdev_dump_sta_rate_stats(&rdev->wiphy, dev, idx, mac);
+	ret = rdev->ops->dump_sta_rate_stats(&rdev->wiphy, dev, idx, mac,
+					 rate_stats_buf, len);
+	trace_rdev_return_int(&rdev->wiphy, ret);
+	return ret;
+}
+
 static inline int rdev_add_mpath(struct cfg80211_registered_device *rdev,
 				 struct net_device *dev, u8 *dst, u8 *next_hop)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 2b417a2..09dd69b 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -759,6 +759,11 @@ DEFINE_EVENT(wiphy_netdev_mac_evt, rdev_get_station,
 	TP_ARGS(wiphy, netdev, mac)
 );
 
+DEFINE_EVENT(wiphy_netdev_mac_evt, rdev_get_sta_rate_stats,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, const u8 *mac),
+	TP_ARGS(wiphy, netdev, mac)
+);
+
 DEFINE_EVENT(wiphy_netdev_mac_evt, rdev_del_mpath,
 	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, const u8 *mac),
 	TP_ARGS(wiphy, netdev, mac)
@@ -790,6 +795,27 @@ TRACE_EVENT(rdev_dump_station,
 		  __entry->idx)
 );
 
+TRACE_EVENT(rdev_dump_sta_rate_stats,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, int idx,
+		 u8 *mac),
+	TP_ARGS(wiphy, netdev, idx, mac),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(sta_mac)
+		__field(int, idx)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(sta_mac, mac);
+		__entry->idx = idx;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", station mac: " MAC_PR_FMT ", idx: %d",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(sta_mac),
+		  __entry->idx)
+);
+
 TRACE_EVENT(rdev_return_int_station_info,
 	TP_PROTO(struct wiphy *wiphy, int ret, struct station_info *sinfo),
 	TP_ARGS(wiphy, ret, sinfo),
-- 
2.7.4
