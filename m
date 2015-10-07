Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41442 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754167AbbJGNsb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 09:48:31 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] wireless: add WNM action frame categories
Date: Wed,  7 Oct 2015 15:48:26 +0200
Message-Id: <1444225706-12676-2-git-send-email-johannes@sipsolutions.net> (sfid-20151007_154837_665496_57B25FAB)
In-Reply-To: <1444225706-12676-1-git-send-email-johannes@sipsolutions.net>
References: <1444225706-12676-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add the WNM and unprotected WNM categories and mark the latter
as not robust.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index d55e605212e3..f4709ab4fccd 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1932,6 +1932,8 @@ enum ieee80211_category {
 	WLAN_CATEGORY_HT = 7,
 	WLAN_CATEGORY_SA_QUERY = 8,
 	WLAN_CATEGORY_PROTECTED_DUAL_OF_ACTION = 9,
+	WLAN_CATEGORY_WNM = 10,
+	WLAN_CATEGORY_WNM_UNPROTECTED = 11,
 	WLAN_CATEGORY_TDLS = 12,
 	WLAN_CATEGORY_MESH_ACTION = 13,
 	WLAN_CATEGORY_MULTIHOP_ACTION = 14,
@@ -2396,6 +2398,7 @@ static inline bool _ieee80211_is_robust_mgmt_frame(struct ieee80211_hdr *hdr)
 		category = ((u8 *) hdr) + 24;
 		return *category != WLAN_CATEGORY_PUBLIC &&
 			*category != WLAN_CATEGORY_HT &&
+			*category != WLAN_CATEGORY_WNM_UNPROTECTED &&
 			*category != WLAN_CATEGORY_SELF_PROTECTED &&
 			*category != WLAN_CATEGORY_UNPROT_DMG &&
 			*category != WLAN_CATEGORY_VHT &&
-- 
2.5.1

