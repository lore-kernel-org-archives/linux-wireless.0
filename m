Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34276 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933805AbeBMJVf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 04:21:35 -0500
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv2 1/3] cfg80211: enable setting cqm rssi config for AP mode
Date: Tue, 13 Feb 2018 14:50:56 +0530
Message-Id: <1518513656-22324-2-git-send-email-tamizhr@codeaurora.org> (sfid-20180213_102143_863956_DD3522A8)
In-Reply-To: <1518513656-22324-1-git-send-email-tamizhr@codeaurora.org>
References: <1518513656-22324-1-git-send-email-tamizhr@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tamizh chelvam <tamizhr@codeaurora.org>

This patch extend cqm rssi config and notifier feature to AP mode
by introducing NL80211_EXT_FEATURE_AP_STA_CQM_RSSI_CONFIG ext
feature bit. And this patch introduces NL80211_MCGRP_AP_STA_CQM
for notifying station's low/high rssi event to userspace application.

Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
---
 include/net/cfg80211.h       |   15 ++++++++++
 include/uapi/linux/nl80211.h |    6 ++++
 net/wireless/nl80211.c       |   68 +++++++++++++++++++++++++++++++++++-------
 3 files changed, 79 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7d49cd0..179904f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5704,6 +5704,21 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 			      s32 rssi_level, gfp_t gfp);
 
 /**
+ * cfg80211_ap_sta_cqm_rssi_notify - CQM rssi event for connected stations
+ * @dev: network device
+ * @mac: peer's MAC address
+ * @rssi_event: the triggered RSSI event
+ * @rssi_level: new RSSI level value or 0 if not available
+ * @gfp: context flags
+ *
+ * This function is called when a configured connection quality monitoring
+ * rssi threshold reached event occurs for a station.
+ */
+void cfg80211_ap_sta_cqm_rssi_notify(struct net_device *dev, const u8 *mac,
+		enum nl80211_cqm_rssi_threshold_event rssi_event,
+		s32 rssi_level, gfp_t gfp);
+
+/**
  * cfg80211_cqm_pktloss_notify - notify userspace about packetloss to peer
  * @dev: network device
  * @peer: peer's MAC address
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index ca3d5a6..9448bba 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -49,6 +49,7 @@
 #define NL80211_MULTICAST_GROUP_MLME		"mlme"
 #define NL80211_MULTICAST_GROUP_VENDOR		"vendor"
 #define NL80211_MULTICAST_GROUP_NAN		"nan"
+#define NL80211_MULTICAST_GROUP_AP_STA_CQM	"apstacqm"
 #define NL80211_MULTICAST_GROUP_TESTMODE	"testmode"
 
 /**
@@ -4996,6 +4997,10 @@ enum nl80211_feature_flags {
  * @NL80211_EXT_FEATURE_LOW_SPAN_SCAN: Driver supports low span scan.
  * @NL80211_EXT_FEATURE_LOW_POWER_SCAN: Driver supports low power scan.
  * @NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN: Driver supports high accuracy scan.
+ * @NL80211_EXT_FEATURE_AP_STA_CQM_RSSI_CONFIG: With this driver the
+ *	non P2P/STA interface accept %NL80211_ATTR_CQM_RSSI_THOLD  and
+ *	%NL80211_ATTR_CQM_RSSI_HYST attributes to monitor connected clients
+ *	rssi values.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -5026,6 +5031,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_LOW_SPAN_SCAN,
 	NL80211_EXT_FEATURE_LOW_POWER_SCAN,
 	NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN,
+	NL80211_EXT_FEATURE_AP_STA_CQM_RSSI_CONFIG,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index cc6ec5b..68627a7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -43,6 +43,7 @@ enum nl80211_multicast_groups {
 	NL80211_MCGRP_MLME,
 	NL80211_MCGRP_VENDOR,
 	NL80211_MCGRP_NAN,
+	NL80211_MCGRP_AP_STA_CQM,
 	NL80211_MCGRP_TESTMODE /* keep last - ifdef! */
 };
 
