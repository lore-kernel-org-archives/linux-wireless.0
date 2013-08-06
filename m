Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54996 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab3HFMLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Aug 2013 08:11:49 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: clean up CQM settings code
Date: Tue,  6 Aug 2013 14:11:42 +0200
Message-Id: <1375791102-5505-1-git-send-email-johannes@sipsolutions.net> (sfid-20130806_141152_987236_ABFBBC5B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Clean up the CQM settings code a bit and while at it
enforce that when setting the threshold to 0 (disable)
the hysteresis is also set to 0 to avoid confusion.
As we haven't enforce it, simply override userspace.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 51 ++++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7e2c389..334697d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7573,14 +7573,12 @@ static int nl80211_set_cqm_txe(struct genl_info *info,
 			       u32 rate, u32 pkts, u32 intvl)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct wireless_dev *wdev;
 	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
 	if (rate > 100 || intvl > NL80211_CQM_TXE_MAX_INTVL)
 		return -EINVAL;
 
-	wdev = dev->ieee80211_ptr;
-
 	if (!rdev->ops->set_cqm_txe_config)
 		return -EOPNOTSUPP;
 
@@ -7595,13 +7593,15 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
 				s32 threshold, u32 hysteresis)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct wireless_dev *wdev;
 	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
 	if (threshold > 0)
 		return -EINVAL;
 
-	wdev = dev->ieee80211_ptr;
+	/* disabling - hysteresis should also be zero then */
+	if (threshold == 0)
+		hysteresis = 0;
 
 	if (!rdev->ops->set_cqm_rssi_config)
 		return -EOPNOTSUPP;
@@ -7620,36 +7620,33 @@ static int nl80211_set_cqm(struct sk_buff *skb, struct genl_info *info)
 	int err;
 
 	cqm = info->attrs[NL80211_ATTR_CQM];
-	if (!cqm) {
-		err = -EINVAL;
-		goto out;
-	}
+	if (!cqm)
+		return -EINVAL;
 
 	err = nla_parse_nested(attrs, NL80211_ATTR_CQM_MAX, cqm,
 			       nl80211_attr_cqm_policy);
 	if (err)
-		goto out;
+		return err;
 
 	if (attrs[NL80211_ATTR_CQM_RSSI_THOLD] &&
 	    attrs[NL80211_ATTR_CQM_RSSI_HYST]) {
-		s32 threshold;
-		u32 hysteresis;
-		threshold = nla_get_u32(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
-		hysteresis = nla_get_u32(attrs[NL80211_ATTR_CQM_RSSI_HYST]);
-		err = nl80211_set_cqm_rssi(info, threshold, hysteresis);
-	} else if (attrs[NL80211_ATTR_CQM_TXE_RATE] &&
-		   attrs[NL80211_ATTR_CQM_TXE_PKTS] &&
-		   attrs[NL80211_ATTR_CQM_TXE_INTVL]) {
-		u32 rate, pkts, intvl;
-		rate = nla_get_u32(attrs[NL80211_ATTR_CQM_TXE_RATE]);
-		pkts = nla_get_u32(attrs[NL80211_ATTR_CQM_TXE_PKTS]);
-		intvl = nla_get_u32(attrs[NL80211_ATTR_CQM_TXE_INTVL]);
-		err = nl80211_set_cqm_txe(info, rate, pkts, intvl);
-	} else
-		err = -EINVAL;
+		s32 threshold = nla_get_s32(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
+		u32 hysteresis = nla_get_u32(attrs[NL80211_ATTR_CQM_RSSI_HYST]);
 
-out:
-	return err;
+		return nl80211_set_cqm_rssi(info, threshold, hysteresis);
+	}
+
+	if (attrs[NL80211_ATTR_CQM_TXE_RATE] &&
+	    attrs[NL80211_ATTR_CQM_TXE_PKTS] &&
+	    attrs[NL80211_ATTR_CQM_TXE_INTVL]) {
+		u32 rate = nla_get_u32(attrs[NL80211_ATTR_CQM_TXE_RATE]);
+		u32 pkts = nla_get_u32(attrs[NL80211_ATTR_CQM_TXE_PKTS]);
+		u32 intvl = nla_get_u32(attrs[NL80211_ATTR_CQM_TXE_INTVL]);
+
+		return nl80211_set_cqm_txe(info, rate, pkts, intvl);
+	}
+
+	return -EINVAL;
 }
 
 static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
-- 
1.8.0

