Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38473 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab2FEMbn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 08:31:43 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SbsvG-0008HZ-Sd
	for linux-wireless@vger.kernel.org; Tue, 05 Jun 2012 14:31:42 +0200
Message-Id: <20120605123058.394432774@sipsolutions.net> (sfid-20120605_143149_867829_1D9E8E88)
Date: Tue, 05 Jun 2012 14:28:41 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] cfg80211: validate remain-on-channel time better
References: <20120605122839.664762975@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The remain-on-channel time validation shouldn't
depend on the value of HZ, as it does now with
the check against jiffies, since then you might
use a value that works on one system but not on
another. Fix it by checking against a minimum
that's fixed.

Also add validation of the wait duration for a
management frame TX since this also translates
into remain-on-channel internally.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |    2 ++
 net/wireless/nl80211.c  |   23 ++++++++++++++++-------
 2 files changed, 18 insertions(+), 7 deletions(-)

--- a/include/linux/nl80211.h	2012-06-05 14:24:05.000000000 +0200
+++ b/include/linux/nl80211.h	2012-06-05 14:25:25.000000000 +0200
@@ -1522,6 +1522,8 @@ enum nl80211_attrs {
 #define NL80211_MAX_NR_CIPHER_SUITES		5
 #define NL80211_MAX_NR_AKM_SUITES		2
 
+#define NL80211_MIN_REMAIN_ON_CHANNEL_TIME	10
+
 /**
  * enum nl80211_iftype - (virtual) interface types
  *
--- a/net/wireless/nl80211.c	2012-06-05 14:24:11.000000000 +0200
+++ b/net/wireless/nl80211.c	2012-06-05 14:25:25.000000000 +0200
@@ -5545,18 +5545,18 @@ static int nl80211_remain_on_channel(str
 
 	duration = nla_get_u32(info->attrs[NL80211_ATTR_DURATION]);
 
+	if (!rdev->ops->remain_on_channel ||
+	    !(rdev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL))
+		return -EOPNOTSUPP;
+
 	/*
-	 * We should be on that channel for at least one jiffie,
-	 * and more than 5 seconds seems excessive.
+	 * We should be on that channel for at least a minimum amount of
+	 * time (10ms) but no longer than the driver supports.
 	 */
-	if (!duration || !msecs_to_jiffies(duration) ||
+	if (duration < NL80211_MIN_REMAIN_ON_CHANNEL_TIME ||
 	    duration > rdev->wiphy.max_remain_on_channel_duration)
 		return -EINVAL;
 
-	if (!rdev->ops->remain_on_channel ||
-	    !(rdev->wiphy.flags & WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL))
-		return -EOPNOTSUPP;
-
 	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] &&
 	    !nl80211_valid_channel_type(info, &channel_type))
 		return -EINVAL;
@@ -5827,6 +5827,15 @@ static int nl80211_tx_mgmt(struct sk_buf
 		if (!(rdev->wiphy.flags & WIPHY_FLAG_OFFCHAN_TX))
 			return -EINVAL;
 		wait = nla_get_u32(info->attrs[NL80211_ATTR_DURATION]);
+
+		/*
+		 * We should wait on the channel for at least a minimum amount
+		 * of time (10ms) but no longer than the driver supports.
+		 */
+		if (wait < NL80211_MIN_REMAIN_ON_CHANNEL_TIME ||
+		    wait > rdev->wiphy.max_remain_on_channel_duration)
+			return -EINVAL;
+
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {


