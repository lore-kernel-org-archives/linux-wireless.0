Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48295 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752375AbbA2PxU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 10:53:20 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: don't document per-wiphy interface dump
Date: Thu, 29 Jan 2015 16:53:16 +0100
Message-Id: <1422546796-22526-1-git-send-email-johannes@sipsolutions.net> (sfid-20150129_165323_364017_3D1EF347)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Such a feature doesn't exist and isn't really needed since you
probably won't have enough interfaces to make it worthwhile, so
just remove that from the documentation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1cbc3aae425c..68b294e83944 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -180,8 +180,8 @@
  *	%NL80211_ATTR_WIPHY and %NL80211_ATTR_WIPHY_NAME.
  *
  * @NL80211_CMD_GET_INTERFACE: Request an interface's configuration;
- *	either a dump request on a %NL80211_ATTR_WIPHY or a specific get
- *	on an %NL80211_ATTR_IFINDEX is supported.
+ *	either a dump request for all interfaces or a specific get with a
+ *	single %NL80211_ATTR_IFINDEX is supported.
  * @NL80211_CMD_SET_INTERFACE: Set type of a virtual interface, requires
  *	%NL80211_ATTR_IFINDEX and %NL80211_ATTR_IFTYPE.
  * @NL80211_CMD_NEW_INTERFACE: Newly created virtual interface or response
-- 
2.1.4

