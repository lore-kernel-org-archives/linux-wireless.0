Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:15535 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbaAIJQF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 04:16:05 -0500
From: Ilan Peer <ilan.peer@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 1/2 v2] cfg80211: Add a function to get the number of supported channels
Date: Thu,  9 Jan 2014 11:17:31 +0200
Message-Id: <1389259051-18072-1-git-send-email-ilan.peer@intel.com> (sfid-20140109_101612_081487_E0BEE015)
In-Reply-To: <1388503946-25862-2-git-send-email-ilan.peer@intel.com>
References: <1388503946-25862-2-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a utility function to get the number of channels supported by
the device, and update the places in the code that need this data.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
---
 include/net/cfg80211.h |    9 +++++++++
 net/wireless/nl80211.c |   13 ++-----------
 net/wireless/scan.c    |    7 ++-----
 net/wireless/sme.c     |   13 +++----------
 net/wireless/util.c    |   13 +++++++++++++
 5 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 56c5977..b5ed170 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4640,6 +4640,15 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
  */
 void cfg80211_crit_proto_stopped(struct wireless_dev *wdev, gfp_t gfp);
 
+/**
+ * ieee80211_get_num_supported_channels - get the number of channels supported
+ * by the device.
+ * @wiphy: the wiphy
+ *
+ * Return: the number of channels supported by the device.
+ */
+unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy);
+
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
 /* wiphy_printk helpers, similar to dev_printk */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b4f40fe..2404564 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5285,12 +5285,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 			goto unlock;
 		}
 	} else {
-		enum ieee80211_band band;
-		n_channels = 0;
-
-		for (band = 0; band < IEEE80211_NUM_BANDS; band++)
-			if (wiphy->bands[band])
-				n_channels += wiphy->bands[band]->n_channels;
+		n_channels = ieee80211_get_num_supported_channels(wiphy);
 	}
 
 	if (info->attrs[NL80211_ATTR_SCAN_SSIDS])
@@ -5498,11 +5493,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 		if (!n_channels)
 			return -EINVAL;
 	} else {
-		n_channels = 0;
-
-		for (band = 0; band < IEEE80211_NUM_BANDS; band++)
-			if (wiphy->bands[band])
-				n_channels += wiphy->bands[band]->n_channels;
+		n_channels = ieee80211_get_num_supported_channels(wiphy);
 	}
 
 	if (info->attrs[NL80211_ATTR_SCAN_SSIDS])
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index a32d52a..2bf4686 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1089,11 +1089,8 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	/* Determine number of channels, needed to allocate creq */
 	if (wreq && wreq->num_channels)
 		n_channels = wreq->num_channels;
-	else {
-		for (band = 0; band < IEEE80211_NUM_BANDS; band++)
-			if (wiphy->bands[band])
-				n_channels += wiphy->bands[band]->n_channels;
-	}
+	else
+		n_channles = ieee80211_get_num_supported_channels(wiphy);
 
 	creq = kzalloc(sizeof(*creq) + sizeof(struct cfg80211_ssid) +
 		       n_channels * sizeof(void *),
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 5d6e7bb..a635091 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -70,18 +70,11 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
 	if (rdev->scan_req)
 		return -EBUSY;
 
-	if (wdev->conn->params.channel) {
+	if (wdev->conn->params.channel)
 		n_channels = 1;
-	} else {
-		enum ieee80211_band band;
-		n_channels = 0;
+	else
+		n_channels = ieee80211_get_num_supported_channels(wdev->wiphy);
 
-		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
-			if (!wdev->wiphy->bands[band])
-				continue;
-			n_channels += wdev->wiphy->bands[band]->n_channels;
-		}
-	}
 	request = kzalloc(sizeof(*request) + sizeof(request->ssids[0]) +
 			  sizeof(request->channels[0]) * n_channels,
 			  GFP_KERNEL);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 5618888..959c43c 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1479,6 +1479,19 @@ int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 	return 0;
 }
 
+unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy)
+{
+	enum ieee80211_band band;
+	unsigned int n_channels;
+
+	for (band = 0, n_channels = 0; band < IEEE80211_NUM_BANDS; band++)
+		if (wiphy->bands[band])
+			n_channels += wiphy->bands[band]->n_channels;
+
+	return n_channels;
+}
+EXPORT_SYMBOL(ieee80211_get_num_supported_channels);
+
 /* See IEEE 802.1H for LLC/SNAP encapsulation/decapsulation */
 /* Ethernet-II snap header (RFC1042 for most EtherTypes) */
 const unsigned char rfc1042_header[] __aligned(2) =
-- 
1.7.10.4

