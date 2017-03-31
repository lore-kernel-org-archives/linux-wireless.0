Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42934 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752942AbdCaHQD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 03:16:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/2] cfg80211: add documentation for cfg80211_get_bss()
Date: Fri, 31 Mar 2017 09:15:55 +0200
Message-Id: <20170331071556.6121-1-johannes@sipsolutions.net> (sfid-20170331_091609_739840_CAE20914)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This was missing, but is referenced a lot in the documentation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 042137d7d226..273b1dca0861 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4699,12 +4699,22 @@ cfg80211_inform_bss(struct wiphy *wiphy,
 					gfp);
 }
 
+/**
+ * cfg80211_get_bss - get a BSS reference
+ * @wiphy: the wiphy this BSS struct belongs to
+ * @channel: the channel to search on (or %NULL)
+ * @bssid: the desired BSSID (or %NULL)
+ * @ssid: the desired SSID (or %NULL)
+ * @ssid_len: length of the SSID (or 0)
+ * @bss_type: type of BSS, see &enum ieee80211_bss_type
+ * @privacy: privacy filter, see &enum ieee80211_privacy
+ */
 struct cfg80211_bss *cfg80211_get_bss(struct wiphy *wiphy,
 				      struct ieee80211_channel *channel,
 				      const u8 *bssid,
 				      const u8 *ssid, size_t ssid_len,
 				      enum ieee80211_bss_type bss_type,
-				      enum ieee80211_privacy);
+				      enum ieee80211_privacy privacy);
 static inline struct cfg80211_bss *
 cfg80211_get_ibss(struct wiphy *wiphy,
 		  struct ieee80211_channel *channel,
-- 
2.11.0
