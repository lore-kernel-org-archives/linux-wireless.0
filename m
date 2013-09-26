Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1236 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753005Ab3IZHeY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 03:34:24 -0400
Date: Thu, 26 Sep 2013 13:04:14 +0530
From: "Sreenath Sharma" <sreenats@broadcom.com>
To: johannes@sipsolutions.net
cc: linux-wireless@vger.kernel.org, j@w1.fi
Subject: [PATCH] cfg80211: Provision to pass probe response ie along
 with remain on channel request
Message-ID: <20130926073414.GA15283@sreenath-Precision-M4700> (sfid-20130926_093428_148446_A06B4DE7)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The probe response ie should be set in driver before the listen state
for a listen only P2P device. Right now probe response ie is set using
driver specific private command implementations. This commit enhances the
remain_on_channel command handler to pass probe response ie along with
rest of the arguments.

Another approach is the addition of a new nl80211 command specific to pass
ies to driver. This will give more flexibilty to upper layer.

Signed-off-by: Sreenath Sharma <sreenats@broadcom.com>
---
 include/net/cfg80211.h  |   24 +++++++++++++++++++++---
 net/wireless/nl80211.c  |   42 ++++++++++++++++++++++++++++++++++--------
 net/wireless/rdev-ops.h |   11 +++++------
 3 files changed, 60 insertions(+), 17 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d530c54..71f7d84 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1425,6 +1425,26 @@ struct cfg80211_sched_scan_request {
 };
 
 /**
+ * struct cfg80211_roc_request - remain on channel request description
+ *
+ * @chandef: defines the channel to remain on
+ * @duration: duration in milliseconds that the driver intents to remain on the
+ *	channel
+ * @ie: optional information element(s) to add into Probe Response or %NULL
+ * @ie_len: length of ie in octets
+ * @cookie: the request cookie to be filled by the driver
+ */
+struct cfg80211_roc_request {
+	struct cfg80211_chan_def chandef;
+	unsigned int duration;
+	const u8 *ie;
+	size_t ie_len;
+
+	/* keep last */
+	u64 *cookie;
+};
+
+/**
  * enum cfg80211_signal_type - signal type
  *
  * @CFG80211_SIGNAL_TYPE_NONE: no signal strength information available
@@ -2313,9 +2333,7 @@ struct cfg80211_ops {
 
 	int	(*remain_on_channel)(struct wiphy *wiphy,
 				     struct wireless_dev *wdev,
-				     struct ieee80211_channel *chan,
-				     unsigned int duration,
-				     u64 *cookie);
+				     struct cfg80211_roc_request *request);
 	int	(*cancel_remain_on_channel)(struct wiphy *wiphy,
 					    struct wireless_dev *wdev,
 					    u64 cookie);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index af8d84a..c0db346 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7093,12 +7093,13 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev = info->user_ptr[1];
+	struct cfg80211_roc_request *request;
 	struct cfg80211_chan_def chandef;
 	struct sk_buff *msg;
 	void *hdr;
-	u64 cookie;
 	u32 duration;
 	int err;
+	size_t ie_len;
 
 	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ] ||
 	    !info->attrs[NL80211_ATTR_DURATION])
@@ -7122,24 +7123,47 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
+	if (info->attrs[NL80211_ATTR_IE])
+		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
+	else
+		ie_len = 0;
+	if (ie_len > rdev->wiphy.max_scan_ie_len)
+		return -EINVAL;
+	request = kzalloc(sizeof(*request)
+			+ sizeof(*request->cookie)
+			+ ie_len, GFP_KERNEL);
+	if (!request)
 		return -ENOMEM;
+	memcpy(&request->chandef, &chandef, sizeof(request->chandef));
+	request->duration = duration;
+	if (ie_len) {
+		request->ie_len = ie_len;
+		request->ie = (void *)(request) + sizeof(*request);
+		memcpy((void *)request->ie,
+		       nla_data(info->attrs[NL80211_ATTR_IE]),
+		       request->ie_len);
+		request->cookie = (void *)(request->ie) + request->ie_len;
+	} else
+		request->cookie = (void *)(request) + sizeof(*request);
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg) {
+		err = -ENOMEM;
+		goto free_buf;
+	}
 
 	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
 			     NL80211_CMD_REMAIN_ON_CHANNEL);
-	if (!hdr) {
-		err = -ENOBUFS;
+	if (IS_ERR(hdr)) {
+		err = PTR_ERR(hdr);
 		goto free_msg;
 	}
 
-	err = rdev_remain_on_channel(rdev, wdev, chandef.chan,
-				     duration, &cookie);
+	err = rdev_remain_on_channel(rdev, wdev, request);
 
 	if (err)
 		goto free_msg;
 
-	if (nla_put_u64(msg, NL80211_ATTR_COOKIE, cookie))
+	if (nla_put_u64(msg, NL80211_ATTR_COOKIE, *request->cookie))
 		goto nla_put_failure;
 
 	genlmsg_end(msg, hdr);
@@ -7150,6 +7174,8 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 	err = -ENOBUFS;
  free_msg:
 	nlmsg_free(msg);
+ free_buf:
+	kfree(request);
 	return err;
 }
 
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 37ce9fd..e521116 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -600,14 +600,13 @@ static inline int rdev_flush_pmksa(struct cfg80211_registered_device *rdev,
 static inline int
 rdev_remain_on_channel(struct cfg80211_registered_device *rdev,
 		       struct wireless_dev *wdev,
-		       struct ieee80211_channel *chan,
-		       unsigned int duration, u64 *cookie)
+		       struct cfg80211_roc_request *request)
 {
 	int ret;
-	trace_rdev_remain_on_channel(&rdev->wiphy, wdev, chan, duration);
-	ret = rdev->ops->remain_on_channel(&rdev->wiphy, wdev, chan,
-					   duration, cookie);
-	trace_rdev_return_int_cookie(&rdev->wiphy, ret, *cookie);
+	trace_rdev_remain_on_channel(&rdev->wiphy, wdev, request->chandef.chan,
+		       request->duration);
+	ret = rdev->ops->remain_on_channel(&rdev->wiphy, wdev, request);
+	trace_rdev_return_int_cookie(&rdev->wiphy, ret, *request->cookie);
 	return ret;
 }
 
-- 
1.7.9.5


