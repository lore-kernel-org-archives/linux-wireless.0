Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:11973 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbbBZN1J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 08:27:09 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Ahmad Kholaif <akholaif@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v2 1/2] cfg80211: Allow NL80211_ATTR_IFINDEX to be added to vendor events
Date: Thu, 26 Feb 2015 15:26:53 +0200
Message-ID: <1424957214-6363-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20150226_142715_029112_390C9C24)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ahmad Kholaif <akholaif@qca.qualcomm.com>

This modifies cfg80211_vendor_event_alloc() with an additional argument
struct wireless_dev *wdev. __cfg80211_alloc_event_skb() is modified to
take in *wdev argument, if wdev != NULL, both the NL80211_ATTR_IFINDEX
and wdev identifier are added to the vendor event.

These changes make it easier for drivers to add ifindex indication in
vendor events cleanly.

This also updates all existing users of cfg80211_vendor_event_alloc()
and __cfg80211_alloc_event_skb() in the kernel tree.

Signed-off-by: Ahmad Kholaif <akholaif@qca.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
v2: address review comments: add NL80211_ATTR_WDEV, modify existing
    cfg80211_vendor_event_alloc() instead of adding a new wrapper
    function, move the wdev argument to be the second argument to the
    functions instead of last

 drivers/net/wireless/ti/wl18xx/event.c |  4 ++--
 include/net/cfg80211.h                 | 14 ++++++++++----
 net/wireless/nl80211.c                 | 20 ++++++++++++++++----
 3 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/event.c b/drivers/net/wireless/ti/wl18xx/event.c
