Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40408 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbXJYNW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2007 09:22:26 -0400
Received: from [131.234.198.68]
	by sipsolutions.net with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Il2fI-0000cd-Ee
	for linux-wireless@vger.kernel.org; Thu, 25 Oct 2007 14:22:24 +0100
Message-Id: <20071025093717.616248000@sipsolutions.net> (sfid-20071025_142234_656186_099589C5)
References: <20071025093618.440937000@sipsolutions.net>
Date: Thu, 25 Oct 2007 11:36:26 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [patch 8/9] cfg80211/nl80211: implement station attribute retrieval
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After a station is added to the kernel's structures, userspace
has to be able to retrieve statistics about that station, especially
whether the station was idle and how much bytes were transferred
to and from it. This adds the necessary code to nl80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/linux/nl80211.h |   28 ++++++++++++++++
 include/net/cfg80211.h  |   35 ++++++++++++++++++++
 net/wireless/nl80211.c  |   82 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 144 insertions(+), 1 deletion(-)

--- linux-2.6.orig/include/linux/nl80211.h	2007-10-24 16:57:06.090256076 +0200
+++ linux-2.6/include/linux/nl80211.h	2007-10-24 16:57:52.880260851 +0200
@@ -152,6 +152,9 @@ enum nl80211_commands {
  *	restriction (at most %NL80211_MAX_SUPP_RATES).
  * @NL80211_ATTR_STA_VLAN: interface index of VLAN interface to move station
  *	to, or the AP interface the station was originally added to to.
+ * @NL80211_ATTR_STA_STATS: statistics for a station, part of station info
+ *	given for %NL80211_CMD_GET_STATION, nested attribute containing
+ *	info as possible, see &enum nl80211_sta_stats.
  *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -185,6 +188,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_STA_LISTEN_INTERVAL,
 	NL80211_ATTR_STA_SUPPORTED_RATES,
 	NL80211_ATTR_STA_VLAN,
+	NL80211_ATTR_STA_STATS,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -247,4 +251,28 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_MAX = __NL80211_STA_FLAG_AFTER_LAST - 1
 };
 
+/**
+ * enum nl80211_sta_stats - station statistics
+ *
+ * These attribute types are used with %NL80211_ATTR_STA_STATS
+ * when getting information about a station.
+ *
+ * @__NL80211_STA_STAT_INVALID: attribute number 0 is reserved
+ * @NL80211_STA_STAT_INACTIVE_TIME: time since last activity (u32, msecs)
+ * @NL80211_STA_STAT_RX_BYTES: total received bytes (u32, from this station)
+ * @NL80211_STA_STAT_TX_BYTES: total transmitted bytes (u32, to this station)
+ * @__NL80211_STA_STAT_AFTER_LAST: internal
+ * @NL80211_STA_STAT_MAX: highest possible station stats attribute
+ */
+enum nl80211_sta_stats {
+	__NL80211_STA_STAT_INVALID,
+	NL80211_STA_STAT_INACTIVE_TIME,
+	NL80211_STA_STAT_RX_BYTES,
+	NL80211_STA_STAT_TX_BYTES,
+
+	/* keep last */
+	__NL80211_STA_STAT_AFTER_LAST,
+	NL80211_STA_STAT_MAX = __NL80211_STA_STAT_AFTER_LAST - 1
+};
+
 #endif /* __LINUX_NL80211_H */
--- linux-2.6.orig/include/net/cfg80211.h	2007-10-24 16:56:35.020252386 +0200
+++ linux-2.6/include/net/cfg80211.h	2007-10-24 16:57:52.880260851 +0200
@@ -130,6 +130,39 @@ struct station_parameters {
 	u8 supported_rates_len;
 };
 
