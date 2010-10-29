Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.ext.nokia.com ([147.243.1.48]:53085 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab0J2MHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Oct 2010 08:07:24 -0400
Received: from wimaxnb.nmp.nokia.com (wimaxnb.nmp.nokia.com [172.22.211.32])
	by mgw-sa02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id o9TC7M6x022621
	for <linux-wireless@vger.kernel.org>; Fri, 29 Oct 2010 15:07:22 +0300
From: juuso.oikarinen@nokia.com
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH] cfg80211: Reorder scan channels at 5 channel intervals
Date: Fri, 29 Oct 2010 15:07:22 +0300
Message-Id: <1288354042-13084-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch reorders scan lists so that channels are placed 5 apart, where
possible. With this patch, scanning 13 channels on the 2.4GHz band is be
performed in the following order: 1, 6, 11, 5, 10, 4, 9, 3, 8, 13, 2, 7.

Each band is ordered separately, so that the benefits of the changed order is
not lost when the underlying drivers with hw-scan bundle each band into groups
for scanning.

The reasoning for this is the reduction of probe-response noise coming from
AP's on overlapping channels responding to the scan probe-requests. Essentially
this should slightly improve the number of scan results received for a scan.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 net/wireless/core.h    |    2 +
 net/wireless/nl80211.c |   27 +++++---------
 net/wireless/scan.c    |   86 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 98 insertions(+), 17 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 6583cca..ca6464f 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -397,6 +397,8 @@ int cfg80211_set_freq(struct cfg80211_registered_device *rdev,
 		      enum nl80211_channel_type channel_type);
 
 u16 cfg80211_calculate_bitrate(struct rate_info *rate);
+bool cfg80211_reorder_scan_req(struct cfg80211_scan_request *req);
+
 
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
 #define CFG80211_DEV_WARN_ON(cond)	WARN_ON(cond)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c506241..980b15d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2819,26 +2819,13 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 	return r;
 }
 
-static int validate_scan_freqs(struct nlattr *freqs)
+static int count_scan_freqs(struct nlattr *freqs)
 {
-	struct nlattr *attr1, *attr2;
-	int n_channels = 0, tmp1, tmp2;
+	struct nlattr *attr1;
+	int n_channels = 0, tmp1;
 
 	nla_for_each_nested(attr1, freqs, tmp1) {
 		n_channels++;
-		/*
-		 * Some hardware has a limited channel list for
-		 * scanning, and it is pretty much nonsensical
-		 * to scan for a channel twice, so disallow that
-		 * and don't require drivers to check that the
-		 * channel list they get isn't longer than what
-		 * they can scan, as long as they can scan all
-		 * the channels they registered at once.
-		 */
-		nla_for_each_nested(attr2, freqs, tmp2)
-			if (attr1 != attr2 &&
-			    nla_get_u32(attr1) == nla_get_u32(attr2))
-				return 0;
 	}
 
 	return n_channels;
@@ -2869,7 +2856,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		return -EBUSY;
 
 	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
-		n_channels = validate_scan_freqs(
+		n_channels = count_scan_freqs(
 				info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]);
 		if (!n_channels)
 			return -EINVAL;
@@ -2960,6 +2947,12 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 
 	request->n_channels = i;
 
+	/* reorder channels in the request and check for duplicates */
+	if (!cfg80211_reorder_scan_req(request)) {
+		err = -EINVAL;
+		goto out_free;
+	}
+
 	i = 0;
 	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
 		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS], tmp) {
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 503ebb8..63f66c5 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -661,6 +661,86 @@ void cfg80211_unlink_bss(struct wiphy *wiphy, struct cfg80211_bss *pub)
 }
 EXPORT_SYMBOL(cfg80211_unlink_bss);
 
+#define CFG80211_SCAN_CHAN_INTERVAL 5
+
+bool cfg80211_reorder_scan_req(struct cfg80211_scan_request *req)
+{
+	struct ieee80211_channel *tmp;
+	int i, j;
+	int diff, min_diff, min_i, max_diff, max_i;
+
+
+	/* sort and validate channels */
+	for (i = 0; i < req->n_channels; i++) {
+		for (j = i + 1; j < req->n_channels; j++) {
+			/*
+			 * Some hardware has a limited channel list for
+			 * scanning, and it is pretty much nonsensical
+			 * to scan for a channel twice, so disallow that
+			 * and don't require drivers to check that the
+			 * channel list they get isn't longer than what
+			 * they can scan, as long as they can scan all
+			 * the channels they registered at once.
+			 */
+			if (req->channels[i]->center_freq ==
+			    req->channels[j]->center_freq)
+				return false;
+
+			if (req->channels[i]->center_freq >
+			    req->channels[j]->center_freq) {
+				tmp = req->channels[i];
+				req->channels[i] = req->channels[j];
+				req->channels[j] = tmp;
+			}
+		}
+	}
+
+	/*
+	 * Reorder consequtive channels apart from each other
+	 * for improved scan results - ordering in such a way that
+	 * different bands remain grouped.
+	 */
+	for (i = 1; i < req->n_channels; i++) {
+		min_i = i;
+		min_diff = -1;
+		max_i = i;
+		max_diff = -1;
+		for (j = i; j < req->n_channels; j++) {
+			int ch1 = ieee80211_frequency_to_channel(req->channels[i-1]->center_freq);
+			int ch2 = ieee80211_frequency_to_channel(req->channels[j]->center_freq);
+			diff = abs(ch1 - ch2);
+
+			if (req->channels[i-1]->band ==
+			    req->channels[j]->band) {
+				if (diff == CFG80211_SCAN_CHAN_INTERVAL) {
+					min_i = j;
+					break;
+				}
+				if (diff > max_diff) {
+					max_diff = diff;
+					max_i = j;
+				}
+				if (diff >= CFG80211_SCAN_CHAN_INTERVAL &&
+				    (min_diff == -1 || diff < min_diff)) {
+					min_diff = diff;
+					min_i = j;
+				}
+			}
+		}
+		if (min_i != i) {
+			tmp = req->channels[i];
+			req->channels[i] = req->channels[min_i];
+			req->channels[min_i] = tmp;
+		} else if (max_i != i) {
+			tmp = req->channels[i];
+			req->channels[i] = req->channels[max_i];
+			req->channels[max_i] = tmp;
+		}
+	}
+
+	return true;
+}
+
 #ifdef CONFIG_CFG80211_WEXT
 int cfg80211_wext_siwscan(struct net_device *dev,
 			  struct iw_request_info *info,
@@ -759,6 +839,12 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	/* Set real number of channels specified in creq->channels[] */
 	creq->n_channels = i;
 
+	/* reorder channels in the request and check for duplicates */
+	if (!cfg80211_reorder_scan_req(creq)) {
+		err = -EINVAL;
+		goto out;
+	}
+
 	/* translate "Scan for SSID" request */
 	if (wreq) {
 		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
-- 
1.7.1