index c28f068..548bb9e 100644
--- a/drivers/net/wireless/ti/wl18xx/event.c
+++ b/drivers/net/wireless/ti/wl18xx/event.c
@@ -77,7 +77,7 @@ static int wlcore_smart_config_sync_event(struct wl1271 *wl, u8 sync_channel,
 	wl1271_debug(DEBUG_EVENT,
 		     "SMART_CONFIG_SYNC_EVENT_ID, freq: %d (chan: %d band %d)",
 		     freq, sync_channel, sync_band);
-	skb = cfg80211_vendor_event_alloc(wl->hw->wiphy, 20,
+	skb = cfg80211_vendor_event_alloc(wl->hw->wiphy, NULL, 20,
 					  WLCORE_VENDOR_EVENT_SC_SYNC,
 					  GFP_KERNEL);
 
@@ -98,7 +98,7 @@ static int wlcore_smart_config_decode_event(struct wl1271 *wl,
 	wl1271_debug(DEBUG_EVENT, "SMART_CONFIG_DECODE_EVENT_ID");
 	wl1271_dump_ascii(DEBUG_EVENT, "SSID:", ssid, ssid_len);
 
-	skb = cfg80211_vendor_event_alloc(wl->hw->wiphy,
+	skb = cfg80211_vendor_event_alloc(wl->hw->wiphy, NULL,
 					  ssid_len + pwd_len + 20,
 					  WLCORE_VENDOR_EVENT_SC_DECODE,
 					  GFP_KERNEL);
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 64e09e1..f9a4d17 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4260,6 +4260,7 @@ struct sk_buff *__cfg80211_alloc_reply_skb(struct wiphy *wiphy,
 					   int approxlen);
 
 struct sk_buff *__cfg80211_alloc_event_skb(struct wiphy *wiphy,
+					   struct wireless_dev *wdev,
 					   enum nl80211_commands cmd,
 					   enum nl80211_attrs attr,
 					   int vendor_event_idx,
@@ -4314,6 +4315,7 @@ int cfg80211_vendor_cmd_reply(struct sk_buff *skb);
 /**
  * cfg80211_vendor_event_alloc - allocate vendor-specific event skb
  * @wiphy: the wiphy
+ * @wdev: the wireless device
  * @event_idx: index of the vendor event in the wiphy's vendor_events
  * @approxlen: an upper bound of the length of the data that will
  *	be put into the skb
@@ -4322,16 +4324,20 @@ int cfg80211_vendor_cmd_reply(struct sk_buff *skb);
  * This function allocates and pre-fills an skb for an event on the
  * vendor-specific multicast group.
  *
+ * If wdev != NULL, both the ifindex and identifier of the specified
+ * wireless device are added to the event message before the vendor data
+ * attribute.
+ *
  * When done filling the skb, call cfg80211_vendor_event() with the
  * skb to send the event.
  *
  * Return: An allocated and pre-filled skb. %NULL if any errors happen.
  */
 static inline struct sk_buff *
-cfg80211_vendor_event_alloc(struct wiphy *wiphy, int approxlen,
-			    int event_idx, gfp_t gfp)
+cfg80211_vendor_event_alloc(struct wiphy *wiphy, struct wireless_dev *wdev,
+			     int approxlen, int event_idx, gfp_t gfp)
 {
-	return __cfg80211_alloc_event_skb(wiphy, NL80211_CMD_VENDOR,
+	return __cfg80211_alloc_event_skb(wiphy, wdev, NL80211_CMD_VENDOR,
 					  NL80211_ATTR_VENDOR_DATA,
 					  event_idx, approxlen, gfp);
 }
@@ -4432,7 +4438,7 @@ static inline int cfg80211_testmode_reply(struct sk_buff *skb)
 static inline struct sk_buff *
 cfg80211_testmode_alloc_event_skb(struct wiphy *wiphy, int approxlen, gfp_t gfp)
 {
-	return __cfg80211_alloc_event_skb(wiphy, NL80211_CMD_TESTMODE,
+	return __cfg80211_alloc_event_skb(wiphy, NULL, NL80211_CMD_TESTMODE,
 					  NL80211_ATTR_TESTDATA, -1,
 					  approxlen, gfp);
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9c6e23e..d3c389a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7379,8 +7379,8 @@ static int nl80211_set_mcast_rate(struct sk_buff *skb, struct genl_info *info)
 
 static struct sk_buff *
 __cfg80211_alloc_vendor_skb(struct cfg80211_registered_device *rdev,
-			    int approxlen, u32 portid, u32 seq,
-			    enum nl80211_commands cmd,
+			    struct wireless_dev *wdev, int approxlen,
+			    u32 portid, u32 seq, enum nl80211_commands cmd,
 			    enum nl80211_attrs attr,
 			    const struct nl80211_vendor_cmd_info *info,
 			    gfp_t gfp)
@@ -7411,6 +7411,17 @@ __cfg80211_alloc_vendor_skb(struct cfg80211_registered_device *rdev,
 			goto nla_put_failure;
 	}
 
+	if (wdev) {
+		if (nla_put_u64(skb, NL80211_ATTR_WDEV,
+				wdev_id(wdev)))
+			goto nla_put_failure;
+		if (wdev->netdev) {
+			if (nla_put_u32(skb, NL80211_ATTR_IFINDEX,
+					wdev->netdev->ifindex))
+				goto nla_put_failure;
+		}
+	}
+
 	data = nla_nest_start(skb, attr);
 
 	((void **)skb->cb)[0] = rdev;
@@ -7425,6 +7436,7 @@ __cfg80211_alloc_vendor_skb(struct cfg80211_registered_device *rdev,
 }
 
 struct sk_buff *__cfg80211_alloc_event_skb(struct wiphy *wiphy,
+					   struct wireless_dev *wdev,
 					   enum nl80211_commands cmd,
 					   enum nl80211_attrs attr,
 					   int vendor_event_idx,
@@ -7450,7 +7462,7 @@ struct sk_buff *__cfg80211_alloc_event_skb(struct wiphy *wiphy,
 		return NULL;
 	}
 
-	return __cfg80211_alloc_vendor_skb(rdev, approxlen, 0, 0,
+	return __cfg80211_alloc_vendor_skb(rdev, wdev, approxlen, 0, 0,
 					   cmd, attr, info, gfp);
 }
 EXPORT_SYMBOL(__cfg80211_alloc_event_skb);
@@ -9896,7 +9908,7 @@ struct sk_buff *__cfg80211_alloc_reply_skb(struct wiphy *wiphy,
 	if (WARN_ON(!rdev->cur_cmd_info))
 		return NULL;
 
-	return __cfg80211_alloc_vendor_skb(rdev, approxlen,
+	return __cfg80211_alloc_vendor_skb(rdev, NULL, approxlen,
 					   rdev->cur_cmd_info->snd_portid,
 					   rdev->cur_cmd_info->snd_seq,
 					   cmd, attr, NULL, GFP_KERNEL);
-- 
1.9.1