@@ -53,6 +54,8 @@ enum nl80211_multicast_groups {
 	[NL80211_MCGRP_MLME] = { .name = NL80211_MULTICAST_GROUP_MLME },
 	[NL80211_MCGRP_VENDOR] = { .name = NL80211_MULTICAST_GROUP_VENDOR },
 	[NL80211_MCGRP_NAN] = { .name = NL80211_MULTICAST_GROUP_NAN },
+	[NL80211_MCGRP_AP_STA_CQM] = {
+				.name = NL80211_MULTICAST_GROUP_AP_STA_CQM },
 #ifdef CONFIG_NL80211_TESTMODE
 	[NL80211_MCGRP_TESTMODE] = { .name = NL80211_MULTICAST_GROUP_TESTMODE }
 #endif
@@ -9903,8 +9906,10 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
 		prev = thresholds[i];
 	}
 
-	if (wdev->iftype != NL80211_IFTYPE_STATION &&
-	    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT)
+	if ((wdev->iftype != NL80211_IFTYPE_STATION &&
+	     wdev->iftype != NL80211_IFTYPE_P2P_CLIENT &&
+	     !wiphy_ext_feature_isset(&rdev->wiphy,
+				NL80211_EXT_FEATURE_AP_STA_CQM_RSSI_CONFIG)))
 		return -EOPNOTSUPP;
 
 	wdev_lock(wdev);
@@ -14601,9 +14606,24 @@ static void cfg80211_send_cqm(struct sk_buff *msg, gfp_t gfp)
 				NL80211_MCGRP_MLME, gfp);
 }
 
-void cfg80211_cqm_rssi_notify(struct net_device *dev,
-			      enum nl80211_cqm_rssi_threshold_event rssi_event,
-			      s32 rssi_level, gfp_t gfp)
+static void cfg80211_send_ap_sta_cqm(struct sk_buff *msg, gfp_t gfp)
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
+				NL80211_MCGRP_AP_STA_CQM, gfp);
+}
+
+static struct sk_buff *cfg80211_cqm_rssi_prepare(struct net_device *dev,
+			const u8 *mac,
+			enum nl80211_cqm_rssi_threshold_event rssi_event,
+			s32 rssi_level, gfp_t gfp)
 {
 	struct sk_buff *msg;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
@@ -14613,7 +14633,7 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 
 	if (WARN_ON(rssi_event != NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW &&
 		    rssi_event != NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH))
-		return;
+		return NULL;
 
 	if (wdev->cqm_config) {
 		wdev->cqm_config->last_rssi_event_value = rssi_level;
@@ -14626,7 +14646,7 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 
 	msg = cfg80211_prepare_cqm(dev, NULL, gfp);
 	if (!msg)
-		return;
+		return NULL;
 
 	if (nla_put_u32(msg, NL80211_ATTR_CQM_RSSI_THRESHOLD_EVENT,
 			rssi_event))
@@ -14636,15 +14656,43 @@ void cfg80211_cqm_rssi_notify(struct net_device *dev,
 				      rssi_level))
 		goto nla_put_failure;
 
-	cfg80211_send_cqm(msg, gfp);
-
-	return;
+	return msg;
 
  nla_put_failure:
 	nlmsg_free(msg);
+	return NULL;
+}
+
+void cfg80211_cqm_rssi_notify(struct net_device *dev,
+			      enum nl80211_cqm_rssi_threshold_event rssi_event,
+			      s32 rssi_level, gfp_t gfp)
+{
+	struct sk_buff *msg;
+
+	msg = cfg80211_cqm_rssi_prepare(dev, NULL, rssi_event, rssi_level,
+					gfp);
+	if (!msg)
+		return;
+	cfg80211_send_cqm(msg, gfp);
+
+	return;
 }
 EXPORT_SYMBOL(cfg80211_cqm_rssi_notify);
 
+void cfg80211_ap_sta_cqm_rssi_notify(struct net_device *dev, const u8 *mac,
+			  enum nl80211_cqm_rssi_threshold_event rssi_event,
+			  s32 rssi_level, gfp_t gfp)
+{
+	struct sk_buff *msg;
+
+	msg = cfg80211_cqm_rssi_prepare(dev, mac, rssi_event, rssi_level,
+					gfp);
+	if (!msg)
+		return;
+	cfg80211_send_ap_sta_cqm(msg, gfp);
+}
+EXPORT_SYMBOL(cfg80211_ap_sta_cqm_rssi_notify);
+
 void cfg80211_cqm_txe_notify(struct net_device *dev,
 			     const u8 *peer, u32 num_packets,
 			     u32 rate, u32 intvl, gfp_t gfp)
-- 
1.7.9.5
