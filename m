Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54164 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932158AbeE3TLG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 15:11:06 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFCv3 3/4] cfg80211: Add support to notify station's txrate crossing event
Date: Thu, 31 May 2018 00:40:49 +0530
Message-Id: <1527707450-2985-4-git-send-email-tamizhr@codeaurora.org> (sfid-20180530_211113_612268_9A721249)
In-Reply-To: <1527707450-2985-1-git-send-email-tamizhr@codeaurora.org>
References: <1527707450-2985-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add cfg80211_sta_mon_txrate_notify to update userspace upon
crossing the configured txrate threshold for a station.
This uses NL80211_CMD_NOTIFY_STA_MON along with
NL80211_ATTR_STA_MON_TXRATE_THRESHOLD_EVENT, NL80211_ATTR_MAC
and NL80211_ATTR_STA_MON_TXRATE_LEVEL. Userspace application can
make a decision on the station depends on this notification.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h | 17 +++++++++++++++++
 net/wireless/nl80211.c | 36 ++++++++++++++++++++++++++++++++++++
 net/wireless/trace.h   | 25 +++++++++++++++++++++++++
 3 files changed, 78 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ab8a43f..b02ed31 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5898,6 +5898,23 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			      s32 rssi_level, gfp_t gfp);
 
 /**
+ * cfg80211_sta_mon_txrate_notify - txrate event for connected stations
+ * @dev: network device
+ * @peer: peer's MAC address
+ * @txrate_event: the triggered TX RATE event
+ * @txrate_level: new TX RATE level value or 0 if not available
+ * @gfp: context flags
+ *
+ * This function is called when a average of attempted frame txrate crossed
+ * above configured high txrate or below configured low txrate event
+ * occurs for a station.
+ */
+void
+cfg80211_sta_mon_txrate_notify(struct net_device *dev, const u8 *peer,
+		enum nl80211_sta_mon_txrate_threshold_event txrate_event,
+		u32 txrate_level, gfp_t gfp);
+
+/**
  * cfg80211_cqm_pktloss_notify - notify userspace about packetloss to peer
  * @dev: network device
  * @peer: peer's MAC address
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 31680d6..6701961 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -15576,6 +15576,42 @@ void cfg80211_sta_mon_rssi_notify(struct net_device *dev, const u8 *peer,
 }
 EXPORT_SYMBOL(cfg80211_sta_mon_rssi_notify);
 
+void
+cfg80211_sta_mon_txrate_notify(struct net_device *dev, const u8 *peer,
+		enum nl80211_sta_mon_txrate_threshold_event txrate_event,
+		u32 txrate_level, gfp_t gfp)
+{
+	struct sk_buff *msg;
+
+	trace_cfg80211_sta_mon_txrate_notify(dev, peer, txrate_event,
+					     txrate_level);
+
+	if (WARN_ON(txrate_event !=
+			NL80211_STA_MON_TXRATE_THRESHOLD_EVENT_LOW &&
+		    txrate_event !=
+			NL80211_STA_MON_TXRATE_THRESHOLD_EVENT_HIGH))
+		return;
+
+	msg = cfg80211_prepare_sta_mon(dev, peer, gfp);
+	if (!msg)
+		return;
+
+	if (nla_put_u32(msg, NL80211_ATTR_STA_MON_TXRATE_THRESHOLD_EVENT,
+			txrate_event))
+		goto nla_put_failure;
+
+	if (txrate_level && nla_put_u32(msg, NL80211_ATTR_STA_MON_TXRATE_LEVEL,
+					txrate_level))
+		goto nla_put_failure;
+
+	cfg80211_send_sta_mon(msg, gfp);
+
+	return;
+nla_put_failure:
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_sta_mon_txrate_notify);
+
 static void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
 				     struct net_device *netdev,
 				     struct cfg80211_chan_def *chandef,
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index ca985c2..95f4a31 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3355,6 +3355,31 @@
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer),
 		  __entry->low_txrate_thold, __entry->high_txrate_thold)
 );
+
+TRACE_EVENT(cfg80211_sta_mon_txrate_notify,
+	TP_PROTO(struct net_device *netdev, const u8 *peer,
+		 enum nl80211_sta_mon_txrate_threshold_event txrate_event,
+		 u32 txrate_level),
+	TP_ARGS(netdev, peer, txrate_event, txrate_level),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(enum nl80211_sta_mon_txrate_threshold_event,
+			txrate_event)
+		__field(u32, txrate_level)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->txrate_event = txrate_event;
+		__entry->txrate_level = txrate_level;
+	),
+	TP_printk(NETDEV_PR_FMT ", peer: " MAC_PR_FMT
+		  ", tx_rate event: %d, txrate : %u",
+		  NETDEV_PR_ARG, MAC_PR_ARG(peer),
+		  __entry->txrate_event, __entry->txrate_level)
+);
+
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.9.1
