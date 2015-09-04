Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49757 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270AbbIDSD0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 14:03:26 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: handle fragmented IEs in splitting
Date: Fri,  4 Sep 2015 20:03:23 +0200
Message-Id: <1441389803-26148-1-git-send-email-johannes@sipsolutions.net> (sfid-20150904_200329_633564_8325C993)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The IEs "output" can sometimes combine IEs coming from userspace
with IEs generated in the kernel - in particular mac80211 does
this for association frames.

Add support in this code for the 802.11 IE fragmentation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211.h |  1 +
 net/wireless/util.c       | 25 ++++++++++++++++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index cfa906f28b7a..2fe22b44b682 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1919,6 +1919,7 @@ enum ieee80211_eid {
 
 	WLAN_EID_VENDOR_SPECIFIC = 221,
 	WLAN_EID_QOS_PARAMETER = 222,
+	WLAN_EID_FRAGMENT = 242,
 };
 
 /* Action category code */
diff --git a/net/wireless/util.c b/net/wireless/util.c
index baf7218cec15..f52fbda56467 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1301,6 +1301,25 @@ static bool ieee80211_id_in_list(const u8 *ids, int n_ids, u8 id)
 	return false;
 }
 
+static size_t skip_ie(const u8 *ies, size_t ielen, size_t pos)
+{
+	/* we assume a validly formed IEs buffer */
+	u8 len = ies[pos + 1];
+
+	pos += 2 + len;
+
+	/* the IE itself must have 255 bytes for fragments to follow */
+	if (len < 255)
+		return pos;
+
+	while (pos < ielen && ies[pos] == WLAN_EID_FRAGMENT) {
+		len = ies[pos + 1];
+		pos += 2 + len;
+	}
+
+	return pos;
+}
+
 size_t ieee80211_ie_split_ric(const u8 *ies, size_t ielen,
 			      const u8 *ids, int n_ids,
 			      const u8 *after_ric, int n_after_ric,
@@ -1310,14 +1329,14 @@ size_t ieee80211_ie_split_ric(const u8 *ies, size_t ielen,
 
 	while (pos < ielen && ieee80211_id_in_list(ids, n_ids, ies[pos])) {
 		if (ies[pos] == WLAN_EID_RIC_DATA && n_after_ric) {
-			pos += 2 + ies[pos + 1];
+			pos = skip_ie(ies, ielen, pos);
 
 			while (pos < ielen &&
 			       !ieee80211_id_in_list(after_ric, n_after_ric,
 						     ies[pos]))
-				pos += 2 + ies[pos + 1];
+				pos = skip_ie(ies, ielen, pos);
 		} else {
-			pos += 2 + ies[pos + 1];
+			pos = skip_ie(ies, ielen, pos);
 		}
 	}
 
-- 
2.1.4

