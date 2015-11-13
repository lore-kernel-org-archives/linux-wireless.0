Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s1.neomailbox.net ([5.148.176.57]:38674 "EHLO s1.neomailbox.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744AbbKMSjh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 13:39:37 -0500
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@meshcoding.com>,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH 1/2] nl80211: add flag to force passive scan on DFS channels
Date: Sat, 14 Nov 2015 01:56:01 +0800
Message-Id: <1447437362-32647-1-git-send-email-antonio@meshcoding.com> (sfid-20151113_193939_502268_3B447A49)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In certain circumstances the user might not want to actively
scan DFS channels, therefore add a nl80211 scan flag to
instruct the underlying layers that DFS channels must be
passively scanned.

This flag can be specified upon scan trigger command.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 include/uapi/linux/nl80211.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1f0b4cf..2083e53 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4456,12 +4456,14 @@ enum nl80211_connect_failed_reason {
  *	locally administered 1, multicast 0) is assumed.
  *	This flag must not be requested when the feature isn't supported, check
  *	the nl80211 feature flags for the device.
+ * @NL80211_SCAN_FLAG_PASSIVE_RADAR: force passive scan on DFS channels
  */
 enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_LOW_PRIORITY			= 1<<0,
 	NL80211_SCAN_FLAG_FLUSH				= 1<<1,
 	NL80211_SCAN_FLAG_AP				= 1<<2,
 	NL80211_SCAN_FLAG_RANDOM_ADDR			= 1<<3,
+	NL80211_SCAN_FLAG_PASSIVE_RADAR			= 1<<4,
 };
 
 /**
-- 
2.6.3

