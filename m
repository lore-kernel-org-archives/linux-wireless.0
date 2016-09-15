Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54572 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753777AbcIOPPT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 11:15:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 18:15:09 +0300
Message-Id: <20160915151509.30840-1-luca@coelho.fi> (sfid-20160915_171524_574466_79E64F12)
Subject: [PATCH] cfg80211: add helper to find an IE that matches a byte-array
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

There are a few places where an IE that matches not only the EID, but
also other bytes inside the element, needs to be found.  To simplify
that and reduce the amount of similar code, implement a new helper
function to match the EID and an extra array of bytes.

Additionally, simplify cfg80211_find_vendor_ie() by using the new
match function.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h | 33 +++++++++++++++++++++++++++-
 net/wireless/scan.c    | 58 +++++++++++++++++++++++---------------------------
 2 files changed, 59 insertions(+), 32 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d5e7f69..533cb64 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3947,6 +3947,34 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 				    struct cfg80211_qos_map *qos_map);
 
 /**
+ * cfg80211_find_ie_match - match information element and byte array in data
+ *
+ * @eid: element ID
+ * @ies: data consisting of IEs
+ * @len: length of data
+ * @match: byte array to match
+ * @match_len: number of bytes in the match array
+ * @match_offset: offset in the IE where the byte array should match.
+ *	If match_len is zero, this must also be set to zero.
+ *	Otherwise this must be set to 2 or more, because the first
+ *	byte is the element id, which is already compared to eid, and
+ *	the second byte is the IE length.
+ *
+ * Return: %NULL if the element ID could not be found or if
+ * the element is invalid (claims to be longer than the given
+ * data) or if the byte array doesn't match, or a pointer to the first
+ * byte of the requested element, that is the byte containing the
+ * element ID.
+ *
+ * Note: There are no checks on the element length other than
+ * having to fit into the given data and being large enough for the
+ * byte array to match.
+ */
+const u8 *cfg80211_find_ie_match(u8 eid, const u8 *ies, int len,
+				 const u8 *match, int match_len,
+				 int match_offset);
+
+/**
  * cfg80211_find_ie - find information element in data
  *
  * @eid: element ID
@@ -3961,7 +3989,10 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
  * Note: There are no checks on the element length other than
  * having to fit into the given data.
  */
-const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len);
+static inline const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len)
+{
+	return cfg80211_find_ie_match(eid, ies, len, NULL, 0, 0);
+}
 
 /**
  * cfg80211_find_vendor_ie - find vendor specific information element in data
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 0358e12..b5bd58d 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -352,52 +352,48 @@ void cfg80211_bss_expire(struct cfg80211_registered_device *rdev)
 	__cfg80211_bss_expire(rdev, jiffies - IEEE80211_SCAN_RESULT_EXPIRE);
 }
 
-const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len)
+const u8 *cfg80211_find_ie_match(u8 eid, const u8 *ies, int len,
+				 const u8 *match, int match_len,
+				 int match_offset)
 {
-	while (len > 2 && ies[0] != eid) {
+	/* match_offset can't be smaller than 2, unless match_len is
+	 * zero, in which case match_offset must be zero as well.
+	 */
+	if (WARN_ON((match_len && match_offset < 2) ||
+		    (!match_len && match_offset)))
+		return NULL;
+
+	while (len >= 2 && len >= ies[1] + 2) {
+		if ((ies[0] == eid) &&
+		    (ies[1] + 2 >= match_offset + match_len) &&
+		    !memcmp(ies + match_offset, match, match_len))
+			return ies;
+
 		len -= ies[1] + 2;
 		ies += ies[1] + 2;
 	}
-	if (len < 2)
-		return NULL;
-	if (len < 2 + ies[1])
-		return NULL;
-	return ies;
+
+	return NULL;
 }
-EXPORT_SYMBOL(cfg80211_find_ie);
+EXPORT_SYMBOL(cfg80211_find_ie_match);
 
 const u8 *cfg80211_find_vendor_ie(unsigned int oui, int oui_type,
 				  const u8 *ies, int len)
 {
-	struct ieee80211_vendor_ie *ie;
-	const u8 *pos = ies, *end = ies + len;
-	int ie_oui;
+	const u8 *ie;
+	u8 match[] = { oui >> 16, oui >> 8, oui, oui_type };
+	int match_len = (oui_type < 0) ? 3 : sizeof(match);
 
 	if (WARN_ON(oui_type > 0xff))
 		return NULL;
 
-	while (pos < end) {
-		pos = cfg80211_find_ie(WLAN_EID_VENDOR_SPECIFIC, pos,
-				       end - pos);
-		if (!pos)
-			return NULL;
-
-		ie = (struct ieee80211_vendor_ie *)pos;
-
-		/* make sure we can access ie->len */
-		BUILD_BUG_ON(offsetof(struct ieee80211_vendor_ie, len) != 1);
+	ie = cfg80211_find_ie_match(WLAN_EID_VENDOR_SPECIFIC, ies, len,
+				    match, match_len, 2);
 
-		if (ie->len < sizeof(*ie))
-			goto cont;
+	if (ie && (ie[1] < 4))
+		return NULL;
 
-		ie_oui = ie->oui[0] << 16 | ie->oui[1] << 8 | ie->oui[2];
-		if (ie_oui == oui &&
-		    (oui_type < 0 || ie->oui_type == oui_type))
-			return pos;
-cont:
-		pos += 2 + ie->len;
-	}
-	return NULL;
+	return ie;
 }
 EXPORT_SYMBOL(cfg80211_find_vendor_ie);
 
-- 
2.9.3
