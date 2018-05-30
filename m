Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48614 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932172AbeE3TJD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 15:09:03 -0400
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [RFCv3 4/7] cfg80211: Add support to notify station's rssi level crossing
Date: Thu, 31 May 2018 00:38:43 +0530
Message-Id: <1527707326-2822-5-git-send-email-tamizhr@codeaurora.org> (sfid-20180530_210912_794345_D3D141E2)
In-Reply-To: <1527707326-2822-1-git-send-email-tamizhr@codeaurora.org>
References: <1527707326-2822-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add cfg80211_sta_mon_rssi_notify api to update user space upon
crossing the configured rssi threshold of a station.
NL80211_CMD_NOTIFY_STA_MON introduced to send this event to
userspace along with NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT,
NL80211_ATTR_MAC and NL80211_ATTR_STA_MON_RSSI_LEVEL info.
Userspace application can make a decision depends on this
notification.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       | 16 ++++++++
 include/uapi/linux/nl80211.h |  1 +
 net/wireless/nl80211.c       | 98 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/trace.h         | 22 ++++++++++
 4 files changed, 137 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8e4c7db..494d47f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5915,6 +5915,22 @@ void cfg80211_cqm_txe_notify(struct net_device *dev, const u8 *peer,
 void cfg80211_cqm_beacon_loss_notify(struct net_device *dev, gfp_t gfp);
 
 /**
+ * cfg80211_sta_mon_rssi_notify - Station's rssi out of range event
+ * @dev: network device
+ * @peer: Station's mac address
+ * @rssi_event: the triggered RSSI event
+ * @rssi_level: new RSSI level value or 0 if not available
+ * @gfp: context flags
+ *
+ * This function is called when a configured rssi threshold reached event
+ * occurs for a station.
+ */
+void
+cfg80211_sta_mon_rssi_notify(struct net_device *dev, const u8 *peer,
+		enum nl80211_sta_mon_rssi_threshold_event rssi_event,
+		s32 rssi_level, gfp_t gfp);
+
+/**
  * cfg80211_radar_event - radar detection event
  * @wiphy: the wiphy
  * @chandef: chandef for the current channel
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f13ad07..9d47ee6 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1249,6 +1249,7 @@ enum nl80211_commands {
 	NL80211_CMD_CONTROL_PORT_FRAME,
 
 	NL80211_CMD_SET_STA_MON,
+	NL80211_CMD_NOTIFY_STA_MON,
 
 	/* add new commands above here */
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 587a5cb1..021e55a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -15364,6 +15364,104 @@ void cfg80211_pmksa_candidate_notify(struct net_device *dev, int index,
 }
 EXPORT_SYMBOL(cfg80211_pmksa_candidate_notify);
 
+static struct sk_buff *cfg80211_prepare_sta_mon(struct net_device *dev,
+						const char *mac, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct sk_buff *msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	void **cb;
+
+	if (!msg)
+		return NULL;
+
+	cb = (void **)msg->cb;
+
+	cb[0] = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_NOTIFY_STA_MON);
+	if (!cb[0]) {
+		nlmsg_free(msg);
+		return NULL;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, dev->ifindex))
+		goto nla_put_failure;
+
+	if (nla_put(msg, NL80211_ATTR_MAC, ETH_ALEN, mac))
+		goto nla_put_failure;
+
+	cb[1] = nla_nest_start(msg, NL80211_ATTR_STA_MON);
+	if (!cb[1])
+		goto nla_put_failure;
+
+	cb[2] = rdev;
+
+	return msg;
+nla_put_failure:
+	nlmsg_free(msg);
+	return NULL;
+}
+
+static void cfg80211_send_sta_mon(struct sk_buff *msg, gfp_t gfp)
+{
+	void **cb = (void **)msg->cb;
+	struct cfg80211_registered_device *rdev = cb[2];
+
+	nla_nest_end(msg, cb[1]);
+	genlmsg_end(msg, cb[0]);
+
+	memset(msg->cb, 0, sizeof(msg->cb));
+
+	genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy), msg, 0,
+				NL80211_MCGRP_MLME, gfp);
+}
+
+void cfg80211_sta_mon_rssi_notify(struct net_device *dev, const u8 *peer,
+		enum nl80211_sta_mon_rssi_threshold_event rssi_event,
+		s32 rssi_level, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_rssi_config *rssi_config;
+
+	if (WARN_ON(!peer))
+		return;
+
+	if (WARN_ON(rssi_event != NL80211_STA_MON_RSSI_THRESHOLD_EVENT_LOW &&
+		    rssi_event != NL80211_STA_MON_RSSI_THRESHOLD_EVENT_HIGH))
+		return;
+
+	trace_cfg80211_sta_mon_rssi_notify(dev, peer, rssi_event, rssi_level);
+
+	list_for_each_entry(rssi_config, &wdev->rssi_config_list, list) {
+		if (!memcmp(rssi_config->addr, peer, ETH_ALEN)) {
+			wdev->rssi_config = rssi_config;
+			wdev->rssi_config->last_rssi_event_value = rssi_level;
+			break;
+		}
+	}
+
+	msg = cfg80211_prepare_sta_mon(dev, peer, gfp);
+	if (!msg)
+		return;
+
+	if (nla_put_u32(msg, NL80211_ATTR_STA_MON_RSSI_THRESHOLD_EVENT,
+			rssi_event))
+		goto nla_put_failure;
+
+	if (rssi_level && nla_put_s32(msg, NL80211_ATTR_STA_MON_RSSI_LEVEL,
+				      rssi_level))
+		goto nla_put_failure;
+
+	cfg80211_send_sta_mon(msg, gfp);
+
+	return;
+
+nla_put_failure:
+	nlmsg_free(msg);
+}
+EXPORT_SYMBOL(cfg80211_sta_mon_rssi_notify);
+
 static void nl80211_ch_switch_notify(struct cfg80211_registered_device *rdev,
 				     struct net_device *netdev,
 				     struct cfg80211_chan_def *chandef,
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 361ec08..5454c57 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -3282,6 +3282,28 @@
 		  WIPHY_PR_ARG, NETDEV_PR_ARG, MAC_PR_ARG(peer),
 		  __entry->rssi_thold, __entry->rssi_hyst)
 );
+TRACE_EVENT(cfg80211_sta_mon_rssi_notify,
+	TP_PROTO(struct net_device *netdev, const u8 *peer,
+		 enum nl80211_sta_mon_rssi_threshold_event rssi_event,
+		 s32 rssi_level),
+	TP_ARGS(netdev, peer, rssi_event, rssi_level),
+	TP_STRUCT__entry(
+		NETDEV_ENTRY
+		MAC_ENTRY(peer)
+		__field(enum nl80211_sta_mon_rssi_threshold_event, rssi_event)
+		__field(s32, rssi_level)
+	),
+	TP_fast_assign(
+		NETDEV_ASSIGN;
+		MAC_ASSIGN(peer, peer);
+		__entry->rssi_event = rssi_event;
+		__entry->rssi_level = rssi_level;
+	),
+	TP_printk(NETDEV_PR_FMT ", peer: " MAC_PR_FMT
+		  ", rssi event: %d, rssi : %d",
+		  NETDEV_PR_ARG, MAC_PR_ARG(peer),
+		  __entry->rssi_event, __entry->rssi_level)
+);
 #endif /* !__RDEV_OPS_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
1.9.1
