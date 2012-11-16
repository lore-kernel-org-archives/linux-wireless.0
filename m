Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:36993 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab2KPUuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 15:50:03 -0500
Date: Fri, 16 Nov 2012 22:49:57 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: Add TDLS event to allow drivers to request
 operations
Message-ID: <20121116204957.GA32028@jouni.qca.qualcomm.com> (sfid-20121116_215008_369003_19BCBEF5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The NL80211_CMD_TDLS_OPER command was previously used only for userspace
request for the kernel code to perform TDLS operations. However, there
are also cases where the driver may need to request operations from
userspace, e.g., when using security on the AP path. Add a new cfg80211
function for generating a TDLS operation event for drivers to request a
new link to be set up (NL80211_TDLS_SETUP) or an existing link to be
torn down (NL80211_TDLS_TEARDOWN). Drivers can optionally use these
events, e.g., based on noticing data traffic being sent to a peer
station that is seen with good signal strength.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       |   19 +++++++++++++++++
 include/uapi/linux/nl80211.h |    6 ++++++
 net/wireless/nl80211.c       |   47 ++++++++++++++++++++++++++++++++++++++++++
 net/wireless/trace.h         |   23 +++++++++++++++++++++
 4 files changed, 95 insertions(+)

Please note that the tracing format here assumes that your cleanup
changes go in:
http://p.sipsolutions.net/34e0f8665f6ae289.txt
Without those, this looks a bit odd, but seems to work, so it should be
fine to apply the patches in either order.


diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 81d7250..8a1aec5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3594,6 +3594,25 @@ void cfg80211_ch_switch_notify(struct net_device *dev, int freq,
 			       enum nl80211_channel_type type);
 
 /*
+ * cfg80211_tdls_oper_request - request userspace to perform TDLS operation
+ * @dev: the device on which the operation is requested
+ * @peer: the MAC address of the peer device
+ * @oper: the requested TDLS operation (NL80211_TDLS_SETUP or
+ *	NL80211_TDLS_TEARDOWN)
+ * @reason_code: the reason code for teardown request
+ * @gfp: allocation flags
+ *
+ * This function is used to request userspace to perform TDLS operation that
+ * requires knowledge of keys, i.e., link setup or teardown when the AP
+ * connection uses encryption. This is optional mechanism for the driver to use
+ * if it can automatically determine when a TDLS link could be useful (e.g.,
+ * based on traffic and signal strength for a peer).
+ */
+void cfg80211_tdls_oper_request(struct net_device *dev, const u8 *peer,
+				enum nl80211_tdls_operation oper,
+				u16 reason_code, gfp_t gfp);
+
+/*
  * cfg80211_calculate_bitrate - calculate actual bitrate (in 100Kbps units)
  * @rate: given rate_info to calculate bitrate from
  *
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index cbd2d6b..a4e7268 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -526,6 +526,12 @@
  *	of PMKSA caching dandidates.
  *
  * @NL80211_CMD_TDLS_OPER: Perform a high-level TDLS command (e.g. link setup).
+ *	In addition, this can be used as an event to request userspace to take
+ *	actions on TDLS links (set up a new link or tear down an existing one).
+ *	In such events, %NL80211_ATTR_TDLS_OPERATION indicates the requested
+ *	operation, %NL80211_ATTR_MAC contains the peer MAC address, and
+ *	%NL80211_ATTR_REASON_CODE the reason code to be used (only with
+ *	%NL80211_TDLS_TEARDOWN).
  * @NL80211_CMD_TDLS_MGMT: Send a TDLS management frame.
  *
  * @NL80211_CMD_UNEXPECTED_FRAME: Used by an application controlling an AP
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c18b2fc..4c427fa 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9027,6 +9027,53 @@ void cfg80211_report_obss_beacon(struct wiphy *wiphy,
 }
 EXPORT_SYMBOL(cfg80211_report_obss_beacon);
 
+void cfg80211_tdls_oper_request(struct net_device *dev, const u8 *peer,
+				enum nl80211_tdls_operation oper,
+				u16 reason_code, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct sk_buff *msg;
+	void *hdr;
+	int err;
+
+	trace_cfg80211_tdls_oper_request(wdev->wiphy, dev, peer, oper,
+					 reason_code);
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_TDLS_OPER);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex) ||
+	    nla_put_u8(msg, NL80211_ATTR_TDLS_OPERATION, oper) ||
+	    nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, peer) ||
+	    (reason_code > 0 &&
+	     nla_put_u16(msg, NL80211_ATTR_REASON_CODE, reason_code)))
+		goto nla_put_failure;
+
+	err = genlmsg_end(msg, hdr);
+	if (err < 0) {
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
+EXPORT_SYMBOL(cfg80211_tdls_oper_request);
+
 static int nl80211_netlink_notify(struct notifier_block * nb,
 				  unsigned long state,
 				  void *_notify)
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 8e03c63..f264c20 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2157,6 +2157,29 @@ TRACE_EVENT(cfg80211_report_obss_beacon,
 		  WIPHY_PR_ARG, __entry->freq, __entry->sig_dbm)
 );
 
+TRACE_EVENT(cfg80211_tdls_oper_request,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, const u8 *peer,
+		 enum nl80211_tdls_operation oper, u16 reason_code),
+	TP_ARGS(wiphy, netdev, peer, oper, reason_code),
+	TP_STRUCT__entry(
+		WIPHY_ENTRY
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(enum nl80211_tdls_operation, oper)
+		__field(u16, reason_code)
+	),
+	TP_fast_assign(
+		WIPHY_ASSIGN;
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->oper = oper;
+		__entry->reason_code = reason_code;
+	),
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", peer: " MAC_PR_FMT ", oper: %d, reason_code %u",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer), __entry->oper,
+		  __entry->reason_code)
+	);
+
 TRACE_EVENT(cfg80211_scan_done,
 	TP_PROTO(struct cfg80211_scan_request *request, bool aborted),
 	TP_ARGS(request, aborted),
-- 
1.7.9.5


-- 
Jouni Malinen                                            PGP id EFC895FA
