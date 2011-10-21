Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37136 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab1JUOZO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:25:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RHG25-0008Tb-AF
	for linux-wireless@vger.kernel.org; Fri, 21 Oct 2011 16:25:13 +0200
Message-Id: <20111021142427.959413959@sipsolutions.net> (sfid-20111021_162519_415547_68BB51BC)
Date: Fri, 21 Oct 2011 16:23:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC v2 03/12] nl80211: allow subscribing to unexpected class3
 frames
References: <20111021142322.229128720@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To implement AP mode without monitor interfaces we
need to be able to send a deauth to stations that
send frames without being associated. Enable this
by adding a new nl80211 event for such frames that
an application can subscribe to.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |   13 +++++++++
 include/net/cfg80211.h  |   19 +++++++++++++
 net/wireless/mlme.c     |   16 +++++++++++
 net/wireless/nl80211.c  |   66 ++++++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/nl80211.h  |    3 ++
 5 files changed, 117 insertions(+)

--- a/include/linux/nl80211.h	2011-10-21 10:20:41.000000000 +0200
+++ b/include/linux/nl80211.h	2011-10-21 12:07:39.000000000 +0200
@@ -509,6 +509,17 @@
  * @NL80211_CMD_TDLS_OPER: Perform a high-level TDLS command (e.g. link setup).
  * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame.
  *
+ * @NL80211_CMD_UNEXPECTED_FRAME: Used by an application controlling an AP
+ *	(or GO) interface (i.e. hostapd) to ask for unexpected frames to
+ *	implement sending deauth to stations that send unexpected class 3
+ *	frames. Also used as the event sent by the kernel when such a frame
+ *	is received. When 4 address mode is supported, it may also be used
+ *	to notify the AP controller about those frames.
+ *	For the event, the %NL80211_ATTR_MAC attribute carries TA along
+ *	with more information like the interface index.
+ *	If used as the command, must have an interface index, and you can
+ *	only unsubscribe from the event by closing the socket.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -638,6 +649,8 @@ enum nl80211_commands {
 	NL80211_CMD_TDLS_OPER,
 	NL80211_CMD_TDLS_MGMT,
 
+	NL80211_CMD_UNEXPECTED_FRAME,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
--- a/include/net/cfg80211.h	2011-10-21 10:20:42.000000000 +0200
+++ b/include/net/cfg80211.h	2011-10-21 12:07:39.000000000 +0200
@@ -2179,6 +2179,8 @@ struct wireless_dev {
 
 	int beacon_interval;
 
+	u32 ap_unexpected_nlpid;
+
 #ifdef CONFIG_CFG80211_WEXT
 	/* wext data */
 	struct {
@@ -3185,6 +3187,23 @@ void cfg80211_gtk_rekey_notify(struct ne
 void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
 				     const u8 *bssid, bool preauth, gfp_t gfp);
 
+/**
+ * cfg80211_rx_spurious_frame - inform userspace about a spurious frame
+ * @dev: The device the frame matched to
+ * @addr: the transmitter address
+ * @gfp: context flags
+ *
+ * This function is used in AP mode (only!) to inform userspace that
+ * a spurious class 3 frame was received, to be able to deauth the
+ * sender. If 4addr frames are supported in AP mode, these may also
+ * be passed here if they aren't yet allowed for the sender so that
+ * the userspace application can set up things properly.
+ * Returns %true if the frame was passed to userspace (or this failed
+ * for a reason other than not having a subscription.)
+ */
+bool cfg80211_rx_spurious_frame(struct net_device *dev,
+				const u8 *addr, gfp_t gfp);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
--- a/net/wireless/mlme.c	2011-10-21 10:20:42.000000000 +0200
+++ b/net/wireless/mlme.c	2011-10-21 12:07:39.000000000 +0200
@@ -879,6 +879,9 @@ void cfg80211_mlme_unregister_socket(str
 	}
 
 	spin_unlock_bh(&wdev->mgmt_registrations_lock);
+
+	if (nlpid == wdev->ap_unexpected_nlpid)
+		wdev->ap_unexpected_nlpid = 0;
 }
 
 void cfg80211_mlme_purge_registrations(struct wireless_dev *wdev)
@@ -1107,3 +1110,16 @@ void cfg80211_pmksa_candidate_notify(str
 	nl80211_pmksa_candidate_notify(rdev, dev, index, bssid, preauth, gfp);
 }
 EXPORT_SYMBOL(cfg80211_pmksa_candidate_notify);
+
+bool cfg80211_rx_spurious_frame(struct net_device *dev,
+				const u8 *addr, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_AP &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_GO))
+		return false;
+
+	return nl80211_unexpected_frame(dev, addr, gfp);
+}
+EXPORT_SYMBOL(cfg80211_rx_spurious_frame);
--- a/net/wireless/nl80211.c	2011-10-21 10:20:42.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-10-21 12:07:39.000000000 +0200
@@ -5827,6 +5827,23 @@ static int nl80211_set_rekey_data(struct
 	return err;
 }
 
+static int nl80211_register_unexpected_frame(struct sk_buff *skb,
+					     struct genl_info *info)
+{
+	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	if (wdev->iftype != NL80211_IFTYPE_AP &&
+	    wdev->iftype != NL80211_IFTYPE_P2P_GO)
+		return -EINVAL;
+
+	if (wdev->ap_unexpected_nlpid)
+		return -EBUSY;
+
+	wdev->ap_unexpected_nlpid = info->snd_pid;
+	return 0;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -6382,6 +6399,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_UNEXPECTED_FRAME,
+		.doit = nl80211_register_unexpected_frame,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -7202,6 +7227,47 @@ void nl80211_send_sta_del_event(struct c
 	nlmsg_free(msg);
 }
 
+bool nl80211_unexpected_frame(struct net_device *dev, const u8 *addr, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+	int err;
+	u32 nlpid = ACCESS_ONCE(wdev->ap_unexpected_nlpid);
+
+	if (!nlpid)
+		return false;
+
+	msg = nlmsg_new(100, gfp);
+	if (!msg)
+		return true;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_UNEXPECTED_FRAME);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return true;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+	NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, addr);
+
+	err = genlmsg_end(msg, hdr);
+	if (err < 0) {
+		nlmsg_free(msg);
+		return true;
+	}
+
+	genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, nlpid);
+	return true;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+	return true;
+}
+
 int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 		      struct net_device *netdev, u32 nlpid,
 		      int freq, const u8 *buf, size_t len, gfp_t gfp)
--- a/net/wireless/nl80211.h	2011-10-21 10:20:42.000000000 +0200
+++ b/net/wireless/nl80211.h	2011-10-21 12:07:39.000000000 +0200
@@ -117,4 +117,7 @@ void nl80211_pmksa_candidate_notify(stru
 				    struct net_device *netdev, int index,
 				    const u8 *bssid, bool preauth, gfp_t gfp);
 
+bool nl80211_unexpected_frame(struct net_device *dev,
+			      const u8 *addr, gfp_t gfp);
+
 #endif /* __NET_WIRELESS_NL80211_H */


