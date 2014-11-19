Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39905 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480AbaKSR0w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:26:52 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH] cfg80211: refactor nl80211_start_sched_scan so it can be reused
Date: Wed, 19 Nov 2014 18:26:48 +0100
Message-Id: <1416418008-5299-1-git-send-email-johannes@sipsolutions.net> (sfid-20141119_182654_571013_C6AF3BB2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

For net detect, we will need to reuse most of the scheduled scan
parsing function, but not all, so split out the attributes parsing
part out of the main start sched_scan function.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 130 +++++++++++++++++++++++++++----------------------
 1 file changed, 72 insertions(+), 58 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ea496c71491d..f8c1b30ec048 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5681,14 +5681,12 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
-static int nl80211_start_sched_scan(struct sk_buff *skb,
-				    struct genl_info *info)
+static struct cfg80211_sched_scan_request *
+nl80211_parse_sched_scan(struct wiphy *wiphy,
+			 struct nlattr **attrs)
 {
 	struct cfg80211_sched_scan_request *request;
-	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct net_device *dev = info->user_ptr[1];
 	struct nlattr *attr;
-	struct wiphy *wiphy;
 	int err, tmp, n_ssids = 0, n_match_sets = 0, n_channels, i;
 	u32 interval;
 	enum ieee80211_band band;
@@ -5696,38 +5694,32 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	struct nlattr *tb[NL80211_SCHED_SCAN_MATCH_ATTR_MAX + 1];
 	s32 default_match_rssi = NL80211_SCAN_RSSI_THOLD_OFF;
 
-	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
-	    !rdev->ops->sched_scan_start)
-		return -EOPNOTSUPP;
-
-	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
-		return -EINVAL;
+	if (!is_valid_ie_attr(attrs[NL80211_ATTR_IE]))
+		return ERR_PTR(-EINVAL);
 
-	if (!info->attrs[NL80211_ATTR_SCHED_SCAN_INTERVAL])
-		return -EINVAL;
+	if (!attrs[NL80211_ATTR_SCHED_SCAN_INTERVAL])
+		return ERR_PTR(-EINVAL);
 
-	interval = nla_get_u32(info->attrs[NL80211_ATTR_SCHED_SCAN_INTERVAL]);
+	interval = nla_get_u32(attrs[NL80211_ATTR_SCHED_SCAN_INTERVAL]);
 	if (interval == 0)
-		return -EINVAL;
-
-	wiphy = &rdev->wiphy;
+		return ERR_PTR(-EINVAL);
 
-	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
+	if (attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
 		n_channels = validate_scan_freqs(
-				info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]);
+				attrs[NL80211_ATTR_SCAN_FREQUENCIES]);
 		if (!n_channels)
-			return -EINVAL;
+			return ERR_PTR(-EINVAL);
 	} else {
 		n_channels = ieee80211_get_num_supported_channels(wiphy);
 	}
 
-	if (info->attrs[NL80211_ATTR_SCAN_SSIDS])
-		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS],
+	if (attrs[NL80211_ATTR_SCAN_SSIDS])
+		nla_for_each_nested(attr, attrs[NL80211_ATTR_SCAN_SSIDS],
 				    tmp)
 			n_ssids++;
 
 	if (n_ssids > wiphy->max_sched_scan_ssids)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	/*
 	 * First, count the number of 'real' matchsets. Due to an issue with
@@ -5738,9 +5730,9 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	 * older userspace that treated a matchset with only the RSSI as the
 	 * global RSSI for all other matchsets - if there are other matchsets.
 	 */
