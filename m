Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:7430 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbbBTOfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2015 09:35:37 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Ahmad Kholaif <akholaif@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 1/2] cfg80211: Allow NL80211_ATTR_IFINDEX to be added to vendor events
Date: Fri, 20 Feb 2015 16:35:24 +0200
Message-ID: <1424442925-10778-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20150220_153541_974012_5DF7D072)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ahmad Kholaif <akholaif@qca.qualcomm.com>

This adds a new alternative static inline wrapper to
cfg80211_vendor_event_alloc() with an additional argument
struct wireless_dev *wdev.

__cfg80211_alloc_event_skb() is modified to take in *wdev argument
(either NULL which would be the existing cfg80211_vendor_event_alloc()
case or not-NULL which would the new wrapper case; if wdev != NULL, the
NL80211_ATTR_IFINDEX is added to the vendor event.

These changes make it easier for drivers to add ifindex indication in
vendor events cleanly.

Signed-off-by: Ahmad Kholaif <akholaif@qca.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h | 39 +++++++++++++++++++++++++++++++++++----
 net/wireless/nl80211.c | 15 +++++++++++----
 2 files changed, 46 insertions(+), 8 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 64e09e1..55d1648 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4263,7 +4263,8 @@ struct sk_buff *__cfg80211_alloc_event_skb(struct wiphy *wiphy,
 					   enum nl80211_commands cmd,
 					   enum nl80211_attrs attr,
 					   int vendor_event_idx,
-					   int approxlen, gfp_t gfp);
+					   int approxlen, gfp_t gfp,
+					   struct wireless_dev *wdev);
 
 void __cfg80211_send_event_skb(struct sk_buff *skb, gfp_t gfp);
 
@@ -4333,7 +4334,36 @@ cfg80211_vendor_event_alloc(struct wiphy *wiphy, int approxlen,
 {
 	return __cfg80211_alloc_event_skb(wiphy, NL80211_CMD_VENDOR,
 					  NL80211_ATTR_VENDOR_DATA,
-					  event_idx, approxlen, gfp);
+					  event_idx, approxlen, gfp, NULL);
+}
+
+/**
+ * cfg80211_vendor_event_alloc_ext - allocate vendor-specific event skb
+ * @wiphy: the wiphy
+ * @event_idx: index of the vendor event in the wiphy's vendor_events
+ * @approxlen: an upper bound of the length of the data that will
+ *	be put into the skb
+ * @gfp: allocation flags
+ * @wdev: the wireless device
+ *
+ * This function allocates and pre-fills an skb for an event on the
+ * vendor-specific multicast group. This is otherwise identical to
+ * cfg80211_vendor_event_alloc(), but ifindex of the specified wireless device
+ * is added to the event message before the vendor data attribute.
+ *
+ * When done filling the skb, call cfg80211_vendor_event() with the
+ * skb to send the event.
+ *
+ * Return: An allocated and pre-filled skb. %NULL if any errors happen.
+ */
+static inline struct sk_buff *
+cfg80211_vendor_event_alloc_ext(struct wiphy *wiphy, int approxlen,
+				int event_idx, gfp_t gfp,
+				struct wireless_dev *wdev)
+{
+	return __cfg80211_alloc_event_skb(wiphy, NL80211_CMD_VENDOR,
+					  NL80211_ATTR_VENDOR_DATA,
+					  event_idx, approxlen, gfp, wdev);
 }
 
 /**
@@ -4342,7 +4372,8 @@ cfg80211_vendor_event_alloc(struct wiphy *wiphy, int approxlen,
  * @gfp: allocation flags
  *
  * This function sends the given @skb, which must have been allocated
- * by cfg80211_vendor_event_alloc(), as an event. It always consumes it.
+ * by cfg80211_vendor_event_alloc() or cfg80211_vendor_event_alloc_ext(), as an
+ * event. It always consumes it.
  */
 static inline void cfg80211_vendor_event(struct sk_buff *skb, gfp_t gfp)
 {
@@ -4434,7 +4465,7 @@ cfg80211_testmode_alloc_event_skb(struct wiphy *wiphy, int approxlen, gfp_t gfp)
 {
 	return __cfg80211_alloc_event_skb(wiphy, NL80211_CMD_TESTMODE,
 					  NL80211_ATTR_TESTDATA, -1,
-					  approxlen, gfp);
+					  approxlen, gfp, NULL);
 }
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 454d7a0..ed2b98e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7377,7 +7377,7 @@ __cfg80211_alloc_vendor_skb(struct cfg80211_registered_device *rdev,
 			    enum nl80211_commands cmd,
 			    enum nl80211_attrs attr,
 			    const struct nl80211_vendor_cmd_info *info,
-			    gfp_t gfp)
+			    gfp_t gfp, struct wireless_dev *wdev)
 {
 	struct sk_buff *skb;
 	void *hdr;
@@ -7405,6 +7405,12 @@ __cfg80211_alloc_vendor_skb(struct cfg80211_registered_device *rdev,
 			goto nla_put_failure;
 	}
 
+	if (wdev && wdev->netdev) {
+		if (nla_put_u32(skb, NL80211_ATTR_IFINDEX,
+				wdev->netdev->ifindex))
+			goto nla_put_failure;
+	}
+
 	data = nla_nest_start(skb, attr);
 
 	((void **)skb->cb)[0] = rdev;
@@ -7422,7 +7428,8 @@ struct sk_buff *__cfg80211_alloc_event_skb(struct wiphy *wiphy,
 					   enum nl80211_commands cmd,
 					   enum nl80211_attrs attr,
 					   int vendor_event_idx,
-					   int approxlen, gfp_t gfp)
+					   int approxlen, gfp_t gfp,
+					   struct wireless_dev *wdev)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 	const struct nl80211_vendor_cmd_info *info;
@@ -7445,7 +7452,7 @@ struct sk_buff *__cfg80211_alloc_event_skb(struct wiphy *wiphy,
 	}
 
 	return __cfg80211_alloc_vendor_skb(rdev, approxlen, 0, 0,
-					   cmd, attr, info, gfp);
+					   cmd, attr, info, gfp, wdev);
 }
 EXPORT_SYMBOL(__cfg80211_alloc_event_skb);
 
@@ -9893,7 +9900,7 @@ struct sk_buff *__cfg80211_alloc_reply_skb(struct wiphy *wiphy,
 	return __cfg80211_alloc_vendor_skb(rdev, approxlen,
 					   rdev->cur_cmd_info->snd_portid,
 					   rdev->cur_cmd_info->snd_seq,
-					   cmd, attr, NULL, GFP_KERNEL);
+					   cmd, attr, NULL, GFP_KERNEL, NULL);
 }
 EXPORT_SYMBOL(__cfg80211_alloc_reply_skb);
 
-- 
1.9.1

