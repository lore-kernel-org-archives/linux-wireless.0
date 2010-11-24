Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37320 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab0KXHN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 02:13:27 -0500
Message-Id: <20101124071042.770832639@sipsolutions.net>
Date: Wed, 24 Nov 2010 08:10:05 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: allow using CQM event to notify packet loss
References: <20101124071004.597318320@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This adds the ability for drivers to use CQM events
to notify about packet loss for specific stations
(which could be the AP for the managed mode case).
Since the threshold might be determined by the
driver (it isn't passed in right now) it will be
passed out of the driver to userspace in the event.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |    3 +++
 include/net/cfg80211.h  |   12 ++++++++++++
 net/wireless/mlme.c     |   12 ++++++++++++
 net/wireless/nl80211.c  |   45 +++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    4 ++++
 5 files changed, 76 insertions(+)

--- wireless-testing.orig/include/linux/nl80211.h	2010-11-23 10:36:12.000000000 +0100
+++ wireless-testing/include/linux/nl80211.h	2010-11-24 08:09:22.000000000 +0100
@@ -1821,6 +1821,8 @@ enum nl80211_ps_state {
  *	the minimum amount the RSSI level must change after an event before a
  *	new event may be issued (to reduce effects of RSSI oscillation).
  * @NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT: RSSI threshold event
+ * @NL80211_ATTR_CQM_PKT_LOSS_EVENT: a u32 value indicating that this many
+ *	consecutive packets were not acknowledged by the peer
  * @__NL80211_ATTR_CQM_AFTER_LAST: internal
  * @NL80211_ATTR_CQM_MAX: highest key attribute
  */
@@ -1829,6 +1831,7 @@ enum nl80211_attr_cqm {
 	NL80211_ATTR_CQM_RSSI_THOLD,
 	NL80211_ATTR_CQM_RSSI_HYST,
 	NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT,
+	NL80211_ATTR_CQM_PKT_LOSS_EVENT,
 
 	/* keep last */
 	__NL80211_ATTR_CQM_AFTER_LAST,
--- wireless-testing.orig/net/wireless/mlme.c	2010-11-23 10:36:12.000000000 +0100
+++ wireless-testing/net/wireless/mlme.c	2010-11-24 08:09:22.000000000 +0100
@@ -1028,3 +1028,15 @@ void cfg80211_cqm_rssi_notify(struct net
 	nl80211_send_cqm_rssi_notify(rdev, dev, rssi_event, gfp);
 }
 EXPORT_SYMBOL(cfg80211_cqm_rssi_notify);
+
+void cfg80211_cqm_pktloss_notify(struct net_device *dev,
+				 const u8 *peer, u32 num_packets, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	/* Indicate roaming trigger event to user space */
+	nl80211_send_cqm_pktloss_notify(rdev, dev, peer, num_packets, gfp);
+}
+EXPORT_SYMBOL(cfg80211_cqm_pktloss_notify);
--- wireless-testing.orig/net/wireless/nl80211.c	2010-11-23 10:36:12.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.c	2010-11-24 08:09:22.000000000 +0100
@@ -5688,6 +5688,51 @@ nl80211_send_cqm_rssi_notify(struct cfg8
 	nlmsg_free(msg);
 }
 
+void
+nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
+				struct net_device *netdev, const u8 *peer,
+				u32 num_packets, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	struct nlattr *pinfoattr;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NOTIFY_CQM);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex);
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, peer);
+
+	pinfoattr = nla_nest_start(msg, NL80211_ATTR_CQM);
+	if (!pinfoattr)
+		goto nla_put_failure;
+
+	NLA_PUT_U32(msg, NL80211_ATTR_CQM_PKT_LOSS_EVENT, num_packets);
+
+	nla_nest_end(msg, pinfoattr);
+
+	if (genlmsg_end(msg, hdr) < 0) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
 static int nl80211_netlink_notify(struct notifier_block * nb,
 				  unsigned long state,
 				  void *_notify)
--- wireless-testing.orig/net/wireless/nl80211.h	2010-11-23 10:36:12.000000000 +0100
+++ wireless-testing/net/wireless/nl80211.h	2010-11-24 08:09:22.000000000 +0100
@@ -87,5 +87,9 @@ nl80211_send_cqm_rssi_notify(struct cfg8
 			     struct net_device *netdev,
 			     enum nl80211_cqm_rssi_threshold_event rssi_event,
 			     gfp_t gfp);
+void
+nl80211_send_cqm_pktloss_notify(struct cfg80211_registered_device *rdev,
+				struct net_device *netdev, const u8 *peer,
+				u32 num_packets, gfp_t gfp);
 
 #endif /* __NET_WIRELESS_NL80211_H */
--- wireless-testing.orig/include/net/cfg80211.h	2010-11-23 10:36:12.000000000 +0100
+++ wireless-testing/include/net/cfg80211.h	2010-11-24 08:09:22.000000000 +0100
@@ -2605,6 +2605,18 @@ void cfg80211_cqm_rssi_notify(struct net
 			      enum nl80211_cqm_rssi_threshold_event rssi_event,
 			      gfp_t gfp);
 
+/**
+ * cfg80211_cqm_pktloss_notify - notify userspace about packetloss to peer
+ * @dev: network device
+ * @peer: peer's MAC address
+ * @num_packets: how many packets were lost -- should be a fixed threshold
+ *	but probably no less than maybe 50, or maybe a throughput dependent
+ *	threshold (to account for temporary interference)
+ * @gfp: context flags
+ */
+void cfg80211_cqm_pktloss_notify(struct net_device *dev,
+				 const u8 *peer, u32 num_packets, gfp_t gfp);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */


