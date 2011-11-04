Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35410 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab1KDKVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 06:21:40 -0400
Message-Id: <20111104101945.189301400@sipsolutions.net> (sfid-20111104_112929_313180_F1D0D948)
Date: Fri, 04 Nov 2011 11:18:19 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/12] cfg80211: add event for unexpected 4addr frames
References: <20111104101809.711636760@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The frames are used by AP/STA WDS mode, and hostapd
needs to know when such a frame was received to set
up the VLAN appropriately to allow using it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |   10 +++++++++-
 include/net/cfg80211.h  |   16 ++++++++++++++++
 net/wireless/mlme.c     |   14 ++++++++++++++
 net/wireless/nl80211.c  |   19 +++++++++++++++++--
 net/wireless/nl80211.h  |    2 ++
 5 files changed, 58 insertions(+), 3 deletions(-)

--- a/include/linux/nl80211.h	2011-11-03 14:17:00.000000000 +0100
+++ b/include/linux/nl80211.h	2011-11-03 14:17:00.000000000 +0100
@@ -517,7 +517,13 @@
  *	For the event, the %NL80211_ATTR_MAC attribute carries the TA and
  *	other attributes like the interface index are present.
  *	If used as the command it must have an interface index and you can
- *	only unsubscribe from the event by closing the socket.
+ *	only unsubscribe from the event by closing the socket. Subscription
+ *	is also for %NL80211_CMD_UNEXPECTED_4ADDR_FRAME events.
+ *
+ * @NL80211_CMD_UNEXPECTED_4ADDR_FRAME: Sent as an event indicating that the
+ *	associated station identified by %NL80211_ATTR_MAC sent a 4addr frame
+ *	and wasn't already in a 4-addr VLAN. The event will be sent similarly
+ *	to the %NL80211_CMD_UNEXPECTED_FRAME event, to the same listener.
  *
  * @NL80211_CMD_PROBE_CLIENT: Probe an associated station on an AP interface
  *	by sending a null data frame to it and reporting when the frame is
@@ -667,6 +673,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_REGISTER_BEACONS,
 
+	NL80211_CMD_UNEXPECTED_4ADDR_FRAME,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
--- a/net/wireless/mlme.c	2011-11-03 14:16:34.000000000 +0100
+++ b/net/wireless/mlme.c	2011-11-03 14:21:06.000000000 +0100
@@ -1123,3 +1123,17 @@ bool cfg80211_rx_spurious_frame(struct n
 	return nl80211_unexpected_frame(dev, addr, gfp);
 }
 EXPORT_SYMBOL(cfg80211_rx_spurious_frame);
+
+bool cfg80211_rx_unexpected_4addr_frame(struct net_device *dev,
+					const u8 *addr, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_GO &&
+		    wdev->iftype != NL80211_IFTYPE_AP_VLAN))
+		return false;
+
+	return nl80211_unexpected_4addr_frame(dev, addr, gfp);
+}
+EXPORT_SYMBOL(cfg80211_rx_unexpected_4addr_frame);
--- a/net/wireless/nl80211.c	2011-11-03 14:17:00.000000000 +0100
+++ b/net/wireless/nl80211.c	2011-11-03 14:17:41.000000000 +0100
@@ -7283,7 +7283,8 @@ void nl80211_send_sta_del_event(struct c
 	nlmsg_free(msg);
 }
 
-bool nl80211_unexpected_frame(struct net_device *dev, const u8 *addr, gfp_t gfp)
+static bool __nl80211_unexpected_frame(struct net_device *dev, u8 cmd,
+				       const u8 *addr, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
@@ -7299,7 +7300,7 @@ bool nl80211_unexpected_frame(struct net
 	if (!msg)
 		return true;
 
-	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_UNEXPECTED_FRAME);
+	hdr = nl80211hdr_put(msg, 0, 0, 0, cmd);
 	if (!hdr) {
 		nlmsg_free(msg);
 		return true;
@@ -7324,6 +7325,20 @@ bool nl80211_unexpected_frame(struct net
 	return true;
 }
 
+bool nl80211_unexpected_frame(struct net_device *dev, const u8 *addr, gfp_t gfp)
+{
+	return __nl80211_unexpected_frame(dev, NL80211_CMD_UNEXPECTED_FRAME,
+					  addr, gfp);
+}
+
+bool nl80211_unexpected_4addr_frame(struct net_device *dev,
+				    const u8 *addr, gfp_t gfp)
+{
+	return __nl80211_unexpected_frame(dev,
+					  NL80211_CMD_UNEXPECTED_4ADDR_FRAME,
+					  addr, gfp);
+}
+
 int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 		      struct net_device *netdev, u32 nlpid,
 		      int freq, const u8 *buf, size_t len, gfp_t gfp)
--- a/net/wireless/nl80211.h	2011-11-03 14:16:34.000000000 +0100
+++ b/net/wireless/nl80211.h	2011-11-03 14:17:00.000000000 +0100
@@ -119,5 +119,7 @@ void nl80211_pmksa_candidate_notify(stru
 
 bool nl80211_unexpected_frame(struct net_device *dev,
 			      const u8 *addr, gfp_t gfp);
+bool nl80211_unexpected_4addr_frame(struct net_device *dev,
+				    const u8 *addr, gfp_t gfp);
 
 #endif /* __NET_WIRELESS_NL80211_H */
--- a/include/net/cfg80211.h	2011-11-03 14:17:00.000000000 +0100
+++ b/include/net/cfg80211.h	2011-11-03 14:17:00.000000000 +0100
@@ -3223,6 +3223,22 @@ bool cfg80211_rx_spurious_frame(struct n
 				const u8 *addr, gfp_t gfp);
 
 /**
+ * cfg80211_rx_unexpected_4addr_frame - inform about unexpected WDS frame
+ * @dev: The device the frame matched to
+ * @addr: the transmitter address
+ * @gfp: context flags
+ *
+ * This function is used in AP mode (only!) to inform userspace that
+ * an associated station sent a 4addr frame but that wasn't expected.
+ * It is allowed and desirable to send this event only once for each
+ * station to avoid event flooding.
+ * Returns %true if the frame was passed to userspace (or this failed
+ * for a reason other than not having a subscription.)
+ */
+bool cfg80211_rx_unexpected_4addr_frame(struct net_device *dev,
+					const u8 *addr, gfp_t gfp);
+
+/**
  * cfg80211_probe_status - notify userspace about probe status
  * @dev: the device the probe was sent on
  * @addr: the address of the peer


