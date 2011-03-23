Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:49166 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932872Ab1CWNaD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2011 09:30:03 -0400
Date: Wed, 23 Mar 2011 15:29:52 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] cfg80211: Add nl80211 event for deletion of a station
 entry
Message-ID: <20110323132952.GA9679@jm.kir.nu>
References: <20110323125513.GB26467@jm.kir.nu>
 <1300885229.3790.39.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1300885229.3790.39.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Indicate an NL80211_CMD_DEL_STATION event when a station entry in
mac80211 is deleted to match with the NL80211_CMD_NEW_STATION event
that is used when the entry was added. This is needed, e.g., to allow
user space to remove a peer from RSN IBSS Authenticator state machine
to avoid re-authentication and re-keying delays when the peer is not
reachable anymore.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

---
 include/net/cfg80211.h  |    9 +++++++++
 net/mac80211/sta_info.c |    2 ++
 net/wireless/mlme.c     |    9 +++++++++
 net/wireless/nl80211.c  |   34 ++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    3 +++
 5 files changed, 57 insertions(+)

v2: Fix msg leak noticed by Johannes


--- wireless-testing.orig/include/net/cfg80211.h	2011-03-23 14:21:41.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2011-03-23 14:22:48.000000000 +0200
@@ -2667,6 +2667,15 @@ void cfg80211_new_sta(struct net_device
 		      struct station_info *sinfo, gfp_t gfp);
 
 /**
+ * cfg80211_del_sta - notify userspace about deletion of a station
+ *
+ * @dev: the netdev
+ * @mac_addr: the station's address
+ * @gfp: allocation flags
+ */
+void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp);
+
+/**
  * cfg80211_rx_mgmt - notification of received, unprocessed management frame
  * @dev: network device
  * @freq: Frequency on which the frame was received in MHz
--- wireless-testing.orig/net/mac80211/sta_info.c	2011-03-23 14:17:47.000000000 +0200
+++ wireless-testing/net/mac80211/sta_info.c	2011-03-23 14:19:50.000000000 +0200
@@ -698,6 +698,8 @@ static int __must_check __sta_info_destr
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 	cancel_work_sync(&sta->drv_unblock_wk);
 
+	cfg80211_del_sta(sdata->dev, sta->sta.addr, GFP_KERNEL);
+
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
 
--- wireless-testing.orig/net/wireless/mlme.c	2011-03-23 14:17:51.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2011-03-23 14:31:42.000000000 +0200
@@ -770,6 +770,15 @@ void cfg80211_new_sta(struct net_device
 }
 EXPORT_SYMBOL(cfg80211_new_sta);
 
+void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp)
+{
+	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	nl80211_send_sta_del_event(rdev, dev, mac_addr, gfp);
+}
+EXPORT_SYMBOL(cfg80211_del_sta);
+
 struct cfg80211_mgmt_registration {
 	struct list_head list;
 
--- wireless-testing.orig/net/wireless/nl80211.c	2011-03-23 14:17:54.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2011-03-23 15:08:31.000000000 +0200
@@ -5966,6 +5966,40 @@ void nl80211_send_sta_event(struct cfg80
 				nl80211_mlme_mcgrp.id, gfp);
 }
 
+void nl80211_send_sta_del_event(struct cfg80211_registered_device *rdev,
+				struct net_device *dev, const u8 *mac_addr,
+				gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_DEL_STATION);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
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
 int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 		      struct net_device *netdev, u32 nlpid,
 		      int freq, const u8 *buf, size_t len, gfp_t gfp)
--- wireless-testing.orig/net/wireless/nl80211.h	2011-03-23 14:23:31.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.h	2011-03-23 14:23:48.000000000 +0200
@@ -79,6 +79,9 @@ void nl80211_send_remain_on_channel_canc
 void nl80211_send_sta_event(struct cfg80211_registered_device *rdev,
 			    struct net_device *dev, const u8 *mac_addr,
 			    struct station_info *sinfo, gfp_t gfp);
+void nl80211_send_sta_del_event(struct cfg80211_registered_device *rdev,
+				struct net_device *dev, const u8 *mac_addr,
+				gfp_t gfp);
 
 int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 		      struct net_device *netdev, u32 nlpid, int freq,

-- 
Jouni Malinen                                            PGP id EFC895FA