-	if (info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH]) {
+	if (attrs[NL80211_ATTR_SCHED_SCAN_MATCH]) {
 		nla_for_each_nested(attr,
-				    info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH],
+				    attrs[NL80211_ATTR_SCHED_SCAN_MATCH],
 				    tmp) {
 			struct nlattr *rssi;
 
@@ -5748,7 +5740,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 					nla_data(attr), nla_len(attr),
 					nl80211_match_policy);
 			if (err)
-				return err;
+				return ERR_PTR(err);
 			/* add other standalone attributes here */
 			if (tb[NL80211_SCHED_SCAN_MATCH_ATTR_SSID]) {
 				n_match_sets++;
@@ -5765,30 +5757,23 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 		n_match_sets = 1;
 
 	if (n_match_sets > wiphy->max_match_sets)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
-	if (info->attrs[NL80211_ATTR_IE])
-		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+	if (attrs[NL80211_ATTR_IE])
+		ie_len = nla_len(attrs[NL80211_ATTR_IE]);
 	else
 		ie_len = 0;
 
 	if (ie_len > wiphy->max_sched_scan_ie_len)
-		return -EINVAL;
-
-	if (rdev->sched_scan_req) {
-		err = -EINPROGRESS;
-		goto out;
-	}
+		return ERR_PTR(-EINVAL);
 
 	request = kzalloc(sizeof(*request)
 			+ sizeof(*request->ssids) * n_ssids
 			+ sizeof(*request->match_sets) * n_match_sets
 			+ sizeof(*request->channels) * n_channels
 			+ ie_len, GFP_KERNEL);
-	if (!request) {
-		err = -ENOMEM;
-		goto out;
-	}
+	if (!request)
+		return ERR_PTR(-ENOMEM);
 
 	if (n_ssids)
 		request->ssids = (void *)&request->channels[n_channels];
@@ -5813,10 +5798,10 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	request->n_match_sets = n_match_sets;
 
 	i = 0;
-	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
+	if (attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
 		/* user specified, bail out if channel not found */
 		nla_for_each_nested(attr,
-				    info->attrs[NL80211_ATTR_SCAN_FREQUENCIES],
+				    attrs[NL80211_ATTR_SCAN_FREQUENCIES],
 				    tmp) {
 			struct ieee80211_channel *chan;
 
@@ -5862,8 +5847,8 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	request->n_channels = i;
 
 	i = 0;
-	if (info->attrs[NL80211_ATTR_SCAN_SSIDS]) {
-		nla_for_each_nested(attr, info->attrs[NL80211_ATTR_SCAN_SSIDS],
+	if (attrs[NL80211_ATTR_SCAN_SSIDS]) {
+		nla_for_each_nested(attr, attrs[NL80211_ATTR_SCAN_SSIDS],
 				    tmp) {
 			if (nla_len(attr) > IEEE80211_MAX_SSID_LEN) {
 				err = -EINVAL;
@@ -5877,9 +5862,9 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	}
 
 	i = 0;
-	if (info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH]) {
+	if (attrs[NL80211_ATTR_SCHED_SCAN_MATCH]) {
 		nla_for_each_nested(attr,
-				    info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH],
+				    attrs[NL80211_ATTR_SCHED_SCAN_MATCH],
 				    tmp) {
 			struct nlattr *ssid, *rssi;
 
@@ -5934,13 +5919,13 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (ie_len) {
 		request->ie_len = ie_len;
 		memcpy((void *)request->ie,
-		       nla_data(info->attrs[NL80211_ATTR_IE]),
+		       nla_data(attrs[NL80211_ATTR_IE]),
 		       request->ie_len);
 	}
 
-	if (info->attrs[NL80211_ATTR_SCAN_FLAGS]) {
+	if (attrs[NL80211_ATTR_SCAN_FLAGS]) {
 		request->flags = nla_get_u32(
-			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
+			attrs[NL80211_ATTR_SCAN_FLAGS]);
 		if ((request->flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
 		    !(wiphy->features & NL80211_FEATURE_LOW_PRIORITY_SCAN)) {
 			err = -EOPNOTSUPP;
@@ -5948,22 +5933,51 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 		}
 	}
 
-	request->dev = dev;
-	request->wiphy = &rdev->wiphy;
 	request->interval = interval;
 	request->scan_start = jiffies;
 
-	err = rdev_sched_scan_start(rdev, dev, request);
-	if (!err) {
-		rdev->sched_scan_req = request;
-		nl80211_send_sched_scan(rdev, dev,
-					NL80211_CMD_START_SCHED_SCAN);
-		goto out;
-	}
+	return request;
 
 out_free:
 	kfree(request);
-out:
+	return ERR_PTR(err);
+}
+
+static int nl80211_start_sched_scan(struct sk_buff *skb,
+				    struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	int err;
+
+	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
+	    !rdev->ops->sched_scan_start)
+		return -EOPNOTSUPP;
+
+	if (rdev->sched_scan_req)
+		return -EINPROGRESS;
+
+	rdev->sched_scan_req = nl80211_parse_sched_scan(&rdev->wiphy,
+							info->attrs);
+	err = PTR_ERR_OR_ZERO(rdev->sched_scan_req);
+	if (err)
+		goto out_err;
+
+	err = rdev_sched_scan_start(rdev, dev, rdev->sched_scan_req);
+	if (err)
+		goto out_free;
+
+	rdev->sched_scan_req->dev = dev;
+	rdev->sched_scan_req->wiphy = &rdev->wiphy;
+
+	nl80211_send_sched_scan(rdev, dev,
+				NL80211_CMD_START_SCHED_SCAN);
+	return 0;
+
+out_free:
+	kfree(rdev->sched_scan_req);
+out_err:
+	rdev->sched_scan_req = NULL;
 	return err;
 }
 
-- 
2.1.1

