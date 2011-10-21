Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37144 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab1JUOZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Oct 2011 10:25:47 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RHG2c-00004r-Fj
	for linux-wireless@vger.kernel.org; Fri, 21 Oct 2011 16:25:46 +0200
Message-Id: <20111021142430.021723679@sipsolutions.net> (sfid-20111021_162550_899624_81891510)
Date: Fri, 21 Oct 2011 16:23:33 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC v2 11/12] cfg80211: allow registering to beacons
References: <20111021142322.229128720@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add the ability to register to received beacon frames
to allow implementing OLBC logic in userspace. The
registration is per wiphy since there's no point in
receiving the same frame multiple times.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |    7 ++++
 include/net/cfg80211.h  |   20 +++++++++++++
 net/wireless/core.h     |    2 +
 net/wireless/nl80211.c  |   70 +++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 98 insertions(+), 1 deletion(-)

--- a/net/wireless/core.h	2011-10-21 12:07:56.000000000 +0200
+++ b/net/wireless/core.h	2011-10-21 13:10:17.000000000 +0200
@@ -54,6 +54,8 @@ struct cfg80211_registered_device {
 	int opencount; /* also protected by devlist_mtx */
 	wait_queue_head_t dev_wait;
 
+	u32 ap_beacons_nlpid;
+
 	/* BSSes/scanning */
 	spinlock_t bss_lock;
 	struct list_head bss_list;
--- a/include/linux/nl80211.h	2011-10-21 12:07:45.000000000 +0200
+++ b/include/linux/nl80211.h	2011-10-21 13:15:22.000000000 +0200
@@ -528,6 +528,11 @@
  *	up the event with the request. The event includes the same data and
  *	has %NL80211_ATTR_ACK set if the frame was ACKed.
  *
+ * @NL80211_CMD_REGISTER_BEACONS: Register this socket to receive beacons from
+ *	other BSSes when any interfaces are in AP mode. This helps implement
+ *	OLBC handling in hostapd. Beacons are reported in %NL80211_CMD_FRAME
+ *	messages. Note that per PHY only one application may register.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -661,6 +666,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_PROBE_CLIENT,
 
+	NL80211_CMD_REGISTER_BEACONS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
--- a/net/wireless/nl80211.c	2011-10-21 12:07:45.000000000 +0200
+++ b/net/wireless/nl80211.c	2011-10-21 13:56:35.000000000 +0200
@@ -892,6 +892,10 @@ static int nl80211_send_wiphy(struct sk_
 	if (dev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
 		CMD(sched_scan_start, START_SCHED_SCAN);
 	CMD(probe_client, PROBE_CLIENT);
+	if (dev->wiphy.flags & WIPHY_FLAG_REPORTS_OBSS) {
+		i++;
+		NLA_PUT_U32(msg, i, NL80211_CMD_REGISTER_BEACONS);
+	}
 
 #undef CMD
 
@@ -5904,6 +5908,21 @@ static int nl80211_probe_client(struct s
 	return err;
 }
 
+static int nl80211_register_beacons(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_REPORTS_OBSS))
+		return -EOPNOTSUPP;
+
+	if (rdev->ap_beacons_nlpid)
+		return -EBUSY;
+
+	rdev->ap_beacons_nlpid = info->snd_pid;
+
+	return 0;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -6475,6 +6494,14 @@ static struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_REGISTER_BEACONS,
+		.doit = nl80211_register_beacons,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_WIPHY |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 static struct genl_multicast_group nl80211_mlme_mcgrp = {
@@ -7638,6 +7665,44 @@ void cfg80211_probe_status(struct net_de
 }
 EXPORT_SYMBOL(cfg80211_probe_status);
 
+void cfg80211_report_obss_beacon(struct wiphy *wiphy,
+				 const u8 *frame, size_t len,
+				 int freq, gfp_t gfp)
+{
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+	u32 nlpid = ACCESS_ONCE(rdev->ap_beacons_nlpid);
+
+	if (!nlpid)
+		return;
+
+	msg = nlmsg_new(len + 100, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_FRAME);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	NLA_PUT_U32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx);
+	if (freq)
+		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_FREQ, freq);
+	NLA_PUT(msg, NL80211_ATTR_FRAME, len, frame);
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_unicast(wiphy_net(&rdev->wiphy), msg, nlpid);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_report_obss_beacon);
+
 static int nl80211_netlink_notify(struct notifier_block * nb,
 				  unsigned long state,
 				  void *_notify)
@@ -7651,9 +7716,12 @@ static int nl80211_netlink_notify(struct
 
 	rcu_read_lock();
 
-	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list)
+	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list) {
 		list_for_each_entry_rcu(wdev, &rdev->netdev_list, list)
 			cfg80211_mlme_unregister_socket(wdev, notify->pid);
+		if (rdev->ap_beacons_nlpid == notify->pid)
+			rdev->ap_beacons_nlpid = 0;
+	}
 
 	rcu_read_unlock();
 
--- a/include/net/cfg80211.h	2011-10-21 12:07:45.000000000 +0200
+++ b/include/net/cfg80211.h	2011-10-21 13:30:37.000000000 +0200
@@ -1682,6 +1682,9 @@ struct cfg80211_ops {
  *	command. When this flag is not set, @NL80211_CMD_TDLS_OPER should be
  *	used for asking the driver/firmware to perform a TDLS operation.
  * @WIPHY_FLAG_HAVE_AP_SME: device integrates AP SME
+ * @WIPHY_FLAG_REPORTS_OBSS: the device will report beacons from other BSSes
+ *	when there are virtual interfaces in AP mode by calling
+ *	cfg80211_report_obss_beacon().
  */
 enum wiphy_flags {
 	WIPHY_FLAG_CUSTOM_REGULATORY		= BIT(0),
@@ -1701,6 +1704,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_SUPPORTS_TDLS		= BIT(15),
 	WIPHY_FLAG_TDLS_EXTERNAL_SETUP		= BIT(16),
 	WIPHY_FLAG_HAVE_AP_SME			= BIT(17),
+	WIPHY_FLAG_REPORTS_OBSS			= BIT(18),
 };
 
 /**
@@ -3228,6 +3232,22 @@ bool cfg80211_rx_spurious_frame(struct n
 void cfg80211_probe_status(struct net_device *dev, const u8 *addr,
 			   u64 cookie, bool acked, gfp_t gfp);
 
+/**
+ * cfg80211_report_obss_beacon - report beacon from other APs
+ * @wiphy: The wiphy that received the beacon
+ * @frame: the frame
+ * @len: length of the frame
+ * @freq: frequency the frame was received on
+ * @gfp: allocation flags
+ *
+ * Use this function to report to userspace when a beacon was
+ * received. It is not useful to call this when there is no
+ * netdev that is in AP/GO mode.
+ */
+void cfg80211_report_obss_beacon(struct wiphy *wiphy,
+				 const u8 *frame, size_t len,
+				 int freq, gfp_t gfp);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */


