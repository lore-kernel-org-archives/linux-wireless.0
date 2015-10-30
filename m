Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:27954 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030304AbbJ3NpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2015 09:45:13 -0400
From: Sunil Dutt <usdutt@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
	<vkanchan@qti.qualcomm.com>, <amarnath@qca.qualcomm.com>,
	<usdutt@qti.qualcomm.com>
Subject: [PATCH v2 1/2] cfg80211: Add support for aborting an ongoing scan
Date: Fri, 30 Oct 2015 19:14:49 +0530
Message-ID: <1446212690-326-1-git-send-email-usdutt@qti.qualcomm.com> (sfid-20151030_144519_032142_D18A7DE4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vidyullatha Kanchanapally <vkanchan@qti.qualcomm.com>

Implement new functionality for aborting an ongoing scan.

Add NL80211_CMD_ABORT_SCAN to the nl80211 interface. After
aborting the scan, driver shall provide the scan status by
calling cfg80211_scan_done().

Reviewed-by: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: Vidyullatha Kanchanapally <vkanchan@qti.qualcomm.com>
Signed-off-by: Sunil Dutt <usdutt@qti.qualcomm.com>
---
v2: Change return value of abort_scan to void

 include/net/cfg80211.h       |  4 ++++
 include/uapi/linux/nl80211.h |  6 ++++++
 net/wireless/nl80211.c       | 26 ++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      |  9 +++++++++
 net/wireless/trace.h         |  5 +++++
 5 files changed, 50 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 48155be..6cb2e25 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2488,6 +2488,9 @@ struct cfg80211_qos_map {
  *	and returning to the base channel for communication with the AP.
  * @tdls_cancel_channel_switch: Stop channel-switching with a TDLS peer. Both
  *	peers must be on the base channel when the call completes.
+ *
+ * @abort_scan: Tell the driver to abort an ongoing scan. The driver shall
+ *	indicate the status of the scan through cfg80211_scan_done().
  */
 struct cfg80211_ops {
 	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
@@ -2752,6 +2755,7 @@ struct cfg80211_ops {
 	void	(*tdls_cancel_channel_switch)(struct wiphy *wiphy,
 					      struct net_device *dev,
 					      const u8 *addr);
+	void     (*abort_scan)(struct wiphy *wiphy, struct net_device *dev);
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1f0b4cf..7c8645f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -820,6 +820,10 @@
  *	as an event to indicate changes for devices with wiphy-specific regdom
  *	management.
  *
+ * @NL80211_CMD_ABORT_SCAN: Stop an ongoing scan. Returns -ENOENT if a scan is
+ *	not running. The driver indicates the status of the scan through
+ *	cfg80211_scan_done().
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1006,6 +1010,8 @@ enum nl80211_commands {
 
 	NL80211_CMD_WIPHY_REG_CHANGE,
 
+	NL80211_CMD_ABORT_SCAN,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d693c9d..6a7b4cf 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10588,6 +10588,24 @@ static int nl80211_tdls_cancel_channel_switch(struct sk_buff *skb,
 	return 0;
 }
 
+static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+
+	if (!rdev->ops->abort_scan)
+		return -EOPNOTSUPP;
+
+	if (rdev->scan_msg)
+		return 0;
+
+	if (!rdev->scan_req)
+		return -ENOENT;
+
+	rdev_abort_scan(rdev, dev);
+	return 0;
+}
+
 #define NL80211_FLAG_NEED_WIPHY		0x01
 #define NL80211_FLAG_NEED_NETDEV	0x02
 #define NL80211_FLAG_NEED_RTNL		0x04
@@ -11406,6 +11424,14 @@ static const struct genl_ops nl80211_ops[] = {
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
+	{
+		.cmd = NL80211_CMD_ABORT_SCAN,
+		.doit = nl80211_abort_scan,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+				  NL80211_FLAG_NEED_RTNL,
+	},
 };
 
 /* notification functions */
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index c23516d..05edf43 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -1020,4 +1020,13 @@ rdev_tdls_cancel_channel_switch(struct cfg80211_registered_device *rdev,
 	trace_rdev_return_void(&rdev->wiphy);
 }
 
+static inline void
+rdev_abort_scan(struct cfg80211_registered_device *rdev,
+		struct net_device *dev)
+{
+	trace_rdev_abort_scan(&rdev->wiphy, dev);
+	rdev->ops->abort_scan(&rdev->wiphy, dev);
+	trace_rdev_return_void(&rdev->wiphy);
+}
+
 #endif /* __CFG80211_RDEV_OPS */
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 0c392d3..ceb20eb 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2818,6 +2818,11 @@ TRACE_EVENT(cfg80211_stop_iface,
 		  WIPHY_PR_ARG, WDEV_PR_ARG)
 );
 
+DEFINE_EVENT(wiphy_netdev_evt, rdev_abort_scan,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev)
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.8.2.1

