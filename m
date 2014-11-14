Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50620 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934046AbaKNQPn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2014 11:15:43 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] cfg80211: allow including station info in delete event
Date: Fri, 14 Nov 2014 17:15:38 +0100
Message-Id: <1415981738-17439-1-git-send-email-johannes@sipsolutions.net> (sfid-20141114_171546_974067_83E11164)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a station is removed, its statistics may be interesting to
userspace, for example for further aggregation of statistics of
all stations that ever connected to an AP.

Introduce a new cfg80211_del_sta_sinfo() function (and make the
cfg80211_del_sta() a static inline calling it) to allow passing
a struct station_info along with this, and send the data in the
nl80211 event message.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 16 +++++++++++++++-
 net/wireless/nl80211.c | 37 ++++++++++++++++---------------------
 2 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c59b93714728..bd46a4901383 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4489,13 +4489,27 @@ void cfg80211_new_sta(struct net_device *dev, const u8 *mac_addr,
 		      struct station_info *sinfo, gfp_t gfp);
 
 /**
+ * cfg80211_del_sta_sinfo - notify userspace about deletion of a station
+ * @dev: the netdev
+ * @mac_addr: the station's address
+ * @sinfo: the station information/statistics
+ * @gfp: allocation flags
+ */
+void cfg80211_del_sta_sinfo(struct net_device *dev, const u8 *mac_addr,
+			    struct station_info *sinfo, gfp_t gfp);
+
+/**
  * cfg80211_del_sta - notify userspace about deletion of a station
  *
  * @dev: the netdev
  * @mac_addr: the station's address
  * @gfp: allocation flags
  */
-void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp);
+static inline void cfg80211_del_sta(struct net_device *dev,
+				    const u8 *mac_addr, gfp_t gfp)
+{
+	cfg80211_del_sta_sinfo(dev, mac_addr, NULL, gfp);
+}
 
 /**
  * cfg80211_conn_failed - connection request failed notification
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 648374c4f815..5ff4ed4312cd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3598,8 +3598,8 @@ static bool nl80211_put_signal(struct sk_buff *msg, u8 mask, s8 *signal,
 	return true;
 }
 
-static int nl80211_send_station(struct sk_buff *msg, u32 portid, u32 seq,
-				int flags,
+static int nl80211_send_station(struct sk_buff *msg, u32 cmd, u32 portid,
+				u32 seq, int flags,
 				struct cfg80211_registered_device *rdev,
 				struct net_device *dev,
 				const u8 *mac_addr, struct station_info *sinfo)
@@ -3607,7 +3607,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 portid, u32 seq,
 	void *hdr;
 	struct nlattr *sinfoattr, *bss_param;
 
-	hdr = nl80211hdr_put(msg, portid, seq, flags, NL80211_CMD_NEW_STATION);
+	hdr = nl80211hdr_put(msg, portid, seq, flags, cmd);
 	if (!hdr)
 		return -1;
 
@@ -3802,7 +3802,7 @@ static int nl80211_dump_station(struct sk_buff *skb,
 		if (err)
 			goto out_err;
 
-		if (nl80211_send_station(skb,
+		if (nl80211_send_station(skb, NL80211_CMD_NEW_STATION,
 				NETLINK_CB(cb->skb).portid,
 				cb->nlh->nlmsg_seq, NLM_F_MULTI,
 				rdev, wdev->netdev, mac_addr,
@@ -3849,7 +3849,8 @@ static int nl80211_get_station(struct sk_buff *skb, struct genl_info *info)
 	if (!msg)
 		return -ENOMEM;
 
-	if (nl80211_send_station(msg, info->snd_portid, info->snd_seq, 0,
+	if (nl80211_send_station(msg, NL80211_CMD_NEW_STATION,
+				 info->snd_portid, info->snd_seq, 0,
 				 rdev, dev, mac_addr, &sinfo) < 0) {
 		nlmsg_free(msg);
 		return -ENOBUFS;
@@ -11256,7 +11257,7 @@ void cfg80211_new_sta(struct net_device *dev, const u8 *mac_addr,
 	if (!msg)
 		return;
 
-	if (nl80211_send_station(msg, 0, 0, 0,
+	if (nl80211_send_station(msg, NL80211_CMD_NEW_STATION, 0, 0, 0,
 				 rdev, dev, mac_addr, sinfo) < 0) {
 		nlmsg_free(msg);
 		return;
@@ -11267,12 +11268,17 @@ void cfg80211_new_sta(struct net_device *dev, const u8 *mac_addr,
 }
 EXPORT_SYMBOL(cfg80211_new_sta);
 
-void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp)
+void cfg80211_del_sta_sinfo(struct net_device *dev, const u8 *mac_addr,
+			    struct station_info *sinfo, gfp_t gfp)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	struct sk_buff *msg;
 	void *hdr;
+	struct station_info empty_sinfo = {};
+
+	if (!sinfo)
+		sinfo = &_empty;
 
 	trace_cfg80211_del_sta(dev, mac_addr);
 
@@ -11280,27 +11286,16 @@ void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp)
 	if (!msg)
 		return;
 
-	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_DEL_STATION);
-	if (!hdr) {
+	if (nl80211_send_station(msg, NL80211_CMD_DEL_STATION, 0, 0, 0,
+				 rdev, dev, mac_addr, sinfo)) {
 		nlmsg_free(msg);
 		return;
 	}
 
-	if (nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
-	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr))
-		goto nla_put_failure;
-
-	genlmsg_end(msg, hdr);
-
 	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
 				NL80211_MCGRP_MLME, gfp);
-	return;
-
- nla_put_failure:
-	genlmsg_cancel(msg, hdr);
-	nlmsg_free(msg);
 }
-EXPORT_SYMBOL(cfg80211_del_sta);
+EXPORT_SYMBOL(cfg80211_del_sta_sinfo);
 
 void cfg80211_conn_failed(struct net_device *dev, const u8 *mac_addr,
 			  enum nl80211_connect_failed_reason reason,
-- 
2.1.1

