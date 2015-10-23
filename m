Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36916 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbbJWHuH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 03:50:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: replace ieee80211_ie_split() with an inline
Date: Fri, 23 Oct 2015 09:50:03 +0200
Message-Id: <1445586603-30066-1-git-send-email-johannes@sipsolutions.net> (sfid-20151023_095011_977379_1BA9465A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The function is a very simple wrapper around another one,
just adds a few default parameters, so replace it with a
static inline instead of using EXPORT_SYMBOL, reducing
the module size slightly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h | 7 +++++--
 net/wireless/util.c    | 7 -------
 2 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2c7bdb81d30c..e568872203a5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5173,8 +5173,11 @@ size_t ieee80211_ie_split_ric(const u8 *ies, size_t ielen,
  * buffer starts, which may be @ielen if the entire (remainder)
  * of the buffer should be used.
  */
-size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
-			  const u8 *ids, int n_ids, size_t offset);
+static inline size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
+					const u8 *ids, int n_ids, size_t offset)
+{
+	return ieee80211_ie_split_ric(ies, ielen, ids, n_ids, NULL, 0, offset);
+}
 
 /**
  * cfg80211_report_wowlan_wakeup - report wakeup from WoWLAN
diff --git a/net/wireless/util.c b/net/wireless/util.c
index baf7218cec15..010a3c75a677 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1325,13 +1325,6 @@ size_t ieee80211_ie_split_ric(const u8 *ies, size_t ielen,
 }
 EXPORT_SYMBOL(ieee80211_ie_split_ric);
 
-size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
-			  const u8 *ids, int n_ids, size_t offset)
-{
-	return ieee80211_ie_split_ric(ies, ielen, ids, n_ids, NULL, 0, offset);
-}
-EXPORT_SYMBOL(ieee80211_ie_split);
-
 bool ieee80211_operating_class_to_band(u8 operating_class,
 				       enum ieee80211_band *band)
 {
-- 
2.5.1

