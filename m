Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41440 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211AbbJGNs3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 09:48:29 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] wireless: update robust action frame list
Date: Wed,  7 Oct 2015 15:48:25 +0200
Message-Id: <1444225706-12676-1-git-send-email-johannes@sipsolutions.net> (sfid-20151007_154837_062043_36EC64E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Unprotected DMG and VHT action frames are not protected, reflect
that in the list.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index f79a02a69d26..d55e605212e3 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -2397,6 +2397,8 @@ static inline bool _ieee80211_is_robust_mgmt_frame(struct ieee80211_hdr *hdr)
 		return *category != WLAN_CATEGORY_PUBLIC &&
 			*category != WLAN_CATEGORY_HT &&
 			*category != WLAN_CATEGORY_SELF_PROTECTED &&
+			*category != WLAN_CATEGORY_UNPROT_DMG &&
+			*category != WLAN_CATEGORY_VHT &&
 			*category != WLAN_CATEGORY_VENDOR_SPECIFIC;
 	}
 
-- 
2.5.1

