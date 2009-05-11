Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59059 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751180AbZEKHZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 03:25:41 -0400
Date: Mon, 11 May 2009 10:20:35 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Robust Action frame categories for MFP
Message-ID: <20090511072035.GA31927@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE 802.11w/D9.0 introduces a mechanism for Action field Category
values to be used to select which Action frames are Robust. Public and
Vendor-specific categories are marked as not Robust in IEEE 802.11w;
HT will be marked not Robust in IEEE 802.11n. A new Vendor-specific
Protected category is allocated for Robust vendor-specific Action
frames. Another new category, Protected Dual of Action, is introduced
for protecting some existing Public Action frames (e.g., IEEE 802.11y
protected enablement).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 include/linux/ieee80211.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- uml.orig/include/linux/ieee80211.h	2009-05-08 12:53:07.000000000 +0300
+++ uml/include/linux/ieee80211.h	2009-05-11 10:14:57.000000000 +0300
@@ -1068,8 +1068,12 @@ enum ieee80211_category {
 	WLAN_CATEGORY_DLS = 2,
 	WLAN_CATEGORY_BACK = 3,
 	WLAN_CATEGORY_PUBLIC = 4,
+	WLAN_CATEGORY_HT = 7,
 	WLAN_CATEGORY_SA_QUERY = 8,
+	WLAN_CATEGORY_PROTECTED_DUAL_OF_ACTION = 9,
 	WLAN_CATEGORY_WMM = 17,
+	WLAN_CATEGORY_VENDOR_SPECIFIC_PROTECTED = 126,
+	WLAN_CATEGORY_VENDOR_SPECIFIC = 127,
 };
 
 /* SPECTRUM_MGMT action code */
@@ -1261,7 +1265,9 @@ static inline bool ieee80211_is_robust_m
 		if (ieee80211_has_protected(hdr->frame_control))
 			return true;
 		category = ((u8 *) hdr) + 24;
-		return *category != WLAN_CATEGORY_PUBLIC;
+		return *category != WLAN_CATEGORY_PUBLIC &&
+			*category != WLAN_CATEGORY_HT &&
+			*category != WLAN_CATEGORY_VENDOR_SPECIFIC;
 	}
 
 	return false;

-- 
Jouni Malinen                                            PGP id EFC895FA
