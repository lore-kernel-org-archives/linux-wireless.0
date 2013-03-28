Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:28758 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752837Ab3C1VSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 17:18:48 -0400
From: "Thalappil, Sameer" <sameert@qca.qualcomm.com>
To: "johannes@sipsolutions.net" <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Add "interface unavailable" event
Date: Thu, 28 Mar 2013 21:18:47 +0000
Message-ID: <E5558617D99C4049BE29CA73B21DCDA9114497BC@nasanexd01h.na.qualcomm.com> (sfid-20130328_221857_693295_D5E6FA12)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NL80211_CMD_INTERFACE_UNAVAILABLE command is used to indicate that
the interface is not available to userspace. The driver may have
encountered errors that has forced the driver to report this event.

When the driver is in P2P-Go mode, and when it goes thru automatic
recovery from firmware crashes, it uses this interface to notify the
userspace that the group has been deleted. The userspace should retry
once this event is received.

Signed-off-by: Sameer Thalappil <sameert@qca.qualcomm.com>
---
 include/net/cfg80211.h       |   11 +++++++++++
 include/uapi/linux/nl80211.h |    5 +++++
 net/wireless/nl80211.c       |   12 ++++++++++++
 net/wireless/trace.h         |   15 +++++++++++++++
 4 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h index bdba9b6..699baba 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3854,6 +3854,17 @@ bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_dbm,  void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
 			     const u8 *buf, size_t len, bool ack, gfp_t gfp);
 
+/**
+ * cfg80211_send_iface_unavailable - Notify unavailable interface
+ * @netdev: network device
+ * @gfp: allocation flags
+ *
+ * This function is used to notify the userspace about the 
+unavailability
+ * of the network interface. The driver may have encountered errors 
+that has
+ * forced it to notify the userpace.
+ */
+void cfg80211_send_iface_unavailable(struct net_device *netdev, gfp_t 
+gfp);
+
 
 /**
  * cfg80211_cqm_rssi_notify - connection quality monitoring rssi event diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h index 79da871..401e520 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -639,6 +639,9 @@
  *	with the relevant Information Elements. This event is used to report
  *	received FT IEs (MDIE, FTIE, RSN IE, TIE, RICIE).
  *
+ * @NL80211_CMD_INTERFACE_UNAVAILABLE: Notify the userspace about the
+ *	unavailability of network interface.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -798,6 +801,8 @@ enum nl80211_commands {
 	NL80211_CMD_UPDATE_FT_IES,
 	NL80211_CMD_FT_EVENT,
 
+	NL80211_CMD_INTERFACE_UNAVAILABLE,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */ diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c index 671b69a..6ef18dc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10549,6 +10549,18 @@ void cfg80211_tdls_oper_request(struct net_device *dev, const u8 *peer,  }  EXPORT_SYMBOL(cfg80211_tdls_oper_request);
 
+void cfg80211_send_iface_unavailable(struct net_device *netdev, gfp_t 
+gfp) {
+	struct wireless_dev *wdev = netdev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+
+	trace_cfg80211_send_iface_unavailable(wdev->wiphy, netdev);
+
+	nl80211_send_mlme_event(rdev, netdev, NULL, 0,
+				NL80211_CMD_INTERFACE_UNAVAILABLE, gfp); } 
+EXPORT_SYMBOL(cfg80211_send_iface_unavailable);
+
 static int nl80211_netlink_notify(struct notifier_block * nb,
 				  unsigned long state,
 				  void *_notify)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h index 3c2033b..0b10a58 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2460,6 +2460,21 @@ TRACE_EVENT(cfg80211_ft_event,
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(target_ap))  );
 
+TRACE_EVENT(cfg80211_send_iface_unavailable,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev),
+	TP_ARGS(wiphy, netdev),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT,
+		  WIPHY_PR_ARG, NETDEV_PR_ARG)
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
--
1.7.8.3