+/**
+ * enum station_stats_flags - station statistics flags
+ *
+ * Used by the driver to indicate which info in &struct station_stats
+ * it has filled in during get_station().
+ *
+ * @STATION_STAT_INACTIVE_TIME: @inactive_time filled
+ * @STATION_STAT_RX_BYTES: @rx_bytes filled
+ * @STATION_STAT_TX_BYTES: @tx_bytes filled
+ */
+enum station_stats_flags {
+	STATION_STAT_INACTIVE_TIME	= 1<<0,
+	STATION_STAT_RX_BYTES		= 1<<1,
+	STATION_STAT_TX_BYTES		= 1<<2,
+};
+
+/**
+ * struct station_stats - station statistics
+ *
+ * Station information filled by driver for get_station().
+ *
+ * @filled: bitflag of flags from &enum station_stats_flags
+ * @inactive_time: time since last station activity (tx/rx) in milliseconds
+ * @rx_bytes: bytes received from this station
+ * @tx_bytes: bytes transmitted to this station
+ */
+struct station_stats {
+	u32 filled;
+	u32 inactive_time;
+	u32 rx_bytes;
+	u32 tx_bytes;
+};
+
 /* from net/wireless.h */
 struct wiphy;
 
@@ -203,6 +236,8 @@ struct cfg80211_ops {
 			       u8 *mac);
 	int	(*change_station)(struct wiphy *wiphy, struct net_device *dev,
 				  u8 *mac, struct station_parameters *params);
+	int	(*get_station)(struct wiphy *wiphy, struct net_device *dev,
+			       u8 *mac, struct station_stats *stats);
 };
 
 #endif /* __NET_CFG80211_H */
--- linux-2.6.orig/net/wireless/nl80211.c	2007-10-24 16:57:23.710253471 +0200
+++ linux-2.6/net/wireless/nl80211.c	2007-10-24 16:58:10.820253147 +0200
@@ -728,9 +728,89 @@ static int parse_station_flags(struct nl
 	return 0;
 }
 
+static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
+				int flags, struct net_device *dev,
+				u8 *mac_addr, struct station_stats *stats)
+{
+	void *hdr;
+	struct nlattr *statsattr;
+
+	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_STATION);
+	if (!hdr)
+		return -1;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
+
+	statsattr = nla_nest_start(msg, NL80211_ATTR_STA_STATS);
+	if (!statsattr)
+		goto nla_put_failure;
+	if (stats->filled & STATION_STAT_INACTIVE_TIME)
+		NLA_PUT_U32(msg, NL80211_STA_STAT_INACTIVE_TIME,
+			    stats->inactive_time);
+	if (stats->filled & STATION_STAT_RX_BYTES)
+		NLA_PUT_U32(msg, NL80211_STA_STAT_RX_BYTES,
+			    stats->rx_bytes);
+	if (stats->filled & STATION_STAT_TX_BYTES)
+		NLA_PUT_U32(msg, NL80211_STA_STAT_TX_BYTES,
+			    stats->tx_bytes);
+
+	nla_nest_end(msg, statsattr);
+
+	return genlmsg_end(msg, hdr);
+
+ nla_put_failure:
+	return genlmsg_cancel(msg, hdr);
+}
+
+
 static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
 {
-	return -EOPNOTSUPP;
+	struct cfg80211_registered_device *drv;
+	int err;
+	struct net_device *dev;
+	struct station_stats stats;
+	struct sk_buff *msg;
+	u8 *mac_addr = NULL;
+
+	memset(&stats, 0, sizeof(stats));
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
+
+	err = get_drv_dev_by_info_ifindex(info, &drv, &dev);
+	if (err)
+		return err;
+
+	if (!drv->ops->get_station) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	rtnl_lock();
+	err = drv->ops->get_station(&drv->wiphy, dev, mac_addr, &stats);
+	rtnl_unlock();
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!msg)
+		goto out;
+
+	if (nl80211_send_station(msg, info->snd_pid, info->snd_seq, 0,
+				 dev, mac_addr, &stats) < 0)
+		goto out_free;
+
+	err = genlmsg_unicast(msg, info->snd_pid);
+	goto out;
+
+ out_free:
+	nlmsg_free(msg);
+
+ out:
+	cfg80211_put_dev(drv);
+	dev_put(dev);
+	return err;
 }
 
 /*

-- 

